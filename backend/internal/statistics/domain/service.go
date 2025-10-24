package domain

import "github.com/google/uuid"

// StatisticsService defines business logic for player statistics
type StatisticsService interface {
	// Performance operations
	RecordPerformance(req RecordPerformanceRequest) (*PlayerMatchPerformance, error)
	GetPerformance(performanceID uuid.UUID) (*PlayerMatchPerformance, error)
	GetPlayerMatchPerformance(playerID, matchID uuid.UUID) (*PlayerMatchPerformance, error)
	ListPerformances(filters PerformanceFilters) ([]PlayerMatchPerformance, int, error)
	UpdatePerformance(performanceID uuid.UUID, req UpdatePerformanceRequest) (*PlayerMatchPerformance, error)
	DeletePerformance(performanceID uuid.UUID) error

	// Career stats operations
	GetPlayerCareerStats(playerID uuid.UUID) (*PlayerCareerStats, error)
	RefreshPlayerStats(playerID uuid.UUID) (*PlayerCareerStats, error)

	// Leaderboard operations
	GetBattingLeaderboard(season *string, limit int) ([]LeaderboardEntryWithPlayer, error)
	GetBowlingLeaderboard(season *string, limit int) ([]LeaderboardEntryWithPlayer, error)
	GetMostRunsLeaderboard(season *string, limit int) ([]LeaderboardEntryWithPlayer, error)
	GetMostWicketsLeaderboard(season *string, limit int) ([]LeaderboardEntryWithPlayer, error)
	RefreshLeaderboards(season *string) error
}
