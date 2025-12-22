OPT MODULE

EXPORT PROC installhook(hook,func)
  MOVE.L  hook,A0
  MOVE.L  func,12(A0)
  LEA     hookentry(PC),A1
  MOVE.L  A1,8(A0)
  MOVE.L  A4,16(A0)
  MOVE.L  A0,D0
ENDPROC D0

hookentry:
  MOVEM.L D2-D7/A2-A6,-(A7)
  MOVE.L  16(A0),A4
  MOVE.L  A0,-(A7)
  MOVE.L  A2,-(A7)
  MOVE.L  A1,-(A7)
  MOVE.L  12(A0),A0
  JSR     (A0)
  LEA     12(A7),A7
  MOVEM.L (A7)+,D2-D7/A2-A6
  RTS
