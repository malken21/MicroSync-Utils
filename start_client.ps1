# Enable TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MicroSync Client Launcher (Auto Update)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Path settings
$scriptDir = $PSScriptRoot
$exeName = "Unity-GLB-Vehicle-Sync.exe"
$zipPath = Join-Path $scriptDir "temp_latest.zip"

# Architecture detection
$targetAssetPattern = "Windows\.zip"

Write-Host "Checking for latest release on GitHub..."
try {
    $url = 'https://api.github.com/repos/malken21/Unity-GLB-Vehicle-Sync/releases/latest'
    $response = Invoke-RestMethod -Uri $url
    
    # Search for ZIP asset
    $asset = $response.assets | Where-Object { 
        $_.name -match $targetAssetPattern 
    } | Select-Object -First 1

    if (-not $asset) {
        $asset = $response.assets | Where-Object { $_.name -match '\.zip$' } | Select-Object -First 1
    }

    if ($asset) {
        Write-Host ("Found asset: " + $asset.name)
        Write-Host "Downloading..."
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
        Write-Host "Extracting..."
        
        # Expand ZIP
        Expand-Archive -Path $zipPath -DestinationPath $scriptDir -Force
        
        # Cleanup
        Remove-Item $zipPath -ErrorAction SilentlyContinue
        
        Write-Host "Update Complete!" -ForegroundColor Green
    }
} catch {
    Write-Host "[Warning] Failed to check/update. Using existing files." -ForegroundColor Yellow
}

# Find EXE in subdirectories if not in root
$exePath = Join-Path $scriptDir $exeName
if (-not (Test-Path $exePath)) {
    $found = Get-ChildItem -Path $scriptDir -Filter $exeName -Recurse | Select-Object -First 1
    if ($found) {
        $exePath = $found.FullName
    }
}

if (-not (Test-Path $exePath)) {
    Write-Host "[Error] $exeName not found." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# Config
$port = 7777
$serverIp = "127.0.0.1"
$logFile = "./client.log"

Write-Host ""
Write-Host "[Start] Starting Client (CLIENT) mode..." -ForegroundColor Green
Write-Host "EXE: $exePath"
Write-Host "Port: $port"
Write-Host "Server IP: $serverIp"
Write-Host "----------------------------------------"

# Execute
$exeDir = Split-Path $exePath
Push-Location $exeDir
& $exePath -mode CLIENT -port $port -serverIp $serverIp -logfile $logFile
Pop-Location

Write-Host ""
Read-Host "Finished. Press Enter to close window"
