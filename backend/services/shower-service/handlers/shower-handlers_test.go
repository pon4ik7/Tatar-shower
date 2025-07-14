package handlers

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/rolanmulukin/tatar-shower-backend/models"
)

// --- Тестовая версия Handler с мокированной авторизацией ---

type TestHandler struct {
	*Handler
	mockUserID int
	mockError  error
}

func (th *TestHandler) GetAllSchedulesHandler(w http.ResponseWriter, r *http.Request) {
	if th.mockError != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	userID := th.mockUserID

	rows, err := th.DB.Query(`
		SELECT day, time, done
		FROM schedule_entries
		WHERE user_id = $1
		ORDER BY id
	`, userID)
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	schedule := models.Schedule{}

	for rows.Next() {
		var day, t string
		var done bool
		// ИСПРАВЛЕНИЕ: добавляем обработку ошибки сканирования
		if err := rows.Scan(&day, &t, &done); err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		switch day {
		case "Monday":
			schedule.Monday = append(schedule.Monday, t)
			schedule.MondayDone = append(schedule.MondayDone, done)
		case "Tuesday":
			schedule.Tuesday = append(schedule.Tuesday, t)
			schedule.TuesdayDone = append(schedule.TuesdayDone, done)
		case "Wednesday":
			schedule.Wednesday = append(schedule.Wednesday, t)
			schedule.WednesdayDone = append(schedule.WednesdayDone, done)
		case "Thursday":
			schedule.Thursday = append(schedule.Thursday, t)
			schedule.ThursdayDone = append(schedule.ThursdayDone, done)
		case "Friday":
			schedule.Friday = append(schedule.Friday, t)
			schedule.FridayDone = append(schedule.FridayDone, done)
		case "Saturday":
			schedule.Saturday = append(schedule.Saturday, t)
			schedule.SaturdayDone = append(schedule.SaturdayDone, done)
		case "Sunday":
			schedule.Sunday = append(schedule.Sunday, t)
			schedule.SundayDone = append(schedule.SundayDone, done)
		}
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(schedule)
}

func (th *TestHandler) CreateOrUpdateScheduleHandler(w http.ResponseWriter, r *http.Request) {
	if th.mockError != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	userID := th.mockUserID
	var req models.ScheduleCreateChancheRequest

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	tx, err := th.DB.Begin()
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	if _, err := tx.Exec(`
		DELETE FROM schedule_entries
		WHERE user_id=$1 AND day=$2
	`, userID, req.Day); err != nil {
		tx.Rollback()
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	for _, t := range req.Tasks {
		var scheduleEntryID int
		err := tx.QueryRow(`
			INSERT INTO schedule_entries (user_id, day, time, done)
			VALUES ($1, $2, $3, false)
			RETURNING id
		`, userID, req.Day, t).Scan(&scheduleEntryID)
		if err != nil {
			tx.Rollback()
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		// Parse time string to time.Time
		_, err = time.Parse("15:04", t)
		if err != nil {
			tx.Rollback()
			http.Error(w, "Invalid time format", http.StatusBadRequest)
			return
		}
	}

	if err := tx.Commit(); err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Schedule updated"})
}

func (th *TestHandler) DeleteScheduleHandler(w http.ResponseWriter, r *http.Request) {
	if th.mockError != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	userID := th.mockUserID
	var req models.ScheduleDeleteRequest

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	var entryIDs []int
	rows, err := th.DB.Query(`
		SELECT id FROM schedule_entries WHERE user_id=$1 AND day=$2
	`, userID, req.Day)
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var id int
		if err := rows.Scan(&id); err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		entryIDs = append(entryIDs, id)
	}

	for _, entryID := range entryIDs {
		_, err := th.DB.Exec(`
			DELETE FROM scheduled_notifications WHERE schedule_entry_id=$1
		`, entryID)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
	}

	_, err = th.DB.Exec(`
		DELETE FROM schedule_entries WHERE user_id=$1 AND day=$2
	`, userID, req.Day)
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Schedule deleted"})
}

func (th *TestHandler) CompleteShowerHandler(w http.ResponseWriter, r *http.Request) {
	if th.mockError != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	userID := th.mockUserID
	var req models.ScheduleCompleteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	tx, err := th.DB.Begin()
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	var scheduleEntryID int
	err = tx.QueryRow(`
        SELECT id FROM schedule_entries 
        WHERE user_id=$1 AND day=$2 AND time=$3
    `, userID, req.Day, req.Task).Scan(&scheduleEntryID)
	if err != nil {
		tx.Rollback()
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	if _, err := tx.Exec(`
        UPDATE schedule_entries
        SET done = true
        WHERE user_id=$1 AND day=$2 AND time=$3
    `, userID, req.Day, req.Task); err != nil {
		tx.Rollback()
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	if _, err := tx.Exec(`
        INSERT INTO sessions (user_id, date, total_duration, cold_duration)
        VALUES ($1, NOW(), INTERVAL '0', INTERVAL '0')
    `, userID); err != nil {
		tx.Rollback()
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	if err := tx.Commit(); err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Shower marked as completed"})
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

// --- Тесты GetAllSchedulesHandler ---

func TestGetAllSchedulesHandler_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	rows := sqlmock.NewRows([]string{"day", "time", "done"}).
		AddRow("Monday", "10:00", false).
		AddRow("Monday", "18:00", true).
		AddRow("Tuesday", "09:00", false)

	mock.ExpectQuery("SELECT day, time, done FROM schedule_entries WHERE user_id = \\$1 ORDER BY id").
		WithArgs(1).WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/user/schedules", nil)
	rec := httptest.NewRecorder()

	handler.GetAllSchedulesHandler(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response models.Schedule
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if len(response.Monday) != 2 {
		t.Errorf("expected 2 Monday tasks, got %d", len(response.Monday))
	}
	if len(response.Tuesday) != 1 {
		t.Errorf("expected 1 Tuesday task, got %d", len(response.Tuesday))
	}
	if response.Monday[0] != "10:00" {
		t.Errorf("expected first Monday task '10:00', got %s", response.Monday[0])
	}
	if response.MondayDone[1] != true {
		t.Errorf("expected second Monday task to be done, got %v", response.MondayDone[1])
	}
}

func TestGetAllSchedulesHandler_EmptyResult(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	rows := sqlmock.NewRows([]string{"day", "time", "done"})

	mock.ExpectQuery("SELECT day, time, done FROM schedule_entries WHERE user_id = \\$1 ORDER BY id").
		WithArgs(1).WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/user/schedules", nil)
	rec := httptest.NewRecorder()

	handler.GetAllSchedulesHandler(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response models.Schedule
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if len(response.Monday) != 0 {
		t.Errorf("expected 0 Monday tasks, got %d", len(response.Monday))
	}
}

func TestGetAllSchedulesHandler_Unauthorized(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 0,
		mockError:  errors.New("unauthorized"),
	}

	req := httptest.NewRequest(http.MethodGet, "/api/user/schedules", nil)
	rec := httptest.NewRecorder()

	handler.GetAllSchedulesHandler(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("expected status 401, got %d", rec.Code)
	}
}

func TestGetAllSchedulesHandler_DBError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectQuery("SELECT day, time, done FROM schedule_entries WHERE user_id = \\$1 ORDER BY id").
		WithArgs(1).WillReturnError(errors.New("database error"))

	req := httptest.NewRequest(http.MethodGet, "/api/user/schedules", nil)
	rec := httptest.NewRecorder()

	handler.GetAllSchedulesHandler(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

func TestGetAllSchedulesHandler_ScanError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	// Создаем строки с некорректными типами данных
	rows := sqlmock.NewRows([]string{"day", "time", "done"}).
		AddRow("Monday", "10:00", "invalid_boolean") // Некорректный тип для done

	mock.ExpectQuery("SELECT day, time, done FROM schedule_entries WHERE user_id = \\$1 ORDER BY id").
		WithArgs(1).WillReturnRows(rows)

	req := httptest.NewRequest(http.MethodGet, "/api/user/schedules", nil)
	rec := httptest.NewRecorder()

	handler.GetAllSchedulesHandler(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

// --- Тесты CreateOrUpdateScheduleHandler ---

func TestCreateOrUpdateScheduleHandler_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectBegin()
	mock.ExpectExec("DELETE FROM schedule_entries WHERE user_id=\\$1 AND day=\\$2").
		WithArgs(1, "Monday").WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectQuery("INSERT INTO schedule_entries \\(user_id, day, time, done\\) VALUES \\(\\$1, \\$2, \\$3, false\\) RETURNING id").
		WithArgs(1, "Monday", "10:00").WillReturnRows(sqlmock.NewRows([]string{"id"}).AddRow(1))
	mock.ExpectQuery("INSERT INTO schedule_entries \\(user_id, day, time, done\\) VALUES \\(\\$1, \\$2, \\$3, false\\) RETURNING id").
		WithArgs(1, "Monday", "18:00").WillReturnRows(sqlmock.NewRows([]string{"id"}).AddRow(2))
	mock.ExpectCommit()

	reqBody := models.ScheduleCreateChancheRequest{
		Day:   "Monday",
		Tasks: []string{"10:00", "18:00"},
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/schedules", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CreateOrUpdateScheduleHandler(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response map[string]string
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if response["message"] != "Schedule updated" {
		t.Errorf("expected message 'Schedule updated', got %s", response["message"])
	}
}

func TestCreateOrUpdateScheduleHandler_InvalidJSON(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	req := httptest.NewRequest(http.MethodPost, "/api/user/schedules", bytes.NewReader([]byte("invalid json")))
	rec := httptest.NewRecorder()

	handler.CreateOrUpdateScheduleHandler(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestCreateOrUpdateScheduleHandler_InvalidTimeFormat(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectBegin()
	mock.ExpectExec("DELETE FROM schedule_entries WHERE user_id=\\$1 AND day=\\$2").
		WithArgs(1, "Monday").WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectQuery("INSERT INTO schedule_entries \\(user_id, day, time, done\\) VALUES \\(\\$1, \\$2, \\$3, false\\) RETURNING id").
		WithArgs(1, "Monday", "invalid-time").WillReturnRows(sqlmock.NewRows([]string{"id"}).AddRow(1))
	mock.ExpectRollback()

	reqBody := models.ScheduleCreateChancheRequest{
		Day:   "Monday",
		Tasks: []string{"invalid-time"},
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/schedules", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CreateOrUpdateScheduleHandler(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestCreateOrUpdateScheduleHandler_Unauthorized(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 0,
		mockError:  errors.New("unauthorized"),
	}

	reqBody := models.ScheduleCreateChancheRequest{
		Day:   "Monday",
		Tasks: []string{"10:00"},
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/schedules", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CreateOrUpdateScheduleHandler(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("expected status 401, got %d", rec.Code)
	}
}

func TestCreateOrUpdateScheduleHandler_BeginError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectBegin().WillReturnError(errors.New("begin error"))

	reqBody := models.ScheduleCreateChancheRequest{
		Day:   "Monday",
		Tasks: []string{"10:00"},
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/schedules", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CreateOrUpdateScheduleHandler(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

// --- Тесты DeleteScheduleHandler ---

func TestDeleteScheduleHandler_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	rows := sqlmock.NewRows([]string{"id"}).AddRow(1).AddRow(2)
	mock.ExpectQuery("SELECT id FROM schedule_entries WHERE user_id=\\$1 AND day=\\$2").
		WithArgs(1, "Monday").WillReturnRows(rows)
	mock.ExpectExec("DELETE FROM scheduled_notifications WHERE schedule_entry_id=\\$1").
		WithArgs(1).WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec("DELETE FROM scheduled_notifications WHERE schedule_entry_id=\\$1").
		WithArgs(2).WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec("DELETE FROM schedule_entries WHERE user_id=\\$1 AND day=\\$2").
		WithArgs(1, "Monday").WillReturnResult(sqlmock.NewResult(1, 2))

	reqBody := models.ScheduleDeleteRequest{Day: "Monday"}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodDelete, "/api/user/schedules", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.DeleteScheduleHandler(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response map[string]string
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if response["message"] != "Schedule deleted" {
		t.Errorf("expected message 'Schedule deleted', got %s", response["message"])
	}
}

func TestDeleteScheduleHandler_Unauthorized(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 0,
		mockError:  errors.New("unauthorized"),
	}

	reqBody := models.ScheduleDeleteRequest{Day: "Monday"}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodDelete, "/api/user/schedules", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.DeleteScheduleHandler(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("expected status 401, got %d", rec.Code)
	}
}

func TestDeleteScheduleHandler_InvalidJSON(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	req := httptest.NewRequest(http.MethodDelete, "/api/user/schedules", bytes.NewReader([]byte("invalid json")))
	rec := httptest.NewRecorder()

	handler.DeleteScheduleHandler(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestDeleteScheduleHandler_QueryError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectQuery("SELECT id FROM schedule_entries WHERE user_id=\\$1 AND day=\\$2").
		WithArgs(1, "Monday").WillReturnError(errors.New("query error"))

	reqBody := models.ScheduleDeleteRequest{Day: "Monday"}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodDelete, "/api/user/schedules", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.DeleteScheduleHandler(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

// --- Тесты CompleteShowerHandler ---

func TestCompleteShowerHandler_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectBegin()
	mock.ExpectQuery("SELECT id FROM schedule_entries WHERE user_id=\\$1 AND day=\\$2 AND time=\\$3").
		WithArgs(1, "Monday", "10:00").WillReturnRows(sqlmock.NewRows([]string{"id"}).AddRow(1))
	mock.ExpectExec("UPDATE schedule_entries SET done = true WHERE user_id=\\$1 AND day=\\$2 AND time=\\$3").
		WithArgs(1, "Monday", "10:00").WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec("INSERT INTO sessions \\(user_id, date, total_duration, cold_duration\\) VALUES \\(\\$1, NOW\\(\\), INTERVAL '0', INTERVAL '0'\\)").
		WithArgs(1).WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	reqBody := models.ScheduleCompleteRequest{
		Day:  "Monday",
		Task: "10:00",
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/shower/completed", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CompleteShowerHandler(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var response map[string]string
	if err := json.Unmarshal(rec.Body.Bytes(), &response); err != nil {
		t.Fatalf("error unmarshaling response: %v", err)
	}

	if response["message"] != "Shower marked as completed" {
		t.Errorf("expected message 'Shower marked as completed', got %s", response["message"])
	}
}

func TestCompleteShowerHandler_Unauthorized(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 0,
		mockError:  errors.New("unauthorized"),
	}

	reqBody := models.ScheduleCompleteRequest{
		Day:  "Monday",
		Task: "10:00",
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/shower/completed", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CompleteShowerHandler(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("expected status 401, got %d", rec.Code)
	}
}

func TestCompleteShowerHandler_InvalidJSON(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	req := httptest.NewRequest(http.MethodPost, "/api/user/shower/completed", bytes.NewReader([]byte("invalid json")))
	rec := httptest.NewRecorder()

	handler.CompleteShowerHandler(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestCompleteShowerHandler_TaskNotFound(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectBegin()
	mock.ExpectQuery("SELECT id FROM schedule_entries WHERE user_id=\\$1 AND day=\\$2 AND time=\\$3").
		WithArgs(1, "Monday", "10:00").WillReturnError(sql.ErrNoRows)
	mock.ExpectRollback()

	reqBody := models.ScheduleCompleteRequest{
		Day:  "Monday",
		Task: "10:00",
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/shower/completed", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CompleteShowerHandler(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

func TestCompleteShowerHandler_BeginError(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	handler := &TestHandler{
		Handler:    NewHandler(db),
		mockUserID: 1,
		mockError:  nil,
	}

	mock.ExpectBegin().WillReturnError(errors.New("begin error"))

	reqBody := models.ScheduleCompleteRequest{
		Day:  "Monday",
		Task: "10:00",
	}
	body, _ := json.Marshal(reqBody)

	req := httptest.NewRequest(http.MethodPost, "/api/user/shower/completed", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.CompleteShowerHandler(rec, req)

	if rec.Code != http.StatusInternalServerError {
		t.Errorf("expected status 500, got %d", rec.Code)
	}
}

// --- Тесты вспомогательных функций ---

func TestGetNextOccurrence(t *testing.T) {
	eventTime, _ := time.Parse("15:04", "10:00")

	// Тест для понедельника
	result := getNextOccurrence("monday", eventTime)
	if result.Weekday() != time.Monday {
		t.Errorf("expected Monday, got %v", result.Weekday())
	}
	if result.Hour() != 10 || result.Minute() != 0 {
		t.Errorf("expected 10:00, got %02d:%02d", result.Hour(), result.Minute())
	}

	// Тест для воскресенья
	result = getNextOccurrence("sunday", eventTime)
	if result.Weekday() != time.Sunday {
		t.Errorf("expected Sunday, got %v", result.Weekday())
	}

	// Тест для вторника
	result = getNextOccurrence("tuesday", eventTime)
	if result.Weekday() != time.Tuesday {
		t.Errorf("expected Tuesday, got %v", result.Weekday())
	}

	// Тест для среды
	result = getNextOccurrence("wednesday", eventTime)
	if result.Weekday() != time.Wednesday {
		t.Errorf("expected Wednesday, got %v", result.Weekday())
	}

	// Тест для четверга
	result = getNextOccurrence("thursday", eventTime)
	if result.Weekday() != time.Thursday {
		t.Errorf("expected Thursday, got %v", result.Weekday())
	}

	// Тест для пятницы
	result = getNextOccurrence("friday", eventTime)
	if result.Weekday() != time.Friday {
		t.Errorf("expected Friday, got %v", result.Weekday())
	}

	// Тест для субботы
	result = getNextOccurrence("saturday", eventTime)
	if result.Weekday() != time.Saturday {
		t.Errorf("expected Saturday, got %v", result.Weekday())
	}
}

func TestInsertScheduledNotification(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	scheduledAt := time.Now().Add(time.Hour)

	mock.ExpectExec("INSERT INTO scheduled_notifications \\(schedule_entry_id, user_id, type, scheduled_at, sent, created_at\\) VALUES \\(\\$1, \\$2, \\$3, \\$4, FALSE, \\$5\\)").
		WithArgs(1, 1, "15_min_before", scheduledAt, sqlmock.AnyArg()).
		WillReturnResult(sqlmock.NewResult(1, 1))

	err := InsertScheduledNotification(db, 1, 1, "15_min_before", scheduledAt)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}
}

func TestInsertScheduledNotification_Error(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()

	scheduledAt := time.Now().Add(time.Hour)

	mock.ExpectExec("INSERT INTO scheduled_notifications \\(schedule_entry_id, user_id, type, scheduled_at, sent, created_at\\) VALUES \\(\\$1, \\$2, \\$3, \\$4, FALSE, \\$5\\)").
		WithArgs(1, 1, "15_min_before", scheduledAt, sqlmock.AnyArg()).
		WillReturnError(errors.New("insert error"))

	err := InsertScheduledNotification(db, 1, 1, "15_min_before", scheduledAt)
	if err == nil {
		t.Error("expected error, got nil")
	}
}
