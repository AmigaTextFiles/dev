OPT NOHEAD,NOEXE,CPU='WUP'
MODULE 'dos'
PROC ReadEStr(fh,estr)
  FGets(fh,estr,EStrMax(estr))
  SetEStr(estr,StrLen(estr)-1)
ENDPROC
