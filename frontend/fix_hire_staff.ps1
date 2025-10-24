# Fix hire_staff_screen.dart responsive references

$file = "c:\Users\ASUS\Documents\CricketApp\frontend\lib\features\hire_staff\presentation\pages\hire_staff_screen.dart"
$content = Get-Content -Path $file -Raw

# Remove the responsive import line (no longer needed for now)
# Keep it since ResponsiveHelper is used statically

# Remove the instance variable usage and replace with const values temporarily
$content = $content -replace 'responsive\.getSpacingMedium\(\)', '16'
$content = $content -replace 'responsive\.getSpacingSmall\(\)', '8'
$content = $content -replace 'responsive\.getSpacingLarge\(\)', '24'
$content = $content -replace 'responsive\.getCardPadding\(\)', 'const EdgeInsets.all(20)'
$content = $content -replace 'responsive\.getPagePadding\(\)', 'const EdgeInsets.all(24)'
$content = $content -replace 'responsive\.getTitle1\(\)\.', 'const TextStyle(fontSize: 28).'
$content = $content -replace 'responsive\.getTitle2\(\)\.', 'const TextStyle(fontSize: 32).'
$content = $content -replace 'responsive\.getHeadline\(\)\.', 'const TextStyle(fontSize: 18).'
$content = $content -replace 'responsive\.getBody\(\)\.', 'const TextStyle(fontSize: 14).'
$content = $content -replace 'responsive\.getBody\(\)', 'const TextStyle(fontSize: 14)'
$content = $content -replace 'responsive\.getCaption\(\)\.', 'const TextStyle(fontSize: 11).'
$content = $content -replace 'responsive\.getBorderRadius\(BorderRadiusSize\.large\)', '16'
$content = $content -replace 'responsive\.getBorderRadius\(BorderRadiusSize\.medium\)', '12'
$content = $content -replace 'responsive\.getBorderRadius\(BorderRadiusSize\.small\)', '8'
$content = $content -replace 'responsive\.getIconSize\(IconSize\.large\)', '32'
$content = $content -replace 'responsive\.getIconSize\(IconSize\.medium\)', '24'
$content = $content -replace 'responsive\.getIconSize\(IconSize\.small\)', '14'
$content = $content -replace 'responsive\.getValue\(\s*mobile:\s*70,\s*tablet:\s*75,\s*desktop:\s*80,\s*\)', '80'
$content = $content -replace 'responsive\.getGridColumns\(\)', 'ResponsiveHelper.getGridColumns(context)'

Set-Content -Path $file -Value $content -NoNewline
Write-Host "Fixed hire_staff_screen.dart"
