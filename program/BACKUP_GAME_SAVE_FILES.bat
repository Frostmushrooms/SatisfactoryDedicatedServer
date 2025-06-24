@echo off
setlocal enabledelayedexpansion

:: ������ԱȨ��
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ��������������
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)


set "source_dir=%LOCALAPPDATA%\FactoryGame\Saved\SaveGames"       :: �豸�ݵĴ浵Ŀ¼
set "backup_root=%~dp0save"                :: ���ݴ洢λ��
set "retain_days=30"                        :: ���ݱ�������

:: ����ʱ����ļ���
set "timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%"
set "zip_file=%backup_root%\Satisfactory_%timestamp%.zip"

:: ��������Ŀ¼
if not exist "%backup_root%" mkdir "%backup_root%"

:: ִ��ѹ�����Զ�ʶ��ZIP��ʽ��
tar -a -c -f "%zip_file%" "%source_dir%" 2>> "%backup_root%\error.log"
if %errorlevel% equ 0 (
    echo [%date% %time%] ѹ���ɹ�: %zip_file% >> "%backup_root%\backup.log"
) else (
    echo [ERROR] ѹ��ʧ�ܣ����error.log >> "%backup_root%\backup.log"
)

:: ����ɱ���
forfiles /p "%backup_root%" /m *.zip /d -%retain_days% /c "cmd /c del @path"
