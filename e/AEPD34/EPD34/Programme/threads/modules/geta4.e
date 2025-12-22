-> geta4.e - store and get the global data pointer kept in register A4

OPT MODULE

EXPORT PROC storea4()
  LEA a4storage(PC),A0
  MOVE.L A4,(A0)
ENDPROC

EXPORT PROC geta4()
  LEA a4storage(PC),A0
  MOVE.L (A0),A4
ENDPROC

a4storage:
  LONG NIL

