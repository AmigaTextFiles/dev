OPT TURBO

PMODULE 'PMODULES:cSkipWhite'
PMODULE 'PMODULES:cSkipNonWhite'

PROC getArg (theArg,  /* PTR TO STRING       */
             index)   /* Argument id, 1 .. n */
  DEF startPos : PTR TO CHAR, numChars, i, length

  /* This routine is intended for KS1.3 programmers who don't have access */
  /* to taglists.  To get the first command-line argument pass in a       */
  /* string large enough to hold arg (s := String (StrLen (arg)) ), and   */
  /* a long int where 1 = first argument, 2 = second argument...  If      */
  /* the requested argument doesn't exist (3 is requested when only 2     */
  /* were entered on the command line) the function returns -1.  This     */
  /* function does not recognize quoted arguments with embedded spaces.   */

  IF arg [] <= 0
    StrCopy (theArg, '', ALL)
    RETURN FALSE
  ENDIF

  length := StrLen (arg)
  startPos := arg

  FOR i := 2 TO index
    startPos := cSkipNonWhite (startPos)  /* Find next space. */
    startPos := cSkipWhite (startPos)     /* Find start of next arg. */
    IF (startPos [] = 0)
      /* End of string encountered before requested arg. */
      StrCopy (theArg, '', ALL)
      RETURN FALSE
    ENDIF
  ENDFOR

  numChars := (cSkipNonWhite (startPos) - startPos)   /* Find end of arg. */
  MidStr (theArg, startPos, 0, numChars)

ENDPROC  TRUE
  /* getArg */

