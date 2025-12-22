PROC skipNonWhite (theString,  /* PTR TO STRING */
                   startPos)   /* Char index into theString, passed by value */
  DEF endPos, length

  /* Stops at SPACE, TAB, LF, CR.  Returns endPos so that                 */
  /* MidStr (someString, theString, startPos, (endPos - startPos)) can be */
  /* used in the calling program.                                         */
  /* Return of -1 indicates access beyond end of string.                  */

  length := StrLen (theString)
  IF startPos >= length THEN RETURN startPos

  endPos := startPos
  WHILE (endPos < length) AND
        ((theString [endPos] <> " ") AND
         (theString [endPos] <> 9) AND   /* TAB */
         (theString [endPos] <> 10) AND  /* LF */
         (theString [endPos] <> 13))     /* CR */ DO INC endPos

ENDPROC  endPos
  /* skipNonWhite */

