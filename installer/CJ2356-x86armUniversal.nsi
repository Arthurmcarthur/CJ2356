Unicode True
!include MUI2.nsh
!include "Registry.nsh"
!include x64.nsh
!include nsDialogs.nsh
!include Sections.nsh



!define PRODUCT_NAME "倉頡三五"
!define PRODUCT_VERSION "0.1"
!define PRODUCT_PUBLISHER "倉頡之友 & 輕鬆輸入法團隊"
!define PRODUCT_WEB_SITE "http://github.com/jrywu/DIME"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
; ## HKLM = HKEY_LOCAL_MACHINE
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; ## HKCU = HKEY_CURRENT_USER

SetCompressor lzma
ManifestDPIAware true
BrandingText " "

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_NOSTRETCH

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
;!insertmacro MUI_PAGE_LICENSE "LICENSE-zh-Hant.rtf"
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
Page custom SelectLevel1Opt ProcessLevel1
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_TITLE "安裝完成"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
;!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "TradChinese"


; MUI end ------
RequestExecutionLevel admin

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
RequestExecutionLevel admin
OutFile "CJ2356-x86armUniversal.exe"
InstallDir "$PROGRAMFILES64\CJ2356"
ShowInstDetails show
ShowUnInstDetails show

;====================RADIO BUTTON BEGIN====================
Var countryEnum

Section /o "Simplified Chinese(PRC)" ZH_CN
  ;MessageBox MB_OK "Simplified Chinese(PRC)"
  StrCpy $countryEnum "1"
SectionEnd

Section /o "Simplified Chinese(Singapore)" ZH_SG
  ;MessageBox MB_OK "Simplified Chinese(Singapore)"
  StrCpy $countryEnum "2"
SectionEnd

Section /o "Traditional Chinese(Taiwan)" ZH_TW
  ;MessageBox MB_OK "Traditional Chinese(Taiwan)"
  StrCpy $countryEnum "3"
SectionEnd

Section /o "Traditional Chinese(Taiwan)" ZH_HK
  ;MessageBox MB_OK "Traditional Chinese(Hong Kong)"
  StrCpy $countryEnum "4"
SectionEnd

Section /o "Traditional Chinese(Taiwan)" ZH_MO
  ;MessageBox MB_OK "Traditional Chinese(Macau)"
  StrCpy $countryEnum "5"
SectionEnd

;Section "Language" SEC00
;MessageBox MB_OK "Now We are Creating Huuello_world.txt at Desktop!"
;FileOpen $0 "$DESKTOP\Hello_world.txt" w
;FileWrite $0 $countryEnum
;FileClose $0
;SectionEnd

Var hInnerDialog
Var Country_CN
Var Country_SG
Var Country_TW
Var Country_HK
Var Country_MO

Function SelectLevel1Opt
nsDialogs::Create 1018
pop $hInnerDialog
${NSD_CreateLabel} 0 0 100% 12u "請選擇安裝區域。若不選擇，默認將選中繁體中文（台灣）。"
Pop $0
${NSD_CreateRadioButton} 10% 12u 100% 12u "简体中文（中国）"
Pop $Country_CN
nsDialogs::SetUserData $Country_CN ${ZH_CN} ; Only used by the generic function

${NSD_CreateRadioButton} 10% 24u 100% 12u "简体中文（新加坡）"
Pop $Country_SG
nsDialogs::SetUserData $Country_SG ${ZH_SG} ; Only used by the generic function

${NSD_CreateRadioButton} 10% 36u 100% 12u "繁體中文（台灣）"
Pop $Country_TW
nsDialogs::SetUserData $Country_TW ${ZH_TW} ; Only used by the generic function

${NSD_CreateRadioButton} 10% 48u 100% 12u "繁體中文（香港特别行政區）"
Pop $Country_HK
nsDialogs::SetUserData $Country_HK ${ZH_HK} ; Only used by the generic function

${NSD_CreateRadioButton} 10% 60u 100% 12u "繁體中文（澳門特別行政區）"
Pop $Country_MO
nsDialogs::SetUserData $Country_HK ${ZH_HK} ; Only used by the generic function
nsDialogs::Show

FunctionEnd

Function ProcessLevel1
${NSD_GetState} $Country_CN $1
${NSD_GetState} $Country_SG $2
${NSD_GetState} $Country_TW $3
${NSD_GetState} $Country_HK $4
${NSD_GetState} $Country_MO $5
${If} $1 <> ${BST_UNCHECKED}
    !insertmacro SelectSection ${ZH_CN}
    !insertmacro UnselectSection ${ZH_SG}
    !insertmacro UnselectSection ${ZH_TW}
    !insertmacro UnselectSection ${ZH_HK}
    !insertmacro UnselectSection ${ZH_MO}
${EndIf}
${If} $2 <> ${BST_UNCHECKED}
    !insertmacro SelectSection ${ZH_SG}
    !insertmacro UnselectSection ${ZH_CN}
    !insertmacro UnselectSection ${ZH_TW}
    !insertmacro UnselectSection ${ZH_HK}
    !insertmacro UnselectSection ${ZH_MO}
${EndIf}
${If} $3 <> ${BST_UNCHECKED}
    !insertmacro SelectSection ${ZH_TW}
    !insertmacro UnselectSection ${ZH_CN}
    !insertmacro UnselectSection ${ZH_SG}
    !insertmacro UnselectSection ${ZH_HK}
    !insertmacro UnselectSection ${ZH_MO}
${EndIf}
${If} $4 <> ${BST_UNCHECKED}
    !insertmacro SelectSection ${ZH_HK}
    !insertmacro UnselectSection ${ZH_CN}
    !insertmacro UnselectSection ${ZH_SG}
    !insertmacro UnselectSection ${ZH_TW}
    !insertmacro UnselectSection ${ZH_MO}
${EndIf}
${If} $5 <> ${BST_UNCHECKED}
    !insertmacro SelectSection ${ZH_MO}
    !insertmacro UnselectSection ${ZH_CN}
    !insertmacro UnselectSection ${ZH_SG}
    !insertmacro UnselectSection ${ZH_TW}
    !insertmacro UnselectSection ${ZH_HK}
${EndIf}
FunctionEnd

;====================RADIO BUTTON ENDS====================

; Language Strings
LangString DESC_INSTALLING ${LANG_TradChinese} "安裝中"
LangString DESC_DOWNLOADING1 ${LANG_TradChinese} "下載中"
LangString DESC_DOWNLOADFAILED ${LANG_TradChinese} "下載失敗:"
LangString DESC_VCX86 ${LANG_TradChinese} "Visual Studio Redistritable x86"
LangString DESC_VCX64 ${LANG_TradChinese} "Visual Studio Redistritable x64"
LangString DESC_VCARM64 ${LANG_TradChinese} "Visual Studio Redistritable ARM64"
LangString DESC_VCX86_DECISION ${LANG_TradChinese} "安裝此輸入法之前，必須先安裝 $(DESC_VCX86)，若你想繼續安裝 \
  ，您的電腦必須連接網路。$\n您要繼續這項安裝嗎？"
LangString DESC_VCX64_DECISION ${LANG_TradChinese} "安裝此輸入法之前，必須先安裝 $(DESC_VCX64)，若你想繼續安裝 \
  ，您的電腦必須連接網路。$\n您要繼續這項安裝嗎？"
LangString DESC_VCARM64_DECISION ${LANG_TradChinese} "安裝此輸入法之前，必須先安裝 $(DESC_VCARM64)，若你想繼續安裝 \
  ，您的電腦必須連接網路。$\n您要繼續這項安裝嗎？"
!define URL_VC_REDISTX64 https://aka.ms/vs/17/release/vc_redist.x64.exe
!define URL_VC_REDISTX86 https://aka.ms/vs/17/release/vc_redist.x86.exe
!define URL_VC_REDISTARM64 https://aka.ms/vs/17/release/VC_redist.arm64.exe


Var "URL_VCX86"
Var "URL_VCX64"
Var "URL_VCARM64"

Function .onInit
  InitPluginsDir
  StrCpy $URL_VCX86 "${URL_VC_REDISTX86}"
  StrCpy $URL_VCX64 "${URL_VC_REDISTX64}"
  StrCpy $URL_VCARM64 "${URL_VC_REDISTARM64}"
  ${If} ${RunningX64}
  	SetRegView 64
  ${EndIf}
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"
  StrCmp $0 "" StartInstall 0

  MessageBox MB_OKCANCEL|MB_ICONQUESTION "偵測到舊版 $0，必須先移除才能安裝新版。是否要現在進行？" IDOK +2
  	Abort
  ExecWait '"$INSTDIR\uninst.exe" /S _?=$INSTDIR'
  ${If} ${RunningX64}
  	${DisableX64FSRedirection}
  	IfFileExists "$SYSDIR\CJ2356.dll"  0 CheckX64     ;代表反安裝失敗
  		Abort
  CheckX64:
 	${EnableX64FSRedirection}
  ${EndIf}
  IfFileExists "$SYSDIR\CJ2356.dll"  0 RemoveFinished     ;代表反安裝失敗
        Abort
  RemoveFinished:
    	MessageBox MB_ICONINFORMATION|MB_OK "舊版已移除。"
StartInstall:
;!insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "CheckVCRedist" VCR
  Push $R0
  ${If} ${RunningX64}
    SetRegView 64
	ClearErrors	
	${If} ${IsNativeAMD64}
		ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64" "Minor"
		IfErrors InstallVCx64Redist 0
		${If} $R0 > 31
			Goto VCx64RedistInstalled
		${EndIf}
		ClearErrors
		ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64" "Bld"
		IfErrors InstallVCx64Redist 0
		${If} $R0 >= 31103
			Goto VCx64RedistInstalled
		${EndIf}
	InstallVCx64Redist:
		MessageBox MB_ICONEXCLAMATION|MB_YESNO|MB_DEFBUTTON2 "$(DESC_VCX64_DECISION)" /SD IDNO IDYES +1 IDNO VCRedistInstalledAbort
		AddSize 7000
		nsisdl::download /TIMEOUT=30000 "$URL_VCX64" "$PLUGINSDIR\vcredist_x64.exe"
			Pop $0
			StrCmp "$0" "success" lbl_continue64
			DetailPrint "$(DESC_DOWNLOADFAILED) $0"
			Abort
		 lbl_continue64:
		  DetailPrint "$(DESC_INSTALLING) $(DESC_VCX64)..."
		  nsExec::ExecToStack "$PLUGINSDIR\vcredist_x64.exe /q"
		  ;pop $DOTNET_RETURN_CODE
	VCx64RedistInstalled:
	${ElseIf} ${IsNativeARM64}
		ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\arm64" "Minor"
		IfErrors InstallVCarm64Redist 0
		${If} $R0 > 31
			Goto VCarm64RedistInstalled
		${EndIf}
		ClearErrors
		ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\arm64" "Bld"
		IfErrors InstallVCx64Redist 0
		${If} $R0 >= 31103
			Goto VCarm64RedistInstalled
		${EndIf}
	InstallVCarm64Redist:
		MessageBox MB_ICONEXCLAMATION|MB_YESNO|MB_DEFBUTTON2 "$(DESC_VCARM64_DECISION)" /SD IDNO IDYES +1 IDNO VCRedistInstalledAbort
		AddSize 7000
		nsisdl::download /TIMEOUT=30000 "$URL_VCARM64" "$PLUGINSDIR\vcredist_arm64.exe"
			Pop $0
			StrCmp "$0" "success" lbl_continueARM64
			DetailPrint "$(DESC_DOWNLOADFAILED) $0"
			Abort
		 lbl_continueARM64:
		  DetailPrint "$(DESC_INSTALLING) $(DESC_VCARM64)..."
		  nsExec::ExecToStack "$PLUGINSDIR\vcredist_arm64.exe /q"
		  ;pop $DOTNET_RETURN_CODE
	VCarm64RedistInstalled:
	${Endif}
    SetRegView 32
  ${EndIf}
  ClearErrors
  ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X86" "Minor"
  IfErrors InstallVCx86Redist 0
  ${If} $R0 > 31
  	Goto VCRedistInstalled
  ${EndIf}
  ClearErrors
  ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X86" "Bld"
  IfErrors InstallVCx86Redist 0
  ${If} $R0 >= 31103
	Goto VCRedistInstalled
  ${EndIf}
InstallVCx86Redist:
  MessageBox MB_ICONEXCLAMATION|MB_YESNO|MB_DEFBUTTON2 "$(DESC_VCX86_DECISION)" /SD IDNO IDYES +1 IDNO VCRedistInstalledAbort
  AddSize 7000
  nsisdl::download /TIMEOUT=30000 "$URL_VCX86" "$PLUGINSDIR\vcredist_x86.exe"
    Pop $0
    StrCmp "$0" "success" lbl_continue
    DetailPrint "$(DESC_DOWNLOADFAILED) $0"
    Abort

    lbl_continue:
      DetailPrint "$(DESC_INSTALLING) $(DESC_VCX86)..."
      nsExec::ExecToStack "$PLUGINSDIR\vcredist_x86.exe /q"
      ;pop $DOTNET_RETURN_CODE
  Goto VCRedistInstalled
VCRedistInstalledAbort:
  Quit
VCRedistInstalled:
  Exch $R0
SectionEnd



Section "Modules" SEC01
SetOutPath $PROGRAMFILES64
  SetOVerwrite ifnewer
SectionEnd

Section "Language" SEC02
SetOutPath "$PROGRAMFILES64\CJ2356\"
CreateDirectory "$PROGRAMFILES64\CJ2356"
;MessageBox MB_OK "Now We are Creating Huuello_world.txt at Desktop!"
FileOpen $0 "$PROGRAMFILES64\CJ2356\location.txt" w
FileWrite $0 $countryEnum
FileClose $0
SectionEnd


Section "MainSection" SEC03
  SetOutPath "$SYSDIR"
  SetOverwrite ifnewer
  ${If} ${RunningX64}
  	${DisableX64FSRedirection}
	${If} ${IsNativeAMD64}
    	File "system32.x64\CJ2356.dll"
	${ElseIf} ${IsNativeARM64}
		File "system32.arm64\CJ2356.dll"
	${EndIf}
  	ExecWait '"$SYSDIR\regsvr32.exe" /s $SYSDIR\CJ2356.dll'
  	${EnableX64FSRedirection}
  ${EndIf}
  File "system32.x86\CJ2356.dll"
  ExecWait '"$SYSDIR\regsvr32.exe" /s $SYSDIR\CJ2356.dll'
  CreateDirectory  "$INSTDIR"
  SetOutPath "$INSTDIR"
  File "*.cin"
  File "Phrase.txt"
  File "CJ2356Settings.exe"
  File "cj5-ftzk.txt"
  File "cj5-jtzk.txt"
  SetOutPath "$APPDATA\CJ2356\"
  CreateDirectory "$APPDATA\CJ2356"
  ;File "config.ini"

SectionEnd

Section -AdditionalIcons
  SetShellVarContext all
  SetOutPath $SMPROGRAMS\倉頡三五
  CreateDirectory "$SMPROGRAMS\倉頡三五"
  CreateShortCut "$SMPROGRAMS\倉頡三五\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$SMPROGRAMS\倉頡三五\倉頡三五設定.lnk" "$INSTDIR\CJ2356Settings.exe"
  CreateShortCut "$SMPROGRAMS\倉頡三五\捐助倉頡之友.lnk" "C:\Program Files\Internet Explorer\iexplore.exe" "https://chinesecj.com/forum/forum.php?mod=viewthread&tid=2061"
  CreateShortCut "$SMPROGRAMS\倉頡三五\訪問GitHub開源專案.lnk" "C:\Program Files\Internet Explorer\iexplore.exe" "https://github.com/Arthurmcarthur/CJ2356"
SectionEnd

Section -Post
  SetOutPath  "$INSTDIR"
  WriteUninstaller "$INSTDIR\uninst.exe"
  ${If} ${RunningX64}
  	SetRegView 64
  ${EndIf}
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  ;WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  ;這應該是卸載時顯示的名稱
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$SYSDIR\CJ2356.dll"
  ${If} ${RunningX64}
  	WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" 286
  ${Else}
  	WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" 183
   ${EndIf}
SectionEnd

Function un.onUninstSuccess
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name)已移除成功。" /SD IDOK
FunctionEnd

Function un.onInit
;!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "確定要完全移除$(^Name)？" /SD IDYES IDYES +2
  Abort
FunctionEnd

Section Uninstall
 ${If} ${RunningX64}
  ${DisableX64FSRedirection}
  IfFileExists "$SYSDIR\CJ2356.dll"  0 +2
  ExecWait '"$SYSDIR\regsvr32.exe" /u /s $SYSDIR\CJ2356.dll'
  ${EnableX64FSRedirection}
 ${EndIf}
  IfFileExists "$SYSDIR\CJ2356.dll"  0 +2
  ExecWait '"$SYSDIR\regsvr32.exe" /u /s $SYSDIR\CJ2356.dll'

  ClearErrors
  ${If} ${RunningX64}
  ${DisableX64FSRedirection}
  IfFileExists "$SYSDIR\CJ2356.dll"  0 +3
  Delete "$SYSDIR\CJ2356.dll"
  IfErrors lbNeedReboot +1
  ${EnableX64FSRedirection}
  ${EndIf}
  IfFileExists "$SYSDIR\CJ2356.dll"  0  lbContinueUninstall
  Delete "$SYSDIR\CJ2356.dll"
  IfErrors lbNeedReboot lbContinueUninstall

  lbNeedReboot:
  MessageBox MB_ICONSTOP|MB_YESNO "偵測到有程式正在使用輸入法，請重新開機以繼續移除舊版。是否要立即重新開機？" IDNO lbNoReboot
  Reboot

  lbNoReboot:
  MessageBox MB_ICONSTOP|MB_OK "請將所有程式關閉，再嘗試執行本安裝程式。若仍看到此畫面，請重新開機。" IDOK +1
  Quit
  lbContinueUninstall:

  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.cin"
  Delete "$INSTDIR\Phrase.txt"
  Delete "$INSTDIR\cj5-ftzk.txt"
  Delete "$INSTDIR\cj5-jtzk.txt"
  RMDir /r "$INSTDIR"
  SetShellVarContext all
  Delete "$SMPROGRAMS\倉頡三五\Uninstall.lnk"
  Delete "$SMPROGRAMS\倉頡三五\倉頡三五設定.lnk"
  Delete "$SMPROGRAMS\倉頡三五\捐助倉頡之友.lnk"
  Delete "$SMPROGRAMS\倉頡三五\訪問GitHub開源專案.lnk"
  RMDir  "$SMPROGRAMS\倉頡三五"
  ${If} ${RunningX64}
  	SetRegView 64
  ${EndIf}
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd
