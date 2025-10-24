# CricketApp Full Stack Launcher
# Starts both Backend and Frontend together

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "    CricketApp Full Stack Application Launcher" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if backend is already running
$backendProcess = Get-Process -Name "main" -ErrorAction SilentlyContinue
if ($backendProcess) {
    Write-Host "[INFO] Backend is already running (PID: $($backendProcess.Id))" -ForegroundColor Yellow
} else {
    Write-Host "[1/2] Starting Backend Server..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd c:\Users\ASUS\Documents\CricketApp\backend; Write-Host '=== BACKEND SERVER ===' -ForegroundColor Green; Write-Host 'Running on: http://localhost:8080' -ForegroundColor Cyan; Write-Host 'API: http://localhost:8080/api/v1' -ForegroundColor Cyan; Write-Host ''; .\main.exe"
    
    Write-Host "      Backend server starting on http://localhost:8080" -ForegroundColor Green
    Start-Sleep -Seconds 3
}

Write-Host ""
Write-Host "[2/2] Starting Frontend Application..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd c:\Users\ASUS\Documents\CricketApp\frontend; Write-Host '=== FRONTEND APPLICATION ===' -ForegroundColor Green; Write-Host 'Running on: http://localhost:3000' -ForegroundColor Cyan; Write-Host 'Connecting to backend: http://localhost:8080' -ForegroundColor Cyan; Write-Host ''; flutter run -d chrome --web-port 3000"

Write-Host "      Frontend starting on http://localhost:3000" -ForegroundColor Green

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  APPLICATION IS STARTING!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend:  http://localhost:8080" -ForegroundColor White
Write-Host "Frontend: http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "Two PowerShell windows will open:" -ForegroundColor Yellow
Write-Host "  1. Backend Server (Go)" -ForegroundColor Yellow
Write-Host "  2. Frontend App (Flutter)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Wait for both to start, then open your browser to:" -ForegroundColor Cyan
Write-Host "  http://localhost:3000" -ForegroundColor Green
Write-Host ""
Write-Host "To stop the application:" -ForegroundColor Yellow
Write-Host "  - Close both PowerShell windows OR" -ForegroundColor Yellow
Write-Host "  - Press Ctrl+C in each window" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to continue or Ctrl+C to cancel..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
