# API description

## Full API collection is available in Postman:  

[Postman Collection – Tatar Shower API](https://www.postman.com/pon4ik7/tatarshower/collection/kh8lsf5/tatar-shower-api?action=share&creator=45796036)


## Authentication
Describe authentication method (JWT, API key, etc.)

## Endpoints

### 1. User Registration
- **Method:** `POST`
- **Endpoint:** `/register`
- **Description:** Register a new user
- **Request Body:**
```
{
  "login": "string",
  "password": "string",
  "language": "string",
  "reason": "string",
  "frequency_type": "string",
  "custom_days": ["string"],
  "experience_type": "string",
  "target_streak": "integer"
}
```
- **Response:** 
  - **200:** User created successfully
  - **400:** Invalid input data
  - **409:** User already exists

### 2. User Login
- **Method:** `POST`
- **Endpoint:** `/login`
- **Description:** Authenticate user
- **Request Body:**
```
{
  "login": "string",
  "password": "string"
}
```
- **Response:**
  - **200:** Login successful, returns JWT token
  - **401:** Invalid credentials

### 3. Get User Profile
- **Method:** `GET`
- **Endpoint:** `/user/profile`
- **Description:** Get current user profile
- **Headers:**
  - `Authorization: Bearer {token}`
- **Response:**
  - **200:** User profile data
  - **401:** Unauthorized

### 4. Update User Settings
- **Method:** `PUT`
- **Endpoint:** `/user/settings`
- **Description:** Update user learning settings
- **Headers:**
  - `Authorization: Bearer {token}`
- **Request Body:**
```
{
  "language": "string",
  "frequency_type": "string",
  "custom_days": ["string"],
  "target_streak": "integer"
}
```
- **Response:**
  - **200:** Settings updated
  - **400:** Invalid input
  - **401:** Unauthorized

### 5. Get Lessons
- **Method:** `GET`
- **Endpoint:** `/lessons`
- **Description:** Get available lessons
- **Headers:**
  - `Authorization: Bearer {token}`
- **Query Parameters:**
  - `level`: Difficulty level (optional)
  - `category`: Lesson category (optional)
- **Response:**
  - **200:** List of lessons
  - **401:** Unauthorized

### 6. Submit Lesson Progress
- **Method:** `POST`
- **Endpoint:** `/lessons/{lesson_id}/progress`
- **Description:** Submit lesson completion
- **Headers:**
  - `Authorization: Bearer {token}`
- **Request Body:**
```
{
  "score": "integer",
  "completed": "boolean",
  "time_spent": "integer"
}
```
- **Response:**
  - **200:** Progress saved
  - **400:** Invalid data
  - **401:** Unauthorized

### 7. Get User Statistics
- **Method:** `GET`
- **Endpoint:** `/user/stats`
- **Description:** Get user learning statistics
- **Headers:**
  - `Authorization: Bearer {token}`
- **Response:**
  - **200:** Statistics data
  - **401:** Unauthorized

## Data Models

### User Model
```
{
  "id": "integer",
  "login": "string",
  "language": "string",
  "experience_type": "string",
  "target_streak": "integer",
  "current_streak": "integer",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Lesson Model
```
{
  "id": "integer",
  "title": "string",
  "description": "string",
  "level": "string",
  "category": "string",
  "content": "object",
  "created_at": "timestamp"
}
```

## Error Responses

All error responses follow this format:
```
{
  "error": {
    "code": "string",
    "message": "string",
    "details": "object"
  }
}
```

## Rate Limiting
- Max 100 requests per minute per user
- Max 1000 requests per hour per IP

## Notes
- All timestamps are in ISO 8601 format
- All requests must include `Content-Type: application/json`
- API responses are always in JSON format
