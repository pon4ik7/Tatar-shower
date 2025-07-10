package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rolanmulukin/tatar-shower-backend/models"
)

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
	apiRouter.HandleFunc("/streak", h.GetStreak).Methods("GET")
	apiRouter.HandleFunc("/tips", h.GetTips).Methods("GET")

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

func (h *Handler) GetStreak(w http.ResponseWriter, r *http.Request) {
	// TODO: query DB → current_streak, last_completed
	// TODO: create logic это я для себя уже
	json.NewEncoder(w).Encode(map[string]interface{}{
		"current_streak": 0,
		"last_completed": nil,
	})
}

func (h *Handler) GetTips(w http.ResponseWriter, r *http.Request) {
	// TODO: query DB → tips
	// TODO: create logic это я для себя уже
	json.NewEncoder(w).Encode([]string{
		"Stay hydrated before cold shower",
		"Breathe deeply",
	})
}
