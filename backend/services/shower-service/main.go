package main

import (
	"github.com/gorilla/mux"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"github.com/rolanmulukin/tatar-shower-backend/services/shower-service/handlers"
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
	api.HandleFunc("/user/schedules", h.GetAllSchedulesHandler).Methods("GET")
	api.HandleFunc("/user/schedules", h.CreateOrUpdateScheduleHandler).Methods("POST", "PUT")
	api.HandleFunc("/user/schedules", h.DeleteScheduleHandler).Methods("DELETE")
	api.HandleFunc("/user/shower/completed", h.CompleteShowerHandler).Methods("POST")

	srv := &http.Server{
		Addr:         ":8002",
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
	}
	log.Println("shower-service starting on", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}
