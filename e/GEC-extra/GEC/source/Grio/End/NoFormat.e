
MODULE 'devices/trackdisk'
MODULE 'exec/execbase','exec/io'
MODULE 'dos/dos'

CONST COMMAND=28,OFFSET=44,ERROR=31


PROC main()
DEF devbase,oldfunc,sysbase:PTR TO execbase
IF (0=arg[]) OR ("?"=arg[])
   WriteF('USAGE: <device>\n')
   RETURN 5
ENDIF
sysbase:=execbase
Forbid()
devbase:=FindName(sysbase.devicelist,arg)
Permit()
IF devbase
   Forbid()
   IF (oldfunc:=SetFunction(devbase,DEV_BEGINIO,{noformat}))
      PutLong({oldfunction}+2,oldfunc)
      Permit()
      Wait(SIGBREAKF_CTRL_C)
      Forbid()
      SetFunction(devbase,DEV_BEGINIO,oldfunc)
      Permit()
   ELSE
      Permit()
      WriteF('SetFunction() failed!\n')
   ENDIF
ELSE
   WriteF('Can\at find device "\s"\n',arg)
ENDIF
ENDPROC


noformat:
  MOVEM.L D0/A0,-(A7)
  MOVE.L  A1,D0
  BEQ.S   exit
  LEA     COMMAND(A1),A0
  MOVEQ   #TD_FORMAT,D0
  CMP.W   (A0),D0
  BEQ.S   quit
  MOVEQ   #CMD_WRITE,D0
  CMP.W   (A0),D0
  BEQ.S   testoffset
  MOVEQ   #CMD_UPDATE,D0
  CMP.W   (A0),D0
  BNE.S   work
testoffset:
  LEA     OFFSET(A1),A0
  TST.L   (A0)
  BEQ.S   quit
  MOVEQ   #1,D0
  CMP.L   (A0),D0
  BNE.S   work
quit:
  MOVEQ   #TDERR_WRITEPROT,D0
  MOVE.B  D0,ERROR(A1)
exit:
  MOVEM.L (A7)+,D0/A0
  RTS


work:
  MOVEM.L (A7)+,D0/A0
oldfunction:
  JMP     $0.L

CHAR '$VER: NoFormat 1.0 (19.02.98) by Grio',0

