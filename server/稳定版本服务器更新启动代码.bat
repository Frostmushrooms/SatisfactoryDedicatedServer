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

:: 设置路径变量
set "STEAMCMD_DIR=%~dp0servercore\steamcmd"
set "SERVER_DIR=%~dp0servercore\servercore7777"

:: 创建目录并下载SteamCMD
if not exist "%STEAMCMD_DIR%" mkdir "%STEAMCMD_DIR%"
cd /d "%STEAMCMD_DIR%"
if not exist steamcmd.zip (
    curl -o "steamcmd.zip" "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
    if %errorlevel% neq 0 (
        echo 下载SteamCMD失败
        exit /b 1
    )
    tar -xf steamcmd.zip
)

:: 停止现有服务器进程
taskkill /IM FactoryServer-Win64-Shipping-Cmd.exe /F >nul 2>&1
for /f "tokens=2" %%i in ('tasklist /v ^| findstr /c:"FactoryServerDaemon"') do (
    echo 停止守护进程 PID: %%i
    taskkill /PID %%i /F
)

:: 更新服务器
"%STEAMCMD_DIR%/steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 1690800 -beta public validate +quit

echo 服务器更新完成


@echo off
setlocal enabledelayedexpansion

title FactoryServerDaemon
color AF
echo 您正在以守护进程模式启动幸福工厂服务器
echo 请不要关闭此窗口
echo QQ:1056484009 QQ群:264127585

mkdir "%~dp0logs" >nul 2>nul

set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%

set log_file=%~dp0logs\%date:~0,4%%date:~5,2%%date:~8,2%_%hour%%time:~3,2%%time:~6,2%.log
echo %date:~0,11%%time% 幸福工厂服务器守护进程已启动 >> %log_file%
echo %date:~0,11%%time% 幸福工厂服务器守护进程已启动

:loop
tasklist | findstr "FactoryServer.exe" > nul
if %errorlevel% == 1 (
    taskkill /f /t /im FactoryServer.exe >nul
    echo %date:~0,11%%time% 幸福工厂服务器错误，正在重新启动 >> %log_file%
    echo %date:~0,11%%time% 幸福工厂服务器错误，正在重新启动
    powershell -Command "& { [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null; $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02); $xml = New-Object Windows.Data.Xml.Dom.XmlDocument; $xml.LoadXml($template.GetXml()); $toastElements = $xml.GetElementsByTagName('text'); if ($toastElements.Count -ge 2) { $titleNode = $xml.CreateTextNode('幸福工厂服务器错误'); $toastElements.Item(0).AppendChild($titleNode) > $null; $contentNode = $xml.CreateTextNode('检测到服务器崩溃, 正在重新启动.'); $toastElements.Item(1).AppendChild($contentNode) > $null; $toast = [Windows.UI.Notifications.ToastNotification]::new($xml); $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Satisfactory Dedicated Server'); $notifier.Show($toast); } else { Write-Host 'Unable to create toast notification.' } }" >nul 10>nul
    timeout /T 5 >nul
    explorer "%~dp0demotion7777.cmd"
) else (
    echo %date:~0,11%%time% 幸福工厂服务器正在工作.
    echo %date:~0,11%%time% 幸福工厂服务器正在工作.>> %log_file%
)
timeout /t 2 > nul
goto loop

pause

