@echo off
echo �����������Ҹ����������� �ػ�ģʽ

taskkill /f /t /im FactoryServer-Win64-Shipping-Cmd.exe

setlocal
 
set PORT=9999
 
:check_port
set "found="
for /F "tokens=2 delims=:" %%a in ('netstat -a -n -o -p UDP ^| findstr :%PORT%') do set "found=%%a"
if not defined found (
    echo %date%%time% �Ҹ�����������������. ������������������ �����ĵȴ�
taskkill /f /t /im FactoryServer-Win64-Shipping-Cmd.exe & start C:\SatisfactoryDedicatedServer\GameServers\SatisfactoryServer\FactoryServer.exe -log -unattended -port=9999
)
 
echo %date%%time% �Ҹ��������������ڹ���. ��˪Ģ�� QQ:1056484009 QQȺ:264127585 
timeout /T 30 >nul
goto check_port
