# Test Ground Booking Endpoints

Write-Host "`n=== Testing Ground Booking API ===" -ForegroundColor Cyan

# Step 1: List all grounds (public, no auth)
Write-Host "`n1. Listing all grounds..." -ForegroundColor Yellow
try {
    $groundsResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/grounds?page=1&limit=10" -Method GET
    Write-Host "✅ Grounds retrieved successfully!" -ForegroundColor Green
    Write-Host "`nFound $($groundsResponse.data.grounds.Count) grounds:" -ForegroundColor Cyan
    $groundsResponse.data.grounds | ForEach-Object {
        Write-Host "  - $($_.name) (₹$($_.hourly_price)/hr) - Rating: $($_.rating)" -ForegroundColor White
    }
    $firstGroundId = $groundsResponse.data.grounds[0].id
} catch {
    Write-Host "❌ List grounds failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Get ground details
Write-Host "`n2. Getting ground details..." -ForegroundColor Yellow
try {
    $groundDetailResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/grounds/$firstGroundId" -Method GET
    Write-Host "✅ Ground details retrieved!" -ForegroundColor Green
    Write-Host "`nGround: $($groundDetailResponse.data.name)" -ForegroundColor Cyan
    Write-Host "Address: $($groundDetailResponse.data.address)" -ForegroundColor Gray
    Write-Host "Facilities: $($groundDetailResponse.data.facilities -join ', ')" -ForegroundColor Gray
    Write-Host "Pricing: Hourly=₹$($groundDetailResponse.data.hourly_price), Half-day=₹$($groundDetailResponse.data.half_day_price), Full-day=₹$($groundDetailResponse.data.full_day_price)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Get ground details failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Login to create booking
Write-Host "`n3. Logging in..." -ForegroundColor Yellow
$loginBody = @{
    email = "testuser@cricket.com"
    password = "Pass123!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.data.access_token
    Write-Host "✅ Login successful!" -ForegroundColor Green
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 4: Create a booking
Write-Host "`n4. Creating a booking..." -ForegroundColor Yellow
$bookingBody = @{
    ground_id = $firstGroundId
    booking_date = "2025-11-15"
    start_time = "09:00"
    end_time = "12:00"
    duration_type = "hourly"
    notes = "Team practice session"
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $token"
}

try {
    $bookingResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/bookings" -Method POST -Body $bookingBody -Headers $headers -ContentType "application/json"
    Write-Host "✅ Booking created successfully!" -ForegroundColor Green
    Write-Host "`nBooking Details:" -ForegroundColor Cyan
    $bookingResponse.data | Format-List
} catch {
    Write-Host "❌ Create booking failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Error details: $($_.ErrorDetails.Message)" -ForegroundColor Red
}

# Step 5: Get user's bookings
Write-Host "`n5. Getting user bookings..." -ForegroundColor Yellow
try {
    $myBookingsResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/bookings/my" -Method GET -Headers $headers
    Write-Host "✅ User bookings retrieved!" -ForegroundColor Green
    Write-Host "`nYou have $($myBookingsResponse.data.Count) booking(s):" -ForegroundColor Cyan
    $myBookingsResponse.data | Select-Object -First 5 | ForEach-Object {
        Write-Host "  - Date: $($_.booking_date) | Time: $($_.start_time)-$($_.end_time) | Status: $($_.status) | Price: ₹$($_.total_price)" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Get bookings failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== Test Complete ===" -ForegroundColor Cyan
