package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/cricketapp/backend/internal/hiring/domain"
	"github.com/lib/pq"
)

type hiringRepository struct {
	db *sql.DB
}

// NewHiringRepository creates a new hiring repository
func NewHiringRepository(db *sql.DB) domain.HiringRepository {
	return &hiringRepository{db: db}
}

func (r *hiringRepository) CreateJobPosting(ctx context.Context, job *domain.JobPosting) error {
	query := `
		INSERT INTO job_postings (
			id, employer_id, title, description, job_type, experience_required,
			location, salary_range, employment_type, requirements, responsibilities,
			benefits, application_deadline, status
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
		RETURNING created_at, updated_at
	`

	var deadline sql.NullString
	if job.ApplicationDeadline != "" {
		deadline.String = job.ApplicationDeadline
		deadline.Valid = true
	}

	var expRequired, salaryRange sql.NullString
	if job.ExperienceRequired != "" {
		expRequired.String = job.ExperienceRequired
		expRequired.Valid = true
	}
	if job.SalaryRange != "" {
		salaryRange.String = job.SalaryRange
		salaryRange.Valid = true
	}

	err := r.db.QueryRowContext(
		ctx, query,
		job.ID, job.EmployerID, job.Title, job.Description, job.JobType,
		expRequired, job.Location, salaryRange, job.EmploymentType,
		pq.Array(job.Requirements), pq.Array(job.Responsibilities),
		pq.Array(job.Benefits), deadline, job.Status,
	).Scan(&job.CreatedAt, &job.UpdatedAt)

	if err != nil {
		return fmt.Errorf("failed to create job posting: %w", err)
	}

	return nil
}

func (r *hiringRepository) GetJobPostingByID(ctx context.Context, jobID string) (*domain.JobPosting, error) {
	query := `
		SELECT 
			j.id, j.employer_id, u.full_name, j.title, j.description, j.job_type,
			j.experience_required, j.location, j.salary_range, j.employment_type,
			j.requirements, j.responsibilities, j.benefits, j.application_deadline,
			j.status, j.total_applications, j.created_at, j.updated_at
		FROM job_postings j
		JOIN users u ON j.employer_id = u.id
		WHERE j.id = $1
	`

	var job domain.JobPosting
	var expRequired, salaryRange, deadline sql.NullString

	err := r.db.QueryRowContext(ctx, query, jobID).Scan(
		&job.ID, &job.EmployerID, &job.EmployerName, &job.Title, &job.Description,
		&job.JobType, &expRequired, &job.Location, &salaryRange, &job.EmploymentType,
		pq.Array(&job.Requirements), pq.Array(&job.Responsibilities),
		pq.Array(&job.Benefits), &deadline, &job.Status, &job.TotalApplications,
		&job.CreatedAt, &job.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("job posting not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get job posting: %w", err)
	}

	if expRequired.Valid {
		job.ExperienceRequired = expRequired.String
	}
	if salaryRange.Valid {
		job.SalaryRange = salaryRange.String
	}
	if deadline.Valid {
		job.ApplicationDeadline = deadline.String
	}

	return &job, nil
}

func (r *hiringRepository) ListJobPostings(ctx context.Context, page, limit int, jobType, status string) ([]domain.JobPosting, int, error) {
	offset := (page - 1) * limit

	// Build count query
	countQuery := `SELECT COUNT(*) FROM job_postings WHERE 1=1`
	args := []interface{}{}
	argCount := 1

	if jobType != "" {
		countQuery += fmt.Sprintf(" AND job_type = $%d", argCount)
		args = append(args, jobType)
		argCount++
	}
	if status != "" {
		countQuery += fmt.Sprintf(" AND status = $%d", argCount)
		args = append(args, status)
		argCount++
	}

	var total int
	err := r.db.QueryRowContext(ctx, countQuery, args...).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count jobs: %w", err)
	}

	// Build list query
	listQuery := `
		SELECT 
			j.id, j.employer_id, u.full_name, j.title, j.description, j.job_type,
			j.experience_required, j.location, j.salary_range, j.employment_type,
			j.requirements, j.responsibilities, j.benefits, j.application_deadline,
			j.status, j.total_applications, j.created_at, j.updated_at
		FROM job_postings j
		JOIN users u ON j.employer_id = u.id
		WHERE 1=1
	`

	args = []interface{}{}
	argCount = 1

	if jobType != "" {
		listQuery += fmt.Sprintf(" AND j.job_type = $%d", argCount)
		args = append(args, jobType)
		argCount++
	}
	if status != "" {
		listQuery += fmt.Sprintf(" AND j.status = $%d", argCount)
		args = append(args, status)
		argCount++
	}

	listQuery += fmt.Sprintf(" ORDER BY j.created_at DESC LIMIT $%d OFFSET $%d", argCount, argCount+1)
	args = append(args, limit, offset)

	rows, err := r.db.QueryContext(ctx, listQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to list jobs: %w", err)
	}
	defer rows.Close()

	var jobs []domain.JobPosting
	for rows.Next() {
		var job domain.JobPosting
		var expRequired, salaryRange, deadline sql.NullString

		err := rows.Scan(
			&job.ID, &job.EmployerID, &job.EmployerName, &job.Title, &job.Description,
			&job.JobType, &expRequired, &job.Location, &salaryRange, &job.EmploymentType,
			pq.Array(&job.Requirements), pq.Array(&job.Responsibilities),
			pq.Array(&job.Benefits), &deadline, &job.Status, &job.TotalApplications,
			&job.CreatedAt, &job.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan job: %w", err)
		}

		if expRequired.Valid {
			job.ExperienceRequired = expRequired.String
		}
		if salaryRange.Valid {
			job.SalaryRange = salaryRange.String
		}
		if deadline.Valid {
			job.ApplicationDeadline = deadline.String
		}

		jobs = append(jobs, job)
	}

	if err = rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("rows error: %w", err)
	}

	return jobs, total, nil
}

func (r *hiringRepository) GetEmployerJobs(ctx context.Context, employerID string) ([]domain.JobPosting, error) {
	query := `
		SELECT 
			j.id, j.employer_id, u.full_name, j.title, j.description, j.job_type,
			j.experience_required, j.location, j.salary_range, j.employment_type,
			j.requirements, j.responsibilities, j.benefits, j.application_deadline,
			j.status, j.total_applications, j.created_at, j.updated_at
		FROM job_postings j
		JOIN users u ON j.employer_id = u.id
		WHERE j.employer_id = $1
		ORDER BY j.created_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, employerID)
	if err != nil {
		return nil, fmt.Errorf("failed to get employer jobs: %w", err)
	}
	defer rows.Close()

	var jobs []domain.JobPosting
	for rows.Next() {
		var job domain.JobPosting
		var expRequired, salaryRange, deadline sql.NullString

		err := rows.Scan(
			&job.ID, &job.EmployerID, &job.EmployerName, &job.Title, &job.Description,
			&job.JobType, &expRequired, &job.Location, &salaryRange, &job.EmploymentType,
			pq.Array(&job.Requirements), pq.Array(&job.Responsibilities),
			pq.Array(&job.Benefits), &deadline, &job.Status, &job.TotalApplications,
			&job.CreatedAt, &job.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan job: %w", err)
		}

		if expRequired.Valid {
			job.ExperienceRequired = expRequired.String
		}
		if salaryRange.Valid {
			job.SalaryRange = salaryRange.String
		}
		if deadline.Valid {
			job.ApplicationDeadline = deadline.String
		}

		jobs = append(jobs, job)
	}

	return jobs, nil
}

func (r *hiringRepository) UpdateJobStatus(ctx context.Context, jobID, status string) error {
	query := `UPDATE job_postings SET status = $1, updated_at = $2 WHERE id = $3`
	_, err := r.db.ExecContext(ctx, query, status, time.Now(), jobID)
	if err != nil {
		return fmt.Errorf("failed to update job status: %w", err)
	}
	return nil
}

func (r *hiringRepository) CreateApplication(ctx context.Context, app *domain.JobApplication) error {
	query := `
		INSERT INTO job_applications (
			id, job_id, applicant_id, cover_letter, resume_url, experience_years,
			relevant_experience, availability, expected_salary, status
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
		RETURNING applied_at
	`

	var resumeURL, relevantExp, availability, expectedSalary sql.NullString
	if app.ResumeURL != "" {
		resumeURL.String = app.ResumeURL
		resumeURL.Valid = true
	}
	if app.RelevantExperience != "" {
		relevantExp.String = app.RelevantExperience
		relevantExp.Valid = true
	}
	if app.Availability != "" {
		availability.String = app.Availability
		availability.Valid = true
	}
	if app.ExpectedSalary != "" {
		expectedSalary.String = app.ExpectedSalary
		expectedSalary.Valid = true
	}

	err := r.db.QueryRowContext(
		ctx, query,
		app.ID, app.JobID, app.ApplicantID, app.CoverLetter, resumeURL,
		app.ExperienceYears, relevantExp, availability, expectedSalary, app.Status,
	).Scan(&app.AppliedAt)

	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			if pqErr.Code == "23505" { // unique_violation
				return fmt.Errorf("already applied to this job")
			}
		}
		return fmt.Errorf("failed to create application: %w", err)
	}

	return nil
}

func (r *hiringRepository) GetApplicationByID(ctx context.Context, appID string) (*domain.JobApplication, error) {
	query := `
		SELECT 
			a.id, a.job_id, a.applicant_id, u.full_name, u.email, a.cover_letter,
			a.resume_url, a.experience_years, a.relevant_experience, a.availability,
			a.expected_salary, a.status, a.applied_at, a.reviewed_at, a.notes
		FROM job_applications a
		JOIN users u ON a.applicant_id = u.id
		WHERE a.id = $1
	`

	var app domain.JobApplication
	var resumeURL, relevantExp, availability, expectedSalary, notes sql.NullString
	var reviewedAt sql.NullTime

	err := r.db.QueryRowContext(ctx, query, appID).Scan(
		&app.ID, &app.JobID, &app.ApplicantID, &app.ApplicantName, &app.ApplicantEmail,
		&app.CoverLetter, &resumeURL, &app.ExperienceYears, &relevantExp, &availability,
		&expectedSalary, &app.Status, &app.AppliedAt, &reviewedAt, &notes,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("application not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get application: %w", err)
	}

	if resumeURL.Valid {
		app.ResumeURL = resumeURL.String
	}
	if relevantExp.Valid {
		app.RelevantExperience = relevantExp.String
	}
	if availability.Valid {
		app.Availability = availability.String
	}
	if expectedSalary.Valid {
		app.ExpectedSalary = expectedSalary.String
	}
	if notes.Valid {
		app.Notes = notes.String
	}
	if reviewedAt.Valid {
		app.ReviewedAt = reviewedAt.Time
	}

	return &app, nil
}

func (r *hiringRepository) GetJobApplications(ctx context.Context, jobID string) ([]domain.JobApplication, error) {
	query := `
		SELECT 
			a.id, a.job_id, a.applicant_id, u.full_name, u.email, a.cover_letter,
			a.resume_url, a.experience_years, a.relevant_experience, a.availability,
			a.expected_salary, a.status, a.applied_at, a.reviewed_at, a.notes
		FROM job_applications a
		JOIN users u ON a.applicant_id = u.id
		WHERE a.job_id = $1
		ORDER BY a.applied_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, jobID)
	if err != nil {
		return nil, fmt.Errorf("failed to get job applications: %w", err)
	}
	defer rows.Close()

	var applications []domain.JobApplication
	for rows.Next() {
		var app domain.JobApplication
		var resumeURL, relevantExp, availability, expectedSalary, notes sql.NullString
		var reviewedAt sql.NullTime

		err := rows.Scan(
			&app.ID, &app.JobID, &app.ApplicantID, &app.ApplicantName, &app.ApplicantEmail,
			&app.CoverLetter, &resumeURL, &app.ExperienceYears, &relevantExp, &availability,
			&expectedSalary, &app.Status, &app.AppliedAt, &reviewedAt, &notes,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan application: %w", err)
		}

		if resumeURL.Valid {
			app.ResumeURL = resumeURL.String
		}
		if relevantExp.Valid {
			app.RelevantExperience = relevantExp.String
		}
		if availability.Valid {
			app.Availability = availability.String
		}
		if expectedSalary.Valid {
			app.ExpectedSalary = expectedSalary.String
		}
		if notes.Valid {
			app.Notes = notes.String
		}
		if reviewedAt.Valid {
			app.ReviewedAt = reviewedAt.Time
		}

		applications = append(applications, app)
	}

	return applications, nil
}

func (r *hiringRepository) GetUserApplications(ctx context.Context, userID string) ([]domain.JobApplication, error) {
	query := `
		SELECT 
			a.id, a.job_id, a.applicant_id, u.full_name, u.email, a.cover_letter,
			a.resume_url, a.experience_years, a.relevant_experience, a.availability,
			a.expected_salary, a.status, a.applied_at, a.reviewed_at, a.notes
		FROM job_applications a
		JOIN users u ON a.applicant_id = u.id
		WHERE a.applicant_id = $1
		ORDER BY a.applied_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to get user applications: %w", err)
	}
	defer rows.Close()

	var applications []domain.JobApplication
	for rows.Next() {
		var app domain.JobApplication
		var resumeURL, relevantExp, availability, expectedSalary, notes sql.NullString
		var reviewedAt sql.NullTime

		err := rows.Scan(
			&app.ID, &app.JobID, &app.ApplicantID, &app.ApplicantName, &app.ApplicantEmail,
			&app.CoverLetter, &resumeURL, &app.ExperienceYears, &relevantExp, &availability,
			&expectedSalary, &app.Status, &app.AppliedAt, &reviewedAt, &notes,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan application: %w", err)
		}

		if resumeURL.Valid {
			app.ResumeURL = resumeURL.String
		}
		if relevantExp.Valid {
			app.RelevantExperience = relevantExp.String
		}
		if availability.Valid {
			app.Availability = availability.String
		}
		if expectedSalary.Valid {
			app.ExpectedSalary = expectedSalary.String
		}
		if notes.Valid {
			app.Notes = notes.String
		}
		if reviewedAt.Valid {
			app.ReviewedAt = reviewedAt.Time
		}

		applications = append(applications, app)
	}

	return applications, nil
}

func (r *hiringRepository) UpdateApplicationStatus(ctx context.Context, appID, status string) error {
	query := `UPDATE job_applications SET status = $1, reviewed_at = $2 WHERE id = $3`
	_, err := r.db.ExecContext(ctx, query, status, time.Now(), appID)
	if err != nil {
		return fmt.Errorf("failed to update application status: %w", err)
	}
	return nil
}

func (r *hiringRepository) IncrementApplicationCount(ctx context.Context, jobID string) error {
	query := `UPDATE job_postings SET total_applications = total_applications + 1 WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, jobID)
	if err != nil {
		return fmt.Errorf("failed to increment application count: %w", err)
	}
	return nil
}
