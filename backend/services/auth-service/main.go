package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/rolanmulukin/tatar-shower-backend/db"

	"github.com/rolanmulukin/tatar-shower-backend/services/auth-service/handlers"
)

func main() {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		log.Fatal("DATABASE_URL is not set")
	}
	sqlDB, err := db.NewDB(dsn)
	if err != nil {
		log.Fatalf("failed to connect to DB: %v", err)
	}

	h := handlers.NewHandler(sqlDB)
	r := h.SetupRoutes()

	srv := &http.Server{
		Addr:         ":8001",
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
	}
	log.Println("auth-service starting on", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}
