# CricketApp Full Stack Stopper
# Stops both Backend and Frontend

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "    Stopping CricketApp Application" -ForegroundColor Red
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Stop backend
Write-Host "[1/2] Stopping Backend Server..." -ForegroundColor Yellow
$backendProcess = Get-Process -Name "main" -ErrorAction SilentlyContinue
if ($backendProcess) {
    Stop-Process -Name "main" -Force
    Write-Host "      Backend stopped successfully" -ForegroundColor Green
} else {
    Write-Host "      Backend is not running" -ForegroundColor Gray
}

# Stop Flutter (it runs as flutter process)
Write-Host ""
Write-Host "[2/2] Stopping Frontend Application..." -ForegroundColor Yellow
$flutterProcesses = Get-Process -Name "flutter" -ErrorAction SilentlyContinue
if ($flutterProcesses) {
    Stop-Process -Name "flutter" -Force
    Write-Host "      Frontend stopped successfully" -ForegroundColor Green
} else {
    Write-Host "      Frontend is not running" -ForegroundColor Gray
}

# Also stop any Chrome processes that might be running the app
$chromeProcesses = Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -like "*localhost:3000*"}
if ($chromeProcesses) {
    Write-Host ""
    Write-Host "Closing Chrome browser windows..." -ForegroundColor Yellow
    $chromeProcesses | Stop-Process -Force
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  APPLICATION STOPPED" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
