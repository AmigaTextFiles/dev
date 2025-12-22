OPT MODULE

MODULE 'grio/str/sprintf'


EXPORT PROC textf(rastport,x,y,fmt,args=0,buf=0)
 DEF      inbuf
 TST.L    fmt
 BEQ.S    quit
 MOVE.L   rastport,D0
 BEQ.S    quit
 MOVEA.L  D0,A1
 MOVE.L   buf,D0
 BNE.S    setbuf
 LEA      -512(A7),A7
 MOVE.L   A7,D0
setbuf:
 MOVE.L   D0,inbuf
 MOVEA.L  gfxbase,A6
 MOVE.L   x,D0
 MOVE.L   y,D1
 JSR      Move(A6)
 TST.L    args
 BNE.S    format
 MOVEA.L  fmt,A0
 MOVEA.L  inbuf,A1
 MOVE.L   A1,D0
copy:
 MOVE.B   (A0)+,(A1)+
 BNE.S    copy
 SUB.L    A1,D0
 NOT.L    D0
 BRA.S    puttext
format:
 sprintf  (inbuf,fmt,args)
puttext:
 MOVE.L   D0,D2
 MOVEA.L  gfxbase,A6
 MOVEA.L  rastport,A1
 MOVEA.L  inbuf,A0
 JSR      Text(A6)
 MOVE.L   D2,D0
quit:
ENDPROC D0


