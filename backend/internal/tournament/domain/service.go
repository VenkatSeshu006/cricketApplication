package domain

import (
	"context"

	"github.com/google/uuid"
)

// TournamentService defines business logic for tournaments
type TournamentService interface {
	// Tournament operations
	CreateTournament(ctx context.Context, req CreateTournamentRequest, organizerID uuid.UUID) (*Tournament, error)
	GetTournament(ctx context.Context, tournamentID uuid.UUID) (*Tournament, error)
	ListTournaments(ctx context.Context, filters TournamentFilters) (*TournamentListResponse, error)
	UpdateTournament(ctx context.Context, tournamentID uuid.UUID, req UpdateTournamentRequest, userID uuid.UUID) (*Tournament, error)
	DeleteTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error

	// Tournament status management
	OpenRegistration(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error
	CloseRegistration(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error
	StartTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error
	CompleteTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error
	CancelTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error

	// Registration operations
	RegisterTeam(ctx context.Context, tournamentID uuid.UUID, req RegisterTeamRequest, userID uuid.UUID) (*TournamentRegistration, error)
	GetRegistration(ctx context.Context, tournamentID, teamID uuid.UUID) (*TournamentRegistration, error)
	ListRegistrations(ctx context.Context, tournamentID uuid.UUID, status *string) (*RegistrationListResponse, error)
	ApproveRegistration(ctx context.Context, registrationID uuid.UUID, userID uuid.UUID) error
	RejectRegistration(ctx context.Context, registrationID uuid.UUID, reason string, userID uuid.UUID) error
	WithdrawRegistration(ctx context.Context, tournamentID, teamID uuid.UUID, userID uuid.UUID) error

	// Standings operations
	GetStandings(ctx context.Context, tournamentID uuid.UUID, groupName *string) (*StandingsResponse, error)
	RefreshStandings(ctx context.Context, tournamentID uuid.UUID) error

	// Tournament match operations
	GetTournamentMatches(ctx context.Context, tournamentID uuid.UUID, roundNumber *int, groupName *string) (*TournamentMatchesResponse, error)
	ScheduleMatch(ctx context.Context, tournamentID uuid.UUID, matchID uuid.UUID, roundNumber int, roundName, groupName *string) error
}
