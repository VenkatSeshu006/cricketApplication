# 🏗️ Build Android APK with Cloud Backend
# This script builds a production APK that connects to your AWS backend

param(
    [switch]$Clean = $false,
    [switch]$Release = $true
)

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  CricketApp - Android APK Builder" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to frontend directory
$frontendPath = "C:\Users\ASUS\Documents\CricketApp\frontend"
Set-Location $frontendPath

Write-Host "[INFO] Current directory: $frontendPath" -ForegroundColor Yellow
Write-Host ""

# Step 1: Verify API Configuration
Write-Host "Step 1: Verifying API Configuration..." -ForegroundColor Cyan
Write-Host "---------------------------------------" -ForegroundColor Gray

$apiConfigPath = "lib\core\config\api_config.dart"
$apiConfig = Get-Content $apiConfigPath -Raw

if ($apiConfig -match "USE_CLOUD_BACKEND\s*=\s*true") {
    Write-Host "[OK] Cloud backend enabled" -ForegroundColor Green
} else {
    Write-Host "[WARN] Cloud backend not enabled!" -ForegroundColor Yellow
}

if ($apiConfig -match "13\.233\.117\.234") {
    Write-Host "[OK] Backend URL: http://13.233.117.234:8080/api/v1" -ForegroundColor Green
} else {
    Write-Host "[WARN] Backend URL not configured!" -ForegroundColor Yellow
}

Write-Host ""

# Step 2: Test Backend Connectivity
Write-Host "Step 2: Testing Backend Connectivity..." -ForegroundColor Cyan
Write-Host "---------------------------------------" -ForegroundColor Gray

try {
    $response = Invoke-WebRequest -Uri "http://13.233.117.234:8080/health" -TimeoutSec 5 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Backend is LIVE and reachable!" -ForegroundColor Green
        Write-Host "Response: $($response.Content)" -ForegroundColor White
    }
} catch {
    Write-Host "[ERROR] Backend is NOT reachable!" -ForegroundColor Red
    Write-Host "Please check if backend is running: .\check_deployment.ps1" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue with build anyway? (y/n)"
    if ($continue -ne "y") {
        exit 1
    }
}

Write-Host ""

# Step 3: Clean build (optional)
if ($Clean) {
    Write-Host "Step 3: Cleaning previous builds..." -ForegroundColor Cyan
    Write-Host "---------------------------------------" -ForegroundColor Gray
    
    flutter clean
    Write-Host "[OK] Clean completed" -ForegroundColor Green
    Write-Host ""
}

# Step 4: Get dependencies
Write-Host "Step 4: Getting Flutter dependencies..." -ForegroundColor Cyan
Write-Host "---------------------------------------" -ForegroundColor Gray

flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to get dependencies!" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Dependencies installed" -ForegroundColor Green
Write-Host ""

# Step 5: Check for errors
Write-Host "Step 5: Analyzing code..." -ForegroundColor Cyan
Write-Host "---------------------------------------" -ForegroundColor Gray

$analysisResult = flutter analyze 2>&1
$criticalErrors = $analysisResult | Select-String -Pattern "error •" -CaseSensitive

if ($criticalErrors) {
    Write-Host "[WARN] Found errors in code:" -ForegroundColor Yellow
    $criticalErrors | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    Write-Host ""
    $continue = Read-Host "Continue with build anyway? (y/n)"
    if ($continue -ne "y") {
        exit 1
    }
} else {
    Write-Host "[OK] No critical errors found" -ForegroundColor Green
}

Write-Host ""

# Step 6: Build APK
Write-Host "Step 6: Building Android APK..." -ForegroundColor Cyan
Write-Host "---------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "This may take 5-10 minutes..." -ForegroundColor Yellow
Write-Host ""

$buildType = if ($Release) { "release" } else { "debug" }

Write-Host "Building $buildType APK..." -ForegroundColor White
flutter build apk --$buildType

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[OK] Build completed successfully!" -ForegroundColor Green
Write-Host ""

# Step 7: Locate APK
Write-Host "Step 7: Locating APK file..." -ForegroundColor Cyan
Write-Host "---------------------------------------" -ForegroundColor Gray

$apkPath = "build\app\outputs\flutter-apk\app-$buildType.apk"

if (Test-Path $apkPath) {
    $apkFile = Get-Item $apkPath
    $apkSizeMB = [math]::Round($apkFile.Length / 1MB, 2)
    
    Write-Host "[OK] APK built successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Location: $($apkFile.FullName)" -ForegroundColor White
    Write-Host "Size: $apkSizeMB MB" -ForegroundColor White
    Write-Host "Type: $buildType" -ForegroundColor White
    Write-Host ""
    
    # Copy to easy location
    $easyPath = "C:\Users\ASUS\Documents\CricketApp\cricketapp-$buildType.apk"
    Copy-Item $apkPath $easyPath -Force
    Write-Host "[OK] APK copied to: $easyPath" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "[ERROR] APK file not found at expected location!" -ForegroundColor Red
    exit 1
}

# Step 8: Summary
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Build Summary" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend URL: http://13.233.117.234:8080/api/v1" -ForegroundColor White
Write-Host "APK Location: $easyPath" -ForegroundColor White
Write-Host "APK Size: $apkSizeMB MB" -ForegroundColor White
Write-Host "Build Type: $buildType" -ForegroundColor White
Write-Host ""

# Step 9: Installation Instructions
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Installation Instructions" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Option 1: USB Installation" -ForegroundColor Yellow
Write-Host "--------------------------" -ForegroundColor Gray
Write-Host "1. Enable USB Debugging on your phone" -ForegroundColor White
Write-Host "2. Connect phone via USB" -ForegroundColor White
Write-Host "3. Run: flutter install" -ForegroundColor Cyan
Write-Host ""
Write-Host "Option 2: Manual Installation" -ForegroundColor Yellow
Write-Host "--------------------------" -ForegroundColor Gray
Write-Host "1. Transfer APK to your phone:" -ForegroundColor White
Write-Host "   - Via USB cable" -ForegroundColor Gray
Write-Host "   - Via WhatsApp/Telegram" -ForegroundColor Gray
Write-Host "   - Via Google Drive/Dropbox" -ForegroundColor Gray
Write-Host "2. On your phone, tap the APK file" -ForegroundColor White
Write-Host "3. Allow 'Install from Unknown Sources'" -ForegroundColor White
Write-Host "4. Install and open the app" -ForegroundColor White
Write-Host ""
Write-Host "Option 3: ADB Install" -ForegroundColor Yellow
Write-Host "--------------------------" -ForegroundColor Gray
Write-Host "adb install `"$easyPath`"" -ForegroundColor Cyan
Write-Host ""

# Step 10: Testing Checklist
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Testing Checklist" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[ ] Backend is running (http://13.233.117.234:8080)" -ForegroundColor Yellow
Write-Host "[ ] Phone has internet connection" -ForegroundColor Yellow
Write-Host "[ ] Phone can reach 13.233.117.234:8080" -ForegroundColor Yellow
Write-Host "[ ] App can register new user" -ForegroundColor Yellow
Write-Host "[ ] App can login" -ForegroundColor Yellow
Write-Host "[ ] App can view profile" -ForegroundColor Yellow
Write-Host ""

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Install APK on your Android device" -ForegroundColor White
Write-Host "2. Test user registration" -ForegroundColor White
Write-Host "3. Test login functionality" -ForegroundColor White
Write-Host "4. Report any issues" -ForegroundColor White
Write-Host ""
Write-Host "For testing, you can use these test accounts:" -ForegroundColor Cyan
Write-Host "See: TEST_ACCOUNTS.md" -ForegroundColor Gray
Write-Host ""
Write-Host "Build completed successfully! 🎉" -ForegroundColor Green
Write-Host ""
