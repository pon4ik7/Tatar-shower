package main

import (
	"fmt"
	"github.com/spf13/viper"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/rolanmulukin/tatar-shower-backend/db"

	"github.com/rolanmulukin/tatar-shower-backend/services/auth-service/handlers"
	fcmservice "github.com/rolanmulukin/tatar-shower-backend/services/fcm-service"
)

func loadConfig() {
	viper.AddConfigPath("config")
	viper.SetConfigName("development")
	viper.SetConfigType("yaml")
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	viper.AutomaticEnv()
	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("config read error: %v", err)
	}
}

func main() {
	loadConfig()
	port := viper.GetInt("server.port")
	dsn := viper.GetString("database.url")
	if dsn == "" {
		log.Fatal("DATABASE_URL is not set")
	}
	sqlDB, err := db.NewDB(dsn)
	if err != nil {
		log.Fatalf("failed to connect to DB: %v", err)
	}

	h := handlers.NewHandler(sqlDB)
	r := h.SetupRoutes()

	fcmServerKey := os.Getenv("FCM_SERVER_KEY") // Get from environment
	fcmService := fcmservice.NewFCMService(fcmServerKey)

	scheduler := fcmservice.NewNotificationScheduler(sqlDB, fcmService)
	scheduler.Start()
	defer scheduler.Stop()

	addr := fmt.Sprintf(":%d", port)
	srv := &http.Server{
		Addr:         addr,
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
	}
	log.Println("auth-service starting on", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}
