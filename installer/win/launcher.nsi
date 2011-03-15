; Java Jar Launcher
;--------------

Name "@APP_NAME@ @VERSION@"
Caption "@APP_NAME@"
Icon "launcher.ico"
OutFile "@EXE_FILE@"
 
SilentInstall silent
AutoCloseWindow true
ShowInstDetails nevershow

;A file which can contain extra VM arguments
!define ARGFILE "vmargs.cfg"

;The executable jar file
;Note that this file should have a mainclass and/or classpath specified in the jar's manifest
!define JARFILE "@JAR_FILE@"
 
!define LineRead `!insertmacro LineReadCall`
 
	!macro LineReadCall _FILE _NUMBER _RESULT
		Push `${_FILE}`
		Push `${_NUMBER}`
		Call LineRead
		Pop ${_RESULT}
	!macroend

!define GetJRE `!insertmacro GetJRECall`
 
	!macro GetJRECall _RESULT		
		Call GetJRE
		Pop ${_RESULT}
	!macroend

!define GetVMArgs `!insertmacro GetVMArgsCall`
 
	!macro GetVMArgsCall _RESULT		
		Call GetVMArgs
		Pop ${_RESULT}
	!macroend

!define Trim `!insertmacro TrimCall`
 
	!macro TrimCall _STRING _RESULT
		Push `${_STRING}`
		Call Trim
		Pop ${_RESULT}
	!macroend

!define IndexOf "!insertmacro IndexOf"

  !macro IndexOf Var Str Char
    Push "${Char}"
    Push "${Str}"
    Call IndexOf
    Pop "${Var}"
  !macroend
 
Section ""

  
  ${GetVMArgs} $0
  StrCpy $1 '$0 -jar ${JARFILE}'  ;var $1 contains everything after 'javaw'
  
  ; Just try to launch it normally... E.g javaw -jar jarfile
  Exec 'javaw $1'
  IfErrors 0 done
    
  ${GetJRE} $2
  Exec '$2 $1'
  IfErrors 0 done
  
  MessageBox MB_OK 'Cannot launch ${JARFILE}. Check that you have a correct version of Java installed.'
  
  done:    

SectionEnd
 
Function GetJRE
;
;  Find JRE (javaw.exe)
;  1 - in .\jre directory (JRE Installed with application)
;  2 - in JAVA_HOME environment variable
;  3 - in the registry
;  4 - assume javaw.exe in current dir or PATH
 
  Push $R0
  Push $R1
 
  ClearErrors
  StrCpy $R0 "$EXEDIR\jre\bin\javaw.exe"
  IfFileExists $R0 JreFound
  StrCpy $R0 ""
 
  ClearErrors
  ReadEnvStr $R0 "JAVA_HOME"
  StrCpy $R0 "$R0\bin\javaw.exe"
  IfErrors 0 JreFound
 
  ClearErrors
  ReadRegStr $R1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
  ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$R1" "JavaHome"
  StrCpy $R0 "$R0\bin\javaw.exe"
 
  IfErrors 0 JreFound
  StrCpy $R0 "javaw.exe"
        
 JreFound:
  Pop $R1
  Exch $R0
FunctionEnd


Function GetVMArgs

; This function gets extra VM arguments from the file specified in ARGFILE.

	Push $0 ;this is our result	
	StrCpy $R0 '' ;no args
	
	IfFileExists ${ARGFILE} 0 done
   
  StrCpy $2 1 ;start at line 1
  loop:
  
  ${LineRead} ${ARGFILE} $2 $R0
  IfErrors done   ; error reading the next line or EOF
  
  ${Trim} $R0 $R0  ;trim leading and trailing whitespace
  StrCmp $R0 '' commentOrBlank 
  
  ${IndexOf} $R1 $R0 '#' ;wasn't blank so check if it's a comment    
  IntCmp $R1 0 commentOrBlank done done 
  
  commentOrBlank:
  StrCpy $R0 '' 
  IntOp $2 $2 + 1  ;line was blank or a comment so keep looping
  goto loop
    
  done:  
  StrCpy $0 $R0  
  Exch $0

FunctionEnd

Function LineRead
	 
	Exch $1
	Exch
	Exch $0
	Exch
	Push $2
	Push $3
	Push $4
	ClearErrors
 
	IfFileExists $0 0 error
	IntOp $1 $1 + 0
	IntCmp $1 0 error 0 plus
	StrCpy $4 0
	FileOpen $2 $0 r
	IfErrors error
	FileRead $2 $3
	IfErrors +3
	IntOp $4 $4 + 1
	Goto -3
	FileClose $2
	IntOp $1 $4 + $1
	IntOp $1 $1 + 1
	IntCmp $1 0 error error
 
	plus:
	FileOpen $2 $0 r
	IfErrors error
	StrCpy $3 0
	IntOp $3 $3 + 1
	FileRead $2 $0
	IfErrors +4
	StrCmp $3 $1 0 -3
	FileClose $2
	goto end
	FileClose $2
 
	error:
	SetErrors
	StrCpy $0 ''
 
	end:
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Exch $0
FunctionEnd


Function Trim
	Exch $R1 ; Original string
	Push $R2
 
Loop:
	StrCpy $R2 "$R1" 1
	StrCmp "$R2" " " TrimLeft
	StrCmp "$R2" "$\r" TrimLeft
	StrCmp "$R2" "$\n" TrimLeft
	StrCmp "$R2" "$\t" TrimLeft
	GoTo Loop2
TrimLeft:	
	StrCpy $R1 "$R1" "" 1
	Goto Loop
 
Loop2:
	StrCpy $R2 "$R1" 1 -1
	StrCmp "$R2" " " TrimRight
	StrCmp "$R2" "$\r" TrimRight
	StrCmp "$R2" "$\n" TrimRight
	StrCmp "$R2" "$\t" TrimRight
	GoTo Done
TrimRight:	
	StrCpy $R1 "$R1" -1
	Goto Loop2
 
Done:
	Pop $R2
	Exch $R1
FunctionEnd


Function IndexOf
Exch $R0
Exch
Exch $R1
Push $R2
Push $R3
 
 StrCpy $R3 $R0
 StrCpy $R0 -1
 IntOp $R0 $R0 + 1
  StrCpy $R2 $R3 1 $R0
  StrCmp $R2 "" +2
  StrCmp $R2 $R1 +2 -3
 
 StrCpy $R0 -1
 
Pop $R3
Pop $R2
Pop $R1
Exch $R0
FunctionEnd
