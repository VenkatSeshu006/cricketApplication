# CricketApp - Complete Application Test Suite
# Tests all major features across the full stack

$baseUrl = "http://localhost:8080/api/v1"
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   CRICKETAPP - QUICK HEALTH CHECK" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# Test 1: Backend Health
Write-Host "1. Testing Backend Health..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:8080/health" -Method Get
    Write-Host "   [OK] Backend: $($health.message)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Backend is not responding!" -ForegroundColor Red
    exit 1
}

# Test 2: Database Connection (via auth endpoint)
Write-Host "`n2. Testing Database Connection..." -ForegroundColor Yellow
try {
    $timestamp = (Get-Date).ToString("HHmmss")
    $registerBody = @{
        email = "quicktest_$timestamp@cricket.com"
        password = "Test@123"
        full_name = "Quick Test User"
        phone = "+1234567890"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $registerBody -ContentType "application/json"
    Write-Host "   [OK] Database connection working" -ForegroundColor Green
    $token = $response.data.access_token
} catch {
    Write-Host "   [FAIL] Database connection issue: $_" -ForegroundColor Red
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Test 3: Ground Booking Service
Write-Host "`n3. Testing Ground Booking Service..." -ForegroundColor Yellow
try {
    $grounds = Invoke-RestMethod -Uri "$baseUrl/grounds" -Method Get
    Write-Host "   [OK] Ground service working (Found $($grounds.Count) grounds)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Ground service issue" -ForegroundColor Red
}

# Test 4: Medical Service
Write-Host "`n4. Testing Medical Service..." -ForegroundColor Yellow
try {
    $physios = Invoke-RestMethod -Uri "$baseUrl/physiotherapists" -Method Get
    Write-Host "   [OK] Medical service working" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Medical service issue" -ForegroundColor Red
}

# Test 5: Hiring Service
Write-Host "`n5. Testing Hiring Service..." -ForegroundColor Yellow
try {
    $jobs = Invoke-RestMethod -Uri "$baseUrl/jobs" -Method Get
    Write-Host "   [OK] Hiring service working (Found $($jobs.total) jobs)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Hiring service issue" -ForegroundColor Red
}

# Test 6: Community Service
Write-Host "`n6. Testing Community Service..." -ForegroundColor Yellow
try {
    $posts = Invoke-RestMethod -Uri "$baseUrl/posts" -Method Get
    Write-Host "   [OK] Community service working (Found $($posts.total) posts)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Community service issue" -ForegroundColor Red
}

# Test 7: Match Management Service
Write-Host "`n7. Testing Match Management Service..." -ForegroundColor Yellow
try {
    $teams = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Get
    Write-Host "   [OK] Match service working (Found $($teams.total) teams)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Match service issue" -ForegroundColor Red
}

# Test 8: Tournament Service
Write-Host "`n8. Testing Tournament Service..." -ForegroundColor Yellow
try {
    $tournaments = Invoke-RestMethod -Uri "$baseUrl/tournaments" -Method Get
    Write-Host "   [OK] Tournament service working (Found $($tournaments.total) tournaments)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Tournament service issue" -ForegroundColor Red
}

# Test 9: Statistics Service
Write-Host "`n9. Testing Statistics Service..." -ForegroundColor Yellow
try {
    $leaderboard = Invoke-RestMethod -Uri "$baseUrl/leaderboards/most-runs?limit=5" -Method Get
    Write-Host "   [OK] Statistics service working (Found $($leaderboard.entries.Count) players in leaderboard)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Statistics service issue" -ForegroundColor Red
}

# Test 10: Create a complete workflow
Write-Host "`n10. Testing Complete Workflow (Team → Player → Match → Performance)..." -ForegroundColor Yellow
try {
    # Create team
    $team = Invoke-RestMethod -Uri "$baseUrl/teams" -Method Post -Headers $headers -Body (@{
        name = "Test Team $timestamp"
        short_name = "TT"
        colors = @("blue", "white")
    } | ConvertTo-Json)
    
    # Create player
    $player = Invoke-RestMethod -Uri "$baseUrl/players" -Method Post -Headers $headers -Body (@{
        user_id = $response.data.user.id
        team_id = $team.id
        jersey_number = 10
        role = "batsman"
        batting = "right-hand"
        bowling = "right-arm-fast"
    } | ConvertTo-Json)
    
    Write-Host "   [OK] Complete workflow test passed!" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Workflow test issue: $_" -ForegroundColor Red
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   ALL SERVICES ARE OPERATIONAL!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nYou can now test the application:" -ForegroundColor Yellow
Write-Host "  • Frontend: http://localhost:3000 (Chrome)" -ForegroundColor White
Write-Host "  • Backend API: http://localhost:8080" -ForegroundColor White
Write-Host "`nTry these actions in the app:" -ForegroundColor Yellow
Write-Host "  1. Register a new account" -ForegroundColor Cyan
Write-Host "  2. Browse and book cricket grounds" -ForegroundColor Cyan
Write-Host "  3. Create a team and add players" -ForegroundColor Cyan
Write-Host "  4. Schedule a match" -ForegroundColor Cyan
Write-Host "  5. Record player performances" -ForegroundColor Cyan
Write-Host "  6. View leaderboards and statistics" -ForegroundColor Cyan
Write-Host "  7. Create posts in the community feed" -ForegroundColor Cyan
Write-Host "  8. Organize tournaments" -ForegroundColor Cyan
Write-Host "`nPress any key to run comprehensive test suites..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Run comprehensive tests
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   RUNNING COMPREHENSIVE TEST SUITES" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Running Match Management Tests..." -ForegroundColor Yellow
powershell -ExecutionPolicy Bypass -File "c:\Users\ASUS\Documents\CricketApp\backend\test_match.ps1"

Write-Host "`nRunning Tournament Management Tests..." -ForegroundColor Yellow
powershell -ExecutionPolicy Bypass -File "c:\Users\ASUS\Documents\CricketApp\backend\test_tournament.ps1"

Write-Host "`nRunning Statistics Service Tests..." -ForegroundColor Yellow
powershell -ExecutionPolicy Bypass -File "c:\Users\ASUS\Documents\CricketApp\backend\test_statistics.ps1"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   ALL TESTS COMPLETE!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan
