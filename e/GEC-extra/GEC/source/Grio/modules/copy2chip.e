OPT MODULE


EXPORT PROC copy2Chip(dataptr,size) HANDLE
  MOVE.L   dataptr,D0
  BEQ.S    quit
  MOVEA.L  execbase,A6
  MOVE.L   D0,-(A7)
  MOVEA.L  D0,A1
  JSR      TypeOfMem(A6)
  MOVEQ    #2,D1
  AND.L    D1,D0
  BNE.S    nomem
  ADDQ.L   #4,A7
  MOVE.L   size,D0
  BEQ.B    quit
  ADDQ.L   #3,D0
  MOVEQ    #-4,D1
  AND.L    D1,D0
  MOVE.L   D0,size
  NewM     (size,2)
  MOVE.L   D0,-(A7)
  BEQ.B    nomem
  MOVEA.L  D0,A1
  MOVEA.L  dataptr,A0
  MOVE.L   size,D0
  JSR      CopyMemQuick(A6)
nomem:
  MOVE.L   (A7)+,D0
quit:
EXCEPT DO
ENDPROC D0






