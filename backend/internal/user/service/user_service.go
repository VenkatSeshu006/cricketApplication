package service

import (
	"context"
	"fmt"
	"strings"

	"github.com/cricketapp/backend/internal/user/domain"
)

type userService struct {
	userRepo domain.UserRepository
}

// NewUserService creates a new user service
func NewUserService(userRepo domain.UserRepository) domain.UserService {
	return &userService{
		userRepo: userRepo,
	}
}

func (s *userService) GetProfile(ctx context.Context, userID string) (*domain.UserProfile, error) {
	if userID == "" {
		return nil, fmt.Errorf("user ID is required")
	}

	profile, err := s.userRepo.GetProfileByID(ctx, userID)
	if err != nil {
		return nil, err
	}

	return profile, nil
}

func (s *userService) UpdateProfile(ctx context.Context, userID string, req *domain.UpdateProfileRequest) (*domain.UserProfile, error) {
	if userID == "" {
		return nil, fmt.Errorf("user ID is required")
	}

	// Validate request
	if err := s.validateUpdateRequest(req); err != nil {
		return nil, err
	}

	// Update profile
	if err := s.userRepo.UpdateProfile(ctx, userID, req); err != nil {
		return nil, err
	}

	// Get updated profile
	profile, err := s.userRepo.GetProfileByID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch updated profile: %w", err)
	}

	return profile, nil
}

func (s *userService) validateUpdateRequest(req *domain.UpdateProfileRequest) error {
	if req.FullName != "" {
		req.FullName = strings.TrimSpace(req.FullName)
		if len(req.FullName) < 2 {
			return fmt.Errorf("full name must be at least 2 characters")
		}
	}

	if req.Phone != "" {
		req.Phone = strings.TrimSpace(req.Phone)
		if len(req.Phone) < 10 {
			return fmt.Errorf("invalid phone number")
		}
	}

	if req.Bio != "" && len(req.Bio) > 500 {
		return fmt.Errorf("bio must not exceed 500 characters")
	}

	return nil
}
