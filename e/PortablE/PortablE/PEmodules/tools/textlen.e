OPT MODULE
OPT EXPORT
OPT POINTER

MODULE 'intuition/intuition'
MODULE 'intuition', 'graphics/text'

PROC textlen(s:ARRAY OF CHAR,ta:PTR TO textattr) IS IF s THEN IntuiTextLength([0,0,0,0,0,ta,s,NIL]:intuitext) ELSE 0

PROC textlen_key(s:ARRAY OF CHAR,ta:PTR TO textattr,key)
  DEF len
  len:=0
  IF s
    len:=textlen(s,ta)
    IF key
      IF InStr(s,'_')<>-1 THEN len:=len-textlen('_',ta)
    ENDIF
  ENDIF
ENDPROC len
