# Ultra comprehensive cleanup - Remove ALL ResponsiveHelper and enum references
$file = "c:\Users\ASUS\Documents\CricketApp\frontend\lib\features\hire_staff\presentation\pages\hire_staff_screen.dart"
$content = Get-Content $file -Raw

# Replace multiline ResponsiveHelper calls
$content = $content -replace "ResponsiveHelper\.getBorderRadius\(\s*context,\s*BorderRadiusSize\.\w+,?\s*\)", "12"
$content = $content -replace "ResponsiveHelper\.getIconSize\(\s*context,\s*IconSize\.\w+,?\s*\)", "24"
$content = $content -replace "ResponsiveHelper\.getCardPadding\(context\)", "const EdgeInsets.all(16)"
$content = $content -replace "ResponsiveHelper\.getGridColumns\(context\)", "2"

# Replace single-line ResponsiveHelper references that might remain
$content = $content -replace "ResponsiveHelper\.\w+\([^\)]*\)", "16"

# Remove BorderRadiusSize and IconSize enum references
$content = $content -replace ",\s*BorderRadiusSize\.\w+", ""
$content = $content -replace "BorderRadiusSize\.\w+,?", ""
$content = $content -replace ",\s*IconSize\.\w+", ""
$content = $content -replace "IconSize\.\w+,?", ""

# Remove responsive variable
$content = $content -replace "responsive\.\w+\([^\)]*\)", "16"
$content = $content -replace "responsive", ""

# Remove comments mentioning ResponsiveHelper
$content = $content -replace "//\s*Use ResponsiveHelper.*", "// Use responsive grid"

$content | Set-Content $file -NoNewline

Write-Host "Applied ultra-comprehensive cleanup to hire_staff_screen.dart"
