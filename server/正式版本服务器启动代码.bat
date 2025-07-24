@echo off
setlocal enabledelayedexpansion

:: 检查管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 正在获取管理员权限...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

title 幸福工厂服务器正式版守护进程
color 0F

mkdir "%~dp0logs\START_STABLE_SERVER" >nul 2>nul

set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%

set log_file=%~dp0logs\START_STABLE_SERVER\%date:~0,4%%date:~5,2%%date:~8,2%_%hour%%time:~3,2%%time:~6,2%.log
echo %date:~0,11%%time% 幸福工厂服务器守护进程已启动 >> %log_file%
echo %date:~0,11%%time% 幸福工厂服务器守护进程已启动

:loop
tasklist | findstr "FactoryServer.exe" > nul
if %errorlevel% == 1 (
    taskkill /f /t /im FactoryServer.exe >nul
    echo %date:~0,11%%time% 幸福工厂服务器错误，正在重新启动 >> %log_file%
    echo %date:~0,11%%time% 幸福工厂服务器错误，正在重新启动
    timeout /T 5 >nul
    explorer "%~dp0demotion7777.cmd"
) else (
    echo %date:~0,11%%time% 幸福工厂服务器正在工作.
    echo %date:~0,11%%time% 幸福工厂服务器正在工作.>> %log_file%
)
timeout /t 2 > nul
goto loop

pause

