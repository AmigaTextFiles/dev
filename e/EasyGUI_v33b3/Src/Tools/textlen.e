OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition'

PROC textlen(s,ta) IS IF s THEN IntuiTextLength([0,0,0,0,0,ta,s,NIL]:intuitext) ELSE 0

PROC textlen_key(s,ta,key)
  DEF len=0
  IF s
    len:=textlen(s,ta)
    IF key
      IF InStr(s,'_')<>-1 THEN len:=len-textlen('_',ta)
    ENDIF
  ENDIF
ENDPROC len
