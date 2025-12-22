/* easy float parsing for E v2.1, by wouter! */

ENUM ER_FLOAT

PROC main() HANDLE
  DEF x:PTR TO LONG			/* test routine */
  ForAll({x},
    [[3.14159,'3.14159'],
     [SpNeg(.001),'    -.001       '],
     [1.,'1.']],
    `WriteF(IF floatvalue(x[1])=x[0] THEN 'Ok!\n' ELSE 'Send bug report!\n'))
EXCEPT
  IF exception=ER_FLOAT
    WriteF('Problems with float format\n')
  ENDIF
ENDPROC

/* floatvalue: in goes a nil-terminated string, out comes an FFP float!
   note that "num" and "com" contain the float in int format: com is
   the amount num should be divided with to obtain the float value.
   NOTE: this function raises an ER_FLOAT exception if something
   goes wrong: replace the Raise() statement if you don't like this. */

PROC floatvalue(str)
  DEF neg=FALSE,num=0,com=1
  WHILE str[]=" " DO INC str		/* deal with leading spaces */
  IF str[]="-"				/* accept negative numbers also */
    INC str
    neg:=TRUE
  ENDIF
  WHILE (str[]>="0") AND (str[]<="9") DO num:=str[]++-"0"+(num*10)
  IF str[]="."
    INC str
    WHILE (str[]>="0") AND (str[]<="9")
      num:=str[]++-"0"+(num*10)
      com:=Mul(com,10)
    ENDWHILE
  ENDIF
  WHILE str[]=" " DO INC str		/* cleanup trailing spaces */
  IF str[]<>0 THEN Raise(ER_FLOAT) ELSE IF neg THEN num:=-num
ENDPROC SpDiv(SpFlt(com),SpFlt(num))
