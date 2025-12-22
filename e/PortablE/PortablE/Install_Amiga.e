/* Install_Amiga.e
	Amiga version of the installer; used for AmigaOS3, AmigaOS4, AROS & MorphOS.
*/
MODULE 'libraries/asl'
MODULE 'CSH/pGeneral', 'CSH/pAmiga_requesters'
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
ENDPROC

PROC getFolder(request:ARRAY OF CHAR, defaultFolder=NILA:ARRAY OF CHAR) RETURNS folder:OWNS STRING REPLACEMENT
	DEF hostFolder:OWNS STRING, hostDefaultFolder:OWNS STRING
	
	->loop until answer folder exists, or user cancels
	hostDefaultFolder := ExportPath(defaultFolder)
	REPEAT
		IF hostFolder := requestFile(hostDefaultFolder, NILA, NILA, request, FRF_DRAWERSONLY OR FRF_DOSAVEMODE)
			->(user did not cancel) so check that folder exists
			folder := ImportDirPath(hostFolder) ; END hostFolder
			IF ExistsPath(folder) = FALSE
				IF getYesNoAnswer('The folder "\s" does not exist. Do you want to create it', [hostFolder]) = FALSE THEN END folder
			ENDIF
		ENDIF
	UNTIL (folder <> NILS) OR (hostFolder = NILS)
FINALLY
	END hostFolder, hostDefaultFolder
ENDPROC

PROC getYesNoAnswer(question:ARRAY OF CHAR, questionParams=NILL:ILIST) RETURNS yes:BOOL REPLACEMENT
	DEF fullQ:OWNS STRING
	
	fullQ := StrJoin(question, '?')
	
	yes := (requestChoice('PortablE\'s installer', fullQ, 'Yes|No', questionParams) <> 0)
FINALLY
	END fullQ
ENDPROC

PROC showInfo(info:ARRAY OF CHAR, infoParams=NILL:ILIST) REPLACEMENT
	requestChoice('PortablE\'s installer', info, 'OK', infoParams)
ENDPROC
