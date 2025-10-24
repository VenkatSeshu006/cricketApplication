package postgres

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/cricketapp/backend/internal/user/domain"
)

type userRepository struct {
	db *sql.DB
}

// NewUserRepository creates a new user repository
func NewUserRepository(db *sql.DB) domain.UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) GetProfileByID(ctx context.Context, userID string) (*domain.UserProfile, error) {
	query := `
		SELECT id, email, full_name, phone, role, profile_picture_url, 
		       is_verified, created_at, updated_at
		FROM users
		WHERE id = $1
	`

	profile := &domain.UserProfile{}
	var phone, profilePictureURL sql.NullString

	err := r.db.QueryRowContext(ctx, query, userID).Scan(
		&profile.ID,
		&profile.Email,
		&profile.FullName,
		&phone,
		&profile.Role,
		&profilePictureURL,
		&profile.IsVerified,
		&profile.CreatedAt,
		&profile.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("user not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get user profile: %w", err)
	}

	// Handle nullable fields
	if phone.Valid {
		profile.Phone = phone.String
	}
	if profilePictureURL.Valid {
		profile.ProfilePictureURL = profilePictureURL.String
	}

	return profile, nil
}

func (r *userRepository) UpdateProfile(ctx context.Context, userID string, req *domain.UpdateProfileRequest) error {
	query := `
		UPDATE users
		SET 
			full_name = COALESCE(NULLIF($2, ''), full_name),
			phone = COALESCE(NULLIF($3, ''), phone),
			profile_picture_url = COALESCE(NULLIF($4, ''), profile_picture_url),
			updated_at = CURRENT_TIMESTAMP
		WHERE id = $1
	`

	result, err := r.db.ExecContext(ctx, query,
		userID,
		req.FullName,
		req.Phone,
		req.ProfilePictureURL,
	)

	if err != nil {
		return fmt.Errorf("failed to update profile: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("user not found")
	}

	return nil
}
