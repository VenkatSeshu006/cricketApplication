# PowerShell script to remove all ResponsiveHelper references from hire_staff_screen.dart
$filePath = "hire_staff_screen.dart"
$content = Get-Content $filePath -Raw

# Remove all ResponsiveHelper static method calls and replace with simple values

# AppBar and spacing
$content = $content -replace 'ResponsiveHelper\.getAppBarHeight\(context\)', '120.0'
$content = $content -replace 'ResponsiveHelper\.getPagePadding\(context\)', 'const EdgeInsets.all(24.0)'
$content = $content -replace 'ResponsiveHelper\.getSpacing\(context\)', '16.0'
$content = $content -replace 'ResponsiveHelper\.getSpacingSmall\(context\)', '8.0'
$content = $content -replace 'ResponsiveHelper\.getSpacingMedium\(context\)', '16.0'
$content = $content -replace 'ResponsiveHelper\.getSpacingLarge\(context\)', '24.0'

# Text styles
$content = $content -replace 'ResponsiveHelper\.getTitle1\(context\)', 'const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)'
$content = $content -replace 'ResponsiveHelper\.getHeadline\(context\)', 'const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)'
$content = $content -replace 'ResponsiveHelper\.getBody\(context\)', 'const TextStyle(fontSize: 14)'
$content = $content -replace 'ResponsiveHelper\.getCaption\(context\)', 'const TextStyle(fontSize: 12)'
$content = $content -replace 'ResponsiveHelper\.getSubtitle\(context\)', 'const TextStyle(fontSize: 14)'

# Icon sizes
$content = $content -replace 'ResponsiveHelper\.getIconSize\(context,\s*IconSize\.small\)', '16.0'
$content = $content -replace 'ResponsiveHelper\.getIconSize\(context,\s*IconSize\.medium\)', '24.0'
$content = $content -replace 'ResponsiveHelper\.getIconSize\(context,\s*IconSize\.large\)', '32.0'
$content = $content -replace 'ResponsiveHelper\.getIconSize\(context\)', '24.0'

# Border radius
$content = $content -replace 'ResponsiveHelper\.getBorderRadius\(context,\s*BorderRadiusSize\.small\)', 'BorderRadius.circular(8.0)'
$content = $content -replace 'ResponsiveHelper\.getBorderRadius\(context,\s*BorderRadiusSize\.medium\)', 'BorderRadius.circular(12.0)'
$content = $content -replace 'ResponsiveHelper\.getBorderRadius\(context,\s*BorderRadiusSize\.large\)', 'BorderRadius.circular(16.0)'
$content = $content -replace 'ResponsiveHelper\.getBorderRadius\(context\)', 'BorderRadius.circular(12.0)'

# getValue patterns (more complex)
$content = $content -replace 'ResponsiveHelper\.getValue\(\s*context,\s*mobile:\s*(\d+\.?\d*),\s*tablet:\s*\d+\.?\d*,\s*desktop:\s*\d+\.?\d*,?\s*\)', '$1'
$content = $content -replace 'ResponsiveHelper\.getValue\(\s*context,\s*mobile:\s*(\d+),\s*tablet:\s*\d+,\s*desktop:\s*\d+,?\s*\)', '$1'

# Clean up any remaining patterns with simpler replacements
$content = $content -replace 'ResponsiveHelper\.getValue\([^)]+\)', '16.0'

# Remove any remaining responsive variable references
$content = $content -replace 'final responsive = ResponsiveHelper\(context\);?\s*', ''
$content = $content -replace 'responsive\.get\w+\(\)', '16.0'

# Fix any TextStyle issues from previous script
$content = $content -replace 'style:\s*const TextStyle\(fontSize: 14\)\.copyWith', 'style: const TextStyle(fontSize: 14)'
$content = $content -replace '\.copyWith\(\s*color:\s*([^)]+)\)', ''

# Save the file
Set-Content -Path $filePath -Value $content -NoNewline
Write-Host "Reverted hire_staff_screen.dart - removed all ResponsiveHelper references"
