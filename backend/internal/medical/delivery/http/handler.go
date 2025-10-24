package http

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cricketapp/backend/internal/medical/domain"
	"github.com/go-chi/chi/v5"
)

type MedicalHandler struct {
	service domain.MedicalService
}

// NewMedicalHandler creates a new medical handler
func NewMedicalHandler(service domain.MedicalService) *MedicalHandler {
	return &MedicalHandler{service: service}
}

// ListPhysiotherapists handles GET /api/v1/physiotherapists
func (h *MedicalHandler) ListPhysiotherapists(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get pagination parameters
	page := 1
	limit := 10

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

	response, err := h.service.ListPhysiotherapists(ctx, page, limit)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// GetPhysiotherapistDetails handles GET /api/v1/physiotherapists/:id
func (h *MedicalHandler) GetPhysiotherapistDetails(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	physioID := chi.URLParam(r, "id")

	physio, err := h.service.GetPhysiotherapistDetails(ctx, physioID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(physio)
}

// CreateAppointment handles POST /api/v1/appointments
func (h *MedicalHandler) CreateAppointment(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get patient ID from context (set by auth middleware)
	patientID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	var req domain.CreateAppointmentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	appointment, err := h.service.CreateAppointment(ctx, patientID, &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(appointment)
}

// GetMyAppointments handles GET /api/v1/appointments/my
func (h *MedicalHandler) GetMyAppointments(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get patient ID from context (set by auth middleware)
	patientID, ok := ctx.Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	appointments, err := h.service.GetPatientAppointments(ctx, patientID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(appointments)
}
