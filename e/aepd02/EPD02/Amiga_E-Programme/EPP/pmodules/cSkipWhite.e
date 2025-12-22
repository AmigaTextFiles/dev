OPT TURBO

PROC cSkipWhite (pos : PTR TO CHAR)
  DEF c

  /*----------------------------------------------------------------------*/
  /* pos must point into a null-terminated string!                        */
  /* pos must be passed by value!                                         */
  /* pos must not point beyond the end of the string when it's passed in! */
  /*                                                                      */
  /* Skips SPACE, TAB, LF, CR.  Returns end pos so that the following     */
  /* statement sequence can be used in the calling program:               */
  /*   length := (cSkipWhite (startPos) - startPos)                       */
  /*   MidStr (someString, startPos, 0, length)                           */
  /*                                                                      */
  /* If you use the string with index method in your main program, you    */
  /* can get the PTR TO CHAR pos by using:                                */
  /*   length := (cSkipWhite (string + index) - (string + index))         */
  /*   MidStr (someString, string, index, length)                         */
  /*----------------------------------------------------------------------*/

  WHILE (c := pos [])
    SELECT c
      CASE 32; INC pos  /* SPACE */
      CASE  9; INC pos  /* TAB */
      CASE 10; INC pos  /* LF */
      DEFAULT; RETURN pos
    ENDSELECT
  ENDWHILE

ENDPROC  pos
  /* cSkipWhite */

