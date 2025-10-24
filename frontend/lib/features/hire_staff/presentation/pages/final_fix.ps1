# Final comprehensive fix for hire_staff_screen.dart
$file = "c:\Users\ASUS\Documents\CricketApp\frontend\lib\features\hire_staff\presentation\pages\hire_staff_screen.dart"
$content = Get-Content $file -Raw

# Fix corrupted EdgeInsets
$content = $content -replace "EdgeInsets\.all\(20Padding\(\)", "EdgeInsets.all(20)"

# Remove all remaining responsive. variable references
$content = $content -replace "responsive\.getValue\([^)]*\)", "80"
$content = $content -replace "responsive\.getTitle2\(\)", "const TextStyle(fontSize: 20)"
$content = $content -replace "responsive\.getBody\(\)", "const TextStyle(fontSize: 14)"
$content = $content -replace "responsive\.getCaption\(\)", "const TextStyle(fontSize: 12)"
$content = $content -replace "responsive\.getHeadline\(\)", "const TextStyle(fontSize: 18)"
$content = $content -replace "responsive\.getIconSize\([^)]*\)", "24"
$content = $content -replace "responsive\.", ""

# Remove IconSize enum references
$content = $content -replace ",\s*IconSize\.\w+", ""
$content = $content -replace "IconSize\.\w+,?", ""

# Fix any remaining const issues with TextStyle
$content = $content -replace "const TextStyle\(fontSize: \d+\)\.copyWith", "TextStyle"

# Set the content back
$content | Set-Content $file -NoNewline

Write-Host "Applied final fixes to hire_staff_screen.dart"
