@echo off
setlocal enabledelayedexpansion

:: ������ԱȨ��
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ���ڻ�ȡ����ԱȨ��...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:: ����·������
set "STEAMCMD_DIR=%~dp0servercore\steamcmd"
set "SERVER_DIR=%~dp0servercore\servercore7777"

:: ����Ŀ¼������SteamCMD
if not exist "%STEAMCMD_DIR%" mkdir "%STEAMCMD_DIR%"
cd /d "%STEAMCMD_DIR%"
if not exist steamcmd.zip (
    curl -o "steamcmd.zip" "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
    if %errorlevel% neq 0 (
        echo ����SteamCMDʧ��
        exit /b 1
    )
    tar -xf steamcmd.zip
)
"%STEAMCMD_DIR%/steamcmd.exe"