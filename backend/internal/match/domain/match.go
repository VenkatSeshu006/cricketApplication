package domain

import (
	"time"

	"github.com/google/uuid"
	"github.com/lib/pq"
)

// Team represents a cricket team
type Team struct {
	ID          uuid.UUID      `json:"id" db:"id"`
	Name        string         `json:"name" db:"name"`
	ShortName   string         `json:"short_name" db:"short_name"`
	LogoURL     *string        `json:"logo_url,omitempty" db:"logo_url"`
	Colors      pq.StringArray `json:"colors" db:"colors"`
	CreatedBy   uuid.UUID      `json:"created_by" db:"created_by"`
	CreatedAt   time.Time      `json:"created_at" db:"created_at"`
	CaptainID   *uuid.UUID     `json:"captain_id,omitempty" db:"captain_id"`
	IsActive    bool           `json:"is_active" db:"is_active"`
	Description *string        `json:"description,omitempty" db:"description"`
	HomeGround  *string        `json:"home_ground,omitempty" db:"home_ground"`

	// Stats (stored as JSONB)
	TotalMatches int `json:"total_matches" db:"-"`
	Wins         int `json:"wins" db:"-"`
	Losses       int `json:"losses" db:"-"`
	Draws        int `json:"draws" db:"-"`
}

// Player represents a cricket player
type Player struct {
	ID           uuid.UUID `json:"id" db:"id"`
	UserID       uuid.UUID `json:"user_id" db:"user_id"`
	TeamID       uuid.UUID `json:"team_id" db:"team_id"`
	JerseyNumber int       `json:"jersey_number" db:"jersey_number"`
	Role         string    `json:"role" db:"role"`                 // batsman, bowler, all-rounder, wicket-keeper
	Batting      string    `json:"batting" db:"batting"`           // right-hand, left-hand
	Bowling      *string   `json:"bowling,omitempty" db:"bowling"` // right-arm-fast, left-arm-spin, etc.
	IsActive     bool      `json:"is_active" db:"is_active"`
	JoinedAt     time.Time `json:"joined_at" db:"joined_at"`

	// Career stats (stored as JSONB)
	MatchesPlayed int `json:"matches_played" db:"-"`
	RunsScored    int `json:"runs_scored" db:"-"`
	WicketsTaken  int `json:"wickets_taken" db:"-"`
	Catches       int `json:"catches" db:"-"`
}

// Match represents a cricket match
type Match struct {
	ID          uuid.UUID `json:"id" db:"id"`
	Title       string    `json:"title" db:"title"`
	MatchType   string    `json:"match_type" db:"match_type"`     // practice, friendly, league, tournament
	MatchFormat string    `json:"match_format" db:"match_format"` // T20, ODI, Test, T10

	// Teams
	TeamAID uuid.UUID `json:"team_a_id" db:"team_a_id"`
	TeamBID uuid.UUID `json:"team_b_id" db:"team_b_id"`

	// Schedule
	MatchDate time.Time `json:"match_date" db:"match_date"`
	MatchTime string    `json:"match_time" db:"match_time"`

	// Venue
	GroundID  *uuid.UUID `json:"ground_id,omitempty" db:"ground_id"`
	VenueName string     `json:"venue_name" db:"venue_name"`
	VenueCity string     `json:"venue_city" db:"venue_city"`

	// Match Settings
	TotalOvers int    `json:"total_overs" db:"total_overs"`
	BallType   string `json:"ball_type" db:"ball_type"` // red, white, pink

	// Toss (stored as JSONB)
	TossWonBy    *uuid.UUID `json:"toss_won_by,omitempty" db:"-"`
	TossDecision *string    `json:"toss_decision,omitempty" db:"-"` // bat, field

	// Officials (stored as JSONB array)
	Umpires []string `json:"umpires,omitempty" db:"-"`
	Scorers []string `json:"scorers,omitempty" db:"-"`

	// Match Status
	Status string `json:"status" db:"status"` // upcoming, live, completed, cancelled

	// Result (stored as JSONB)
	WinnerTeamID *uuid.UUID `json:"winner_team_id,omitempty" db:"-"`
	WinMargin    *string    `json:"win_margin,omitempty" db:"-"`  // "5 wickets", "50 runs"
	ResultType   *string    `json:"result_type,omitempty" db:"-"` // normal, tie, no-result, abandoned

	// Management
	CreatedBy   uuid.UUID `json:"created_by" db:"created_by"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
	Description *string   `json:"description,omitempty" db:"description"`
}

// MatchSquad represents a player in a match squad
type MatchSquad struct {
	ID             uuid.UUID `json:"id" db:"id"`
	MatchID        uuid.UUID `json:"match_id" db:"match_id"`
	PlayerID       uuid.UUID `json:"player_id" db:"player_id"`
	TeamID         uuid.UUID `json:"team_id" db:"team_id"`
	InPlaying11    bool      `json:"in_playing_11" db:"in_playing_11"`
	IsCaptain      bool      `json:"is_captain" db:"is_captain"`
	IsViceCaptain  bool      `json:"is_vice_captain" db:"is_vice_captain"`
	IsWicketKeeper bool      `json:"is_wicket_keeper" db:"is_wicket_keeper"`
	AddedAt        time.Time `json:"added_at" db:"added_at"`
}

// CreateTeamRequest is the request for creating a team
type CreateTeamRequest struct {
	Name        string   `json:"name"`
	ShortName   string   `json:"short_name"`
	LogoURL     *string  `json:"logo_url,omitempty"`
	Colors      []string `json:"colors"`
	Description *string  `json:"description,omitempty"`
	HomeGround  *string  `json:"home_ground,omitempty"`
}

// CreatePlayerRequest is the request for adding a player to a team
type CreatePlayerRequest struct {
	UserID       uuid.UUID `json:"user_id"`
	TeamID       uuid.UUID `json:"team_id"`
	JerseyNumber int       `json:"jersey_number"`
	Role         string    `json:"role"`
	Batting      string    `json:"batting"`
	Bowling      *string   `json:"bowling,omitempty"`
}

// CreateMatchRequest is the request for creating a match
type CreateMatchRequest struct {
	Title       string     `json:"title"`
	MatchType   string     `json:"match_type"`
	MatchFormat string     `json:"match_format"`
	TeamAID     uuid.UUID  `json:"team_a_id"`
	TeamBID     uuid.UUID  `json:"team_b_id"`
	MatchDate   time.Time  `json:"match_date"`
	MatchTime   string     `json:"match_time"`
	GroundID    *uuid.UUID `json:"ground_id,omitempty"`
	VenueName   string     `json:"venue_name"`
	VenueCity   string     `json:"venue_city"`
	TotalOvers  int        `json:"total_overs"`
	BallType    string     `json:"ball_type"`
	Description *string    `json:"description,omitempty"`
}

// UpdateMatchRequest is the request for updating a match
type UpdateMatchRequest struct {
	Title       *string    `json:"title,omitempty"`
	MatchDate   *time.Time `json:"match_date,omitempty"`
	MatchTime   *string    `json:"match_time,omitempty"`
	VenueName   *string    `json:"venue_name,omitempty"`
	VenueCity   *string    `json:"venue_city,omitempty"`
	TotalOvers  *int       `json:"total_overs,omitempty"`
	Description *string    `json:"description,omitempty"`
}

// UpdateMatchStatusRequest updates match status and result
type UpdateMatchStatusRequest struct {
	Status       string     `json:"status"`
	TossWonBy    *uuid.UUID `json:"toss_won_by,omitempty"`
	TossDecision *string    `json:"toss_decision,omitempty"`
	WinnerTeamID *uuid.UUID `json:"winner_team_id,omitempty"`
	WinMargin    *string    `json:"win_margin,omitempty"`
	ResultType   *string    `json:"result_type,omitempty"`
}

// AddSquadPlayerRequest adds a player to match squad
type AddSquadPlayerRequest struct {
	PlayerID       uuid.UUID `json:"player_id"`
	TeamID         uuid.UUID `json:"team_id"`
	InPlaying11    bool      `json:"in_playing_11"`
	IsCaptain      bool      `json:"is_captain"`
	IsViceCaptain  bool      `json:"is_vice_captain"`
	IsWicketKeeper bool      `json:"is_wicket_keeper"`
}

// MatchListResponse contains a list of matches with pagination
type MatchListResponse struct {
	Matches []Match `json:"matches"`
	Total   int     `json:"total"`
	Page    int     `json:"page"`
	Limit   int     `json:"limit"`
}

// TeamListResponse contains a list of teams
type TeamListResponse struct {
	Teams []Team `json:"teams"`
	Total int    `json:"total"`
}

// PlayerListResponse contains a list of players
type PlayerListResponse struct {
	Players []Player `json:"players"`
	Total   int      `json:"total"`
}
