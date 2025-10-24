package http

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cricketapp/backend/internal/ground/domain"
	"github.com/cricketapp/backend/internal/ground/repository/postgres"
	"github.com/cricketapp/backend/internal/ground/service"
	"github.com/go-chi/chi/v5"
)

type GroundHandler struct {
	groundService domain.GroundService
}

func NewGroundHandler(db *sql.DB) *GroundHandler {
	groundRepo := postgres.NewGroundRepository(db)
	groundService := service.NewGroundService(groundRepo)

	return &GroundHandler{
		groundService: groundService,
	}
}

// ListGrounds handles GET /api/v1/grounds
func (h *GroundHandler) ListGrounds(w http.ResponseWriter, r *http.Request) {
	// Parse query parameters
	page, _ := strconv.Atoi(r.URL.Query().Get("page"))
	limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))

	if page < 1 {
		page = 1
	}
	if limit < 1 {
		limit = 10
	}

	response, err := h.groundService.ListGrounds(r.Context(), page, limit)
	if err != nil {
		respondError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"status": "success",
		"data":   response,
	})
}

// GetGroundDetails handles GET /api/v1/grounds/:id
func (h *GroundHandler) GetGroundDetails(w http.ResponseWriter, r *http.Request) {
	groundID := chi.URLParam(r, "id")
	if groundID == "" {
		respondError(w, http.StatusBadRequest, "Ground ID is required")
		return
	}

	ground, err := h.groundService.GetGroundDetails(r.Context(), groundID)
	if err != nil {
		respondError(w, http.StatusNotFound, err.Error())
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"status": "success",
		"data":   ground,
	})
}

// CreateBooking handles POST /api/v1/bookings
func (h *GroundHandler) CreateBooking(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value("user_id")
	if userID == nil {
		respondError(w, http.StatusUnauthorized, "Unauthorized")
		return
	}

	var req domain.CreateBookingRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	booking, err := h.groundService.CreateBooking(r.Context(), userID.(string), &req)
	if err != nil {
		respondError(w, http.StatusBadRequest, err.Error())
		return
	}

	respondJSON(w, http.StatusCreated, map[string]interface{}{
		"status":  "success",
		"data":    booking,
		"message": "Booking created successfully",
	})
}

// GetUserBookings handles GET /api/v1/bookings/my
func (h *GroundHandler) GetUserBookings(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value("user_id")
	if userID == nil {
		respondError(w, http.StatusUnauthorized, "Unauthorized")
		return
	}

	bookings, err := h.groundService.GetUserBookings(r.Context(), userID.(string))
	if err != nil {
		respondError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"status": "success",
		"data":   bookings,
	})
}

func respondJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(data)
}

func respondError(w http.ResponseWriter, status int, message string) {
	respondJSON(w, status, map[string]interface{}{
		"status":  "error",
		"message": message,
	})
}
