/* Creates a file of size specified in command line. */




MODULE 'dos/Dos'



/* Runtime exceptions. */
ENUM ER_NONE,
     ER_USAGE,
     ER_MEM,
     ER_OUTFILE



/*=== Command-line Argument Parser =======================================*/

CONST BUFSIZE = 488

DEF argFileSize,
    argDestPath = NIL



PROC skipSpaces (bool, theString, startPos)
  DEF char [1] : STRING,
      endPos, length

  length := StrLen (theString)
  IF startPos = length THEN RETURN startPos

  endPos := startPos
  MidStr (char, theString, endPos, 1)
  WHILE (StrCmp (char, ' ', 1)) = bool
     /* bool=TRUE then skip space; bool=FALSE then skip non-space */
    IF endPos = length THEN RETURN endPos
    INC endPos
    MidStr (char, theString, endPos, 1)
  ENDWHILE
ENDPROC endPos
  /* skipSpaces */


PROC getArg (theArg, index)
  DEF startPos, endPos,
      i, length

  IF arg [] <= 0
    StrCopy (theArg, '', ALL)
    RETURN FALSE
  ENDIF

  length := StrLen (arg)
  startPos := 0
  endPos := skipSpaces (FALSE, arg, startPos)

  FOR i := 2 TO index
    startPos := skipSpaces (FALSE, arg, startPos)
    startPos := skipSpaces (TRUE, arg, startPos)
    IF startPos = length
      /* Request past end of argument is invalid. */
      StrCopy (theArg, '', ALL)
      RETURN FALSE
    ENDIF
    endPos := skipSpaces (FALSE, arg, startPos)
  ENDFOR

  MidStr (theArg, arg, startPos, (endPos - startPos))

ENDPROC TRUE
  /* getArg */



PROC parseCommandLineArguments () HANDLE
  DEF index = 1,
      theArg

  theArg := String (StrLen (arg))
  IF theArg = NIL THEN Raise (ER_MEM)

  FOR index := 1 TO 2
    IF getArg (theArg, index)
      IF index = 1
          argFileSize := Val (theArg, NIL)
          IF argFileSize < 0 THEN Raise (ER_USAGE)
      ELSE  /* Last arg, must be DestPath. */
        argDestPath := String (StrLen (theArg))
        IF argDestPath = NIL THEN Raise (ER_MEM)
        StrCopy (argDestPath, theArg, ALL)
      ENDIF
    ENDIF
  ENDFOR

  Dispose (theArg)

EXCEPT

  IF theArg THEN Dispose (theArg)
  Raise (exception)

ENDPROC
  /* parseCommandLineArguments */


/*=== End Command-line Argument Parser ===================================*/


PROC main () HANDLE
  DEF destFileHandle = NIL,
      numberOfWrites,
      bytesWritten,
      buffer, i

  IF arg [] = 0 THEN Raise (ER_USAGE)

  parseCommandLineArguments ()
  IF argDestPath = NIL THEN Raise (ER_USAGE)

  buffer := String (BUFSIZE)
  IF buffer = NIL THEN Raise (ER_MEM)
  FOR i := 1 TO BUFSIZE DO StrAdd (buffer, 'x', ALL)

  WriteF ('\n\nCreating file: \s', argDestPath)

  destFileHandle := Open (argDestPath, NEWFILE)
  IF destFileHandle = NIL THEN Raise (ER_OUTFILE)

  numberOfWrites := argFileSize / BUFSIZE
  FOR i := 1 TO numberOfWrites
    bytesWritten := Write (destFileHandle, buffer, BUFSIZE)
    IF bytesWritten < BUFSIZE THEN Raise (ER_OUTFILE)
  ENDFOR
  FOR i := 1 TO (argFileSize - (numberOfWrites * BUFSIZE)) DO Out (destFileHandle, 'x')

  Close (destFileHandle)

  WriteF ('\nDone.\n\n')

  CleanUp (0)

EXCEPT

  IF destFileHandle THEN Close (destFileHandle)

  SELECT exception
    CASE ER_USAGE;             WriteF ('\nUsage:  CreateFile <bytes> <filespec>')
    CASE ER_MEM;               WriteF ('\nInsufficient memory.')
    CASE ER_OUTFILE;           WriteF ('\nError opening or writing to file.')
  ENDSELECT

  WriteF ('\n\n')

  CleanUp (exception)

ENDPROC
