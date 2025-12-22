/* POSIX/cPath_Dir.e 15-10-2022
	POSIX-specific classes & procedures for portable file & dir access.
	Developed in 2009,2010,2011,2022 by Christopher Steven Handley.
	Basically completed 18-04-2009, started 15-04-09.
*/

OPT NATIVE, POINTER, INLINE, PREPROCESS
PUBLIC MODULE 'targetShared/cPath_DirBase'
MODULE 'targetShared/POSIX/cPath_shared'
MODULE 'target/sys/types', 'target/sys/stat', 'target/errno'
MODULE 'target/sys/time', 'target/time', 'target/utime'
MODULE 'target/fcntl', 'target/dirent'
MODULE 'target/unistd'	->POSIX (non-Windows) module

PRIVATE
CONST DEBUG = FALSE

->this is part of <stdio.h>, and theoretically also <io.h> under Windows.
PROC rename(oldName:ARRAY OF CHAR, newName:ARRAY OF CHAR) IS NATIVE {rename( (const char*)} oldName {, (const char*)} newName {)} ENDNATIVE !!VALUE

->throw an error rather than returning returning an error value
PROC safeSeek(fileDesc, position:BIGVALUE, from=SEEK_SET) RETURNS newPosition:BIGVALUE
	DEF seek
	
	SELECT SEEKMAX OF from
	CASE SEEK_SET ; seek := {SEEK_SET}!!VALUE
	CASE SEEK_END ; seek := {SEEK_END}!!VALUE
	CASE SEEK_CUR ; seek := {SEEK_CUR}!!VALUE
	DEFAULT ; Throw("EPU", 'cPath; safeSeek(); from has illegal value')
	ENDSELECT
	
	newPosition := lseek64(fileDesc, position, seek)
	IF newPosition = -1 THEN Throw("FILE", posixFailureReason('cPath; safeSeek(); lseek64() failed'))
ENDPROC

CONST POSIXFAULTBUFFERSIZE = 512
DEF posixFaultBuffer[POSIXFAULTBUFFERSIZE]:STRING

->return string describing reason for posix failure, appended with the supplied explanation
PROC posixFailureReason(explanation:ARRAY OF CHAR, param1=0, param2=0, param3=0) RETURNS reason:ARRAY OF CHAR
	IF errno
		StringF(posixFaultBuffer, explanation, param1, param2, param3)
		IF explanation
			StrAdd( posixFaultBuffer, ': ')
			StrAdd( posixFaultBuffer, describeErrNo())
		ENDIF
		reason := posixFaultBuffer
	ELSE
		reason := explanation
	ENDIF
ENDPROC 

PROC describeErrNo() RETURNS desc:ARRAY OF CHAR
	SELECT 128 OF errno
	CASE EPERM ; desc := 'Operation not permitted'
	CASE ENOENT ; desc := 'No such file or directory'
	CASE ESRCH ; desc := 'No such process'
	CASE EINTR ; desc := 'Interrupted function call'
	CASE EIO ; desc := 'Input/output error'
	CASE ENXIO ; desc := 'No such device or address'
	CASE E2BIG ; desc := 'Arg list too long'
	CASE ENOEXEC ; desc := 'Exec format error'
	CASE EBADF ; desc := 'Bad file descriptor'
	CASE ECHILD ; desc := 'No child processes'
	CASE EAGAIN ; desc := 'Resource temporarily unavailable'
	CASE ENOMEM ; desc := 'Not enough space'
	CASE EACCES ; desc := 'Permission denied'
	CASE EFAULT ; desc := 'Bad address'
	CASE EBUSY ; desc := 'strerror reports "Resource device"'
	CASE EEXIST ; desc := 'File exists'
	CASE EXDEV ; desc := 'Improper link (cross-device link?)'
	CASE ENODEV ; desc := 'No such device'
	CASE ENOTDIR ; desc := 'Not a directory'
	CASE EISDIR ; desc := 'Is a directory'
	CASE EINVAL ; desc := 'Invalid argument'
	CASE ENFILE ; desc := 'Too many open files in system'
	CASE EMFILE ; desc := 'Too many open files'
	CASE ENOTTY ; desc := 'Inappropriate I/O control operation'
	CASE EFBIG ; desc := 'File too large'
	CASE ENOSPC ; desc := 'No space left on device'
	CASE ESPIPE ; desc := 'Invalid seek (seek on a pipe?)'
	CASE EROFS ; desc := 'Read-only file system'
	CASE EMLINK ; desc := 'Too many links'
	CASE EPIPE ; desc := 'Broken pipe'
	CASE EDOM ; desc := 'Domain error (math functions)'
	CASE ERANGE ; desc := 'Result too large (possibly too small)'
	CASE EDEADLOCK ; desc := 'Resource deadlock avoided'
	CASE ENAMETOOLONG, 91 ; desc := 'Filename too long'
	CASE ENOLCK, 46 ; desc := 'No locks available'
	CASE ENOSYS, 88 ; desc := 'Function not implemented'
	CASE ENOTEMPTY, 90 ; desc := 'Directory not empty'
	CASE EILSEQ ; desc := 'Illegal byte sequence'
	DEFAULT ; desc := 'Unknown error'
	ENDSELECT
ENDPROC

PROC bigMax(a:BIGVALUE, b:BIGVALUE) IS IF a > b THEN a ELSE b
PROC bigMin(a:BIGVALUE, b:BIGVALUE) IS IF a < b THEN a ELSE b

PUBLIC


/*****************************/ ->cHostDir class has host OS implementation
CLASS cHostDir OF cBaseDir PRIVATE
	->failureOrigin:ARRAY OF CHAR
	->failureReason:ARRAY OF CHAR
	->readOnly:BOOL
	dirPath:OWNS STRING
	hostDirPath:OWNS STRING
	stat:_stat			->write-through cache of: mode bits
	dirp:PTR TO DIR
	forcedMode:MODE_T	->which mode bits had to be forced (set) to be opened
	linkPath:OWNS STRING	->path of link, if any, returned by queryExtra()
	linkIs0unknown1none2soft
ENDCLASS

PROC new() OF cHostDir
	self.failureOrigin := NILA
	self.failureReason := NILA
	self.readOnly := FALSE
	self.dirPath := NILS
	self.hostDirPath := NILS
	->self.stat
	self.dirp := NIL
	self.forcedMode := 0
	self.linkPath := NILS
ENDPROC

PROC end() OF cHostDir
	IF self.dirp THEN self.close()
	SUPER self.end()
ENDPROC

->opens a dir for use, creating it if necessary IF in write mode
->NOTE: Any previous dir must have been closed, or an error will be raised.
->NOTE: readOnly=TRUE prevents *any* changes to the dir.
PROC open(dirPath:ARRAY OF CHAR, readOnly=FALSE:BOOL, forceOpen=FALSE:BOOL) OF cHostDir RETURNS success:BOOL
	DEF alreadyExisted:BOOL
	
	success := TRUE
	alreadyExisted := TRUE
	
	->use check
	IF self.dirp THEN Throw("EMU", 'cHostDir.open(); a dir is already open')
	IF dirPath = NILA THEN Throw("EMU", 'cHostDir.open(); dirPath=NIL')
	IF InvalidDirPath(dirPath) THEN Throw("EMU", 'cHostDir.open(); dirPath is invalid')
	
	->store parameters
	self.failureOrigin := NILA
	self.failureReason := NILA
	self.readOnly := readOnly
	self.hostDirPath := ExportPath(dirPath)
	self.dirPath     := StrJoin(dirPath)
	self.forcedMode := 0
	self.linkPath := NILS
	self.linkIs0unknown1none2soft := 0
	
	alreadyExisted := access(self.hostDirPath, 0) <> -1
	
	->examine dir before opening, and deal with read/write protection
	IF alreadyExisted
		IF self.hostDirPath[EstrLen(self.hostDirPath) - 1] = ":"
			->(disk root)
			self.stat.mode := S_IRUSR OR S_IWUSR
		ELSE
			->(not disk root)
			IF stat(self.hostDirPath, self.stat) = -1
				self.failureReason := posixFailureReason('error examining dir')
				RETURN FALSE
			ENDIF
			
			IF self.stat.mode AND S_IRUSR = 0
				->(dir is read protected)
				IF forceOpen
					self.stat.mode := self.stat.mode OR S_IRUSR
					IF chmod(self.hostDirPath, self.stat.mode) = -1
						self.failureReason := posixFailureReason('could not remove read protection')
						RETURN FALSE
					ENDIF
					self.forcedMode := self.forcedMode OR S_IRUSR
				ELSE
					->'emulate' what POSIX cannot enforce - failure to open
					self.failureReason := 'no read permission'
					RETURN FALSE
				ENDIF
			ENDIF
			
			IF (readOnly = FALSE) AND (self.stat.mode AND S_IWUSR = 0)
				->(dir is write protected)
				IF forceOpen
					self.stat.mode := self.stat.mode OR S_IWUSR
					IF chmod(self.hostDirPath, self.stat.mode) = -1
						self.failureReason := posixFailureReason('could not remove write protection')
						RETURN FALSE
					ENDIF
					self.forcedMode := self.forcedMode OR S_IWUSR
				ELSE
					->'emulate' what POSIX cannot enforce - failure to open
					self.failureReason := 'no write permission'
					RETURN FALSE
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	
	->open dir as specified
	IF alreadyExisted = FALSE
		IF self.hostDirPath[EstrLen(self.hostDirPath) - 1] = ":"
			->(disk root)
			self.stat.mode := S_IRUSR OR S_IWUSR
		ELSE
			->(not disk root)
			IF readOnly
				self.failureReason := 'dir does not exist'
				RETURN FALSE
			ELSE
				IF _mkdir(self.hostDirPath, S_IRWXU #ifdef pe_TargetOS_Linux OR S_IRWXG OR (S_IROTH OR S_IXOTH) #endif) = -1
					self.failureReason := posixFailureReason('failed to create dir')
					RETURN FALSE
				ENDIF
			ENDIF
			
			IF stat(self.hostDirPath, self.stat) = -1
				self.failureReason := posixFailureReason('error examining dir')
				RETURN FALSE
			ENDIF
		ENDIF
	ENDIF
	
	self.dirp := opendir(self.hostDirPath)
	IF self.dirp = NIL
		self.failureReason := posixFailureReason('error opening dir')
		RETURN FALSE
	ENDIF
FINALLY
	IF (success = FALSE) OR exception
		->clean-up after a failure, returning the object & the dir itself to the state it had before open() was called
		IF self.dirp
			closedir(self.dirp)
			self.dirp := NIL
		ENDIF
		END self.hostDirPath
		IF self.dirPath
			IF alreadyExisted OR readOnly = FALSE THEN DeletePath(self.dirPath, TRUE)	->remove dir if it didn't exist before it was opened
			END self.dirPath
		ENDIF
	ENDIF
	
	IF success = FALSE
		self.failureOrigin := 'cHostDir.open()'
	ENDIF
ENDPROC

->close an open dir
PROC close() OF cHostDir
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.close(); dir not open')
	
	IF closedir(self.dirp) = -1 THEN Throw("EMU", 'cHostDir.close(); closing dir failed')
	self.dirp := NIL
	
	IF self.forcedMode
		->restore forced mode bits
		self.stat.mode := self.stat.mode AND NOT self.forcedMode
		chmod(self.hostDirPath, self.stat.mode)
	ENDIF
	
	END self.dirPath
	END self.hostDirPath
	
	END self.linkPath
ENDPROC

->flushes any caches used for the dir, whether they are provided by this class or the host OS
->NOTE: In write mode, ensures all changes are commited to disk, without needing to close() dir.
->NOTE: In read mode, refreshes any caches, ensuring any changes to dir will be seen.
PROC flush() OF cHostDir
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.flush(); dir not open')
	
	->refresh write-through cache (should not strictly be required in write mode)
	IF self.hostDirPath[EstrLen(self.hostDirPath) - 1] <> ":"
		->(not disk root)
		IF stat(self.hostDirPath, self.stat) = -1 THEN Throw("FILE", posixFailureReason('cHostDir.flush(); stat() failed'))
	ENDIF
	
	->flush cached link info
	END self.linkPath
	self.linkIs0unknown1none2soft := 0
ENDPROC

PROC make() OF cHostDir RETURNS object:OWNS PTR TO cHostDir
	NEW object
ENDPROC

->return clone of current object, with same dir open, but in read-only mode unless writeNotRead=TRUE
->NOTE: Will return clone=NIL if there is a problem.
PROC clone(writeNotRead=FALSE:BOOL) OF cHostDir RETURNS clone:OWNS PTR TO cHostDir
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.clone(); dir not open')
	
	clone := self.make()
	clone.new()
	IF (self.readOnly = FALSE) AND (writeNotRead = TRUE)
		->(opening two files in write mode) which is not allowed, so fail without trying
		END clone
		
	ELSE IF clone.open(self.dirPath, NOT writeNotRead) = FALSE
		->(failed to open file)
		END clone
	ELSE
		->success
	ENDIF
ENDPROC

->PROC infoReadOnly() OF cHostDir RETURNS readOnly:BOOL

PROC infoIsOpen() OF cHostDir RETURNS isOpen:BOOL IS self.dirp <> NIL

PRIVATE
PROC openKludgeBegin() OF cHostDir
/*
	IF self.dirp = NIL THEN Throw("BUG", 'cHostDir.openKludgeBegin(); kludge already started')
	
	IF closedir(self.dirp) = -1 THEN Throw("BUG", 'cHostDir.openKludgeBegin(); closedir() failed')
	self.dirp := NIL
*/
ENDPROC

PROC openKludgeFinish() OF cHostDir
IF (self.linkIs0unknown1none2soft < 2) AND (self.readOnly = FALSE) THEN _mkdir(self.hostDirPath, S_IRWXU #ifdef pe_TargetOS_Linux OR S_IRWXG OR (S_IROTH OR S_IXOTH) #endif)
/*
	IF self.dirp THEN Throw("BUG", 'cHostDir.openKludgeFinish(); kludge already finished')
	
	->undo kludge; re-opening of dir must match that in the open() method
	self.dirp := opendir(self.hostDirPath)
	IF (self.dirp = NIL) AND (self.readOnly = FALSE)
		IF _mkdir(self.hostDirPath, S_IRWXU #ifdef pe_TargetOS_Linux OR S_IRWXG OR (S_IROTH OR S_IXOTH) #endif) = 0
			self.dirp := opendir(self.hostDirPath)
		ENDIF
	ENDIF
	IF self.dirp = NIL
		END self.dirPath
		END self.hostDirPath
		Throw("BUG", 'cHostDir.openKludgeFinish(); kludge failed')
	ENDIF
*/
ENDPROC
PUBLIC

->changes the attributes in a flexible manner
PROC setAttributes(attr, mask=-1) OF cHostDir RETURNS success:BOOL
	DEF newAttr, mode:MODE_T
	
	success := TRUE
	
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.setAttributes(); dir not open')
	IF self.readOnly THEN Throw("EMU", 'cHostDir.setAttributes(); dir opened in read only mode')
	
	->calculate new attributes
	attr := attr AND mask		->clear any bits that the mask excludes (mistakes?)
	
	newAttr := self.getAttributes()
	newAttr := newAttr AND NOT mask		->clear any bits that will be changed; i.e. only copy bits that are not changing
	newAttr := newAttr OR attr			->add changed bits
	
	->change dir's mode bits according to new attributes
	mode := self.stat.mode AND NOT (S_IRUSR OR S_IWUSR)	->keep unsupported mode bits the same
	IF newAttr AND CPA_READ THEN mode := mode OR S_IRUSR
	IF attr AND CPA_STRICT = FALSE
		IF newAttr AND CPA_WRITE  THEN mode := mode OR S_IWUSR
		IF newAttr AND CPA_DELETE THEN mode := mode OR S_IWUSR
	ELSE
		IF newAttr AND (CPA_WRITE OR CPA_DELETE) THEN mode := mode OR S_IWUSR
	ENDIF
	
	->#might need? self.openKludgeBegin()
	IF chmod(self.hostDirPath, mode) = -1
		self.failureReason := posixFailureReason('error setting dir mode bits')
		RETURN FALSE
	ENDIF
	self.forcedMode := self.forcedMode AND NOT (mode XOR self.stat.mode)	->clear any bits that have been changed, so they will no-longer be restored
	self.stat.mode := mode
	
	->#might need? self.openKludgeFinish()
FINALLY
	IF success = FALSE
		self.failureOrigin := 'cHostDir.setAttributes()'
	ENDIF
ENDPROC

->returns the dir's attribute bit pattern
->NOTE: The OS's attributes are mapped as well as possible to the CPA_ set.
PROC getAttributes() OF cHostDir RETURNS attr
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.getAttributes(); dir not open')
	
	attr := 0
	IF self.stat.mode AND S_IRUSR THEN attr := attr OR CPA_READ
	IF self.stat.mode AND S_IWUSR THEN attr := attr OR CPA_WRITE OR CPA_DELETE
ENDPROC

->return what attributes are supported
->NOTE: a bit set to 1 indicate a supported attribute
PROC getAttributesSupported() OF cHostDir RETURNS mask
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.getAttributesSupported(); dir not open')
	
	mask := CPA_READ OR (CPA_WRITE OR CPA_DELETE)
ENDPROC

->changes the whole path (moving & renaming)
PROC setPath(path:ARRAY OF CHAR) OF cHostDir RETURNS success:BOOL
	DEF hostDirPath:OWNS STRING
	
	success := TRUE
	
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.setPath(); dir not open')
	IF self.readOnly THEN Throw("EMU", 'cHostDir.setPath(); dir opened in read only mode')
	IF path = NILA THEN Throw("EMU", 'cHostDir.setPath(); path=NILA')
	IF InvalidDirPath(path) THEN Throw("EMU", 'cHostDir.setPath(); path is invalid')
	
	->perform rename/move
	hostDirPath := ExportPath(path)
	->#might need? self.openKludgeBegin()
	IF rename(self.hostDirPath, hostDirPath) = -1
		self.failureReason := posixFailureReason('error renaming host dir')
		RETURN FALSE
	ENDIF
	
	->update internal dirpath
	END self.dirPath
	self.dirPath := StrJoin(path)
	
	END self.hostDirPath
	self.hostDirPath := PASS hostDirPath
	
	->#might need? self.openKludgeFinish()
FINALLY
	END hostDirPath
	
	IF success = FALSE
		self.failureOrigin := 'cHostDir.setPath()'
	ENDIF
ENDPROC

->returns the whole path
PROC getPath() OF cHostDir RETURNS path:ARRAY OF CHAR
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.getPath(); dir not open')
	
	path := self.dirPath
ENDPROC


->changes the info of a dir that is not changed by non-Extra methods of this class
->NOTE: The returned failure may only indicate a partial failure, if multiple
->      underlying OS elements are changed.
->NOTE: Will avoid setting stuff that is not supported in the place the extra originated 
->      from (this does NOT generate a failure).
->NOTE: May be passed extra=NIL; will do nothing.
PROC setExtra(extra:PTR TO cExtra) OF cHostDir RETURNS success:BOOL
	DEF value, unknown:BOOL
	
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.setExtra(); dir not open')
	IF self.readOnly THEN Throw("EMU", 'cHostDir.setExtra(); dir opened in read only mode')
	
	success := TRUE
	IF extra = NIL THEN RETURN
	
	value, unknown := extra.queryExtra("ATTR")
	IF unknown = FALSE THEN success := success AND self.changeExtra("ATTR", value)
	
	value, unknown := extra.queryExtra("SLNK")
	IF unknown = FALSE THEN success := success AND self.changeExtra("SLNK", value)
ENDPROC

->returns an object storing all the info of a dir that is not returned by non-Extra methods of this class
->NOTE: It returns NIL to indicate a failure.
PROC getExtra() OF cHostDir RETURNS extra:OWNS PTR TO cExtra
	DEF hostExtra:OWNS PTR TO cHostExtra
	
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.getExtra(); dir not open')
	
	NEW hostExtra.new()
	IF hostExtra.setExtra(self) = FALSE THEN END hostExtra
	RETURN hostExtra
ENDPROC

->changes an OS-specific element of the dir
->NOTE: Returns unknown=TRUE if the specified element is not supported by the host OS.
PROC changeExtra(specific:QUAD, value) OF cHostDir RETURNS success:BOOL, unknown:BOOL
	DEF mode:MODE_T, mask:MODE_T, newMode:MODE_T
#ifdef pe_TargetOS_Linux
	DEF linkType, linkPath:ARRAY OF CHAR, hostLinkPath:OWNS STRING, changesNeeded:BOOL
#endif
	
	success := TRUE
	
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.changeExtra(); dir not open')
	IF self.readOnly THEN Throw("EMU", 'cHostDir.changeExtra(); dir opened in read only mode')
	
#ifdef pe_TargetOS_Linux
	linkType := IF specific = "SLNK" THEN 2 ELSE /*IF specific = "HLNK" THEN 3 ELSE*/ 0
	IF linkType THEN specific := "link" ELSE IF specific = "link" THEN specific := 0
#endif
	
	unknown := FALSE
	SELECT specific
	CASE "ATTR"
		->calculate new mode
		mask := NOT (S_IRUSR OR S_IWUSR)	->exclude bits supported by getAttributes(), since these may be cached by a super class that is unaware of POSIX flags
		mode := value AND mask !!MODE_T		->clear any bits that the mask excludes
		
		newMode := self.stat.mode
		newMode := newMode AND NOT mask		->clear any bits that will be changed; i.e. only copy bits that are not changing
		newMode := newMode OR mode			->add changed bits
		
		->change dir's mode bits
		IF chmod(self.hostDirPath, newMode) = -1
			self.failureReason := posixFailureReason('error setting dir mode bits')
			RETURN FALSE
		ENDIF
		self.stat.mode := newMode
#ifdef pe_TargetOS_Linux
	CASE "link"
		linkPath := value!!ARRAY OF CHAR
		
		changesNeeded := FALSE
		IF self.linkIs0unknown1none2soft <> linkType
			->(changing from a soft to a hard link, or vice versa)
			changesNeeded := TRUE
			
		ELSE IF (self.linkPath <> NILA) AND (linkPath <> NILA)
			->(before & after states are both links) so see if the link is being changed
			IF StrCmpNoCase(self.linkPath, linkPath) = FALSE THEN changesNeeded := TRUE
			
		ELSE IF (self.linkPath <> NILA) <> (linkPath <> NILA)
			->(changing creating or destroying a link)
			changesNeeded := TRUE
		ENDIF
		
		IF changesNeeded
			IF linkPath
				self.openKludgeBegin()
				
				IF success := DeletePath(self.dirPath, /*force*/TRUE)
					hostLinkPath := ExportPath(linkPath)
					IF symlink(hostLinkPath, self.hostDirPath) = 0
						END self.linkPath
						self.linkPath := StrJoin(linkPath)
						self.linkIs0unknown1none2soft := linkType
					ENDIF
				ENDIF
				
				self.openKludgeFinish()
			ELSE
				->(removing link)
				IF self.linkIs0unknown1none2soft = 0
					self.linkPath, self.linkIs0unknown1none2soft := getDirLink(self.hostDirPath)
				ENDIF
				
				IF self.linkIs0unknown1none2soft = linkType
					->(there is a link to be removed)
					self.openKludgeBegin()
					
					IF success := DeletePath(self.dirPath, /*force*/TRUE)
						->a new dir will be subsequently created
						END self.linkPath
						self.linkIs0unknown1none2soft := 1
					ENDIF
					
					self.openKludgeFinish()
				ELSE
					success := TRUE
				ENDIF
			ENDIF
			
			IF success
				->refresh write-through cache
				IF stat(self.hostDirPath, self.stat) = -1 THEN Throw("FILE", posixFailureReason('cHostFile.changeExtra(); stat() failed'))
			ENDIF
		ELSE
			success := TRUE
		ENDIF
#endif
	DEFAULT
		success := FALSE
		unknown := TRUE
	ENDSELECT
FINALLY
	IF success = FALSE
		self.failureOrigin := 'cHostDir.changeExtra()'
	ENDIF
	
#ifdef pe_TargetOS_Linux
	END hostLinkPath
#endif
ENDPROC

->returns an OS-specific element of this dir
->NOTE: Returns unknown=TRUE if the specified element is not supported by the host OS.
PROC queryExtra(specific:QUAD) OF cHostDir RETURNS value, unknown:BOOL
	DEF mask
	
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.queryExtra(); dir not open')
	
	value := 0
	unknown := FALSE
	SELECT specific
	CASE "ATTR"
		mask := NOT (S_IRUSR OR S_IWUSR)
		value := self.stat.mode AND mask
#ifdef pe_TargetOS_Linux
	CASE "LINK"
		IF self.linkIs0unknown1none2soft = 0
			self.linkPath, self.linkIs0unknown1none2soft := getDirLink(self.hostDirPath)
		ENDIF
		
		value := self.linkPath
#endif
	DEFAULT
		unknown := TRUE
	ENDSELECT
ENDPROC

#ifdef pe_TargetOS_Linux
PRIVATE
PROC getDirLink(hostPath:STRING) RETURNS linkPath:OWNS STRING, linkIs0unknown1none2soft
	DEF hostLinkPath:OWNS STRING, max, len:SSIZE_T
	
	max := 1024 / 2
	REPEAT
		max := max * 2
		END hostLinkPath
		
		NEW hostLinkPath[max]
		len := readlink(hostPath, hostLinkPath, max)
	UNTIL (len < max) OR (max > 1024000)
	
	IF len >= 0
		SetStr(hostLinkPath, len!!VALUE)
		linkPath := ImportDirPath(hostLinkPath)
		linkIs0unknown1none2soft := 2
	ELSE
		linkIs0unknown1none2soft := 1	-># this could be wrong, should really check errno
	ENDIF
FINALLY
	END hostLinkPath
ENDPROC
PUBLIC
#endif


->PROC openParent(forceOpen=FALSE:BOOL) OF cHostDir RETURNS success:BOOL

->closes the current dir & opens the specified sub-dir
PROC openChild(relativePath:ARRAY OF CHAR, forceOpen=FALSE:BOOL) OF cHostDir RETURNS success:BOOL
	DEF currentPath:OWNS STRING, childPath:OWNS STRING
	
	->use check
	IF self.dirp = NIL THEN Throw("EMU", 'cHostDir.openChild(); dir not open')
	IF InvalidDirPath(relativePath) THEN Throw("EMU", 'cHostDir.openChild(); relativePath is invalid')
	
	NEW currentPath[EstrLen(self.dirPath)]
	StrCopy(currentPath, self.dirPath)
	
	NEW childPath[EstrLen(self.dirPath) + StrLen(relativePath)]
	StrCopy(childPath, self.dirPath)
	StrAdd( childPath, relativePath)
	
	self.close()
	success := self.open(childPath, self.readOnly, forceOpen)
	IF success = FALSE
		IF self.open(currentPath, self.readOnly, TRUE) = FALSE	->forceOpen=TRUE
			Throw("BUG", 'cHostDir.openChild(); failed to reopen current dir, after failed to open child')
		ENDIF
	ENDIF
FINALLY
	END currentPath, childPath
ENDPROC

->returns a list of the dirs contents
PROC makeEntryList() OF cHostDir RETURNS list:OWNS PTR TO cDirEntryList
	DEF dir:PTR TO DIR, dirent:PTR TO dirent, fullHostPath:OWNS STRING, isDir:BOOL, name:OWNS STRING
#ifndef pe_TargetOS_Linux
	DEF stat:_stat
#endif	
	
	dir := opendir(self.hostDirPath)
	IF dir = NIL THEN Throw("FILE", posixFailureReason('cHostDir.makeEntryList(); opendir() failed for dir "\s"', self.hostDirPath))
	
	/*isNetworkShare := StrCmp(self.hostDirPath, '\\\\', 2)*/
	
	NEW list.new()
 	REPEAT
		IF dirent := readdir(dir)
			IF StrCmp(dirent.name, '.') OR StrCmp(dirent.name, '..') = FALSE
				->determine whether file or dir
				NEW fullHostPath[EstrLen(self.hostDirPath) + 1 + StrLen(dirent.name) + 1]
				StrCopy(fullHostPath, self.hostDirPath)
				StrAdd( fullHostPath, #ifdef pe_TargetOS_Linux '/' #else '\\' #endif)
				StrAdd( fullHostPath, dirent.name)
				
				#ifdef pe_TargetOS_Linux
					isDir := (dirent.type = DT_DIR)
				#else
					IF stat(fullHostPath, stat) = 0
						isDir := (stat.mode AND S_IFDIR <> 0)
					ELSE
						isDir := FALSE
					ENDIF
					/*
					DEF tmpDir:PTR TO DIR
					tmpDir := opendir(fullHostPath)
					isDir := tmpDir <> NIL
					IF isDir THEN closedir(tmpDir)
					*/
					/*
					DEF isNetworkShare:BOOL, fileDesc
					IF isNetworkShare = FALSE
						->(not on a network share) so can use a very fast file/dir check
						StrAdd( fullHostPath, '\\.')
						isDir := access(fullHostPath, 0) <> -1
					ELSE
						isDir := TRUE
					ENDIF
					
					IF isDir
						->(on a network share, or else is likely a dir) so use a file check that is much slower (20 times) when anti-virus is running
						fileDesc := open(fullHostPath, O_BINARY OR O_RDONLY)
						isDir := fileDesc = -1
						IF isDir = FALSE THEN close(fileDesc)
					ENDIF
					*/
				#endif
				
				END fullHostPath
				
				->add to list
				NEW name[StrLen(dirent.name) + 1]
				StrCopy(name, dirent.name)
				IF isDir THEN StrAdd(name, '/')
				
				list.addString(PASS name)
			ENDIF
		ENDIF
	UNTIL dirent = NIL
FINALLY
	IF dir THEN IF closedir(dir) = -1 THEN Throw("FILE", posixFailureReason('cHostDir.makeEntryList(); closedir() failed'))
	
	IF exception THEN END list
	END fullHostPath
ENDPROC
