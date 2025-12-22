MODULE	'exec/tasks',
			'exec/ports',
			'exec/libraries',
			'exec/semaphores',
			'devices/timer',
			'dos/dos'

#define	BSTR	PTR TO CHAR

/* All DOS processes have this structure */
/* Create and Device Proc returns pointer to the MP in this structure */
/* dev_proc = (struct Process *) (DeviceProc(..) - sizeof(struct Task)); */

OBJECT Process
	Task:TC,
	MsgPort:MP,				/* This is BPTR address from DOS functions  */
	Pad:WORD,				/* Remaining variables on 4 byte boundaries */
	SegList:BPTR,			/* Array of seg lists used by this process  */
	StackSize:LONG,		/* Size of process stack in bytes	    */
	GlobVec:APTR,			/* Global vector for this process (BCPL)    */
	TaskNum:LONG,			/* CLI task number of zero if not a CLI	    */
	StackBase:BPTR,		/* Ptr to high memory end of process stack  */
	Result2:LONG,			/* Value of secondary result from last call */
	CurrentDir:BPTR,		/* Lock associated with current directory   */
	CIS:BPTR,				/* Current CLI Input Stream		    */
	COS:BPTR,				/* Current CLI Output Stream		    */
	ConsoleTask:APTR,		/* Console handler process for current window*/
	FileSystemTask:APTR,	/* File handler process for current drive   */
	CLI:BPTR,				/* pointer to CommandLineInterface	    */
	ReturnAddr:APTR,		/* pointer to previous stack frame	    */
	PktWait:APTR,			/* Function to be called when awaiting msg  */
	WindowPtr:APTR,		/* Window for error printing		    */

    /* following definitions are new with 2.0 */
	HomeDir:BPTR,			/* Home directory of executing program	    */
	Flags:LONG,				/* flags telling dos about process	    */
	ExitCode/*()*/:PTR,		/* code to call on exit of program or NULL  */
	ExitData:LONG,			/* Passed as an argument to pr_ExitCode.    */
	Arguments:PTR TO UBYTE,	/* Arguments passed to the process at start */
	LocalVars:MLH,			/* Local environment variables		    */
	ShellPrivate:ULONG,	/* for the use of the current shell	    */
	CES:BPTR					/* Error stream - if NULL, use pr_COS	    */

/*
 * Flags for pr_Flags
 */
FLAG	PR_FREESEGLIST,
		PR_FREECURRDIR,
		PR_FREECLI,
		PR_CLOSEINPUT,
		PR_CLOSEOUTPUT,
		PR_FREEARGS

/* The long word address (BPTR) of this structure is returned by
 * Open() and other routines that return a file.  You need only worry
 * about this struct to do async io's via PutMsg() instead of
 * standard file system calls */

OBJECT FileHandle
	Link:PTR TO MN,		/* EXEC message	      */
	Port:PTR TO MP,		/* Reply port for the packet */
	Type:PTR TO MP,		/* Port to do PutMsg() to
							 * Address is negative if a plain file */
	Buf:LONG,
	Pos:LONG,
	End:LONG,
	Funcs|Func1:LONG,
	Func2:LONG,
	Func3:LONG,
	Args|Arg1:LONG,
	Arg2:LONG

/* This is the extension to EXEC Messages used by DOS */

OBJECT DosPacket
	Link:PTR TO MN,		 /* EXEC message	      */
	Port:PTR TO MP,		 /* Reply port for the packet */
								 /* Must be filled in each send. */
	Type|Action:LONG,		 /* See ACTION_... below and
								  * 'R' means Read, 'W' means Write to the
								  * file system */
	Res1|Status:LONG,		 /* For file system calls this is the result
								  * that would have been returned by the
								  * function, e.g. Write ('W') returns actual
								  * length written */
	Res2|Status2:LONG,	 /* For file system calls this is what would
								  * have been returned by IoErr() */
	Arg1|BufAddr:LONG,
	Arg2:LONG,
	Arg3:LONG,
	Arg4:LONG,
	Arg5:LONG,
	Arg6:LONG,
	Arg7:LONG

/* A Packet does not require the Message to be before it in memory, but
 * for convenience it is useful to associate the two.
 * Also see the function init_std_pkt for initializing this structure */

OBJECT StandardPacket
	Msg:MN,
	Pkt:DosPacket

/* Packet types */
CONST	ACTION_NIL					=0,
		ACTION_STARTUP				=0,
		ACTION_GET_BLOCK			=2,	/* OBSOLETE */
		ACTION_SET_MAP				=4,
		ACTION_DIE					=5,
		ACTION_EVENT				=6,
		ACTION_CURRENT_VOLUME	=7,
		ACTION_LOCATE_OBJECT		=8,
		ACTION_RENAME_DISK		=9,
		ACTION_WRITE				=87,	// "W",
		ACTION_READ					=82,	// "R",
		ACTION_FREE_LOCK			=15,
		ACTION_DELETE_OBJECT		=16,
		ACTION_RENAME_OBJECT		=17,
		ACTION_MORE_CACHE			=18,
		ACTION_COPY_DIR			=19,
		ACTION_WAIT_CHAR			=20,
		ACTION_SET_PROTECT		=21,
		ACTION_CREATE_DIR			=22,
		ACTION_EXAMINE_OBJECT	=23,
		ACTION_EXAMINE_NEXT		=24,
		ACTION_DISK_INFO			=25,
		ACTION_INFO					=26,
		ACTION_FLUSH				=27,
		ACTION_SET_COMMENT		=28,
		ACTION_PARENT				=29,
		ACTION_TIMER				=30,
		ACTION_INHIBIT				=31,
		ACTION_DISK_TYPE			=32,
		ACTION_DISK_CHANGE		=33,
		ACTION_SET_DATE			=34,

		ACTION_SCREEN_MODE		=994,

		ACTION_READ_RETURN		=1001,
		ACTION_WRITE_RETURN		=1002,
		ACTION_SEEK					=1008,
		ACTION_FINDUPDATE			=1004,
		ACTION_FINDINPUT			=1005,
		ACTION_FINDOUTPUT			=1006,
		ACTION_END					=1007,
		ACTION_SET_FILE_SIZE		=1022,	/* fast file system only in 1.3 */
		ACTION_WRITE_PROTECT		=1023,	/* fast file system only in 1.3 */

/* new 2.0 packets */
		ACTION_SAME_LOCK			=40,
		ACTION_CHANGE_SIGNAL		=995,
		ACTION_FORMAT				=1020,
		ACTION_MAKE_LINK			=1021,

		ACTION_READ_LINK			=1024,
		ACTION_FH_FROM_LOCK		=1026,
		ACTION_IS_FILESYSTEM		=1027,
		ACTION_CHANGE_MODE		=1028,

		ACTION_COPY_DIR_FH		=1030,
		ACTION_PARENT_FH			=1031,
		ACTION_EXAMINE_ALL		=1033,
		ACTION_EXAMINE_FH			=1034,

		ACTION_LOCK_RECORD		=2008,
		ACTION_FREE_RECORD		=2009,

		ACTION_ADD_NOTIFY			=4097,
		ACTION_REMOVE_NOTIFY		=4098,

/* Added in V39: */
		ACTION_EXAMINE_ALL_END	=1035,
		ACTION_SET_OWNER			=1036,

/* Tell a file system to serialize the current volume. This is typically
 * done by changing the creation date of the disk. This packet does not take
 * any arguments.  NOTE: be prepared to handle failure of this packet for
 * V37 ROM filesystems.
 */
		ACTION_SERIALIZE_DISK	=4200

/*
 * A structure for holding error messages - stored as array with error == 0
 * for the last entry.
 */
OBJECT ErrorString
	Nums:PTR TO LONG,
	Strings:PTR TO UBYTE

/* DOS library node structure.
 * This is the data at positive offsets from the library node.
 * Negative offsets from the node is the jump table to DOS functions
 * node = (struct DosLibrary *) OpenLibrary( "dos.library" .. )	     */

OBJECT DosLibrary
	lib:Lib,
	Root:PTR TO RootNode,			/* Pointer to RootNode, described below */
	GV:APTR,								/* Pointer to BCPL global vector	      */
	A2:LONG,								/* BCPL standard register values	      */
	A5:LONG,
	A6:LONG,
	Errors:PTR TO ErrorString,		/* PRIVATE pointer to array of error msgs */
	TimeReq:PTR TO TimeRequest,	/* PRIVATE pointer to timer request */
	UtilityBase:PTR TO Lib,			/* PRIVATE ptr to utility library */
	IntuitionBase:PTR TO Lib		/* PRIVATE ptr to intuition library */

OBJECT RootNode
	TaskArray:BPTR,			/* [0] is max number of CLI's
									 * [1] is APTR to process id of CLI 1
									 * [n] is APTR to process id of CLI n */
	ConsoleSegment:BPTR,		/* SegList for the CLI			   */
	Time:DateStamp,			/* Current time				   */
	RestartSeg:LONG,			/* SegList for the disk validator process   */
	Info:BPTR,					/* Pointer to the Info structure		   */
	FileHandlerSegment:BPTR,/* segment for a file handler	   */
	CliList:MLH,				/* new list of all CLI processes */
									/* the first cpl_Array is also rn_TaskArray */
	BootProc:PTR TO MP,		/* private ptr to msgport of boot fs	   */
	ShellSegment:BPTR,		/* seglist for Shell (for NewShell)	   */
	Flags:LONG					/* dos flags */

FLAG	RN_WILDSTAR	=24,
		RN_PRIVATE1	=1			/* private for dos */

/* ONLY to be allocated by DOS! */
OBJECT CliProcList
	Node:MN,
	First:LONG,	/* number of first entry in array */
	Array:PTR TO PTR TO MP
					/* [0] is max number of CLI's in this entry (n)
					 * [1] is CPTR to process id of CLI cpl_First
					 * [n] is CPTR to process id of CLI cpl_First+n-1
					 */

OBJECT DosInfo
	McName|ResList:BPTR,			/* PRIVATE: system resident module list	    */
	DevInfo:BPTR,					/* Device List				    */
	Devices:BPTR,					/* Currently zero			    */
	Handlers:BPTR,					/* Currently zero			    */
	NetHand:APTR,					/* Network handler processid; currently zero */
	DevLock:SS,						/* do NOT access directly! */
	EntryLock:SS,					/* do NOT access directly! */
	DeleteLock:SS					/* do NOT access directly! */

/* structure for the Dos resident list.  Do NOT allocate these, use	  */
/* AddSegment(), and heed the warnings in the autodocs!			  */

OBJECT Segment
	Next:BPTR,
	UC:LONG,
	Seg:BPTR,
	Name[4]:UBYTE	/* actually the first 4 chars of BSTR name */

CONST	CMD_SYSTEM  =-1,
		CMD_INTERNAL=-2,
		CMD_DISABLED=-999


/* DOS Processes started from the CLI via RUN or NEWCLI have this additional
 * set to data associated with them */

OBJECT CommandLineInterface
	Result2:LONG,			/* Value of IoErr from last command	  */
	SetName:BSTR,			/* Name of current directory		  */
	CommandDir:BPTR,		/* Head of the path locklist		  */
	ReturnCode:LONG,		/* Return code from last command		  */
	CommandName:BSTR,		/* Name of current command		  */
	FailLevel:LONG,		/* Fail level (set by FAILAT)		  */
	Prompt:BSTR,			/* Current prompt (set by PROMPT)	  */
	StandardInput:BPTR,	/* Default (terminal) CLI input		  */
	CurrentInput:BPTR,	/* Current CLI input			  */
	CommandFile:BSTR,		/* Name of EXECUTE command file		  */
	Interactive:LONG,		/* Boolean; True if prompts required	  */
	Background:LONG,		/* Boolean; True if CLI created by RUN	  */
	CurrentOutput:BPTR,	/* Current CLI output			  */
	DefaultStack:LONG,	/* Stack size to be obtained in long words */
	StandardOutput:BPTR,	/* Default (terminal) CLI output		  */
	Module:BPTR				/* SegList of currently loaded command	  */

/* This structure can take on different values depending on whether it is
 * a device, an assigned directory, or a volume.  Below is the structure
 * reflecting volumes only.  Following that is the structure representing
 * only devices. Following that is the unioned structure representing all
 * the values
 */

/* structure representing a volume */

OBJECT DeviceList
	Next:BPTR,				/* bptr to next device list */
	Type:LONG,				/* see DLT below */
	Task:PTR TO MP,		/* ptr to handler task */
	Lock:BPTR,				/* not for volumes */
	VolumeDate:DateStamp,/* creation date */
	LockList:BPTR,			/* outstanding locks */
	DiskType:LONG,			/* "DOS", etc */
	unused:LONG,
	Name:BSTR		/* bptr to bcpl name */


/* device structure (same as the DeviceNode structure in filehandler.h) */

OBJECT DevInfo
	Next:BPTR,
	Type:LONG,
	Task:APTR,
	Lock:BPTR,
	Handler:BSTR,
	StackSize:LONG,
	Priority:LONG,
	Startup:LONG,
	SegList:BPTR,
	GlobVec:BPTR,
	Name:BSTR

/* combined structure for devices, assigned directories, volumes */

OBJECT DosList
	Next:BPTR,				/* bptr to next device on list */
	Type:LONG,				/* see DLT below */
	Task:PTR TO MP,		/* ptr to handler task */
	Lock:BPTR,
	NEWUNION Misc
		NEWUNION Handler
			Handler:BPTR,		/* file name to load if seglist is null */
			StackSize:LONG,	/* stacksize to use when starting process */
			Priority:LONG,		/* task priority when starting process */
			Startup:ULONG,		/* startup msg: FileSysStartupMsg for disks */
			SegList:BPTR,		/* already loaded code for new task */
			GlobVec:BPTR		/* BCPL global vector to use when starting
									 * a process. -1 indicates a C/Assembler
									 * program. */
		UNION Volume
			VolumeDate:DateStamp,	 /* creation date */
			LockList:BPTR,		/* outstanding locks */
			DiskType:LONG		/* 'DOS', etc */
		UNION Assign
			AssignName:PTR TO CHAR,	/* name for non-or-late-binding assign */
			List:PTR TO AssignList	/* for multi-directory assigns (regular) */
		ENDUNION
	ENDUNION,
	Name:BSTR			/* bptr to bcpl name */

/* structure used for multi-directory assigns. AllocVec()ed. */

OBJECT AssignList
	Next:PTR TO AssignList,
	Lock:BPTR

/* definitions for dl_Type */
ENUM	DLT_PRIVATE=-1,		/* for internal use only */
		DLT_DEVICE,
		DLT_DIRECTORY,			/* assign */
		DLT_VOLUME,
		DLT_LATE,				/* late-binding assign */
		DLT_NONBINDING			/* non-binding assign */

/* structure return by GetDeviceProc() */
OBJECT DevProc
	Port:PTR TO MP,
	Lock:BPTR,
	Flags:ULONG,
	DevNode:PTR TO DosList	/* DON'T TOUCH OR USE! */

/* definitions for dvp_Flags */
FLAG	DVP_UNLOCK,
		DVP_ASSIGN,
/* Flags to be passed to LockDosList(), etc */
/* you MUST specify one of LDF_READ or LDF_WRITE */
		LD_READ=0,
		LD_WRITE,
		LD_DEVICES,
		LD_VOLUMES,
		LD_ASSIGNS,
		LD_ENTRY,
		LD_DELETE

/* actually all but LDF_ENTRY (which is used for internal locking) */
CONST	LDF_ALL=LDF_DEVICES|LDF_VOLUMES|LDF_ASSIGNS

/* a lock structure, as returned by Lock() or DupLock() */
OBJECT FileLock
	Link:BPTR,				/* bcpl pointer to next lock */
	Key:LONG,				/* disk block number */
	Access:LONG,			/* exclusive or shared */
	Task:PTR TO MP,		/* handler task's port */
	Volume:BPTR				/* bptr to DLT_VOLUME DosList entry */

/* error report types for ErrorReport() */
ENUM	REPORT_STREAM,		/* a stream */
		REPORT_TASK,		/* a process - unused */
		REPORT_LOCK,		/* a lock */
		REPORT_VOLUME,		/* a volume node */
		REPORT_INSERT		/* please insert volume */

/* Special error codes for ErrorReport() */
CONST	ABORT_DISK_ERROR=296,/* Read/write error */
		ABORT_BUSY=288			/* You MUST replace... */

/* types for initial packets to shells from run/newcli/execute/system. */
/* For shell-writers only */
CONST	RUN_EXECUTE=-1,
		RUN_SYSTEM=-2,
		RUN_SYSTEM_ASYNCH=-3

/* Types for fib_DirEntryType.	NOTE that both USERDIR and ROOT are	 */
/* directories, and that directory/file checks should use <0 and >=0.	 */
/* This is not necessarily exhaustive!	Some handlers may use other	 */
/* values as needed, though <0 and >=0 should remain as supported as	 */
/* possible.								 */
CONST	ST_ROOT		=1,
		ST_USERDIR	=2,
		ST_SOFTLINK	=3,	/* looks like dir, but may point to a file! */
		ST_LINKDIR	=4,	/* hard link to dir */
		ST_FILE		=-3,	/* must be negative for FIB! */
		ST_LINKFILE	=-4,	/* hard link to file */
		ST_PIPEFILE	=-5	/* for pipes that support ExamineFH */
