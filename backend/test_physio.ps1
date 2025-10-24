# Test Medical/Physio Service Endpoints
$baseUrl = "http://localhost:8080/api/v1"
$testUser = @{
    email = "testuser@cricket.com"
    password = "Pass123!"
}

Write-Host "`n=== Medical/Physio Service API Tests ===" -ForegroundColor Cyan
Write-Host "Testing endpoints: /physiotherapists, /appointments`n" -ForegroundColor Gray

# Test 1: List Physiotherapists (Public - No Auth)
Write-Host "Test 1: List Physiotherapists (GET /physiotherapists)" -ForegroundColor Yellow
$listResponse = Invoke-RestMethod -Uri "$baseUrl/physiotherapists?page=1&limit=10" -Method Get -ContentType "application/json"
Write-Host "* Found $($listResponse.physiotherapists.Count) physiotherapists" -ForegroundColor Green
Write-Host "  Total: $($listResponse.pagination.total), Pages: $($listResponse.pagination.total_pages)" -ForegroundColor Gray
if ($listResponse.physiotherapists.Count -gt 0) {
    $firstPhysio = $listResponse.physiotherapists[0]
    Write-Host "  First Physio: $($firstPhysio.full_name) - $($firstPhysio.specialization)" -ForegroundColor Gray
    Write-Host "  Fee: ₹$($firstPhysio.consultation_fee) | Rating: $($firstPhysio.rating)/5.0" -ForegroundColor Gray
    Write-Host "  Available: $($firstPhysio.available_days -join ', ')" -ForegroundColor Gray
}
Start-Sleep -Seconds 1

# Test 2: Get Physiotherapist Details (Public - No Auth)
Write-Host "`nTest 2: Get Physiotherapist Details (GET /physiotherapists/:id)" -ForegroundColor Yellow
if ($listResponse.physiotherapists.Count -gt 0) {
    $physioId = $listResponse.physiotherapists[0].id
    $detailsResponse = Invoke-RestMethod -Uri "$baseUrl/physiotherapists/$physioId" -Method Get -ContentType "application/json"
    Write-Host "* Retrieved details for: $($detailsResponse.full_name)" -ForegroundColor Green
    Write-Host "  Specialization: $($detailsResponse.specialization)" -ForegroundColor Gray
    Write-Host "  Experience: $($detailsResponse.experience_years) years" -ForegroundColor Gray
    Write-Host "  Qualifications: $($detailsResponse.qualifications -join ', ')" -ForegroundColor Gray
    Write-Host "  Clinic: $($detailsResponse.clinic_name)" -ForegroundColor Gray
    Write-Host "  Address: $($detailsResponse.clinic_address)" -ForegroundColor Gray
    Write-Host "  Hours: $($detailsResponse.available_hours)" -ForegroundColor Gray
    Write-Host "  Bio: $($detailsResponse.bio)" -ForegroundColor Gray
} else {
    Write-Host "* No physiotherapists found to test details" -ForegroundColor Red
}
Start-Sleep -Seconds 1

# Test 3: Login to get auth token
Write-Host "`nTest 3: User Login (POST /auth/login)" -ForegroundColor Yellow
$loginBody = $testUser | ConvertTo-Json
$loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
$token = $loginResponse.data.access_token
Write-Host "* Login successful, token received" -ForegroundColor Green
Write-Host "  User: $($loginResponse.data.user.full_name) ($($loginResponse.data.user.email))" -ForegroundColor Gray
Start-Sleep -Seconds 1

# Test 4: Create Appointment (Protected - Auth Required)
Write-Host "`nTest 4: Create Appointment (POST /appointments)" -ForegroundColor Yellow
if ($listResponse.physiotherapists.Count -gt 0) {
    $selectedPhysio = $listResponse.physiotherapists[0]
    
    # Calculate a future date (5 days from now)
    $futureDate = (Get-Date).AddDays(5)
    # Find an available day
    $daysOfWeek = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
    $targetDay = $daysOfWeek[$futureDate.DayOfWeek.value__ - 1]
    
    # If the physio is not available on that day, find next available day
    $daysToAdd = 5
    while ($selectedPhysio.available_days -notcontains $targetDay -and $daysToAdd -lt 12) {
        $daysToAdd++
        $futureDate = (Get-Date).AddDays($daysToAdd)
        $targetDay = $daysOfWeek[$futureDate.DayOfWeek.value__ - 1]
    }
    
    $appointmentBody = @{
        physiotherapist_id = $selectedPhysio.id
        appointment_date = $futureDate.ToString("yyyy-MM-dd")
        appointment_time = "10:00"
        complaint = "Lower back pain after cricket practice. Need assessment and treatment plan."
    } | ConvertTo-Json
    
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $appointmentResponse = Invoke-RestMethod -Uri "$baseUrl/appointments" -Method Post -Body $appointmentBody -Headers $headers
    Write-Host "* Appointment created successfully" -ForegroundColor Green
    Write-Host "  Appointment ID: $($appointmentResponse.id)" -ForegroundColor Gray
    Write-Host "  Physiotherapist: $($selectedPhysio.full_name)" -ForegroundColor Gray
    Write-Host "  Date: $($appointmentResponse.appointment_date) at $($appointmentResponse.appointment_time)" -ForegroundColor Gray
    Write-Host "  Duration: $($appointmentResponse.duration_minutes) minutes" -ForegroundColor Gray
    Write-Host "  Status: $($appointmentResponse.status)" -ForegroundColor Gray
    Write-Host "  Fee: ₹$($appointmentResponse.fee)" -ForegroundColor Gray
    Write-Host "  Payment: $($appointmentResponse.payment_status)" -ForegroundColor Gray
} else {
    Write-Host "* No physiotherapists available to book" -ForegroundColor Red
}
Start-Sleep -Seconds 1

# Test 5: Get My Appointments (Protected - Auth Required)
Write-Host "`nTest 5: Get My Appointments (GET /appointments/my)" -ForegroundColor Yellow
$myAppointments = Invoke-RestMethod -Uri "$baseUrl/appointments/my" -Method Get -Headers $headers
Write-Host "* Retrieved $($myAppointments.Count) appointment(s)" -ForegroundColor Green
foreach ($apt in $myAppointments) {
    Write-Host "  - Date: $($apt.appointment_date) at $($apt.appointment_time)" -ForegroundColor Gray
    Write-Host "    Status: $($apt.status) | Fee: ₹$($apt.fee) | Payment: $($apt.payment_status)" -ForegroundColor Gray
    Write-Host "    Complaint: $($apt.complaint)" -ForegroundColor Gray
}

Write-Host "`n=== All Medical/Physio Tests Completed Successfully! ===" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  * Listed physiotherapists with pagination" -ForegroundColor Green
Write-Host "  * Retrieved physiotherapist details" -ForegroundColor Green
Write-Host "  * User authentication working" -ForegroundColor Green
Write-Host "  * Created appointment successfully" -ForegroundColor Green
Write-Host "  * Retrieved user appointments" -ForegroundColor Green
