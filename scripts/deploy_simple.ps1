#!/usr/bin/env pwsh
# Simple deployment script

$ErrorActionPreference = "Stop"

$KEY = "C:\Users\ASUS\Documents\CricketApp\Secret Key\cricket-app-keypair.pem"
$EC2 = "ubuntu@13.233.117.234"

Write-Host "=== Building Backend ===" -ForegroundColor Cyan
Set-Location ..\backend

$env:GOOS = "linux"
$env:GOARCH = "amd64"  
$env:CGO_ENABLED = "0"

Write-Host "Running: go build -o main ." -ForegroundColor Yellow
go build -o main .

if (Test-Path ".\main") {
    $size = (Get-Item ".\main").Length
    Write-Host "SUCCESS: Binary created ($size bytes)" -ForegroundColor Green
} else {
    Write-Host "ERROR: Binary not created" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Uploading to EC2 ===" -ForegroundColor Cyan
Write-Host "Running: scp main to EC2..." -ForegroundColor Yellow
scp -i $KEY ".\main" "${EC2}:~/cricket-backend/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Upload failed" -ForegroundColor Red
    exit 1
}
Write-Host "SUCCESS: Upload complete" -ForegroundColor Green

Write-Host "`n=== Restarting Backend ===" -ForegroundColor Cyan
ssh -i $KEY $EC2 "cd cricket-backend && docker-compose down && docker-compose up -d && sleep 3 && docker logs cricket-backend-backend-1 --tail 10"

Write-Host "`n=== DEPLOYMENT COMPLETE ===" -ForegroundColor Green
Write-Host "Backend is running at: http://13.233.117.234:8080" -ForegroundColor Cyan

Set-Location ..\scripts
