
#define	 DOSNAME  'dos.library'

/* Predefined Amiga DOS global constants */

CONST	DOSTRUE=-1,
		DOSFALSE=0

/* Mode parameter to Open() */
CONST	MODE_OLDFILE=1005,
						/* Open existing file read/write
						 * positioned at beginning of file. */
		MODE_NEWFILE=1006,
						/* Open freshly created file (delete
						 * old file) read/write, exclusive lock. */
		MODE_READWRITE=1004
						/* Open old file w/shared lock,
						 * creates file if doesn't exist. */

/* Relative position to Seek() */
CONST	OFFSET_BEGINNING=-1,	    /* relative to Begining Of File */
		OFFSET_CURRENT=	0,	    /* relative to Current file position */
		OFFSET_END=			1	    /* relative to End Of File	  */

CONST	OFFSET_BEGINING=OFFSET_BEGINNING  /* ancient compatibility */

CONST	BITSPERBYTE=8
CONST	BYTESPERLONG=4
CONST	BITSPERLONG=32
CONST	MAXINT=$7FFFFFFF
CONST	MININT=$80000000

/* Passed as type to Lock() */
CONST	SHARED_LOCK=-2	   	 /* File is readable by others */
CONST	ACCESS_READ=-2		    /* Synonym */
CONST	EXCLUSIVE_LOCK=-1	    /* No other access allowed	  */
CONST	ACCESS_WRITE=-1	    /* Synonym */

OBJECT DateStamp
	Days:LONG,	      /* Number of days since Jan. 1, 1978 */
	Minute:LONG,      /* Number of minutes past midnight */
	Tick:LONG	      /* Number of ticks past minute */

#define TICKS_PER_SECOND 50   /* Number of ticks in one second */

/* Returned by Examine() and ExNext(), must be on a 4 byte boundary */
OBJECT FileInfoBlock|FIB
	DiskKey:LONG,
	DirEntryType:LONG,	/* Type of Directory. If < 0, then a plain file.
								 * If > 0 a directory */
	FileName[108]:CHAR,	/* Null terminated. Max 30 chars used for now */
	Protection:LONG,		/* bit mask of protection, rwxd are 3-0.	   */
	EntryType:LONG,
	Size:LONG,				/* Number of bytes in file */
	NumBlocks:LONG,		/* Number of blocks in file */
	Date:DateStamp,		/* Date file last changed */
	Comment[80]:CHAR,	/* Null terminated comment associated with file */
	
   /* Note: the following fields are not supported by all filesystems.	*/
   /* They should be initialized to 0 sending an ACTION_EXAMINE packet.	*/
   /* When Examine() is called, these are set to 0 for you.		*/
   /* AllocDosObject() also initializes them to 0.			*/
	OwnerUID:UWORD,		/* owner's UID */
	OwnerGID:UWORD,		/* owner's GID */

	Reserved[32]:CHAR

/* FIB stands for FileInfoBlock */

/* FIBB are bit definitions, FIBF are field definitions */
/* Regular RWED bits are 0 == allowed. */
/* NOTE: GRP and OTR RWED permissions are 0 == not allowed! */
/* Group and Other permissions are not directly handled by the filesystem */
#define FIBB_OTR_READ	   15	/* Other: file is readable */
#define FIBB_OTR_WRITE	   14	/* Other: file is writable */
#define FIBB_OTR_EXECUTE   13	/* Other: file is executable */
#define FIBB_OTR_DELETE    12	/* Other: prevent file from being deleted */
#define FIBB_GRP_READ	   11	/* Group: file is readable */
#define FIBB_GRP_WRITE	   10	/* Group: file is writable */
#define FIBB_GRP_EXECUTE   9	/* Group: file is executable */
#define FIBB_GRP_DELETE    8	/* Group: prevent file from being deleted */

#define FIBB_SCRIPT    6		/* program is a script (execute) file */
#define FIBB_PURE      5		/* program is reentrant and rexecutable */
#define FIBB_ARCHIVE   4		/* cleared whenever file is changed */
#define FIBB_READ      3		/* ignored by old filesystem */
#define FIBB_WRITE     2		/* ignored by old filesystem */
#define FIBB_EXECUTE   1		/* ignored by system, used by Shell */
#define FIBB_DELETE    0		/* prevent file from being deleted */

#define FIBF_OTR_READ	   (1<<FIBB_OTR_READ)
#define FIBF_OTR_WRITE	   (1<<FIBB_OTR_WRITE)
#define FIBF_OTR_EXECUTE   (1<<FIBB_OTR_EXECUTE)
#define FIBF_OTR_DELETE    (1<<FIBB_OTR_DELETE)
#define FIBF_GRP_READ	   (1<<FIBB_GRP_READ)
#define FIBF_GRP_WRITE	   (1<<FIBB_GRP_WRITE)
#define FIBF_GRP_EXECUTE   (1<<FIBB_GRP_EXECUTE)
#define FIBF_GRP_DELETE    (1<<FIBB_GRP_DELETE)

#define FIBF_SCRIPT    (1<<FIBB_SCRIPT)
#define FIBF_PURE      (1<<FIBB_PURE)
#define FIBF_ARCHIVE   (1<<FIBB_ARCHIVE)
#define FIBF_READ      (1<<FIBB_READ)
#define FIBF_WRITE     (1<<FIBB_WRITE)
#define FIBF_EXECUTE   (1<<FIBB_EXECUTE)
#define FIBF_DELETE    (1<<FIBB_DELETE)

/* Standard maximum length for an error string from fault.  However, most */
/* error strings should be kept under 60 characters if possible.  Don't   */
/* forget space for the header you pass in. */
#define FAULT_MAX	82

/* BCPL strings have a length in the first byte and then the characters.
 * For example:	 s[0]=3 s[1]=S s[2]=Y s[3]=S				 */

/* returned by Info(), must be on a 4 byte boundary */
OBJECT InfoData
	NumSoftErrors:LONG,	/* number of soft errors on disk */
	UnitNumber:LONG,		/* Which unit disk is (was) mounted on */
	DiskState:LONG,			/* See defines below */
	NumBlocks:LONG,			/* Number of blocks on disk */
	NumBlocksUsed:LONG,	/* Number of block in use */
	BytesPerBlock:LONG,
	DiskType:LONG,			/* Disk Type code */
	VolumeNode:BPTR,		/* BCPL pointer to volume node */
	InUse:LONG				/* Flag, zero if not in use */

/* ID stands for InfoData */
	/* Disk states */
#define ID_WRITE_PROTECTED	80	 /* Disk is write protected */
#define ID_VALIDATING		81	 /* Disk is currently being validated */
#define ID_VALIDATED			82	 /* Disk is consistent and writeable */

	/* Disk types */
/* ID_INTER_* use international case comparison routines for hashing */
/* Any other new filesystems should also, if possible. */
#define ID_NO_DISK_PRESENT		-1
#define ID_UNREADABLE_DISK		$42414400	/* 'BAD\0' */
#define ID_DOS_DISK				$444F5300	/* 'DOS\0' */
#define ID_FFS_DISK				$444F5301	/* 'DOS\1' */
#define ID_INTER_DOS_DISK		$444F5302	/* 'DOS\2' */
#define ID_INTER_FFS_DISK		$444F5303	/* 'DOS\3' */
#define ID_FASTDIR_DOS_DISK	$444F5304	/* 'DOS\4' */
#define ID_FASTDIR_FFS_DISK	$444F5305	/* 'DOS\5' */
#define ID_NOT_REALLY_DOS		$4E444F53	/* 'NDOS'  */
#define ID_KICKSTART_DISK		$4B49434B	/* 'KICK'  */
#define ID_MSDOS_DISK			$4d534400	/* 'MSD\0' */

/* Errors from IoErr(), etc. */
CONST	ERROR_NO_FREE_STORE			=103,
		ERROR_TASK_TABLE_FULL		=105,
		ERROR_BAD_TEMPLATE			=114,
		ERROR_BAD_NUMBER				=115,
		ERROR_REQUIRED_ARG_MISSING	=116,
		ERROR_KEY_NEEDS_ARG			=117,
		ERROR_TOO_MANY_ARGS			=118,
		ERROR_UNMATCHED_QUOTES		=119,
		ERROR_LINE_TOO_LONG			=120,
		ERROR_FILE_NOT_OBJECT		=121,
		ERROR_INVALID_RESIDENT_LIBRARY=122,
		ERROR_NO_DEFAULT_DIR			=201,
		ERROR_OBJECT_IN_USE			=202,
		ERROR_OBJECT_EXISTS			=203,
		ERROR_DIR_NOT_FOUND			=204,
		ERROR_OBJECT_NOT_FOUND		=205,
		ERROR_BAD_STREAM_NAME		=206,
		ERROR_OBJECT_TOO_LARGE		=207,
		ERROR_ACTION_NOT_KNOWN	 	=209,
		ERROR_INVALID_COMPONENT_NAME=210,
		ERROR_INVALID_LOCK			=211,
		ERROR_OBJECT_WRONG_TYPE		=212,
		ERROR_DISK_NOT_VALIDATED	=213,
		ERROR_DISK_WRITE_PROTECTED	=214,
		ERROR_RENAME_ACROSS_DEVICES=215,
		ERROR_DIRECTORY_NOT_EMPTY	=216,
		ERROR_TOO_MANY_LEVELS		=217,
		ERROR_DEVICE_NOT_MOUNTED	=218,
		ERROR_SEEK_ERROR				=219,
		ERROR_COMMENT_TOO_BIG		=220,
		ERROR_DISK_FULL				=221,
		ERROR_DELETE_PROTECTED		=222,
		ERROR_WRITE_PROTECTED		=223,
		ERROR_READ_PROTECTED			=224,
		ERROR_NOT_A_DOS_DISK			=225,
		ERROR_NO_DISK					=226,
		ERROR_NO_MORE_ENTRIES		=232,
/* added for 1.4 */
		ERROR_IS_SOFT_LINK			=233,
		ERROR_OBJECT_LINKED			=234,
		ERROR_BAD_HUNK					=235,
		ERROR_NOT_IMPLEMENTED		=236,
		ERROR_RECORD_NOT_LOCKED		=240,
		ERROR_LOCK_COLLISION			=241,
		ERROR_LOCK_TIMEOUT			=242,
		ERROR_UNLOCK_ERROR			=243

/* error codes 303-305 are defined in dosasl.h */

/* These are the return codes used by convention by AmigaDOS commands */
/* See FAILAT and IF for relvance to EXECUTE files		      */
CONST	RETURN_OK		=0,	/* No problems, success */
		RETURN_WARN		=5,	/* A warning only */
		RETURN_ERROR	=10,	/* Something wrong */
		RETURN_FAIL		=20	/* Complete or severe failure*/

/* Bit numbers that signal you that a user has issued a break */
FLAG	SIGBREAK_CTRL_C=12,
		SIGBREAK_CTRL_D,
		SIGBREAK_CTRL_E,
		SIGBREAK_CTRL_F

/* Values returned by SameLock() */
#define LOCK_DIFFERENT		-1
#define LOCK_SAME				0
#define LOCK_SAME_VOLUME	1	/* locks are on same volume */
#define LOCK_SAME_HANDLER	LOCK_SAME_VOLUME
/* LOCK_SAME_HANDLER was a misleading name, def kept for src compatibility */

/* types for ChangeMode() */
#define CHANGE_LOCK	0
#define CHANGE_FH		1

/* Values for MakeLink() */
#define LINK_HARD	0
#define LINK_SOFT	1	/* softlinks are not fully supported yet */

/* values returned by ReadItem */
#define	ITEM_EQUAL		-2		/* "=" Symbol */
#define ITEM_ERROR		-1		/* error */
#define ITEM_NOTHING		0		/* *N, ;, endstreamch */
#define ITEM_UNQUOTED	1		/* unquoted item */
#define ITEM_QUOTED		2		/* quoted item */

/* types for AllocDosObject/FreeDosObject */
#define DOS_FILEHANDLE		0	/* few people should use this */
#define DOS_EXALLCONTROL	1	/* Must be used to allocate this! */
#define DOS_FIB				2	/* useful */
#define DOS_STDPKT			3	/* for doing packet-level I/O */
#define DOS_CLI				4	/* for shell-writers, etc */
#define DOS_RDARGS			5	/* for ReadArgs if you pass it in */
