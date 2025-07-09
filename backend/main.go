package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/rolanmulukin/tatar-shower-backend/api"
	"github.com/rolanmulukin/tatar-shower-backend/models"
)

func main() {
	storage := models.NewStrorage()

	hanler := api.NewHandler(storage)

	// Create new router
	router := hanler.SetupRoutes()

	// Configure server
	server := &http.Server{
		Addr:         ":8080",
		Handler:      router,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	fmt.Println("🚀 Server starting on http://localhost:8080")
	log.Fatal(server.ListenAndServe())
}
