# Tatar Shower App

A cross-platform application for building healthy cold shower habits. Includes a Go backend, Flutter frontend, and DevOps automation for modern development.

## Team Roles & Responsibilities
- Latipov Arsen - Frontent Developer
- Minaeva Ksenia - QA Engeneer & Designer
- Muliukin Rolan - Backend Developer & API Engeneer
- Nagimova Adelia - DevOps Engeneer & DB Developer


---


## Project Overview

Tatar Shower App helps users schedule cold showers, receive reminders, track progress, and get motivational tips. The project is organized as a monorepo containing:

- **Backend:** REST API on Go (Gorilla Mux, JWT)
- **Frontend:** Mobile app on Flutter (Dart)
- **DevOps:** Automated workflows, Docker, and infrastructure scripts

---

## Setup instructions

[Contributing](./docs/SETUP_INSTRUCTIONS.md)

## Architecture
```
tatar-shower/
├── backend/      # Go REST API
├── frontend/     # Flutter mobile app
├── devops/       # CI/CD, Docker, IaC, scripts
├── README.md
└── …
```

---

## Backend (Go)

### Features

- User registration and authentication (JWT)
- Weekly schedule management for cold showers
- Progress tracking and statistics
- Tips and advice endpoints
- RESTful API with JSON responses

### Directory Structure

```
frontend/
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── models/
│   ├── services/
│   └── …
├── android/
├── ios/
└── …
```

---

## DevOps & CI/CD

### Features

- Automated testing, build, and deployment (GitHub Actions)
- Dockerized backend for local and cloud deployments
- Infrastructure as Code (Terraform, scripts)
- Monitoring, logging, and backup scripts
- Security scanning and dependency checks

---

## API Documentation

[API description](./docs/API_DOCUMENTATION.md)

---

## Git Workflow

[Documentation](./docs/GIT_WORKFLOW.md)

## Environment Variables

Create a `.env` file in the appropriate directory (backend/frontend):

```
JWT_SECRET=your_secret_key
DATABASE_URL=./app.db
```

---

## Running Tests

### Backend

```
cd backend
go test ./…
```

### Frontend

```
cd frontend
flutter test
```

---
