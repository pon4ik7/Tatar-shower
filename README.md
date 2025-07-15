# Tatar Shower App

A cross-platform application for building healthy cold shower habits. Includes a Go backend, Flutter frontend, and DevOps automation for modern development.

## Team Roles & Responsibilities
- Latipov Arsen - Frontent Developer
- Minaeva Ksenia - QA Engeneer & Designer
- Muliukin Rolan - Backend Developer & API Engeneer
- Nagimova Adelia - DevOps Engeneer & DB Developer


---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Backend (Go)](#backend-go)
- [Frontend (Flutter)](#frontend-flutter)
- [DevOps & CI/CD](#devops--cicd)
- [API Documentation](#api-documentation)
- [Git Workflow](#git-workflow)
- [Environment Variables](#environment-variables)
- [Running Tests](#running-tests)
- [Contributing](#contributing)
- [License](#license)

---

## Project Overview

Tatar Shower App helps users schedule cold showers, receive reminders, track progress, and get motivational tips. The project is organized as a monorepo containing:

- **Backend:** REST API on Go (Gorilla Mux, JWT)
- **Frontend:** Mobile app on Flutter (Dart)
- **DevOps:** Automated workflows, Docker, and infrastructure scripts

---

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

### Getting Started

1. **Install dependencies:**
    ```
    cd backend
    go mod tidy
    ```

2. **Run the server:**
    ```
    go run main.go
    ```
    The server will start on `http://localhost:8080`.

3. **Environment Variables:**
    - `JWT_SECRET` – Secret key for JWT signing
    - `DATABASE_URL` – Path to SQLite DB (e.g., `./app.db`)

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

### Getting Started

- **CI/CD:** All pushes/PRs trigger automated workflows (`.github/workflows/`)
- **Docker:**  
    ```
    docker-compose up --build
    ```
- **Terraform:**  
    See `devops/terraform/` for infrastructure setup instructions.

---

## API Documentation

[API description](./docs/API_DOCUMENTATION.md)

---

## Git Workflow

### Branching Strategy

- `main` — production-ready code
- `dev` — integration branch
- `feature/xyz` — feature branches
- `bugfix/xyz` — bugfix branches
- `hotfix/xyz` — urgent fixes

### Typical Workflow

1. **Create a branch:**
    ```
    git checkout dev
    git pull
    git checkout -b feature/your-feature
    ```
2. **Make changes and commit:**
    ```
    git add .
    git commit -m "Describe your feature"
    ```
3. **Push and open a PR to `dev`**

### Commit Message Guidelines

- Use clear, descriptive messages.
- Examples:
    - `feat: add user registration endpoint`
    - `fix: correct JWT expiration logic`
    - `docs: update API documentation`

---

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

## Contributing

- Fork the repository
- Create a feature branch
- Follow the Git Workflow above
- Make sure all tests pass before submitting a PR

---

## License

MIT License

---
