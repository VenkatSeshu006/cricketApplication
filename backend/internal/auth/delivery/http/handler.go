package http

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/cricketapp/backend/config"
	"github.com/cricketapp/backend/internal/auth/domain"
	"github.com/cricketapp/backend/internal/auth/repository/postgres"
	"github.com/cricketapp/backend/internal/auth/service"
	"github.com/cricketapp/backend/internal/auth/util"
)

type AuthHandler struct {
	authService domain.AuthService
}

func NewAuthHandler(db *sql.DB, cfg *config.Config) *AuthHandler {
	userRepo := postgres.NewUserRepository(db)
	jwtUtil := util.NewJWTUtil(cfg.JWT.Secret, cfg.JWT.AccessTokenExpiry)
	authService := service.NewAuthService(userRepo, jwtUtil)

	return &AuthHandler{
		authService: authService,
	}
}

func (h *AuthHandler) Register(w http.ResponseWriter, r *http.Request) {
	var req domain.RegisterRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	response, err := h.authService.Register(r.Context(), &req)
	if err != nil {
		respondError(w, http.StatusBadRequest, err.Error())
		return
	}

	respondJSON(w, http.StatusCreated, map[string]interface{}{
		"status":  "success",
		"data":    response,
		"message": "Registration successful",
	})
}

func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	var req domain.LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	response, err := h.authService.Login(r.Context(), &req)
	if err != nil {
		respondError(w, http.StatusUnauthorized, err.Error())
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"status": "success",
		"data":   response,
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
