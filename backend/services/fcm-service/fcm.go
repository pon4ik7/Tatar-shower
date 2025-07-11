package fcmservice

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

type FCMService struct {
	ServerKey string
}

type FCMMessage struct {
	To           string                 `json:"to"`
	Notification FCMNotificationPayload `json:"notification"`
	Data         map[string]string      `json:"data,omitempty"`
}

type FCMNotificationPayload struct {
	Title string `json:"title"`
	Body  string `json:"body"`
}

func NewFCMService(serverKey string) *FCMService {
	return &FCMService{ServerKey: serverKey}
}

// SendNotification sends a push notification via FCM
func (f *FCMService) SendNotification(token, title, body string) error {
	message := FCMMessage{
		To: token,
		Notification: FCMNotificationPayload{
			Title: title,
			Body:  body,
		},
	}

	jsonData, err := json.Marshal(message)
	if err != nil {
		return err
	}

	req, err := http.NewRequest("POST", "https://fcm.googleapis.com/fcm/send", bytes.NewBuffer(jsonData))
	if err != nil {
		return err
	}

	req.Header.Set("Authorization", "key="+f.ServerKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("FCM request failed with status: %d", resp.StatusCode)
	}

	return nil
}
