package domain

import "context"

// UserRepository defines the interface for user data access
type UserRepository interface {
	GetProfileByID(ctx context.Context, userID string) (*UserProfile, error)
	UpdateProfile(ctx context.Context, userID string, req *UpdateProfileRequest) error
}
