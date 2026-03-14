# Import utils
. "$PSScriptRoot\utils.ps1"

Initialize-Launcher
Show-Header "MicroSync Host"

$scriptDir = $PSScriptRoot
$mainExe = "Unity-GLB-Vehicle-Sync.exe"
$archPattern = Get-TargetArchPattern
$assetServerExe = if ($archPattern -match "x86_64") { "simple-rust-asset-server-windows-x64.exe" } else { "simple-rust-asset-server-windows-arm64.exe" }

# Start Asset Server in background
$archPattern = Get-TargetArchPattern
$assetServerExe = if ($archPattern -match "x86_64") { "simple-rust-asset-server-windows-x64.exe" } else { "simple-rust-asset-server-windows-arm64.exe" }
$assetServerPath = Join-Path $scriptDir $assetServerExe
if (Test-Path $assetServerPath) {
    Start-BackgroundApp -exePath $assetServerPath -workingDir $scriptDir
}

# Start Main App
Start-App -scriptDir $scriptDir -exeName $mainExe -mode HOST -port 7777 -logName "host_log.txt"
