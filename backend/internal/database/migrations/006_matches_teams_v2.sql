-- Migration 006: Match Management System
-- Creates tables for teams, players, matches, and match squads

-- Teams table
CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(50) NOT NULL,
    logo_url TEXT,
    colors TEXT[] NOT NULL,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    captain_id UUID REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    description TEXT,
    home_ground TEXT,
    stats JSONB DEFAULT '{}'::jsonb
);

-- Players table
CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    jersey_number INTEGER NOT NULL,
    role VARCHAR(50) NOT NULL,
    batting VARCHAR(50) NOT NULL,
    bowling VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    career_stats JSONB DEFAULT '{}'::jsonb,
    UNIQUE(team_id, jersey_number),
    UNIQUE(user_id, team_id)
);

-- Matches table
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    match_type VARCHAR(50) NOT NULL,
    match_format VARCHAR(50) NOT NULL,
    team_a_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    team_b_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    match_date DATE NOT NULL,
    match_time VARCHAR(10) NOT NULL,
    ground_id UUID REFERENCES grounds(id),
    venue_name VARCHAR(255) NOT NULL,
    venue_city VARCHAR(100) NOT NULL,
    total_overs INTEGER NOT NULL,
    ball_type VARCHAR(20) NOT NULL,
    toss JSONB DEFAULT '{}'::jsonb,
    officials JSONB DEFAULT '{}'::jsonb,
    status VARCHAR(20) DEFAULT 'upcoming',
    result JSONB DEFAULT '{}'::jsonb,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);

-- Match squads table
CREATE TABLE match_squads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    in_playing_11 BOOLEAN DEFAULT false,
    is_captain BOOLEAN DEFAULT false,
    is_vice_captain BOOLEAN DEFAULT false,
    is_wicket_keeper BOOLEAN DEFAULT false,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(match_id, player_id)
);

-- Indexes for teams
CREATE INDEX idx_teams_name ON teams(name);
CREATE INDEX idx_teams_created_by ON teams(created_by);
CREATE INDEX idx_teams_captain ON teams(captain_id);

-- Indexes for players
CREATE INDEX idx_players_user_id ON players(user_id);
CREATE INDEX idx_players_team_id ON players(team_id);
CREATE INDEX idx_players_role ON players(role);
CREATE INDEX idx_players_active ON players(is_active);

-- Indexes for matches
CREATE INDEX idx_matches_date ON matches(match_date);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_type ON matches(match_type);
CREATE INDEX idx_matches_format ON matches(match_format);
CREATE INDEX idx_matches_team_a ON matches(team_a_id);
CREATE INDEX idx_matches_team_b ON matches(team_b_id);
CREATE INDEX idx_matches_created_by ON matches(created_by);
CREATE INDEX idx_matches_ground ON matches(ground_id);

-- Indexes for match squads
CREATE INDEX idx_match_squads_match ON match_squads(match_id);
CREATE INDEX idx_match_squads_player ON match_squads(player_id);
CREATE INDEX idx_match_squads_team ON match_squads(team_id);
CREATE INDEX idx_match_squads_playing_11 ON match_squads(in_playing_11);

-- Sample data
INSERT INTO teams (id, name, short_name, colors, home_ground, description) VALUES
('11111111-1111-1111-1111-111111111111', 'Dhaka Warriors', 'DW', ARRAY['#E91E63', '#880E4F'], 'Sher-e-Bangla National Stadium', 'Premier cricket team from Dhaka'),
('22222222-2222-2222-2222-222222222222', 'Chittagong Challengers', 'CC', ARRAY['#2196F3', '#0D47A1'], 'Zahur Ahmed Chowdhury Stadium', 'Historic team from the port city'),
('33333333-3333-3333-3333-333333333333', 'Sylhet Strikers', 'SS', ARRAY['#4CAF50', '#1B5E20'], 'Sylhet International Cricket Stadium', 'Dynamic team from the tea capital'),
('44444444-4444-4444-4444-444444444444', 'Khulna Tigers', 'KT', ARRAY['#FF9800', '#E65100'], 'Sheikh Abu Naser Stadium', 'Fierce competitors from western Bangladesh'),
('55555555-5555-5555-5555-555555555555', 'Rajshahi Rangers', 'RR', ARRAY['#9C27B0', '#4A148C'], 'Shaheed Kamruzzaman Stadium', 'Well-balanced team with experienced players'),
('66666666-6666-6666-6666-666666666666', 'Comilla Victorians', 'CV', ARRAY['#00BCD4', '#006064'], 'Comilla Cricket Stadium', 'Champions of multiple seasons');

INSERT INTO matches (id, title, match_type, match_format, team_a_id, team_b_id, match_date, match_time, venue_name, venue_city, total_overs, ball_type, status) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Dhaka Warriors vs Chittagong Challengers', 'league', 'T20', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2025-10-26', '14:00', 'Sher-e-Bangla National Stadium', 'Dhaka', 20, 'white', 'upcoming'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Sylhet Strikers vs Khulna Tigers', 'friendly', 'T20', '33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444', '2025-10-28', '10:00', 'Sylhet International Cricket Stadium', 'Sylhet', 20, 'white', 'upcoming'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Rajshahi Rangers vs Comilla Victorians', 'practice', 'T10', '55555555-5555-5555-5555-555555555555', '66666666-6666-6666-6666-666666666666', 'Shaheed Kamruzzaman Stadium', 'Rajshahi', 10, 'red', 'upcoming');
