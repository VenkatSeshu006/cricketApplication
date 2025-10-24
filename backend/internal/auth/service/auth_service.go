package service

import (
	"context"
	"fmt"
	"strings"

	"github.com/cricketapp/backend/internal/auth/domain"
	"github.com/cricketapp/backend/internal/auth/util"
)

type authService struct {
	userRepo domain.UserRepository
	jwtUtil  *util.JWTUtil
}

// NewAuthService creates a new authentication service
func NewAuthService(userRepo domain.UserRepository, jwtUtil *util.JWTUtil) domain.AuthService {
	return &authService{
		userRepo: userRepo,
		jwtUtil:  jwtUtil,
	}
}

func (s *authService) Register(ctx context.Context, req *domain.RegisterRequest) (*domain.AuthResponse, error) {
	// Validate input
	if err := s.validateRegisterRequest(req); err != nil {
		return nil, err
	}

	// Check if user already exists
	existingUser, _ := s.userRepo.GetByEmail(ctx, req.Email)
	if existingUser != nil {
		return nil, fmt.Errorf("user with email %s already exists", req.Email)
	}

	// Hash password
	hashedPassword, err := util.HashPassword(req.Password)
	if err != nil {
		return nil, fmt.Errorf("failed to hash password: %w", err)
	}

	// Create user
	user := &domain.User{
		Email:        req.Email,
		PasswordHash: hashedPassword,
		FullName:     req.FullName,
		Phone:        req.Phone,
		Role:         req.Role,
		IsVerified:   false,
	}

	if err := s.userRepo.Create(ctx, user); err != nil {
		return nil, fmt.Errorf("failed to create user: %w", err)
	}

	// Generate tokens
	accessToken, err := s.jwtUtil.GenerateToken(user.ID, user.Email, user.Role)
	if err != nil {
		return nil, fmt.Errorf("failed to generate access token: %w", err)
	}

	refreshToken, err := s.jwtUtil.GenerateToken(user.ID, user.Email, user.Role)
	if err != nil {
		return nil, fmt.Errorf("failed to generate refresh token: %w", err)
	}

	// Remove password hash from response
	user.PasswordHash = ""

	return &domain.AuthResponse{
		User:         user,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		ExpiresIn:    900, // 15 minutes
	}, nil
}

func (s *authService) Login(ctx context.Context, req *domain.LoginRequest) (*domain.AuthResponse, error) {
	// Validate input
	if req.Email == "" || req.Password == "" {
		return nil, fmt.Errorf("email and password are required")
	}

	// Get user by email
	user, err := s.userRepo.GetByEmail(ctx, req.Email)
	if err != nil {
		return nil, fmt.Errorf("invalid email or password")
	}

	// Check password
	if err := util.CheckPassword(req.Password, user.PasswordHash); err != nil {
		return nil, fmt.Errorf("invalid email or password")
	}

	// Generate tokens
	accessToken, err := s.jwtUtil.GenerateToken(user.ID, user.Email, user.Role)
	if err != nil {
		return nil, fmt.Errorf("failed to generate access token: %w", err)
	}

	refreshToken, err := s.jwtUtil.GenerateToken(user.ID, user.Email, user.Role)
	if err != nil {
		return nil, fmt.Errorf("failed to generate refresh token: %w", err)
	}

	// Remove password hash from response
	user.PasswordHash = ""

	return &domain.AuthResponse{
		User:         user,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		ExpiresIn:    900, // 15 minutes
	}, nil
}

func (s *authService) ValidateToken(ctx context.Context, token string) (*domain.User, error) {
	claims, err := s.jwtUtil.ValidateToken(token)
	if err != nil {
		return nil, fmt.Errorf("invalid token: %w", err)
	}

	user, err := s.userRepo.GetByID(ctx, claims.UserID)
	if err != nil {
		return nil, fmt.Errorf("user not found: %w", err)
	}

	// Remove password hash from response
	user.PasswordHash = ""

	return user, nil
}

func (s *authService) validateRegisterRequest(req *domain.RegisterRequest) error {
	if req.Email == "" {
		return fmt.Errorf("email is required")
	}
	if !strings.Contains(req.Email, "@") {
		return fmt.Errorf("invalid email format")
	}
	if req.Password == "" {
		return fmt.Errorf("password is required")
	}
	if len(req.Password) < 6 {
		return fmt.Errorf("password must be at least 6 characters")
	}
	if req.FullName == "" {
		return fmt.Errorf("full name is required")
	}
	if req.Role == "" {
		req.Role = "player" // Default role
	}
	// Validate role
	validRoles := map[string]bool{
		"player":         true,
		"umpire":         true,
		"commentator":    true,
		"streamer":       true,
		"organiser":      true,
		"personal_coach": true,
		"physio":         true,
	}
	if !validRoles[req.Role] {
		return fmt.Errorf("invalid role: %s", req.Role)
	}
	return nil
}
