package domain

import "context"

// UserService defines the interface for user business logic
type UserService interface {
	GetProfile(ctx context.Context, userID string) (*UserProfile, error)
	UpdateProfile(ctx context.Context, userID string, req *UpdateProfileRequest) (*UserProfile, error)
}
