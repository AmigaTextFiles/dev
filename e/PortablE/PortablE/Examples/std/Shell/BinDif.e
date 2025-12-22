/* BinDif.e 16-10-22 by Christopher Steven Handley.
*/
/*
	This program does a binary comparison of two files, or of all the files
	within two folders.  For folder comparisons, the first folder is the one
	scanned for files, such that files present in the second folder but not the
	first will be ignored.
	
	The Numeric switch makes the output easily usable by scripts.
	
	Folder comparisons has the option to Copy the identical/different files
	to other folders.
*/

MODULE 'std/cPath', 'std/pShellParameters', 'std/pShell'

PRIVATE
STATIC shellArgs = 'MainFileDir/A, OtherFileDir/A, Fast/S, OnlyOverlap/S, Numeric/S, ListBytes/S, ResumeFrom/K,  Copy/S, IdenticalFilesTo/K, DifferentMainFilesTo/K, DifferentOtherFilesTo/K'
->index:            0              1               2       3              4          5            6              7       8                   9                       10

CONST BUFSIZE = 512000
PUBLIC

PROC main() RETURNS ret
	DEF hostPath1:ARRAY OF CHAR, hostPath2:ARRAY OF CHAR, hostResumePath1:ARRAY OF CHAR, fast:BOOL, onlyOverlap:BOOL, numeric:BOOL, listBytes:BOOL
	DEF     path1:OWNS STRING,       path2:OWNS STRING,       resumePath1:OWNS STRING,   dif
	
	DEF copy:BOOL, hostIdenticalFilesTo:ARRAY OF CHAR, hostDifferentMainFilesTo:ARRAY OF CHAR, hostDifferentOtherFilesTo:ARRAY OF CHAR
	DEF                identicalFilesTo:OWNS STRING,       differentMainFilesTo:OWNS STRING,       differentOtherFilesTo:OWNS STRING
	
	ret := SHELL_RET_OK
	
	->parse parameters
	IF ParseParams(shellArgs) = FALSE THEN Raise("ARGS")
	hostPath1 := GetParam(0)
	hostPath2 := GetParam(1)
	fast      := GetParam(2) <> NILA
	onlyOverlap := GetParam(3) <> NILA
	numeric     := GetParam(4) <> NILA
	listBytes   := GetParam(5) <> NILA
	hostResumePath1 := GetParam(6)
	copy            := GetParam(7) <> NILA
	hostIdenticalFilesTo      := GetParam(8)
	hostDifferentMainFilesTo  := GetParam(9)
	hostDifferentOtherFilesTo := GetParam(10)
	
	->perform request
	path1 := ImportDirPath(hostPath1)
	path2 := ImportDirPath(hostPath2)
	
	IF ExistsPath(path1) AND ExistsPath(path2)
		->(paths were dirs)
		IF hostResumePath1
			resumePath1 := ImportDirPath(hostResumePath1)
			IF InvalidDirPath(resumePath1) THEN Throw("ARGS", 'Invalid path for ResumeFrom/K parameter')
			
			IF ExistsPath(resumePath1) = FALSE
				END resumePath1
				
				resumePath1 := ImportFilePath(hostResumePath1)
				IF InvalidFilePath(resumePath1) THEN Throw("ARGS", 'Invalid path for ResumeFrom/K parameter')
			ENDIF
		ENDIF
		
		IF (hostIdenticalFilesTo <> NILA) OR (hostDifferentMainFilesTo <> NILA) OR (hostDifferentOtherFilesTo <> NILA) XOR copy
			Throw("ARGS", 'The Copy/S parameter requires the IdenticalFilesTo/K or DifferentMainFilesTo/K or DifferentOtherFilesTo/K parameters, and vice versa')
		ENDIF
		
		IF hostIdenticalFilesTo      THEN      identicalFilesTo := ImportDirPath(hostIdenticalFilesTo)
		IF hostDifferentMainFilesTo  THEN  differentMainFilesTo := ImportDirPath(hostDifferentMainFilesTo)
		IF hostDifferentOtherFilesTo THEN differentOtherFilesTo := ImportDirPath(hostDifferentOtherFilesTo)
		
		IF      identicalFilesTo THEN IF InvalidDirPath(     identicalFilesTo) THEN Throw("ARGS", 'Invalid path for IdenticalFilesTo/K parameter')
		IF  differentMainFilesTo THEN IF InvalidDirPath( differentMainFilesTo) THEN Throw("ARGS", 'Invalid path for DifferentMainFilesTo/K parameter')
		IF differentOtherFilesTo THEN IF InvalidDirPath(differentOtherFilesTo) THEN Throw("ARGS", 'Invalid path for DifferentOtherFilesTo/K parameter')
		
		dif := binDifDir(path1, path2, onlyOverlap, fast, /*quiet=*/numeric, copy, listBytes, identicalFilesTo, differentMainFilesTo, differentOtherFilesTo, resumePath1)
		
		IF numeric
			Print('\d\n', dif)
			
		ELSE IF dif = 0
			Print('No different files found.\n')
		ELSE
			Print('Found \d different files.\n', dif)
		ENDIF
	ELSE
		END path1, path2
		path1 := ImportFilePath(hostPath1)
		path2 := ImportFilePath(hostPath2)
		
		IF ExistsPath(path1) AND ExistsPath(path2)
			->(paths were files)
			IF hostResumePath1           THEN Throw("ARGS",            'ResumeFrom/K parameter does not make sense for files')
			IF copy                      THEN Throw("ARGS",                  'Copy/S parameter does not make sense for files')
			IF hostIdenticalFilesTo      THEN Throw("ARGS",      'IdenticalFilesTo/K parameter does not make sense for files')
			IF hostDifferentMainFilesTo  THEN Throw("ARGS",  'DifferentMainFilesTo/K parameter does not make sense for files')
			IF hostDifferentOtherFilesTo THEN Throw("ARGS", 'DifferentOtherFilesTo/K parameter does not make sense for files')
			
			dif := binDifFile(path1, path2, onlyOverlap, fast, /*dirMode=*/FALSE, listBytes)
			
			IF numeric
				Print('\d\n', dif)
				
			ELSE IF dif = 0
				Print('No differences found.\n')
			ELSE
				Print('Found \d bytes difference.\n', dif)
			ENDIF
		ELSE
			IF ExistsPath(path1, TRUE) AND ExistsPath(path2, TRUE)
				Print('ERROR:  One FileDir was a file & one was a directory.\n')
			ELSE
				Print('ERROR:  One or both FileDirs did not exist.\n')
			ENDIF
			Raise("ERR")
		ENDIF
	ENDIF
	
	IF dif <> 0 THEN ret := SHELL_RET_WARN
FINALLY
	SELECT exception
	CASE 0
		->use existing "ret" value
	CASE "FILE"
		->(error already reported) so finish gracefully
		ret := SHELL_RET_ERROR
	CASE "ARGS"
		->(error already reported) so finish gracefully
		IF exceptionInfo THEN Print('ERROR:  \s\n', exceptionInfo)
		ret := SHELL_RET_ERROR
	CASE "ERR"
		->(error already reported) so finish gracefully
		ret := SHELL_RET_ERROR
	CASE "BRK"
		Print('User break\n')
		ret := SHELL_RET_ERROR
	CASE "MEM"
		Print('Ran out of memory\n')
		ret := SHELL_RET_FAIL
	DEFAULT
		PrintException()
		ret := SHELL_RET_FAIL
	ENDSELECT
	
	END path1, path2, resumePath1
	END identicalFilesTo, differentMainFilesTo, differentOtherFilesTo
ENDPROC


PRIVATE
DEF file1:OWNS PTR TO cHostFile, file2:OWNS PTR TO cHostFile
DEF buf1:ARRAY OF BYTE, buf2:ARRAY OF BYTE
PUBLIC

PROC new()
	NEW file1.new(), file2.new()
	NEW buf1[BUFSIZE], buf2[BUFSIZE]
ENDPROC

PROC end()
	END file1, file2
	END buf1, buf2
ENDPROC

PROC binDifFile(filePath1:ARRAY OF CHAR, filePath2:ARRAY OF CHAR, onlyOverlap:BOOL, fast:BOOL, dirMode:BOOL, listBytes:BOOL) RETURNS dif
	DEF length1:BIGVALUE, nextPos1:BIGVALUE, readLen1
	DEF length2:BIGVALUE, nextPos2:BIGVALUE, readLen2
	DEF index, minLen, oldPos:BIGVALUE
	DEF temp:OWNS STRING
	
	IF file1.open(filePath1, TRUE) = FALSE THEN errorFile(file1, filePath1, 'open')
	IF file2.open(filePath2, TRUE) = FALSE THEN errorFile(file2, filePath2, 'open')
	
	length1 := file1.getSize()
	length2 := file2.getSize()
	
	IF fast THEN IF (length1 = length2) AND (file1.getTime() = file2.getTime()) THEN RETURN 0
	
	dif := 0
	nextPos1 := nextPos2 := 0
	REPEAT
		readLen1 := bigMin(BUFSIZE, length1 - nextPos1) !!VALUE
		readLen2 := bigMin(BUFSIZE, length2 - nextPos2) !!VALUE
		
		oldPos := nextPos1
		minLen := Min(readLen1, readLen2)
		file1.setPosition(nextPos1 := file1.read(buf1, minLen))
		file2.setPosition(nextPos2 := file2.read(buf2, minLen))
		
		->compare buffers
		FOR index := 0 TO minLen-1
			IF buf1[index] <> buf2[index]
				dif++
				IF listBytes THEN Print('Byte \d was $\h[2] for main & $\h[2] for other.\n', index+oldPos!!VALUE,
					buf1[index] + IF buf1[index] < 0 THEN 256 ELSE 0,
					buf2[index] + IF buf2[index] < 0 THEN 256 ELSE 0)
			ENDIF
		ENDFOR
		
		IF CtrlC()
			IF dirMode THEN abortDir(temp := StrJoin(filePath1))
			Raise("BRK")
		ENDIF
	UNTIL (nextPos1 >= length1) OR (nextPos2 >= length2)
	
	IF onlyOverlap = FALSE THEN dif := dif + Abs(length1 - length2 !!VALUE)
FINALLY
	IF file1.infoIsOpen() THEN file1.close()
	IF file2.infoIsOpen() THEN file2.close()
	END temp
ENDPROC

PRIVATE
PROC bigMin(a:BIGVALUE, b:BIGVALUE) IS IF a < b THEN a ELSE b

PROC errorFile(file:PTR TO cHostFile, path:ARRAY OF CHAR, action:ARRAY OF CHAR)
	DEF hostPath:OWNS STRING
	
	hostPath := ExportPath(path)
	Print('ERROR:  Failed to \s the file "\s" because of \s in \s.\n', action, hostPath, file.infoFailureReason(), file.infoFailureOrigin())
	Raise("FILE")
FINALLY
	END hostPath
ENDPROC
PUBLIC


PROC binDifDir(dirPath1:ARRAY OF CHAR, dirPath2:ARRAY OF CHAR, onlyOverlap:BOOL, fast:BOOL, quiet:BOOL, copy:BOOL, listBytes:BOOL, identicalFilesTo:STRING, differentMainFilesTo:STRING, differentOtherFilesTo:STRING, resumePath1:STRING) RETURNS dif
	baseDirPathLen1 := StrLen(dirPath1)
	baseDirPathLen2 := StrLen(dirPath2)
	baseDirPath2 := dirPath2
	
	cmp_fast := fast
	cmp_quiet := quiet
	cmp_onlyOverlap := onlyOverlap
	cmp_listBytes := listBytes
	cmp_resumeFromPath1 := resumePath1
	cmp_copy                  := copy
	cmp_identicalFilesTo      := identicalFilesTo
	cmp_differentMainFilesTo  := differentMainFilesTo
	cmp_differentOtherFilesTo := differentOtherFilesTo
	
	RecurseDir(dirPath1, compareFile, NIL, NIL, abortDir)
	dif := diffFiles
ENDPROC

PRIVATE
DEF diffFiles=0, baseDirPathLen1, baseDirPathLen2, baseDirPath2:ARRAY OF CHAR, cmp_resumeFromPath1:STRING, cmp_fast:BOOL, cmp_quiet:BOOL, cmp_onlyOverlap:BOOL, cmp_listBytes:BOOL
DEF cmp_copy:BOOL, cmp_identicalFilesTo:STRING, cmp_differentMainFilesTo:STRING, cmp_differentOtherFilesTo:STRING
PUBLIC

FUNC compareFile(filePath1:STRING) OF funcRecurseFile
	DEF filePath2:OWNS STRING, dif
	DEF hostFilePath1:OWNS STRING, hostFilePath2:OWNS STRING
	
	IF cmp_resumeFromPath1 
		IF StrCmpPath(filePath1, cmp_resumeFromPath1, EstrLen(cmp_resumeFromPath1))
			->(reached the resume point)
			cmp_resumeFromPath1 := NILS
		ELSE
			RETURN
		ENDIF
	ENDIF
	
	NEW filePath2[EstrLen(filePath1) - baseDirPathLen1 + baseDirPathLen2]
	StrCopy(filePath2, baseDirPath2)
	StrAdd( filePath2, filePath1, ALL, baseDirPathLen1)
	
	IF ExistsPath(filePath2) = FALSE
		dif := -1
		diffFiles++
		
		IF cmp_quiet = FALSE
			hostFilePath2 := ExportPath(filePath2)
			Print('File "\s" does not exist!\n', hostFilePath2)
		ENDIF
		
	ELSE IF dif := binDifFile(filePath1, filePath2, cmp_onlyOverlap, cmp_fast, /*dirMode=*/TRUE, cmp_listBytes)
		diffFiles++
		
		IF cmp_quiet = FALSE
			hostFilePath1 := ExportPath(filePath1)
			hostFilePath2 := ExportPath(filePath2)
			Print('File "\s" was \d bytes different from "\s".\n', hostFilePath2, dif, hostFilePath1)
			->was: Print('Found \d bytes difference between file "\s" & "\s".\n', dif, hostFilePath1, hostFilePath2)
		ENDIF
	ENDIF
	
	IF dif = 0
		IF cmp_identicalFilesTo THEN relativeCopy(filePath1, 1, cmp_identicalFilesTo)
		
	ELSE IF dif <> 0
		IF cmp_differentMainFilesTo THEN relativeCopy(filePath1, 1, cmp_differentMainFilesTo)
		
		IF cmp_differentOtherFilesTo THEN IF dif <> -1 THEN relativeCopy(filePath2, 2, cmp_differentOtherFilesTo)
	ENDIF
FINALLY
	IF exception = "FILE"
		diffFiles++
		exception := 0
	ENDIF
	
	END filePath2
	END hostFilePath1, hostFilePath2
ENDFUNC


FUNC abortDir(nextPath:STRING) OF funcRecurseDirAbort
	DEF hostPath:OWNS STRING
	
	hostPath := ExportPath(IF cmp_resumeFromPath1 THEN cmp_resumeFromPath1 ELSE nextPath)	->if still resuming, then show the resume folder, since folders are scanned in a non-obvious order
	Print('Aborted while scanning \s "\s" (you can use this with the ResumeFrom/K parameter).\n', IF FastIsFile(nextPath) THEN 'file' ELSE 'directory', hostPath)
	Raise("BRK")
FINALLY
	END hostPath
ENDFUNC


PRIVATE

PROC relativeCopy(sourceFilePath:STRING, baseNumber, targetDirPath:STRING)
	DEF baseDirPathLen
	DEF sourceFile:OWNS PTR TO cFile, targetFile:OWNS PTR TO cFile, targetFilePath:OWNS STRING
	
	NEW sourceFile.new()
	
	baseDirPathLen := IF baseNumber = 1 THEN baseDirPathLen1 ELSE baseDirPathLen2
	NEW targetFilePath[EstrLen(sourceFilePath) - baseDirPathLen + EstrLen(targetDirPath)]
	StrCopy(targetFilePath, targetDirPath)
	StrAdd( targetFilePath, sourceFilePath, ALL, baseDirPathLen)
	
	CreateDirs(targetFilePath)
	IF sourceFile.open(sourceFilePath, TRUE)	->readOnly=TRUE
		targetFile := sourceFile.makeCopy(targetFilePath)
		IF targetFile
			targetFile.close()
		ELSE
			IF cmp_quiet = FALSE THEN Print('WARNING: Failed to copy file "\s" because of \s in \s.\n', sourceFilePath, sourceFile.infoFailureReason(), sourceFile.infoFailureOrigin())
		ENDIF
		sourceFile.close()
	ELSE
			IF cmp_quiet = FALSE THEN Print('WARNING: Failed to copy file "\s" because of \s in \s.\n', sourceFilePath, sourceFile.infoFailureReason(), sourceFile.infoFailureOrigin())
	ENDIF
FINALLY
	END sourceFile, targetFile, targetFilePath
ENDPROC

PUBLIC
