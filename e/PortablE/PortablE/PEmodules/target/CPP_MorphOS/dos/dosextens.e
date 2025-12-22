/* $VER: dosextens.h 36.41 (14.5.1992) */
OPT NATIVE
MODULE 'target/exec/tasks', 'target/exec/ports', 'target/exec/libraries', 'target/exec/semaphores', 'target/devices/timer', 'target/dos/dos_shared'
MODULE 'target/exec/lists', 'target/exec/nodes', 'target/exec/types', 'target/dos/dos'
{#include <dos/dosextens.h>}
NATIVE {DOS_DOSEXTENS_H} CONST

/* All DOS processes have this structure */
/* Create and Device Proc returns pointer to the MsgPort in this structure */
/* dev_proc = (struct Process *) (DeviceProc(..) - sizeof(struct Task)); */

NATIVE {Process} OBJECT process
    {pr_Task}		task		:tc
    {pr_MsgPort}	msgport		:mp /* This is BPTR address from DOS functions  */
    {pr_Pad}		pad			:INT		/* Remaining variables on 4 byte boundaries */
    {pr_SegList}	seglist		:BPTR		/* Array of seg lists used by this process  */
    {pr_StackSize}	stacksize	:VALUE	/* Size of process stack in bytes	    */
    {pr_GlobVec}	globvec		:APTR		/* Global vector for this process (BCPL)    */
    {pr_TaskNum}	tasknum		:VALUE		/* CLI task number of zero if not a CLI	    */
    {pr_StackBase}	stackbase	:BPTR	/* Ptr to high memory end of process stack  */
    {pr_Result2}	result2		:VALUE		/* Value of secondary result from last call */
    {pr_CurrentDir}	currentdir	:BPTR	/* Lock associated with current directory   */
    {pr_CIS}		cis			:BPTR		/* Current CLI Input Stream		    */
    {pr_COS}		cos			:BPTR		/* Current CLI Output Stream		    */
    {pr_ConsoleTask}	consoletask		:APTR	/* Console handler process for current window*/
    {pr_FileSystemTask}	filesystemtask	:APTR	/* File handler process for current drive   */
    {pr_CLI}		cli			:BPTR		/* pointer to CommandLineInterface	    */
    {pr_ReturnAddr}	returnaddr	:APTR	/* pointer to previous stack frame	    */
    {pr_PktWait}	pktwait		:APTR		/* Function to be called when awaiting msg  */
    {pr_WindowPtr}	windowptr	:APTR	/* Window for error printing		    */

    /* following definitions are new with 2.0 */
    {pr_HomeDir}	homedir		:BPTR		/* Home directory of executing program	    */
    {pr_Flags}		flags		:VALUE		/* flags telling dos about process	    */
    {pr_ExitCode}	exitcode	:NATIVE {void    (*)()} PTR	/* code to call on exit of program or NULL  */
    {pr_ExitData}	exitdata	:VALUE	/* Passed as an argument to pr_ExitCode.    */
    {pr_Arguments}	arguments	:ARRAY OF UBYTE	/* Arguments passed to the process at start */
    {pr_LocalVars}	localvars	:mlh /* Local environment variables		    */
    {pr_ShellPrivate}	shellprivate	:ULONG	/* for the use of the current shell	    */
    {pr_CES}		ces			:BPTR		/* Error stream - if NULL, use pr_COS	    */
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

/* The long word address (BPTR) of this structure is returned by
 * Open() and other routines that return a file.  You need only worry
 * about this struct to do async io's via PutMsg() instead of
 * standard file system calls */

NATIVE {fh_Func1} DEF
NATIVE {fh_Arg1} DEF

NATIVE {FileHandle} OBJECT filehandle
   {fh_Link}	link		:PTR TO mn	 /* EXEC message	      */
   {fh_Port}	interactive	:PTR TO mp	 /* Reply port for the packet */
   {fh_Type}	type		:PTR TO mp	 /* Port to do PutMsg() to
										  * Address is negative if a plain file */
   {fh_Buf}		buf		:VALUE
   {fh_Pos}		pos		:VALUE
   {fh_End}		end		:VALUE
   {fh_Funcs}	funcs	:VALUE
   {fh_Func2}	func2	:VALUE
   {fh_Func3}	func3	:VALUE
   {fh_Args}	args	:VALUE
   {fh_Arg2}	arg2	:VALUE
ENDOBJECT /* FileHandle */

/* This is the extension to EXEC Messages used by DOS */

NATIVE {dp_Action} DEF
NATIVE {dp_Status} DEF
NATIVE {dp_Status2} DEF
NATIVE {dp_BufAddr} DEF

NATIVE {DosPacket} OBJECT dospacket
   {dp_Link}	link	:PTR TO mn	 /* EXEC message	      */
   {dp_Port}	port	:PTR TO mp	 /* Reply port for the packet */
									 /* Must be filled in each send. */
   {dp_Type}	action	:VALUE
   {dp_Type}	type	:VALUE		 /* See ACTION_... below and
									  * 'R' means Read, 'W' means Write to the
									  * file system */
   {dp_Res1}	status	:VALUE
   {dp_Res1}	res1	:VALUE		 /* For file system calls this is the result
									  * that would have been returned by the
									  * function, e.g. Write ('W') returns actual
									  * length written */
   {dp_Res2}	status2	:VALUE
   {dp_Res2}	res2	:VALUE		 /* For file system calls this is what would
									  * have been returned by IoErr() */
/*  Device packets common equivalents */
   {dp_Arg1}	bufaddr	:VALUE
   {dp_Arg1}	arg1	:VALUE
   {dp_Arg2}	arg2	:VALUE
   {dp_Arg3}	arg3	:VALUE
   {dp_Arg4}	arg4	:VALUE
   {dp_Arg5}	arg5	:VALUE
   {dp_Arg6}	arg6	:VALUE
   {dp_Arg7}	arg7	:VALUE
ENDOBJECT /* DosPacket */

/* A Packet does not require the Message to be before it in memory, but
 * for convenience it is useful to associate the two.
 * Also see the function init_std_pkt for initializing this structure */

NATIVE {StandardPacket} OBJECT standardpacket
   {sp_Msg}	msg	:mn
   {sp_Pkt}	pkt	:dospacket
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

/* Tell a file system to serialize the current volume. This is typically
 * done by changing the creation date of the disk. This packet does not take
 * any arguments.  NOTE: be prepared to handle failure of this packet for
 * V37 ROM filesystems.
 */
NATIVE {ACTION_SERIALIZE_DISK}	CONST ACTION_SERIALIZE_DISK	= 4200

/*
 * A structure for holding error messages - stored as array with error == 0
 * for the last entry.
 */
NATIVE {ErrorString} OBJECT errorstring
	{estr_Nums}		nums	:PTR TO VALUE
	{estr_Strings}	strings	:ARRAY OF UBYTE
ENDOBJECT

/* DOS library node structure.
 * This is the data at positive offsets from the library node.
 * Negative offsets from the node is the jump table to DOS functions
 * node = (struct DosLibrary *) OpenLibrary( "dos.library" .. )	     */

NATIVE {DosLibrary} OBJECT doslibrary
    {dl_lib}	lib	:lib
    {dl_Root}	root:PTR TO rootnode /* Pointer to RootNode, described below */
    {dl_GV}		gv	:APTR	      /* Pointer to BCPL global vector	      */
    {dl_A2}		a2	:VALUE	      /* BCPL standard register values	      */
    {dl_A5}		a5	:VALUE
    {dl_A6}		a6	:VALUE
    {dl_Errors}			errors			:PTR TO errorstring	  /* PRIVATE pointer to array of error msgs */
    {dl_TimeReq}		timereq			:PTR TO timerequest	  /* PRIVATE pointer to timer request */
    {dl_UtilityBase}	utilitybase		:PTR TO lib   /* PRIVATE ptr to utility library */
    {dl_IntuitionBase}	intuitionbase	:PTR TO lib /* PRIVATE ptr to intuition library */
ENDOBJECT  /*	DosLibrary */

/*			       */

NATIVE {RootNode} OBJECT rootnode
    {rn_TaskArray}		taskarray	:BPTR	     /* [0] is max number of CLI's
													      * [1] is APTR to process id of CLI 1
													      * [n] is APTR to process id of CLI n */
    {rn_ConsoleSegment}	consolesegment	:BPTR /* SegList for the CLI			   */
    {rn_Time}			time	:datestamp /* Current time				   */
    {rn_RestartSeg}		restartseg	:VALUE     /* SegList for the disk validator process   */
    {rn_Info}			info	:BPTR	       /* Pointer to the Info structure		   */
    {rn_FileHandlerSegment}	filehandlersegment	:BPTR /* segment for a file handler	   */
    {rn_CliList}		clilist	:mlh /* new list of all CLI processes */
						       /* the first cpl_Array is also rn_TaskArray */
    {rn_BootProc}		bootproc	:PTR TO mp /* private ptr to msgport of boot fs	   */
    {rn_ShellSegment}	shellsegment	:BPTR   /* seglist for Shell (for NewShell)	   */
    {rn_Flags}			flags	:VALUE	       /* dos flags */
ENDOBJECT  /* RootNode */

NATIVE {RNB_WILDSTAR}	CONST RNB_WILDSTAR	= 24
NATIVE {RNF_WILDSTAR}	CONST RNF_WILDSTAR	= $1000000
NATIVE {RNB_PRIVATE1}	CONST RNB_PRIVATE1	= 1	/* private for dos */
NATIVE {RNF_PRIVATE1}	CONST RNF_PRIVATE1	= 2

/* ONLY to be allocated by DOS! */
NATIVE {CliProcList} OBJECT cliproclist
	{cpl_Node}	node	:mln
	{cpl_First}	first	:VALUE	     /* number of first entry in array */
	{cpl_Array}	array	:ARRAY OF PTR TO mp
			     /* [0] is max number of CLI's in this entry (n)
			      * [1] is CPTR to process id of CLI cpl_First
			      * [n] is CPTR to process id of CLI cpl_First+n-1
			      */
ENDOBJECT

NATIVE {di_ResList} DEF

NATIVE {DosInfo} OBJECT dosinfo
    {di_McName}	mcname	:BPTR	       /* PRIVATE: system resident module list	    */
    {di_DevInfo}	devinfo	:BPTR	       /* Device List				    */
    {di_Devices}	devices	:BPTR	       /* Currently zero			    */
    {di_Handlers}	handlers	:BPTR       /* Currently zero			    */
    {di_NetHand}	nethand	:APTR	       /* Network handler processid; currently zero */
    {di_DevLock}	devlock	:ss	   /* do NOT access directly! */
    {di_EntryLock}	entrylock	:ss  /* do NOT access directly! */
    {di_DeleteLock}	deletelock	:ss /* do NOT access directly! */
ENDOBJECT  /* DosInfo */

/* structure for the Dos resident list.  Do NOT allocate these, use	  */
/* AddSegment(), and heed the warnings in the autodocs!			  */

NATIVE {Segment} OBJECT segment
	{seg_Next}	next	:BPTR
	{seg_UC}	uc	:VALUE
	{seg_Seg}	seg	:BPTR
	{seg_Name}	name[4]	:ARRAY OF UBYTE	/* actually the first 4 chars of BSTR name */
ENDOBJECT

NATIVE {CMD_SYSTEM}	CONST CMD_SYSTEM	= -1
NATIVE {CMD_INTERNAL}	CONST CMD_INTERNAL	= -2
NATIVE {CMD_DISABLED}	CONST CMD_DISABLED	= -999


/* DOS Processes started from the CLI via RUN or NEWCLI have this additional
 * set to data associated with them */

NATIVE {CommandLineInterface} OBJECT commandlineinterface
    {cli_Result2}	result2	:VALUE	       /* Value of IoErr from last command	  */
    {cli_SetName}	setname	:BSTR	       /* Name of current directory		  */
    {cli_CommandDir}	commanddir	:BPTR     /* Head of the path locklist		  */
    {cli_ReturnCode}	returncode	:VALUE     /* Return code from last command		  */
    {cli_CommandName}	commandname	:BSTR    /* Name of current command		  */
    {cli_FailLevel}	faillevel	:VALUE      /* Fail level (set by FAILAT)		  */
    {cli_Prompt}	prompt	:BSTR	       /* Current prompt (set by PROMPT)	  */
    {cli_StandardInput}	standardinput	:BPTR  /* Default (terminal) CLI input		  */
    {cli_CurrentInput}	currentinput	:BPTR   /* Current CLI input			  */
    {cli_CommandFile}	commandfile	:BSTR    /* Name of EXECUTE command file		  */
    {cli_Interactive}	interactive	:VALUE    /* Boolean; True if prompts required	  */
    {cli_Background}	background	:VALUE     /* Boolean; True if CLI created by RUN	  */
    {cli_CurrentOutput}	currentoutput	:BPTR  /* Current CLI output			  */
    {cli_DefaultStack}	defaultstack	:VALUE   /* Stack size to be obtained in long words */
    {cli_StandardOutput}	standardoutput	:BPTR /* Default (terminal) CLI output		  */
    {cli_Module}	module	:BPTR	       /* SegList of currently loaded command	  */
ENDOBJECT  /* CommandLineInterface */

/* This structure can take on different values depending on whether it is
 * a device, an assigned directory, or a volume.  Below is the structure
 * reflecting volumes only.  Following that is the structure representing
 * only devices. Following that is the unioned structure representing all
 * the values
 */

/* structure representing a volume */

NATIVE {DeviceList} OBJECT devlist
    {dl_Next}	next	:BPTR	/* bptr to next device list */
    {dl_Type}	type	:VALUE	/* see DLT below */
    {dl_Task}	task	:PTR TO mp	/* ptr to handler task */
    {dl_Lock}	lock	:BPTR	/* not for volumes */
    {dl_VolumeDate}	volumedate	:datestamp	/* creation date */
    {dl_LockList}	locklist	:BPTR	/* outstanding locks */
    {dl_DiskType}	disktype	:VALUE	/* 'DOS', etc */
    {dl_unused}	unused	:VALUE
    {dl_Name}	name	:BSTR	/* bptr to bcpl name */
ENDOBJECT

/* device structure (same as the DeviceNode structure in filehandler.h) */

NATIVE {DevInfo} OBJECT devinfo
    {dvi_Next}	next	:BPTR
    {dvi_Type}	type	:VALUE
    {dvi_Task}	task	:APTR
    {dvi_Lock}	lock	:BPTR
    {dvi_Handler}	handler	:BSTR
    {dvi_StackSize}	stacksize	:VALUE
    {dvi_Priority}	priority	:VALUE
    {dvi_Startup}	startup	:VALUE
    {dvi_SegList}	seglist	:BPTR
    {dvi_GlobVec}	globvec	:BPTR
    {dvi_Name}	name	:BSTR
ENDOBJECT

/* combined structure for devices, assigned directories, volumes */

NATIVE {DosList} OBJECT doslist
    {dol_Next}	next	:BPTR	 /* bptr to next device on list */
    {dol_Type}	type	:VALUE	 /* see DLT below */
    {dol_Task}	task	:PTR TO mp	 /* ptr to handler task */
    {dol_Lock}	lock	:BPTR
    
	{dol_misc.dol_handler.dol_Handler}	handler	:BSTR	/* file name to load if seglist is null */
	{dol_misc.dol_handler.dol_StackSize}	stacksize	:VALUE	/* stacksize to use when starting process */
	{dol_misc.dol_handler.dol_Priority}	priority	:VALUE	/* task priority when starting process */
	{dol_misc.dol_handler.dol_Startup}	startup	:ULONG	/* startup msg: FileSysStartupMsg for disks */
	{dol_misc.dol_handler.dol_SegList}	seglist	:BPTR	/* already loaded code for new task */
	{dol_misc.dol_handler.dol_GlobVec}	globvec	:BPTR	/* BCPL global vector to use when starting
																		 * a process. -1 indicates a C/Assembler
																		 * program. */

	{dol_misc.dol_volume.dol_VolumeDate}	volumedate	:datestamp	 /* creation date */
	{dol_misc.dol_volume.dol_LockList}	locklist	:BPTR	 /* outstanding locks */
	{dol_misc.dol_volume.dol_DiskType}	disktype	:VALUE	 /* 'DOS', etc */

	{dol_misc.dol_assign.dol_AssignName}	assignname	:ARRAY OF UBYTE     /* name for non-or-late-binding assign */
	{dol_misc.dol_assign.dol_List}	list	:PTR TO assignlist /* for multi-directory assigns (regular) */

    {dol_Name}	name	:BSTR	 /* bptr to bcpl name */
ENDOBJECT

/* structure used for multi-directory assigns. AllocVec()ed. */

NATIVE {AssignList} OBJECT assignlist
	{al_Next}	next	:PTR TO assignlist
	{al_Lock}	lock	:BPTR
ENDOBJECT

/* definitions for dl_Type */
NATIVE {DLT_DEVICE}	CONST DLT_DEVICE	= 0
NATIVE {DLT_DIRECTORY}	CONST DLT_DIRECTORY	= 1	/* assign */
NATIVE {DLT_VOLUME}	CONST DLT_VOLUME	= 2
NATIVE {DLT_LATE}	CONST DLT_LATE	= 3	/* late-binding assign */
NATIVE {DLT_NONBINDING}	CONST DLT_NONBINDING	= 4	/* non-binding assign */
NATIVE {DLT_PRIVATE}	CONST DLT_PRIVATE	= -1	/* for internal use only */

/* structure return by GetDeviceProc() */
NATIVE {DevProc} OBJECT devproc
	{dvp_Port}	port	:PTR TO mp
	{dvp_Lock}	lock	:BPTR
	{dvp_Flags}	flags	:ULONG
	{dvp_DevNode}	devnode	:PTR TO doslist	/* DON'T TOUCH OR USE! */
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
NATIVE {FileLock} OBJECT filelock
    {fl_Link}	link	:BPTR	/* bcpl pointer to next lock */
    {fl_Key}	key	:VALUE		/* disk block number */
    {fl_Access}	access	:VALUE	/* exclusive or shared */
    {fl_Task}	task	:PTR TO mp	/* handler task's port */
    {fl_Volume}	volume	:BPTR	/* bptr to DLT_VOLUME DosList entry */
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
/* For shell-writers only */
NATIVE {RUN_EXECUTE}		CONST RUN_EXECUTE		= -1
NATIVE {RUN_SYSTEM}		CONST RUN_SYSTEM		= -2
NATIVE {RUN_SYSTEM_ASYNCH}	CONST RUN_SYSTEM_ASYNCH	= -3

/* Types for fib_DirEntryType.	NOTE that both USERDIR and ROOT are	 */
/* directories, and that directory/file checks should use <0 and >=0.	 */
/* This is not necessarily exhaustive!	Some handlers may use other	 */
/* values as needed, though <0 and >=0 should remain as supported as	 */
/* possible.								 */
NATIVE {ST_ROOT}		CONST ST_ROOT		= 1
NATIVE {ST_USERDIR}	CONST ST_USERDIR	= 2
NATIVE {ST_SOFTLINK}	CONST ST_SOFTLINK	= 3	/* looks like dir, but may point to a file! */
NATIVE {ST_LINKDIR}	CONST ST_LINKDIR	= 4	/* hard link to dir */
NATIVE {ST_FILE}		CONST ST_FILE		= -3	/* must be negative for FIB! */
NATIVE {ST_LINKFILE}	CONST ST_LINKFILE	= -4	/* hard link to file */
NATIVE {ST_PIPEFILE}	CONST ST_PIPEFILE	= -5	/* for pipes that support ExamineFH */
