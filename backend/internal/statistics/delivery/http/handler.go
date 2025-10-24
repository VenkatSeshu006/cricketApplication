package http

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cricketapp/backend/internal/statistics/domain"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

type StatisticsHandler struct {
	service domain.StatisticsService
}

// NewStatisticsHandler creates a new statistics handler
func NewStatisticsHandler(service domain.StatisticsService) *StatisticsHandler {
	return &StatisticsHandler{service: service}
}

// RecordPerformance handles POST /performances
func (h *StatisticsHandler) RecordPerformance(w http.ResponseWriter, r *http.Request) {
	var req domain.RecordPerformanceRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	perf, err := h.service.RecordPerformance(req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(perf)
}

// GetPerformance handles GET /performances/{id}
func (h *StatisticsHandler) GetPerformance(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		http.Error(w, "Invalid performance ID", http.StatusBadRequest)
		return
	}

	perf, err := h.service.GetPerformance(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(perf)
}

// ListPerformances handles GET /performances
func (h *StatisticsHandler) ListPerformances(w http.ResponseWriter, r *http.Request) {
	filters := domain.PerformanceFilters{
		Page:  1,
		Limit: 10,
	}

	if playerIDStr := r.URL.Query().Get("player_id"); playerIDStr != "" {
		playerID, err := uuid.Parse(playerIDStr)
		if err == nil {
			filters.PlayerID = &playerID
		}
	}

	if matchIDStr := r.URL.Query().Get("match_id"); matchIDStr != "" {
		matchID, err := uuid.Parse(matchIDStr)
		if err == nil {
			filters.MatchID = &matchID
		}
	}

	if teamIDStr := r.URL.Query().Get("team_id"); teamIDStr != "" {
		teamID, err := uuid.Parse(teamIDStr)
		if err == nil {
			filters.TeamID = &teamID
		}
	}

	if minRunsStr := r.URL.Query().Get("min_runs"); minRunsStr != "" {
		if minRuns, err := strconv.Atoi(minRunsStr); err == nil {
			filters.MinRuns = &minRuns
		}
	}

	if minWicketsStr := r.URL.Query().Get("min_wickets"); minWicketsStr != "" {
		if minWickets, err := strconv.Atoi(minWicketsStr); err == nil {
			filters.MinWickets = &minWickets
		}
	}

	if pageStr := r.URL.Query().Get("page"); pageStr != "" {
		if page, err := strconv.Atoi(pageStr); err == nil && page > 0 {
			filters.Page = page
		}
	}

	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if limit, err := strconv.Atoi(limitStr); err == nil && limit > 0 {
			filters.Limit = limit
		}
	}

	performances, total, err := h.service.ListPerformances(filters)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	response := domain.PerformanceListResponse{
		Performances: performances,
		Total:        total,
		Page:         filters.Page,
		Limit:        filters.Limit,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// UpdatePerformance handles PUT /performances/{id}
func (h *StatisticsHandler) UpdatePerformance(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		http.Error(w, "Invalid performance ID", http.StatusBadRequest)
		return
	}

	var req domain.UpdatePerformanceRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	perf, err := h.service.UpdatePerformance(id, req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(perf)
}

// DeletePerformance handles DELETE /performances/{id}
func (h *StatisticsHandler) DeletePerformance(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		http.Error(w, "Invalid performance ID", http.StatusBadRequest)
		return
	}

	err = h.service.DeletePerformance(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// GetPlayerStats handles GET /players/{id}/stats
func (h *StatisticsHandler) GetPlayerStats(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		http.Error(w, "Invalid player ID", http.StatusBadRequest)
		return
	}

	stats, err := h.service.GetPlayerCareerStats(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(stats)
}

// RefreshPlayerStats handles POST /players/{id}/refresh-stats
func (h *StatisticsHandler) RefreshPlayerStats(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		http.Error(w, "Invalid player ID", http.StatusBadRequest)
		return
	}

	stats, err := h.service.RefreshPlayerStats(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(stats)
}

// GetBattingLeaderboard handles GET /leaderboards/batting
func (h *StatisticsHandler) GetBattingLeaderboard(w http.ResponseWriter, r *http.Request) {
	var season *string
	if s := r.URL.Query().Get("season"); s != "" {
		season = &s
	}

	limit := 10
	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 {
			limit = l
		}
	}

	entries, err := h.service.GetBattingLeaderboard(season, limit)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	seasonStr := "all_time"
	if season != nil {
		seasonStr = *season
	}

	response := domain.LeaderboardResponse{
		Category: "best_batting_average",
		Season:   seasonStr,
		Entries:  entries,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// GetBowlingLeaderboard handles GET /leaderboards/bowling
func (h *StatisticsHandler) GetBowlingLeaderboard(w http.ResponseWriter, r *http.Request) {
	var season *string
	if s := r.URL.Query().Get("season"); s != "" {
		season = &s
	}

	limit := 10
	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 {
			limit = l
		}
	}

	entries, err := h.service.GetBowlingLeaderboard(season, limit)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	seasonStr := "all_time"
	if season != nil {
		seasonStr = *season
	}

	response := domain.LeaderboardResponse{
		Category: "best_bowling_average",
		Season:   seasonStr,
		Entries:  entries,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// GetMostRunsLeaderboard handles GET /leaderboards/most-runs
func (h *StatisticsHandler) GetMostRunsLeaderboard(w http.ResponseWriter, r *http.Request) {
	var season *string
	if s := r.URL.Query().Get("season"); s != "" {
		season = &s
	}

	limit := 10
	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 {
			limit = l
		}
	}

	entries, err := h.service.GetMostRunsLeaderboard(season, limit)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	seasonStr := "all_time"
	if season != nil {
		seasonStr = *season
	}

	response := domain.LeaderboardResponse{
		Category: "most_runs",
		Season:   seasonStr,
		Entries:  entries,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// GetMostWicketsLeaderboard handles GET /leaderboards/most-wickets
func (h *StatisticsHandler) GetMostWicketsLeaderboard(w http.ResponseWriter, r *http.Request) {
	var season *string
	if s := r.URL.Query().Get("season"); s != "" {
		season = &s
	}

	limit := 10
	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 {
			limit = l
		}
	}

	entries, err := h.service.GetMostWicketsLeaderboard(season, limit)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	seasonStr := "all_time"
	if season != nil {
		seasonStr = *season
	}

	response := domain.LeaderboardResponse{
		Category: "most_wickets",
		Season:   seasonStr,
		Entries:  entries,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// RefreshLeaderboards handles POST /leaderboards/refresh
func (h *StatisticsHandler) RefreshLeaderboards(w http.ResponseWriter, r *http.Request) {
	var season *string
	if s := r.URL.Query().Get("season"); s != "" {
		season = &s
	}

	err := h.service.RefreshLeaderboards(season)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"message": "Leaderboards refreshed successfully"})
}
