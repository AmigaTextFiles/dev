/**************************************************************************/
/*                                                                        */
/* This is the cammand-line argument code for my program Fill.            */
/* Unfortunately, I didn't have EPP when I wrote Fill, else it would have */
/* looked like this.                                                      */
/*                                                                        */
/**************************************************************************/

PMODULE 'PMODULES:commandLineArgs'


/* Exceptions in main program. */
ENUM ER_NONE,
     ER_USAGE,
     ER_MEM


CONST MAX_ARG_BUFSIZE = 100,
      MAX_ARG_ERRORMARGIN = 20


/* Default options which can be over-ridden via command line. */
DEF optionIsSet_CopyOnly = FALSE,
    argBufSize = 20,
    argErrorMargin = 0,
    argDestPath = NIL



PROC parseCommandLineArguments () HANDLE
  DEF argIndex = 1,
      char,
      theArg, nextArg

  theArg := String (StrLen (arg))
  IF theArg = NIL THEN Raise (ER_MEM)

  nextArg := String (StrLen (arg))
  IF nextArg = NIL THEN Raise (ER_MEM)

  /* I used theArg and nextArg because I have to make sure the last arg  */
  /* goes into argDestPath, so if there is another arg to put in nextArg */
  /* then theArg must be an option.                                      */

  WHILE getArg (theArg, argIndex)

    INC argIndex
    IF getArg (nextArg, argIndex)  /* If there is another, theArg must be an option. */
      char := theArg [0]

      IF char = "-"
        char := theArg [1]

        IF char = "c"
          optionIsSet_CopyOnly := TRUE
        ELSEIF char = "b"
          /* Use nextArg just to save storage. */
          MidStr (nextArg, theArg, 2, ALL)
          argBufSize := Val (nextArg, NIL)
          IF argBufSize <=0 THEN Raise (ER_USAGE)
          IF argBufSize > MAX_ARG_BUFSIZE THEN argBufSize := MAX_ARG_BUFSIZE
        ELSEIF char =  "e"
          /* Use nextArg just to save storage. */
          MidStr (nextArg, theArg, 2, ALL)
          argErrorMargin := Val (nextArg, NIL)
          IF argErrorMargin <=0 THEN Raise (ER_USAGE)
          IF argErrorMargin > MAX_ARG_ERRORMARGIN THEN argErrorMargin := MAX_ARG_ERRORMARGIN
        ENDIF
      ELSE  /* Too many arguments. */
        Raise (ER_USAGE)
      ENDIF
    ELSE  /* Last arg, must be DestPath. */
      argDestPath := String (StrLen (theArg))
      IF argDestPath = NIL THEN Raise (ER_MEM)
      StrCopy (argDestPath, theArg, ALL)
    ENDIF
  ENDWHILE

  Dispose (theArg)
  Dispose (nextArg)

EXCEPT

  IF theArg THEN Dispose (theArg)
  IF nextArg THEN Dispose (nextArg)
  Raise (exception)

ENDPROC
  /* parseCommandLineArguments */




PROC main () HANDLE
  IF arg [] = 0 THEN Raise (ER_USAGE)

  parseCommandLineArguments ()

  WriteF ('\n  Destination Path is \a\s\a.', argDestPath)
  WriteF ('\n  Copy Only Option is \sset.',
          IF optionIsSet_CopyOnly THEN '' ELSE 'not ')
  WriteF ('\n  Buffer Size is \a\d\a.', argBufSize)
  WriteF ('\n  Error Margin is \a\d\a.\n\n', argErrorMargin)

  CleanUp (0)

EXCEPT

  SELECT exception
    CASE ER_USAGE;  WriteF ('\n\n  Usage:  Args [-c] [-b###] [-e##] dest-path\n\n')
    CASE ER_MEM;    WriteF ('\n\n  Insufficient memory.\n\n')
  ENDSELECT

  CleanUp (exception)

ENDPROC
