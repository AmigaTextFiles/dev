/* POSIX/cPath_shared.e 16-10-2022
	POSIX-specific classes & procedures for portable file & dir access.
	Developed in 2009,2010,2011,2013,2014,2022 by Christopher Steven Handley.
	Basically completed 18-04-2009, started 15-04-09.
*/

OPT NATIVE, POINTER, INLINE, PREPROCESS
PUBLIC MODULE 'targetShared/cPath_sharedBase'
MODULE 'target/sys/types', 'target/sys/stat', 'target/errno'
MODULE 'target/sys/time', 'target/time', 'target/utime'
MODULE 'target/fcntl', 'target/dirent'
MODULE 'target/io'		->Windows (non-POSIX) module
MODULE 'target/direct'	->Windows (non-POSIX) module
MODULE 'target/unistd'	->POSIX (non-Windows) module
MODULE 'target/mntent', 'target/sys/select', 'target/sys/time', 'CSH/pGeneral'	->for Linux drive detection

#ifdef pe_TargetOS_Linux
	->emulate Windows constants
	CONST O_BINARY = 0		->this is the default mode & so no flag value is actually needed
	CONST SEEKMAX = SEEK_END+1
	
	->emulate Windows object name (as Windows already uses both names)
	OBJECT _stat OF stat ; ENDOBJECT
	OBJECT _utimbuf OF utimbuf ; ENDOBJECT
	
	->emulate useful Windows functions on Linux
	PROC _filelengthi64(fileDesc) RETURNS length:BIGVALUE
		DEF stat:stat
		IF fstat(fileDesc, stat) THEN RETURN -1
		length := stat.size
	ENDPROC
	PROC _futime(fileDesc, utimbuf:PTR TO _utimbuf) RETURNS error	->set the modification time on an open file
		DEF tv[2]:ARRAY OF timeval
		tv[0].sec  := utimbuf.actime
		tv[0].usec := 0
		tv[1].sec  := utimbuf.modtime
		tv[1].usec := 0
		error := futimes(fileDesc, tv)		->changes the access and modification times of a file
	ENDPROC
	
	->shared abstraction
	#define _mkdir(path, mode) mkdir(path, mode)
#endif
#ifdef pe_TargetOS_Windows
	->emulate Linux/POSIX constants
	ENUM SEEK_SET=0, SEEK_CUR=1, SEEK_END=2, SEEKMAX
	
	->map missing Linux/POSIX functions onto Windows ones
	PROC ftruncate(fd, length:BIGVALUE) IS IF length < $7FFFFFFF THEN _chsize(fd, length!!VALUE) ELSE Throw("BUG", 'cPath_shared; ftruncate() doesn\'t support files >= 2GB') BUT 0	->### WARNING: This is incorrect!
	PROC fsync(fd) IS _commit(fd)
	->PROC lstat(path:ARRAY OF CHAR, buf:PTR TO _stat) IS stat(path, buf)		->Windows doesn't support POSIX links, but lstat() also works on non-link files
	PROC s_ISDIR(mode) IS s_isdir(mode)
	PROC s_ISCHR(mode) IS s_ischr(mode)
	PROC s_ISBLK(mode) IS s_isblk(mode)
	PROC s_ISREG(mode) IS s_isreg(mode)
	PROC s_ISFIFO(mode) IS s_isfifo(mode)
	->PROC s_ISLNK(mode)
	
	->shared abstraction
	#define _mkdir(path, mode) mkdir(path)		->ignore "mode" parameter
#endif

PROC new()
	new_assignments()
ENDPROC

PROC end()
	end_assignments()
	end_drives()
ENDPROC

PRIVATE
CONST DEBUG = FALSE

->this is part of <stdio.h>, and theoretically also <io.h> under Windows.
PROC rename(oldName:ARRAY OF CHAR, newName:ARRAY OF CHAR) IS NATIVE {rename( (const char*)} oldName {, (const char*)} newName {)} ENDNATIVE !!VALUE

PROC fullpath(oldPath:ARRAY OF CHAR, size) RETURNS newPath:OWNS STRING
#ifdef pe_TargetOS_Windows
	DEF oldHostPath:OWNS STRING, maxLen, newHostPath:OWNS STRING
	
	oldHostPath := ExportPath(oldPath)
	NEW newHostPath[maxLen := Max(size, FILENAME_MAX)]
	->_fullpath() is part of <stdlib.h>
	IF NATIVE {_fullpath(} newHostPath {, (const char*)} oldHostPath {,} maxLen {)} ENDNATIVE !!ARRAY OF CHAR = NILA THEN END newHostPath
	newPath := IF IsFile(oldPath) THEN ImportFilePath(newHostPath) ELSE ImportDirPath(newHostPath)
FINALLY
	END oldHostPath, newHostPath
#else
	DEF oldSubPath:OWNS STRING, temp:OWNS STRING, oldHostPath:OWNS STRING, newHostPath:OWNS STRING
	DEF result:ARRAY OF CHAR, retry:BOOL, oldPathLen
	
	size := 0	->dummy
	NEW newHostPath[FILENAME_MAX]
	->realpath() is part of <stdlib.h>, but unlike _fullpath() it only works on an existing file/dir, so we need to emulate _fullpath()'s behaviour
	oldPathLen := StrLen( oldPath)
	oldSubPath := StrJoin(oldPath)
	REPEAT
		END oldHostPath
		oldHostPath := ExportPath(oldSubPath)
		result := NATIVE {realpath(} oldHostPath {,} newHostPath {)} ENDNATIVE !!ARRAY OF CHAR
		IF retry := (result = NILA) AND (errno = ENOENT)
			->(realpath() failed due to full path not existing) so get sub-path & try again
			temp := PASS oldSubPath
			oldSubPath := ExtractSubPath(temp) ; END temp
		ENDIF
	UNTIL retry = FALSE
	
	IF result = NILA THEN RETURN ->NILS
	newPath := IF IsFile(oldSubPath) THEN ImportFilePath(newHostPath) ELSE ImportDirPath(newHostPath)
	IF EstrLen(oldSubPath) < oldPathLen
		->(a sub-path was used) so reconstruct the full path
		temp := NewString(EstrLen(newPath) + oldPathLen - EstrLen(oldSubPath))
		StrCopy(temp, newPath)
		StrAdd( temp, oldPath, ALL, EstrLen(oldSubPath))
		END newPath ; newPath := PASS temp
	ENDIF
FINALLY
	END oldSubPath, temp, oldHostPath, newHostPath
#endif
ENDPROC

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

/*
PROC bigMax(a:BIGVALUE, b:BIGVALUE) IS IF a > b THEN a ELSE b
PROC bigMin(a:BIGVALUE, b:BIGVALUE) IS IF a < b THEN a ELSE b
*/

PUBLIC

/*****************************/ ->host procedures

CONST CP_MAXNAMELENGTH = FILENAME_MAX
CONST CP_COLONCHAR = 0

#ifdef pe_TargetOS_Windows
CONST CP_CASEINSENSITIVE = TRUE
#else
CONST CP_CASEINSENSITIVE = FALSE
#endif

#ifdef pe_TargetOS_Windows
STATIC cFile_NewLine = '\b\n'
#else
STATIC cFile_NewLine = '\n'
#endif

->like StrCmp() but with case-sensitivity appropriate for the host OS
PROC StrCmpPath(path1:ARRAY OF CHAR, path2:ARRAY OF CHAR, len=ALL, firstOffset=0, secondOffset=0) RETURNS match:BOOL REPLACEMENT
	RETURN IF CP_CASEINSENSITIVE THEN StrCmpNoCase(path1, path2, len, firstOffset, secondOffset) ELSE StrCmp(path1, path2, len, firstOffset, secondOffset)
ENDPROC

->like OstrCmp() but with case-sensitivity appropriate for the host OS
PROC OstrCmpPath(path1:ARRAY OF CHAR, path2:ARRAY OF CHAR, max=ALL, firstOffset=0, secondOffset=0) RETURNS sign:RANGE -1 TO 1 REPLACEMENT
	RETURN IF CP_CASEINSENSITIVE THEN OstrCmpNoCase(path1, path2, max, firstOffset, secondOffset) ELSE OstrCmp(path1, path2, max, firstOffset, secondOffset)
ENDPROC

->returns the current (absolute) dir path the program was started with
PROC CurrentDirPath() RETURNS dirPath:OWNS STRING REPLACEMENT
	DEF hostDirPath[CP_MAXNAMELENGTH+1]:ARRAY OF CHAR, newDirPath:OWNS STRING
	
	IF getcwd(hostDirPath, CP_MAXNAMELENGTH+1) = NILA THEN Throw("FILE", posixFailureReason('cPath; CurrentDirPath(); getcwd() failed'))
	dirPath := ImportDirPath(hostDirPath)
	
	#ifdef pe_TargetOS_Linux
		->ensure absolute paths are inside the 'root drive', so it's not treated as a relative path; e.g. ':/home/chris/foobar.txt'
		IF (dirPath[0] = "/") AND (InStr(dirPath, ':') = -1)
			NEW newDirPath[1+EstrLen(dirPath)]
			StrCopy(newDirPath, ':')
			StrAdd( newDirPath, dirPath, ALL)
			END dirPath
			dirPath := PASS newDirPath
		ENDIF
	#endif
FINALLY
	IF exception THEN END dirPath
	END newDirPath
ENDPROC

->tries to delete the file/dir, returning whether it succeeded
->NOTE: It will fail if the directory is not empty.
->NOTE: If force=TRUE then file/dir attributes will be overridden, but it can still fail.
->NOTE: If fileOrDir=TRUE then it will try to delete the named item, ignoring whether it is a file or directory (since many filingsystems disallow files with the same names as directories).
PROC DeletePath(path:ARRAY OF CHAR, force=FALSE:BOOL, fileOrDir=FALSE:BOOL) RETURNS success:BOOL REPLACEMENT
	DEF hostPath:OWNS STRING, stat:_stat, isReallyFileNotDir:BOOL
	
	->use check
	IF path = NIL THEN Throw("EPU", 'cPath; DeletePath(); path=NILA')
	
	success := TRUE
	
	hostPath := ExportPath(path)
	
	IF access(hostPath, 0) = -1 THEN RETURN FALSE	->return failure if file/dir does not exist
	IF stat(hostPath, stat) = -1 THEN Throw("FILE", posixFailureReason('cPath; DeletePath(); stat() failed'))
	isReallyFileNotDir := s_ISREG(stat.mode)		->s_ISDIR(stat.mode) = FALSE
	
	IF fileOrDir = FALSE
		IF isReallyFileNotDir <> IsFile(path)
			->expected file, but was dir, or vice versa
			RETURN FALSE
		ENDIF
	ENDIF
	
	IF force THEN chmod(hostPath, stat.mode OR S_IWUSR OR S_IRUSR)
	
	success := (0 = IF isReallyFileNotDir THEN unlink(hostPath) ELSE rmdir(hostPath))
FINALLY
	END hostPath
ENDPROC

->returns if the file/dir exists
->NOTE: If fileOrDir=TRUE then it will detect the named item, ignoring whether it is a file or directory (since many filingsystems disallow files with the same names as directories).
PROC ExistsPath(path:ARRAY OF CHAR, fileOrDir=FALSE:BOOL) RETURNS exists:BOOL REPLACEMENT
	DEF hostPath:OWNS STRING, stat:_stat, isReallyFileNotDir:BOOL
	
	->use check
	IF path = NIL THEN Throw("EPU", 'cPath; ExistsPath(); path=NILA')
	
	hostPath := ExportPath(path)
	
	IF access(hostPath, 0) = -1 THEN RETURN FALSE	->return failure if file/dir does not exist
	IF stat(hostPath, stat) = -1 THEN Throw("FILE", posixFailureReason('cPath; ExistsPath(); stat() failed'))
	
	IF fileOrDir = FALSE
		isReallyFileNotDir := s_ISREG(stat.mode)		->s_ISDIR(stat.mode) = FALSE
		IF isReallyFileNotDir <> IsFile(path)
			->expected file, but was dir, or vice versa
			RETURN FALSE
		ENDIF
	ENDIF
	
	exists := TRUE
FINALLY
	END hostPath
ENDPROC

PROC RenamePath(origPath:ARRAY OF CHAR, newPath:ARRAY OF CHAR, force=FALSE:BOOL) RETURNS success:BOOL REPLACEMENT
	DEF hostOrigPath:OWNS STRING, hostNewPath:OWNS STRING, stat:_stat
	
	success := FALSE
	
	hostOrigPath := ExportPath(origPath)
	hostNewPath  := ExportPath( newPath)
	
	->check read/write access, like open() would require to rename
	IF stat(hostOrigPath, stat) <> -1
		IF stat.mode AND (S_IRUSR OR S_IWUSR) = 0
			->(file is read/write protected)
			IF force = FALSE THEN RETURN
			->pretend we changed the protection bits, since they would be changed back immediately anyway
		ENDIF
	ENDIF
	
	->perform rename
	success := IF rename(hostOrigPath, hostNewPath) <> -1 THEN TRUE ELSE FALSE
FINALLY
	END hostOrigPath, hostNewPath
ENDPROC

PROC CreateLink(path:ARRAY OF CHAR, targetPath:ARRAY OF CHAR, specific:QUAD) RETURNS success:BOOL, unknown:BOOL REPLACEMENT
#ifdef pe_TargetOS_Linux
	DEF hostPath:OWNS STRING, hostTargetPath:OWNS STRING
	
	IF specific <> "SLNK" THEN RETURN FALSE, TRUE
	
	hostPath       := ExportPath(path)
	hostTargetPath := ExportPath(targetPath)
	
	success := symlink(hostTargetPath, hostPath) = 0
	unknown := FALSE
FINALLY
	END hostPath, hostTargetPath
#else
	->Throw("BUG", 'cPath; CreateLink(); this is currently unsupported by POSIX targets')
	path := NILA ; targetPath := NILA ; specific := 0
	success := FALSE ; unknown := TRUE
#endif
ENDPROC

PROC ReadLink(path:ARRAY OF CHAR) RETURNS targetPath:OWNS STRING, specific:QUAD REPLACEMENT
#ifdef pe_TargetOS_Linux
	DEF hostPath:OWNS STRING, linkIs0unknown1none2soft
	
	hostPath := ExportPath(path)
	targetPath, linkIs0unknown1none2soft := getLink(hostPath, IsDir(path))
	IF linkIs0unknown1none2soft
		SELECT 4 OF linkIs0unknown1none2soft
	->	CASE 3 ; specific := "HLNK"
		CASE 2 ; specific := "SLNK"
		CASE 1 ; specific := 0
		CASE 0 ; specific := "LINK"
		ENDSELECT
	ELSE
		targetPath := NILS
		specific   := 0
	ENDIF
FINALLY
	END hostPath
#else
->Throw("BUG", 'cPath; ReadLink(); this is currently unsupported by POSIX targets')
	path := NILA
	targetPath := NILS ; specific := 0
#endif
ENDPROC

PRIVATE

#ifdef pe_TargetOS_Linux
PROC getLink(hostPath:STRING, isDir=FALSE:BOOL) RETURNS linkPath:OWNS STRING, linkIs0unknown1none2soft
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
		IF isDir
			linkPath := ImportDirPath( hostLinkPath)
		ELSE
			linkPath := ImportFilePath(hostLinkPath)
		ENDIF
		linkIs0unknown1none2soft := 2
	ELSE
		linkIs0unknown1none2soft := 1	-># this could be wrong, should really check errno
	ENDIF
FINALLY
	END hostLinkPath
ENDPROC
#endif

#ifdef pe_TargetOS_Windows
->get rid of Window's strange "drive working directory" concept
->Note: It returns the supplied path with the working directory removed - or it returns NILS if there would be no change.
PROC expandWorkingDir(hostPath:ARRAY OF CHAR, hostPathLength) RETURNS newHostPath:OWNS STRING
	DEF driveLetter:CHAR, driveNumber, driveOffset, driveHostPath:ARRAY OF CHAR, driveHostSlash:ARRAY OF CHAR
	
	driveHostPath := NILA
	
	driveNumber := -1
	IF hostPathLength >= 1
		IF (hostPath[0] = ":") AND (hostPath[1] <> "\\")
			driveOffset := 1 * SIZEOF CHAR
			driveNumber := 0
		ENDIF
	ENDIF
	IF hostPathLength >= 2
		IF (hostPath[1] = ":") AND (hostPath[2] <> "\\")
			driveOffset := 2 * SIZEOF CHAR
			driveLetter := hostPath[0]
			driveNumber := driveLetter + 1 - IF (driveLetter >= "a") AND (driveLetter <= "z") THEN "a" ELSE "A"
		ENDIF
	ENDIF
	
	IF (driveNumber >= 0) AND (driveNumber <= 26)
		driveHostPath  := _getdcwd(driveNumber, NILA, 1)
		driveHostSlash := IF driveHostPath[StrLen(driveHostPath)-1] <> "\\" THEN '\\' ELSE NILA
		newHostPath := StrJoin(driveHostPath, driveHostSlash, hostPath + driveOffset !!ARRAY OF CHAR)
	ENDIF
FINALLY
	IF exception THEN END newHostPath
	IF driveHostPath THEN NATIVE {free(} driveHostPath {)} ENDNATIVE
ENDPROC
#endif

->implementation that's shared by both ImportDirPath() & ImportFilePath
PROC importFileDirPath(hostPath:ARRAY OF CHAR, hostPathLength) RETURNS path:OWNS STRING
	DEF newHostPath:OWNS STRING
	#ifdef pe_TargetOS_Windows
	DEF pos
	#else
	DEF insertColonBefore, drive:STRING, driveLen
	#endif
	
	#ifdef pe_TargetOS_Windows
		->get rid of Window's strange "drive working directory" concept
		IF newHostPath := expandWorkingDir(hostPath, hostPathLength)
			hostPath := newHostPath
			hostPathLength := EstrLen(newHostPath)
		ENDIF
	#else
		->mark deepest mount point with a colon as a logical drive (as long as it's not already a logical drive), e.g. '/media/usbstick:/foobar.txt',
		->which at worst will make absolute paths be inside the root drive, so it's not treated as a relative path; e.g. ':/root/foobar.txt'
		IF (hostPath[0] = "/") AND (InStr(hostPath, ':') = -1)
			insertColonBefore := -1
			
			->check if mount point needs updating
			updateMountList()
			
			->check for mount point
			drive := mountList
			WHILE drive
				driveLen := EstrLen(drive)
				IF StrCmpPath(hostPath, drive, driveLen) THEN insertColonBefore := driveLen - 1
				
				drive := Next(drive)
			ENDWHILE IF insertColonBefore <> -1
			
			->if a drive was found then insert a colon after it
			IF insertColonBefore <> -1
				NEW newHostPath[1+StrLen(hostPath)]
				StrCopy(newHostPath, hostPath, insertColonBefore)
				StrAdd( newHostPath, ':')
				StrAdd( newHostPath, hostPath, ALL, insertColonBefore)
				hostPath := newHostPath
				hostPathLength++
			ENDIF
		ENDIF
	#endif
	
	->copy hostPath
	path := NewString(hostPathLength + 1)	->extra character for possible end slash
	StrCopy(path, hostPath)
	
	#ifdef pe_TargetOS_Windows
		->convert all back slashes to forward slashes
		pos := 0
		WHILE (pos := InStr(path, '\\', pos)) <> -1 DO path[pos] := "/"
	#endif
FINALLY
	END newHostPath
ENDPROC

#ifdef pe_TargetOS_Linux
DEF mountList:OWNS STRING, mountFd=-1

PROC updateMountList()
	DEF proc_mounts:ARRAY OF CHAR, mounts:PTR TO FILE, entry:PTR TO mntent, drive:OWNS STRING
	DEF fds:fd_set, tv:timeval
	
	proc_mounts := '/proc/self/mounts'
	IF mountFd = -1 THEN mountFd := open(proc_mounts, O_RDONLY, 0)
	
	IF mountList
		->(we already have a mount list) so check if it needs to be updated
    	fd_zero(fds)
	    fd_set(mountFd, fds)
    	tv.sec  := 0
	    tv.usec := 0
		IF select(mountFd+1, NIL, NIL, fds, tv) > 0
			IF fd_isset(mountFd, fds) THEN END mountList	->Print('Mount points changed.\n') ELSE Print('UNEXPECTED no mount point changes.\n')
		ENDIF
	ENDIF
	
	IF mountList = NILS
		->(no mount list or it needs updating) so store a new mount list
		mountList := NEW ''
		IF mounts := setmntent(proc_mounts, 'r')
			->store list of all mount points in reverse alphabetical order, so that the deepest device in a path matches first
			WHILE entry := getmntent(mounts)
				->Print('* (\s) "\s"\n', entry.fsname, entry.dir)
				NEW drive[StrLen(entry.dir)+1]
				StrCopy(drive, entry.dir)
				IF drive[EstrLen(drive)-1] <> "/" THEN StrAdd(drive, '/')
				
				StrListInsertSorted(mountList, PASS drive, /*order*/ -1)
			ENDWHILE
			
			endmntent(mounts)
		ENDIF
		
		IF Next(mountList) = NILS
			->(nothing is supposedly mounted, probably due to an error) so at least mark the root drive as a mount point
			drive := NEW '/'
			StrListInsertSorted(mountList, PASS drive, /*order*/ -1)
		ENDIF
	ENDIF
ENDPROC

PROC end_drives()
	END mountList
	IF mountFd >= 0 THEN close(mountFd) ; mountFd := -1
ENDPROC
#else
PROC end_drives() IS EMPTY
#endif

PUBLIC

->converts a dirpath in host-OS format into our proper format, returning a new estring
PROC ImportDirPath(hostDirPath:ARRAY OF CHAR) RETURNS dirPath:OWNS STRING REPLACEMENT
	DEF hostDirPathLength
	
	IF hostDirPath = NILA THEN RETURN NILS
	
	hostDirPathLength := StrLen(hostDirPath)
	IF hostDirPathLength = 0 THEN RETURN NEW ''
	
	dirPath := importFileDirPath(hostDirPath, hostDirPathLength)
	
	->add expected slash to end of dirPath, if not already have one
	IF dirPath[EstrLen(dirPath) - 1] <> "/" THEN StrAdd(dirPath, '/')
ENDPROC

->converts a filepath in host-OS format into our proper format, returning a new estring
PROC ImportFilePath(hostFilePath:ARRAY OF CHAR) RETURNS filePath:OWNS STRING REPLACEMENT
	DEF hostFilePathLength
	
	IF hostFilePath = NILA THEN RETURN NILS
	
	hostFilePathLength := StrLen(hostFilePath)
	
	filePath := importFileDirPath(hostFilePath, hostFilePathLength)
	
	->strip any end-slash character that would be wrongly interpreted
	IF filePath[EstrLen(filePath)-1] = "/" THEN SetStr(filePath, EstrLen(filePath)-1)
ENDPROC

->converts a path from our proper format into host-OS format, returning a new estring
PROC ExportPath(path:ARRAY OF CHAR) RETURNS hostPath:OWNS STRING REPLACEMENT
	DEF fullPath:OWNS STRING, isDir:BOOL, pathLength, pos, tempPath:OWNS STRING
	
	IF path = NILA THEN RETURN NILS
	
	IF path[0] = 0
		->(empty path) so replace with actual path
		fullPath := CurrentDirPath()
		path := fullPath
	ENDIF
	
	->->use check
	->IF path = NIL THEN Throw("EPU", 'cPath; ExportPath(); path=NIL')
	
	IF isDir := IsDir(path)
		IF InvalidDirPath(path) THEN Throw("EPU", 'cPath(); ExportPath(); path is invalid')
	ELSE
		IF InvalidFilePath(path) THEN Throw("EPU", 'cPath(); ExportPath(); path is invalid')
	ENDIF
	
	->copy path, with assignments expanded
	hostPath := applyAssignments(path)
	pathLength := EstrLen(hostPath)
	
	IF isDir
		#ifdef pe_TargetOS_Windows
			IF pathLength >= 2 THEN IF hostPath[pathLength - 2] <> ":" THEN SetStr(hostPath, pathLength - 1)		->strip trailing \ from all except root drive (which Windows treats as a relative path)
		#else
			IF StrCmp(hostPath, ':/') = FALSE THEN SetStr(hostPath, pathLength - 1)		->strip trailing / from all except the root drive ':/' (as we need it so the final path is '/' after the colon is removed)
		#endif
	ENDIF
	
	#ifdef pe_TargetOS_Windows
		->convert all forward slashes to back slashes
		pos := 0
		WHILE (pos := InStr(hostPath, '/', pos)) <> -1 DO hostPath[pos] := "\\"
	#endif
	
	#ifdef pe_TargetOS_Linux
		->convert drives back to absolute paths
		pos := InStr(hostPath, ':')
		IF pos = -1
			->(no drive colon)
		ELSE IF pos = 0
			->(this is the 'root drive') so just remove colon from start
			StrCopy(hostPath, hostPath, ALL, 1)
		ELSE
			->remove colon from path
			tempPath := PASS hostPath
			NEW hostPath[Max(1,EstrLen(tempPath)-1)]
			StrCopy(hostPath, tempPath, pos)
			StrAdd( hostPath, tempPath, ALL, pos+1)
		ENDIF
	#endif
FINALLY
	END fullPath, tempPath
ENDPROC

->ensure that path is fully expanded to the full physical path (removing any aliases or links or assignments)
PROC ExpandPath(path:ARRAY OF CHAR) RETURNS expandedPath:OWNS STRING REPLACEMENT
	DEF currentDirPath:OWNS STRING, i, chara:CHAR, containsDevice:BOOL, completePath:OWNS STRING
	
	->ensure path is absolute (not relative) and has assignments expanded
	containsDevice := FALSE
	i := 0
	WHILE chara := path[i++]
		IF chara = ":" THEN containsDevice := TRUE
	ENDWHILE
	
	IF containsDevice
		->(has device) so make copy by expanding assignments
		completePath := applyAssignments(path)
	ELSE
		->(no device) so add current path
		currentDirPath := CurrentDirPath()
		NEW completePath[EstrLen(currentDirPath) + StrLen(path)]
		StrCopy(completePath, currentDirPath)
		StrAdd( completePath, path)
	ENDIF
	
	->expand path
	expandedPath := fullpath(completePath, EstrLen(completePath) + 128)
	IF expandedPath = NILS THEN Throw("FILE", posixFailureReason('cPath; ExpandPath(); fullpath() failed'))
FINALLY
	IF exception THEN END expandedPath
	END currentDirPath, completePath
ENDPROC


/*****************************/ ->cHostExtra class has host OS implementation
CLASS cHostExtra OF cExtra PRIVATE
	mode
#ifdef pe_TargetOS_Linux
	linkPath:OWNS STRING
	linkIs0unknown1none2soft
#endif
ENDCLASS

->PRIVATE, do not use!
PROC new() OF cHostExtra
	self.mode := 0
#ifdef pe_TargetOS_Linux
	self.linkPath := NILS
	self.linkIs0unknown1none2soft := 0
#endif
ENDPROC

PROC end() OF cHostExtra
#ifdef pe_TargetOS_Linux
	END self.linkPath
#endif
ENDPROC

->NOTE: Unlike cFile/cDir, this will clear stuff that is not supported in the place the 
->      extra originated from (which does NOT generate a failure).
PROC setExtra(extra:PTR TO cExtra) OF cHostExtra RETURNS success:BOOL
	DEF value, unknown:BOOL
	
	success := TRUE
	
	value, unknown := extra.queryExtra("ATTR")
	success := success AND self.changeExtra("ATTR", IF unknown = FALSE THEN value ELSE 0)
	
#ifdef pe_TargetOS_Linux
	value, unknown := extra.queryExtra("SLNK")
	success := success AND self.changeExtra("SLNK", IF unknown = FALSE THEN value ELSE NILS)
#endif
ENDPROC

PROC getExtra() OF cHostExtra RETURNS extra:OWNS PTR TO cExtra
	DEF hostExtra:OWNS PTR TO cHostExtra
	NEW hostExtra.new()
	hostExtra.setExtra(self)
	RETURN hostExtra
ENDPROC

PROC changeExtra(specific:QUAD, value) OF cHostExtra RETURNS success:BOOL, unknown:BOOL
	DEF linkType
	
	linkType := IF specific = "SLNK" THEN 2 ELSE /*IF specific = "HLNK" THEN 3 ELSE*/ 0
	IF linkType THEN specific := "link" ELSE IF specific = "link" THEN specific := 0
	
	success := TRUE
	unknown := FALSE
	SELECT specific
	CASE "ATTR"
		self.mode := value
#ifdef pe_TargetOS_Linux
	CASE "link"
		IF value
			END self.linkPath
			self.linkPath := StrJoin(value!!ARRAY OF CHAR)
			self.linkIs0unknown1none2soft := linkType
		ELSE
			->(removing link)
			IF (self.linkIs0unknown1none2soft = linkType) OR (self.linkIs0unknown1none2soft = 0)		->this allows cHostExtra.setExtra() to work as expected
				->(there is a link to be removed)
				END self.linkPath
				self.linkIs0unknown1none2soft := 1
			ENDIF
		ENDIF
#endif
	DEFAULT
		success := FALSE
		unknown := TRUE
	ENDSELECT
ENDPROC

PROC queryExtra(specific:QUAD) OF cHostExtra RETURNS value, unknown:BOOL
	value := 0
	unknown := FALSE
	SELECT specific
	CASE "ATTR"
		value := self.mode
#ifdef pe_TargetOS_Linux
	CASE "SLNK"
		value := IF self.linkIs0unknown1none2soft = 2 THEN self.linkPath ELSE NILS
	CASE "LINK"
		value := self.linkPath
#endif
	DEFAULT
		unknown := TRUE
	ENDSELECT
ENDPROC


/*****************************/ ->assignment emulation
PRIVATE
PROC getenv(name:ARRAY OF CHAR) IS NATIVE {getenv(} name {)} ENDNATIVE !!ARRAY OF CHAR

PROC new_assignments()
	DEF home:OWNS STRING, userAssignFile:OWNS STRING
	
	#ifdef pe_TargetOS_Windows
		home := ImportDirPath(getenv('USERPROFILE'))
		userAssignFile := StrJoin(home, 'Assignments.txt')
		
		addAssignment(NEW 'HOME', PASS home)
		loadAssignmentsFile('C:/Assignments.txt')			->global assignments #2
		loadAssignmentsFile('C:/PortablE/Assignments.txt')	->global assignments #1
		loadAssignmentsFile(userAssignFile)					->  user assignments takes precedence over global ones
		->loadAssignmentsFile('Assignments.txt')			-> local assignments take precedence over user one
	#else
		home := ImportDirPath(getenv('HOME'))
		userAssignFile := StrJoin(home, '.portable/Assignments.txt')
		
		addAssignment(NEW 'HOME', PASS home)
		loadAssignmentsFile(':/root/.portable/Assignments.txt')	->global assignments
		loadAssignmentsFile(userAssignFile)						->  user assignments takes precedence over global one
		->loadAssignmentsFile('.assignments.txt')				-> local assignments take precedence over user one
	#endif
	
	->warn user against using PortablE programs as root
	#ifdef pe_TargetOS_Linux
		IF StrCmp('root', getenv('USER')) THEN Print('WARNING: PortablE\'s Linux port needs more testing before programs like this are run as "root".\n')
	#endif
FINALLY
	END home, userAssignFile
ENDPROC

PROC end_assignments()
	DEF node:OWNS PTR TO assignNode, next:OWNS PTR TO assignNode
	next := PASS firstAssignment
	WHILE next
		node := PASS next
		next := PASS node.next
		END node
	ENDWHILE
FINALLY
	PrintException()
ENDPROC


CLASS assignNode PUBLIC
	from:OWNS STRING
	to  :OWNS STRING
	next:OWNS PTR TO assignNode
ENDCLASS

PROC new(from:OWNS STRING, to:OWNS STRING) OF assignNode
	self.from := PASS from
	self.to   := PASS to
	self.next := NIL
ENDPROC

PROC end() OF assignNode
	DEF node:OWNS PTR TO assignNode, next:OWNS PTR TO assignNode
	
	node := PASS self.next
	WHILE node
		next := PASS node.next
		END node
		node := PASS next
	ENDWHILE
	
	END self.from
	END self.to
	SUPER self.end()
ENDPROC

DEF firstAssignment=NIL:OWNS PTR TO assignNode

PROC addAssignment(from:OWNS STRING, to:OWNS STRING)
	DEF node:OWNS PTR TO assignNode, importedTo:OWNS STRING
	
	importedTo := ImportDirPath(to)
	NEW node.new(PASS from, applyAssignments(importedTo))
	
	node.next := PASS firstAssignment
	firstAssignment := PASS node
FINALLY
	END from, to
	END node, importedTo
ENDPROC

PROC findAssignment(from:ARRAY OF CHAR) RETURNS to:STRING
	DEF node:PTR TO assignNode
	node := firstAssignment
	WHILE node
		IF StrCmpPath(node.from, from) THEN to := node.to
		
		node := node.next
	ENDWHILE IF to
ENDPROC

PROC applyAssignments(path:ARRAY OF CHAR) RETURNS newPath:OWNS STRING
	DEF device:OWNS STRING, deviceLen, assignment:STRING
	
	device := ExtractDevice(path)
	deviceLen := EstrLen(device)
	->IF deviceLen = 1 THEN Throw("BUG", 'applyAssignments(); ExtractDevice() returned string of length 1')
	IF (deviceLen <= 2) #ifdef pe_TargetOS_Linux OR (device[0] = "/") #endif
		->(no device, root device, or real device) so just return path as is
		newPath := StrJoin(path)
		RETURN
	ENDIF
	->(device should be an assignment)
	
	SetStr(device, deviceLen - 2)	->strip ':/' from end of device path
	assignment := findAssignment(device)
	IF assignment
		->replace device with assignment target in path
		NEW newPath[StrLen(path) - deviceLen + EstrLen(assignment)]
		StrCopy(newPath, assignment)
		StrAdd( newPath, path, ALL, deviceLen)
	ELSE
		->(unknown assignment)
		#ifdef pe_TargetOS_Linux
			->so force an absolute path that cannot exist
			newPath := StrJoin('/dev/null:/UNKNOWN_DEVICE/', path)
		#else
			->so just copy path as is
			newPath := StrJoin(path)
		#endif
	ENDIF
FINALLY
	IF exception THEN END newPath
	END device
ENDPROC


PROC loadAssignmentsFile(path:ARRAY OF CHAR)
	DEF fileDesc, hostPath:OWNS STRING
	DEF size, contents:OWNS ARRAY OF CHAR
	DEF pos, nextPos, line:OWNS STRING, lineSize
	DEF from:OWNS STRING, to:OWNS STRING, linePos
	
	fileDesc := -1
	
	hostPath := ExportPath(path)
	fileDesc := open(hostPath, O_BINARY OR O_RDONLY, S_IWUSR OR S_IRUSR)
	IF fileDesc <> -1
		->parse contents of file
		size := _filelengthi64(fileDesc) !!VALUE / SIZEOF CHAR
		NEW contents[size + 1]
		safeSeek(fileDesc, 0)
		IF read(fileDesc, contents, size * SIZEOF CHAR) = (size * SIZEOF CHAR)	->IF ... <> -1
			contents[size] := "\n"
			
			->loop through every line of file
			pos := 0
			WHILE pos < size
				->get next line
				nextPos := InStr(contents, '\n', pos)	->find LF
				IF nextPos = -1 THEN nextPos := size	->should be unnecessary
				
				lineSize := nextPos - pos
				NEW line[lineSize]
				StrCopy(line, contents, lineSize, pos)
				IF line[lineSize - 1] = "\b" THEN SetStr(line, lineSize - 1)	->strip CR (as line may end in a CRLF)
				
				->parse line, ignoring it if nonsensical
				linePos := InStr(line, ':')
				IF linePos <> -1
					->(virtual volume ends in a colon)
					NEW from[linePos]
					StrCopy(from, line)
					
					linePos := linePos + 1
					IF (line[linePos] = "\t") OR (line[linePos] = " ")
						->(two parts of line are separated by a tab)
						WHILE (line[linePos] = "\t") OR (line[linePos] = " ") AND (linePos < lineSize) DO linePos++
						
						NEW to[lineSize - linePos]
						StrCopy(to, line, ALL, linePos)
						
						#ifdef pe_TargetOS_Windows
							IF InStr(to, ':') <> -1
								->(target is an absolute path)
								addAssignment(PASS from, PASS to)
								
							ELSE IF StrCmp(to, '\\\\', 2)
								->(target is a network drive)
								addAssignment(PASS from, PASS to)
							ENDIF
						#else
							IF (to[0] = "/") OR (InStr(to, ':') <> -1)
								->(target is an absolute path)
								addAssignment(PASS from, PASS to)
							ENDIF
						#endif
					ENDIF
				ENDIF
				
				->move to next line
				END from, to, line
				pos := nextPos
				WHILE (contents[pos] = "\n") AND (pos < size) DO pos++
			ENDWHILE
			
		ENDIF
		END contents
	ENDIF
FINALLY
	IF fileDesc <> -1 THEN close(fileDesc) ; fileDesc := -1
	
	END hostPath
	END contents
	END line
	END from, to
ENDPROC

PUBLIC
