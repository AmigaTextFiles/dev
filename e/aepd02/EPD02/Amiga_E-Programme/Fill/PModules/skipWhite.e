PROC skipWhite (theString,  /* PTR TO STRING */
                startPos)   /* Char index into theString, passed by value */
  DEF endPos, length

  /* Skips SPACE, TAB, LF, CR.  Returns endPos so that                    */
  /* MidStr (someString, theString, startPos, (endPos - startPos)) can be */
  /* used in the calling program.                                         */
  /* Return of -1 indicates access beyond end of string.                  */

  length := StrLen (theString)
  IF startPos >= length THEN RETURN startPos

  endPos := startPos
  WHILE (endPos < length) AND
        ((theString [endPos] = " ") OR
         (theString [endPos] = 9) OR   /* TAB */
         (theString [endPos] = 10) OR  /* LF */
         (theString [endPos] = 13))    /* CR */ DO INC endPos

ENDPROC  endPos
  /* skipWhite */

