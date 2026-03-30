const { app, BrowserWindow, Menu, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    title: 'NoteForge',
    icon: path.join(__dirname, 'icon.ico'),
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      webviewTag: true
    },
    show: false,
    backgroundColor: '#0d1117'
  });

  // 加载主 HTML 文件
  mainWindow.loadFile('noteforge.html');

  // 窗口准备好后显示
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  // 创建菜单栏
  const menuTemplate = [
    {
      label: '文件',
      submenu: [
        {
          label: '导出数据',
          click: () => {
            mainWindow.webContents.send('menu-export');
          }
        },
        {
          label: '导入数据',
          click: () => {
            mainWindow.webContents.send('menu-import');
          }
        },
        { type: 'separator' },
        {
          label: '退出',
          accelerator: 'Alt+F4',
          click: () => {
            app.quit();
          }
        }
      ]
    },
    {
      label: '编辑',
      submenu: [
        { role: 'undo' },
        { role: 'redo' },
        { type: 'separator' },
        { role: 'cut' },
        { role: 'copy' },
        { role: 'paste' },
        { role: 'selectAll' }
      ]
    },
    {
      label: '视图',
      submenu: [
        {
          label: '刷新',
          accelerator: 'Ctrl+R',
          click: () => {
            mainWindow.reload();
          }
        },
        { type: 'separator' },
        {
          label: '放大',
          accelerator: 'Ctrl+=',
          click: () => {
            const zoom = mainWindow.webContents.getZoomLevel();
            mainWindow.webContents.setZoomLevel(zoom + 0.5);
          }
        },
        {
          label: '缩小',
          accelerator: 'Ctrl+-',
          click: () => {
            const zoom = mainWindow.webContents.getZoomLevel();
            mainWindow.webContents.setZoomLevel(zoom - 0.5);
          }
        },
        {
          label: '重置缩放',
          accelerator: 'Ctrl+0',
          click: () => {
            mainWindow.webContents.setZoomLevel(0);
          }
        },
        { type: 'separator' },
        {
          label: '开发者工具',
          accelerator: 'F12',
          click: () => {
            mainWindow.webContents.openDevTools();
          }
        }
      ]
    },
    {
      label: '帮助',
      submenu: [
        {
          label: '关于',
          click: () => {
            const { dialog } = require('electron');
            dialog.showMessageBox(mainWindow, {
              type: 'info',
              title: '关于 NoteForge',
              message: 'NoteForge v4.1.0',
              detail: '一个功能强大的本地 Markdown 笔记工具\n\n© 2024 NoteForge Team',
              buttons: ['确定']
            });
          }
        }
      ]
    }
  ];

  const menu = Menu.buildFromTemplate(menuTemplate);
  Menu.setApplicationMenu(menu);

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// 应用准备就绪时创建窗口
app.whenReady().then(createWindow);

// 所有窗口关闭时退出应用
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// 应用激活时重新创建窗口
app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// 防止多实例
const gotTheLock = app.requestSingleInstanceLock();
if (!gotTheLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.focus();
    }
  });
}
