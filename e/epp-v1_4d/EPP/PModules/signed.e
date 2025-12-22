PROC signed (x)
  MOVE.L  x,D0
  EXT.L   D0
  MOVE.L  D0,x
ENDPROC x


