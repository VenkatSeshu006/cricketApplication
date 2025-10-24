package domain

import (
	"context"

	"github.com/google/uuid"
)

// MatchService defines the business logic for matches
type MatchService interface {
	// Team operations
	CreateTeam(ctx context.Context, req CreateTeamRequest, userID uuid.UUID) (*Team, error)
	GetTeam(ctx context.Context, teamID uuid.UUID) (*Team, error)
	GetTeamStats(ctx context.Context, teamID uuid.UUID) (*Team, error)
	ListTeams(ctx context.Context, userID *uuid.UUID) (*TeamListResponse, error)
	UpdateTeam(ctx context.Context, teamID uuid.UUID, req CreateTeamRequest, userID uuid.UUID) (*Team, error)
	DeleteTeam(ctx context.Context, teamID uuid.UUID, userID uuid.UUID) error

	// Player operations
	AddPlayer(ctx context.Context, req CreatePlayerRequest, userID uuid.UUID) (*Player, error)
	GetPlayer(ctx context.Context, playerID uuid.UUID) (*Player, error)
	ListTeamPlayers(ctx context.Context, teamID uuid.UUID) (*PlayerListResponse, error)
	ListUserPlayers(ctx context.Context, userID uuid.UUID) (*PlayerListResponse, error)
	RemovePlayer(ctx context.Context, playerID uuid.UUID, userID uuid.UUID) error

	// Match operations
	CreateMatch(ctx context.Context, req CreateMatchRequest, userID uuid.UUID) (*Match, error)
	GetMatch(ctx context.Context, matchID uuid.UUID) (*Match, error)
	ListMatches(ctx context.Context, filters MatchFilters) (*MatchListResponse, error)
	UpdateMatch(ctx context.Context, matchID uuid.UUID, req UpdateMatchRequest, userID uuid.UUID) (*Match, error)
	UpdateMatchStatus(ctx context.Context, matchID uuid.UUID, req UpdateMatchStatusRequest, userID uuid.UUID) (*Match, error)
	DeleteMatch(ctx context.Context, matchID uuid.UUID, userID uuid.UUID) error

	// Squad operations
	AddPlayerToMatchSquad(ctx context.Context, matchID uuid.UUID, req AddSquadPlayerRequest, userID uuid.UUID) (*MatchSquad, error)
	RemovePlayerFromMatchSquad(ctx context.Context, matchID, playerID uuid.UUID, userID uuid.UUID) error
	GetMatchSquad(ctx context.Context, matchID uuid.UUID) ([]MatchSquad, error)
	UpdateSquadPlayer(ctx context.Context, matchID uuid.UUID, req AddSquadPlayerRequest, userID uuid.UUID) (*MatchSquad, error)
}
