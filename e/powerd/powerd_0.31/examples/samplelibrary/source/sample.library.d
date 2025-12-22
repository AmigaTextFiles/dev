/*****************************************************************/

OPT NOHEAD

MODULE 'exec',
       'exec/execbase',
       'exec/libraries',
       'exec/nodes',
       'exec/resident'

OBJECT LibBase
  library :Library,
  flags   :BYTE,
  pad     :BYTE,
  segment :BPTR
/*
here we could add a semaphore, pointers to library bases (dosbase etc.) etc.
*/
ENDOBJECT

#define LibVersion 1
#define LibRevision 0
#define libname 'sample.library'
#define LibCopyright(ver,rev) ' v ver.rev (\x3d) (C) Marco Antoniazzi'

DEF ExecBase

/* Add these if you PrintF() something
DEF stdin,stdout
*/

/* Avoid execution and LibNull all in once */
APROC LibNull()
  move.l #0,d0
ENDPROC

/* this static structure must be here. This is an AUTOINIT library */
Romtag:
  WORD RTC_MATCHWORD
  LONG Romtag,EndRom
  BYTE RTF_AUTOINIT,LibVersion,NT_LIBRARY,0
  LONG LibName,LibIDString,LibInitTable
EndRom:
  WORD 0

/* the 4 magic LONGs for Autoinit libraries. */
LibInitTable:
  LONG SIZEOF_LibBase,LibVectors,LibData,LibInit

/* our functions. 1st 4 are fixed */
LibVectors:
  LONG LibOpen,LibClose,LibExpunge,LibNull
/* Here we must add all the functions of our library, which must
match exactly (also in the same order) those of the corrisponding .m file */
  LONG Subtract

  LONG -1   /* terminator */
  
LibData:
  BYTE $a0,8,9,0,$80,10   /* some "magic" numbers ;) */
  LONG LibName
  BYTE $a0,14,6,0,$90,20  /* more "magic" numbers ;) */
  WORD LibVersion
  BYTE $90,22             /* more "magic" numbers ;) */
  WORD LibRevision
  BYTE $80,24             /* more "magic" numbers ;) */
  LONG LibIDString
  LONG 0   /* terminator */

LibName:
  BYTE libname,0
LibIDString:      /* make the version string */
  BYTE '$VER: ',libname,LibCopyright(LibVersion,LibRevision),0

PROC LibInit(base:PTR TO LibBase IN d0,segment IN a0)(PTR TO LibBase)

  base.segment:=segment
    
  IFN myInitLib(base)
    LibExpunge(base)
    base:=0
  ENDIF

ENDPROC base

PROC LibOpen(base:PTR TO LibBase IN a6)(PTR TO LibBase)
  
  IFN myOpenLib(base) THEN RETURN 0
  base.library.Flags &=~LIBF_DELEXP
  base.library.OpenCnt++

ENDPROC base

PROC LibClose(base:PTR TO LibBase IN a6)(LONG)
  
  myCloseLib(base)
  IFN --base.library.OpenCnt
    IF base.library.Flags & LIBF_DELEXP THEN RETURN LibExpunge(base)
  ENDIF

ENDPROC 0

PROC LibExpunge(base:PTR TO LibBase IN a6)(LONG)
  DEF rc
  
  IF base.library.OpenCnt
    base.library.Flags |=LIBF_DELEXP
    RETURN 0
  ENDIF
  myExpungeLib(base)
  Remove(base)
  rc:=base.segment
  FreeMem(base-base.library.NegSize,base.library.NegSize+base.library.PosSize)

ENDPROC rc

/* here we could open libraries, allocate some "global" memory ecc. */
PROC myInitLib(base:PTR TO LibBase)(LONG)
/*
  IF OpenLibrary(...)
    stdout:=Output() ; stdin:=Input()
    RETURN TRUE
  ENDIF
*/
ENDPROC FALSE

PROC myOpenLib(base:PTR TO LibBase)(LONG)
ENDPROC TRUE

PROC myCloseLib(base:PTR TO LibBase)(LONG)
ENDPROC TRUE

/* here we could deallocate "global" memory ecc. */
PROC myExpungeLib(base:PTR TO LibBase)
/* no need to check for null conditions because it's done by the functions
  CloseLibrary(...)
*/
ENDPROC


PROC Subtract(a IN d0,b IN d1)(LONG)
ENDPROC a-b

/*****************************************************************/


