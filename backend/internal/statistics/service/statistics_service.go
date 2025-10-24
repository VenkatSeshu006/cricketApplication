package service

import (
	"fmt"

	"github.com/cricketapp/backend/internal/statistics/domain"

	"github.com/google/uuid"
)

type statisticsService struct {
	repo domain.StatisticsRepository
}

// NewStatisticsService creates a new statistics service
func NewStatisticsService(repo domain.StatisticsRepository) domain.StatisticsService {
	return &statisticsService{repo: repo}
}

// RecordPerformance records a player's match performance
func (s *statisticsService) RecordPerformance(req domain.RecordPerformanceRequest) (*domain.PlayerMatchPerformance, error) {
	// Validate dismissal type
	if req.DismissalType != nil {
		validDismissals := map[string]bool{
			"bowled": true, "caught": true, "lbw": true, "run_out": true, "stumped": true,
			"hit_wicket": true, "retired_hurt": true, "not_out": true, "timed_out": true,
			"obstructing": true, "hit_twice": true,
		}
		if !validDismissals[*req.DismissalType] {
			return nil, fmt.Errorf("invalid dismissal type: %s", *req.DismissalType)
		}
	}

	// Validate batting stats
	if req.BallsFaced < 0 || req.RunsScored < 0 || req.Fours < 0 || req.Sixes < 0 {
		return nil, fmt.Errorf("batting stats cannot be negative")
	}

	// Validate bowling stats
	if req.OversBowled < 0 || req.RunsConceded < 0 || req.WicketsTaken < 0 || req.Maidens < 0 {
		return nil, fmt.Errorf("bowling stats cannot be negative")
	}

	// Validate fielding stats
	if req.Catches < 0 || req.RunOuts < 0 || req.Stumpings < 0 {
		return nil, fmt.Errorf("fielding stats cannot be negative")
	}

	perf := &domain.PlayerMatchPerformance{
		PlayerID:            req.PlayerID,
		MatchID:             req.MatchID,
		TeamID:              req.TeamID,
		Played:              req.Played,
		Captain:             req.Captain,
		ViceCaptain:         req.ViceCaptain,
		WicketKeeper:        req.WicketKeeper,
		BattingPosition:     req.BattingPosition,
		RunsScored:          req.RunsScored,
		BallsFaced:          req.BallsFaced,
		Fours:               req.Fours,
		Sixes:               req.Sixes,
		DismissalType:       req.DismissalType,
		DismissedByPlayerID: req.DismissedByPlayerID,
		OversBowled:         req.OversBowled,
		RunsConceded:        req.RunsConceded,
		WicketsTaken:        req.WicketsTaken,
		Maidens:             req.Maidens,
		Catches:             req.Catches,
		RunOuts:             req.RunOuts,
		Stumpings:           req.Stumpings,
		PlayerOfMatch:       req.PlayerOfMatch,
	}

	err := s.repo.RecordPerformance(perf)
	if err != nil {
		return nil, fmt.Errorf("failed to record performance: %w", err)
	}

	return perf, nil
}

// GetPerformance retrieves a performance by ID
func (s *statisticsService) GetPerformance(performanceID uuid.UUID) (*domain.PlayerMatchPerformance, error) {
	return s.repo.GetPerformance(performanceID)
}

// GetPlayerMatchPerformance retrieves a performance by player and match
func (s *statisticsService) GetPlayerMatchPerformance(playerID, matchID uuid.UUID) (*domain.PlayerMatchPerformance, error) {
	return s.repo.GetPerformanceByPlayerMatch(playerID, matchID)
}

// ListPerformances lists performances with filters
func (s *statisticsService) ListPerformances(filters domain.PerformanceFilters) ([]domain.PlayerMatchPerformance, int, error) {
	return s.repo.ListPerformances(filters)
}

// UpdatePerformance updates a performance
func (s *statisticsService) UpdatePerformance(performanceID uuid.UUID, req domain.UpdatePerformanceRequest) (*domain.PlayerMatchPerformance, error) {
	updates := make(map[string]interface{})

	if req.Played != nil {
		updates["played"] = *req.Played
	}
	if req.Captain != nil {
		updates["captain"] = *req.Captain
	}
	if req.ViceCaptain != nil {
		updates["vice_captain"] = *req.ViceCaptain
	}
	if req.WicketKeeper != nil {
		updates["wicket_keeper"] = *req.WicketKeeper
	}
	if req.BattingPosition != nil {
		updates["batting_position"] = *req.BattingPosition
	}
	if req.RunsScored != nil {
		if *req.RunsScored < 0 {
			return nil, fmt.Errorf("runs cannot be negative")
		}
		updates["runs_scored"] = *req.RunsScored
	}
	if req.BallsFaced != nil {
		if *req.BallsFaced < 0 {
			return nil, fmt.Errorf("balls faced cannot be negative")
		}
		updates["balls_faced"] = *req.BallsFaced
	}
	if req.Fours != nil {
		if *req.Fours < 0 {
			return nil, fmt.Errorf("fours cannot be negative")
		}
		updates["fours"] = *req.Fours
	}
	if req.Sixes != nil {
		if *req.Sixes < 0 {
			return nil, fmt.Errorf("sixes cannot be negative")
		}
		updates["sixes"] = *req.Sixes
	}
	if req.DismissalType != nil {
		updates["dismissal_type"] = *req.DismissalType
	}
	if req.DismissedByPlayerID != nil {
		updates["dismissed_by_player_id"] = *req.DismissedByPlayerID
	}
	if req.OversBowled != nil {
		if *req.OversBowled < 0 {
			return nil, fmt.Errorf("overs cannot be negative")
		}
		updates["overs_bowled"] = *req.OversBowled
	}
	if req.RunsConceded != nil {
		if *req.RunsConceded < 0 {
			return nil, fmt.Errorf("runs conceded cannot be negative")
		}
		updates["runs_conceded"] = *req.RunsConceded
	}
	if req.WicketsTaken != nil {
		if *req.WicketsTaken < 0 {
			return nil, fmt.Errorf("wickets cannot be negative")
		}
		updates["wickets_taken"] = *req.WicketsTaken
	}
	if req.Maidens != nil {
		if *req.Maidens < 0 {
			return nil, fmt.Errorf("maidens cannot be negative")
		}
		updates["maidens"] = *req.Maidens
	}
	if req.Catches != nil {
		if *req.Catches < 0 {
			return nil, fmt.Errorf("catches cannot be negative")
		}
		updates["catches"] = *req.Catches
	}
	if req.RunOuts != nil {
		if *req.RunOuts < 0 {
			return nil, fmt.Errorf("run outs cannot be negative")
		}
		updates["run_outs"] = *req.RunOuts
	}
	if req.Stumpings != nil {
		if *req.Stumpings < 0 {
			return nil, fmt.Errorf("stumpings cannot be negative")
		}
		updates["stumpings"] = *req.Stumpings
	}
	if req.PlayerOfMatch != nil {
		updates["player_of_match"] = *req.PlayerOfMatch
	}

	if len(updates) == 0 {
		return s.repo.GetPerformance(performanceID)
	}

	// Recalculate rates if batting/bowling stats changed
	if req.BallsFaced != nil || req.RunsScored != nil {
		perf, err := s.repo.GetPerformance(performanceID)
		if err == nil {
			runs := perf.RunsScored
			balls := perf.BallsFaced
			if req.RunsScored != nil {
				runs = *req.RunsScored
			}
			if req.BallsFaced != nil {
				balls = *req.BallsFaced
			}
			if balls > 0 {
				updates["strike_rate"] = (float64(runs) / float64(balls)) * 100
			}
		}
	}

	if req.OversBowled != nil || req.RunsConceded != nil || req.WicketsTaken != nil {
		perf, err := s.repo.GetPerformance(performanceID)
		if err == nil {
			overs := perf.OversBowled
			runs := perf.RunsConceded
			wickets := perf.WicketsTaken
			if req.OversBowled != nil {
				overs = *req.OversBowled
			}
			if req.RunsConceded != nil {
				runs = *req.RunsConceded
			}
			if req.WicketsTaken != nil {
				wickets = *req.WicketsTaken
			}
			if overs > 0 {
				updates["economy_rate"] = float64(runs) / overs
				if wickets > 0 {
					updates["bowling_strike_rate"] = (overs * 6) / float64(wickets)
				}
			}
		}
	}

	err := s.repo.UpdatePerformance(performanceID, updates)
	if err != nil {
		return nil, fmt.Errorf("failed to update performance: %w", err)
	}

	return s.repo.GetPerformance(performanceID)
}

// DeletePerformance deletes a performance
func (s *statisticsService) DeletePerformance(performanceID uuid.UUID) error {
	return s.repo.DeletePerformance(performanceID)
}

// GetPlayerCareerStats retrieves career stats for a player
func (s *statisticsService) GetPlayerCareerStats(playerID uuid.UUID) (*domain.PlayerCareerStats, error) {
	return s.repo.GetCareerStats(playerID)
}

// RefreshPlayerStats recalculates career stats for a player
func (s *statisticsService) RefreshPlayerStats(playerID uuid.UUID) (*domain.PlayerCareerStats, error) {
	err := s.repo.RecalculateCareerStats(playerID)
	if err != nil {
		return nil, fmt.Errorf("failed to refresh stats: %w", err)
	}

	return s.repo.GetCareerStats(playerID)
}

// GetBattingLeaderboard retrieves batting average leaderboard
func (s *statisticsService) GetBattingLeaderboard(season *string, limit int) ([]domain.LeaderboardEntryWithPlayer, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	// Update leaderboard first
	err := s.repo.UpdateLeaderboard("best_batting_average", season)
	if err != nil {
		return nil, fmt.Errorf("failed to update leaderboard: %w", err)
	}

	return s.repo.GetLeaderboard("best_batting_average", season, limit)
}

// GetBowlingLeaderboard retrieves bowling average leaderboard
func (s *statisticsService) GetBowlingLeaderboard(season *string, limit int) ([]domain.LeaderboardEntryWithPlayer, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	// Update leaderboard first
	err := s.repo.UpdateLeaderboard("best_bowling_average", season)
	if err != nil {
		return nil, fmt.Errorf("failed to update leaderboard: %w", err)
	}

	return s.repo.GetLeaderboard("best_bowling_average", season, limit)
}

// GetMostRunsLeaderboard retrieves most runs leaderboard
func (s *statisticsService) GetMostRunsLeaderboard(season *string, limit int) ([]domain.LeaderboardEntryWithPlayer, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	// Update leaderboard first
	err := s.repo.UpdateLeaderboard("most_runs", season)
	if err != nil {
		return nil, fmt.Errorf("failed to update leaderboard: %w", err)
	}

	return s.repo.GetLeaderboard("most_runs", season, limit)
}

// GetMostWicketsLeaderboard retrieves most wickets leaderboard
func (s *statisticsService) GetMostWicketsLeaderboard(season *string, limit int) ([]domain.LeaderboardEntryWithPlayer, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	// Update leaderboard first
	err := s.repo.UpdateLeaderboard("most_wickets", season)
	if err != nil {
		return nil, fmt.Errorf("failed to update leaderboard: %w", err)
	}

	return s.repo.GetLeaderboard("most_wickets", season, limit)
}

// RefreshLeaderboards refreshes all leaderboards
func (s *statisticsService) RefreshLeaderboards(season *string) error {
	categories := []string{"most_runs", "most_wickets", "best_batting_average", "best_bowling_average", "best_strike_rate"}

	for _, category := range categories {
		err := s.repo.UpdateLeaderboard(category, season)
		if err != nil {
			return fmt.Errorf("failed to update %s leaderboard: %w", category, err)
		}
	}

	return nil
}
