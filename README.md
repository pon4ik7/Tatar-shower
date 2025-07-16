# Tatar Shower App

A cross-platform application for building healthy cold shower habits. Includes a Go backend, Flutter frontend, and DevOps automation for modern development.

## Team Roles & Responsibilities
- **Latipov Arsen** - Frontent Developer
- **Minaeva Kseniia** - QA Engineer & Designer
- **Muliukin Rolan** - Backend Engineer & API Engineer
- **Nagimova Adelia** - DevOps Engineer & DB Developer


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
├── .github/      # GitHub Actions workflows
├── backend/      # Go REST API
├── frontend/     # Flutter mobile app
├── devops/       # CI/CD, Docker, IaC, scripts
├── docs/         # Architecture, API, workflow docs
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
│   ├── l10n/
│   ├── onboarding/
│   ├── main.dart
│   ├── screens/
│   ├── models/
│   ├── services/
│   ├── storage/
│   └── …
├── android/
├── ios/
└── …

backend/
├── db/
│ └── db.go
├── migrations/
├── models/
├── services/
│ ├── auth-service/
│ ├── shower-service/
│ └── rec-service/
├── tokens/
└── go.mod
```

---

## DevOps & CI/CD

### Features

- Automated testing, build, and deployment (GitHub Actions)
- Docker Compose for all services  
- GitHub Pages for frontend 
- Environment config management with YAML  
- Consistent code style & formatting checks
- Monitoring, logging, and backup scripts

---

## API Documentation

[API description](./docs/API_DOCUMENTATION.md)

---

## Architecture diagrams

[System architecture](./docs/System_arch.jpeg)
[Backend architecture](./docs/Backend_arch.jpeg)

---

## Git Workflow

[Documentation](./docs/GIT_WORKFLOW.md)

## Environment Variables

Create a `.env` file in the devOps directory:

```
POSTGRES_USER=tatar_shower
POSTGRES_PASSWORD=chinchanchonchi
POSTGRES_DB=shower_db
DATABASE_URL=postgres://tatar_shower:chinchanchonchi@db:5432/shower_db?sslmode=disable&client_encoding=UTF8
JWT_SECRET=your_secret_token
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

## Implementation checklist

### Technical requirements (20 points)
#### Backend development (8 points)
- [x] Go-based microservices architecture (minimum 3 services) (3 points)
- [ ] RESTful API with Swagger documentation (1 point)
- [ ] gRPC implementation for communication between microservices (1 point)
- [x] PostgreSQL database with proper schema design (1 point)
- [x] JWT-based authentication and authorization (1 point)
- [x] Comprehensive unit and integration tests (1 point)

#### Frontend development (8 points)
- [x] Flutter-based cross-platform application (mobile + web) (3 points)
- [x] Responsive UI design with custom widgets (1 point)
- [x] State management implementation (1 point)
- [x] Offline data persistence (1 point)
- [x] Unit and widget tests (1 point)
- [ ] Support light and dark mode (1 point)

#### DevOps & deployment (4 points)
- [x] Docker compose for all services (1 point)
- [x] CI/CD pipeline implementation (1 point)
- [x] Environment configuration management using config files (1 point)
- [x] GitHub pages for the project (1 point)

### Non-Technical Requirements (10 points)
#### Project management (4 points)
- [x] GitHub organization with well-maintained repository (1 point)
- [x] Regular commits and meaningful pull requests from all team members (1 point)
- [ ] Project board (GitHub Projects) with task tracking (1 point)
- [x] Team member roles and responsibilities documentation (1 point)

#### Documentation (4 points)
- [x] Project overview and setup instructions (1 point)
- [ ] Screenshots and GIFs of key features (1 point)
- [x] API documentation (1 point)
- [x] Architecture diagrams and explanations (1 point)

#### Code quality (2 points)
- [x] Consistent code style and formatting during CI/CD pipeline (1 point)
- [x] Code review participation and resolution (1 point)

### Bonus Features (up to 10 points)
- [ ] Localization for Russian (RU) and English (ENG) languages (2 points)
- [x] Good UI/UX design (up to 3 points)
- [ ] Integration with external APIs (fitness trackers, health devices) (up to 5 points)
- [ ] Comprehensive error handling and user feedback (up to 2 points)
- [ ] Advanced animations and transitions (up to 3 points)
- [x] Widget implementation for native mobile elements (up to 2 points)

Total points implemented: 21/30 (excluding bonus points)

---
