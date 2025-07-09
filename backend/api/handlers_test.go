package api

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/rolanmulukin/tatar-shower-backend/models"
)

// Вспомогательная функция для инициализации test handler
func setupTestHandler() *Handler {
	storage := &models.Storage{
		Users:           make(map[string]*models.User),
		RegisteredUsers: make(map[string]int),
		NextID:          1,
	}
	return NewHandler(storage)
}

func TestRegisterUser_Success(t *testing.T) {
	handler := setupTestHandler()
	reqBody := models.InputRegisterUserRequest{
		Login:    "testuser",
		Password: "testpass",
	}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest("POST", "/api/register", bytes.NewReader(body))
	w := httptest.NewRecorder()

	handler.RegisterUser(w, req)

	resp := w.Result()
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusCreated {
		t.Fatalf("expected 200 or 201, got %d", resp.StatusCode)
	}
	var respBody map[string]string
	json.NewDecoder(resp.Body).Decode(&respBody)
	if respBody["message"] != "User registered successfully" {
		t.Errorf("unexpected response: %v", respBody)
	}
}

func TestRegisterUser_AlreadyExists(t *testing.T) {
	handler := setupTestHandler()
	reqBody := models.InputRegisterUserRequest{
		Login:    "testuser",
		Password: "testpass",
	}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest("POST", "/api/register", bytes.NewReader(body))
	w := httptest.NewRecorder()
	handler.RegisterUser(w, req)

	req2 := httptest.NewRequest("POST", "/api/register", bytes.NewReader(body))
	w2 := httptest.NewRecorder()
	handler.RegisterUser(w2, req2)

	resp := w2.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusConflict {
		t.Fatalf("expected 409 Conflict, got %d", resp.StatusCode)
	}
}

func TestRegisterUser_InvalidBody(t *testing.T) {
	handler := setupTestHandler()
	req := httptest.NewRequest("POST", "/api/register", bytes.NewReader([]byte("invalid json")))
	w := httptest.NewRecorder()
	handler.RegisterUser(w, req)

	resp := w.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusBadRequest {
		t.Fatalf("expected 400 Bad Request, got %d", resp.StatusCode)
	}
}

func TestRegisterUser_MissingFields(t *testing.T) {
	handler := setupTestHandler()
	reqBody := models.InputRegisterUserRequest{
		Login:    "",
		Password: "",
	}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest("POST", "/api/register", bytes.NewReader(body))
	w := httptest.NewRecorder()
	handler.RegisterUser(w, req)

	resp := w.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusBadRequest {
		t.Fatalf("expected 400 Bad Request, got %d", resp.StatusCode)
	}
}

func TestSignInUser_Success(t *testing.T) {
	handler := setupTestHandler()
	// Регистрация
	reqBody := models.InputRegisterUserRequest{
		Login:    "testuser",
		Password: "testpass",
	}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest("POST", "/api/register", bytes.NewReader(body))
	w := httptest.NewRecorder()
	handler.RegisterUser(w, req)

	// Логин
	loginBody := models.InputRegisterUserRequest{
		Login:    "testuser",
		Password: "testpass",
	}
	loginBytes, _ := json.Marshal(loginBody)
	loginReq := httptest.NewRequest("POST", "/api/signin", bytes.NewReader(loginBytes))
	loginW := httptest.NewRecorder()
	handler.SingInUser(loginW, loginReq)

	resp := loginW.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		t.Fatalf("expected 200 OK, got %d", resp.StatusCode)
	}
	var respBody map[string]string
	json.NewDecoder(resp.Body).Decode(&respBody)
	if respBody["message"] != "User signed in successfully" {
		t.Errorf("unexpected response: %v", respBody)
	}
}

func TestSignInUser_WrongPassword(t *testing.T) {
	handler := setupTestHandler()
	// Регистрация
	reqBody := models.InputRegisterUserRequest{
		Login:    "testuser",
		Password: "testpass",
	}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest("POST", "/api/register", bytes.NewReader(body))
	w := httptest.NewRecorder()
	handler.RegisterUser(w, req)

	// Логин с неверным паролем
	loginBody := models.InputRegisterUserRequest{
		Login:    "testuser",
		Password: "wrongpass",
	}
	loginBytes, _ := json.Marshal(loginBody)
	loginReq := httptest.NewRequest("POST", "/api/signin", bytes.NewReader(loginBytes))
	loginW := httptest.NewRecorder()
	handler.SingInUser(loginW, loginReq)

	resp := loginW.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusUnauthorized {
		t.Fatalf("expected 401 Unauthorized, got %d", resp.StatusCode)
	}
}

func TestSignInUser_UserNotFound(t *testing.T) {
	handler := setupTestHandler()
	loginBody := models.InputRegisterUserRequest{
		Login:    "nouser",
		Password: "nopass",
	}
	loginBytes, _ := json.Marshal(loginBody)
	loginReq := httptest.NewRequest("POST", "/api/signin", bytes.NewReader(loginBytes))
	loginW := httptest.NewRecorder()
	handler.SingInUser(loginW, loginReq)

	resp := loginW.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusUnauthorized {
		t.Fatalf("expected 401 Unauthorized, got %d", resp.StatusCode)
	}
}

func TestSignInUser_InvalidBody(t *testing.T) {
	handler := setupTestHandler()
	req := httptest.NewRequest("POST", "/api/signin", bytes.NewReader([]byte("invalid json")))
	w := httptest.NewRecorder()
	handler.SingInUser(w, req)

	resp := w.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusBadRequest {
		t.Fatalf("expected 400 Bad Request, got %d", resp.StatusCode)
	}
}

func TestSignInUser_MissingFields(t *testing.T) {
	handler := setupTestHandler()
	reqBody := models.InputRegisterUserRequest{
		Login:    "",
		Password: "",
	}
	body, _ := json.Marshal(reqBody)
	req := httptest.NewRequest("POST", "/api/signin", bytes.NewReader(body))
	w := httptest.NewRecorder()
	handler.SingInUser(w, req)

	resp := w.Result()
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusBadRequest {
		t.Fatalf("expected 400 Bad Request, got %d", resp.StatusCode)
	}
}
