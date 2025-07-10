package main

import (
	"log"
	"net/http"
	"time"

	"github.com/rolanmulukin/tatar-shower-backend/models"
	"github.com/rolanmulukin/tatar-shower-backend/services/rec-service/handlers"
)

func main() {
	// TODO: switch to DB-backed storage
	storage := models.NewStrorage()
	h := handlers.NewHandler(storage)
	r := h.SetupRoutes()

	srv := &http.Server{
		Addr:         ":8003",
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
	}
	log.Println("rec-service starting on", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}
