!define PRODUCT "@APPNAME@"
!define VERSION "@VERSION@"

!include "MUI.nsh"

;--------------------------------
;Configuration

;General
Name "${PRODUCT} ${VERSION}"
OutFile "${PRODUCT}_${VERSION}.exe"

;Folder selection page
InstallDir "$PROGRAMFILES\${PRODUCT}"
 
;Remember install folder
InstallDirRegKey HKCU "Software\${PRODUCT}" ""

;
; Uncomment for smaller file size
;
SetCompressor "lzma"
;
; Uncomment for quick built time
;
;SetCompress "off"

CompletedText "Installation completed. Thank you for choosing ${PRODUCT}"

BrandingText "${PRODUCT}"

;--------------------------------
;Modern UI Configuration

!define MUI_ABORTWARNING
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "@HEADING@"

;--------------------------------
;Pages

!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_LICENSEPAGE_RADIOBUTTONS_TEXT_ACCEPT "I'm cool"
!define MUI_LICENSEPAGE_RADIOBUTTONS_TEXT_DECLINE "Go away"
!define MUI_FINISHPAGE_RUN "$INSTDIR\@APPNAME@.exe"

!insertmacro MUI_PAGE_LICENSE "@LICENSE@"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;!insertmacro MUI_DEFAULT UMUI_HEADERIMAGE_BMP "@HEADING@"

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"
 
;--------------------------------
;Language Strings

;Description
LangString DESC_SecMain ${LANG_ENGLISH} "Install ${PRODUCT}"
LangString DESC_SecDesk ${LANG_ENGLISH} "Create Desktop Shortcuts"
LangString DESC_SecStart ${LANG_ENGLISH} "Create Start Menu Shortcuts"

;--------------------------------
;Installer Sections

Section "!Main EXE" SecMain
 SectionIn RO
 SetOutPath "$INSTDIR"
; File *.ico
 File *.txt
; File @APPNAME@.exe.manifest
 File @APPNAME@.exe
 Delete "$INSTDIR\*.pyd"
 File *.pyd
 Delete "$INSTDIR\python*.dll"
 File *.dll
 Delete "$INSTDIR\*.zip"
 File *.zip
; CreateDirectory "$INSTDIR\icons"
; SetOutPath "$INSTDIR\icons"
; File icons\*.*
 CreateDirectory "$INSTDIR\Lang"
 SetOutPath "$INSTDIR\Lang"
 IfFileExists user.lang userlang
 File lang\*.*
 userlang:
 File /x user.lang lang\*.*
 SetOutPath "$INSTDIR"
 WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayName" "${PRODUCT} (remove only)"
 WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString" "$INSTDIR\Uninstall.exe"

; Now writing to KHEY_LOCAL_MACHINE only -- remove references to uninstall from current user
 DeleteRegKey HKEY_CURRENT_USER "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
; Remove old error log if present
 Delete "$INSTDIR\@APPNAME@.exe.log"

 WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Desktop Icons" SecDesk
   CreateShortCut "$DESKTOP\${PRODUCT}.lnk" "$INSTDIR\${PRODUCT}.exe" ""
SectionEnd

Section "Startmenu Icons" SecStart
   CreateDirectory "$SMPROGRAMS\${PRODUCT}"
   CreateShortCut "$SMPROGRAMS\${PRODUCT}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
   CreateShortCut "$SMPROGRAMS\${PRODUCT}\${PRODUCT}.lnk" "$INSTDIR\${PRODUCT}.exe" "" "$INSTDIR\${PRODUCT}.exe" 0
SectionEnd

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
!insertmacro MUI_DESCRIPTION_TEXT ${SecDesk} $(DESC_SecDesk)
!insertmacro MUI_DESCRIPTION_TEXT ${SecStart} $(DESC_SecStart)
;!insertmacro MUI_DESCRIPTION_TEXT ${SecLang} $(DESC_SecLang)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

 Delete "$INSTDIR\icons\*.*"
 RMDir "$INSTDIR\icons"

 Delete "$INSTDIR\lang\*.*"
 RMDir "$INSTDIR\lang"

 Delete "$INSTDIR\*.*"
 RMDir "$INSTDIR"

 Delete "$DESKTOP\${PRODUCT}.lnk"
 Delete "$SMPROGRAMS\${PRODUCT}\*.*"
 RmDir  "$SMPROGRAMS\${PRODUCT}"

 DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${PRODUCT}"
 DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"

SectionEnd

;--------------------------------
;Functions Section

Function .onInit
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "RTMPyApp") i .r1 ?e' 

  Pop $R0 

  StrCmp $R0 0 +3 

  MessageBox MB_OK "The installer is already running."

  Abort 
FunctionEnd
