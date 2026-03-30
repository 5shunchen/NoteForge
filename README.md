# NoteForge v4.1

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Electron](https://img.shields.io/badge/Electron-31.0.0-blue?logo=electron)](https://www.electronjs.org/)

一个功能强大的本地 Markdown 笔记工具，纯前端实现，数据存储在浏览器本地。

![NoteForge](https://via.placeholder.com/800x450.png?text=NoteForge+Screenshot)

## ✨ 功能特性

### 核心功能
- 🔐 **密码保护** - SHA-256 加密存储
- 📁 **多区域管理** - 支持拖拽排序
- 🌳 **树形笔记结构** - 文件夹/笔记层级管理
- ✂️ **自动大纲切分** - 60 秒无操作自动保存为新大纲
- 🏷️ **6 种大纲命名模式** - 时间/序号/首行/标签/字数/会话
- 📝 **Markdown 渲染** - 支持编辑/分栏/预览三种模式
- 🔍 **全局搜索** - 搜索所有内容（区域/文件夹/笔记/大纲/内容）
- 💾 **数据导入导出** - JSON 格式备份

### 编辑器功能
- 工具栏快捷插入（粗体/斜体/标题/列表/表格等）
- 行号显示
- 字数/行数统计
- 图片插入（支持拖拽/粘贴/URL）
- 语法高亮
- 专注模式

### 主题支持
- 🎨 黑曜石（默认）
- 🌅 Solarized
- 🟢 Monokai
- ❄️ Nord
- 📄 纸张（亮色）
- 🧛 Dracula
- 🟤 Gruvbox
- 🌊 Oceanic

## 🚀 快速开始

### 方法 1：网页版（推荐）
```bash
# 直接用浏览器打开
双击 noteforge.html
```

### 方法 2：Electron 桌面版
```bash
# 1. 安装依赖
npm install

# 2. 运行
npm start

# 3. 打包安装程序
npm run build
```

安装包位置：`build/NoteForge-Setup-4.1.0.exe`

## 📦 打包发布

### 前提条件
- Node.js >= 16.0.0
- npm >= 8.0.0

### 步骤
```bash
# 1. 安装依赖
npm install

# 2. 打包
npm run build
```

### 安装包功能
- ✅ 支持自定义安装目录
- ✅ 自动注册到 Windows 应用列表（控制面板可卸载）
- ✅ 创建桌面快捷方式
- ✅ 创建开始菜单快捷方式
- ✅ 支持完全卸载

## ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+N` | 新建笔记 |
| `Ctrl+T` | 新建区域 |
| `Ctrl+S` | 保存 |
| `Ctrl+L` | 锁定应用 |
| `Ctrl+B` | 粗体 |
| `Ctrl+I` | 斜体 |
| `Ctrl+Enter` | 手动切分大纲 |
| `Enter` (搜索框) | 立即搜索 |
| `Escape` | 关闭搜索面板 |
| `F12` | 开发者工具 |
| `Alt+F4` | 退出应用 |

## 💾 数据管理

### 导出数据
1. 点击标题栏的 `💾` 按钮
2. 选择保存位置
3. 备份文件为 JSON 格式

### 导入数据
1. 点击标题栏的 `📥` 按钮
2. 选择之前导出的 JSON 文件
3. 确认后页面自动刷新

### ⚠️ 注意事项
- 数据存储在浏览器的 localStorage 中
- 不同浏览器的数据不互通
- 清除浏览器缓存会丢失数据
- 建议定期导出备份

## 🏗️ 技术栈

- **前端**: 纯 HTML/CSS/JavaScript
- **Markdown 渲染**: marked.js
- **数据存储**: localStorage
- **加密**: Web Crypto API (SHA-256)
- **桌面框架**: Electron

## 📁 项目结构

```
noteforge/
├── src/                        # 源代码目录
│   ├── main.js                 # Electron 主进程
│   ├── noteforge.html          # 主程序 HTML
│   ├── icon.ico                # 应用图标
│   └── installer.nsh           # NSIS 自定义安装脚本
├── build/                      # 打包输出目录
│   ├── installer.nsi           # NSIS 安装脚本
│   └── NoteForge-Setup-4.1.0.exe  # 安装包
├── build.bat                   # 打包脚本
├── package.json                # 项目配置
└── README.md                   # 项目说明
```

## 🐛 已知限制

1. 图片以 Base64 存储，大图片会快速占用存储空间
2. localStorage 容量限制约 5-10MB
3. 仅支持单用户本地使用

## 📄 版本历史

### v4.1.0
- ✨ 新增数据导入导出功能
- 🚀 优化全局搜索
- 📦 支持 EXE 安装包
- 🐛 修复已知问题

### v4.0.0
- 🎉 初始版本发布

## 📝 使用技巧

1. **大纲管理**: 每个笔记可以有多个大纲，60 秒无操作自动创建新大纲
2. **历史编辑**: 点击历史大纲可编辑，修改会自动创建衍生大纲
3. **大纲重命名**: 双击大纲标题或点击✏按钮即可重命名（包括历史大纲）
4. **拖拽排序**: 区域和笔记都支持拖拽移动
5. **右键菜单**: 右键点击笔记/文件夹显示操作菜单

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

---

**NoteForge** - 为思考者打造的笔记工具 ✍️
