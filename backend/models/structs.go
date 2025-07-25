package models

import (
	"sync"
	"time"
)

// Storage struct is a thread-safe storage for users.
// It uses a mutex to synchronize access to the users map.
type Storage struct {
	StorageMutex    sync.Mutex     // Mutex to ensure thread-safe operations
	Users           map[int]*User  // Map of user JWT to User pointers
	RegisteredUsers map[string]int // Map of users logins
	NextID          int            // The next ID for user
}

func NewStrorage() *Storage {
	return &Storage{
		StorageMutex:    sync.Mutex{},
		Users:           make(map[int]*User),
		RegisteredUsers: make(map[string]int),
		NextID:          0,
	}
}

// User struct represents a user with an ID and a weekly schedule.
type User struct {
	ID       int      // Unique identifier for the user
	Login    string   // User's login
	Password string   // User's hashed passord
	Schedule Schedule // User's weekly schedule
}

// Schedule struct stores a list of tasks or events for each day of the week.
type Schedule struct {
	Monday        []string // Tasks/events for Monday
	MondayDone    []bool   // Completion status for Monday tasks
	Tuesday       []string // Tasks/events for Tuesday
	TuesdayDone   []bool   // Completion status for Tuesday tasks
	Wednesday     []string // Tasks/events for Wednesday
	WednesdayDone []bool   // Completion status for Wednesday tasks
	Thursday      []string // Tasks/events for Thursday
	ThursdayDone  []bool   // Completion status for Thursday tasks
	Friday        []string // Tasks/events for Friday
	FridayDone    []bool   // Completion status for Friday tasks
	Saturday      []string // Tasks/events for Saturday
	SaturdayDone  []bool   // Completion status for Saturday tasks
	Sunday        []string // Tasks/events for Sunday
	SundayDone    []bool   // Completion status for Sunday tasks
}

func NewEmptySchedule() *Schedule {
	return &Schedule{}
}

type InputRegisterUserRequest struct {
	Login          string   `json:"login"`
	Password       string   `json:"password"`
	Language       string   `json:"language"`
	Reason         *string  `json:"reason"`
	FrequencyType  string   `json:"frequency_type"`
	CustomDays     []string `json:"custom_days"`
	ExperienceType string   `json:"experience_type"`
	TargetStreak   int      `json:"target_streak"`
}

type InputRegisterUserRequestTemp struct {
	Login    string `json:"login"`
	Password string `json:"password"`
}

type ScheduleCreateChancheRequest struct {
	Day   string   `json:"day"`
	Tasks []string `json:"tasks"`
}

type ScheduleDeleteRequest struct {
	Day string `json:"day"`
}

type ScheduleCompleteRequest struct {
	Day  string `json:"day"`
	Task string `json:"tasks"`
}

type NewScheduleCompleteRequest struct {
	Day      string `json:"day"`
	Task     string `json:"task"`
	Time     string `json:"time"`
	ColdTime string `json:"coldTime"`
}

type DeviceRegisterRequest struct {
	Token string `json:"device_token"`
}

type ScheduledNotification struct {
	ID          int       `json:"id" db:"id"`
	EventID     int       `json:"event_id" db:"event_id"`
	UserID      int       `json:"user_id" db:"user_id"`
	Type        string    `json:"type" db:"type"` // "15_min_before" or "5_min_before"
	ScheduledAt time.Time `json:"scheduled_at" db:"scheduled_at"`
	Sent        bool      `json:"sent" db:"sent"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}
