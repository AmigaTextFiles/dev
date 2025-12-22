/*

THIS IS COMPILED TO 68K NOT PPC!
*/
OPT NOHEAD,NOEXE

MODULE 
  'exec','exec/libraries','powerpc','powerpc/powerpc'

OBJECT LibMinBase
  library   :Library
  flags     :BYTE
  pad       :BYTE
  segment   :LONG
->  stack     :LONG
ENDOBJECT

LIBRARY LINK
 customInitLib(base),
 customOpenLib(base),
 customCloseLib(base),
 customExpungeLib(base)

->IMPORT DEF PowerPCBase
DEF stk:PTR TO LONG
DEF ppcstruct:PPCArgs

PROC pushregs(a REG d0)='movem.l\td0-d7/a0-a6,-(a7)'
PROC popregs(a REG d0)='movem.l\t(a7)+,d0-d7/a0-a6'

PROC LibNull()
ENDPROC 0

__getA7:WORD 0  ->WARNING:align to 32 bit (if put after LibNull)
LONG $7C7E1B78,$4E800020 ->PPC code:mr r30,d0; blr

PROC LibInit(base:PTR TO LibMinBase REG d0,segment REG a0)
  pushregs(0)

  ExecBase := Long(4)

  base.segment:=segment
  IF PowerPCBase:=OpenLibrary('powerpc.library',7)
ASM
	xref	_LinkerDB
	lea	_LinkerDB,a4	; get local data
	lea	_ppcstruct,a0
	move.l	a4,$44(a0)	; store a4/r2
ENDASM
  ->allocate own stack to be able to call custom functions
    stk:=AllocVec($1000,$10005)
    ->base.stack:=stk
    ppcstruct.Code := &__getA7
    ppcstruct.Regs[PPREG_D0] := (stk+32 + 31) AND NOT 31 ->round up to 32
    RunPPC(ppcstruct)
    ppcstruct.Code := &customInitLib
    ppcstruct.Regs[PPREG_D0] := base
    RunPPC(ppcstruct)
    IFN ppcstruct.Regs[PPREG_D0]
      LibExpunge(base)
      base:=0
    ENDIF
  ELSE
    base:=0
  ENDIF
  popregs(0)
ENDPROC base
PROC LibOpen(base:PTR TO LibMinBase REG a6)
  
  ppcstruct.Code := &__getA7
  ppcstruct.Regs[PPREG_D0] := (stk+32 + 31) AND NOT 31 ->round up to 32
  RunPPC(ppcstruct)
  ppcstruct.Code := &customOpenLib
  ppcstruct.Regs[0] := base
  RunPPC(ppcstruct)
  IFN ppcstruct.Regs[0] THEN RETURN 0

  base.library.Flags &=~LIBF_DELEXP
  base.library.OpenCnt +=1

ENDPROC base
PROC LibClose(base:PTR TO LibMinBase REG a6)
  
  ppcstruct.Code := &__getA7
  ppcstruct.Regs[PPREG_D0] := (stk+32 + 31) AND NOT 31 ->round up to 32
  RunPPC(ppcstruct)
  ppcstruct.Code := &customCloseLib
  ppcstruct.Regs[0] := base
  RunPPC(ppcstruct)

  IFN base.library.OpenCnt -=1
    IF base.library.Flags & LIBF_DELEXP THEN RETURN LibExpunge(base)
  ENDIF

ENDPROC 0
PROC LibExpunge(base:PTR TO LibMinBase REG a6)
  DEF rc

  pushregs(0)
  IF base.library.OpenCnt
    base.library.Flags |=LIBF_DELEXP
    RETURN 0
  ENDIF

  ppcstruct.Code := &__getA7
  ppcstruct.Regs[PPREG_D0] := (stk+32 + 31) AND NOT 31 ->round up to 32
  RunPPC(ppcstruct)
  ppcstruct.Code := &customExpungeLib
  ppcstruct.Regs[0] := base
  RunPPC(ppcstruct)

  FreeVec(stk)
  CloseLibrary(PowerPCBase)
  Remove(base)
  rc:=base.segment
  FreeMem(base-base.library.NegSize,base.library.NegSize+base.library.PosSize)
  popregs(0)
ENDPROC rc
