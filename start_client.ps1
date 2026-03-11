# TLS1.2を有効化（GitHub APIとの通信エラー対策）
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MicroSync Client Launcher (Auto Update)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# PowerShellスクリプトの初期設定
$scriptDir = $PSScriptRoot
$exeName = "Unity-GLB-Vehicle-Sync.exe"
$exePath = Join-Path $scriptDir $exeName

# システムアーキテクチャの判定
$osArch = $env:PROCESSOR_ARCHITECTURE
if ($osArch -eq "ARM64") {
    $targetArchPattern = "aarch64|arm64|arm"
} else {
    $targetArchPattern = "x86_64|x64|amd64"
}

Write-Host "GitHubの最新リリースを確認しています..."
try {
    $url = 'https://api.github.com/repos/malken21/Unity-GLB-Vehicle-Sync/releases/latest'
    $response = Invoke-RestMethod -Uri $url
    
    $asset = $response.assets | Where-Object { 
        $_.name -match '\.exe$' -and $_.name -match $targetArchPattern 
    } | Select-Object -First 1

    if (-not $asset) {
        $asset = $response.assets | Where-Object { $_.name -match '\.exe$' } | Select-Object -First 1
    }

    if ($asset) {
        Write-Host ("対象ファイルが見つかりました: " + $asset.name)
        Write-Host "ダウンロード中..."
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $exePath
        Write-Host "ダウンロード完了！" -ForegroundColor Green
    }
} catch {
    Write-Host "[警告] 最新版の確認に失敗しました。既存のファイルを使用します。" -ForegroundColor Yellow
}

# 設定値
$port = 7777
$serverIp = "127.0.0.1"
$logFile = "./client.log"

if (-not (Test-Path $exePath)) {
    Write-Host "[エラー] $exeName が見つかりません。" -ForegroundColor Red
    Read-Host "Enterキーを押して終了します"
    exit
}

Write-Host ""
Write-Host "[起動] クライアント(CLIENT)モードを開始します..." -ForegroundColor Green
Write-Host "Port: $port"
Write-Host "Server: $serverIp"
Write-Host "----------------------------------------"

# アプリケーションの実行
& $exePath -mode CLIENT -port $port -serverIp $serverIp -logfile $logFile

Write-Host ""
Read-Host "終了しました。Enterキーを押して画面を閉じます"
