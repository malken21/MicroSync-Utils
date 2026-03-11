# Import utils
. "$PSScriptRoot\utils.ps1"

Initialize-Launcher
Show-Header "MicroSync Client"

$scriptDir = $PSScriptRoot
$exeName = "Unity-GLB-Vehicle-Sync.exe"

Update-App -scriptDir $scriptDir -repo "malken21/Unity-GLB-Vehicle-Sync" -assetPattern "Windows\.zip$" -outputPath (Join-Path $scriptDir "Windows.zip") -isZip $true
Start-App -scriptDir $scriptDir -exeName $exeName -port 7777 -logName "client_log.txt"
