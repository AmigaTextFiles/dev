/* $VER: dosextens.h 53.29 (10.8.2015) */
OPT NATIVE
MODULE 'target/exec/tasks', 'target/exec/ports', 'target/exec/libraries', 'target/exec/semaphores', 'target/devices/timer', 'target/intuition/intuition', 'target/dos/dos'
MODULE 'target/exec/lists', 'target/exec/io', 'target/exec/types', 'target/utility/hooks'
{#include <dos/dosextens.h>}
NATIVE {DOS_DOSEXTENS_H} CONST

/* All DOS processes have this structure */

/* Notes for V50 DOS:-
 *
 * BCPL programs are no longer supported from V50 onwards,
 * if a BCPL program is launched, it will halt with a dead-end requester.
 *
 * Old BCPL register values & members marked as "do not access" must NOT be
 * accessed or assumed to contain any values whatsoever, they may even be 
 * intensionally reused in the future for completely incompatible purposes,
 * these are guaranteed to have indeterminant contents that can and will 
 * change without any notice.  So be warned !!!  Leave these alone.
 *
 * Most important: Do not attempt to allocate these structures yourself,
 *                 they are guaranteed to grow and change in the future.
 */

NATIVE {Process} OBJECT process
    /* original definitions from version 1.0 and earlier betas (v30 - 1984) */
    {pr_Task}	task	:tc           /* The exec task structure for this process */
    {pr_MsgPort}	msgport	:mp        /* This process' message port structure */
    {pr_Size}	pad	:UINT           /* Size of struct from V51.08+, previously 0 */
    {pr_SegArray}	seglist	:BPTR       /* -- PRIVATE - BPTR to internal process segarray[]. */
    {pr_StackSize}	stacksize	:ULONG      /* The running process stack size, in bytes */
    {pr_gv}	globvec	:VALUE             /* -- OBSOLETE BCPL value - do not access this. */
    {pr_CliNum}	tasknum	:ULONG         /* CLI number, for DOS allocated cli processes. */
    {pr_sb}	stackbase	:BPTR             /* -- OBSOLETE BCPL value - do not access this. */
    {pr_Result2}	result2	:VALUE        /* Secondary result from last call, for IoErr() */
    {pr_CurrentDir}	currentdir	:BPTR     /* Lock associated with current directory  */
    {pr_CIS}	cis	:BPTR            /* Current CLI Input Stream */
    {pr_COS}	cos	:BPTR            /* Current CLI Output Stream */
    {pr_ConsolePort}	consoletask	:PTR TO mp    /* Console handler port for current window */
    {pr_FileSystemPort}	filesystemtask	:PTR TO mp /* File handler port for current drive */
    {pr_CLI}	cli	:BPTR            /* BCPL Pointer to struct CommandLineInterface */
    {pr_ra}	returnaddr	:APTR             /* -- OBSOLETE - do not access this. */
    {pr_PktWait}	pktwait	:PTR /*APTR          (*pr_PktWait)()*/     /* Function to be called when awaiting packet */
    {pr_WindowPtr}	windowptr	:APTR      /* Window for posting error requesters */

    /* following definitions are new with 2.0 (v36 - 1990) */
    {pr_ProgramDir}	homedir	:BPTR     /* Program's home directory lock */
    {pr_Flags}	flags	:ULONG          /* Flags telling dos about this process */
    {pr_ExitCode}	exitcode	:PTR /*VOID          (*pr_ExitCode)()*/    /* Code to call on exit of process or NULL */
    {pr_ExitData}	exitdata	:VALUE       /* Passed as an argument to pr_ExitCode func. */
    {pr_Arguments}	arguments	:/*STRPTR*/ ARRAY OF CHAR      /* Arguments passed to the process at start */
    {pr_LocalVars}	localvars	:mlh      /* Local environment variables */
    {pr_ShellPrivate}	shellprivate	:ULONG   /* -- PRIVATE - Internal shell use only. */
    {pr_CES}	ces	:BPTR            /* Error stream - if 0, use pr_COS */

    /* following definitions are new from 4.0 (v50 - Apr,2004) */
    {pr_PrData}	prdata	:APTR         /* -- PRIVATE - internal dos access ONLY. */
    {pr_CurrentSeg}	currentseg	:BPTR     /* Seglist of current running code.(READ ONLY) */
    {pr_EmulPrivate}	emulprivate	:ULONG    /* -- PRIVATE - Flags for 68k JIT Emulator. */
    {pr_68kPrivate}	m68kprivate	:ULONG     /* -- PRIVATE - 68K control opts, OS access only */
    {pr_ParentID}	parentid	:ULONG       /* ID# of parent process, 0 if a task. (READ ONLY) */
    {pr_ProcessID}	processid	:ULONG      /* ID# for this process. (READ ONLY) */
    {pr_Reserved4}	reserved4	:ULONG      /* -- reserved for dos expansion - leave alone */
    {pr_OGLContextData}	oglcontextdata	:APTR /* -- PRIVATE - ogl access only. */
    {pr_Reserved5}	reserved5	:APTR      /* -- reserved for dos expansion - leave alone. */
    {pr_CLibData}	clibdata	:APTR       /* -- PRIVATE - clib/newlib use, copied by CNP() */
    {pr_Reserved6}	reserved6	:APTR      /* -- reserved for dos expansion - leave alone  */

    /* following definitions are new from (v51 - Jan,2006) */
    {pr_RestoreList}	restorelist	:mlh    /* -- PRIVATE - used by DOS for process cleanup() */
    {pr_DeathSigTask}	deathsigtask	:APTR   /* Process/task to signal when the process ends */
    {pr_DeathSigBit}	deathsigbit	:ULONG    /* Signal bit number for pr_DeathSigTask */
    {pr_DeathMessage}	deathmessage	:APTR   /* DeathMessage to ReplyMsg() to when process ends */
    {pr_EntryCode}	entrycode	:PTR /*VOID          (*pr_EntryCode)()*/   /* Code to call on startup of process, or NULL   */
    {pr_EntryData}	entrydata	:VALUE      /* Passed as an argument to pr_EntryCode func.   */
    {pr_FinalCode}	finalcode	:PTR /*VOID          (*pr_FinalCode)()*/   /* Code to call on exit of the process, or NULL  */
    {pr_FinalData}	finaldata	:VALUE      /* Passed as an argument to pr_FinalCode func.   */
	{pr_DLNotifyData}	dlnotifydata	:ULONG   /* -- PRIVATE - dos NotifyDosListChange() data.  */
    {pr_PLNotifyData}	plnotifydata	:ULONG   /* -- PRIVATE - dos NotifyProcListChange() data. */

    /* following definitions are new from (v52 - Dec,2006) */
    {pr_UID}	uid	:ULONG            /* -- PRIVATE - dos Set/GetOwnerInfo() use only. */
    {pr_GID}	gid	:ULONG            /* -- PRIVATE - dos Set/GetOwnerInfo() use only. */
    {pr_Reserved3}	reserved3	:VALUE      /* -- reserved for dos expansion - leave alone */
    {pr_Reserved2}	reserved2	:VALUE      /* -- reserved for dos expansion - leave alone */
    {pr_Reserved1}	reserved1	:VALUE      /* -- reserved for dos expansion - leave alone */
    {pr_Reserved0}	reserved0	:VALUE      /* -- reserved for dos expansion - leave alone */
ENDOBJECT
/* Process - 344 bytes */




/*
 * Flags for Process->pr_Flags for all DOS processes.
 * These bits control how the process works and also provide
 * statistical and historical information about the process
 * to allow other subsystems to interact appropriately.
 */
NATIVE {PRB_FREESEGLIST}         CONST PRB_FREESEGLIST         = 0   /* NP_FreeSegList,TRUE sets this bit. */
NATIVE {PRB_FREECURRDIR}         CONST PRB_FREECURRDIR         = 1   /* NP_CurrentDir will be UnLocked if set */
NATIVE {PRB_FREECLI}             CONST PRB_FREECLI             = 2   /* NP_Cli will be freed if this is set. */
NATIVE {PRB_CLOSEINPUT}          CONST PRB_CLOSEINPUT          = 3   /* NP_CloseInput,TRUE sets this bit. */
NATIVE {PRB_CLOSEOUTPUT}         CONST PRB_CLOSEOUTPUT         = 4   /* NP_CloseOutput,TRUE sets this bit.  */
NATIVE {PRB_FREEARGS_OBSOLETE}   CONST PRB_FREEARGS_OBSOLETE   = 5   /* (V50) obsolete, args copy now on task memlist. */
NATIVE {PRB_CLOSEERROR}          CONST PRB_CLOSEERROR          = 6   /* NP_CloseError,TRUE sets this bit. (V51) */
NATIVE {PRB_LOCKSTACK}           CONST PRB_LOCKSTACK           = 7   /* NP_LockStack,TRUE sets this bit. (V52.10) */
NATIVE {PRB_spare08}             CONST PRB_SPARE08             = 8
NATIVE {PRB_spare09}             CONST PRB_SPARE09             = 9
NATIVE {PRB_spare10}            CONST PRB_SPARE10            = 10
NATIVE {PRB_spare11}            CONST PRB_SPARE11            = 11
NATIVE {PRB_spare12}            CONST PRB_SPARE12            = 12
NATIVE {PRB_spare13}            CONST PRB_SPARE13            = 13
NATIVE {PRB_spare14}            CONST PRB_SPARE14            = 14
NATIVE {PRB_spare15}            CONST PRB_SPARE15            = 15

NATIVE {PRB_spare16}            CONST PRB_SPARE16            = 16
NATIVE {PRB_spare17}            CONST PRB_SPARE17            = 17
NATIVE {PRB_spare18}            CONST PRB_SPARE18            = 18
NATIVE {PRB_spare19}            CONST PRB_SPARE19            = 19
NATIVE {PRB_spare20}            CONST PRB_SPARE20            = 20
NATIVE {PRB_spare21}            CONST PRB_SPARE21            = 21
NATIVE {PRB_spare22}            CONST PRB_SPARE22            = 22
NATIVE {PRB_spare23}            CONST PRB_SPARE23            = 23
NATIVE {PRB_CHILDPROCESS}       CONST PRB_CHILDPROCESS       = 24   /* (V50) NP_Child,TRUE sets this for a dependant child. */
NATIVE {PRB_HADCHILDREN}        CONST PRB_HADCHILDREN        = 25   /* (V51) Gets set if this process had created any children. */
NATIVE {PRB_HASDLNOTIFY}        CONST PRB_HASDLNOTIFY        = 26   /* (V51) Set when doslist change signal notify is enabled. */
NATIVE {PRB_HASPLNOTIFY}        CONST PRB_HASPLNOTIFY        = 27   /* (V51) Set when process list change signal notify is on. */
NATIVE {PRB_SERVERPROCESS}      CONST PRB_SERVERPROCESS      = 28   /* (V53) Set when process is one of the internal dos servers */
NATIVE {PRB_HANDLERPROCESS}     CONST PRB_HANDLERPROCESS     = 29   /* (V52) Set to indicate if this is a handler/filesystem process */
NATIVE {PRB_SHELLPROCESS}       CONST PRB_SHELLPROCESS       = 30   /* (V51) Set to indicate if this is a shell handler process */
NATIVE {PRB_EXTENDED_FLAGS}     CONST PRB_EXTENDED_FLAGS     = 31   /* (V51) Reserved for internal dos flags expansion use only. */


/* Mask definitions for above bits */
NATIVE {PRF_FREESEGLIST}        CONST PRF_FREESEGLIST        = (1 SHL PRB_FREESEGLIST)
NATIVE {PRF_FREECURRDIR}        CONST PRF_FREECURRDIR        = (1 SHL PRB_FREECURRDIR)
NATIVE {PRF_FREECLI}            CONST PRF_FREECLI            = (1 SHL PRB_FREECLI)
NATIVE {PRF_CLOSEINPUT}         CONST PRF_CLOSEINPUT         = (1 SHL PRB_CLOSEINPUT)
NATIVE {PRF_CLOSEOUTPUT}        CONST PRF_CLOSEOUTPUT        = (1 SHL PRB_CLOSEOUTPUT)
NATIVE {PRF_FREEARGS_OBSOLETE}  CONST PRF_FREEARGS_OBSOLETE  = (1 SHL PRB_FREEARGS_OBSOLETE)
NATIVE {PRF_CLOSEERROR}         CONST PRF_CLOSEERROR         = (1 SHL PRB_CLOSEERROR)
NATIVE {PRF_LOCKSTACK}          CONST PRF_LOCKSTACK          = (1 SHL PRB_LOCKSTACK)    

NATIVE {PRF_CHILDPROCESS}       CONST PRF_CHILDPROCESS       = (1 SHL PRB_CHILDPROCESS)
NATIVE {PRF_HADCHILDREN}        CONST PRF_HADCHILDREN        = (1 SHL PRB_HADCHILDREN)
NATIVE {PRF_HASDLNOTIFY}        CONST PRF_HASDLNOTIFY        = (1 SHL PRB_HASDLNOTIFY)
NATIVE {PRF_HASPLNOTIFY}        CONST PRF_HASPLNOTIFY        = (1 SHL PRB_HASPLNOTIFY)
NATIVE {PRF_SERVERPROCESS}      CONST PRF_SERVERPROCESS      = (1 SHL PRB_SERVERPROCESS)
NATIVE {PRF_HANDLERPROCESS}     CONST PRF_HANDLERPROCESS     = (1 SHL PRB_HANDLERPROCESS)
NATIVE {PRF_SHELLPROCESS}       CONST PRF_SHELLPROCESS       = (1 SHL PRB_SHELLPROCESS)
NATIVE {PRF_EXTENDED_FLAGS}     CONST PRF_EXTENDED_FLAGS     = (1 SHL PRB_EXTENDED_FLAGS)


/****************************************************************************/
/* The long word address (BPTR) of this structure is returned by
 * Open() and other routines that return a filehandle.
 *
 * This structure is effectively READ-ONLY outside of dos.library & handlers.
 * Do not assume the size of this structure, it will expand at any time.
 * Do not access private members, their function can change at any time.
 * Do not allocate these structures other than through the DOS API,
 *  otherwise they will =NOT= work anymore, as validation data is now present.
 */

NATIVE {FileHandle} OBJECT filehandle
    {fh_StructSize}	structsize	:UINT  /* Size of DOS structure allocation.    */
    {fh_Flags}	flags	:UINT       /* --Private DOS use only.              */

    {fh_Interactive}	interactive	:VALUE /* BOOLEAN; True if interactive handle  */
    {fh_MsgPort}	type	:PTR TO mp     /* MsgPort of the filesystem/handler.   */

    {fh_Buf}	buf	:BPTR         /* --Private Bufferered stream members. */
    {fh_Pos}	pos	:VALUE
    {fh_End}	end	:VALUE

    {fh_Func1}	funcs	:APTR       /* --Private function pointers to the   */
    {fh_Func2}	func2	:APTR       /*   DOS i/o routines.                  */
    {fh_Func3}	func3	:APTR

    {fh_Arg1}	args	:BPTR        /* --Private, packet handler use.       */
    {fh_Arg2}	arg2	:APTR        /* --Private, FSVP handler use.         */

    {fh_OpenerPID}	openerpid	:ULONG   /* The process ID of the opener. V52.16 */

    {fh_Reserved2}	reserved2	:VALUE   /* public expansion, leave alone.       */
    {fh_Reserved1}	reserved1	:VALUE   /* public expansion, leave alone.       */

    {fh_Priv}	priv[18]	:ARRAY OF VALUE    /* --Private, start of the remainder    */
                                    /*   of many more private DOS members.  */
ENDOBJECT 
/* FileHandle - 128 bytes */



/****************************************************************************/
/* This is the standard extension to EXEC Messages used by DOS 
 */

NATIVE {DosPacket} OBJECT dospacket
    {dp_Link}	link	:PTR TO mn    /* EXEC message          */
    {dp_Port}	port	:PTR TO mp    /* Reply port for the packet */
                                /* Must be filled in each send. */
    {dp_Type}	type	:VALUE    /* See ACTION_... below */
    {dp_Res1}	res1	:VALUE    /* For file system calls this is the result
                                   that would have been returned by the
                                   function, e.g. Write() returns actual
                                   length written */
    {dp_Res2}	res2	:VALUE    /* For file system calls, this is what would
                                   have been returned by IoErr() */
    {dp_Arg1}	arg1	:VALUE
    {dp_Arg2}	arg2	:VALUE
    {dp_Arg3}	arg3	:VALUE
    {dp_Arg4}	arg4	:VALUE
    {dp_Arg5}	arg5	:VALUE
    {dp_Arg6}	arg6	:VALUE
    {dp_Arg7}	arg7	:VALUE
ENDOBJECT
/* DosPacket - 48 bytes */

/*  Device packets common equivalents */
NATIVE {dp_Action}   CONST ->DP_ACTION   = dp_Type
NATIVE {dp_Status}   CONST ->DP_STATUS   = dp_Res1
NATIVE {dp_Status2}  CONST ->DP_STATUS2  = dp_Res2
NATIVE {dp_BufAddr}  CONST ->DP_BUFADDR  = dp_Arg1

/* A Packet does not require the Message to be before it in memory,
   but for convenience it is useful to associate the two. */

NATIVE {StandardPacket} OBJECT standardpacket
    {sp_Msg}	msg	:mn
    {sp_Pkt}	pkt	:dospacket
ENDOBJECT

/****************************************************************************/
/* This is the extended 64 bit style EXEC Messages used by DOS.
 * Only dp_Type packets between 8000-8999 range use this structure.
 * NB: #pragma pack() used here to obtain default alignment padding.
 */

NATIVE {DosPacket64} OBJECT dospacket64
    {dp_Link}	link	:PTR TO mn    /* EXEC message                    */
    {dp_Port}	port	:PTR TO mp    /* Reply port for the packet,      */
                                /* must be filled in on each send. */
    {dp_Type}	type	:VALUE    /* See ACTION_... below            */
    {dp_Res0}	res0	:VALUE    /* Special compatibility field. [See below] */

    {dp_Res2}	res2	:VALUE    /* This is returned for IoErr()    */
    {dp_Res1}	res1	:BIGVALUE    /* This is the 64 bit primary result */

    {dp_Arg1}	arg1	:VALUE    /* 32 bit argument */
    {dp_Arg2}	arg2	:BIGVALUE    /* 64 bit argument */
    {dp_Arg3}	arg3	:VALUE    /* 32 bit argument */
    {dp_Arg4}	arg4	:VALUE    /* 32 bit argument */
    {dp_Arg5}	arg5	:BIGVALUE    /* 64 bit argument */
ENDOBJECT
/* DosPacket64 - 64 bytes */

/*--------------------------------------------------------------------------*/
/* NOTE: Old style handlers may not be prepared for this new dospacket,     */
/* so when sending these, dp_Res0 must be initialised to DP64_INIT.         */
/* This is used as a test value to differentiate unsupporting handlers.     */
/* This must be initialised for every send, just like the dp_Port member.   */
/*                                                                          */
/* DosPacket64 supporting handlers must NEVER touch the dp_Res0 member.     */
/*                                                                          */
/* Upon receiving the dospacket back, dp_Res0 MUST still equal DP64_INIT.   */
/* If this packet is returned by a non-supporting handler, this member will */
/* have been overwritten with some other value,  that value will actually   */
/* be the old 32 bit value corresponding to the 32 bit dospackets primary   */
/* result1 code and should be used as such.                                 */
/* dp_Res2 will always be the secondary error code regardless of support.   */
/*                                                                          */
/* The following test is required by the sender for the replied dospacket.  */
/*                                                                          */
/*   if( DP64_INIT == dp->dp_Res0 )                                         */
/*       result1 = dp->dp_Res1;          // supporting handler result.      */
/*   else                                                                   */
/*       result1 = (int64) dp->dp_Res0;  // un-supporting handler result.   */
/*                                                                          */
/*   result2 = dp->dp_Res2;              // always secondary error code.    */
/*--------------------------------------------------------------------------*/

NATIVE {StandardPacket64} OBJECT standardpacket64
    {sp_Msg}	msg	:mn
    {sp_Pkt}	pkt	:dospacket64
ENDOBJECT


/* The DosPacket64 dp_Res0 member initialisation value. */
NATIVE {DP64_INIT}       CONST DP64_INIT       = -3




/****************************************************************************/
/* DEPRECATED PACKET TYPES; these must NOT be supported by new handlers or  */
/* filesystems from DOS release 53.87+  the respective functions are now    */
/* emulated by DOS using the new 3000 series (EXAMINEDATA) and the          */
/* 8000 series (64 BIT) packets and/or vector-port calls,                   */
/* your handler should only support those.                                  */
/*                                                                          */
/* Filesystems and handlers may still get probed by these old packets but   */
/* should only return a primary result of 0 and a secondary result2 value   */
/* set to; ERROR_ACTION_NOT_KNOWN  so the DOS emulator will be invoked.     */
/*                                                                          */
/* For vector-port based filesystems, the DOSPacket emulator vector will    */
/* take care of all deprecated and probe dospackets for you.                */
/*                                                                          */
/* Note: ACTION_SEEK and ACTION_SET_FILE_SIZE will also accept -1 or 0 as   */
/*       the primary result code, providing the secondary result code is    */
/*       set to; ERROR_ACTION_NOT_KNOWN.                                    */
/*                                                                          */
/****************************************************************************/

NATIVE {ACTION_EXAMINE_OBJECT}    CONST ACTION_EXAMINE_OBJECT    = 23    /* DEPRECATED */
NATIVE {ACTION_EXAMINE_NEXT}      CONST ACTION_EXAMINE_NEXT      = 24    /* DEPRECATED */
NATIVE {ACTION_SEEK}            CONST ACTION_SEEK            = 1008    /* DEPRECATED */
NATIVE {ACTION_SET_FILE_SIZE}   CONST ACTION_SET_FILE_SIZE   = 1022    /* DEPRECATED */
NATIVE {ACTION_EXAMINE_ALL}     CONST ACTION_EXAMINE_ALL     = 1033    /* DEPRECATED */
NATIVE {ACTION_EXAMINE_FH}      CONST ACTION_EXAMINE_FH      = 1034    /* DEPRECATED */
NATIVE {ACTION_EXAMINE_ALL_END} CONST ACTION_EXAMINE_ALL_END = 1035    /* DEPRECATED */
NATIVE {ACTION_SET_OWNER}       CONST ACTION_SET_OWNER       = 1036    /* DEPRECATED */



/****************************************************************************/
/* Other Packet types */

NATIVE {ACTION_NIL}                CONST ACTION_NIL                = 0
NATIVE {ACTION_STARTUP}            CONST ACTION_STARTUP            = 0
NATIVE {ACTION_EVENT}              CONST ACTION_EVENT              = 6     /* INTERNAL for CDFS and CrossDos commodity */
NATIVE {ACTION_CURRENT_VOLUME}     CONST ACTION_CURRENT_VOLUME     = 7     /* DEPRECATED from DOS 53.100+ */   
NATIVE {ACTION_LOCATE_OBJECT}      CONST ACTION_LOCATE_OBJECT      = 8
NATIVE {ACTION_RENAME_DISK}        CONST ACTION_RENAME_DISK        = 9
NATIVE {ACTION_FREE_LOCK}         CONST ACTION_FREE_LOCK         = 15
NATIVE {ACTION_DELETE_OBJECT}     CONST ACTION_DELETE_OBJECT     = 16
NATIVE {ACTION_RENAME_OBJECT}     CONST ACTION_RENAME_OBJECT     = 17
NATIVE {ACTION_MORE_CACHE}        CONST ACTION_MORE_CACHE        = 18
NATIVE {ACTION_COPY_LOCK}         CONST ACTION_COPY_LOCK         = 19
NATIVE {ACTION_WAIT_CHAR}         CONST ACTION_WAIT_CHAR         = 20
NATIVE {ACTION_SET_PROTECT}       CONST ACTION_SET_PROTECT       = 21
NATIVE {ACTION_CREATE_DIR}        CONST ACTION_CREATE_DIR        = 22
NATIVE {ACTION_DISK_INFO}         CONST ACTION_DISK_INFO         = 25
NATIVE {ACTION_INFO}              CONST ACTION_INFO              = 26
NATIVE {ACTION_FLUSH}             CONST ACTION_FLUSH             = 27
NATIVE {ACTION_SET_COMMENT}       CONST ACTION_SET_COMMENT       = 28
NATIVE {ACTION_PARENT}            CONST ACTION_PARENT            = 29
NATIVE {ACTION_TIMER}             CONST ACTION_TIMER             = 30     /* INTERNAL */
NATIVE {ACTION_INHIBIT}           CONST ACTION_INHIBIT           = 31

NATIVE {ACTION_SET_DATE}          CONST ACTION_SET_DATE          = 34
NATIVE {ACTION_SAME_LOCK}         CONST ACTION_SAME_LOCK         = 40
NATIVE {ACTION_SAME_FH}           CONST ACTION_SAME_FH           = 53     /* Added 53.71 */

NATIVE {ACTION_READ}              CONST ACTION_READ              = 82     /* 'R' */
NATIVE {ACTION_WRITE}             CONST ACTION_WRITE             = 87     /* 'W' */

NATIVE {ACTION_SINGLE_CHARACTER_MODE}  CONST ACTION_SINGLE_CHARACTER_MODE  = 994
NATIVE {ACTION_CHANGE_SIGNAL}     CONST ACTION_CHANGE_SIGNAL     = 995

/* Internal packets used by con-handler  */
NATIVE {ACTION_READ_RETURN}       CONST ACTION_READ_RETURN       = 1001   /* INTERNAL */
NATIVE {ACTION_WRITE_RETURN}      CONST ACTION_WRITE_RETURN      = 1002   /* INTERNAL */
NATIVE {ACTION_INT_WRITE_RETURN}  CONST ACTION_INT_WRITE_RETURN  = 1003   /* INTERNAL */

NATIVE {ACTION_FINDUPDATE}        CONST ACTION_FINDUPDATE        = 1004   /* aka MODE_READWRITE */
NATIVE {ACTION_FINDINPUT}         CONST ACTION_FINDINPUT         = 1005   /* aka MODE_OLDFILE   */
NATIVE {ACTION_FINDOUTPUT}        CONST ACTION_FINDOUTPUT        = 1006   /* aka MODE_NEWFILE   */
NATIVE {ACTION_END}               CONST ACTION_END               = 1007

NATIVE {ACTION_ICONIFY}           CONST ACTION_ICONIFY           = 1009   /* INTERNAL */

NATIVE {ACTION_FORMAT}            CONST ACTION_FORMAT            = 1020
NATIVE {ACTION_MAKE_LINK}         CONST ACTION_MAKE_LINK         = 1021
NATIVE {ACTION_WRITE_PROTECT}     CONST ACTION_WRITE_PROTECT     = 1023
NATIVE {ACTION_READ_SOFT_LINK}    CONST ACTION_READ_SOFT_LINK    = 1024
NATIVE {ACTION_FH_FROM_LOCK}      CONST ACTION_FH_FROM_LOCK      = 1026
NATIVE {ACTION_IS_FILESYSTEM}     CONST ACTION_IS_FILESYSTEM     = 1027
NATIVE {ACTION_CHANGE_MODE}       CONST ACTION_CHANGE_MODE       = 1028
NATIVE {ACTION_COPY_LOCK_FH}      CONST ACTION_COPY_LOCK_FH      = 1030
NATIVE {ACTION_PARENT_FH}         CONST ACTION_PARENT_FH         = 1031

/* Added V52.18 - SetOwnerInfo() - replaces old SetOwner() packet 1036. */
NATIVE {ACTION_SET_OWNER_INFO}    CONST ACTION_SET_OWNER_INFO    = 1037

/* Internal packets used by datatypes.library */
NATIVE {ACTION_NEWMEMFILE}        CONST ACTION_NEWMEMFILE        = 1039   /* INTERNAL */
NATIVE {ACTION_NEWMEMLOCK}        CONST ACTION_NEWMEMLOCK        = 1040   /* INTERNAL */

/* New packet types for V50 */
NATIVE {ACTION_WAIT_FOR_DATA}     CONST ACTION_WAIT_FOR_DATA     = 1998
NATIVE {ACTION_SET_BLOCKING_MODE} CONST ACTION_SET_BLOCKING_MODE = 1999


/*###########################################################################*/
/*  PACKETS 2050-2999 are reserved for use by third party applications.      */
/*###########################################################################*/


/****************************************************************************/
/* Similar functionality to ACTION_DIE, which was never properly documented.
   This replacement causes supporting filesystems to relinquish all active
   locks to the dos lockhandler process, remove the volume node (if added),
   and then end the filesystem process itself. 
   See; DismountDevice() for extensive information. (V51) */
NATIVE {ACTION_SHUTDOWN}             CONST ACTION_SHUTDOWN             = 3000

/* The following action exclusively controls the relinquishing of active
   filesystem objects to the dos lockhandler, the object identifer value
   (see below) is placed in dp_Arg1, the object is placed in dp_Arg2.
   The dp_Arg2 argument is always an APTR to the object being collected. */
NATIVE {ACTION_COLLECT}              CONST ACTION_COLLECT              = 3001

/* The following are the ACTION_COLLECT object identifiers (in dp_Arg1)
   to identify the object that is placed in dp_Arg2. */
NATIVE {ID_COLLECT_LOCK}                CONST ID_COLLECT_LOCK                = 1
NATIVE {ID_COLLECT_FILEHANDLE}          CONST ID_COLLECT_FILEHANDLE          = 2
NATIVE {ID_COLLECT_NOTIFICATION}        CONST ID_COLLECT_NOTIFICATION        = 3


/****************************************************************************/

/* Obtain or Set filesystem specific attributes; FileSystemAttr()  51.46  */
NATIVE {ACTION_FILESYSTEM_ATTR}        CONST ACTION_FILESYSTEM_ATTR        = 3005

/* Obtain information on a console window; you must pass an APTR to a
   'struct ConsoleWindowData' in dp_Arg1 and sizeof(struct ConsoleWindowData)
   in dp_Arg2; dp_Res1 will indicate success or failure. */
NATIVE {ACTION_OBTAIN_CON_INFO}        CONST ACTION_OBTAIN_CON_INFO        = 3006

/* Release console information, as obtained through ACTION_OBTAIN_CON_INFO;
   you must pass the same parameters as with ACTION_OBTAIN_CON_INFO. */
NATIVE {ACTION_RELEASE_CON_INFO}       CONST ACTION_RELEASE_CON_INFO       = 3007

/* Packets for ExamineObject() and ExamineDir() functions. 51.104 */
NATIVE {ACTION_EXAMINEDATA}            CONST ACTION_EXAMINEDATA            = 3030
NATIVE {ACTION_EXAMINEDATA_FH}         CONST ACTION_EXAMINEDATA_FH         = 3031   /* added @ 52.30 */
NATIVE {ACTION_EXAMINEDATA_DIR}        CONST ACTION_EXAMINEDATA_DIR        = 3040


/* DOS will emulate notifications from 52.33+ if you do not support these */ 
NATIVE {ACTION_ADD_NOTIFY}             CONST ACTION_ADD_NOTIFY             = 4097   /* optional */
NATIVE {ACTION_REMOVE_NOTIFY}          CONST ACTION_REMOVE_NOTIFY          = 4098   /* optional */


/* Tell a file system to serialize the current volume. This is typically
   done by changing the creation date of the disk. This packet does not take
   any arguments.  NOTE: be prepared to handle failure of this packet for
   V37 ROM filesystems. */
NATIVE {ACTION_SERIALIZE_DISK}         CONST ACTION_SERIALIZE_DISK         = 4200


/* Obtain a disk's geometry data (struct FileSysStartupMsg) from a
   file system. This must be released again with ACTION_FREE_DISK_FSSM
   when no longer needed.  (V50: see function GetDiskFileSystemData() ) 
   NOTE: If this packet is unsupported by the handler, DOS will emulate
         this functionality by using startup data from the device node. */
NATIVE {ACTION_GET_DISK_FSSM}          CONST ACTION_GET_DISK_FSSM          = 4201   /* DEPRECATED */

/* Release the disk's geometry data obtained through ACTION_GET_DISK_FSSM.
   (V50: see function FreeDiskFileSystemData() ) */
NATIVE {ACTION_FREE_DISK_FSSM}         CONST ACTION_FREE_DISK_FSSM         = 4202   /* DEPRECATED */


/* New Packet to control dos.library long path handling code. (@ v53.23)
 * This packet has been introduced to be able to formally control the 
 * behaviour of the internal dos.library long path name handling code.
 *
 * When a filesystem or handler responds with DOSTRUE to this query packet,
 * which is only sent when dos.library encounters a long path name string
 * longer than 255 characters, dos.library will inhibit the use of its internal
 * long path handling code and pass the full length string to the handler.
 * This string will likely be in the form of a nul-terminated extended BSTR.
 * ( XBSTR )
 *
 * If your handler is unprepared for extended BSTR's &/or path strings longer
 * than 255 characters, then you must return FALSE to this packet.
 *
 * This packet has no effect on Vector-Port based filesystems.
 */ 
NATIVE {ACTION_INHIBIT_DOS_LONGPATH_HANDLING}   CONST ACTION_INHIBIT_DOS_LONGPATH_HANDLING   = 5323


/****************************************************************************/
/* 64 Bit ACTION types, ONLY the 8000 series use struct DosPacket64.  51.62 */

NATIVE {ACTION_CHANGE_FILE_POSITION64}  CONST ACTION_CHANGE_FILE_POSITION64  = 8001
NATIVE {ACTION_GET_FILE_POSITION64}     CONST ACTION_GET_FILE_POSITION64     = 8002
NATIVE {ACTION_CHANGE_FILE_SIZE64}      CONST ACTION_CHANGE_FILE_SIZE64      = 8003
NATIVE {ACTION_GET_FILE_SIZE64}         CONST ACTION_GET_FILE_SIZE64         = 8004

NATIVE {ACTION_LOCK_RECORD64}           CONST ACTION_LOCK_RECORD64           = 8010   /* added 53.86 */
NATIVE {ACTION_FREE_RECORD64}           CONST ACTION_FREE_RECORD64           = 8011   /* added 53.86 */

/*############################################################################*/
/* 64 bit PACKETS 8500-8999 are reserved for use by third party applications. */
/*############################################################################*/


/****************************************************************************/
/* The following were used to convert UID and GID to names and visa-versa    */

NATIVE {ACTION_USERNAME_TO_UID}   CONST ACTION_USERNAME_TO_UID   = 20000
NATIVE {ACTION_GROUPNAME_TO_GID}  CONST ACTION_GROUPNAME_TO_GID  = 20001
NATIVE {ACTION_UID_TO_USERINFO}   CONST ACTION_UID_TO_USERINFO   = 20002
NATIVE {ACTION_GID_TO_GROUPINFO}  CONST ACTION_GID_TO_GROUPINFO  = 20003







/****************************************************************************/
/* Data structure used by ACTION_OBTAIN_CON_INFO/ACTION_RELEASE_CON_INFO */

NATIVE {ConsoleWindowData} OBJECT consolewindowdata
    {Reserved}	reserved[4]	:ARRAY OF ULONG   /* For use by the console handler */
    {ConsoleWindow}	window	:PTR TO window /* Pointer to console window; this
                                      may be NULL for console handlers
                                      which are not bound to a window,
                                      or if that window is currently
                                      closed. */
    {ConsoleIO}	io	:PTR TO io  /* Pointer to console.device I/O
                                      request; this may be NULL for
                                      console handlers which are not
                                      bound to a window, or if that
                                      window is currently closed. */
    {ConsoleType}	type	:ULONG   /* Identifies the type of console,
                                      e.g. ID_RAWCON or ID_CON */

    {DOSPrivate}	dosprivate[2]	:ARRAY OF APTR /* Private fields for use by DOS only */ 
ENDOBJECT


/****************************************************************************/
/* The following are used by the new V50 Address Tracking functions */

NATIVE {AddressAndSize} OBJECT addressandsize
    {aas_Address}	address	:ULONG
    {aas_Size}	size	:ULONG
ENDOBJECT

NATIVE {FindTrackedAddressMsg} OBJECT findtrackedaddressmsg
    {ftam_Size}	size	:VALUE
    {ftam_Name}	name	:/*STRPTR*/ ARRAY OF CHAR
    {ftam_Date}	date	:datestamp
    {ftam_SegList}	seglist	:BPTR
    {ftam_SegmentNumber}	segmentnumber	:ULONG
    {ftam_SegmentOffset}	segmentoffset	:ULONG
    {ftam_ExtraInfo}	extrainfo	:APTR
    {ftam_ExtraInfoSize}	extrainfosize	:VALUE
/* -- 40 bytes @ V50 */
    {ftam_AAS}	aas	:addressandsize 
/* -- 48 bytes @ 53.118 */
ENDOBJECT


/****************************************************************************/
/* The following is used by the new V50 pattern functions */

NATIVE {CapturedExpression} OBJECT capturedexpression
    {cape_Next}	next	:PTR TO capturedexpression
    {cape_Match}	match	:/*STRPTR*/ ARRAY OF CHAR
    {cape_Start}	start	:/*STRPTR*/ ARRAY OF CHAR
    {cape_End}	end	:/*STRPTR*/ ARRAY OF CHAR
    {cape_Pool}	pool	:APTR   /* private */
ENDOBJECT

/****************************************************************************/
/* The public structure for PseudoSegLists which are used by RunCommand(),
   LoadSeg(), Create[new]Proc(), AllocSegList(), etc..  to handle new formats.
   ==DO NOT== create these yourself if you can call AllocSegList() to do so,
   there are members omitted, like the size member in front,
   however, this structure declaration does provide the required minimum size,
   due to ps_Data[4] being included as part of the public definition.

   WARNING:  Alignment padding may change in future for segment alignments
   greater than 32 bytes, so, at least avoid accessing the ps_Data member
   yourself using this structure definition, instead, call the function;
   IDOS->GetSegListInfoTags(seg,GSLI_Data,...) to obtain a pointer to the data
   area, it would be wise to call it to get any information about a seglist.

   Refer to IDOS->AllocSegList() documentation for further details.
   Refer to IDOS->GetSegListInfo() when accessing information from any seglist.

   Failure to observe this warning can and likely will render your software
   partially or completely non-functional in future DOS releases.
*/

NATIVE {PseudoSegList} OBJECT pseudoseglist
    {ps_Next}	next	:BPTR       /* BPTR   - Pointer to next segment. Or 0.       */
    {ps_Jump}	jump	:ULONG       /* uint32 - Internal compatibility magic.        */
    {ps_Entry}	entry	:APTR      /* APTR   - The function entry pointer.          */
    {ps_Ikey}	ikey	:ULONG       /* uint32 - Identification key.                  */
    {ps_DosPrivate}	dosprivate	:ULONG /* uint32 - DOS Private use only.                */
    {ps_Reserved1}	reserved1	:ULONG  /* uint32 - Block alignment - reserved.          */
    {ps_Reserved2}	reserved2	:ULONG  /* uint32 - Block alignment - reserved.          */
    {ps_Data}	data[4]	:ARRAY OF UBYTE    /* uint8  - First 4 bytes of data area.          */
ENDOBJECT


/* This value is always initialised in the ps_Jump member. (PPC & 68K)      */

NATIVE {PSJUMP_MAGIC}	 CONST PSJUMP_MAGIC	 = $4e714ef9	/* NOP,JMP - 68k compatibility      */



/* These are the currently used values for use in the ps_Ikey member.       */

NATIVE {PSIKEY_INIT}      CONST PSIKEY_INIT      = 0
    /* Set this value for normal native, data or 68k types.                 */
    /* UnLoadSeg() will perform the normal memory freeing on these.         */

NATIVE {PSIKEY_NOFREE}    CONST PSIKEY_NOFREE    = $80000000
    /* Set this value if your seglist must not be UnLoadSeg()'ed.           */
    /* Not for internal components, see PSIKEY_NFSYS below.                 */

NATIVE {PSIKEY_ELF32}     CONST PSIKEY_ELF32     = $7F454C46        /* 7F 'E' 'L' 'F'              */
    /* This is set EXCLUSIVELY by LoadSeg() for ELF32 executables.          */

NATIVE {PSIKEY_NFSYS}     CONST PSIKEY_NFSYS     = $FFFFFFFF
    /* This is set EXCLUSIVELY by internal system components such as        */
    /* filesystems that create a device segment by hand,                    */
    /* usually before DOS is available, these segments reside in the        */
    /* data area of loaded modules and must not be freed if they            */
    /* happen to be inadvertently passed to UnLoadSeg().                    */
    /*                                                                      */
    /* A hand-made PPC segment MUST have at least the following members     */
    /* initialised as shown, to be recognised by DOS.                       */
    /*                                                                      */
    /*     SegSize >= sizeof(struct PseudoSegList);  //@ -4 offset          */
    /*     ps_Next  = 0;                             //@  0 offset          */
    /*     ps_Jump  = PSJUMP_MAGIC;                  //@ +4 offset          */
    /*     ps_Entry = ((*)());     //Address of the executable code.        */
    /*     ps_Ikey  = PSIKEY_NFSYS;                                         */
    /*     ps_DosPrivate =0;                                                */
    /*     ps_Reserved1  =0;                                                */
    /*     ps_Reserved2  =0;                                                */
    /*                                                                      */
    /* NB: The segment MUST start on a longword multiple address as         */
    /*     it will be converted to a BCPL pointer. (BPTR).                  */
    /*                                                                      */
    /*     Only single segments are allowed to be created this way.         */
    /*                                                                      */
    /*     The 'SegSize' value MUST also be a longword multiple.            */
    /*                                                                      */
    /*     The SegSize MUST also represent the actual byte size of          */
    /*     the whole memory space that incorporates the fake segment.       */
    /*     This value is used for segment scanning purposes and must        */
    /*     include all space that may be used to contain a resident         */
    /*     structure or a nul-terminated version string which is to be      */
    /*     formatted as;   "$VER: name ver.rev (dd.mm.yyyy)\r\n\0"          */
    /*     or any other data that needs to be included in the segment.      */
    /*     See also; dos/AllocSegList() for more information.               */


/****************************************************************************/
/* A structure ONLY for the Dos resident list.  Do NOT allocate these,
   use AddSegment() and heed the warnings in the autodocs! 
 
   For legacy reasons, the name array is formatted in the old style BCPL format,
   that being the first byte holds the strlen() of the following bytes,
   it also has a nul-terminator byte so as to be interoperable with C-Strings.
*/

NATIVE {DosResidentSeg} OBJECT segment
    {seg_Next}	next	:BPTR     /* BCPL pointer to next DosResidentSeg, or zero */
    {seg_UC}	uc	:VALUE       /* Use Count */
    {seg_Seg}	seg	:BPTR      /* BCPL pointer to seglist of command. */
    {seg_Name}	name[4]	:ARRAY OF /*TEXT*/ CHAR  /* First 4 chars of BCPL style formatted name */
ENDOBJECT

NATIVE {CMD_SYSTEM}      CONST CMD_SYSTEM      = -1
NATIVE {CMD_INTERNAL}    CONST CMD_INTERNAL    = -2
NATIVE {CMD_DISABLED}    CONST CMD_DISABLED    = -999


/****************************************************************************/
/* DOS Processes started from the CLI via RUN or NEWCLI have this additional
   set of data associated with them */

NATIVE {CommandLineInterface} OBJECT commandlineinterface
    {cli_Result2}	result2	:VALUE        /* Value of IoErr from last command          */
    {cli_CurrentDirName}	setname	:BSTR /* BSTR name of current directory            */
    {cli_PathList}	commanddir	:BPTR       /* BPTR to the first 'struct PathNode'       */
    {cli_ReturnCode}	returncode	:VALUE     /* Return code from last command             */
    {cli_CommandName}	commandname	:BSTR    /* BSTR name of current command              */
    {cli_FailLevel}	faillevel	:VALUE      /* Fail level (set by FAILAT)                */
    {cli_Prompt}	prompt	:BSTR         /* BSTR prompt string (set by PROMPT)        */
    {cli_StandardInput}	standardinput	:BPTR  /* Default (terminal) CLI input stream       */
    {cli_CurrentInput}	currentinput	:BPTR   /* Current CLI input stream                  */
    {cli_CommandFile}	commandfile	:BSTR    /* BSTR name of EXECUTE command file         */
    {cli_Interactive}	interactive	:VALUE    /* Boolean; Truth if prompts required        */
    {cli_RunBackground}	background	:VALUE  /* Boolean; Truth if CLI created by 'RUN'    */
    {cli_CurrentOutput}	currentoutput	:BPTR  /* Current CLI output                        */
    {cli_DefaultStack}	defaultstack	:ULONG   /* Stack size to be obtained in long words   */
    {cli_StandardOutput}	standardoutput	:BPTR /* Default (terminal) CLI output             */
    {cli_Module}	module	:BPTR         /* SegList of currently loaded command       */
ENDOBJECT

NATIVE {cli_Background}  CONST ->CLI_BACKGROUND  = cli_RunBackground   /* synonym */




/****************************************************************************/
/* DosList structures can take on different values depending on whether it 
   is a device, an assignment, or a volume.  Below is the structure
   reflecting volumes only, following that is the structure representing
   only devices, following that is the structure for assignments, 
   then following that is the unioned structure representing all types. */


NATIVE {VolumeNode} OBJECT volumenode
    {vn_Next}	next	:BPTR        /* BPTR to next entry in the chain     */
    {vn_Type}	type	:VALUE        /* always DLT_VOLUME for dos "volumes" */
    {vn_Port}	port	:PTR TO mp        /* msg port for the handler process    */
    {vn_Reserved2}	reserved2	:VALUE   /* reserved for use by DOS             */
    {vn_VolumeDate}	volumedate	:datestamp  /* creation date                       */
    {vn_LockList}	locklist	:BPTR    /* unused, leave as 0                  */
    {vn_DOSType}	dostype	:VALUE     /* ie; 'DOS\7' - 32 bit hex dostype    */
    {vn_FSPrivate}	fsprivate	:VALUE   /* private filesystem use              */
    {vn_Name}	name	:BSTR        /* bstr name                           */
    {vn_StructSize}	structsize	:VALUE  /* FULL size of this structure         */
    {vn_Reserved}	reserved[4]	:ARRAY OF VALUE /* DOS expansion                       */
ENDOBJECT

NATIVE {vn_DiskType}  CONST ->VN_DISKTYPE  = vn_DOSType  /* synonym */

/****************************************************************************/


NATIVE {DeviceNode} OBJECT devicenode
    {dn_Next}	next	:BPTR        /* BPTR to next entry in the chain     */
    {dn_Type}	type	:VALUE        /* always DLT_DEVICE for dos "devices" */
    {dn_Port}	port	:PTR TO mp        /* msg port to the handler process.    */
    {dn_Reserved1}	reserved1	:VALUE   /* reserved for use by DOS             */
    {dn_Handler}	handler	:BSTR     /* BSTR name to loadseg if seglist==0  */
    {dn_StackSize}	stacksize	:VALUE   /* stacksize for the handler process   */
    {dn_Priority}	priority	:VALUE    /* task priority when starting task    */
    {dn_Startup}	startup	:BPTR     /* startup msg / FileSysStartupMsg     */
    {dn_SegList}	seglist	:BPTR     /* code to run handler process.        */
                                     /* if 0 then dn_Handler will be loaded */
    {dn_GlobVec}	globvec	:VALUE     /* Global vector locking method key to */
                                     /* use when starting the handler proc. */
                                     /* A value of -1 is used for standard  */
                                     /* C startup locking method.           */
                                     /* Only values -1 & -2 are valid now.  */
    {dn_Name}	name	:BSTR        /* BSTR device node name.              */
    {dn_StructSize}	structsize	:VALUE  /* FULL size of this structure.        */
    {dn_Reserved}	reserved[4]	:ARRAY OF VALUE /* DOS expansion space.                */
ENDOBJECT



/****************************************************************************/


NATIVE {MultiAssign} OBJECT assignlist
    {ma_Next}	next	:PTR TO assignlist    /* next MultiAssign in chain, or NULL */
    {dat.ma_lock}	lock	:BPTR    /*  for DLT_LOCK multi-assigns */
    {dat.ma_name}	name	:/*STRPTR*/ ARRAY OF CHAR    /*  for DLT_NONBINDING multi-assigns (v54) */
ENDOBJECT

/* Shortcut for union reference */
NATIVE {ma_Lock}   CONST ->MA_LOCK   = dat.ma_lock
NATIVE {ma_Name}   CONST ->MA_NAME   = dat.ma_name



NATIVE {AssignNode} OBJECT assignnode
    {an_Next}	next	:BPTR              /* BPTR to next entry in the chain */
    {an_Type}	type	:VALUE              /* DLT_LOCK,DLT_LATE,DLT_NONBINDING */
    {an_Port}	port	:PTR TO mp              /* Ptr to handler process port for DLT_LOCK types. */
    {an_Lock}	lock	:BPTR              /* Primary lock for DLT_LOCK assignments */
    {an_AssignName}	assignname	:/*STRPTR*/ ARRAY OF CHAR        /* Primary name for non or late-binding assigns */
    {an_MultiAssignList}	multiassignlist	:PTR TO assignlist   /* Chain of DLT_LOCK multi-assigns */
    {an_NBMultiAssignList}	nbmultiassignlist	:PTR TO assignlist /* Chain of DLT_NONBINDING multi-assigns */
    {an_Unused}	unused[3]	:ARRAY OF VALUE         /* not currently used, leave as 0  */
    {an_Name}	name	:BSTR              /* BSTR assignment node name       */
    {an_StructSize}	structsize	:VALUE        /* FULL allocated size of this structure. */
    {an_Reserved}	reserved[4]	:ARRAY OF VALUE       /* DOS reserved expansion space.   */
ENDOBJECT



/****************************************************************************/


NATIVE {DosList} OBJECT doslist
    {dol_Next}	next	:BPTR     /* BPTR to next entry in the chain */
    {dol_Type}	type	:VALUE     /* See DLT below */
    {dol_Port}	task	:PTR TO mp     /* Ptr to handler process port */

    {dol_misc.dol_device.dol_Handler}	handler	:BSTR      /* BSTR file name to LoadSeg if dol_Seglist==0.*/
    {dol_misc.dol_device.dol_StackSize}	stacksize	:VALUE    /* Stacksize to use when starting process.     */
    {dol_misc.dol_device.dol_Priority}	priority	:VALUE     /* Task priority when starting process.        */
    {dol_misc.dol_device.dol_Startup}	startup	:BPTR      /* Startup msg: FileSysStartupMsg for disks.   */
    {dol_misc.dol_device.dol_SegList}	seglist	:BPTR      /* Already loaded seglist for new process.     */
    {dol_misc.dol_device.dol_GlobVec}	globvec	:VALUE      /* Global vector locking method key (-1 or -2) */

    {dol_misc.dol_volume.dol_VolumeDate}	volumedate	:datestamp   /* Creation date.                  */
    {dol_misc.dol_volume.dol_LockList}	locklist	:BPTR     /* Unused, leave as 0                        */
    {dol_misc.dol_volume.dol_DOSType}	disktype	:VALUE      /* 'DOS\0' - 32 bit hex identity             */

    {dol_misc.dol_assign.dol_Lock}	lock	:BPTR         /* Used by DLT_LOCK assign type only.        */
    {dol_misc.dol_assign.dol_AssignName}	assignname	:/*STRPTR*/ ARRAY OF CHAR   /* CSTR name for non-or-late-binding assign  */
    {dol_misc.dol_assign.dol_MultiAssignList}	list	:PTR TO assignlist   /* Chain of DLT_LOCK multi-assigns */
    {dol_misc.dol_assign.dol_NBMultiAssignList}	nblist	:PTR TO assignlist /* Chain of DLT_NONBINDING multi-assigns (V54) */

    {dol_Name}	name	:BSTR         /* BSTR formatted name string */
    {dol_StructSize}	structsize	:VALUE   /* (See NOTES) FULL allocated size of struct */
ENDOBJECT


/*  NOTES: Please note that it is now required that you reflect the full size
 *         of any custom struct in the dol_StructSize member to allow new planned
 *         features to work.   This is initialised automatically when using the
 *         DOS AllocDosObject() and MakeDosEntry() functions from V52.16+
 */


NATIVE {dol_handler}   CONST
NATIVE {dol_DiskType}  CONST

/****************************************************************************/
/* definitions for dl_Type */

NATIVE {DLT_DEVICE}       CONST DLT_DEVICE       = 0
NATIVE {DLT_LOCK}         CONST DLT_LOCK         = 1     /* normal assign */
NATIVE {DLT_VOLUME}       CONST DLT_VOLUME       = 2
NATIVE {DLT_LATE}         CONST DLT_LATE         = 3     /* late-binding assign */
NATIVE {DLT_NONBINDING}   CONST DLT_NONBINDING   = 4     /* non-binding assign */
NATIVE {DLT_PRIVATE}     CONST DLT_PRIVATE     = -1     /* for internal dos use only */


/****************************************************************************/
/* Flags for Doslist functions */

NATIVE {LDB_READ}         CONST LDB_READ         = 0
NATIVE {LDB_WRITE}        CONST LDB_WRITE        = 1
NATIVE {LDB_DEVICES}      CONST LDB_DEVICES      = 2
NATIVE {LDB_VOLUMES}      CONST LDB_VOLUMES      = 3
NATIVE {LDB_ASSIGNS}      CONST LDB_ASSIGNS      = 4
NATIVE {LDB_ENTRY}        CONST LDB_ENTRY        = 5
NATIVE {LDB_DELETE}       CONST LDB_DELETE       = 6

/* You MUST specify one of LDF_READ or LDF_WRITE */
NATIVE {LDF_READ}        CONST LDF_READ        = (1 SHL LDB_READ)
NATIVE {LDF_WRITE}       CONST LDF_WRITE       = (1 SHL LDB_WRITE)

/* Flags to be passed to LockDosList(), etc */
NATIVE {LDF_DEVICES}     CONST LDF_DEVICES     = (1 SHL LDB_DEVICES)
NATIVE {LDF_VOLUMES}     CONST LDF_VOLUMES     = (1 SHL LDB_VOLUMES)
NATIVE {LDF_ASSIGNS}     CONST LDF_ASSIGNS     = (1 SHL LDB_ASSIGNS)
NATIVE {LDF_ENTRY}       CONST LDF_ENTRY       = (1 SHL LDB_ENTRY)       /* internal */
NATIVE {LDF_DELETE}      CONST LDF_DELETE      = (1 SHL LDB_DELETE)      /* internal */

/* Actually all but the internal locking flags */
NATIVE {LDF_ALL}         CONST LDF_ALL         = (LDF_DEVICES OR LDF_VOLUMES OR LDF_ASSIGNS)

/****************************************************************************/
/* Mode types for NonBlockingModifyDosEntry()   (v51.30) */

NATIVE {NBM_ADDDOSENTRY}        CONST NBM_ADDDOSENTRY        = 1 SHL 0
NATIVE {NBM_REMDOSENTRY}        CONST NBM_REMDOSENTRY        = 1 SHL 1
NATIVE {NBM_RENAMEDOSENTRY}     CONST NBM_RENAMEDOSENTRY     = 1 SHL 2
NATIVE {NBM_CHANGESIGNAL}       CONST NBM_CHANGESIGNAL       = 1 SHL 3
NATIVE {NBM_REMFREEDOSENTRY}    CONST NBM_REMFREEDOSENTRY    = 1 SHL 4  /* added 53.67 */
NATIVE {NBM_DISKINSERTED}       CONST NBM_DISKINSERTED       = 1 SHL 5  /* added 53.73 */
NATIVE {NBM_DISKREMOVED}        CONST NBM_DISKREMOVED        = 1 SHL 6  /* added 53.73 */


/****************************************************************************/
/* A filesystem lock structure, as returned by Lock(), DupLock(), etc...    */
/* Most of this structure is private to the filesystem and dos.library.     */
/*                                                                          */
/* DO NOT ACCESS PRIVATE FIELDS - They may not even be used for the         */
/* purpose indicated by the labelled name or type declaration.              */
/****************************************************************************/

NATIVE {Lock} OBJECT filelock
    {fl_Link}	link	:BPTR          /* PRIVATE - filesystem use only.    */
    {fl_Key}	key	:VALUE           /* PRIVATE - filesystem use only.    */
    {fl_Access}	access	:VALUE        /* PRIVATE - filesystem use only.    */

    {fl_Port}	task	:PTR TO mp          /* Handler process message port      */
    {fl_Volume}	volume	:BPTR        /* BPTR to DLT_VOLUME DosList entry  */

                                       /* -- V51 additions -- */
    {fl_FSPrivate1}	fsprivate1	:APTR    /* PRIVATE - filesystem use only.    */
    {fl_FSPrivate2}	fsprivate2	:APTR    /* PRIVATE - filesystem use only.    */

    {fl_DOSType}	dostype	:ULONG       /* The DOSType of the filesystem,    */
                                       /*  initialised by AllocDosObject(). */
    {fl_StructSize}	structsize	:ULONG    /* Full DOS allocated struct size,   */
                                       /*  initialised by AllocDosObject(). */

                                       /* -- V53 additions -- */
    {fl_DosPrivate}	dosprivate	:VALUE    /* PRIVATE - dos library use only.   */
    {fl_Reserved}	reserved[2]	:ARRAY OF VALUE   /* RESERVED for expansion. V53       */
ENDOBJECT
/* Filesystem private data usually extends past the end of this definition. */




/****************************************************************************/
/* The Public structure return by GetDeviceProc(), GetDeviceProcFlags()  */

NATIVE {DevProc} OBJECT devproc
    {dvp_Port}	port	:PTR TO mp         /* Handler message port     */
    {dvp_Lock}	lock	:BPTR         /* Reference lock (or ZERO) */
    {dvp_Flags}	flags	:ULONG        /* Flags fields.            */
ENDOBJECT
/* DOS private data extends past the end of this definition. */



/* Definitions for DevProc->dvp_Flags;  */

NATIVE {DVPB_UNLOCK}         CONST DVPB_UNLOCK         = 0    
  /* For DOS internal use. 
   * This currently means the lock is temporary and will be unlocked
   * on the next call to GetDeviceProcFlags() or FreeDeviceProc().
   * This is generally used for resolving assignments.
   */

NATIVE {DVPB_MULTIASSIGN}    CONST DVPB_MULTIASSIGN    = 1
  /* The Lock refers to part of a multi-assignment, this flag bit indicates
   * there are more entries of a multi-directory assignment to come.
   * ie; The last part of a multi-assignment will have this cleared.
   * ( Note: This used to be called just DVPB_ASSIGN.)
   */

/*
 * The following flags were added at V53.56 to provide additional
 * functionality for LockTags() and other internal subsystems. 
 */

NATIVE {DVPB_DEVICE}         CONST DVPB_DEVICE         = 16
  /* The supplied path is a device relative specification. */
 
NATIVE {DVPB_VOLUME}         CONST DVPB_VOLUME         = 17
  /* The supplied path is a volume relative specification. */
 
NATIVE {DVPB_ASSIGNMENT}     CONST DVPB_ASSIGNMENT     = 18
  /* The supplied path is an assignment relative specification. */
 
NATIVE {DVPB_PROGDIR}        CONST DVPB_PROGDIR        = 19
  /* The supplied path is a PROGDIR: relative specification. */
 
NATIVE {DVPB_CURRDIR}        CONST DVPB_CURRDIR        = 20
  /* The supplied path is a CURRDIR: relative specification. */

NATIVE {DVPB_ROOTDIR}        CONST DVPB_ROOTDIR        = 21
  /* The supplied path is a root directory relative specification. */

NATIVE {DVPB_CONSOLE}        CONST DVPB_CONSOLE        = 23
  /* The supplied path is a CONSOLE: handler specification. */

NATIVE {DVPB_FILESYS}        CONST DVPB_FILESYS        = 24
  /* The supplied path returned the root of the default filesystem. */


/* Field definitions for above bits */ 
NATIVE {DVPF_UNLOCK}         CONST DVPF_UNLOCK         = (1 SHL DVPB_UNLOCK)
NATIVE {DVPF_MULTIASSIGN}    CONST DVPF_MULTIASSIGN    = (1 SHL DVPB_MULTIASSIGN)
NATIVE {DVPF_DEVICE}         CONST DVPF_DEVICE         = (1 SHL DVPB_DEVICE)
NATIVE {DVPF_VOLUME}         CONST DVPF_VOLUME         = (1 SHL DVPB_VOLUME)
NATIVE {DVPF_ASSIGNMENT}     CONST DVPF_ASSIGNMENT     = (1 SHL DVPB_ASSIGNMENT)
NATIVE {DVPF_PROGDIR}        CONST DVPF_PROGDIR        = (1 SHL DVPB_PROGDIR)
NATIVE {DVPF_CURRDIR}        CONST DVPF_CURRDIR        = (1 SHL DVPB_CURRDIR)
NATIVE {DVPF_ROOTDIR}        CONST DVPF_ROOTDIR        = (1 SHL DVPB_ROOTDIR)
NATIVE {DVPF_CONSOLE}        CONST DVPF_CONSOLE        = (1 SHL DVPB_CONSOLE)
NATIVE {DVPF_FILESYS}        CONST DVPF_FILESYS        = (1 SHL DVPB_FILESYS)


/****************************************************************************/
/* Error report types for ErrorReport() */

NATIVE {REPORT_STREAM}        CONST REPORT_STREAM        = 0    /* a stream */
NATIVE {REPORT_TASK}          CONST REPORT_TASK          = 1    /* a process - currently unused */
NATIVE {REPORT_LOCK}          CONST REPORT_LOCK          = 2    /* a lock */
NATIVE {REPORT_VOLUME}        CONST REPORT_VOLUME        = 3    /* a volume node */
NATIVE {REPORT_INSERT}        CONST REPORT_INSERT        = 4    /* "please insert volume..." */

/* Special error codes for ErrorReport() */
NATIVE {ABORT_DISK_ERROR}    CONST ABORT_DISK_ERROR    = 296   /* Read/write error */
NATIVE {ABORT_BUSY}          CONST ABORT_BUSY          = 288   /* "You MUST replace..." */

/****************************************************************************/
/* Types for initial packets to shells from run/newcli/execute/system.
   For shell-writers only */

NATIVE {RUN_EXECUTE}          CONST RUN_EXECUTE          = -1
NATIVE {RUN_SYSTEM}           CONST RUN_SYSTEM           = -2
NATIVE {RUN_SYSTEM_ASYNCH}    CONST RUN_SYSTEM_ASYNCH    = -3


/****************************************************************************/
/* PRIVATE: THE FOLLOWING IS EXCLUSIVELY DOS & FILESYSTEM USE ONLY - SERIOUSLY !
 *
 * Application code is NOT permitted to access any members of this structure.
 * Application code MUST consider that this structure does not actually exist. 
 *
 * If you can't think of a way for your application to avoid accessing any of
 * these structure members, think again, and then think again some more.
 * If you still find yourself at an impasse, read the relevant autodocs again
 * and finally contact developer support for help, if all else fails.
 *
 * The most asked question to date is;
 *  
 * (Q) How do I access the reference directory lock without peeking in here. ? 
 * (A) Set EX_DoCurrentDir,TRUE in ObtainDirContext() and call GetCurrentDir().
 *     Refer to ObtainDirContext() autodoc for detailed information.
 *
 */

NATIVE {PRIVATE_ExamineDirContext} OBJECT private_examinedircontext
    {StructSize}	structsize	:ULONG
    {FreshNodeList}	freshnodelist	:mlh
    {StaleNodeList}	stalenodelist	:mlh
    {DataRequestFlags}	datarequestflags	:ULONG
    {ReferenceLock}	referencelock	:PTR TO filelock
    {MessagePort}	messageport	:PTR TO mp
    {MemoryPool}	memorypool	:APTR

    {DOSPrivateCD}	dosprivatecd	:BPTR
    {DOSPrivateLock}	dosprivatelock	:BPTR
    {DOSPrivateName}	dosprivatename	:/*STRPTR*/ ARRAY OF CHAR
    {DOSPrivateResult2}	dosprivateresult2	:VALUE
    {DOSPrivateFallback}	dosprivatefallback	:APTR
    {DOSPrivateMatchFunc}	dosprivatematchfunc	:PTR TO hook
    {DOSPrivateMatchString}	dosprivatematchstring	:/*STRPTR*/ ARRAY OF CHAR

    {FSPrivateMemPtr}	fsprivatememptr	:APTR
    {FSPrivate}	fsprivate[8]	:ARRAY OF ULONG
ENDOBJECT
/* 108 bytes - v51.104 */
