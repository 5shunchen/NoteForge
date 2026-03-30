// Electron Builder 配置 - 用于打包 NW.js 构建的应用
// 这不是 Electron 应用，只是借用 electron-builder 的 NSIS 打包功能

module.exports = {
  appId: "com.noteforge.app",
  productName: "NoteForge",
  artifactName: "${productName}-Setup-${version}.${ext}",
  directories: {
    output: "build"
  },
  files: [
    {
      from: "dist",
      to: ".",
      filter: ["**/*"]
    }
  ],
  win: {
    target: "nsis",
    arch: ["x64"],
    icon: "src/icon.ico"
  },
  nsis: {
    oneClick: false,
    allowToChangeInstallationDirectory: true,
    createDesktopShortcut: true,
    createStartMenuShortcut: true,
    shortcutName: "NoteForge",
    deleteAppDataOnUninstall: false,
    runAfterFinish: true,
    installerLanguages: ["zh_CN"],
    language: "2052",
    license: "LICENSE",
    installerHeaderIcon: "src/icon.ico",
    installerIcon: "src/icon.ico",
    uninstallerIcon: "src/icon.ico"
  }
}
