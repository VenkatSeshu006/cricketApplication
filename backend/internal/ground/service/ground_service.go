package service

import (
	"context"
	"fmt"
	"math"

	"github.com/cricketapp/backend/internal/ground/domain"
)

type groundService struct {
	groundRepo domain.GroundRepository
}

func NewGroundService(groundRepo domain.GroundRepository) domain.GroundService {
	return &groundService{
		groundRepo: groundRepo,
	}
}

func (s *groundService) ListGrounds(ctx context.Context, page, limit int) (*domain.GroundListResponse, error) {
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 10
	}

	grounds, total, err := s.groundRepo.ListGrounds(ctx, page, limit)
	if err != nil {
		return nil, err
	}

	totalPages := int(math.Ceil(float64(total) / float64(limit)))

	return &domain.GroundListResponse{
		Grounds: grounds,
		Pagination: domain.Pagination{
			Page:       page,
			Limit:      limit,
			Total:      total,
			TotalPages: totalPages,
		},
	}, nil
}

func (s *groundService) GetGroundDetails(ctx context.Context, groundID string) (*domain.Ground, error) {
	if groundID == "" {
		return nil, fmt.Errorf("ground ID is required")
	}

	ground, err := s.groundRepo.GetGroundByID(ctx, groundID)
	if err != nil {
		return nil, err
	}

	return ground, nil
}

func (s *groundService) CreateBooking(ctx context.Context, userID string, req *domain.CreateBookingRequest) (*domain.Booking, error) {
	// Validate request
	if err := s.validateBookingRequest(req); err != nil {
		return nil, err
	}

	// Get ground to calculate price
	ground, err := s.groundRepo.GetGroundByID(ctx, req.GroundID)
	if err != nil {
		return nil, fmt.Errorf("invalid ground ID: %w", err)
	}

	// Calculate price based on duration type
	var price float64
	switch req.DurationType {
	case "hourly":
		price = ground.HourlyPrice
	case "half_day":
		price = ground.HalfDayPrice
	case "full_day":
		price = ground.FullDayPrice
	default:
		return nil, fmt.Errorf("invalid duration type")
	}

	// Create booking
	booking := &domain.Booking{
		GroundID:      req.GroundID,
		UserID:        userID,
		BookingDate:   req.BookingDate,
		StartTime:     req.StartTime,
		EndTime:       req.EndTime,
		DurationType:  req.DurationType,
		TotalPrice:    price,
		Status:        "pending",
		PaymentStatus: "pending",
		Notes:         req.Notes,
	}

	if err := s.groundRepo.CreateBooking(ctx, booking); err != nil {
		return nil, err
	}

	return booking, nil
}

func (s *groundService) GetUserBookings(ctx context.Context, userID string) ([]domain.Booking, error) {
	if userID == "" {
		return nil, fmt.Errorf("user ID is required")
	}

	bookings, err := s.groundRepo.GetBookingsByUser(ctx, userID)
	if err != nil {
		return nil, err
	}

	return bookings, nil
}

func (s *groundService) validateBookingRequest(req *domain.CreateBookingRequest) error {
	if req.GroundID == "" {
		return fmt.Errorf("ground ID is required")
	}
	if req.BookingDate == "" {
		return fmt.Errorf("booking date is required")
	}
	if req.StartTime == "" {
		return fmt.Errorf("start time is required")
	}
	if req.EndTime == "" {
		return fmt.Errorf("end time is required")
	}
	if req.DurationType == "" {
		return fmt.Errorf("duration type is required")
	}

	// Validate duration type
	validDurations := map[string]bool{
		"hourly":   true,
		"half_day": true,
		"full_day": true,
	}
	if !validDurations[req.DurationType] {
		return fmt.Errorf("invalid duration type. Must be: hourly, half_day, or full_day")
	}

	return nil
}
