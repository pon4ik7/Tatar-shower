package main

import (
	"github.com/gorilla/mux"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"github.com/rolanmulukin/tatar-shower-backend/services/rec-service/handlers"
	"log"
	"net/http"
	"time"
)

func main() {
	// TODO: switch to DB-backed storage
	storage := models.NewStrorage()
	h := handlers.NewHandler(storage)
	r := mux.NewRouter()
	api := r.PathPrefix("/api").Subrouter()
	api.HandleFunc("/stats/streak", h.GetStreakHandler).Methods("GET")
	api.HandleFunc("/tips/random", h.GetTipsHandler).Methods("GET")

	srv := &http.Server{
		Addr:         ":8003",
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
	}
	log.Println("rec-service starting on", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}
