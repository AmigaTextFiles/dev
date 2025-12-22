/* $Id: alerts.h,v 1.14 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
{#include <exec/alerts.h>}
NATIVE {EXEC_ALERTS_H} CONST

/*********************************************************************
*
*  Format of the alert error number:
*
*    +-+-------------+----------------+--------------------------------+
*    |D|  SubSysId   |  General Error |    SubSystem Specific Error    |
*    +-+-------------+----------------+--------------------------------+
*     1    7 bits          8 bits                  16 bits
*
*                    D:  DeadEnd alert
*             SubSysId:  indicates ROM subsystem number.
*        General Error:  roughly indicates what the error was
*       Specific Error:  indicates more detail
**********************************************************************/

/**********************************************************************
*
*  Hardware/CPU specific alerts:  They may show without the 8 at the
*  front of the number.  These are CPU/68000 specific.  See 680x0
*  programmer's manuals for more details.
*
**********************************************************************/

NATIVE {ACPU_BusErr}     CONST ACPU_BUSERR     = $80000002 /* Hardware bus fault/access error */
NATIVE {ACPU_AddressErr} CONST ACPU_ADDRESSERR = $80000003 /* Illegal address access (ie: odd) */
NATIVE {ACPU_InstErr}    CONST ACPU_INSTERR    = $80000004 /* Illegal instruction */
NATIVE {ACPU_DivZero}    CONST ACPU_DIVZERO    = $80000005 /* Divide by zero */
NATIVE {ACPU_CHK}        CONST ACPU_CHK        = $80000006 /* Check instruction error */
NATIVE {ACPU_TRAPV}      CONST ACPU_TRAPV      = $80000007 /* TrapV instruction error */
NATIVE {ACPU_PrivErr}    CONST ACPU_PRIVERR    = $80000008 /* Privilege violation error */
NATIVE {ACPU_Trace}      CONST ACPU_TRACE      = $80000009 /* Trace error */
NATIVE {ACPU_LineA}      CONST ACPU_LINEA      = $8000000A /* Line 1010 Emulator error */
NATIVE {ACPU_LineF}      CONST ACPU_LINEF      = $8000000B /* Line 1111 Emulator error */
NATIVE {ACPU_Format}     CONST ACPU_FORMAT     = $8000000E /* Stack frame format error */
NATIVE {ACPU_Spurious}   CONST ACPU_SPURIOUS   = $80000018 /* Spurious interrupt error */
NATIVE {ACPU_AutoVec1}   CONST ACPU_AUTOVEC1   = $80000019 /* AutoVector Level 1 interrupt error */
NATIVE {ACPU_AutoVec2}   CONST ACPU_AUTOVEC2   = $8000001A /* AutoVector Level 2 interrupt error */
NATIVE {ACPU_AutoVec3}   CONST ACPU_AUTOVEC3   = $8000001B /* AutoVector Level 3 interrupt error */
NATIVE {ACPU_AutoVec4}   CONST ACPU_AUTOVEC4   = $8000001C /* AutoVector Level 4 interrupt error */
NATIVE {ACPU_AutoVec5}   CONST ACPU_AUTOVEC5   = $8000001D /* AutoVector Level 5 interrupt error */
NATIVE {ACPU_AutoVec6}   CONST ACPU_AUTOVEC6   = $8000001E /* AutoVector Level 6 interrupt error */
NATIVE {ACPU_AutoVec7}   CONST ACPU_AUTOVEC7   = $8000001F /* AutoVector Level 7 interrupt error */

/*********************************************************************
*
*  General Alerts
*
*  For example: timer.device cannot open math.library would be 0x05038015
*
*       Alert(AN_TimerDev|AG_OpenLib|AO_MathLib);
*
*********************************************************************/

/*------ alert types */
NATIVE {AT_DeadEnd}      CONST AT_DEADEND      = $80000000
NATIVE {AT_Recovery}     CONST AT_RECOVERY     = $00000000

/*------ general purpose alert codes */
NATIVE {AG_NoMemory}     CONST AG_NOMEMORY     = $00010000
NATIVE {AG_MakeLib}      CONST AG_MAKELIB      = $00020000
NATIVE {AG_OpenLib}      CONST AG_OPENLIB      = $00030000
NATIVE {AG_OpenDev}      CONST AG_OPENDEV      = $00040000
NATIVE {AG_OpenRes}      CONST AG_OPENRES      = $00050000
NATIVE {AG_IOError}      CONST AG_IOERROR      = $00060000
NATIVE {AG_NoSignal}     CONST AG_NOSIGNAL     = $00070000
NATIVE {AG_BadParm}      CONST AG_BADPARM      = $00080000
NATIVE {AG_CloseLib}     CONST AG_CLOSELIB     = $00090000 /* usually too many closes */
NATIVE {AG_CloseDev}     CONST AG_CLOSEDEV     = $000A0000 /* or a mismatched close */
NATIVE {AG_ProcCreate}   CONST AG_PROCCREATE   = $000B0000 /* Process creation failed */
NATIVE {AG_Obsolete}     CONST AG_OBSOLETE     = $000C0000 /* Obsolete feature used */

/*------ alert objects: */
NATIVE {AO_ExecLib}      CONST AO_EXECLIB      = $00008001
NATIVE {AO_GraphicsLib}  CONST AO_GRAPHICSLIB  = $00008002
NATIVE {AO_LayersLib}    CONST AO_LAYERSLIB    = $00008003
NATIVE {AO_Intuition}    CONST AO_INTUITION    = $00008004
NATIVE {AO_MathLib}      CONST AO_MATHLIB      = $00008005
NATIVE {AO_DOSLib}       CONST AO_DOSLIB       = $00008007
NATIVE {AO_RAMLib}       CONST AO_RAMLIB       = $00008008
NATIVE {AO_IconLib}      CONST AO_ICONLIB      = $00008009
NATIVE {AO_ExpansionLib} CONST AO_EXPANSIONLIB = $0000800A
NATIVE {AO_DiskfontLib}  CONST AO_DISKFONTLIB  = $0000800B
NATIVE {AO_UtilityLib}   CONST AO_UTILITYLIB   = $0000800C
NATIVE {AO_KeyMapLib}    CONST AO_KEYMAPLIB    = $0000800D

NATIVE {AO_AudioDev}     CONST AO_AUDIODEV     = $00008010
NATIVE {AO_ConsoleDev}   CONST AO_CONSOLEDEV   = $00008011
NATIVE {AO_GamePortDev}  CONST AO_GAMEPORTDEV  = $00008012
NATIVE {AO_KeyboardDev}  CONST AO_KEYBOARDDEV  = $00008013
NATIVE {AO_TrackDiskDev} CONST AO_TRACKDISKDEV = $00008014
NATIVE {AO_TimerDev}     CONST AO_TIMERDEV     = $00008015

NATIVE {AO_CIARsrc}      CONST AO_CIARSRC      = $00008020
NATIVE {AO_DiskRsrc}     CONST AO_DISKRSRC     = $00008021
NATIVE {AO_MiscRsrc}     CONST AO_MISCRSRC     = $00008022

NATIVE {AO_BootStrap}    CONST AO_BOOTSTRAP    = $00008030
NATIVE {AO_Workbench}    CONST AO_WORKBENCH    = $00008031
NATIVE {AO_DiskCopy}     CONST AO_DISKCOPY     = $00008032
NATIVE {AO_GadTools}     CONST AO_GADTOOLS     = $00008033
NATIVE {AO_Unknown}      CONST AO_UNKNOWN      = $00008035

/*********************************************************************
*
*   Specific Alerts:
*
*   For example:   exec.library -- corrupted memory list
*
*           ALERT  AN_MemCorrupt        ;8100 0005
*
*********************************************************************/

/*------ exec.library */
NATIVE {AN_ExecLib}      CONST AN_EXECLIB      = $01000000
NATIVE {AN_ExcptVect}    CONST AN_EXCPTVECT    = $01000001 /* 68000 exception vector checksum (obs.) */
NATIVE {AN_BaseChkSum}   CONST AN_BASECHKSUM   = $01000002 /* Execbase checksum (obs.) */
NATIVE {AN_LibChkSum}    CONST AN_LIBCHKSUM    = $01000003 /* Library checksum failure */
NATIVE {AN_IFaceChkSum}  CONST AN_IFACECHKSUM  = $01000004 /* Interface checksum failure */

NATIVE {AN_MemCorrupt}   CONST AN_MEMCORRUPT   = $81000005 /* Corrupt memory list detected in FreeMem */
NATIVE {AN_IntrMem}      CONST AN_INTRMEM      = $81000006 /* No memory for interrupt servers */
NATIVE {AN_InitAPtr}     CONST AN_INITAPTR     = $01000007 /* InitStruct() of an APTR source (obs.) */
NATIVE {AN_SemCorrupt}   CONST AN_SEMCORRUPT   = $01000008 /* A semaphore is in an illegal state
                                        at ReleaseSemaphore() */
NATIVE {AN_FreeTwice}    CONST AN_FREETWICE    = $01000009 /* Freeing memory already freed */
NATIVE {AN_BogusExcpt}   CONST AN_BOGUSEXCPT   = $8100000A /* illegal 68k exception taken (obs.) */
NATIVE {AN_IOUsedTwice}  CONST AN_IOUSEDTWICE  = $0100000B /* Attempt to reuse active IORequest */
NATIVE {AN_MemoryInsane} CONST AN_MEMORYINSANE = $0100000C /* Sanity check on memory list failed
                                        during AvailMem(MEMF_LARGEST) */
NATIVE {AN_IOAfterClose} CONST AN_IOAFTERCLOSE = $0100000D /* IO attempted on closed IORequest */
NATIVE {AN_StackProbe}   CONST AN_STACKPROBE   = $0100000E /* Stack appears to extend out of range */
NATIVE {AN_BadFreeAddr}  CONST AN_BADFREEADDR  = $0100000F /* Memory header not located. [ Usually an
                                        invalid address passed to FreeMem() ] */
NATIVE {AN_BadSemaphore} CONST AN_BADSEMAPHORE = $01000010 /* An attempt was made to use the old
                                        message semaphores. */
NATIVE {AN_BadMemory}    CONST AN_BADMEMORY    = $01000011 /* A bad memory request was made (Realloc
                                        on non-allocated memory) */
NATIVE {AN_BadHook}      CONST AN_BADHOOK      = $01000012 /* An uninitialized hook was called */

/*------ graphics.library */
NATIVE {AN_GraphicsLib}  CONST AN_GRAPHICSLIB  = $02000000
NATIVE {AN_GfxNoMem}     CONST AN_GFXNOMEM     = $82010000 /* graphics out of memory */
NATIVE {AN_GfxNoMemMspc} CONST AN_GFXNOMEMMSPC = $82010001 /* MonitorSpec alloc, no memory */
NATIVE {AN_LongFrame}    CONST AN_LONGFRAME    = $82010006 /* long frame, no memory */
NATIVE {AN_ShortFrame}   CONST AN_SHORTFRAME   = $82010007 /* short frame, no memory */
NATIVE {AN_TextTmpRas}   CONST AN_TEXTTMPRAS   = $02010009 /* text, no memory for TmpRas */
NATIVE {AN_BltBitMap}    CONST AN_BLTBITMAP    = $8201000A /* BltBitMap, no memory */
NATIVE {AN_RegionMemory} CONST AN_REGIONMEMORY = $8201000B /* regions, memory not available */
NATIVE {AN_MakeVPort}    CONST AN_MAKEVPORT    = $82010030 /* MakeVPort, no memory */
NATIVE {AN_GfxNewError}  CONST AN_GFXNEWERROR  = $0200000C
NATIVE {AN_GfxFreeError} CONST AN_GFXFREEERROR = $0200000D

NATIVE {AN_GfxNoLCM}     CONST AN_GFXNOLCM     = $82011234 /* emergency memory not available */

NATIVE {AN_ObsoleteFont} CONST AN_OBSOLETEFONT = $02000401 /* unsupported font description used */

/*------ layers.library */
NATIVE {AN_LayersLib}    CONST AN_LAYERSLIB    = $03000000
NATIVE {AN_LayersNoMem}  CONST AN_LAYERSNOMEM  = $83010000 /* layers out of memory */

/*------ intuition.library */
NATIVE {AN_Intuition}    CONST AN_INTUITION    = $04000000
NATIVE {AN_GadgetType}   CONST AN_GADGETTYPE   = $84000001 /* unknown gadget type */
NATIVE {AN_BadGadget}    CONST AN_BADGADGET    = $04000001 /* Recovery form of AN_GadgetType */
NATIVE {AN_CreatePort}   CONST AN_CREATEPORT   = $84010002 /* create port, no memory */
NATIVE {AN_ItemAlloc}    CONST AN_ITEMALLOC    = $04010003 /* item plane alloc, no memory */
NATIVE {AN_SubAlloc}     CONST AN_SUBALLOC     = $04010004 /* sub alloc, no memory */
NATIVE {AN_PlaneAlloc}   CONST AN_PLANEALLOC   = $84010005 /* plane alloc, no memory */
NATIVE {AN_ItemBoxTop}   CONST AN_ITEMBOXTOP   = $84000006 /* item box top < RelZero */
NATIVE {AN_OpenScreen}   CONST AN_OPENSCREEN   = $84010007 /* open screen, no memory */
NATIVE {AN_OpenScrnRast} CONST AN_OPENSCRNRAST = $84010008 /* open screen, raster alloc, no memory */
NATIVE {AN_SysScrnType}  CONST AN_SYSSCRNTYPE  = $84000009 /* open sys screen, unknown type */
NATIVE {AN_AddSWGadget}  CONST AN_ADDSWGADGET  = $8401000A /* add SW gadgets, no memory */
NATIVE {AN_OpenWindow}   CONST AN_OPENWINDOW   = $8401000B /* open window, no memory */
NATIVE {AN_BadState}     CONST AN_BADSTATE     = $8400000C /* Bad State Return entering Intuition */
NATIVE {AN_BadMessage}   CONST AN_BADMESSAGE   = $8400000D /* Bad Message received by IDCMP */
NATIVE {AN_WeirdEcho}    CONST AN_WEIRDECHO    = $8400000E /* Weird echo causing incomprehension */
NATIVE {AN_NoConsole}    CONST AN_NOCONSOLE    = $8400000F /* couldn't open the Console Device */
NATIVE {AN_NoISem}       CONST AN_NOISEM       = $04000010 /* Intuition skipped obtaining a sem */
NATIVE {AN_ISemOrder}    CONST AN_ISEMORDER    = $04000011 /* Intuition obtained a sem in bad order */

/*------ math.library */
NATIVE {AN_MathLib}      CONST AN_MATHLIB      = $05000000

/*------ dos.library */
NATIVE {AN_DOSLib}       CONST AN_DOSLIB       = $07000000
NATIVE {AN_StartMem}     CONST AN_STARTMEM     = $07010001 /* no memory at startup */
NATIVE {AN_EndTask}      CONST AN_ENDTASK      = $07000002 /* EndTask didn't */
NATIVE {AN_QPktFail}     CONST AN_QPKTFAIL     = $07000003 /* Qpkt failure */
NATIVE {AN_AsyncPkt}     CONST AN_ASYNCPKT     = $07000004 /* Unexpected packet received */
NATIVE {AN_FreeVec}      CONST AN_FREEVEC      = $07000005 /* Freevec failed */
NATIVE {AN_DiskBlkSeq}   CONST AN_DISKBLKSEQ   = $07000006 /* Disk block sequence error */
NATIVE {AN_BitMap}       CONST AN_BITMAP       = $07000007 /* Bitmap corrupt */
NATIVE {AN_KeyFree}      CONST AN_KEYFREE      = $07000008 /* Key already free */
NATIVE {AN_BadChkSum}    CONST AN_BADCHKSUM    = $07000009 /* Invalid checksum */
NATIVE {AN_DiskError}    CONST AN_DISKERROR    = $0700000A /* Disk Error */
NATIVE {AN_KeyRange}     CONST AN_KEYRANGE     = $0700000B /* Key out of range */
NATIVE {AN_BadOverlay}   CONST AN_BADOVERLAY   = $0700000C /* Bad overlay */
NATIVE {AN_BadInitFunc}  CONST AN_BADINITFUNC  = $0700000D /* Invalid init packet for cli/shell */
NATIVE {AN_FileReclosed} CONST AN_FILERECLOSED = $0700000E /* A filehandle was closed more than once */
NATIVE {AN_NoBootNode}   CONST AN_NOBOOTNODE   = $0700000F /* No bootnode found in eb_MountList */

/*------ ramlib.library */
NATIVE {AN_RAMLib}       CONST AN_RAMLIB       = $08000000
NATIVE {AN_BadSegList}   CONST AN_BADSEGLIST   = $08000001 /* no overlays in library seglists */

/*------ icon.library */
NATIVE {AN_IconLib}      CONST AN_ICONLIB      = $09000000

/*------ expansion.library */
NATIVE {AN_ExpansionLib}     CONST AN_EXPANSIONLIB     = $0A000000
NATIVE {AN_BadExpansionFree} CONST AN_BADEXPANSIONFREE = $0A000001 /* freed free region */

/*------ diskfont.library */
NATIVE {AN_DiskfontLib}  CONST AN_DISKFONTLIB  = $0B000000

/*------ audio.device */
NATIVE {AN_AudioDev}     CONST AN_AUDIODEV     = $10000000

/*------ console.device */
NATIVE {AN_ConsoleDev}   CONST AN_CONSOLEDEV   = $11000000
NATIVE {AN_NoWindow}     CONST AN_NOWINDOW     = $11000001 /* Console can't open initial window */

/*------ gameport.device */
NATIVE {AN_GamePortDev}  CONST AN_GAMEPORTDEV  = $12000000

/*------ keyboard.device */
NATIVE {AN_KeyboardDev}  CONST AN_KEYBOARDDEV  = $13000000

/*------ trackdisk.device */
NATIVE {AN_TrackDiskDev} CONST AN_TRACKDISKDEV = $14000000
NATIVE {AN_TDCalibSeek}  CONST AN_TDCALIBSEEK  = $14000001 /* calibrate: seek error */
NATIVE {AN_TDDelay}      CONST AN_TDDELAY      = $14000002 /* delay: error on timer wait */

/*------ timer.device */
NATIVE {AN_TimerDev}     CONST AN_TIMERDEV     = $15000000
NATIVE {AN_TMBadReq}     CONST AN_TMBADREQ     = $15000001 /* bad request */
NATIVE {AN_TMBadSupply}  CONST AN_TMBADSUPPLY  = $15000002 /* power supply -- no 50/60Hz ticks */

/*------ cybppc.device */
NATIVE {AN_CybppcDev}    CONST AN_CYBPPCDEV    = $16000000
NATIVE {AN_CybppcNoTerm} CONST AN_CYBPPCNOTERM = $16000001 /* no termination */
NATIVE {AN_CybppcNoWide} CONST AN_CYBPPCNOWIDE = $16000002 /* no wide termination */

/*------ cia.resource */
NATIVE {AN_CIARsrc}      CONST AN_CIARSRC      = $20000000

/*------ disk.resource */
NATIVE {AN_DiskRsrc}     CONST AN_DISKRSRC     = $21000000
NATIVE {AN_DRHasDisk}    CONST AN_DRHASDISK    = $21000001 /* get unit: already has disk */
NATIVE {AN_DRIntNoAct}   CONST AN_DRINTNOACT   = $21000002 /* interrupt: no active unit */

/*------ misc.resource */
NATIVE {AN_MiscRsrc}     CONST AN_MISCRSRC     = $22000000

/*------ bootstrap */
NATIVE {AN_BootStrap}    CONST AN_BOOTSTRAP    = $30000000
NATIVE {AN_BootError}    CONST AN_BOOTERROR    = $30000001 /* boot code returned an error */

/*------ Workbench */
NATIVE {AN_Workbench}          CONST AN_WORKBENCH          = $31000000
NATIVE {AN_NoFonts}            CONST AN_NOFONTS            = $B1000001
NATIVE {AN_WBBadStartupMsg1}   CONST AN_WBBADSTARTUPMSG1   = $31000001
NATIVE {AN_WBBadStartupMsg2}   CONST AN_WBBADSTARTUPMSG2   = $31000002
NATIVE {AN_WBBadIOMsg}         CONST AN_WBBADIOMSG         = $31000003 /* Hacker code? */
NATIVE {AN_WBReLayoutToolMenu} CONST AN_WBRELAYOUTTOOLMENU = $B1010009 /* GadTools broke? */

/*------ DiskCopy */
NATIVE {AN_DiskCopy}     CONST AN_DISKCOPY     = $32000000

/*------ toolkit for Intuition */
NATIVE {AN_GadTools}     CONST AN_GADTOOLS     = $33000000

/*------ System utility library */
NATIVE {AN_UtilityLib}   CONST AN_UTILITYLIB   = $34000000

/*------ For use by any application that needs it */
NATIVE {AN_Unknown}      CONST AN_UNKNOWN      = $35000000
