package domain

import (
	"context"
	"time"

	"github.com/google/uuid"
)

// MatchRepository defines the interface for match data access
type MatchRepository interface {
	// Team operations
	CreateTeam(ctx context.Context, team *Team) error
	GetTeamByID(ctx context.Context, teamID uuid.UUID) (*Team, error)
	GetTeamByName(ctx context.Context, name string) (*Team, error)
	GetTeamStats(ctx context.Context, teamID uuid.UUID) (*Team, error)
	ListTeams(ctx context.Context, createdBy *uuid.UUID) ([]Team, error)
	UpdateTeam(ctx context.Context, team *Team) error
	DeleteTeam(ctx context.Context, teamID uuid.UUID) error

	// Player operations
	AddPlayerToTeam(ctx context.Context, player *Player) error
	GetPlayerByID(ctx context.Context, playerID uuid.UUID) (*Player, error)
	ListPlayersByTeam(ctx context.Context, teamID uuid.UUID) ([]Player, error)
	ListPlayersByUser(ctx context.Context, userID uuid.UUID) ([]Player, error)
	UpdatePlayer(ctx context.Context, player *Player) error
	RemovePlayerFromTeam(ctx context.Context, playerID uuid.UUID) error

	// Match operations
	CreateMatch(ctx context.Context, match *Match) error
	GetMatchByID(ctx context.Context, matchID uuid.UUID) (*Match, error)
	ListMatches(ctx context.Context, filters MatchFilters) ([]Match, int, error)
	UpdateMatch(ctx context.Context, match *Match) error
	UpdateMatchStatus(ctx context.Context, matchID uuid.UUID, status string, result map[string]interface{}) error
	DeleteMatch(ctx context.Context, matchID uuid.UUID) error

	// Squad operations
	AddPlayerToSquad(ctx context.Context, squad *MatchSquad) error
	RemovePlayerFromSquad(ctx context.Context, matchID, playerID uuid.UUID) error
	GetMatchSquad(ctx context.Context, matchID uuid.UUID) ([]MatchSquad, error)
	GetTeamSquad(ctx context.Context, matchID, teamID uuid.UUID) ([]MatchSquad, error)
	UpdateSquadPlayer(ctx context.Context, squad *MatchSquad) error
}

// MatchFilters contains filters for listing matches
type MatchFilters struct {
	Status      *string
	MatchType   *string
	MatchFormat *string
	TeamID      *uuid.UUID
	CreatedBy   *uuid.UUID
	FromDate    *time.Time
	ToDate      *time.Time
	Page        int
	Limit       int
}
