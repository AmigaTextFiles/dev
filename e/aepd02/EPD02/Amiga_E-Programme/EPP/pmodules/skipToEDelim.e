OPT TURBO

PROC skipToEDelim (theString, pos)
  DEF length, c

  /* Finds the next E delimiter in theString and returns its position. */

  length := StrLen (theString)
  WHILE pos < length
    c := theString [pos]
    IF ((c > 64) AND (c < 90))  /* A-Z */
      NOP
    ELSEIF ((c > 96) AND (c <123))  /* a-z */
      NOP
    ELSEIF ((c > 47) AND (c < 58))  /* 0-9 */
      NOP
    ELSEIF c = 95  /* underscore */
      NOP
    ELSE
      RETURN pos
    ENDIF
    INC pos
  ENDWHILE
ENDPROC  pos
  /* skipToEDelim */

