@echo off
setlocal enabledelayedexpansion

:: ������ԱȨ��
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ��Ҫ����ԱȨ��...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:: ֹͣ���з���������
taskkill /IM FactoryServer-Win64-Shipping-Cmd.exe /F >nul 2>&1
for /f "tokens=2" %%i in ('tasklist /v ^| findstr /c:"FactoryServerDaemon"') do (
    echo ֹͣ�ػ����� PID: %%i
    taskkill /PID %%i /F
)
