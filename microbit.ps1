# TLS1.2を有効化（GitHub APIとの通信エラー対策）
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MicroBridge 起動ランチャー (自動更新版)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$exeName = "microbridge.exe"
$scriptDir = $PSScriptRoot
$exePath = Join-Path $scriptDir $exeName

# システムアーキテクチャの判定
$osArch = $env:PROCESSOR_ARCHITECTURE
Write-Host "システムアーキテクチャ [$osArch] を検出しました。" -ForegroundColor Green

if ($osArch -eq "ARM64") {
    $targetArchPattern = "aarch64|arm64|arm"
} else {
    # 互換性のため、ARM以外は標準の x64 として扱う
    $targetArchPattern = "x86_64|x64|amd64"
}

Write-Host "GitHubの最新リリースを確認しています..."
Write-Host "(少々お待ちください...)"

try {
    $url = 'https://api.github.com/repos/malken21/MicroBridge/releases/latest'
    $response = Invoke-RestMethod -Uri $url
    
    # 拡張子が.exeであり、かつアーキテクチャ名を含むアセットを探す
    $asset = $response.assets | Where-Object { 
        $_.name -match '\.exe$' -and $_.name -match $targetArchPattern 
    } | Select-Object -First 1

    # もし名前にアーキテクチャが含まれていない単一の.exeしかない場合のフォールバック
    if (-not $asset) {
        $asset = $response.assets | Where-Object { $_.name -match '\.exe$' } | Select-Object -First 1
    }

    if ($asset) {
        Write-Host ("対象ファイルが見つかりました: " + $asset.name)
        Write-Host "ダウンロード中..."
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $exePath
        Write-Host "ダウンロード完了！" -ForegroundColor Green
    } else {
        Write-Host "[警告] 環境($osArch)に一致する .exe ファイルが見つかりませんでした。" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[エラー] 通信に失敗しました。既存のファイルを使用します。" -ForegroundColor Red
}

# 実行ファイルが存在するか最終確認
if (-not (Test-Path $exePath)) {
    Write-Host ""
    Write-Host "[エラー] $exeName が見つかりません。ダウンロードにも失敗しました。" -ForegroundColor Red
    Read-Host "Enterキーを押して終了します"
    exit
}

# ID入力ループ（5桁入力されるまで繰り返す）
Write-Host ""
$mbId = ""
while ($true) {
    $mbId = Read-Host "microbit の ID を教えて！ (5桁)"
    # 前後の空白を削除して文字数をカウント
    $mbId = $mbId.Trim()
    if ($mbId.Length -eq 5) {
        break
    } else {
        Write-Host "※IDは5桁で入力してください。" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "ID: [$mbId] で MicroBridge を起動します..." -ForegroundColor Cyan
Write-Host "停止するには Ctrl + C を押してください。"
Write-Host "----------------------------------------"

# MicroBridgeの実行
& $exePath -i $mbId

Write-Host ""
Read-Host "終了しました。Enterキーを押して画面を閉じます"