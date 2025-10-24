package domain

import "time"

// Ground represents a cricket ground
type Ground struct {
	ID           string    `json:"id"`
	OwnerID      string    `json:"owner_id"`
	Name         string    `json:"name"`
	Description  string    `json:"description,omitempty"`
	Address      string    `json:"address"`
	Latitude     float64   `json:"latitude,omitempty"`
	Longitude    float64   `json:"longitude,omitempty"`
	Facilities   []string  `json:"facilities,omitempty"`
	HourlyPrice  float64   `json:"hourly_price"`
	HalfDayPrice float64   `json:"half_day_price"`
	FullDayPrice float64   `json:"full_day_price"`
	Images       []string  `json:"images,omitempty"`
	Rating       float64   `json:"rating"`
	TotalReviews int       `json:"total_reviews"`
	IsActive     bool      `json:"is_active"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

// Booking represents a ground booking
type Booking struct {
	ID            string    `json:"id"`
	GroundID      string    `json:"ground_id"`
	UserID        string    `json:"user_id"`
	BookingDate   string    `json:"booking_date"`  // YYYY-MM-DD format
	StartTime     string    `json:"start_time"`    // HH:MM format
	EndTime       string    `json:"end_time"`      // HH:MM format
	DurationType  string    `json:"duration_type"` // hourly, half_day, full_day
	TotalPrice    float64   `json:"total_price"`
	Status        string    `json:"status"`         // pending, confirmed, cancelled, completed
	PaymentStatus string    `json:"payment_status"` // pending, paid, refunded
	Notes         string    `json:"notes,omitempty"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// CreateBookingRequest represents booking creation request
type CreateBookingRequest struct {
	GroundID     string `json:"ground_id"`
	BookingDate  string `json:"booking_date"`  // YYYY-MM-DD
	StartTime    string `json:"start_time"`    // HH:MM
	EndTime      string `json:"end_time"`      // HH:MM
	DurationType string `json:"duration_type"` // hourly, half_day, full_day
	Notes        string `json:"notes,omitempty"`
}

// GroundListResponse represents paginated ground list
type GroundListResponse struct {
	Grounds    []Ground   `json:"grounds"`
	Pagination Pagination `json:"pagination"`
}

// Pagination represents pagination info
type Pagination struct {
	Page       int `json:"page"`
	Limit      int `json:"limit"`
	Total      int `json:"total"`
	TotalPages int `json:"total_pages"`
}
