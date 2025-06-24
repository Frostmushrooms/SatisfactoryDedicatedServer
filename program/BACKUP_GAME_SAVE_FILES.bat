@echo off
setlocal enabledelayedexpansion

:: 检查管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 重新启动服务器
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)


set "source_dir=%LOCALAPPDATA%\FactoryGame\Saved\SaveGames"       :: 需备份的存档目录
set "backup_root=%~dp0save"                :: 备份存储位置
set "retain_days=30"                        :: 备份保留天数

:: 生成时间戳文件名
set "timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%"
set "zip_file=%backup_root%\Satisfactory_%timestamp%.zip"

:: 创建备份目录
if not exist "%backup_root%" mkdir "%backup_root%"

:: 执行压缩（自动识别ZIP格式）
tar -a -c -f "%zip_file%" "%source_dir%" 2>> "%backup_root%\error.log"
if %errorlevel% equ 0 (
    echo [%date% %time%] 压缩成功: %zip_file% >> "%backup_root%\backup.log"
) else (
    echo [ERROR] 压缩失败！检查error.log >> "%backup_root%\backup.log"
)

:: 清理旧备份
forfiles /p "%backup_root%" /m *.zip /d -%retain_days% /c "cmd /c del @path"
