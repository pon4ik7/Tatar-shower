package handlers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/rolanmulukin/tatar-shower-backend/models"
	"github.com/rolanmulukin/tatar-shower-backend/tokens"
	"golang.org/x/crypto/bcrypt"
)

func TestRegisterUser_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()
	handler := NewHandler(db)

	mock.ExpectBegin()
	mock.ExpectQuery(`INSERT INTO users`).WithArgs("testuser", sqlmock.AnyArg()).
		WillReturnRows(sqlmock.NewRows([]string{"id"}).AddRow(1))
	mock.ExpectExec(`INSERT INTO preferences`).WithArgs(1, "everyday").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec(`INSERT INTO goals`).WithArgs(1).
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	input := models.InputRegisterUserRequest{Login: "testuser", Password: "password"}
	body, _ := json.Marshal(input)
	req := httptest.NewRequest(http.MethodPost, "/api/register", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.RegisterUser(rec, req)
}

func TestRegisterUser_ValidationError(t *testing.T) {
	db, _, _ := sqlmock.New()
	defer db.Close()
	handler := NewHandler(db)

	input := models.InputRegisterUserRequest{Login: "", Password: ""}
	body, _ := json.Marshal(input)
	req := httptest.NewRequest(http.MethodPost, "/api/register", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.RegisterUser(rec, req)
}

func TestSignInUser_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()
	handler := NewHandler(db)

	hashed, _ := bcrypt.GenerateFromPassword([]byte("password"), bcrypt.DefaultCost)
	mock.ExpectQuery(`SELECT id, password_hash FROM users WHERE login = \$1`).
		WithArgs("testuser").
		WillReturnRows(sqlmock.NewRows([]string{"id", "password_hash"}).AddRow(1, string(hashed)))

	input := models.InputRegisterUserRequest{Login: "testuser", Password: "password"}
	body, _ := json.Marshal(input)
	req := httptest.NewRequest(http.MethodPost, "/api/signin", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.SignInUser(rec, req)
}

func TestSignInUser_InvalidPassword(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()
	handler := NewHandler(db)

	hashed, _ := bcrypt.GenerateFromPassword([]byte("password"), bcrypt.DefaultCost)
	mock.ExpectQuery(`SELECT id, password_hash FROM users WHERE login = \$1`).
		WithArgs("testuser").
		WillReturnRows(sqlmock.NewRows([]string{"id", "password_hash"}).AddRow(1, string(hashed)))

	input := models.InputRegisterUserRequest{Login: "testuser", Password: "wrong"}
	body, _ := json.Marshal(input)
	req := httptest.NewRequest(http.MethodPost, "/api/signin", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.SignInUser(rec, req)
}

var getUserIDFromRequest = tokens.GetUserIDFromRequest

func TestRegisterPushToken_Success(t *testing.T) {
	db, mock, _ := sqlmock.New()
	defer db.Close()
	handler := NewHandler(db)

	getUserIDFromRequest = func(r *http.Request) (int, error) { return 1, nil }
	defer func() { getUserIDFromRequest = tokens.GetUserIDFromRequest }()

	mock.ExpectExec(`INSERT INTO push_tokens`).WithArgs(1, "token123", "android").
		WillReturnResult(sqlmock.NewResult(1, 1))

	body := []byte(`{"token":"token123","platform":"android"}`)
	req := httptest.NewRequest(http.MethodPost, "/api/user/push-token", bytes.NewReader(body))
	rec := httptest.NewRecorder()

	handler.RegisterPushToken(rec, req)
}
