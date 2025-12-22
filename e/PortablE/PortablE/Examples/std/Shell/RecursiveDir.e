/* RecursiveDir.e 06-06-2020 by Christopher Steven Handley.
*/
/*
	This program recursively scan the (current/specified) dir, and displays the relative path of every file.
*/

MODULE 'std/pShellParameters', 'std/pShell', 'std/cPath'

/* Shell arguments definition */
STATIC shellArgs = 'Folder, Prepend, Append, NoQuotes/S, ShowDirs=Dirs/S, NoFiles/S'
->index:            0       1        2       3           4                5

PROC main() RETURNS ret
	DEF hostFolder:ARRAY OF CHAR, noQuotes:BOOL, showDirs:BOOL, noFiles:BOOL
	
	->parse parameters
	IF ParseParams(shellArgs) = FALSE THEN Raise("ARGS")
	hostFolder := GetParam(0)
	prepend    := GetParam(1)
	append     := GetParam(2)
	noQuotes   := GetParam(3) <> NILA
	showDirs   := GetParam(4) <> NILA
	noFiles    := GetParam(5) <> NILA
	
	IF hostFolder = NILA THEN hostFolder := ''
	IF prepend    = NILA THEN prepend    := ''
	IF append     = NILA THEN append     := ''
	quotes := IF noQuotes THEN '' ELSE '"'
	
	->perform request
	folder := IF StrLen(hostFolder) > 0 THEN ImportDirPath(hostFolder) ELSE CurrentDirPath()
	RecurseDir(folder, IF noFiles THEN /*dummy*/ funcRecurseFile ELSE funcRelPath, IF showDirs THEN funcRelPath ELSE NIL)
FINALLY
	SELECT exception
	CASE 0
		ret := SHELL_RET_OK
	CASE "ARGS"
		->(error already reported) so finish gracefully
		IF exceptionInfo THEN Print('ERROR:  \s\n', exceptionInfo)
		ret := SHELL_RET_ERROR
	CASE "BRK"
		Print('User break\n')
		ret := SHELL_RET_ERROR
	CASE "MEM"
		Print('ERROR:  Ran out of memory\n')
		ret := SHELL_RET_FAIL
	DEFAULT
		PrintException()
		ret := SHELL_RET_FAIL
	ENDSELECT
	
	END folder
ENDPROC

PRIVATE
DEF folder:OWNS STRING, prepend:ARRAY OF CHAR, append:ARRAY OF CHAR, quotes:ARRAY OF CHAR
PUBLIC

FUNC funcRelPath(filePath:STRING) OF funcRecurseDir RETURNS scanDir:BOOL
	DEF relFilePath:OWNS STRING, hostPath:OWNS STRING
	
	NEW relFilePath[EstrLen(filePath) - EstrLen(folder) + 1]
	StrCopy(relFilePath, filePath, ALL, EstrLen(folder))
	IF IsDir(filePath) THEN StrAdd(relFilePath, '/')
	
	Print('\s\s\s\s\s\n', prepend, quotes, hostPath := ExportPath(relFilePath), quotes, append) ; END hostPath
	
	scanDir := TRUE
FINALLY
	END relFilePath, hostPath
ENDFUNC

