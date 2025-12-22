/* pAmigaDos.e 02-09-2016
	A collection of useful procedures/wrappers for the AmigaDOS library..
	Copyright (c) 2009, 2010, 2011, 2012, 2013, 2015, 2016 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
/* Public procedures:
getFilePosition64(handle:BPTR) RETURNS position:BIGVALUE
setFilePosition64(handle:BPTR, position:BIGVALUE, mode=OFFSET_BEGINNING) RETURNS success:BOOL
getFileSize64(handle:BPTR, trashPosition=FALSE:BOOL) RETURNS size:BIGVALUE
setFileSize64(handle:BPTR, size:BIGVALUE) RETURNS success:BOOL
searchCmdPathList(path:PTR TO pathnode, hook:PTR TO hook, name:ARRAY OF CHAR) RETURNS found

strGetProgramName(     estring:STRING) RETURNS success:BOOL
strGetNameOfCurrentDir(estring:STRING) RETURNS success:BOOL
strGetVar(varName:ARRAY OF CHAR, estring:STRING, flags=0) RETURNS success:BOOL
strSetVar(varName:ARRAY OF CHAR, estring:STRING, flags=0) RETURNS success:BOOL
strNameFromLock(estring:STRING,   lock:BPTR) RETURNS success:BOOL
strNameFromFH(  estring:STRING, handle:BPTR) RETURNS success:BOOL
strDevNameFromLock(estring:STRING,   lock:BPTR, mode) RETURNS success:BOOL
strDevNameFromFH(  estring:STRING, handle:BPTR, mode) RETURNS success:BOOL
strAddPart(dir:STRING, relFile:ARRAY OF CHAR) RETURNS success:BOOL
strFault(code, header:NULL ARRAY OF CHAR /*STRPTR*/, buffer:STRING) RETURNS len

strSafeGetProgramName() RETURNS path:OWNS STRING
strSafeGetNameOfCurrentDir() RETURNS path:OWNS STRING
strSafeGetVar(varName:ARRAY OF CHAR, flags=0) RETURNS variable:OWNS STRING
strSafeNameFromLock(lock:BPTR) RETURNS path:OWNS STRING
strSafeNameFromFH(handle:BPTR) RETURNS path:OWNS STRING
strSafeDevNameFromLock(lock:BPTR, mode) RETURNS path:OWNS STRING
strSafeDevNameFromFH(handle:BPTR, mode) RETURNS path:OWNS STRING

strJoinPart(dir:ARRAY OF CHAR, relFile:ARRAY OF CHAR, stripFilePart=FALSE:BOOL) RETURNS path:OWNS STRING
strSubPathPart(path:ARRAY OF CHAR) RETURNS subPath:OWNS STRING
strSubFilePart(path:ARRAY OF CHAR) RETURNS filePart:OWNS STRING

fullPath(dirLock:BPTR, name:ARRAY OF CHAR) RETURNS path:OWNS STRING
pathOfWbArg(wbarg:PTR TO wbarg) RETURNS path:OWNS STRING
splitPath(filePath:ARRAY OF CHAR) RETURNS fileName:OWNS STRING, fileDir:OWNS STRING
expandPath(path:ARRAY OF CHAR, doNotFollowLinks=FALSE:BOOL) RETURNS fullPath:OWNS STRING
expandPathForCreation(path:ARRAY OF CHAR) RETURNS fullPath:OWNS STRING

fileDirType(path:ARRAY OF CHAR, needToKnowAboutLinks=FALSE:BOOL, returnExists=NILA:ARRAY OF BOOL) RETURNS dirEntryType, exists:BOOL
fileDirTypeOfLock(lock:BPTR, path=NILA:ARRAY OF CHAR, needToKnowAboutLinks=FALSE:BOOL) RETURNS dirEntryType
dirEntryTypeIsFile(dirEntryType, path:ARRAY OF CHAR) RETURNS isFile:BOOL
dirEntryTypeIsLink(dirEntryType) RETURNS isLink:BOOL
exists(path:ARRAY OF CHAR, only1file2dir4device=0) RETURNS exists:BOOL
deviceExists(path:ARRAY OF CHAR) RETURNS exists:BOOL
commandExists(command:ARRAY OF CHAR) RETURNS exists:BOOL
isFile(path:ARRAY OF CHAR) RETURNS isFile:BOOL
isDir( path:ARRAY OF CHAR) RETURNS isDir:BOOL
isLink(path:ARRAY OF CHAR) RETURNS isLink:BOOL

fileSize(path:ARRAY OF CHAR, linkSizeIsZero=FALSE:BOOL) RETURNS sizeInBytes:BIGVALUE
fileSizeFromFH(handle:BPTR, preservePosition=FALSE:BOOL, linkSizeIsZero=FALSE:BOOL) RETURNS sizeInBytes:BIGVALUE
getComment(path:ARRAY OF CHAR) RETURNS comment:OWNS STRING
createDirTree(path:ARRAY OF CHAR, ignoreFinalName=FALSE:BOOL) RETURNS success:BOOL
staticFault(code, header=NILA:ARRAY OF CHAR /*STRPTR*/) RETURNS buffer:STRING
processNameOfTask(task:PTR TO tc) RETURNS name:OWNS STRING

copyFile(from:ARRAY OF CHAR, to:ARRAY OF CHAR, allowReplace=FALSE:BOOL) RETURNS success:BOOL
asyncDosRead( file:BPTR, buffer:ARRAY, bufSize, port:PTR TO mp) RETURNS success:BOOL
asyncDosWrite(file:BPTR, buffer:ARRAY, bufSize, port:PTR TO mp) RETURNS success:BOOL
asyncDosWait(port:PTR TO mp) RETURNS result

easyMakeLink(path:ARRAY OF CHAR, linkPath:ARRAY OF CHAR, linkIsSoftNotHard:BOOL) RETURNS success:BOOL
easyReadLink(path:ARRAY OF CHAR, returnLinkIs0unknown1none2soft3hard=NILA:ARRAY OF VALUE, doNotReturnLinkType=FALSE:BOOL) RETURNS linkPath:OWNS STRING, linkIs0unknown1none2soft3hard
examineAll(filePath:ARRAY OF CHAR, fib:PTR TO fileinfoblock) RETURNS success:BOOL

bcplToString(bcplString:BSTR) RETURNS string:OWNS STRING
stringToBcpl(string:ARRAY OF CHAR, len=-1) RETURNS bcplString:BSTR, buffer:OWNS STRING

executeCommand(command:ARRAY OF CHAR, silent=FALSE:BOOL, async=FALSE:BOOL, stackSize=0, taskPri=0, currentDir=NIL:BPTR, tagList=NILA:ARRAY OF tagitem) RETURNS success:BOOL, returnCode
*/
OPT PREPROCESS
OPT INLINE, POINTER
PUBLIC MODULE 'dos'
MODULE 'exec', 'utility', 'workbench/startup', 'tools/installhook'
MODULE 'wb'	->Needed for AROS for "wbmessage"

/*****************************/

->NOTE: Returns -1 for an error.
#ifdef pe_TargetOS_AmigaOS4
	PROC getFilePosition64(handle:BPTR) RETURNS position:BIGVALUE IS GetFilePosition(handle)
#else
	PROC getFilePosition64(handle:BPTR) RETURNS position:BIGVALUE
		position := Seek(handle, 0, OFFSET_CURRENT)
		IF position = -1 THEN IF IoErr() <> 0 THEN RETURN	->really was an error
		IF position < 0 THEN position := $40000000!!BIGVALUE * 4 + position	->if at 4GB-1 = $FFFFFFFF = -1 as a signed 32-bit value, then we return ($40000000*4 = $100000000) + -1 = $FFFFFFFF = 4GB-1
	ENDPROC
#endif

PRIVATE
CONST  LARGEST_LONG = $7FFFFFFF		-> 2147483647
CONST SMALLEST_LONG = $80000000		->-2147483648
PUBLIC

#ifdef pe_TargetOS_AmigaOS4
	PROC setFilePosition64(handle:BPTR, position:BIGVALUE, mode=OFFSET_BEGINNING) RETURNS success:BOOL IS ChangeFilePosition(handle, position, mode) <> 0
#else
	PROC setFilePosition64(handle:BPTR, position:BIGVALUE, mode=OFFSET_BEGINNING) RETURNS success:BOOL
		DEF chunk
		
		IF (position <= LARGEST_LONG) AND (position >= SMALLEST_LONG)
			success := IF Seek(handle, position!!VALUE, mode) <> -1 THEN TRUE ELSE (IoErr() = 0)	->IoErr() handles the case where we seeked to position 4GB-1 = $FFFFFFFF, which is -1 as a signed 32-bit value
		ELSE
			->(beyond 2GB barrier) so break-down into smaller 2GB steps
			success := TRUE
			IF mode <> OFFSET_CURRENT THEN Seek(handle, 0, mode)
			WHILE position <> 0
				chunk := IF position > LARGEST_LONG THEN LARGEST_LONG ELSE IF position < SMALLEST_LONG THEN SMALLEST_LONG ELSE position!!VALUE
				IF Seek(handle, chunk, OFFSET_CURRENT) = -1 THEN IF IoErr() <> 0 THEN success := FALSE
				position := position - chunk
			ENDWHILE IF success = FALSE
		ENDIF
	ENDPROC
#endif

->NOTE: Returns -1 for an error.
#ifdef pe_TargetOS_AmigaOS4
	PROC getFileSize64(handle:BPTR, trashPosition=FALSE:BOOL) RETURNS size:BIGVALUE
		DEF oldPos:BIGVALUE
		
		size := GetFileSize(handle)
		IF size = -1
			IF trashPosition = FALSE THEN oldPos := getFilePosition64(handle)
			IF setFilePosition64(handle, 0, OFFSET_END) THEN size := getFilePosition64(handle)
			IF trashPosition = FALSE THEN setFilePosition64(handle, oldPos)
		ENDIF
	ENDPROC
	->was: PROC getFileSize64(handle:BPTR, trashPosition=FALSE:BOOL) RETURNS size:BIGVALUE IS trashPosition BUT GetFileSize(handle)
#else
	PROC getFileSize64(handle:BPTR, trashPosition=FALSE:BOOL) RETURNS size:BIGVALUE
		DEF fib:PTR TO fileinfoblock, origPos:BIGVALUE
		
		size := -1
		IF fib := AllocDosObject(DOS_FIB, NILA)
			IF ExamineFH(handle, fib)
				size := fib.size
				IF size < 0 THEN size := $40000000!!BIGVALUE * 4 + size		->see getFilePosition64() for more info
			ENDIF
		ENDIF
		
		IF size = -1
			IF trashPosition = FALSE THEN origPos := getFilePosition64(handle)
			
			IF Seek(handle, 0, OFFSET_END) <> -1
				size := getFilePosition64(handle)
				
			ELSE IF IoErr() = 0
				size := getFilePosition64(handle)
			ELSE
				->(really was an error)
				size := -1
			ENDIF
			
			IF trashPosition = FALSE THEN setFilePosition64(handle, origPos)
		ENDIF
	FINALLY
		IF fib THEN FreeDosObject(DOS_FIB, fib)
	ENDPROC
#endif

#ifdef pe_TargetOS_AmigaOS4
	PROC setFileSize64(handle:BPTR, size:BIGVALUE) RETURNS success:BOOL IS ChangeFileSize(handle, size, OFFSET_BEGINNING) <> 0
#else
	PROC setFileSize64(handle:BPTR, size:BIGVALUE) RETURNS success:BOOL
		IF size > LARGEST_LONG THEN RETURN FALSE
		success := SetFileSize(handle, size!!VALUE, OFFSET_BEGINNING) = size
	ENDPROC
#endif

#ifdef pe_TargetOS_AmigaOS4
PROC searchCmdPathList(path:PTR TO pathnode, hook:PTR TO hook, name:ARRAY OF CHAR /*, tags=NILA:ARRAY OF tagitem*/) RETURNS found IS SearchCmdPathList(path, hook, name, [TAG_END]:tagitem)
#else
PROC searchCmdPathList(path:PTR TO pathnode, hook:PTR TO hook, name:ARRAY OF CHAR /*, tags=NILA:ARRAY OF tagitem*/) RETURNS found
	DEF message:searchcmdpathlistmsg, node:PTR TO pathnode, devProc:PTR TO devproc, oldFSPort:PTR TO mp, oldCD:BPTR
	
	->optimisation to reduce the number of calls to SetFileSysTask() & CurrentDir() (and avoid the need for storing their return values)
	oldCD     := getCurrentDir()
	oldFSPort := GetFileSysTask()
	
	->prepare "message"
	message.size := SIZEOF searchcmdpathlistmsg
	message.name := name
	->message.lock
	
	->check current directory
	message.lock := oldCD ; found := CallHookPkt(hook, /*reserved*/ NIL, message)
	IF found THEN RETURN
	
	->check command path
	node := path
	WHILE node
		CurrentDir(     node.lock)
		message.lock := node.lock ; found := CallHookPkt(hook, /*reserved*/ NIL, message)
		
		node := Baddr(node.next)
	ENDWHILE IF found
	IF found THEN RETURN
	
	->check C: (which is not part of the path list, and) which may be a multi-assign
	WHILE devProc := GetDeviceProc('C:', devProc)
		SetFileSysTask( devProc.port)	->this should be done for any use of "devProc.lock", and *must* be done if the lock is NIL (which it will be for absolute paths)
		CurrentDir(     devProc.lock)
		message.lock := devProc.lock ; found := CallHookPkt(hook, /*reserved*/ NIL, message)
	ENDWHILE IF found OR (devProc.flags AND DVPB_ASSIGN = 0)
FINALLY
	CurrentDir(    oldCD)
	SetFileSysTask(oldFSPort)
	IF devProc THEN FreeDeviceProc(devProc)
ENDPROC

->The message passed to the hook invoked by the SearchCmdPathList() function.
OBJECT searchcmdpathlistmsg
    size	:VALUE
    lock	:BPTR
    name	:ARRAY OF CHAR /*STRPTR*/
ENDOBJECT

PRIVATE
OBJECT pathnode
    next	:BPTR    /* Pointer to next path node */
    lock	:BPTR    /* Directory lock */
ENDOBJECT

PROC getCurrentDir() RETURNS lock:BPTR
	DEF process:PTR TO process
	process := FindTask(NILA) !!PTR
	lock := DupLock(process.currentdir)
ENDPROC
PUBLIC

PROC new()
	utilitybase := OpenLibrary('utility.library', 39)
	IF utilitybase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(utilitybase)
	END faultBuffer
ENDPROC
#endif

/*****************************/

PROC strGetProgramName(estring:STRING) RETURNS success:BOOL
	IF success := GetProgramName(estring, StrMax(estring)) THEN SetStr(estring, StrLen(estring))
ENDPROC

PROC strGetNameOfCurrentDir(estring:STRING) RETURNS success:BOOL
	DEF process:PTR TO process, lock:BPTR
	
	process := FindTask(NILA) !!PTR
	lock    := IF process.currentdir THEN process.currentdir ELSE process.homedir	->WB progs *supposedly* have no currentdir, so must use their PROGDIR: in that case; or we could just have used lock := GetCurrentDir() if we were only targetting AmigaOS4.1
	success := strNameFromLock(estring, lock)
ENDPROC

PROC strGetVar(varName:ARRAY OF CHAR, estring:STRING, flags=0) RETURNS success:BOOL
	DEF len
	len := GetVar(varName, estring, StrMax(estring), flags)
	IF success := len <> - 1 THEN SetStr(estring, len)
ENDPROC

PROC strSetVar(varName:ARRAY OF CHAR, estring:STRING, flags=0) RETURNS success:BOOL
	success := SetVar(varName, estring, StrLen(estring), flags) <> 0
ENDPROC

PROC strNameFromLock(estring:STRING, lock:BPTR) RETURNS success:BOOL
	IF success := NameFromLock(lock, estring, StrMax(estring)) THEN SetStr(estring, StrLen(estring))
ENDPROC

PROC strNameFromFH(estring:STRING, handle:BPTR) RETURNS success:BOOL
	IF success := NameFromFH(handle, estring, StrMax(estring)) THEN SetStr(estring, StrLen(estring))
ENDPROC

#ifdef pe_TargetOS_AmigaOS4
PROC strDevNameFromLock(estring:STRING, lock:BPTR, mode) RETURNS success:BOOL
	IF success := DevNameFromLock(lock, estring, StrMax(estring), mode) THEN SetStr(estring, StrLen(estring))
ENDPROC

PROC strDevNameFromFH(estring:STRING, handle:BPTR, mode) RETURNS success:BOOL
	IF success := DevNameFromFH(handle, estring, StrMax(estring), mode) THEN SetStr(estring, StrLen(estring))
ENDPROC
#endif

PROC strAddPart(dir:STRING, relFile:ARRAY OF CHAR) RETURNS success:BOOL
	IF success := AddPart(dir, relFile, StrMax(dir) + 1) <> 0 THEN SetStr(dir, StrLen(dir))
ENDPROC

PROC strFault(code, header:NULL ARRAY OF CHAR /*STRPTR*/, buffer:STRING) RETURNS len
	len := Fault(code, header, buffer, StrMax(buffer))
	SetStr(buffer, len)
ENDPROC

/*****************************/

->always allocates an e-string which is large enough for strGetProgramName()
->NOTE: It will return NILS in the event of an error.
PROC strSafeGetProgramName() RETURNS path:OWNS STRING
	DEF len, success:BOOL, bigEnough:BOOL, notCLI:BOOL
	
	len := 128
	REPEAT
		END path
		NEW path[len]
		success := strGetProgramName(path)
		bigEnough := IF success THEN EstrLen(path) < len ELSE TRUE
		notCLI := IF success = FALSE THEN (IoErr() = ERROR_OBJECT_WRONG_TYPE) ELSE FALSE
		
		len := len * 2
	UNTIL success AND bigEnough OR notCLI
	
	IF success = FALSE
		END path
		IF NOT bigEnough AND NOT notCLI THEN SetIoErr(ERROR_LINE_TOO_LONG)
	ENDIF
FINALLY
	IF exception THEN END path
ENDPROC

->always allocates an e-string which is large enough for strGetNameOfCurrentDir()
->NOTE: It will return NILS in the event of an error.
PROC strSafeGetNameOfCurrentDir() RETURNS path:OWNS STRING
	DEF len, success:BOOL, bigEnough:BOOL, notCLI:BOOL
	
	len := 128
	REPEAT
		END path
		NEW path[len]
		success := strGetNameOfCurrentDir(path)
		bigEnough := IF success THEN EstrLen(path) < len ELSE TRUE
		notCLI := IF success = FALSE THEN (IoErr() = ERROR_OBJECT_WRONG_TYPE) ELSE FALSE
		
		len := len * 2
	UNTIL success AND bigEnough OR notCLI
	
	IF success = FALSE
		END path
		IF NOT bigEnough AND NOT notCLI THEN SetIoErr(ERROR_LINE_TOO_LONG)
	ENDIF
FINALLY
	IF exception THEN END path
ENDPROC

->always allocates an e-string which is large enough for strGetVar()
->NOTE: It will return NILS in the event of an error.
PROC strSafeGetVar(varName:ARRAY OF CHAR, flags=0) RETURNS variable:OWNS STRING
	DEF len, success:BOOL, bigEnough:BOOL
	
	len := 128
	REPEAT
		END variable
		NEW variable[len]
		success := strGetVar(varName, variable, flags)
		bigEnough := IF success THEN EstrLen(variable) < len ELSE TRUE
		
		len := len * 2
	UNTIL success OR bigEnough
	
	IF success = FALSE THEN END variable
FINALLY
	IF exception THEN END variable
ENDPROC

->always allocates an e-string which is large enough for strNameFromLock()
->NOTE: It will return NILS in the event of an error.
PROC strSafeNameFromLock(lock:BPTR) RETURNS path:OWNS STRING
	DEF len, success:BOOL, bigEnough:BOOL
	
	len := 128
	REPEAT
		END path
		NEW path[len]
		success := strNameFromLock(path, lock)
		bigEnough := IF success THEN TRUE ELSE IoErr() <> ERROR_LINE_TOO_LONG
		
		len := len * 2
	UNTIL success OR bigEnough
	
	IF success = FALSE THEN END path
FINALLY
	IF exception THEN END path
ENDPROC

->always allocates an e-string which is large enough for strNameFromFH()
->NOTE: It will return NILS in the event of an error.
PROC strSafeNameFromFH(handle:BPTR) RETURNS path:OWNS STRING
	DEF len, success:BOOL, bigEnough:BOOL
	
	len := 128
	REPEAT
		END path
		NEW path[len]
		success := strNameFromFH(path, handle)
		bigEnough := IF success THEN TRUE ELSE IoErr() <> ERROR_LINE_TOO_LONG
		
		len := len * 2
	UNTIL success OR bigEnough
	
	IF success = FALSE THEN END path
FINALLY
	IF exception THEN END path
ENDPROC

#ifdef pe_TargetOS_AmigaOS4
->always allocates an e-string which is large enough for strDevNameFromLock()
->NOTE: It will return NILS in the event of an error.
PROC strSafeDevNameFromLock(lock:BPTR, mode) RETURNS path:OWNS STRING
	DEF len, success:BOOL, bigEnough:BOOL
	
	len := 128
	REPEAT
		END path
		NEW path[len]
		success := strDevNameFromLock(path, lock, mode)
		bigEnough := IF success THEN TRUE ELSE IoErr() <> ERROR_LINE_TOO_LONG
		
		len := len * 2
	UNTIL success OR bigEnough
	
	IF success = FALSE THEN END path
FINALLY
	IF exception THEN END path
ENDPROC

->always allocates an e-string which is large enough for strDevNameFromFH()
->NOTE: It will return NILS in the event of an error.
PROC strSafeDevNameFromFH(handle:BPTR, mode) RETURNS path:OWNS STRING
	DEF len, success:BOOL, bigEnough:BOOL
	
	len := 128
	REPEAT
		END path
		NEW path[len]
		success := strDevNameFromFH(path, handle, mode)
		bigEnough := IF success THEN TRUE ELSE IoErr() <> ERROR_LINE_TOO_LONG
		
		len := len * 2
	UNTIL success OR bigEnough
	
	IF success = FALSE THEN END path
FINALLY
	IF exception THEN END path
ENDPROC
#endif

/*****************************/

->equivalent of strSafeAddPart()
->always allocates an e-string which is large enough for strAddPart()
PROC strJoinPart(dir:ARRAY OF CHAR, relFile:ARRAY OF CHAR, stripFilePart=FALSE:BOOL) RETURNS path:OWNS STRING
	NEW path[StrLen(dir) + 2 + StrLen(relFile)]
	StrCopy(path, dir, IF stripFilePart THEN PathPart(dir) - dir ELSE ALL)
	IF strAddPart(path, relFile) = FALSE THEN Throw("BUG", 'pAmigaDos; strJoinPart(); the allocated string was too small')
FINALLY
	IF exception THEN END path
ENDPROC

PROC strSubPathPart(path:ARRAY OF CHAR) RETURNS subPath:OWNS STRING
	DEF len
	len := PathPart(path) - path
	NEW subPath[len]
	StrCopy(subPath, path, len)
ENDPROC

PROC strSubFilePart(path:ARRAY OF CHAR) RETURNS filePart:OWNS STRING
	DEF len, filePartStr:ARRAY OF CHAR
	filePartStr := FilePart(path)
	len := StrLen(filePartStr)
	NEW filePart[len]
	StrCopy(filePart, filePartStr)
ENDPROC

/*****************************/

->obtains the full path of a file/dir, given the name & a directory lock
->NOTE: If name is a full path then the directory lock is ignored.
PROC fullPath(dirLock:BPTR, name:ARRAY OF CHAR) RETURNS path:OWNS STRING
	DEF dirPath:OWNS STRING
	
	->obtain dir path from lock
	dirPath := strSafeNameFromLock(dirLock)
	IF dirPath = NILS THEN RETURN NILS
	
	->obtain complete path
	NEW path[EstrLen(dirPath) + 1 + StrLen(name) + 1]
	StrCopy(path, dirPath)
	IF strAddPart(path, name) = FALSE THEN END path
	
	/*, joiner:ARRAY OF CHAR
	joiner := IF dirPath[EstrLen(dirPath)-1] <> ":" THEN '/' ELSE NILA
	path := StrJoin(dirPath, joiner, name)
	*/
FINALLY
	IF exception THEN END path
	END dirPath
ENDPROC

->obtains the full path of the given workbench argument
PROC pathOfWbArg(wbarg:PTR TO wbarg) RETURNS path:OWNS STRING IS fullPath(wbarg.lock, wbarg.name)

PROC splitPath(filePath:ARRAY OF CHAR) RETURNS fileName:OWNS STRING, fileDir:OWNS STRING
	DEF dirLen
	
	fileName := StrJoin(FilePart(filePath))
	
	dirLen := StrLen(filePath) - EstrLen(fileName)
	NEW fileDir[ Max(dirLen,1) ]
	StrCopy(fileDir, filePath, dirLen)
FINALLY
	IF exception THEN END fileName, fileDir
ENDPROC

PROC expandPath(path:ARRAY OF CHAR, doNotFollowLinks=FALSE:BOOL) RETURNS fullPath:OWNS STRING
	DEF linkPath:OWNS STRING
	DEF lock:BPTR
	DEF pos, pathNotVolume:ARRAY OF CHAR, devProc:PTR TO devproc, oldFSPort:PTR TO mp, oldCurDir:BPTR
	DEF  subDir:OWNS STRING, fullSubDir :OWNS STRING
	DEF currDir:OWNS STRING
	
	fullPath := NILS
	
	->if it isn't a link, then it is OK to directly lock it!
	IF doNotFollowLinks		-># was: AND NOT doNotCheckForLinks
		linkPath := easyReadLink(path, NILA, /*doNotReturnLinkType*/ TRUE)
		IF linkPath = NILS THEN doNotFollowLinks := FALSE
		END linkPath
	ENDIF
	
	->try a direct lock to expand the path
	IF doNotFollowLinks = FALSE
		->this works correctly with multi-assigns
		IF lock := Lock(path, ACCESS_READ)
			fullPath := strSafeNameFromLock(lock)
			lock := unLock(lock)
		ENDIF
	ENDIF
	
	->(if that is not allowed) search the (multi-assign) parent directory for a matching name, and then construct the full path from the parent directory
	IF (fullPath = NILS) AND doNotFollowLinks
		->get path without any volume
		pos := InStr(path, ':')
		pathNotVolume := IF pos = -1 THEN path ELSE path + (pos + 1 * SIZEOF CHAR)
		
		->search for the first handler/filesystem volume (expanded sub-assignment) that has the specified path
		WHILE devProc := GetDeviceProc(path, devProc)
			oldFSPort := SetFileSysTask(devProc.port)	->this should be done for any use of "devProc.lock", and *must* be done if the lock is NIL (which it will be for absolute paths)
			oldCurDir := CurrentDir(devProc.lock)		->set CD for pathNotVolume to be interpreted correctly
			
			IF lock := Lock(pathNotVolume, ACCESS_READ)
				->(found a match) so construct full path from the parent directory (and thus avoid following the link)
				lock := unLock(lock)
				
				IF subDir := strSubPathPart(pathNotVolume)
					IF lock := Lock(subDir, ACCESS_READ)
						->(locked parent directory) so should be able to exactly emulate the result of locking the actual file
						IF fullSubDir := strSafeNameFromLock(lock) THEN fullPath := strJoinPart(fullSubDir, FilePart(path))
						END fullSubDir
						lock := unLock(lock)
					ENDIF
					END subDir
				ENDIF
			ENDIF
			
			SetFileSysTask(oldFSPort) ; oldFSPort := NIL
			CurrentDir(oldCurDir)     ; oldCurDir := NIL	->restore CD
		ENDWHILE IF fullPath
	ENDIF
	
	->(if that fails then) try locking the parent directory to expand the path
	IF fullPath = NILS
		IF subDir := strSubPathPart(path)
			IF lock := Lock(subDir, ACCESS_READ)
				->(locked parent directory) so should be able to exactly emulate the result of locking the actual file UNLESS a multi-assignment is used
				IF fullSubDir := strSafeNameFromLock(lock) THEN fullPath := strJoinPart(fullSubDir, FilePart(path))
				END fullSubDir
				lock := unLock(lock)
			ENDIF
		ENDIF
	ENDIF
	
	->(if that fails then) use the current directory to expand the path
	IF fullPath = NILS
		IF currDir := strSafeGetNameOfCurrentDir()
			fullPath := strJoinPart(currDir, path)
			END currDir
		ENDIF
	ENDIF
	
	->(if that fails then) simply return the original path
	IF fullPath = NILS
		fullPath := StrJoin(path)
	ENDIF
FINALLY
	IF lock      THEN UnLock(lock)
	IF oldFSPort THEN SetFileSysTask(oldFSPort)
	IF oldCurDir THEN CurrentDir(oldCurDir)
	IF devProc   THEN FreeDeviceProc(devProc)
	
	IF exception THEN END fullPath
	END subDir, fullSubDir
	END currDir
ENDPROC

->expands the path in the way AmigaDOS would use when creating a new file (rather than opening/locking an existing one)
PROC expandPathForCreation(path:ARRAY OF CHAR) RETURNS fullPath:OWNS STRING
	DEF pathVolume   :OWNS STRING, pos,
	    pathNotVolume:OWNS STRING, len
	DEF fullVolume:OWNS STRING, lock:BPTR
	
	fullPath := NILS
	
	->extract volume if possible
	pos := InStr(path, ':')
	IF pos <> -1
		NEW pathVolume[pos+1]
		StrCopy(pathVolume, path, pos+1)
	ENDIF
	
	IF pathVolume = NILS
		pathNotVolume := StrJoin(path)
	ELSE
		len := StrLen(path)
		pos++
		NEW pathNotVolume[len-pos]
		StrCopy(pathNotVolume, path, ALL, pos)
	ENDIF
	
	->get expanded volume
	IF pathVolume
		->expand volume given in path
		IF lock := Lock(pathVolume, ACCESS_READ)
			fullVolume := strSafeNameFromLock(lock)
			lock := unLock(lock)
		ENDIF
	ELSE
		->expand current directory
		fullVolume := strSafeGetNameOfCurrentDir()
	ENDIF
	
	IF fullVolume = NILS THEN RETURN
	
	->create full path
	fullPath := strJoinPart(fullVolume, pathNotVolume)
FINALLY
	IF exception THEN END fullPath
	END pathVolume,
	    pathNotVolume
	END fullVolume
ENDPROC

PROC lockWithoutRequester(path:ARRAY OF CHAR, accessMode) RETURNS lock:BPTR
	DEF process:PTR TO process, oldwindowptr:APTR
	
	->prevent "Please insert volume" requester for unknown volume/assign
	process := FindTask(NILA) !!PTR
	oldwindowptr := process.windowptr
	process.windowptr := -1 !!VALUE!!APTR
	
	->try to lock the file/dir
	lock := Lock(path, accessMode)
	
	->restore "Please insert volume" requester, etc
	process.windowptr := oldwindowptr
ENDPROC

->NOTE: If needToKnowAboutLinks=FALSE then dirEntryType may not correctly indicate a soft/hard link on some filesystems (like SFS).
->NOTE: Returns dirEntryType=0 if the file/dir did not exist or could not be examined.
->NOTE: If the file/dir exists but could not be examined, it still returns exists=TRUE.
PROC fileDirType(path:ARRAY OF CHAR, needToKnowAboutLinks=FALSE:BOOL, returnExists=NILA:ARRAY OF BOOL) RETURNS dirEntryType, exists:BOOL
	DEF lock:BPTR
	
	->try to lock the file/dir
	IF (needToKnowAboutLinks = FALSE) OR (returnExists <> NILA)
		lock := lockWithoutRequester(path, ACCESS_READ)
	ENDIF
	exists := lock <> NIL
	
	->determine dirEntryType
	dirEntryType := fileDirTypeOfLock(lock, path, needToKnowAboutLinks)
FINALLY
	IF lock THEN UnLock(lock)
	
	IF returnExists THEN returnExists[0] := exists
ENDPROC

->perform fileDirType() on an existing lock, to avoid performing a second lock.
->NOTE: If needToKnowAboutLinks=TRUE then you must supply path<>NILA, but you can supply lock=NIL without any problem... however you might as well call fileDirType() in that case!
PROC fileDirTypeOfLock(lock:BPTR, path=NILA:ARRAY OF CHAR, needToKnowAboutLinks=FALSE:BOOL) RETURNS dirEntryType
	DEF fib:PTR TO fileinfoblock
	
	dirEntryType := 0
	IF fib := AllocDosObject(DOS_FIB, NILA)
		IF needToKnowAboutLinks = FALSE
			IF lock
				IF Examine(lock, fib) THEN dirEntryType := fib.direntrytype
			ENDIF
		ELSE
			IF examineAll(path, fib) THEN dirEntryType := fib.direntrytype
		ENDIF
	ENDIF
FINALLY
	IF fib THEN FreeDosObject(DOS_FIB, fib)
ENDPROC

->NOTE: This correctly handles soft links, which normally look like dirs due to being positive.
->NOTE: If the filetype cannot be determined then it assumes it is a file.
PROC dirEntryTypeIsFile(dirEntryType, path:ARRAY OF CHAR) RETURNS isFile:BOOL
	DEF linkPath:OWNS STRING
	
	IF dirEntryType = ST_SOFTLINK
		linkPath := easyReadLink(path)
		IF linkPath = NILS THEN Throw("BUG", 'dirEntryTypeIsFile(); linkPath=NILS')
		
		dirEntryType := fileDirType(linkPath)
		isFile := dirEntryTypeIsFile(dirEntryType, linkPath)		->use recursion, in case soft link points to another soft link!
	ELSE
		isFile := dirEntryType <= 0
	ENDIF
FINALLY
	END linkPath
ENDPROC

->NOTE: If the filetype cannot be determined then it assumes it is NOT a link.
PROC dirEntryTypeIsLink(dirEntryType) RETURNS isLink:BOOL IS (dirEntryType = ST_SOFTLINK) OR (dirEntryType = ST_LINKDIR) OR (dirEntryType = ST_LINKFILE)

PROC exists(path:ARRAY OF CHAR, only1file2dir4device=0) RETURNS exists:BOOL
	DEF lock:BPTR
	DEF dirEntryType
	
	IF only1file2dir4device = 0
		/* this whole IF section could be replaced by exists:=deviceExists(path), but it would be slower in the common case */
		lock := lockWithoutRequester(path, ACCESS_READ)
		exists := (lock<>NIL)
		IF lock THEN UnLock(lock)
		
		IF exists = FALSE
			->lock() fails on handler-based devices, so check if device exists (with given path)
			exists := deviceExists(path)
		ENDIF
	ELSE
		dirEntryType := fileDirType(path, FALSE, ADDRESSOF exists)
		
		IF dirEntryType <> 0
			IF dirEntryTypeIsFile(dirEntryType, path)
				->(is a file)
				IF only1file2dir4device AND 1 = 0 THEN exists := FALSE
			ELSE
				->(is a dir)
				IF only1file2dir4device AND 2 = 0 THEN exists := FALSE
			ENDIF
			
		ELSE IF only1file2dir4device AND 4
			->(devices are allowed) and lock() fails on handler-based devices, so check if device exists (with given path)
			exists := deviceExists(path)
		ENDIF
	ENDIF
ENDPROC

->check if a device exists which contains the given path (but may just be the device volume on it's own)
->NOTE: This works with handler-based devices (like PIPE:), as well as normal filesystem devices.
PROC deviceExists(path:ARRAY OF CHAR) RETURNS exists:BOOL
	DEF process:PTR TO process, oldwindowptr:APTR
	DEF pos, pathNotVolume:ARRAY OF CHAR, devProc:PTR TO devproc, oldFSPort:PTR TO mp, oldCurDir:BPTR, lock:BPTR
	
	->prevent "Please insert volume" requester for unknown volume/assign
	process := FindTask(NILA) !!PTR
	oldwindowptr := process.windowptr
	process.windowptr := -1 !!VALUE!!APTR
	
	->get path without any volume
	pos := InStr(path, ':')
	pathNotVolume := IF pos = -1 THEN path ELSE path + (pos + 1 * SIZEOF CHAR)
	
	->search for the first handler/filesystem volume that has the specified path
	exists := FALSE
	WHILE devProc := GetDeviceProc(path, devProc)
		oldFSPort := SetFileSysTask(devProc.port)	->this should be done for any use of "devProc.lock", and *must* be done if the lock is NIL (which it will be for absolute paths)
		oldCurDir := CurrentDir(devProc.lock)		->set CD for pathNotVolume to be interpreted correctly
		
		IF pathNotVolume[0] = 0
			->(no path after volume) so always match
			exists := TRUE
			
		ELSE IF lock := Lock(pathNotVolume, ACCESS_READ)
			->(found a match)
			lock := unLock(lock)
			
			exists := TRUE
		ENDIF
		
		SetFileSysTask(oldFSPort) ; oldFSPort := NIL
		CurrentDir(oldCurDir)     ; oldCurDir := NIL	->restore CD
	ENDWHILE IF exists
	
	->restore "Please insert volume" requester, etc
	process.windowptr := oldwindowptr
FINALLY
	IF oldFSPort THEN SetFileSysTask(oldFSPort)
	IF oldCurDir THEN CurrentDir(oldCurDir)
	IF lock      THEN UnLock(lock)
	IF devProc   THEN FreeDeviceProc(devProc)
ENDPROC

PROC commandExists(command:ARRAY OF CHAR) RETURNS exists:BOOL
	DEF cli:PTR TO commandlineinterface, hook:hook, lock:BPTR
	
	IF cli := Cli()
		installhook(hook, CALLBACK checkDirHook())
		lock := searchCmdPathList(Baddr(cli.commanddir), hook, command) !!BPTR
	ELSE
		lock := lockOnlyFile(command)
	ENDIF
	exists := (lock<>NIL)
FINALLY
	IF lock THEN UnLock(lock)
ENDPROC
PRIVATE
PROC checkDirHook(hook:PTR TO hook, reserved, message:PTR TO searchcmdpathlistmsg) RETURNS ret
	DEF oldCD:BPTR
	
	oldCD := CurrentDir(message.lock)
	ret := lockOnlyFile(message.name)
	CurrentDir(oldCD)
	
	IF FALSE ; hook := hook ; reserved := reserved ; ENDIF	->dummy
FINALLY
	PrintException()
	IF exception THEN ret := 0
	exception := 0
ENDPROC
PROC lockOnlyFile(name:ARRAY OF CHAR) RETURNS lock:BPTR
	IF lock := Lock(name, SHARED_LOCK)
		IF dirEntryTypeIsFile(fileDirTypeOfLock(lock), name) = FALSE
			UnLock(lock) ; lock := NIL
		ENDIF
	ENDIF
FINALLY
	IF exception THEN UnLock(lock)
ENDPROC
PUBLIC

->NOTE: If the filetype cannot be determined then it assumes it is NOT a file.
PROC isFile(path:ARRAY OF CHAR) RETURNS isFile:BOOL
	DEF dirEntryType, exists:BOOL
	
	dirEntryType := fileDirType(path, FALSE, ADDRESSOF exists)
	isFile := dirEntryTypeIsFile(dirEntryType, path) AND exists
ENDPROC

->NOTE: If the filetype cannot be determined then it assumes it is NOT a dir.
PROC isDir(path:ARRAY OF CHAR) RETURNS isDir:BOOL
	DEF dirEntryType, exists:BOOL
	
	dirEntryType := fileDirType(path, FALSE, ADDRESSOF exists)
	isDir := (dirEntryTypeIsFile(dirEntryType, path) = FALSE) AND exists
ENDPROC

->NOTE: If the filetype cannot be determined then it assumes it is NOT a link.
PROC isLink(path:ARRAY OF CHAR) RETURNS isLink:BOOL
	DEF dirEntryType
	
	dirEntryType := fileDirType(path, /*needToKnowAboutLinks*/ TRUE)
	isLink := dirEntryTypeIsLink(dirEntryType)
ENDPROC

PROC fileSize(path:ARRAY OF CHAR, linkSizeIsZero=FALSE:BOOL) RETURNS sizeInBytes:BIGVALUE
	DEF lock:BPTR, fib:PTR TO fileinfoblock
	DEF handle:BPTR
	
	sizeInBytes := -1
	
	handle := Open(path, MODE_OLDFILE)	->this can fail if the file is opened in exclusive mode (e.g. due to being a new file)
	IF handle
		sizeInBytes := fileSizeFromFH(handle, FALSE, linkSizeIsZero)
	ELSE
		->32-bit fall-back
		IF fib := AllocDosObject(DOS_FIB, NILA)
			IF linkSizeIsZero
				IF examineAll(path, fib)
					sizeInBytes := fib.size
					/*IF linkSizeIsZero THEN*/ IF dirEntryTypeIsLink(fib.direntrytype) THEN sizeInBytes := 0
				ENDIF
			ELSE
				IF lock := Lock(path, ACCESS_READ)
					IF Examine(lock, fib) THEN sizeInBytes := fib.size
				ENDIF
				IF sizeInBytes = -1
					IF examineAll(path, fib) THEN sizeInBytes := fib.size
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	
	IF sizeInBytes = -1
		Print('WARNING: fileSize("\s", \d); failed to obtain size of file (3)\n', path, linkSizeIsZero)	->###
	ENDIF
FINALLY
	IF lock   THEN UnLock(lock)
	IF handle THEN Close(handle)
ENDPROC

PROC fileSizeFromFH(handle:BPTR, preservePosition=FALSE:BOOL, linkSizeIsZero=FALSE:BOOL) RETURNS sizeInBytes:BIGVALUE
	DEF fib:PTR TO fileinfoblock
	
	IF linkSizeIsZero
		IF fib := AllocDosObject(DOS_FIB, NILA)
			IF ExamineFH(handle, fib)
				IF dirEntryTypeIsLink(fib.direntrytype) THEN RETURN 0
			ENDIF
		ENDIF
	ENDIF
	
	sizeInBytes := getFileSize64(handle, /*trashPosition*/ NOT preservePosition)
	IF sizeInBytes = -1 THEN Throw("ERR", 'fileSizeFromFH(); failed to obtain size of file (6)')
FINALLY
	IF fib THEN FreeDosObject(DOS_FIB, fib)
ENDPROC

->NOTE: Returns NILS if the comment could not be read.
PROC getComment(path:ARRAY OF CHAR) RETURNS comment:OWNS STRING
	DEF lock:BPTR, fib:PTR TO fileinfoblock
	
	IF fib := AllocDosObject(DOS_FIB, NILA)
		IF lock := Lock(path, SHARED_LOCK)
			IF Examine(lock, fib)
				comment := StrJoin(fib.comment)
			ENDIF
		ENDIF
	ENDIF
FINALLY
	IF lock THEN UnLock(lock)
	IF fib THEN FreeDosObject(DOS_FIB, fib)
ENDPROC

->returns TRUE if full dir path did or does now exist (or FALSE if it still doesn't exist)
PROC createDirTree(path:ARRAY OF CHAR, ignoreFinalName=FALSE:BOOL, deleteAnyFiles=FALSE:BOOL) RETURNS success:BOOL
	DEF subPath:OWNS STRING, lock:BPTR
	
	subPath := strSubPathPart(path)
	
	IF success := IF NOT exists(subPath) THEN createDirTree(subPath) ELSE IF ignoreFinalName THEN exists(subPath, /*only1file2dir4device*/ 2) ELSE TRUE
		->(subPath exists as a directory) so create named dir
		IF ignoreFinalName = FALSE
			IF deleteAnyFiles THEN DeleteFile(path)
			
			IF lock := CreateDir(path)
				success := TRUE
				UnLock(lock)
			ELSE
				success := exists(path, /*only1file2dir4device*/ 2)
			ENDIF
		ENDIF
	ENDIF
FINALLY
	END subPath
ENDPROC

PRIVATE
DEF faultBuffer:OWNS STRING
PUBLIC

->like Fault() but does not require a user-supplied buffer, as one is globally allocated
PROC staticFault(code, header=NILA:ARRAY OF CHAR /*STRPTR*/) RETURNS buffer:STRING
	IF header = NILA THEN header := ''
	END faultBuffer
	NEW faultBuffer[80+40 + StrLen(header)]
	
	strFault(code, header, faultBuffer)
	buffer := faultBuffer
ENDPROC

->NOTE: Returns NILS if the task is not a process, or otherwise no suitable name could be found.
PROC processNameOfTask(task:PTR TO tc) RETURNS name:OWNS STRING
	DEF process:PTR TO process, cli:PTR TO commandlineinterface
	
	IF task.ln.type = NT_PROCESS
		process := task!!PTR!!PTR TO process
		IF process.cli
			->(this task is a Shell or similar) so get the name of the program that the Shell is currently executing
			cli := Baddr(process.cli)
			name := bcplToString(cli.commandname)
			IF EstrLen(name) = 0 THEN END name
		ENDIF
	ENDIF
ENDPROC

/*****************************/

->makes an exact copy of the file
PROC copyFile(from:ARRAY OF CHAR, to:ARRAY OF CHAR, allowReplace=FALSE:BOOL) RETURNS success:BOOL
	DEF fromFH:BPTR, toFH:BPTR, size64:BIGVALUE, size, buffer:OWNS ARRAY OF BYTE, fib:PTR TO fileinfoblock
	
	success := FALSE
	
	->open files
	fromFH := Open(from, MODE_OLDFILE)
	IF fromFH = NIL THEN RETURN
	
	IF allowReplace
		SetProtection(to, 0)
		DeleteFile(to)
	ELSE
		IF exists(to) THEN RETURN
	ENDIF
	toFH := Open(to, MODE_NEWFILE)
	IF toFH = NIL THEN RETURN
	
	->create buffer
	size64 := fileSizeFromFH(fromFH)
	IF size64 > $7FFFFFFF THEN RETURN
	size := size64 !!VALUE
	NEW buffer[size]
	
	->copy contents
	setFilePosition64(fromFH, 0)
	IF Read(fromFH, buffer, size) <> size
		Close(toFH) ; toFH := NIL
		DeleteFile(to)
		RETURN
	ENDIF
	
	IF Write(toFH, buffer, size) <> size
		Close(toFH) ; toFH := NIL
		DeleteFile(to)
		RETURN
	ENDIF
	
	->copy meta data
	Close(toFH) ; toFH := NIL
	IF fib := AllocDosObject(DOS_FIB, NILA)
		IF ExamineFH(fromFH, fib)
			SetProtection(to, fib.protection)
			SetComment(   to, fib.comment)
			SetFileDate(  to, fib.datestamp)
		ENDIF
	ENDIF
	
	success := TRUE
FINALLY
	IF fromFH THEN Close(fromFH)
	IF   toFH THEN Close(  toFH)
	IF fib THEN FreeDosObject(DOS_FIB, fib)
	
	END buffer
ENDPROC

/*****************************/
/* Asynchronous I/O based upon:
http://thomas-rapp.homepage.t-online.de/examples/async.c	->code by Thomas Rapp, which avoids complex over-the-top optimisations used in Amiga Mail code intended for 68k machines.
Amiga_Mail_Vol2/II-77
Amiga_Mail_Vol2/II-107		->this has more complex & over-the-top optimisations than the earlier Amiga Mail code
*/

#ifndef pe_TargetOS_AROS

PROC asyncDosRead(file:BPTR, buffer:ARRAY, bufSize, port:PTR TO mp) RETURNS success:BOOL
	DEF handle:PTR TO filehandle, packet:PTR TO dospacket
	
	success := FALSE
	
	IF handle := Baddr(file)
		IF handle.type
			IF packet := AllocDosObject(DOS_STDPKT, NILA)
				packet.port := port
				packet.type := ACTION_READ
				packet.arg1 := handle.args
				packet.arg2 := buffer
				packet.arg3 := bufSize
				
				PutMsg(handle.type, packet.link)
				success := TRUE
			ENDIF
		ENDIF
	ENDIF
ENDPROC

PROC asyncDosWrite(file:BPTR, buffer:ARRAY, bufSize, port:PTR TO mp) RETURNS success:BOOL
	DEF handle:PTR TO filehandle, packet:PTR TO dospacket
	
	success := FALSE
	
	IF handle := Baddr(file)
		IF handle.type
			IF packet := AllocDosObject(DOS_STDPKT, NILA)
				packet.port := port
				packet.type := ACTION_WRITE
				packet.arg1 := handle.args
				packet.arg2 := buffer
				packet.arg3 := bufSize
				
				PutMsg(handle.type, packet.link)
				success := TRUE
			ENDIF
		ENDIF
	ENDIF
ENDPROC

->NOTE: This returns the number of bytes actually Read/Written (actually the value returned by Read()/Write()).
PROC asyncDosWait(port:PTR TO mp) RETURNS result
	DEF msg:PTR TO mn, packet:PTR TO dospacket
	
	WaitPort(port)
	msg := GetMsg(port)
	packet := msg.ln.name !!VALUE!!PTR
	result := packet.res1
	
	FreeDosObject(DOS_STDPKT, packet)
ENDPROC

/*
PROC asyncDosPoll(port:PTR TO mp) RETURNS ready:BOOL
	DEF signal
	signal := 1 SHL port.sigbit
	ready := SetSignal(0, signal) AND signal <> 0
ENDPROC
*/

#endif

/*****************************/

PROC easyMakeLink(path:ARRAY OF CHAR, linkPath:ARRAY OF CHAR, linkIsSoftNotHard:BOOL) RETURNS success:BOOL
	DEF lock:BPTR
	
	IF linkIsSoftNotHard
		success := MakeLink(path, linkPath, LINK_SOFT) <> 0
	ELSE
		IF lock := Lock(linkPath, SHARED_LOCK)
			success := MakeLink(path, lock, LINK_HARD) <> 0
			UnLock(lock)
		ELSE
			success := FALSE
		ENDIF
	ENDIF
ENDPROC

/*
PRIVATE
#ifdef pe_TargetOS_AROS
PROC DoPkt3(port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE) IS DoPkt(port, action, arg1, arg2, arg3, 0, 0)
#endif
PUBLIC
*/

PROC easyReadLink(path:ARRAY OF CHAR, returnLinkIs0unknown1none2soft3hard=NILA:ARRAY OF VALUE, doNotReturnLinkType=FALSE:BOOL) RETURNS linkPath:OWNS STRING, linkIs0unknown1none2soft3hard
	DEF pos, pathNotVolume:ARRAY OF CHAR, devProc:PTR TO devproc, oldFSPort:PTR TO mp, oldCurDir:BPTR,
	    expandedPath:OWNS STRING, expandedParentDir:OWNS STRING, parentDir:OWNS STRING, lock:BPTR
	DEF len, buf:OWNS ARRAY OF CHAR, bufSize, fib:PTR TO fileinfoblock
	
	linkPath := NILS
	linkIs0unknown1none2soft3hard := 1
	
	->get path without any volume
	pos := InStr(path, ':')
	IF pos <> -1
		->(path has a potential multi-assignment) so search for the first handler/filesystem volume (expanded sub-assignment) that has the specified path
		pathNotVolume := path + (pos + 1 * SIZEOF CHAR)
		WHILE devProc := GetDeviceProc(path, devProc)
			oldFSPort := SetFileSysTask(devProc.port)	->this should be done for any use of "devProc.lock", and *must* be done if the lock is NIL (which it will be for absolute paths)
			oldCurDir := CurrentDir(devProc.lock)		->set CD for pathNotVolume to be interpreted correctly
			
			IF lock := Lock(pathNotVolume, ACCESS_READ)
				->(found a match) so construct full path from the parent directory (and thus avoid following the link)
				lock := unLock(lock)
				
				IF parentDir := strSubPathPart(pathNotVolume)
					IF lock := Lock(parentDir, ACCESS_READ)
						->(locked parent directory) so should be able to exactly emulate the result of locking the actual file
						IF expandedParentDir := strSafeNameFromLock(lock) THEN expandedPath := strJoinPart(expandedParentDir, FilePart(path))
						END expandedParentDir
						lock := unLock(lock)
					ENDIF
					END parentDir
				ENDIF
			ENDIF
			
			SetFileSysTask(oldFSPort) ; oldFSPort := NIL
			CurrentDir(oldCurDir)     ; oldCurDir := NIL	->restore CD
		ENDWHILE IF expandedPath
		
		IF expandedPath THEN path := expandedPath
	ENDIF
	
	parentDir := strSubPathPart(path)
	IF lock := Lock(parentDir, ACCESS_READ)
		->try to retrieve (soft/hard) link path
		NEW buf[bufSize := 256]
		REPEAT
			buf[0] := 0		->in case ReadLink() returns len=TRUE (for success)
			len := ReadLink(Baddr(lock)::filelock.task, lock, FilePart(path), buf, bufSize)
			IF len = -2
				->(buffer too small)
				END buf
				NEW buf[bufSize := bufSize*2]
			ENDIF
		UNTIL len <> -2
		
		lock := unLock(lock)
		
		IF len = -1
			->(could mean "error" OR "success") so determine which
			IF buf[0] <> 0 THEN len := StrLen(buf)
		ENDIF
	ELSE
		len := -1
	ENDIF
	
	->store link path
	IF len > 0
		NEW linkPath[len]
		StrCopy(linkPath, buf)
	ENDIF
	
	->determine type of link
	IF len > 0
		IF doNotReturnLinkType
			linkIs0unknown1none2soft3hard := 0
		ELSE
			linkIs0unknown1none2soft3hard := 2
			IF fib := AllocDosObject(DOS_FIB, NILA)
				IF examineAll(path, fib)
					linkIs0unknown1none2soft3hard := IF fib.direntrytype = ST_SOFTLINK THEN 2 ELSE 3	/*ST_LINKFILE, ST_LINKDIR*/
				ENDIF
			ENDIF
			
			/* -># this does not always work (sometimes soft links appear to be hard links)
			DEF lock:BPTR, bcplString:BSTR, bcplBuffer:OWNS STRING
			bcplString, bcplBuffer := stringToBcpl(path, len)
			
			IF lock := DoPkt3(devProc.port, ACTION_LOCATE_OBJECT, devProc.lock, bcplString, SHARED_LOCK) !!BPTR
				->(not a soft link) so must be a hard link		->EXCEPT for Ram Disk where it could be a soft link
				linkIs0unknown1none2soft3hard := 3
			ELSE
				->(either is a soft link or another error occured)
				linkIs0unknown1none2soft3hard := 2	-># was: IF IoErr() = ERROR_IS_SOFT_LINK THEN 2 ELSE 0		->assume is a soft link when another error occured (I already saw ERROR_OBJECT_NOT_FOUND for a soft link on SFS/0)
			ENDIF
			lock := unLock(lock)
			FINALLY
				IF lock      THEN UnLock(lock)
				END bcplBuffer
			*/
		ENDIF
	ENDIF
FINALLY
	IF oldFSPort THEN SetFileSysTask(oldFSPort)
	IF oldCurDir THEN CurrentDir(oldCurDir)
	IF devProc   THEN FreeDeviceProc(devProc)
	IF lock      THEN UnLock(lock)
	IF fib       THEN FreeDosObject(DOS_FIB, fib)
	
	IF returnLinkIs0unknown1none2soft3hard THEN returnLinkIs0unknown1none2soft3hard[0] := linkIs0unknown1none2soft3hard
	
	END expandedPath, expandedParentDir, parentDir
	END buf
ENDPROC

/* -># obsolete:	Returned the wrong linkPath for soft links with relative links
PROC easyReadLink(path:ARRAY OF CHAR, returnLinkIs0unknown1none2soft3hard=NILA:ARRAY OF VALUE, doNotReturnLinkType=FALSE:BOOL) RETURNS linkPath:OWNS STRING, linkIs0unknown1none2soft3hard
	DEF pos, pathNotVolume:ARRAY OF CHAR, devProc:PTR TO devproc, oldFSPort:PTR TO mp, oldCurDir:BPTR
	DEF len, buf:OWNS ARRAY OF CHAR, bufSize, fib:PTR TO fileinfoblock
	
	linkPath := NILS
	linkIs0unknown1none2soft3hard := 1
	
	->get path without any volume
	pos := InStr(path, ':')
	pathNotVolume := IF pos = -1 THEN path ELSE path + (pos + 1 * SIZEOF CHAR)
	
	->search for the first handler/filesystem volume (expanded sub-assignment) that has the specified path
	WHILE devProc := GetDeviceProc(path, devProc)
		oldFSPort := SetFileSysTask(devProc.port)	->this should be done for any use of "devProc.lock", and *must* be done if the lock is NIL (which it will be for absolute paths)
		oldCurDir := CurrentDir(devProc.lock)		->set CD for pathNotVolume to be interpreted correctly	-># is this really needed? #
		
		->try to retrieve (soft/hard) link path
		END buf
		NEW buf[bufSize := 256]
		REPEAT
			buf[0] := 0		->in case ReadLink() returns len=TRUE (for success)
			len := ReadLink(devProc.port, devProc.lock, pathNotVolume, buf, bufSize)
			IF len = -2
				->(buffer too small)
				END buf
				NEW buf[bufSize := bufSize*2]
			ENDIF
		UNTIL len <> -2
		
		IF len = -1
			->(could mean "error" OR "success") so determine which
			IF buf[0] <> 0 THEN len := StrLen(buf)
		ENDIF
		
		SetFileSysTask(oldFSPort) ; oldFSPort := NIL
		CurrentDir(oldCurDir)     ; oldCurDir := NIL	->restore CD
	ENDWHILE IF len > 0
	
	->store link path
	IF len > 0
		NEW linkPath[len]
		StrCopy(linkPath, buf)
	ENDIF
	
	->determine type of link
	IF len > 0
		IF doNotReturnLinkType
			linkIs0unknown1none2soft3hard := 0
		ELSE
			linkIs0unknown1none2soft3hard := 2
			IF fib := AllocDosObject(DOS_FIB, NILA)
				IF examineAll(path, fib)
					linkIs0unknown1none2soft3hard := IF fib.direntrytype = ST_SOFTLINK THEN 2 ELSE 3	/*ST_LINKFILE, ST_LINKDIR*/
				ENDIF
			ENDIF
		ENDIF
	ENDIF
FINALLY
	IF oldFSPort THEN SetFileSysTask(oldFSPort)
	IF oldCurDir THEN CurrentDir(oldCurDir)
	IF devProc   THEN FreeDeviceProc(devProc)
	IF fib       THEN FreeDosObject(DOS_FIB, fib)
	
	IF returnLinkIs0unknown1none2soft3hard THEN returnLinkIs0unknown1none2soft3hard[0] := linkIs0unknown1none2soft3hard
	
	END buf
ENDPROC
*/

/* -># obsolete:	Failed to read links accessed via a multi-assignment (unless it was in the first assignment)
PROC easyReadLink(path:ARRAY OF CHAR, returnLinkIs0unknown1none2soft3hard=NILA:ARRAY OF VALUE, doNotReturnLinkType=FALSE:BOOL) RETURNS linkPath:OWNS STRING, linkIs0unknown1none2soft3hard
	DEF lock:BPTR, parentDir:OWNS STRING
	DEF len, buf:OWNS ARRAY OF CHAR, bufSize, fib:PTR TO fileinfoblock
	
	linkPath := NILS
	linkIs0unknown1none2soft3hard := 1
	
	parentDir := strSubPathPart(path)
	IF lock := Lock(parentDir, ACCESS_READ)
		->try to retrieve (soft/hard) link path
		NEW buf[bufSize := 256]
		REPEAT
			buf[0] := 0		->in case ReadLink() returns len=TRUE (for success)
			len := ReadLink(Baddr(lock)::filelock.task, lock, FilePart(path), buf, bufSize)
			IF len = -2
				->(buffer too small)
				END buf
				NEW buf[bufSize := bufSize*2]
			ENDIF
		UNTIL len <> -2
		
		lock := unLock(lock)
		
		IF len = -1
			->(could mean "error" OR "success") so determine which
			IF buf[0] <> 0 THEN len := StrLen(buf)
		ENDIF
		
		->store link path
		IF len > 0
			NEW linkPath[len]
			StrCopy(linkPath, buf)
		ENDIF
		
		->determine type of link
		IF len > 0
			IF doNotReturnLinkType
				linkIs0unknown1none2soft3hard := 0
			ELSE
				linkIs0unknown1none2soft3hard := 2
				IF fib := AllocDosObject(DOS_FIB, NILA)
					IF examineAll(path, fib)
						linkIs0unknown1none2soft3hard := IF fib.direntrytype = ST_SOFTLINK THEN 2 ELSE 3	/*ST_LINKFILE, ST_LINKDIR*/
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
FINALLY
	IF lock THEN UnLock(lock)
	IF fib  THEN FreeDosObject(DOS_FIB, fib)
	END parentDir
	END buf
	
	IF returnLinkIs0unknown1none2soft3hard THEN returnLinkIs0unknown1none2soft3hard[0] := linkIs0unknown1none2soft3hard
ENDPROC
*/

PRIVATE
PROC lockOnParentDir(filePath:ARRAY OF CHAR) RETURNS dirLock:BPTR
	DEF fullPath:OWNS STRING, dirPath:OWNS STRING
	
	fullPath := expandPath(filePath, /*doNotFollowLinks*/ TRUE)	-># was:, /*doNotCheckForLinks*/ TRUE)
	dirPath  := strSubPathPart(fullPath)
	dirLock  := Lock(dirPath, ACCESS_READ)
FINALLY
	IF exception THEN IF dirLock THEN UnLock(dirLock)
	END fullPath, dirPath
ENDPROC
PUBLIC

->for some filingsystems (e.g. SFS) this is the only way (except a dir scan) to reliably determine if something is a soft link or not.
PROC examineAll(filePath:ARRAY OF CHAR, fib:PTR TO fileinfoblock) RETURNS success:BOOL
	DEF dirLock:BPTR, ioerr
	DEF fileName:ARRAY OF CHAR, matchPattern:OWNS STRING
	DEF exAllMore, exAllCtrl:PTR TO exallcontrol, bufSize, buffer:ARRAY OF exalldata, bufEntry:PTR TO exalldata, i
	
	exAllCtrl := NIL
	
	success := TRUE
	
	->get lock on dir that holds file
	dirLock := lockOnParentDir(filePath)
	IF dirLock = NIL THEN RETURN FALSE
	
	->create match pattern using file's name
	fileName := FilePart(filePath)
	NEW matchPattern[StrLen(fileName) * 2 + 2]
	IF ParsePatternNoCase(fileName, matchPattern, StrMax(matchPattern)) = -1 THEN RETURN examineAll_slow(filePath, fib)		->was Throw("BUG", 'pAmigaDos; examineAll(); ParsePatternNoCase() failed')
	
	->allocate resources needed by ExAll
	exAllCtrl := AllocDosObject(DOS_EXALLCONTROL, NILA)
	exAllCtrl.lastkey := 0
	exAllCtrl.matchstring := matchPattern
	/*exAllCtrl.matchstring := NILA*/
	exAllCtrl.matchfunc   := NIL
	
	->use ExAll for a single file
	buffer := FastNew(bufSize := 5*SIZEOF exalldata)
	SetIoErr(ERROR_NO_MORE_ENTRIES)		->fix for broken ExAll() implementations that don't set this
	
	/*REPEAT*/
	exAllMore := ExAll(dirLock, buffer, bufSize, ED_COMMENT, exAllCtrl)
	IF exAllMore = NIL
		ioerr := IoErr()
		IF (ioerr <> 0) AND (ioerr <> ERROR_NO_MORE_ENTRIES) THEN RETURN examineAll_slow(filePath, fib)		->was Throw("FILE", 'pAmigaDos; examineAll(); ExAll() failed')
	ENDIF
	IF exAllCtrl.entries = 0 THEN RETURN FALSE
	bufEntry := buffer
	
	/*	WHILE bufEntry
			IF StrCmpNoCase(bufEntry.name, fileName)
				IF exAllMore THEN ExAllEnd(dirLock, buffer, bufSize, ED_COMMENT, exAllCtrl)
				exAllMore := NIL
			ELSE
				bufEntry := bufEntry.next
			ENDIF
		ENDWHILE IF exAllMore = NIL
	UNTIL exAllMore = NIL
	IF bufEntry = NIL THEN RETURN FALSE
	*/
	
	fib.direntrytype := bufEntry.type
	i := 0 ; WHILE fib.filename[i] := bufEntry.name[i] DO i++
	fib.protection   := bufEntry.prot
	fib.size         := bufEntry.size
	fib.datestamp.days   := bufEntry.days
	fib.datestamp.minute := bufEntry.mins
	fib.datestamp.tick   := bufEntry.ticks
	i := 0 ; WHILE fib.comment[i]  := bufEntry.comment[i] DO i++
	
	->complete ExAll() in the unlikely possibility that it has not completed
	IF exAllMore THEN ExAllEnd(dirLock, buffer, bufSize, ED_COMMENT, exAllCtrl)
FINALLY
	IF exAllCtrl THEN FreeDosObject(DOS_EXALLCONTROL, exAllCtrl)
	IF dirLock THEN UnLock(dirLock)
	END matchPattern
	FastDispose(buffer, bufSize)
ENDPROC

PRIVATE
->a fall-back implementation using ExNext(), for when ExAll() is not supported
PROC examineAll_slow(filePath:ARRAY OF CHAR, fib:PTR TO fileinfoblock) RETURNS success:BOOL
	DEF dirPath:OWNS STRING, fileName:ARRAY OF CHAR, lock:BPTR
	
	success := FALSE
	
	->get lock on dir that holds file
	lock := lockOnParentDir(filePath)
	IF lock = NIL THEN RETURN
	
	->scan dir for the corresponding file
	IF Examine(lock, fib) = FALSE THEN RETURN
	
	fileName := FilePart(filePath)
	WHILE ExNext(lock, fib)
		IF StrCmpNoCase(fib.filename, fileName) THEN success := TRUE
	ENDWHILE IF success
	IF success = FALSE
		IF IoErr() <> ERROR_NO_MORE_ENTRIES THEN RETURN
	ENDIF
FINALLY
	IF lock THEN UnLock(lock)
	
	END dirPath
ENDPROC
PUBLIC

PRIVATE
PROC unLock(lock:BPTR) IS UnLock(lock) BUT NIL
PUBLIC

/*****************************/

PROC bcplToString(bcplString:BSTR) RETURNS string:OWNS STRING
	DEF len, temp:ARRAY OF CHAR
	
	temp := Baddr(bcplString) !!VALUE!!ARRAY
	len := CharToUnsigned(temp[0])
	
	NEW string[len]
	StrCopy(string, temp, len, 1)
FINALLY
	IF exception THEN END string
ENDPROC

PROC stringToBcpl(string:ARRAY OF CHAR, len=-1) RETURNS bcplString:BSTR, buffer:OWNS STRING
	DEF tmp:ARRAY
	
	IF len = -1 THEN len := StrLen(string)
	
	NEW buffer[1 + len]
	
	buffer[0] := UnsignedToChar(len)
	SetStr(buffer, 1)
	StrAdd(buffer, string)
	
	tmp := buffer !!VALUE!!ARRAY	->work-around an AmigaE (target) bug, which cannot handle (cast) comments as part of a macro parameter
	bcplString := Mkbaddr(tmp)
ENDPROC

/*****************************/

PROC executeCommand(command:ARRAY OF CHAR, silent=FALSE:BOOL, async=FALSE:BOOL, stackSize=0, taskPri=0, currentDir=NIL:BPTR, tagList=NILA:ARRAY OF tagitem) RETURNS success:BOOL, returnCode
	DEF error, con:ARRAY OF CHAR, input:BPTR, output:BPTR
	#ifdef pe_TargetOS_AmigaOS4
	DEF errOut:BPTR
	#endif
	
	#ifdef pe_TargetOS_AROS
		DEF newCommand:OWNS STRING
		DEF oldPri
		IF taskPri <> 0 THEN oldPri := SetTaskPri(FindTask(NILA), taskPri)
		IF StrCmpNoCase(command, 'Execute ', STRLEN)
			newCommand := StrJoin('Run ', command)
			command := newCommand
			
			async := FALSE
		ENDIF
	#endif
	
	con := IF silent THEN 'NIL:' ELSE 'CONSOLE:'
	#ifdef pe_TargetOS_AROS
		IF (silent = FALSE) AND (wbmessage <> NILA) THEN con := 'CON://///AUTO/CLOSE/WAIT'
	#endif
	IF con
		input  := Open(con, MODE_OLDFILE)
		output := #ifdef pe_TargetOS_AROS NIL #else Open(con, MODE_NEWFILE) #endif
		#ifdef pe_TargetOS_AmigaOS4
		errOut := Open(con, MODE_NEWFILE)
		#endif
	ENDIF
	
	error := SystemTagList(command, [
		SYS_ASYNCH, async,
		IF con THEN SYS_INPUT     ELSE TAG_IGNORE,  input,
		IF con THEN SYS_OUTPUT    ELSE TAG_IGNORE, output,
		#ifdef pe_TargetOS_AmigaOS4
		IF con THEN SYS_ERROR     ELSE TAG_IGNORE, errOut,
		#endif
		IF taskPri    THEN NP_PRIORITY   ELSE TAG_IGNORE, taskPri,	->AROS may ignore this
		IF stackSize  THEN NP_STACKSIZE  ELSE TAG_IGNORE, stackSize,
		IF currentDir THEN NP_CURRENTDIR ELSE TAG_IGNORE, currentDir,
	IF tagList THEN TAG_MORE ELSE TAG_END, tagList]:tagitem)
	success := error <> -1		->if error is not -1 then it is the return code
	returnCode := IF success THEN error ELSE RETURN_FAIL
	
	IF error = -1
		IF input  THEN Close(input)
		IF output THEN Close(output)
		#ifdef pe_TargetOS_AmigaOS4
		IF errOut THEN Close(errOut)
		#endif
		IF currentDir THEN UnLock(currentDir)
	ENDIF
	
	#ifdef pe_TargetOS_AROS
		IF taskPri <> 0 THEN SetTaskPri(FindTask(NILA), oldPri)
		END newCommand
	#endif
ENDPROC
