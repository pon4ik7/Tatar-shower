package api

import (
	"encoding/json"
	"fmt"
	"log" // Добавлено для логирования
	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/gorilla/mux"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"golang.org/x/crypto/bcrypt"
)

var jwtSecret = []byte("secret_key") // TODO add into .env file (for deploy)

type Handler struct {
	Storage models.Storage
}

func NewHandler(storage *models.Storage) *Handler {
	return &Handler{
		Storage: *storage,
	}
}

func (h *Handler) SetupRoutes() *mux.Router {
	r := mux.NewRouter()
	r.Use(corsMiddleware)

	apiRouter := r.PathPrefix("/api").Subrouter()
	apiRouter.HandleFunc("/register", h.RegisterUser).Methods("POST")
	apiRouter.HandleFunc("/signin", h.SingInUser).Methods("POST")
	apiRouter.HandleFunc("/schedules", h.GetAllSchedulesHandler).Methods("GET")
	apiRouter.HandleFunc("/schedules", h.CreateOrUpdateScheduleHandler).Methods("POST", "PUT")
	apiRouter.HandleFunc("/schedules", h.DeleteScheduleHandler).Methods("DELETE")
	apiRouter.HandleFunc("/shower/completed", h.CompleteShowerHandler).Methods("POST")

	return r
}

// CORS middleware
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

// registerUserHandler handles user registration requests.
func (h *Handler) RegisterUser(w http.ResponseWriter, r *http.Request) {
	var input models.InputRegisterUserRequest

	// Check that the request method is POST
	if r.Method != http.MethodPost {
		log.Printf("RegisterUser error: Method not allowed (405)")
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Parse request body
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		log.Printf("RegisterUser error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Basic validation
	if input.Login == "" || input.Password == "" {
		log.Printf("RegisterUser error: Login and password are required (400)")
		http.Error(w, "Login and password are required", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	// Check if user already exists
	if _, exists := h.Storage.RegisteredUsers[input.Login]; exists {
		log.Printf("RegisterUser error: User already exists (409)")
		http.Error(w, "User already exists", http.StatusConflict)
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		log.Printf("RegisterUser error: Internal server error (500): %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// Create and store user
	user := &models.User{
		ID:       h.Storage.NextID,
		Login:    input.Login,
		Password: string(hashedPassword),
		Schedule: *models.NewEmptySchedule(),
	}
	h.Storage.RegisteredUsers[input.Login] = user.ID
	h.Storage.NextID++

	jwtToken, err := h.GetOrCreateJWT(user.ID)
	if err != nil {
		log.Printf("RegisterUser error: Failed to generate token (500): %v", err)
		http.Error(w, "Failed to generate token", http.StatusInternalServerError)
		return
	}
	h.Storage.Users[user.ID] = user

	log.Printf("RegisterUser success: User '%s' registered successfully (201)", input.Login)
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Authorization", "Bearer "+jwtToken)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "User registered successfully",
	})
}

// SingInUser handles user login requests.
func (h *Handler) SingInUser(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		log.Printf("SingInUser error: Only post allowed (405)")
		http.Error(w, "Only post allowed", http.StatusMethodNotAllowed)
		return
	}

	var input models.InputRegisterUserRequest
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		log.Printf("SingInUser error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if input.Login == "" || input.Password == "" {
		log.Printf("SingInUser error: Login and password are required (400)")
		http.Error(w, "Login and password are required", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	// Find user by login
	id, exist := h.Storage.RegisteredUsers[input.Login]
	if !exist {
		log.Printf("SingInUser error: User not found (401)")
		http.Error(w, "User not found", http.StatusUnauthorized)
		return
	}

	jwtToken, err := h.GetOrCreateJWT(id)
	if err != nil {
		log.Printf("SingInUser error: Failed to generate token (500): %v", err)
		http.Error(w, "Failed to generate token", http.StatusInternalServerError)
		return
	}

	foundUser := h.Storage.Users[id]
	if foundUser == nil {
		log.Printf("SingInUser error: User not found by token (401)")
		http.Error(w, "User not found", http.StatusUnauthorized)
		return
	}

	// Compare password
	if err := bcrypt.CompareHashAndPassword([]byte(foundUser.Password), []byte(input.Password)); err != nil {
		log.Printf("SingInUser error: Invalid password (401)")
		http.Error(w, "Invalid password", http.StatusUnauthorized)
		return
	}

	log.Printf("SingInUser success: User '%s' signed in successfully (200)", input.Login)
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Authorization", "Bearer "+jwtToken)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "User signed in successfully",
	})
}

func (h *Handler) GetOrCreateJWT(userID int) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
	})
	return token.SignedString(jwtSecret)
}

// GetAllSchedulesHandler returns all schedules for the authenticated user.
func (h *Handler) GetAllSchedulesHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := getUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	user, exist := h.Storage.Users[userID]
	if !exist {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	log.Printf("GetAllSchedulesHandler success: Schedules returned for user %d", userID)
	json.NewEncoder(w).Encode(user.Schedule)

	log.Printf("GetAllSchedulesHandler error: User not found (404)")
	http.Error(w, "User not found", http.StatusNotFound)
}

// CreateOrUpdateScheduleHandler creates or updates a schedule for the authenticated user.
func (h *Handler) CreateOrUpdateScheduleHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := getUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	var req struct {
		Day   string   `json:"day"`
		Tasks []string `json:"tasks"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("CreateOrUpdateScheduleHandler error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	user, exist := h.Storage.Users[userID]
	if !exist {
		log.Printf("CreateOrUpdateScheduleHandler error: User not found (404)")
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	switch req.Day {
	case "Monday":
		user.Schedule.Monday = req.Tasks
		user.Schedule.MondayDone = make([]bool, len(req.Tasks))
	case "Tuesday":
		user.Schedule.Tuesday = req.Tasks
		user.Schedule.TuesdayDone = make([]bool, len(req.Tasks))
	case "Wednesday":
		user.Schedule.Wednesday = req.Tasks
		user.Schedule.WednesdayDone = make([]bool, len(req.Tasks))
	case "Thursday":
		user.Schedule.Thursday = req.Tasks
		user.Schedule.ThursdayDone = make([]bool, len(req.Tasks))
	case "Friday":
		user.Schedule.Friday = req.Tasks
		user.Schedule.FridayDone = make([]bool, len(req.Tasks))
	case "Saturday":
		user.Schedule.Saturday = req.Tasks
		user.Schedule.SaturdayDone = make([]bool, len(req.Tasks))
	case "Sunday":
		user.Schedule.Sunday = req.Tasks
		user.Schedule.SundayDone = make([]bool, len(req.Tasks))
	default:
		log.Printf("CreateOrUpdateScheduleHandler error: Invalid day (400)")
		http.Error(w, "Invalid day", http.StatusBadRequest)
		return
	}
	log.Printf("CreateOrUpdateScheduleHandler success: Schedule updated for user %d, day %s", userID, req.Day)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Schedule updated"})
}

// DeleteScheduleHandler deletes a schedule for a specific day for the authenticated user.
func (h *Handler) DeleteScheduleHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := getUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	var req struct {
		Day string `json:"day"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("DeleteScheduleHandler error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	user, exist := h.Storage.Users[userID]
	if !exist {
		log.Printf("CreateOrUpdateScheduleHandler error: User not found (404)")
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	switch req.Day {
	case "Monday":
		user.Schedule.Monday = nil
		user.Schedule.MondayDone = nil
	case "Tuesday":
		user.Schedule.Tuesday = nil
		user.Schedule.TuesdayDone = nil
	case "Wednesday":
		user.Schedule.Wednesday = nil
		user.Schedule.WednesdayDone = nil
	case "Thursday":
		user.Schedule.Thursday = nil
		user.Schedule.ThursdayDone = nil
	case "Friday":
		user.Schedule.Friday = nil
		user.Schedule.FridayDone = nil
	case "Saturday":
		user.Schedule.Saturday = nil
		user.Schedule.SaturdayDone = nil
	case "Sunday":
		user.Schedule.Sunday = nil
		user.Schedule.SundayDone = nil
	default:
		log.Printf("DeleteScheduleHandler error: Invalid day (400)")
		http.Error(w, "Invalid day", http.StatusBadRequest)
		return
	}
	log.Printf("DeleteScheduleHandler success: Schedule deleted for user %d, day %s", userID, req.Day)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Schedule deleted"})
}

// CompleteShowerHandler marks a shower as completed for tracking progress and streaks.
func (h *Handler) CompleteShowerHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := getUserIDFromRequest(r)
	if err != nil {
		log.Printf("Auth error: %v", err)
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	var req struct {
		Day  string `json:"day"`
		Time string `json:"time"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("CompleteShowerHandler error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	user, exist := h.Storage.Users[userID]
	if !exist {
		log.Printf("CreateOrUpdateScheduleHandler error: User not found (404)")
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	switch req.Day {
	case "Monday":
		for i, t := range user.Schedule.Monday {
			if t == req.Time {
				user.Schedule.MondayDone[i] = true
			}
		}
	case "Tuesday":
		for i, t := range user.Schedule.Tuesday {
			if t == req.Time {
				user.Schedule.TuesdayDone[i] = true
			}
		}
	case "Wednesday":
		for i, t := range user.Schedule.Wednesday {
			if t == req.Time {
				user.Schedule.WednesdayDone[i] = true
			}
		}
	case "Thursday":
		for i, t := range user.Schedule.Thursday {
			if t == req.Time {
				user.Schedule.ThursdayDone[i] = true
			}
		}
	case "Friday":
		for i, t := range user.Schedule.Friday {
			if t == req.Time {
				user.Schedule.FridayDone[i] = true
			}
		}
	case "Saturday":
		for i, t := range user.Schedule.Saturday {
			if t == req.Time {
				user.Schedule.SaturdayDone[i] = true
			}
		}
	case "Sunday":
		for i, t := range user.Schedule.Sunday {
			if t == req.Time {
				user.Schedule.SundayDone[i] = true
			}
		}
	default:
		log.Printf("CompleteShowerHandler error: Invalid day (400)")
		http.Error(w, "Invalid day", http.StatusBadRequest)
		return
	}
	log.Printf("CompleteShowerHandler success: Shower marked as completed for user %d, day %s, time %s", userID, req.Day, req.Time)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Shower marked as completed"})
}

// Extract user ID from JWT token in Authorization header
func getUserIDFromRequest(r *http.Request) (int, error) {
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		return 0, fmt.Errorf("authorization header missing")
	}
	var tokenString string
	fmt.Sscanf(authHeader, "Bearer %s", &tokenString)
	if tokenString == "" {
		return 0, fmt.Errorf("token missing in authorization header")
	}
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})
	if err != nil || !token.Valid {
		return 0, fmt.Errorf("invalid token: %v", err)
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return 0, fmt.Errorf("invalid token claims")
	}
	userID, ok := claims["user_id"].(int)
	if !ok {
		return 0, fmt.Errorf("user_id not found in token claims")
	}
	return userID, nil
}
