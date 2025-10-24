-- Migration: Player Statistics System
-- Description: Tables for tracking player performance across matches

-- Player match performances table (detailed stats for each match)
CREATE TABLE IF NOT EXISTS player_match_performances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    
    -- Match participation
    played BOOLEAN NOT NULL DEFAULT true,
    captain BOOLEAN DEFAULT false,
    vice_captain BOOLEAN DEFAULT false,
    wicket_keeper BOOLEAN DEFAULT false,
    
    -- Batting statistics
    batting_position INTEGER,
    runs_scored INTEGER DEFAULT 0,
    balls_faced INTEGER DEFAULT 0,
    fours INTEGER DEFAULT 0,
    sixes INTEGER DEFAULT 0,
    strike_rate DECIMAL(10,2) DEFAULT 0.00,
    dismissal_type VARCHAR(50), -- bowled, caught, lbw, run_out, stumped, not_out, etc.
    dismissed_by_player_id UUID REFERENCES players(id) ON DELETE SET NULL,
    
    -- Bowling statistics
    overs_bowled DECIMAL(10,1) DEFAULT 0.0,
    runs_conceded INTEGER DEFAULT 0,
    wickets_taken INTEGER DEFAULT 0,
    maidens INTEGER DEFAULT 0,
    economy_rate DECIMAL(10,2) DEFAULT 0.00,
    bowling_strike_rate DECIMAL(10,2) DEFAULT 0.00,
    
    -- Fielding statistics
    catches INTEGER DEFAULT 0,
    run_outs INTEGER DEFAULT 0,
    stumpings INTEGER DEFAULT 0,
    
    -- Awards
    player_of_match BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    UNIQUE(player_id, match_id),
    CONSTRAINT valid_dismissal_type CHECK (dismissal_type IN ('bowled', 'caught', 'lbw', 'run_out', 'stumped', 'hit_wicket', 'retired_hurt', 'not_out', 'timed_out', 'obstructing', 'hit_twice'))
);

-- Player career statistics (aggregated stats across all matches)
CREATE TABLE IF NOT EXISTS player_career_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL UNIQUE REFERENCES players(id) ON DELETE CASCADE,
    
    -- Overall stats
    total_matches INTEGER DEFAULT 0,
    total_innings INTEGER DEFAULT 0,
    matches_won INTEGER DEFAULT 0,
    matches_lost INTEGER DEFAULT 0,
    
    -- Batting career stats
    total_runs INTEGER DEFAULT 0,
    total_balls_faced INTEGER DEFAULT 0,
    total_fours INTEGER DEFAULT 0,
    total_sixes INTEGER DEFAULT 0,
    highest_score INTEGER DEFAULT 0,
    batting_average DECIMAL(10,2) DEFAULT 0.00,
    batting_strike_rate DECIMAL(10,2) DEFAULT 0.00,
    fifties INTEGER DEFAULT 0,
    hundreds INTEGER DEFAULT 0,
    ducks INTEGER DEFAULT 0,
    not_outs INTEGER DEFAULT 0,
    
    -- Bowling career stats
    total_overs_bowled DECIMAL(10,1) DEFAULT 0.0,
    total_runs_conceded INTEGER DEFAULT 0,
    total_wickets INTEGER DEFAULT 0,
    total_maidens INTEGER DEFAULT 0,
    best_bowling_figures VARCHAR(20), -- e.g., "5/23"
    bowling_average DECIMAL(10,2) DEFAULT 0.00,
    bowling_economy DECIMAL(10,2) DEFAULT 0.00,
    bowling_strike_rate DECIMAL(10,2) DEFAULT 0.00,
    five_wickets INTEGER DEFAULT 0,
    
    -- Fielding career stats
    total_catches INTEGER DEFAULT 0,
    total_run_outs INTEGER DEFAULT 0,
    total_stumpings INTEGER DEFAULT 0,
    
    -- Awards
    player_of_match_awards INTEGER DEFAULT 0,
    
    -- Last updated
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Leaderboard views for quick access
CREATE TABLE IF NOT EXISTS leaderboard_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    category VARCHAR(50) NOT NULL, -- most_runs, most_wickets, best_average, best_strike_rate, etc.
    value DECIMAL(10,2) NOT NULL,
    rank INTEGER NOT NULL,
    season VARCHAR(20), -- e.g., "2025", "all_time"
    
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    UNIQUE(category, season, player_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_player_match_performances_player ON player_match_performances(player_id);
CREATE INDEX IF NOT EXISTS idx_player_match_performances_match ON player_match_performances(match_id);
CREATE INDEX IF NOT EXISTS idx_player_match_performances_team ON player_match_performances(team_id);
CREATE INDEX IF NOT EXISTS idx_player_match_performances_runs ON player_match_performances(runs_scored DESC);
CREATE INDEX IF NOT EXISTS idx_player_match_performances_wickets ON player_match_performances(wickets_taken DESC);

CREATE INDEX IF NOT EXISTS idx_player_career_stats_player ON player_career_stats(player_id);
CREATE INDEX IF NOT EXISTS idx_player_career_stats_runs ON player_career_stats(total_runs DESC);
CREATE INDEX IF NOT EXISTS idx_player_career_stats_wickets ON player_career_stats(total_wickets DESC);
CREATE INDEX IF NOT EXISTS idx_player_career_stats_avg ON player_career_stats(batting_average DESC);

CREATE INDEX IF NOT EXISTS idx_leaderboard_entries_category ON leaderboard_entries(category, season);
CREATE INDEX IF NOT EXISTS idx_leaderboard_entries_player ON leaderboard_entries(player_id);
CREATE INDEX IF NOT EXISTS idx_leaderboard_entries_rank ON leaderboard_entries(category, season, rank);
