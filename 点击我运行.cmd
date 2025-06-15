@echo off
:menu
cls
echo ==============================
echo     服务器管理菜单 v2.2
echo     编译人：冰霜蘑菇
echo     QQ:1056484009 QQ群:264127585
echo ==============================
echo 请选择功能：
echo 1 - 更新并启动正式版服务器
echo 2 - 更新并启动测试版服务器
echo 3 - 重启服务器
echo 4 - 关闭服务器
echo 5 - 打开存档
echo 6 - 修改最大玩家数(MaxPlayers)
echo 7 - 开放端口7777,8888
echo 8 - 卸载服务器
echo 0 - 退出程序
echo ==============================

set /p choice="请输入选项(0-8): "

set config_file=%~dp0server\Game.ini
if not exist "%config_file%" (
    echo 错误：配置文件不存在！
    pause
    goto config_menu
)
if "%choice%"=="1" (
    call %~dp0server\稳定版本服务器更新启动代码.bat
    pause
    goto menu
)
if "%choice%"=="2" (
    call %~dp0server\测试版本服务器更新启动代码.bat
    pause
    goto menu
)
if "%choice%"=="3" (
    call %~dp0server\Restart.bat
    echo 重启服务器完成
    pause
    goto menu
)
if "%choice%"=="4" (
    call %~dp0server\Shut-down-the-server.bat
    echo 已关闭服务器
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
    set /p new_value="请输入新的玩家数量(1-100): "
    call :modify_param
)
if "%choice%"=="7" (
    call %~dp0server\open port.bat
    pause
    goto menu
)
if "%choice%"=="8" (
    set /p confirm="确定卸载服务器所有内容吗 (y/n): "
if /i "%confirm%"=="y" (
    rd /s /q "%~dp0server\servercore"
    echo 文件夹已删除
) else (
    echo 操作取消
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
echo 错误：无效的输入，请输入0-8之间的数字！

goto config_menu

:modify_param
:: 使用findstr定位配置行
findstr /i "%param_name%=" "%config_file%" >nul || (
    echo 错误：参数不存在于配置文件中
    pause
    goto :eof
)

:: 创建临时文件并替换参数值
(
    for /f "tokens=1* delims=:" %%a in ('findstr /n /v /c:"%param_name%=" "%config_file%"') do (
        echo %%b
    )
    echo %param_name%=%new_value%
) > "%config_file%.tmp"

:: 替换原配置文件
move /y "%config_file%.tmp" "%config_file%" >nul

if exist "%~dp0server\Game.ini" (
    copy "%~dp0server\Game.ini" "%~dp0server\servercore\servercore7777\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo 未找到游戏人数文件，测试版服务器游戏人数修改失败
)
if exist "%~dp0server\Game.ini" (
    copy "%~dp0server\Game.ini" "%~dp0server\servercore\servercore8888\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo 未找到游戏人数文件，测试版服务器游戏人数修改失败
)
echo 参数 %param_name% 已更新为 %new_value%
pause
goto menu
