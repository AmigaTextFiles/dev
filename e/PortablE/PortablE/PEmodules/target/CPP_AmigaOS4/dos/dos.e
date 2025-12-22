/* $VER: dos.h 53.29 (10.8.2015) */
OPT NATIVE, PREPROCESS, POINTER
MODULE 'target/exec/types', 'target/exec/ports', 'target/dos/errors'
MODULE 'target/exec/nodes'
PUBLIC MODULE 'target/dos/dos_shared', 'target/dos/errors'
{#include <dos/dos.h>}
NATIVE {DOS_DOS_H} CONST

TYPE BPTR IS NATIVE {BPTR} PTR
TYPE BSTR IS NATIVE {BSTR} ARRAY


NATIVE {DOSNAME} CONST
#define DOSNAME dosname
STATIC dosname = 'dos.library'

/****************************************************************************/
/* These are the return codes used by convention by AmigaDOS commands.      */
/* See FAILAT and IF commands for relevance to EXECUTE files.               */
/* See RunCommand() and CreateNewProc() for relevance to all DOS processes. */

NATIVE {RETURN_OK}      CONST RETURN_OK      = 0  /* No problems, success */
NATIVE {RETURN_WARN}    CONST RETURN_WARN    = 5  /* A warning only, ie; for the shell 'IF' command */
NATIVE {RETURN_ERROR}  CONST RETURN_ERROR  = 10  /* Something caused a normal sort of error */
NATIVE {RETURN_FAIL}   CONST RETURN_FAIL   = 20  /* Severe failure, ie; missing system library */


/****************************************************************************/
/* Predefined Amiga DOS global constants */

NATIVE {DOSTRUE}        CONST DOSTRUE        = (-1)
NATIVE {DOSFALSE}       CONST DOSFALSE       = (0)

NATIVE {BITSPERBYTE}     CONST BITSPERBYTE     = 8
NATIVE {BYTESPERLONG}    CONST BYTESPERLONG    = 4
NATIVE {BITSPERLONG}     CONST BITSPERLONG     = 32
NATIVE {MAXINT32}        CONST MAXINT32        = $7FFFFFFF
NATIVE {MININT32}        CONST MININT32        = $80000000


/****************************************************************************/
/* All BCPL data must be long word aligned.  BCPL pointers are the long word
 * address (i.e byte address divided by 4 (>>2)) 
 */

NATIVE {BPTR} CONST /* Long word (BCPL) pointer */
NATIVE {BSTR} CONST /* Long word pointer to BCPL string */

/* BCPL style 'NULL' */
NATIVE {ZERO}         CONST ZERO         = NIL !!VALUE!!BPTR

/* Convert BPTR to typical C pointer */
NATIVE {BADDR} CONST	->BADDR(x)     ((APTR)((uint32)(x) << 2))
#define BADDR(x) Baddr(x)
PROC Baddr(x:BPTR) IS NATIVE {BADDR(} x {)} ENDNATIVE !!PTR

/* Convert address into a BPTR */
NATIVE {MKBADDR} CONST	->MKBADDR(x)   ((BPTR)(((uint32)(x)) >> 2))
#define MKBADDR(x) Mkbaddr(x)
PROC Mkbaddr(x:PTR) IS NATIVE {MKBADDR(} x {)} ENDNATIVE !!BPTR

/*
 * README -- LEGACY BCPL STRINGS (BSTR):  
 * 
 * BSTR's are the BCPL address of a string that has the length in the
 * first byte with the actual string bytes following.  
 * For example, with the original BCPL implementation, the string "SYS"
 * was formatted as: s[0]=3  s[1]='S'  s[2]='Y'  s[3]='S'
 *
 * From V48+, BCPL strings MUST also have a '\0' nul-terminator byte
 * on the end, for safe interoperability with C-strings.
 * The additional nul-terminator byte is not counted in the length byte,
 * neither is the length byte itself.  For example, the same "SYS" string
 * shall now be formatted as: s[0]=3  s[1]='S'  s[2]='Y'  s[3]='S'  s[4]=0
 *
 * DOS library now provides functions to handle these correctly.
 *     IDOS->CopyStringCToBSTR() and IDOS->CopyStringBSTRToC(). 
 */

/****************************************************************************/
/* Mode parameter to Open(), all files are positioned at beginning of file. */

NATIVE {MODE_OLDFILE}        CONST MODE_OLDFILE        = 1005    /* Open existing file for read/write,
                                       fails if file doesn't exist. */

NATIVE {MODE_NEWFILE}        CONST MODE_NEWFILE        = 1006    /* Open freshly created file, read/write,
                                       deletes an old file, exclusive lock. */

NATIVE {MODE_READWRITE}      CONST MODE_READWRITE      = 1004    /* Open old file, shared lock, read/write,
                                       creates file if it doesn't exist. */

/****************************************************************************/
/* Relative position to Seek(deprecated) and ChangeFilePosition()  */

NATIVE {OFFSET_BEGINNING}     CONST OFFSET_BEGINNING     = -1     /* relative to Begining Of File */
NATIVE {OFFSET_CURRENT}        CONST OFFSET_CURRENT        = 0     /* relative to Current file position */
NATIVE {OFFSET_END}            CONST OFFSET_END            = 1     /* relative to End Of File      */


/****************************************************************************/
/* Passed as 'accessMode' to Lock() */

NATIVE {SHARED_LOCK}     CONST SHARED_LOCK     = -2    /* Object is accessible by all others */
NATIVE {ACCESS_READ}     CONST ACCESS_READ     = -2    /* Somewhat misleading old synonym */

NATIVE {EXCLUSIVE_LOCK}  CONST EXCLUSIVE_LOCK  = -1    /* No other access is allowed */
NATIVE {ACCESS_WRITE}    CONST ACCESS_WRITE    = -1    /* Somewhat misleading old synonym */

/****************************************************************************/
/* Flags for the bitmasks returned by LockTags() when using LK_InfoMask tag.*/
/* These provide detailed information on the string being resolved.  V53.57 */

NATIVE {LOCKB_SOFTLINK_MIDPART}   CONST LOCKB_SOFTLINK_MIDPART   = 8  
  /* One or more soft links were found in the middle of the path */
  /* but none of these formed the last component of the path.    */

NATIVE {LOCKB_SOFTLINK_ENDPART}   CONST LOCKB_SOFTLINK_ENDPART   = 9
  /* One soft link exists as the last component of the path. */
 
NATIVE {LOCKB_DEVICE}            CONST LOCKB_DEVICE            = 16
  /* The supplied path is a device relative specification. */
 
NATIVE {LOCKB_VOLUME}            CONST LOCKB_VOLUME            = 17
  /* The supplied path is a volume relative specification. */
 
NATIVE {LOCKB_ASSIGNMENT}        CONST LOCKB_ASSIGNMENT        = 18
  /* The supplied path is an assignment relative specification. */
 
NATIVE {LOCKB_PROGDIR}           CONST LOCKB_PROGDIR           = 19
  /* The supplied path is a PROGDIR: relative specification. */
 
NATIVE {LOCKB_CURRDIR}           CONST LOCKB_CURRDIR           = 20
  /* The supplied path is a CURRDIR: relative specification. */

NATIVE {LOCKB_ROOTDIR}           CONST LOCKB_ROOTDIR           = 21
  /* The supplied path is a root directory relative specification. */

NATIVE {LOCKB_FILESYS}           CONST LOCKB_FILESYS           = 24
  /* The supplied path returned the root of the default filesystem. */

/* Field definitions of the above. */
NATIVE {LOCKF_SOFTLINK_MIDPART}    CONST LOCKF_SOFTLINK_MIDPART    = (1 SHL LOCKB_SOFTLINK_MIDPART)  
NATIVE {LOCKF_SOFTLINK_ENDPART}    CONST LOCKF_SOFTLINK_ENDPART    = (1 SHL LOCKB_SOFTLINK_ENDPART)
NATIVE {LOCKF_DEVICE}              CONST LOCKF_DEVICE              = (1 SHL LOCKB_DEVICE)
NATIVE {LOCKF_VOLUME}              CONST LOCKF_VOLUME              = (1 SHL LOCKB_VOLUME)
NATIVE {LOCKF_ASSIGNMENT}          CONST LOCKF_ASSIGNMENT          = (1 SHL LOCKB_ASSIGNMENT)
NATIVE {LOCKF_PROGDIR}             CONST LOCKF_PROGDIR             = (1 SHL LOCKB_PROGDIR)
NATIVE {LOCKF_CURRDIR}             CONST LOCKF_CURRDIR             = (1 SHL LOCKB_CURRDIR)
NATIVE {LOCKF_ROOTDIR}             CONST LOCKF_ROOTDIR             = (1 SHL LOCKB_ROOTDIR)
NATIVE {LOCKF_FILESYS}             CONST LOCKF_FILESYS             = (1 SHL LOCKB_FILESYS)

/****************************************************************************/
/* Result flags for WaitForData(). */

NATIVE {WFDB_READ}     CONST WFDB_READ     = 0  /* Stream has data ready to be read */
NATIVE {WFDB_WRITE}    CONST WFDB_WRITE    = 1  /* Stream is ready to accept more data to be written.*/

NATIVE {WFDF_READ}    CONST WFDF_READ    = (1 SHL WFDB_READ)
NATIVE {WFDF_WRITE}   CONST WFDF_WRITE   = (1 SHL WFDB_WRITE)

/****************************************************************************/
/* NotifyProcListChange(), NotifyDosListChange(), termination signal value. */

NATIVE {NPLC_END}     CONST NPLC_END     = $FFFFFFFF
NATIVE {NDLC_END}     CONST NDLC_END     = $FFFFFFFF

/****************************************************************************/
/* SetBlockingMode() mode values which define whether read/write access to a
   stream will block until a request is satisfied or will return immediately.*/

NATIVE {SBM_BLOCKING}        CONST SBM_BLOCKING        = 1
NATIVE {SBM_NON_BLOCKING}    CONST SBM_NON_BLOCKING    = 2

/****************************************************************************/
/* GetPID() function, this flag determins which PID is returned.     53.58  */

NATIVE {GPID_PROCESS}      CONST GPID_PROCESS      = 1
NATIVE {GPID_PARENT}       CONST GPID_PARENT       = 2

/****************************************************************************/
/* Length constants specifically for new vector-port based filesystems.     */
/* Older packet filesystem designs may not support these lengths,           */
/* so use IDOS->FileSystemAttr() to find out filesystem specific values.    */

NATIVE {MAX_VP_FILENAME}   CONST MAX_VP_FILENAME   = 255

NATIVE {MAX_VP_COMMENT}    CONST MAX_VP_COMMENT    = 255

NATIVE {MAX_VP_SOFTLINK_TARGET}   CONST MAX_VP_SOFTLINK_TARGET   = 4000

/****************************************************************************/

->"OBJECT datestamp" is on-purposely missing from here (it can be found in 'dos/dos_shared')

NATIVE {TICKS_PER_SECOND} CONST TICKS_PER_SECOND = 50    /* Fifty ticks = one second  */
                               /* One tick = twenty milliseconds */

/****************************************************************************/
/* V52 Struct ExamineData, returned by ExamineObject() and ExamineDir().
 * This structure supports unlimited string lengths, 64 bit file sizes,
 * automatic resolution of link targets and extended auxilliary information.
 *
 * NOTE; Applications DO NOT allocate these, the filesystem does it.
 *       Also, the filesystem itself must always allocate these using
 *       AllocDosObject(), otherwise they will simply not work.
 */ 

NATIVE {ExamineData} OBJECT examinedata 
    {EXDnode}	mln	:mln      /* MinList node.                           */
    {EXDinfo}	exdinfo	:ULONG      /* General purpose user data.              */

    /* These are private members exclusively for the FS & DOS.                */
    {FSPrivate}	fsprivate	:ULONG    /* FILESYSTEM ONLY - Private usage.        */
    {Reserved0}	reserved0	:ULONG    /* DOS RESERVED - Private usage.           */
    {DOSPrivate}	dosprivate	:APTR   /* DOSLIB ONLY - Private usage.            */
                                   /*                                         */
    /* The following are public fields.                                       */
    {StructSize}	structsize	:ULONG   /* (RO) Full size of the structure.        */
    {Type}	type	:ULONG         /* Entry type; use EXD_IS_ macros below.   */
    {FileSize}	filesize	:BIGVALUE     /* Size of a file, otherwise set to -1LL.  */
    {Date}	date	:datestamp         /* Days, Mins, Ticks.                      */
    {RefCount}	refcount	:ULONG     /* Object hardlink references.    [Note 1] */
    {ObjectID}	objectid	:UBIGVALUE     /* Unique object identifier.      [Note 2] */
    {Name}	name	:/*STRPTR*/ ARRAY OF CHAR         /* (RO) Nul-terminated object name.        */
    {NameSize}	namesize	:ULONG     /* (RO) Allocated size of the name buffer. */
    {Comment}	comment	:/*STRPTR*/ ARRAY OF CHAR      /* (RO) Nul-terminated comment string.     */
    {CommentSize}	commentsize	:ULONG  /* (RO) Allocated size of comment buffer.  */
    {Link}	link	:/*STRPTR*/ ARRAY OF CHAR         /* (RO) Nul-terminated target name string. */
    {LinkSize}	linksize	:ULONG     /* (RO) Allocated size of target buffer.   */
    {Protection}	protection	:ULONG   /* Protection status bitmask.              */
    {OwnerUID}	owneruid	:ULONG     /* Owner info. [Note 3]                    */
    {OwnerGID}	ownergid	:ULONG     /* Group info. [Note 3]                    */
    {Reserved2}	reserved2	:ULONG    /* DOS reserved field.                     */
    {Reserved3}	reserved3	:ULONG    /* DOS reserved field.                     */
    {Reserved4}	reserved4	:ULONG    /* DOS reserved field.                     */
ENDOBJECT
/*	(RO) = Read Only, these fields must not be modified by the application.   */

/*
 * [Note 1] If possible, this field should be supported by filesystems that
 *          support hardlinks, it is used to indicate the hardlink reference
 *          count for objects.  A value of one indicates that the object has
 *          no additional references other than itself, a value of two will
 *          indicate that it has one additional hardlink reference,
 *          a value of three means it has two hardlink references, etc...
 *          All hardlinks themselves always show a value of 1 in this field
 *          when supported, otherwise this field MUST be set to zero for
 *          all objects, if the filesystem does not support it.
 *          It will be undefined if the caller fails to specify the
 *          EXF_REFCOUNT bit in the EX_DataFields mask.
 *
 * [Note 2] This field is the mandatory unique object identfier for all
 *          objects on this volume, the value used here may be any arbitrary
 *          value as long as it is unique from all other objects on this
 *          volume, it may use the object node address, the disk header block
 *          number or other such values. (Note: this field is 64 bits wide.)
 *          This field will be undefined if you fail to specify the
 *          EXF_OBJECTID bit in the EX_DataFields mask.
 *
 * [Note 3] Historically, these fields only used the low 16 bits.
 *          For extensibility, the size of these are now 32 bit fields.
 *          However, for interoperability, it is recommended that values
 *          greater than 65535 be avoided where possible so reading only
 *          the low 16 bits results in the same value for legacy applications.
 *          These fields will be undefined if you fail to specify the
 *          EXF_OWNER bit in the EX_DataFields mask.
 *          (See extended information relating to the UID/GID fields below.)
 */

/****************************************************************************/
/* Bit mask field values that are passed in the EX_DataFields tag,
 * this determines what data is returned from the ExamineDir() function.
 *
 * The data value returned in the respective fields will be undefined if
 * the mask bit is not specified, NEVER assume otherwise.
 */

NATIVE {EXF_DATE}           CONST EXF_DATE           = 1 SHL 0
NATIVE {EXF_REFCOUNT}       CONST EXF_REFCOUNT       = 1 SHL 1
NATIVE {EXF_NAME}           CONST EXF_NAME           = 1 SHL 2
NATIVE {EXF_COMMENT}        CONST EXF_COMMENT        = 1 SHL 3
NATIVE {EXF_LINK}           CONST EXF_LINK           = 1 SHL 4
NATIVE {EXF_PROTECTION}     CONST EXF_PROTECTION     = 1 SHL 5
NATIVE {EXF_OWNER}          CONST EXF_OWNER          = 1 SHL 6   /* both Group and User ID */
NATIVE {EXF_TYPE}           CONST EXF_TYPE           = 1 SHL 7   /* MUST be specified for EXD_IS macros */
NATIVE {EXF_SIZE}           CONST EXF_SIZE           = 1 SHL 8
NATIVE {EXF_OBJECTID}       CONST EXF_OBJECTID       = 1 SHL 9

NATIVE {EXF_spare1}         CONST EXF_SPARE1         = 1 SHL 10  /* reserved for future EXF_ALL feature */
NATIVE {EXF_spare2}         CONST EXF_SPARE2         = 1 SHL 11  /* reserved for future EXF_ALL feature */
NATIVE {EXF_spare3}         CONST EXF_SPARE3         = 1 SHL 12  /* reserved for future EXF_ALL feature */
NATIVE {EXF_spare4}         CONST EXF_SPARE4         = 1 SHL 13  /* reserved for future EXF_ALL feature */
NATIVE {EXF_spare5}         CONST EXF_SPARE5         = 1 SHL 14  /* reserved for future EXF_ALL feature */
NATIVE {EXF_spare6}         CONST EXF_SPARE6         = 1 SHL 15  /* reserved for future EXF_ALL feature */

NATIVE {EXF_ALL}			CONST EXF_ALL			= ($FFFF) /* Return all of the information above */


 
/****************************************************************************/
/* Values for ExamineData->Type for checking what kind of object it describes. 
 * The lower 8 bits form the unique descriptor value, the upper bits are used 
 * as a bitmask. The FSO_TYPE_MASK is used to filter the descriptor value. 
 *
 * NOTE: You MUST specify EXF_TYPE in the EX_DataFields tag for these macros
 *       to work otherwise random values will be returned in the 'Type' field.
 */

NATIVE {FSO_TYPE_MASK}        CONST FSO_TYPE_MASK        = $FF  /* mask for object type descriptors */

NATIVE {FSO_TYPE_SOFTLINK}    CONST FSO_TYPE_SOFTLINK    = 0     /* Object is a softlink */
NATIVE {FSO_TYPE_FILE}        CONST FSO_TYPE_FILE        = 1     /* Object is a file */
NATIVE {FSO_TYPE_DIRECTORY}   CONST FSO_TYPE_DIRECTORY   = 2     /* Object is a directory */
NATIVE {FSO_TYPE_PIPE}        CONST FSO_TYPE_PIPE        = 3     /* Object is a pipe stream */
NATIVE {FSO_TYPE_SOCKET}      CONST FSO_TYPE_SOCKET      = 4     /* Object is a socket stream */

NATIVE {FSO_TYPE_INVALID}     CONST FSO_TYPE_INVALID     = $FE  /* Object is unidentifiable or corrupt,
                                      you SHOULD never actually see this,
                                      but the value is reserved here for use by 
                                      the handler AND DOS to indicate internal errors.
                                      You MAY also possibly see this value if one
                                      were to read the 'Type' member without
                                      setting the EXF_TYPE bit in EX_DataFields. */


NATIVE {FSOF_LINK}           CONST FSOF_LINK           = 1 SHL 8 /* Bit set for FFS style hard & soft links */

NATIVE {FSOF_ALTLINK}        CONST FSOF_ALTLINK        = 1 SHL 9 /* Reserved bit for alternate style links, */
                                   /* - these are currently unimplemented. */


/*
**  DEVELOPERS PLEASE NOTE;
**  Examinedata->Type values 0xD0...0xEF are reserved for exclusive private use
**  for handlers, these values are guaranteed to never be allocated for any
**  purpose by DOS, these values shall also never be returned to DOS. 
*/


/****************************************************************************/
/* Macros for identifying what kind of basic object an ExamineData 'Type' describes. 
 * NOTE: These macros mask out the link attribute bits, so CHECK FOR LINKS FIRST.
 */

/* Standard objects */
NATIVE {EXD_IS_FILE} CONST	->EXD_IS_FILE(exd)        (((exd)->Type & FSO_TYPE_MASK) == FSO_TYPE_FILE)
NATIVE {EXD_IS_DIRECTORY} CONST	->EXD_IS_DIRECTORY(exd)   (((exd)->Type & FSO_TYPE_MASK) == FSO_TYPE_DIRECTORY)
NATIVE {EXD_IS_PIPE} CONST	->EXD_IS_PIPE(exd)        (((exd)->Type & FSO_TYPE_MASK) == FSO_TYPE_PIPE)
NATIVE {EXD_IS_SOCKET} CONST	->EXD_IS_SOCKET(exd)      (((exd)->Type & FSO_TYPE_MASK) == FSO_TYPE_SOCKET)

/*
 * FFS style hard and soft links always set the FSOF_LINK bit.
 * Future Non-FFS style compatible links shall use the FSOF_ALTLINK bit.
 */

/* Generic macro for identifying ALL types of linked objects. (including softlinks) */
NATIVE {EXD_IS_LINK} CONST	->EXD_IS_LINK(exd)          ((exd)->Type & (FSOF_LINK|FSOF_ALTLINK))

/* Specific macro for identifying a softlink. */
NATIVE {EXD_IS_SOFTLINK} CONST	->EXD_IS_SOFTLINK(exd)      ((exd)->Type == (FSOF_LINK|FSO_TYPE_SOFTLINK))



/****************************************************************************
 * Information relating to the ExamineData; OwnerUID and OwnerGID members.
 *  
 * AmigaDOS permissions are NOT the same as the standard UNIX values.
 * For the DOS/Filesystem UID/GID values;
 *
 *     [nobody/nogroup] = 0       (instead of 65534),
 *     [root/wheel]     = 65535   (instead of 0).
 *
 * These only apply to DOS and the Filesystems, but the C and usergroup
 * libraries use the standard UNIX permissions, where;
 *
 *     [nobody/nogroup] = 65534. 
 *     [root/wheel]     = 0.
 *
 * The AmigaOS C libraries convert between these two protocols.
 */

NATIVE {DOS_OWNER_ROOT}     CONST DOS_OWNER_ROOT     = 65535
NATIVE {DOS_OWNER_NONE}     CONST DOS_OWNER_NONE     = 0


/****************************************************************************
 * Definitions for the ExamineData "Protection" bitfield.
 *
 * EXDB are bit definitions, EXDF are field definitions.
 * Regular RWED bits (0...3) are 0 == allowed. [ie: Negated function]
 *
 * NOTE: GRP and OTR RWED permissions are 0 == not allowed!
 * Group and Other permissions are not directly handled by the filesystem, only stored.
 *
 */

/****************************************************************************/

NATIVE {EXDB_OTR_READ}         CONST EXDB_OTR_READ         = 15    /* Other: file is readable */
NATIVE {EXDB_OTR_WRITE}        CONST EXDB_OTR_WRITE        = 14    /* Other: file is writable */
NATIVE {EXDB_OTR_EXECUTE}      CONST EXDB_OTR_EXECUTE      = 13    /* Other: file is executable */
NATIVE {EXDB_OTR_DELETE}       CONST EXDB_OTR_DELETE       = 12    /* Other: file is deleted */
NATIVE {EXDB_GRP_READ}         CONST EXDB_GRP_READ         = 11    /* Group: file is readable */
NATIVE {EXDB_GRP_WRITE}        CONST EXDB_GRP_WRITE        = 10    /* Group: file is writable */
NATIVE {EXDB_GRP_EXECUTE}       CONST EXDB_GRP_EXECUTE       = 9    /* Group: file is executable */
NATIVE {EXDB_GRP_DELETE}        CONST EXDB_GRP_DELETE        = 8    /* Group: file is deleteable */

NATIVE {EXDB_HOLD}              CONST EXDB_HOLD              = 7    /* (H) hold loaded program in cli resident list (v50)*/ 
NATIVE {EXDB_SCRIPT}            CONST EXDB_SCRIPT            = 6    /* (S) program is a script (execute) file */
NATIVE {EXDB_PURE}              CONST EXDB_PURE              = 5    /* (P) program is reentrant and reexecutable */
NATIVE {EXDB_ARCHIVE}           CONST EXDB_ARCHIVE           = 4    /* (A) cleared whenever file is changed */
NATIVE {EXDB_NO_READ}           CONST EXDB_NO_READ           = 3    /* (R) NOT readable, */
NATIVE {EXDB_NO_WRITE}          CONST EXDB_NO_WRITE          = 2    /* (W) NOT writable, */
NATIVE {EXDB_NO_EXECUTE}        CONST EXDB_NO_EXECUTE        = 1    /* (E) NOT executable, Used by Shell only */
NATIVE {EXDB_NO_DELETE}         CONST EXDB_NO_DELETE         = 0    /* (D) NOT deletable, */

/*
**  Note that when bits 0,1,2,3  are set, this represent a negated function. 
**  Early contrarily named definitions have been moved to dos/obsolete.h
*/

/****************************************************************************/
/* Masks for above bits */

NATIVE {EXDF_OTR_READ}         CONST EXDF_OTR_READ         = (1 SHL EXDB_OTR_READ)
NATIVE {EXDF_OTR_WRITE}        CONST EXDF_OTR_WRITE        = (1 SHL EXDB_OTR_WRITE)
NATIVE {EXDF_OTR_EXECUTE}      CONST EXDF_OTR_EXECUTE      = (1 SHL EXDB_OTR_EXECUTE)
NATIVE {EXDF_OTR_DELETE}       CONST EXDF_OTR_DELETE       = (1 SHL EXDB_OTR_DELETE)
NATIVE {EXDF_GRP_READ}         CONST EXDF_GRP_READ         = (1 SHL EXDB_GRP_READ)
NATIVE {EXDF_GRP_WRITE}        CONST EXDF_GRP_WRITE        = (1 SHL EXDB_GRP_WRITE)
NATIVE {EXDF_GRP_EXECUTE}      CONST EXDF_GRP_EXECUTE      = (1 SHL EXDB_GRP_EXECUTE)
NATIVE {EXDF_GRP_DELETE}       CONST EXDF_GRP_DELETE       = (1 SHL EXDB_GRP_DELETE)

NATIVE {EXDF_HOLD}             CONST EXDF_HOLD             = (1 SHL EXDB_HOLD)
NATIVE {EXDF_SCRIPT}           CONST EXDF_SCRIPT           = (1 SHL EXDB_SCRIPT)
NATIVE {EXDF_PURE}             CONST EXDF_PURE             = (1 SHL EXDB_PURE)
NATIVE {EXDF_ARCHIVE}          CONST EXDF_ARCHIVE          = (1 SHL EXDB_ARCHIVE)
NATIVE {EXDF_NO_READ}          CONST EXDF_NO_READ          = (1 SHL EXDB_NO_READ)
NATIVE {EXDF_NO_WRITE}         CONST EXDF_NO_WRITE         = (1 SHL EXDB_NO_WRITE)
NATIVE {EXDF_NO_EXECUTE}       CONST EXDF_NO_EXECUTE       = (1 SHL EXDB_NO_EXECUTE)
NATIVE {EXDF_NO_DELETE}        CONST EXDF_NO_DELETE        = (1 SHL EXDB_NO_DELETE)

/*
 * The following define is the default protection mask value for new objects.
 * This equates to the attributes; R,W,E,D
 */
NATIVE {EXDF_DEFAULT}   CONST EXDF_DEFAULT   = 0
  

/****************************************************************************/
/* Standard semantical maximum length for an error string from fault/printfault. 
   However, most error strings should be kept under 60 characters if possible.
   Don't forget space for the header you pass in. */

NATIVE {FAULT_MAX}  CONST FAULT_MAX  = 82


/****************************************************************************/
/* Handy macros for testing if a given task/process pointer is actually
 * an EXEC task or a DOS process.   V52.
 */

NATIVE {IS_PROCESS} CONST	->IS_PROCESS(x)     (NT_PROCESS==((struct Task *)x)->tc_Node.ln_Type)
NATIVE {IS_TASK} CONST	->IS_TASK(x)        (NT_TASK==((struct Task *)x)->tc_Node.ln_Type)


/****************************************************************************/
/* For the old Info() function, the structure must be on a 4 byte boundary.
 * The new V51+ GetDiskInfo() doesn't require special structure alignment. 
 * Just use AllocDosObject(DOS_INFO,0); to get the right one every time.
 */

NATIVE {InfoData} OBJECT infodata
    {id_NumSoftErrors}	numsofterrors	:VALUE    /* Deprecated; See GetDiskInfo() for more info. */
    {id_UnitNumber}	unitnumber	:VALUE       /* Deprecated; See GetDiskInfo() for more info. */

    {id_DiskState}	diskstate	:VALUE        /* See defines below */
    {id_NumBlocks}	numblocks	:ULONG        /* Number of "blocks" on disk */
    {id_NumBlocksUsed}	numblocksused	:ULONG    /* Number of "block" in use */
    {id_BytesPerBlock}	bytesperblock	:ULONG    /* The size in bytes of a "block" */
    {id_DiskType}	disktype	:VALUE         /* Disk Type code, see defines below */
    {id_VolumeNode}	volumenode	:BPTR       /* BCPL pointer to volume node (see DosList) */
    {id_InUse}	inuse	:VALUE            /* Use count, zero if not in use */
ENDOBJECT 
/* InfoData (ID stands for InfoData) */



/*
**  Disk states for; id_DiskState
*/
NATIVE {ID_DISKSTATE_WRITE_PROTECTED}  CONST ID_DISKSTATE_WRITE_PROTECTED  = 80   /* Disk is write protected */
NATIVE {ID_DISKSTATE_VALIDATING}       CONST ID_DISKSTATE_VALIDATING       = 81   /* Disk is currently waiting or validating */
NATIVE {ID_DISKSTATE_VALIDATED}        CONST ID_DISKSTATE_VALIDATED        = 82   /* Disk is consistent and writeable */



/*
**  Disk types for; id_DiskType
*/
NATIVE {ID_NO_DISK_PRESENT}    CONST ID_NO_DISK_PRESENT    = (-1)
NATIVE {ID_UNREADABLE_DISK}    CONST ID_UNREADABLE_DISK    = ($42414400)    /* 'BAD\0'  */
NATIVE {ID_BUSY_DISK}          CONST ID_BUSY_DISK          = ($42555359)    /* 'BUSY'   */
NATIVE {ID_SWAP_DISK}          CONST ID_SWAP_DISK          = ($53574150)    /* 'SWAP'  */
NATIVE {ID_NOT_REALLY_DOS}     CONST ID_NOT_REALLY_DOS     = ($4E444F53)    /* 'NDOS'  */
NATIVE {ID_KICKSTART_DISK}     CONST ID_KICKSTART_DISK     = ($4B49434B)    /* 'KICK'  */
NATIVE {ID_CDFS_DISK}          CONST ID_CDFS_DISK          = "CD0\x01" /* CDFileSystem 'CD01' */

/* The following are the standard and historic FFS DOS types.*/ 
NATIVE {ID_DOS_DISK}           CONST ID_DOS_DISK           = ($444F5300)    /* 'DOS\0'  */
NATIVE {ID_FFS_DISK}           CONST ID_FFS_DISK           = ($444F5301)    /* 'DOS\1'  */
NATIVE {ID_INTER_DOS_DISK}     CONST ID_INTER_DOS_DISK     = ($444F5302)    /* 'DOS\2'  */
NATIVE {ID_INTER_FFS_DISK}     CONST ID_INTER_FFS_DISK     = ($444F5303)    /* 'DOS\3'  */
NATIVE {ID_FASTDIR_DOS_DISK}   CONST ID_FASTDIR_DOS_DISK   = ($444F5304)    /* 'DOS\4'  */
NATIVE {ID_FASTDIR_FFS_DISK}   CONST ID_FASTDIR_FFS_DISK   = ($444F5305)    /* 'DOS\5'  */
NATIVE {ID_LONGNAME_DOS_DISK}  CONST ID_LONGNAME_DOS_DISK  = ($444F5306)    /* 'DOS\6'  */
NATIVE {ID_LONGNAME_FFS_DISK}  CONST ID_LONGNAME_FFS_DISK  = ($444F5307)    /* 'DOS\7'  */

/* V53 disk type used for new vector-port based filesystems like RAM: ENV: APPDIR: */
NATIVE {ID_VP255_DOS_DISK}     CONST ID_VP255_DOS_DISK     = ($444F5309)    /* 'DOS\9'  */
NATIVE {ID_NGFS_DISK}          CONST ID_NGFS_DISK          = ($4E474653)    /*  NGFS    */    

/* Special 'disk type' signatures returned by con-handler  */
NATIVE {ID_CON}                CONST ID_CON                = ($434F4E00)    /* 'CON\0'  */
NATIVE {ID_RAWCON}             CONST ID_RAWCON             = ($52415700)    /* 'RAW\0'  */

/* Other known disk types */  
NATIVE {ID_MSDOS_DISK}       CONST ID_MSDOS_DISK       = "MSD\x00"
NATIVE {ID_MSDOS_DISK_HD}    CONST ID_MSDOS_DISK_HD    = "MSH\x00"
NATIVE {ID_MSDOS_DISK_DS}    CONST ID_MSDOS_DISK_DS    = "MDD\x00"

/* FAT disk types */
NATIVE {ID_FAT00_DISK}       CONST ID_FAT00_DISK       = "FAT\x00"
NATIVE {ID_FAT01_DISK}       CONST ID_FAT01_DISK       = "FAT\x01"
NATIVE {ID_FAT32_DISK}       CONST ID_FAT32_DISK       = "FAT\x32"

/* FUSE filesystems */
NATIVE {ID_BOX0_DISK}        CONST ID_BOX0_DISK        = $424F5800   /*  BOX\0 - BoxFileSystem */
NATIVE {ID_EXFAT_DISK}       CONST ID_EXFAT_DISK       = $46415458   /*  FATX  - exFATFileSystem */
NATIVE {ID_EXT2_DISK}        CONST ID_EXT2_DISK        = $45585402   /*  EXT\2 - FuseExt2FileSystem */
NATIVE {ID_HFS_DISK}         CONST ID_HFS_DISK         = $48465300   /*  HFS\0 - FuseHFS  */
NATIVE {ID_NTFS_DISK}        CONST ID_NTFS_DISK        = $4e544653   /*  NTFS  - NTFileSystem3G */

/* Other misc DosTypes that may be encountered, third party or otherwise;
**
** DosTypes used for Unix partitions in the RDB:
**    Amix (Commodore Amiga Unix for the A3000UX): 'UNI\0', 'UNI\1'
** NetBSD (used by OpenBSD as well): 
**    'NBR\7' (root partition), 'NBU\7' (others partitions), 'NBS\1' (swap partition)
** Linux: 'LNX\0', 'SWP\0' (swap partition)
** Ami File Safe: 'AFS\0', 'AFS\1'
** Berkeley Fast Filesystem: 'BFFS'
** Professional File System: 'PFS\0', 'PFS\1', 'PFS\2', 'PFS\3'
** Smart File System: 'SFS\0', 'SFS\2'
** Smart File System, AROS little endian version: 'sfs\0'
**
*/



/****************************************************************************/
/* Bit numbers that signal that a user has issued a break */

NATIVE {SIGBREAKB_CTRL_C} CONST SIGBREAKB_CTRL_C = 12
NATIVE {SIGBREAKB_CTRL_D} CONST SIGBREAKB_CTRL_D = 13
NATIVE {SIGBREAKB_CTRL_E} CONST SIGBREAKB_CTRL_E = 14
NATIVE {SIGBREAKB_CTRL_F} CONST SIGBREAKB_CTRL_F = 15

/*
**  Bit fields that signal that a user has issued a break,
**  See IDOS->CheckSignal() for examples. 
*/
NATIVE {SIGBREAKF_CTRL_C} CONST SIGBREAKF_CTRL_C = (1 SHL SIGBREAKB_CTRL_C)
NATIVE {SIGBREAKF_CTRL_D} CONST SIGBREAKF_CTRL_D = (1 SHL SIGBREAKB_CTRL_D)
NATIVE {SIGBREAKF_CTRL_E} CONST SIGBREAKF_CTRL_E = (1 SHL SIGBREAKB_CTRL_E)
NATIVE {SIGBREAKF_CTRL_F} CONST SIGBREAKF_CTRL_F = (1 SHL SIGBREAKB_CTRL_F)

/****************************************************************************/
/* Values returned by SameLock() */

NATIVE {LOCK_DIFFERENT}     CONST LOCK_DIFFERENT     = -1
NATIVE {LOCK_SAME}           CONST LOCK_SAME           = 0
NATIVE {LOCK_SAME_VOLUME}    CONST LOCK_SAME_VOLUME    = 1    /* locks are on same volume */

/****************************************************************************/
/* Values returned by SameFH() */

NATIVE {FH_DIFFERENT}     CONST FH_DIFFERENT     = -1
NATIVE {FH_SAME}           CONST FH_SAME           = 0
NATIVE {FH_SAME_VOLUME}    CONST FH_SAME_VOLUME    = 1    /* filehandles are on same volume */

/****************************************************************************/
/* Types for ChangeMode() */

NATIVE {CHANGE_LOCK}    CONST CHANGE_LOCK    = 0
NATIVE {CHANGE_FH}      CONST CHANGE_FH      = 1

/****************************************************************************/
/* Mode parameter for DevNameFromLock() and DevNameFromFH() */

NATIVE {DN_DEVICEONLY}  CONST DN_DEVICEONLY  = 0
NATIVE {DN_FULLPATH}    CONST DN_FULLPATH    = 1
NATIVE {DN_ROOTPATH}    CONST DN_ROOTPATH    = 2

/****************************************************************************/
/* The following is used by the new V51 tag;  NP_NotifyOnDeathMessage       */
/* See CreateNewProc() autodoc for more details.                            */

NATIVE {DeathMessage} OBJECT deathmessage
    {dm_Msg}	mn	:mn    /* Embedded exec message structure.           */
    {dm_ReturnCode}	returncode	:VALUE     /* Primary process return code, set by DOS    */
    {dm_Result2}	result2	:VALUE        /* The value returned from IoErr(),set by DOS */
ENDOBJECT

/****************************************************************************/
/* The following is the data structure to be used for FReadLine()
 * which is allocated by the AllocDosObject() function ONLY.
 */

NATIVE {FReadLineData} OBJECT freadlinedata
    {frld_Line}	line	:/*STRPTR*/ ARRAY OF CHAR           /* NUL-terminated string */
    {frld_LineLength}	linelength	:ULONG     /* what strlen(frld_Line) would return */
    {frld_DosPrivate}	dosprivate[8]	:ARRAY OF ULONG  /* -- internal dos.library use only */
ENDOBJECT

/****************************************************************************/
/* Mode flags for GetProcSegList()   (v51.88) */

NATIVE {GPSLF_CLI}    CONST GPSLF_CLI    = 1 SHL 1
NATIVE {GPSLF_SEG}    CONST GPSLF_SEG    = 1 SHL 2
NATIVE {GPSLF_ENT}    CONST GPSLF_ENT    = 1 SHL 3
NATIVE {GPSLF_RUN}    CONST GPSLF_RUN    = 1 SHL 4

/****************************************************************************/
/* Values for MakeLink() - DO NOT use random values, new link types will
 * be added in the future that require other values to be used. 
 */

NATIVE {LINK_HARD}      CONST LINK_HARD      = 0
NATIVE {LINK_SOFT}      CONST LINK_SOFT      = 1

/****************************************************************************/
/* Values returned by ReadItem (and ReadLineItem V50) */

NATIVE {ITEM_EQUAL}    CONST ITEM_EQUAL    = -2    /* "=" Symbol */
NATIVE {ITEM_ERROR}    CONST ITEM_ERROR    = -1    /* error */
NATIVE {ITEM_NOTHING}   CONST ITEM_NOTHING   = 0    /* *N, ;, endstreamch */
NATIVE {ITEM_UNQUOTED}  CONST ITEM_UNQUOTED  = 1    /* unquoted item */
NATIVE {ITEM_QUOTED}    CONST ITEM_QUOTED    = 2    /* quoted item */

/****************************************************************************/
/* Types for AllocDosObject/FreeDosObject */

NATIVE {DOS_FILEHANDLE}      CONST DOS_FILEHANDLE      = 0   /* Very few people should use this */
NATIVE {DOS_EXALLCONTROL}    CONST DOS_EXALLCONTROL    = 1   /* Must be used to allocate this! - Obsolete struct */
NATIVE {DOS_FIB}             CONST DOS_FIB             = 2   /* may be useful - not really, it's obsolete now */
NATIVE {DOS_STDPKT}          CONST DOS_STDPKT          = 3   /* for doing packet-level I/O */
NATIVE {DOS_CLI}             CONST DOS_CLI             = 4   /* for shell-writers, etc */
NATIVE {DOS_RDARGS}          CONST DOS_RDARGS          = 5   /* for ReadArgs if you pass it in */
NATIVE {DOS_ANCHORPATH}      CONST DOS_ANCHORPATH      = 6   /* for MatchFirst/MatchNext (V50) */
NATIVE {DOS_INFODATA}        CONST DOS_INFODATA        = 7   /* for Info() aligned InfoData (V50) */
NATIVE {DOS_NOTIFYREQUEST}   CONST DOS_NOTIFYREQUEST   = 8   /* for Notify request functions (V51)  */
NATIVE {DOS_LOCK}            CONST DOS_LOCK            = 9   /* for filesystem lock allocations (V51) */
NATIVE {DOS_FREADLINEDATA}  CONST DOS_FREADLINEDATA  = 10   /* for FReadLine() structure. (V51) */
NATIVE {DOS_EXAMINEDATA}    CONST DOS_EXAMINEDATA    = 11   /* for filesystem ExamineData allocations.(V51) */ 
NATIVE {DOS_DOSLIST}        CONST DOS_DOSLIST        = 12   /* for struct DosList allocations. (V52.16) */
NATIVE {DOS_VOLUMELIST}     CONST DOS_VOLUMELIST     = 13   /* for struct list with attached nodes. (V53.52) */
NATIVE {DOS_FSVECTORPORT}   CONST DOS_FSVECTORPORT   = 14   /* for filesystem vector port creation. (53.80) */
