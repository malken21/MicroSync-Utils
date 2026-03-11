# Import utils
. "$PSScriptRoot\utils.ps1"

Initialize-Launcher
Show-Header "MicroSync Client"

$scriptDir = $PSScriptRoot
$exeName = "Unity-GLB-Vehicle-Sync.exe"

$serverIp = Read-Host "謗･邯壼・繧ｵ繝ｼ繝舌・縺ｮ IP 繧｢繝峨Ξ繧ｹ繧貞・蜉帙＠縺ｦ縺上□縺輔＞ (繝・ヵ繧ｩ繝ｫ繝・ 127.0.0.1)"
if ([string]::IsNullOrWhiteSpace($serverIp)) { $serverIp = "127.0.0.1" }

Update-App -scriptDir $scriptDir -repo "malken21/Unity-GLB-Vehicle-Sync" -assetPattern "Windows\.zip$" -outputPath (Join-Path $scriptDir "Windows.zip") -isZip $true
Start-App -scriptDir $scriptDir -exeName $exeName -port 7777 -logName "client_log.txt" -ip $serverIp

