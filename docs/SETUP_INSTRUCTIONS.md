## Setup Instructions

### Prerequisites
Before starting, make sure you have the following installed:

- **Go** (version 1.19 or higher)
- **Flutter SDK** (version 3.0 or higher)
- **Dart** (included with Flutter SDK)
- **Git** for version control
- **PostgreSQL** (or your preferred database)
- **IDE**: VS Code, Android Studio, or GoLand

### Backend Setup (Go)

1. **Clone the repository:**
   ```
   git clone https://github.com/your-org/tatar-shower-app-flutter-go.git
   cd tatar-shower-app-flutter-go/backend
   ```

2. **Install Go dependencies:**
   ```
   go mod download
   ```

3. **Configure environment variables:**
   Create a `.env` file in the devOps directory:
   ```
   POSTGRES_USER=tatar_shower
   POSTGRES_PASSWORD=chinchanchonchi
   POSTGRES_DB=shower_db
   DATABASE_URL=postgres://tatar_shower:chinchanchonchi@db:5432/shower_db?sslmode=disable&client_encoding=UTF8
   JWT_SECRET=your_jwt_secret_key
   ```

4. **Run the backend services:**
   ```
   cd tatar-shower-app-flutter-go/devOps
   docker-compose up --build
   ```
   This will start:
   - database (Postgres)

   - migrator (applies DB migrations)

   - auth‑service (port 8001)

   - shower‑service (port 8002)

   - rec‑service (port 8003)

   APIs will be available under http://localhost:8001/api, http://localhost:8002/api, http://localhost:8003/api

### Frontend Setup (Flutter)

1. **Navigate to the frontend directory:**
   ```
   cd frontend
   ```

2. **Install Flutter dependencies:**
   ```
   flutter pub get
   ```

3. **Run the Flutter app:**
   ```
   # For development
   flutter run
   
   # For specific device
   flutter run -d chrome    # Web browser
   flutter run -d android   # Android device/emulator
   flutter run -d ios       # iOS device/simulator
   ```

### Development Environment

1. **Check Flutter doctor:**
   ```
   flutter doctor
   ```
   Fix any issues reported by Flutter doctor.

2. **Verify Go installation:**
   ```
   go version
   ```

### Build for Production

#### Backend (Go)
```
cd backend/services/auth-service
go build -o auth-service
# similarly for shower-service, rec-service
```

#### Frontend (Flutter)
```
cd frontend

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release

# Build for Web
flutter build web --release
```

### Troubleshooting

**Common Issues:**

1. **Database connection error:**
   - Check if PostgreSQL is running
   - Verify database credentials in `.env`

2. **Flutter build fails:**
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter doctor for missing dependencies

3. **API connection issues:**
   - Verify backend server is running on correct port
   - Check firewall settings
   - For mobile testing, ensure device and backend are on same network

4. **Go modules issues:**
   - Run `go mod tidy` to clean up dependencies
   - Delete `go.sum` and run `go mod download`

### Testing

#### Backend Tests
```
go test ./backend/services/auth-service/handlers
go test ./backend/services/shower-service/handlers
go test ./backend/services/rec-service/handlers
```

#### Frontend Tests
```
cd frontend
flutter test
```

### Additional Commands

**Generate Flutter models from JSON:**
```
flutter packages pub run build_runner build
```

**Format code:**
```
# Go
go fmt ./...

# Flutter
flutter format .
```

**Check for updates:**
```
# Flutter
flutter upgrade

# Go modules
go get -u ./...
```
