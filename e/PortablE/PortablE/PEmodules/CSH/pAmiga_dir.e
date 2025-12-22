/* pAmiga_dir.e 08-08-2013
	A collection of useful directory procedures, which mirrors some suppled by cPath.
	Copyright (c) 2011,2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
OPT INLINE
MODULE 'CSH/pAmigaDos', 'CSH/cMegaList_STRING'

/*****************************/

->returns an (optionally sorted) list of directory entry names, or NIL if there was an error
->NOTE: In the event of an error, ioErr *may* be non-zero.
->NOTE: Directory names end in a slash.
->NOTE: Supply NIL to compareFunction if you don't want the scanned directory to be in any order.
->NOTE: Or supply fCompareMegaNodes_STRING_NoCase to compareFunction if you want the scanned directory to sorted normally.
-># This should be optimised to use ExAll().
PROC scanDir(dir:ARRAY OF CHAR, compareFunction:NULL PTR TO fCompareMegaNodes, returnIoErr=NILA:ARRAY OF VALUE) RETURNS list:OWNS PTR TO cMegaList_STRING, ioErr
	DEF lock:BPTR, fib:PTR TO fileinfoblock
	DEF cursor:OWNS PTR TO cMegaCursor_STRING, name:OWNS STRING
	DEF origDirEntryType, filePath:OWNS STRING
	
	ioErr := 0
	SetIoErr(0)
	
	IF lock := Lock(dir, SHARED_LOCK)
		IF fib := AllocDosObject(DOS_FIB, NILA)
			IF Examine(lock, fib)
				NEW list.new()
				cursor := list.infoStart().clone()
				
				WHILE ExNext(lock, fib)
					origDirEntryType := fib.direntrytype
					IF fib.direntrytype = ST_SOFTLINK
						filePath := strJoinPart(dir, fib.filename)
						fib.direntrytype := IF dirEntryTypeIsFile(fib.direntrytype, filePath) THEN ST_FILE ELSE ST_USERDIR
						END filePath
					ENDIF
					
					IF fib.direntrytype > 0
						->(directory)
						name := StrJoin(fib.filename, '/_')
					ELSE
						->(file)
						name := StrJoin(fib.filename, '_')
					ENDIF
					
					SetStr(name, EstrLen(name)-1)	->strip trailing _
					name[EstrLen(name)+1] := UnsignedToChar(128 + origDirEntryType)	->store direntrytype where the zero terminator used to be (after where the _ was)
					
					IF compareFunction
						cursor.sortedInsert(list.makeNode(PASS name), compareFunction)
					ELSE
						cursor.beforeInsert(list.makeNode(PASS name))
					ENDIF
				ENDWHILE
				
				ioErr := IoErr()
				IF ioErr = ERROR_NO_MORE_ENTRIES
					ioErr := 0
				ELSE
					END list
				ENDIF
			ELSE
				ioErr := IoErr()
			ENDIF
		ELSE
			ioErr := IoErr()
		ENDIF
	ELSE
		ioErr := IoErr()
	ENDIF
FINALLY
	IF lock THEN UnLock(lock)
	IF fib THEN FreeDosObject(DOS_FIB, fib)
	
	IF exception THEN END list
	END cursor
	END filePath
	
	IF returnIoErr THEN returnIoErr[0] := ioErr
ENDPROC

/*****************************/

PROC fastIsFile(path:STRING) RETURNS isFile:BOOL IS path[EstrLen(path)-1] <> "/"

PROC fastIsDir( path:STRING) RETURNS isFile:BOOL IS path[EstrLen(path)-1]  = "/"

PROC fastIsLink(path:STRING) RETURNS isLink:BOOL IS dirEntryTypeIsLink(fastFileDirType(path))

PROC fastFileDirType(path:STRING) RETURNS dirEntryType IS CharToUnsigned(path[EstrLen(path)+1]) - 128

->this clones a path, preserving it's hidden dirEntryType information (which is needed by fastIsLink() & fastFileDirType())
PROC fastCopyPath(path:STRING) RETURNS copy:OWNS STRING
	DEF len
	len := EstrLen(path)
	NEW copy[len+1]
	StrCopy(copy, path)
	copy[len+1] := path[len+1]	->copy the encoded dirEntryType into the new string
ENDPROC

->this logically appends a path to an e-string, and copies the path's hidden dirEntryType information (which is needed by fastIsLink() & fastFileDirType())
->NOTE: Returns success=FALSE if there was not enough space to store the dirEntryType (needs 1 extra character).
PROC fastStrAddPart(eString:STRING, path:STRING) RETURNS success:BOOL
	DEF len, size
	IF strAddPart(eString, path) = FALSE THEN RETURN FALSE
	len := EstrLen(eString)
	size := StrMax(eString)
	IF success := len < size THEN eString[len+1] := path[EstrLen(path)+1]	->copy the encoded dirEntryType into the new string
ENDPROC

/*****************************/

->NOTE: These functions may use fastIsFile/Dir() on the supplied path.
FUNC funcRecurseFile(filePath:STRING) IS EMPTY
FUNC funcRecurseDir(dirPath:STRING) OF funcRecurseFile RETURNS scanDir:BOOL IS EMPTY
FUNC funcRecurseDirFailure(dirPath:STRING, ioErr=0) OF funcRecurseDir RETURNS continueScan:BOOL IS EMPTY
FUNC funcRecurseDirAbort(nextDirPath:STRING) IS EMPTY

->recurse directory, passing each file to the supplied function
->NOTE: Supply NIL to compareFunction if you don't want each scanned directory to be in any order.
->NOTE: Or supply fCompareMegaNodes_STRING_NoCase to compareFunction if you want each scanned directory to sorted normally.
->NOTE: It is very similar to cPath's RecurseDir().
PROC recurseDir(startDirPath:ARRAY OF CHAR, compareFunction:NULL PTR TO fCompareMegaNodes, funcFile:PTR TO funcRecurseFile, funcDir=NIL:PTR TO funcRecurseDir, funcDirFailure=NIL:PTR TO funcRecurseDirFailure, funcDirAbort=NIL:PTR TO funcRecurseDirAbort)
	DEF scanList:OWNS PTR TO cMegaList_STRING, dirList:OWNS PTR TO cMegaList_STRING
	DEF ioErr, dirPath:STRING, name:STRING, path:OWNS STRING
	
	->set-up
	NEW scanList.new()
	scanList.infoPastEnd().beforeInsert(scanList.makeNode(StrJoin(startDirPath)))		->do not expand this path!
	
	->breadth-first recursive scan
	WHILE scanList.infoIsEmpty() = FALSE
		dirPath := scanList.infoStart().read()
		
		->scan folder
		dirList, ioErr := scanDir(dirPath, compareFunction)
		IF dirList
			WHILE dirList.infoIsEmpty() = FALSE
				name := dirList.infoStart().read()
				
				->was: path := strJoinPart(dirPath, name)
				NEW path[EstrLen(dirPath) + 2 + EstrLen(name) + 1]	->this is 1 larger than strJoinPart() would do
				StrCopy(path, dirPath)
				IF fastStrAddPart(path, name) = FALSE THEN Throw("BUG", 'recurseDir(); the allocated string was too small')
				
				->skipDirLink := IF followDirLinks THEN FALSE ELSE fastIsLink(name)
				
				IF fastIsDir(name) ->AND NOT skipDirLink
					->(entry is a folder) so add it to tail of scan list
					IF funcDir THEN IF funcDir(path) = FALSE THEN END path
					IF path
						scanList.infoPastEnd().beforeInsert(scanList.makeNode(PASS path))
					ENDIF
				ELSE
					->(entry is file) so pass it to function
					funcFile(path)
					END path
				ENDIF
				
				dirList.infoStart().destroy()
			ENDWHILE
			END dirList
		ELSE
			IF funcDirFailure
				IF funcDirFailure(dirPath, ioErr) = FALSE THEN RETURN
			ENDIF
		ENDIF
		
		scanList.infoStart().destroy()
	ENDWHILE IF CtrlC()
	
	IF scanList.infoIsEmpty() = FALSE
		dirPath := scanList.infoStart().read()
		IF funcDirAbort THEN funcDirAbort(dirPath) ELSE Raise("BRK")
	ENDIF
FINALLY
	END scanList, dirList
	END path
ENDPROC

/*****************************/

->delete dir & everything it contains, including sub-directories
PROC deleteDirTree(dirPath:ARRAY OF CHAR, force=FALSE:BOOL) RETURNS success:BOOL
	DEF dirList:OWNS PTR TO cMegaList_STRING, path:OWNS STRING, name:STRING
	
	success := TRUE
	
	IF force THEN SetProtection(dirPath, 0)		->do this before attempting to scan or modify dir's contents
	
	IF dirList := scanDir(dirPath, NIL)
		WHILE dirList.infoIsEmpty() = FALSE
			name := dirList.infoStart().read()
			path := strJoinPart(dirPath, name)
			
			IF fastIsFile(name)
				IF force THEN SetProtection(path, 0)
				IF DeleteFile(path) = FALSE THEN success := FALSE
				
			ELSE IF fastIsLink(name) = 0
				IF deleteDirTree(path, force) = FALSE THEN success := FALSE
			ELSE
				SetStr(path, EstrLen(path)-1)	->strip trailing /
				IF force THEN SetProtection(path, 0)
				IF DeleteFile(path) = FALSE THEN success := FALSE
			ENDIF
			
			END path
			dirList.infoStart().destroy()
		ENDWHILE
	ENDIF
	
	IF DeleteFile(dirPath) = FALSE THEN success := FALSE
FINALLY
	END dirList, path
ENDPROC
