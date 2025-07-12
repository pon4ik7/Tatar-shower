package models

import (
	"testing"
	"time"
)

func TestNewStrorage(t *testing.T) {
	storage := NewStrorage()
	if storage == nil {
		t.Fatal("NewStrorage() returned nil")
	}
	if storage.Users == nil {
		t.Error("Users map is not initialized")
	}
	if storage.RegisteredUsers == nil {
		t.Error("RegisteredUsers map is not initialized")
	}
	if storage.NextID != 0 {
		t.Errorf("NextID expected 0, got %d", storage.NextID)
	}
}

func TestNewEmptySchedule(t *testing.T) {
	schedule := NewEmptySchedule()
	if schedule == nil {
		t.Fatal("NewEmptySchedule() returned nil")
	}
	// Проверяем, что все срезы пустые
	if len(schedule.Monday) != 0 || len(schedule.MondayDone) != 0 {
		t.Error("Monday slices should be empty")
	}
	if len(schedule.Tuesday) != 0 || len(schedule.TuesdayDone) != 0 {
		t.Error("Tuesday slices should be empty")
	}
	if len(schedule.Wednesday) != 0 || len(schedule.WednesdayDone) != 0 {
		t.Error("Wednesday slices should be empty")
	}
	if len(schedule.Thursday) != 0 || len(schedule.ThursdayDone) != 0 {
		t.Error("Thursday slices should be empty")
	}
	if len(schedule.Friday) != 0 || len(schedule.FridayDone) != 0 {
		t.Error("Friday slices should be empty")
	}
	if len(schedule.Saturday) != 0 || len(schedule.SaturdayDone) != 0 {
		t.Error("Saturday slices should be empty")
	}
	if len(schedule.Sunday) != 0 || len(schedule.SundayDone) != 0 {
		t.Error("Sunday slices should be empty")
	}
}

func TestUserStruct(t *testing.T) {
	user := User{
		ID:       1,
		Login:    "testuser",
		Password: "hashedpassword",
		Schedule: Schedule{
			Monday:     []string{"task1"},
			MondayDone: []bool{true},
		},
	}

	if user.ID != 1 {
		t.Errorf("Expected ID 1, got %d", user.ID)
	}
	if user.Login != "testuser" {
		t.Errorf("Expected Login 'testuser', got %s", user.Login)
	}
	if user.Password != "hashedpassword" {
		t.Errorf("Expected Password 'hashedpassword', got %s", user.Password)
	}
	if len(user.Schedule.Monday) != 1 || user.Schedule.Monday[0] != "task1" {
		t.Error("Schedule Monday tasks not set correctly")
	}
	if len(user.Schedule.MondayDone) != 1 || !user.Schedule.MondayDone[0] {
		t.Error("Schedule MondayDone not set correctly")
	}
}

func TestScheduledNotificationStruct(t *testing.T) {
	n := ScheduledNotification{
		ID:          1,
		EventID:     2,
		UserID:      3,
		Type:        "15_min_before",
		ScheduledAt: time.Now(),
		Sent:        false,
		CreatedAt:   time.Now(),
	}
	if n.ID != 1 {
		t.Errorf("Expected ID 1, got %d", n.ID)
	}
	if n.EventID != 2 {
		t.Errorf("Expected EventID 2, got %d", n.EventID)
	}
	if n.UserID != 3 {
		t.Errorf("Expected UserID 3, got %d", n.UserID)
	}
	if n.Type != "15_min_before" {
		t.Errorf("Expected Type '15_min_before', got %s", n.Type)
	}
	if n.Sent != false {
		t.Errorf("Expected Sent false, got %v", n.Sent)
	}
}
