# Import utils
. "$PSScriptRoot\utils.ps1"

Initialize-Launcher
Show-Header "MicroSync Update"

$scriptDir = $PSScriptRoot
$archPattern = Get-TargetArchPattern

Write-Host "[Process] Checking for updates..." -ForegroundColor Cyan

# Update Main App
Update-App -scriptDir $scriptDir -repo "malken21/Unity-GLB-Vehicle-Sync" -assetPattern "Windows\.zip$" -outputPath (Join-Path $scriptDir "Windows.zip") -isZip $true

# Update Asset Server
$assetServerExe = if ($archPattern -match "x86_64") { "simple-rust-asset-server-windows-x64.exe" } else { "simple-rust-asset-server-windows-arm64.exe" }
$assetPattern = if ($archPattern -match "x86_64") { "windows-x64\.exe$" } else { "windows-arm64\.exe$" }
Update-App -scriptDir $scriptDir -repo "malken21/Simple-Rust-Asset-Server" -assetPattern $assetPattern -outputPath (Join-Path $scriptDir $assetServerExe) -isZip $false

Write-Host ""
Write-Host "Update Finished." -ForegroundColor Green
Read-Host "Press Enter to close window"
