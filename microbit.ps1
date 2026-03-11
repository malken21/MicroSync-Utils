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
    $mbId = Read-Host "microbit 縺ｮ ID 繧呈蕗縺医※・・(5譯・"
    $mbId = $mbId.Trim()
    if ($mbId.Length -eq 5) {
        break
    } else {
        Write-Host "窶ｻID縺ｯ5譯√〒蜈･蜉帙＠縺ｦ縺上□縺輔＞縲・ -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "ID: [$mbId] 縺ｧ MicroBridge 繧定ｵｷ蜍輔＠縺ｾ縺・.." -ForegroundColor Cyan
Write-Host "蛛懈ｭ｢縺吶ｋ縺ｫ縺ｯ Ctrl + C 繧呈款縺励※縺上□縺輔＞縲・
Write-Host "----------------------------------------"

# Execute
& $exePath -i $mbId

Write-Host ""
Read-Host "邨ゆｺ・＠縺ｾ縺励◆縲・nter繧ｭ繝ｼ繧呈款縺励※逕ｻ髱｢繧帝哩縺倥∪縺・
