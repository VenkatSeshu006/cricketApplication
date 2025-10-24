package domain

import "context"

// HiringRepository defines hiring data access interface
type HiringRepository interface {
	// Job Postings
	CreateJobPosting(ctx context.Context, job *JobPosting) error
	GetJobPostingByID(ctx context.Context, jobID string) (*JobPosting, error)
	ListJobPostings(ctx context.Context, page, limit int, jobType, status string) ([]JobPosting, int, error)
	GetEmployerJobs(ctx context.Context, employerID string) ([]JobPosting, error)
	UpdateJobStatus(ctx context.Context, jobID, status string) error

	// Job Applications
	CreateApplication(ctx context.Context, app *JobApplication) error
	GetApplicationByID(ctx context.Context, appID string) (*JobApplication, error)
	GetJobApplications(ctx context.Context, jobID string) ([]JobApplication, error)
	GetUserApplications(ctx context.Context, userID string) ([]JobApplication, error)
	UpdateApplicationStatus(ctx context.Context, appID, status string) error
	IncrementApplicationCount(ctx context.Context, jobID string) error
}
