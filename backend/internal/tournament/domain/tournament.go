package domain

import (
	"time"

	"github.com/google/uuid"
)

// Tournament represents a cricket tournament
type Tournament struct {
	ID          uuid.UUID `json:"id" db:"id"`
	Name        string    `json:"name" db:"name"`
	ShortName   *string   `json:"short_name,omitempty" db:"short_name"`
	Description *string   `json:"description,omitempty" db:"description"`

	// Tournament type and settings
	TournamentType string `json:"tournament_type" db:"tournament_type"` // knockout, round_robin, league, mixed
	MatchFormat    string `json:"match_format" db:"match_format"`       // T10, T20, ODI, Test

	// Dates
	StartDate            time.Time `json:"start_date" db:"start_date"`
	EndDate              time.Time `json:"end_date" db:"end_date"`
	RegistrationDeadline time.Time `json:"registration_deadline" db:"registration_deadline"`

	// Settings
	MaxTeams  int     `json:"max_teams" db:"max_teams"`
	MinTeams  int     `json:"min_teams" db:"min_teams"`
	EntryFee  float64 `json:"entry_fee" db:"entry_fee"`
	PrizePool float64 `json:"prize_pool" db:"prize_pool"`

	// Rules (JSONB)
	Rules map[string]interface{} `json:"rules,omitempty" db:"-"`

	// Status
	Status string `json:"status" db:"status"` // upcoming, registration_open, registration_closed, ongoing, completed, cancelled

	// Venue
	VenueName *string    `json:"venue_name,omitempty" db:"venue_name"`
	VenueCity *string    `json:"venue_city,omitempty" db:"venue_city"`
	GroundID  *uuid.UUID `json:"ground_id,omitempty" db:"ground_id"`

	// Organizer info
	OrganizerID uuid.UUID `json:"organizer_id" db:"organizer_id"`
	LogoURL     *string   `json:"logo_url,omitempty" db:"logo_url"`
	BannerURL   *string   `json:"banner_url,omitempty" db:"banner_url"`

	// Timestamps
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// TournamentRegistration represents a team's registration in a tournament
type TournamentRegistration struct {
	ID           uuid.UUID `json:"id" db:"id"`
	TournamentID uuid.UUID `json:"tournament_id" db:"tournament_id"`
	TeamID       uuid.UUID `json:"team_id" db:"team_id"`

	// Registration info
	RegistrationDate time.Time `json:"registration_date" db:"registration_date"`
	Status           string    `json:"status" db:"status"`                 // pending, approved, rejected, withdrawn
	PaymentStatus    string    `json:"payment_status" db:"payment_status"` // pending, paid, refunded

	// Team details
	CaptainID *uuid.UUID `json:"captain_id,omitempty" db:"captain_id"`
	SquadSize int        `json:"squad_size" db:"squad_size"`

	// Approval
	ApprovedBy      *uuid.UUID `json:"approved_by,omitempty" db:"approved_by"`
	ApprovedAt      *time.Time `json:"approved_at,omitempty" db:"approved_at"`
	RejectionReason *string    `json:"rejection_reason,omitempty" db:"rejection_reason"`

	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// TournamentStanding represents a team's standing in a tournament
type TournamentStanding struct {
	ID           uuid.UUID `json:"id" db:"id"`
	TournamentID uuid.UUID `json:"tournament_id" db:"tournament_id"`
	TeamID       uuid.UUID `json:"team_id" db:"team_id"`

	// Standings data
	Position         int `json:"position" db:"position"`
	MatchesPlayed    int `json:"matches_played" db:"matches_played"`
	MatchesWon       int `json:"matches_won" db:"matches_won"`
	MatchesLost      int `json:"matches_lost" db:"matches_lost"`
	MatchesDrawn     int `json:"matches_drawn" db:"matches_drawn"`
	MatchesAbandoned int `json:"matches_abandoned" db:"matches_abandoned"`

	// Points
	Points     int     `json:"points" db:"points"`
	NetRunRate float64 `json:"net_run_rate" db:"net_run_rate"`

	// Batting/Bowling stats
	RunsScored   int `json:"runs_scored" db:"runs_scored"`
	RunsConceded int `json:"runs_conceded" db:"runs_conceded"`
	WicketsTaken int `json:"wickets_taken" db:"wickets_taken"`
	WicketsLost  int `json:"wickets_lost" db:"wickets_lost"`

	// Additional stats (JSONB)
	Stats map[string]interface{} `json:"stats,omitempty" db:"-"`

	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// TournamentMatch links a match to a tournament
type TournamentMatch struct {
	ID           uuid.UUID `json:"id" db:"id"`
	TournamentID uuid.UUID `json:"tournament_id" db:"tournament_id"`
	MatchID      uuid.UUID `json:"match_id" db:"match_id"`

	// Match info in tournament
	RoundNumber int     `json:"round_number" db:"round_number"`
	MatchNumber *int    `json:"match_number,omitempty" db:"match_number"`
	RoundName   *string `json:"round_name,omitempty" db:"round_name"`

	// Bracket info (for knockout)
	BracketPosition *int       `json:"bracket_position,omitempty" db:"bracket_position"`
	NextMatchID     *uuid.UUID `json:"next_match_id,omitempty" db:"next_match_id"`

	// Group info (for round robin/league)
	GroupName *string `json:"group_name,omitempty" db:"group_name"`

	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

// DTOs for API

type CreateTournamentRequest struct {
	Name                 string                 `json:"name" binding:"required"`
	ShortName            *string                `json:"short_name,omitempty"`
	Description          *string                `json:"description,omitempty"`
	TournamentType       string                 `json:"tournament_type" binding:"required"` // knockout, round_robin, league, mixed
	MatchFormat          string                 `json:"match_format" binding:"required"`    // T10, T20, ODI, Test
	StartDate            time.Time              `json:"start_date" binding:"required"`
	EndDate              time.Time              `json:"end_date" binding:"required"`
	RegistrationDeadline time.Time              `json:"registration_deadline" binding:"required"`
	MaxTeams             int                    `json:"max_teams" binding:"required,min=2"`
	MinTeams             int                    `json:"min_teams" binding:"required,min=2"`
	EntryFee             float64                `json:"entry_fee"`
	PrizePool            float64                `json:"prize_pool"`
	Rules                map[string]interface{} `json:"rules,omitempty"`
	VenueName            *string                `json:"venue_name,omitempty"`
	VenueCity            *string                `json:"venue_city,omitempty"`
	GroundID             *uuid.UUID             `json:"ground_id,omitempty"`
	LogoURL              *string                `json:"logo_url,omitempty"`
	BannerURL            *string                `json:"banner_url,omitempty"`
}

type UpdateTournamentRequest struct {
	Name                 *string                `json:"name,omitempty"`
	ShortName            *string                `json:"short_name,omitempty"`
	Description          *string                `json:"description,omitempty"`
	StartDate            *time.Time             `json:"start_date,omitempty"`
	EndDate              *time.Time             `json:"end_date,omitempty"`
	RegistrationDeadline *time.Time             `json:"registration_deadline,omitempty"`
	MaxTeams             *int                   `json:"max_teams,omitempty"`
	EntryFee             *float64               `json:"entry_fee,omitempty"`
	PrizePool            *float64               `json:"prize_pool,omitempty"`
	Rules                map[string]interface{} `json:"rules,omitempty"`
	VenueName            *string                `json:"venue_name,omitempty"`
	VenueCity            *string                `json:"venue_city,omitempty"`
	LogoURL              *string                `json:"logo_url,omitempty"`
	BannerURL            *string                `json:"banner_url,omitempty"`
}

type RegisterTeamRequest struct {
	TeamID    uuid.UUID  `json:"team_id" binding:"required"`
	CaptainID *uuid.UUID `json:"captain_id,omitempty"`
	SquadSize int        `json:"squad_size" binding:"min=11"`
}

type UpdateRegistrationStatusRequest struct {
	Status          string  `json:"status" binding:"required,oneof=approved rejected"`
	RejectionReason *string `json:"rejection_reason,omitempty"`
}

type TournamentListResponse struct {
	Tournaments []Tournament `json:"tournaments"`
	Total       int          `json:"total"`
}

type RegistrationListResponse struct {
	Registrations []TournamentRegistration `json:"registrations"`
	Total         int                      `json:"total"`
}

type StandingsResponse struct {
	Standings []TournamentStanding `json:"standings"`
	Total     int                  `json:"total"`
}

type TournamentMatchesResponse struct {
	Matches []TournamentMatch `json:"matches"`
	Total   int               `json:"total"`
}
