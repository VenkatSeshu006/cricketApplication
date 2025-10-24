-- Migration 006: Matches, Teams, and Players Management
-- This migration creates tables for cricket match management, team management, and player tracking

-- ================================================================
-- TEAMS TABLE
-- ================================================================
CREATE TABLE IF NOT EXISTS teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(50),
    logo_url TEXT,
    colors TEXT[],
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    captain_id UUID REFERENCES users(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT true,
    description TEXT,
    home_ground TEXT,
    stats JSONB DEFAULT '{}'::jsonb
);

-- ================================================================
-- PLAYERS TABLE
-- ================================================================
CREATE TABLE IF NOT EXISTS players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
    jersey_number INTEGER,
    playing_role VARCHAR(50) NOT NULL, -- Batsman, Bowler, All-rounder, Wicket-keeper
    batting_style VARCHAR(50), -- Right-handed, Left-handed
    bowling_style VARCHAR(50), -- Right-arm fast, Left-arm spin, etc.
    is_active BOOLEAN DEFAULT true,
    joined_date DATE DEFAULT CURRENT_DATE,
    
    -- Career Statistics (aggregated)
    total_matches INTEGER DEFAULT 0,
    total_runs INTEGER DEFAULT 0,
    total_wickets INTEGER DEFAULT 0,
    total_catches INTEGER DEFAULT 0,
    highest_score INTEGER DEFAULT 0,
    best_bowling VARCHAR(20), -- Format: "5/42"
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(team_id, jersey_number),
    UNIQUE(user_id, team_id)
);

-- ================================================================
-- MATCHES TABLE
-- ================================================================
CREATE TABLE IF NOT EXISTS matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    match_type VARCHAR(50) NOT NULL, -- Friendly, League, Tournament, Practice
    match_format VARCHAR(50) NOT NULL, -- T10, T20, One Day, Test
    overs INTEGER NOT NULL,
    
    -- Teams
    team_a_id UUID REFERENCES teams(id) ON DELETE CASCADE,
    team_b_id UUID REFERENCES teams(id) ON DELETE CASCADE,
    
    -- Venue and Schedule
    venue VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    match_date DATE NOT NULL,
    match_time TIME,
    
    -- Toss Details
    toss_winner_team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
    toss_decision VARCHAR(20), -- Bat, Bowl
    
    -- Match Officials
    umpire_1 VARCHAR(100),
    umpire_2 VARCHAR(100),
    third_umpire VARCHAR(100),
    referee VARCHAR(100),
    scorer VARCHAR(100),
    
    -- Match Status
    status VARCHAR(50) DEFAULT 'scheduled', -- scheduled, live, completed, cancelled, postponed
    result TEXT,
    winner_team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
    
    -- Additional Details
    tournament_id UUID, -- Will be linked when tournament service is created
    season VARCHAR(50),
    broadcast_channel VARCHAR(100),
    
    -- Metadata
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- MATCH_SQUADS TABLE (Players selected for a specific match)
-- ================================================================
CREATE TABLE IF NOT EXISTS match_squads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_id UUID REFERENCES matches(id) ON DELETE CASCADE,
    player_id UUID REFERENCES players(id) ON DELETE CASCADE,
    team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
    is_playing_11 BOOLEAN DEFAULT false,
    is_captain BOOLEAN DEFAULT false,
    is_vice_captain BOOLEAN DEFAULT false,
    batting_position INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(match_id, player_id)
);

-- ================================================================
-- INDEXES
-- ================================================================

-- Teams indexes
CREATE INDEX idx_teams_name ON teams(name);
CREATE INDEX idx_teams_created_by ON teams(created_by);
CREATE INDEX idx_teams_captain ON teams(captain_id);

-- Players indexes
CREATE INDEX idx_players_user_id ON players(user_id);
CREATE INDEX idx_players_team_id ON players(team_id);
CREATE INDEX idx_players_role ON players(playing_role);
CREATE INDEX idx_players_active ON players(is_active);

-- Matches indexes
CREATE INDEX idx_matches_date ON matches(match_date);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_type ON matches(match_type);
CREATE INDEX idx_matches_format ON matches(match_format);
CREATE INDEX idx_matches_team_a ON matches(team_a_id);
CREATE INDEX idx_matches_team_b ON matches(team_b_id);
CREATE INDEX idx_matches_winner ON matches(winner_team_id);
CREATE INDEX idx_matches_created_by ON matches(created_by);

-- Match squads indexes
CREATE INDEX idx_match_squads_match ON match_squads(match_id);
CREATE INDEX idx_match_squads_player ON match_squads(player_id);
CREATE INDEX idx_match_squads_team ON match_squads(team_id);
CREATE INDEX idx_match_squads_playing_11 ON match_squads(is_playing_11);

-- ================================================================
-- SAMPLE DATA
-- ================================================================

-- Insert sample teams
INSERT INTO teams (id, name, short_name, colors, home_ground, description) VALUES
('11111111-1111-1111-1111-111111111111', 'Dhaka Warriors', 'DW', ARRAY['#E91E63', '#880E4F'], 'Sher-e-Bangla National Stadium', 'Premier cricket team from Dhaka representing the city in national tournaments'),
('22222222-2222-2222-2222-222222222222', 'Chittagong Challengers', 'CC', ARRAY['#2196F3', '#0D47A1'], 'Zahur Ahmed Chowdhury Stadium', 'Historic team from the port city known for aggressive batting'),
('33333333-3333-3333-3333-333333333333', 'Sylhet Strikers', 'SS', ARRAY['#4CAF50', '#1B5E20'], 'Sylhet International Cricket Stadium', 'Dynamic team from the tea capital with strong bowling lineup'),
('44444444-4444-4444-4444-444444444444', 'Khulna Tigers', 'KT', ARRAY['#FF9800', '#E65100'], 'Sheikh Abu Naser Stadium', 'Fierce competitors from western Bangladesh'),
('55555555-5555-5555-5555-555555555555', 'Rajshahi Rangers', 'RR', ARRAY['#9C27B0', '#4A148C'], 'Shaheed Kamruzzaman Stadium', 'Well-balanced team with experienced players'),
('66666666-6666-6666-6666-666666666666', 'Comilla Victorians', 'CV', ARRAY['#00BCD4', '#006064'], 'Comilla Cricket Stadium', 'Champions of multiple seasons with star players');

-- Insert sample matches
INSERT INTO matches (id, title, match_type, match_format, overs, team_a_id, team_b_id, venue, city, match_date, match_time, status) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Dhaka Warriors vs Chittagong Challengers - Season Opener', 'League', 'T20', 20, '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Sher-e-Bangla National Stadium', 'Dhaka', '2025-10-26', '14:00:00', 'scheduled'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Sylhet Strikers vs Khulna Tigers - Weekend Clash', 'Friendly', 'One Day', 50, '33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444', 'Sylhet International Cricket Stadium', 'Sylhet', '2025-10-28', '10:00:00', 'scheduled'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Rajshahi Rangers vs Comilla Victorians - Practice Match', 'Practice', 'T10', 10, '55555555-5555-5555-5555-555555555555', '66666666-6666-6666-6666-666666666666', 'Shaheed Kamruzzaman Stadium', 'Rajshahi', '2025-10-25', '16:00:00', 'live');
