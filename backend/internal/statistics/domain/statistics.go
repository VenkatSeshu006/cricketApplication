package domain

import (
	"time"

	"github.com/google/uuid"
)

// PlayerMatchPerformance represents a player's performance in a single match
type PlayerMatchPerformance struct {
	ID                  uuid.UUID  `json:"id"`
	PlayerID            uuid.UUID  `json:"player_id"`
	MatchID             uuid.UUID  `json:"match_id"`
	TeamID              uuid.UUID  `json:"team_id"`
	Played              bool       `json:"played"`
	Captain             bool       `json:"captain"`
	ViceCaptain         bool       `json:"vice_captain"`
	WicketKeeper        bool       `json:"wicket_keeper"`
	BattingPosition     *int       `json:"batting_position,omitempty"`
	RunsScored          int        `json:"runs_scored"`
	BallsFaced          int        `json:"balls_faced"`
	Fours               int        `json:"fours"`
	Sixes               int        `json:"sixes"`
	StrikeRate          float64    `json:"strike_rate"`
	DismissalType       *string    `json:"dismissal_type,omitempty"`
	DismissedByPlayerID *uuid.UUID `json:"dismissed_by_player_id,omitempty"`
	OversBowled         float64    `json:"overs_bowled"`
	RunsConceded        int        `json:"runs_conceded"`
	WicketsTaken        int        `json:"wickets_taken"`
	Maidens             int        `json:"maidens"`
	EconomyRate         float64    `json:"economy_rate"`
	BowlingStrikeRate   float64    `json:"bowling_strike_rate"`
	Catches             int        `json:"catches"`
	RunOuts             int        `json:"run_outs"`
	Stumpings           int        `json:"stumpings"`
	PlayerOfMatch       bool       `json:"player_of_match"`
	CreatedAt           time.Time  `json:"created_at"`
	UpdatedAt           time.Time  `json:"updated_at"`
}

// PlayerCareerStats represents aggregated career statistics for a player
type PlayerCareerStats struct {
	ID                  uuid.UUID `json:"id"`
	PlayerID            uuid.UUID `json:"player_id"`
	TotalMatches        int       `json:"total_matches"`
	TotalInnings        int       `json:"total_innings"`
	MatchesWon          int       `json:"matches_won"`
	MatchesLost         int       `json:"matches_lost"`
	TotalRuns           int       `json:"total_runs"`
	TotalBallsFaced     int       `json:"total_balls_faced"`
	TotalFours          int       `json:"total_fours"`
	TotalSixes          int       `json:"total_sixes"`
	HighestScore        int       `json:"highest_score"`
	BattingAverage      float64   `json:"batting_average"`
	BattingStrikeRate   float64   `json:"batting_strike_rate"`
	Fifties             int       `json:"fifties"`
	Hundreds            int       `json:"hundreds"`
	Ducks               int       `json:"ducks"`
	NotOuts             int       `json:"not_outs"`
	TotalOversBowled    float64   `json:"total_overs_bowled"`
	TotalRunsConceded   int       `json:"total_runs_conceded"`
	TotalWickets        int       `json:"total_wickets"`
	TotalMaidens        int       `json:"total_maidens"`
	BestBowlingFigures  *string   `json:"best_bowling_figures,omitempty"`
	BowlingAverage      float64   `json:"bowling_average"`
	BowlingEconomy      float64   `json:"bowling_economy"`
	BowlingStrikeRate   float64   `json:"bowling_strike_rate"`
	FiveWickets         int       `json:"five_wickets"`
	TotalCatches        int       `json:"total_catches"`
	TotalRunOuts        int       `json:"total_run_outs"`
	TotalStumpings      int       `json:"total_stumpings"`
	PlayerOfMatchAwards int       `json:"player_of_match_awards"`
	UpdatedAt           time.Time `json:"updated_at"`
}

// LeaderboardEntry represents a player's position in a leaderboard
type LeaderboardEntry struct {
	ID        uuid.UUID `json:"id"`
	PlayerID  uuid.UUID `json:"player_id"`
	Category  string    `json:"category"`
	Value     float64   `json:"value"`
	Rank      int       `json:"rank"`
	Season    *string   `json:"season,omitempty"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// RecordPerformanceRequest represents the request to record a player's match performance
type RecordPerformanceRequest struct {
	PlayerID            uuid.UUID  `json:"player_id"`
	MatchID             uuid.UUID  `json:"match_id"`
	TeamID              uuid.UUID  `json:"team_id"`
	Played              bool       `json:"played"`
	Captain             bool       `json:"captain"`
	ViceCaptain         bool       `json:"vice_captain"`
	WicketKeeper        bool       `json:"wicket_keeper"`
	BattingPosition     *int       `json:"batting_position,omitempty"`
	RunsScored          int        `json:"runs_scored"`
	BallsFaced          int        `json:"balls_faced"`
	Fours               int        `json:"fours"`
	Sixes               int        `json:"sixes"`
	DismissalType       *string    `json:"dismissal_type,omitempty"`
	DismissedByPlayerID *uuid.UUID `json:"dismissed_by_player_id,omitempty"`
	OversBowled         float64    `json:"overs_bowled"`
	RunsConceded        int        `json:"runs_conceded"`
	WicketsTaken        int        `json:"wickets_taken"`
	Maidens             int        `json:"maidens"`
	Catches             int        `json:"catches"`
	RunOuts             int        `json:"run_outs"`
	Stumpings           int        `json:"stumpings"`
	PlayerOfMatch       bool       `json:"player_of_match"`
}

// UpdatePerformanceRequest represents the request to update a player's match performance
type UpdatePerformanceRequest struct {
	Played              *bool      `json:"played,omitempty"`
	Captain             *bool      `json:"captain,omitempty"`
	ViceCaptain         *bool      `json:"vice_captain,omitempty"`
	WicketKeeper        *bool      `json:"wicket_keeper,omitempty"`
	BattingPosition     *int       `json:"batting_position,omitempty"`
	RunsScored          *int       `json:"runs_scored,omitempty"`
	BallsFaced          *int       `json:"balls_faced,omitempty"`
	Fours               *int       `json:"fours,omitempty"`
	Sixes               *int       `json:"sixes,omitempty"`
	DismissalType       *string    `json:"dismissal_type,omitempty"`
	DismissedByPlayerID *uuid.UUID `json:"dismissed_by_player_id,omitempty"`
	OversBowled         *float64   `json:"overs_bowled,omitempty"`
	RunsConceded        *int       `json:"runs_conceded,omitempty"`
	WicketsTaken        *int       `json:"wickets_taken,omitempty"`
	Maidens             *int       `json:"maidens,omitempty"`
	Catches             *int       `json:"catches,omitempty"`
	RunOuts             *int       `json:"run_outs,omitempty"`
	Stumpings           *int       `json:"stumpings,omitempty"`
	PlayerOfMatch       *bool      `json:"player_of_match,omitempty"`
}

// PerformanceListResponse represents the response for listing performances
type PerformanceListResponse struct {
	Performances []PlayerMatchPerformance `json:"performances"`
	Total        int                      `json:"total"`
	Page         int                      `json:"page"`
	Limit        int                      `json:"limit"`
}

// LeaderboardResponse represents the response for leaderboard queries
type LeaderboardResponse struct {
	Category string                       `json:"category"`
	Season   string                       `json:"season"`
	Entries  []LeaderboardEntryWithPlayer `json:"entries"`
}

// LeaderboardEntryWithPlayer includes player details in leaderboard entry
type LeaderboardEntryWithPlayer struct {
	LeaderboardEntry
	PlayerName string `json:"player_name"`
	TeamName   string `json:"team_name,omitempty"`
}

// PerformanceFilters represents filters for querying performances
type PerformanceFilters struct {
	PlayerID   *uuid.UUID
	MatchID    *uuid.UUID
	TeamID     *uuid.UUID
	Season     *string
	MinRuns    *int
	MinWickets *int
	Page       int
	Limit      int
}
