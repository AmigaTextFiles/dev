/* $VER: obsolete.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/dos/dos', 'target/dos/anchorpath'
MODULE 'target/dos/dosextens', 'target/dos/filehandler', 'target/dos/dostags', 'target/exec/types', 'target/exec/ports'
{
#include <dos/obsolete.h>
#undef dol_Lock
}
NATIVE {DOS_OBSOLETE_H} CONST

/****************************************************************************/
/* Sundry obsolete definitions for old source code compatibility */

NATIVE {MAXINT}               CONST MAXINT = MAXINT32
NATIVE {MININT}               CONST MININT = MININT32

NATIVE {pr_TaskNum}           DEF
NATIVE {pr_OGLContextPtr}     DEF
NATIVE {pr_ConsoleTask}       DEF
NATIVE {pr_FileSystemTask}    DEF
NATIVE {pr_HomeDir}           DEF
NATIVE {pr_ProgDir}           DEF

NATIVE {fh_Port}              DEF
NATIVE {fh_Type}              DEF
NATIVE {fh_Args}              DEF

NATIVE {dl_Task}              DEF
NATIVE {dl_unused}            DEF

NATIVE {dvi_Task}             DEF

NATIVE {dn_Task}              DEF
NATIVE {dn_GlobalVec}         DEF

NATIVE {dol_Task}             DEF
NATIVE {dol_List}             DEF
NATIVE {dol_Lock}             DEF

NATIVE {AssignList}           OBJECT
NATIVE {al_Next}              DEF
NATIVE {al_Lock}              DEF

NATIVE {Segment}              OBJECT

NATIVE {cli_CommandDir}       DEF
NATIVE {cli_SetName}          DEF

NATIVE {DLT_DIRECTORY}        CONST

NATIVE {fl_Task}              DEF
NATIVE {FileLock}             DEF

NATIVE {DVPB_ASSIGN}          CONST
NATIVE {DVPF_ASSIGN}          CONST

NATIVE {DOSPrivateStatus}     DEF
NATIVE {PacketPort}           DEF

NATIVE {EXF_USE}              CONST

NATIVE {OWNER_ROOT}           CONST
NATIVE {OWNER_NONE}           CONST

NATIVE {LOCK_SAME_HANDLER}    CONST LOCK_SAME_HANDLER    = LOCK_SAME_VOLUME

NATIVE {DOS_FILELOCK}         CONST DOS_FILELOCK         = DOS_LOCK

NATIVE {OFFSET_BEGINING}      CONST OFFSET_BEGINING      = OFFSET_BEGINNING

NATIVE {ID_WRITE_PROTECTED}   CONST ID_WRITE_PROTECTED   = ID_DISKSTATE_WRITE_PROTECTED
NATIVE {ID_VALIDATING}        CONST ID_VALIDATING        = ID_DISKSTATE_VALIDATING
NATIVE {ID_VALIDATED}         CONST ID_VALIDATED         = ID_DISKSTATE_VALIDATED

/* Semantical name changes in DosEnvec */
NATIVE {DE_SIZEBLOCK}          CONST DE_SIZEBLOCK          = DE_SECSIZE
NATIVE {de_SizeBlock}         DEF
 
NATIVE {DE_BLKSPERTRACK}      CONST DE_BLKSPERTRACK      = DE_SECSPERTRACK    
NATIVE {de_BlocksPerTrack}    DEF

NATIVE {DE_MEMBUFTYPE}        CONST DE_MEMBUFTYPE        = DE_BUFMEMTYPE



/* Early function source name change quick fix. */
NATIVE {FSReadLink}           DEF

NATIVE {ftam_Segment}         DEF


/* Obsolete when APPDIR: became a real filesystem in 53.134+ */
NATIVE {DVPB_APPDIR}          CONST
NATIVE {DVPF_APPDIR}         CONST
NATIVE {LOCKB_APPDIR}         CONST
NATIVE {LOCKF_APPDIR}        CONST


/*
** Finally redefine the name to reflect the exact function 
** of these particular contradictory protection bits. 
*/
NATIVE {EXDB_READ}            CONST
NATIVE {EXDB_WRITE}           CONST
NATIVE {EXDB_EXECUTE}         CONST
NATIVE {EXDB_DELETE}          CONST

NATIVE {EXDF_READ}            CONST
NATIVE {EXDF_WRITE}           CONST
NATIVE {EXDF_EXECUTE}         CONST
NATIVE {EXDF_DELETE}          CONST



/*********************/
/* Renamed functions */

/* this was changed in V50 */
NATIVE {Flush} PROC	->Flush(x)                     FFlush(x) 

/* these were changed in V53 */
NATIVE {SetPrompt} PROC	->SetPrompt(x)                 SetCliPrompt(x)
NATIVE {GetPrompt} PROC	->GetPrompt(x,y)               GetCliPrompt(x,y)

NATIVE {SetCurrentDirName} PROC	->SetCurrentDirName(x)         SetCliCurrentDirName(x)
NATIVE {GetCurrentDirName} PROC	->GetCurrentDirName(x,y)       GetCliCurrentDirName(x,y)

NATIVE {SetProgramName} PROC	->SetProgramName(x)            SetCliProgramName(x)
NATIVE {GetProgramName} PROC	->GetProgramName(x,y)          GetCliProgramName(x,y)

NATIVE {DeleteFile} PROC	->DeleteFile(x)                Delete(x)
NATIVE {SetFileDate} PROC	->SetFileDate(x,y)             SetDate(x,y)

NATIVE {ReadLink} PROC	->ReadLink(p,k,a,b,bs)         ReadSoftLink(p,k,a,b,bs)




/*********************/
/* Obsolete tags     */

NATIVE {ADO_FH_Mode}      CONST ADO_FH_MODE      = (ADO_DUMMY + 1)        /* obsolete V50 */
NATIVE {ADO_DirLen}       CONST ADO_DIRLEN       = (ADO_DUMMY + 2)        /* obsolete V50 */
NATIVE {ADO_CommNameLen}  CONST ADO_COMMNAMELEN  = (ADO_DUMMY + 3)        /* obsolete V50 */
NATIVE {ADO_CommFileLen}  CONST ADO_COMMFILELEN  = (ADO_DUMMY + 4)        /* obsolete V50 */
NATIVE {ADO_PromptLen}    CONST ADO_PROMPTLEN    = (ADO_DUMMY + 5)        /* obsolete V50 */

NATIVE {NP_ProgDir}        CONST NP_PROGDIR        = NP_PROGRAMDIR
NATIVE {NP_HomeDir}        CONST NP_HOMEDIR        = NP_PROGRAMDIR




/*********************/
/* Obsolete macros   */

/* 
**  This assumes a BCPL pointer always has the two most significant bits cleared.
**  Unfortunately, this will only be true with 32 bit addressing.
*/
NATIVE {IS_VALID_BPTR} CONST	->IS_VALID_BPTR(bptr)   ((((uint32)(bptr)) & 0xC0000000) == 0)
PROC is_valid_bptr(x:PTR) IS NATIVE {IS_VALID_BPTR(} x {)} ENDNATIVE !!BOOL








/****************************************************************************/
/* Obsolete structure definition,  although called a "devicelist" it was    */
/* actually used only for volume nodes, how quaint !.                       */

NATIVE {DeviceList} OBJECT devlist
    {dl_Next}	next	:BPTR        /* bptr to next device list */
    {dl_Type}	type	:VALUE        /* see DLT below */
    {dl_Port}	task	:PTR TO mp        /* ptr to handler task */
    {dl_Lock}	lock	:BPTR        /* not for volumes */
    {dl_VolumeDate}	volumedate	:datestamp  /* creation date */
    {dl_LockList}	locklist	:BPTR    /* outstanding locks */
    {dl_DiskType}	disktype	:VALUE    /* 'DOS', etc */
    {dl_FSPrivate}	unused	:VALUE   /* private filesystem use */
    {dl_Name}	name	:BSTR        /* bptr to bstr name */
    {dl_Reserved}	dl_reserved[5]	:ARRAY OF VALUE /* DOS expansion added, V51.24   */
ENDOBJECT



/****************************************************************************/
/* Obsolete device structure definition,  this structure has identical      */
/* members to a struct DeviceNode that used to be found in filehandler.h.   */
/* Moved this one here because it was pointless having two definitions.     */

NATIVE {DevInfo} OBJECT devinfo
    {dvi_Next}	next	:BPTR        /* Singly linked list, next entry.                  */
    {dvi_Type}	type	:VALUE        /* Always DLT_DEVICE [0] for dos "devices".         */
    {dvi_Port}	task	:APTR        /* Standard dos msgport. If this is NULL when -     */
                          /* - the node is accesses, a task will be     -     */
                          /* - started up automatically.                      */
    {dvi_Lock}	lock	:BPTR        /* Not used for devices, leave as 0.                */
    {dvi_Handler}	handler	:BSTR     /* BPTR to BSTR Filename to loadseg() if seglist=0  */
    {dvi_StackSize}	stacksize	:VALUE   /* Initial stacksize used when starting up.         */
    {dvi_Priority}	priority	:VALUE    /* The task priority when starting task.            */
    {dvi_Startup}	startup	:VALUE     /* Startup msg: FileSystemStartupMsg for disks.     */
    {dvi_SegList}	seglist	:BPTR     /* Code to run when starting new task. or 0.        */
    {dvi_GlobVec}	globvec	:BPTR     /* Obsolete BCPL global vector to use when starting */
                          /* - a task. -1 or -2 means that dn_SegList is not  */
                          /* - for a bcpl program, these are the only values  */
                          /* - supported for V50 DOS.  Other values may cause */
                          /* - notifiable failure.                            */
    {dvi_Name}	name	:BSTR        /* BPTR to BSTR node name, e.g;  '\3','D','F','3'   */
    {dvi_StructSize}	structsize	:VALUE
    {dvi_Reserved}	reserved[4]	:ARRAY OF VALUE /* DOS expansion space added, V51.24                */
ENDOBJECT



/****************************************************************************/
/* Old struct for the OBSOLETELockRecords()/OBSOLETEUnLockRecords()         */
/* Do NOT use this with the new functions, it is here only for the DOS      */
/* fallback code to reference.                                              */

NATIVE {RecordLock32} OBJECT recordlock32
    {rec_FH}	fh	:BPTR         /* filehandle */
    {rec_Offset}	offset	:ULONG     /* 32 bit offset in file */
    {rec_Length}	length	:ULONG     /* 32 bit length of file to be locked */
    {rec_Mode}	mode	:ULONG       /* Type of lock */
ENDOBJECT





/****************************************************************************/
/* FIB stands for FileInfoBlock - these are obsolete definitions.           */

/* FIBB are bit definitions, FIBF are field definitions */
/* Regular RWED bits are 0 == allowed. */
/* NOTE: GRP and OTR RWED permissions are 0 == not allowed! */
/* Group and Other permissions are not directly handled by the filesystem */

NATIVE {FIBB_OTR_READ}         CONST FIBB_OTR_READ         = 15    /* Other: file is readable */
NATIVE {FIBB_OTR_WRITE}        CONST FIBB_OTR_WRITE        = 14    /* Other: file is writable */
NATIVE {FIBB_OTR_EXECUTE}      CONST FIBB_OTR_EXECUTE      = 13    /* Other: file is executable */
NATIVE {FIBB_OTR_DELETE}       CONST FIBB_OTR_DELETE       = 12    /* Other: prevent file from being deleted */
NATIVE {FIBB_GRP_READ}         CONST FIBB_GRP_READ         = 11    /* Group: file is readable */
NATIVE {FIBB_GRP_WRITE}        CONST FIBB_GRP_WRITE        = 10    /* Group: file is writable */
NATIVE {FIBB_GRP_EXECUTE}       CONST FIBB_GRP_EXECUTE       = 9    /* Group: file is executable */
NATIVE {FIBB_GRP_DELETE}        CONST FIBB_GRP_DELETE        = 8    /* Group: prevent file from being deleted */

NATIVE {FIBB_HOLD}              CONST FIBB_HOLD              = 7    /* (V50) hold loaded program in cli resident list */ 
NATIVE {FIBB_SCRIPT}            CONST FIBB_SCRIPT            = 6    /* program is a script (execute) file */
NATIVE {FIBB_PURE}              CONST FIBB_PURE              = 5    /* program is reentrant and rexecutable */
NATIVE {FIBB_ARCHIVE}           CONST FIBB_ARCHIVE           = 4    /* cleared whenever file is changed */
NATIVE {FIBB_READ}              CONST FIBB_READ              = 3    /* ignored by old filesystem */
NATIVE {FIBB_WRITE}             CONST FIBB_WRITE             = 2    /* ignored by old filesystem */
NATIVE {FIBB_EXECUTE}           CONST FIBB_EXECUTE           = 1    /* ignored by system, used by Shell */
NATIVE {FIBB_DELETE}            CONST FIBB_DELETE            = 0    /* prevent file from being deleted */

NATIVE {FIBF_OTR_READ}         CONST FIBF_OTR_READ         = (1 SHL FIBB_OTR_READ)
NATIVE {FIBF_OTR_WRITE}        CONST FIBF_OTR_WRITE        = (1 SHL FIBB_OTR_WRITE)
NATIVE {FIBF_OTR_EXECUTE}      CONST FIBF_OTR_EXECUTE      = (1 SHL FIBB_OTR_EXECUTE)
NATIVE {FIBF_OTR_DELETE}       CONST FIBF_OTR_DELETE       = (1 SHL FIBB_OTR_DELETE)
NATIVE {FIBF_GRP_READ}         CONST FIBF_GRP_READ         = (1 SHL FIBB_GRP_READ)
NATIVE {FIBF_GRP_WRITE}        CONST FIBF_GRP_WRITE        = (1 SHL FIBB_GRP_WRITE)
NATIVE {FIBF_GRP_EXECUTE}      CONST FIBF_GRP_EXECUTE      = (1 SHL FIBB_GRP_EXECUTE)
NATIVE {FIBF_GRP_DELETE}       CONST FIBF_GRP_DELETE       = (1 SHL FIBB_GRP_DELETE)

NATIVE {FIBF_HOLD}             CONST FIBF_HOLD             = (1 SHL FIBB_HOLD)
NATIVE {FIBF_SCRIPT}           CONST FIBF_SCRIPT           = (1 SHL FIBB_SCRIPT)
NATIVE {FIBF_PURE}             CONST FIBF_PURE             = (1 SHL FIBB_PURE)
NATIVE {FIBF_ARCHIVE}          CONST FIBF_ARCHIVE          = (1 SHL FIBB_ARCHIVE)
NATIVE {FIBF_READ}             CONST FIBF_READ             = (1 SHL FIBB_READ)
NATIVE {FIBF_WRITE}            CONST FIBF_WRITE            = (1 SHL FIBB_WRITE)
NATIVE {FIBF_EXECUTE}          CONST FIBF_EXECUTE          = (1 SHL FIBB_EXECUTE)
NATIVE {FIBF_DELETE}           CONST FIBF_DELETE           = (1 SHL FIBB_DELETE)

/****************************************************************************/
/* Obsolete types for fib_DirEntryType. NOTE that both USERDIR and ROOT are
 * directories, and that directory/file checks should use the macros below.
 */

NATIVE {ST_ROOT}         CONST ST_ROOT         = 1
NATIVE {ST_USERDIR}      CONST ST_USERDIR      = 2
NATIVE {ST_SOFTLINK}     CONST ST_SOFTLINK     = 3    /* looks like dir, but may point to a file! */
NATIVE {ST_LINKDIR}      CONST ST_LINKDIR      = 4    /* hard link to dir */
NATIVE {ST_FILE}        CONST ST_FILE        = -3    /* must be negative for FIB! */
NATIVE {ST_LINKFILE}    CONST ST_LINKFILE    = -4    /* hard link to file */
NATIVE {ST_PIPEFILE}    CONST ST_PIPEFILE    = -5    /* for pipes that support ExamineFH */

/****************************************************************************/
/* Obsolete macros for checking what kind of object a FileInfoBlock
 * describes; Examine() / ExNext().
 * Special versions of these  macros for ExAll() are available 
 * in the include file;  dos/exall.h 
 */

NATIVE {FIB_IS_FILE} CONST	->FIB_IS_FILE(fib)      ((fib)->fib_DirEntryType <  0)

NATIVE {FIB_IS_DRAWER} CONST	->FIB_IS_DRAWER(fib)    ((fib)->fib_DirEntryType >= 0 && (fib)->fib_DirEntryType != ST_SOFTLINK)

NATIVE {FIB_IS_LINK} CONST	->FIB_IS_LINK(fib)      ((fib)->fib_DirEntryType == ST_SOFTLINK || (fib)->fib_DirEntryType == ST_LINKDIR || (fib)->fib_DirEntryType == ST_LINKFILE)

NATIVE {FIB_IS_SOFTLINK} CONST	->FIB_IS_SOFTLINK(fib)  ((fib)->fib_DirEntryType == ST_SOFTLINK)

NATIVE {FIB_IS_LINKDIR} CONST	->FIB_IS_LINKDIR(fib)   ((fib)->fib_DirEntryType == ST_LINKDIR)
