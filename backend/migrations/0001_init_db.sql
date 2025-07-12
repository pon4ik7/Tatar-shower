-- 0001_init_db.sql
-- +goose Up

CREATE TABLE users
(
    id            SERIAL PRIMARY KEY,
    login         VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(100)       NOT NULL,
    created_at    TIMESTAMP          NOT NULL DEFAULT NOW(),
    device_token  TEXT                        DEFAULT NULL
);

CREATE TABLE preferences
(
    user_id         INT PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    language        VARCHAR(10) NOT NULL DEFAULT 'en',
    notifications   BOOLEAN     NOT NULL DEFAULT true,
    reason          VARCHAR(255),
    frequency_type  VARCHAR(20) NOT NULL DEFAULT 'everyday',
    custom_days     SMALLINT[]    DEFAULT NULL,
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

CREATE TABLE push_tokens
(
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    token      VARCHAR(255) NOT NULL,
    platform   VARCHAR(10)  NOT NULL CHECK (platform IN ('android', 'ios')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, platform)
);

CREATE TABLE scheduled_notifications
(
    schedule_entry_id INT REFERENCES schedule_entries (id) ON DELETE CASCADE,
    id                SERIAL PRIMARY KEY,
    user_id           INTEGER     NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    type              VARCHAR(20) NOT NULL CHECK (type IN ('10_min_before', '5_min_before')),
    scheduled_at      TIMESTAMP   NOT NULL,
    sent              BOOLEAN   DEFAULT FALSE,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_scheduled_notifications_scheduled_at ON scheduled_notifications (scheduled_at);
CREATE INDEX idx_scheduled_notifications_sent ON scheduled_notifications (sent);
CREATE INDEX idx_scheduled_notifications_user_id ON scheduled_notifications (user_id);

-- +goose Down
DROP TABLE IF EXISTS tips;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS preferences;
DROP TABLE IF EXISTS scheduled_notifications;
DROP TABLE IF EXISTS schedule_entries;
DROP TABLE IF EXISTS push_tokens;
DROP TABLE IF EXISTS users;