# Import utils
. "$PSScriptRoot\utils.ps1"

Initialize-Launcher
Show-Header "MicroBridge"

$exeName = "microbridge.exe"
$scriptDir = $PSScriptRoot
$exePath = Join-Path $scriptDir $exeName

# Update
$archPattern = Get-TargetArchPattern
Update-App -scriptDir $scriptDir -repo "malken21/MicroBridge" -assetPattern $archPattern -outputPath $exePath -isZip $false

# Final check
if (-not (Test-Path $exePath)) {
    Write-Host ""
    Write-Host "[Error] $exeName not found. Download failed." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# ID Input
Write-Host ""
$mbId = ""
while ($true) {
    $mbId = Read-Host "microbit の ID を教えて！ (5桁)"
    $mbId = $mbId.Trim()
    if ($mbId.Length -eq 5) {
        break
    }
    else {
        Write-Host "※IDは5桁で入力してください。" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "ID: [$mbId] で MicroBridge を起動します..." -ForegroundColor Cyan
Write-Host "停止するには Ctrl + C を押してください。"
Write-Host "----------------------------------------"

# Execute
& $exePath -i $mbId

Write-Host ""
Read-Host "終了しました。Enterキーを押して画面を閉じます"