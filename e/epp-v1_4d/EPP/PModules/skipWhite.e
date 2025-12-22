OPT TURBO

PROC skipWhite(theString:PTR TO CHAR, startPos)
  DEF length
  /* Skips SPACE, TAB, LF, CR.  Returns endPos so that                    */
  /* MidStr (someString, theString, startPos, (endPos - startPos)) can be */
  /* used in the calling program.                                         */
  /* Return of -1 indicates access beyond end of string.                  */
  length:=StrLen(theString)
  IF startPos>=length THEN RETURN startPos
  WHILE (startPos<length) AND
        ((theString[startPos]=" ") OR
         (theString[startPos]=9)   OR /* TAB */
         (theString[startPos]=10)  OR /* LF */
         (theString[startPos]=13))    /* CR */ DO INC startPos

ENDPROC startPos
  /* skipWhite */

