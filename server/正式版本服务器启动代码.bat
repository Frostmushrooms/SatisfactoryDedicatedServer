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

title �Ҹ�������������ʽ���ػ�����
color 0F

mkdir "%~dp0logs\START_STABLE_SERVER" >nul 2>nul

set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%

set log_file=%~dp0logs\START_STABLE_SERVER\%date:~0,4%%date:~5,2%%date:~8,2%_%hour%%time:~3,2%%time:~6,2%.log
echo %date:~0,11%%time% �Ҹ������������ػ����������� >> %log_file%
echo %date:~0,11%%time% �Ҹ������������ػ�����������

:loop
tasklist | findstr "FactoryServer.exe" > nul
if %errorlevel% == 1 (
    taskkill /f /t /im FactoryServer.exe >nul
    echo %date:~0,11%%time% �Ҹ��������������������������� >> %log_file%
    echo %date:~0,11%%time% �Ҹ���������������������������
    timeout /T 5 >nul
    explorer "%~dp0demotion7777.cmd"
) else (
    echo %date:~0,11%%time% �Ҹ��������������ڹ���.
    echo %date:~0,11%%time% �Ҹ��������������ڹ���.>> %log_file%
)
timeout /t 2 > nul
goto loop

pause

