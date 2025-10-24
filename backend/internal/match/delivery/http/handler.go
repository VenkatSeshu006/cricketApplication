package http

import (
	"encoding/json"
	"net/http"
	"strconv"
	"time"

	"github.com/cricketapp/backend/internal/match/domain"
	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

type MatchHandler struct {
	service domain.MatchService
}

func NewMatchHandler(service domain.MatchService) *MatchHandler {
	return &MatchHandler{service: service}
}

// getUserID extracts and parses the user ID from request context
func getUserID(r *http.Request) (uuid.UUID, error) {
	userID := r.Context().Value("user_id").(string)
	return uuid.Parse(userID)
}

// Team Handlers

func (h *MatchHandler) CreateTeam(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateTeamRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID := r.Context().Value("user_id").(string)
	userUUID, err := uuid.Parse(userID)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	team, err := h.service.CreateTeam(r.Context(), req, userUUID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(team)
}

func (h *MatchHandler) GetTeam(w http.ResponseWriter, r *http.Request) {
	teamID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid team ID", http.StatusBadRequest)
		return
	}

	team, err := h.service.GetTeam(r.Context(), teamID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(team)
}

func (h *MatchHandler) GetTeamStats(w http.ResponseWriter, r *http.Request) {
	teamID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid team ID", http.StatusBadRequest)
		return
	}

	team, err := h.service.GetTeamStats(r.Context(), teamID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(team)
}

func (h *MatchHandler) ListTeams(w http.ResponseWriter, r *http.Request) {
	var userID *uuid.UUID
	if userIDStr := r.URL.Query().Get("created_by"); userIDStr != "" {
		id, err := uuid.Parse(userIDStr)
		if err == nil {
			userID = &id
		}
	}

	teams, err := h.service.ListTeams(r.Context(), userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(teams)
}

func (h *MatchHandler) UpdateTeam(w http.ResponseWriter, r *http.Request) {
	teamID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid team ID", http.StatusBadRequest)
		return
	}

	var req domain.CreateTeamRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	team, err := h.service.UpdateTeam(r.Context(), teamID, req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(team)
}

func (h *MatchHandler) DeleteTeam(w http.ResponseWriter, r *http.Request) {
	teamID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid team ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	err = h.service.DeleteTeam(r.Context(), teamID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// Player Handlers

func (h *MatchHandler) AddPlayer(w http.ResponseWriter, r *http.Request) {
	var req domain.CreatePlayerRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	player, err := h.service.AddPlayer(r.Context(), req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(player)
}

func (h *MatchHandler) GetPlayer(w http.ResponseWriter, r *http.Request) {
	playerID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid player ID", http.StatusBadRequest)
		return
	}

	player, err := h.service.GetPlayer(r.Context(), playerID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(player)
}

func (h *MatchHandler) ListTeamPlayers(w http.ResponseWriter, r *http.Request) {
	teamID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid team ID", http.StatusBadRequest)
		return
	}

	players, err := h.service.ListTeamPlayers(r.Context(), teamID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(players)
}

func (h *MatchHandler) RemovePlayer(w http.ResponseWriter, r *http.Request) {
	playerID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid player ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	err = h.service.RemovePlayer(r.Context(), playerID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// Match Handlers

func (h *MatchHandler) CreateMatch(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateMatchRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	match, err := h.service.CreateMatch(r.Context(), req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(match)
}

func (h *MatchHandler) GetMatch(w http.ResponseWriter, r *http.Request) {
	matchID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid match ID", http.StatusBadRequest)
		return
	}

	match, err := h.service.GetMatch(r.Context(), matchID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(match)
}

func (h *MatchHandler) ListMatches(w http.ResponseWriter, r *http.Request) {
	filters := domain.MatchFilters{}

	// Parse query parameters
	if status := r.URL.Query().Get("status"); status != "" {
		filters.Status = &status
	}
	if matchType := r.URL.Query().Get("type"); matchType != "" {
		filters.MatchType = &matchType
	}
	if format := r.URL.Query().Get("format"); format != "" {
		filters.MatchFormat = &format
	}
	if teamID := r.URL.Query().Get("team_id"); teamID != "" {
		if id, err := uuid.Parse(teamID); err == nil {
			filters.TeamID = &id
		}
	}
	if createdBy := r.URL.Query().Get("created_by"); createdBy != "" {
		if id, err := uuid.Parse(createdBy); err == nil {
			filters.CreatedBy = &id
		}
	}
	if fromDate := r.URL.Query().Get("from_date"); fromDate != "" {
		if t, err := time.Parse("2006-01-02", fromDate); err == nil {
			filters.FromDate = &t
		}
	}
	if toDate := r.URL.Query().Get("to_date"); toDate != "" {
		if t, err := time.Parse("2006-01-02", toDate); err == nil {
			filters.ToDate = &t
		}
	}

	if page := r.URL.Query().Get("page"); page != "" {
		if p, err := strconv.Atoi(page); err == nil {
			filters.Page = p
		}
	}
	if limit := r.URL.Query().Get("limit"); limit != "" {
		if l, err := strconv.Atoi(limit); err == nil {
			filters.Limit = l
		}
	}

	matches, err := h.service.ListMatches(r.Context(), filters)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(matches)
}

func (h *MatchHandler) UpdateMatch(w http.ResponseWriter, r *http.Request) {
	matchID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid match ID", http.StatusBadRequest)
		return
	}

	var req domain.UpdateMatchRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	match, err := h.service.UpdateMatch(r.Context(), matchID, req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(match)
}

func (h *MatchHandler) UpdateMatchStatus(w http.ResponseWriter, r *http.Request) {
	matchID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid match ID", http.StatusBadRequest)
		return
	}

	var req domain.UpdateMatchStatusRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	match, err := h.service.UpdateMatchStatus(r.Context(), matchID, req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(match)
}

func (h *MatchHandler) DeleteMatch(w http.ResponseWriter, r *http.Request) {
	matchID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid match ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	err = h.service.DeleteMatch(r.Context(), matchID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// Squad Handlers

func (h *MatchHandler) AddPlayerToSquad(w http.ResponseWriter, r *http.Request) {
	matchID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid match ID", http.StatusBadRequest)
		return
	}

	var req domain.AddSquadPlayerRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	squad, err := h.service.AddPlayerToMatchSquad(r.Context(), matchID, req, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(squad)
}

func (h *MatchHandler) RemovePlayerFromSquad(w http.ResponseWriter, r *http.Request) {
	matchID, err := uuid.Parse(chi.URLParam(r, "matchId"))
	if err != nil {
		http.Error(w, "Invalid match ID", http.StatusBadRequest)
		return
	}

	playerID, err := uuid.Parse(chi.URLParam(r, "playerId"))
	if err != nil {
		http.Error(w, "Invalid player ID", http.StatusBadRequest)
		return
	}

	userID, err := getUserID(r)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusUnauthorized)
		return
	}

	err = h.service.RemovePlayerFromMatchSquad(r.Context(), matchID, playerID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *MatchHandler) GetMatchSquad(w http.ResponseWriter, r *http.Request) {
	matchID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "Invalid match ID", http.StatusBadRequest)
		return
	}

	squad, err := h.service.GetMatchSquad(r.Context(), matchID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"squad": squad,
		"total": len(squad),
	})
}
