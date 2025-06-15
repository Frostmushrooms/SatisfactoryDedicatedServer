@echo off
setlocal enabledelayedexpansion

:: 检查管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 需要管理员权限...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:: 停止现有服务器进程
taskkill /IM FactoryServer-Win64-Shipping-Cmd.exe /F >nul 2>&1
for /f "tokens=2" %%i in ('tasklist /v ^| findstr /c:"FactoryServerDaemon"') do (
    echo 停止守护进程 PID: %%i
    taskkill /PID %%i /F
)
