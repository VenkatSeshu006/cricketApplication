package postgres

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/cricketapp/backend/internal/medical/domain"
	"github.com/lib/pq"
)

type medicalRepository struct {
	db *sql.DB
}

// NewMedicalRepository creates a new medical repository
func NewMedicalRepository(db *sql.DB) domain.MedicalRepository {
	return &medicalRepository{db: db}
}

func (r *medicalRepository) ListPhysiotherapists(ctx context.Context, page, limit int) ([]domain.Physiotherapist, int, error) {
	offset := (page - 1) * limit

	// Get total count
	var total int
	countQuery := `SELECT COUNT(*) FROM physiotherapists WHERE is_verified = true`
	err := r.db.QueryRowContext(ctx, countQuery).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count physiotherapists: %w", err)
	}

	// Get paginated list with user details
	query := `
		SELECT 
			p.id, p.user_id, u.full_name, u.phone, p.specialization,
			p.experience_years, p.qualifications, p.clinic_name, p.clinic_address,
			p.consultation_fee, p.available_days, p.available_hours, p.rating,
			p.total_reviews, p.is_verified, p.bio, u.profile_picture_url,
			p.created_at, p.updated_at
		FROM physiotherapists p
		JOIN users u ON p.user_id = u.id
		WHERE p.is_verified = true
		ORDER BY p.rating DESC, p.total_reviews DESC
		LIMIT $1 OFFSET $2
	`

	rows, err := r.db.QueryContext(ctx, query, limit, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to list physiotherapists: %w", err)
	}
	defer rows.Close()

	var physios []domain.Physiotherapist
	for rows.Next() {
		var p domain.Physiotherapist
		var clinicName, bio sql.NullString
		var profileImageURL sql.NullString

		err := rows.Scan(
			&p.ID, &p.UserID, &p.FullName, &p.Phone, &p.Specialization,
			&p.ExperienceYears, pq.Array(&p.Qualifications), &clinicName, &p.ClinicAddress,
			&p.ConsultationFee, pq.Array(&p.AvailableDays), &p.AvailableHours, &p.Rating,
			&p.TotalReviews, &p.IsVerified, &bio, &profileImageURL,
			&p.CreatedAt, &p.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan physiotherapist: %w", err)
		}

		if clinicName.Valid {
			p.ClinicName = clinicName.String
		}
		if bio.Valid {
			p.Bio = bio.String
		}
		if profileImageURL.Valid {
			p.ProfileImageURL = profileImageURL.String
		}

		physios = append(physios, p)
	}

	if err = rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("rows error: %w", err)
	}

	return physios, total, nil
}

func (r *medicalRepository) GetPhysiotherapistByID(ctx context.Context, physioID string) (*domain.Physiotherapist, error) {
	query := `
		SELECT 
			p.id, p.user_id, u.full_name, u.phone, p.specialization,
			p.experience_years, p.qualifications, p.clinic_name, p.clinic_address,
			p.consultation_fee, p.available_days, p.available_hours, p.rating,
			p.total_reviews, p.is_verified, p.bio, u.profile_picture_url,
			p.created_at, p.updated_at
		FROM physiotherapists p
		JOIN users u ON p.user_id = u.id
		WHERE p.id = $1
	`

	var p domain.Physiotherapist
	var clinicName, bio sql.NullString
	var profileImageURL sql.NullString

	err := r.db.QueryRowContext(ctx, query, physioID).Scan(
		&p.ID, &p.UserID, &p.FullName, &p.Phone, &p.Specialization,
		&p.ExperienceYears, pq.Array(&p.Qualifications), &clinicName, &p.ClinicAddress,
		&p.ConsultationFee, pq.Array(&p.AvailableDays), &p.AvailableHours, &p.Rating,
		&p.TotalReviews, &p.IsVerified, &bio, &profileImageURL,
		&p.CreatedAt, &p.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("physiotherapist not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get physiotherapist: %w", err)
	}

	if clinicName.Valid {
		p.ClinicName = clinicName.String
	}
	if bio.Valid {
		p.Bio = bio.String
	}
	if profileImageURL.Valid {
		p.ProfileImageURL = profileImageURL.String
	}

	return &p, nil
}

func (r *medicalRepository) CreateAppointment(ctx context.Context, appointment *domain.Appointment) error {
	query := `
		INSERT INTO appointments (
			id, physiotherapist_id, patient_id, appointment_date, appointment_time,
			duration_minutes, status, complaint, notes, fee, payment_status
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
		RETURNING created_at, updated_at
	`

	var complaint, notes sql.NullString
	if appointment.Complaint != "" {
		complaint.String = appointment.Complaint
		complaint.Valid = true
	}
	if appointment.Notes != "" {
		notes.String = appointment.Notes
		notes.Valid = true
	}

	err := r.db.QueryRowContext(
		ctx, query,
		appointment.ID, appointment.PhysiotherapistID, appointment.PatientID,
		appointment.AppointmentDate, appointment.AppointmentTime,
		appointment.DurationMinutes, appointment.Status, complaint, notes,
		appointment.Fee, appointment.PaymentStatus,
	).Scan(&appointment.CreatedAt, &appointment.UpdatedAt)

	if err != nil {
		// Check for unique constraint violation (double booking)
		if pqErr, ok := err.(*pq.Error); ok {
			if pqErr.Code == "23505" { // unique_violation
				return fmt.Errorf("appointment slot already booked")
			}
		}
		return fmt.Errorf("failed to create appointment: %w", err)
	}

	return nil
}

func (r *medicalRepository) GetAppointmentsByPatient(ctx context.Context, patientID string) ([]domain.Appointment, error) {
	query := `
		SELECT 
			id, physiotherapist_id, patient_id, appointment_date, appointment_time,
			duration_minutes, status, complaint, notes, fee, payment_status,
			created_at, updated_at
		FROM appointments
		WHERE patient_id = $1
		ORDER BY appointment_date DESC, appointment_time DESC
	`

	rows, err := r.db.QueryContext(ctx, query, patientID)
	if err != nil {
		return nil, fmt.Errorf("failed to get appointments: %w", err)
	}
	defer rows.Close()

	var appointments []domain.Appointment
	for rows.Next() {
		var a domain.Appointment
		var complaint, notes sql.NullString

		err := rows.Scan(
			&a.ID, &a.PhysiotherapistID, &a.PatientID, &a.AppointmentDate, &a.AppointmentTime,
			&a.DurationMinutes, &a.Status, &complaint, &notes, &a.Fee, &a.PaymentStatus,
			&a.CreatedAt, &a.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan appointment: %w", err)
		}

		if complaint.Valid {
			a.Complaint = complaint.String
		}
		if notes.Valid {
			a.Notes = notes.String
		}

		appointments = append(appointments, a)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("rows error: %w", err)
	}

	return appointments, nil
}

func (r *medicalRepository) GetAppointmentByID(ctx context.Context, appointmentID string) (*domain.Appointment, error) {
	query := `
		SELECT 
			id, physiotherapist_id, patient_id, appointment_date, appointment_time,
			duration_minutes, status, complaint, notes, fee, payment_status,
			created_at, updated_at
		FROM appointments
		WHERE id = $1
	`

	var a domain.Appointment
	var complaint, notes sql.NullString

	err := r.db.QueryRowContext(ctx, query, appointmentID).Scan(
		&a.ID, &a.PhysiotherapistID, &a.PatientID, &a.AppointmentDate, &a.AppointmentTime,
		&a.DurationMinutes, &a.Status, &complaint, &notes, &a.Fee, &a.PaymentStatus,
		&a.CreatedAt, &a.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("appointment not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get appointment: %w", err)
	}

	if complaint.Valid {
		a.Complaint = complaint.String
	}
	if notes.Valid {
		a.Notes = notes.String
	}

	return &a, nil
}
