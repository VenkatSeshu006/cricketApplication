package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/cricketapp/backend/internal/auth/domain"
)

type userRepository struct {
	db *sql.DB
}

// NewUserRepository creates a new PostgreSQL user repository
func NewUserRepository(db *sql.DB) domain.UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) Create(ctx context.Context, user *domain.User) error {
	query := `
		INSERT INTO users (email, password_hash, full_name, phone, role, is_verified, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		RETURNING id
	`

	now := time.Now()
	user.CreatedAt = now
	user.UpdatedAt = now

	err := r.db.QueryRowContext(
		ctx,
		query,
		user.Email,
		user.PasswordHash,
		user.FullName,
		user.Phone,
		user.Role,
		user.IsVerified,
		user.CreatedAt,
		user.UpdatedAt,
	).Scan(&user.ID)

	if err != nil {
		return fmt.Errorf("failed to create user: %w", err)
	}

	return nil
}

func (r *userRepository) GetByEmail(ctx context.Context, email string) (*domain.User, error) {
	query := `
		SELECT id, email, password_hash, full_name, phone, role, created_at, updated_at, is_verified, profile_picture_url
		FROM users
		WHERE email = $1
	`

	user := &domain.User{}
	var phone, profilePicture sql.NullString

	err := r.db.QueryRowContext(ctx, query, email).Scan(
		&user.ID,
		&user.Email,
		&user.PasswordHash,
		&user.FullName,
		&phone,
		&user.Role,
		&user.CreatedAt,
		&user.UpdatedAt,
		&user.IsVerified,
		&profilePicture,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("user not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %w", err)
	}

	if phone.Valid {
		user.Phone = phone.String
	}
	if profilePicture.Valid {
		user.ProfilePictureURL = profilePicture.String
	}

	return user, nil
}

func (r *userRepository) GetByID(ctx context.Context, id string) (*domain.User, error) {
	query := `
		SELECT id, email, password_hash, full_name, phone, role, created_at, updated_at, is_verified, profile_picture_url
		FROM users
		WHERE id = $1
	`

	user := &domain.User{}
	var phone, profilePicture sql.NullString

	err := r.db.QueryRowContext(ctx, query, id).Scan(
		&user.ID,
		&user.Email,
		&user.PasswordHash,
		&user.FullName,
		&phone,
		&user.Role,
		&user.CreatedAt,
		&user.UpdatedAt,
		&user.IsVerified,
		&profilePicture,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("user not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %w", err)
	}

	if phone.Valid {
		user.Phone = phone.String
	}
	if profilePicture.Valid {
		user.ProfilePictureURL = profilePicture.String
	}

	return user, nil
}

func (r *userRepository) Update(ctx context.Context, user *domain.User) error {
	query := `
		UPDATE users
		SET full_name = $1, phone = $2, profile_picture_url = $3, updated_at = $4
		WHERE id = $5
	`

	user.UpdatedAt = time.Now()

	_, err := r.db.ExecContext(
		ctx,
		query,
		user.FullName,
		user.Phone,
		user.ProfilePictureURL,
		user.UpdatedAt,
		user.ID,
	)

	if err != nil {
		return fmt.Errorf("failed to update user: %w", err)
	}

	return nil
}
