/* $VER: dos.h 36.27 (5.4.1992) */
OPT NATIVE, INLINE, PREPROCESS
MODULE 'target/exec/types'
PUBLIC MODULE 'target/dos/dos_shared'
{MODULE 'dos/dos'}

TYPE BPTR IS PTR
TYPE BSTR IS ARRAY


NATIVE {DOSNAME}  CONST
#define DOSNAME dosname
STATIC dosname = 'dos.library'

/* Predefined Amiga DOS global constants */

NATIVE {DOSTRUE} CONST DOSTRUE = -1
NATIVE {DOSFALSE} CONST DOSFALSE = 0

/* Mode parameter to Open() */
NATIVE {MODE_OLDFILE}	     CONST MODE_OLDFILE	     = 1005   /* Open existing file read/write
														       * positioned at beginning of file. */
NATIVE {MODE_NEWFILE}	     CONST MODE_NEWFILE	     = 1006   /* Open freshly created file (delete
														       * old file) read/write, exclusive lock. */
NATIVE {MODE_READWRITE}	     CONST MODE_READWRITE	     = 1004   /* Open old file w/shared lock,
				     * creates file if doesn't exist. */

/* Relative position to Seek() */
NATIVE {OFFSET_BEGINNING}    CONST OFFSET_BEGINNING    = -1	    /* relative to Begining Of File */
NATIVE {OFFSET_CURRENT}	     CONST OFFSET_CURRENT	     = 0	    /* relative to Current file position */
NATIVE {OFFSET_END}	     CONST OFFSET_END	     = 1	    /* relative to End Of File	  */

NATIVE {OFFSET_BEGINING}	    CONST OFFSET_BEGINING	    = OFFSET_BEGINNING  /* ancient compatibility */

NATIVE {BITSPERBYTE}	     CONST BITSPERBYTE	     = 8
NATIVE {BYTESPERLONG}	     CONST BYTESPERLONG	     = 4
NATIVE {BITSPERLONG}	     CONST BITSPERLONG	     = 32
NATIVE {MAXINT}		     CONST MAXINT		     = $7FFFFFFF
NATIVE {MININT}		     CONST MININT		     = $80000000

/* Passed as type to Lock() */
NATIVE {SHARED_LOCK}	     CONST SHARED_LOCK	     = -2	    /* File is readable by others */
NATIVE {ACCESS_READ}	     CONST ACCESS_READ	     = -2	    /* Synonym */
NATIVE {EXCLUSIVE_LOCK}	     CONST EXCLUSIVE_LOCK	     = -1	    /* No other access allowed	  */
NATIVE {ACCESS_WRITE}	     CONST ACCESS_WRITE	     = -1	    /* Synonym */

->"OBJECT datestamp" is on-purposely missing from here (it can be found in 'dos/dos_shared')

NATIVE {TICKS_PER_SECOND}      CONST TICKS_PER_SECOND      = 50   /* Number of ticks in one second */

/* Returned by Examine() and ExNext(), must be on a 4 byte boundary */
->"OBJECT fileinfoblock" is on-purposely missing from here (it can be found in 'dos/dos_shared')

/* FIB stands for FileInfoBlock */

NATIVE {FIBB_OTR_READ}	   CONST FIBB_OTR_READ	   = 15	/* Other: file is readable */
NATIVE {FIBB_OTR_WRITE}	   CONST FIBB_OTR_WRITE	   = 14	/* Other: file is writable */
NATIVE {FIBB_OTR_EXECUTE}   CONST FIBB_OTR_EXECUTE   = 13	/* Other: file is executable */
NATIVE {FIBB_OTR_DELETE}    CONST FIBB_OTR_DELETE    = 12	/* Other: prevent file from being deleted */
NATIVE {FIBB_GRP_READ}	   CONST FIBB_GRP_READ	   = 11	/* Group: file is readable */
NATIVE {FIBB_GRP_WRITE}	   CONST FIBB_GRP_WRITE	   = 10	/* Group: file is writable */
NATIVE {FIBB_GRP_EXECUTE}   CONST FIBB_GRP_EXECUTE   = 9	/* Group: file is executable */
NATIVE {FIBB_GRP_DELETE}    CONST FIBB_GRP_DELETE    = 8	/* Group: prevent file from being deleted */

NATIVE {FIBB_SCRIPT}    CONST FIBB_SCRIPT    = 6	/* program is a script (execute) file */
NATIVE {FIBB_PURE}      CONST FIBB_PURE      = 5	/* program is reentrant and rexecutable */
NATIVE {FIBB_ARCHIVE}   CONST FIBB_ARCHIVE   = 4	/* cleared whenever file is changed */
NATIVE {FIBB_READ}      CONST FIBB_READ      = 3	/* ignored by old filesystem */
NATIVE {FIBB_WRITE}     CONST FIBB_WRITE     = 2	/* ignored by old filesystem */
NATIVE {FIBB_EXECUTE}   CONST FIBB_EXECUTE   = 1	/* ignored by system, used by Shell */
NATIVE {FIBB_DELETE}    CONST FIBB_DELETE    = 0	/* prevent file from being deleted */

NATIVE {FIBF_OTR_READ}    CONST FIBF_OTR_READ    = $8000
NATIVE {FIBF_OTR_WRITE}   CONST FIBF_OTR_WRITE   = $4000
NATIVE {FIBF_OTR_EXECUTE} CONST FIBF_OTR_EXECUTE = $2000
NATIVE {FIBF_OTR_DELETE}  CONST FIBF_OTR_DELETE  = $1000
NATIVE {FIBF_GRP_READ}    CONST FIBF_GRP_READ    = $0800
NATIVE {FIBF_GRP_WRITE}   CONST FIBF_GRP_WRITE   = $0400
NATIVE {FIBF_GRP_EXECUTE} CONST FIBF_GRP_EXECUTE = $0200
NATIVE {FIBF_GRP_DELETE}  CONST FIBF_GRP_DELETE  = $0100

NATIVE {FIBF_SCRIPT}      CONST FIBF_SCRIPT      = $0040
NATIVE {FIBF_PURE}        CONST FIBF_PURE        = $0020
NATIVE {FIBF_ARCHIVE}     CONST FIBF_ARCHIVE     = $0010
NATIVE {FIBF_READ}        CONST FIBF_READ        = $0008
NATIVE {FIBF_WRITE}       CONST FIBF_WRITE       = $0004
NATIVE {FIBF_EXECUTE}     CONST FIBF_EXECUTE     = $0002
NATIVE {FIBF_DELETE}      CONST FIBF_DELETE      = $0001

NATIVE {FAULT_MAX}	CONST FAULT_MAX	= 82

/* Convert BPTR to typical C pointer */
NATIVE {BADDR} CONST	->BADDR(x)	((APTR)((ULONG)(x) << 2))
#define BADDR(x) Baddr(x)
PROC Baddr(x:BPTR) IS NATIVE {BADDR(} x {)} ENDNATIVE !!PTR

/* Convert address into a BPTR */
NATIVE {MKBADDR} CONST	->MKBADDR(x)	(((LONG)(x)) >> 2)
#define MKBADDR(x) Mkbaddr(x)
PROC Mkbaddr(x:PTR) IS NATIVE {MKBADDR(} x {)} ENDNATIVE !!BPTR

/* returned by Info(), must be on a 4 byte boundary */
NATIVE {infodata} OBJECT infodata
   {numsofterrors}	numsofterrors	:VALUE	/* number of soft errors on disk */
   {unitnumber}		unitnumber	:VALUE	/* Which unit disk is (was) mounted on */
   {diskstate}		diskstate	:VALUE		/* See defines below */
   {numblocks}		numblocks	:VALUE		/* Number of blocks on disk */
   {numblocksused}	numblocksused	:VALUE	/* Number of block in use */
   {bytesperblock}	bytesperblock	:VALUE
   {disktype}		disktype	:VALUE		/* Disk Type code */
   {volumenode}		volumenode	:BPTR	/* BCPL pointer to volume node (see DosList) */
   {inuse}			inuse	:VALUE		/* Flag, zero if not in use */
ENDOBJECT /* InfoData */

/* ID stands for InfoData */
	/* Disk states */
NATIVE {ID_WRITE_PROTECTED} CONST ID_WRITE_PROTECTED = 80	 /* Disk is write protected */
NATIVE {ID_VALIDATING}	   CONST ID_VALIDATING	   = 81	 /* Disk is currently being validated */
NATIVE {ID_VALIDATED}	   CONST ID_VALIDATED	   = 82	 /* Disk is consistent and writeable */

	/* Disk types */
NATIVE {ID_NO_DISK_PRESENT}		CONST ID_NO_DISK_PRESENT	= -1
NATIVE {ID_UNREADABLE_DISK}  CONST ID_UNREADABLE_DISK  = "BAD\x00"
NATIVE {ID_DOS_DISK}         CONST ID_DOS_DISK         = "DOS\x00"
NATIVE {ID_FFS_DISK}         CONST ID_FFS_DISK         = "DOS\x01"
NATIVE {ID_INTER_DOS_DISK}   CONST ID_INTER_DOS_DISK   = "DOS\x02"
NATIVE {ID_INTER_FFS_DISK}   CONST ID_INTER_FFS_DISK   = "DOS\x03"
NATIVE {ID_FASTDIR_DOS_DISK} CONST ID_FASTDIR_DOS_DISK = "DOS\x04"
NATIVE {ID_FASTDIR_FFS_DISK} CONST ID_FASTDIR_FFS_DISK = "DOS\x05"
NATIVE {ID_NOT_REALLY_DOS}   CONST ID_NOT_REALLY_DOS   = "NDOS"
NATIVE {ID_KICKSTART_DISK}   CONST ID_KICKSTART_DISK   = "KICK"
NATIVE {ID_MSDOS_DISK}       CONST ID_MSDOS_DISK       = "MSD\x00"

/* Errors from IoErr(), etc. */
NATIVE {ERROR_NO_FREE_STORE}		  CONST ERROR_NO_FREE_STORE		  = 103
NATIVE {ERROR_TASK_TABLE_FULL}		  CONST ERROR_TASK_TABLE_FULL		  = 105
NATIVE {ERROR_BAD_TEMPLATE}		  CONST ERROR_BAD_TEMPLATE		  = 114
NATIVE {ERROR_BAD_NUMBER}		  CONST ERROR_BAD_NUMBER		  = 115
NATIVE {ERROR_REQUIRED_ARG_MISSING}	  CONST ERROR_REQUIRED_ARG_MISSING	  = 116
NATIVE {ERROR_KEY_NEEDS_ARG}		  CONST ERROR_KEY_NEEDS_ARG		  = 117
NATIVE {ERROR_TOO_MANY_ARGS}		  CONST ERROR_TOO_MANY_ARGS		  = 118
NATIVE {ERROR_UNMATCHED_QUOTES}		  CONST ERROR_UNMATCHED_QUOTES		  = 119
NATIVE {ERROR_LINE_TOO_LONG}		  CONST ERROR_LINE_TOO_LONG		  = 120
NATIVE {ERROR_FILE_NOT_OBJECT}		  CONST ERROR_FILE_NOT_OBJECT		  = 121
NATIVE {ERROR_INVALID_RESIDENT_LIBRARY}	  CONST ERROR_INVALID_RESIDENT_LIBRARY	  = 122
NATIVE {ERROR_NO_DEFAULT_DIR}		  CONST ERROR_NO_DEFAULT_DIR		  = 201
NATIVE {ERROR_OBJECT_IN_USE}		  CONST ERROR_OBJECT_IN_USE		  = 202
NATIVE {ERROR_OBJECT_EXISTS}		  CONST ERROR_OBJECT_EXISTS		  = 203
NATIVE {ERROR_DIR_NOT_FOUND}		  CONST ERROR_DIR_NOT_FOUND		  = 204
NATIVE {ERROR_OBJECT_NOT_FOUND}		  CONST ERROR_OBJECT_NOT_FOUND		  = 205
NATIVE {ERROR_BAD_STREAM_NAME}		  CONST ERROR_BAD_STREAM_NAME		  = 206
NATIVE {ERROR_OBJECT_TOO_LARGE}		  CONST ERROR_OBJECT_TOO_LARGE		  = 207
NATIVE {ERROR_ACTION_NOT_KNOWN}		  CONST ERROR_ACTION_NOT_KNOWN		  = 209
NATIVE {ERROR_INVALID_COMPONENT_NAME}	  CONST ERROR_INVALID_COMPONENT_NAME	  = 210
NATIVE {ERROR_INVALID_LOCK}		  CONST ERROR_INVALID_LOCK		  = 211
NATIVE {ERROR_OBJECT_WRONG_TYPE}		  CONST ERROR_OBJECT_WRONG_TYPE		  = 212
NATIVE {ERROR_DISK_NOT_VALIDATED}	  CONST ERROR_DISK_NOT_VALIDATED	  = 213
NATIVE {ERROR_DISK_WRITE_PROTECTED}	  CONST ERROR_DISK_WRITE_PROTECTED	  = 214
NATIVE {ERROR_RENAME_ACROSS_DEVICES}	  CONST ERROR_RENAME_ACROSS_DEVICES	  = 215
NATIVE {ERROR_DIRECTORY_NOT_EMPTY}	  CONST ERROR_DIRECTORY_NOT_EMPTY	  = 216
NATIVE {ERROR_TOO_MANY_LEVELS}		  CONST ERROR_TOO_MANY_LEVELS		  = 217
NATIVE {ERROR_DEVICE_NOT_MOUNTED}	  CONST ERROR_DEVICE_NOT_MOUNTED	  = 218
NATIVE {ERROR_SEEK_ERROR}		  CONST ERROR_SEEK_ERROR		  = 219
NATIVE {ERROR_COMMENT_TOO_BIG}		  CONST ERROR_COMMENT_TOO_BIG		  = 220
NATIVE {ERROR_DISK_FULL}			  CONST ERROR_DISK_FULL			  = 221
NATIVE {ERROR_DELETE_PROTECTED}		  CONST ERROR_DELETE_PROTECTED		  = 222
NATIVE {ERROR_WRITE_PROTECTED}		  CONST ERROR_WRITE_PROTECTED		  = 223
NATIVE {ERROR_READ_PROTECTED}		  CONST ERROR_READ_PROTECTED		  = 224
NATIVE {ERROR_NOT_A_DOS_DISK}		  CONST ERROR_NOT_A_DOS_DISK		  = 225
NATIVE {ERROR_NO_DISK}			  CONST ERROR_NO_DISK			  = 226
NATIVE {ERROR_NO_MORE_ENTRIES}		  CONST ERROR_NO_MORE_ENTRIES		  = 232
/* added for 1.4 */
NATIVE {ERROR_IS_SOFT_LINK}		  CONST ERROR_IS_SOFT_LINK		  = 233
NATIVE {ERROR_OBJECT_LINKED}		  CONST ERROR_OBJECT_LINKED		  = 234
NATIVE {ERROR_BAD_HUNK}			  CONST ERROR_BAD_HUNK			  = 235
NATIVE {ERROR_NOT_IMPLEMENTED}		  CONST ERROR_NOT_IMPLEMENTED		  = 236
NATIVE {ERROR_RECORD_NOT_LOCKED}		  CONST ERROR_RECORD_NOT_LOCKED		  = 240
NATIVE {ERROR_LOCK_COLLISION}		  CONST ERROR_LOCK_COLLISION		  = 241
NATIVE {ERROR_LOCK_TIMEOUT}		  CONST ERROR_LOCK_TIMEOUT		  = 242
NATIVE {ERROR_UNLOCK_ERROR}		  CONST ERROR_UNLOCK_ERROR		  = 243

/* error codes 303-305 are defined in dosasl.h */

/* These are the return codes used by convention by AmigaDOS commands */
NATIVE {RETURN_OK}			    CONST RETURN_OK			    = 0  /* No problems, success */
NATIVE {RETURN_WARN}			    CONST RETURN_WARN			    = 5  /* A warning only */
NATIVE {RETURN_ERROR}			   CONST RETURN_ERROR			   = 10  /* Something wrong */
NATIVE {RETURN_FAIL}			   CONST RETURN_FAIL			   = 20  /* Complete or severe failure*/

/* Bit numbers that signal you that a user has issued a break */
NATIVE {SIGBREAKB_CTRL_C}   CONST SIGBREAKB_CTRL_C   = 12
NATIVE {SIGBREAKB_CTRL_D}   CONST SIGBREAKB_CTRL_D   = 13
NATIVE {SIGBREAKB_CTRL_E}   CONST SIGBREAKB_CTRL_E   = 14
NATIVE {SIGBREAKB_CTRL_F}   CONST SIGBREAKB_CTRL_F   = 15

/* Bit fields that signal you that a user has issued a break */
NATIVE {SIGBREAKF_CTRL_C} CONST SIGBREAKF_CTRL_C = $1000
NATIVE {SIGBREAKF_CTRL_D} CONST SIGBREAKF_CTRL_D = $2000
NATIVE {SIGBREAKF_CTRL_E} CONST SIGBREAKF_CTRL_E = $4000
NATIVE {SIGBREAKF_CTRL_F} CONST SIGBREAKF_CTRL_F = $8000

/* Values returned by SameLock() */
NATIVE {LOCK_DIFFERENT}		CONST LOCK_DIFFERENT		= -1
NATIVE {LOCK_SAME}		CONST LOCK_SAME		= 0
NATIVE {LOCK_SAME_VOLUME}	CONST LOCK_SAME_VOLUME	= 1	/* locks are on same volume */
NATIVE {LOCK_SAME_HANDLER}	CONST LOCK_SAME_HANDLER	= LOCK_SAME_VOLUME
/* LOCK_SAME_HANDLER was a misleading name, def kept for src compatibility */

/* types for ChangeMode() */
NATIVE {CHANGE_LOCK}	CONST CHANGE_LOCK	= 0
NATIVE {CHANGE_FH}	CONST CHANGE_FH	= 1

/* Values for MakeLink() */
NATIVE {LINK_HARD}	CONST LINK_HARD	= 0
NATIVE {LINK_SOFT}	CONST LINK_SOFT	= 1	/* softlinks are not fully supported yet */

/* values returned by ReadItem */
NATIVE {ITEM_EQUAL}	CONST ITEM_EQUAL	= -2		/* "=" Symbol */
NATIVE {ITEM_ERROR}	CONST ITEM_ERROR	= -1		/* error */
NATIVE {ITEM_NOTHING}	CONST ITEM_NOTHING	= 0		/* *N, ;, endstreamch */
NATIVE {ITEM_UNQUOTED}	CONST ITEM_UNQUOTED	= 1		/* unquoted item */
NATIVE {ITEM_QUOTED}	CONST ITEM_QUOTED	= 2		/* quoted item */

/* types for AllocDosObject/FreeDosObject */
NATIVE {DOS_FILEHANDLE}		CONST DOS_FILEHANDLE	= 0	/* few people should use this */
NATIVE {DOS_EXALLCONTROL}	CONST DOS_EXALLCONTROL	= 1	/* Must be used to allocate this! */
NATIVE {DOS_FIB}			CONST DOS_FIB			= 2	/* useful */
NATIVE {DOS_STDPKT}			CONST DOS_STDPKT		= 3	/* for doing packet-level I/O */
NATIVE {DOS_CLI}			CONST DOS_CLI			= 4	/* for shell-writers, etc */
NATIVE {DOS_RDARGS}			CONST DOS_RDARGS		= 5	/* for ReadArgs if you pass it in */
