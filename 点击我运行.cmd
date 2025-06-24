@echo off
setlocal enabledelayedexpansion

:: 常量定义
set CONFIG_FILE=%~dp0program\Game.ini
set CONFIG_FILE1=%~dp0program\Engine.ini
set SAVE_GAME_PATH=%USERPROFILE%\AppData\Local\FactoryGame\Saved\SaveGames
set SERVER_FOLDERS=server\servercore\logs
set target_folder_program=%~dp0program
set target_folder_server=%~dp0server
set STEAM_ID=526870
set LOG_PATH=%~dp0\server\logs\SatisfactoryRestartLogs
set RESTART_TIME=03:00
set file_path=%~dp0server\正式版本服务器更新启动代码.bat
set log_file=%~dp0\server\logs\SatisfactoryRestartLogsexecution_log_%date:~0,4%%date:~5,2%%date:~8,2%.log

:: 检查目标文件夹是否存在
if exist "%target_folder%" (
    echo 文件夹已存在，跳过自动更新
) else (
    echo 文件夹不存在，执行自动更新操作
    curl -o "SatisfactoryDe-dicatedServer.zip" "http://nas.sxtvip.top:5244/d/1/update/SatisfactoryDe-dicatedServer.zip?sign=n7RvJDuPF5hBidV9iMnM9lcdbTDyd0vPXbSxImn40G0=:0"
    if %errorlevel% neq 0 (
        echo 下载更新失败，无法连接到网络
        pause
        exit /b
    )
    tar -xf "%~dp0SatisfactoryDe-dicatedServer.zip" && del "%~dp0SatisfactoryDe-dicatedServer.zip"
    echo 更新完成
)
pause     echo 进入服务器管理菜单

:: 进入服务器管理菜单
:MAIN_MENU
cls
title 服务器管理菜单
color 09
echo ==============================
echo     服务器管理菜单 v3.4版本
echo     编译人：冰霜蘑菇
echo     QQ:1056484009 QQ群:264127585
echo ==============================
echo 1  -  更新服务器
echo 2  -  （未使用）
echo 3  -  备份游戏存档
echo 4  -  关闭服务器
echo 5  -  打开存档
echo 6  -  修改最大玩家数
echo 7  -  开放端口7777,8888
echo 8  -  卸载服务器
echo 9  -  更新管理菜单
echo 10 -  修改自动保存存档数量
echo 11 -  实时监控在线人数
echo 12 -  设置定时重启任务
echo 0  -  退出程序
echo ==============================

set /p CHOICE=请输入选项(0-12): 

:: 选项处理
if "%CHOICE%"=="1" call :UPDATE_SERVER
if "%CHOICE%"=="2" call :
if "%CHOICE%"=="3" call :BACKUP_GAME_SAVE_FILES
if "%CHOICE%"=="4" call :SHUTDOWN_SERVER
if "%CHOICE%"=="5" call :OPEN_SAVES
if "%CHOICE%"=="6" call :SET_MAX_PLAYERS
if "%CHOICE%"=="7" call :OPEN_PORTS
if "%CHOICE%"=="8" call :UNINSTALL_SERVER
if "%CHOICE%"=="9" call :UPDATE_MENU
if "%CHOICE%"=="10" call :MODIFY_AUTO_SAVE
if "%CHOICE%"=="11" call :MONITOR_PLAYERS
if "%CHOICE%"=="12" call :SCHEDULE_MENU
if "%CHOICE%"=="0" exit /b
if "%CHOICE%"=="" echo 检测到空输入！   

:: 清空变量
set CHOICE=
if not defined var echo 输入已清空
goto MAIN_MENU

:: 进入更新服务器菜单
:UPDATE_SERVER
cls
title 服务器管理菜单
color 09
echo ==============================
echo     服务器管理菜单 v3.4版本
echo     编译人：冰霜蘑菇
echo     QQ:1056484009 QQ群:264127585
echo ==============================
echo 1  -  更新并启动正式版服务器
echo 2  -  更新并启动测试版服务器
echo 0  -  返回主菜单
echo ==============================

set /p CHOICE2=请输入选项(0-2): 

:: 选项处理
if "%CHOICE2%"=="1" call :START_STABLE_SERVER
if "%CHOICE2%"=="2" call :START_TEST_SERVER
if "%CHOICE2%"=="0" goto MAIN_MENU
if "%CHOICE2%"=="" echo 检测到空输入！   

:: 使用setlocal清空CHOICE2变量，避免污染全局环境
set CHOICE2=
if not defined var echo 输入已清空
goto UPDATE_SERVER

:: 功能函数
:START_STABLE_SERVER
call %~dp0server\正式版本服务器更新启动代码.bat
echo 执行正式版启动流程...
pause
goto :eof

:START_TEST_SERVER
call %~dp0server\测试版本服务器更新启动代码.bat
echo 执行测试版启动流程...
pause
goto :eof

:: 功能函数
:SCHEDULE_MENU
set FILE_PATH_OFFICIAL_VERSION_IMMEDIATELY=%~dp0server\正式版本服务器更新启动代码.bat
set "target_folder=%~dp0server"
set log_file=%~dp0\server\logs\SatisfactoryRestartLogsexecution_log_%date:~0,4%%date:~5,2%%date:~8,2%.log

:: 进入幸福工厂自定义重启菜单
:SCHEDULE_MENU
cls
title 幸福工厂自定义重启菜单
color 09
echo ==============================
echo     服务器管理菜单 v3.4版本
echo     编译人：冰霜蘑菇
echo     QQ:1056484009 QQ群:264127585
echo ==============================
echo 1. 立即重启正式版
echo 2. 立即重启测试版
echo 3. 设置正式版定时重启任务（启动之后管理菜单不可使用，如果要退出请 CTAR+C 或者关闭当前菜单，如果想同时使用其他指令，请再次打开新的管理器菜单）
echo 4. 设置测试版定时重启任务（启动之后管理菜单不可使用，如果要退出请 CTAR+C 或者关闭当前菜单，如果想同时使用其他指令，请再次打开新的管理器菜单）
echo 0  -  返回主菜单
echo ==============================

set /p CHOICE3=请输入选项(0-3): 

if "%CHOICE3%"=="1" call :RESTART_THE_official_version_immediately
if "%CHOICE3%"=="2" call :RESTART_THE_BETA_VERSION_IMMEDIATELY
if "%CHOICE3%"=="3" goto SCHEDULE_OFFICIAL_RESTART
if "%CHOICE3%"=="4" goto SCHEDULE_BETA_RESTART
if "%CHOICE3%"=="0" goto MAIN_MENU
if "%CHOICE3%"==""  echo 检测到空输入！   

:: 使用setlocal清空CHOICE3变量，避免污染全局环境
set CHOICE3=
if not defined var echo 输入已清空
goto :SCHEDULE_MENU


:RESTART_THE_OFFICIAL_VERSION_IMMEDIATELY
call %~dp0server\正式版本服务器更新启动代码.bat
echo 执行正式版重新启动流程... >> %LOG_FILE%
echo [%date% %time%] 游戏已手动重启 >> %LOG_FILE%
pause
goto :eof

:RESTART_THE_BETA_VERSION_IMMEDIATELY
call %~dp0server\测试版本服务器更新启动代码.bat
echo 执行测试版重新启动流程... >> %LOG_FILE%
echo [%date% %time%] 游戏已手动重启 >> %LOG_FILE%
pause
goto :eof

:SCHEDULE_OFFICIAL_RESTART
set /p "target_time=请输入下次执行时间(HH:MM:SS格式): "
set /p "max_count=请输入最大执行次数(0为无限循环): "

echo [%date% %time%] 脚本启动，目标文件:!FILE_PATH_OFFICIAL_VERSION_IMMEDIATELY! >> !log_file!
if not exist "!FILE_PATH_OFFICIAL_VERSION_IMMEDIATELY!" (
    echo [%date% %time%] 错误：文件不存在 >> !log_file!
    pause
    exit /b 1
)

set counter=0
:loop
set /a counter+=1

:wait_loop
for /f "tokens=1-3 delims=:." %%a in ("%time%") do (
    set current_hour=%%a
    set current_min=%%b
    set current_sec=%%c
)
for /f "tokens=1-3 delims=:." %%a in ("%target_time%") do (
    set target_hour=%%a
    set target_min=%%b
    set target_sec=%%c
)

if !current_hour! lss !target_hour! goto check_time
if !current_hour! gtr !target_hour! goto next_day
if !current_min! lss !target_min! goto check_time
if !current_min! gtr !target_min! goto next_day
if !current_sec! lss !target_sec! goto check_time

:execute
echo [%date% %time%] 开始第!counter!次执行 >> !log_file!
call %~dp0server\正式版本服务器更新启动代码.bat
echo [%date% %time%] 第!counter!次执行完成 >> !log_file!

if !max_count! gtr 0 (
    if !counter! geq !max_count! goto end
)

:next_day
set /a target_hour+=24
goto wait_loop

:check_time
timeout /t 1 /nobreak >nul
goto wait_loop

:end
echo [%date% %time%] 循环执行完成，共执行!counter!次 >> !log_file!
pause
goto :eof

:SCHEDULE_BETA_RESTART
set /p "target_time=请输入下次执行时间(HH:MM:SS格式): "
set /p "max_count=请输入最大执行次数(0为无限循环): "

echo [%date% %time%] 脚本启动，目标文件:!file_path_official_version_immediately! >> !log_file!
if not exist "!file_path_official_version_immediately!" (
    echo [%date% %time%] 错误：文件不存在 >> !log_file!
    pause
    exit /b 1
)

set counter=0
:loop
set /a counter+=1

:wait_loop
for /f "tokens=1-3 delims=:." %%a in ("%time%") do (
    set current_hour=%%a
    set current_min=%%b
    set current_sec=%%c
)
for /f "tokens=1-3 delims=:." %%a in ("%target_time%") do (
    set target_hour=%%a
    set target_min=%%b
    set target_sec=%%c
)

if !current_hour! lss !target_hour! goto check_time
if !current_hour! gtr !target_hour! goto next_day
if !current_min! lss !target_min! goto check_time
if !current_min! gtr !target_min! goto next_day
if !current_sec! lss !target_sec! goto check_time

:execute
echo [%date% %time%] 开始第!counter!次执行 >> !log_file!
call %~dp0server\测试版本服务器更新启动代码.bat
echo [%date% %time%] 第!counter!次执行完成 >> !log_file!

if !max_count! gtr 0 (
    if !counter! geq !max_count! goto end
)

:next_day
set /a target_hour+=24
goto wait_loop

:check_time
timeout /t 1 /nobreak >nul
goto wait_loop

:end
echo [%date% %time%] 循环执行完成，共执行!counter!次 >> !log_file!
pause
goto :eof


:: 其他功能函数（如: START_TEST_SERVER, BACKUP_GAME_SAVE_FILES 等）在此处省略，需根据实际需求补充

:BACKUP_GAME_SAVE_FILES
call %~dp0program\Shut-down-the-server.bat
echo 存档已备份至program文件夹
pause
goto :EOF

:SHUTDOWN_SERVER
call %~dp0program\Shut-down-the-server.bat
echo 服务器已关闭
pause
goto :EOF

:OPEN_SAVES
if exist "%SAVE_GAME_PATH%" (
    explorer.exe "%SAVE_GAME_PATH%"
) else (
    echo 存档路径不存在: %SAVE_GAME_PATH%
)
echo 已打开存档
pause
goto :EOF

:SET_MAX_PLAYERS
set /p NEW_VALUE=请输入新的玩家数量(1-100): 
if %NEW_VALUE% GEQ 1 if %NEW_VALUE% LEQ 100 (
    (for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%CONFIG_FILE%"') do (
        set "line=%%b"
        if defined line (
            if "!line:MaxPlayers=!" neq "!line!" (
                echo MaxPlayers=%NEW_VALUE%
            ) else (
                echo !line!
            )
        )
    )) > "%CONFIG_FILE%.tmp"
    move /y "%CONFIG_FILE%.tmp" "%CONFIG_FILE%" >nul
    echo 最大玩家数已更新为 %NEW_VALUE%
) else (
    echo 输入无效，请输入1-100之间的数字
)
:: 替换原配置文件
if exist "%~dp0program\Game.ini" (
    copy "%~dp0program\Game.ini" "%~dp0server\servercore\servercore7777\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo 未找到游戏人数文件，测试版服务器游戏人数修改失败
)
if exist "%~dp0program\Game.ini" (
    copy "%~dp0program\Game.ini" "%~dp0server\servercore\servercore8888\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo 未找到游戏人数文件，测试版服务器游戏人数修改失败
)
pause
goto :EOF

:OPEN_PORTS
call %~dp0program\open-port.bat
goto :EOF

:UNINSTALL_SERVER
set /p CONFIRM=确定要卸载服务器文件吗？(y/n): 
if /i "%CONFIRM%"=="y" (
    rd /s /q "server\servercore"
    echo 已删除: 服务器文件
) else (
    echo 卸载已取消
)
pause
goto :EOF

:UPDATE_MENU
set /p confirm="更新服务器管理菜单吗 (y/n): "
if /i "%confirm%"=="y" (
    rd /s /q "%~dp0program"
            echo 已删除: program
    curl -o "SatisfactoryDe-dicatedServer.zip" "http://nas.sxtvip.top:5244/d/1/update/SatisfactoryDe-dicatedServer.zip?sign=n7RvJDuPF5hBidV9iMnM9lcdbTDyd0vPXbSxImn40G0=:0"
    if %errorlevel% neq 0 (
        echo 下载更新失败
       tar -xf "%~dp0SatisfactoryDe-dicatedServer.zip" && del "%~dp0SatisfactoryDe-dicatedServer.zip"
    )
       tar -xf "%~dp0SatisfactoryDe-dicatedServer.zip" && del "%~dp0SatisfactoryDe-dicatedServer.zip"
    echo 更新完成
) else (
    echo 操作取消
)
pause
goto :EOF


:MODIFY_AUTO_SAVE
set /p NEW_VALUE1=自动保存文件的数量(1-999): 
if %NEW_VALUE1% GEQ 1 if %NEW_VALUE1% LEQ 999 (
    (for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%CONFIG_FILE1%"') do (
        set "line=%%b"
        if defined line (
            if "!line:mNumRotatingAutosaves=!" neq "!line!" (
                echo mNumRotatingAutosaves=%NEW_VALUE1%
            ) else (
                echo !line!
            )
        )
    )) > "%CONFIG_FILE1%.tmp"
    move /y "%CONFIG_FILE1%.tmp" "%CONFIG_FILE1%" >nul
    echo 自动保存文件的数量为 %NEW_VALUE1%
) else (
    echo 输入无效，请输入1-999之间的数字
)
:: 替换原配置文件
if exist "%~dp0program\Engine.ini" (
    copy "%~dp0program\Engine.ini" "%~dp0server\servercore\servercore7777\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo 未找到游戏人数文件，测试版服务器游戏人数修改失败
)
if exist "%~dp0program\Engine.ini" (
    copy "%~dp0program\Engine.ini" "%~dp0server\servercore\servercore8888\FactoryGame\Saved\Config\WindowsServer"
) else (
    echo 未找到游戏人数文件，测试版服务器游戏人数修改失败
)
pause
goto :EOF

:OPEN_PORTS
call %~dp0program\open-port.bat
echo 启动完成
pause
goto :EOF

:MONITOR_PLAYERS
call %~dp0server\monitor_players.bat
echo 启动完成
pause 
goto :EOF

