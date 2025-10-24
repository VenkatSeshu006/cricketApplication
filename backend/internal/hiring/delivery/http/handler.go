package http

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cricketapp/backend/internal/hiring/domain"
	"github.com/go-chi/chi/v5"
)

type HiringHandler struct {
	service domain.HiringService
}

// NewHiringHandler creates a new hiring handler
func NewHiringHandler(service domain.HiringService) *HiringHandler {
	return &HiringHandler{service: service}
}

// CreateJob handles POST /api/v1/jobs
func (h *HiringHandler) CreateJob(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get employer ID from context (set by auth middleware)
	employerID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	var req domain.CreateJobRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	job, err := h.service.CreateJob(ctx, employerID, &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(job)
}

// ListJobs handles GET /api/v1/jobs
func (h *HiringHandler) ListJobs(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get query parameters
	page := 1
	limit := 10
	jobType := r.URL.Query().Get("type")
	status := r.URL.Query().Get("status")

	if pageStr := r.URL.Query().Get("page"); pageStr != "" {
		if p, err := strconv.Atoi(pageStr); err == nil && p > 0 {
			page = p
		}
	}

	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 && l <= 50 {
			limit = l
		}
	}

	response, err := h.service.ListJobs(ctx, page, limit, jobType, status)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// GetJobDetails handles GET /api/v1/jobs/:id
func (h *HiringHandler) GetJobDetails(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	jobID := chi.URLParam(r, "id")

	job, err := h.service.GetJobDetails(ctx, jobID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(job)
}

// GetMyJobs handles GET /api/v1/jobs/my
func (h *HiringHandler) GetMyJobs(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get employer ID from context
	employerID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	jobs, err := h.service.GetMyJobs(ctx, employerID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(jobs)
}

// CloseJob handles PUT /api/v1/jobs/:id/close
func (h *HiringHandler) CloseJob(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	jobID := chi.URLParam(r, "id")

	// Get employer ID from context
	employerID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	if err := h.service.CloseJob(ctx, employerID, jobID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "success",
		"message": "job closed successfully",
	})
}

// ApplyForJob handles POST /api/v1/jobs/:id/apply
func (h *HiringHandler) ApplyForJob(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	jobID := chi.URLParam(r, "id")

	// Get applicant ID from context
	applicantID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	var req domain.ApplyJobRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	application, err := h.service.ApplyForJob(ctx, applicantID, jobID, &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(application)
}

// GetJobApplications handles GET /api/v1/jobs/:id/applications
func (h *HiringHandler) GetJobApplications(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	jobID := chi.URLParam(r, "id")

	// Get employer ID from context
	employerID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	applications, err := h.service.GetJobApplications(ctx, employerID, jobID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusForbidden)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(applications)
}

// GetMyApplications handles GET /api/v1/applications/my
func (h *HiringHandler) GetMyApplications(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get user ID from context
	userID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	applications, err := h.service.GetMyApplications(ctx, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(applications)
}

// UpdateApplicationStatus handles PUT /api/v1/applications/:id/status
func (h *HiringHandler) UpdateApplicationStatus(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	appID := chi.URLParam(r, "id")

	// Get employer ID from context
	employerID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	var req struct {
		Status string `json:"status"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	if err := h.service.UpdateApplicationStatus(ctx, employerID, appID, req.Status); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "success",
		"message": "application status updated",
	})
}
