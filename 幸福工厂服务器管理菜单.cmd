@echo off
setlocal enabledelayedexpansion
title 幸福工厂服务器管理菜单
color 0F

:: 检查管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 正在获取管理员权限...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:: 常量定义
set CONFIG_FILE=%~dp0program\Game.ini
set CONFIG_FILE1=%~dp0program\Engine.ini
set SAVE_GAME_PATH=%USERPROFILE%\AppData\Local\FactoryGame\Saved\SaveGames
set SERVER_FOLDERS=server\servercore\logs
set target_folder_program=%~dp0program
set target_folder_server=%~dp0server
set LOG_PATH=%~dp0\server\logs\SatisfactoryRestartLogs
set file_path=%~dp0server\正式版本服务器更新启动代码.bat
set file2_path=%~dp0server\测试版本服务器更新启动代码.bat
set log_file=%~dp0\server\logs\SatisfactoryRestart\Satisfactory_Restart_Logsexecution_log_%date:~0,4%%date:~5,2%%date:~8,2%.log
set log2_file=%~dp0\server\logs\SatisfactorybateRestart\Satisfactory_bate_Restart_Logsexecution_log_%date:~0,4%%date:~5,2%%date:~8,2%.log

mkdir "%~dp0\server\logs\SatisfactoryRestart" >nul 2>nul
mkdir "%~dp0\server\logs\SatisfactorybateRestart" >nul 2>nul
mkdir "%~dp0\server\logs\START_TEST_SERVER" >nul 2>nul
mkdir "%~dp0\server\logs\START_STABLE_SERVER" >nul 2>nul

:: 检查目标文件夹是否存在
if exist "%target_folder_program%" (
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

:: 提示使用者是否需要更新最新版本
set /p confirm="是否需要更新到最新版本？ (y/n): "
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
    pause
) else (
    echo 操作取消
    pause
)

:: 进入服务器管理菜单
:MAIN_MENU
cls
title 幸福工厂服务器管理菜单
echo ============================================================
echo     服务器管理菜单 v3.5.5版本
echo     编译人：冰霜蘑菇
echo     QQ:1056484009 QQ群:264127585
echo ============================================================
echo     v3.5.5更新内容
echo     1.增加直接启动服务器代码，跳过更新避免多次写入影响SSD硬盘寿命
echo     修改日期：2025-07-24-22:16
echo ============================================================
echo 1  -  更新/启动服务器
echo 2  -  更新STEAMCDM
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
echo ============================================================

set /p CHOICE=请输入选项(0-12): 

:: 选项处理
if "%CHOICE%"=="1" call :UPDATE_SERVER
if "%CHOICE%"=="2" call :UPDATE_STEAMCDM
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
title 幸福工厂服务器更新菜单
echo ============================================================
echo     服务器管理菜单 v3.5.5版本
echo     编译人：冰霜蘑菇
echo     QQ:1056484009 QQ群:264127585
echo ============================================================
echo 1  -  启动正式版服务器
echo 2  -  启动测试版服务器
echo 3  -  更新并启动正式版服务器
echo 4  -  更新并启动测试版服务器
echo 0  -  返回主菜单
echo ============================================================

set /p CHOICE2=请输入选项(0-4): 

:: 选项处理
if "%CHOICE2%"=="1" call :START_THE_SERVER
if "%CHOICE2%"=="2" call :START_THE_BETA_SERVER
if "%CHOICE2%"=="3" call :UPDATE_AND_START_THE_SERVER
if "%CHOICE2%"=="4" call :UPDATE_AND_START_THE_BETA_SERVER
if "%CHOICE2%"=="0" goto MAIN_MENU
if "%CHOICE2%"=="" echo 检测到空输入！   

:: 使用setlocal清空CHOICE2变量，避免污染全局环境
set CHOICE2=
if not defined var echo 输入已清空
goto UPDATE_SERVER

:: 功能函数

:START_THE_SERVER
call %~dp0server\正式版本服务器启动代码.bat
echo 执行正式版启动流程...
pause
goto :eof

:START_THE_BETA_SERVER
call %~dp0server\测试版本服务器启动代码.bat
echo 执行测试版启动流程...
pause
goto :eof

:UPDATE_AND_START_THE_SERVER
call %~dp0server\正式版本服务器更新启动代码.bat
echo 执行正式版启动流程...
pause
goto :eof

:UPDATE_AND_START_THE_BETA_SERVER
call %~dp0server\测试版本服务器更新启动代码.bat
echo 执行测试版启动流程...
pause
goto :eof

:: 功能函数
:SCHEDULE_MENU
set "target_folder=%~dp0server"

:: 进入幸福工厂自定义重启菜单
:SCHEDULE_MENU
cls
title 幸福工厂自定义重启菜单
echo ============================================================
echo     服务器管理菜单 v3.5.5版本
echo     编译人：冰霜蘑菇
echo     QQ:1056484009 QQ群:264127585
echo     在设置定时重启任务时请注意
echo     启动之后管理菜单不可使用
echo     如果要退出请 CTAR+C 或者关闭当前菜单
echo     如果想同时使用其他指令，请再次打开新的管理器菜单
echo ============================================================
echo 1  -  立即重启正式版
echo 2  -  立即重启测试版
echo 3  -  设置正式版定时重启任务
echo 4  -  设置测试版定时重启任务
echo 0  -  返回主菜单
echo ============================================================

set /p CHOICE3=请输入选项(0-4): 

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
echo 执行正式版重新启动流程... 
echo [%date% %time%] 游戏已手动重启 
pause
goto :eof

:RESTART_THE_BETA_VERSION_IMMEDIATELY
call %~dp0server\测试版本服务器更新启动代码.bat
echo 执行测试版重新启动流程...
echo [%date% %time%] 游戏已手动重启
pause
goto :eof

:SCHEDULE_OFFICIAL_RESTART
set /p execute_time=请输入执行时间(格式HH:MM，如03:00):
set /p loop_days=请输入循环天数(0表示无限循环):
title 正式版每天%execute_time%循环重启
color 0F
echo [%date% %time%] 脚本启动 >> %LOG_FILE%
echo [%date% %time%] 设置执行时间: %execute_time% >> %LOG_FILE%
echo [%date% %time%] 设置循环天数: %loop_days% >> %LOG_FILE%

:: 初始化变量
set day_counter=0
set last_date=

:main_loop
set current_time=%time:~0,5%
set current_date=%date%

:: 检查是否是新的一天
if not "!last_date!"=="!current_date!" (
    set /a day_counter+=1
    set last_date=!current_date!
    echo [!date! !time!] 新的一天开始，已循环天数: !day_counter! >> %LOG_FILE%
)

:wait_loop
cls
echo [%date% %time%] 当前状态: 等待执行 >> %LOG_FILE%
echo 当前日期: %current_date%
echo 当前时间: %current_time%
echo 等待执行时间: %execute_time%
echo 剩余循环天数: %loop_days% (0表示无限循环)
echo 已循环天数: %day_counter%  (功能可能未实现)

:: 每分钟检查一次时间
ping -n 60 127.0.0.1 >nul
set current_time=%time:~0,5%
set current_date=%date%

if "%current_time%" neq "%execute_time%" (
    goto wait_loop
) else (
    echo [%date% %time%] 到达指定时间，开始执行重启 >> %LOG_FILE%
    echo 到达指定时间！正在重新启动服务器...
    
    call %~dp0server\正式版本服务器更新启动代码.bat
    
    :: 记录执行结果
    if %errorlevel% equ 0 (
        echo [%date% %time%] 服务器重启成功 >> %LOG_FILE%
    ) else (
        echo [%date% %time%] 服务器重启失败，错误代码: %errorlevel% >> %LOG_FILE%
    )
    
    :: 更新循环计数器
    if "%loop_days%"=="0" (
        echo [%date% %time%] 无限循环模式，继续等待下次执行 >> %LOG_FILE%
        goto main_loop
    ) else (
        set /a loop_days-=1
        if %loop_days% gtr 0 (
            echo [%date% %time%] 剩余循环次数: %loop_days% >> %LOG_FILE%
            goto main_loop
        ) else (
            echo [%date% %time%] 所有循环已完成！ >> %LOG_FILE%
            echo 所有循环已完成！
            pause
        )
    )
)
goto :eof

:SCHEDULE_BETA_RESTART
set /p execute2_time=请输入执行时间(格式HH:MM，如03:00):
set /p loop2_days=请输入循环天数(0表示无限循环):
title 测试版每天%execute_time%循环重启
color 0F
echo [%date% %time%] 脚本启动 >> %LOG2_FILE%
echo [%date% %time%] 设置执行时间: %execute2_time% >> %LOG2_FILE%
echo [%date% %time%] 设置循环天数: %loop2_days% >> %LOG2_FILE%

:: 初始化变量
set day2_counter=0
set last2_date=

:main2_loop
set current2_time=%time:~0,5%
set current2_date=%date%

:: 检查是否是新的一天
if not "!last2_date!"=="!current2_date!" (
    set /a day2_counter+=1
    set last2_date=!current2_date!
    echo [!date! !time!] 新的一天开始，已循环天数: !day2_counter! >> %LOG_FILE%
)

:wait2_loop
cls
echo [%date% %time%] 当前状态: 等待执行 >> %LOG2_FILE%
echo 当前日期: %current2_date%
echo 当前时间: %current2_time%
echo 等待执行时间: %execute2_time%
echo 剩余循环天数: %loop2_days% (0表示无限循环)
echo 已循环天数: %day2_counter%  (功能可能未实现)

:: 每分钟检查一次时间
ping -n 60 127.0.0.1 >nul
set current_time=%time:~0,5%
set current_date=%date%

if "%current2_time%" neq "%execute2_time%" (
    goto wait2_loop
) else (
    echo [%date% %time%] 到达指定时间，开始执行重启 >> %LOG2_FILE%
    echo 到达指定时间！正在重新启动服务器...
    
    call %~dp0server\测试版本服务器更新启动代码.bat
    
    :: 记录执行结果
    if %errorlevel% equ 0 (
        echo [%date% %time%] 服务器重启成功 >> %LOG2_FILE%
    ) else (
        echo [%date% %time%] 服务器重启失败，错误代码: %errorlevel% >> %LOG2_FILE%
    )
    
    :: 更新循环计数器
    if "%loop2_days%"=="0" (
        echo [%date% %time%] 无限循环模式，继续等待下次执行 >> %LOG2_FILE%
        goto main2_loop
    ) else (
        set /a loop2_days-=1
        if %loop2_days% gtr 0 (
            echo [%date% %time%] 剩余循环次数: %loop2_days% >> %LOG2_FILE%
            goto main2_loop
        ) else (
            echo [%date% %time%] 所有循环已完成！ >> %LOG2_FILE%
            echo 所有循环已完成！
            pause
        )
    )
)
goto :eof

:: 其他功能函数（如: START_TEST_SERVER, BACKUP_GAME_SAVE_FILES 等）在此处省略，需根据实际需求补充

:BACKUP_GAME_SAVE_FILES
call %~dp0program\BACKUP_GAME_SAVE_FILES.bat
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

:UPDATE_STEAMCDM
call %~dp0server\STEAMCMD.bat
echo 执行STEAMCMD启动流程...
pause
goto :eof

