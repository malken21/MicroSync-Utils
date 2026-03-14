# Import utils
. "$PSScriptRoot\utils.ps1"

Initialize-Launcher
Show-Header "MicroSync Client"

$scriptDir = $PSScriptRoot
$exeName = "Unity-GLB-Vehicle-Sync.exe"

Start-App -scriptDir $scriptDir -exeName $exeName -mode CLIENT -serverIp "[IP_ADDRESS]" -port 7777 -logName "client_log.txt"
