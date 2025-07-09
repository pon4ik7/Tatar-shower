-- 0001_init_db.sql
-- +goose Up

CREATE TABLE users
(
    id            SERIAL PRIMARY KEY,
    login         VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(100)       NOT NULL,
    email         VARCHAR(100) UNIQUE,
    created_at    TIMESTAMP          NOT NULL DEFAULT NOW()
);

CREATE TABLE preferences
(
    user_id         INT PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    language        VARCHAR(10) NOT NULL DEFAULT 'en',
    theme           VARCHAR(10) NOT NULL DEFAULT 'light',
    notifications   BOOLEAN     NOT NULL DEFAULT true,
    reason          VARCHAR(255),
    frequency_type  VARCHAR(20) NOT NULL,
    custom_days     SMALLINT[]    DEFAULT NULL,
    reminder_time   TIME                 DEFAULT NULL,
    experience_type VARCHAR(20) NOT NULL DEFAULT 'first_time',

    target_streak   INT         NOT NULL DEFAULT 7
);

CREATE TABLE sessions
(
    id         SERIAL PRIMARY KEY,
    user_id    INT REFERENCES users (id) ON DELETE CASCADE,
    started_at TIMESTAMP NOT NULL,
    total_duration INTERVAL NOT NULL,
    cold_duration INTERVAL NOT NULL,
    notes      TEXT
);

CREATE TABLE goals
(
    user_id        INT PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    current_streak INT NOT NULL DEFAULT 0,
    last_completed DATE NULL
);

CREATE TABLE tips
(
    id       SERIAL PRIMARY KEY,
    message  TEXT NOT NULL,
    category VARCHAR(50)
);

-- +goose Down
DROP TABLE IF EXISTS tips;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS preferences;
DROP TABLE IF EXISTS users;
