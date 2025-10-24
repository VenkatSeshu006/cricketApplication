package postgres

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/cricketapp/backend/internal/match/domain"
	"github.com/google/uuid"
	"github.com/lib/pq"
)

type matchRepository struct {
	db *sql.DB
}

// NewMatchRepository creates a new match repository
func NewMatchRepository(db *sql.DB) domain.MatchRepository {
	return &matchRepository{db: db}
}

// Team operations

func (r *matchRepository) CreateTeam(ctx context.Context, team *domain.Team) error {
	query := `
		INSERT INTO teams (id, name, short_name, logo_url, colors, created_by, captain_id, description, home_ground)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
	`
	_, err := r.db.ExecContext(ctx, query,
		team.ID, team.Name, team.ShortName, team.LogoURL, pq.Array(team.Colors),
		team.CreatedBy, team.CaptainID, team.Description, team.HomeGround,
	)
	return err
}

func (r *matchRepository) GetTeamByID(ctx context.Context, teamID uuid.UUID) (*domain.Team, error) {
	query := `
		SELECT id, name, short_name, logo_url, colors, created_by, created_at, 
		       captain_id, is_active, description, home_ground,
		       COALESCE((stats->>'total_matches')::int, 0) as total_matches,
		       COALESCE((stats->>'wins')::int, 0) as wins,
		       COALESCE((stats->>'losses')::int, 0) as losses,
		       COALESCE((stats->>'draws')::int, 0) as draws
		FROM teams
		WHERE id = $1
	`
	team := &domain.Team{}
	var colors pq.StringArray

	err := r.db.QueryRowContext(ctx, query, teamID).Scan(
		&team.ID, &team.Name, &team.ShortName, &team.LogoURL, &colors,
		&team.CreatedBy, &team.CreatedAt, &team.CaptainID, &team.IsActive,
		&team.Description, &team.HomeGround,
		&team.TotalMatches, &team.Wins, &team.Losses, &team.Draws,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("team not found")
	}
	if err != nil {
		return nil, err
	}

	team.Colors = colors
	return team, nil
}

func (r *matchRepository) GetTeamByName(ctx context.Context, name string) (*domain.Team, error) {
	query := `
		SELECT id, name, short_name, logo_url, colors, created_by, created_at, 
		       captain_id, is_active, description, home_ground,
		       COALESCE((stats->>'total_matches')::int, 0) as total_matches,
		       COALESCE((stats->>'wins')::int, 0) as wins,
		       COALESCE((stats->>'losses')::int, 0) as losses,
		       COALESCE((stats->>'draws')::int, 0) as draws
		FROM teams
		WHERE name = $1
	`
	team := &domain.Team{}
	var colors pq.StringArray

	err := r.db.QueryRowContext(ctx, query, name).Scan(
		&team.ID, &team.Name, &team.ShortName, &team.LogoURL, &colors,
		&team.CreatedBy, &team.CreatedAt, &team.CaptainID, &team.IsActive,
		&team.Description, &team.HomeGround,
		&team.TotalMatches, &team.Wins, &team.Losses, &team.Draws,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("team not found")
	}
	if err != nil {
		return nil, err
	}

	team.Colors = colors
	return team, nil
}

func (r *matchRepository) GetTeamStats(ctx context.Context, teamID uuid.UUID) (*domain.Team, error) {
	// First get the team basic info
	team, err := r.GetTeamByID(ctx, teamID)
	if err != nil {
		return nil, err
	}

	// Calculate stats from matches
	statsQuery := `
		SELECT 
			COUNT(*) as total_matches,
			COUNT(CASE WHEN (result->>'winner_team_id')::uuid = $1 THEN 1 END) as wins,
			COUNT(CASE WHEN result->>'winner_team_id' IS NOT NULL AND (result->>'winner_team_id')::uuid != $1 THEN 1 END) as losses,
			COUNT(CASE WHEN result->>'result_type' IN ('tie', 'no-result') THEN 1 END) as draws
		FROM matches
		WHERE (team_a_id = $1 OR team_b_id = $1) AND status = 'completed'
	`

	err = r.db.QueryRowContext(ctx, statsQuery, teamID).Scan(
		&team.TotalMatches,
		&team.Wins,
		&team.Losses,
		&team.Draws,
	)

	if err != nil && err != sql.ErrNoRows {
		return nil, err
	}

	return team, nil
}

func (r *matchRepository) ListTeams(ctx context.Context, createdBy *uuid.UUID) ([]domain.Team, error) {
	query := `
		SELECT id, name, short_name, logo_url, colors, created_by, created_at, 
		       captain_id, is_active, description, home_ground,
		       COALESCE((stats->>'total_matches')::int, 0) as total_matches,
		       COALESCE((stats->>'wins')::int, 0) as wins,
		       COALESCE((stats->>'losses')::int, 0) as losses,
		       COALESCE((stats->>'draws')::int, 0) as draws
		FROM teams
		WHERE ($1::uuid IS NULL OR created_by = $1)
		AND is_active = true
		ORDER BY created_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, createdBy)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var teams []domain.Team
	for rows.Next() {
		var team domain.Team
		var colors pq.StringArray

		err := rows.Scan(
			&team.ID, &team.Name, &team.ShortName, &team.LogoURL, &colors,
			&team.CreatedBy, &team.CreatedAt, &team.CaptainID, &team.IsActive,
			&team.Description, &team.HomeGround,
			&team.TotalMatches, &team.Wins, &team.Losses, &team.Draws,
		)
		if err != nil {
			return nil, err
		}

		team.Colors = colors
		teams = append(teams, team)
	}

	return teams, rows.Err()
}

func (r *matchRepository) UpdateTeam(ctx context.Context, team *domain.Team) error {
	query := `
		UPDATE teams 
		SET name = $1, short_name = $2, logo_url = $3, colors = $4,
		    captain_id = $5, description = $6, home_ground = $7
		WHERE id = $8
	`
	_, err := r.db.ExecContext(ctx, query,
		team.Name, team.ShortName, team.LogoURL, pq.Array(team.Colors),
		team.CaptainID, team.Description, team.HomeGround, team.ID,
	)
	return err
}

func (r *matchRepository) DeleteTeam(ctx context.Context, teamID uuid.UUID) error {
	query := `UPDATE teams SET is_active = false WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, teamID)
	return err
}

// Player operations

func (r *matchRepository) AddPlayerToTeam(ctx context.Context, player *domain.Player) error {
	query := `
		INSERT INTO players (id, user_id, team_id, jersey_number, role, batting, bowling)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
	`
	_, err := r.db.ExecContext(ctx, query,
		player.ID, player.UserID, player.TeamID, player.JerseyNumber,
		player.Role, player.Batting, player.Bowling,
	)
	return err
}

func (r *matchRepository) GetPlayerByID(ctx context.Context, playerID uuid.UUID) (*domain.Player, error) {
	query := `
		SELECT id, user_id, team_id, jersey_number, role, batting, bowling, 
		       is_active, joined_at,
		       COALESCE((career_stats->>'matches_played')::int, 0) as matches_played,
		       COALESCE((career_stats->>'runs_scored')::int, 0) as runs_scored,
		       COALESCE((career_stats->>'wickets_taken')::int, 0) as wickets_taken,
		       COALESCE((career_stats->>'catches')::int, 0) as catches
		FROM players
		WHERE id = $1
	`
	player := &domain.Player{}

	err := r.db.QueryRowContext(ctx, query, playerID).Scan(
		&player.ID, &player.UserID, &player.TeamID, &player.JerseyNumber,
		&player.Role, &player.Batting, &player.Bowling, &player.IsActive, &player.JoinedAt,
		&player.MatchesPlayed, &player.RunsScored, &player.WicketsTaken, &player.Catches,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("player not found")
	}
	return player, err
}

func (r *matchRepository) ListPlayersByTeam(ctx context.Context, teamID uuid.UUID) ([]domain.Player, error) {
	query := `
		SELECT id, user_id, team_id, jersey_number, role, batting, bowling, 
		       is_active, joined_at,
		       COALESCE((career_stats->>'matches_played')::int, 0) as matches_played,
		       COALESCE((career_stats->>'runs_scored')::int, 0) as runs_scored,
		       COALESCE((career_stats->>'wickets_taken')::int, 0) as wickets_taken,
		       COALESCE((career_stats->>'catches')::int, 0) as catches
		FROM players
		WHERE team_id = $1 AND is_active = true
		ORDER BY jersey_number
	`

	rows, err := r.db.QueryContext(ctx, query, teamID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var players []domain.Player
	for rows.Next() {
		var player domain.Player
		err := rows.Scan(
			&player.ID, &player.UserID, &player.TeamID, &player.JerseyNumber,
			&player.Role, &player.Batting, &player.Bowling, &player.IsActive, &player.JoinedAt,
			&player.MatchesPlayed, &player.RunsScored, &player.WicketsTaken, &player.Catches,
		)
		if err != nil {
			return nil, err
		}
		players = append(players, player)
	}

	return players, rows.Err()
}

func (r *matchRepository) ListPlayersByUser(ctx context.Context, userID uuid.UUID) ([]domain.Player, error) {
	query := `
		SELECT id, user_id, team_id, jersey_number, role, batting, bowling, 
		       is_active, joined_at,
		       COALESCE((career_stats->>'matches_played')::int, 0) as matches_played,
		       COALESCE((career_stats->>'runs_scored')::int, 0) as runs_scored,
		       COALESCE((career_stats->>'wickets_taken')::int, 0) as wickets_taken,
		       COALESCE((career_stats->>'catches')::int, 0) as catches
		FROM players
		WHERE user_id = $1 AND is_active = true
		ORDER BY joined_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var players []domain.Player
	for rows.Next() {
		var player domain.Player
		err := rows.Scan(
			&player.ID, &player.UserID, &player.TeamID, &player.JerseyNumber,
			&player.Role, &player.Batting, &player.Bowling, &player.IsActive, &player.JoinedAt,
			&player.MatchesPlayed, &player.RunsScored, &player.WicketsTaken, &player.Catches,
		)
		if err != nil {
			return nil, err
		}
		players = append(players, player)
	}

	return players, rows.Err()
}

func (r *matchRepository) UpdatePlayer(ctx context.Context, player *domain.Player) error {
	query := `
		UPDATE players 
		SET jersey_number = $1, role = $2, batting = $3, bowling = $4
		WHERE id = $5
	`
	_, err := r.db.ExecContext(ctx, query,
		player.JerseyNumber, player.Role, player.Batting, player.Bowling, player.ID,
	)
	return err
}

func (r *matchRepository) RemovePlayerFromTeam(ctx context.Context, playerID uuid.UUID) error {
	query := `UPDATE players SET is_active = false WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, playerID)
	return err
}

// Match operations

func (r *matchRepository) CreateMatch(ctx context.Context, match *domain.Match) error {
	// Prepare JSONB fields
	toss := map[string]interface{}{}
	if match.TossWonBy != nil {
		toss["won_by"] = match.TossWonBy.String()
		toss["decision"] = match.TossDecision
	}
	tossJSON, _ := json.Marshal(toss)

	officials := map[string]interface{}{
		"umpires": match.Umpires,
		"scorers": match.Scorers,
	}
	officialsJSON, _ := json.Marshal(officials)

	result := map[string]interface{}{}
	resultJSON, _ := json.Marshal(result)

	query := `
		INSERT INTO matches (
			id, title, match_type, match_format, team_a_id, team_b_id,
			match_date, match_time, ground_id, venue_name, venue_city,
			total_overs, ball_type, toss, officials, status, result,
			created_by, description
		)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19)
	`

	_, err := r.db.ExecContext(ctx, query,
		match.ID, match.Title, match.MatchType, match.MatchFormat,
		match.TeamAID, match.TeamBID, match.MatchDate, match.MatchTime,
		match.GroundID, match.VenueName, match.VenueCity,
		match.TotalOvers, match.BallType, tossJSON, officialsJSON,
		match.Status, resultJSON, match.CreatedBy, match.Description,
	)

	return err
}

func (r *matchRepository) GetMatchByID(ctx context.Context, matchID uuid.UUID) (*domain.Match, error) {
	query := `
		SELECT id, title, match_type, match_format, team_a_id, team_b_id,
		       match_date, match_time, ground_id, venue_name, venue_city,
		       total_overs, ball_type, toss, officials, status, result,
		       created_by, created_at, updated_at, description
		FROM matches
		WHERE id = $1
	`

	match := &domain.Match{}
	var tossJSON, officialsJSON, resultJSON []byte

	err := r.db.QueryRowContext(ctx, query, matchID).Scan(
		&match.ID, &match.Title, &match.MatchType, &match.MatchFormat,
		&match.TeamAID, &match.TeamBID, &match.MatchDate, &match.MatchTime,
		&match.GroundID, &match.VenueName, &match.VenueCity,
		&match.TotalOvers, &match.BallType, &tossJSON, &officialsJSON,
		&match.Status, &resultJSON, &match.CreatedBy,
		&match.CreatedAt, &match.UpdatedAt, &match.Description,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("match not found")
	}
	if err != nil {
		return nil, err
	}

	// Parse JSONB fields
	var toss map[string]interface{}
	json.Unmarshal(tossJSON, &toss)
	if wonBy, ok := toss["won_by"].(string); ok {
		id, _ := uuid.Parse(wonBy)
		match.TossWonBy = &id
	}
	if decision, ok := toss["decision"].(string); ok {
		match.TossDecision = &decision
	}

	var officials map[string]interface{}
	json.Unmarshal(officialsJSON, &officials)
	if umpires, ok := officials["umpires"].([]interface{}); ok {
		for _, u := range umpires {
			if str, ok := u.(string); ok {
				match.Umpires = append(match.Umpires, str)
			}
		}
	}
	if scorers, ok := officials["scorers"].([]interface{}); ok {
		for _, s := range scorers {
			if str, ok := s.(string); ok {
				match.Scorers = append(match.Scorers, str)
			}
		}
	}

	var result map[string]interface{}
	json.Unmarshal(resultJSON, &result)
	if winnerID, ok := result["winner_team_id"].(string); ok {
		id, _ := uuid.Parse(winnerID)
		match.WinnerTeamID = &id
	}
	if margin, ok := result["win_margin"].(string); ok {
		match.WinMargin = &margin
	}
	if resType, ok := result["result_type"].(string); ok {
		match.ResultType = &resType
	}

	return match, nil
}

func (r *matchRepository) ListMatches(ctx context.Context, filters domain.MatchFilters) ([]domain.Match, int, error) {
	// Build WHERE clause
	var conditions []string
	var args []interface{}
	argCount := 1

	if filters.Status != nil {
		conditions = append(conditions, fmt.Sprintf("status = $%d", argCount))
		args = append(args, *filters.Status)
		argCount++
	}

	if filters.MatchType != nil {
		conditions = append(conditions, fmt.Sprintf("match_type = $%d", argCount))
		args = append(args, *filters.MatchType)
		argCount++
	}

	if filters.MatchFormat != nil {
		conditions = append(conditions, fmt.Sprintf("match_format = $%d", argCount))
		args = append(args, *filters.MatchFormat)
		argCount++
	}

	if filters.TeamID != nil {
		conditions = append(conditions, fmt.Sprintf("(team_a_id = $%d OR team_b_id = $%d)", argCount, argCount))
		args = append(args, *filters.TeamID)
		argCount++
	}

	if filters.CreatedBy != nil {
		conditions = append(conditions, fmt.Sprintf("created_by = $%d", argCount))
		args = append(args, *filters.CreatedBy)
		argCount++
	}

	if filters.FromDate != nil {
		conditions = append(conditions, fmt.Sprintf("match_date >= $%d", argCount))
		args = append(args, *filters.FromDate)
		argCount++
	}

	if filters.ToDate != nil {
		conditions = append(conditions, fmt.Sprintf("match_date <= $%d", argCount))
		args = append(args, *filters.ToDate)
		argCount++
	}

	whereClause := ""
	if len(conditions) > 0 {
		whereClause = "WHERE " + strings.Join(conditions, " AND ")
	}

	// Count total
	countQuery := fmt.Sprintf("SELECT COUNT(*) FROM matches %s", whereClause)
	var total int
	err := r.db.QueryRowContext(ctx, countQuery, args...).Scan(&total)
	if err != nil {
		return nil, 0, err
	}

	// Get matches with pagination
	if filters.Limit == 0 {
		filters.Limit = 20
	}
	offset := (filters.Page - 1) * filters.Limit

	query := fmt.Sprintf(`
		SELECT id, title, match_type, match_format, team_a_id, team_b_id,
		       match_date, match_time, ground_id, venue_name, venue_city,
		       total_overs, ball_type, toss, officials, status, result,
		       created_by, created_at, updated_at, description
		FROM matches
		%s
		ORDER BY match_date DESC, match_time DESC
		LIMIT $%d OFFSET $%d
	`, whereClause, argCount, argCount+1)

	args = append(args, filters.Limit, offset)

	rows, err := r.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var matches []domain.Match
	for rows.Next() {
		var match domain.Match
		var tossJSON, officialsJSON, resultJSON []byte

		err := rows.Scan(
			&match.ID, &match.Title, &match.MatchType, &match.MatchFormat,
			&match.TeamAID, &match.TeamBID, &match.MatchDate, &match.MatchTime,
			&match.GroundID, &match.VenueName, &match.VenueCity,
			&match.TotalOvers, &match.BallType, &tossJSON, &officialsJSON,
			&match.Status, &resultJSON, &match.CreatedBy,
			&match.CreatedAt, &match.UpdatedAt, &match.Description,
		)
		if err != nil {
			return nil, 0, err
		}

		// Parse JSONB (simplified for listing)
		var toss map[string]interface{}
		json.Unmarshal(tossJSON, &toss)

		matches = append(matches, match)
	}

	return matches, total, rows.Err()
}

func (r *matchRepository) UpdateMatch(ctx context.Context, match *domain.Match) error {
	query := `
		UPDATE matches 
		SET title = $1, match_date = $2, match_time = $3,
		    venue_name = $4, venue_city = $5, total_overs = $6,
		    description = $7, updated_at = $8
		WHERE id = $9
	`
	_, err := r.db.ExecContext(ctx, query,
		match.Title, match.MatchDate, match.MatchTime,
		match.VenueName, match.VenueCity, match.TotalOvers,
		match.Description, time.Now(), match.ID,
	)
	return err
}

func (r *matchRepository) UpdateMatchStatus(ctx context.Context, matchID uuid.UUID, status string, result map[string]interface{}) error {
	resultJSON, _ := json.Marshal(result)

	query := `
		UPDATE matches 
		SET status = $1, result = $2, updated_at = $3
		WHERE id = $4
	`
	_, err := r.db.ExecContext(ctx, query, status, resultJSON, time.Now(), matchID)
	return err
}

func (r *matchRepository) DeleteMatch(ctx context.Context, matchID uuid.UUID) error {
	query := `DELETE FROM matches WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, matchID)
	return err
}

// Squad operations

func (r *matchRepository) AddPlayerToSquad(ctx context.Context, squad *domain.MatchSquad) error {
	query := `
		INSERT INTO match_squads (
			id, match_id, player_id, team_id, in_playing_11,
			is_captain, is_vice_captain, is_wicket_keeper
		)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`
	_, err := r.db.ExecContext(ctx, query,
		squad.ID, squad.MatchID, squad.PlayerID, squad.TeamID,
		squad.InPlaying11, squad.IsCaptain, squad.IsViceCaptain, squad.IsWicketKeeper,
	)
	return err
}

func (r *matchRepository) RemovePlayerFromSquad(ctx context.Context, matchID, playerID uuid.UUID) error {
	query := `DELETE FROM match_squads WHERE match_id = $1 AND player_id = $2`
	_, err := r.db.ExecContext(ctx, query, matchID, playerID)
	return err
}

func (r *matchRepository) GetMatchSquad(ctx context.Context, matchID uuid.UUID) ([]domain.MatchSquad, error) {
	query := `
		SELECT id, match_id, player_id, team_id, in_playing_11,
		       is_captain, is_vice_captain, is_wicket_keeper, added_at
		FROM match_squads
		WHERE match_id = $1
		ORDER BY team_id, in_playing_11 DESC, added_at
	`

	rows, err := r.db.QueryContext(ctx, query, matchID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var squad []domain.MatchSquad
	for rows.Next() {
		var s domain.MatchSquad
		err := rows.Scan(
			&s.ID, &s.MatchID, &s.PlayerID, &s.TeamID, &s.InPlaying11,
			&s.IsCaptain, &s.IsViceCaptain, &s.IsWicketKeeper, &s.AddedAt,
		)
		if err != nil {
			return nil, err
		}
		squad = append(squad, s)
	}

	return squad, rows.Err()
}

func (r *matchRepository) GetTeamSquad(ctx context.Context, matchID, teamID uuid.UUID) ([]domain.MatchSquad, error) {
	query := `
		SELECT id, match_id, player_id, team_id, in_playing_11,
		       is_captain, is_vice_captain, is_wicket_keeper, added_at
		FROM match_squads
		WHERE match_id = $1 AND team_id = $2
		ORDER BY in_playing_11 DESC, added_at
	`

	rows, err := r.db.QueryContext(ctx, query, matchID, teamID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var squad []domain.MatchSquad
	for rows.Next() {
		var s domain.MatchSquad
		err := rows.Scan(
			&s.ID, &s.MatchID, &s.PlayerID, &s.TeamID, &s.InPlaying11,
			&s.IsCaptain, &s.IsViceCaptain, &s.IsWicketKeeper, &s.AddedAt,
		)
		if err != nil {
			return nil, err
		}
		squad = append(squad, s)
	}

	return squad, rows.Err()
}

func (r *matchRepository) UpdateSquadPlayer(ctx context.Context, squad *domain.MatchSquad) error {
	query := `
		UPDATE match_squads 
		SET in_playing_11 = $1, is_captain = $2, is_vice_captain = $3, is_wicket_keeper = $4
		WHERE match_id = $5 AND player_id = $6
	`
	_, err := r.db.ExecContext(ctx, query,
		squad.InPlaying11, squad.IsCaptain, squad.IsViceCaptain, squad.IsWicketKeeper,
		squad.MatchID, squad.PlayerID,
	)
	return err
}
