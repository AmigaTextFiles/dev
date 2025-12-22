OPT MODULE

CONST STARTV=1000000000


/* converts an filesize 'size' into estring 'stri'.
** 'stri' is returned.
** 'pointstri' is the used thousand seperator. If its NIL, a point is used.
*/
EXPORT PROC filesize2string(stri,size,pointstri=NIL)
DEF divi=STARTV,
    hsize,
    convstri,
    hstri[4]:STRING

  StrCopy(stri,'')
  convstri:='\d'
  IF pointstri=NIL THEN pointstri:='.'

  WHILE divi
    IF hsize:=Div(size,divi)
      StringF(hstri,convstri,hsize)
      StrAdd(stri,hstri,ALL)
      IF divi>1 THEN StrAdd(stri,pointstri,ALL)
      size:=size-Mul(hsize,divi)
      convstri:='\z\d[3]'
    ENDIF
    divi:=Div(divi,1000)
  ENDWHILE

ENDPROC stri

