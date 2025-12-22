/* DeleteModuleCache.e 16.10.2022 by Christopher Steven Handley.
*/
/*
	This program recursively deletes all .PEM (module cache) files.
*/

MODULE 'std/pShellParameters', 'std/pShell', 'std/cPath'

PRIVATE
/* Shell arguments definition */
STATIC shellArgs = 'Folder, Verbose/S'
->index:            0       1
PUBLIC

PROC main() RETURNS ret
	DEF hostFolder:ARRAY OF CHAR, folder:OWNS STRING, temp:OWNS STRING, verbose:BOOL
	
	->parse parameters
	IF ParseParams(shellArgs) = FALSE THEN Raise("ARGS")
	hostFolder := GetParam(0)
	verbose    := GetParam(1) <> NILA
	
	IF hostFolder = NILA THEN hostFolder := 'PEmodules:'
	
	->perform request
	temp := ImportDirPath(hostFolder)
	folder := ExpandPath(temp) ; END temp
	DeleteModuleCache(folder, verbose)
	
	Print('Finished deleting module cache files.\n')
FINALLY
	SELECT exception
	CASE 0
		ret := 0
	CASE "ARGS"
		->(error already reported) so finish gracefully
		IF exceptionInfo THEN Print('ERROR:  \s\n', exceptionInfo)
		ret := 10
	CASE "BRK"
		Print('User break\n')
		ret := 10
	CASE "MEM"
		Print('ERROR:  Ran out of memory\n')
		ret := 20
	DEFAULT
		PrintException()
		ret := 20
	ENDSELECT
	
	END folder, temp
ENDPROC

PROC DeleteModuleCache(folder:STRING, verbose:BOOL)
	DEF shrunkPath:OWNS STRING, pemodulesPath:OWNS STRING, pemodules:ARRAY OF CHAR
	DEF cacheFolder:OWNS STRING, cacheBasePath:ARRAY OF CHAR, pos
	
	cacheBasePath := 'PEmodules:/PE/cache/'
	
	->UNexpand any 'PEmodules:/' part of path
	pemodules := 'PEmodules:/'
	pemodulesPath := ExpandPath(pemodules)
	IF StrCmpPath(folder, pemodulesPath, EstrLen(pemodulesPath))
		NEW shrunkPath[StrLen(pemodules) + EstrLen(folder) - EstrLen(pemodulesPath)]
		StrCopy(shrunkPath, pemodules)
		StrAdd( shrunkPath, folder, ALL, EstrLen(pemodulesPath))
		folder := shrunkPath
	ENDIF
	
	->convert folder path to cach path
	pos := InStr(folder, ':')
	IF pos = -1 THEN Throw("BUG", 'DeleteModuleCache(); no ":" in expanded path')
	NEW cacheFolder[StrLen(cacheBasePath) + EstrLen(folder)]
	StrCopy(cacheFolder, cacheBasePath)
	StrAdd( cacheFolder, folder, pos)
	StrAdd( cacheFolder, folder, ALL, pos+1)
	
	->delete cache files
	verboseDelete := verbose
	RecurseDir(   cacheFolder, funcDeleteAll)	->delete files
	DeleteDirPath(cacheFolder)					->delete folders
	
	IF StrCmpPath(pemodulesPath, folder, EstrLen(folder)) AND (EstrLen(folder) < EstrLen(pemodulesPath))
		->(folder contains PEmodules: (but folder not PEmodules) so delete PEmodules cache too)
		END cacheFolder
		cacheFolder := StrJoin(cacheBasePath, 'PEmodules/')
		RecurseDir(   cacheFolder, funcDeleteAll)	->delete files
		DeleteDirPath(cacheFolder)					->delete folders
	ENDIF
	
	->delete old-style cache files (this will be removed eventually)
	verboseDelete := verbose
	RecurseDir(folder, funcDeletePEM)	->was: Print('# NOT deleting old-style cache.\n')
FINALLY
	END shrunkPath, pemodulesPath
	END cacheFolder
ENDPROC

PRIVATE
DEF verboseDelete:BOOL
PUBLIC

FUNC funcDeletePEM(filePath:STRING) OF funcRecurseFile
	DEF hostPath:OWNS STRING
	
	IF StrCmpPath('.pem', filePath, ALL, 0, EstrLen(filePath) - STRLEN)
		->(file ends in .pem) so delete it
		IF DeletePath(filePath) AND verboseDelete
			Print('Deleted "\s"\n', hostPath := ExportPath(filePath)) ; END hostPath
		ENDIF
	ENDIF
FINALLY
	END hostPath
ENDFUNC

FUNC funcDeleteAll(filePath:STRING) OF funcRecurseFile
	DEF hostPath:OWNS STRING
	
	IF DeletePath(filePath) AND verboseDelete
		Print('Deleted "\s"\n', hostPath := ExportPath(filePath)) ; END hostPath
	ENDIF
FINALLY
	END hostPath
ENDFUNC
