package fcmservice

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"golang.org/x/oauth2/google"
)

type FCMService struct {
	CredentialsFile string
	ProjectID       string
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

func NewFCMService(credentialsFile, projectID string) *FCMService {
	return &FCMService{CredentialsFile: credentialsFile, ProjectID: projectID}
}

func (f *FCMService) getAccessToken() (string, error) {
	data, err := ioutil.ReadFile(f.CredentialsFile)
	if err != nil {
		return "", err
	}
	conf, err := google.JWTConfigFromJSON(data, "https://www.googleapis.com/auth/firebase.messaging")
	if err != nil {
		return "", err
	}
	token, err := conf.TokenSource(context.Background()).Token()
	if err != nil {
		return "", err
	}
	return token.AccessToken, nil
}

// SendNotification sends a push notification via FCM
func (f *FCMService) SendNotification(token, title, body string) error {
	accessToken, err := f.getAccessToken()
	if err != nil {
		return err
	}

	url := fmt.Sprintf("https://fcm.googleapis.com/v1/projects/%s/messages:send", f.ProjectID)

	payload := map[string]interface{}{
		"message": map[string]interface{}{
			"token": token,
			"notification": map[string]string{
				"title": title,
				"body":  body,
			},
			"android": map[string]interface{}{
				"notification": map[string]string{
					"channel_id": "shower_reminders",
				},
			},
		},
	}

	jsonData, err := json.Marshal(payload)
	if err != nil {
		return err
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		return err
	}
	req.Header.Set("Authorization", "Bearer "+accessToken)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	respBody, _ := ioutil.ReadAll(resp.Body)
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("FCM v1 error: %s", string(respBody))
	}

	return nil
}
