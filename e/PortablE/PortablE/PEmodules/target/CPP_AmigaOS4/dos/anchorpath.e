/* $VER: anchorpath.h 53.29 (10.8.2015) */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/dos/dos'
MODULE 'target/exec/types', 'target/dos/dosextens'
{#include <dos/anchorpath.h>}
NATIVE {DOS_ANCHORPATH_H} CONST
                      
/* Returned by obsolete Examine(), ExamineFH() and ExNext(), it must also be
 * allocated on a 4 byte boundary address.
 *
 * This structure is obsolete, due to 4 gig file size limits, short string 
 * length issues and lack of extensibility.
 * Software should migrate to using the new ExamineDir() and the ExamineObject()
 * functions which use the struct ExamineData. 
 * 
 * This structure is here because it is nested within other structures and for
 * legacy compatibility reasons, so this definition can't be removed at this time.
 *
 * NOTE: The fib_DOSReserved[8] area is ABSOLUTELY DOS PRIVATE !! - Do not access it.
 *       DOS uses all of this space for context information when emulating the
 *       old V40 functions that require this structure.
 */

NATIVE {FileInfoBlock} OBJECT fileinfoblock
    {fib_DiskKey}	diskkey	:ULONG        /* -- FILESYSTEM PRIVATE !!                */
    {fib_DirEntryType}	direntrytype	:VALUE   /* Use FIB_IS_ macros to identify object.  */
    {fib_FileName}	filename[108]	:ARRAY OF /*TEXT*/ CHAR  /* Null terminated.                        */
    {fib_Protection}	protection	:ULONG     /* Bit mask of protection, rwxd are 3-0.   */

    {fib_Obsolete}	obsolete_entrytype	:VALUE       /* -- OBSOLETE !! - Do not access this.    */
                                         /* Change old source code to reference     */
                                         /* the fib_DirEntryType member instead.    */
                                         /* Handlers should init this to the same   */
                                         /* compatibility value as fib_DirEntryType */

    {fib_Size}	size	:ULONG           /* Byte size of file, only good to 4 gig.  */
    {fib_NumBlocks}	numblocks	:ULONG      /* Number of blocks in file                */
    {fib_Date}	datestamp	:datestamp           /* Date file last changed                  */
    {fib_Comment}	comment[80]	:ARRAY OF /*TEXT*/ CHAR    /* Null terminated comment string.         */

    /*  Note: the following two fields are not supported by all filesystems.
    **  They should be initialized to 0 when sending an ACTION_EXAMINE packet.
    **  When Examine() is called, these are set to 0 for you.
    **  AllocDosObject() also initializes them to 0. 
    */
    {fib_OwnerUID}	owneruid	:UINT       /* owner's UID */
    {fib_OwnerGID}	ownergid	:UINT       /* owner's GID */

    {fib_DOSReserved}	reserved[8]	:ARRAY OF PTR /* -- DOS PRIVATE !! - Do not access this. 
                                         **    DOS uses all of this space for the
                                         **    legacy emulation context data.
                                         */
ENDOBJECT 
/* FileInfoBlock - 260 bytes */






/*****************************************************************************/
/*  Obsolete definition ==ONLY== for legacy reference, pre V50.76 DOS.       */
/*  This is what DOS will expect when NOT allocated by AllocDosObject().     */
/*                                                                           */
/*  #define USE_OLD_ANCHORPATH will use this definition for old source code. */ 
/*****************************************************************************/

NATIVE {AnchorPathOld} OBJECT anchorpathold
    {ap_Base}	base	:PTR TO achain       /* pointer to first anchor */
    {ap_Current}	current	:PTR TO achain    /* pointer to current anchor */
    {ap_BreakBits}	breakbits	:ULONG  /* Bits we want to break on */
    {ap_FoundBreak}	foundbreak	:ULONG /* Bits we broke on. Also returns ERROR_BREAK */
    {ap_Flags}	flags	:UBYTE      /* New use for extra word. */
    {ap_Reserved}	reserved	:UBYTE
    {ap_Strlen}	strlen	:UINT     /* This is what ap_Length used to be */
    {ap_Info}	info	:fileinfoblock
    {ap_Buf}	buf	:ARRAY OF /*TEXT*/ CHAR     /* Buffer for path name, allocated by user */
ENDOBJECT






/***********************************************************************
************************ PATTERN MATCHING ******************************
************************************************************************
*
* Structure expected by MatchFirst, MatchNext.
* Allocate this structure ONLY with AllocDosObject() from DOS 50.76+
* and initialize the ADO_Flags with the appropriate bits as follows:
*
* Set ADO_Mask, (ap_BreakBits) to the signal bitmask (^CDEF) that you want to
* take a break on, or 0L, (default) if you don't want to convenience the user.
*
* If you want to have the FULL PATH NAME of the files you found,
* allocate an additional buffer space using the tag ADO_Strlen, this will 
* place the buffer in ap_Buffer and the size into ap_Strlen.  
*
* If you don't need the full path name, DO NOT specify the ADO_Strlen tag, 
* this will by default, set ap_Strlen to zero, for no additional buffer space.
* In this case, the name of the file, and other stats are available in the
* ap_ExData structure if not NULL, (or old FIB ap_Info struct for legacy apps),
* Note that the ap_ExData pointer was NULL prior to V54, so you MUST check the
* pointer before access, when operating with previous dos.library releases.
* Always use ap_ExData in preference to the old ap_Info data, because only
* ap_ExData supports 64 bit file sizes and long names > 107 bytes.
* 
* Then call MatchFirst() and then afterwards, MatchNext() with this structure.
* You should check the return value each time (see below) and take the
* appropriate action, ultimately calling MatchEnd() when there are
* no more files and you are done.  You can tell when you are done by
* checking for the normal AmigaDOS return code ERROR_NO_MORE_ENTRIES.
*
*
******************************************************************************
* WARNING:  You MUST allocate these with AllocDosObject() from DOS 50.76+ 
*           MatchXXX() will simply not work if you do not heed this warning.
******************************************************************************
*/

NATIVE {AnchorPath} OBJECT anchorpath
    {ap_Magic}	magic	:VALUE        /* -- PRIVATE - DOS compatibility  */
    {ap_Base}	base	:PTR TO achain         /* Ptr to first anchor             */
    {ap_Current}	current	:PTR TO achain      /* Ptr to current anchor           */
    {ap_BreakBits}	breakbits	:ULONG    /* Bits we want to break on        */
    {ap_FoundBreak}	foundbreak	:ULONG   /* Bits we broke on.               */
    {ap_Flags}	flags	:ULONG        /* The flags bitfield.             */
    {ap_ExData}	exdata	:PTR TO examinedata       /* Ptr to ExamineData (or NULL)    */
	{ap_CTXPrivate}	ctxprivate	:APTR   /* -- PRIVATE, DOS use only.       */
    {ap_Reserved}	reserved[2]	:ARRAY OF ULONG  /* Future use, currently 0         */
    {ap_Strlen}	strlen	:ULONG       /* Strlen : Size of the buffer -1  */
    {ap_Buffer}	buffer	:/*STRPTR*/ ARRAY OF CHAR       /* Full name, (see ADO_Strlen)     */
    {ap_Info}	info	:fileinfoblock         /* The old FileInfoBlock space     */
    {ap_Private1}	private1	:ULONG     /* --PRIVATE, DOS use only.        */
    {ap_Private2}	private2	:ULONG     /* --PRIVATE, DOS use only.        */
ENDOBJECT


/****************************************************************************/
/* 
 * Some usefull synonyms.
 */

NATIVE {ap_First}      CONST ->AP_FIRST      = ap_Base
NATIVE {ap_Last}       CONST ->AP_LAST       = ap_Current



/***************************************************************************/
/* 
 * Flags for AnchorPath->ap_Flags.
 */

NATIVE {APB_DOWILD}       CONST APB_DOWILD       = 0  /* Unused */

NATIVE {APB_ITSWILD}      CONST APB_ITSWILD      = 1  /* Set by MatchFirst, used by MatchNext.
                               Application can test APB_ITSWILD, too
                              (means that there's a wildcard
                               in the pattern after calling
                               MatchFirst). */

NATIVE {APB_DODIR}        CONST APB_DODIR        = 2  /* Bit is SET if a DIR node should be
                               entered. Application can RESET this
                               bit after MatchFirst/MatchNext to AVOID
                               entering a dir. */

NATIVE {APB_DIDDIR}       CONST APB_DIDDIR       = 3  /* Bit is SET for an "expired" dir node. */

NATIVE {APB_NOMEMERR}     CONST APB_NOMEMERR     = 4  /* Set on memory error */

NATIVE {APB_DODOT}        CONST APB_DODOT        = 5  /* Unused */

NATIVE {APB_DirChanged}   CONST APB_DIRCHANGED   = 6  /* ap_Current->an_Lock changed
                               since last MatchNext call */

NATIVE {APB_FollowHLinks} CONST APB_FOLLOWHLINKS = 7  /* follow hardlinks on DODIR - defaults
                               to not following hardlinks on a DODIR. */

NATIVE {APB_MultiAssigns} CONST APB_MULTIASSIGNS = 8  /* Set this bit via AllocDosObject() to allow
                               Multi-Assign scanning to be enabled.  
                              ( NOTE: ONLY AVAILABLE FROM DOS 50.76+ ) */


NATIVE {APF_DOWILD}       CONST APF_DOWILD       = (1 SHL APB_DOWILD)
NATIVE {APF_ITSWILD}      CONST APF_ITSWILD      = (1 SHL APB_ITSWILD)
NATIVE {APF_DODIR}        CONST APF_DODIR        = (1 SHL APB_DODIR)
NATIVE {APF_DIDDIR}       CONST APF_DIDDIR       = (1 SHL APB_DIDDIR)
NATIVE {APF_NOMEMERR}     CONST APF_NOMEMERR     = (1 SHL APB_NOMEMERR)
NATIVE {APF_DODOT}        CONST APF_DODOT        = (1 SHL APB_DODOT)
NATIVE {APF_DirChanged}   CONST APF_DIRCHANGED   = (1 SHL APB_DIRCHANGED)
NATIVE {APF_FollowHLinks} CONST APF_FOLLOWHLINKS = (1 SHL APB_FOLLOWHLINKS)

NATIVE {APF_MultiAssigns} CONST APF_MULTIASSIGNS = (1 SHL APB_MULTIASSIGNS)    
                /* New for V50, See AllocDosObject() */



/****************************************************************************/
/* This structure is mostly DOS private for MatchXXX() directory scanner.   */

NATIVE {AChain} OBJECT achain
    {an_Child}	child	:PTR TO achain
    {an_Parent}	parent	:PTR TO achain
    {an_Lock}	lock	:BPTR

/*
**  The remaining members are strictly DOS private. 
*/  
    {an_Info}	info	:fileinfoblock
    {an_Flags}	flags	:ULONG
    {an_ExData}	exdata	:PTR TO examinedata 
    {an_DevProc}	devproc	:PTR TO devproc
    {an_String}	string	:ARRAY OF /*TEXT*/ CHAR
ENDOBJECT


/*
 * Flags for AChain->an_Flags; these are private to DOS!
 */

NATIVE {DDB_PatternBit}        CONST DDB_PATTERNBIT        = 0
NATIVE {DDB_ExaminedBit}       CONST DDB_EXAMINEDBIT       = 1
NATIVE {DDB_Completed}         CONST DDB_COMPLETED         = 2
NATIVE {DDB_AllBit}            CONST DDB_ALLBIT            = 3
NATIVE {DDB_Assign}            CONST DDB_ASSIGN            = 4
NATIVE {DDB_Device}            CONST DDB_DEVICE            = 5

NATIVE {DDF_Device}           CONST DDF_DEVICE           = (1 SHL DDB_DEVICE)
NATIVE {DDF_Assign}           CONST DDF_ASSIGN           = (1 SHL DDB_ASSIGN)
NATIVE {DDF_AllBit}           CONST DDF_ALLBIT           = (1 SHL DDB_ALLBIT)
NATIVE {DDF_Completed}        CONST DDF_COMPLETED        = (1 SHL DDB_COMPLETED)
NATIVE {DDF_ExaminedBit}      CONST DDF_EXAMINEDBIT      = (1 SHL DDB_EXAMINEDBIT)
NATIVE {DDF_PatternBit}       CONST DDF_PATTERNBIT       = (1 SHL DDB_PATTERNBIT)
