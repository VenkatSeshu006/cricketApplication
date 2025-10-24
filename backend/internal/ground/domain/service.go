package domain

import "context"

// GroundService defines ground business logic interface
type GroundService interface {
	ListGrounds(ctx context.Context, page, limit int) (*GroundListResponse, error)
	GetGroundDetails(ctx context.Context, groundID string) (*Ground, error)
	CreateBooking(ctx context.Context, userID string, req *CreateBookingRequest) (*Booking, error)
	GetUserBookings(ctx context.Context, userID string) ([]Booking, error)
}
