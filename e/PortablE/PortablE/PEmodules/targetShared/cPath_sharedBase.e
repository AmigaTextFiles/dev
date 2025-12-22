/* cPath_sharedBase.e 05-08-2022
	Abstract classes & procedures/methods for portable file & dir access.


Copyright (c) 2007,2008,2009,2012,2013,2022 Christopher Steven Handley ( http://cshandley.co.uk/email )
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* The source code must not be modified after it has been translated or converted
away from the PortablE programming language.  For clarification, the intention
is that all development of the source code must be done using the PortablE
programming language (as defined by Christopher Steven Handley).

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

->Basically completed 03-01-09, restarted 15-11-08, stopped 10-11-07, started 07-11-07.

OPT POINTER, INLINE
MODULE 'target/std/pTime'

PROC new()
	->for makeUniqueName() & makeUniquePath()
	cPath_randomSeed := CurrentTime(/*zone0local1utc2quick*/ 2)!!VALUE
ENDPROC

/*****************************/ ->path procedures
->returns whether the supplied path is for a file
PROC IsFile(path:ARRAY OF CHAR) IS (path[StrLen(path)-1] <> "/") AND (path[0] <> 0)	->isFile:BOOL

->returns whether the supplied path is for a directory
PROC IsDir( path:ARRAY OF CHAR) IS (path[StrLen(path)-1] = "/") OR (path[0] = 0)	->isDir:BOOL

->returns whether the supplied path is for a file
PROC FastIsFile(path:STRING) IS (path[EstrLen(path)-1] <> "/") AND (path[0] <> 0)	->isFile:BOOL

->returns whether the supplied path is for a directory
PROC FastIsDir( path:STRING) IS (path[EstrLen(path)-1] = "/") OR (path[0] = 0)		->isDir:BOOL

->checks the filepath is valid
PROC InvalidFilePath(filePath:ARRAY OF CHAR) RETURNS invalid:BOOL
	DEF len, pos
	
	->use check
	IF filePath = NILA THEN Throw("EPU", 'cPath; InvalidFilePath(); filePath=NILA')
	
	invalid := FALSE
	len := StrLen(filePath)
	IF len = 0
		invalid := TRUE
		
	ELSE IF filePath[len-1] = "/"
		invalid := TRUE
	ELSE
		pos := InStr(filePath, ':')
		IF pos <> -1
			IF filePath[pos+1] <> "/"
				invalid := TRUE
			ENDIF
		ENDIF
	ENDIF
ENDPROC

->checks the dirpath is valid
PROC InvalidDirPath(dirPath:ARRAY OF CHAR) RETURNS invalid:BOOL
	DEF len, pos
	
	->use check
	IF dirPath = NILA THEN Throw("EPU", 'cPath; InvalidDirPath(); dirPath=NILA')
	
	invalid := FALSE
	len := StrLen(dirPath)
	IF len = 0
		invalid := FALSE
		
	ELSE IF dirPath[len-1] <> "/"
		invalid := TRUE
	ELSE
		pos := InStr(dirPath, ':')
		IF pos <> -1
			IF dirPath[pos+1] <> "/"
				invalid := TRUE
			ENDIF
		ENDIF
	ENDIF
ENDPROC

->checks the filename is valid
PROC InvalidFileName(fileName:ARRAY OF CHAR) RETURNS invalid:BOOL
	
	->use check
	IF fileName = NILA THEN Throw("EPU", 'cPath; InvalidFileName(); fileName=NILA')
	
	invalid := FALSE
	IF StrLen(fileName) = 0
		invalid := TRUE
		
	ELSE IF (InStr(fileName,'/')<>-1) OR (InStr(fileName,':')<>-1)
		invalid := TRUE
	ENDIF
ENDPROC

->checks the dirname is valid
PROC InvalidDirName(dirName:ARRAY OF CHAR) RETURNS invalid:BOOL
	DEF matchpos, dirNameLength
	
	->use check
	IF dirName = NILA THEN Throw("EPU", 'cPath; InvalidDirName(); dirName=NILA')
	
	dirNameLength := StrLen(dirName)
	
	invalid := FALSE
	IF dirNameLength = 0
		invalid := TRUE
		
	ELSE IF InStr(dirName,':') <> -1
		invalid := TRUE
	ELSE
		matchpos := InStr(dirName, '/')
		IF (matchpos <> -1) AND (matchpos < (dirNameLength - 1))
			invalid := TRUE
		ENDIF
	ENDIF
ENDPROC

->like StrCmp() but with case-sensitivity appropriate for the host OS
PROC StrCmpPath(path1:ARRAY OF CHAR, path2:ARRAY OF CHAR, len=ALL, firstOffset=0, secondOffset=0) RETURNS match:BOOL PROTOTYPE IS EMPTY

->like OstrCmp() but with case-sensitivity appropriate for the host OS
PROC OstrCmpPath(path1:ARRAY OF CHAR, path2:ARRAY OF CHAR, max=ALL, firstOffset=0, secondOffset=0) RETURNS sign:RANGE -1 TO 1 PROTOTYPE IS EMPTY

->returns the file/dir name ending a path
PROC FindName(path:ARRAY OF CHAR) RETURNS name:ARRAY OF CHAR, nameLength
	DEF index
	
	->use check
	IF path = NILA THEN Throw("EPU", 'cPath; FindName(); path=NILA')
	
	nameLength := 1
	index := StrLen(path) - nameLength
	IF path[index] = "/"
		->(path is a dir) so skip to beginning (end) of it's name
		index--
		nameLength++
	ENDIF
	WHILE (path[index] <> "/") AND (index > 0)
		index--
		nameLength++
	ENDWHILE
	
	IF path[index] = "/"
		index++
		nameLength--
	ENDIF
	
	name := path!!PTR TO CHAR + (index*SIZEOF CHAR) !!ARRAY OF CHAR
ENDPROC

->extracts the file/dir name ending a path
PROC ExtractName(path:ARRAY OF CHAR) RETURNS name:OWNS STRING
	DEF oldName:ARRAY OF CHAR, nameLength
	
	oldName, nameLength := FindName(path)
	
	name := NewString(nameLength)
	StrCopy(name, oldName)
ENDPROC

->returns the dirpath of the root dir of the device, for a given path
->NOTE: If the given path does not mention a device, then the returned dirpath will be empty.
PROC ExtractDevice(path:ARRAY OF CHAR) RETURNS devicePath:OWNS STRING
	DEF colonPos
	
	->use check
	IF path = NILA THEN Throw("EPU", 'cPath; ExtractDevice(); path=NILA')
	
	colonPos := InStr(path, ':/')
	IF colonPos = -1
		->(no device present in path)
		devicePath := NewString(1)
	ELSE
		->(device found in path)
		devicePath := NewString(colonPos + 2)
		StrCopy(devicePath, path, colonPos + 1)
		StrAdd( devicePath, '/')
	ENDIF
ENDPROC

->returns the subpath of the given path; i.e. removes any file/dir name
->NOTE: If the given path does not mention a dir, then the returned subpath will be empty.
PROC ExtractSubPath(path:ARRAY OF CHAR) RETURNS subPath:OWNS STRING
	DEF index
	
	->use check
	IF path = NIL THEN Throw("EPU", 'cPath; ExtractSubPath(); path=NIL')
	
	index := StrLen(path) - 2
	WHILE (path[index] <> "/") AND (index >= 0)
		index--
	ENDWHILE
	
	IF index >= 0
		subPath := NewString(index+1)
		StrCopy(subPath, path)
	ELSE
		subPath := NewString(1)
	ENDIF
ENDPROC

PRIVATE
DEF cPath_randomSeed=123
PUBLIC

->creates a file/dir path which does not exist
->NOTE: For file1dir2, supply 1 for a file path, or 2 for a dir path.
->NOTE: If base is not specified then it will default to 'TMP'.
PROC MakeUniquePath(file1dir2, dirPath:ARRAY OF CHAR, base=NILA:ARRAY OF CHAR) RETURNS newPath:OWNS STRING
	DEF format:ARRAY OF CHAR, retries
	
	->use check
	IF (file1dir2 < 1) OR (file1dir2 > 2) THEN Throw("EMU", 'cPath; MakeUniquePath(); file1dir2 <> 1 or 2')
	
	IF base = NILS THEN base := 'TMP'
	format := IF file1dir2 = 1 THEN '\s\s\h' ELSE '\s\s\h/'
	NEW newPath[StrLen(dirPath) + StrLen(base) + 8 + 1]
	
	retries := 0
	REPEAT
		IF ++retries > 999 THEN Throw("BUG", 'cPath; MakeUniquePath(); retry limit exceeded, possibly due to a buggy filing system')
		
		cPath_randomSeed := RndQ(cPath_randomSeed)
		StringF(newPath, format, dirPath, base, cPath_randomSeed)
	UNTIL ExistsPath(newPath, TRUE) = FALSE
FINALLY
	IF exception THEN END newPath
ENDPROC


PROC CurrentDirPath() RETURNS dirPath:OWNS STRING PROTOTYPE IS EMPTY

PROC DeletePath(path:ARRAY OF CHAR, force=FALSE:BOOL, fileOrDir=FALSE:BOOL) RETURNS success:BOOL PROTOTYPE IS EMPTY

PROC ExistsPath(path:ARRAY OF CHAR, fileOrDir=FALSE:BOOL) RETURNS exists:BOOL PROTOTYPE IS EMPTY

PROC RenamePath(origPath:ARRAY OF CHAR, newPath:ARRAY OF CHAR, force=FALSE:BOOL) RETURNS success:BOOL PROTOTYPE IS EMPTY

PROC CreateLink(path:ARRAY OF CHAR, targetPath:ARRAY OF CHAR, specific:QUAD) RETURNS success:BOOL, unknown:BOOL PROTOTYPE IS EMPTY

PROC ReadLink(path:ARRAY OF CHAR) RETURNS targetPath:OWNS STRING, specific:QUAD PROTOTYPE IS EMPTY

PROC ImportDirPath(hostDirPath:ARRAY OF CHAR) RETURNS dirPath:OWNS STRING PROTOTYPE IS EMPTY

PROC ImportFilePath(hostFilePath:ARRAY OF CHAR) RETURNS filePath:OWNS STRING PROTOTYPE IS EMPTY

PROC ExportPath(path:ARRAY OF CHAR) RETURNS hostPath:OWNS STRING PROTOTYPE IS EMPTY

PROC ExpandPath(path:ARRAY OF CHAR) RETURNS expandedPath:OWNS STRING PROTOTYPE IS EMPTY


->Only present for backwards-compatibility!
PROC Delete(path:ARRAY OF CHAR, force=FALSE:BOOL, fileOrDir=FALSE:BOOL) RETURNS success:BOOL IS DeletePath(path, force, fileOrDir)

->Only present for backwards-compatibility!
PROC Exists(path:ARRAY OF CHAR, fileOrDir=FALSE:BOOL) RETURNS exists:BOOL IS ExistsPath(path, fileOrDir)

/*****************************/ ->cExtra class is the abstract interface
CLASS cExtra ABSTRACT
ENDCLASS
PROC setExtra(extra:PTR TO cExtra) OF cExtra RETURNS success:BOOL IS EMPTY
PROC getExtra() OF cExtra RETURNS extra:OWNS PTR TO cExtra IS EMPTY
PROC changeExtra(specific:QUAD, value) OF cExtra RETURNS success:BOOL, unknown:BOOL IS EMPTY
PROC queryExtra(specific:QUAD) OF cExtra RETURNS value, unknown:BOOL IS EMPTY


/*****************************/ ->cPath class is the shared file/dir abstract interface
CLASS cPath ABSTRACT OF cExtra
	failureOrigin:ARRAY OF CHAR
	failureReason:ARRAY OF CHAR
	readOnly:BOOL
ENDCLASS
PROC open(path:ARRAY OF CHAR, readOnly=FALSE:BOOL, forceOpen=FALSE:BOOL) OF cPath RETURNS success:BOOL IS EMPTY
PROC create(path:ARRAY OF CHAR, doNotReplace=FALSE:BOOL, forceOpen=FALSE:BOOL) OF cPath RETURNS success:BOOL
	IF doNotReplace = FALSE
		DeletePath(path, /*force*/ forceOpen, /*fileOrDir*/ forceOpen)
		success := self.open(path, FALSE, forceOpen)
		
	ELSE IF ExistsPath(path)
		->(already exists but doNotReplace=TRUE)
		success := FALSE
	ELSE
		success := self.open(path, FALSE, forceOpen)
		IF success = FALSE THEN DeletePath(path, /*force*/ forceOpen, /*fileOrDir*/ forceOpen)
	ENDIF
ENDPROC
PROC close() OF cPath IS EMPTY
PROC flush() OF cPath IS EMPTY
PROC sleep() OF cPath IS EMPTY
PROC make() OF cPath RETURNS object:OWNS PTR TO cPath IS EMPTY
PROC clone(writeNotRead=FALSE:BOOL) OF cPath RETURNS clone:OWNS PTR TO cPath IS EMPTY
PROC infoFailureOrigin() OF cPath RETURNS origin:ARRAY OF CHAR IS self.failureOrigin
PROC infoFailureReason() OF cPath RETURNS reason:ARRAY OF CHAR IS self.failureReason
PROC infoReadOnly() OF cPath RETURNS readOnly:BOOL IS self.readOnly
PROC infoIsOpen() OF cPath RETURNS isOpen:BOOL IS EMPTY
PROC setAttributes(attr, mask=-1) OF cPath RETURNS success:BOOL IS EMPTY
PROC getAttributes() OF cPath RETURNS attr IS EMPTY
PROC getAttributesSupported() OF cPath RETURNS mask IS EMPTY
PROC setPath(path:ARRAY OF CHAR) OF cPath RETURNS success:BOOL IS EMPTY
PROC getPath() OF cPath RETURNS path:ARRAY OF CHAR IS EMPTY

->changes the subpath (moves the file to a new path)
PROC setSubPath(path:ARRAY OF CHAR) OF cPath RETURNS success:BOOL
	DEF fileName:ARRAY OF CHAR, fileNameLength
	DEF newFilePath:OWNS STRING, newFilePathLength
	
	success := TRUE
	
	->use check
	IF path = NILA THEN Throw("EMU", 'cPath.setSubPath(); path=NILA')
	
	->find start of old name in current filepath
	fileName, fileNameLength := FindName(self.getPath())
	
 	->generate filepath with new path
	newFilePathLength := StrLen(path) + fileNameLength
	NEW newFilePath[newFilePathLength]
	StrCopy(newFilePath, path)
	StrAdd( newFilePath, fileName)
	
	->perform move
	success := self.setPath(newFilePath)
FINALLY
	END newFilePath
	
	IF success = FALSE
		self.failureOrigin := 'cPath.setSubPath()'
	ENDIF
ENDPROC

->returns the getpath (no filename)
PROC getSubPath() OF cPath RETURNS path:OWNS STRING IS ExtractSubPath(self.getPath())

->changes the filename (renames the file)
PROC setName(newFileName:ARRAY OF CHAR) OF cPath RETURNS success:BOOL
	DEF newFileNameLength
	DEF fileName:ARRAY OF CHAR, fileNameLength
	DEF    filePath:ARRAY OF CHAR,  filePathLength
	DEF newFilePath:OWNS STRING, newFilePathLength
	
	success := TRUE
	
	->use check
	IF newFileName = NILA THEN Throw("EMU", 'cPath.setName(); newFileName=NILA')
	
	->set-up
	newFileNameLength := StrLen(newFileName)
	
	filePath := self.getPath()
	filePathLength := StrLen(filePath)
	
	->find start of old name in filepath
	fileName, fileNameLength := FindName(filePath)
	
	->generate filepath with new name
	newFilePathLength := filePathLength - fileNameLength + newFileNameLength
	NEW newFilePath[newFilePathLength]
	StrCopy(newFilePath, filePath, filePathLength - fileNameLength)
	StrAdd( newFilePath, newFileName)
	
	->perform rename
	success := self.setPath(newFilePath)
FINALLY
	END newFilePath
	
	IF success = FALSE
		self.failureOrigin := 'cPath.setName()'
	ENDIF
ENDPROC

->returns the filename (no path)
->NOTE: String is invalidated when file name/path is changed or file closed
PROC getName() OF cPath RETURNS name:ARRAY OF CHAR IS ExtractName(self.getPath())

->PROC setExtra(extra:PTR TO cExtra) OF cPath RETURNS success:BOOL IS EMPTY
->PROC getExtra() OF cPath RETURNS extra:OWNS PTR TO cExtra IS EMPTY
->PROC changeExtra(specific:QUAD, value) OF cPath RETURNS success:BOOL, unknown:BOOL IS EMPTY
->PROC queryExtra(specific:QUAD) OF cPath RETURNS value, unknown:BOOL IS EMPTY

->shared attribute flags
SET CPA_STRICT, CPA_READ, CPA_WRITE, CPA_DELETE, CPA_HIDE, 	CPA_UNUSED1, CPA_UNUSED2, CPA_UNUSED3, CPA_UNUSED4
