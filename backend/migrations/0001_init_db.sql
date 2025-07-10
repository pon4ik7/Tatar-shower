-- 0001_init_db.sql
-- +goose Up

CREATE TABLE users
(
    id            SERIAL PRIMARY KEY,
    login         VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(100)       NOT NULL,
    created_at    TIMESTAMP          NOT NULL DEFAULT NOW()
);

CREATE TABLE preferences
(
    user_id         INT PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    language        VARCHAR(10) NOT NULL DEFAULT 'en',
    theme           VARCHAR(10) NOT NULL DEFAULT 'light',
    notifications   BOOLEAN     NOT NULL DEFAULT true,
    frequency_type  VARCHAR(20) NOT NULL DEFAULT 'everyday',
    custom_days     SMALLINT[]    DEFAULT NULL,
    reminder_time   TIME                 DEFAULT NULL,
    experience_type VARCHAR(20) NOT NULL DEFAULT 'first_time',
    target_streak   INT         NOT NULL DEFAULT 7
);

CREATE TABLE sessions
(
    id      SERIAL PRIMARY KEY,
    user_id INT REFERENCES users (id) ON DELETE CASCADE,
    date    TIMESTAMP NOT NULL,
    total_duration INTERVAL NOT NULL,
    cold_duration INTERVAL NOT NULL,
    notes   TEXT
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

CREATE TABLE schedule_entries
(
    id      SERIAL PRIMARY KEY,
    user_id INT REFERENCES users (id) ON DELETE CASCADE,
    day     VARCHAR(10) NOT NULL,
    time    VARCHAR(10) NOT NULL,
    done    BOOLEAN DEFAULT false
);

-- +goose Down
DROP TABLE IF EXISTS tips;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS preferences;
DROP TABLE IF EXISTS schedule_entries;
DROP TABLE IF EXISTS users;
