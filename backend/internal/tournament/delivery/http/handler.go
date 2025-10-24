package http

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cricketapp/backend/internal/tournament/domain"
	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

type TournamentHandler struct {
	service domain.TournamentService
}

func NewTournamentHandler(service domain.TournamentService) *TournamentHandler {
	return &TournamentHandler{service: service}
}

// getUserID extracts and parses the user ID from request context
func getUserID(r *http.Request) (uuid.UUID, error) {
	userID := r.Context().Value("user_id").(string)
	return uuid.Parse(userID)
}

// Tournament CRUD handlers

func (h *TournamentHandler) CreateTournament(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateTournamentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	tournament, err := h.service.CreateTournament(r.Context(), req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(tournament)
}

func (h *TournamentHandler) GetTournament(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	tournament, err := h.service.GetTournament(r.Context(), tournamentID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tournament)
}

func (h *TournamentHandler) ListTournaments(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()

	filters := domain.TournamentFilters{
		Page:  1,
		Limit: 20,
	}

	if page := query.Get("page"); page != "" {
		if p, err := strconv.Atoi(page); err == nil {
			filters.Page = p
		}
	}

	if limit := query.Get("limit"); limit != "" {
		if l, err := strconv.Atoi(limit); err == nil {
			filters.Limit = l
		}
	}

	if status := query.Get("status"); status != "" {
		filters.Status = &status
	}

	if tournamentType := query.Get("type"); tournamentType != "" {
		filters.TournamentType = &tournamentType
	}

	if organizerID := query.Get("organizer_id"); organizerID != "" {
		if id, err := uuid.Parse(organizerID); err == nil {
			filters.OrganizerID = &id
		}
	}

	if startFrom := query.Get("start_from"); startFrom != "" {
		filters.StartDateFrom = &startFrom
	}

	if startTo := query.Get("start_to"); startTo != "" {
		filters.StartDateTo = &startTo
	}

	response, err := h.service.ListTournaments(r.Context(), filters)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (h *TournamentHandler) UpdateTournament(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	var req domain.UpdateTournamentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	tournament, err := h.service.UpdateTournament(r.Context(), tournamentID, req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tournament)
}

func (h *TournamentHandler) DeleteTournament(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.DeleteTournament(r.Context(), tournamentID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// Tournament status management handlers

func (h *TournamentHandler) OpenRegistration(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.OpenRegistration(r.Context(), tournamentID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Registration opened successfully"})
}

func (h *TournamentHandler) CloseRegistration(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.CloseRegistration(r.Context(), tournamentID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Registration closed successfully"})
}

func (h *TournamentHandler) StartTournament(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.StartTournament(r.Context(), tournamentID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Tournament started successfully"})
}

func (h *TournamentHandler) CompleteTournament(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.CompleteTournament(r.Context(), tournamentID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Tournament completed successfully"})
}

func (h *TournamentHandler) CancelTournament(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.CancelTournament(r.Context(), tournamentID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Tournament cancelled successfully"})
}

// Registration handlers

func (h *TournamentHandler) RegisterTeam(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	var req domain.RegisterTeamRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	registration, err := h.service.RegisterTeam(r.Context(), tournamentID, req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(registration)
}

func (h *TournamentHandler) ListRegistrations(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	var status *string
	if s := r.URL.Query().Get("status"); s != "" {
		status = &s
	}

	response, err := h.service.ListRegistrations(r.Context(), tournamentID, status)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (h *TournamentHandler) ApproveRegistration(w http.ResponseWriter, r *http.Request) {
	registrationID, err := uuid.Parse(chi.URLParam(r, "registrationId"))
	if err != nil {
		http.Error(w, "Invalid registration ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.ApproveRegistration(r.Context(), registrationID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Registration approved successfully"})
}

func (h *TournamentHandler) RejectRegistration(w http.ResponseWriter, r *http.Request) {
	registrationID, err := uuid.Parse(chi.URLParam(r, "registrationId"))
	if err != nil {
		http.Error(w, "Invalid registration ID", http.StatusBadRequest)
		return
	}

	var reqBody struct {
		Reason string `json:"reason"`
	}
	if err := json.NewDecoder(r.Body).Decode(&reqBody); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.RejectRegistration(r.Context(), registrationID, reqBody.Reason, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Registration rejected successfully"})
}

func (h *TournamentHandler) WithdrawRegistration(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	teamID, err := uuid.Parse(chi.URLParam(r, "teamId"))
	if err != nil {
		http.Error(w, "Invalid team ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	if err := h.service.WithdrawRegistration(r.Context(), tournamentID, teamID, userID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Registration withdrawn successfully"})
}

// Standings handlers

func (h *TournamentHandler) GetStandings(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	var groupName *string
	if g := r.URL.Query().Get("group"); g != "" {
		groupName = &g
	}

	response, err := h.service.GetStandings(r.Context(), tournamentID, groupName)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// Tournament matches handlers

func (h *TournamentHandler) GetTournamentMatches(w http.ResponseWriter, r *http.Request) {
	tournamentID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid tournament ID", http.StatusBadRequest)
		return
	}

	var roundNumber *int
	if r := r.URL.Query().Get("round"); r != "" {
		if rn, err := strconv.Atoi(r); err == nil {
			roundNumber = &rn
		}
	}

	var groupName *string
	if g := r.URL.Query().Get("group"); g != "" {
		groupName = &g
	}

	response, err := h.service.GetTournamentMatches(r.Context(), tournamentID, roundNumber, groupName)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
