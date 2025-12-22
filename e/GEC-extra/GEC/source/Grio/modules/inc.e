OPT MODULE
OPT EXPORT

PROC inc(adr,value=1)
 MOVE.L  adr,A0
 MOVE.L  value,D0
 ADD.L   D0,(A0)
ENDPROC D0

