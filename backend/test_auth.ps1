# Test Auth Endpoints

## 1. Register a new user
$registerBody = @{
    email = "john@cricketapp.com"
    password = "Test123!"
    full_name = "John Doe"
    phone = "+919876543210"
    role = "player"
} | ConvertTo-Json

$registerResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/v1/auth/register" `
    -Method POST `
    -Body $registerBody `
    -ContentType "application/json"

Write-Host "=== REGISTER RESPONSE ===" -ForegroundColor Green
$registerResponse.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10

## 2. Login with the user
$loginBody = @{
    email = "john@cricketapp.com"
    password = "Test123!"
} | ConvertTo-Json

$loginResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/v1/auth/login" `
    -Method POST `
    -Body $loginBody `
    -ContentType "application/json"

Write-Host "`n=== LOGIN RESPONSE ===" -ForegroundColor Green
$loginResponse.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
