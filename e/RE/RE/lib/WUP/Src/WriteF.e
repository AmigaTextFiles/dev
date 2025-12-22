/*
*/
OPT NOHEAD,NOEXE,CPU='WUP'
MODULE 'dos'
IMPORT DEF stdout,conout
PROC WriteF(a,b=0:LIST OF LONG)
  VFPrintF(stdout:=IF stdout=0 THEN conout:=Open('con:0/11/640/80/output',1006) ELSE stdout,a,b)
ENDPROC