package handlers

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/golang-jwt/jwt"
	"github.com/gorilla/mux"
	"github.com/rolanmulukin/tatar-shower-backend/models"
)

var jwtSecret = []byte(os.Getenv("JWT_SECRET"))

// TODO: switch to DB-backed storage

type Handler struct {
	Storage *models.Storage
}

func NewHandler(storage *models.Storage) *Handler {
	return &Handler{Storage: storage}
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
	// TODO change this logic stroring the schedule into BD tables
	// The main idea is to pin dayDone[taskID] = false if no shower and
	// dayDone[taskID] = true if shower was
	// Только не меняй структуру ответов
	w.Header().Set("Content-Type", "application/json")
	log.Printf("GetAllSchedulesHandler success: Schedules returned for user %d", userID)
	json.NewEncoder(w).Encode(user.Schedule)
}

// CreateOrUpdateScheduleHandler creates or updates a schedule for the authenticated user.
func (h *Handler) CreateOrUpdateScheduleHandler(w http.ResponseWriter, r *http.Request) {
	userID, err := getUserIDFromRequest(r)
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

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	// TODO change this logic stroring the schedule into BD tables
	// The main idea is to pin dayDone[taskID] = false if no shower and
	// dayDone[taskID] = true if shower was
	// Только не меняй структуру ответов

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
	var req models.ScheduleDeleteRequest

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("DeleteScheduleHandler error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	// TODO change this logic stroring the schedule into BD tables
	// The main idea is to pin dayDone[taskID] = false if no shower and
	// dayDone[taskID] = true if shower was
	// Только не меняй структуру ответов

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
	var req models.ScheduleCompleteRequest
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

	// TODO change this logic stroring the schedule into BD tables
	// The main idea is to pin dayDone[taskID] = false if no shower and
	// dayDone[taskID] = true if shower was
	// Только не меняй структуру ответов

	switch req.Day {
	case "Monday":
		for i, t := range user.Schedule.Monday {
			if t == req.Task {
				user.Schedule.MondayDone[i] = true
			}
		}
	case "Tuesday":
		for i, t := range user.Schedule.Tuesday {
			if t == req.Task {
				user.Schedule.TuesdayDone[i] = true
			}
		}
	case "Wednesday":
		for i, t := range user.Schedule.Wednesday {
			if t == req.Task {
				user.Schedule.WednesdayDone[i] = true
			}
		}
	case "Thursday":
		for i, t := range user.Schedule.Thursday {
			if t == req.Task {
				user.Schedule.ThursdayDone[i] = true
			}
		}
	case "Friday":
		for i, t := range user.Schedule.Friday {
			if t == req.Task {
				user.Schedule.FridayDone[i] = true
			}
		}
	case "Saturday":
		for i, t := range user.Schedule.Saturday {
			if t == req.Task {
				user.Schedule.SaturdayDone[i] = true
			}
		}
	case "Sunday":
		for i, t := range user.Schedule.Sunday {
			if t == req.Task {
				user.Schedule.SundayDone[i] = true
			}
		}
	default:
		log.Printf("CompleteShowerHandler error: Invalid day (400)")
		http.Error(w, "Invalid day", http.StatusBadRequest)
		return
	}
	log.Printf("CompleteShowerHandler success: Shower marked as completed for user %d, day %s, time %s", userID, req.Day, req.Task)
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
	userIDFloat, ok := claims["user_id"].(float64)
	if !ok {
		return 0, fmt.Errorf("user_id not found in token claims")
	}
	return int(userIDFloat), nil
}
