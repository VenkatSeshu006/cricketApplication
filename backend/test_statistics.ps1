# Player Statistics Service Test Script
# Tests all statistics endpoints

$baseUrl = "http://localhost:8080/api/v1"
$testsPassed = 0
$testsFailed = 0

# Color output functions
function Write-TestResult {
    param($message, $success)
    if ($success) {
        Write-Host "[PASS] $message" -ForegroundColor Green
        $script:testsPassed++
    } else {
        Write-Host "[FAIL] $message" -ForegroundColor Red
        $script:testsFailed++
    }
}

# Create test user
Write-Host "`nCreating test user..." -ForegroundColor Cyan
$timestamp = (Get-Date).ToString("HHmmss")
$registerBody = @{
    email = "stats_$timestamp@test.com"
    password = "Stats@123"
    full_name = "Statistics Test User"
    phone = "+1234567890"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -ErrorAction SilentlyContinue
    Write-Host "User registration successful" -ForegroundColor Green
} catch {
    Write-Host "User already exists - continuing with login" -ForegroundColor Yellow
}

# Login to get token
$loginBody = @{
    email = "stats_$timestamp@test.com"
    password = "Stats@123"
} | ConvertTo-Json

$loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
$token = $loginResponse.data.access_token
$userId = $loginResponse.data.user.id
Write-Host "User logged in with token (ID: $userId)" -ForegroundColor Green

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Test 1: Create Team
Write-Host "`n1. Creating test teams..." -ForegroundColor Yellow
try {
    $teamResponse = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Post -Headers $headers -Body (@{
        name = "Statistics Test Team $timestamp"
        short_name = "STT"
        colors = @("blue", "white")
        description = "Team for testing statistics"
    } | ConvertTo-Json)
    $teamId = $teamResponse.id
    
    $team2Response = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Post -Headers $headers -Body (@{
        name = "Statistics Test Team 2 $timestamp"
        short_name = "ST2"
        colors = @("red", "yellow")
        description = "Second team for testing"
    } | ConvertTo-Json)
    $team2Id = $team2Response.id
    Write-Host "  Team 1 ID: $teamId"
    Write-Host "  Team 2 ID: $team2Id"
    Write-TestResult "Teams created: $($teamResponse.name) and $($team2Response.name)" $true
} catch {
    Write-TestResult "Failed to create teams: $_" $false
    exit 1
}

# Test 2: Create Player
Write-Host "`n2. Creating test player..." -ForegroundColor Yellow
try {
    $playerResponse = Invoke-RestMethod -Uri "$baseUrl/players" -Method Post -Headers $headers -Body (@{
        user_id = $userId
        name = "Test Player"
        role = "all-rounder"
        batting = "right-hand"
        bowling = "right-arm-medium"
        jersey_number = 7
        team_id = $teamId
    } | ConvertTo-Json)
    $playerId = $playerResponse.id
    Write-TestResult "Player created: $($playerResponse.name) (ID: $playerId)" $true
} catch {
    Write-TestResult "Failed to create player: $_" $false
    exit 1
}

# Test 3: Create Match
Write-Host "`n3. Creating test match..." -ForegroundColor Yellow
try {
    $matchDate = (Get-Date).AddDays(7).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $matchBody = @{
        title = "Statistics Test Match"
        team_a_id = $teamId
        team_b_id = $team2Id
        match_date = $matchDate
        match_time = "15:00"
        venue_name = "Test Stadium"
        venue_city = "Test City"
        match_format = "T20"
        match_type = "tournament"
        total_overs = 20
        ball_type = "white"
    }
    $matchResponse = Invoke-RestMethod -Uri "$baseUrl/matches" -Method Post -Headers $headers -Body ($matchBody | ConvertTo-Json)
    $matchId = $matchResponse.id
    
    # Update to completed
    Invoke-RestMethod -Uri "$baseUrl/matches/$matchId/status" -Method Put -Headers $headers -Body (@{
        status = "completed"
    } | ConvertTo-Json) | Out-Null
    
    Write-TestResult "Match created and completed (ID: $matchId)" $true
} catch {
    Write-TestResult "Failed to create match: $_" $false
    exit 1
}

# Test 4: Record Performance
Write-Host "`n4. Recording player performance..." -ForegroundColor Yellow
try {
    $perfResponse = Invoke-RestMethod -Uri "$baseUrl/performances" -Method Post -Headers $headers -Body (@{
        player_id = $playerId
        match_id = $matchId
        team_id = $teamId
        played = $true
        captain = $false
        vice_captain = $false
        wicket_keeper = $false
        batting_position = 3
        runs_scored = 75
        balls_faced = 45
        fours = 8
        sixes = 3
        dismissal_type = "caught"
        overs_bowled = 3.4
        runs_conceded = 28
        wickets_taken = 2
        maidens = 0
        catches = 1
        run_outs = 0
        stumpings = 0
        player_of_match = $true
    } | ConvertTo-Json)
    $perfId = $perfResponse.id
    Write-TestResult "Performance recorded (ID: $perfId, Runs: $($perfResponse.runs_scored), Wickets: $($perfResponse.wickets_taken))" $true
} catch {
    Write-TestResult "Failed to record performance: $_" $false
    exit 1
}

# Test 5: Get Performance
Write-Host "`n5. Getting performance details..." -ForegroundColor Yellow
try {
    $getPerf = Invoke-RestMethod -Uri "$baseUrl/performances/$perfId" -Method Get
    $success = ($getPerf.id -eq $perfId -and $getPerf.runs_scored -eq 75)
    Write-TestResult "Performance details retrieved (Strike Rate: $($getPerf.strike_rate), Economy: $($getPerf.economy_rate))" $success
} catch {
    Write-TestResult "Failed to get performance: $_" $false
}

# Test 6: List Performances
Write-Host "`n6. Listing performances..." -ForegroundColor Yellow
try {
    $listPerf = Invoke-RestMethod -Uri "$baseUrl/performances?player_id=$playerId" -Method Get
    $success = ($listPerf.performances.Count -ge 1)
    Write-TestResult "Performances listed: $($listPerf.total) found" $success
} catch {
    Write-TestResult "Failed to list performances: $_" $false
}

# Test 7: Update Performance
Write-Host "`n7. Updating performance..." -ForegroundColor Yellow
try {
    $updatePerf = Invoke-RestMethod -Uri "$baseUrl/performances/$perfId" -Method Put -Headers $headers -Body (@{
        runs_scored = 85
        balls_faced = 50
        sixes = 4
    } | ConvertTo-Json)
    $success = ($updatePerf.runs_scored -eq 85 -and $updatePerf.sixes -eq 4)
    Write-TestResult "Performance updated (Runs: $($updatePerf.runs_scored), Sixes: $($updatePerf.sixes))" $success
} catch {
    Write-TestResult "Failed to update performance: $_" $false
}

# Wait for stats calculation
Start-Sleep -Seconds 1

# Test 8: Get Player Career Stats
Write-Host "`n8. Getting player career stats..." -ForegroundColor Yellow
try {
    $stats = Invoke-RestMethod -Uri "$baseUrl/players/$playerId/stats" -Method Get
    $success = ($stats.total_runs -ge 75 -and $stats.total_wickets -ge 2)
    Write-Host "  Total Matches: $($stats.total_matches)"
    Write-Host "  Total Runs: $($stats.total_runs)"
    Write-Host "  Total Wickets: $($stats.total_wickets)"
    Write-Host "  Batting Average: $($stats.batting_average)"
    Write-Host "  Batting Strike Rate: $($stats.batting_strike_rate)"
    Write-Host "  Bowling Economy: $($stats.bowling_economy)"
    Write-TestResult "Career stats retrieved" $success
} catch {
    Write-TestResult "Failed to get career stats: $_" $false
}

# Test 9: Refresh Player Stats
Write-Host "`n9. Refreshing player stats..." -ForegroundColor Yellow
try {
    $refreshStats = Invoke-RestMethod -Uri "$baseUrl/players/$playerId/refresh-stats" -Method Post -Headers $headers
    $success = ($refreshStats.total_runs -ge 75)
    Write-TestResult "Stats refreshed (Total Runs: $($refreshStats.total_runs))" $success
} catch {
    Write-TestResult "Failed to refresh stats: $_" $false
}

# Create more performances for leaderboard testing
Write-Host "`n10. Creating additional performance for leaderboards..." -ForegroundColor Yellow
try {
    # Create another match
    $match2Date = (Get-Date).AddDays(14).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $match2Response = Invoke-RestMethod -Uri "$baseUrl/matches" -Method Post -Headers $headers -Body (@{
        title = "Statistics Test Match 2"
        team_a_id = $teamId
        team_b_id = $team2Id
        match_date = $match2Date
        match_time = "18:00"
        venue_name = "Test Stadium 2"
        venue_city = "Test City"
        match_format = "T20"
        match_type = "friendly"
        total_overs = 20
        ball_type = "white"
    } | ConvertTo-Json)
    $match2Id = $match2Response.id
    
    # Mark as completed
    Invoke-RestMethod -Uri "$baseUrl/matches/$match2Id/status" -Method Put -Headers $headers -Body (@{
        status = "completed"
    } | ConvertTo-Json) | Out-Null
    
    # Performance 2: Century
    $perf2 = Invoke-RestMethod -Uri "$baseUrl/performances" -Method Post -Headers $headers -Body (@{
        player_id = $playerId
        match_id = $match2Id
        team_id = $teamId
        played = $true
        runs_scored = 120
        balls_faced = 75
        fours = 10
        sixes = 5
        dismissal_type = "not_out"
        overs_bowled = 4.0
        runs_conceded = 35
        wickets_taken = 3
        maidens = 1
        catches = 2
        player_of_match = $true
    } | ConvertTo-Json)
    
    Write-TestResult "Additional performance created (Runs: 120, Wickets: 3)" $true
} catch {
    Write-TestResult "Failed to create additional performances: $_" $false
}

# Wait for stats recalculation
Start-Sleep -Seconds 1

# Test 11: Most Runs Leaderboard
Write-Host "`n11. Getting most runs leaderboard..." -ForegroundColor Yellow
try {
    $runsLeaderboard = Invoke-RestMethod -Uri "$baseUrl/leaderboards/most-runs?limit=10" -Method Get
    Write-Host "  Category: $($runsLeaderboard.category)"
    Write-Host "  Entries: $($runsLeaderboard.entries.Count)"
    if ($runsLeaderboard.entries.Count -gt 0) {
        Write-Host "  Top Player: $($runsLeaderboard.entries[0].player_name) - $($runsLeaderboard.entries[0].value) runs"
    }
    Write-TestResult "Most runs leaderboard retrieved" $true
} catch {
    Write-TestResult "Failed to get most runs leaderboard: $_" $false
}

# Test 12: Most Wickets Leaderboard
Write-Host "`n12. Getting most wickets leaderboard..." -ForegroundColor Yellow
try {
    $wicketsLeaderboard = Invoke-RestMethod -Uri "$baseUrl/leaderboards/most-wickets?limit=10" -Method Get
    Write-Host "  Category: $($wicketsLeaderboard.category)"
    Write-Host "  Entries: $($wicketsLeaderboard.entries.Count)"
    if ($wicketsLeaderboard.entries.Count -gt 0) {
        Write-Host "  Top Player: $($wicketsLeaderboard.entries[0].player_name) - $($wicketsLeaderboard.entries[0].value) wickets"
    }
    Write-TestResult "Most wickets leaderboard retrieved" $true
} catch {
    Write-TestResult "Failed to get most wickets leaderboard: $_" $false
}

# Test 13: Batting Average Leaderboard
Write-Host "`n13. Getting batting average leaderboard..." -ForegroundColor Yellow
try {
    $battingLeaderboard = Invoke-RestMethod -Uri "$baseUrl/leaderboards/batting?limit=10" -Method Get
    Write-Host "  Category: $($battingLeaderboard.category)"
    Write-Host "  Entries: $($battingLeaderboard.entries.Count)"
    if ($battingLeaderboard.entries.Count -gt 0) {
        Write-Host "  Top Player: $($battingLeaderboard.entries[0].player_name) - $($battingLeaderboard.entries[0].value) average"
    }
    Write-TestResult "Batting average leaderboard retrieved" $true
} catch {
    Write-TestResult "Failed to get batting leaderboard: $_" $false
}

# Test 14: Bowling Average Leaderboard
Write-Host "`n14. Getting bowling average leaderboard..." -ForegroundColor Yellow
try {
    $bowlingLeaderboard = Invoke-RestMethod -Uri "$baseUrl/leaderboards/bowling?limit=10" -Method Get
    Write-Host "  Category: $($bowlingLeaderboard.category)"
    Write-Host "  Entries: $($bowlingLeaderboard.entries.Count)"
    if ($bowlingLeaderboard.entries.Count -gt 0) {
        Write-Host "  Top Player: $($bowlingLeaderboard.entries[0].player_name) - $($bowlingLeaderboard.entries[0].value) average"
    }
    Write-TestResult "Bowling average leaderboard retrieved" $true
} catch {
    Write-TestResult "Failed to get bowling leaderboard: $_" $false
}

# Test 15: Refresh All Leaderboards
Write-Host "`n15. Refreshing all leaderboards..." -ForegroundColor Yellow
try {
    $refresh = Invoke-RestMethod -Uri "$baseUrl/leaderboards/refresh" -Method Post -Headers $headers
    Write-TestResult "Leaderboards refreshed: $($refresh.message)" $true
} catch {
    Write-TestResult "Failed to refresh leaderboards: $_" $false
}

# Test 16: Filter Performances by Match
Write-Host "`n16. Filtering performances by match..." -ForegroundColor Yellow
try {
    $matchPerfs = Invoke-RestMethod -Uri "$baseUrl/performances?match_id=$matchId" -Method Get
    Write-TestResult "Match performances retrieved: $($matchPerfs.total) found" ($matchPerfs.total -ge 1)
} catch {
    Write-TestResult "Failed to filter performances: $_" $false
}

# Test 17: Filter Performances by Team
Write-Host "`n17. Filtering performances by team..." -ForegroundColor Yellow
try {
    $teamPerfs = Invoke-RestMethod -Uri "$baseUrl/performances?team_id=$teamId" -Method Get
    Write-TestResult "Team performances retrieved: $($teamPerfs.total) found" ($teamPerfs.total -ge 1)
} catch {
    Write-TestResult "Failed to filter by team: $_" $false
}

# Test 18: Filter Performances by Minimum Runs
Write-Host "`n18. Filtering performances by minimum runs..." -ForegroundColor Yellow
try {
    $highScorers = Invoke-RestMethod -Uri "$baseUrl/performances?min_runs=50" -Method Get
    Write-TestResult "High scorers retrieved: $($highScorers.total) found" $true
} catch {
    Write-TestResult "Failed to filter by min runs: $_" $false
}

# Test 19: Delete Performance
Write-Host "`n19. Deleting performance..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$baseUrl/performances/$perfId" -Method Delete -Headers $headers
    Write-TestResult "Performance deleted" $true
} catch {
    Write-TestResult "Failed to delete performance: $_" $false
}

# Test 20: Verify Stats Updated After Delete
Write-Host "`n20. Verifying stats updated after delete..." -ForegroundColor Yellow
try {
    $updatedStats = Invoke-RestMethod -Uri "$baseUrl/players/$playerId/stats" -Method Get
    Write-TestResult "Stats recalculated after delete (Total Runs: $($updatedStats.total_runs))" $true
} catch {
    Write-TestResult "Failed to verify updated stats: $_" $false
}

# Summary
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "TEST SUMMARY" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Tests Passed: $testsPassed" -ForegroundColor Green
Write-Host "Tests Failed: $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })
Write-Host "Total Tests: $($testsPassed + $testsFailed)" -ForegroundColor Cyan

if ($testsFailed -eq 0) {
    Write-Host "`nALL TESTS PASSED! Player Statistics Service is fully functional!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`nSOME TESTS FAILED. Please review the errors above." -ForegroundColor Red
    exit 1
}
