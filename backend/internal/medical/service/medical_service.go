package service

import (
	"context"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/cricketapp/backend/internal/medical/domain"
	"github.com/google/uuid"
)

type medicalService struct {
	repo domain.MedicalRepository
}

// NewMedicalService creates a new medical service
func NewMedicalService(repo domain.MedicalRepository) domain.MedicalService {
	return &medicalService{repo: repo}
}

func (s *medicalService) ListPhysiotherapists(ctx context.Context, page, limit int) (*domain.PhysioListResponse, error) {
	// Validate pagination
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 50 {
		limit = 10
	}

	physios, total, err := s.repo.ListPhysiotherapists(ctx, page, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to list physiotherapists: %w", err)
	}

	totalPages := int(math.Ceil(float64(total) / float64(limit)))

	return &domain.PhysioListResponse{
		Physiotherapists: physios,
		Pagination: domain.Pagination{
			Page:       page,
			Limit:      limit,
			Total:      total,
			TotalPages: totalPages,
		},
	}, nil
}

func (s *medicalService) GetPhysiotherapistDetails(ctx context.Context, physioID string) (*domain.Physiotherapist, error) {
	if physioID == "" {
		return nil, fmt.Errorf("physiotherapist ID is required")
	}

	physio, err := s.repo.GetPhysiotherapistByID(ctx, physioID)
	if err != nil {
		return nil, fmt.Errorf("failed to get physiotherapist: %w", err)
	}

	return physio, nil
}

func (s *medicalService) CreateAppointment(ctx context.Context, patientID string, req *domain.CreateAppointmentRequest) (*domain.Appointment, error) {
	// Validate request
	if err := s.validateAppointmentRequest(req); err != nil {
		return nil, err
	}

	// Check if physiotherapist exists
	physio, err := s.repo.GetPhysiotherapistByID(ctx, req.PhysiotherapistID)
	if err != nil {
		return nil, fmt.Errorf("physiotherapist not found")
	}

	// Parse appointment date
	appointmentDate, err := time.Parse("2006-01-02", req.AppointmentDate)
	if err != nil {
		return nil, fmt.Errorf("invalid appointment date format, use YYYY-MM-DD")
	}

	// Check if date is in the future
	if appointmentDate.Before(time.Now().Truncate(24 * time.Hour)) {
		return nil, fmt.Errorf("appointment date must be in the future")
	}

	// Validate time format
	if _, err := time.Parse("15:04", req.AppointmentTime); err != nil {
		return nil, fmt.Errorf("invalid appointment time format, use HH:MM")
	}

	// Check if day is available
	dayOfWeek := appointmentDate.Weekday().String()
	dayAvailable := false
	for _, availableDay := range physio.AvailableDays {
		if strings.EqualFold(availableDay, dayOfWeek) {
			dayAvailable = true
			break
		}
	}
	if !dayAvailable {
		return nil, fmt.Errorf("physiotherapist is not available on %s", dayOfWeek)
	}

	// Create appointment
	appointment := &domain.Appointment{
		ID:                uuid.New().String(),
		PhysiotherapistID: req.PhysiotherapistID,
		PatientID:         patientID,
		AppointmentDate:   req.AppointmentDate,
		AppointmentTime:   req.AppointmentTime,
		DurationMinutes:   60, // Default 1 hour
		Status:            "scheduled",
		Complaint:         req.Complaint,
		Fee:               physio.ConsultationFee,
		PaymentStatus:     "pending",
	}

	if err := s.repo.CreateAppointment(ctx, appointment); err != nil {
		return nil, fmt.Errorf("failed to create appointment: %w", err)
	}

	return appointment, nil
}

func (s *medicalService) GetPatientAppointments(ctx context.Context, patientID string) ([]domain.Appointment, error) {
	if patientID == "" {
		return nil, fmt.Errorf("patient ID is required")
	}

	appointments, err := s.repo.GetAppointmentsByPatient(ctx, patientID)
	if err != nil {
		return nil, fmt.Errorf("failed to get appointments: %w", err)
	}

	return appointments, nil
}

func (s *medicalService) validateAppointmentRequest(req *domain.CreateAppointmentRequest) error {
	if req.PhysiotherapistID == "" {
		return fmt.Errorf("physiotherapist ID is required")
	}
	if req.AppointmentDate == "" {
		return fmt.Errorf("appointment date is required")
	}
	if req.AppointmentTime == "" {
		return fmt.Errorf("appointment time is required")
	}
	if strings.TrimSpace(req.Complaint) == "" {
		return fmt.Errorf("complaint/reason is required")
	}
	if len(req.Complaint) > 500 {
		return fmt.Errorf("complaint must not exceed 500 characters")
	}

	return nil
}
