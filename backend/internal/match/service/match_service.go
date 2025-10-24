package service

import (
	"context"
	"fmt"
	"time"

	"github.com/cricketapp/backend/internal/match/domain"
	"github.com/google/uuid"
)

type matchService struct {
	repo domain.MatchRepository
}

// NewMatchService creates a new match service
func NewMatchService(repo domain.MatchRepository) domain.MatchService {
	return &matchService{repo: repo}
}

// Team operations

func (s *matchService) CreateTeam(ctx context.Context, req domain.CreateTeamRequest, userID uuid.UUID) (*domain.Team, error) {
	// Validate
	if req.Name == "" {
		return nil, fmt.Errorf("team name is required")
	}
	if req.ShortName == "" {
		return nil, fmt.Errorf("team short name is required")
	}
	if len(req.Colors) == 0 {
		return nil, fmt.Errorf("at least one team color is required")
	}

	// Check if team name exists
	existing, _ := s.repo.GetTeamByName(ctx, req.Name)
	if existing != nil {
		return nil, fmt.Errorf("team with this name already exists")
	}

	team := &domain.Team{
		ID:          uuid.New(),
		Name:        req.Name,
		ShortName:   req.ShortName,
		LogoURL:     req.LogoURL,
		Colors:      req.Colors,
		CreatedBy:   userID,
		CreatedAt:   time.Now(),
		IsActive:    true,
		Description: req.Description,
		HomeGround:  req.HomeGround,
	}

	err := s.repo.CreateTeam(ctx, team)
	if err != nil {
		return nil, err
	}

	return team, nil
}

func (s *matchService) GetTeam(ctx context.Context, teamID uuid.UUID) (*domain.Team, error) {
	return s.repo.GetTeamByID(ctx, teamID)
}

func (s *matchService) GetTeamStats(ctx context.Context, teamID uuid.UUID) (*domain.Team, error) {
	return s.repo.GetTeamStats(ctx, teamID)
}

func (s *matchService) ListTeams(ctx context.Context, userID *uuid.UUID) (*domain.TeamListResponse, error) {
	teams, err := s.repo.ListTeams(ctx, userID)
	if err != nil {
		return nil, err
	}

	return &domain.TeamListResponse{
		Teams: teams,
		Total: len(teams),
	}, nil
}

func (s *matchService) UpdateTeam(ctx context.Context, teamID uuid.UUID, req domain.CreateTeamRequest, userID uuid.UUID) (*domain.Team, error) {
	// Get existing team
	team, err := s.repo.GetTeamByID(ctx, teamID)
	if err != nil {
		return nil, err
	}

	// Check authorization
	if team.CreatedBy != userID {
		return nil, fmt.Errorf("not authorized to update this team")
	}

	// Update fields
	team.Name = req.Name
	team.ShortName = req.ShortName
	team.LogoURL = req.LogoURL
	team.Colors = req.Colors
	team.Description = req.Description
	team.HomeGround = req.HomeGround

	err = s.repo.UpdateTeam(ctx, team)
	if err != nil {
		return nil, err
	}

	return team, nil
}

func (s *matchService) DeleteTeam(ctx context.Context, teamID uuid.UUID, userID uuid.UUID) error {
	// Get team
	team, err := s.repo.GetTeamByID(ctx, teamID)
	if err != nil {
		return err
	}

	// Check authorization
	if team.CreatedBy != userID {
		return fmt.Errorf("not authorized to delete this team")
	}

	return s.repo.DeleteTeam(ctx, teamID)
}

// Player operations

func (s *matchService) AddPlayer(ctx context.Context, req domain.CreatePlayerRequest, userID uuid.UUID) (*domain.Player, error) {
	// Validate
	if req.JerseyNumber < 1 || req.JerseyNumber > 99 {
		return nil, fmt.Errorf("jersey number must be between 1 and 99")
	}

	validRoles := map[string]bool{
		"batsman": true, "bowler": true, "all-rounder": true, "wicket-keeper": true,
	}
	if !validRoles[req.Role] {
		return nil, fmt.Errorf("invalid player role")
	}

	// Check team exists
	team, err := s.repo.GetTeamByID(ctx, req.TeamID)
	if err != nil {
		return nil, fmt.Errorf("team not found")
	}

	// Check authorization (only team creator can add players)
	if team.CreatedBy != userID {
		return nil, fmt.Errorf("not authorized to add players to this team")
	}

	player := &domain.Player{
		ID:           uuid.New(),
		UserID:       req.UserID,
		TeamID:       req.TeamID,
		JerseyNumber: req.JerseyNumber,
		Role:         req.Role,
		Batting:      req.Batting,
		Bowling:      req.Bowling,
		IsActive:     true,
		JoinedAt:     time.Now(),
	}

	err = s.repo.AddPlayerToTeam(ctx, player)
	if err != nil {
		return nil, err
	}

	return player, nil
}

func (s *matchService) GetPlayer(ctx context.Context, playerID uuid.UUID) (*domain.Player, error) {
	return s.repo.GetPlayerByID(ctx, playerID)
}

func (s *matchService) ListTeamPlayers(ctx context.Context, teamID uuid.UUID) (*domain.PlayerListResponse, error) {
	players, err := s.repo.ListPlayersByTeam(ctx, teamID)
	if err != nil {
		return nil, err
	}

	return &domain.PlayerListResponse{
		Players: players,
		Total:   len(players),
	}, nil
}

func (s *matchService) ListUserPlayers(ctx context.Context, userID uuid.UUID) (*domain.PlayerListResponse, error) {
	players, err := s.repo.ListPlayersByUser(ctx, userID)
	if err != nil {
		return nil, err
	}

	return &domain.PlayerListResponse{
		Players: players,
		Total:   len(players),
	}, nil
}

func (s *matchService) RemovePlayer(ctx context.Context, playerID uuid.UUID, userID uuid.UUID) error {
	// Get player
	player, err := s.repo.GetPlayerByID(ctx, playerID)
	if err != nil {
		return err
	}

	// Get team to check authorization
	team, err := s.repo.GetTeamByID(ctx, player.TeamID)
	if err != nil {
		return err
	}

	if team.CreatedBy != userID {
		return fmt.Errorf("not authorized to remove this player")
	}

	return s.repo.RemovePlayerFromTeam(ctx, playerID)
}

// Match operations

func (s *matchService) CreateMatch(ctx context.Context, req domain.CreateMatchRequest, userID uuid.UUID) (*domain.Match, error) {
	// Validate
	if req.Title == "" {
		return nil, fmt.Errorf("match title is required")
	}

	if req.TeamAID == req.TeamBID {
		return nil, fmt.Errorf("teams must be different")
	}

	validTypes := map[string]bool{
		"practice": true, "friendly": true, "league": true, "tournament": true,
	}
	if !validTypes[req.MatchType] {
		return nil, fmt.Errorf("invalid match type")
	}

	validFormats := map[string]bool{
		"T20": true, "ODI": true, "Test": true, "T10": true,
	}
	if !validFormats[req.MatchFormat] {
		return nil, fmt.Errorf("invalid match format")
	}

	// Validate overs based on format
	expectedOvers := map[string]int{
		"T10": 10, "T20": 20, "ODI": 50, "Test": 90,
	}
	if req.TotalOvers == 0 {
		req.TotalOvers = expectedOvers[req.MatchFormat]
	}

	// Match date should not be in the past
	if req.MatchDate.Before(time.Now().Truncate(24 * time.Hour)) {
		return nil, fmt.Errorf("match date cannot be in the past")
	}

	// Check teams exist
	_, err := s.repo.GetTeamByID(ctx, req.TeamAID)
	if err != nil {
		return nil, fmt.Errorf("team A not found")
	}

	_, err = s.repo.GetTeamByID(ctx, req.TeamBID)
	if err != nil {
		return nil, fmt.Errorf("team B not found")
	}

	match := &domain.Match{
		ID:          uuid.New(),
		Title:       req.Title,
		MatchType:   req.MatchType,
		MatchFormat: req.MatchFormat,
		TeamAID:     req.TeamAID,
		TeamBID:     req.TeamBID,
		MatchDate:   req.MatchDate,
		MatchTime:   req.MatchTime,
		GroundID:    req.GroundID,
		VenueName:   req.VenueName,
		VenueCity:   req.VenueCity,
		TotalOvers:  req.TotalOvers,
		BallType:    req.BallType,
		Status:      "upcoming",
		CreatedBy:   userID,
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
		Description: req.Description,
		Umpires:     []string{},
		Scorers:     []string{},
	}

	err = s.repo.CreateMatch(ctx, match)
	if err != nil {
		return nil, err
	}

	return match, nil
}

func (s *matchService) GetMatch(ctx context.Context, matchID uuid.UUID) (*domain.Match, error) {
	return s.repo.GetMatchByID(ctx, matchID)
}

func (s *matchService) ListMatches(ctx context.Context, filters domain.MatchFilters) (*domain.MatchListResponse, error) {
	if filters.Page == 0 {
		filters.Page = 1
	}
	if filters.Limit == 0 {
		filters.Limit = 20
	}

	matches, total, err := s.repo.ListMatches(ctx, filters)
	if err != nil {
		return nil, err
	}

	return &domain.MatchListResponse{
		Matches: matches,
		Total:   total,
		Page:    filters.Page,
		Limit:   filters.Limit,
	}, nil
}

func (s *matchService) UpdateMatch(ctx context.Context, matchID uuid.UUID, req domain.UpdateMatchRequest, userID uuid.UUID) (*domain.Match, error) {
	// Get match
	match, err := s.repo.GetMatchByID(ctx, matchID)
	if err != nil {
		return nil, err
	}

	// Check authorization
	if match.CreatedBy != userID {
		return nil, fmt.Errorf("not authorized to update this match")
	}

	// Can't update completed matches
	if match.Status == "completed" {
		return nil, fmt.Errorf("cannot update completed match")
	}

	// Update fields
	if req.Title != nil {
		match.Title = *req.Title
	}
	if req.MatchDate != nil {
		match.MatchDate = *req.MatchDate
	}
	if req.MatchTime != nil {
		match.MatchTime = *req.MatchTime
	}
	if req.VenueName != nil {
		match.VenueName = *req.VenueName
	}
	if req.VenueCity != nil {
		match.VenueCity = *req.VenueCity
	}
	if req.TotalOvers != nil {
		match.TotalOvers = *req.TotalOvers
	}
	if req.Description != nil {
		match.Description = req.Description
	}

	match.UpdatedAt = time.Now()

	err = s.repo.UpdateMatch(ctx, match)
	if err != nil {
		return nil, err
	}

	return match, nil
}

func (s *matchService) UpdateMatchStatus(ctx context.Context, matchID uuid.UUID, req domain.UpdateMatchStatusRequest, userID uuid.UUID) (*domain.Match, error) {
	// Get match
	match, err := s.repo.GetMatchByID(ctx, matchID)
	if err != nil {
		return nil, err
	}

	// Check authorization
	if match.CreatedBy != userID {
		return nil, fmt.Errorf("not authorized to update this match")
	}

	// Validate status
	validStatuses := map[string]bool{
		"upcoming": true, "live": true, "completed": true, "cancelled": true,
	}
	if !validStatuses[req.Status] {
		return nil, fmt.Errorf("invalid status")
	}

	// Build result object
	result := make(map[string]interface{})

	if req.TossWonBy != nil {
		result["toss_won_by"] = req.TossWonBy.String()
		if req.TossDecision != nil {
			result["toss_decision"] = *req.TossDecision
		}
	}

	if req.Status == "completed" {
		if req.WinnerTeamID != nil {
			result["winner_team_id"] = req.WinnerTeamID.String()
		}
		if req.WinMargin != nil {
			result["win_margin"] = *req.WinMargin
		}
		if req.ResultType != nil {
			result["result_type"] = *req.ResultType
		}
	}

	err = s.repo.UpdateMatchStatus(ctx, matchID, req.Status, result)
	if err != nil {
		return nil, err
	}

	return s.repo.GetMatchByID(ctx, matchID)
}

func (s *matchService) DeleteMatch(ctx context.Context, matchID uuid.UUID, userID uuid.UUID) error {
	// Get match
	match, err := s.repo.GetMatchByID(ctx, matchID)
	if err != nil {
		return err
	}

	// Check authorization
	if match.CreatedBy != userID {
		return fmt.Errorf("not authorized to delete this match")
	}

	// Can't delete live or completed matches
	if match.Status == "live" || match.Status == "completed" {
		return fmt.Errorf("cannot delete %s match", match.Status)
	}

	return s.repo.DeleteMatch(ctx, matchID)
}

// Squad operations

func (s *matchService) AddPlayerToMatchSquad(ctx context.Context, matchID uuid.UUID, req domain.AddSquadPlayerRequest, userID uuid.UUID) (*domain.MatchSquad, error) {
	// Get match
	match, err := s.repo.GetMatchByID(ctx, matchID)
	if err != nil {
		return nil, fmt.Errorf("match not found")
	}

	// Check authorization
	if match.CreatedBy != userID {
		return nil, fmt.Errorf("not authorized to manage squad")
	}

	// Validate team is in this match
	if req.TeamID != match.TeamAID && req.TeamID != match.TeamBID {
		return nil, fmt.Errorf("team is not part of this match")
	}

	// Get player
	player, err := s.repo.GetPlayerByID(ctx, req.PlayerID)
	if err != nil {
		return nil, fmt.Errorf("player not found")
	}

	// Validate player belongs to the team
	if player.TeamID != req.TeamID {
		return nil, fmt.Errorf("player does not belong to this team")
	}

	// Check squad size if adding to playing 11
	if req.InPlaying11 {
		squad, _ := s.repo.GetTeamSquad(ctx, matchID, req.TeamID)
		playing11Count := 0
		for _, p := range squad {
			if p.InPlaying11 {
				playing11Count++
			}
		}
		if playing11Count >= 11 {
			return nil, fmt.Errorf("playing 11 is full")
		}
	}

	squadPlayer := &domain.MatchSquad{
		ID:             uuid.New(),
		MatchID:        matchID,
		PlayerID:       req.PlayerID,
		TeamID:         req.TeamID,
		InPlaying11:    req.InPlaying11,
		IsCaptain:      req.IsCaptain,
		IsViceCaptain:  req.IsViceCaptain,
		IsWicketKeeper: req.IsWicketKeeper,
		AddedAt:        time.Now(),
	}

	err = s.repo.AddPlayerToSquad(ctx, squadPlayer)
	if err != nil {
		return nil, err
	}

	return squadPlayer, nil
}

func (s *matchService) RemovePlayerFromMatchSquad(ctx context.Context, matchID, playerID uuid.UUID, userID uuid.UUID) error {
	// Get match
	match, err := s.repo.GetMatchByID(ctx, matchID)
	if err != nil {
		return err
	}

	// Check authorization
	if match.CreatedBy != userID {
		return fmt.Errorf("not authorized to manage squad")
	}

	return s.repo.RemovePlayerFromSquad(ctx, matchID, playerID)
}

func (s *matchService) GetMatchSquad(ctx context.Context, matchID uuid.UUID) ([]domain.MatchSquad, error) {
	return s.repo.GetMatchSquad(ctx, matchID)
}

func (s *matchService) UpdateSquadPlayer(ctx context.Context, matchID uuid.UUID, req domain.AddSquadPlayerRequest, userID uuid.UUID) (*domain.MatchSquad, error) {
	// Get match
	match, err := s.repo.GetMatchByID(ctx, matchID)
	if err != nil {
		return nil, err
	}

	// Check authorization
	if match.CreatedBy != userID {
		return nil, fmt.Errorf("not authorized to manage squad")
	}

	squadPlayer := &domain.MatchSquad{
		MatchID:        matchID,
		PlayerID:       req.PlayerID,
		TeamID:         req.TeamID,
		InPlaying11:    req.InPlaying11,
		IsCaptain:      req.IsCaptain,
		IsViceCaptain:  req.IsViceCaptain,
		IsWicketKeeper: req.IsWicketKeeper,
	}

	err = s.repo.UpdateSquadPlayer(ctx, squadPlayer)
	if err != nil {
		return nil, err
	}

	return squadPlayer, nil
}
