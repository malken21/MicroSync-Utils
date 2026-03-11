# Import utils
. "$PSScriptRoot\utils.ps1"

Initialize-Launcher
Show-Header "MicroSync Server"

$scriptDir = $PSScriptRoot
$mainExe = "Unity-GLB-Vehicle-Sync.exe"
$archPattern = Get-TargetArchPattern
$assetServerExe = if ($archPattern -match "x86_64") { "simple-rust-asset-server-windows-x64.exe" } else { "simple-rust-asset-server-windows-arm64.exe" }

# Update Main App (Server)
Update-App -scriptDir $scriptDir -repo "malken21/Unity-GLB-Vehicle-Sync" -assetPattern "Windows\.zip$" -outputPath (Join-Path $scriptDir "WindowsServer.zip") -isZip $true

# Update Asset Server
$assetPattern = if ($archPattern -match "x86_64") { "windows-x64\.exe$" } else { "windows-arm64\.exe$" }
Update-App -scriptDir $scriptDir -repo "malken21/Simple-Rust-Asset-Server" -assetPattern $assetPattern -outputPath (Join-Path $scriptDir $assetServerExe) -isZip $false

# Start Asset Server in background
$assetServerPath = Join-Path $scriptDir $assetServerExe
if (Test-Path $assetServerPath) {
    Start-BackgroundApp -exePath $assetServerPath -workingDir $scriptDir
}

# Start Main App
Start-App -scriptDir $scriptDir -exeName $mainExe -port 7777 -logName "server_log.txt"
