package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"github.com/rolanmulukin/tatar-shower-backend/services/auth-service/handlers"
)

func main() {
	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		log.Fatal("JWT_SECRET is not set")
	}
	// TODO: switch to DB-backed storage
	storage := models.NewStrorage()
	h := handlers.NewHandler(storage)
	r := mux.NewRouter()
	api := r.PathPrefix("/api").Subrouter()
	api.HandleFunc("/register", h.RegisterUser).Methods("POST")
	api.HandleFunc("/signin", h.SingInUser).Methods("POST")

	srv := &http.Server{
		Addr:         ":8001",
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
	}
	log.Println("auth-service starting on", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}
