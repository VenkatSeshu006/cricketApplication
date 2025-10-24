package domain

import "context"

// GroundRepository defines ground data access interface
type GroundRepository interface {
	ListGrounds(ctx context.Context, page, limit int) ([]Ground, int, error)
	GetGroundByID(ctx context.Context, groundID string) (*Ground, error)
	CreateBooking(ctx context.Context, booking *Booking) error
	GetBookingsByUser(ctx context.Context, userID string) ([]Booking, error)
	GetBookingByID(ctx context.Context, bookingID string) (*Booking, error)
}
