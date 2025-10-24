package domain

import "context"

// MedicalRepository defines medical data access interface
type MedicalRepository interface {
	ListPhysiotherapists(ctx context.Context, page, limit int) ([]Physiotherapist, int, error)
	GetPhysiotherapistByID(ctx context.Context, physioID string) (*Physiotherapist, error)
	CreateAppointment(ctx context.Context, appointment *Appointment) error
	GetAppointmentsByPatient(ctx context.Context, patientID string) ([]Appointment, error)
	GetAppointmentByID(ctx context.Context, appointmentID string) (*Appointment, error)
}
