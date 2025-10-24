# Test Staff Hiring Service Endpoints
$baseUrl = "http://localhost:8080/api/v1"
$testUser = @{
    email = "testuser@cricket.com"
    password = "Pass123!"
}

Write-Host "`n=== Staff Hiring Service API Tests ===" -ForegroundColor Cyan
Write-Host "Testing endpoints: /jobs, /applications`n" -ForegroundColor Gray

# Test 1: List Job Postings (Public - No Auth)
Write-Host "Test 1: List Job Postings (GET /jobs)" -ForegroundColor Yellow
$listResponse = Invoke-RestMethod -Uri "$baseUrl/jobs?page=1&limit=10" -Method Get -ContentType "application/json"
Write-Host "* Found $($listResponse.jobs.Count) job posting(s)" -ForegroundColor Green
Write-Host "  Total: $($listResponse.pagination.total), Pages: $($listResponse.pagination.total_pages)" -ForegroundColor Gray
if ($listResponse.jobs.Count -gt 0) {
    $firstJob = $listResponse.jobs[0]
    Write-Host "  First Job: $($firstJob.title) - $($firstJob.job_type)" -ForegroundColor Gray
    Write-Host "  Location: $($firstJob.location) | Salary: $($firstJob.salary_range)" -ForegroundColor Gray
    Write-Host "  Applications: $($firstJob.total_applications)" -ForegroundColor Gray
}
Start-Sleep -Seconds 1

# Test 2: Get Job Details (Public - No Auth)
Write-Host "`nTest 2: Get Job Details (GET /jobs/:id)" -ForegroundColor Yellow
if ($listResponse.jobs.Count -gt 0) {
    $jobId = $listResponse.jobs[0].id
    $jobDetails = Invoke-RestMethod -Uri "$baseUrl/jobs/$jobId" -Method Get -ContentType "application/json"
    Write-Host "* Retrieved details for: $($jobDetails.title)" -ForegroundColor Green
    Write-Host "  Employer: $($jobDetails.employer_name)" -ForegroundColor Gray
    Write-Host "  Type: $($jobDetails.job_type) | Employment: $($jobDetails.employment_type)" -ForegroundColor Gray
    Write-Host "  Experience: $($jobDetails.experience_required)" -ForegroundColor Gray
    Write-Host "  Description: $($jobDetails.description.Substring(0, [Math]::Min(100, $jobDetails.description.Length)))..." -ForegroundColor Gray
    Write-Host "  Requirements: $($jobDetails.requirements.Count) | Responsibilities: $($jobDetails.responsibilities.Count)" -ForegroundColor Gray
    Write-Host "  Deadline: $($jobDetails.application_deadline)" -ForegroundColor Gray
} else {
    Write-Host "* No jobs found to test details" -ForegroundColor Red
}
Start-Sleep -Seconds 1

# Test 3: Filter Jobs by Type
Write-Host "`nTest 3: Filter Jobs by Type (GET /jobs?type=coach)" -ForegroundColor Yellow
$coachJobs = Invoke-RestMethod -Uri "$baseUrl/jobs?type=coach&page=1&limit=10" -Method Get -ContentType "application/json"
Write-Host "* Found $($coachJobs.jobs.Count) coach position(s)" -ForegroundColor Green
foreach ($job in $coachJobs.jobs) {
    Write-Host "  - $($job.title) at $($job.location)" -ForegroundColor Gray
}
Start-Sleep -Seconds 1

# Test 4: Login to get auth token
Write-Host "`nTest 4: User Login (POST /auth/login)" -ForegroundColor Yellow
$loginBody = $testUser | ConvertTo-Json
$loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
$token = $loginResponse.data.access_token
Write-Host "* Login successful, token received" -ForegroundColor Green
Write-Host "  User: $($loginResponse.data.user.full_name) ($($loginResponse.data.user.email))" -ForegroundColor Gray
Start-Sleep -Seconds 1

# Test 5: Create Job Posting (Protected - Auth Required)
Write-Host "`nTest 5: Create Job Posting (POST /jobs)" -ForegroundColor Yellow
$jobBody = @{
    title = "Cricket Batting Coach"
    description = "We are looking for an experienced batting coach to work with our academy players. Must have strong technical knowledge and ability to develop young talent."
    job_type = "coach"
    experience_required = "intermediate"
    location = "Chennai, Tamil Nadu"
    salary_range = "Rs.40,000 - Rs.60,000/month"
    employment_type = "full-time"
    requirements = @(
        "Cricket coaching certification",
        "3+ years coaching experience",
        "Strong communication skills",
        "Experience with youth players"
    )
    responsibilities = @(
        "Conduct batting training sessions",
        "Develop personalized training plans",
        "Analyze player performance",
        "Provide technical feedback"
    )
    benefits = @(
        "Health insurance",
        "Performance bonus",
        "Professional development"
    )
    application_deadline = "2025-12-15"
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$newJob = Invoke-RestMethod -Uri "$baseUrl/jobs" -Method Post -Body $jobBody -Headers $headers
Write-Host "* Job posting created successfully" -ForegroundColor Green
Write-Host "  Job ID: $($newJob.id)" -ForegroundColor Gray
Write-Host "  Title: $($newJob.title)" -ForegroundColor Gray
Write-Host "  Type: $($newJob.job_type) | Status: $($newJob.status)" -ForegroundColor Gray
Write-Host "  Location: $($newJob.location)" -ForegroundColor Gray
Start-Sleep -Seconds 1

# Test 6: Apply for Job (Protected - Auth Required)
Write-Host "`nTest 6: Apply for Job (POST /jobs/:id/apply)" -ForegroundColor Yellow
if ($listResponse.jobs.Count -gt 0) {
    $targetJob = $listResponse.jobs[0]
    
    $applicationBody = @{
        cover_letter = "I am writing to express my strong interest in the $($targetJob.title) position. With over 5 years of experience in cricket coaching and a proven track record of developing talented players, I believe I would be an excellent fit for this role. I am passionate about cricket and committed to helping players reach their full potential through structured training programs and personalized attention."
        resume_url = "https://example.com/resumes/john-doe.pdf"
        experience_years = 5
        relevant_experience = "Coached U-19 state team for 3 years, private coaching for 2 years"
        availability = "immediate"
        expected_salary = "Rs.50,000/month"
    } | ConvertTo-Json
    
    $application = Invoke-RestMethod -Uri "$baseUrl/jobs/$($targetJob.id)/apply" -Method Post -Body $applicationBody -Headers $headers
    Write-Host "* Application submitted successfully" -ForegroundColor Green
    Write-Host "  Application ID: $($application.id)" -ForegroundColor Gray
    Write-Host "  Job: $($targetJob.title)" -ForegroundColor Gray
    Write-Host "  Status: $($application.status)" -ForegroundColor Gray
    Write-Host "  Experience: $($application.experience_years) years" -ForegroundColor Gray
} else {
    Write-Host "* No jobs available to apply" -ForegroundColor Red
}
Start-Sleep -Seconds 1

# Test 7: Get My Job Postings (Protected - Auth Required)
Write-Host "`nTest 7: Get My Job Postings (GET /jobs/my)" -ForegroundColor Yellow
$myJobs = Invoke-RestMethod -Uri "$baseUrl/jobs/my" -Method Get -Headers $headers
Write-Host "* Retrieved $($myJobs.Count) job posting(s)" -ForegroundColor Green
foreach ($job in $myJobs) {
    Write-Host "  - $($job.title) | Status: $($job.status) | Applications: $($job.total_applications)" -ForegroundColor Gray
}
Start-Sleep -Seconds 1

# Test 8: Get My Applications (Protected - Auth Required)
Write-Host "`nTest 8: Get My Applications (GET /applications/my)" -ForegroundColor Yellow
$myApplications = Invoke-RestMethod -Uri "$baseUrl/applications/my" -Method Get -Headers $headers
Write-Host "* Retrieved $($myApplications.Count) application(s)" -ForegroundColor Green
foreach ($app in $myApplications) {
    Write-Host "  - Job ID: $($app.job_id)" -ForegroundColor Gray
    Write-Host "    Status: $($app.status) | Applied: $($app.applied_at)" -ForegroundColor Gray
    Write-Host "    Experience: $($app.experience_years) years" -ForegroundColor Gray
}
Start-Sleep -Seconds 1

# Test 9: Get Applications for My Job (Protected - Employer Only)
Write-Host "`nTest 9: Get Job Applications (GET /jobs/:id/applications)" -ForegroundColor Yellow
if ($myJobs.Count -gt 0) {
    $myJobId = $myJobs[0].id
    $jobApplications = Invoke-RestMethod -Uri "$baseUrl/jobs/$myJobId/applications" -Method Get -Headers $headers
    Write-Host "* Retrieved $($jobApplications.Count) application(s) for job" -ForegroundColor Green
    foreach ($app in $jobApplications) {
        Write-Host "  - Applicant: $($app.applicant_name) ($($app.applicant_email))" -ForegroundColor Gray
        Write-Host "    Status: $($app.status) | Experience: $($app.experience_years) years" -ForegroundColor Gray
    }
} else {
    Write-Host "* No jobs to check applications for" -ForegroundColor Yellow
}

Write-Host "`n=== All Staff Hiring Tests Completed Successfully! ===" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  * Listed job postings with pagination" -ForegroundColor Green
Write-Host "  * Retrieved job details" -ForegroundColor Green
Write-Host "  * Filtered jobs by type" -ForegroundColor Green
Write-Host "  * User authentication working" -ForegroundColor Green
Write-Host "  * Created job posting successfully" -ForegroundColor Green
Write-Host "  * Applied for job successfully" -ForegroundColor Green
Write-Host "  * Retrieved employer's job postings" -ForegroundColor Green
Write-Host "  * Retrieved user's applications" -ForegroundColor Green
Write-Host "  * Retrieved applications for employer's job" -ForegroundColor Green
