package handlers

import (
	"encoding/json"
	"fmt"
	"github.com/golang-jwt/jwt"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	"os"
)

var jwtSecret = []byte(os.Getenv("JWT_SECRET"))

// TODO: switch to DB-backed storage

type Handler struct {
	Storage *models.Storage
}

func NewHandler(storage *models.Storage) *Handler {
	return &Handler{Storage: storage}
}

// registerUserHandler handles user registration requests.
func (h *Handler) RegisterUser(w http.ResponseWriter, r *http.Request) {
	var input models.InputRegisterUserRequest

	// Check that the request method is POST
	if r.Method != http.MethodPost {
		log.Printf("RegisterUser error: Method not allowed (405)")
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Parse request body
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		log.Printf("RegisterUser error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Basic validation
	if input.Login == "" || input.Password == "" {
		log.Printf("RegisterUser error: Login and password are required (400)")
		http.Error(w, "Login and password are required", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	// Check if user already exists
	if _, exists := h.Storage.RegisteredUsers[input.Login]; exists {
		log.Printf("RegisterUser error: User already exists (409)")
		http.Error(w, "User already exists", http.StatusConflict)
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		log.Printf("RegisterUser error: Internal server error (500): %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// Create and store user
	user := &models.User{
		ID:       h.Storage.NextID,
		Login:    input.Login,
		Password: string(hashedPassword),
		Schedule: *models.NewEmptySchedule(),
	}
	h.Storage.RegisteredUsers[input.Login] = user.ID
	h.Storage.NextID++

	jwtToken, err := h.GetOrCreateJWT(user.ID)
	if err != nil {
		log.Printf("RegisterUser error: Failed to generate token (500): %v", err)
		http.Error(w, "Failed to generate token", http.StatusInternalServerError)
		return
	}
	h.Storage.Users[user.ID] = user

	log.Printf("RegisterUser success: User '%s' registered successfully (201)", input.Login)
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Authorization", "Bearer "+jwtToken)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "User registered successfully",
	})
}

// SingInUser handles user login requests.
func (h *Handler) SingInUser(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		log.Printf("SingInUser error: Only post allowed (405)")
		http.Error(w, "Only post allowed", http.StatusMethodNotAllowed)
		return
	}

	var input models.InputRegisterUserRequest
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		log.Printf("SingInUser error: Invalid request body (400): %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if input.Login == "" || input.Password == "" {
		log.Printf("SingInUser error: Login and password are required (400)")
		http.Error(w, "Login and password are required", http.StatusBadRequest)
		return
	}

	h.Storage.StorageMutex.Lock()
	defer h.Storage.StorageMutex.Unlock()

	// Find user by login
	id, exist := h.Storage.RegisteredUsers[input.Login]
	if !exist {
		log.Printf("SingInUser error: User not found (401)")
		http.Error(w, "User not found", http.StatusUnauthorized)
		return
	}

	jwtToken, err := h.GetOrCreateJWT(id)
	if err != nil {
		log.Printf("SingInUser error: Failed to generate token (500): %v", err)
		http.Error(w, "Failed to generate token", http.StatusInternalServerError)
		return
	}

	foundUser := h.Storage.Users[id]
	if foundUser == nil {
		log.Printf("SingInUser error: User not found by token (401)")
		http.Error(w, "User not found", http.StatusUnauthorized)
		return
	}

	// Compare password
	if err := bcrypt.CompareHashAndPassword([]byte(foundUser.Password), []byte(input.Password)); err != nil {
		log.Printf("SingInUser error: Invalid password (401)")
		http.Error(w, "Invalid password", http.StatusUnauthorized)
		return
	}

	log.Printf("SingInUser success: User '%s' signed in successfully (200)", input.Login)
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Authorization", "Bearer "+jwtToken)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "User signed in successfully",
	})
}

func (h *Handler) GetOrCreateJWT(userID int) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
	})
	return token.SignedString(jwtSecret)
}

// Extract user ID from JWT token in Authorization header
func getUserIDFromRequest(r *http.Request) (int, error) {
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		return 0, fmt.Errorf("authorization header missing")
	}
	var tokenString string
	fmt.Sscanf(authHeader, "Bearer %s", &tokenString)
	if tokenString == "" {
		return 0, fmt.Errorf("token missing in authorization header")
	}
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})
	if err != nil || !token.Valid {
		return 0, fmt.Errorf("invalid token: %v", err)
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return 0, fmt.Errorf("invalid token claims")
	}
	userIDFloat, ok := claims["user_id"].(float64)
	if !ok {
		return 0, fmt.Errorf("user_id not found in token claims")
	}
	return int(userIDFloat), nil
}
