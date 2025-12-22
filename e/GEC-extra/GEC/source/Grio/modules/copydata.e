OPT MODULE

MODULE 'grio/newm'


EXPORT PROC copyData(dataptr,size,memtype=2)
  MOVE.L   size,D0
  BEQ.B    quit
  ADDQ.L   #3,D0
  MOVEQ    #-4,D1
  AND.L    D1,D0
  MOVE.L   D0,size
  newM     (size,memtype)
  MOVE.L   D0,-(A7)
  BEQ.B    nomem
  MOVEA.L  D0,A1
  MOVEA.L  dataptr,A0
  MOVE.L   size,D0
  JSR      CopyMemQuick(A6)
nomem:
  MOVE.L   (A7)+,D0
quit:
ENDPROC D0






