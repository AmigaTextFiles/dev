/* $VER: dosextens.h 36.41 (14.5.1992) */
OPT NATIVE
MODULE 'target/exec/tasks', 'target/exec/ports', 'target/exec/libraries', 'target/exec/semaphores', 'target/devices/timer', 'target/dos/dos_shared'
MODULE 'target/exec/lists', 'target/exec/nodes', 'target/exec/types', 'target/dos/dos'
{MODULE 'dos/dosextens'}

NATIVE {process} OBJECT process
    {task}		task		:tc
    {msgport}	msgport		:mp /* This is BPTR address from DOS functions  */
    {pad}		pad			:INT		/* Remaining variables on 4 byte boundaries */
    {seglist}	seglist		:BPTR		/* Array of seg lists used by this process  */
    {stacksize}	stacksize	:VALUE	/* Size of process stack in bytes	    */
    {globvec}	globvec		:APTR		/* Global vector for this process (BCPL)    */
    {tasknum}	tasknum		:VALUE		/* CLI task number of zero if not a CLI	    */
    {stackbase}	stackbase	:BPTR	/* Ptr to high memory end of process stack  */
    {result2}	result2		:VALUE		/* Value of secondary result from last call */
    {currentdir}	currentdir	:BPTR	/* Lock associated with current directory   */
    {cis}		cis			:BPTR		/* Current CLI Input Stream		    */
    {cos}		cos			:BPTR		/* Current CLI Output Stream		    */
    {consoletask}	consoletask		:APTR	/* Console handler process for current window*/
    {filesystemtask}	filesystemtask	:APTR	/* File handler process for current drive   */
    {cli}		cli			:BPTR		/* pointer to CommandLineInterface	    */
    {returnaddr}	returnaddr	:APTR	/* pointer to previous stack frame	    */
    {pktwait}	pktwait		:APTR		/* Function to be called when awaiting msg  */
    {windowptr}	windowptr	:APTR	/* Window for error printing		    */

    /* following definitions are new with 2.0 */
    {homedir}	homedir		:BPTR		/* Home directory of executing program	    */
    {flags}		flags		:VALUE		/* flags telling dos about process	    */
    {exitcode}	exitcode	:PTR /*void    (*pr_ExitCode)()*/	/* code to call on exit of program or NULL  */
    {exitdata}	exitdata	:VALUE	/* Passed as an argument to pr_ExitCode.    */
    {arguments}	arguments	:ARRAY OF UBYTE	/* Arguments passed to the process at start */
    {localvars}	localvars	:mlh /* Local environment variables		    */
    {shellprivate}	shellprivate	:ULONG	/* for the use of the current shell	    */
    {ces}		ces			:BPTR		/* Error stream - if NULL, use pr_COS	    */
ENDOBJECT  /* Process */

/*
 * Flags for pr_Flags
 */
NATIVE {PRB_FREESEGLIST}	CONST PRB_FREESEGLIST		= 0
NATIVE {PRF_FREESEGLIST}	CONST PRF_FREESEGLIST		= 1
NATIVE {PRB_FREECURRDIR}	CONST PRB_FREECURRDIR		= 1
NATIVE {PRF_FREECURRDIR}	CONST PRF_FREECURRDIR		= 2
NATIVE {PRB_FREECLI}		CONST PRB_FREECLI		= 2
NATIVE {PRF_FREECLI}		CONST PRF_FREECLI		= 4
NATIVE {PRB_CLOSEINPUT}		CONST PRB_CLOSEINPUT		= 3
NATIVE {PRF_CLOSEINPUT}		CONST PRF_CLOSEINPUT		= 8
NATIVE {PRB_CLOSEOUTPUT}	CONST PRB_CLOSEOUTPUT		= 4
NATIVE {PRF_CLOSEOUTPUT}	CONST PRF_CLOSEOUTPUT		= 16
NATIVE {PRB_FREEARGS}		CONST PRB_FREEARGS		= 5
NATIVE {PRF_FREEARGS}		CONST PRF_FREEARGS		= 32

NATIVE {filehandle} OBJECT filehandle
   {link}	link		:PTR TO mn	 /* EXEC message	      */
   {interactive}	interactive	:PTR TO mp	 /* Reply port for the packet */
   {type}	type		:PTR TO mp	 /* Port to do PutMsg() to
										  * Address is negative if a plain file */
   {buf}		buf		:VALUE
   {pos}		pos		:VALUE
   {end}		end		:VALUE
   {funcs}	funcs	:VALUE
   {func2}	func2	:VALUE
   {func3}	func3	:VALUE
   {args}	args	:VALUE
   {arg2}	arg2	:VALUE
ENDOBJECT /* FileHandle */

/* This is the extension to EXEC Messages used by DOS */

NATIVE {dospacket} OBJECT dospacket
   {link}	link	:PTR TO mn	 /* EXEC message	      */
   {port}	port	:PTR TO mp	 /* Reply port for the packet */
									 /* Must be filled in each send. */
   {action}	action	:VALUE
   {type}	type	:VALUE		 /* See ACTION_... below and
									  * 'R' means Read, 'W' means Write to the
									  * file system */
   {status}	status	:VALUE
   {res1}	res1	:VALUE		 /* For file system calls this is the result
									  * that would have been returned by the
									  * function, e.g. Write ('W') returns actual
									  * length written */
   {status2}	status2	:VALUE
   {res2}	res2	:VALUE		 /* For file system calls this is what would
									  * have been returned by IoErr() */
/*  Device packets common equivalents */
   {bufaddr}	bufaddr	:VALUE
   {arg1}	arg1	:VALUE
   {arg2}	arg2	:VALUE
   {arg3}	arg3	:VALUE
   {arg4}	arg4	:VALUE
   {arg5}	arg5	:VALUE
   {arg6}	arg6	:VALUE
   {arg7}	arg7	:VALUE
ENDOBJECT /* DosPacket */

NATIVE {standardpacket} OBJECT standardpacket
   {msg}	msg	:mn
   {pkt}	pkt	:dospacket
ENDOBJECT /* StandardPacket */

/* Packet types */
NATIVE {ACTION_NIL}			CONST ACTION_NIL		= 0
NATIVE {ACTION_STARTUP}		CONST ACTION_STARTUP		= 0
NATIVE {ACTION_GET_BLOCK}	CONST ACTION_GET_BLOCK	= 2	/* OBSOLETE */

NATIVE {ACTION_SET_MAP}		CONST ACTION_SET_MAP		= 4
NATIVE {ACTION_DIE}			CONST ACTION_DIE		= 5
NATIVE {ACTION_EVENT}		CONST ACTION_EVENT		= 6
NATIVE {ACTION_CURRENT_VOLUME}	CONST ACTION_CURRENT_VOLUME	= 7
NATIVE {ACTION_LOCATE_OBJECT}	CONST ACTION_LOCATE_OBJECT	= 8
NATIVE {ACTION_RENAME_DISK}	CONST ACTION_RENAME_DISK	= 9
NATIVE {ACTION_WRITE}		CONST ACTION_WRITE		= "W"
NATIVE {ACTION_READ}		CONST ACTION_READ		= "R"
NATIVE {ACTION_FREE_LOCK}	CONST ACTION_FREE_LOCK	= 15
NATIVE {ACTION_DELETE_OBJECT}	CONST ACTION_DELETE_OBJECT	= 16
NATIVE {ACTION_RENAME_OBJECT}	CONST ACTION_RENAME_OBJECT	= 17
NATIVE {ACTION_MORE_CACHE}		CONST ACTION_MORE_CACHE	= 18
NATIVE {ACTION_COPY_DIR}		CONST ACTION_COPY_DIR		= 19
NATIVE {ACTION_WAIT_CHAR}	CONST ACTION_WAIT_CHAR	= 20
NATIVE {ACTION_SET_PROTECT}	CONST ACTION_SET_PROTECT	= 21
NATIVE {ACTION_CREATE_DIR}	CONST ACTION_CREATE_DIR	= 22
NATIVE {ACTION_EXAMINE_OBJECT}	CONST ACTION_EXAMINE_OBJECT	= 23
NATIVE {ACTION_EXAMINE_NEXT}	CONST ACTION_EXAMINE_NEXT	= 24
NATIVE {ACTION_DISK_INFO}	CONST ACTION_DISK_INFO	= 25
NATIVE {ACTION_INFO}		CONST ACTION_INFO		= 26
NATIVE {ACTION_FLUSH}		CONST ACTION_FLUSH		= 27
NATIVE {ACTION_SET_COMMENT}	CONST ACTION_SET_COMMENT	= 28
NATIVE {ACTION_PARENT}		CONST ACTION_PARENT		= 29
NATIVE {ACTION_TIMER}		CONST ACTION_TIMER		= 30
NATIVE {ACTION_INHIBIT}		CONST ACTION_INHIBIT		= 31
NATIVE {ACTION_DISK_TYPE}	CONST ACTION_DISK_TYPE	= 32
NATIVE {ACTION_DISK_CHANGE}	CONST ACTION_DISK_CHANGE	= 33
NATIVE {ACTION_SET_DATE}	CONST ACTION_SET_DATE		= 34

NATIVE {ACTION_SCREEN_MODE}	CONST ACTION_SCREEN_MODE	= 994

NATIVE {ACTION_READ_RETURN}	CONST ACTION_READ_RETURN	= 1001
NATIVE {ACTION_WRITE_RETURN}	CONST ACTION_WRITE_RETURN	= 1002
NATIVE {ACTION_SEEK}		CONST ACTION_SEEK		= 1008
NATIVE {ACTION_FINDUPDATE}	CONST ACTION_FINDUPDATE	= 1004
NATIVE {ACTION_FINDINPUT}	CONST ACTION_FINDINPUT	= 1005
NATIVE {ACTION_FINDOUTPUT}	CONST ACTION_FINDOUTPUT	= 1006
NATIVE {ACTION_END}		CONST ACTION_END		= 1007
NATIVE {ACTION_SET_FILE_SIZE}	CONST ACTION_SET_FILE_SIZE	= 1022	/* fast file system only in 1.3 */
NATIVE {ACTION_WRITE_PROTECT}	CONST ACTION_WRITE_PROTECT	= 1023	/* fast file system only in 1.3 */

/* new 2.0 packets */
NATIVE {ACTION_SAME_LOCK}	CONST ACTION_SAME_LOCK	= 40
NATIVE {ACTION_CHANGE_SIGNAL}	CONST ACTION_CHANGE_SIGNAL	= 995
NATIVE {ACTION_FORMAT}		CONST ACTION_FORMAT		= 1020
NATIVE {ACTION_MAKE_LINK}	CONST ACTION_MAKE_LINK	= 1021
/**/
/**/
NATIVE {ACTION_READ_LINK}	CONST ACTION_READ_LINK	= 1024
NATIVE {ACTION_FH_FROM_LOCK}	CONST ACTION_FH_FROM_LOCK	= 1026
NATIVE {ACTION_IS_FILESYSTEM}	CONST ACTION_IS_FILESYSTEM	= 1027
NATIVE {ACTION_CHANGE_MODE}	CONST ACTION_CHANGE_MODE	= 1028
/**/
NATIVE {ACTION_COPY_DIR_FH}	CONST ACTION_COPY_DIR_FH	= 1030
NATIVE {ACTION_PARENT_FH}	CONST ACTION_PARENT_FH	= 1031
NATIVE {ACTION_EXAMINE_ALL}	CONST ACTION_EXAMINE_ALL	= 1033
NATIVE {ACTION_EXAMINE_FH}	CONST ACTION_EXAMINE_FH	= 1034

NATIVE {ACTION_LOCK_RECORD}	CONST ACTION_LOCK_RECORD	= 2008
NATIVE {ACTION_FREE_RECORD}	CONST ACTION_FREE_RECORD	= 2009

NATIVE {ACTION_ADD_NOTIFY}	CONST ACTION_ADD_NOTIFY	= 4097
NATIVE {ACTION_REMOVE_NOTIFY}	CONST ACTION_REMOVE_NOTIFY	= 4098

/* Added in V39: */
NATIVE {ACTION_EXAMINE_ALL_END}	CONST ACTION_EXAMINE_ALL_END	= 1035
NATIVE {ACTION_SET_OWNER}	CONST ACTION_SET_OWNER	= 1036

NATIVE {ACTION_SERIALIZE_DISK}	CONST ACTION_SERIALIZE_DISK	= 4200

NATIVE {errorstring} OBJECT errorstring
	{nums}		nums	:PTR TO VALUE
	{strings}	strings	:ARRAY OF UBYTE
ENDOBJECT

NATIVE {doslibrary} OBJECT doslibrary
    {lib}	lib	:lib
    {root}	root:PTR TO rootnode /* Pointer to RootNode, described below */
    {gv}		gv	:APTR	      /* Pointer to BCPL global vector	      */
    {a2}		a2	:VALUE	      /* BCPL standard register values	      */
    {a5}		a5	:VALUE
    {a6}		a6	:VALUE
    {errors}			errors			:PTR TO errorstring	  /* PRIVATE pointer to array of error msgs */
    {timereq}		timereq			:PTR TO timerequest	  /* PRIVATE pointer to timer request */
    {utilitybase}	utilitybase		:PTR TO lib   /* PRIVATE ptr to utility library */
    {intuitionbase}	intuitionbase	:PTR TO lib /* PRIVATE ptr to intuition library */
ENDOBJECT  /*	DosLibrary */

NATIVE {rootnode} OBJECT rootnode
    {taskarray}		taskarray	:BPTR	     /* [0] is max number of CLI's
													      * [1] is APTR to process id of CLI 1
													      * [n] is APTR to process id of CLI n */
    {consolesegment}	consolesegment	:BPTR /* SegList for the CLI			   */
    {time}			time	:datestamp /* Current time				   */
    {restartseg}		restartseg	:VALUE     /* SegList for the disk validator process   */
    {info}			info	:BPTR	       /* Pointer to the Info structure		   */
    {filehandlersegment}	filehandlersegment	:BPTR /* segment for a file handler	   */
    {clilist}		clilist	:mlh /* new list of all CLI processes */
						       /* the first cpl_Array is also rn_TaskArray */
    {bootproc}		bootproc	:PTR TO mp /* private ptr to msgport of boot fs	   */
    {shellsegment}	shellsegment	:BPTR   /* seglist for Shell (for NewShell)	   */
    {flags}			flags	:VALUE	       /* dos flags */
ENDOBJECT  /* RootNode */

NATIVE {RNB_WILDSTAR}	CONST RNB_WILDSTAR	= 24
NATIVE {RNF_WILDSTAR}	CONST RNF_WILDSTAR	= $1000000
NATIVE {RNB_PRIVATE1}	CONST RNB_PRIVATE1	= 1	/* private for dos */
NATIVE {RNF_PRIVATE1}	CONST RNF_PRIVATE1	= 2

/* ONLY to be allocated by DOS! */
NATIVE {cliproclist} OBJECT cliproclist
	{node}	node	:mln
	{first}	first	:VALUE	     /* number of first entry in array */
	{array}	array	:ARRAY OF PTR TO mp
			     /* [0] is max number of CLI's in this entry (n)
			      * [1] is CPTR to process id of CLI cpl_First
			      * [n] is CPTR to process id of CLI cpl_First+n-1
			      */
ENDOBJECT

NATIVE {dosinfo} OBJECT dosinfo
    {mcname}	mcname	:BPTR	       /* PRIVATE: system resident module list	    */
    {devinfo}	devinfo	:BPTR	       /* Device List				    */
    {devices}	devices	:BPTR	       /* Currently zero			    */
    {handlers}	handlers	:BPTR       /* Currently zero			    */
    {nethand}	nethand	:APTR	       /* Network handler processid; currently zero */
    {devlock}	devlock	:ss	   /* do NOT access directly! */
    {entrylock}	entrylock	:ss  /* do NOT access directly! */
    {deletelock}	deletelock	:ss /* do NOT access directly! */
ENDOBJECT  /* DosInfo */

NATIVE {segment} OBJECT segment
	{next}	next	:BPTR
	{uc}	uc	:VALUE
	{seg}	seg	:BPTR
	{name}	name[4]	:ARRAY OF UBYTE	/* actually the first 4 chars of BSTR name */
ENDOBJECT

NATIVE {CMD_SYSTEM}	CONST CMD_SYSTEM	= -1
NATIVE {CMD_INTERNAL}	CONST CMD_INTERNAL	= -2
NATIVE {CMD_DISABLED}	CONST CMD_DISABLED	= -999


/* DOS Processes started from the CLI via RUN or NEWCLI have this additional
 * set to data associated with them */

NATIVE {commandlineinterface} OBJECT commandlineinterface
    {result2}	result2	:VALUE	       /* Value of IoErr from last command	  */
    {setname}	setname	:BSTR	       /* Name of current directory		  */
    {commanddir}	commanddir	:BPTR     /* Head of the path locklist		  */
    {returncode}	returncode	:VALUE     /* Return code from last command		  */
    {commandname}	commandname	:BSTR    /* Name of current command		  */
    {faillevel}	faillevel	:VALUE      /* Fail level (set by FAILAT)		  */
    {prompt}	prompt	:BSTR	       /* Current prompt (set by PROMPT)	  */
    {standardinput}	standardinput	:BPTR  /* Default (terminal) CLI input		  */
    {currentinput}	currentinput	:BPTR   /* Current CLI input			  */
    {commandfile}	commandfile	:BSTR    /* Name of EXECUTE command file		  */
    {interactive}	interactive	:VALUE    /* Boolean; True if prompts required	  */
    {background}	background	:VALUE     /* Boolean; True if CLI created by RUN	  */
    {currentoutput}	currentoutput	:BPTR  /* Current CLI output			  */
    {defaultstack}	defaultstack	:VALUE   /* Stack size to be obtained in long words */
    {standardoutput}	standardoutput	:BPTR /* Default (terminal) CLI output		  */
    {module}	module	:BPTR	       /* SegList of currently loaded command	  */
ENDOBJECT  /* CommandLineInterface */

/* structure representing a volume */

NATIVE {devlist} OBJECT devlist
    {next}	next	:BPTR	/* bptr to next device list */
    {type}	type	:VALUE	/* see DLT below */
    {task}	task	:PTR TO mp	/* ptr to handler task */
    {lock}	lock	:BPTR	/* not for volumes */
    {volumedate}	volumedate	:datestamp	/* creation date */
    {locklist}	locklist	:BPTR	/* outstanding locks */
    {disktype}	disktype	:VALUE	/* 'DOS', etc */
    {unused}	unused	:VALUE
    {name}	name	:BSTR	/* bptr to bcpl name */
ENDOBJECT

/* device structure (same as the DeviceNode structure in filehandler.h) */

NATIVE {devinfo} OBJECT devinfo
    {next}	next	:BPTR
    {type}	type	:VALUE
    {task}	task	:APTR
    {lock}	lock	:BPTR
    {handler}	handler	:BSTR
    {stacksize}	stacksize	:VALUE
    {priority}	priority	:VALUE
    {startup}	startup	:VALUE
    {seglist}	seglist	:BPTR
    {globvec}	globvec	:BPTR
    {name}	name	:BSTR
ENDOBJECT

/* combined structure for devices, assigned directories, volumes */

NATIVE {doslist} OBJECT doslist
    {next}	next	:BPTR	 /* bptr to next device on list */
    {type}	type	:VALUE	 /* see DLT below */
    {task}	task	:PTR TO mp	 /* ptr to handler task */
    {lock}	lock	:BPTR
    
	{handler}	handler	:BSTR	/* file name to load if seglist is null */
	{stacksize}	stacksize	:VALUE	/* stacksize to use when starting process */
	{priority}	priority	:VALUE	/* task priority when starting process */
	{startup}	startup	:ULONG	/* startup msg: FileSysStartupMsg for disks */
	{seglist}	seglist	:BPTR	/* already loaded code for new task */
	{globvec}	globvec	:BPTR	/* BCPL global vector to use when starting
																		 * a process. -1 indicates a C/Assembler
																		 * program. */

	{volumedate}	volumedate	:datestamp	 /* creation date */
	{locklist}	locklist	:BPTR	 /* outstanding locks */
	{disktype}	disktype	:VALUE	 /* 'DOS', etc */

	{assignname}	assignname	:ARRAY OF UBYTE     /* name for non-or-late-binding assign */
	{list}	list	:PTR TO assignlist /* for multi-directory assigns (regular) */

    {name}	name	:BSTR	 /* bptr to bcpl name */
ENDOBJECT

/* structure used for multi-directory assigns. AllocVec()ed. */

NATIVE {assignlist} OBJECT assignlist
	{next}	next	:PTR TO assignlist
	{lock}	lock	:BPTR
ENDOBJECT

/* definitions for dl_Type */
NATIVE {DLT_DEVICE}	CONST DLT_DEVICE	= 0
NATIVE {DLT_DIRECTORY}	CONST DLT_DIRECTORY	= 1	/* assign */
NATIVE {DLT_VOLUME}	CONST DLT_VOLUME	= 2
NATIVE {DLT_LATE}	CONST DLT_LATE	= 3	/* late-binding assign */
NATIVE {DLT_NONBINDING}	CONST DLT_NONBINDING	= 4	/* non-binding assign */
NATIVE {DLT_PRIVATE}	CONST DLT_PRIVATE	= -1	/* for internal use only */

/* structure return by GetDeviceProc() */
NATIVE {devproc} OBJECT devproc
	{port}	port	:PTR TO mp
	{lock}	lock	:BPTR
	{flags}	flags	:ULONG
	{devnode}	devnode	:PTR TO doslist	/* DON'T TOUCH OR USE! */
ENDOBJECT

/* definitions for dvp_Flags */
NATIVE {DVPB_UNLOCK}	CONST DVPB_UNLOCK	= 0
NATIVE {DVPF_UNLOCK}	CONST DVPF_UNLOCK	= $01	/* PRIVATE! */
NATIVE {DVPB_ASSIGN}	CONST DVPB_ASSIGN	= 1
NATIVE {DVPF_ASSIGN}	CONST DVPF_ASSIGN	= $02

/* Flags to be passed to LockDosList(), etc */
NATIVE {LDB_DEVICES}	CONST LDB_DEVICES	= 2
NATIVE {LDF_DEVICES}	CONST LDF_DEVICES	= $04
NATIVE {LDB_VOLUMES}	CONST LDB_VOLUMES	= 3
NATIVE {LDF_VOLUMES}	CONST LDF_VOLUMES	= $08
NATIVE {LDB_ASSIGNS}	CONST LDB_ASSIGNS	= 4
NATIVE {LDF_ASSIGNS}	CONST LDF_ASSIGNS	= $10
NATIVE {LDB_ENTRY}	CONST LDB_ENTRY	= 5
NATIVE {LDF_ENTRY}	CONST LDF_ENTRY	= $20
NATIVE {LDB_DELETE}	CONST LDB_DELETE	= 6
NATIVE {LDF_DELETE}	CONST LDF_DELETE	= $40

/* you MUST specify one of LDF_READ or LDF_WRITE */
NATIVE {LDB_READ}	CONST LDB_READ	= 0
NATIVE {LDF_READ}	CONST LDF_READ	= $01
NATIVE {LDB_WRITE}	CONST LDB_WRITE	= 1
NATIVE {LDF_WRITE}	CONST LDF_WRITE	= $02

/* actually all but LDF_ENTRY (which is used for internal locking) */
NATIVE {LDF_ALL}		CONST LDF_ALL		= LDF_DEVICES OR LDF_VOLUMES OR LDF_ASSIGNS

/* a lock structure, as returned by Lock() or DupLock() */
NATIVE {filelock} OBJECT filelock
    {link}	link	:BPTR	/* bcpl pointer to next lock */
    {key}	key	:VALUE		/* disk block number */
    {access}	access	:VALUE	/* exclusive or shared */
    {task}	task	:PTR TO mp	/* handler task's port */
    {volume}	volume	:BPTR	/* bptr to DLT_VOLUME DosList entry */
ENDOBJECT

/* error report types for ErrorReport() */
NATIVE {REPORT_STREAM}		CONST REPORT_STREAM		= 0	/* a stream */
NATIVE {REPORT_TASK}		CONST REPORT_TASK		= 1	/* a process - unused */
NATIVE {REPORT_LOCK}		CONST REPORT_LOCK		= 2	/* a lock */
NATIVE {REPORT_VOLUME}		CONST REPORT_VOLUME		= 3	/* a volume node */
NATIVE {REPORT_INSERT}		CONST REPORT_INSERT		= 4	/* please insert volume */

/* Special error codes for ErrorReport() */
NATIVE {ABORT_DISK_ERROR}	CONST ABORT_DISK_ERROR	= 296	/* Read/write error */
NATIVE {ABORT_BUSY}		CONST ABORT_BUSY		= 288	/* You MUST replace... */

/* types for initial packets to shells from run/newcli/execute/system. */
NATIVE {RUN_EXECUTE}		CONST RUN_EXECUTE		= -1
NATIVE {RUN_SYSTEM}		CONST RUN_SYSTEM		= -2
NATIVE {RUN_SYSTEM_ASYNCH}	CONST RUN_SYSTEM_ASYNCH	= -3

NATIVE {ST_ROOT}		CONST ST_ROOT		= 1
NATIVE {ST_USERDIR}	CONST ST_USERDIR	= 2
NATIVE {ST_SOFTLINK}	CONST ST_SOFTLINK	= 3	/* looks like dir, but may point to a file! */
NATIVE {ST_LINKDIR}	CONST ST_LINKDIR	= 4	/* hard link to dir */
NATIVE {ST_FILE}		CONST ST_FILE		= -3	/* must be negative for FIB! */
NATIVE {ST_LINKFILE}	CONST ST_LINKFILE	= -4	/* hard link to file */
NATIVE {ST_PIPEFILE}	CONST ST_PIPEFILE	= -5	/* for pipes that support ExamineFH */
