OPT TURBO

PROC cSkipNonWhite (pos : PTR TO CHAR)

  /*----------------------------------------------------------------------*/
  /* pos must point into a null-terminated string!                        */
  /* pos must be passed by value!                                         */
  /* pos must not point beyond the end of the string when it's passed in! */
  /*                                                                      */
  /* Skips SPACE, TAB, LF, CR.  Returns end pos so that the following     */
  /* statement sequence can be used in the calling program:               */
  /*   length := (cSkipNonWhite (startPos) - startPos)                    */
  /*   MidStr (someString, startPos, 0, length)                           */
  /*                                                                      */
  /* If you use the string with index method in your main program, you    */
  /* can get the PTR TO CHAR pos by using:                                */
  /*   length := (cSkipNonWhite (string + index) - (string + index))      */
  /*   MidStr (someString, string, index, length)                         */
  /*----------------------------------------------------------------------*/
  DEF c

  WHILE (c := pos [])
    SELECT c
      CASE  32; RETURN pos    /* SPACE */
      CASE   9; RETURN pos    /* TAB */
      CASE  10; RETURN pos    /* LF */
      CASE  13; RETURN pos    /* CR */
      DEFAULT;  INC pos
    ENDSELECT
  ENDWHILE

ENDPROC  pos
  /* cSkipNonWhite */
