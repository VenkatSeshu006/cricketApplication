# CricketApp - API Specification

**Version:** 1.0  
**Base URL:** `https://api.cricketapp.com/v1`  
**Protocol:** HTTPS  
**Format:** JSON  
**Authentication:** JWT (Bearer Token)

---

## Table of Contents

1. [Authentication](#authentication)
2. [Error Handling](#error-handling)
3. [API Endpoints](#api-endpoints)
   - [Auth Service](#auth-service)
   - [User Service](#user-service)
   - [Ground Service](#ground-service)
   - [Booking Service](#booking-service)
   - [Match Service](#match-service)
   - [Medical Service](#medical-service)
   - [Staff Service](#staff-service)
4. [WebSocket Events](#websocket-events)
5. [Rate Limiting](#rate-limiting)

---

## Authentication

### JWT Token Structure

```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "user_id": "uuid",
    "email": "user@example.com",
    "role": "player",
    "exp": 1234567890,
    "iat": 1234567890
  }
}
```

### Authorization Header

```
Authorization: Bearer <access_token>
```

### Token Lifecycle

- **Access Token**: Expires in 15 minutes
- **Refresh Token**: Expires in 7 days
- Store refresh token securely (HTTP-only cookie or secure storage)

---

## Error Handling

### Standard Error Response

```json
{
  "status": "error",
  "code": "VALIDATION_ERROR",
  "message": "Invalid input data",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ],
  "timestamp": "2025-10-20T10:30:00Z"
}
```

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200  | Success |
| 201  | Created |
| 204  | No Content |
| 400  | Bad Request (validation error) |
| 401  | Unauthorized (missing/invalid token) |
| 403  | Forbidden (insufficient permissions) |
| 404  | Not Found |
| 409  | Conflict (duplicate resource) |
| 422  | Unprocessable Entity |
| 429  | Too Many Requests (rate limit) |
| 500  | Internal Server Error |
| 503  | Service Unavailable |

### Error Codes

```
AUTH_001: Invalid credentials
AUTH_002: Token expired
AUTH_003: Account not verified
USER_001: User not found
USER_002: Duplicate email
GROUND_001: Ground not found
BOOKING_001: Slot not available
PAYMENT_001: Payment failed
```

---

## API Endpoints

---

## Auth Service

### 1. Register User

**Endpoint:** `POST /auth/register`

**Description:** Create a new user account.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "SecurePass123!",
  "full_name": "John Doe",
  "phone": "+919876543210",
  "role": "player"
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "data": {
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "john@example.com",
    "full_name": "John Doe",
    "role": "player",
    "is_verified": false
  },
  "message": "Registration successful. Please verify your email."
}
```

---

### 2. Login

**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "user": {
      "user_id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "john@example.com",
      "full_name": "John Doe",
      "role": "player",
      "profile_picture_url": "https://cdn.cricketapp.com/avatars/john.jpg"
    },
    "tokens": {
      "access_token": "eyJhbGciOiJIUzI1NiIs...",
      "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2g...",
      "expires_in": 900
    }
  }
}
```

---

### 3. Refresh Token

**Endpoint:** `POST /auth/refresh`

**Request Body:**
```json
{
  "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2g..."
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "expires_in": 900
  }
}
```

---

### 4. Logout

**Endpoint:** `POST /auth/logout`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "Logged out successfully"
}
```

---

### 5. Verify Email

**Endpoint:** `POST /auth/verify-email`

**Request Body:**
```json
{
  "token": "email_verification_token_here"
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "Email verified successfully"
}
```

---

### 6. Forgot Password

**Endpoint:** `POST /auth/forgot-password`

**Request Body:**
```json
{
  "email": "john@example.com"
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "Password reset link sent to your email"
}
```

---

### 7. Reset Password

**Endpoint:** `POST /auth/reset-password`

**Request Body:**
```json
{
  "token": "reset_token_from_email",
  "new_password": "NewSecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "Password reset successfully"
}
```

---

## User Service

### 1. Get User Profile

**Endpoint:** `GET /users/{user_id}`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "john@example.com",
    "full_name": "John Doe",
    "phone": "+919876543210",
    "role": "player",
    "profile_picture_url": "https://cdn.cricketapp.com/avatars/john.jpg",
    "created_at": "2025-01-15T10:30:00Z",
    "player_profile": {
      "batting_style": "Right-hand bat",
      "bowling_style": "Right-arm fast",
      "playing_role": "All-rounder",
      "teams": ["City Challengers", "State Warriors"],
      "stats": {
        "matches": 45,
        "runs": 1250,
        "wickets": 38,
        "average": 27.78
      }
    }
  }
}
```

---

### 2. Update User Profile

**Endpoint:** `PUT /users/{user_id}`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "full_name": "John Doe Updated",
  "phone": "+919876543211",
  "player_profile": {
    "batting_style": "Right-hand bat",
    "bowling_style": "Right-arm fast-medium"
  }
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "full_name": "John Doe Updated",
    "updated_at": "2025-10-20T11:45:00Z"
  }
}
```

---

### 3. Search Users

**Endpoint:** `GET /users/search`

**Query Parameters:**
- `q` (string): Search query
- `role` (string): Filter by role (player, coach, etc.)
- `location` (string): Filter by location
- `page` (int): Page number (default: 1)
- `limit` (int): Results per page (default: 20, max: 100)

**Example:** `GET /users/search?q=john&role=player&page=1&limit=10`

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "users": [
      {
        "user_id": "550e8400-e29b-41d4-a716-446655440000",
        "full_name": "John Doe",
        "role": "player",
        "profile_picture_url": "https://cdn.cricketapp.com/avatars/john.jpg"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 42,
      "total_pages": 5
    }
  }
}
```

---

### 4. Upload Profile Picture

**Endpoint:** `POST /users/{user_id}/avatar`

**Headers:** 
- `Authorization: Bearer <token>`
- `Content-Type: multipart/form-data`

**Request Body:**
- `file`: Image file (max 5MB, jpg/png)

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "profile_picture_url": "https://cdn.cricketapp.com/avatars/john.jpg"
  }
}
```

---

## Ground Service

### 1. List Grounds

**Endpoint:** `GET /grounds`

**Query Parameters:**
- `lat` (float): Latitude
- `lng` (float): Longitude
- `radius` (int): Search radius in km (default: 10)
- `facilities` (array): Filter by facilities
- `min_price` (float): Minimum price
- `max_price` (float): Maximum price
- `page` (int): Page number
- `limit` (int): Results per page

**Example:** `GET /grounds?lat=28.6139&lng=77.2090&radius=5&limit=10`

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "grounds": [
      {
        "ground_id": "650e8400-e29b-41d4-a716-446655440000",
        "name": "City Cricket Stadium",
        "address": "123 Stadium Road, New Delhi",
        "latitude": 28.6139,
        "longitude": 77.2090,
        "distance_km": 2.5,
        "facilities": ["floodlights", "pavilion", "parking", "wifi"],
        "pricing": {
          "hourly": 1000,
          "half_day": 4000,
          "full_day": 7000
        },
        "images": [
          "https://cdn.cricketapp.com/grounds/ground1-1.jpg",
          "https://cdn.cricketapp.com/grounds/ground1-2.jpg"
        ],
        "rating": 4.5,
        "owner": {
          "user_id": "750e8400-e29b-41d4-a716-446655440000",
          "full_name": "Ground Owner"
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 25,
      "total_pages": 3
    }
  }
}
```

---

### 2. Get Ground Details

**Endpoint:** `GET /grounds/{ground_id}`

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "ground_id": "650e8400-e29b-41d4-a716-446655440000",
    "name": "City Cricket Stadium",
    "description": "Premier cricket facility with modern amenities",
    "address": "123 Stadium Road, New Delhi",
    "latitude": 28.6139,
    "longitude": 77.2090,
    "facilities": ["floodlights", "pavilion", "parking", "wifi", "changing_rooms"],
    "pricing": {
      "hourly": 1000,
      "half_day": 4000,
      "full_day": 7000
    },
    "images": ["..."],
    "rating": 4.5,
    "total_reviews": 120,
    "availability": {
      "mon": ["09:00-12:00", "14:00-18:00"],
      "tue": ["09:00-18:00"],
      "wed": ["09:00-18:00"]
    },
    "owner": {
      "user_id": "750e8400-e29b-41d4-a716-446655440000",
      "full_name": "Ground Owner",
      "phone": "+919876543210"
    }
  }
}
```

---

### 3. Create Ground (Ground Owner only)

**Endpoint:** `POST /grounds`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "name": "New Cricket Ground",
  "description": "Well-maintained turf pitch",
  "address": "456 Ground Street, Mumbai",
  "latitude": 19.0760,
  "longitude": 72.8777,
  "facilities": ["floodlights", "parking"],
  "pricing": {
    "hourly": 800,
    "half_day": 3500,
    "full_day": 6000
  }
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "data": {
    "ground_id": "850e8400-e29b-41d4-a716-446655440000",
    "name": "New Cricket Ground",
    "created_at": "2025-10-20T12:00:00Z"
  }
}
```

---

## Booking Service

### 1. Check Availability

**Endpoint:** `GET /bookings/availability`

**Query Parameters:**
- `ground_id` (uuid): Ground ID
- `date` (date): Date in YYYY-MM-DD format

**Example:** `GET /bookings/availability?ground_id=650e8400&date=2025-11-15`

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "ground_id": "650e8400-e29b-41d4-a716-446655440000",
    "date": "2025-11-15",
    "available_slots": [
      {
        "start_time": "09:00",
        "end_time": "12:00",
        "price": 3000
      },
      {
        "start_time": "14:00",
        "end_time": "18:00",
        "price": 4000
      }
    ]
  }
}
```

---

### 2. Create Booking

**Endpoint:** `POST /bookings`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "ground_id": "650e8400-e29b-41d4-a716-446655440000",
  "booking_date": "2025-11-15",
  "start_time": "09:00",
  "end_time": "12:00"
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "data": {
    "booking_id": "950e8400-e29b-41d4-a716-446655440000",
    "ground_id": "650e8400-e29b-41d4-a716-446655440000",
    "booking_date": "2025-11-15",
    "start_time": "09:00",
    "end_time": "12:00",
    "amount": 3000,
    "status": "pending",
    "payment_url": "https://payment.cricketapp.com/pay/950e8400",
    "created_at": "2025-10-20T12:30:00Z"
  }
}
```

---

### 3. Get My Bookings

**Endpoint:** `GET /bookings/my`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `status` (string): Filter by status (pending, confirmed, cancelled)
- `page` (int): Page number
- `limit` (int): Results per page

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "bookings": [
      {
        "booking_id": "950e8400-e29b-41d4-a716-446655440000",
        "ground": {
          "ground_id": "650e8400-e29b-41d4-a716-446655440000",
          "name": "City Cricket Stadium",
          "address": "123 Stadium Road"
        },
        "booking_date": "2025-11-15",
        "start_time": "09:00",
        "end_time": "12:00",
        "amount": 3000,
        "status": "confirmed",
        "created_at": "2025-10-20T12:30:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 5,
      "total_pages": 1
    }
  }
}
```

---

### 4. Cancel Booking

**Endpoint:** `POST /bookings/{booking_id}/cancel`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "booking_id": "950e8400-e29b-41d4-a716-446655440000",
    "status": "cancelled",
    "refund_amount": 2400,
    "refund_status": "processing"
  }
}
```

---

## Match Service

### 1. List Matches

**Endpoint:** `GET /matches`

**Query Parameters:**
- `status` (string): scheduled, live, completed
- `date` (date): Filter by date
- `page` (int): Page number
- `limit` (int): Results per page

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "matches": [
      {
        "match_id": "a50e8400-e29b-41d4-a716-446655440000",
        "team1": {
          "name": "City Challengers",
          "logo": "https://cdn.cricketapp.com/teams/team1.png"
        },
        "team2": {
          "name": "State Warriors",
          "logo": "https://cdn.cricketapp.com/teams/team2.png"
        },
        "match_type": "T20",
        "match_date": "2025-11-20T14:00:00Z",
        "venue": "City Cricket Stadium",
        "status": "live",
        "live_stream_url": "wss://stream.cricketapp.com/match/a50e8400",
        "score": {
          "team1": {"runs": 145, "wickets": 5, "overs": 18.2},
          "team2": {"runs": 0, "wickets": 0, "overs": 0}
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 15,
      "total_pages": 2
    }
  }
}
```

---

### 2. Get Match Details

**Endpoint:** `GET /matches/{match_id}`

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "match_id": "a50e8400-e29b-41d4-a716-446655440000",
    "team1": {...},
    "team2": {...},
    "match_type": "T20",
    "match_date": "2025-11-20T14:00:00Z",
    "venue": {
      "ground_id": "650e8400-e29b-41d4-a716-446655440000",
      "name": "City Cricket Stadium",
      "address": "123 Stadium Road"
    },
    "status": "live",
    "live_stream_url": "wss://stream.cricketapp.com/match/a50e8400",
    "score": {
      "team1": {
        "runs": 145,
        "wickets": 5,
        "overs": 18.2,
        "batsmen": [
          {"name": "Player 1", "runs": 45, "balls": 32},
          {"name": "Player 2", "runs": 12, "balls": 8}
        ],
        "bowlers": [...]
      },
      "team2": {...}
    },
    "commentary": [
      {
        "over": 18.2,
        "text": "SIX! What a shot!",
        "timestamp": "2025-11-20T15:30:00Z"
      }
    ]
  }
}
```

---

## Medical Service

### 1. List Doctors

**Endpoint:** `GET /doctors`

**Query Parameters:**
- `specialization` (string): physiotherapy, sports_medicine
- `location` (string): City or area
- `availability` (date): Check availability on specific date

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "doctors": [
      {
        "user_id": "c50e8400-e29b-41d4-a716-446655440000",
        "full_name": "Dr. Sarah Johnson",
        "specialization": "Sports Physiotherapy",
        "experience_years": 8,
        "rating": 4.8,
        "profile_picture_url": "https://cdn.cricketapp.com/doctors/sarah.jpg",
        "consultation_fee": 500,
        "next_available": "2025-10-22T10:00:00Z"
      }
    ]
  }
}
```

---

### 2. Book Consultation

**Endpoint:** `POST /consultations`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "doctor_id": "c50e8400-e29b-41d4-a716-446655440000",
  "appointment_time": "2025-10-22T10:00:00Z",
  "consultation_type": "video",
  "reason": "Knee injury assessment"
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "data": {
    "consultation_id": "d50e8400-e29b-41d4-a716-446655440000",
    "doctor_id": "c50e8400-e29b-41d4-a716-446655440000",
    "appointment_time": "2025-10-22T10:00:00Z",
    "consultation_type": "video",
    "status": "scheduled",
    "video_call_url": "https://video.cricketapp.com/call/d50e8400"
  }
}
```

---

## Staff Service

### 1. List Job Postings

**Endpoint:** `GET /jobs`

**Query Parameters:**
- `role` (string): coach, umpire, statistician, ground_staff
- `location` (string): City
- `salary_min` (int): Minimum salary
- `page` (int): Page number

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "jobs": [
      {
        "job_id": "e50e8400-e29b-41d4-a716-446655440000",
        "title": "Head Coach Required",
        "role": "coach",
        "description": "Experienced coach needed for U-19 team",
        "location": "Mumbai",
        "salary_range": "50000-80000",
        "requirements": ["Level 2 Coaching Certificate", "5+ years experience"],
        "posted_by": {
          "user_id": "f50e8400-e29b-41d4-a716-446655440000",
          "full_name": "Team Manager"
        },
        "posted_at": "2025-10-15T09:00:00Z"
      }
    ]
  }
}
```

---

### 2. Create Job Posting

**Endpoint:** `POST /jobs`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "title": "Umpire Needed",
  "role": "umpire",
  "description": "Certified umpire for local tournaments",
  "location": "Delhi",
  "salary_range": "2000 per match",
  "requirements": ["BCCI Level 1 Certification"]
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "data": {
    "job_id": "g50e8400-e29b-41d4-a716-446655440000",
    "title": "Umpire Needed",
    "posted_at": "2025-10-20T13:00:00Z"
  }
}
```

---

### 3. Apply for Job

**Endpoint:** `POST /jobs/{job_id}/apply`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "cover_letter": "I am interested in this position...",
  "resume_url": "https://storage.cricketapp.com/resumes/john-resume.pdf"
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "data": {
    "application_id": "h50e8400-e29b-41d4-a716-446655440000",
    "job_id": "g50e8400-e29b-41d4-a716-446655440000",
    "status": "pending",
    "applied_at": "2025-10-20T13:15:00Z"
  }
}
```

---

## WebSocket Events

### Connection

**URL:** `wss://api.cricketapp.com/v1/ws`

**Authentication:** Include token in connection URL:
```
wss://api.cricketapp.com/v1/ws?token=<access_token>
```

### Live Match Updates

**Subscribe:**
```json
{
  "type": "subscribe",
  "channel": "match",
  "match_id": "a50e8400-e29b-41d4-a716-446655440000"
}
```

**Server Events:**
```json
{
  "type": "score_update",
  "match_id": "a50e8400-e29b-41d4-a716-446655440000",
  "data": {
    "runs": 146,
    "wickets": 5,
    "overs": 18.3,
    "current_run_rate": 7.97
  },
  "timestamp": "2025-11-20T15:31:00Z"
}
```

### Chat Messages

**Send Message:**
```json
{
  "type": "chat_message",
  "match_id": "a50e8400-e29b-41d4-a716-446655440000",
  "message": "Great shot!"
}
```

**Receive Message:**
```json
{
  "type": "chat_message",
  "match_id": "a50e8400-e29b-41d4-a716-446655440000",
  "data": {
    "message_id": "i50e8400-e29b-41d4-a716-446655440000",
    "user": {
      "user_id": "550e8400-e29b-41d4-a716-446655440000",
      "full_name": "John Doe"
    },
    "message": "Great shot!",
    "timestamp": "2025-11-20T15:32:00Z"
  }
}
```

---

## Rate Limiting

### Limits

| Tier | Requests per Minute | Requests per Day |
|------|---------------------|------------------|
| Anonymous | 20 | 1,000 |
| Authenticated | 100 | 10,000 |
| Premium | 500 | 50,000 |

### Headers

Response includes rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1634567890
```

### Rate Limit Exceeded Response (429)

```json
{
  "status": "error",
  "code": "RATE_LIMIT_EXCEEDED",
  "message": "Too many requests. Please try again later.",
  "retry_after": 60
}
```

---

## Pagination

All list endpoints support pagination with consistent parameters:

**Query Parameters:**
- `page` (int): Page number (default: 1)
- `limit` (int): Results per page (default: 20, max: 100)

**Response Structure:**
```json
{
  "status": "success",
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "total_pages": 8,
      "has_next": true,
      "has_prev": false
    }
  }
}
```

---

## Versioning

API versioning is done via URL path:
- Current: `/v1/`
- Future: `/v2/`

Deprecated versions will be supported for 6 months after a new version is released.

---

**Last Updated:** October 20, 2025  
**Contact:** api-support@cricketapp.com  
**Status:** Draft - Version 1.0
