	IFND DPKERNEL_I
DPKERNEL_I  SET  1

**
**  $VER: dpkernel.i V2.1
**
**  General include file for programs using the DPKernel.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
**

	IFND	LIBRARIES_DPKERNEL_LIB_I
	include	'modules/dpkernel_lib.i'
	include	'modules/screens.i'
	include	'modules/blitter.i'
	include	'modules/sound.i'
	ENDC

	IFND    SYSTEM_TYPES_I
	include 'system/types.i'
	ENDC

	IFND	SYSTEM_REGISTER_I
	include	'system/register.i'
	ENDC

****************************************************************************

DPKVersion  =  2             ;Version for these includes.
DPKRevision =  1             ;Revision for these includes.

SKIPENTRY   =  0             ;Used to skip to the next entry.
ENDLIST     =  -1            ;Used to terminate a list.
LISTEND     =  -1            ;Synonym for ENDLIST.
TAGEND      =  0             ;Used to terminate a tag list.
DEFAULT     =  0

TBYTE       =  0             ;Flags used for constructing tag lists.
TLONG       =  (1<<31)
TWORD       =  (1<<30)
TAPTR       =  (1<<29)|TLONG
TSTEPIN     =  (1<<28)
TSTEPOUT    =  (1<<27)
TTRIGGER    =  (1<<26)

  IFND	TAG_IGNORE
TAG_IGNORE  =  1
TAG_MORE    =  2
TAG_SKIP    =  3
  ENDC

GET_NOTRACK = $00010000             ;Disables tracking on an object.
GET_PUBLIC  = $00020000             ;If the object is to be passed to other tasks/processes.
GET_SHARE   = $00040000|GET_PUBLIC  ;If the object is to be openly shared with foreign tasks.

****************************************************************************
* Function synonyms.

_LVODisplay   =	_LVOShow
_LVOVisible   =	_LVOShow
_LVOInvisible =	_LVOHide
_LVOGetParent = _LVOGetContainer

****************************************************************************
* Header used in all objects.

    STRUCTURE	Head,0
	WORD	HEAD_ID       ;Object Identifier, eg ID_PICTURE
	WORD	HEAD_Version  ;Version of this object.
	APTR	HEAD_Class    ;Pointer to relevant system object.
	APTR	HEAD_Stats    ;Private.
	LABEL	HEAD_SIZEOF

    STRUCTURE	Stats,0             ;This structure is completely private.
	LONG	STATS_Key           ;Resource key.
	APTR	STATS_ChildPrivate  ;Available for child objects.
	LONG	STATS_Flags         ;General flags.
	APTR	STATS_Exclusive     ;What task owns the Exclusive.
	WORD	STATS_LockCount     ;A running count of active locks.
	WORD	STATS_not00         ;
	LONG	STATS_MemFlags      ;Recommended memory allocation flags.

ST_SHARED      = $00000001          ;The object is being openly shared.
ST_EXCLUSIVE   = $00000002          ;If object is exclusive to a process.
ST_PUBLIC      = $00000004          ;If GET_PUBLIC was set on Get().
ST_NOTRACKING  = $00000008          ;Do not track resources on this object.
ST_INITIALISED = $00000010          ;This is set by Init().

****************************************************************************
* RawData object.

VER_RAWDATA  = 1
TAGS_RAWDATA = ((ID_SPCTAGS<<16)|ID_RAWDATA)

   STRUCTURE	RD,HEAD_SIZEOF   ;Standard structure header.
	LONG	RD_Size          ;Size of the data in bytes.
	APTR	RD_Data          ;Pointer to the data.
	BYTE	RD_AFlags        ;Private.
	BYTE	RD_Pad           ;Private.
	LABEL	RD_SIZEOF

****************************************************************************
* List object.

VER_ITEMLIST  = 1
TAGS_ITEMLIST = ((ID_SPCTAGS<<16)|ID_ITEMLIST)

   STRUCTURE	LST,HEAD_SIZEOF  ;Standard structure header.
	LONG	LST_Array        ;Pointer to the list's array.
	APTR	LST_MaxSize      ;Maximum amount of objects that we can hold.

****************************************************************************
* This macro will allow you to run a DPK program directly (ie no StartDPK),
* and still retain compatibility on other platforms.  It will also set up
* the self-destruct mechanism so that hitting left-amiga and delete will
* destroy your task and leave the system 100% intact with all resources.
*
* Usage: STARTDPK

   STRUCTURE	dp1,0
	LONG	DPK_ID	;ID Header.
	WORD	DPK_Version	;Version number of this program table.
	WORD	DPK_DPKType	;Type of jump table from DPK.
	LONG	DPK_Start	;Start of program.
	APTR	DPK_Name	;Name of the program.
	APTR	DPK_Author	;Who wrote the program.
	APTR	DPK_Date	;Date of compilation.
	APTR	DPK_Copyright	;Copyright details.
	APTR	DPK_Short	;Short description of program.
	WORD	DPK_MinVersion	;Minimum required DPKernel version.
	WORD	DPK_MinRevision	;Minimum required DPKernel revision.

STARTDPK MACRO
	bra.s	StartAmigaDOS	;Jump if running from AmigaDOS.

	dc.l	"PRGM"	;ID Header.
	dc.w	1	;Version number of this program table.
	dc.w	JMP_LVO	;Type of jump table from DPK.
	dc.l	StartDPKernel	;Start of program.
	dc.l	ProgName	;Name of the program.
	dc.l	ProgAuthor	;Who wrote the program.
	dc.l	ProgDate	;Date of compilation.
	dc.l	ProgCopyright	;Copyright details.
	dc.l	ProgShort	;Short description of program.
	dc.w	DPKVersion	;Minimum required DPKernel version.
	dc.w	DPKRevision	;Minimum required DPKernel revision.

StartAmigaDOS:
	MOVEM.L	D0-D7/A0-A6,-(SP)	;SP = Save all registers.
.Check	move.l	($4).w,a6
	sub.l	a1,a1
	jsr	-294(a6)	;>> = FindTask
	move.l	d0,a4
	tst.l	172(a4)	;a4 = pr_CLI
	bne.s	.DOS

.WBench	lea	92(a4),a0	;a0 = pr_MsgPort
	jsr	-384(a6)	;>> = WaitPort()

	lea	92(a4),a0	;a0 = pr_MsgPort
	jsr	-372(a6)	;>> = GetMsg()
	move.l	d0,ReturnMsg	;ma = Store message.

.DOS	move.l	($4).w,a6	;a6 = ExecBase
	lea	DPKName(pc),a1	;a1 = Library name.
	moveq	#DPKVersion,d0	;d0 = Version of these includes.
	jsr	-552(a6)	;>> = OpenLibrary()
	lea	DPKBase(pc),a4
	move.l	d0,(a4)	;ma = Save base.
	beq	ProgEnd	;>> = Error, exit.
	move.w	#1,DOS	;ma = Started from DOS.

	move.l	d0,a6	;a6 = DPKBase.
	lea	ProgExit(pc),a0	;a0 = Pointer to SelfDestruct() cleanup.
	move.l	a7,a1	;a1 = Stack pointer.
	CALL	InitDestruct	;>> = Initialise the call.
	bra.s	Launch

StartDPKernel:
	MOVEM.L	D0-D7/A0-A6,-(SP)	;SP = Save all registers.
	cmp.w	#ID_TASK,(a0)
	bne	ProgEnd
	lea	DPKBase(pc),a4
	move.l	GT_DPKBase(a0),(a4)
	lea	GVBase(pc),a4
	move.l	GT_DPKBase(a0),(a4)

Launch:	move.l	DPKBase(pc),a6
	moveq	#MOD_SCREENS,d0
	sub.l	a0,a0
	CALL	OpenModule
	lea	SCRModule(pc),a4
	move.l	d0,(a4)
	beq.s	ProgExit
	move.l	d0,a5
	lea	SCRBase(pc),a4
	move.l	MOD_ModBase(a5),(a4)

	moveq	#MOD_BLITTER,d0
	sub.l	a0,a0
	CALL	OpenModule
	lea	BLTModule(pc),a4
	move.l	d0,(a4)
	beq.s	ProgExit
	move.l	d0,a5
	lea	BLTBase(pc),a4
	move.l	MOD_ModBase(a5),(a4)

	moveq	#MOD_SOUND,d0
	sub.l	a0,a0
	CALL	OpenModule
	lea	SNDModule(pc),a4
	move.l	d0,(a4)
	beq.s	ProgExit
	move.l	d0,a5
	lea	SNDBase(pc),a4
	move.l	MOD_ModBase(a5),(a4)

	bsr	Start\@	;>> = Start the program.
	tst.l	d0	;d0 = Check for error.
	beq.s	ProgExit	;>> = No errors, exit.
	move.l	DPKBase(pc),a6
	CALL	ErrCode	;>> = Send the error code.

ProgExit:
	move.l	DPKBase(pc),a6	;a6 = DPKBase
	move.l	SCRModule(pc),a0
	CALL	Free
	move.l	BLTModule(pc),a0
	CALL	Free
	move.l	SNDModule(pc),a0
	CALL	Free

	move.w	DOS(pc),d0
	beq.s	ProgEnd	;>> = We started from the StartDPK CLI.
	CALL	CloseDPK	;>> = Close the kernel.

	move.l	ReturnMsg(pc),d0
	beq.s	ProgEnd
	move.l	($4).w,a6
	jsr	-378(a6)

ProgEnd	MOVEM.L	(SP)+,D0-D7/A0-A6	;SP = Return registers.
	moveq	#ERR_OK,d0	;d0 = No errors.
	rts

DOS:		dc.w  0
SNDBase:	dc.l  0
BLTBase:	dc.l  0
SCRBase:	dc.l  0
SNDModule:	dc.l  0
BLTModule:	dc.l  0
SCRModule:	dc.l  0
ReturnMsg:	dc.l  0
DPKBase:	dc.l  0	;DPKBase.
GVBase:		dc.l  0 	;Global variable base.
Args:		dc.l  0	;Pointer to argument string.

DPKName:	dc.b  "GMS:libs/dpkernel.library",0
		even
Start\@
	ENDM

******************************************************************************
* This macro provides an easy way of sending a message to IceBreaker.
* The DPKBase must be in register a6.
*
* Example:
*
*	MESSAGE	"Hello World."

MESSAGE	MACRO
	MOVEM.L	A5/D7,-(SP)
	moveq	#DBG_Message,d7
	lea	.text\@(pc),a5
	CALL	DebugMessage
	bra.s	.cont\@
.text\@	dc.b	\1,0
	even
.cont\@	MOVEM.L	(SP)+,A5/D7
	ENDM

*****************************************************************************
* Universal errorcodes returned by certain functions.  These are further
* explained in the documentation.

 STRUCTURE Errors,0
   BYTE  ERR_OK           ;Function went OK.
   BYTE  ERR_NOMEM        ;Not enough memory available.
   BYTE  ERR_NOPTR        ;A required address pointer is not present.
   BYTE  ERR_INUSE        ;Previous allocations have not been freed.
   BYTE  ERR_STRUCT       ;Structure version not supported/not found.
   BYTE  ERR_FAILED       ;General/Miscellaneous failure.
   BYTE  ERR_FILE         ;General file error, eg file not found, disk full etc.
   BYTE  ERR_BADDATA      ;There is an error in the given data.
   BYTE  ERR_SEARCH       ;An internal search was performed and it failed.
   BYTE  ERR_SCRTYPE      ;Screen Type not recognised.
   BYTE  ERR_MODULE       ;Trouble with initialising/using a system module.
   BYTE  ERR_RASTCOMMAND  ;Invalid raster command detected.
   BYTE  ERR_RASTERLIST   ;Complete rasterlist failure.
   BYTE  ERR_NORASTER     ;Expected rasterlist is missing from GS_Rasterlist.
   BYTE  ERR_DISKFULL     ;Disk full error.
   BYTE  ERR_FILEMISSING  ;File not found.
   BYTE  ERR_WRONGVER     ;Wrong version or version not supported.
   BYTE  ERR_MONITOR      ;Monitor driver not found or cannot be used.
   BYTE  ERR_UNPACK       ;Problem with unpacking of data.
   BYTE  ERR_ARGS         ;Invalid arguments passed to function.
   BYTE  ERR_NODATA       ;No data is available for use.
   BYTE  ERR_READ         ;Error reading data from file.
   BYTE  ERR_WRITE        ;Error writing data to file.
   BYTE  ERR_LOCK         ;Could not obtain lock on object.
   BYTE  ERR_EXAMINE      ;Could not examine the directory or file.
   BYTE  ERR_LOSTCLASS    ;This object has lost its class reference.
   BYTE  ERR_NOACTION     ;This object does not support the required action.
   BYTE  ERR_NOSUPPORT    ;Object does not support the given data.
   BYTE  ERR_MEMORY       ;General memory error.
   BYTE  ERR_TIMEOUT      ;Function timed-out before successful completion.
   BYTE  ERR_NOSTATS      ;This object has lost its stats structure.
   BYTE  ERR_GET          ;Error in Get()ing an object.
   BYTE  ERR_INIT         ;Error in Init()ialising an object.
   BYTE  ERR_NOPERMISSION ;Used in cases of security violation.
   LABEL ERR_END          ;Private code (used by IceBreaker).

ERR_SUCCESS   = ERR_OK
ERR_DATA      = ERR_BADDATA
ERR_LOSTSTATS = ERR_NOSTATS
ERR_NOCLASS   = ERR_LOSTCLASS
ERR_SECURITY  = ERR_NOPERMISSION

*****************************************************************************
* Memory types used by AllocMemBlock().  This is almost identical to the
* exec definition but CHIP is renamed to VIDEO (displayable memory) and
* there is an addition of BLIT and SOUND specific memory.  CLEARed memory is
* redundant (all GMS memory is cleared on allocation), REVERSE and NO_EXPUNGE
* are also no longer needed (NB: GMS uses exec's reverse flag to reduce
* fragmentation).

MEM_DATA      = $00000000   ;Default.
MEM_PUBLIC    = $00000001   ;Memory can be shared between tasks.
MEM_VIDEO     = $00000002   ;Suitable for the video display and blitting.
MEM_BLIT      = $00000004   ;For blitting only.
MEM_SOUND     = $00000008   ;Sound/Audio memory for playback of sounds.
MEM_CODE      = $00000010   ;For executing code and storing data.
MEM_PRIVATE   = $00000020   ;Force private memory.
MEM_NOCLEAR   = $00000040   ;Do not clear the memory.
MEM_RESOURCED = $00000080   ;This memory is going to be resourced.
MEM_UNTRACKED = $80000000   ;Do not track the memory.

MPUBLIC       = MEM_PUBLIC  ;Synonym.
MPRIVATE      = MEM_PRIVATE ;Synonym.

	IFND	SYSTEM_MODULES_I
	include	'system/modules.i'
	ENDC

	IFND	GRAPHICS_BLITTER_I
	include	'graphics/blitter.i'
	ENDC

	IFND	GRAPHICS_SCREENS_I
	include	'graphics/screens.i'
	ENDC

	IFND    GRAPHICS_PICTURES_I
	include 'graphics/pictures.i'
	ENDC

	IFND    SYSTEM_MISC_I
	include 'system/misc.i'
	ENDC

	IFND    SYSTEM_TASKS_I
	include 'system/tasks.i'
	ENDC

	IFND    SOUND_SOUND_I
	include 'sound/sound.i'
	ENDC

	IFND    INPUT_JOYPORTS_I
	include 'input/joyports.i'
	ENDC

	IFND    INPUT_KEYBOARD_I
	include 'input/keyboard.i'
	ENDC

	IFND    FILES_FILES_I
	include 'files/files.i'
	ENDC

  ENDC	;DPKERNEL_I
