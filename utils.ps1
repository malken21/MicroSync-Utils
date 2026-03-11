function Initialize-Launcher {
    # Set encoding to UTF-8
    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
    
    # Enable TLS1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Clear-Host
}

function Show-Header ($title) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  $title Launcher (Auto Update)" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Get-TargetArchPattern {
    $osArch = $env:PROCESSOR_ARCHITECTURE
    if ($osArch -eq "ARM64") {
        return "aarch64|arm64|arm"
    } else {
        return "x86_64|x64|amd64"
    }
}

function Update-App ($scriptDir, $repo, $assetPattern, $outputPath, $isZip = $true) {
    Write-Host "Checking for latest release on $repo..."
    try {
        $url = "https://api.github.com/repos/$repo/releases/latest"
        $response = Invoke-RestMethod -Uri $url
        
        # Search for asset
        $asset = $response.assets | Where-Object { 
            $_.name -match $assetPattern 
        } | Select-Object -First 1

        if (-not $asset -and $isZip) {
            $asset = $response.assets | Where-Object { $_.name -match '\.zip$' } | Select-Object -First 1
        }
        
        # Microbit specific: if no arch match, fallback to any .exe
        if (-not $asset -and -not $isZip) {
            $asset = $response.assets | Where-Object { $_.name -match '\.exe$' } | Select-Object -First 1
        }

        if ($asset) {
            Write-Host ("Found asset: " + $asset.name)
            
            $needsUpdate = $true
            $versionFilePath = "$outputPath.version"
            
            if ($isZip) {
                if (Test-Path $versionFilePath) {
                    $localVersion = Get-Content $versionFilePath -Raw
                    if ($localVersion -eq $asset.updated_at) {
                        $needsUpdate = $false
                    }
                }
            } else {
                if (Test-Path $outputPath) {
                    $localSize = (Get-Item $outputPath).Length
                    if ($localSize -eq $asset.size) {
                        $needsUpdate = $false
                    }
                }
            }

            if (-not $needsUpdate) {
                Write-Host "Already up to date. Skipping download." -ForegroundColor Cyan
                return
            }

            Write-Host "Downloading (Size: $($asset.size / 1KB) KB)..."
            Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $outputPath
            
            if ($isZip) {
                Write-Host "Extracting..."
                Expand-Archive -Path $outputPath -DestinationPath $scriptDir -Force
                Remove-Item $outputPath -ErrorAction SilentlyContinue
                $asset.updated_at | Out-File -FilePath $versionFilePath -Encoding utf8
            }
            
            Write-Host "Update Complete!" -ForegroundColor Green
        }
    } catch {
        Write-Host "[Warning] Failed to check/update. Using existing files." -ForegroundColor Yellow
    }
}

function Start-App ($scriptDir, $exeName, $port, $logName, $ip = "127.0.0.1") {
    $logFile = Join-Path $scriptDir $logName
    
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

    Write-Host ""
    Write-Host "[Start] Starting Application..." -ForegroundColor Green
    Write-Host "EXE: $exePath"
    Write-Host "IP: $ip"
    Write-Host "Port: $port"
    Write-Host "Log: $logFile"
    Write-Host "----------------------------------------"

    # Execute
    $exeDir = Split-Path $exePath
    Push-Location $exeDir
    & $exePath -ip $ip -port $port -logpath $logFile
    Pop-Location

    Write-Host ""
    Read-Host "Finished. Press Enter to close window"
}

function Start-BackgroundApp ($exePath, $workingDir) {
    Write-Host "[Start] Starting Background Application..." -ForegroundColor Cyan
    Write-Host "EXE: $exePath"
    
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $exePath
    $startInfo.WorkingDirectory = $workingDir
    $startInfo.UseShellExecute = $true # Opens in a new window
    
    [System.Diagnostics.Process]::Start($startInfo) | Out-Null
}

