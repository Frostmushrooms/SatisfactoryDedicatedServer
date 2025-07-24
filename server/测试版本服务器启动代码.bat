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

title 幸福工厂服务器测试版守护进程
color 0F

mkdir "%~dp0logs\START_TEST_SERVER" >nul 2>nul

set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%

set log_file=%~dp0logs\START_TEST_SERVER\%date:~0,4%%date:~5,2%%date:~8,2%_%hour%%time:~3,2%%time:~6,2%.log
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
    explorer "%~dp0demotion8888.cmd"
) else (
    echo %date:~0,11%%time% 幸福工厂服务器正在工作.
    echo %date:~0,11%%time% 幸福工厂服务器正在工作.>> %log_file%
)
timeout /t 2 > nul
goto loop

pause

