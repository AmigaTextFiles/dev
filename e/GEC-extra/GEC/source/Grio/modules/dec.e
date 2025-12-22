OPT MODULE
OPT EXPORT

PROC dec(adr,value=1)
 MOVE.L  adr,A0
 MOVE.L  value,D0
 SUB.L   D0,(A0)
ENDPROC D0

