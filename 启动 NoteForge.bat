@echo off
chcp 65001 >nul
cd /d "%~dp0"

title NoteForge 启动器

echo.
echo ╔════════════════════════════════════════╗
echo ║     NoteForge - Markdown 笔记工具      ║
echo ╚════════════════════════════════════════╝
echo.
echo 正在启动...
echo.

REM 方法 1：用浏览器直接打开 HTML 文件（最快）
start "" "%~dp0noteforge.html"
echo [✓] 已用浏览器打开 noteforge.html
echo.
echo ──────────────────────────────────────
echo 如果浏览器没有自动打开，请双击当前目录下的
echo noteforge.html 文件
echo ──────────────────────────────────────
echo.
echo 提示：如果需要更好的体验，可以安装 Node.js
echo 然后运行：启动服务器.bat 启动本地服务器
echo.
echo 按任意键退出此窗口...
pause >nul
