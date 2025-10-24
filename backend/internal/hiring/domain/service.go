package domain

import "context"

// HiringService defines hiring business logic interface
type HiringService interface {
	// Job Postings
	CreateJob(ctx context.Context, employerID string, req *CreateJobRequest) (*JobPosting, error)
	GetJobDetails(ctx context.Context, jobID string) (*JobPosting, error)
	ListJobs(ctx context.Context, page, limit int, jobType, status string) (*JobListResponse, error)
	GetMyJobs(ctx context.Context, employerID string) ([]JobPosting, error)
	CloseJob(ctx context.Context, employerID, jobID string) error

	// Job Applications
	ApplyForJob(ctx context.Context, applicantID string, jobID string, req *ApplyJobRequest) (*JobApplication, error)
	GetJobApplications(ctx context.Context, employerID, jobID string) ([]JobApplication, error)
	GetMyApplications(ctx context.Context, userID string) ([]JobApplication, error)
	UpdateApplicationStatus(ctx context.Context, employerID, appID, status string) error
}
