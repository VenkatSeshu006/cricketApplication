$files = @(
    "lib\features\dashboard\presentation\pages\all_pages_screen.dart",
    "lib\features\dashboard\presentation\pages\home_dashboard_screen.dart",
    "lib\features\dashboard\presentation\pages\main_shell.dart",
    "lib\features\hire_staff\presentation\pages\hire_staff_screen.dart",
    "lib\features\hire_staff\presentation\pages\staff_detail_page.dart",
    "lib\features\live_matches\presentation\pages\live_matches_screen.dart",
    "lib\features\network\presentation\pages\your_network_screen.dart",
    "lib\features\tournaments\presentation\pages\tournaments_screen.dart",
    "lib\features\tournaments\presentation\pages\upcoming_screen.dart",
    "lib\features\user_profile\presentation\pages\coach_profile_screen.dart",
    "lib\features\user_profile\presentation\pages\commentator_profile_screen.dart",
    "lib\features\user_profile\presentation\pages\doctor_profile_screen.dart",
    "lib\features\user_profile\presentation\pages\organiser_profile_screen.dart",
    "lib\features\user_profile\presentation\pages\player_profile_screen.dart",
    "lib\features\user_profile\presentation\pages\streamer_profile_screen.dart",
    "lib\features\user_profile\presentation\pages\umpire_profile_screen.dart",
    "lib\shared\widgets\custom_card.dart"
)

foreach ($file in $files) {
    $filePath = Join-Path "C:\Users\ASUS\Documents\CricketApp\frontend" $file
    if (Test-Path $filePath) {
        $content = Get-Content -Path $filePath -Raw
        $content = $content -replace '\.withOpacity\(', '.withValues(alpha: '
        Set-Content -Path $filePath -Value $content -NoNewline
        Write-Host "Fixed: $file"
    } else {
        Write-Host "File not found: $file" -ForegroundColor Red
    }
}

Write-Host "`nAll withOpacity replacements completed!" -ForegroundColor Green
