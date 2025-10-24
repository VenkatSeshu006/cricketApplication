# Test Tournament Service - CricketApp Backend
# Tests all tournament management endpoints

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

# Authentication
Write-Test "`n=== AUTHENTICATION ===" $cyan

$loginBody = @{
    email = "test.player@cricketapp.com"
    password = "Cricket123!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.data.access_token
    $userId = $loginResponse.data.user.id
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    Write-Test "[OK] Login successful - Token obtained" $green
} catch {
    Write-Test "[FAIL] Login failed: $_" $red
    exit 1
}

# Test 1: Create Tournament
Write-Test "`n=== TEST 1: Create Tournament ===" $cyan
$tournamentBody = @{
    name = "Championship 2025"
    short_name = "C2025"
    description = "Annual cricket championship"
    tournament_type = "knockout"
    match_format = "T20"
    start_date = (Get-Date).AddDays(30).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    end_date = (Get-Date).AddDays(45).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    registration_deadline = (Get-Date).AddDays(20).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    max_teams = 16
    min_teams = 8
    entry_fee = 500.00
    prize_pool = 50000.00
    venue_name = "National Stadium"
    venue_city = "Mumbai"
    rules = @{
        points_per_win = 2
        points_per_draw = 1
        tie_breaker = "net_run_rate"
    }
} | ConvertTo-Json

try {
    $tournament = Invoke-RestMethod -Uri "$baseUrl/tournaments" -Method Post -Body $tournamentBody -Headers $headers
    Write-Test "[OK] Tournament created: $($tournament.name) (ID: $($tournament.id))" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to create tournament: $_" $red
    $testsFailed++
}

# Test 2: List Tournaments
Write-Test "`n=== TEST 2: List All Tournaments ===" $cyan
try {
    $tournamentsList = Invoke-RestMethod -Uri "$baseUrl/tournaments" -Method Get
    Write-Test "[OK] Retrieved $($tournamentsList.total) tournaments" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to list tournaments: $_" $red
    $testsFailed++
}

# Test 3: Get Tournament Details
Write-Test "`n=== TEST 3: Get Tournament Details ===" $cyan
try {
    $tournamentDetails = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)" -Method Get
    Write-Test "[OK] Tournament details retrieved: $($tournamentDetails.name)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to get tournament details: $_" $red
    $testsFailed++
}

# Test 4: Update Tournament
Write-Test "`n=== TEST 4: Update Tournament ===" $cyan
$updateBody = @{
    name = "Championship 2025 - Updated"
    prize_pool = 75000.00
} | ConvertTo-Json

try {
    $updatedTournament = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)" -Method Put -Body $updateBody -Headers $headers
    Write-Test "[OK] Tournament updated: $($updatedTournament.name)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to update tournament: $_" $red
    $testsFailed++
}

# Test 5: Open Registration
Write-Test "`n=== TEST 5: Open Registration ===" $cyan
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/open-registration" -Method Post -Headers $headers
    Write-Test "[OK] Registration opened" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to open registration: $_" $red
    $testsFailed++
}

# Test 6: Create Team for Registration
Write-Test "`n=== TEST 6: Create Team ===" $cyan
$timestamp = (Get-Date).ToString("HHmmss")
$teamBody = @{
    name = "Test Team $timestamp"
    short_name = "TT"
    colors = @("blue", "white")
} | ConvertTo-Json

try {
    $team = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Post -Body $teamBody -Headers $headers
    Write-Test "[OK] Team created: $($team.name)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to create team: $_" $red
    $testsFailed++
}

# Test 7: Register Team in Tournament
Write-Test "`n=== TEST 7: Register Team in Tournament ===" $cyan
$registrationBody = @{
    team_id = $team.id
    squad_size = 15
} | ConvertTo-Json

try {
    $registration = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/register" -Method Post -Body $registrationBody -Headers $headers
    Write-Test "[OK] Team registered: Status = $($registration.status)" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to register team: $_" $red
    $testsFailed++
}

# Test 8: List Registrations
Write-Test "`n=== TEST 8: List Tournament Registrations ===" $cyan
try {
    $registrations = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/registrations" -Method Get
    Write-Test "[OK] Retrieved $($registrations.total) registrations" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to list registrations: $_" $red
    $testsFailed++
}

# Test 9: Approve Registration
Write-Test "`n=== TEST 9: Approve Registration ===" $cyan
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/registrations/$($registration.id)/approve" -Method Post -Headers $headers
    Write-Test "[OK] Registration approved" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to approve registration: $_" $red
    $testsFailed++
}

# Test 10: Get Standings (should be empty initially)
Write-Test "`n=== TEST 10: Get Tournament Standings ===" $cyan
try {
    $standings = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/standings" -Method Get
    Write-Test "[OK] Retrieved $($standings.total) standings" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to get standings: $_" $red
    $testsFailed++
}

# Test 11: Get Tournament Matches (should be empty initially)
Write-Test "`n=== TEST 11: Get Tournament Matches ===" $cyan
try {
    $matches = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/matches" -Method Get
    Write-Test "[OK] Retrieved $($matches.total) matches" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to get tournament matches: $_" $red
    $testsFailed++
}

# Test 12: Close Registration
Write-Test "`n=== TEST 12: Close Registration ===" $cyan

# Create more teams to meet minimum requirement
for ($i = 1; $i -le 7; $i++) {
    $ts = (Get-Date).AddSeconds($i).ToString("HHmmss")
    $tb = @{ name = "Team $ts"; short_name = "T$i"; colors = @("red", "blue") } | ConvertTo-Json
    $t = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Post -Body $tb -Headers $headers
    $rb = @{ team_id = $t.id; squad_size = 15 } | ConvertTo-Json
    $r = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/register" -Method Post -Body $rb -Headers $headers
    Invoke-RestMethod -Uri "$baseUrl/registrations/$($r.id)/approve" -Method Post -Headers $headers | Out-Null
}

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/close-registration" -Method Post -Headers $headers
    Write-Test "[OK] Registration closed" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to close registration: $_" $red
    $testsFailed++
}

# Test 13: Start Tournament
Write-Test "`n=== TEST 13: Start Tournament ===" $cyan
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/start" -Method Post -Headers $headers
    Write-Test "[OK] Tournament started" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to start tournament: $_" $red
    $testsFailed++
}

# Test 14: Complete Tournament
Write-Test "`n=== TEST 14: Complete Tournament ===" $cyan
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)/complete" -Method Post -Headers $headers
    Write-Test "[OK] Tournament completed" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to complete tournament: $_" $red
    $testsFailed++
}

# Test 15: Delete Tournament
Write-Test "`n=== TEST 15: Delete Tournament ===" $cyan
try {
    Invoke-RestMethod -Uri "$baseUrl/tournaments/$($tournament.id)" -Method Delete -Headers $headers
    Write-Test "[OK] Tournament deleted successfully" $green
    $testsPassed++
} catch {
    Write-Test "[FAIL] Failed to delete tournament: $_" $red
    $testsFailed++
}

# Test Summary
Write-Test "`n=== TEST SUMMARY ===" $cyan
Write-Test "Tests Passed: $testsPassed" $green
Write-Test "Tests Failed: $testsFailed" $red
Write-Test "Total Tests: $($testsPassed + $testsFailed)" $cyan

if ($testsFailed -eq 0) {
    Write-Test "`nALL TESTS PASSED! Tournament Service is fully functional!" $green
} else {
    Write-Test "`nSome tests failed. Check the errors above." $yellow
}
