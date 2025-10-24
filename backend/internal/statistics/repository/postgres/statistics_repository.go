package postgres

import (
	"database/sql"
	"fmt"
	"strings"

	"github.com/cricketapp/backend/internal/statistics/domain"

	"github.com/google/uuid"
)

type statisticsRepository struct {
	db *sql.DB
}

// NewStatisticsRepository creates a new statistics repository
func NewStatisticsRepository(db *sql.DB) domain.StatisticsRepository {
	return &statisticsRepository{db: db}
}

// RecordPerformance records a player's match performance
func (r *statisticsRepository) RecordPerformance(perf *domain.PlayerMatchPerformance) error {
	// Calculate strike rates
	if perf.BallsFaced > 0 {
		perf.StrikeRate = (float64(perf.RunsScored) / float64(perf.BallsFaced)) * 100
	}
	if perf.OversBowled > 0 {
		perf.EconomyRate = float64(perf.RunsConceded) / perf.OversBowled
		ballsBowled := perf.OversBowled * 6
		if perf.WicketsTaken > 0 {
			perf.BowlingStrikeRate = ballsBowled / float64(perf.WicketsTaken)
		}
	}

	query := `
		INSERT INTO player_match_performances (
			player_id, match_id, team_id, played, captain, vice_captain, wicket_keeper,
			batting_position, runs_scored, balls_faced, fours, sixes, strike_rate,
			dismissal_type, dismissed_by_player_id,
			overs_bowled, runs_conceded, wickets_taken, maidens, economy_rate, bowling_strike_rate,
			catches, run_outs, stumpings, player_of_match
		) VALUES (
			$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
			$16, $17, $18, $19, $20, $21, $22, $23, $24, $25
		) RETURNING id, created_at, updated_at`

	err := r.db.QueryRow(
		query,
		perf.PlayerID, perf.MatchID, perf.TeamID, perf.Played, perf.Captain, perf.ViceCaptain, perf.WicketKeeper,
		perf.BattingPosition, perf.RunsScored, perf.BallsFaced, perf.Fours, perf.Sixes, perf.StrikeRate,
		perf.DismissalType, perf.DismissedByPlayerID,
		perf.OversBowled, perf.RunsConceded, perf.WicketsTaken, perf.Maidens, perf.EconomyRate, perf.BowlingStrikeRate,
		perf.Catches, perf.RunOuts, perf.Stumpings, perf.PlayerOfMatch,
	).Scan(&perf.ID, &perf.CreatedAt, &perf.UpdatedAt)

	if err != nil {
		return fmt.Errorf("failed to record performance: %w", err)
	}

	// Recalculate career stats
	if err := r.RecalculateCareerStats(perf.PlayerID); err != nil {
		return fmt.Errorf("failed to recalculate career stats: %w", err)
	}

	return nil
}

// GetPerformance retrieves a performance by ID
func (r *statisticsRepository) GetPerformance(performanceID uuid.UUID) (*domain.PlayerMatchPerformance, error) {
	query := `
		SELECT id, player_id, match_id, team_id, played, captain, vice_captain, wicket_keeper,
			   batting_position, runs_scored, balls_faced, fours, sixes, strike_rate,
			   dismissal_type, dismissed_by_player_id,
			   overs_bowled, runs_conceded, wickets_taken, maidens, economy_rate, bowling_strike_rate,
			   catches, run_outs, stumpings, player_of_match, created_at, updated_at
		FROM player_match_performances
		WHERE id = $1`

	perf := &domain.PlayerMatchPerformance{}
	err := r.db.QueryRow(query, performanceID).Scan(
		&perf.ID, &perf.PlayerID, &perf.MatchID, &perf.TeamID, &perf.Played, &perf.Captain, &perf.ViceCaptain, &perf.WicketKeeper,
		&perf.BattingPosition, &perf.RunsScored, &perf.BallsFaced, &perf.Fours, &perf.Sixes, &perf.StrikeRate,
		&perf.DismissalType, &perf.DismissedByPlayerID,
		&perf.OversBowled, &perf.RunsConceded, &perf.WicketsTaken, &perf.Maidens, &perf.EconomyRate, &perf.BowlingStrikeRate,
		&perf.Catches, &perf.RunOuts, &perf.Stumpings, &perf.PlayerOfMatch, &perf.CreatedAt, &perf.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("performance not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get performance: %w", err)
	}

	return perf, nil
}

// GetPerformanceByPlayerMatch retrieves a performance by player and match
func (r *statisticsRepository) GetPerformanceByPlayerMatch(playerID, matchID uuid.UUID) (*domain.PlayerMatchPerformance, error) {
	query := `
		SELECT id, player_id, match_id, team_id, played, captain, vice_captain, wicket_keeper,
			   batting_position, runs_scored, balls_faced, fours, sixes, strike_rate,
			   dismissal_type, dismissed_by_player_id,
			   overs_bowled, runs_conceded, wickets_taken, maidens, economy_rate, bowling_strike_rate,
			   catches, run_outs, stumpings, player_of_match, created_at, updated_at
		FROM player_match_performances
		WHERE player_id = $1 AND match_id = $2`

	perf := &domain.PlayerMatchPerformance{}
	err := r.db.QueryRow(query, playerID, matchID).Scan(
		&perf.ID, &perf.PlayerID, &perf.MatchID, &perf.TeamID, &perf.Played, &perf.Captain, &perf.ViceCaptain, &perf.WicketKeeper,
		&perf.BattingPosition, &perf.RunsScored, &perf.BallsFaced, &perf.Fours, &perf.Sixes, &perf.StrikeRate,
		&perf.DismissalType, &perf.DismissedByPlayerID,
		&perf.OversBowled, &perf.RunsConceded, &perf.WicketsTaken, &perf.Maidens, &perf.EconomyRate, &perf.BowlingStrikeRate,
		&perf.Catches, &perf.RunOuts, &perf.Stumpings, &perf.PlayerOfMatch, &perf.CreatedAt, &perf.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("performance not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get performance: %w", err)
	}

	return perf, nil
}

// ListPerformances lists performances with filters
func (r *statisticsRepository) ListPerformances(filters domain.PerformanceFilters) ([]domain.PlayerMatchPerformance, int, error) {
	conditions := []string{}
	args := []interface{}{}
	argPos := 1

	if filters.PlayerID != nil {
		conditions = append(conditions, fmt.Sprintf("player_id = $%d", argPos))
		args = append(args, *filters.PlayerID)
		argPos++
	}

	if filters.MatchID != nil {
		conditions = append(conditions, fmt.Sprintf("match_id = $%d", argPos))
		args = append(args, *filters.MatchID)
		argPos++
	}

	if filters.TeamID != nil {
		conditions = append(conditions, fmt.Sprintf("team_id = $%d", argPos))
		args = append(args, *filters.TeamID)
		argPos++
	}

	if filters.MinRuns != nil {
		conditions = append(conditions, fmt.Sprintf("runs_scored >= $%d", argPos))
		args = append(args, *filters.MinRuns)
		argPos++
	}

	if filters.MinWickets != nil {
		conditions = append(conditions, fmt.Sprintf("wickets_taken >= $%d", argPos))
		args = append(args, *filters.MinWickets)
		argPos++
	}

	whereClause := ""
	if len(conditions) > 0 {
		whereClause = "WHERE " + strings.Join(conditions, " AND ")
	}

	// Get total count
	countQuery := fmt.Sprintf("SELECT COUNT(*) FROM player_match_performances %s", whereClause)
	var total int
	err := r.db.QueryRow(countQuery, args...).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count performances: %w", err)
	}

	// Get performances
	if filters.Page < 1 {
		filters.Page = 1
	}
	if filters.Limit < 1 {
		filters.Limit = 10
	}

	offset := (filters.Page - 1) * filters.Limit

	query := fmt.Sprintf(`
		SELECT id, player_id, match_id, team_id, played, captain, vice_captain, wicket_keeper,
			   batting_position, runs_scored, balls_faced, fours, sixes, strike_rate,
			   dismissal_type, dismissed_by_player_id,
			   overs_bowled, runs_conceded, wickets_taken, maidens, economy_rate, bowling_strike_rate,
			   catches, run_outs, stumpings, player_of_match, created_at, updated_at
		FROM player_match_performances
		%s
		ORDER BY created_at DESC
		LIMIT $%d OFFSET $%d
	`, whereClause, argPos, argPos+1)

	args = append(args, filters.Limit, offset)

	rows, err := r.db.Query(query, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to list performances: %w", err)
	}
	defer rows.Close()

	performances := []domain.PlayerMatchPerformance{}
	for rows.Next() {
		perf := domain.PlayerMatchPerformance{}
		err := rows.Scan(
			&perf.ID, &perf.PlayerID, &perf.MatchID, &perf.TeamID, &perf.Played, &perf.Captain, &perf.ViceCaptain, &perf.WicketKeeper,
			&perf.BattingPosition, &perf.RunsScored, &perf.BallsFaced, &perf.Fours, &perf.Sixes, &perf.StrikeRate,
			&perf.DismissalType, &perf.DismissedByPlayerID,
			&perf.OversBowled, &perf.RunsConceded, &perf.WicketsTaken, &perf.Maidens, &perf.EconomyRate, &perf.BowlingStrikeRate,
			&perf.Catches, &perf.RunOuts, &perf.Stumpings, &perf.PlayerOfMatch, &perf.CreatedAt, &perf.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan performance: %w", err)
		}
		performances = append(performances, perf)
	}

	return performances, total, nil
}

// UpdatePerformance updates a performance
func (r *statisticsRepository) UpdatePerformance(performanceID uuid.UUID, updates map[string]interface{}) error {
	if len(updates) == 0 {
		return nil
	}

	setClauses := []string{}
	args := []interface{}{}
	argPos := 1

	for key, value := range updates {
		setClauses = append(setClauses, fmt.Sprintf("%s = $%d", key, argPos))
		args = append(args, value)
		argPos++
	}

	setClauses = append(setClauses, "updated_at = CURRENT_TIMESTAMP")

	query := fmt.Sprintf(
		"UPDATE player_match_performances SET %s WHERE id = $%d",
		strings.Join(setClauses, ", "),
		argPos,
	)
	args = append(args, performanceID)

	result, err := r.db.Exec(query, args...)
	if err != nil {
		return fmt.Errorf("failed to update performance: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("performance not found")
	}

	// Get player_id to recalculate stats
	var playerID uuid.UUID
	err = r.db.QueryRow("SELECT player_id FROM player_match_performances WHERE id = $1", performanceID).Scan(&playerID)
	if err == nil {
		r.RecalculateCareerStats(playerID)
	}

	return nil
}

// DeletePerformance deletes a performance
func (r *statisticsRepository) DeletePerformance(performanceID uuid.UUID) error {
	// Get player_id before deleting
	var playerID uuid.UUID
	err := r.db.QueryRow("SELECT player_id FROM player_match_performances WHERE id = $1", performanceID).Scan(&playerID)
	if err != nil {
		return fmt.Errorf("failed to get player_id: %w", err)
	}

	result, err := r.db.Exec("DELETE FROM player_match_performances WHERE id = $1", performanceID)
	if err != nil {
		return fmt.Errorf("failed to delete performance: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("performance not found")
	}

	// Recalculate career stats
	r.RecalculateCareerStats(playerID)

	return nil
}

// GetCareerStats retrieves career stats for a player
func (r *statisticsRepository) GetCareerStats(playerID uuid.UUID) (*domain.PlayerCareerStats, error) {
	query := `
		SELECT id, player_id, total_matches, total_innings, matches_won, matches_lost,
			   total_runs, total_balls_faced, total_fours, total_sixes, highest_score,
			   batting_average, batting_strike_rate, fifties, hundreds, ducks, not_outs,
			   total_overs_bowled, total_runs_conceded, total_wickets, total_maidens,
			   best_bowling_figures, bowling_average, bowling_economy, bowling_strike_rate, five_wickets,
			   total_catches, total_run_outs, total_stumpings, player_of_match_awards, updated_at
		FROM player_career_stats
		WHERE player_id = $1`

	stats := &domain.PlayerCareerStats{}
	err := r.db.QueryRow(query, playerID).Scan(
		&stats.ID, &stats.PlayerID, &stats.TotalMatches, &stats.TotalInnings, &stats.MatchesWon, &stats.MatchesLost,
		&stats.TotalRuns, &stats.TotalBallsFaced, &stats.TotalFours, &stats.TotalSixes, &stats.HighestScore,
		&stats.BattingAverage, &stats.BattingStrikeRate, &stats.Fifties, &stats.Hundreds, &stats.Ducks, &stats.NotOuts,
		&stats.TotalOversBowled, &stats.TotalRunsConceded, &stats.TotalWickets, &stats.TotalMaidens,
		&stats.BestBowlingFigures, &stats.BowlingAverage, &stats.BowlingEconomy, &stats.BowlingStrikeRate, &stats.FiveWickets,
		&stats.TotalCatches, &stats.TotalRunOuts, &stats.TotalStumpings, &stats.PlayerOfMatchAwards, &stats.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		// Create initial stats record
		return r.initializeCareerStats(playerID)
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get career stats: %w", err)
	}

	return stats, nil
}

// initializeCareerStats creates initial career stats record
func (r *statisticsRepository) initializeCareerStats(playerID uuid.UUID) (*domain.PlayerCareerStats, error) {
	query := `
		INSERT INTO player_career_stats (player_id)
		VALUES ($1)
		RETURNING id, player_id, total_matches, total_innings, matches_won, matches_lost,
				  total_runs, total_balls_faced, total_fours, total_sixes, highest_score,
				  batting_average, batting_strike_rate, fifties, hundreds, ducks, not_outs,
				  total_overs_bowled, total_runs_conceded, total_wickets, total_maidens,
				  best_bowling_figures, bowling_average, bowling_economy, bowling_strike_rate, five_wickets,
				  total_catches, total_run_outs, total_stumpings, player_of_match_awards, updated_at`

	stats := &domain.PlayerCareerStats{}
	err := r.db.QueryRow(query, playerID).Scan(
		&stats.ID, &stats.PlayerID, &stats.TotalMatches, &stats.TotalInnings, &stats.MatchesWon, &stats.MatchesLost,
		&stats.TotalRuns, &stats.TotalBallsFaced, &stats.TotalFours, &stats.TotalSixes, &stats.HighestScore,
		&stats.BattingAverage, &stats.BattingStrikeRate, &stats.Fifties, &stats.Hundreds, &stats.Ducks, &stats.NotOuts,
		&stats.TotalOversBowled, &stats.TotalRunsConceded, &stats.TotalWickets, &stats.TotalMaidens,
		&stats.BestBowlingFigures, &stats.BowlingAverage, &stats.BowlingEconomy, &stats.BowlingStrikeRate, &stats.FiveWickets,
		&stats.TotalCatches, &stats.TotalRunOuts, &stats.TotalStumpings, &stats.PlayerOfMatchAwards, &stats.UpdatedAt,
	)

	if err != nil {
		return nil, fmt.Errorf("failed to initialize career stats: %w", err)
	}

	return stats, nil
}

// RecalculateCareerStats recalculates career stats for a player
func (r *statisticsRepository) RecalculateCareerStats(playerID uuid.UUID) error {
	// Aggregate stats from all performances
	query := `
		WITH aggregated AS (
			SELECT
				COUNT(DISTINCT match_id) as total_matches,
				COUNT(CASE WHEN balls_faced > 0 THEN 1 END) as total_innings,
				SUM(runs_scored) as total_runs,
				SUM(balls_faced) as total_balls_faced,
				SUM(fours) as total_fours,
				SUM(sixes) as total_sixes,
				MAX(runs_scored) as highest_score,
				COUNT(CASE WHEN runs_scored >= 50 AND runs_scored < 100 THEN 1 END) as fifties,
				COUNT(CASE WHEN runs_scored >= 100 THEN 1 END) as hundreds,
				COUNT(CASE WHEN runs_scored = 0 AND balls_faced > 0 THEN 1 END) as ducks,
				COUNT(CASE WHEN dismissal_type = 'not_out' OR dismissal_type IS NULL THEN 1 END) as not_outs,
				SUM(overs_bowled) as total_overs_bowled,
				SUM(runs_conceded) as total_runs_conceded,
				SUM(wickets_taken) as total_wickets,
				SUM(maidens) as total_maidens,
				COUNT(CASE WHEN wickets_taken >= 5 THEN 1 END) as five_wickets,
				SUM(catches) as total_catches,
				SUM(run_outs) as total_run_outs,
				SUM(stumpings) as total_stumpings,
				COUNT(CASE WHEN player_of_match = true THEN 1 END) as player_of_match_awards
			FROM player_match_performances
			WHERE player_id = $1 AND played = true
		)
		INSERT INTO player_career_stats (
			player_id, total_matches, total_innings, total_runs, total_balls_faced,
			total_fours, total_sixes, highest_score, fifties, hundreds, ducks, not_outs,
			batting_average, batting_strike_rate,
			total_overs_bowled, total_runs_conceded, total_wickets, total_maidens,
			bowling_average, bowling_economy, bowling_strike_rate, five_wickets,
			total_catches, total_run_outs, total_stumpings, player_of_match_awards
		)
		SELECT
			$1,
			COALESCE(total_matches, 0),
			COALESCE(total_innings, 0),
			COALESCE(total_runs, 0),
			COALESCE(total_balls_faced, 0),
			COALESCE(total_fours, 0),
			COALESCE(total_sixes, 0),
			COALESCE(highest_score, 0),
			COALESCE(fifties, 0),
			COALESCE(hundreds, 0),
			COALESCE(ducks, 0),
			COALESCE(not_outs, 0),
			CASE WHEN (total_innings - not_outs) > 0 
				THEN CAST(total_runs AS DECIMAL) / (total_innings - not_outs)
				ELSE 0 END,
			CASE WHEN total_balls_faced > 0
				THEN (CAST(total_runs AS DECIMAL) / total_balls_faced) * 100
				ELSE 0 END,
			COALESCE(total_overs_bowled, 0),
			COALESCE(total_runs_conceded, 0),
			COALESCE(total_wickets, 0),
			COALESCE(total_maidens, 0),
			CASE WHEN total_wickets > 0
				THEN CAST(total_runs_conceded AS DECIMAL) / total_wickets
				ELSE 0 END,
			CASE WHEN total_overs_bowled > 0
				THEN CAST(total_runs_conceded AS DECIMAL) / total_overs_bowled
				ELSE 0 END,
			CASE WHEN total_wickets > 0
				THEN (total_overs_bowled * 6) / total_wickets
				ELSE 0 END,
			COALESCE(five_wickets, 0),
			COALESCE(total_catches, 0),
			COALESCE(total_run_outs, 0),
			COALESCE(total_stumpings, 0),
			COALESCE(player_of_match_awards, 0)
		FROM aggregated
		ON CONFLICT (player_id) DO UPDATE SET
			total_matches = EXCLUDED.total_matches,
			total_innings = EXCLUDED.total_innings,
			total_runs = EXCLUDED.total_runs,
			total_balls_faced = EXCLUDED.total_balls_faced,
			total_fours = EXCLUDED.total_fours,
			total_sixes = EXCLUDED.total_sixes,
			highest_score = EXCLUDED.highest_score,
			fifties = EXCLUDED.fifties,
			hundreds = EXCLUDED.hundreds,
			ducks = EXCLUDED.ducks,
			not_outs = EXCLUDED.not_outs,
			batting_average = EXCLUDED.batting_average,
			batting_strike_rate = EXCLUDED.batting_strike_rate,
			total_overs_bowled = EXCLUDED.total_overs_bowled,
			total_runs_conceded = EXCLUDED.total_runs_conceded,
			total_wickets = EXCLUDED.total_wickets,
			total_maidens = EXCLUDED.total_maidens,
			bowling_average = EXCLUDED.bowling_average,
			bowling_economy = EXCLUDED.bowling_economy,
			bowling_strike_rate = EXCLUDED.bowling_strike_rate,
			five_wickets = EXCLUDED.five_wickets,
			total_catches = EXCLUDED.total_catches,
			total_run_outs = EXCLUDED.total_run_outs,
			total_stumpings = EXCLUDED.total_stumpings,
			player_of_match_awards = EXCLUDED.player_of_match_awards,
			updated_at = CURRENT_TIMESTAMP`

	_, err := r.db.Exec(query, playerID)
	if err != nil {
		return fmt.Errorf("failed to recalculate career stats: %w", err)
	}

	return nil
}

// GetLeaderboard retrieves leaderboard entries
func (r *statisticsRepository) GetLeaderboard(category string, season *string, limit int) ([]domain.LeaderboardEntryWithPlayer, error) {
	seasonFilter := "all_time"
	if season != nil {
		seasonFilter = *season
	}

	query := `
		SELECT l.id, l.player_id, l.category, l.value, l.rank, l.season, l.created_at, l.updated_at,
			   u.full_name as player_name, t.name as team_name
		FROM leaderboard_entries l
		JOIN players p ON l.player_id = p.id
		JOIN users u ON p.user_id = u.id
		LEFT JOIN teams t ON p.team_id = t.id
		WHERE l.category = $1 AND (l.season = $2 OR $2 IS NULL)
		ORDER BY l.rank
		LIMIT $3`

	rows, err := r.db.Query(query, category, seasonFilter, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to get leaderboard: %w", err)
	}
	defer rows.Close()

	entries := []domain.LeaderboardEntryWithPlayer{}
	for rows.Next() {
		entry := domain.LeaderboardEntryWithPlayer{}
		err := rows.Scan(
			&entry.ID, &entry.PlayerID, &entry.Category, &entry.Value, &entry.Rank, &entry.Season,
			&entry.CreatedAt, &entry.UpdatedAt, &entry.PlayerName, &entry.TeamName,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan leaderboard entry: %w", err)
		}
		entries = append(entries, entry)
	}

	return entries, nil
}

// UpdateLeaderboard updates leaderboard for a category
func (r *statisticsRepository) UpdateLeaderboard(category string, season *string) error {
	seasonFilter := "all_time"
	if season != nil {
		seasonFilter = *season
	}

	// Delete old entries
	_, err := r.db.Exec("DELETE FROM leaderboard_entries WHERE category = $1 AND season = $2", category, seasonFilter)
	if err != nil {
		return fmt.Errorf("failed to delete old leaderboard: %w", err)
	}

	// Insert new entries based on category
	var query string
	switch category {
	case "most_runs":
		query = `
			INSERT INTO leaderboard_entries (player_id, category, value, rank, season)
			SELECT player_id, $1, total_runs, ROW_NUMBER() OVER (ORDER BY total_runs DESC), $2
			FROM player_career_stats
			WHERE total_runs > 0
			ORDER BY total_runs DESC
			LIMIT 100`
	case "most_wickets":
		query = `
			INSERT INTO leaderboard_entries (player_id, category, value, rank, season)
			SELECT player_id, $1, total_wickets, ROW_NUMBER() OVER (ORDER BY total_wickets DESC), $2
			FROM player_career_stats
			WHERE total_wickets > 0
			ORDER BY total_wickets DESC
			LIMIT 100`
	case "best_batting_average":
		query = `
			INSERT INTO leaderboard_entries (player_id, category, value, rank, season)
			SELECT player_id, $1, batting_average, ROW_NUMBER() OVER (ORDER BY batting_average DESC), $2
			FROM player_career_stats
			WHERE total_innings >= 5 AND batting_average > 0
			ORDER BY batting_average DESC
			LIMIT 100`
	case "best_bowling_average":
		query = `
			INSERT INTO leaderboard_entries (player_id, category, value, rank, season)
			SELECT player_id, $1, bowling_average, ROW_NUMBER() OVER (ORDER BY bowling_average ASC), $2
			FROM player_career_stats
			WHERE total_wickets >= 5 AND bowling_average > 0
			ORDER BY bowling_average ASC
			LIMIT 100`
	case "best_strike_rate":
		query = `
			INSERT INTO leaderboard_entries (player_id, category, value, rank, season)
			SELECT player_id, $1, batting_strike_rate, ROW_NUMBER() OVER (ORDER BY batting_strike_rate DESC), $2
			FROM player_career_stats
			WHERE total_innings >= 5 AND batting_strike_rate > 0
			ORDER BY batting_strike_rate DESC
			LIMIT 100`
	default:
		return fmt.Errorf("unknown leaderboard category: %s", category)
	}

	_, err = r.db.Exec(query, category, seasonFilter)
	if err != nil {
		return fmt.Errorf("failed to update leaderboard: %w", err)
	}

	return nil
}
