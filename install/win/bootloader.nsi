;======================================================
; Include
 
  !include "MUI.nsh"

;======================================================
; Installer Information
 
  Name "Pair Bootloader version 0.1.0"
  OutFile "Pair.exe"
  InstallDir "C:\Program Files\Pair"
 
;======================================================
; Modern Interface Configuration
 
  !define MUI_HEADERIMAGE
  !define MUI_ABORTWARNING
  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
  !define MUI_FINISHPAGE
  !define MUI_FINISHPAGE_TEXT "Thank you for installing the appname. \r\n\n\nYou can check the install by going to the Test Page at: http://appname/testpage.jsp"
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

  ;DetailPrint "nsPython::execFile $PLUGINSDIR\startup.py"
  ;nsPython::execFile "$PLUGINSDIR\startup.py"

  ; Version checking logic
  ; This will send out a warning if the same version is already installed
  
  ; copy version to the variable
  FileRead $R8 $varPreviousVersion
  ; If the variable is empty (which will mean the file is not there in this case
  ; go to lbl_noprev. Otherwise go to lbl_prev
  StrCmp $varPreviousVersion "" lbl_noprev lbl_prev
 
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
    ;!insertmacro MUI_INSTALLOPTIONS_EXTRACT "..\customerConfig.ini"
    ;!insertmacro MUI_INSTALLOPTIONS_EXTRACT "..\priorApp.ini"
 
    ;Extract Install Options files
    ;$PLUGINSDIR will automatically be removed when the installer closes
    ;InitPluginsDir
    
    ;File "/oname=$PLUGINSDIR\python23.dll" "c:\windows\system32\python23.dll"
    ;File "/oname=$PLUGINSDIR\startup.py" "startup.py"

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
 
Function AdvReplaceInFile
         Exch $0 ;file to replace in
         Exch
         Exch $1 ;number to replace after
         Exch
         Exch 2
         Exch $2 ;replace and onwards
         Exch 2
         Exch 3
         Exch $3 ;replace with
         Exch 3
         Exch 4
         Exch $4 ;to replace
         Exch 4
         Push $5 ;minus count
         Push $6 ;universal
         Push $7 ;end string
         Push $8 ;left string
         Push $9 ;right string
         Push $R0 ;file1
         Push $R1 ;file2
         Push $R2 ;read
         Push $R3 ;universal
         Push $R4 ;count (onwards)
         Push $R5 ;count (after)
         Push $R6 ;temp file name
         GetTempFileName $R6
         FileOpen $R1 $0 r ;file to search in
         FileOpen $R0 $R6 w ;temp file
                  StrLen $R3 $4
                  StrCpy $R4 -1
                  StrCpy $R5 -1
        loop_read:
         ClearErrors
         FileRead $R1 $R2 ;read line
         IfErrors exit
         StrCpy $5 0
         StrCpy $7 $R2
 
        loop_filter:
         IntOp $5 $5 - 1
         StrCpy $6 $7 $R3 $5 ;search
         StrCmp $6 "" file_write2
         StrCmp $6 $4 0 loop_filter
 
         StrCpy $8 $7 $5 ;left part
         IntOp $6 $5 + $R3
         StrCpy $9 $7 "" $6 ;right part
         StrCpy $7 $8$3$9 ;re-join
 
         IntOp $R4 $R4 + 1
         StrCmp $2 all file_write1
         StrCmp $R4 $2 0 file_write2
         IntOp $R4 $R4 - 1
 
         IntOp $R5 $R5 + 1
         StrCmp $1 all file_write1
         StrCmp $R5 $1 0 file_write1
         IntOp $R5 $R5 - 1
         Goto file_write2
 
        file_write1:
         FileWrite $R0 $7 ;write modified line
         Goto loop_read
 
        file_write2:
         FileWrite $R0 $R2 ;write unmodified line
         Goto loop_read
 
        exit:
         FileClose $R0
         FileClose $R1
 
         SetDetailsPrint none
         Delete $0
         Rename $R6 $0
         Delete $R6
         SetDetailsPrint both
 
         Pop $R6
         Pop $R5
         Pop $R4
         Pop $R3
         Pop $R2
         Pop $R1
         Pop $R0
         Pop $9
         Pop $8
         Pop $7
         Pop $6
         Pop $5
         Pop $4
         Pop $3
         Pop $2
         Pop $1
         Pop $0
FunctionEnd
