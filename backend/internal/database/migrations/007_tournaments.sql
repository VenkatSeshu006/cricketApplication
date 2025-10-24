-- Migration: Tournament Management System
-- Description: Tables for tournaments, registrations, and standings

-- Tournaments table
CREATE TABLE IF NOT EXISTS tournaments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(50),
    description TEXT,
    
    -- Tournament type and settings
    tournament_type VARCHAR(50) NOT NULL, -- knockout, round_robin, league, mixed
    match_format VARCHAR(20) NOT NULL, -- T10, T20, ODI, Test
    
    -- Dates
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    registration_deadline TIMESTAMP NOT NULL,
    
    -- Settings
    max_teams INTEGER NOT NULL DEFAULT 16,
    min_teams INTEGER NOT NULL DEFAULT 4,
    entry_fee DECIMAL(10,2) DEFAULT 0,
    prize_pool DECIMAL(10,2) DEFAULT 0,
    
    -- Rules stored as JSONB
    rules JSONB DEFAULT '{}', -- points_per_win, points_per_draw, tie_breaker_rules, etc.
    
    -- Status
    status VARCHAR(50) NOT NULL DEFAULT 'upcoming', -- upcoming, registration_open, registration_closed, ongoing, completed, cancelled
    
    -- Venue
    venue_name VARCHAR(255),
    venue_city VARCHAR(255),
    ground_id UUID REFERENCES grounds(id) ON DELETE SET NULL,
    
    -- Organizer info
    organizer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    logo_url TEXT,
    banner_url TEXT,
    
    -- Timestamps
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_tournament_type CHECK (tournament_type IN ('knockout', 'round_robin', 'league', 'mixed')),
    CONSTRAINT valid_match_format CHECK (match_format IN ('T10', 'T20', 'ODI', 'Test')),
    CONSTRAINT valid_status CHECK (status IN ('upcoming', 'registration_open', 'registration_closed', 'ongoing', 'completed', 'cancelled')),
    CONSTRAINT valid_dates CHECK (end_date > start_date AND registration_deadline <= start_date),
    CONSTRAINT valid_teams CHECK (max_teams >= min_teams AND min_teams >= 2)
);

-- Tournament registrations (teams joining tournaments)
CREATE TABLE IF NOT EXISTS tournament_registrations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    
    -- Registration info
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'pending', -- pending, approved, rejected, withdrawn
    payment_status VARCHAR(50) DEFAULT 'pending', -- pending, paid, refunded
    
    -- Team details at registration
    captain_id UUID REFERENCES players(id) ON DELETE SET NULL,
    squad_size INTEGER DEFAULT 0,
    
    -- Approval
    approved_by UUID REFERENCES users(id) ON DELETE SET NULL,
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique constraint
    UNIQUE(tournament_id, team_id),
    
    -- Status constraint
    CONSTRAINT valid_registration_status CHECK (status IN ('pending', 'approved', 'rejected', 'withdrawn')),
    CONSTRAINT valid_payment_status CHECK (payment_status IN ('pending', 'paid', 'refunded'))
);

-- Tournament standings (team performance in tournament)
CREATE TABLE IF NOT EXISTS tournament_standings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    
    -- Standings data
    position INTEGER NOT NULL DEFAULT 0,
    matches_played INTEGER NOT NULL DEFAULT 0,
    matches_won INTEGER NOT NULL DEFAULT 0,
    matches_lost INTEGER NOT NULL DEFAULT 0,
    matches_drawn INTEGER NOT NULL DEFAULT 0,
    matches_abandoned INTEGER NOT NULL DEFAULT 0,
    
    -- Points
    points INTEGER NOT NULL DEFAULT 0,
    net_run_rate DECIMAL(10,4) DEFAULT 0.0000,
    
    -- Batting/Bowling stats
    runs_scored INTEGER DEFAULT 0,
    runs_conceded INTEGER DEFAULT 0,
    wickets_taken INTEGER DEFAULT 0,
    wickets_lost INTEGER DEFAULT 0,
    
    -- Additional stats as JSONB
    stats JSONB DEFAULT '{}', -- highest_score, lowest_score, etc.
    
    -- Timestamps
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique constraint
    UNIQUE(tournament_id, team_id)
);

-- Tournament matches (links matches to tournaments)
CREATE TABLE IF NOT EXISTS tournament_matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    
    -- Match info in tournament
    round_number INTEGER NOT NULL DEFAULT 1, -- 1 = Round of 16, 2 = Quarter Final, 3 = Semi Final, 4 = Final
    match_number INTEGER, -- Match number within round
    round_name VARCHAR(100), -- "Round of 16", "Quarter Final", "Semi Final", "Final", "Group A Match 1", etc.
    
    -- Bracket info (for knockout tournaments)
    bracket_position INTEGER, -- Position in bracket tree
    next_match_id UUID REFERENCES tournament_matches(id) ON DELETE SET NULL, -- Winner goes to this match
    
    -- Group info (for round robin/league tournaments)
    group_name VARCHAR(50), -- "Group A", "Group B", etc.
    
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique constraint
    UNIQUE(tournament_id, match_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_tournaments_status ON tournaments(status);
CREATE INDEX IF NOT EXISTS idx_tournaments_organizer ON tournaments(organizer_id);
CREATE INDEX IF NOT EXISTS idx_tournaments_dates ON tournaments(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_tournaments_type ON tournaments(tournament_type);

CREATE INDEX IF NOT EXISTS idx_tournament_registrations_tournament ON tournament_registrations(tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_registrations_team ON tournament_registrations(team_id);
CREATE INDEX IF NOT EXISTS idx_tournament_registrations_status ON tournament_registrations(status);

CREATE INDEX IF NOT EXISTS idx_tournament_standings_tournament ON tournament_standings(tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_standings_team ON tournament_standings(team_id);
CREATE INDEX IF NOT EXISTS idx_tournament_standings_position ON tournament_standings(tournament_id, position);
CREATE INDEX IF NOT EXISTS idx_tournament_standings_points ON tournament_standings(tournament_id, points DESC);

CREATE INDEX IF NOT EXISTS idx_tournament_matches_tournament ON tournament_matches(tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_match ON tournament_matches(match_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_round ON tournament_matches(tournament_id, round_number);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_group ON tournament_matches(tournament_id, group_name);
