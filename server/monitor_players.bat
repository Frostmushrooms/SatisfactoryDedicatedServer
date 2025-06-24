@echo off
setlocal enabledelayedexpansion

:: 检查管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
   :: echo 需要管理员权限...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:: 配置日志文件路径
set LOG_PATH="%~dp0servercore\servercore7777\FactoryGame\Saved\Logs\FactoryGame.log"
set TEMP_FILE="%temp%\satisfactory_counter.tmp"
set player_count=0
set TEMP_JOIN="%temp%\players_join.tmp"
set TEMP_LEAVE="%temp%\players_leave.tmp"


:monitor_loop
cls
echo 当前时间[%time%]
echo 幸福工厂服务器在线人数监控
echo 仅支持稳定版
echo ----------------------------------

:: 统计登录玩家数
findstr /R /C:"Join succeeded:" %LOG_PATH% > %TEMP_FILE%
for /f %%a in ('type %TEMP_FILE% ^| find /c /v ""') do set JOINS=%%a

:: 统计退出玩家数
findstr /R /C:"UNetConnection::SendCloseReason:" %LOG_PATH% > %TEMP_FILE%
for /f %%a in ('type %TEMP_FILE% ^| find /c /v ""') do set LEAVES=%%a

:: 日志预处理（移除BOM头等干扰）
type %LOG_PATH% | find "Join succeeded:" > %TEMP_JOIN%


:: 提取玩家名并去重
:: for /f "tokens=4 delims=:" %%a in ('type "%TEMP_JOIN%" ^| findstr /r /v "^$"') do (
    set "player1=%%a"
)

:: 提取服务器最大人数
for /f "tokens=2 delims==" %%b in ('findstr /i "MaxPlayers" "%~dp0servercore\servercore7777\FactoryGame\Saved\Config\WindowsServer\Game.ini"') do (
    set "player=%%b"
)



:: 计算当前在线人数
set /a player_count=!JOINS!-!LEAVES!

:: 显示统计信息
echo 当前在线玩家: !player_count!/!player! 人
echo [登录:!JOINS! 退出:!LEAVES!]
:: echo !player1! 已加入
echo ----------------------------------

timeout /t 1 >nul
goto :monitor_loop

pause