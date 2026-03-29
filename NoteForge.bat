@echo off
chcp 65001 >nul
cd /d "%~dp0"

REM 检查 dist 文件夹是否存在
if not exist "dist\NoteForge.exe" (
    echo.
    echo ╔════════════════════════════════════════╗
    echo ║   NoteForge - 首次启动                 ║
    echo ╚════════════════════════════════════════╝
    echo.
    echo [!] 未找到 EXE 文件，正在打包...
    echo.
    call "打包 exe.bat"
    echo.
)

REM 启动应用
start "" "%~dp0dist\NoteForge.exe"
