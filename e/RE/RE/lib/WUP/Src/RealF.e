
OPT NOEXE,NOHEAD,CPU='WUP'

PROC RealF(str:PTR TO CHAR,f,n=1)
  DEF  top,neg=NIL,rest
  DEF  buf[24]:ARRAY    -> this is large enough

  IF !f<0.0
    neg:='-'
    f:=!-f
  ENDIF
  top:=!f!
  IF n=0
    f:=0.0
  ELSE
    IF !f<(top!) THEN top--
    rest:=!(f-(top!))
    ->f:=!rest*1000000000.0! ->transform mantissa to integer
    f:=!rest*Fpow(10.0,n!)!->transform mantissa to integer with rounding
  ENDIF

  StringF(buf,'\s\d.',neg,top)
  StrCopy(str,buf,StrLen(buf))
  StringF(buf,'\z\d[9]',f)
  StrAdd(str,buf+9-n,StrLen(buf)-9+n)
ENDPROC str
