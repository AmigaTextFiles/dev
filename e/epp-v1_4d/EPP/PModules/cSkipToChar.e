OPT TURBO

PROC cSkipToChar(char, pos:PTR TO CHAR)
  /* Finds the specified character in theString and returns its position. */
  WHILE pos[]
    IF pos[]=char THEN RETURN pos
    INC pos
  ENDWHILE
ENDPROC pos
  /* cSkipToChar */

