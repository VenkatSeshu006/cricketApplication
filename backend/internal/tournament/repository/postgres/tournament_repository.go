package postgres

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"

	"github.com/cricketapp/backend/internal/tournament/domain"
	"github.com/google/uuid"
)

type tournamentRepository struct {
	db *sql.DB
}

func NewTournamentRepository(db *sql.DB) domain.TournamentRepository {
	return &tournamentRepository{db: db}
}

// Tournament operations

func (r *tournamentRepository) CreateTournament(ctx context.Context, tournament *domain.Tournament) error {
	rulesJSON, err := json.Marshal(tournament.Rules)
	if err != nil {
		return fmt.Errorf("failed to marshal rules: %w", err)
	}

	query := `
		INSERT INTO tournaments (
			id, name, short_name, description, tournament_type, match_format,
			start_date, end_date, registration_deadline, max_teams, min_teams,
			entry_fee, prize_pool, rules, status, venue_name, venue_city,
			ground_id, organizer_id, logo_url, banner_url, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23)
	`

	_, err = r.db.ExecContext(ctx, query,
		tournament.ID, tournament.Name, tournament.ShortName, tournament.Description,
		tournament.TournamentType, tournament.MatchFormat, tournament.StartDate,
		tournament.EndDate, tournament.RegistrationDeadline, tournament.MaxTeams,
		tournament.MinTeams, tournament.EntryFee, tournament.PrizePool, rulesJSON,
		tournament.Status, tournament.VenueName, tournament.VenueCity, tournament.GroundID,
		tournament.OrganizerID, tournament.LogoURL, tournament.BannerURL,
		tournament.CreatedAt, tournament.UpdatedAt,
	)

	return err
}

func (r *tournamentRepository) GetTournamentByID(ctx context.Context, tournamentID uuid.UUID) (*domain.Tournament, error) {
	query := `
		SELECT id, name, short_name, description, tournament_type, match_format,
		       start_date, end_date, registration_deadline, max_teams, min_teams,
		       entry_fee, prize_pool, rules, status, venue_name, venue_city,
		       ground_id, organizer_id, logo_url, banner_url, created_at, updated_at
		FROM tournaments
		WHERE id = $1
	`

	var tournament domain.Tournament
	var rulesJSON []byte

	err := r.db.QueryRowContext(ctx, query, tournamentID).Scan(
		&tournament.ID, &tournament.Name, &tournament.ShortName, &tournament.Description,
		&tournament.TournamentType, &tournament.MatchFormat, &tournament.StartDate,
		&tournament.EndDate, &tournament.RegistrationDeadline, &tournament.MaxTeams,
		&tournament.MinTeams, &tournament.EntryFee, &tournament.PrizePool, &rulesJSON,
		&tournament.Status, &tournament.VenueName, &tournament.VenueCity, &tournament.GroundID,
		&tournament.OrganizerID, &tournament.LogoURL, &tournament.BannerURL,
		&tournament.CreatedAt, &tournament.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("tournament not found")
	}
	if err != nil {
		return nil, err
	}

	if len(rulesJSON) > 0 {
		if err := json.Unmarshal(rulesJSON, &tournament.Rules); err != nil {
			return nil, fmt.Errorf("failed to unmarshal rules: %w", err)
		}
	}

	return &tournament, nil
}

func (r *tournamentRepository) ListTournaments(ctx context.Context, filters domain.TournamentFilters) ([]domain.Tournament, int, error) {
	query := `
		SELECT id, name, short_name, description, tournament_type, match_format,
		       start_date, end_date, registration_deadline, max_teams, min_teams,
		       entry_fee, prize_pool, rules, status, venue_name, venue_city,
		       ground_id, organizer_id, logo_url, banner_url, created_at, updated_at
		FROM tournaments
		WHERE ($1::text IS NULL OR status = $1)
		  AND ($2::text IS NULL OR tournament_type = $2)
		  AND ($3::uuid IS NULL OR organizer_id = $3)
		  AND ($4::timestamp IS NULL OR start_date >= $4::timestamp)
		  AND ($5::timestamp IS NULL OR start_date <= $5::timestamp)
		ORDER BY start_date DESC
		LIMIT $6 OFFSET $7
	`

	countQuery := `
		SELECT COUNT(*)
		FROM tournaments
		WHERE ($1::text IS NULL OR status = $1)
		  AND ($2::text IS NULL OR tournament_type = $2)
		  AND ($3::uuid IS NULL OR organizer_id = $3)
		  AND ($4::timestamp IS NULL OR start_date >= $4::timestamp)
		  AND ($5::timestamp IS NULL OR start_date <= $5::timestamp)
	`

	// Get total count
	var total int
	err := r.db.QueryRowContext(ctx, countQuery,
		filters.Status, filters.TournamentType, filters.OrganizerID,
		filters.StartDateFrom, filters.StartDateTo,
	).Scan(&total)
	if err != nil {
		return nil, 0, err
	}

	// Get tournaments
	limit := filters.Limit
	if limit <= 0 {
		limit = 20
	}
	offset := (filters.Page - 1) * limit
	if offset < 0 {
		offset = 0
	}

	rows, err := r.db.QueryContext(ctx, query,
		filters.Status, filters.TournamentType, filters.OrganizerID,
		filters.StartDateFrom, filters.StartDateTo, limit, offset,
	)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var tournaments []domain.Tournament
	for rows.Next() {
		var t domain.Tournament
		var rulesJSON []byte

		err := rows.Scan(
			&t.ID, &t.Name, &t.ShortName, &t.Description,
			&t.TournamentType, &t.MatchFormat, &t.StartDate,
			&t.EndDate, &t.RegistrationDeadline, &t.MaxTeams,
			&t.MinTeams, &t.EntryFee, &t.PrizePool, &rulesJSON,
			&t.Status, &t.VenueName, &t.VenueCity, &t.GroundID,
			&t.OrganizerID, &t.LogoURL, &t.BannerURL,
			&t.CreatedAt, &t.UpdatedAt,
		)
		if err != nil {
			return nil, 0, err
		}

		if len(rulesJSON) > 0 {
			if err := json.Unmarshal(rulesJSON, &t.Rules); err != nil {
				return nil, 0, fmt.Errorf("failed to unmarshal rules: %w", err)
			}
		}

		tournaments = append(tournaments, t)
	}

	return tournaments, total, rows.Err()
}

func (r *tournamentRepository) UpdateTournament(ctx context.Context, tournamentID uuid.UUID, tournament *domain.Tournament) error {
	rulesJSON, err := json.Marshal(tournament.Rules)
	if err != nil {
		return fmt.Errorf("failed to marshal rules: %w", err)
	}

	query := `
		UPDATE tournaments
		SET name = $1, short_name = $2, description = $3, start_date = $4,
		    end_date = $5, registration_deadline = $6, max_teams = $7,
		    entry_fee = $8, prize_pool = $9, rules = $10, venue_name = $11,
		    venue_city = $12, logo_url = $13, banner_url = $14, updated_at = $15
		WHERE id = $16
	`

	_, err = r.db.ExecContext(ctx, query,
		tournament.Name, tournament.ShortName, tournament.Description,
		tournament.StartDate, tournament.EndDate, tournament.RegistrationDeadline,
		tournament.MaxTeams, tournament.EntryFee, tournament.PrizePool, rulesJSON,
		tournament.VenueName, tournament.VenueCity, tournament.LogoURL,
		tournament.BannerURL, tournament.UpdatedAt, tournamentID,
	)

	return err
}

func (r *tournamentRepository) DeleteTournament(ctx context.Context, tournamentID uuid.UUID) error {
	query := `DELETE FROM tournaments WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, tournamentID)
	return err
}

func (r *tournamentRepository) UpdateTournamentStatus(ctx context.Context, tournamentID uuid.UUID, status string) error {
	query := `UPDATE tournaments SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2`
	_, err := r.db.ExecContext(ctx, query, status, tournamentID)
	return err
}

// Registration operations

func (r *tournamentRepository) RegisterTeam(ctx context.Context, registration *domain.TournamentRegistration) error {
	query := `
		INSERT INTO tournament_registrations (
			id, tournament_id, team_id, registration_date, status, payment_status,
			captain_id, squad_size, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
	`

	_, err := r.db.ExecContext(ctx, query,
		registration.ID, registration.TournamentID, registration.TeamID,
		registration.RegistrationDate, registration.Status, registration.PaymentStatus,
		registration.CaptainID, registration.SquadSize,
		registration.CreatedAt, registration.UpdatedAt,
	)

	return err
}

func (r *tournamentRepository) GetRegistration(ctx context.Context, tournamentID, teamID uuid.UUID) (*domain.TournamentRegistration, error) {
	query := `
		SELECT id, tournament_id, team_id, registration_date, status, payment_status,
		       captain_id, squad_size, approved_by, approved_at, rejection_reason,
		       created_at, updated_at
		FROM tournament_registrations
		WHERE tournament_id = $1 AND team_id = $2
	`

	var reg domain.TournamentRegistration
	err := r.db.QueryRowContext(ctx, query, tournamentID, teamID).Scan(
		&reg.ID, &reg.TournamentID, &reg.TeamID, &reg.RegistrationDate,
		&reg.Status, &reg.PaymentStatus, &reg.CaptainID, &reg.SquadSize,
		&reg.ApprovedBy, &reg.ApprovedAt, &reg.RejectionReason,
		&reg.CreatedAt, &reg.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("registration not found")
	}
	if err != nil {
		return nil, err
	}

	return &reg, nil
}

func (r *tournamentRepository) ListRegistrations(ctx context.Context, tournamentID uuid.UUID, status *string) ([]domain.TournamentRegistration, error) {
	query := `
		SELECT id, tournament_id, team_id, registration_date, status, payment_status,
		       captain_id, squad_size, approved_by, approved_at, rejection_reason,
		       created_at, updated_at
		FROM tournament_registrations
		WHERE tournament_id = $1
		  AND ($2::text IS NULL OR status = $2)
		ORDER BY registration_date ASC
	`

	rows, err := r.db.QueryContext(ctx, query, tournamentID, status)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var registrations []domain.TournamentRegistration
	for rows.Next() {
		var reg domain.TournamentRegistration
		err := rows.Scan(
			&reg.ID, &reg.TournamentID, &reg.TeamID, &reg.RegistrationDate,
			&reg.Status, &reg.PaymentStatus, &reg.CaptainID, &reg.SquadSize,
			&reg.ApprovedBy, &reg.ApprovedAt, &reg.RejectionReason,
			&reg.CreatedAt, &reg.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		registrations = append(registrations, reg)
	}

	return registrations, rows.Err()
}

func (r *tournamentRepository) UpdateRegistrationStatus(ctx context.Context, registrationID uuid.UUID, status string, approvedBy uuid.UUID, rejectionReason *string) error {
	query := `
		UPDATE tournament_registrations
		SET status = $1, approved_by = $2, approved_at = CURRENT_TIMESTAMP,
		    rejection_reason = $3, updated_at = CURRENT_TIMESTAMP
		WHERE id = $4
	`

	_, err := r.db.ExecContext(ctx, query, status, approvedBy, rejectionReason, registrationID)
	return err
}

func (r *tournamentRepository) WithdrawRegistration(ctx context.Context, registrationID uuid.UUID) error {
	query := `UPDATE tournament_registrations SET status = 'withdrawn', updated_at = CURRENT_TIMESTAMP WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, registrationID)
	return err
}

func (r *tournamentRepository) GetRegistrationCount(ctx context.Context, tournamentID uuid.UUID, status *string) (int, error) {
	query := `
		SELECT COUNT(*)
		FROM tournament_registrations
		WHERE tournament_id = $1
		  AND ($2::text IS NULL OR status = $2)
	`

	var count int
	err := r.db.QueryRowContext(ctx, query, tournamentID, status).Scan(&count)
	return count, err
}

// Standings operations

func (r *tournamentRepository) CreateOrUpdateStanding(ctx context.Context, standing *domain.TournamentStanding) error {
	statsJSON, err := json.Marshal(standing.Stats)
	if err != nil {
		return fmt.Errorf("failed to marshal stats: %w", err)
	}

	query := `
		INSERT INTO tournament_standings (
			id, tournament_id, team_id, position, matches_played, matches_won,
			matches_lost, matches_drawn, matches_abandoned, points, net_run_rate,
			runs_scored, runs_conceded, wickets_taken, wickets_lost, stats, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
		ON CONFLICT (tournament_id, team_id)
		DO UPDATE SET
			position = EXCLUDED.position,
			matches_played = EXCLUDED.matches_played,
			matches_won = EXCLUDED.matches_won,
			matches_lost = EXCLUDED.matches_lost,
			matches_drawn = EXCLUDED.matches_drawn,
			matches_abandoned = EXCLUDED.matches_abandoned,
			points = EXCLUDED.points,
			net_run_rate = EXCLUDED.net_run_rate,
			runs_scored = EXCLUDED.runs_scored,
			runs_conceded = EXCLUDED.runs_conceded,
			wickets_taken = EXCLUDED.wickets_taken,
			wickets_lost = EXCLUDED.wickets_lost,
			stats = EXCLUDED.stats,
			updated_at = EXCLUDED.updated_at
	`

	_, err = r.db.ExecContext(ctx, query,
		standing.ID, standing.TournamentID, standing.TeamID, standing.Position,
		standing.MatchesPlayed, standing.MatchesWon, standing.MatchesLost,
		standing.MatchesDrawn, standing.MatchesAbandoned, standing.Points,
		standing.NetRunRate, standing.RunsScored, standing.RunsConceded,
		standing.WicketsTaken, standing.WicketsLost, statsJSON, standing.UpdatedAt,
	)

	return err
}

func (r *tournamentRepository) GetStandings(ctx context.Context, tournamentID uuid.UUID, groupName *string) ([]domain.TournamentStanding, error) {
	query := `
		SELECT s.id, s.tournament_id, s.team_id, s.position, s.matches_played,
		       s.matches_won, s.matches_lost, s.matches_drawn, s.matches_abandoned,
		       s.points, s.net_run_rate, s.runs_scored, s.runs_conceded,
		       s.wickets_taken, s.wickets_lost, s.stats, s.updated_at
		FROM tournament_standings s
		WHERE s.tournament_id = $1
		ORDER BY s.position ASC, s.points DESC, s.net_run_rate DESC
	`

	rows, err := r.db.QueryContext(ctx, query, tournamentID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var standings []domain.TournamentStanding
	for rows.Next() {
		var s domain.TournamentStanding
		var statsJSON []byte

		err := rows.Scan(
			&s.ID, &s.TournamentID, &s.TeamID, &s.Position, &s.MatchesPlayed,
			&s.MatchesWon, &s.MatchesLost, &s.MatchesDrawn, &s.MatchesAbandoned,
			&s.Points, &s.NetRunRate, &s.RunsScored, &s.RunsConceded,
			&s.WicketsTaken, &s.WicketsLost, &statsJSON, &s.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}

		if len(statsJSON) > 0 {
			if err := json.Unmarshal(statsJSON, &s.Stats); err != nil {
				return nil, fmt.Errorf("failed to unmarshal stats: %w", err)
			}
		}

		standings = append(standings, s)
	}

	return standings, rows.Err()
}

func (r *tournamentRepository) GetTeamStanding(ctx context.Context, tournamentID, teamID uuid.UUID) (*domain.TournamentStanding, error) {
	query := `
		SELECT id, tournament_id, team_id, position, matches_played,
		       matches_won, matches_lost, matches_drawn, matches_abandoned,
		       points, net_run_rate, runs_scored, runs_conceded,
		       wickets_taken, wickets_lost, stats, updated_at
		FROM tournament_standings
		WHERE tournament_id = $1 AND team_id = $2
	`

	var s domain.TournamentStanding
	var statsJSON []byte

	err := r.db.QueryRowContext(ctx, query, tournamentID, teamID).Scan(
		&s.ID, &s.TournamentID, &s.TeamID, &s.Position, &s.MatchesPlayed,
		&s.MatchesWon, &s.MatchesLost, &s.MatchesDrawn, &s.MatchesAbandoned,
		&s.Points, &s.NetRunRate, &s.RunsScored, &s.RunsConceded,
		&s.WicketsTaken, &s.WicketsLost, &statsJSON, &s.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("standing not found")
	}
	if err != nil {
		return nil, err
	}

	if len(statsJSON) > 0 {
		if err := json.Unmarshal(statsJSON, &s.Stats); err != nil {
			return nil, fmt.Errorf("failed to unmarshal stats: %w", err)
		}
	}

	return &s, nil
}

func (r *tournamentRepository) RecalculateStandings(ctx context.Context, tournamentID uuid.UUID) error {
	// This would implement complex logic to recalculate standings from match results
	// For now, it's a placeholder
	return nil
}

// Tournament match operations

func (r *tournamentRepository) LinkMatchToTournament(ctx context.Context, tournamentMatch *domain.TournamentMatch) error {
	query := `
		INSERT INTO tournament_matches (
			id, tournament_id, match_id, round_number, match_number, round_name,
			bracket_position, next_match_id, group_name, created_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
	`

	_, err := r.db.ExecContext(ctx, query,
		tournamentMatch.ID, tournamentMatch.TournamentID, tournamentMatch.MatchID,
		tournamentMatch.RoundNumber, tournamentMatch.MatchNumber, tournamentMatch.RoundName,
		tournamentMatch.BracketPosition, tournamentMatch.NextMatchID, tournamentMatch.GroupName,
		tournamentMatch.CreatedAt,
	)

	return err
}

func (r *tournamentRepository) GetTournamentMatches(ctx context.Context, tournamentID uuid.UUID, roundNumber *int, groupName *string) ([]domain.TournamentMatch, error) {
	query := `
		SELECT id, tournament_id, match_id, round_number, match_number, round_name,
		       bracket_position, next_match_id, group_name, created_at
		FROM tournament_matches
		WHERE tournament_id = $1
		  AND ($2::int IS NULL OR round_number = $2)
		  AND ($3::text IS NULL OR group_name = $3)
		ORDER BY round_number ASC, match_number ASC
	`

	rows, err := r.db.QueryContext(ctx, query, tournamentID, roundNumber, groupName)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var matches []domain.TournamentMatch
	for rows.Next() {
		var tm domain.TournamentMatch
		err := rows.Scan(
			&tm.ID, &tm.TournamentID, &tm.MatchID, &tm.RoundNumber,
			&tm.MatchNumber, &tm.RoundName, &tm.BracketPosition,
			&tm.NextMatchID, &tm.GroupName, &tm.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
		matches = append(matches, tm)
	}

	return matches, rows.Err()
}

func (r *tournamentRepository) GetTournamentMatch(ctx context.Context, tournamentID, matchID uuid.UUID) (*domain.TournamentMatch, error) {
	query := `
		SELECT id, tournament_id, match_id, round_number, match_number, round_name,
		       bracket_position, next_match_id, group_name, created_at
		FROM tournament_matches
		WHERE tournament_id = $1 AND match_id = $2
	`

	var tm domain.TournamentMatch
	err := r.db.QueryRowContext(ctx, query, tournamentID, matchID).Scan(
		&tm.ID, &tm.TournamentID, &tm.MatchID, &tm.RoundNumber,
		&tm.MatchNumber, &tm.RoundName, &tm.BracketPosition,
		&tm.NextMatchID, &tm.GroupName, &tm.CreatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("tournament match not found")
	}
	if err != nil {
		return nil, err
	}

	return &tm, nil
}

func (r *tournamentRepository) UpdateTournamentMatch(ctx context.Context, tournamentMatchID uuid.UUID, tournamentMatch *domain.TournamentMatch) error {
	query := `
		UPDATE tournament_matches
		SET round_number = $1, match_number = $2, round_name = $3,
		    bracket_position = $4, next_match_id = $5, group_name = $6
		WHERE id = $7
	`

	_, err := r.db.ExecContext(ctx, query,
		tournamentMatch.RoundNumber, tournamentMatch.MatchNumber, tournamentMatch.RoundName,
		tournamentMatch.BracketPosition, tournamentMatch.NextMatchID, tournamentMatch.GroupName,
		tournamentMatchID,
	)

	return err
}
