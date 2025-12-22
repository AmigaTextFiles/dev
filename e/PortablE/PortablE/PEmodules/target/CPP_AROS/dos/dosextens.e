/* $Id: dosextens.h 28978 2008-07-04 06:07:27Z sonic $ */
OPT NATIVE
MODULE 'target/aros/config', 'target/exec/types', 'target/exec/tasks', 'target/exec/ports', 'target/exec/libraries', 'target/exec/devices', 'target/exec/semaphores', 'target/devices/timer', 'target/exec/interrupts', 'target/dos/dos'
MODULE 'target/exec/execbase', 'target/exec/lists', 'target/exec/nodes'
{#include <dos/dosextens.h>}
NATIVE {DOS_DOSEXTENS_H} CONST

/* This is how the base of dos.library looks like. */
NATIVE {DosLibrary} OBJECT doslibrary
    /* A normal library-base as defined in <exec/libraries.h>. */
    {dl_lib}	lib	:lib

    {dl_Root}	root	:PTR TO rootnode

->#if (AROS_FLAVOUR & AROS_FLAVOUR_BINCOMPAT)
    /* The following fields are not used by AROS and are just there to
       guarantee binary compatibility. DO NOT USE THESE FIELDS IN ANY WAY.
       Original names were: dl_GV, dl_A2, dl_A5 and dl_A6 */
    {NoAROS2}	noaros2	:APTR
    {NoAROS3}	noaros3[3]	:ARRAY OF SLONG
->#endif

    /* The following fields are PRIVATE! */
    {dl_Errors}	errors	:PTR TO errorstring
    {dl_TimerBase}	timereq	:PTR TO dd
    {dl_UtilityBase}	utilitybase	:PTR TO lib
    {dl_IntuitionBase}	intuitionbase	:PTR TO lib

    /* These are AROS specific extensions. They are all PRIVATE! */
    {dl_TimerIO}	timerio	:timerequest

    {dl_DosListLock}	doslistlock	:ss
    {dl_DevInfo}	devinfo	:PTR TO doslist
    {dl_SysBase}	sysbase	:PTR TO execbase
    {dl_SegList}	seglist	:BPTR
    {dl_NulHandler}	nulhandler	:PTR TO dd
    {dl_NulLock}	nullock	:PTR TO unit

    {dl_LDObjectsListSigSem}	ldobjectslistsigsem	:ss
    {dl_LDObjectsList}	ldobjectslist	:lh
    {dl_LDHandler}	ldhandler	:is
    {dl_LDDemonPort}	lddemonport	:PTR TO mp
    {dl_LDDemonTask}	lddemontask	:PTR TO process
    {dl_LDReturn}	ldreturn	:ULONG
    {dl_SYSLock}	syslock	:BPTR
    
->#if 0
->    {dl_ProcCnt}	proccnt	:ULONG
->#endif
      /* The flags are the same, as they were in RootNode->rn_Flags. See below
         for definitions. */
    {dl_Flags}	flags	:ULONG

    /* Resident segment list **PRIVATE** */
    {dl_ResList}	reslist	:BPTR
ENDOBJECT

/* dl_Flags/rn_Flags */
NATIVE {RNB_WILDSTAR} CONST RNB_WILDSTAR = 24 /* Activate '*' as wildcard character. */
NATIVE {RNF_WILDSTAR} CONST RNF_WILDSTAR = $1000000


NATIVE {RootNode} OBJECT rootnode
      /* (IPTR *) Pointer to an array containing pointers to CLI processes.
         The CLI process number is equal to the index of that array. The
         first field (index 0) contains the maximal number of CLI processes.
         See also rn_CliList. */
    {rn_TaskArray}	taskarray	:BPTR
      /* (void *) Pointer to the SegList for CLIs. */
    {rn_ConsoleSegment}	consolesegment	:BPTR
      /* The current time. */
    {rn_Time}	time	:datestamp
      /* (APTR) The SegList of the process that handles validation of devices.
      */
    {rn_RestartSeg}	restartseg	:VALUE
      /* (struct DosInfo *) see below for DosInfo */
    {rn_Info}	info	:BPTR
    {rn_FileHandlerSegment}	filehandlersegment	:BPTR
      /* List of all CLI processes (struct CliProcList - see below). See also
         rn_TaskArray. */
    {rn_CliList}	clilist	:mlh
      /* Message port of boot filesystem. (PRIVATE) */
    {rn_BootProc}	bootproc	:PTR TO mp
      /* (void *) Pointer to the SegList for shells. */
    {rn_ShellSegment}	shellsegment	:BPTR
      /* Additional flags (see above). */
    {rn_Flags}	flags	:VALUE

    /* RootNode arbitrator */
    {rn_RootLock}	rootlock	:ss
ENDOBJECT


/* Structure that is linked into the rootnode's rn_CliList. Completely
   private, of course! ... and it's not compatible to AmigaOS. */
NATIVE {CLIInfo} OBJECT cliinfo
    {ci_Node}	node	:ln
    {ci_Process}	process	:PTR TO process
ENDOBJECT


/* The following structures in this sections are not used by AROS and may
   be removed in the future. So BEWARE, if you use them. */

/*#if 0

NATIVE {DosInfo} OBJECT dosinfo
    {di_McName}	mcname	:BPTR   /* PRIVATE */
    {di_DevInfo}	devinfo	:BPTR
    {di_Devices}	devices	:BPTR
    {di_Handlers}	handlers	:BPTR
    {di_NetHand}	nethand	:APTR

    /* The following semaphores are PRIVATE. */
    {di_DevLock}	devlock	:ss
    {di_EntryLock}	entrylock	:ss
    {di_DeleteLock}	deletelock	:ss
ENDOBJECT
NATIVE {di_ResList} CONST DI_RESLIST = di_McName

#endif*/


/* Standard process structure. Processes are just extended tasks. */
NATIVE {Process} OBJECT process
      /* Embedded task structure as defined in <exec/tasks.h>. */
    {pr_Task}	task	:tc

      /* Processes standard message-port. Used for various puposes. */
    {pr_MsgPort}	msgport	:mp
    {pr_Pad}	pad	:INT     /* PRIVATE */
      /* SegList array, used by this process. (void **) */
    {pr_SegList}	seglist	:BPTR
      /* StackSize of the current process. */
    {pr_StackSize}	stacksize	:VALUE
    {pr_GlobVec}	globvec	:APTR
      /* CLI process number. This may be 0, in which case the process is not
         connected to a CLI. */
    {pr_TaskNum}	tasknum	:VALUE
      /* Pointer to upper end of stack. (void *) */
    {pr_StackBase}	stackbase	:BPTR
      /* Secondary return-value, as defined in <dos/dos.h>. As of now this
         field is declared PRIVATE. Use IoErr()/SetIoErr() to access it. */
    {pr_Result2}	result2	:VALUE
      /* Lock of the current directory. As of now this is declared READ-ONLY.
         Use CurrentDir() to set it. (struct FileLock *) */
    {pr_CurrentDir}	currentdir	:BPTR
      /* Standard input file. As of now this is declared WRITE-ONLY. Use
         Input() to query it. */
    {pr_CIS}	cis	:BPTR
      /* Standard output file. As of now this is declared WRITE-ONLY. Use
         Output() to query it. */
    {pr_COS}	cos	:BPTR
      /* Task to handle the console associated with process. */
    {pr_ConsoleTask}	consoletask	:APTR
      /* The task that is responsible for handling the filesystem. */
    {pr_FileSystemTask}	filesystemtask	:APTR
      /* CLI the process is connected to. (struct CommandLineInterface *) */
    {pr_CLI}	cli	:BPTR
    {pr_ReturnAddr}	returnaddr	:APTR
      /* Function to be called, when process waits for a packet-message. */
    {pr_PktWait}	pktwait	:APTR
      /* Standard-Window of process. */
    {pr_WindowPtr}	windowptr	:APTR
      /* Lock to home-directory of process. (struct FileLock *) */
    {pr_HomeDir}	homedir	:BPTR
    {pr_Flags}	flags	:VALUE /* see below */

      /* Code that is called, when the process exits. pr_ExitData takes an
         argument to be passed to this code. */
    {pr_ExitCode}	exitcode	:NATIVE {void   (*)()} PTR
    {pr_ExitData}	exitdata	:IPTR
      /* Arguments passed to the process from caller. */
    {pr_Arguments}	arguments	:/*STRPTR*/ ARRAY OF CHAR

      /* List of local environment variables. This list should be in
         alphabetical order. Multiple entries may have the same name, if they
         are of different types. See <dos/var.h> for more information. */
    {pr_LocalVars}	localvars	:mlh
    {pr_ShellPrivate}	shellprivate	:ULONG
      /* Standard error file. May be NULL, in which case pr_COS is to be used.
         Use this instead of Output() to report errors. */
    {pr_CES}	ces	:BPTR
ENDOBJECT

/* pr_Flags (all PRIVATE) They mainly descibe what happens if the process
   exits, i.e. which resources the process should clean itself. The flags
   are self-explaining. */
NATIVE {PRB_FREESEGLIST} CONST PRB_FREESEGLIST = 0
NATIVE {PRB_FREECURRDIR} CONST PRB_FREECURRDIR = 1
NATIVE {PRB_FREECLI}	CONST PRB_FREECLI	= 2
NATIVE {PRB_CLOSEINPUT}	CONST PRB_CLOSEINPUT	= 3
NATIVE {PRB_CLOSEOUTPUT} CONST PRB_CLOSEOUTPUT = 4
NATIVE {PRB_FREEARGS}	CONST PRB_FREEARGS	= 5
NATIVE {PRB_CLOSEERROR}	CONST PRB_CLOSEERROR	= 6
NATIVE {PRB_SYNCHRONOUS} CONST PRB_SYNCHRONOUS = 7
NATIVE {PRB_WAITINGFORCHILD} CONST PRB_WAITINGFORCHILD = 8 /* This one is subject to change! */

NATIVE {PRF_FREESEGLIST} CONST PRF_FREESEGLIST = $1
NATIVE {PRF_FREECURRDIR} CONST PRF_FREECURRDIR = $2
NATIVE {PRF_FREECLI}	CONST PRF_FREECLI	= $4
NATIVE {PRF_CLOSEINPUT}	CONST PRF_CLOSEINPUT	= $8
NATIVE {PRF_CLOSEOUTPUT} CONST PRF_CLOSEOUTPUT = $10
NATIVE {PRF_FREEARGS}	CONST PRF_FREEARGS	= $20
NATIVE {PRF_CLOSEERROR}	CONST PRF_CLOSEERROR	= $40
NATIVE {PRF_SYNCHRONOUS} CONST PRF_SYNCHRONOUS = $80
NATIVE {PRF_WAITINGFORCHILD} CONST PRF_WAITINGFORCHILD = $100

/* Structure used for CLIs and Shells. Allocate this structure with
   AllocDosObject() only! */
NATIVE {CommandLineInterface} OBJECT commandlineinterface
      /* Secondary error code, set by last command. */
    {cli_Result2}	result2	:VALUE
      /* Name of the current directory. */
    {cli_SetName}	setname	:BSTR
      /* Lock of the first directory in path. (struct FileLock *) */
    {cli_CommandDir}	commanddir	:BPTR
      /* Error code, the last command returned. See <dos/dos.h> for
         definitions. */
    {cli_ReturnCode}	returncode	:VALUE
      /* Name of the command that is currently executed. */
    {cli_CommandName}	commandname	:BSTR
      /* Fail-Level as set by the command "FailAt". */
    {cli_FailLevel}	faillevel	:VALUE
      /* Current prompt in the CLI window. */
    {cli_Prompt}	prompt	:BSTR
      /* Standard/Default input file. (struct FileLock *) */
    {cli_StandardInput}	standardinput	:BPTR
      /* Current input file. (struct FileLock *) */
    {cli_CurrentInput}	currentinput	:BPTR
      /* Name of the file that is currently executed. */
    {cli_CommandFile}	commandfile	:BSTR
      /* TRUE if the currently CLI is connected to a controlling terminal,
         otherwise FALSE. */
    {cli_Interactive}	interactive	:VALUE
      /* FALSE if there is no controlling terminal, otherwise TRUE. */
    {cli_Background}	background	:VALUE
      /* Current output file. (struct FileLock *) */
    {cli_CurrentOutput}	currentoutput	:BPTR
      /* Default stack size as set by the command "Stack". */
    {cli_DefaultStack}	defaultstack	:VALUE
      /* Standard/Default output file. (struct FileLock *) */
    {cli_StandardOutput}	standardoutput	:BPTR
      /* SegList of currently loaded command. */
    {cli_Module}	module	:BPTR

       /* Here begins the aros specific part */
      /* Standard/Default Error file. (struct FileLock *) */
    {cli_StandardError}	standarderror	:BPTR
ENDOBJECT

/* CLI_DEFAULTSTACK_UNIT * cli_DefaultStack = stack in bytes */

NATIVE {CLI_DEFAULTSTACK_UNIT}	CONST CLI_DEFAULTSTACK_UNIT	= SIZEOF LONG

/* Devices process structure as returned by GetDeviceProc(). */
NATIVE {DevProc} OBJECT devproc
    {dvp_Port}	port	:PTR TO mp
    {dvp_Lock}	lock	:BPTR    /* struct FileLock * */
    {dvp_Flags}	flags	:ULONG   /* see below */
    {dvp_DevNode}	devnode	:PTR TO doslist /* PRIVATE */
ENDOBJECT

/* dvp_Flags */
NATIVE {DVPB_UNLOCK} CONST DVPB_UNLOCK = 0
NATIVE {DVPB_ASSIGN} CONST DVPB_ASSIGN = 1
NATIVE {DVPF_UNLOCK} CONST DVPF_UNLOCK = $1
NATIVE {DVPF_ASSIGN} CONST DVPF_ASSIGN = $2


/* Standard file-handle as returned by Open() (as BPTR). Generally said, you
   should not use this structure in any way and only use library-calls to
   access files. Note that this structure is very different to the structure
   used in AmigaOS! Treat this structure as PRIVATE. If you want to create
   this structure nevertheless, use AllocDosObject(). */
NATIVE {FileHandle} OBJECT filehandle
    /* The next three are used with packet-based filesystems */
    {fh_Link}	link	:PTR TO mn   /* exec message containing packet */
    {fh_Port}	interactive	:PTR TO mp   /* packet reply port */
    {fh_Type}	type	:PTR TO mp   /* port to send packets to */

    {fh_Buf}	buf	:PTR TO UBYTE
    {fh_Pos}	pos	:PTR TO UBYTE
    {fh_End}	end	:PTR TO UBYTE

    /* The following four fields have different names and a different
       function than their AmigaOS equivalents. The original names were:
       fh_Funcs/fh_Func1, fh_Func2, fh_Func3, fh_Args/fh_Arg1 and fh_Arg2 */
    {fh_Size}	size	:ULONG
    {fh_Flags}	flags	:ULONG   /* see below */
      /* This is a pointer to a filesystem handler. See <dos/filesystems.h> for
         more information. */
    {fh_Device}	device	:PTR TO dd

    /* SDuvan: Added this and removed the #if below. This field allows us
               to emulate packets -- specifically it makes it possible
	       to implement the ***Pkt() functions */
    {fh_CompatibilityHack}	compatibilityhack	:PTR TO filehandle

      /* A private pointer to a device specific filehandle structure. See
         <dos/filesystems.h> for more information. */
    {fh_Unit}	unit	:PTR TO unit
->#if (AROS_FLAVOUR & AROS_FLAVOUR_BINCOMPAT)
    {fh_NoAROS3}	noaros3	:VALUE /* not used by AROS */
->#endif
ENDOBJECT

NATIVE {fh_Arg1}  DEF

/* fh_Flags. The flags are AROS specific and therefore PRIVATE.. */
NATIVE {FHF_WRITE} CONST FHF_WRITE = $7FFFFFFF+1	->(~0UL/2+1)
NATIVE {FHF_BUF}     CONST FHF_BUF     = 1
NATIVE {FHF_APPEND}  CONST FHF_APPEND  = 2
NATIVE {FHF_LINEBUF} CONST FHF_LINEBUF = 4
NATIVE {FHF_NOBUF}   CONST FHF_NOBUF   = 8

/* Structure of a lock. This is provided as it may be required internally by
 * packet-based filesystems, but it is not used by dos.library and the rest of
 * AROS. Lock() returns a struct FileHandle! */
NATIVE {FileLock} OBJECT filelock
    {fl_Link}	link	:BPTR   /* (struct FileLock *) Pointer to next lock. */
    {fl_Key}	key	:VALUE
    {fl_Access}	access	:VALUE
    {fl_Task}	task	:PTR TO mp
    {fl_Volume}	volume	:BPTR /* (struct DeviceList * - see below) */
ENDOBJECT

/* This is a definition telling that AROS uses fake FileLocks which are
   FileHandles in fact. It will go away when real FileLocks are implemented. */
NATIVE {AROS_FAKE_LOCK} CONST

/* Constants, defining of what kind a file is. These constants are used in
   many structures, including FileInfoBlock (<dos/dos.h>) and ExAllData
   (<dos/exall.h>). */
NATIVE {ST_PIPEFILE} CONST ST_PIPEFILE = -5 /* File is a pipe */
NATIVE {ST_LINKFILE} CONST ST_LINKFILE = -4 /* Hard link to a file */
NATIVE {ST_FILE}     CONST ST_FILE     = -3 /* Plain file */
NATIVE {ST_ROOT}      CONST ST_ROOT      = 1 /* Root directory of filesystem */
NATIVE {ST_USERDIR}   CONST ST_USERDIR   = 2 /* Normal directory */
NATIVE {ST_SOFTLINK}  CONST ST_SOFTLINK  = 3 /* Soft link (may be a file or directory) */
NATIVE {ST_LINKDIR}   CONST ST_LINKDIR   = 4 /* Hard link to a directory */


/* This structure is returned by LockDosList() and similar calls. This
   structure is different to the AmigaOS one. But this structure is PRIVATE
   anyway. Use system-calls for dos list-handling. */
NATIVE {DosList} OBJECT doslist
    {dol_Next}	next	:PTR TO doslist
    {dol_Type}	type	:VALUE
    {dol_Task}	task	:PTR TO mp
    {dol_Lock}	lock	:BPTR

      /* This union combines all the different types. */
    {dol_misc.dol_handler.dol_Handler}	handler	:BSTR
    {dol_misc.dol_handler.dol_StackSize}	stacksize	:VALUE
    {dol_misc.dol_handler.dol_Priority}	priority	:VALUE
    {dol_misc.dol_handler.dol_Startup}	startup	:BPTR
    {dol_misc.dol_handler.dol_NoAROS3}	noaros3[2]	:ARRAY OF BPTR
    {dol_misc.dol_volume.dol_VolumeDate}	volumedate	:datestamp
    {dol_misc.dol_volume.dol_LockList}	locklist	:BPTR
    {dol_misc.dol_volume.dol_DiskType}	disktype	:VALUE
    {dol_misc.dol_volume.dol_unused}	unused	:IPTR
    {dol_misc.dol_assign.dol_AssignName}	assignname	:ARRAY OF UBYTE
    {dol_misc.dol_assign.dol_List}	list	:PTR TO assignlist

    {dol_OldName}	name	:BSTR

    /* The following fields are new to AROS. */
    {dol_DevName}	devname	:/*STRPTR*/ ARRAY OF CHAR
    {dol_Device}	device	:PTR TO dd
    {dol_Unit}	unit	:PTR TO unit
ENDOBJECT
NATIVE {dol_Name} DEF

/* dol_Type/dl_Type/dvi_Type. Given to MakeDosEntry(). */
NATIVE {DLT_DEVICE}     CONST DLT_DEVICE     = 0 /* A real filesystem (or similar) */
NATIVE {DLT_DIRECTORY}  CONST DLT_DIRECTORY  = 1 /* Just a simple assign */
NATIVE {DLT_VOLUME}     CONST DLT_VOLUME     = 2 /* Volume node (for removable media) */
NATIVE {DLT_LATE}       CONST DLT_LATE       = 3 /* Late binding assign (not yet) */
NATIVE {DLT_NONBINDING} CONST DLT_NONBINDING = 4 /* Nonbinding assign (not yet) */


/* The following structures are essentially the same as DosList above. The
   difference is that they support just one type of entry. You can use them
   instead of DosList, if you have a list, containing just one type of
   entries. For more information see above. */

/* Structure that describes a volume.
   ATTENTION: This struture does currently work on 32bit computers only due to
              the fact that dl_unused does not compensate the missing pointers
              in this structure. In DevInfo we have three pointer and three
              longwords, while in this structure we have only two pointers and
              four longwords. */
NATIVE {DeviceList} OBJECT devlist
    {dl_Next}	next	:PTR TO devlist
    {dl_Type}	type	:VALUE /* see above, always = DLT_VOLUME */

    {dl_Task}	task	:PTR TO mp
    {dl_Lock}	lock	:BPTR

      /* Embedded DateStamp structured as defined in <dos/dos.h>. At this
         date the volume was created. */
    {dl_VolumeDate}	volumedate	:datestamp
      /* (void *) List of all locks on the volume. */
    {dl_LockList}	locklist	:BPTR
      /* Type of the disk. (see <dos/dos.h> for definitions) */
    {dl_DiskType}	disktype	:VALUE
    {dl_unused}	unused	:IPTR /* PRIVATE */

    {dl_OldName}	name	:BSTR

    {dl_DevName}	devname	:/*STRPTR*/ ARRAY OF CHAR
    {dl_Device}	device	:PTR TO dd
    {dl_Unit}	unit	:PTR TO unit
ENDOBJECT
NATIVE {dl_Name} DEF


/* Structure that describes a device. This is essentially the same structure
   as DeviceNode, defined in <dos/filehandler.h>. */
NATIVE {DevInfo} OBJECT devinfo
    {dvi_Next}	next	:PTR TO devinfo
    {dvi_Type}	type	:VALUE /* see above, always = DLT_DEVICE */

    {dvi_Task}	task	:PTR TO mp
    {dvi_Lock}	lock	:BPTR

    {dvi_Handler}	handler	:BSTR    /* Device name for handler. */
    {dvi_StackSize}	stacksize	:VALUE  /* Packet-handler initial stack size */
    {dvi_Priority}	priority	:VALUE   /* Packet-handler initial priority */
    {dvi_Startup}	startup	:BPTR    /* (struct FileSysStartupMsg * - defined in
                            <dos/filehandler.h>) */
    {dvi_NoAROS4}	noaros4[2]	:ARRAY OF BPTR /* PRIVATE */

    {dvi_OldName}	oldname	:BSTR

    {dvi_DevName}	name	:/*STRPTR*/ ARRAY OF CHAR
    {dvi_Device}	device	:PTR TO dd
    {dvi_Unit}	unit	:PTR TO unit
ENDOBJECT
NATIVE {dvi_Name} DEF


/* Dos list scanning and locking modes as used in LockDosList() */
/* Specify either LDF_READ, if you want a non-exclusive lock, or LDF_WRITE,
   if you want an exclusive lock (i.e. if you want to modify the list).
*/
NATIVE {LDB_READ}    CONST LDB_READ    = 0 /* Non-exclusive/read lock */
NATIVE {LDB_WRITE}   CONST LDB_WRITE   = 1 /* Exclusive/write lock */
/* Specify which list(s) to lock. */
NATIVE {LDB_DEVICES} CONST LDB_DEVICES = 2 /* Device list */
NATIVE {LDB_VOLUMES} CONST LDB_VOLUMES = 3 /* Volume list */
NATIVE {LDB_ASSIGNS} CONST LDB_ASSIGNS = 4 /* Assign list */
NATIVE {LDB_ENTRY}   CONST LDB_ENTRY   = 5
NATIVE {LDB_DELETE}  CONST LDB_DELETE  = 6

NATIVE {LDF_READ}    CONST LDF_READ    = $1
NATIVE {LDF_WRITE}   CONST LDF_WRITE   = $2
NATIVE {LDF_DEVICES} CONST LDF_DEVICES = $4
NATIVE {LDF_VOLUMES} CONST LDF_VOLUMES = $8
NATIVE {LDF_ASSIGNS} CONST LDF_ASSIGNS = $10
NATIVE {LDF_ENTRY}   CONST LDF_ENTRY   = $20
NATIVE {LDF_DELETE}  CONST LDF_DELETE  = $40
NATIVE {LDF_ALL}     CONST LDF_ALL     = (LDF_DEVICES OR LDF_VOLUMES OR LDF_ASSIGNS)


/* Used for assigns that point to multiple directories. */
NATIVE {AssignList} OBJECT assignlist
    {al_Next}	next	:PTR TO assignlist /* Pointer to next assign node. */
    {al_Lock}	lock	:BPTR /* (struct FileLock *) Lock of on of the
                                    directories. */
ENDOBJECT


/* This section is OBSOLETE and is not implemented in AROS! AROS uses a
   different concept for filesystem-handling. See <dos/filesystem.h> for
   more information. Use the structures and defines in this section only, if
   you are programming just for AmigaOS. */


/* Allocate this structure with AllocDosObject(). */
NATIVE {DosPacket} OBJECT dospacket
   {dp_Link}	link	:PTR TO mn /* Pointer to a standard exec message. */
   {dp_Port}	port	:PTR TO mp /* Reply-Port of that packet. */

   {dp_Type}	type	:VALUE /* see below */
   {dp_Res1}	res1	:VALUE /* Normal return value. */
   {dp_Res2}	res2	:VALUE /* Secondary return value (as returned by IoErr()). See
                    <dos/dos.h> for possible values. */

   /* The actual data. */
   {dp_Arg1}	arg1	:IPTR
   {dp_Arg2}	arg2	:IPTR
   {dp_Arg3}	arg3	:IPTR
   {dp_Arg4}	arg4	:IPTR
   {dp_Arg5}	arg5	:IPTR
   {dp_Arg6}	arg6	:IPTR
   {dp_Arg7}	arg7	:IPTR
ENDOBJECT
NATIVE {dp_Action}   DEF
NATIVE {dp_Status}   DEF
NATIVE {dp_Status2}  DEF
NATIVE {dp_BufAddr}  DEF


/* These are defined for packet emulation purposes only! AROS doesn't use
   packets at all, but emulates (some of) them via DoPkt(), SendPkt() and
   others to function like they did in AmigaOS */

/* dp_Type */
NATIVE {ACTION_NIL}             CONST ACTION_NIL             = 0
NATIVE {ACTION_STARTUP}         CONST ACTION_STARTUP         = 0
NATIVE {ACTION_GET_BLOCK}       CONST ACTION_GET_BLOCK       = 2	/* Obsolete */
NATIVE {ACTION_SET_MAP}         CONST ACTION_SET_MAP         = 4
NATIVE {ACTION_DIE}             CONST ACTION_DIE             = 5
NATIVE {ACTION_EVENT}           CONST ACTION_EVENT           = 6
NATIVE {ACTION_CURRENT_VOLUME}  CONST ACTION_CURRENT_VOLUME  = 7
NATIVE {ACTION_LOCATE_OBJECT}   CONST ACTION_LOCATE_OBJECT   = 8
NATIVE {ACTION_RENAME_DISK}     CONST ACTION_RENAME_DISK     = 9
NATIVE {ACTION_FREE_LOCK}      CONST ACTION_FREE_LOCK      = 15
NATIVE {ACTION_DELETE_OBJECT}  CONST ACTION_DELETE_OBJECT  = 16
NATIVE {ACTION_RENAME_OBJECT}  CONST ACTION_RENAME_OBJECT  = 17
NATIVE {ACTION_MORE_CACHE}     CONST ACTION_MORE_CACHE     = 18
NATIVE {ACTION_COPY_DIR}       CONST ACTION_COPY_DIR       = 19
NATIVE {ACTION_WAIT_CHAR}      CONST ACTION_WAIT_CHAR      = 20
NATIVE {ACTION_SET_PROTECT}    CONST ACTION_SET_PROTECT    = 21
NATIVE {ACTION_CREATE_DIR}     CONST ACTION_CREATE_DIR     = 22
NATIVE {ACTION_EXAMINE_OBJECT} CONST ACTION_EXAMINE_OBJECT = 23
NATIVE {ACTION_EXAMINE_NEXT}   CONST ACTION_EXAMINE_NEXT   = 24
NATIVE {ACTION_DISK_INFO}      CONST ACTION_DISK_INFO      = 25
NATIVE {ACTION_INFO}           CONST ACTION_INFO           = 26
NATIVE {ACTION_FLUSH}          CONST ACTION_FLUSH          = 27
NATIVE {ACTION_SET_COMMENT}    CONST ACTION_SET_COMMENT    = 28
NATIVE {ACTION_PARENT}         CONST ACTION_PARENT         = 29
NATIVE {ACTION_TIMER}          CONST ACTION_TIMER          = 30
NATIVE {ACTION_INHIBIT}        CONST ACTION_INHIBIT        = 31
NATIVE {ACTION_DISK_TYPE}      CONST ACTION_DISK_TYPE      = 32
NATIVE {ACTION_DISK_CHANGE}    CONST ACTION_DISK_CHANGE    = 33
NATIVE {ACTION_SET_DATE}       CONST ACTION_SET_DATE       = 34
NATIVE {ACTION_SAME_LOCK}      CONST ACTION_SAME_LOCK      = 40

NATIVE {ACTION_WRITE} CONST ACTION_WRITE = "W"
NATIVE {ACTION_READ}  CONST ACTION_READ  = "R"

NATIVE {ACTION_SCREEN_MODE}      CONST ACTION_SCREEN_MODE      = 994
NATIVE {ACTION_CHANGE_SIGNAL}    CONST ACTION_CHANGE_SIGNAL    = 995
NATIVE {ACTION_READ_RETURN}     CONST ACTION_READ_RETURN     = 1001
NATIVE {ACTION_WRITE_RETURN}    CONST ACTION_WRITE_RETURN    = 1002
NATIVE {ACTION_FINDUPDATE}      CONST ACTION_FINDUPDATE      = 1004
NATIVE {ACTION_FINDINPUT}       CONST ACTION_FINDINPUT       = 1005
NATIVE {ACTION_FINDOUTPUT}      CONST ACTION_FINDOUTPUT      = 1006
NATIVE {ACTION_END}             CONST ACTION_END             = 1007
NATIVE {ACTION_SEEK}            CONST ACTION_SEEK            = 1008
NATIVE {ACTION_FORMAT}          CONST ACTION_FORMAT          = 1020
NATIVE {ACTION_MAKE_LINK}       CONST ACTION_MAKE_LINK       = 1021
NATIVE {ACTION_SET_FILE_SIZE}   CONST ACTION_SET_FILE_SIZE   = 1022
NATIVE {ACTION_WRITE_PROTECT}   CONST ACTION_WRITE_PROTECT   = 1023
NATIVE {ACTION_READ_LINK}       CONST ACTION_READ_LINK       = 1024
NATIVE {ACTION_FH_FROM_LOCK}    CONST ACTION_FH_FROM_LOCK    = 1026
NATIVE {ACTION_IS_FILESYSTEM}   CONST ACTION_IS_FILESYSTEM   = 1027
NATIVE {ACTION_CHANGE_MODE}     CONST ACTION_CHANGE_MODE     = 1028
NATIVE {ACTION_COPY_DIR_FH}     CONST ACTION_COPY_DIR_FH     = 1030
NATIVE {ACTION_PARENT_FH}       CONST ACTION_PARENT_FH       = 1031
NATIVE {ACTION_EXAMINE_ALL}     CONST ACTION_EXAMINE_ALL     = 1033
NATIVE {ACTION_EXAMINE_FH}      CONST ACTION_EXAMINE_FH      = 1034
NATIVE {ACTION_EXAMINE_ALL_END} CONST ACTION_EXAMINE_ALL_END = 1035
NATIVE {ACTION_SET_OWNER}       CONST ACTION_SET_OWNER       = 1036

NATIVE {ACTION_LOCK_RECORD}   CONST ACTION_LOCK_RECORD   = 2008
NATIVE {ACTION_FREE_RECORD}   CONST ACTION_FREE_RECORD   = 2009

NATIVE {ACTION_ADD_NOTIFY}    CONST ACTION_ADD_NOTIFY    = 4097
NATIVE {ACTION_REMOVE_NOTIFY} CONST ACTION_REMOVE_NOTIFY = 4098

NATIVE {ACTION_SERIALIZE_DISK} CONST ACTION_SERIALIZE_DISK = 4200

/* Structure for easy handling of DosPackets. DosPackets don´t have to be in
   this structure, but this struture may ease the use of it. */
NATIVE {StandardPacket} OBJECT standardpacket
    {sp_Msg}	msg	:mn
    {sp_Pkt}	pkt	:dospacket
ENDOBJECT


/* NOTE: AROS doesn't use startup packets. This will ONLY make a difference
         for shell writers... */

/* Types of command execution */
NATIVE {RUN_EXECUTE}       CONST RUN_EXECUTE       = -1
NATIVE {RUN_SYSTEM}        CONST RUN_SYSTEM        = -2
NATIVE {RUN_SYSTEM_ASYNCH} CONST RUN_SYSTEM_ASYNCH = -3



/* Resident list structure as returned by AddSegment(). */
NATIVE {Segment} OBJECT segment
    {seg_Next}	next	:BPTR    /* Pointer to next segment. */
    {seg_UC}	uc	:VALUE      /* Usage count/type */
    {seg_Seg}	seg	:BPTR     /* Actual Segment */
    {seg_Name}	name[4]	:ARRAY OF UBYTE /* The first characters of the name (BSTR). */
ENDOBJECT

NATIVE {CMD_SYSTEM}	CONST CMD_SYSTEM	= -1
NATIVE {CMD_INTERNAL}	CONST CMD_INTERNAL	= -2
NATIVE {CMD_DISABLED}	CONST CMD_DISABLED	= -999


NATIVE {ErrorString} OBJECT errorstring
    {estr_Nums}	nums	:PTR TO SLONG
    {estr_Strings}	strings	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

/* Return values for ErrorReport(). */
NATIVE {REPORT_STREAM} CONST REPORT_STREAM = 0
NATIVE {REPORT_TASK}   CONST REPORT_TASK   = 1
NATIVE {REPORT_LOCK}   CONST REPORT_LOCK   = 2
NATIVE {REPORT_VOLUME} CONST REPORT_VOLUME = 3
NATIVE {REPORT_INSERT} CONST REPORT_INSERT = 4

NATIVE {ABORT_BUSY}       CONST ABORT_BUSY       = 288
NATIVE {ABORT_DISK_ERROR} CONST ABORT_DISK_ERROR = 296
