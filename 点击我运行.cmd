@echo off
:menu
cls
echo ==============================
echo     ����������˵� v2.2
echo     �����ˣ���˪Ģ��
echo     QQ:1056484009 QQȺ:264127585
echo ==============================
echo ��ѡ���ܣ�
echo 1 - ���²�������ʽ�������
echo 2 - ���²��������԰������
echo 3 - ����������
echo 4 - �رշ�����
echo 5 - �򿪴浵
echo 6 - �޸���������(MaxPlayers)
echo 7 - ���Ŷ˿�7777,8888
echo 8 - ж�ط�����
echo 0 - �˳�����
echo ==============================

set /p choice="������ѡ��(0-8): "

set config_file=%~dp0server\Game.ini
if not exist "%config_file%" (
    echo ���������ļ������ڣ�
    pause
    goto config_menu
)
if "%choice%"=="1" (
    call %~dp0server\�ȶ��汾������������������.bat
    pause
    goto menu
)
if "%choice%"=="2" (
    call %~dp0server\���԰汾������������������.bat
    pause
    goto menu
)
if "%choice%"=="3" (
    call %~dp0server\Restart.bat
    echo �������������
    pause
    goto menu
)
if "%choice%"=="4" (
    call %~dp0server\Shut-down-the-server.bat
    echo �ѹرշ�����
    pause
    goto menu
)
if "%choice%"=="5" (
    call explorer.exe "%USERPROFILE%\AppData\Local\FactoryGame\Saved\SaveGames"
    pause
    goto menu
)
if "%choice%"=="6" (
    set param_name=MaxPlayers
    set /p new_value="�������µ��������(1-100): "
    call :modify_param
)
if "%choice%"=="7" (
    call %~dp0server\open port.bat
    pause
    goto menu
)
if "%choice%"=="8" (
    set /p confirm="ȷ��ж�ط��������������� (y/n): "
if /i "%confirm%"=="y" (
    rd /s /q "%~dp0server\servercore"
    echo �ļ�����ɾ��
) else (
    echo ����ȡ��
)
    pause
    goto menu
)
if "%choice%"=="9" (
    call 
    pause
    goto menu
)
if "%choice%"=="0" (
    exit
)
echo ������Ч�����룬������0-8֮������֣�

goto config_menu

:modify_param
:: ʹ��findstr��λ������
findstr /i "%param_name%=" "%config_file%" >nul || (
    echo ���󣺲����������������ļ���
    pause
    goto :eof
)

:: ������ʱ�ļ����滻����ֵ
(
    for /f "tokens=1* delims=:" %%a in ('findstr /n /v /c:"%param_name%=" "%config_file%"') do (
        echo %%b
    )
    echo %param_name%=%new_value%
) > "%config_file%.tmp"

:: �滻ԭ�����ļ�
move /y "%config_file%.tmp" "%config_file%" >nul

if exist "%~dp0server\Game.ini" (
    copy "%~dp0server\Game.ini" "%~dp0server\servercore\servercore7777\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo δ�ҵ���Ϸ�����ļ������԰��������Ϸ�����޸�ʧ��
)
if exist "%~dp0server\Game.ini" (
    copy "%~dp0server\Game.ini" "%~dp0server\servercore\servercore8888\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo δ�ҵ���Ϸ�����ļ������԰��������Ϸ�����޸�ʧ��
)
echo ���� %param_name% �Ѹ���Ϊ %new_value%
pause
goto menu
