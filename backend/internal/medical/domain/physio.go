package domain

import "time"

// Physiotherapist represents a registered physiotherapist
type Physiotherapist struct {
	ID              string    `json:"id"`
	UserID          string    `json:"user_id"`
	FullName        string    `json:"full_name"` // From users table
	Phone           string    `json:"phone"`     // From users table
	Specialization  string    `json:"specialization"`
	ExperienceYears int       `json:"experience_years"`
	Qualifications  []string  `json:"qualifications"`
	ClinicName      string    `json:"clinic_name,omitempty"`
	ClinicAddress   string    `json:"clinic_address"`
	ConsultationFee float64   `json:"consultation_fee"`
	AvailableDays   []string  `json:"available_days"`
	AvailableHours  string    `json:"available_hours"`
	Rating          float64   `json:"rating"`
	TotalReviews    int       `json:"total_reviews"`
	IsVerified      bool      `json:"is_verified"`
	Bio             string    `json:"bio,omitempty"`
	ProfileImageURL string    `json:"profile_image_url,omitempty"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

// Appointment represents a patient appointment with a physiotherapist
type Appointment struct {
	ID                string    `json:"id"`
	PhysiotherapistID string    `json:"physiotherapist_id"`
	PatientID         string    `json:"patient_id"`
	AppointmentDate   string    `json:"appointment_date"` // YYYY-MM-DD
	AppointmentTime   string    `json:"appointment_time"` // HH:MM
	DurationMinutes   int       `json:"duration_minutes"`
	Status            string    `json:"status"` // scheduled, completed, cancelled, rescheduled
	Complaint         string    `json:"complaint,omitempty"`
	Notes             string    `json:"notes,omitempty"`
	Fee               float64   `json:"fee"`
	PaymentStatus     string    `json:"payment_status"` // pending, paid, refunded
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
}

// CreateAppointmentRequest represents appointment booking request
type CreateAppointmentRequest struct {
	PhysiotherapistID string `json:"physiotherapist_id"`
	AppointmentDate   string `json:"appointment_date"` // YYYY-MM-DD
	AppointmentTime   string `json:"appointment_time"` // HH:MM
	Complaint         string `json:"complaint"`
}

// PhysioListResponse represents paginated physiotherapist list
type PhysioListResponse struct {
	Physiotherapists []Physiotherapist `json:"physiotherapists"`
	Pagination       Pagination        `json:"pagination"`
}

// Pagination represents pagination info
type Pagination struct {
	Page       int `json:"page"`
	Limit      int `json:"limit"`
	Total      int `json:"total"`
	TotalPages int `json:"total_pages"`
}
