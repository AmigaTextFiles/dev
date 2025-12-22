/* Install_WindowsLinux.e
	Windows & Linux version of the installer.
*/
MODULE 'CSH/pGeneral'
MODULE 'std/cPath', 'std/pShell'
MODULE '*Install_shared'

PROC main() RETURNS ret
	install()
FINALLY
	SELECT exception
	CASE 0
		ret := SHELL_RET_OK
	CASE "BRK"
		Print('Cancelled by user\n') 
		ret := SHELL_RET_WARN
	CASE "ERR"
		IF exceptionInfo THEN PrintException()
		ret := SHELL_RET_ERROR
	CASE "MEM"
		Print('Ran out of memory\n')
		ret := SHELL_RET_FAIL
	DEFAULT
		PrintException()
		ret := SHELL_RET_FAIL
	ENDSELECT
	
	Print('\n(press the Enter key to finish)')
	PrintFlush()
	waitForEnter()
ENDPROC

PROC getFolder(request:ARRAY OF CHAR, defaultFolder=NILA:ARRAY OF CHAR) RETURNS folder:OWNS STRING REPLACEMENT
	DEF input:STRING, cancel:BOOL
	NEW input[BUFSIZE]
	
	defaultFolder := NILA
	
	->loop until answer folder exists, or user cancels
	REPEAT
		->loop until get a non-empty answer or the user cancels
		cancel := FALSE
		REPEAT
			Print('\s ', request)
			ReadStr(stdin, input)
			SetStr(input, Max(0, EstrLen(input) - 1))	->strip LF
			
			IF EstrLen(input) = 0 THEN cancel := getYesNoAnswer('Do you want to cancel')
		UNTIL (EstrLen(input) > 0) OR cancel
		
		->check that folder exists
		IF cancel = FALSE
			folder := ImportDirPath(input)
			IF ExistsPath(folder) = FALSE
				IF getYesNoAnswer('This folder does not exist. Do you want to create it') = FALSE THEN END folder
			ENDIF
		ENDIF
	UNTIL (folder <> NILS) OR cancel
FINALLY
	END input
ENDPROC

PROC getYesNoAnswer(question:ARRAY OF CHAR, questionParams=NILL:ILIST) RETURNS yes:BOOL REPLACEMENT
	DEF fullQ:OWNS STRING
	
	fullQ := StrJoin('\n', question, ' [Y/N]? ')
	
	yes := (getAnswer(fullQ, 'YN', questionParams) = "Y")
FINALLY
	END fullQ
ENDPROC

PROC showInfo(info:ARRAY OF CHAR, infoParams=NILL:ILIST) REPLACEMENT
	PrintL(info, infoParams)
	Print('\n(press Enter to continue)\n')
	waitForEnter()
ENDPROC
