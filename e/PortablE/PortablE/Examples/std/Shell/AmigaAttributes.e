/* AmigaAttributes.e 03-09-2012 by Christopher Steven Handley.
*/
/*
	This program can backup & restore Amiga protection flags, comments & hard/soft links.
*/

/* TO DO:
 - Maybe a Scan mode?
*/

OPT POINTER
MODULE 'std/pShellParameters', 'std/pShell', 'std/cPath'
MODULE 'CSH/pAmigaDos', 'dos', 'dos/dos'

/* Executable's AmigaOS-standard version string */
STATIC version_string = '\0$VER: AmigaAttributes 18-02-2012 - By Chris S Handley'

/* Shell arguments definition */
STATIC shellArgs = 'Folder/A, Backup/S, Restore/S, List/S, OnlyLinks/S, DeleteLinks/S, Quiet/S'
->index:            0         1         2          3       4            5              6

STATIC AmigaAttributesStoreName = 'AmigaAttributesBackup'

CONST DEBUG = FALSE

PROC main() RETURNS ret
	DEF hostFolder:ARRAY OF CHAR, folder:OWNS STRING, optBackup:BOOL, optRestore:BOOL, optList:BOOL, optDeleteLinks:BOOL
	DEF streamPath:OWNS STRING
	
	->parse parameters
	IF ParseParams(shellArgs) = FALSE THEN Raise("ARGS")
	hostFolder  := GetParam(0)
	optBackup      := GetParam(1) <> NILA
	optRestore     := GetParam(2) <> NILA
	optList        := GetParam(3) <> NILA
	optOnlyLinks   := GetParam(4) <> NILA
	optDeleteLinks := GetParam(5) <> NILA
	optQuiet       := GetParam(6) <> NILA
	
	->sanity check parameters
	->IF StrLen(hostFolder) = 0  THEN Throw("ARGS", 'Folder parameter is empty')
	IF      optBackup AND optRestore THEN Throw("ARGS", 'Cannot Backup & Restore at the same time!')
	IF optDeleteLinks AND optRestore THEN Throw("ARGS", 'Cannot DeleteLinks & Restore at the same time!')
	IF optBackup OR optRestore OR optList OR optDeleteLinks = FALSE THEN Throw("ARGS", 'Did not specify Backup or Restore or List or DeleteLinks')
	
	->perform request
	NEW stream.new(), file.new(), dir.new()
	
	folder := ImportDirPath(hostFolder)
	streamPath := StrJoin(folder, AmigaAttributesStoreName)
	IF optBackup
		DeletePath(streamPath)
		IF stream.open(streamPath, FALSE) = FALSE THEN errorPath(stream, streamPath, 'open')	->readOnly=FALSE
		stream.setSize(0)
		writeStreamVALUE(2)	->streamVersion
		
		baseFolder := folder
		RecurseDir(folder, funcStoreFileAttr, funcStoreDirAttr)
		
		stream.close()
		Print('Finished backing-up Amiga \s for folder "\s".\n', IF optOnlyLinks THEN 'links' ELSE 'attributes/links', hostFolder)
	ENDIF
	IF optList
		IF stream.open(streamPath, TRUE) = FALSE THEN errorPath(stream, streamPath, 'open')		->readOnly=TRUE
		
		baseFolder := folder
		list()
		
		stream.close()
		Print('Finished listing the backup for folder "\s".\n', hostFolder)
	ENDIF
	IF optDeleteLinks
		IF stream.open(streamPath, TRUE) = FALSE THEN errorPath(stream, streamPath, 'open')		->readOnly=TRUE
		
		baseFolder := folder
		deleteLinks()
		
		stream.close()
		Print('Finished deleting links for folder "\s".\n', hostFolder)
	ENDIF
	IF optRestore
		IF stream.open(streamPath, TRUE) = FALSE THEN errorPath(stream, streamPath, 'open')		->readOnly=TRUE
		
		baseFolder := folder
		restoreFileAttrs()
		
		stream.close()
		Print('Finished restoring Amiga \s for folder "\s".\n', IF optOnlyLinks THEN 'links' ELSE 'attributes/links', hostFolder)
	ENDIF
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
	CASE "FILE"
		Print('ERROR:  Fatal file/dir error \s\n', IF exceptionInfo THEN exceptionInfo ELSE '')
		ret := SHELL_RET_FAIL
	DEFAULT
		PrintException()
		ret := SHELL_RET_FAIL
	ENDSELECT
	
	END stream, file, dir
	
	END folder
	END streamPath
ENDPROC

PROC errorPath(file:PTR TO cPath, path:ARRAY OF CHAR, action:ARRAY OF CHAR)
	DEF hostPath:OWNS STRING
	
	hostPath := ExportPath(path)
	Print('ERROR:  Failed to \s the \s "\s" because of \s in \s.\n', action, IF IsFile(path) THEN 'file' ELSE 'dir', hostPath, file.infoFailureReason(), file.infoFailureOrigin())
	Raise("FILE")
FINALLY
	END hostPath
ENDPROC

PROC warnPath(file:PTR TO cPath, path:ARRAY OF CHAR, action:ARRAY OF CHAR)
	DEF hostPath:OWNS STRING
	
	hostPath := ExportPath(path)
	Print('WARNING:  Failed to \s the \s "\s" because of \s in \s.\n', action, IF IsFile(path) THEN 'file' ELSE 'dir', hostPath, file.infoFailureReason(), file.infoFailureOrigin())
FINALLY
	END hostPath
ENDPROC

/*****************************/

DEF stream:OWNS PTR TO cFile, file:OWNS PTR TO cHostFile, dir:OWNS PTR TO cHostDir	->Host classes used to reduce overhead

PROC writeStream(buffer:ARRAY, lengthInBytes) IS stream.setPosition(stream.write(buffer, lengthInBytes))
PROC  readStream(buffer:ARRAY, lengthInBytes) IS stream.setPosition(stream. read(buffer, lengthInBytes))

PROC writeStreamVALUE(value)
	DEF buffer[1]:ARRAY OF LONG
	
	buffer[0] := EndianSwapLONG(value!!LONG)
	writeStream(buffer, SIZEOF LONG)
ENDPROC

PROC readStreamVALUE() RETURNS value
	DEF buffer[1]:ARRAY OF LONG
	
	readStream(buffer, SIZEOF LONG)
	value := EndianSwapLONG(buffer[0])
ENDPROC

PROC writeStreamString(string:ARRAY OF CHAR)
	DEF len
	
	writeStreamVALUE(len := StrLen(string))
	writeStream(string, len * SIZEOF CHAR)
ENDPROC

PROC readStreamString() RETURNS string:OWNS STRING
	DEF len
	
	NEW string[len := readStreamVALUE()]
	readStream(string, len * SIZEOF CHAR)
	SetStr(string, len)
ENDPROC

/*****************************/

FUNC funcStoreFileAttr(filePath:STRING) OF funcRecurseFile
	storeFileAttr(filePath, file)
ENDFUNC

FUNC funcStoreDirAttr(dirPath:STRING) OF funcRecurseDir RETURNS scanDir:BOOL
	scanDir := NOT storeFileAttr(dirPath, dir)
ENDFUNC

/*****************************/

DEF baseFolder:STRING, optQuiet:BOOL, optOnlyLinks:BOOL

PROC storeFileAttr(path:STRING, fileDir:PTR TO cPath) RETURNS isLink:BOOL
	DEF attr, prot, comment:ARRAY OF CHAR, link:STRING, linkIsSoft:BOOL, save:BOOL
	DEF relPath:OWNS STRING, temp:OWNS STRING
	
	isLink := FALSE
	
	NEW relPath[EstrLen(path) - EstrLen(baseFolder)]
	StrCopy(relPath, path, ALL, EstrLen(baseFolder))
	
	IF StrCmpNoCase(relPath, AmigaAttributesStoreName) THEN RETURN
	
	IF fileDir.open(path, TRUE) = FALSE		->readOnly=TRUE
		warnPath(fileDir, path, 'open')
		RETURN TRUE
	ENDIF
	
	attr    := fileDir.getAttributes()
	prot    := fileDir.queryExtra("ATTR")
	comment := fileDir.queryExtra("COMM") !!ARRAY OF CHAR ; IF comment = NILA THEN comment := ''
	IF link := fileDir.queryExtra("SLNK") !!STRING
		linkIsSoft := TRUE
	ELSE IF link := fileDir.queryExtra("HLNK") !!STRING
		linkIsSoft := FALSE
	ENDIF
	
	IF link
		save := TRUE
		IF DEBUG THEN Print('DEBUG: File "\s" has \s link to "\s".\n', relPath, IF linkIsSoft THEN 'soft' ELSE 'hard', link)
		
	ELSE IF attr AND CPA_HIDE
		save := TRUE
		
	ELSE IF prot AND (FIBF_SCRIPT OR FIBF_PURE OR FIBF_ARCHIVE)
		save := TRUE
		
	ELSE IF (prot AND FIBF_EXECUTE = 0) = FastIsFile(relPath)	->checks if Execute flag is set for files or cleared for dirs
		save := TRUE
		
	ELSE IF StrLen(comment) > 0
		save := TRUE
	ELSE
		save := FALSE
	ENDIF
	
	IF save
		IF (link <> NILS) OR NOT optOnlyLinks
			writeStreamString(relPath)
			writeStreamVALUE(link <> NILS)
			IF link
				IF optQuiet = FALSE THEN Print('Backed-up link for "\s"\n', temp := ExportPath(relPath)) ; END temp
				writeStreamString(link)
				writeStreamVALUE( linkIsSoft)
			ELSE
				IF optQuiet = FALSE THEN Print('Backed-up attributes of "\s"\n', temp := ExportPath(relPath)) ; END temp
				writeStreamVALUE(attr)
				writeStreamVALUE(prot)
				writeStreamString(comment)
			ENDIF
		ENDIF
	ENDIF
	
	fileDir.close()
	isLink := (link <> NILS)
FINALLY
	END relPath, temp
ENDPROC

PROC restoreFileAttrs()
	DEF streamSize:BIGVALUE, streamVersion
	DEF relPath:OWNS STRING, attr, prot, comment:OWNS STRING, link:OWNS STRING, linkIsSoft:BOOL, hostLink:OWNS STRING
	DEF path:OWNS STRING, fileDir:PTR TO cPath
	DEF hostPath:OWNS STRING, lock:BPTR, success:BOOL
	DEF cdLock:BPTR, temp:OWNS STRING
	
	cdLock := NIL
	
	streamVersion := readStreamVALUE()
	streamSize := stream.getSize()
	WHILE stream.getPosition() < streamSize
		relPath := readStreamString()
		IF readStreamVALUE()	->is link
			link       := readStreamString()
			linkIsSoft := readStreamVALUE() <> FALSE
linkIsSoft := TRUE	->###
		ELSE
			attr    := readStreamVALUE()
			prot    := readStreamVALUE()
			comment := readStreamString()
		ENDIF
		
		END hostLink
		IF link
			IF streamVersion >= 2
				hostLink := ExportPath(link)
			ELSE
				hostLink := PASS link
				link := ImportFilePath(hostLink)	->assumes the link is a file, which doesn't matter with the current cPath implementation
			ENDIF
		ENDIF
		
		NEW path[EstrLen(baseFolder) + EstrLen(relPath)]
		StrCopy(path, baseFolder)
		StrAdd( path, relPath)
		
		IF link
			IF DEBUG THEN Print('DEBUG: File "\s" has \s link to "\s".\n', temp := ExportPath(relPath), IF linkIsSoft THEN 'soft' ELSE 'hard', hostLink) ; END temp
			
			temp := ExtractSubPath(path)
			hostPath := ExportPath(temp) ; END temp
			IF lock := Lock(hostPath, SHARED_LOCK) ; END hostPath
				cdLock := CurrentDir(lock)
				
				IF ExistsPath(path, /*fileOrDir*/ TRUE) THEN DeletePath(path, FALSE, /*fileOrDir*/ TRUE)
				
				success := CreateLink(FindName(path), link, IF linkIsSoft THEN "SLNK" ELSE "HLNK")
				
				UnLock(CurrentDir(cdLock)) ; cdLock := NIL
			ELSE
				success := FALSE
			ENDIF
			IF success
				IF optQuiet = FALSE THEN Print('Restored link for "\s"\n', temp := ExportPath(relPath)) ; END temp
			ELSE
				Print('WARNING:  Failed to create \s link from \s "\s" to "\s".\n', IF linkIsSoft THEN 'soft' ELSE 'hard', IF IsFile(path) THEN 'file' ELSE 'dir', temp := ExportPath(relPath), hostLink) ; END temp
			ENDIF
			
		ELSE IF optOnlyLinks = FALSE
			fileDir := IF IsFile(relPath) THEN file ELSE dir
			IF ExistsPath(path) = FALSE
				Print('WARNING:  Missing \s "\s".\n', IF IsFile(path) THEN 'file' ELSE 'dir', temp := ExportPath(relPath)) ; END temp
				
			ELSE IF fileDir.open(path) = FALSE
				warnPath(fileDir, path, 'open')
			ELSE
				IF fileDir.setAttributes(attr)          = FALSE THEN warnPath(fileDir, path, 'set attribute flags of')
				IF fileDir.changeExtra("ATTR", prot)    = FALSE THEN warnPath(fileDir, path, 'set protection flags of')
				IF fileDir.changeExtra("COMM", comment) = FALSE THEN warnPath(fileDir, path, 'set comment of')
				fileDir.close()
			ENDIF
		ENDIF
		
		END relPath, comment, link, path, hostPath
	ENDWHILE
FINALLY
	IF cdLock THEN UnLock(CurrentDir(cdLock))
	
	END relPath, comment, link, hostLink
	END path
	END hostPath
	END temp
ENDPROC

PROC deleteLinks()
	DEF streamSize:BIGVALUE, streamVersion
	DEF relPath:OWNS STRING, link:OWNS STRING, linkIsSoft:BOOL
	DEF path:OWNS STRING, temp:OWNS STRING
	
	streamVersion := readStreamVALUE()
	streamSize := stream.getSize()
	WHILE stream.getPosition() < streamSize
		relPath := readStreamString()
		IF readStreamVALUE()
			link       := readStreamString()
			linkIsSoft := readStreamVALUE() <> FALSE
		ELSE
			readStreamVALUE()
			readStreamVALUE()
			temp := readStreamString() ; END temp
		ENDIF
		
		NEW path[EstrLen(baseFolder) + EstrLen(relPath)]
		StrCopy(path, baseFolder)
		StrAdd( path, relPath)
		
		IF link
			IF ExistsPath(path, /*fileOrDir*/ TRUE)
				IF DeletePath(path, FALSE, /*fileOrDir*/ TRUE) = FALSE THEN Print('WARNING:  Failed to delete "\s".\n', temp := ExportPath(relPath)) ; END temp
			ENDIF
		ENDIF
		
		END relPath, link, path
	ENDWHILE
FINALLY
	END relPath, link
	END path, temp
ENDPROC

PROC list()
	DEF streamSize:BIGVALUE, streamVersion
	DEF relPath:OWNS STRING, attr, prot, comment:OWNS STRING, link:OWNS STRING, linkIsSoft:BOOL, hostLink:OWNS STRING
	DEF path:OWNS STRING, temp:OWNS STRING
	
->Print('#1\n')->###
	streamVersion := readStreamVALUE()
	streamSize := stream.getSize()
	WHILE stream.getPosition() < streamSize
->Print('#2\n')
		relPath := readStreamString()
->Print('#3\n')
		IF readStreamVALUE()
			link       := readStreamString()
			linkIsSoft := readStreamVALUE() <> FALSE
		ELSE
			attr    := readStreamVALUE()
			prot    := readStreamVALUE()
			comment := readStreamString()
		ENDIF
		
		END hostLink
		IF link
			IF streamVersion >= 2
				hostLink := ExportPath(link)
			ELSE
				hostLink := PASS link
				link := ImportFilePath(hostLink)	->assumes the link is a file, which doesn't matter with the current cPath implementation
			ENDIF
		ENDIF
		
->Print('#4\n')
		NEW path[EstrLen(baseFolder) + EstrLen(relPath)]
		StrCopy(path, baseFolder)
		StrAdd( path, relPath)
		
->Print('#5\n')
		IF link
->Print('#6\n')
			Print('\s "\s" had \s link to "\s".\n', IF FastIsFile(relPath) THEN 'File' ELSE 'Dir ', temp := ExportPath(relPath), IF linkIsSoft THEN 'soft' ELSE 'hard', hostLink) ; END temp
			
		ELSE IF optOnlyLinks = FALSE
->Print('#7\n')
			Print('\s "\s" had backed-up flags/comment stored.\n', IF FastIsFile(relPath) THEN 'File' ELSE 'Dir ', temp := ExportPath(relPath)) ; END temp
		ENDIF
		
->Print('#8\n')
		END relPath, comment, link, path
->Print('#9\n')
	ENDWHILE
FINALLY
	END relPath, comment, link, hostLink
	END path, temp
ENDPROC
