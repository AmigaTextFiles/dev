/* POSIX/cPath_File.e 15-10-2022
	POSIX-specific classes & procedures for portable file & dir access.
	Developed in 2009,2010,2011,2012,2013,2022 by Christopher Steven Handley.
	Basically completed 18-04-2009, started 15-04-09.
*/

OPT NATIVE, POINTER, INLINE, PREPROCESS
PUBLIC MODULE 'targetShared/cPath_FileBase', 'targetShared/POSIX/cPath_shared'
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


/*****************************/ ->cHostFile class has host OS implementation
CLASS cHostFile OF cBaseFile PRIVATE
	->failureOrigin:ARRAY OF CHAR
	->failureReason:ARRAY OF CHAR
	->readOnly:BOOL
	padByte:BYTE
	filePath    :OWNS STRING
	hostFilePath:OWNS STRING
	stat:_stat		->write-through cache of: mode bits & time
	fileDesc		->0 represents no open file, even though it is used by C for stdin
	sizeInBytes :BIGVALUE	->cache of file size
	position    :BIGVALUE	->current r/w position
	hostPosition:BIGVALUE	->cache of hosts actual r/w position
	forcedMode:MODE_T		->which mode bits had to be forced (set) to be opened
	linkPath:OWNS STRING	->path of link, if any, returned by queryExtra()
	linkIs0unknown1none2soft
	setSizeQuickKludgeUnsupported:BOOL	->remembers that a setSizeQuick() kludge is not supported by the filingsystem (probably Amiga-hosted SAMBA) the current file is on
ENDCLASS

PROC new(padByte=0:BYTE) OF cHostFile
	self.failureOrigin := NILA
	self.failureReason := NILA
	self.readOnly := FALSE
	self.padByte := padByte
	self.filePath := NILS
	self.hostFilePath := NILS
	->self.stat
	self.fileDesc := 0
	self.sizeInBytes := 0
	self.position := 0
	self.hostPosition := 0
	self.forcedMode := 0
	self.linkPath := NILS
	->self.setSizeQuickKludgeUnsupported
ENDPROC

PROC end() OF cHostFile
	IF self.fileDesc THEN self.close()
	SUPER self.end()
ENDPROC

->opens a file for use, creating it if necessary IF in write mode
->NOTE: Any previous file must have been closed, or an error will be raised.
->NOTE: The file's read/write position is at the start unless requested otherwise.
->NOTE: readOnly=TRUE prevents *any* changes to the file.
PROC open(filePath:ARRAY OF CHAR, readOnly=FALSE:BOOL, forceOpen=FALSE:BOOL, atPastEndNotStart=FALSE:BOOL) OF cHostFile RETURNS success:BOOL
	DEF alreadyExisted:BOOL
	
	success := TRUE
	alreadyExisted := TRUE
	
	->use check
	IF self.fileDesc THEN Throw("EMU", 'cHostFile.open(); a file is already open')
	IF filePath = NILA THEN Throw("EMU", 'cHostFile.open(); filePath=NIL')
	IF InvalidFilePath(filePath) THEN Throw("EMU", 'cHostFile.open(); filePath is invalid')
	
	->store parameters
	self.failureOrigin := NILA
	self.failureReason := NILA
	self.readOnly := readOnly
	self.hostFilePath := ExportPath(filePath)
	self.filePath     := StrJoin(filePath)
	self.forcedMode := 0
	self.linkPath := NILS
	self.linkIs0unknown1none2soft := 0
	self.setSizeQuickKludgeUnsupported := FALSE
	
	alreadyExisted := access(self.hostFilePath, 0) <> -1
	
	->examine file before opening, and deal with read/write protection
	IF alreadyExisted
		IF stat(self.hostFilePath, self.stat) = -1
			self.failureReason := posixFailureReason('error examining file')
			RETURN FALSE
		ENDIF
		
		IF forceOpen
			IF self.stat.mode AND S_IRUSR  = 0
				->(file is read protected)
				self.stat.mode := self.stat.mode OR S_IRUSR
				IF chmod(self.hostFilePath, self.stat.mode) = -1
					self.failureReason := posixFailureReason('could not remove read protection')
					RETURN FALSE
				ENDIF
				self.forcedMode := self.forcedMode OR S_IRUSR
			ENDIF
			
			IF (readOnly = FALSE) AND (self.stat.mode AND S_IWUSR = 0)
				->(file is write protected)
				self.stat.mode := self.stat.mode OR S_IWUSR
				IF chmod(self.hostFilePath, self.stat.mode) = -1
					self.failureReason := posixFailureReason('could not remove write protection')
					RETURN FALSE
				ENDIF
				self.forcedMode := self.forcedMode OR S_IWUSR
			ENDIF
		ENDIF
	ENDIF
	
	->open file as specified
	self.fileDesc := open(self.hostFilePath, O_BINARY OR IF readOnly THEN O_RDONLY ELSE O_RDWR OR O_CREAT, (S_IWUSR OR S_IRUSR) #ifdef pe_TargetOS_Linux OR (S_IWGRP OR S_IRGRP) OR S_IROTH #endif)
	IF self.fileDesc = -1
		self.fileDesc := 0
		self.failureReason := posixFailureReason('error opening file')
		RETURN FALSE
	ENDIF
	
	IF alreadyExisted = FALSE
		IF fstat(self.fileDesc, self.stat) = -1
			self.failureReason := posixFailureReason('error examining file')
			RETURN FALSE
		ENDIF
	ENDIF
	
	/*
	IF alreadyExisted = FALSE
		->check created file has correct mode bits, since Windows/MingW tends to make them read-only!
		IF self.stat.mode AND (S_IWUSR OR S_IRUSR) <> (S_IWUSR OR S_IRUSR)
			self.stat.mode := self.stat.mode OR (S_IWUSR OR S_IRUSR)
			chmod(self.hostFilePath, self.stat.mode)
		ENDIF
	ENDIF
	*/
	
	self.sizeInBytes := _filelengthi64(self.fileDesc)
	IF self.sizeInBytes = -1
		self.failureReason := posixFailureReason('error obtaining file size')
		RETURN FALSE
	ENDIF
	
	self.position := IF atPastEndNotStart THEN self.sizeInBytes ELSE 0
	IF lseek64(self.fileDesc, self.position, {SEEK_SET}!!VALUE) = - 1
		self.failureReason := posixFailureReason(IF atPastEndNotStart THEN 'error seeking to end of file' ELSE 'error seeking to start of file')
		RETURN FALSE
	ENDIF
	self.hostPosition := self.position
FINALLY
	IF (success = FALSE) OR exception
		->clean-up after a failure, returning the object & the file itself to the state it had before open() was called
		IF self.fileDesc
			close(self.fileDesc)
			self.fileDesc := 0
		ENDIF
		END self.hostFilePath
		IF self.filePath
			IF alreadyExisted OR readOnly = FALSE THEN DeletePath(self.filePath, TRUE)	->remove file if it didn't exist before it was openeed
			END self.filePath
		ENDIF
	ENDIF
	
	IF success = FALSE
		self.failureOrigin := 'cHostFile.open()'
	ENDIF
ENDPROC

->close an open file
PROC close() OF cHostFile
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.close(); file not open')
	
	close(self.fileDesc) ; self.fileDesc := 0
	
	IF self.forcedMode
		->restore forced mode bits
		self.stat.mode := self.stat.mode AND NOT self.forcedMode
		chmod(self.hostFilePath, self.stat.mode)
	ENDIF
	
	END self.filePath
	END self.hostFilePath
	
	END self.linkPath
ENDPROC

->flushes any caches used for the file, whether they are provided by this class or the host OS
->NOTE: In write mode, ensures all changes are commited to disk, without needing to close() file.
->NOTE: In read mode, refreshes any caches, ensuring any changes to file will be seen.
PROC flush() OF cHostFile
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.flush(); file not open')
	
	->flush writes
	IF self.readOnly = FALSE
		IF fsync(self.fileDesc) = -1 THEN Throw("FILE", posixFailureReason('cHostFile.flush(); fsync() failed'))
	ENDIF
	
	->refresh write-through cache (should not strictly be required in write mode)
	IF fstat(self.fileDesc, self.stat) = -1 THEN Throw("FILE", posixFailureReason('cHostFile.flush(); fstat() failed'))
	
	->flush cached link info
	END self.linkPath
	self.linkIs0unknown1none2soft := 0
ENDPROC

PROC make() OF cHostFile RETURNS object:OWNS PTR TO cHostFile
	NEW object
ENDPROC

PROC clone(writeNotRead=FALSE:BOOL) OF cHostFile /*RETURNS clone:OWNS PTR TO cHostFile*/ IS SUPER self.clone(writeNotRead)::cHostFile

PROC makeCopy(path:ARRAY OF CHAR) OF cHostFile /*RETURNS copy:OWNS PTR TO cHostFile*/ IS SUPER self.makeCopy(path)::cHostFile

->PROC infoReadOnly() OF cHostFile RETURNS readOnly:BOOL

PROC infoIsOpen() OF cHostFile RETURNS isOpen:BOOL IS self.fileDesc <> NIL

PROC infoPadByte() OF cHostFile RETURNS padByte:BYTE IS self.padByte

->changes the attributes in a flexible manner
PROC setAttributes(attr, mask=-1) OF cHostFile RETURNS success:BOOL
	DEF newAttr, mode:MODE_T
	
	success := TRUE
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.setAttributes(); file not open')
	IF self.readOnly THEN Throw("EMU", 'cHostFile.setAttributes(); file opened in read only mode')
	
	->calculate new attributes
	attr := attr AND mask		->clear any bits that the mask excludes (mistakes?)
	
	newAttr := self.getAttributes()
	newAttr := newAttr AND NOT mask		->clear any bits that will be changed; i.e. only copy bits that are not changing
	newAttr := newAttr OR attr			->add changed bits
	
	->change file's mode bits according to new attributes
	mode := self.stat.mode AND NOT (S_IRUSR OR S_IWUSR)	->keep unsupported mode bits the same
	IF newAttr AND CPA_READ THEN mode := mode OR S_IRUSR
	IF attr AND CPA_STRICT = FALSE
		IF newAttr AND CPA_WRITE  THEN mode := mode OR S_IWUSR
		IF newAttr AND CPA_DELETE THEN mode := mode OR S_IWUSR
	ELSE
		IF newAttr AND (CPA_WRITE OR CPA_DELETE) THEN mode := mode OR S_IWUSR
	ENDIF
	
	IF chmod(self.hostFilePath, mode) = -1
		self.failureReason := posixFailureReason('error setting file mode bits')
		RETURN FALSE
	ENDIF
	self.forcedMode := self.forcedMode AND NOT (mode XOR self.stat.mode)	->clear any bits that have been changed, so they will no-longer be restored
	self.stat.mode := mode
FINALLY
	IF success = FALSE
		self.failureOrigin := 'cHostFile.setAttributes()'
	ENDIF
ENDPROC

->returns the file's attribute bit pattern
->NOTE: The OS's attributes are mapped as well as possible to the CPA_ set.
PROC getAttributes() OF cHostFile RETURNS attr
	DEF mode
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.getAttributes(); file not open')
	
	mode := self.stat.mode AND NOT self.forcedMode
	attr := 0
	IF mode AND S_IRUSR THEN attr := attr OR CPA_READ
	IF mode AND S_IWUSR THEN attr := attr OR CPA_WRITE OR CPA_DELETE
ENDPROC

->return what attributes are supported
->NOTE: a bit set to 1 indicate a supported attribute
PROC getAttributesSupported() OF cHostFile RETURNS mask
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.getAttributesSupported(); file not open')
	
	mask := CPA_READ OR (CPA_WRITE OR CPA_DELETE)
ENDPROC

PRIVATE
PROC openKludgeBegin() OF cHostFile
	IF self.fileDesc = 0 THEN Throw("BUG", 'cHostFile.openKludgeBegin(); kludge already started')
	
	close(self.fileDesc) ; self.fileDesc := 0
ENDPROC

PROC openKludgeFinish() OF cHostFile
	IF self.fileDesc <> 0 THEN Throw("BUG", 'cHostFile.openKludgeFinish(); kludge already finished')
	
	->undo kludge; re-opening of file must match that in the Open() method
	self.fileDesc := open(self.hostFilePath, O_BINARY OR IF self.readOnly THEN O_RDONLY ELSE O_RDWR OR O_CREAT, (S_IWUSR OR S_IRUSR) #ifdef pe_TargetOS_Linux OR (S_IWGRP OR S_IRGRP) OR S_IROTH #endif)
	IF self.fileDesc = -1
		self.fileDesc := 0
		END self.filePath
		END self.hostFilePath
		Throw("BUG", 'cHostFile.openKludgeFinish(); kludge failed')
	ENDIF
	
	->update cache of position, which must have changed since reopened
	self.hostPosition := safeSeek(self.fileDesc, 0, SEEK_CUR)
ENDPROC
PUBLIC

->changes the whole path (moving & renaming)
PROC setPath(path:ARRAY OF CHAR) OF cHostFile RETURNS success:BOOL
	DEF hostFilePath:OWNS STRING
	
	success := TRUE
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.setPath(); file not open')
	IF self.readOnly THEN Throw("EMU", 'cHostFile.setPath(); file opened in read only mode')
	IF path = NILA THEN Throw("EMU", 'cHostFile.setPath(); path=NILA')
	IF InvalidFilePath(path) THEN Throw("EMU", 'cHostFile.setPath(); path is invalid')
	
	->perform rename/move
	hostFilePath := ExportPath(path)
	self.openKludgeBegin()
	IF rename(self.hostFilePath, hostFilePath) = -1
		self.failureReason := posixFailureReason('error renaming host file')
		self.openKludgeFinish()
		RETURN FALSE
	ENDIF
	
	->update internal filepath
	END self.filePath
	self.filePath := StrJoin(path)
	
	END self.hostFilePath
	self.hostFilePath := PASS hostFilePath
	
	self.openKludgeFinish()
FINALLY
	END hostFilePath
	
	IF success = FALSE
		self.failureOrigin := 'cHostFile.setPath()'
	ENDIF
ENDPROC

->returns the whole path
PROC getPath() OF cHostFile RETURNS path:ARRAY OF CHAR
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.getPath(); file not open')
	
	path := self.filePath
ENDPROC


->changes the info of a file that is not changed by non-Extra methods of this class
->NOTE: The returned failure may only indicate a partial failure, if multiple
->      underlying OS elements are changed.
->NOTE: Will avoid setting stuff that is not supported in the place the extra originated 
->      from (this does NOT generate a failure).
->NOTE: May be passed extra=NIL; will do nothing.
PROC setExtra(extra:PTR TO cExtra) OF cHostFile RETURNS success:BOOL
	DEF value, unknown:BOOL
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.setExtra(); file not open')
	IF self.readOnly THEN Throw("EMU", 'cHostFile.setExtra(); file opened in read only mode')
	
	success := TRUE
	IF extra = NIL THEN RETURN
	
	value, unknown := extra.queryExtra("ATTR")
	IF unknown = FALSE THEN success := success AND self.changeExtra("ATTR", value)
	
	value, unknown := extra.queryExtra("SLNK")
	IF unknown = FALSE THEN success := success AND self.changeExtra("SLNK", value)
ENDPROC

->returns an object storing all the info of a file that is not returned by non-Extra methods of this class
->NOTE: It returns NIL to indicate a failure.
PROC getExtra() OF cHostFile RETURNS extra:OWNS PTR TO cExtra
	DEF hostExtra:OWNS PTR TO cHostExtra
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.getExtra(); file not open')
	
	NEW hostExtra.new()
	IF hostExtra.setExtra(self) = FALSE THEN END hostExtra
	RETURN hostExtra
ENDPROC

->changes an OS-specific element of the file
->NOTE: Returns unknown=TRUE if the specified element is not supported by the host OS.
PROC changeExtra(specific:QUAD, value) OF cHostFile RETURNS success:BOOL, unknown:BOOL
	DEF mode:MODE_T, mask:MODE_T, newMode:MODE_T
#ifdef pe_TargetOS_Linux
	DEF linkType, linkPath:ARRAY OF CHAR, hostLinkPath:OWNS STRING, changesNeeded:BOOL
#endif
	
	success := TRUE
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.changeExtra(); file not open')
	IF self.readOnly THEN Throw("EMU", 'cHostFile.changeExtra(); file opened in read only mode')
	
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
		
		->change file's mode bits
		IF chmod(self.hostFilePath, newMode) = -1
			self.failureReason := posixFailureReason('error setting file mode bits')
			RETURN FALSE
		ENDIF
		self.stat.mode := newMode
#ifdef pe_TargetOS_Linux
	CASE "LINK"
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
				
				IF success := DeletePath(self.filePath, /*force*/TRUE)
					hostLinkPath := ExportPath(linkPath)
					IF symlink(hostLinkPath, self.hostFilePath) = 0
						END self.linkPath
						self.linkPath := StrJoin(linkPath)
						self.linkIs0unknown1none2soft := linkType
					ENDIF
				ENDIF
				
				self.openKludgeFinish()
			ELSE
				->(removing link)
				IF self.linkIs0unknown1none2soft = 0
					self.linkPath, self.linkIs0unknown1none2soft := getFileLink(self.hostFilePath)
				ENDIF
				
				IF self.linkIs0unknown1none2soft = linkType
					->(there is a link to be removed)
					self.openKludgeBegin()
					
					IF success := DeletePath(self.filePath, /*force*/TRUE)
						->a new file will be subsequently created
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
				IF fstat(self.fileDesc, self.stat) = -1 THEN Throw("FILE", posixFailureReason('cHostFile.changeExtra(); fstat() failed'))
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
		self.failureOrigin := 'cHostFile.changeExtra()'
	ENDIF
	
#ifdef pe_TargetOS_Linux
	END hostLinkPath
#endif
ENDPROC

->returns an OS-specific element of this file
->NOTE: Returns unknown=TRUE if the specified element is not supported by the host OS.
PROC queryExtra(specific:QUAD) OF cHostFile RETURNS value, unknown:BOOL
	DEF mask
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.queryExtra(); file not open')
	
	IF specific = "SLNK" THEN specific := "LINK"
	
	value := 0
	unknown := FALSE
	SELECT specific
	CASE "ATTR"
		mask := NOT (S_IRUSR OR S_IWUSR)
		value := self.stat.mode AND mask
#ifdef pe_TargetOS_Linux
	CASE "LINK"
		IF self.linkIs0unknown1none2soft = 0
			self.linkPath, self.linkIs0unknown1none2soft := getFileLink(self.hostFilePath)
		ENDIF
		
		value := self.linkPath
#endif
	DEFAULT
		unknown := TRUE
	ENDSELECT
ENDPROC

#ifdef pe_TargetOS_Linux
PRIVATE
PROC getFileLink(hostPath:STRING) RETURNS linkPath:OWNS STRING, linkIs0unknown1none2soft
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
		linkPath := ImportFilePath(hostLinkPath)
		linkIs0unknown1none2soft := 2
	ELSE
		linkIs0unknown1none2soft := 1	-># this could be wrong, should really check errno
	ENDIF
FINALLY
	END hostLinkPath
ENDPROC
PUBLIC
#endif


->writes length bytes from the buffer to the file at the (read/write) position
->NOTE: Normally writing past the end of file extends the file, but
->      if noAutoExtend=TRUE then bytes outside the file range will be ignored.
->NOTE: Returns the position after the bytes written, and the number of bytes lost due to being ignored.
PROC write(buffer:ARRAY, lengthInBytes, offsetInBytes=0, noAutoExtend=FALSE:BOOL) OF cHostFile RETURNS nextPos:BIGVALUE, numOfLostBytes
	DEF maxLength:BIGVALUE, origSizeInBytes:BIGVALUE, finalPosition:BIGVALUE, ret:SSIZE_T
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.write(); file not open')
	IF self.readOnly THEN Throw("EMU", 'cHostFile.write(); file opened in read only mode')
	IF lengthInBytes < 0 THEN Throw("EMU", 'cHostFile.write(); lengthInBytes<0')
	IF buffer = NILA THEN Throw("EMU", 'cHostFile.write(); buffer=NILA')
	IF offsetInBytes < 0 THEN Throw("EMU", 'cHostFile.write(); offsetInBytes<0')
	
	->handle writing past end of file
	IF noAutoExtend
		->modify parameters to prevent extending file size
		maxLength := bigMax(0, self.sizeInBytes - self.position)		->max length of real data that can be written from current position
		numOfLostBytes := Max(0, lengthInBytes - maxLength !!VALUE)
		lengthInBytes  := Min(maxLength !!VALUE, lengthInBytes)
	ELSE
		->increase file size, if necessary
		origSizeInBytes := self.sizeInBytes
		finalPosition := self.position + lengthInBytes
		IF finalPosition > origSizeInBytes
			->no need to physically increase actual file's size, since writing will automatically do it,
			->but doing so does allow us to fail-safe in the event of the disk being full
			self.setSizeQuick(finalPosition)
		ENDIF
		
		->write pad bytes between end of file & start of write position, if necessary
		IF self.position > origSizeInBytes THEN self.writePadBytes(self.position - origSizeInBytes, origSizeInBytes)
		
		numOfLostBytes := 0
	ENDIF
	
	->write data from buffer
	IF lengthInBytes > 0
		IF self.hostPosition <> self.position THEN safeSeek(self.fileDesc, self.hostPosition := self.position)
		ret := write(self.fileDesc, buffer + offsetInBytes, lengthInBytes) 
		IF ret = -1 THEN Throw("FILE", posixFailureReason('cHostFile.write(); write() failed'))
		IF ret <> lengthInBytes THEN Throw("FILE", 'cHostFile.write(); size of written data does not match that expected')
		self.hostPosition := self.hostPosition + lengthInBytes
	ENDIF
	
	->calculate next write position
	nextPos := self.position + lengthInBytes
	
	->update cache with modified file's actual time (& archive mode bit?)
	IF fstat(self.fileDesc, self.stat) = -1 THEN Throw("FILE", posixFailureReason('cHostFile.write(); fstat() failed'))
FINALLY
	IF exception
		->ensure cached state is correct
		self.hostPosition := safeSeek(self.fileDesc, 0, SEEK_CUR)
	ENDIF
ENDPROC

->reads length bytes into buffer, or less if the tobyte is found
->NOTE: It reads starting from the (read/write) position, and does *not* change that position.
->NOTE: The contents between the tobyte & the end of the buffer are undefined.
->NOTE: If reading past the end of file (or after matching toByte), it fills the rest of the buffer with pad bytes.
->NOTE: Returns the position after the bytes read, and the number of pad bytes used.
PROC read(buffer:ARRAY, lengthInBytes, offsetInBytes=0, toByte=-1:INT) OF cHostFile RETURNS nextPos:BIGVALUE, numOfPadBytes
	DEF maxLength:BIGVALUE, origLength, ret:SSIZE_T
	DEF byteBuffer:ARRAY OF BYTE, padByte:BYTE, i
	DEF matchPos, oldNumOfPadBytes
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.read(); file not open')
	IF lengthInBytes < 0 THEN Throw("EMU", 'cHostFile.read(); lengthInBytes<0')
	IF buffer = NILA THEN Throw("EMU", 'cHostFile.read(); buffer=NILA')
	IF offsetInBytes < 0 THEN Throw("EMU", 'cHostFile.read(); offsetInBytes<0')
	
	->compare read request to actual range of file
	origLength := lengthInBytes
	maxLength := bigMax(0, self.sizeInBytes - self.position)	->max length of real data that can be read from current position
	
	numOfPadBytes := bigMax(0, lengthInBytes - maxLength) !!VALUE
	IF numOfPadBytes > 0 THEN lengthInBytes := maxLength !!VALUE
	
	->read data into buffer
	IF lengthInBytes > 0
		IF self.hostPosition <> self.position THEN safeSeek(self.fileDesc, self.hostPosition := self.position)
		ret := read(self.fileDesc, buffer + offsetInBytes, lengthInBytes)
		IF ret = -1 THEN Throw("FILE", posixFailureReason('cHostFile.read(); read() failed'))
		IF ret <> lengthInBytes THEN Throw("BUG", 'cHostFile.read(); size of read data does not match that expected')
		self.hostPosition := self.hostPosition + lengthInBytes
	ENDIF
	
	->fill rest of buffer with pad bytes
	byteBuffer := buffer + offsetInBytes !!ARRAY
	padByte := self.padByte
	FOR i := lengthInBytes TO origLength-1 DO byteBuffer[i] := padByte
	
	->search for requested toByte and truncate buffer if found
	IF toByte >= 0
		->search entire buffer (incase pad byte is being searched for)  ->#simple but inefficient
		byteBuffer := buffer + offsetInBytes !!ARRAY
		matchPos := -1
		FOR i := 0 TO origLength-1
			IF byteBuffer[i] = toByte THEN matchPos := i
		ENDFOR IF matchPos <> -1
		
		IF matchPos <> -1
			->(found match) so recalculate size of buffer
			oldNumOfPadBytes := numOfPadBytes
			
			numOfPadBytes := origLength - (matchPos + 1)
			lengthInBytes := matchPos + 1
			
			->fill buffer after match with pad bytes
			padByte := self.padByte
			FOR i := lengthInBytes TO origLength-1-oldNumOfPadBytes DO byteBuffer[i] := padByte
			
			->ensure next position starts after last match
			origLength := lengthInBytes
		ENDIF
	ENDIF
	
	->calculate next read position
	nextPos := self.position + origLength
FINALLY
	IF exception
		->ensure cached position is correct
		self.hostPosition := safeSeek(self.fileDesc, 0, SEEK_CUR)
	ENDIF
ENDPROC

->changes the read/write position in the file; may go beyond it's end (without changing filesize)
->NOTE: A negative pos indicates position from end of file (-1=after last byte, -2=last byte, etc).
->NOTE: An error will be raised if you attempt to go before the beginning of the file.
PROC setPosition(pos:BIGVALUE) OF cHostFile
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.setPosition(); file not open')
	
	IF pos < 0
		pos := pos + self.sizeInBytes + 1
		IF pos < 0 THEN Throw("EMU", 'cHostFile.setPosition(); position before start of file is illegal')
	ENDIF
	
	self.position := pos
ENDPROC

->returns the read/write position in the file, from the beginning unless requested otherwise.
PROC getPosition(fromEnd=FALSE:BOOL) OF cHostFile RETURNS pos:BIGVALUE
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.getPosition(); file not open')
	
	IF fromEnd = FALSE
		pos := self.position
	ELSE
		pos := self.position - self.sizeInBytes - 1
	ENDIF
ENDPROC

PRIVATE
->helper method, writes pad bytes to file
PROC writePadBytes(numOfPadBytes:BIGVALUE, startPosOfPadBytes:BIGVALUE) OF cHostFile
	DEF buffer:ARRAY OF BYTE, bufferSize
	DEF writePadSize, i, padByte:BYTE, ret:SSIZE_T
	
	->create buffer full of necessary pad bytes
	bufferSize := bigMin(CPATH_FILE_BUFFER_SIZE, numOfPadBytes) !!VALUE
	NEW buffer[bufferSize]
	padByte := self.padByte
	IF padByte <> 0 THEN FOR i := 0 TO bufferSize-1 DO buffer[i] := padByte
	
	->write pad bytes
	IF self.hostPosition <> startPosOfPadBytes
		safeSeek(self.fileDesc, self.hostPosition := startPosOfPadBytes)
	ENDIF
	
	writePadSize := bufferSize
	WHILE numOfPadBytes > 0
		ret := write(self.fileDesc, buffer, writePadSize) 
		IF ret = -1 THEN Throw("FILE", posixFailureReason('cHostFile.writePadBytes(); write() failed'))
		IF ret <> writePadSize THEN Throw("FULL", 'cHostFile.writePadBytes(); not all pad bytes were written, disk may be full')
		self.hostPosition := self.hostPosition + writePadSize
		
		numOfPadBytes := numOfPadBytes - writePadSize	->keep track of how many pad bytes still to be written
		IF numOfPadBytes < writePadSize THEN writePadSize := numOfPadBytes !!VALUE	->ensure final write does not goes past intended place
	ENDWHILE
	IF numOfPadBytes <> 0 THEN Throw("BUG", 'cHostFile.writePadBytes(); too many pad bytes were written')
FINALLY
	END buffer
ENDPROC

->helper method, set file size without writing any pad bytes
PROC setSizeQuick(sizeInBytes:BIGVALUE) OF cHostFile
	IF (sizeInBytes <= self.sizeInBytes) OR self.setSizeQuickKludgeUnsupported
		->(reducing file size)
		IF ftruncate(self.fileDesc, sizeInBytes) <> -1
			->(correctly changed file size)
			self.sizeInBytes := sizeInBytes
		ELSE
			->(failed to change size of file)
			Throw("FILE", posixFailureReason('cHostFile.setSizeQuick(); ftruncate() failed'))
		ENDIF
	ELSE
		->(increasing file size) so use alternative method which is much faster on Windows (5.3 times faster for a 2GB FAT32 USB memory stick)
		safeSeek(self.fileDesc, sizeInBytes - 1)
		IF write(self.fileDesc, '', 1) <> -1
			->(correctly changed file size)
			self.sizeInBytes := sizeInBytes
		ELSE
			->(failed to change size of file) so see whether out fast resize method is to blame
			->NOTE: Windows accessing an Amiga-based Samba share gives the EINVAL error.
			IF ftruncate(self.fileDesc, sizeInBytes) <> -1
				->(correctly changed file size)
				self.sizeInBytes := sizeInBytes
				
				self.setSizeQuickKludgeUnsupported := TRUE	->use the slower resize method in the future, for this file
			ELSE
				Throw("FILE", posixFailureReason('cHostFile.setSizeQuick(); write() failed'))
			ENDIF
		ENDIF
	ENDIF
FINALLY
	self.hostPosition := safeSeek(self.fileDesc, 0, SEEK_CUR)		->don't assume position after resizing file (or an exception)
ENDPROC
PUBLIC

->changes the file size, if necessary extending the file with pad bytes
PROC setSize(sizeInBytes:BIGVALUE) OF cHostFile
	DEF numOfPadBytes, startPosOfPadBytes:BIGVALUE
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.setSize(); file not open')
	IF self.readOnly THEN Throw("EMU", 'cHostFile.setSize(); file opened in read only mode')
	IF sizeInBytes < 0 THEN Throw("EMU", 'cHostFile.setSize(); sizeInBytes<0')
	
	->calc number of pad bytes needed
	numOfPadBytes := sizeInBytes - self.sizeInBytes !!VALUE
	IF numOfPadBytes < 0
		numOfPadBytes := 0	->reduced file size, so no pad bytes needed
	ELSE
		startPosOfPadBytes := self.sizeInBytes
	ENDIF
	
	->resize file
	self.setSizeQuick(sizeInBytes)
	
	->write pad bytes
	IF numOfPadBytes > 0 THEN self.writePadBytes(numOfPadBytes, startPosOfPadBytes)
	
	->update cache with modified file's actual time (& archive mode bit?)
	IF fstat(self.fileDesc, self.stat) = -1 THEN Throw("FILE", posixFailureReason('cHostFile.setSize(); fstat() failed'))
ENDPROC

->returns the file size in bytes
PROC getSize() OF cHostFile RETURNS sizeInBytes:BIGVALUE
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.getSize(); file not open')
	
	sizeInBytes := self.sizeInBytes
ENDPROC

->changes the time
->NOTE: If the underlying filingsystem does not support the required time accuracy, then the actual time will be slightly different.
PROC setTime(time:BIGVALUE) OF cHostFile RETURNS success:BOOL
	DEF utimbuf:_utimbuf
	
	success := TRUE
	
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.setTime(); file not open')
	IF self.readOnly THEN Throw("EMU", 'cHostFile.setTime(); file opened in read only mode')
	
	->set time
	utimbuf.actime := utimbuf.modtime := 946684800 + (time!!VALUE)
	IF _futime(self.fileDesc, utimbuf) = -1
		self.failureReason := posixFailureReason('error setting file date')
		RETURN FALSE
	ENDIF
	
	->update cache with actual time (incase it differs slightly)
	IF fstat(self.fileDesc, self.stat) = -1 THEN Throw("FILE", posixFailureReason('cHostFile.setTime(); fstat() failed'))
FINALLY
	IF success = FALSE
		self.failureOrigin := 'cHostFile.changeExtra()'
	ENDIF
ENDPROC

->returns the time the file was last updated
PROC getTime() OF cHostFile RETURNS time:BIGVALUE
	->use check
	IF self.fileDesc = 0 THEN Throw("EMU", 'cHostFile.getTime(); file not open')
	
	time := self.stat.mtime - 946684800
ENDPROC
