package domain

import "context"

// AuthService defines the interface for authentication business logic
type AuthService interface {
	Register(ctx context.Context, req *RegisterRequest) (*AuthResponse, error)
	Login(ctx context.Context, req *LoginRequest) (*AuthResponse, error)
	ValidateToken(ctx context.Context, token string) (*User, error)
}
