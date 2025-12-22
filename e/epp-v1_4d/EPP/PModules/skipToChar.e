OPT TURBO

PROC skipToChar(char, theString:PTR TO CHAR, pos)
  DEF length
  /* Finds the specified character in theString and returns its position. */
  length:=StrLen(theString)
  WHILE pos<length
    IF theString[pos]=char THEN RETURN pos
    INC pos
  ENDWHILE
ENDPROC pos
  /* skipToChar */

