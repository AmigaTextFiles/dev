OPT MODULE

MODULE 'utility/hooks'

EXPORT PROC inithook(hook:PTR TO hook, func, data=NIL)
  hook.subentry:=func
  hook.entry:={hookentry}
  hook.data:=data
  LEA.L storeA4(PC), A0  -> Copy A4 to safe place
  MOVE.L A4, (A0)
ENDPROC hook

storeA4:
  LONG 0

hookentry:
  MOVEM.L D2-D7/A2-A6,-(A7)  -> Save regs
  MOVE.L  A0,-(A7)           -> Stuff parameters on stack for proc call
  MOVE.L  A2,-(A7)
  MOVE.L  A1,-(A7)
  MOVE.L  storeA4(PC), A4    -> Reinstate A4
  MOVE.L  12(A0),A0          -> Get sub-entry
  JSR     (A0)               -> Execute function
  LEA     12(A7),A7          -> Remove parameters
  MOVEM.L (A7)+,D2-D7/A2-A6  -> Restore regs
  RTS
