# Test Match Service - CricketApp Backend
# Tests all match management endpoints

$baseUrl = "http://localhost:8080/api/v1"
$green = "Green"
$red = "Red"
$yellow = "Yellow"
$cyan = "Cyan"

# Test counter
$testsPassed = 0
$testsFailed = 0

function Write-Test {
    param($message, $color = "White")
    Write-Host $message -ForegroundColor $color
}

# First, register and login to get a token
Write-Test "`n=== AUTHENTICATION ===" $cyan

$registerBody = @{
    email = "match_test@cricket.com"
    password = "Test@123"
    full_name = "Match Tester"
    phone = "+1234567890"
} | ConvertTo-Json

$loginBody = @{
    email = "match_test@cricket.com"
    password = "Test@123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -ErrorAction SilentlyContinue
    Write-Test "[OK] User registration successful" $green
} catch {
    Write-Test "  (User already exists - continuing with login)" $yellow
}

$loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
$token = $loginResponse.data.access_token
$userId = $loginResponse.data.user.id
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

Write-Test "[OK] Login successful - Token obtained" $green

# Generate unique team names using timestamp
$timestamp = (Get-Date).ToString("HHmmss")

# Test 1: Create Team A
Write-Test "`n=== TEST 1: Create Team A ===" $cyan
$teamABody = @{
    name = "Test Warriors $timestamp"
    short_name = "TW"
    colors = @("red", "white")
    description = "Test team for match service"
    home_ground = "Test Stadium"
} | ConvertTo-Json

try {
    $teamA = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Post -Body $teamABody -Headers $headers
    Write-Test "[OK] Team A created: $($teamA.name) (ID: $($teamA.id))" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to create Team A: $_" $red
    $testsFailed++
}

# Test 2: Create Team B
Write-Test "`n=== TEST 2: Create Team B ===" $cyan
$teamBBody = @{
    name = "Test Champions $timestamp"
    short_name = "TC"
    colors = @("blue", "gold")
    description = "Second test team"
    home_ground = "Champion Arena"
} | ConvertTo-Json

try {
    $teamB = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Post -Body $teamBBody -Headers $headers
    Write-Test "[OK] Team B created: $($teamB.name) (ID: $($teamB.id))" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to create Team B: $_" $red
    $testsFailed++
}

# Test 3: List All Teams
Write-Test "`n=== TEST 3: List All Teams ===" $cyan
try {
    $teamsList = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Get
    Write-Test "[OK] Retrieved $($teamsList.total) teams" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to list teams: $_" $red
    $testsFailed++
}

# Test 4: Get Team Details
Write-Test "`n=== TEST 4: Get Team Details ===" $cyan
try {
    $teamDetails = Invoke-RestMethod -Uri "$baseUrl/teams/$($teamA.id)" -Method Get
    Write-Test "[OK] Team details retrieved: $($teamDetails.name)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to get team details: $_" $red
    $testsFailed++
}

# Test 5: Create Match
Write-Test "`n=== TEST 5: Create Match ===" $cyan
$matchBody = @{
    title = "Test Championship Final"
    match_type = "tournament"
    match_format = "T20"
    team_a_id = $teamA.id
    team_b_id = $teamB.id
    match_date = (Get-Date).AddDays(7).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    match_time = "19:00"
    venue_name = "Test Stadium"
    venue_city = "Test City"
    total_overs = 20
    ball_type = "white"
    description = "Championship final match"
} | ConvertTo-Json

try {
    $match = Invoke-RestMethod -Uri "$baseUrl/matches" -Method Post -Body $matchBody -Headers $headers
    Write-Test "[OK] Match created: $($match.title)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to create match: $_" $red
    $testsFailed++
}

# Test 6: List Matches
Write-Test "`n=== TEST 6: List All Matches ===" $cyan
try {
    $matchesList = Invoke-RestMethod -Uri "$baseUrl/matches" -Method Get
    Write-Test "[OK] Retrieved $($matchesList.total) matches" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to list matches: $_" $red
    $testsFailed++
}

# Test 7: Filter Matches by Status
Write-Test "`n=== TEST 7: Filter Matches (upcoming) ===" $cyan
try {
    $upcomingMatches = Invoke-RestMethod -Uri "$baseUrl/matches?status=upcoming" -Method Get
    Write-Test "[OK] Retrieved $($upcomingMatches.total) upcoming matches" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to filter matches: $_" $red
    $testsFailed++
}

# Test 8: Get Match Details
Write-Test "`n=== TEST 8: Get Match Details ===" $cyan
try {
    $matchDetails = Invoke-RestMethod -Uri "$baseUrl/matches/$($match.id)" -Method Get
    Write-Test "[OK] Match details retrieved" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to get match details: $_" $red
    $testsFailed++
}

# Test 9: Update Match
Write-Test "`n=== TEST 9: Update Match Details ===" $cyan
$updateBody = @{
    title = "Test Championship Grand Final"
    description = "Updated championship final match"
} | ConvertTo-Json

try {
    $updatedMatch = Invoke-RestMethod -Uri "$baseUrl/matches/$($match.id)" -Method Put -Body $updateBody -Headers $headers
    Write-Test "[OK] Match updated: $($updatedMatch.title)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to update match: $_" $red
    $testsFailed++
}

# Test 10: Update Match Status
Write-Test "`n=== TEST 10: Update Match Status ===" $cyan
$statusBody = @{
    status = "live"
} | ConvertTo-Json

try {
    $liveMatch = Invoke-RestMethod -Uri "$baseUrl/matches/$($match.id)/status" -Method Put -Body $statusBody -Headers $headers
    Write-Test "[OK] Match status updated to: $($liveMatch.status)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to update match status: $_" $red
    $testsFailed++
}

# Test 11: Add Player to Team A
Write-Test "`n=== TEST 11: Add Player to Team A ===" $cyan
$playerBody = @{
    user_id = $userId
    team_id = $teamA.id
    jersey_number = 10
    role = "all-rounder"
    batting = "right-hand"
    bowling = "right-arm-fast"
} | ConvertTo-Json

try {
    $player = Invoke-RestMethod -Uri "$baseUrl/players" -Method Post -Body $playerBody -Headers $headers
    Write-Test "[OK] Player added to Team A (Jersey #$($player.jersey_number))" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to add player: $_" $red
    $testsFailed++
}

# Test 12: List Team Players
Write-Test "`n=== TEST 12: List Team Players ===" $cyan
try {
    $playersList = Invoke-RestMethod -Uri "$baseUrl/teams/$($teamA.id)/players" -Method Get
    Write-Test "[OK] Retrieved $($playersList.total) players from Team A" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to list players: $_" $red
    $testsFailed++
}

# Test 13: Update Team
Write-Test "`n=== TEST 13: Update Team ===" $cyan
$teamUpdateBody = @{
    name = "Test Warriors Updated"
    short_name = "TWU"
    colors = @("red", "white", "black")
    description = "Updated test team"
    home_ground = "New Test Stadium"
} | ConvertTo-Json

try {
    $updatedTeam = Invoke-RestMethod -Uri "$baseUrl/teams/$($teamA.id)" -Method Put -Body $teamUpdateBody -Headers $headers
    Write-Test "[OK] Team updated: $($updatedTeam.name)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to update team: $_" $red
    $testsFailed++
}

# Test 14: Delete Player
Write-Test "`n=== TEST 14: Remove Player ===" $cyan
try {
    Invoke-RestMethod -Uri "$baseUrl/players/$($player.id)" -Method Delete -Headers $headers
    Write-Test "[OK] Player removed successfully" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to remove player: $_" $red
    $testsFailed++
}

# Test 15: Delete Match
Write-Test "`n=== TEST 15: Delete Match ===" $cyan
$upcomingBody = @{ status = "upcoming" } | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/matches/$($match.id)/status" -Method Put -Body $upcomingBody -Headers $headers

try {
    Invoke-RestMethod -Uri "$baseUrl/matches/$($match.id)" -Method Delete -Headers $headers
    Write-Test "[OK] Match deleted successfully" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to delete match: $_" $red
    $testsFailed++
}

# Test 16: Delete Teams
Write-Test "`n=== TEST 16: Delete Teams ===" $cyan
try {
    Invoke-RestMethod -Uri "$baseUrl/teams/$($teamA.id)" -Method Delete -Headers $headers
    Invoke-RestMethod -Uri "$baseUrl/teams/$($teamB.id)" -Method Delete -Headers $headers
    Write-Test "[OK] Teams deleted successfully" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to delete teams: $_" $red
    $testsFailed++
}

# Summary
Write-Test "`n=== TEST SUMMARY ===" $cyan
Write-Test "Tests Passed: $testsPassed" $green
if ($testsFailed -eq 0) {
    Write-Test "Tests Failed: 0" $green
} else {
    Write-Test "Tests Failed: $testsFailed" $red
}
Write-Test "Total Tests: $($testsPassed + $testsFailed)" $cyan

if ($testsFailed -eq 0) {
    Write-Test "`nALL TESTS PASSED! Match Service is fully functional!" $green
} else {
    Write-Test "`nSome tests failed. Check the errors above." $red
}
