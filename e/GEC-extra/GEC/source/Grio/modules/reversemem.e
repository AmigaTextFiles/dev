OPT MODULE

EXPORT PROC reversemem(source,dest,size)
  MOVE.L  size,D0
  MOVEA.L source,A0
  ADDA.L  D0,A0
  MOVEA.L dest,A1
  BRA.S   start
loop:
  MOVE.B  -(A0),(A1)+
start:
  DBF     D0,loop
ENDPROC D0



