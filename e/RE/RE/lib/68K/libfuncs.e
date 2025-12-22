/*
** the main standard four functions
*/
OPT NOHEAD,NOEXE

MODULE 'exec/libraries','exec'

OBJECT LibMinBase
  library   :Library
  flags     :BYTE
  pad       :BYTE
  segment   :LONG
ENDOBJECT

LIBRARY LINK
 customInitLib(base),
 customOpenLib(base),
 customCloseLib(base),
 customExpungeLib(base)

PROC LibInit(base:PTR TO LibMinBase REG d0,segment REG a0)

  ExecBase := Long(4)

  base.segment:=segment
    
  IFN customInitLib(base)
    LibExpunge(base)
    base:=0
  ENDIF

ENDPROC base
PROC LibOpen(base:PTR TO LibMinBase REG a6)

  IFN customOpenLib(base) THEN RETURN 0
  base.library.Flags &=~LIBF_DELEXP
  base.library.OpenCnt +=1

ENDPROC base
PROC LibClose(base:PTR TO LibMinBase REG a6)
  
  customCloseLib(base)
  IFN base.library.OpenCnt -=1
    IF base.library.Flags & LIBF_DELEXP THEN RETURN LibExpunge(base)
  ENDIF

ENDPROC 0
PROC LibExpunge(base:PTR TO LibMinBase REG a6)
  DEF rc
  
  IF base.library.OpenCnt
    base.library.Flags |=LIBF_DELEXP
    RETURN 0
  ENDIF
  customExpungeLib(base)
  Remove(base)
  rc:=base.segment
  FreeMem(base-base.library.NegSize,base.library.NegSize+base.library.PosSize)

ENDPROC rc

