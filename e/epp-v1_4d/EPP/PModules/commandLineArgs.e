OPT TURBO

PMODULE 'PMODULES:cSkipWhite'
PMODULE 'PMODULES:cSkipNonWhite'

PROC getArg(theArg:PTR TO CHAR, index)
  DEF startPos:PTR TO CHAR, numChars, i, length
  IF arg[]<=0
    StrCopy(theArg, '', ALL)
    RETURN FALSE
  ENDIF
  length:=StrLen(arg)
  startPos:=arg
  FOR i:=2 TO index
    startPos:=cSkipNonWhite(startPos)  /* Find next space. */
    startPos:=cSkipWhite(startPos)     /* Find start of next arg. */
    IF startPos[]=0
      /* End of string encountered before requested arg. */
      StrCopy(theArg, '', ALL)
      RETURN FALSE
    ENDIF
  ENDFOR
  numChars:=(cSkipNonWhite(startPos)-startPos)   /* Find end of arg. */
  MidStr(theArg, startPos, 0, numChars)
ENDPROC TRUE
  /* getArg */

