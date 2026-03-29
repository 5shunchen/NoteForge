@echo off
chcp 65001 >nul
cd /d "%~dp0"

title NoteForge 专业打包工具

echo.
echo ╔════════════════════════════════════════╗
echo ║   NoteForge 专业打包工具               ║
echo ╚════════════════════════════════════════╝
echo.

REM 检查 Node.js
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
echo ──────────────────────────────────────
echo  正在安装依赖...
echo ──────────────────────────────────────
echo.

REM 清理旧文件
if exist node_modules rmdir /s /q node_modules
if exist build\win-unpacked rmdir /s /q build\win-unpacked

REM 安装依赖
call npm install

echo.
echo ──────────────────────────────────────
echo  正在打包成 EXE 安装程序...
echo ──────────────────────────────────────
echo.
echo 提示：
echo - 安装程序支持自定义安装目录
echo - 自动注册到 Windows 服务列表
echo - 创建桌面和开始菜单快捷方式
echo.
echo 请稍候...
echo.

REM 执行打包
call npm run build

echo.
echo ──────────────────────────────────────
echo  ✓ 打包完成！
echo ──────────────────────────────────────
echo.

if exist "build\NoteForge-Setup-4.1.0.exe" (
    echo 安装包位置：build\NoteForge-Setup-4.1.0.exe
    echo.
    echo 按任意键打开输出文件夹...
    pause >nul
    explorer "build"
) else (
    echo [!] 未找到安装包，请检查错误信息
    echo.
    pause
)
