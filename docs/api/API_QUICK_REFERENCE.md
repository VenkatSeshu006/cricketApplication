# CricketApp Backend API - Quick Reference

**Base URL**: `http://localhost:8080/api/v1`  
**Version**: 1.0.0  
**Authentication**: JWT Bearer Token

---

## Authentication

### Register
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Pass123!",
  "full_name": "John Doe",
  "phone": "+919999888877",
  "role": "player"
}
```

### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Pass123!"
}
```

**Response**:
```json
{
  "status": "success",
  "data": {
    "user": { /* user object */ },
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "expires_in": 900
  }
}
```

---

## User Profile

### Get Profile
```http
GET /users/profile
Authorization: Bearer {token}
```

### Update Profile
```http
PUT /users/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "full_name": "John Doe Updated",
  "phone": "+919999888877",
  "profile_picture_url": "https://example.com/photo.jpg",
  "bio": "Cricket enthusiast",
  "location": "Bangalore"
}
```

---

## Ground Booking

### List Grounds (Public)
```http
GET /grounds
```

### Get Ground Details (Public)
```http
GET /grounds/{id}
```

### Create Booking
```http
POST /bookings
Authorization: Bearer {token}
Content-Type: application/json

{
  "ground_id": "ground-uuid",
  "booking_date": "2025-10-25",
  "start_time": "14:00:00",
  "end_time": "16:00:00",
  "purpose": "Practice match"
}
```

### Get My Bookings
```http
GET /bookings/my
Authorization: Bearer {token}
```

---

## Medical/Physio Service

### List Physiotherapists (Public)
```http
GET /physiotherapists
```

### Get Physiotherapist Details (Public)
```http
GET /physiotherapists/{id}
```

### Create Appointment
```http
POST /appointments
Authorization: Bearer {token}
Content-Type: application/json

{
  "physiotherapist_id": "physio-uuid",
  "appointment_date": "2025-10-26",
  "appointment_time": "10:00:00",
  "reason": "Shoulder pain"
}
```

### Get My Appointments
```http
GET /appointments/my
Authorization: Bearer {token}
```

---

## Staff Hiring Service

### List Jobs (Public)
```http
GET /jobs?status=open&position_type=coach
```

**Query Parameters**:
- `status`: open, closed
- `position_type`: coach, groundskeeper, scorer, analyst, physio, manager

### Get Job Details (Public)
```http
GET /jobs/{id}
```

### Create Job Posting
```http
POST /jobs
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Head Coach Position",
  "description": "We are looking for an experienced cricket coach...",
  "position_type": "coach",
  "requirements": ["10+ years experience", "Level 3 coaching certificate"],
  "location": "Mumbai",
  "salary_range": "50000-80000",
  "deadline": "2025-11-30"
}
```

### Get My Posted Jobs
```http
GET /jobs/my
Authorization: Bearer {token}
```

### Close Job
```http
PUT /jobs/{id}/close
Authorization: Bearer {token}
```

### Apply for Job
```http
POST /jobs/{id}/apply
Authorization: Bearer {token}
Content-Type: application/json

{
  "cover_letter": "I am excited to apply for this position...",
  "resume_url": "https://example.com/resume.pdf",
  "expected_salary": "60000"
}
```

### View Job Applications
```http
GET /jobs/{id}/applications
Authorization: Bearer {token}
```

### Get My Applications
```http
GET /applications/my
Authorization: Bearer {token}
```

### Update Application Status
```http
PUT /applications/{id}/status
Authorization: Bearer {token}
Content-Type: application/json

{
  "status": "reviewed"
}
```

**Status Values**: `pending`, `reviewed`, `accepted`, `rejected`

---

## Community Feed Service

### Get Feed (Public)
```http
GET /posts?page=1&limit=20&type=training
```

**Query Parameters**:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)
- `type`: Filter by post type (general, match, training, achievement, question)

### Get Post Details (Public)
```http
GET /posts/{id}
```

### Get Post Comments (Public)
```http
GET /posts/{id}/comments
```

### Create Post
```http
POST /posts
Authorization: Bearer {token}
Content-Type: application/json

{
  "content": "Just finished practice! Great session today!",
  "media_urls": ["https://example.com/photo1.jpg"],
  "post_type": "training",
  "visibility": "public"
}
```

**Post Types**: `general`, `match`, `training`, `achievement`, `question`  
**Visibility**: `public`, `friends`, `private`

### Update Post
```http
PUT /posts/{id}
Authorization: Bearer {token}
Content-Type: application/json

{
  "content": "Updated post content"
}
```

### Delete Post
```http
DELETE /posts/{id}
Authorization: Bearer {token}
```

### Get User's Posts
```http
GET /users/{userId}/posts
Authorization: Bearer {token}
```

### Add Comment
```http
POST /posts/{id}/comments
Authorization: Bearer {token}
Content-Type: application/json

{
  "content": "Great work! Keep it up!"
}
```

### Delete Comment
```http
DELETE /comments/{commentId}
Authorization: Bearer {token}
```

### Like Post
```http
POST /posts/{id}/like
Authorization: Bearer {token}
```

### Unlike Post
```http
DELETE /posts/{id}/like
Authorization: Bearer {token}
```

### Like Comment
```http
POST /comments/{commentId}/like
Authorization: Bearer {token}
```

### Unlike Comment
```http
DELETE /comments/{commentId}/like
Authorization: Bearer {token}
```

---

## Response Formats

### Success Response
```json
{
  "status": "success",
  "message": "Operation completed successfully",
  "data": { /* response data */ }
}
```

### Error Response
```json
{
  "status": "error",
  "message": "Error description"
}
```

---

## Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | Successful GET, PUT, DELETE |
| 201 | Created | Successful POST (resource created) |
| 400 | Bad Request | Invalid input, validation error |
| 401 | Unauthorized | Missing/invalid token |
| 404 | Not Found | Resource doesn't exist |
| 500 | Internal Server Error | Unexpected server error |

---

## Common Headers

### All Requests
```
Content-Type: application/json
```

### Protected Endpoints
```
Authorization: Bearer {access_token}
```

---

## Pagination Response Format

For endpoints that return lists (feed, jobs, etc.):

```json
{
  "status": "success",
  "message": "Data retrieved successfully",
  "data": {
    "items": [ /* array of items */ ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "total_pages": 3
    }
  }
}
```

---

## Testing

Run tests with PowerShell:
```powershell
# Navigate to backend directory
cd c:\Users\ASUS\Documents\CricketApp\backend

# Run specific tests
.\test_auth.ps1           # Authentication
.\test_user_profile.ps1   # User profile
.\test_ground_booking.ps1 # Ground booking
.\test_physio.ps1         # Medical/Physio service
.\test_hiring.ps1         # Staff hiring service
.\test_community.ps1      # Community feed service
```

---

## Health Check

```http
GET /health
```

**Response**:
```json
{
  "status": "success",
  "message": "CricketApp API is running",
  "version": "1.0.0"
}
```

---

## Notes

1. **Token Expiration**: Access tokens expire in 15 minutes (900 seconds)
2. **Rate Limiting**: Not implemented yet (future feature)
3. **File Uploads**: Not implemented yet - use URLs for now
4. **Real-time**: Not implemented yet - polling required for updates
5. **Pagination**: Default page size is 20, maximum is 100

---

## Support

For issues or questions:
- Check logs in terminal
- Review test scripts for examples
- See documentation in `docs/` folder
