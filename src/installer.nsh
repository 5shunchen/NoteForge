; NoteForge NSIS 自定义安装脚本
; 支持自定义安装目录、注册到 Windows 应用列表和系统服务

!include "FileFunc.nsh"
!include "WinVer.nsh"

!macro customInit
  ; 检查是否已安装
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "UninstallString"
  StrCmp $R0 "" +2
    MessageBox MB_YESNO|MB_ICONQUESTION "检测到已安装的 NoteForge，是否先卸载旧版本？" /SD IDYES IDYES uninstallPrevious
FunctionEnd

!macro customUnInstall
  ; 清理注册表
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\NoteForge.exe"
  DeleteRegKey HKLM "Software\NoteForge"
  DeleteRegKey HKCU "Software\NoteForge"

  ; 清理文件关联
  DeleteRegKey HKCU "Software\Classes\.md"
  DeleteRegKey HKCU "Software\Classes\NoteForge.md"

  ; 清理开机自启
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "NoteForge"

  ; 清理服务注册
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "NoteForge"

  ; 删除安装目录
  RMDir /r /REBOOTOK "$INSTDIR"
!macroend

!macro customInstall
  ; 设置默认安装目录
  ${If} $INSTDIR == ""
    StrCpy $INSTDIR "$PROGRAMFILES64\NoteForge"
  ${EndIf}

  ; 注册到 Windows 应用路径（可通过运行对话框 Win+R 启动 NoteForge）
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\NoteForge.exe" "" "$INSTDIR\NoteForge.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\NoteForge.exe" "Path" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\NoteForge.exe" "DisplayName" "NoteForge"

  ; 注册应用信息
  WriteRegStr HKLM "Software\NoteForge" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "Software\NoteForge" "Version" "${VERSION}"
  WriteRegStr HKLM "Software\NoteForge" "DisplayName" "NoteForge"

  ; 注册应用卸载信息到控制面板
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "DisplayName" "NoteForge"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "UninstallString" "$INSTDIR\Uninstall NoteForge.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "QuietUninstallString" "$INSTDIR\Uninstall NoteForge.exe /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "DisplayIcon" "$INSTDIR\NoteForge.exe,0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "Publisher" "NoteForge Team"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "HelpLink" "https://github.com/noteforge"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "NoModify" "1"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "NoRepair" "1"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "VersionMajor" "4"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" "VersionMinor" "1"

  ; 注册 .md 文件关联（双击 .md 文件用 NoteForge 打开）
  WriteRegStr HKCU "Software\Classes\.md" "" "NoteForge.md"
  WriteRegStr HKCU "Software\Classes\NoteForge.md" "" "Markdown 文档"
  WriteRegStr HKCU "Software\Classes\NoteForge.md\DefaultIcon" "" "$INSTDIR\NoteForge.exe,0"
  WriteRegStr HKCU "Software\Classes\NoteForge.md\shell\open\command" "" '"$INSTDIR\NoteForge.exe" "%1"'

  ; 注册开机自启服务（用户登录时自动启动）
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "NoteForge" "$INSTDIR\NoteForge.exe"

  ; 注册到 Windows 服务（系统级）
  ; 注意：Electron 应用不适合作为 Windows 服务运行，这里使用开机自启代替
  ; 如果需要真正的系统服务，需要使用 NSSM 或 sc.exe 注册后台服务

  ; 添加到系统 PATH（可选，让用户可以通过命令行启动）
  ReadEnvStr $R1 "PATH"
  StrCmp $R1 "" skip_path
    StrCpy $R1 "$R1;$INSTDIR"
  skip_path:
  WriteEnvStr "PATH" "$R1"

  ; 显示安装成功消息
  MessageBox MB_OK|MB_ICONINFORMATION "NoteForge 已成功安装到：$INSTDIR$\n$\n已注册以下服务：$\n- Windows 应用列表$\n- .md 文件关联$\n- 开机自启动"
!macroend

Function uninstallPrevious
  ExecWait '"$R0" /S _?=$INSTDIR'
FunctionEnd
