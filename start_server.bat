@echo off
chcp 65001 > nul
set EXE_PATH=.\Unity-GLB-Vehicle-Sync.exe
set PORT=7777
set ASSET_URL=http://localhost:3000

echo [起動] サーバー(HOST)モードを開始します...
start "" "%EXE_PATH%" -mode HOST -port %PORT% -assetUrl %ASSET_URL% -summonAvatar false -enableMicrobit false -logfile ./server.log
