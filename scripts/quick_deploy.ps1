# Quick Deploy - Build locally and upload to EC2
# This script builds the backend locally and uploads it to EC2

$KEY_PATH = "C:\Users\ASUS\Documents\CricketApp\Secret Key\cricket-app-keypair.pem"
$EC2_IP = "13.233.117.234"
$EC2_USER = "ubuntu"

Write-Host "🚀 Quick Deploy to EC2..." -ForegroundColor Cyan

# Step 1: Build backend locally for Linux
Write-Host "`n🔨 Building backend for Linux..." -ForegroundColor Yellow

Push-Location ..\backend

$env:GOOS = "linux"
$env:GOARCH = "amd64"
$env:CGO_ENABLED = "0"

Write-Host "Building with GOOS=$env:GOOS GOARCH=$env:GOARCH..." -ForegroundColor Gray
& go build -o main .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backend built successfully" -ForegroundColor Green
    if (Test-Path ".\main") {
        Write-Host "✅ Binary file created: $(Get-Item .\main | Select-Object -ExpandProperty Length) bytes" -ForegroundColor Green
    }
} else {
    Write-Host "❌ Failed to build backend" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Step 2: Upload the binary to EC2
Write-Host "`n📤 Uploading binary to EC2..." -ForegroundColor Yellow

$binaryPath = ".\main"
if (-not (Test-Path $binaryPath)) {
    Write-Host "❌ Binary file not found at: $binaryPath" -ForegroundColor Red
    Pop-Location
    exit 1
}

& scp -i $KEY_PATH $binaryPath "${EC2_USER}@${EC2_IP}:~/cricket-backend/"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Binary uploaded successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to upload binary" -ForegroundColor Red
    Pop-Location
    exit 1
}

Pop-Location

# Step 3: Restart the Docker container
Write-Host "`n🔄 Restarting backend on EC2..." -ForegroundColor Yellow
ssh -i $KEY_PATH "${EC2_USER}@${EC2_IP}" @"
cd cricket-backend
echo '🔄 Stopping container...'
docker-compose down
echo '🚀 Starting container...'
docker-compose up -d
echo '⏳ Waiting for container to start...'
sleep 5
echo '📋 Container status:'
docker ps
echo ''
echo '📝 Recent logs:'
docker logs cricket-backend-backend-1 --tail 20
"@

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Backend deployed successfully!" -ForegroundColor Green
    
    # Step 4: Test the endpoint
    Write-Host "`n🧪 Testing registration endpoint..." -ForegroundColor Cyan
    Start-Sleep -Seconds 3
    
    $testBody = @{
        email = "testuser$(Get-Random)@example.com"
        password = "Test123!"
        full_name = "Test User"
        role = "player"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "http://${EC2_IP}:8080/api/v1/auth/register" -Method Post -Body $testBody -ContentType "application/json"
        Write-Host "✅ Registration test PASSED!" -ForegroundColor Green
        Write-Host "Created user: $($response.data.user.email) with role: $($response.data.user.role)" -ForegroundColor Cyan
    } catch {
        $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "⚠️  Registration response: $($errorDetails.message)" -ForegroundColor Yellow
    }
    
    Write-Host "`n🎉 Deployment complete!" -ForegroundColor Green
    Write-Host "Backend URL: http://${EC2_IP}:8080" -ForegroundColor Cyan
} else {
    Write-Host "`n❌ Failed to restart backend" -ForegroundColor Red
    exit 1
}

# Clean up environment variables
Remove-Item Env:\GOOS
Remove-Item Env:\GOARCH
Remove-Item Env:\CGO_ENABLED
