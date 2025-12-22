/*
 *	unRkv.e		Rick Younie rick@emma.panam.wimsey.com
 *
 *		- make a list of all files/dirs in directories
 *		- show the unarchived files in multiple directories &
 *			optionally, the number of bytes
 *		- unrkv dir1 dir2.. size
 */

MODULE 'dos/dos'

ENUM ER_NONE,
	ER_NOLOCK,
	ER_EXAMINE,
	ER_CTRLC,
	ER_MEM,
	ER_NOARGS,
	ER_ARGS

ENUM RD_DIR,
	RD_BYTES,
	RD_NUMARGS

RAISE ER_NOLOCK IF Lock ()=NIL,
	ER_EXAMINE IF Examine ()=NIL,
	ER_CTRLC IF CtrlC ()=TRUE,
	ER_MEM IF String ()=NIL

DEF	bytes,
	size=FALSE		/* cmd line flag to include file size */

PROC main() HANDLE

	DEF	info:fileinfoblock,
		lock=NIL,

		args[RD_NUMARGS]:ARRAY OF LONG,
		anchor=NIL,
		dirs:PTR TO LONG,	/* ie, a pointer to an array of strings */
		i=0,
		tmp,
		dirTmp,
		lastChar

	/* must be cleared */
	FOR tmp:=0 TO RD_NUMARGS-1 DO args[tmp]:=0

	IF (anchor:=ReadArgs ('Dir/A/M,Size/S', args, NIL))=NIL OR
		(dirs:=args[RD_DIR])=NIL THEN Raise (ER_NOARGS)

	IF args[RD_BYTES] THEN size := TRUE

	/*
	 *	see if all args are valid directories
	 */
	WHILE (dirTmp:=dirs[i])

		lock:=Lock (dirTmp,ACCESS_READ)
		Examine (lock,info)
		UnLock (lock)

		IF info.direntrytype<0 THEN Raise (ER_NOLOCK)

		/* make sure directory ends in : or / */
		lastChar:=StrLen(dirTmp) - 1
		IF (dirTmp[lastChar] <> ":") AND (dirTmp[lastChar] <> "/") THEN
			Raise (ER_ARGS)
		INC i
	ENDWHILE

	/*
	 * args are all directories; do for each
	 */
	i := 0
	WHILE (dirs[i])
		dodir (dirs[i])
		INC i
	ENDWHILE

	IF size THEN WriteF ('\r\d[9] TOTAL\n', bytes)
	Raise (0)

EXCEPT
	SELECT exception
		CASE ER_NOLOCK
			WriteF ('\s isn''t a directory\n',dirs[i])
		CASE ER_EXAMINE
			WriteF ('Examine() failed on \s\n',dirs[i])
			UnLock (lock)
		CASE ER_NOARGS
			WriteF ('**Error** ..no arguments\n')
		CASE ER_ARGS
			WriteF ('\s doesn''t end in / or :\n',dirTmp)
	ENDSELECT
	FreeArgs (anchor)
ENDPROC



/*
 *	print each directory; then each file in that directory
 *
 */
PROC dodir (dir) HANDLE

	DEF info:fileinfoblock,
		lock=NIL,
		nextdir=NIL

	/* get a lock on the new directory */
	lock:=Lock (dir,ACCESS_READ)

	/* fill the object block */
	Examine (lock,info)

	/* do for files */
	WHILE ExNext (lock,info)
		CtrlC ()
		IF info.direntrytype<0

			/* if unarchived flag, print it */
            IF (info.protection AND $10) = 0
				IF size THEN WriteF ('\r\d[9] ',info.size)
                WriteF ('\s\s\n',dir,info.filename)
                bytes:=bytes+info.size
			ENDIF

		ENDIF
	ENDWHILE



	/* do again for directories this time */
	Examine (lock,info)

	WHILE ExNext (lock,info)
		CtrlC ()
		IF info.direntrytype>0
			nextdir:=String (EstrLen (nextdir) + StrLen (info.filename)+1)
			StrCopy (nextdir, dir, ALL)
			StrAdd (nextdir, info.filename, ALL)
			StrAdd (nextdir,'/',1)
			dodir (nextdir)
		ENDIF
	ENDWHILE

	UnLock (lock)

EXCEPT
	SELECT exception
		CASE ER_CTRLC; WriteF ('**User abort**\n')
		CASE ER_NOLOCK; WriteF ('..couldn''t get a lock on \s\n',info.filename) 
		CASE ER_EXAMINE; WriteF ('Examine () had trouble in sub\n')
		CASE ER_MEM; WriteF ('**ERROR** ..no memory\n')
	ENDSELECT
	IF lock THEN UnLock (lock)
	Raise (0)
ENDPROC	
