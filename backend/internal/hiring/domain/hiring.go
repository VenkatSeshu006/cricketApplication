package domain

import "time"

// JobPosting represents a job vacancy
type JobPosting struct {
	ID                  string    `json:"id"`
	EmployerID          string    `json:"employer_id"`
	EmployerName        string    `json:"employer_name"` // From users table
	Title               string    `json:"title"`
	Description         string    `json:"description"`
	JobType             string    `json:"job_type"` // coach, groundsman, umpire, scorer, physio, trainer, manager
	ExperienceRequired  string    `json:"experience_required,omitempty"`
	Location            string    `json:"location"`
	SalaryRange         string    `json:"salary_range,omitempty"`
	EmploymentType      string    `json:"employment_type"` // full-time, part-time, contract, freelance
	Requirements        []string  `json:"requirements,omitempty"`
	Responsibilities    []string  `json:"responsibilities,omitempty"`
	Benefits            []string  `json:"benefits,omitempty"`
	ApplicationDeadline string    `json:"application_deadline,omitempty"` // YYYY-MM-DD
	Status              string    `json:"status"`                         // open, closed, filled
	TotalApplications   int       `json:"total_applications"`
	CreatedAt           time.Time `json:"created_at"`
	UpdatedAt           time.Time `json:"updated_at"`
}

// JobApplication represents a candidate's application
type JobApplication struct {
	ID                 string    `json:"id"`
	JobID              string    `json:"job_id"`
	ApplicantID        string    `json:"applicant_id"`
	ApplicantName      string    `json:"applicant_name"`  // From users table
	ApplicantEmail     string    `json:"applicant_email"` // From users table
	CoverLetter        string    `json:"cover_letter"`
	ResumeURL          string    `json:"resume_url,omitempty"`
	ExperienceYears    int       `json:"experience_years"`
	RelevantExperience string    `json:"relevant_experience,omitempty"`
	Availability       string    `json:"availability,omitempty"`
	ExpectedSalary     string    `json:"expected_salary,omitempty"`
	Status             string    `json:"status"` // pending, reviewing, shortlisted, rejected, accepted
	AppliedAt          time.Time `json:"applied_at"`
	ReviewedAt         time.Time `json:"reviewed_at,omitempty"`
	Notes              string    `json:"notes,omitempty"`
}

// CreateJobRequest represents job posting creation request
type CreateJobRequest struct {
	Title               string   `json:"title"`
	Description         string   `json:"description"`
	JobType             string   `json:"job_type"`
	ExperienceRequired  string   `json:"experience_required"`
	Location            string   `json:"location"`
	SalaryRange         string   `json:"salary_range"`
	EmploymentType      string   `json:"employment_type"`
	Requirements        []string `json:"requirements"`
	Responsibilities    []string `json:"responsibilities"`
	Benefits            []string `json:"benefits"`
	ApplicationDeadline string   `json:"application_deadline"` // YYYY-MM-DD
}

// ApplyJobRequest represents job application request
type ApplyJobRequest struct {
	CoverLetter        string `json:"cover_letter"`
	ResumeURL          string `json:"resume_url"`
	ExperienceYears    int    `json:"experience_years"`
	RelevantExperience string `json:"relevant_experience"`
	Availability       string `json:"availability"`
	ExpectedSalary     string `json:"expected_salary"`
}

// JobListResponse represents paginated job list
type JobListResponse struct {
	Jobs       []JobPosting `json:"jobs"`
	Pagination Pagination   `json:"pagination"`
}

// Pagination represents pagination info
type Pagination struct {
	Page       int `json:"page"`
	Limit      int `json:"limit"`
	Total      int `json:"total"`
	TotalPages int `json:"total_pages"`
}
