;======================================================
; Include
 
  !include "MUI.nsh"

;======================================================
; Installer Information
 
  Name "Pair 1.0.0"
  OutFile "Pair.exe"
  InstallDir "C:\Program Files\Pair"
  BrandingText " "
 
;======================================================
; Modern Interface Configuration
 
  !define MUI_HEADERIMAGE
  !define MUI_ABORTWARNING
  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
  !define MUI_FINISHPAGE
  !define MUI_FINISHPAGE_TEXT "Thank you for installing Pair."
  !define MUI_WELCOMEFINISHPAGE_BITMAP "header.bmp"
  !define MUI_ICON "favicon.ico"
 
;======================================================
; Pages
 
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_COMPONENTS
  Page custom customerConfig
  Page custom priorApp
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

;======================================================
; Languages
 
  !insertmacro MUI_LANGUAGE "English"
 
;======================================================
; Reserve Files
 
  ;ReserveFile "..\customerConfig.ini"
  ;ReserveFile "..\priorApp.ini"
  ReserveFile "c:\windows\system32\python23.dll"
  ReserveFile "startup.py"
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
 
 
;======================================================
; Variables
  var varCustomerName
  var varCustomerLicense
  var varPriorApp
  var varPreviousVersion

;======================================================
; Sections
 
Section "Install a full application" fullInstallSection

  ; Version checking logic
  ; This will send out a warning if the same version is already installed
  ; copy version to the variable
  ;FileRead $R8 $varPreviousVersion
  ; If the variable is empty (which will mean the file is not there in this case
  ; go to lbl_noprev. Otherwise go to lbl_prev
  ;StrCmp $varPreviousVersion "" lbl_noprev lbl_prev
 
  ; start python
  nsPython::execFile "$PLUGINSDIR\startup.py"
  Pop $0
  lbl_noprev:
       

  GoTo lbl_prevdone
 
  lbl_prev:
  ;MessageBox MB_OK "Previous version: $varPreviousVersion"
  ; If the variable is equal to 1.0.0, which is the version of this installer,
  ; go to lbl_warn, otherwise for to lbl_del
  StrCmp $varPreviousVersion "1.0.0" lbl_warn lbl_del
 
      lbl_warn:
      ; Ask confirmation to user that they want to install 1.0.0 even though they
      ; already have it installed. If they click OK, go to lbl_prevdone, if they click
      ; Cancel, go to lbl_ABORT
      MessageBox MB_OKCANCEL|MB_ICONQUESTION "Existing install is the same version as this installer. The existing install will be removed. Do you want to continue?" IDOK lbl_prevdone IDCANCEL lbl_ABORT
 
             lbl_ABORT:
             ; Abort the install
             ABORT
             GoTo lbl_del
 
                    lbl_del:
                    ; Delete the previous install by deleting a file and a directory
                    ;Delete "$varPriorapp\bin\app.bat"
                    ; The /r ensures the directory will be deleted even though it's not empty
                    ;RMDir /r "$varPriorapp\webapps"
                    GoTo lbl_prevdone
 
  lbl_prevdone:
       ; start python
       nsPython::execFile "$PLUGINSDIR\startup.py"
       Pop $0

  SetOutPath $INSTDIR
 
SectionEnd
 
Section "Install a Patch to an existing app" installPatchSection
  ; Version checking logic
  ; This will send out a warning if the same version is already installed
  ; and abort if there is no previous version
  ; Copy version to a variable
  ;FileRead $R8 $varPreviousVersion
  ; If the variable is empty (which will mean the file is not there in this case
  ; go to lbl_noprev. Otherwise go to lbl_prev
  StrCmp $varPreviousVersion "" lbl_noprev lbl_prev
 
  lbl_noprev:
  ; The variable is empty, meaning either the previous install was corrupt or the file wasn't
  ; there, which means they need to do a full install, not just a patch install
  MessageBox MB_OK "No previous version detected. You need to perform a full install"
  ; Abort the install
  ABORT
  GoTo lbl_prevdone
 
  lbl_prev:
  ;MessageBox MB_OK "Previous version of app: $varPreviousVersion"
  ; If the variable is equal to 1.0.0, which is the version of this installer,
  ; go to next command (the message box), otherwise for to two commands down (or the CreateDirectory)
  StrCmp $varPreviousVersion "1.0.0" "+1" "+2"
  ; Ask confirmation to user that they want to install 1.0.0 even though they
  ; already have it installed. If they click OK, go to lbl_prevdone, if they click
  ; Cancel, go to lbl_ABORT
  MessageBox MB_OKCANCEL|MB_ICONQUESTION "Existing install is the same version as this installer. Do you want to continue?" IDOK lbl_prevdone IDCANCEL lbl_ABORT
 
          lbl_ABORT:
          ; Abort the install
          ABORT
          GoTo lbl_prevdone
 
  lbl_prevdone:
  
  ; Perform the actual install

SectionEnd
;======================================================
;Descriptions
 
  ;Language strings
  LangString DESC_InstallPatch ${LANG_ENGLISH} "This will install a patch to an existing app."
  LangString DESC_InstallFull ${LANG_ENGLISH} "This will install a full app. PLEASE NOTE: This will delete any existing install."
 
  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${fullInstallSection} $(DESC_InstallFull)
  !insertmacro MUI_DESCRIPTION_TEXT ${installPatchSection} $(DESC_InstallPatch)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;======================================================
; Functions
 
Function .onInit
    ;Extract Install Options files
    ;$PLUGINSDIR will automatically be removed when the installer closes
    InitPluginsDir
    
    File "/oname=$PLUGINSDIR\python23.dll" "c:\windows\system32\python23.dll"
    File "/oname=$PLUGINSDIR\startup.py" "startup.py"

    ;!insertmacro MUI_INSTALLOPTIONS_EXTRACT "c:\windows\system32\python23.dll"
    ;!insertmacro MUI_INSTALLOPTIONS_EXTRACT "startup.py"

    ;==============================================================
    ; Mutually exclusive functions
    Push $0
 
    StrCpy $R9 ${fullInstallSection}
    SectionGetFlags ${fullInstallSection} $0
    IntOp $0 $0 | ${SF_SELECTED}
    SectionSetFlags ${fullInstallSection} $0
 
    SectionGetFlags ${installPatchSection} $0
    IntOp $0 $0 & ${SECTION_OFF}
    SectionSetFlags ${installPatchSection} $0
 
    Pop $0
    ; END
 
    

FunctionEnd
 
;==============================================================
; Mutually exclusive functions
Function .onSelChange
  Push $0
 
  StrCmp $R9 ${fullInstallSection} check_sec1
 
    SectionGetFlags ${fullInstallSection} $0
    IntOp $0 $0 & ${SF_SELECTED}
    IntCmp $0 ${SF_SELECTED} 0 done done
      StrCpy $R9 ${fullInstallSection}
      SectionGetFlags ${installPatchSection} $0
      IntOp $0 $0 & ${SECTION_OFF}
      SectionSetFlags ${installPatchSection} $0
 
    Goto done
 
  check_sec1:
 
    SectionGetFlags ${installPatchSection} $0
    IntOp $0 $0 & ${SF_SELECTED}
    IntCmp $0 ${SF_SELECTED} 0 done done
      StrCpy $R9 ${installPatchSection}
      SectionGetFlags ${fullInstallSection} $0
      IntOp $0 $0 & ${SECTION_OFF}
      SectionSetFlags ${fullInstallSection} $0
 
  done:
 
  Pop $0
FunctionEnd
 
;==============================================================
; Custom screen functions
LangString TEXT_IO_TITLE ${LANG_ENGLISH} "Configuration page"
LangString TEXT_IO_SUBTITLE ${LANG_ENGLISH} "This page will update application files based on your system configuration."
 
Function priorapp
   ; read in section flag
   Push $0
   SectionGetFlags ${installPatchSection} $0
   ; skip complete function if not selected. that way this InstallOptions screen doesn't show
   ; if it's not needed (if they do a patch install, we don't need to ask them this question)
   StrCmp $0 ${SF_SELECTED} configdone 0
   !insertmacro MUI_HEADER_TEXT "$(TEXT_IO_TITLE)" "$(TEXT_IO_SUBTITLE)"
   !insertmacro MUI_INSTALLOPTIONS_DISPLAY "..\priorApp.ini"
   !insertmacro MUI_INSTALLOPTIONS_READ $varPriorapp "..\priorApp.ini" "Field 2" "State"
   configdone:
   Pop $0
FunctionEnd
 
Function customerConfig
   ; read in section flag
   Push $0
   SectionGetFlags ${installPatchSection} $0
   ; skip complete function if not selected
   StrCmp $0 ${SF_SELECTED} configdone 0
   !insertmacro MUI_HEADER_TEXT "$(TEXT_IO_TITLE)" "$(TEXT_IO_SUBTITLE)"
   !insertmacro MUI_INSTALLOPTIONS_DISPLAY "..\customerConfig.ini"
   !insertmacro MUI_INSTALLOPTIONS_READ $varCustomerName "..\customerConfig.ini" "Field 1" "State"
   !insertmacro MUI_INSTALLOPTIONS_READ $varCustomerLicense "..\customerConfig.ini" "Field 2" "State"
   configdone:
   Pop $0
FunctionEnd
