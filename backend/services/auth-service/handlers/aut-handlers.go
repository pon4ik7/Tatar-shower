package handlers

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/gorilla/mux"
	"github.com/lib/pq"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"github.com/rolanmulukin/tatar-shower-backend/tokens"
	"golang.org/x/crypto/bcrypt"
)

type Handler struct {
	DB *sql.DB
}

func NewHandler(db *sql.DB) *Handler {
	return &Handler{DB: db}
}

func (h *Handler) SetupRoutes() *mux.Router {
	r := mux.NewRouter()
	r.Use(corsMiddleware)

	apiRouter := r.PathPrefix("/api").Subrouter()
	apiRouter.HandleFunc("/register", h.RegisterUser).Methods("POST")
	apiRouter.HandleFunc("/signin", h.SignInUser).Methods("POST")
	apiRouter.HandleFunc("/user/push-token", h.RegisterPushToken).Methods("POST")

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

// registerUserHandler handles user registration requests.
// func (h *Handler) RegisterUser(w http.ResponseWriter, r *http.Request) {
// 	var input models.InputRegisterUserRequest

// 	// Check that the request method is POST
// 	if r.Method != http.MethodPost {
// 		log.Printf("RegisterUser error: Method not allowed (405)")
// 		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
// 		return
// 	}

// 	// Parse request body
// 	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
// 		log.Printf("RegisterUser error: Invalid request body (400): %v", err)
// 		http.Error(w, "Invalid request body", http.StatusBadRequest)
// 		return
// 	}

// 	// Basic validation
// 	if input.Login == "" || input.Password == "" {
// 		log.Printf("RegisterUser error: Username and password are required (400)")
// 		http.Error(w, "Username and password are required", http.StatusBadRequest)
// 		return
// 	}

// 	hash, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
// 	if err != nil {
// 		http.Error(w, "Internal error", http.StatusInternalServerError)
// 		return
// 	}

// 	tx, err := h.DB.Begin()
// 	if err != nil {
// 		log.Printf("RegisterUser: could not begin tx: %v", err)
// 		http.Error(w, "Internal server error", http.StatusInternalServerError)
// 		return
// 	}
// 	defer tx.Rollback()

// 	var userID int
// 	err = h.DB.QueryRow(`
//         INSERT INTO users (login, password_hash)
//         VALUES ($1, $2)
//         RETURNING id
//     `, input.Login, string(hash)).Scan(&userID)

// 	if err != nil {
// 		if pqErr, ok := err.(*pq.Error); ok && pqErr.Code == "23505" {
// 			http.Error(w, "User exists", http.StatusConflict)
// 			return
// 		}
// 		http.Error(w, "DB error", http.StatusInternalServerError)
// 		return
// 	}

// 	if err := h.initializeUserData(tx, userID, &input); err != nil {
// 		log.Printf("RegisterUser: init user data error: %v", err)
// 		http.Error(w, "DB error", http.StatusInternalServerError)
// 		return
// 	}

// 	if err := tx.Commit(); err != nil {
// 		log.Printf("RegisterUser: commit error: %v", err)
// 		http.Error(w, "Internal server error", http.StatusInternalServerError)
// 		return
// 	}

// 	jwtToken, err := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
// 		"user_id": userID,
// 	}).SignedString(tokens.JwtSecret)
// 	if err != nil {
// 		http.Error(w, "Token error", http.StatusInternalServerError)
// 		return
// 	}

// 	log.Printf("RegisterUser success: User '%s' registered successfully (201)", input.Login)
// 	w.Header().Set("Content-Type", "application/json")
// 	w.Header().Set("Authorization", "Bearer "+jwtToken)
// 	w.WriteHeader(http.StatusCreated)
// 	json.NewEncoder(w).Encode(map[string]string{
// 		"message": "User registered successfully",
// 	})
// }

// Temp register
func (h *Handler) RegisterUser(w http.ResponseWriter, r *http.Request) {
	var input models.InputRegisterUserRequestTemp

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
		log.Printf("RegisterUser error: Username and password are required (400)")
		http.Error(w, "Username and password are required", http.StatusBadRequest)
		return
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		http.Error(w, "Internal error", http.StatusInternalServerError)
		return
	}

	tx, err := h.DB.Begin()
	if err != nil {
		log.Printf("RegisterUser: could not begin tx: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	defer tx.Rollback()

	var userID int
	err = h.DB.QueryRow(`
        INSERT INTO users (login, password_hash)
        VALUES ($1, $2)
        RETURNING id
    `, input.Login, string(hash)).Scan(&userID)

	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok && pqErr.Code == "23505" {
			http.Error(w, "User exists", http.StatusConflict)
			return
		}
		http.Error(w, "DB error", http.StatusInternalServerError)
		return
	}

	// if err := h.initializeUserData(tx, userID); err != nil {
	// 	log.Printf("RegisterUser: init user data error: %v", err)
	// 	http.Error(w, "DB error", http.StatusInternalServerError)
	// 	return
	// }

	if err := tx.Commit(); err != nil {
		log.Printf("RegisterUser: commit error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	jwtToken, err := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
	}).SignedString(tokens.JwtSecret)
	if err != nil {
		http.Error(w, "Token error", http.StatusInternalServerError)
		return
	}

	log.Printf("RegisterUser success: User '%s' registered successfully (201)", input.Login)
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Authorization", "Bearer "+jwtToken)
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "User registered successfully",
	})
}

// SingInUser handles user login requests.
func (h *Handler) SignInUser(w http.ResponseWriter, r *http.Request) {
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
		log.Printf("SingInUser error: Username and password are required (400)")
		http.Error(w, "Username and password are required", http.StatusBadRequest)
		return
	}

	var userID int
	var storedHash string
	err := h.DB.QueryRow(
		`SELECT id, password_hash FROM users WHERE login = $1`,
		input.Login,
	).Scan(&userID, &storedHash)
	if err == sql.ErrNoRows {
		log.Printf("SingInUser error: User not found (401)")
		http.Error(w, "User not found", http.StatusUnauthorized)
		return
	}
	if err != nil {
		log.Printf("SingInUser error: DB error: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	if err := bcrypt.CompareHashAndPassword([]byte(storedHash), []byte(input.Password)); err != nil {
		log.Printf("SingInUser error: Invalid password (401)")
		http.Error(w, "Invalid password", http.StatusUnauthorized)
		return
	}

	jwtToken, err := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
	}).SignedString(tokens.JwtSecret)
	if err != nil {
		log.Printf("SingInUser error: Token generation failed: %v", err)
		http.Error(w, "Failed to generate token", http.StatusInternalServerError)
		return
	}

	log.Printf("SingInUser success: User '%s' signed in successfully (200)", input.Login)
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Authorization", "Bearer "+jwtToken)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "User signed in successfully",
	})
}

func (h *Handler) RegisterPushToken(w http.ResponseWriter, r *http.Request) {
	userID, err := tokens.GetUserIDFromRequest(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	var req struct {
		Token    string `json:"token"`
		Platform string `json:"platform"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	// Insert or update push token
	query := `
        INSERT INTO push_tokens (user_id, token, platform, created_at, updated_at)
        VALUES ($1, $2, $3, NOW(), NOW())
        ON CONFLICT (user_id, platform) 
        DO UPDATE SET token = $2, updated_at = NOW()
    `

	_, err = h.DB.Exec(query, userID, req.Token, req.Platform)
	if err != nil {
		log.Printf("DB error inserting push token: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"message": "Push token registered"})
}

// TODO: add language
// Now this function is just a template for DB visualization
func (h *Handler) initializeUserData(tx *sql.Tx, userID int, input *models.InputRegisterUserRequest) error {
	_, err := tx.Exec(`
        INSERT INTO preferences (
            user_id, language, reason, frequency_type, 
        	custom_days, experience_type, target_streak
        ) VALUES ($1,$2,$3,$4,$5,$6,$7)
    `, userID,
		input.Language,
		input.Reason,
		input.FrequencyType,
		pq.Array(input.CustomDays),
		input.ExperienceType,
		input.TargetStreak,
	)
	if err != nil {
		return err
	}
	if _, err := tx.Exec(`
        INSERT INTO goals (
            user_id
        ) VALUES ($1)
    `, userID); err != nil {
		return err
	}

	return nil
}
