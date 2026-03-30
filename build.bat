@echo off
chcp 65001 >nul
cd /d "%~dp0"

title NoteForge 打包工具

echo.
echo ╔════════════════════════════════════════╗
echo ║      NoteForge v4.1.0 打包工具         ║
echo ╚════════════════════════════════════════╝
echo.

REM 检查 Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Node.js
    echo.
    echo 请先安装 Node.js: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo [✓] 检测到 Node.js
echo.

REM 检查依赖
if not exist "node_modules" (
    echo [安装] 正在安装依赖...
    call npm install
    if %errorlevel% neq 0 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
)

echo.
echo ════════════════════════════════════════
echo   开始打包...
echo ════════════════════════════════════════
echo.

call npm run build

if %errorlevel% neq 0 (
    echo.
    echo [错误] 打包失败
    pause
    exit /b 1
)

echo.
echo ╔════════════════════════════════════════╗
echo ║         ✓ 打包完成！                  ║
echo ╚════════════════════════════════════════╝
echo.
echo 安装包位置：build\NoteForge-Setup-4.1.0.exe
echo.

if exist "build\NoteForge-Setup-4.1.0.exe" (
    explorer /select,"build\NoteForge-Setup-4.1.0.exe"
)

pause
exit /b 0
