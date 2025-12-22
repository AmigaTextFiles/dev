OPT MODULE

EXPORT PROC puts(str)

  MOVEA.L  str,A0
  MOVE.L   A0,D2
len:
  TST.B    (A0)+
  BNE.S    len
  MOVE.L   A0,D3
  SUB.L    D2,D3
  MOVEA.L  A0,A2
  SUBQ.W   #1,A2
  MOVE.B   #10,(A2)
  MOVEA.L  dosbase,A6
  MOVE.L   stdout,D1
  JSR      Write(A6)
  CLR.B    (A2)

ENDPROC

EXPORT PROC putc(char)

  MOVE.L  stdout,D1
  SUBQ.W  #4,A7
  MOVEA.L A7,A0
  MOVE.L  A7,D2
  MOVE.L  char,D0
  MOVE.B  D0,(A0)+
  MOVE.B  #10,(A0)
  MOVEQ   #2,D3
  MOVEA.L dosbase,A6
  JSR     Write(A6)
  ADDQ.W  #4,A7

ENDPROC


  
  
