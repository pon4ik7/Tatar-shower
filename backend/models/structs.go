package models

import "sync"

// Storage struct is a thread-safe storage for users.
// It uses a mutex to synchronize access to the users map.
type Storage struct {
	StorageMutex    sync.Mutex       // Mutex to ensure thread-safe operations
	Users           map[string]*User // Map of user JWT to User pointers
	RegisteredUsers map[string]int   // Map of users logins
	NextID          int              // The next ID for user
}

func NewStrorage() *Storage {
	return &Storage{
		StorageMutex:    sync.Mutex{},
		Users:           make(map[string]*User),
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
	Monday    []string // Tasks/events for Monday
	Tuesday   []string // Tasks/events for Tuesday
	Wednesday []string // Tasks/events for Wednesday
	Thursday  []string // Tasks/events for Thursday
	Friday    []string // Tasks/events for Friday
	Saturday  []string // Tasks/events for Saturday
	Sunday    []string // Tasks/events for Sunday
}

func NewEmptySchedule() *Schedule {
	return &Schedule{}
}

type InputRegisterUserRequest struct {
	Login    string `json:"login"`
	Password string `json:"password"`
}
