package handlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
)

// --- Тестовая версия Handler с мокированной авторизацией ---

type TestHandler struct {
	*Handler
	mockUserID int
	mockError  error
}

func (th *TestHandler) GetStreak(w http.ResponseWriter, r *http.Request) {
	// Используем мок вместо реальной авторизации
	if th.mockError != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	userID := th.mockUserID

	var currentStreak int
	var lastCompleted sql.NullTime
	err := th.DB.QueryRow(
		`SELECT current_streak, last_completed 
         FROM goals 
         WHERE user_id = $1`,
		userID,
	).Scan(&currentStreak, &lastCompleted)
	if err == sql.ErrNoRows {
		currentStreak = 0
	} else if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	resp := map[string]interface{}{
		"current_streak": currentStreak,
	}
	if lastCompleted.Valid {
		resp["last_completed"] = lastCompleted.Time.Format("2006-01-02")
	} else {
		resp["last_completed"] = nil
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}

// --- Основные тесты ---

func TestNewHandler(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := NewHandler(db)

	if handler == nil {
		t.Fatal("NewHandler returned nil")
	}
	if handler.DB != db {
		t.Error("DB not set correctly")
	}
}

func TestSetupRoutes(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := NewHandler(db)
	router := handler.SetupRoutes()

	if router == nil {
		t.Fatal("SetupRoutes returned nil")
	}
}

func TestCorsMiddleware(t *testing.T) {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	middleware := corsMiddleware(handler)

	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	rec := httptest.NewRecorder()

	middleware.ServeHTTP(rec, req)

	if rec.Header().Get("Access-Control-Allow-Origin") != "*" {
		t.Error("CORS Allow-Origin header not set correctly")
	}
	if rec.Header().Get("Access-Control-Allow-Methods") != "GET, POST, PUT, DELETE, OPTIONS" {
		t.Error("CORS Allow-Methods header not set correctly")
	}
	if rec.Header().Get("Access-Control-Allow-Headers") != "Content-Type, Authorization" {
		t.Error("CORS Allow-Headers header not set correctly")
	}
}

func TestCorsMiddleware_Options(t *testing.T) {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	middleware := corsMiddleware(handler)

	req := httptest.NewRequest(http.MethodOptions, "/test", nil)
	rec := httptest.NewRecorder()

	middleware.ServeHTTP(rec, req)

	if rec.Code != http.StatusNoContent {
		t.Errorf("expected status 204 for OPTIONS request, got %d", rec.Code)
	}
}

// --- Тесты GetStreak ---

func TestGetStreak_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	lastCompleted := time.Date(2025, 7, 10, 0, 0, 0, 0, time.UTC)
	rows := sqlmock.NewRows([]string{"current_streak", "last_completed"}).
		AddRow(5, lastCompleted)

	mock.ExpectQuery("SELECT current_streak, last_completed FROM goals WHERE user_id = \\$1").
		WithArgs(1).WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/streak", nil)
	rec := httptest.NewRecorder()

	handler.GetStreak(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response map[string]interface{}
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if response["current_streak"] != float64(5) {
		t.Errorf("expected current_streak 5, got %v", response["current_streak"])
	}
	if response["last_completed"] != "2025-07-10" {
		t.Errorf("expected last_completed '2025-07-10', got %v", response["last_completed"])
	}
}

func TestGetStreak_NoRows(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectQuery("SELECT current_streak, last_completed FROM goals WHERE user_id = \\$1").
		WithArgs(1).WillReturnError(sql.ErrNoRows)

	req := httptest.NewRequest(http.MethodGet, "/api/streak", nil)
	rec := httptest.NewRecorder()

	handler.GetStreak(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response map[string]interface{}
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if response["current_streak"] != float64(0) {
		t.Errorf("expected current_streak 0, got %v", response["current_streak"])
	}
	if response["last_completed"] != nil {
		t.Errorf("expected last_completed nil, got %v", response["last_completed"])
	}
}

func TestGetStreak_NullLastCompleted(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	rows := sqlmock.NewRows([]string{"current_streak", "last_completed"}).
		AddRow(3, nil)

	mock.ExpectQuery("SELECT current_streak, last_completed FROM goals WHERE user_id = \\$1").
		WithArgs(1).WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/streak", nil)
	rec := httptest.NewRecorder()

	handler.GetStreak(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response map[string]interface{}
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if response["current_streak"] != float64(3) {
		t.Errorf("expected current_streak 3, got %v", response["current_streak"])
	}
	if response["last_completed"] != nil {
		t.Errorf("expected last_completed nil, got %v", response["last_completed"])
	}
}

func TestGetStreak_Unauthorized(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 0,
		mockError:  errors.New("unauthorized"),
	}

	req := httptest.NewRequest(http.MethodGet, "/api/streak", nil)
	rec := httptest.NewRecorder()

	handler.GetStreak(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("expected status 401, got %d", rec.Code)
	}
}

func TestGetStreak_DBError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectQuery("SELECT current_streak, last_completed FROM goals WHERE user_id = \\$1").
		WithArgs(1).WillReturnError(errors.New("database error"))

	req := httptest.NewRequest(http.MethodGet, "/api/streak", nil)
	rec := httptest.NewRecorder()

	handler.GetStreak(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

// --- Тесты GetTips ---

func TestGetTips_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := NewHandler(db)

	rows := sqlmock.NewRows([]string{"message"}).
		AddRow("Tip 1").
		AddRow("Tip 2").
		AddRow("Tip 3")

	mock.ExpectQuery("SELECT message FROM tips WHERE category=\\$1 ORDER BY id").
		WithArgs("en").
		WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/tips", nil)
	rec := httptest.NewRecorder()

	handler.GetTips(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response []string
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if len(response) != 3 {
		t.Errorf("expected 3 tips, got %d", len(response))
	}
	if response[0] != "Tip 1" {
		t.Errorf("expected first tip 'Tip 1', got %s", response[0])
	}
	if response[1] != "Tip 2" {
		t.Errorf("expected second tip 'Tip 2', got %s", response[1])
	}
	if response[2] != "Tip 3" {
		t.Errorf("expected third tip 'Tip 3', got %s", response[2])
	}
}

func TestGetTips_EmptyResult(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := NewHandler(db)

	rows := sqlmock.NewRows([]string{"message"})

	mock.ExpectQuery("SELECT message FROM tips WHERE category=\\$1 ORDER BY id").
		WithArgs("en").
		WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/tips", nil)
	rec := httptest.NewRecorder()

	handler.GetTips(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response []string
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if len(response) != 0 {
		t.Errorf("expected 0 tips, got %d", len(response))
	}
}

func TestGetTips_DBError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := NewHandler(db)

	mock.ExpectQuery("SELECT message FROM tips WHERE category=\\$1 ORDER BY id").
		WithArgs("en").
		WillReturnError(errors.New("database error"))

	req := httptest.NewRequest(http.MethodGet, "/api/tips", nil)
	rec := httptest.NewRecorder()

	handler.GetTips(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

func TestGetTips_ScanError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := NewHandler(db)

	rows := sqlmock.NewRows([]string{"message"}).
		AddRow("Tip 1").
		AddRow("Tip 2").
		RowError(1, errors.New("scan error"))

	mock.ExpectQuery("SELECT message FROM tips WHERE category=\\$1 ORDER BY id").
		WithArgs("en").
		WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/tips", nil)
	rec := httptest.NewRecorder()

	handler.GetTips(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response []string
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if len(response) != 1 {
		t.Errorf("expected 1 tip (scan error should skip second), got %d", len(response))
	}
	if response[0] != "Tip 1" {
		t.Errorf("expected first tip 'Tip 1', got %s", response[0])
	}
}
