@echo off
chcp 65001 > nul
set EXE_PATH=.\Unity-GLB-Vehicle-Sync.exe
set PORT=7777
set SERVER_IP=127.0.0.1

echo [起動] クライアント(CLIENT)モードを開始します...
start "" "%EXE_PATH%" -mode CLIENT -port %PORT% -serverIp %SERVER_IP% -logfile ./client.log
