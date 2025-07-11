package handlers

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/gorilla/mux"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"github.com/rolanmulukin/tatar-shower-backend/tokens"
)

type Handler struct {
	DB *sql.DB
}

func NewHandler(db *sql.DB) *Handler {
	return &Handler{DB: db}
}

func (h *Handler) SetupRoutes() *mux.Router {
	r := mux.NewRouter()
	r.Use(corsMiddleware)

	apiRouter := r.PathPrefix("/api").Subrouter()
	apiRouter.HandleFunc("/user/schedules", h.GetAllSchedulesHandler).Methods("GET")
	apiRouter.HandleFunc("/user/schedules", h.CreateOrUpdateScheduleHandler).Methods("POST", "PUT")
	apiRouter.HandleFunc("/user/schedules", h.DeleteScheduleHandler).Methods("DELETE")
	apiRouter.HandleFunc("/user/shower/completed", h.CompleteShowerHandler).Methods("POST")

	return r
}

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}

		next.ServeHTTP(w, r)
	})
}

// GetAllSchedulesHandler returns all schedules for the authenticated user.
func (h *Handler) GetAllSchedulesHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := tokens.GetUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	rows, err := h.DB.Query(`
		SELECT day, time, done
		FROM schedule_entries
		WHERE user_id = $1
		ORDER BY id
	`, userID)
	if err != nil {
		log.Printf("DB error in GetAllSchedules: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	schedule := models.Schedule{}

	for rows.Next() {
		var day, t string
		var done bool
		if err := rows.Scan(&day, &t, &done); err != nil {
			log.Printf("Scan error in GetAllSchedules: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		switch day {
		case "Monday":
			schedule.Monday = append(schedule.Monday, t)
			schedule.MondayDone = append(schedule.MondayDone, done)
		case "Tuesday":
			schedule.Tuesday = append(schedule.Tuesday, t)
			schedule.TuesdayDone = append(schedule.TuesdayDone, done)
		case "Wednesday":
			schedule.Wednesday = append(schedule.Wednesday, t)
			schedule.WednesdayDone = append(schedule.WednesdayDone, done)
		case "Thursday":
			schedule.Thursday = append(schedule.Thursday, t)
			schedule.ThursdayDone = append(schedule.ThursdayDone, done)
		case "Friday":
			schedule.Friday = append(schedule.Friday, t)
			schedule.FridayDone = append(schedule.FridayDone, done)
		case "Saturday":
			schedule.Saturday = append(schedule.Saturday, t)
			schedule.SaturdayDone = append(schedule.SaturdayDone, done)
		case "Sunday":
			schedule.Sunday = append(schedule.Sunday, t)
			schedule.SundayDone = append(schedule.SundayDone, done)
		}
	}
	w.Header().Set("Content-Type", "application/json")
	log.Printf("GetAllSchedulesHandler success: Schedules returned for user %d", userID)
	json.NewEncoder(w).Encode(schedule)
}

// TODO create logic update events for future weeks
// CreateOrUpdateScheduleHandler creates or updates a schedule for the authenticated user.
func (h *Handler) CreateOrUpdateScheduleHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := tokens.GetUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	var req models.ScheduleCreateChancheRequest

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("CreateOrUpdateScheduleHandler error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	tx, err := h.DB.Begin()
	if err != nil {
		log.Printf("DB begin error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	if _, err := tx.Exec(`
		DELETE FROM schedule_entries
		WHERE user_id=$1 AND day=$2
	`, userID, req.Day); err != nil {
		tx.Rollback()
		log.Printf("DB delete error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	for _, t := range req.Tasks {
		var scheduleEntryID int
		err := tx.QueryRow(`
			INSERT INTO schedule_entries (user_id, day, time, done)
			VALUES ($1, $2, $3, false)
			RETURNING id
		`, userID, req.Day, t).Scan(&scheduleEntryID)
		if err != nil {
			tx.Rollback()
			log.Printf("DB insert error: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		// Parse time string to time.Time
		eventTime, err := time.Parse("15:04", t)
		if err != nil {
			tx.Rollback()
			log.Printf("Time parse error: %v", err)
			http.Error(w, "Invalid time format", http.StatusBadRequest)
			return
		}
		// Calculate the next occurrence of this day and time
		startTime := getNextOccurrence(req.Day, eventTime)

		// Create scheduled notifications
		err = createScheduledNotifications(h.DB, scheduleEntryID, userID, startTime)
		if err != nil {
			tx.Rollback()
			log.Printf("Failed to create scheduled notifications: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
	}

	if err := tx.Commit(); err != nil {
		log.Printf("DB commit error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	log.Printf("CreateOrUpdateScheduleHandler success: Schedule updated for user %d, day %s", userID, req.Day)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Schedule updated"})
}

// DeleteScheduleHandler deletes a schedule for a specific day for the authenticated user.
func (h *Handler) DeleteScheduleHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := tokens.GetUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	var req models.ScheduleDeleteRequest

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("DeleteScheduleHandler error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	var entryIDs []int
	rows, err := h.DB.Query(`
		SELECT id FROM schedule_entries WHERE user_id=$1 AND day=$2
	`, userID, req.Day)
	if err != nil {
		log.Printf("DB select error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()
	for rows.Next() {
		var id int
		if err := rows.Scan(&id); err != nil {
			log.Printf("DB scan error: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		entryIDs = append(entryIDs, id)
	}

	for _, entryID := range entryIDs {
		_, err := h.DB.Exec(`
			DELETE FROM scheduled_notifications WHERE schedule_entry_id=$1
		`, entryID)
		if err != nil {
			log.Printf("DB delete notifications error: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
	}

	// Now delete schedule_entries as before
	_, err = h.DB.Exec(`
		DELETE FROM schedule_entries WHERE user_id=$1 AND day=$2
	`, userID, req.Day)
	if err != nil {
		log.Printf("DB delete error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	if _, err := h.DB.Exec(`
		DELETE FROM schedule_entries
		WHERE user_id=$1 AND day=$2
	`, userID, req.Day); err != nil {
		log.Printf("DB delete error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	log.Printf("DeleteScheduleHandler success: Schedule deleted for user %d, day %s", userID, req.Day)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Schedule deleted"})
}

// CompleteShowerHandler marks a shower as completed for tracking progress and streaks.
func (h *Handler) CompleteShowerHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := tokens.GetUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	var req models.ScheduleCompleteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("CompleteShowerHandler error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	tx, err := h.DB.Begin()
	if err != nil {
		log.Printf("DB begin error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	//TODO increase day streack and add last complete task

	var scheduleEntryID int
	err = tx.QueryRow(`
        SELECT id FROM schedule_entries 
        WHERE user_id=$1 AND day=$2 AND time=$3
    `, userID, req.Day, req.Task).Scan(&scheduleEntryID)
	if err != nil {
		tx.Rollback()
		log.Printf("DB select error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// Mark task as completed
	if _, err := tx.Exec(`
        UPDATE schedule_entries
        SET done = true
        WHERE user_id=$1 AND day=$2 AND time=$3
    `, userID, req.Day, req.Task); err != nil {
		tx.Rollback()
		log.Printf("DB update error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// Update notifications for this completed task
	err = updateNotificationsForCompletedTask(h.DB, scheduleEntryID)
	if err != nil {
		tx.Rollback()
		log.Printf("Failed to update notifications: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// TODO create a logic to get total_duration and cold_duration
	if _, err := tx.Exec(`
        INSERT INTO sessions (user_id, date, total_duration, cold_duration)
        VALUES ($1, NOW(), INTERVAL '0', INTERVAL '0')
    `, userID); err != nil {
		tx.Rollback()
		log.Printf("DB insert session error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	if err := tx.Commit(); err != nil {
		log.Printf("DB commit error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	log.Printf("CompleteShowerHandler success: Shower marked as completed for user %d, day %s, time %s", userID, req.Day, req.Task)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Shower marked as completed"})
}

// UpdateNotificationsForCompletedTask updates notifications when a task is completed
func updateNotificationsForCompletedTask(db *sql.DB, scheduleEntryID int) error {
	// Get all notifications for this schedule entry
	rows, err := db.Query(`
        SELECT id, scheduled_at, sent 
        FROM scheduled_notifications 
        WHERE schedule_entry_id = $1
    `, scheduleEntryID)
	if err != nil {
		return err
	}
	defer rows.Close()

	for rows.Next() {
		var notificationID int
		var scheduledAt time.Time
		var sent bool

		if err := rows.Scan(&notificationID, &scheduledAt, &sent); err != nil {
			return err
		}

		if !sent {
			// If not sent, move to next week
			newScheduledAt := scheduledAt.AddDate(0, 0, 7)
			_, err := db.Exec(`
                UPDATE scheduled_notifications 
                SET scheduled_at = $1 
                WHERE id = $2
            `, newScheduledAt, notificationID)
			if err != nil {
				return err
			}
		} else {
			// If already sent, mark as not sent for next week
			_, err := db.Exec(`
                UPDATE scheduled_notifications 
                SET sent = FALSE 
                WHERE id = $2
            `, notificationID)
			if err != nil {
				return err
			}
		}
	}
	return nil
}

func createScheduledNotifications(db *sql.DB, scheduleEntryID, userID int, startTime time.Time) error {
	now := time.Now()
	times := []struct {
		Type   string
		Offset time.Duration
	}{
		{"15_min_before", -15 * time.Minute},
		{"5_min_before", -5 * time.Minute},
	}
	for _, t := range times {
		scheduled := startTime.Add(t.Offset)
		if !scheduled.After(now) {
			scheduled = scheduled.AddDate(0, 0, 7) // Move to next week
		}
		err := InsertScheduledNotification(db, scheduleEntryID, userID, t.Type, scheduled)
		if err != nil {
			return err
		}
	}
	return nil
}

func InsertScheduledNotification(db *sql.DB, scheduleEntryID int, userID int, notifType string, scheduledAt time.Time) error {
	query := `
        INSERT INTO scheduled_notifications (schedule_entry_id, user_id, type, scheduled_at, sent, created_at)
        VALUES ($1, $2, $3, $4, FALSE, $5)
    `
	createdAt := time.Now()
	_, err := db.Exec(query, scheduleEntryID, userID, notifType, scheduledAt, createdAt)
	return err
}

func getNextOccurrence(weekdayStr string, eventTime time.Time) time.Time {
	// Map day string to time.Weekday
	weekdayStr = strings.ToLower(weekdayStr)
	var weekday time.Weekday
	switch weekdayStr {
	case "monday":
		weekday = time.Monday
	case "tuesday":
		weekday = time.Tuesday
	case "wednesday":
		weekday = time.Wednesday
	case "thursday":
		weekday = time.Thursday
	case "friday":
		weekday = time.Friday
	case "saturday":
		weekday = time.Saturday
	case "sunday":
		weekday = time.Sunday
	}

	now := time.Now()
	// Build today's date with eventTime's hour and minute
	eventDateTime := time.Date(now.Year(), now.Month(), now.Day(), eventTime.Hour(), eventTime.Minute(), 0, 0, now.Location())

	// Find how many days to add to get to the next weekday
	daysUntil := (int(weekday) - int(now.Weekday()) + 7) % 7
	if daysUntil == 0 && eventDateTime.Before(now) {
		daysUntil = 7 // If today but time already passed, go to next week
	}
	if daysUntil != 0 {
		eventDateTime = eventDateTime.AddDate(0, 0, daysUntil)
	}
	return eventDateTime
}
