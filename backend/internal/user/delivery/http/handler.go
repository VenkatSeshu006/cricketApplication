package http

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/cricketapp/backend/internal/user/domain"
	"github.com/cricketapp/backend/internal/user/repository/postgres"
	"github.com/cricketapp/backend/internal/user/service"
	"github.com/go-chi/chi/v5"
)

type UserHandler struct {
	userService domain.UserService
}

func NewUserHandler(db *sql.DB) *UserHandler {
	userRepo := postgres.NewUserRepository(db)
	userService := service.NewUserService(userRepo)

	return &UserHandler{
		userService: userService,
	}
}

// GetProfile handles GET /api/v1/users/profile
func (h *UserHandler) GetProfile(w http.ResponseWriter, r *http.Request) {
	// Extract user ID from context (set by auth middleware)
	userID := r.Context().Value("user_id")
	if userID == nil {
		respondError(w, http.StatusUnauthorized, "Unauthorized")
		return
	}

	profile, err := h.userService.GetProfile(r.Context(), userID.(string))
	if err != nil {
		respondError(w, http.StatusNotFound, err.Error())
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"status": "success",
		"data":   profile,
	})
}

// UpdateProfile handles PUT /api/v1/users/profile
func (h *UserHandler) UpdateProfile(w http.ResponseWriter, r *http.Request) {
	// Extract user ID from context (set by auth middleware)
	userID := r.Context().Value("user_id")
	if userID == nil {
		respondError(w, http.StatusUnauthorized, "Unauthorized")
		return
	}

	var req domain.UpdateProfileRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	profile, err := h.userService.UpdateProfile(r.Context(), userID.(string), &req)
	if err != nil {
		respondError(w, http.StatusBadRequest, err.Error())
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"status":  "success",
		"data":    profile,
		"message": "Profile updated successfully",
	})
}

// GetUserByID handles GET /api/v1/users/:id (public profile view)
func (h *UserHandler) GetUserByID(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "id")
	if userID == "" {
		respondError(w, http.StatusBadRequest, "User ID is required")
		return
	}

	profile, err := h.userService.GetProfile(r.Context(), userID)
	if err != nil {
		respondError(w, http.StatusNotFound, err.Error())
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"status": "success",
		"data":   profile,
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
