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
title ���������ʵʱ���
color 0F

mkdir "%~dp0logs\monitor_players" >nul 2>nul

:: ������־�ļ�·��
set LOG_PATH="%~dp0servercore\servercore7777\FactoryGame\Saved\Logs\FactoryGame.log"
set TEMP_FILE="%temp%\satisfactory_counter.tmp"
set player_count=0
set TEMP_JOIN="%temp%\players_join.tmp"
set TEMP_LEAVE="%temp%\players_leave.tmp"
set LOG2_PATH="%~dp0servercore\servercore7777\FactoryGame\Saved\Logs\FactoryGame.log"
set log_file=%~dp0logs\monitor_players\%date:~0,4%%date:~5,2%%date:~8,2%_%hour%%time:~3,2%%time:~6,2%.log

:: ��־��С����(��λ:MB)
set MAX_LOG_SIZE=2
set MAX_LOG_BYTES=2097152

:: �����־��С����ת
for %%F in ("%log_file%") do (
   if %%~zF geq !MAX_LOG_BYTES! (
      move "%log_file%" "%~dp0logs\monitor_players\archive_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
      type nul > "%log_file%"
   )
)


:monitor_loop
cls
echo ��ǰʱ��[%time%]
echo �Ҹ����������������������
echo ��֧���ȶ���
echo ----------------------------------

:: ͳ�Ƶ�¼�����
findstr /R /C:"Join succeeded:" %LOG_PATH% > %TEMP_FILE%
for /f %%a in ('type %TEMP_FILE% ^| find /c /v ""') do set JOINS=%%a

:: ͳ���˳������
findstr /R /C:"UNetConnection::SendCloseReason:" %LOG_PATH% > %TEMP_FILE%
for /f %%a in ('type %TEMP_FILE% ^| find /c /v ""') do set LEAVES=%%a

:: ��־Ԥ�����Ƴ�BOMͷ�ȸ��ţ�
type %LOG_PATH% | find "Join succeeded:" > %TEMP_JOIN%


:: ��ȡ�������ȥ��
:: for /f "tokens=4 delims=:" %%a in ('type "%TEMP_JOIN%" ^| findstr /r /v "^$"') do (
    set "player1=%%a"
)

:: ��ȡ�������������
for /f "tokens=2 delims==" %%b in ('findstr /i "MaxPlayers" "%~dp0servercore\servercore7777\FactoryGame\Saved\Config\WindowsServer\Game.ini"') do (
    set "player=%%b"
)



:: ���㵱ǰ��������
set /a player_count=!JOINS!-!LEAVES!

:: ��ʾͳ����Ϣ
echo %date:~0,11%%time% ��ǰ�������: !player_count!/!player! �� >> %log_file%
echo ��ǰ�������: !player_count!/!player! �� 
echo [��¼:!JOINS! �˳�:!LEAVES!]
:: echo !player1! �Ѽ���
echo ----------------------------------

timeout /t 1 >nul
goto :monitor_loop

pause