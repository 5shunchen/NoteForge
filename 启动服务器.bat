@echo off
chcp 65001 >nul
cd /d "%~dp0"

title NoteForge 服务器

echo.
echo ╔════════════════════════════════════════╗
echo ║   NoteForge - 本地服务器模式           ║
echo ╚════════════════════════════════════════╝
echo.

node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [✗] 未检测到 Node.js
    echo.
    echo 请先安装 Node.js: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo [✓] 检测到 Node.js
echo.
echo 正在启动服务器...
echo.
echo ──────────────────────────────────────
echo  服务器地址：http://localhost:8080
echo  文件位置：%~dp0noteforge.html
echo  按 Ctrl+C 可停止服务器
echo ──────────────────────────────────────
echo.

start http://localhost:8080/noteforge.html

npx -y http-server -p 8080 -c-1 --silent
