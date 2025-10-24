package domain

import "github.com/google/uuid"

// StatisticsRepository defines methods for statistics data access
type StatisticsRepository interface {
	// Performance operations
	RecordPerformance(performance *PlayerMatchPerformance) error
	GetPerformance(performanceID uuid.UUID) (*PlayerMatchPerformance, error)
	GetPerformanceByPlayerMatch(playerID, matchID uuid.UUID) (*PlayerMatchPerformance, error)
	ListPerformances(filters PerformanceFilters) ([]PlayerMatchPerformance, int, error)
	UpdatePerformance(performanceID uuid.UUID, updates map[string]interface{}) error
	DeletePerformance(performanceID uuid.UUID) error

	// Career stats operations
	GetCareerStats(playerID uuid.UUID) (*PlayerCareerStats, error)
	RecalculateCareerStats(playerID uuid.UUID) error

	// Leaderboard operations
	GetLeaderboard(category string, season *string, limit int) ([]LeaderboardEntryWithPlayer, error)
	UpdateLeaderboard(category string, season *string) error
}
