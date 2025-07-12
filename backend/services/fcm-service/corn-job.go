package fcmservice

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	"github.com/robfig/cron/v3"
)

type NotificationScheduler struct {
	db     *sql.DB
	fcmSvc *FCMService
	cron   *cron.Cron
}

func NewNotificationScheduler(db *sql.DB, fcmSvc *FCMService) *NotificationScheduler {
	return &NotificationScheduler{
		db:     db,
		fcmSvc: fcmSvc,
		cron:   cron.New(),
	}
}

func (ns *NotificationScheduler) Start() {
	// Run every minute to check for pending notifications
	ns.cron.AddFunc("* * * * *", ns.processPendingNotifications)
	ns.cron.Start()
	log.Println("Notification scheduler started")
}

func (ns *NotificationScheduler) Stop() {
	ns.cron.Stop()
	log.Println("Notification scheduler stopped")
}

func (ns *NotificationScheduler) processPendingNotifications() {
	now := time.Now()

	// Get all unsent notifications that should be sent now
	query := `
        SELECT sn.id, sn.schedule_entry_id, sn.user_id, sn.type, sn.scheduled_at,
               se.day, se.time
        FROM scheduled_notifications sn
        JOIN schedule_entries se ON sn.schedule_entry_id = se.id
        WHERE sn.sent = FALSE 
        AND sn.scheduled_at <= $1
        ORDER BY sn.scheduled_at ASC
    `

	rows, err := ns.db.Query(query, now)
	if err != nil {
		log.Printf("Error querying pending notifications: %v", err)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var notificationID, scheduleEntryID, userID int
		var notificationType, day, eventTime string
		var scheduledAt time.Time

		err := rows.Scan(&notificationID, &scheduleEntryID, &userID, &notificationType, &scheduledAt, &day, &eventTime)
		if err != nil {
			log.Printf("Error scanning notification row: %v", err)
			continue
		}

		// Send the notification
		err = ns.sendEventNotification(userID, day, eventTime, notificationType)
		if err != nil {
			log.Printf("Error sending notification %d: %v", notificationID, err)
			continue
		}

		// Mark as sent and move to next week
		err = ns.markSentAndMoveToNextWeek(notificationID, scheduledAt)
		if err != nil {
			log.Printf("Error updating notification %d: %v", notificationID, err)
		}

		log.Printf("Notification sent and moved to next week: ID %d, User %d", notificationID, userID)
	}
}

func (ns *NotificationScheduler) sendEventNotification(userID int, day, eventTime, notificationType string) error {
	// Get user's push tokens
	tokens, err := ns.getUserPushTokens(userID)
	if err != nil {
		return err
	}

	if len(tokens) == 0 {
		log.Printf("No push tokens found for user %d", userID)
		return nil
	}

	// Prepare notification message
	var message string
	switch notificationType {
	case "15_min_before":
		message = fmt.Sprintf("Напоминание: душ в %s начнётся через 15 минут", eventTime)
	case "5_min_before":
		message = fmt.Sprintf("Напоминание: душ в %s начнётся через 5 минут", eventTime)
	default:
		message = fmt.Sprintf("Напоминание: душ в %s", eventTime)
	}

	// Send to all user's devices
	for _, token := range tokens {
		err := ns.fcmSvc.SendNotification(token.Token, "Время принимать душ!", message)
		if err != nil {
			log.Printf("Error sending FCM notification to token %s: %v", token.Token, err)
		}
	}

	return nil
}

func (ns *NotificationScheduler) markSentAndMoveToNextWeek(notificationID int, currentScheduledAt time.Time) error {
	// Move to next week (same day and time)
	nextWeekScheduledAt := currentScheduledAt.AddDate(0, 0, 7)

	query := `
        UPDATE scheduled_notifications 
        SET sent = TRUE, scheduled_at = $1
        WHERE id = $2
    `

	_, err := ns.db.Exec(query, nextWeekScheduledAt, notificationID)
	return err
}

func (ns *NotificationScheduler) getUserPushTokens(userID int) ([]PushToken, error) {
	query := `SELECT id, user_id, token, platform FROM push_tokens WHERE user_id = $1`

	rows, err := ns.db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tokens []PushToken
	for rows.Next() {
		var token PushToken
		err := rows.Scan(&token.ID, &token.UserID, &token.Token, &token.Platform)
		if err != nil {
			return nil, err
		}
		tokens = append(tokens, token)
	}

	return tokens, nil
}

type PushToken struct {
	ID       int    `json:"id"`
	UserID   int    `json:"user_id"`
	Token    string `json:"token"`
	Platform string `json:"platform"`
}
