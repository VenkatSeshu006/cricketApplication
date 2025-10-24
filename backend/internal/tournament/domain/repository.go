package domain

import (
	"context"

	"github.com/google/uuid"
)

// TournamentRepository defines data access methods for tournaments
type TournamentRepository interface {
	// Tournament operations
	CreateTournament(ctx context.Context, tournament *Tournament) error
	GetTournamentByID(ctx context.Context, tournamentID uuid.UUID) (*Tournament, error)
	ListTournaments(ctx context.Context, filters TournamentFilters) ([]Tournament, int, error)
	UpdateTournament(ctx context.Context, tournamentID uuid.UUID, tournament *Tournament) error
	DeleteTournament(ctx context.Context, tournamentID uuid.UUID) error
	UpdateTournamentStatus(ctx context.Context, tournamentID uuid.UUID, status string) error

	// Registration operations
	RegisterTeam(ctx context.Context, registration *TournamentRegistration) error
	GetRegistration(ctx context.Context, tournamentID, teamID uuid.UUID) (*TournamentRegistration, error)
	ListRegistrations(ctx context.Context, tournamentID uuid.UUID, status *string) ([]TournamentRegistration, error)
	UpdateRegistrationStatus(ctx context.Context, registrationID uuid.UUID, status string, approvedBy uuid.UUID, rejectionReason *string) error
	WithdrawRegistration(ctx context.Context, registrationID uuid.UUID) error
	GetRegistrationCount(ctx context.Context, tournamentID uuid.UUID, status *string) (int, error)

	// Standings operations
	CreateOrUpdateStanding(ctx context.Context, standing *TournamentStanding) error
	GetStandings(ctx context.Context, tournamentID uuid.UUID, groupName *string) ([]TournamentStanding, error)
	GetTeamStanding(ctx context.Context, tournamentID, teamID uuid.UUID) (*TournamentStanding, error)
	RecalculateStandings(ctx context.Context, tournamentID uuid.UUID) error

	// Tournament match operations
	LinkMatchToTournament(ctx context.Context, tournamentMatch *TournamentMatch) error
	GetTournamentMatches(ctx context.Context, tournamentID uuid.UUID, roundNumber *int, groupName *string) ([]TournamentMatch, error)
	GetTournamentMatch(ctx context.Context, tournamentID, matchID uuid.UUID) (*TournamentMatch, error)
	UpdateTournamentMatch(ctx context.Context, tournamentMatchID uuid.UUID, tournamentMatch *TournamentMatch) error
}

// TournamentFilters for filtering tournaments
type TournamentFilters struct {
	Status         *string
	TournamentType *string
	OrganizerID    *uuid.UUID
	StartDateFrom  *string
	StartDateTo    *string
	Page           int
	Limit          int
}
