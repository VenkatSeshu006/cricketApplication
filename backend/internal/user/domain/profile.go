package domain

import "time"

// UserProfile represents user profile information
type UserProfile struct {
	ID                string     `json:"id"`
	Email             string     `json:"email"`
	FullName          string     `json:"full_name"`
	Phone             string     `json:"phone,omitempty"`
	Role              string     `json:"role"`
	ProfilePictureURL string     `json:"profile_picture_url,omitempty"`
	Bio               string     `json:"bio,omitempty"`
	Location          string     `json:"location,omitempty"`
	DateOfBirth       *time.Time `json:"date_of_birth,omitempty"`
	IsVerified        bool       `json:"is_verified"`
	CreatedAt         time.Time  `json:"created_at"`
	UpdatedAt         time.Time  `json:"updated_at"`
}

// UpdateProfileRequest represents profile update request
type UpdateProfileRequest struct {
	FullName          string     `json:"full_name,omitempty"`
	Phone             string     `json:"phone,omitempty"`
	Bio               string     `json:"bio,omitempty"`
	Location          string     `json:"location,omitempty"`
	DateOfBirth       *time.Time `json:"date_of_birth,omitempty"`
	ProfilePictureURL string     `json:"profile_picture_url,omitempty"`
}
