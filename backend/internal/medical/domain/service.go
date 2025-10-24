package domain

import "context"

// MedicalService defines medical business logic interface
type MedicalService interface {
	ListPhysiotherapists(ctx context.Context, page, limit int) (*PhysioListResponse, error)
	GetPhysiotherapistDetails(ctx context.Context, physioID string) (*Physiotherapist, error)
	CreateAppointment(ctx context.Context, patientID string, req *CreateAppointmentRequest) (*Appointment, error)
	GetPatientAppointments(ctx context.Context, patientID string) ([]Appointment, error)
}
