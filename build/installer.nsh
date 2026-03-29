; NSIS 自定义安装脚本
; 支持自定义安装目录和注册到服务列表

!include MUI2.nsh
!include FileFunc.nsh
!include x64.nsh

; 安装器属性
!define MUI_ICON "src\icon.ico"
!define MUI_UNICON "src\icon.ico"
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\nsis3-metro.bmp"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME

; 许可协议页面
!define MUI_LICENSEPAGE_TEXT_BOTTOM "请点击我同意继续安装"
!insertmacro MUI_PAGE_LICENSE "LICENSE"

; 安装目录选择页面
!define MUI_PAGE_CUSTOMFUNCTION_PRE InstDirPre
!insertmacro MUI_PAGE_DIRECTORY

; 组件选择页面
!insertmacro MUI_PAGE_COMPONENTS

; 安装页面
!insertmacro MUI_PAGE_INSTFILES

; 完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\NoteForge.exe"
!define MUI_FINISHPAGE_RUN_CHECKED
!insertmacro MUI_PAGE_FINISH

; 卸载确认页面
!insertmacro MUI_UNPAGE_CONFIRM

; 卸载页面
!insertmacro MUI_UNPAGE_INSTFILES

; 语言
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装程序初始化
Function .onInit
  SetShellVarContext all

  ; 默认安装目录
  ${If} ${RunningX64}
    ReadRegStr $INSTDIR HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "InstallLocation"
  ${Else}
    ReadRegStr $INSTDIR HKLM "Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "InstallLocation"
  ${EndIf}

  ${If} $INSTDIR == ""
    StrCpy $INSTDIR "$PROGRAMFILES64\NoteForge"
  ${EndIf}
FunctionEnd

; 安装目录选择前
Function InstDirPre
  ${If} $INSTDIR == ""
    StrCpy $INSTDIR "$PROGRAMFILES64\NoteForge"
  ${EndIf}
FunctionEnd

; 安装段落
Section "NoteForge 主程序" SecMain
  SectionIn RO

  ; 设置输出目录
  SetOutPath "$INSTDIR"

  ; 复制文件
  File /r "src\*.*"

  ; 创建卸载程序
  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; 创建开始菜单快捷方式
  CreateDirectory "$SMPROGRAMS\NoteForge"
  CreateShortcut "$SMPROGRAMS\NoteForge\NoteForge.lnk" "$INSTDIR\NoteForge.exe"
  CreateShortcut "$SMPROGRAMS\NoteForge\卸载 NoteForge.lnk" "$INSTDIR\uninstall.exe"

  ; 创建桌面快捷方式
  CreateShortcut "$DESKTOP\NoteForge.lnk" "$INSTDIR\NoteForge.exe"

  ; 写入注册表
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "DisplayName" "NoteForge"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "DisplayIcon" "$INSTDIR\NoteForge.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "Publisher" "NoteForge Team"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "DisplayVersion" "4.1.0"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "NoRepair" 1

  ; 获取安装大小
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge" "EstimatedSize" "$0"
SectionEnd

; 可选组件
Section /o "添加到 PATH 环境变量" SecPath
  AddToPath "$INSTDIR"
SectionEnd

; 卸载
Section "Uninstall"
  ; 删除快捷方式
  Delete "$DESKTOP\NoteForge.lnk"
  Delete "$SMPROGRAMS\NoteForge\NoteForge.lnk"
  Delete "$SMPROGRAMS\NoteForge\卸载 NoteForge.lnk"
  RMDir "$SMPROGRAMS\NoteForge"

  ; 删除安装文件
  RMDir /r "$INSTDIR"

  ; 删除注册表
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NoteForge"

  ; 从 PATH 移除
  un.RemoveFromPath "$INSTDIR"
SectionEnd

; 添加到 PATH 函数
Function AddToPath
  Exch $0
  Push $1
  Push $2
  Push $3
  Push $4

  ; 读取当前 PATH
  ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"

  ; 检查是否已存在
  Push "$1;"
  Push "$0;"
  Call StrStr
  Pop $2
  StrCmp $2 "" 0 AddToPath_done

  ; 添加到 PATH
  StrCpy $3 "$1;$0"
  WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" $3

  ; 通知系统
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

AddToPath_done:
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd

; 从 PATH 移除函数
Function un.RemoveFromPath
  Exch $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $5
  Push $6

  ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"

  ; 保存原始 PATH
  StrCpy $5 $1

  ; 移除路径
  Push "$1;"
  Push "$0;"
  Call un.StrStr
  Pop $2

  StrCmp $2 "" un_RemoveFromPath_done

  ; 计算新 PATH
  StrLen $3 $2
  StrLen $4 $1
  StrCpy $6 $1  ; 前半部分
  IntOp $3 $3 + 0  ; 调整长度

  ; 重建 PATH
  System::Call 'kernel32::lstrlen(t r1) i .r3'
  System::Call 'kernel32::lstrlen(t r0) i .r4'

  ; 简单替换
  StrReplace $1 $1 "$0;" ""
  WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" $1

  ; 通知系统
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

un_RemoveFromPath_done:
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd

; 字符串查找函数
Function StrStr
  Exch $R1 ; 子串
  Exch
  Exch $R2 ; 主串
  Push $R3
  Push $R4
  Push $R5

  StrLen $R3 $R1
  StrLen $R4 $R2
  StrCpy $R5 0

  IntOp $R4 $R4 - $R3

StrStr_loop:
  IntOp $R5 $R5 + 1
  StrCpy $R0 $R2 $R3 $R5
  StrCmp $R0 $R1 StrStr_found
  StrCmp $R5 $R4 StrStr_not_found
  Goto StrStr_loop

StrStr_found:
  StrCpy $R1 $R2 "" $R5
  Goto StrStr_done

StrStr_not_found:
  StrCpy $R1 ""

StrStr_done:
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1
FunctionEnd

Function un.StrStr
  Exch $R1
  Exch
  Exch $R2
  Push $R3
  Push $R4
  Push $R5

  StrLen $R3 $R1
  StrLen $R4 $R2
  StrCpy $R5 0

  IntOp $R4 $R4 - $R3

un_StrStr_loop:
  IntOp $R5 $R5 + 1
  StrCpy $R0 $R2 $R3 $R5
  StrCmp $R0 $R1 un_StrStr_found
  StrCmp $R5 $R4 un_StrStr_not_found
  Goto un_StrStr_loop

un_StrStr_found:
  StrCpy $R1 $R2 "" $R5
  Goto un_StrStr_done

un_StrStr_not_found:
  StrCpy $R1 ""

un_StrStr_done:
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1
FunctionEnd

; 字符串替换函数
!define StrReplace '!insertmacro StrReplaceCall'
!macro StrReplaceCall _STRING _SEARCH _REPLACE _RESULT
  Push `${_STRING}`
  Push `${_SEARCH}`
  Push `${_REPLACE}`
  Call StrReplace
  Pop ${_RESULT}
!macroend

Function StrReplace
  Exch $R0 ; 替换值
  Exch
  Exch $R1 ; 查找值
  Exch
  Exch $R2 ; 原字符串
  Push $R3
  Push $R4
  Push $R5

  StrCpy $R3 ""
  StrCpy $R4 $R2

StrReplace_loop:
  Push $R4
  Push $R1
  Call StrStr
  Pop $R5

  StrCmp $R5 "" StrReplace_done

  ; 获取匹配前的部分
  StrLen $R0 $R5
  StrLen $R1 $R1
  IntOp $R0 $R0 - $R1
  StrCpy $R0 $R4 $R0

  StrCpy $R3 "$R3$R0$R0"

  ; 获取剩余部分
  StrLen $R0 $R5
  StrLen $R4 $R4
  IntOp $R0 $R0 + 0
  StrCpy $R4 $R4 $R0 $R0

  Goto StrReplace_loop

StrReplace_done:
  StrCpy $R0 "$R3$R4"

  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd
