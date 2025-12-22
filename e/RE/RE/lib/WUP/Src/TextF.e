/*
*/
OPT NOHEAD,NOEXE,CPU='WUP'
MODULE 'exec','graphics','powerpc'
PROC TextF(x,y,fmtstring,params:LIST OF LONG)
  DEF buffer[512]:STRING
  IF stdrast
    RawDoFmtPPC(fmtstring,params,0,buffer)
    Move(stdrast,x,y)
    Text(stdrast,buffer,StrLen(buffer))
  ENDIF
ENDPROC
