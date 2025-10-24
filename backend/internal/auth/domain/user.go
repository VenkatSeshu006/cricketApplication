package domain

import "time"

// User represents a user in the system
type User struct {
	ID                string    `json:"id"`
	Email             string    `json:"email"`
	PasswordHash      string    `json:"-"` // Never expose password hash in JSON
	FullName          string    `json:"full_name"`
	Phone             string    `json:"phone,omitempty"`
	Role              string    `json:"role"`
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
	IsVerified        bool      `json:"is_verified"`
	ProfilePictureURL string    `json:"profile_picture_url,omitempty"`
}

// RegisterRequest represents user registration data
type RegisterRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	FullName string `json:"full_name"`
	Phone    string `json:"phone,omitempty"`
	Role     string `json:"role"`
}

// LoginRequest represents login credentials
type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

// AuthResponse represents authentication response with tokens
type AuthResponse struct {
	User         *User  `json:"user"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	ExpiresIn    int    `json:"expires_in"` // seconds
}
