package handlers

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

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
		if _, err := tx.Exec(`
			INSERT INTO schedule_entries (user_id, day, time, done)
			VALUES ($1, $2, $3, false)
		`, userID, req.Day, t); err != nil {
			tx.Rollback()
			log.Printf("DB insert error: %v", err)
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
