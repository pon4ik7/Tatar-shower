package models

import (
	"testing"
)

func TestNewStorage(t *testing.T) {
	storage := NewStrorage()
	if storage == nil {
		t.Fatal("NewStrorage() returned nil")
	}
	if storage.NextID != 0 {
		t.Errorf("Expected NextID to be 0, got %d", storage.NextID)
	}
	if len(storage.Users) != 0 {
		t.Errorf("Expected Users map to be empty, got %d", len(storage.Users))
	}
	if len(storage.RegisteredUsers) != 0 {
		t.Errorf("Expected RegisteredUsers map to be empty, got %d", len(storage.RegisteredUsers))
	}
}

func TestNewEmptySchedule(t *testing.T) {
	schedule := NewEmptySchedule()
	if schedule == nil {
		t.Fatal("NewEmptySchedule() returned nil")
	}
	if len(schedule.Monday) != 0 || len(schedule.Tuesday) != 0 ||
		len(schedule.Wednesday) != 0 || len(schedule.Thursday) != 0 ||
		len(schedule.Friday) != 0 || len(schedule.Saturday) != 0 ||
		len(schedule.Sunday) != 0 {
		t.Error("Expected all days in Schedule to be empty slices")
	}
}

func TestUserStruct(t *testing.T) {
	user := User{
		ID:       1,
		Login:    "testuser",
		Password: "hashedpass",
		Schedule: Schedule{
			Monday:    []string{"task1"},
			Tuesday:   []string{},
			Wednesday: []string{},
			Thursday:  []string{},
			Friday:    []string{},
			Saturday:  []string{},
			Sunday:    []string{},
		},
	}

	if user.ID != 1 {
		t.Errorf("Expected ID to be 1, got %d", user.ID)
	}
	if user.Login != "testuser" {
		t.Errorf("Expected Login to be 'testuser', got %s", user.Login)
	}
	if user.Password != "hashedpass" {
		t.Errorf("Expected Password to be 'hashedpass', got %s", user.Password)
	}
	if len(user.Schedule.Monday) != 1 || user.Schedule.Monday[0] != "task1" {
		t.Error("Expected Monday schedule to contain 'task1'")
	}
}

func TestInputRegisterUserRequest(t *testing.T) {
	req := InputRegisterUserRequest{
		Login:    "user",
		Password: "pass",
	}
	if req.Login != "user" {
		t.Errorf("Expected Login to be 'user', got %s", req.Login)
	}
	if req.Password != "pass" {
		t.Errorf("Expected Password to be 'pass', got %s", req.Password)
	}
}
