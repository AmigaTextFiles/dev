PMODULE 'PMODULES:skipWhite'
PMODULE 'PMODULES:skipNonWhite'



PROC getArg (theArg,  /* PTR TO STRING       */
             index)   /* Argument id, 1 .. n */
  DEF startPos, endPos, i, length

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
  startPos := 0

  FOR i := 2 TO index
    startPos := skipNonWhite (arg, startPos)  /* Find next space. */
    startPos := skipWhite (arg, startPos)     /* Find start of next arg. */
    IF (startPos = length)
      /* Access beyond end of string, and we haven't reached requested arg. */
      StrCopy (theArg, '', ALL)
      RETURN FALSE
    ENDIF
  ENDFOR

  endPos := skipNonWhite (arg, startPos)    /* Find end of arg. */
  MidStr (theArg, arg, startPos, (endPos - startPos))

ENDPROC  TRUE
  /* getArg */



PROC main () HANDLE
  ENUM ER_NONE,
       ER_USAGE,
       ER_MEM
  DEF anArg,
      i = 1

  /* This main procedure demonstrates the usage of getArg () */

  IF arg [] <= 0 THEN Raise (ER_USAGE)

  anArg := String (StrLen (arg))
  IF anArg = NIL THEN Raise (ER_MEM)

  WHILE getArg (anArg, i++)
    WriteF ('Arg = \a\s\a\n', anArg)  /* In the using program you can check */
                                      /* the value of anArg (ot whatever    */
                                      /* you call it) and copy it to the    */
                                      /* appropriate variable.              */
    /*INC i*/
  ENDWHILE

  CleanUp (0)

EXCEPT

  SELECT exception
    CASE ER_USAGE;   WriteF ('Illegal usage.\n')
    CASE ER_MEM;     WriteF ('Get more memory!\n')
  ENDSELECT

  CleanUp (exception)

ENDPROC
  /* getArg */

