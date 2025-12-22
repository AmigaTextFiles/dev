/*
   EPP V1.1 - E Preprocessor.
   Copyright ©1993 Barry Wills.  All rights reserved.
*/



PMODULE 'PMODULES:commandLineArgs'
PMODULE 'PMODULES:cSkipWhite'
PMODULE 'PMODULES:cSkipToChar'
PMODULE 'PMODULES:cSkipToEDelim'



/*===  Runtime exceptions.  ==============================================*/

ENUM ER_NONE,
     ER_MEM,
     ER_USAGE,
     ER_OPENING_INFILE,
     ER_OPENING_OUTFILE,
     ER_WRITING_FILE,
     ER_SYNTAX



RAISE ER_MEM IF New () = NIL,
      ER_MEM IF List () = NIL,
      ER_MEM IF String () = NIL



/*===  Global constants.  ================================================*/

CONST DEFAULT_BUFSIZE         = 128,
      MINIMUM_BUFSIZE         = 20,
      LARGEST_TOKEN_SUPPORTED = 64  /* Largest identifier expected. */



/*===  Object type definitions.  =========================================*/

/* V0.13b - My answer to the slow IO problem.  I decided to try an input */
/* juggling act instead of restructuring the program.  String input was  */
/* definitely the bottleneck, so that's where I decided to hack.  See    */
/* function read () for more details.                                    */

OBJECT readDataType
  inputBuffer : LONG
  length : LONG        /* num bytes read into inputBuffer    */
  pos : LONG           /* next available char in inputBuffer */
  turboMode : LONG     /* TURBO mode for this module only.   */
ENDOBJECT



/*===  Global variables.  ================================================*/


DEF defsFileHandle    = NIL,
    procsFileHandle   = NIL,
    procsFileName     = NIL,
    theModuleList     = NIL,
    argMainModuleName = NIL,
    argOutFileName    = NIL,
    argBufSize,
    argLineLength,
    argIncludeComments = FALSE,
    argProgressIsVerbose = TRUE,
    argTurboMode = FALSE,
    nestedCommentCount = 0,
    userBreak = FALSE


/*===  Main procedures.  =================================================*/

PROC getArgs ()
  DEF tempArg [108] : STRING,
      i = 1

  IF arg [] = 0 THEN Raise (ER_USAGE)

  argBufSize := DEFAULT_BUFSIZE
  argLineLength := DEFAULT_BUFSIZE

  WHILE getArg (tempArg, i++)

    IF (tempArg [0] = "-")
      /* Get switch. */
      IF tempArg [1] = "b"  /* File buffer size. */
        MidStr (tempArg, tempArg, 2, ALL)
        IF (argBufSize := Val (tempArg, NIL)) = -1 THEN Raise (ER_USAGE)
        IF (argBufSize < MINIMUM_BUFSIZE)
          WriteF ('\n ··· Using mimimum buffer size \d', MINIMUM_BUFSIZE)
          argBufSize := MINIMUM_BUFSIZE
        ENDIF
      ELSEIF tempArg [1] = "l"  /* Line length. */
        MidStr (tempArg, tempArg, 2, ALL)
        IF (argLineLength := Val (tempArg, NIL)) = -1 THEN Raise (ER_USAGE)
        IF (argLineLength < MINIMUM_BUFSIZE)
          WriteF ('\n ··· Using mimimum line length \d', MINIMUM_BUFSIZE)
          argLineLength := MINIMUM_BUFSIZE
        ENDIF
      ELSEIF tempArg [1] = "s"  /* Progress messages. */
        argProgressIsVerbose := FALSE
      ELSEIF tempArg [1] = "c"  /* Include comments in output source. */
        argIncludeComments := TRUE
      ELSEIF tempArg [1] = "t"  /* Turbo proc copy mode. */
        argTurboMode := TRUE
      ENDIF
    ELSEIF argMainModuleName = NIL
      /* Not a switch:  get main input file name. */
      argMainModuleName := String (StrLen (arg))
      StrCopy (argMainModuleName, tempArg, ALL)
    ELSEIF argOutFileName = NIL
      /* Not a switch, already got main input file name: */
      /* get output file name.                           */
      argOutFileName := String (StrLen (arg))
      StrCopy (argOutFileName, tempArg, ALL)
    ELSE
      /* Not a switch, already got main input file  */
      /* name and output file name:  too many args. */
      Raise (ER_USAGE)
    ENDIF
  ENDWHILE

  /* Must have these two args as a minimum. */
  IF (argMainModuleName = NIL) OR
     (argOutFileName = NIL) THEN Raise (ER_USAGE)

ENDPROC
  /* getArgs */



PROC buildEProgramName (theFileName)
  DEF length,
      fileExtension [2] : STRING
  length := StrLen (theFileName)
  MidStr (fileExtension, theFileName, length - 2, 2)
  LowerStr (fileExtension)
  IF StrCmp (fileExtension, '.e', ALL) = FALSE THEN length := length + 2
  IF StrCmp (fileExtension, '.e', ALL) = FALSE
    StrAdd (theFileName, '.e', ALL)
  ENDIF
ENDPROC
  /* buildEProgramName */



PROC isInList (theModuleName, theList)
  DEF moduleName
  IF (moduleName := theList) = NIL THEN RETURN FALSE
  REPEAT
    IF StrCmp (moduleName, theModuleName, ALL) THEN RETURN TRUE
  UNTIL (moduleName := Next (moduleName)) = NIL
ENDPROC  FALSE
  /* isInList */



PROC continueGettingComments (pos)
  DEF p : PTR TO CHAR
  p := ^pos

  WHILE (p [] > 0) AND (nestedCommentCount)
    IF (p [] = "*")    /* Closing comment? */
      IF (p [1] = "/")
        DEC nestedCommentCount
        INC p
      ENDIF
    ELSEIF (p [] = "/")    /* Nested comment? */
      IF (p [1] = "*")
        INC nestedCommentCount
        INC p
      ENDIF
    ENDIF
    INC p
  ENDWHILE

  ^pos := p
ENDPROC



PROC checkEnclosing (pos, c)
  DEF p : PTR TO CHAR
  p := ^pos

  /* If found an open quote, "'", or comment, search for it's partner */

  IF c = "'"
    REPEAT
      INC p
    UNTIL ((p [] = 0) OR (p [] = "'"))
  ELSEIF c = 34  /* QUOTE */
    REPEAT
      INC p
    UNTIL ((p [] = 0) OR (p [] = 34))
  ELSEIF c = "/"
    IF (p [1] = "*")
      p := p + 2
      INC nestedCommentCount
      continueGettingComments ({p})
    ENDIF
  ELSEIF c = "*"
    IF (p [1] = "/")
      p := p + 2
      DEC nestedCommentCount
      continueGettingComments ({p})
    ENDIF
  ENDIF

  ^pos := p
ENDPROC
  /* checkEnclosing */



PROC skipToValidToken (pos : PTR TO CHAR,
                       proc_endproc)
  DEF c

  /* Finds the next important E keyword in theString and returns its pos. */
  /* Thanks to Son Le for coming up with this routine to speed up the     */
  /* parsing!                                                             */

  /* Nested comments?  If so, find closing comment brackets. */
  IF nestedCommentCount THEN continueGettingComments ({pos})

  WHILE (c := pos [])
    SELECT c
      CASE "'"
        checkEnclosing ({pos}, c)
      CASE 34  /* Quote */
        checkEnclosing ({pos}, c)
      CASE "/"
        checkEnclosing ({pos}, c)
      CASE "*"
        checkEnclosing ({pos}, c)

      CASE "P"  /* PROC or PMODULE */
        IF ((pos [1] = "R") OR
            (pos [1] = "M")) THEN RETURN pos

      CASE "E"  /* ENDPROC or ENUM */
        IF (pos [1] = "N") THEN RETURN pos
    ENDSELECT
    IF (proc_endproc = FALSE)   /* if proc_endproc is true, we search only */
      SELECT c                  /* for the keywords PROC or ENDPROC (ENUM) */

        CASE "O"  /* OPT or OBJECT */
          IF ((pos [1] = "P") OR (pos [1] = "B")) THEN RETURN pos

        CASE "R"  /* RAISE */
          IF (pos [1] = "A") THEN RETURN pos

        CASE "C"  /* CONST */
          IF (pos [1] = "O") THEN RETURN pos

        CASE "D"  /* DEF */
          IF (pos [1] = "E") THEN RETURN pos
      ENDSELECT
    ENDIF
    IF pos [] THEN INC pos
  ENDWHILE
ENDPROC  pos
  /* skipToValidToken */



PROC getToken (token, startPos : PTR TO CHAR)
  /*  Get an E token and place it in token. */
  DEF endPos
  startPos := cSkipWhite (startPos)
  endPos := (cSkipToEDelim (startPos) - startPos)
  MidStr (token, startPos, 0, endPos)
ENDPROC  (startPos + endPos)
  /* getToken */



PROC getModuleName (name, startPos)
  /* Look for a module name ('identifier') and place it in name. */
  DEF endPos

  ^startPos := cSkipToChar ("'", ^startPos)
  IF Char (^startPos) <> "'" THEN Raise (ER_SYNTAX)
  ^startPos := ^startPos + 1

  endPos := (cSkipToChar ("'", ^startPos) - ^startPos)
  IF Char (^startPos + endPos) = "'"
    MidStr (name, ^startPos, 0, endPos)
    StrAdd (name, '.e', ALL)
    ^startPos := ^startPos + endPos
  ELSE
    ^startPos := ^startPos + endPos
    Raise (ER_SYNTAX)
  ENDIF
ENDPROC
  /* getModuleName */



PROC read (fileHandle,
           rData : PTR TO readDataType,
           sourceLine)
  DEF inputBuffer,
      i = 0,
      pos

  inputBuffer := rData.inputBuffer
  pos := rData.pos

  WHILE i < argBufSize
    IF pos >= rData.length
      rData.length := Read (fileHandle, inputBuffer, argBufSize)
      IF rData.length < 1
          IF i > 0
            sourceLine [i++] := 10
            sourceLine [i] := 0
            rData.length := i
          ENDIF
          rData.pos := rData.length
          RETURN i
      ENDIF
      pos := 0
    ENDIF
    sourceLine [i] := inputBuffer [pos++]
    IF (sourceLine [i++] = 10) OR  /* LF */
       (i = argLineLength)
      SetStr (sourceLine, i)
      rData.pos := pos
      RETURN i
    ENDIF
  ENDWHILE

ENDPROC
  /* read */



PROC copyProc (rData : PTR TO readDataType,  /* Input file buffer info. */
               sourceLine,         /* The current source line being considered. */
               inFileHandle,       /* Which file to continue reading from. */
               moduleName,         /* The name of the module for inclusion in comments. */
               tempStr,            /* Why allocate another work variable? */
               currentPos,         /* Where sourceLine examination is to continue. */
               length,             /* Length of current sourceLine. */
               lineCount)          /* Keep track in case an error occurs. */

  /* Copy until uncommented ENDPROC is found.  When this procedure is */
  /* called we are never within a comment.                            */

  DEF keywordENDPROCfound,  /* Indicates we found the whole proc. */
      bytesRead,            /* used only in Turbo mode. */
      pos : PTR TO CHAR

  /* Comments to EPP code. */
  IF argIncludeComments
    Write (procsFileHandle, '\n/*** Procedure included from ', 30)
    Write (procsFileHandle, moduleName, StrLen (moduleName))
    Write (procsFileHandle, ' ***/\n', 6)
  ENDIF

  IF (argTurboMode) OR
     (rData.turboMode)
    /* Status indication to stdout. */
    IF argProgressIsVerbose
      WriteF ('\n     Turbo module:  \a\s\a', moduleName)
    ENDIF
    IF argIncludeComments
      Write (procsFileHandle, '/*** Turbo dump of module ', 26)
      Write (procsFileHandle, moduleName, StrLen (moduleName))
      Write (procsFileHandle, ' ***/\n', 6)
    ENDIF
    Write (procsFileHandle, sourceLine, ^length)
    /* Empty the inputBuffer before trying to read again. */
    IF (rData.pos < rData.length)
      bytesRead := rData.length - rData.pos
      IF Write (procsFileHandle,
                (rData.inputBuffer + rData.pos),
                bytesRead) < bytesRead THEN Raise (ER_WRITING_FILE)
    ENDIF
    WHILE (bytesRead := Read (inFileHandle, rData.inputBuffer, argBufSize)) > 0
      IF Write (procsFileHandle, rData.inputBuffer,
                bytesRead) < bytesRead THEN Raise (ER_WRITING_FILE)
    ENDWHILE
    StrCopy (sourceLine, '', ALL)
    ^length := 0
    ^currentPos := sourceLine
    rData.length := 0
    rData.pos := 0
    RETURN
  ENDIF

  /* Omit PROC main () in all but main module. */
  ^currentPos := getToken (tempStr, ^currentPos)

  IF StrCmp (tempStr, 'main', ALL)
    IF StrCmp (moduleName, argMainModuleName, ALL) = FALSE
      IF argIncludeComments THEN Write (procsFileHandle,
                                        '/*** Superfluous PROC main () '+
                                        'omitted ***/\n\n', 44)
      WHILE Read (inFileHandle, rData.inputBuffer, argBufSize) > 0 DO NOP
      SetStr (sourceLine, 0)
      ^currentPos := sourceLine
      ^length := 0
      rData.pos := 0
      rData.length := 0
      RETURN
    ENDIF
  ENDIF

  /* Status indication to stdout. */
  IF argProgressIsVerbose THEN WriteF ('\n     Copying proc:  \a\s\a', tempStr)

  pos := ^currentPos

  LOOP  /* Only ways out of this loop are:               */
        /*  1. RETURN when uncommented ENDPROC is found, */
        /*  2. Encounter another PROC statement,         */
        /*  3. Encounter end of file.                    */

    keywordENDPROCfound := FALSE

    WHILE pos []

      /* Quick skip to valid character, instead of parsing each char */
      pos := skipToValidToken (pos, TRUE)

      IF (pos [] = "E")
        /* Could be we found ENDPROC. */
        pos := getToken (tempStr, pos)
        IF StrCmp (tempStr, 'ENDPROC', ALL) THEN keywordENDPROCfound := TRUE
      ELSEIF (pos [] = "P")
        /* Could be we found another PROC (this was a one-liner). */
        pos := getToken (tempStr, pos)
        IF StrCmp (tempStr, 'PROC', ALL)
          copyProc (rData, sourceLine, inFileHandle, moduleName,
                    tempStr, {pos}, length, lineCount)
          StrCopy (sourceLine, '', ALL)  /* sourceLine comes back with 'ENDPROC'  */
          ^length := 0                   /* in it.  Don't want to write it again. */
          pos := sourceLine
          keywordENDPROCfound := TRUE
        ENDIF
      ENDIF

      IF pos [] THEN INC pos
    ENDWHILE

    IF Write (procsFileHandle, sourceLine, ^length) < 0 THEN Raise (ER_WRITING_FILE)

    IF keywordENDPROCfound
      ^currentPos := pos
      RETURN
    ENDIF

    ^length := read (inFileHandle, rData, sourceLine)
    IF ^length < 1
      /* If EOF and ENDPROC not found, we have to assume one-line PROC */
      /* transcending more than one line.  There is no way to enforce  */
      /* ENDPROC without doing full-blown syntax checking.             */
      ^currentPos := pos
      RETURN
    ENDIF

    /*^length := StrLen (sourceLine)*/
    pos := sourceLine
    ^lineCount := ^lineCount + 1
  ENDLOOP

ENDPROC
  /* copyProc */



PROC copyDefs (rData : PTR TO readDataType,  /* Input file buffer info. */
               sourceLine,         /* The current source line being considered. */
               inFileHandle,       /* Which file to continue reading from. */
               moduleName,         /* The name of the module for inclusion in comments. */
               tempStr,            /* Why allocate another work variable? */
               currentPos,         /* Where sourceLine examination is to continue. */
               length,             /* Length of current sourceLine. */
               lineCount,          /* Keep track in case an error occurs. */
               lastFileWrittenTo)  /* Must change if we need to make a call to copyProcs. */

  /* Copy until a PROC keyword or eof is encountered. */

  DEF pos : PTR TO CHAR

  /* Status indication to stdout. */
  IF argProgressIsVerbose THEN WriteF ('\n     Copying defs:  \a\s\a', moduleName)

  /* Comment EPP code. */
  IF argIncludeComments
    Write (defsFileHandle, '/*** Declarations included from ', 32)
    Write (defsFileHandle, moduleName, StrLen (moduleName))
    Write (defsFileHandle, ' ***/\n', 6)
  ENDIF

  pos := ^currentPos

  LOOP  /* Only two ways out of this loop:             */
        /*  1.  RETURN when uncommented PROC is found, */
        /*  2.  End of file is encountered.            */

    WHILE pos []

      /* Quick skip to valid character, instead of parsing each one */
      pos := skipToValidToken (pos, TRUE)

      IF (pos [] = "P")
        /* See if we found beginning of PROC section. */
        pos := getToken (tempStr, pos)
        IF StrCmp (tempStr, 'PROC', ALL)
          ^lastFileWrittenTo := procsFileHandle
          copyProc (rData, sourceLine, inFileHandle, moduleName,
                    tempStr, {pos}, length, lineCount)
          ^currentPos := pos
          RETURN
        ELSEIF StrCmp (tempStr, 'PMODULE', ALL)
          getModuleName (tempStr, {pos})
          getModule (tempStr)
          /* Shorten sourceLine to get rid of the PMODULE statement. */
          MidStr (sourceLine, (pos + 1), 0, ALL)
          ^length := StrLen (sourceLine)
          pos := sourceLine
          IF ^length = 2
            IF StrCmp (sourceLine, ';\n', ALL) THEN SetStr (sourceLine, 0)
            ^length := 0
          ENDIF
        ENDIF
      ELSEIF (pos [] = "O")
        /* See if we found OPT TURBO option. */
        pos := getToken (tempStr, pos)
        IF StrCmp (tempStr, 'OPT', ALL)
          pos := getToken (tempStr, pos)
          IF StrCmp (tempStr, 'TURBO', ALL)
            rData.turboMode := TRUE
            StrCopy (sourceLine, pos, ALL)
            length := StrLen (sourceLine)
            pos := sourceLine
          ENDIF
        ENDIF
      ENDIF

      IF pos [] THEN INC pos
    ENDWHILE

    IF Write (defsFileHandle, sourceLine, ^length) < 0 THEN Raise (ER_WRITING_FILE)

    ^length := read (inFileHandle, rData, sourceLine)
    IF ^length < 1
      ^currentPos := pos
      RETURN
    ENDIF

    /*^length := StrLen (sourceLine)*/
    pos := sourceLine
    ^lineCount := ^lineCount + 1

  ENDLOOP

ENDPROC
  /* copyDefs */



PROC getModule (theModuleName) HANDLE
  DEF rData : PTR TO readDataType,  /* File buffer info used for theModuleName. */
      sourceLine,            /* The line of source; output buffer. */
      fileHandle = NIL,      /* File handle used for theModuleName. */
      lastFileWrittenTo,     /* Where to put a line that doesn't need to be handled specifically. */
      length,                /* StrLen (sourceLine) for speed in repetitious access. */
      pos : PTR TO CHAR,     /* Current character index. */
      lineCount = 0,         /* Count line number for use in error message. */
      tempStr,               /* Holds a string value for comparison, etc. */
      lineRecognized,        /* Flag indicates if the line has been handled       */
                             /*  specifically or if it still needs to be written. */
      doCopyDefs             /* Controls logic based on OPT keyword. */

  IF isInList (theModuleName, theModuleList)
    IF argProgressIsVerbose THEN WriteF ('\n ··· Duplicate definition omitted:  \a\s\a', theModuleName)
    RETURN
  ELSE
    IF argProgressIsVerbose
      WriteF ('\n »»» \s   \a\s\a',
              IF StrCmp (theModuleName,
                         argMainModuleName, ALL) THEN 'Main module:' ELSE 'New module: ',
              theModuleName)
    ENDIF
    tempStr := String (StrLen (theModuleName))
    StrCopy (tempStr, theModuleName, ALL)
    theModuleList := Link (tempStr, theModuleList)
  ENDIF

  fileHandle := Open (theModuleName, OLDFILE)
  IF fileHandle = NIL THEN Raise (ER_OPENING_INFILE)

  rData := New (SIZEOF readDataType)
  rData.inputBuffer := String (argBufSize)
  rData.pos := 0
  rData.length := 0
  rData.turboMode := FALSE
  sourceLine := String (argLineLength)
  tempStr := String (LARGEST_TOKEN_SUPPORTED)
  lastFileWrittenTo := defsFileHandle  /* Where to put a line that doesn't */
                                       /* need to be handled specifically. */

  /* Keep reading until module keyword not found or eof. */
  WHILE (length := read (fileHandle, rData, sourceLine)) > 0 AND
        (userBreak = FALSE)

    /* Initialize substring search. */
    /*length := StrLen (sourceLine)*/
    pos := sourceLine
    INC lineCount
    lineRecognized := FALSE

    WHILE pos []  /* Until end of line. */

      /* Quick skip to valid character, instead of parsing each one */
      pos := skipToValidToken (pos, FALSE)

      IF pos [] = "P"
        pos := getToken (tempStr, pos)
        IF StrCmp (tempStr, 'PMODULE', ALL)
          getModuleName (tempStr, {pos})
          getModule (tempStr)
          /* Shorten sourceLine to get rid of the PMODULE statement. */
          MidStr (sourceLine, (pos + 1), 0, ALL)
          length := StrLen (sourceLine)
          pos := sourceLine
          IF length = 2
            IF StrCmp (sourceLine, ';\n', ALL) THEN SetStr (sourceLine, 0)
            length := 0
          ENDIF
        ELSEIF StrCmp (tempStr, 'PROC', ALL)
          lastFileWrittenTo := procsFileHandle
          copyProc (rData, sourceLine, fileHandle, theModuleName,
                    tempStr, {pos}, {length}, {lineCount})
          lineRecognized := TRUE
        ENDIF
      ELSEIF ((pos [] = "O") OR
              (pos [] = "D") OR
              (pos [] = "C") OR
              (pos [] = "E") OR
              (pos [] = "R"))
        pos := getToken (tempStr, pos)
        IF InStr ('OPT OBJECT DEF CONST ENUM RAISE', tempStr, NIL) > -1
          doCopyDefs := TRUE  /* Controls the following IF block. */
          IF StrCmp (tempStr, 'OPT', ALL)
            doCopyDefs := FALSE
            /* See if we found OPT TURBO option. */
            pos := getToken (tempStr, pos)
            IF StrCmp (tempStr, 'TURBO', ALL)
              rData.turboMode := TRUE
              StrCopy (sourceLine, pos, ALL)  /* Remove OPT TURBO statement. */
              length := StrLen (sourceLine)
              pos := sourceLine
              SetStr (tempStr, 0)
              doCopyDefs := FALSE
            ENDIF
          ENDIF
          /* Was it a def, or was it OPT TURBO? */
          IF (doCopyDefs)
            lastFileWrittenTo := defsFileHandle
            copyDefs (rData, sourceLine, fileHandle, theModuleName,
                      tempStr, {pos}, {length}, {lineCount},
                      {lastFileWrittenTo})
            Write (defsFileHandle, '\n', 1)
            lineRecognized := TRUE
          ENDIF
        ENDIF
      ENDIF

      IF pos [] THEN INC pos
    ENDWHILE  /* EOLN */

    IF lineRecognized = FALSE THEN IF Write (lastFileWrittenTo,
                                             sourceLine,
                                             length) < 0 THEN Raise (ER_WRITING_FILE)

    IF CtrlC () THEN userBreak := TRUE

  ENDWHILE  /* EOF */

  IF fileHandle THEN Close (fileHandle)
  Dispose (rData.inputBuffer)
  Dispose (rData)
  Dispose (sourceLine)
  Dispose (tempStr)

EXCEPT

  IF fileHandle THEN Close (fileHandle)

  SELECT exception
    CASE ER_SYNTAX
      WriteF ('\n *** Syntax error: module \a\s\a, line \d, pos \d.\n\n',
              theModuleName, lineCount, (pos - sourceLine))
      Raise (ER_NONE)  /* Avoid more messages upon return from recursion. */
    CASE ER_WRITING_FILE
      WriteF ('\n *** Error occurred while writing to ')
      IF lastFileWrittenTo = procsFileHandle
        WriteF ('Procs File, \s.\n', procsFileName)
      ELSE
        WriteF ('Defs File, \s.\n', argMainModuleName)
      ENDIF
      Raise (ER_NONE)  /* Avoid more messages upon return from recursion. */
  ENDSELECT

  Raise (exception)

ENDPROC
  /* getModule */



PROC appendProcsToDefs ()
  DEF sourceLine,
      bytesRead = 0

  IF argProgressIsVerbose THEN WriteF ('\n »»» Writing procs-file' +
                                       ' to end of defs-file.')

  sourceLine := New (argBufSize)

  Close (procsFileHandle)
  procsFileHandle := Open (procsFileName, OLDFILE)
  IF procsFileHandle = NIL THEN Raise (ER_OPENING_INFILE)

  WHILE (bytesRead := Read (procsFileHandle, sourceLine, argBufSize)) > 0
    IF Write (defsFileHandle, sourceLine, bytesRead) <> bytesRead
      WriteF ('\n *** Error writing output file.\n\n')
/*    Dispose (sourceLine) --> Calling CleanUp() anyway. */
      Raise (ER_WRITING_FILE)
    ENDIF
  ENDWHILE

/*Dispose (sourceLine) --> Calling CleanUp() anyway. */

ENDPROC
  /* appendProcsToDefs */



PROC main () HANDLE
  DEF saveDefsFileHandle = NIL,
      saveProcsFileHandle = NIL
  WbenchToFront()

  WriteF ('\n  EPP V1.1 - E Preprocessor.')
  WriteF ('\n  Copyright ©1993 Barry Wills.  All rights reserved.\n')

  /* Get command-line arguments. */
  getArgs ()

  /* Build names for E source files. */
  buildEProgramName (argMainModuleName)  /* main input file  */
  buildEProgramName (argOutFileName)     /* main output file */

  /* Open output files. */
  procsFileName := String (13)
  StrCopy (procsFileName, 'T:procsfile.e', ALL)
  defsFileHandle := Open (argOutFileName, NEWFILE)
  IF defsFileHandle = NIL
    WriteF ('\n *** \s', argOutFileName)
    Raise (ER_OPENING_OUTFILE)
  ENDIF
  saveDefsFileHandle := defsFileHandle
  procsFileHandle := Open (procsFileName, NEWFILE)
  IF procsFileHandle = NIL
    WriteF ('\n *** \s', procsFileName)
    Raise (ER_OPENING_OUTFILE)
  ENDIF
  saveProcsFileHandle := procsFileHandle

  /* Start recursive process. */
  getModule (argMainModuleName)

  /* Copy tempfile containing procs onto the end of the main output file. */
  IF userBreak = FALSE THEN appendProcsToDefs ()

  Close (defsFileHandle)
  Close (procsFileHandle)

  IF DeleteFile (procsFileName) = FALSE
    WriteF (' *** Unable to remove temporary file \s\n', procsFileName)
  ENDIF

  IF userBreak
    WriteF ('\n\n *** User break.\n\n')
  ELSE
    WriteF ('\s', IF argProgressIsVerbose THEN '\n »»» Done.\n\n' ELSE '\n')
  ENDIF

  CleanUp (0)

EXCEPT

  SELECT exception
    CASE ER_USAGE;
      WriteF ('\n *** Usage:  EPP [switches] infile[.e] outfile[.e]' +
              '\n      switches: -b### = file buffer size (20+; default 128)' +
              '\n                -l### = source line length (20+; default 128)' +
              '\n                -s    = silence progress messages' +
              '\n                -c    = insert EPP comments in final output source' +
              '\n                -t    = Turbo mode\n\n')
    CASE ER_MEM;
      WriteF ('\n *** Insufficient memory.  ' +
              'Try shorter line length if possible.\n\n')
    CASE ER_OPENING_INFILE;  WriteF ('\n     Error opening input file.\n\n')
    CASE ER_OPENING_OUTFILE; WriteF ('\n     Error opening output file.\n\n')
  ENDSELECT

  IF defsFileHandle THEN Close (defsFileHandle)
  IF procsFileHandle THEN Close (procsFileHandle)

  CleanUp (5)

ENDPROC
  /* main */
