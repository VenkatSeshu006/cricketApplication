# Backend Deployment Status Checker
# Run this script to verify your backend deployment

param(
    [string]$EC2_IP = "",
    [string]$KeyPairPath = "C:\Users\ASUS\Documents\CricketApp\Secret Key\cricket-app-keypair.pem"
)

Write-Host "CricketApp Backend Deployment Status Checker" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if keypair exists
if (Test-Path $KeyPairPath) {
    Write-Host "[OK] AWS KeyPair found: cricket-app-keypair.pem" -ForegroundColor Green
} else {
    Write-Host "[ERROR] AWS KeyPair not found!" -ForegroundColor Red
    Write-Host "Expected location: $KeyPairPath" -ForegroundColor Yellow
    exit 1
}

# If no IP provided, ask user
if ($EC2_IP -eq "") {
    Write-Host ""
    Write-Host "Please provide your EC2 instance details:" -ForegroundColor Yellow
    Write-Host ""
    $EC2_IP = Read-Host "Enter your EC2 Public IP (or press Enter to skip)"
    
    if ($EC2_IP -eq "") {
        Write-Host ""
        Write-Host "[INFO] No EC2 IP provided. Checking local deployment only..." -ForegroundColor Yellow
        Write-Host ""
        
        # Check local backend
        Write-Host "Checking local backend (localhost:8080)..." -ForegroundColor Cyan
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -TimeoutSec 5 -UseBasicParsing
            if ($response.StatusCode -eq 200) {
                Write-Host "[OK] Local backend is RUNNING!" -ForegroundColor Green
                Write-Host "URL: http://localhost:8080" -ForegroundColor White
                Write-Host "Status: $($response.Content)" -ForegroundColor White
            }
        } catch {
            Write-Host "[ERROR] Local backend is NOT running!" -ForegroundColor Red
            Write-Host "Start it with: cd backend; go run main.go" -ForegroundColor Yellow
        }
        
        Write-Host ""
        Write-Host "To check cloud deployment, run: .\check_deployment.ps1 -EC2_IP '54.123.45.67'" -ForegroundColor Cyan
        exit 0
    }
}

Write-Host ""
Write-Host "Checking Deployment Status..." -ForegroundColor Cyan
Write-Host ""

# 1. Check if EC2 instance is reachable
Write-Host "1. Testing EC2 Connectivity..." -ForegroundColor White
$pingResult = Test-Connection -ComputerName $EC2_IP -Count 2 -Quiet -ErrorAction SilentlyContinue
if ($pingResult) {
    Write-Host "[OK] EC2 instance is reachable ($EC2_IP)" -ForegroundColor Green
} else {
    Write-Host "[WARN] EC2 instance is not responding to ping" -ForegroundColor Yellow
    Write-Host "This might be normal if ICMP is disabled" -ForegroundColor Gray
}

Write-Host ""

# 2. Check backend API health
Write-Host "2. Testing Backend API..." -ForegroundColor White
$apiUrl = "http://${EC2_IP}:8080/health"
try {
    $response = Invoke-WebRequest -Uri $apiUrl -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Backend API is LIVE!" -ForegroundColor Green
        Write-Host "URL: $apiUrl" -ForegroundColor White
        Write-Host "Response: $($response.Content)" -ForegroundColor White
    }
} catch {
    Write-Host "[ERROR] Backend API is NOT accessible!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible reasons:" -ForegroundColor Yellow
    Write-Host "- Backend not deployed yet" -ForegroundColor Gray
    Write-Host "- Backend not running (check with SSH)" -ForegroundColor Gray
    Write-Host "- Security group not allowing port 8080" -ForegroundColor Gray
    Write-Host "- Wrong IP address" -ForegroundColor Gray
}

Write-Host ""

# 3. Test API endpoints
Write-Host "3. Testing API Endpoints..." -ForegroundColor White
$endpoints = @("/api/v1/health", "/api/v1/auth/register")

foreach ($endpoint in $endpoints) {
    $url = "http://${EC2_IP}:8080$endpoint"
    try {
        $response = Invoke-WebRequest -Uri $url -TimeoutSec 5 -Method GET -UseBasicParsing -ErrorAction Stop
        Write-Host "[OK] $endpoint - Status: $($response.StatusCode)" -ForegroundColor Green
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode) {
            Write-Host "[WARN] $endpoint - Status: $statusCode" -ForegroundColor Yellow
        } else {
            Write-Host "[ERROR] $endpoint - Not accessible" -ForegroundColor Red
        }
    }
}

Write-Host ""

# 4. SSH Connection Test
Write-Host "4. Testing SSH Connection..." -ForegroundColor White
Write-Host "To connect to your EC2 instance:" -ForegroundColor White
Write-Host "ssh -i `"$KeyPairPath`" ubuntu@$EC2_IP" -ForegroundColor Cyan

Write-Host ""

# Summary
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "EC2 IP: $EC2_IP" -ForegroundColor White
Write-Host "API URL: http://${EC2_IP}:8080/api/v1" -ForegroundColor White
Write-Host "KeyPair: cricket-app-keypair.pem" -ForegroundColor White
Write-Host ""

# Next steps
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "If backend is NOT running:" -ForegroundColor Yellow
Write-Host "1. SSH into EC2: ssh -i `"$KeyPairPath`" ubuntu@$EC2_IP" -ForegroundColor White
Write-Host "2. Check if Docker is running: docker ps" -ForegroundColor White
Write-Host "3. Check logs: docker logs cricketapp_backend" -ForegroundColor White
Write-Host "4. Start backend: cd ~/cricketapp && docker-compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "If backend is RUNNING:" -ForegroundColor Green
Write-Host "1. Update your Flutter app API config" -ForegroundColor White
Write-Host "2. Change baseUrl to: http://${EC2_IP}:8080" -ForegroundColor White
Write-Host "3. Test from mobile device" -ForegroundColor White
Write-Host ""

# Additional info
Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host "- Cloud Setup: CLOUD_DEPLOYMENT_GUIDE.md" -ForegroundColor White
Write-Host "- Quick Guide: QUICK_CLOUD_SETUP.md" -ForegroundColor White
Write-Host "- DevOps Tutorial: DEVOPS_DEPLOYMENT_TUTORIAL.md" -ForegroundColor White
Write-Host ""
