@echo off
chcp 65001 >nul

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

echo --- EXTENDED DRIVE INFO ---
powershell -NoProfile -Command "$d = Get-PhysicalDisk | Select-Object -First 1; $s = $d | Get-StorageReliabilityCounter; Write-Host \"Model: $($d.FriendlyName)\"; Write-Host \"Type: $($d.MediaType)\"; Write-Host \"Total Capacity: $([Math]::Round($d.Size/1GB,2)) GB\"; Write-Host \"Health Status: $($d.HealthStatus)\"; Write-Host \"Wear Level: $($s.Wear)%%\"; Write-Host \"Power-On Hours: $($s.PowerOnHours)\"; Write-Host \"Temperature: $($s.Temperature) C\"; Write-Host \"`n--- FREE SPACE ---\"; Get-Volume | Where-Object DriveLetter -match 'C|D' | ForEach-Object { Write-Host \"Drive $($_.DriveLetter): $([Math]::Round($_.SizeRemaining/1GB,2)) GB free\" }"

echo.
echo --- DATA TRANSFER SPEED (Please wait...) ---
winsat disk -drive c | findstr /i "MB/s"

echo.
pause