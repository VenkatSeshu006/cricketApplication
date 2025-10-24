package service

import (
	"context"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/cricketapp/backend/internal/hiring/domain"
	"github.com/google/uuid"
)

type hiringService struct {
	repo domain.HiringRepository
}

// NewHiringService creates a new hiring service
func NewHiringService(repo domain.HiringRepository) domain.HiringService {
	return &hiringService{repo: repo}
}

func (s *hiringService) CreateJob(ctx context.Context, employerID string, req *domain.CreateJobRequest) (*domain.JobPosting, error) {
	// Validate request
	if err := s.validateJobRequest(req); err != nil {
		return nil, err
	}

	// Validate deadline if provided
	if req.ApplicationDeadline != "" {
		deadline, err := time.Parse("2006-01-02", req.ApplicationDeadline)
		if err != nil {
			return nil, fmt.Errorf("invalid deadline format, use YYYY-MM-DD")
		}
		if deadline.Before(time.Now().Truncate(24 * time.Hour)) {
			return nil, fmt.Errorf("deadline must be in the future")
		}
	}

	job := &domain.JobPosting{
		ID:                  uuid.New().String(),
		EmployerID:          employerID,
		Title:               req.Title,
		Description:         req.Description,
		JobType:             req.JobType,
		ExperienceRequired:  req.ExperienceRequired,
		Location:            req.Location,
		SalaryRange:         req.SalaryRange,
		EmploymentType:      req.EmploymentType,
		Requirements:        req.Requirements,
		Responsibilities:    req.Responsibilities,
		Benefits:            req.Benefits,
		ApplicationDeadline: req.ApplicationDeadline,
		Status:              "open",
		TotalApplications:   0,
	}

	if err := s.repo.CreateJobPosting(ctx, job); err != nil {
		return nil, fmt.Errorf("failed to create job: %w", err)
	}

	return job, nil
}

func (s *hiringService) GetJobDetails(ctx context.Context, jobID string) (*domain.JobPosting, error) {
	if jobID == "" {
		return nil, fmt.Errorf("job ID is required")
	}

	job, err := s.repo.GetJobPostingByID(ctx, jobID)
	if err != nil {
		return nil, fmt.Errorf("failed to get job: %w", err)
	}

	return job, nil
}

func (s *hiringService) ListJobs(ctx context.Context, page, limit int, jobType, status string) (*domain.JobListResponse, error) {
	// Validate pagination
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 50 {
		limit = 10
	}

	// Default to open jobs if no status specified
	if status == "" {
		status = "open"
	}

	jobs, total, err := s.repo.ListJobPostings(ctx, page, limit, jobType, status)
	if err != nil {
		return nil, fmt.Errorf("failed to list jobs: %w", err)
	}

	totalPages := int(math.Ceil(float64(total) / float64(limit)))

	return &domain.JobListResponse{
		Jobs: jobs,
		Pagination: domain.Pagination{
			Page:       page,
			Limit:      limit,
			Total:      total,
			TotalPages: totalPages,
		},
	}, nil
}

func (s *hiringService) GetMyJobs(ctx context.Context, employerID string) ([]domain.JobPosting, error) {
	if employerID == "" {
		return nil, fmt.Errorf("employer ID is required")
	}

	jobs, err := s.repo.GetEmployerJobs(ctx, employerID)
	if err != nil {
		return nil, fmt.Errorf("failed to get jobs: %w", err)
	}

	return jobs, nil
}

func (s *hiringService) CloseJob(ctx context.Context, employerID, jobID string) error {
	// Verify job belongs to employer
	job, err := s.repo.GetJobPostingByID(ctx, jobID)
	if err != nil {
		return fmt.Errorf("job not found")
	}

	if job.EmployerID != employerID {
		return fmt.Errorf("unauthorized: not your job posting")
	}

	if err := s.repo.UpdateJobStatus(ctx, jobID, "closed"); err != nil {
		return fmt.Errorf("failed to close job: %w", err)
	}

	return nil
}

func (s *hiringService) ApplyForJob(ctx context.Context, applicantID string, jobID string, req *domain.ApplyJobRequest) (*domain.JobApplication, error) {
	// Validate request
	if err := s.validateApplicationRequest(req); err != nil {
		return nil, err
	}

	// Check if job exists and is open
	job, err := s.repo.GetJobPostingByID(ctx, jobID)
	if err != nil {
		return nil, fmt.Errorf("job not found")
	}

	if job.Status != "open" {
		return nil, fmt.Errorf("job is no longer accepting applications")
	}

	// Check deadline
	if job.ApplicationDeadline != "" {
		deadline, _ := time.Parse("2006-01-02", job.ApplicationDeadline)
		if time.Now().After(deadline) {
			return nil, fmt.Errorf("application deadline has passed")
		}
	}

	// Check if user is the employer
	if job.EmployerID == applicantID {
		return nil, fmt.Errorf("cannot apply to your own job posting")
	}

	app := &domain.JobApplication{
		ID:                 uuid.New().String(),
		JobID:              jobID,
		ApplicantID:        applicantID,
		CoverLetter:        req.CoverLetter,
		ResumeURL:          req.ResumeURL,
		ExperienceYears:    req.ExperienceYears,
		RelevantExperience: req.RelevantExperience,
		Availability:       req.Availability,
		ExpectedSalary:     req.ExpectedSalary,
		Status:             "pending",
	}

	if err := s.repo.CreateApplication(ctx, app); err != nil {
		return nil, fmt.Errorf("failed to create application: %w", err)
	}

	// Increment application count
	if err := s.repo.IncrementApplicationCount(ctx, jobID); err != nil {
		// Log error but don't fail the application
		fmt.Printf("Warning: failed to increment application count: %v\n", err)
	}

	return app, nil
}

func (s *hiringService) GetJobApplications(ctx context.Context, employerID, jobID string) ([]domain.JobApplication, error) {
	// Verify job belongs to employer
	job, err := s.repo.GetJobPostingByID(ctx, jobID)
	if err != nil {
		return nil, fmt.Errorf("job not found")
	}

	if job.EmployerID != employerID {
		return nil, fmt.Errorf("unauthorized: not your job posting")
	}

	applications, err := s.repo.GetJobApplications(ctx, jobID)
	if err != nil {
		return nil, fmt.Errorf("failed to get applications: %w", err)
	}

	return applications, nil
}

func (s *hiringService) GetMyApplications(ctx context.Context, userID string) ([]domain.JobApplication, error) {
	if userID == "" {
		return nil, fmt.Errorf("user ID is required")
	}

	applications, err := s.repo.GetUserApplications(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to get applications: %w", err)
	}

	return applications, nil
}

func (s *hiringService) UpdateApplicationStatus(ctx context.Context, employerID, appID, status string) error {
	// Get application to verify ownership
	app, err := s.repo.GetApplicationByID(ctx, appID)
	if err != nil {
		return fmt.Errorf("application not found")
	}

	// Get job to verify employer
	job, err := s.repo.GetJobPostingByID(ctx, app.JobID)
	if err != nil {
		return fmt.Errorf("job not found")
	}

	if job.EmployerID != employerID {
		return fmt.Errorf("unauthorized: not your job posting")
	}

	// Validate status
	validStatuses := map[string]bool{
		"reviewing":   true,
		"shortlisted": true,
		"rejected":    true,
		"accepted":    true,
	}
	if !validStatuses[status] {
		return fmt.Errorf("invalid status")
	}

	if err := s.repo.UpdateApplicationStatus(ctx, appID, status); err != nil {
		return fmt.Errorf("failed to update status: %w", err)
	}

	return nil
}

func (s *hiringService) validateJobRequest(req *domain.CreateJobRequest) error {
	if strings.TrimSpace(req.Title) == "" {
		return fmt.Errorf("title is required")
	}
	if len(req.Title) < 5 || len(req.Title) > 255 {
		return fmt.Errorf("title must be 5-255 characters")
	}

	if strings.TrimSpace(req.Description) == "" {
		return fmt.Errorf("description is required")
	}
	if len(req.Description) < 20 {
		return fmt.Errorf("description must be at least 20 characters")
	}

	validJobTypes := map[string]bool{
		"coach": true, "groundsman": true, "umpire": true,
		"scorer": true, "physio": true, "trainer": true, "manager": true,
	}
	if !validJobTypes[req.JobType] {
		return fmt.Errorf("invalid job type")
	}

	if strings.TrimSpace(req.Location) == "" {
		return fmt.Errorf("location is required")
	}

	validEmploymentTypes := map[string]bool{
		"full-time": true, "part-time": true, "contract": true, "freelance": true,
	}
	if !validEmploymentTypes[req.EmploymentType] {
		return fmt.Errorf("invalid employment type")
	}

	return nil
}

func (s *hiringService) validateApplicationRequest(req *domain.ApplyJobRequest) error {
	if strings.TrimSpace(req.CoverLetter) == "" {
		return fmt.Errorf("cover letter is required")
	}
	if len(req.CoverLetter) < 50 {
		return fmt.Errorf("cover letter must be at least 50 characters")
	}
	if len(req.CoverLetter) > 2000 {
		return fmt.Errorf("cover letter must not exceed 2000 characters")
	}

	if req.ExperienceYears < 0 {
		return fmt.Errorf("experience years cannot be negative")
	}

	return nil
}
