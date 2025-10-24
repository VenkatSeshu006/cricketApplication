# Test User Profile Endpoints

Write-Host "`n=== Testing User Profile API ===" -ForegroundColor Cyan

# Step 1: Login
Write-Host "`n1. Logging in..." -ForegroundColor Yellow
$loginBody = @{
    email = "testuser@cricket.com"
    password = "Pass123!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/login" `
        -Method POST `
        -Body $loginBody `
        -ContentType "application/json"
    
    $token = $loginResponse.data.access_token
    Write-Host "✅ Login successful!" -ForegroundColor Green
    Write-Host "Token: $($token.Substring(0, 50))..." -ForegroundColor Gray
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Get Profile
Write-Host "`n2. Getting user profile..." -ForegroundColor Yellow
$headers = @{
    "Authorization" = "Bearer $token"
}

try {
    $profileResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/users/profile" `
        -Method GET `
        -Headers $headers
    
    Write-Host "✅ Profile retrieved successfully!" -ForegroundColor Green
    Write-Host "`nProfile Data:" -ForegroundColor Cyan
    $profileResponse.data | Format-List
} catch {
    Write-Host "❌ Get profile failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Error details: $($_.ErrorDetails.Message)" -ForegroundColor Red
}

# Step 3: Update Profile
Write-Host "`n3. Updating profile..." -ForegroundColor Yellow
$updateBody = @{
    full_name = "Test User Updated"
    phone = "+919999888877"
    bio = "I love playing cricket!"
} | ConvertTo-Json

try {
    $updateResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/users/profile" `
        -Method PUT `
        -Body $updateBody `
        -Headers $headers `
        -ContentType "application/json"
    
    Write-Host "✅ Profile updated successfully!" -ForegroundColor Green
    Write-Host "`nUpdated Profile:" -ForegroundColor Cyan
    $updateResponse.data | Format-List
} catch {
    Write-Host "❌ Update profile failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Error details: $($_.ErrorDetails.Message)" -ForegroundColor Red
}

Write-Host "`n=== Test Complete ===" -ForegroundColor Cyan
