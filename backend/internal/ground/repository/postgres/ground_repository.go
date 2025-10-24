package postgres

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/cricketapp/backend/internal/ground/domain"
	"github.com/lib/pq"
)

type groundRepository struct {
	db *sql.DB
}

func NewGroundRepository(db *sql.DB) domain.GroundRepository {
	return &groundRepository{db: db}
}

func (r *groundRepository) ListGrounds(ctx context.Context, page, limit int) ([]domain.Ground, int, error) {
	offset := (page - 1) * limit

	// Get total count
	var total int
	err := r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM grounds WHERE is_active = true").Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count grounds: %w", err)
	}

	// Get grounds
	query := `
		SELECT id, owner_id, name, description, address, latitude, longitude,
		       facilities, hourly_price, half_day_price, full_day_price, images,
		       rating, total_reviews, is_active, created_at, updated_at
		FROM grounds
		WHERE is_active = true
		ORDER BY rating DESC, created_at DESC
		LIMIT $1 OFFSET $2
	`

	rows, err := r.db.QueryContext(ctx, query, limit, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query grounds: %w", err)
	}
	defer rows.Close()

	var grounds []domain.Ground
	for rows.Next() {
		var g domain.Ground
		var description, latitude, longitude sql.NullString
		var facilities, images pq.StringArray

		err := rows.Scan(
			&g.ID, &g.OwnerID, &g.Name, &description, &g.Address,
			&latitude, &longitude, &facilities,
			&g.HourlyPrice, &g.HalfDayPrice, &g.FullDayPrice, &images,
			&g.Rating, &g.TotalReviews, &g.IsActive, &g.CreatedAt, &g.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan ground: %w", err)
		}

		if description.Valid {
			g.Description = description.String
		}
		if latitude.Valid && longitude.Valid {
			fmt.Sscanf(latitude.String, "%f", &g.Latitude)
			fmt.Sscanf(longitude.String, "%f", &g.Longitude)
		}
		g.Facilities = facilities
		g.Images = images

		grounds = append(grounds, g)
	}

	return grounds, total, nil
}

func (r *groundRepository) GetGroundByID(ctx context.Context, groundID string) (*domain.Ground, error) {
	query := `
		SELECT id, owner_id, name, description, address, latitude, longitude,
		       facilities, hourly_price, half_day_price, full_day_price, images,
		       rating, total_reviews, is_active, created_at, updated_at
		FROM grounds
		WHERE id = $1
	`

	var g domain.Ground
	var description, latitude, longitude sql.NullString
	var facilities, images pq.StringArray

	err := r.db.QueryRowContext(ctx, query, groundID).Scan(
		&g.ID, &g.OwnerID, &g.Name, &description, &g.Address,
		&latitude, &longitude, &facilities,
		&g.HourlyPrice, &g.HalfDayPrice, &g.FullDayPrice, &images,
		&g.Rating, &g.TotalReviews, &g.IsActive, &g.CreatedAt, &g.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("ground not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get ground: %w", err)
	}

	if description.Valid {
		g.Description = description.String
	}
	if latitude.Valid && longitude.Valid {
		fmt.Sscanf(latitude.String, "%f", &g.Latitude)
		fmt.Sscanf(longitude.String, "%f", &g.Longitude)
	}
	g.Facilities = facilities
	g.Images = images

	return &g, nil
}

func (r *groundRepository) CreateBooking(ctx context.Context, booking *domain.Booking) error {
	query := `
		INSERT INTO bookings (ground_id, user_id, booking_date, start_time, end_time,
		                     duration_type, total_price, status, payment_status, notes)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
		RETURNING id, created_at, updated_at
	`

	err := r.db.QueryRowContext(ctx, query,
		booking.GroundID, booking.UserID, booking.BookingDate,
		booking.StartTime, booking.EndTime, booking.DurationType,
		booking.TotalPrice, booking.Status, booking.PaymentStatus, booking.Notes,
	).Scan(&booking.ID, &booking.CreatedAt, &booking.UpdatedAt)

	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok && pqErr.Code == "23505" {
			return fmt.Errorf("this time slot is already booked")
		}
		return fmt.Errorf("failed to create booking: %w", err)
	}

	return nil
}

func (r *groundRepository) GetBookingsByUser(ctx context.Context, userID string) ([]domain.Booking, error) {
	query := `
		SELECT id, ground_id, user_id, booking_date, start_time, end_time,
		       duration_type, total_price, status, payment_status, notes,
		       created_at, updated_at
		FROM bookings
		WHERE user_id = $1
		ORDER BY booking_date DESC, start_time DESC
	`

	rows, err := r.db.QueryContext(ctx, query, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to query bookings: %w", err)
	}
	defer rows.Close()

	var bookings []domain.Booking
	for rows.Next() {
		var b domain.Booking
		var notes sql.NullString

		err := rows.Scan(
			&b.ID, &b.GroundID, &b.UserID, &b.BookingDate,
			&b.StartTime, &b.EndTime, &b.DurationType,
			&b.TotalPrice, &b.Status, &b.PaymentStatus, &notes,
			&b.CreatedAt, &b.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan booking: %w", err)
		}

		if notes.Valid {
			b.Notes = notes.String
		}
		bookings = append(bookings, b)
	}

	return bookings, nil
}

func (r *groundRepository) GetBookingByID(ctx context.Context, bookingID string) (*domain.Booking, error) {
	query := `
		SELECT id, ground_id, user_id, booking_date, start_time, end_time,
		       duration_type, total_price, status, payment_status, notes,
		       created_at, updated_at
		FROM bookings
		WHERE id = $1
	`

	var b domain.Booking
	var notes sql.NullString

	err := r.db.QueryRowContext(ctx, query, bookingID).Scan(
		&b.ID, &b.GroundID, &b.UserID, &b.BookingDate,
		&b.StartTime, &b.EndTime, &b.DurationType,
		&b.TotalPrice, &b.Status, &b.PaymentStatus, &notes,
		&b.CreatedAt, &b.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("booking not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get booking: %w", err)
	}

	if notes.Valid {
		b.Notes = notes.String
	}

	return &b, nil
}
