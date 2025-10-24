# Deploy Backend Update Script
# This script uploads the updated auth service and rebuilds the backend

$KEY_PATH = "C:\Users\ASUS\Documents\CricketApp\Secret Key\cricket-app-keypair.pem"
$EC2_IP = "13.233.117.234"
$EC2_USER = "ubuntu"
$BACKEND_PATH = "../backend"

Write-Host "🚀 Deploying Backend Update..." -ForegroundColor Cyan

# Step 1: Copy the updated file to EC2
Write-Host "`n📤 Uploading updated auth_service.go..." -ForegroundColor Yellow
scp -i $KEY_PATH "$BACKEND_PATH/internal/auth/service/auth_service.go" "${EC2_USER}@${EC2_IP}:~/cricket-backend/internal/auth/service/"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ File uploaded successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to upload file" -ForegroundColor Red
    exit 1
}

# Step 2: Rebuild and restart the backend
Write-Host "`n🔨 Rebuilding backend on EC2..." -ForegroundColor Yellow
ssh -i $KEY_PATH "${EC2_USER}@${EC2_IP}" @"
cd cricket-backend
echo '🔨 Building Go binary...'
go build -o main .
echo '🔄 Restarting Docker container...'
docker-compose down
docker-compose up -d
echo '✅ Deployment complete!'
docker ps
echo '📋 Recent logs:'
docker logs cricket-backend-backend-1 --tail 20
"@

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Backend updated and restarted successfully!" -ForegroundColor Green
    Write-Host "`n🔍 Testing the endpoint..." -ForegroundColor Cyan
    
    # Test the registration endpoint
    $testBody = @{
        email = "test$(Get-Random)@example.com"
        password = "Test123!"
        full_name = "Test User"
        role = "player"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "http://$EC2_IP:8080/api/v1/auth/register" -Method Post -Body $testBody -ContentType "application/json"
        Write-Host "✅ Registration test successful!" -ForegroundColor Green
        Write-Host "User created: $($response.data.user.email)" -ForegroundColor Cyan
    } catch {
        Write-Host "⚠️  Test registration: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n❌ Deployment failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 All done! You can now test the app." -ForegroundColor Green
