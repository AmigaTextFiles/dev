/*
*/
OPT NOHEAD,NOEXE
MODULE 'exec','graphics'
PROC TextF(x,y,fmtstring,params:LIST OF LONG)
  DEF buffer[512]:ARRAY
  IF stdrast
    RawDoFmt(fmtstring,params,'\j22\j192\j78\j117',buffer)
    Move(stdrast,x,y)
    Text(stdrast,buffer,StrLen(buffer))
  ENDIF
ENDPROC
