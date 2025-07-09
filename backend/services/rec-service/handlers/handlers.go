package handlers

import (
	"encoding/json"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"net/http"
)

// TODO: switch to DB-backed storage

type Handler struct {
	Storage *models.Storage
}

func NewHandler(storage *models.Storage) *Handler {
	return &Handler{Storage: storage}
}

func (h *Handler) GetStreakHandler(w http.ResponseWriter, r *http.Request) {
	// TODO: query DB → current_streak, last_completed
	json.NewEncoder(w).Encode(map[string]interface{}{
		"current_streak": 0,
		"last_completed": nil,
	})
}

func (h *Handler) GetTipsHandler(w http.ResponseWriter, r *http.Request) {
	// TODO: query DB → tips
	json.NewEncoder(w).Encode([]string{
		"Stay hydrated before cold shower",
		"Breathe deeply",
	})
}
