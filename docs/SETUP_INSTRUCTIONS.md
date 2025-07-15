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
   git clone https://github.com/your-org/tatar-shower-api.git
   cd tatar-shower-api/backend
   ```

2. **Install Go dependencies:**
   ```
   go mod download
   ```

3. **Configure environment variables:**
   Create a `.env` file in the backend directory:
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_USER=your_db_user
   DB_PASSWORD=your_db_password
   DB_NAME=tatar_shower_db
   JWT_SECRET=your_jwt_secret_key
   PORT=8080
   ```

4. **Set up the database:**
   ```
   # Create database
   createdb tatar_shower_db
   
   # Run migrations
   go run migrations/migrate.go
   ```

5. **Start the backend server:**
   ```
   go run main.go
   ```
   The API will be available at `http://localhost:8080`

### Frontend Setup (Flutter)

1. **Navigate to the frontend directory:**
   ```
   cd ../frontend
   ```

2. **Install Flutter dependencies:**
   ```
   flutter pub get
   ```

3. **Configure API endpoint:**
   Edit `lib/config/api_config.dart`:
   ```
   class ApiConfig {
     static const String baseUrl = 'http://localhost:8080/api';
     // For Android emulator use: 'http://10.0.2.2:8080/api'
     // For iOS simulator use: 'http://127.0.0.1:8080/api'
   }
   ```

4. **Run the Flutter app:**
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

3. **Database connection test:**
   ```
   cd backend
   go run cmd/test-db/main.go
   ```

### Build for Production

#### Backend (Go)
```
cd backend
go build -o tatar-shower-api main.go
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
cd backend
go test ./...
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
