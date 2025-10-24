# Manual Backend Update Instructions

## Quick Test of Local Changes

Write-Host "Testing password hashing speed..." -ForegroundColor Cyan

# Test the updated backend locally
cd ..\backend

# Start local backend
Write-Host "`nStarting local backend on port 8080..." -ForegroundColor Yellow
Start-Process -FilePath "go" -ArgumentList "run", "main.go" -NoNewWindow

Start-Sleep -Seconds 3

# Test registration speed
Write-Host "`nTesting registration speed..." -ForegroundColor Cyan
$body = @{
    email = "speedtest$(Get-Random)@test.com"
    password = "Test123!"
    full_name = "Speed Test"
    role = "player"
} | ConvertTo-Json

$time = Measure-Command {
    try {
        $result = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/register" -Method Post -Body $body -ContentType "application/json"
        Write-Host "✅ Registration successful" -ForegroundColor Green
    } catch {
        Write-Host "❌ Registration failed: $_" -ForegroundColor Red
    }
}

Write-Host "`nRegistration took: $($time.TotalMilliseconds)ms" -ForegroundColor $(if ($time.TotalMilliseconds -lt 1000) { "Green" } else { "Yellow" })

Write-Host "`n=== TO DEPLOY TO EC2 ===" -ForegroundColor Cyan
Write-Host @"

1. Build for Linux:
   cd backend
   `$env:GOOS = "linux"; `$env:GOARCH = "amd64"; go build -o main .

2. Upload using WinSCP or FileZilla:
   - Host: 13.233.117.234
   - User: ubuntu  
   - Key: C:\Users\ASUS\Documents\CricketApp\Secret Key\cricket-app-keypair.pem
   - Upload 'main' to /home/ubuntu/cricket-backend/

3. SSH and restart (using PuTTY or another SSH client):
   cd cricket-backend
   chmod +x main
   pkill -f './main'
   nohup ./main > backend.log 2>&1 &

"@ -ForegroundColor Yellow
