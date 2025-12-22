/*
   EPP V1.4d - E Preprocessor.
   Copyright ©1993-1994 Barry Wills.  All rights reserved.
*/

MODULE 'exec/strings'

PMODULE 'PMODULES:commandLineArgs',
        'PMODULES:cSkipWhite',
        'PMODULES:cSkipToChar',
        'PMODULES:cSkipToEDelim',
        'PMODULES:openFile',
        'PMODULES:closeFile',
        'PMODULES:readStr'

/*===  Runtime exceptions.  ==============================================*/

ENUM ER_NONE,
     ER_MEM,
     ER_USAGE,
     ER_READING_FILE,
     ER_WRITING_FILE,
     ER_SYNTAX

RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL


/*===  Global constants.  ================================================*/

/*-- Largest identifier expected. --*/
CONST LARGEST_TOKEN_SUPPORTED=255

CONST SPACE=32,
      QUOTE=34,
      APOSTROPHE=39

/*------------------------------------------------------------------*
  These are used to process PMODULE and MODULE statements which have
  multiple names in their lists( i.e., PMODULE 'x', 'y', 'z').
 *------------------------------------------------------------------*/
ENUM MODE_GETANYTHING,
     MODE_GETPMODULE,
     MODE_GETEMODULE


/*===  Object type definitions.  =========================================*/

/*-- Read-buffer info.  One of these for each pmodule. --*/
OBJECT readDataType
  inputBuffer:LONG
  maxLength:LONG     /* physical max size of inputBuffer    */
  length:LONG        /* num bytes read into inputBuffer     */
  first:LONG         /* first byte read into inputBuffer    */
  pos:LONG           /* next available char in inputBuffer  */
  end:LONG           /* address of last byte in inputBuffer */
  turboMode:LONG     /* TURBO mode for this module only.    */
ENDOBJECT


/*===  Global variables.  ================================================*/

/*-- Main files. --*/
DEF defsFileHandle=NIL,     /* Main source file; all defs relocated into here. */
    procsFileHandle=NIL,    /* Temp file holds procs; finally appended to main. */
    defsMapFileHandle=NIL,  /* Main map; defs pmodule+line number map. */
    procsMapFileHandle=NIL  /* Procs pmodule+line number map; appended to main map. */

/*-- Main file names. --*/
DEF procsFileName=NIL,
    defsMapFileName=NIL,
    procsMapFileName=NIL

/*-- Command line args. --*/
DEF argMainModuleName=NIL,       /* STRING: Main module name. */
    argOutFileName=NIL,          /* STRING: Final output name, default 'temp_main.e' */
    argIncludeComments=NIL,      /* BOOL: Write pmodule info to final output? */
    argProgressIsVerbose=FALSE,  /* BOOL: Display runtime progress info? */
    argTurboMode=FALSE,          /* BOOL: NO-CARE process of procs? */
    argWBtoFront=FALSE,          /* BOOL: WbToFront()? (for scripts) */
    argSaveOutput=FALSE,         /* BOOL: Save final output source? */
    argKeepMapFile=FALSE,        /* BOOL: Save pmodule map file? */
    argCompile=TRUE,             /* BOOL: Call EC after processing? */
    argECOpts=NIL,               /* STRING: command line options to pass to EC. */
    argNoWarn=FALSE,             /* BOOL: Display UNREFERENCED messages gen'd by EC? */
    argExecute=NIL               /* STRING: command to execute upon final output file
                                  *         before calling EC. */

/*-- Module list vars. --*/
DEF theEmoduleList[1]:STRING,    /* Emodule names, for redundancy check. */
    thePmoduleList[1]:STRING     /* Pmodule names, for redundancy check. */

/*-- Misc work variables. --*/
DEF nestedCommentCount=0,    /* Tracks comment nesting. */
    defsLineNumber=0,        /* Current line number written to defs file. */
    procsLineNumber=0,       /* Current line number written to procs file. */
    userBreak=FALSE,         /* Logic control. */
    workStr=NIL:PTR TO CHAR, /* Just what it says. ;-) */
    moduleCount=0            /* Pmodule id, index to pmodule name in map file. */


/*===  Main procedures.  =================================================*/

/*-- File Operations. ----------------------------------------------------*/

PROC getArgs ()
/*-- Parse command line arguments. --*/
  DEF tempArg[108]:STRING, i=1, len, dash_EXECUTE=FALSE
  IF arg[]=0 THEN Raise(ER_USAGE)
  argECOpts:=[0]:CHAR
  WHILE getArg(tempArg, i++) AND (dash_EXECUTE=FALSE)
    IF tempArg[0]="-"
      /*-- Get switch. --*/
      IF tempArg[1]="v"  /* Progress messages. */
        argProgressIsVerbose:=TRUE
      ELSEIF tempArg[1]="c"  /* Include comments in output source. */
        argIncludeComments:=TRUE
      ELSEIF tempArg[1]="m"
        argKeepMapFile:=TRUE
      ELSEIF tempArg[1]="n"  /* No compilation. */
        argCompile:=FALSE
      ELSEIF tempArg[1]="t"  /* Turbo proc copy mode. */
        argTurboMode:=TRUE
      ELSEIF tempArg[1]="w"  /* Workbench to front. */
        argWBtoFront:=TRUE
      ELSEIF tempArg[1]="s"  /* Save final output. */
        argSaveOutput:=TRUE
      ELSEIF tempArg[1]="e"  /* EC options. */
        /** Abandoning static array on purpose. **/
        argECOpts:=String(len:=StrLen(tempArg)-1)
        StrCopy(argECOpts, '-', 1)
        StrAdd(argECOpts, tempArg+2, len)
        IF InStr(tempArg, 'n', 2)>-1 THEN argNoWarn:=TRUE
      ELSEIF tempArg[1]="x"  /* Execute command (last on command line). */
        dash_EXECUTE:=TRUE
      ENDIF
    ELSEIF argMainModuleName=NIL
      /* ...else not a switch:  get main input file name. */
      argMainModuleName:=String(StrLen(arg)+2)
      StrCopy(argMainModuleName, tempArg, ALL)
    ELSEIF argOutFileName=NIL
      /* ...else not a switch, already got main input file name, */
      /* so must be output file name.                            */
      argOutFileName:=String(StrLen(arg))
      StrCopy(argOutFileName, tempArg, ALL)
    ELSE
      /* ...else not a switch, already got main input file  */
      /* name and output file name, so too many args.       */
      Raise(ER_USAGE)
    ENDIF
  ENDWHILE
  IF argMainModuleName=NIL THEN Raise(ER_USAGE)
  /*-- Get -x (execute command) arg. --*/
  IF (i:=InStr(arg, ' -x', 0))>-1
    i:=arg+i+3
    argExecute:=String(len:=StrLen(i))
    StrCopy(argExecute, i, len)
    IF argExecute[]=QUOTE THEN argExecute[]:=$20
    IF argExecute[len-1]=QUOTE THEN argExecute[len-1]:=$20
  ENDIF
ENDPROC
  /* getArgs */

/*-- Misc Operations. ----------------------------------------------------*/

PROC buildEProgramName(theFileName)
  DEF fileExtension[2]:STRING
  MidStr(fileExtension, theFileName, StrLen(theFileName)-2, 2)
  LowerStr(fileExtension)
  IF StrCmp(fileExtension, '.e', ALL)=FALSE THEN StrAdd(theFileName, '.e', ALL)
ENDPROC
  /* buildEProgramName */

PROC getModuleName(name, startPos)
/*-- Look for a module name ('identifier') and place it in name. --*/
  DEF endPos, pos
  pos:=^startPos
  pos:=cSkipToChar(APOSTROPHE, pos)
  IF pos[]<>APOSTROPHE THEN Raise(ER_SYNTAX)
  INC pos
  endPos:=cSkipToChar(APOSTROPHE, pos)-pos
  IF pos[endPos]=APOSTROPHE
    MidStr(name, pos, 0, endPos)
    StrAdd(name, '.e', ALL)
    LowerStr(name)
    ^startPos:=pos+endPos
  ELSE
    ^startPos:=pos+endPos
    Raise(ER_SYNTAX)
  ENDIF
ENDPROC
  /* getModuleName */

PROC isInList(string:PTR TO CHAR, list)
/*-- Search linked estrings for a match. --*/
  REPEAT
    IF StrCmp(list, string, ALL) THEN RETURN TRUE
  UNTIL (list:=Next(list))=NIL
ENDPROC FALSE
  /* isInList */

PROC incLineNumberFor(fh)
/*-- Logic to increment global line number depending on file written to. --*/
  SELECT fh
    CASE procsFileHandle; INC procsLineNumber
    DEFAULT;              INC defsLineNumber
  ENDSELECT
ENDPROC
  /* incLineNumberFor */

PROC isEDelim(c)
/*-- If it ain't a number, an u- or l-case letter, or an underscore, it's a delimiter. --*/
  IF c>122 THEN RETURN TRUE     /* "z" */
  IF c<95                       /* "_" */
    IF c>90 THEN RETURN TRUE    /* "Z" */
    IF c<65                     /* "A" */
      IF c>57 THEN RETURN TRUE  /* "9" */
      IF c<48 THEN RETURN TRUE  /* "0" */
    ENDIF
  ENDIF
ENDPROC FALSE
  /* isEDelim */

/*--EE--
PROC putLine(s)
  REPEAT
    Out(stdout,s[])
  UNTIL s[]++=LF
ENDPROC
  --EE--*/
  /* putLine */

/*-- File Operations. ----------------------------------------------------*/

PROC read(fileHandle, rData:PTR TO readDataType)
/*-- Buffered read with no-copy, very fast. --*/
  DEF inputBuffer, endOfBuffer, maxLength, lineLength=0, pos
  inputBuffer:=rData.inputBuffer
  rData.first:=pos:=rData.pos
  endOfBuffer:=rData.end
  IF pos>=endOfBuffer THEN RETURN -1  /* end of file */
  maxLength:=rData.maxLength
  IF rData.length=0
    rData.length:=Read(fileHandle, inputBuffer, maxLength)
    IF rData.length<maxLength THEN Raise(ER_READING_FILE)
    /*-----------------------------------------------------------*
      End-of-buffer massage to fix hang-n-crash when last line is
      missing LF.  Consequently fixes EC's "missing ENDPROC" bug:
     *-----------------------------------------------------------*/
    IF endOfBuffer[]<>10
      endOfBuffer[1]++:=LF
      INC maxLength
      rData.maxLength:=maxLength
      rData.length:=maxLength
      rData.end:=inputBuffer+maxLength-1
    ENDIF
    /*-- End massage code.-- */
    endOfBuffer[1]:=NIL
  ENDIF
  WHILE pos[]++<>LF DO INC lineLength
  rData.pos:=pos
ENDPROC lineLength+1
  /* read */

PROC copyFile(sourceName, destName) HANDLE
/*-- Just what it says, called if Rename() doesn't work. --*/
  DEF sfh, dfh, buf, bufLen
  buf:=New(bufLen:=FileLength(sourceName))
  sfh:=openFile(sourceName, OLDFILE)
  dfh:=openFile(destName, NEWFILE)
  IF Read(sfh, buf, bufLen)<bufLen THEN Raise(ER_READING_FILE)
  IF Write(dfh, buf, bufLen)<bufLen THEN Raise(ER_WRITING_FILE)
  closeFile(sfh)
  closeFile(dfh)
EXCEPT
  closeFile(sfh)
  closeFile(dfh)
  SELECT exception
    CASE ER_READING_FILE; WriteF('\n***READ: \s\n\n', sourceName)
    CASE ER_WRITING_FILE; WriteF('\n***WRITE: \s\n\n', destName)
  ENDSELECT
  WriteF('\n   Copy-file unsuccessful.')
  RETURN FALSE
ENDPROC TRUE
  /* copyFile */

PROC appendProcsToDefs()
/*-- Append temporary procs file to end of defs file. --*/
  DEF sourceLine, length, bytesRead=0
  IF argProgressIsVerbose THEN WriteF('\n »»» Writing procs-file to end of defs-file.')
  procsFileHandle:=closeFile(procsFileHandle)
  sourceLine:=New(length:=FileLength(procsFileName))
  procsFileHandle:=openFile(procsFileName, OLDFILE)
  IF (bytesRead:=Read(procsFileHandle, sourceLine, length))>0
    IF Write(defsFileHandle, sourceLine, bytesRead)<bytesRead
      WriteF('\n***ERROR WRITING OUTPUT FILE\n\n')
      Raise(ER_WRITING_FILE)
    ENDIF
  ENDIF
ENDPROC
  /* appendProcsToDefs */

/*-- Map File Operations. ------------------------------------------------*/

PROC writeMapIndex(source_fh, moduleId, localLineCount)
/*-------------------------------------------------------------*
  Writes module id, global line number, and local line number to main- or
  temp-mapfile, depending on file being written to by calling function.
 *-------------------------------------------------------------*/
  DEF lineNumber, map_fh
  SELECT source_fh
    CASE procsFileHandle; lineNumber:=procsLineNumber; map_fh:=procsMapFileHandle
    DEFAULT;              lineNumber:=defsLineNumber;  map_fh:=defsMapFileHandle
  ENDSELECT
  IF Write(map_fh, [moduleId, lineNumber, localLineCount]:INT, 6)<6 THEN Raise(ER_WRITING_FILE)
ENDPROC
  /* writeMapIndex */

PROC writeMapBody() HANDLE
/*-------------------------------------------------------------------------*
  Writes module names to end of temp-mapfile before closing.  Since name
  strings are linked in reverse order, they must be put in the right order.
 *-------------------------------------------------------------------------*/
  DEF moduleName, i, len, modNames:PTR TO LONG
  modNames:=New(moduleCount*4)
  moduleName:=thePmoduleList
  FOR i:=moduleCount TO 1 STEP -1
    modNames[i-1]:=moduleName
    moduleName:=Next(moduleName)
  ENDFOR
  FOR i:=1 TO moduleCount
    IF Write(procsMapFileHandle, modNames[i-1], len:=EstrLen(modNames[i-1]))<len THEN Raise(ER_WRITING_FILE)
    IF Write(procsMapFileHandle, '\n', 1)<1 THEN Raise(ER_WRITING_FILE)
  ENDFOR
EXCEPT
  WriteF('\n***ERROR WRITING MAP BODY\n')
  Raise(exception)
ENDPROC
  /* writeMapBody */

PROC joinMapFileHalves() HANDLE
/*--------------------------------------------------------------------------*
  Append temp-mapfile onto main-mapfile.  Since the procs lines were counted
  separately, they must be computed relative to the defs line numbers.
 *--------------------------------------------------------------------------*/
  DEF index:PTR TO INT, fileLength, intPtr:PTR TO INT
  procsMapFileHandle:=closeFile(procsMapFileHandle)
  intPtr:=index:=New(fileLength:=FileLength(procsMapFileName))
  procsMapFileHandle:=openFile(procsMapFileName, OLDFILE)
  IF Read(procsMapFileHandle, index, fileLength)<fileLength THEN Raise(ER_READING_FILE)
  REPEAT
    intPtr[1]:=intPtr[1]+defsLineNumber
    intPtr:=intPtr+6
  UNTIL intPtr[0]=0
  intPtr[1]:=intPtr[1]+defsLineNumber
  IF Write(defsMapFileHandle, index, fileLength)<fileLength THEN Raise(ER_WRITING_FILE)
EXCEPT
  SELECT exception
    CASE ER_READING_FILE; WriteF('\n***ERROR READING MAP FILE\n\n')
    CASE ER_WRITING_FILE; WriteF('\n***ERROR WRITING MAP FILE\n\n')
  ENDSELECT
  Raise(exception)
ENDPROC
  /* joinMapFileHalves */

/*-- Parsing Operations. -------------------------------------------------*/

PROC continueGettingComments(pos:PTR TO CHAR)
/*-- Go until eoln, or no comments are left open. --*/
  DEF p:PTR TO CHAR
  p:=^pos
  WHILE p[]<>LF AND nestedCommentCount
    IF p[]="*"    /* Closing comment? */
      IF p[1]="/"
        DEC nestedCommentCount
        INC p
      ENDIF
    ELSEIF p[]="/"    /* Nested comment? */
      IF p[1]="*"
        INC nestedCommentCount
        INC p
      ENDIF
    ENDIF
    INC p
  ENDWHILE
  ^pos:=p
ENDPROC
  /* continueGettingComments */

PROC checkEnclosing (pos:PTR TO CHAR, c)
/*-- Check for an opening delimiter, continue until closed or eoln. --*/
  DEF p:PTR TO CHAR
  p:=^pos
  /*-- If found an open quote, "'", or comment, search for it's partner --*/
  IF c=APOSTROPHE
    REPEAT
      INC p
    UNTIL (p[]=LF) OR (p[]=APOSTROPHE)
  ELSEIF c=QUOTE
    REPEAT
      INC p
    UNTIL (p[]=LF) OR (p[]=QUOTE)
  ELSEIF c="/"
    IF p[1]="*"
      p:=p+2
      INC nestedCommentCount
      continueGettingComments({p})
    ENDIF
  ELSEIF c="*"
    IF p[1]="/"
      p:=p+2
      DEC nestedCommentCount
      IF nestedCommentCount THEN continueGettingComments({p})
    ENDIF
  ENDIF
  ^pos:=p
ENDPROC
  /* checkEnclosing */

PROC skipToValidToken(pos:PTR TO CHAR, sourceLine:PTR TO CHAR)
/*--------------------------------------------------------------*
  Finds the next important E or EPP keyword and returns its pos.
  Main purpose is to eat whitespace and indentifiers.
 *--------------------------------------------------------------*/
  DEF c, oldPos
  /*-- Nested comments?  If so, find closing comment brackets. --*/
  IF nestedCommentCount THEN continueGettingComments({pos})
  WHILE (c:=pos[])<>LF
    oldPos:=pos
    /*-- Check opening delimiters. --*/
    SELECT c
      CASE APOSTROPHE
        checkEnclosing({pos}, c)
      CASE QUOTE
        checkEnclosing({pos}, c)
      CASE "/"
        checkEnclosing({pos}, c)
      CASE "*"
        checkEnclosing({pos}, c)
      CASE "-"  /* One-line comment */
        IF pos[1]=">"
          WHILE pos[]<>LF DO INC pos
          RETURN pos
        ENDIF
      DEFAULT
        /*-- Else, check E or EPP keyword. --*/
        IF (pos=sourceLine) OR isEDelim(pos[-1])
          SELECT c
            CASE "P"  /* PROC or PMODULE */
              IF (pos[1]="R") OR (pos[1]="M") THEN RETURN pos
            CASE "E"  /* ENDPROC or ENUM */
              IF pos[1]="N" THEN RETURN pos
            CASE "D"  /* DEF */
              IF pos[1]="E" THEN RETURN pos
            CASE "C"  /* CONST */
              IF pos[1]="O" THEN RETURN pos
            CASE "M"  /* MODULE */
              IF pos[1]="O" THEN RETURN pos
            CASE "O"  /* OPT or OBJECT */
              IF (pos[1]="P") OR (pos[1]="B") THEN RETURN pos
            CASE "R"  /* RAISE */
              IF pos[1]="A" THEN RETURN pos
          ENDSELECT
        ENDIF
    ENDSELECT
    IF (pos[]<>LF) AND (pos=oldPos) THEN INC pos
  ENDWHILE
ENDPROC pos
  /* skipToValidToken */

PROC getToken(token:PTR TO CHAR, startPos:PTR TO CHAR)
/*--  Get an E token and place it in token. --*/
  DEF endPos
  startPos:=cSkipWhite(startPos)
  endPos:=cSkipToEDelim(startPos)-startPos
  IF endPos>0
    MidStr(token, startPos, 0, endPos)
  ELSE
    SetStr(token, 0)
  ENDIF
ENDPROC startPos+endPos
  /* getToken */

PROC getOrFakeModuleToken(tempStr, pos, mode)
/*------------------------------------------------------------------------*
  Fakes MODULE and PMODULE keywords when processing continuation of these
  statements  (i.e., multiple names in lists, e.g., MODULE 'x', 'y', 'z').
 *------------------------------------------------------------------------*/
  IF mode=MODE_GETANYTHING
    pos:=getToken(tempStr, pos)
  ELSE
    StrCopy(tempStr, IF mode=MODE_GETPMODULE THEN 'PMODULE' ELSE 'MODULE', ALL)
    pos:=advanceInModuleNameList(pos, {mode}, "'")
    IF (mode=MODE_GETANYTHING) OR (pos[]=LF) THEN SetStr(tempStr, 0)
  ENDIF
ENDPROC pos
  /* getOrFakeModuleToken */

PROC advanceInModuleNameList(pos, mode, lookForChar)
/*----------------------------------------------------------------------*
  Move pos to next crucial position in MODULE or PMODULE statement list.
  Primary purpose of this function is to eat whitespace and comments.
  Two possible initial states:  1) looking for start of a module name
  literal; lookForChar="'"; pos may be resting on any char; 2) looking
  for continuation; lookForChar=","; pos will be resting on "'" (hence
  it must be INC'ed at the start); if found, then lookForChar is changed
  to "'" to set up for reading next module name literal.  In both cases,
  if any nonwhite/non-comment char is found, a syntax error results.
 *----------------------------------------------------------------------*/
  DEF done=FALSE, foundContinuation=FALSE
  IF lookForChar="," THEN INC pos
  WHILE done=FALSE
    IF (pos[]="/") AND (pos[1]="*")
      INC nestedCommentCount
      pos:=pos+2
      continueGettingComments({pos})
    ELSEIF pos[]=LF
      IF (nestedCommentCount=0) AND
         (foundContinuation=FALSE) THEN ^mode:=MODE_GETANYTHING
      done:=TRUE
    ELSEIF nestedCommentCount
      continueGettingComments({pos})
    ELSEIF (pos[]>0) AND (pos[]<=SPACE)
      INC pos
    ELSEIF pos[]=lookForChar
      IF lookForChar=","
        lookForChar:="'"
        INC pos
        foundContinuation:=TRUE
      ELSE
        done:=TRUE
      ENDIF
    ELSEIF (pos[]="-") AND (pos[1]=">")
      WHILE pos[]<>LF DO INC pos
      done:=TRUE
    ELSEIF (pos[]=";") AND (lookForChar=",")
      INC pos
      ^mode:=MODE_GETANYTHING
      done:=TRUE
    ELSE
      Raise(ER_SYNTAX)
    ENDIF
  ENDWHILE
ENDPROC pos
  /* advanceInModuleNameList */

PROC handleNewEmodule(tempStr, fh)
/*-- Get Emodule name.  Ignore if already in list, else write a MODULE statement. --*/
  DEF emoduleName
  IF isInList(tempStr, theEmoduleList)=FALSE
    Write(fh, 'MODULE ''', STRLEN)
    Write(fh, tempStr, EstrLen(tempStr)-2)
    Write(fh, '\a;', STRLEN)
    emoduleName:=String(EstrLen(tempStr))
    StrCopy(emoduleName, tempStr, ALL)
    theEmoduleList:=Link(emoduleName, theEmoduleList)
    RETURN TRUE
  ENDIF
ENDPROC FALSE
  /* handleNewEmodule */

PROC copyProc (rData:PTR TO readDataType,  /* Input file buffer info. */
               sourceLine,         /* The current source line being considered. */
               inFileHandle,       /* Which file to continue reading from. */
               moduleName,         /* Module name. */
               moduleId,           /* For module mapping/error reporting */
               tempStr,            /* Work string. */
               currentPos,         /* Where sourceLine examination is to continue. */
               length,             /* Length of current sourceLine. */
               lineCount)          /* Module line num, for error reporting. */
/*---------------------------------------------------------------------*
  Copy until uncommented ENDPROC is found.  When this procedure is
  called we are never within a comment.  May need to process MODULE and
  PMODULE statements on the way.
 *---------------------------------------------------------------------*/
  DEF keywordENDPROCfound,   /* Indicates we found the whole proc. */
      mode=MODE_GETANYTHING, /* Signals MODULE or PMODULE statement continuation. */
      pos:PTR TO CHAR
  IF argIncludeComments
    Write(procsFileHandle, '\n/*** Procedure included from ', 30)
    Write(procsFileHandle, moduleName, StrLen (moduleName))
    Write(procsFileHandle, ' ***/\n', 6)
    procsLineNumber:=procsLineNumber+2
  ENDIF
  IF argTurboMode OR rData.turboMode
    IF argProgressIsVerbose
      WriteF('\n     Turbo module:  \a\s\a', moduleName)
    ENDIF
    IF argIncludeComments
      Write(procsFileHandle, '/*** Turbo dump of module ', 26)
      Write(procsFileHandle, moduleName, StrLen (moduleName))
      Write(procsFileHandle, ' ***/\n', 6)
      INC procsLineNumber
    ENDIF
    /*-- Init for turbo writing, account for LFs in remainder of file. --*/
    pos:=^sourceLine
    INC procsLineNumber
    writeMapIndex(procsFileHandle, moduleId, ^lineCount)
    DEC procsLineNumber
    WHILE pos[]++ DO IF pos[]=LF THEN INC procsLineNumber
    /*-- Write remainder of current source line. --*/
    Write(procsFileHandle, ^sourceLine, ^length)
    /*-- Dump rest of file in one Write(). --*/
    ^currentPos:=(^sourceLine)+(^length)-1
    ^length:=rData.maxLength-(rData.pos-rData.inputBuffer)
    IF Write(procsFileHandle, rData.pos, ^length)<^length THEN Raise(ER_WRITING_FILE)
    /*-- Fake EOF and get out. --*/
    ^length:=0
    rData.pos:=rData.inputBuffer+rData.maxLength-1
    RETURN
  ENDIF
  /*-- Omit PROC main () in all but main module. --*/
  ^currentPos:=getToken(tempStr, ^currentPos)
  IF StrCmp(tempStr, 'main', ALL)
    IF StrCmp(moduleName, argMainModuleName, ALL)=FALSE
      IF argIncludeComments
        Write(procsFileHandle, '/*** Superfluous PROC main () omitted ***/\n\n', 44)
        procsLineNumber:=procsLineNumber+2
      ENDIF
      ^currentPos:=(^sourceLine)+(^length)-1
      rData.pos:=rData.inputBuffer+rData.maxLength-1
      RETURN
    ENDIF
  ENDIF
  /*-- Else, normal copy of a proc. --*/
  IF argProgressIsVerbose THEN WriteF('\n     Copying proc:  \a\s\a', tempStr)
  pos:=^currentPos
  LOOP
    keywordENDPROCfound:=FALSE
    WHILE (pos[]<>LF) AND (pos[]<>0)
      /*-- Quick skip to valid character, instead of parsing each char --*/
      IF mode=MODE_GETANYTHING THEN pos:=skipToValidToken(pos, ^sourceLine)
      IF pos[]="E" AND pos[1]="N"
        /*-- Could be we found ENDPROC. --*/
        pos:=getToken(tempStr, pos)
        IF StrCmp(tempStr, 'ENDPROC', ALL) THEN keywordENDPROCfound:=TRUE
      ELSEIF pos[]="P" AND pos[1]="R"
        /*-- Could be we found another PROC (this was a one-liner). --*/
        pos:=getToken(tempStr, pos)
        IF StrCmp(tempStr, 'PROC', ALL)
          copyProc(rData, sourceLine, inFileHandle, moduleName, moduleId,
                   tempStr, {pos}, length, lineCount)
          ^sourceLine:=pos   /* sourceLine comes back with 'ENDPROC'  */
          ^length:=0         /* in it.  Don't want to write it again. */
          pos:=^sourceLine
          keywordENDPROCfound:=TRUE
        ENDIF
      ELSEIF (mode=MODE_GETPMODULE) OR ((pos[]="P") AND (pos[1]="M"))
        /*-- PMODULE statement after a one-liner? --*/
        pos:=getOrFakeModuleToken(tempStr, pos, mode)
        IF StrCmp(tempStr, 'PMODULE', ALL)
          getModuleName(tempStr, {pos})
          getModule(tempStr)
          /*-- Shorten sourceLine to get rid of the PMODULE statement. --*/
          mode:=MODE_GETPMODULE
          pos:=advanceInModuleNameList(pos, {mode}, ",")
          ^length:=^length-(pos-^sourceLine)
          ^sourceLine:=pos
          IF pos[]<>LF THEN DEC pos
        ENDIF
      ELSEIF (mode=MODE_GETEMODULE) OR ((pos[]="M") AND (pos[1]="O"))
        /*-- MODULE statement after a one-liner? --*/
        pos:=getOrFakeModuleToken(tempStr, pos, mode)
        IF StrCmp(tempStr, 'MODULE', ALL)
          getModuleName(tempStr, {pos})
          handleNewEmodule(tempStr, procsFileHandle)
          /*-- Shorten sourceLine to get rid of the MODULE statement. --*/
          mode:=MODE_GETEMODULE
          pos:=advanceInModuleNameList(pos, {mode}, ",")
          ^length:=^length-(pos-^sourceLine)
          ^sourceLine:=pos
          IF pos[]<>LF THEN DEC pos
        ENDIF
      ELSEIF pos[]="O"
        /*-- See if we found OPT TURBO option after a one-liner? --*/
        pos:=getToken(tempStr, pos)
        IF StrCmp(tempStr, 'OPT', ALL)
          pos:=getToken(tempStr, pos)
          IF StrCmp(tempStr, 'TURBO', ALL)
            rData.turboMode:=TRUE
            ^length:=^length-(pos-^sourceLine)
            ^sourceLine:=pos
            DEC pos
          ENDIF
        ENDIF
      ENDIF
      IF (pos[]<>LF) AND (pos[]<>0) THEN INC pos
    ENDWHILE
    IF ^length>0  /* <== messy leftover; may not need anymore */
      IF Write(procsFileHandle, ^sourceLine, ^length)<0 THEN Raise(ER_WRITING_FILE)
      INC procsLineNumber
      writeMapIndex(procsFileHandle, moduleId, ^lineCount)
    ENDIF
    IF keywordENDPROCfound
      ^currentPos:=pos
      RETURN
    ENDIF
    ^length:=read(inFileHandle, rData)
    ^sourceLine:=rData.first
    ^currentPos:=^sourceLine
    IF ^length<1
      /*--------------------------------------------------------------------*
        If EOF and ENDPROC not found, must assume one-line PROC transcending
        more than one line.  There is no way to enforce ENRPCO without doing
        full-blown syntax checking of a PROC statement.
       *--------------------------------------------------------------------*/
      ^currentPos:=pos
      RETURN
    ENDIF
    ^lineCount:=^lineCount+1
    pos:=^sourceLine
  ENDLOOP
ENDPROC
  /* copyProc */

PROC copyDefs (rData:PTR TO readDataType,  /* Input file buffer info. */
               sourceLine,         /* The current source line being considered. */
               inFileHandle,       /* Which file to continue reading from. */
               moduleName,         /* Name of module. */
               moduleId,           /* For module mapping/error reporting */
               tempStr,            /* Work string. */
               currentPos,         /* Where sourceLine examination is to continue. */
               length,             /* Number of chars to write from sourceLine. */
               lineCount,          /* Module's line num, for error reporting. */
               lastFileWrittenTo)  /* Must change if we need to make a call to copyProc. */
/*---------------------------------------------------------------------*
  Copy until a PROC keyword or eof is encountered.  When this procedure
  called we are never within a comment.  Need to process MODULE and
  PMUDULE statements on the way.
 *---------------------------------------------------------------------*/
  DEF pos:PTR TO CHAR,
      mode=MODE_GETANYTHING /* Signals MODULE or PMODULE statement continuation. */
  IF argProgressIsVerbose THEN WriteF('\n     Copying defs:  \a\s\a', moduleName)
  IF argIncludeComments
    Write(defsFileHandle, '/*** Declarations included from ', 32)
    Write(defsFileHandle, moduleName, StrLen (moduleName))
    Write(defsFileHandle, ' ***/\n', 6)
    INC defsLineNumber
  ENDIF
  pos:=^currentPos
  LOOP
    WHILE (pos[]<>LF) AND (pos[]<>0)
      /*-- Quick skip to E keyword. --*/
      IF mode=MODE_GETANYTHING THEN pos:=skipToValidToken(pos, ^sourceLine)
      IF (pos[]="P") AND (pos[1]="R")
        /*-- Found beginning of PROC section? --*/
        pos:=getToken(tempStr, pos)
        IF StrCmp(tempStr, 'PROC', ALL)
          ^lastFileWrittenTo:=procsFileHandle
          copyProc(rData, sourceLine, inFileHandle, moduleName, moduleId,
                   tempStr, {pos}, length, lineCount)
          ^currentPos:=pos
          RETURN
        ENDIF
      ELSEIF (mode=MODE_GETPMODULE) OR ((pos[]="P") AND (pos[1]="M"))
        /*-- Found a PMODULE statement? --*/
        pos:=getOrFakeModuleToken(tempStr, pos, mode)
        IF StrCmp(tempStr, 'PMODULE', ALL)
          getModuleName(tempStr, {pos})
          getModule(tempStr)
          /*-- Shorten sourceLine to get rid of the PMODULE statement. --*/
          mode:=MODE_GETPMODULE
          pos:=advanceInModuleNameList(pos, {mode}, ",")
          ^length:=^length-(pos-^sourceLine)
          ^sourceLine:=pos
          IF pos[]<>LF THEN DEC pos
        ENDIF
      ELSEIF (mode=MODE_GETEMODULE) OR ((pos[]="M") AND (pos[1]="O"))
        /*-- Found a MODULE statement? --*/
        pos:=getOrFakeModuleToken(tempStr, pos, mode)
        IF StrCmp(tempStr, 'MODULE', ALL)
          getModuleName(tempStr, {pos})
          handleNewEmodule(tempStr, defsFileHandle)
          /*-- Shorten sourceLine to get rid of the MODULE statement. --*/
          mode:=MODE_GETEMODULE
          pos:=advanceInModuleNameList(pos, {mode}, ",")
          ^length:=^length-(pos-^sourceLine)
          ^sourceLine:=pos
          IF pos[]<>LF THEN DEC pos
        ENDIF
      ELSEIF pos[]="O"
        /*-- Found OPT TURBO option? --*/
        pos:=getToken(tempStr, pos)
        IF StrCmp(tempStr, 'OPT', ALL)
          pos:=getToken(tempStr, pos)
          IF StrCmp(tempStr, 'TURBO', ALL)
            rData.turboMode:=TRUE
            ^length:=^length-(pos-^sourceLine)
            ^sourceLine:=pos
            DEC pos
          ENDIF
        ENDIF
      ENDIF
      IF (pos[]<>LF) AND (pos[]<>0) THEN INC pos
    ENDWHILE
    IF length>0  /* <== messy leftover; may not need anymore */
      IF Write(defsFileHandle, ^sourceLine, ^length)<0 THEN Raise(ER_WRITING_FILE)
      INC defsLineNumber
      writeMapIndex(defsFileHandle, moduleId, ^lineCount)
    ENDIF
    ^length:=read(inFileHandle, rData)
    ^sourceLine:=rData.first
    ^currentPos:=^sourceLine
    IF ^length<1
      ^currentPos:=pos
      RETURN
    ENDIF
    ^lineCount:=^lineCount+1
    pos:=^sourceLine
  ENDLOOP
ENDPROC
  /* copyDefs */

PROC getModule(theModuleName) HANDLE
  DEF rData:PTR TO readDataType,  /* File buffer info used for theModuleName. */
      sourceLine,          /* Pointer to line of source. */
      fileHandle=NIL,      /* File handle used for theModuleName. */
      lastFileWrittenTo,   /* Where to put misc lines, for better source readability. */
      length,              /* Number of chars in sourceLine to write. */
      pos:PTR TO CHAR,     /* Current character index. */
      lineCount=0,         /* Line num in the module, for error reporting. */
      tempStr,             /* Work string. */
      lineRecognized,      /* Flag indicates if the line has been handled yet by */
                           /*  copyDefs or copyProc, or must still be written. */
      doCopyDefs,          /* Controls logic based on OPT keyword. */
      moduleId,            /* Module's pos in moduleNameList, for error reporting. */
      mode=MODE_GETANYTHING /* Signals MODULE or PMODULE statement continuation. */
/*--------------------------------------------------------------------*
  Point of entry for all recursive PMODULE processing.  Fires up a new
  context for a Pmodule.  Aborts immediately if duplicate inclusion.
 *--------------------------------------------------------------------*/
  IF isInList(theModuleName, thePmoduleList)
    IF argProgressIsVerbose THEN WriteF('\n ··· Duplicate definition omitted:  \a\s\a', theModuleName)
    RETURN
  ELSE
    IF argProgressIsVerbose
      WriteF('\n »»» \s   \a\s\a',
             IF StrCmp(theModuleName,
                       argMainModuleName, ALL) THEN 'Main module:' ELSE 'New module: ',
             theModuleName)
    ENDIF
    INC moduleCount
    moduleId:=moduleCount
    tempStr:=String(StrLen(theModuleName))
    StrCopy(tempStr, theModuleName, ALL)
    thePmoduleList:=Link(tempStr, thePmoduleList)
  ENDIF
  /*-- Set up an object for interfacing with read(). --*/
  fileHandle:=openFile(theModuleName, OLDFILE)
  rData:=New(SIZEOF readDataType)
  rData.maxLength:=FileLength(theModuleName)
  rData.length:=0
  rData.inputBuffer:=New(rData.maxLength+2) /* +1 in case of missing LF at eof */
  rData.pos:=rData.inputBuffer
  rData.end:=rData.inputBuffer+rData.maxLength-1
  rData.turboMode:=FALSE
  tempStr:=String(LARGEST_TOKEN_SUPPORTED)  /* Work string for this Pmodule. */
  lastFileWrittenTo:=defsFileHandle         /* Track where last write went. */
  /*-- Keep reading until eof, process keywords on the way. --*/
  WHILE (length:=read(fileHandle, rData))>-1 AND (userBreak=FALSE)
    /*-- Initialize substring search. --*/
    INC lineCount
    pos:=sourceLine:=rData.first
    lineRecognized:=FALSE
    WHILE (pos[]<>LF) AND (pos[]<>0)  /* Until end of line. */
      /*-- Quick skip to valid character, instead of parsing in big loop. --*/
      IF mode=MODE_GETANYTHING THEN pos:=skipToValidToken(pos, sourceLine)
      IF (pos[]="P") AND (pos[1]="R")
        pos:=getToken(tempStr, pos)
        IF StrCmp(tempStr, 'PROC', ALL)
          copyProc (rData, {sourceLine}, fileHandle, theModuleName, moduleId,
                    tempStr, {pos}, {length}, {lineCount})
          lastFileWrittenTo:=procsFileHandle
          lineRecognized:=TRUE
        ENDIF
      ELSEIF (mode=MODE_GETPMODULE) OR ((pos[]="P") AND (pos[1]="M"))
        pos:=getOrFakeModuleToken(tempStr, pos, mode)
        IF StrCmp(tempStr, 'PMODULE', ALL)
          getModuleName(tempStr, {pos})
          getModule(tempStr)
          /*-- Shorten sourceLine to get rid of the PMODULE statement. --*/
          mode:=MODE_GETPMODULE
          pos:=advanceInModuleNameList(pos, {mode}, ",")
          length:=length-(pos-sourceLine)
          sourceLine:=pos
          IF pos[]<>LF THEN DEC pos
        ENDIF
      ELSEIF (mode=MODE_GETEMODULE) OR ((pos[]="M") AND (pos[1]="O"))
        pos:=getOrFakeModuleToken(tempStr, pos, mode)
        IF StrCmp(tempStr, 'MODULE', ALL)
          getModuleName(tempStr, {pos})
          handleNewEmodule(tempStr, lastFileWrittenTo)
          /*-- Shorten sourceLine to get rid of the MODULE statement. --*/
          mode:=MODE_GETEMODULE
          pos:=advanceInModuleNameList(pos, {mode}, ",")
          length:=length-(pos-sourceLine)
          sourceLine:=pos
          IF pos[]<>LF THEN DEC pos
        ENDIF
      ELSEIF (pos[]="O") OR
             (pos[]="D") OR
             (pos[]="C") OR
             (pos[]="E") OR
             (pos[]="R")
        pos:=getToken(tempStr, pos)
        IF InStr('OPT OBJECT DEF CONST ENUM RAISE MODULE ', tempStr, NIL)>-1
          doCopyDefs:=TRUE  /* Controls the following IF block. */
          IF StrCmp(tempStr, 'OPT', ALL)
            /*-- See if we found OPT TURBO option. --*/
            pos:=getToken(tempStr, pos)
            IF StrCmp(tempStr, 'TURBO', ALL)
              rData.turboMode:=TRUE
              /*-- Remove OPT TURBO statement. --*/
              length:=length-(pos-sourceLine)
              sourceLine:=pos
              DEC pos
              doCopyDefs:=FALSE
            ENDIF
          ENDIF
          /*-- Was it a def, or was it OPT TURBO? --*/
          IF doCopyDefs
            lastFileWrittenTo:=defsFileHandle
            copyDefs (rData, {sourceLine}, fileHandle, theModuleName, moduleId,
                      tempStr, {pos}, {length}, {lineCount},
                      {lastFileWrittenTo})
            lineRecognized:=TRUE
          ENDIF
        ENDIF
      ENDIF
      IF (pos[]<>LF) AND (pos[]<>0) THEN INC pos
    ENDWHILE  /* EOLN */
    IF (lineRecognized=FALSE) AND (length>0)
      IF Write(lastFileWrittenTo, sourceLine, length) < 0 THEN Raise (ER_WRITING_FILE)
      incLineNumberFor(lastFileWrittenTo)
      writeMapIndex(lastFileWrittenTo, moduleId, lineCount)
    ENDIF
    IF CtrlC() THEN userBreak:=TRUE
  ENDWHILE  /* EOF */
  closeFile(fileHandle)
  Dispose(rData.inputBuffer)
  Dispose(rData)
EXCEPT
  closeFile(fileHandle)
  SELECT exception
    CASE ER_SYNTAX
      WriteF('\n***SYNTAX ERROR: PMODULE \a\s\a, LINE \d, POS \d\n\n',
             theModuleName, lineCount, pos-sourceLine)
    CASE ER_READING_FILE
      WriteF('\n***ERROR READING PMODULE \s\n', theModuleName)
    CASE ER_WRITING_FILE
      WriteF('\n***ERROR WRITING ')
      IF lastFileWrittenTo=procsFileHandle
        WriteF('PROCS FILE \s\n', procsFileName)
      ELSE
        WriteF('DEFS FILE \s\n', argMainModuleName)
      ENDIF
    DEFAULT
      Raise(exception)
  ENDSELECT
  Raise(ER_NONE)
ENDPROC
  /* getModule */

PROC reportError(mainLineNumber) HANDLE
/*--------------------------------------------------*
  Use map file to correct error line number reported
  by EC, and find out what the module name is.
 *--------------------------------------------------*/
  DEF index:PTR TO INT, moduleId=1, moduleLineNumber,
      localLineNumber, globalLineNumber, i=0
  index:=[0, 0, 0]:INT
  defsMapFileHandle:=openFile(defsMapFileName, OLDFILE)
  REPEAT
    IF index[1]<=mainLineNumber
      moduleId:=index[0]
      globalLineNumber:=index[1]
      localLineNumber:=index[2]
    ENDIF
    IF Read(defsMapFileHandle, index, 6)<6 THEN Raise(ER_READING_FILE)
  UNTIL index[0]=0
  WHILE i++<moduleId DO readStr(defsMapFileHandle, workStr)
  moduleLineNumber:=mainLineNumber-globalLineNumber+localLineNumber
  WriteF('***EPP: CORRECTED LINE \d, PMODULE ''\s''\n', moduleLineNumber, workStr)
  defsMapFileHandle:=closeFile(defsMapFileHandle)
EXCEPT
  defsMapFileHandle:=closeFile(defsMapFileHandle)
  IF exception=ER_READING_FILE THEN WriteF('\n***INTERNAL ERROR READING MAP FILE\n\n')
ENDPROC
  /* reportError */

PROC compile() HANDLE
/*-- Compiler interface. --*/
  DEF fh=NIL, errorFilename,
      warningsOccurred=FALSE, compileError=FALSE,
      inStr, numRead, srcNameLen, errorLine=0
  IF argProgressIsVerbose THEN WriteF('\n »»» Compiling...')
  /*-- Build command line (redirect EC output to tempfile). --*/
  errorFilename:='T:EPP.er'
  srcNameLen:=StrLen(argOutFileName)-2
  StringF(workStr, '\s\s ', 'EC >', errorFilename)
  IF argECOpts[]
    StrAdd(workStr, argECOpts, ALL)
    StrAdd(workStr, ' ', ALL)
  ENDIF
  StrAdd(workStr, argOutFileName, srcNameLen)
  /*-- Call EC. --*/
  IF Execute(workStr, NIL, NIL)=0 THEN Raise("CMD0")
  /*-- Report status gleaned from reading redirected output of EC. --*/
  fh:=openFile(errorFilename, OLDFILE)
  WHILE readStr(fh, workStr)>-1
    SetStr(workStr, StrLen(workStr))
    IF InStr(workStr, 'ERROR', 0)>-1
      WriteF('\s\n', workStr)
      compileError:=TRUE
    ELSEIF (InStr(workStr, 'UNREF', 0)>-1) AND (argNoWarn=FALSE)
      WriteF('\s\n', workStr)
      warningsOccurred:=TRUE
    ELSEIF (InStr(workStr, 'WARN', 0)>-1) AND (argNoWarn=FALSE)
      WriteF('\s\n', workStr)
      warningsOccurred:=TRUE
    ELSEIF (InStr(workStr, 'WITH', 0)>-1)
      WriteF('\s\n', workStr)
    ENDIF
    IF (inStr:=InStr(workStr, 'LINE', 0))>-1
      WriteF('\s\n', workStr)
      errorLine:=Val(workStr+inStr+5, {numRead})
      IF numRead>0 THEN reportError(errorLine)
    ENDIF
  ENDWHILE
  fh:=closeFile(fh)
  /*-- Clean up files if no errors (else, leave for debugging). --*/
  IF compileError=FALSE
    /*-- Delete temp source file. --*/
    IF argSaveOutput=FALSE THEN DeleteFile(argOutFileName)
    /*-- Delete executable (if exists), then replace with new executable. --*/
    argOutFileName[srcNameLen]:=NIL
    srcNameLen:=StrLen(argMainModuleName)-2
    argMainModuleName[srcNameLen]:=NIL
    DeleteFile(argMainModuleName)
    IF Rename(argOutFileName, argMainModuleName)=0
      IF copyFile(argOutFileName, argMainModuleName)=FALSE
        WriteF('Could not rename executable \s to \s', argOutFileName, argMainModuleName)
      ELSE
        DeleteFile(argOutFileName)
      ENDIF
    ENDIF
    IF argProgressIsVerbose THEN WriteF('\n »»» Compiled with\s.',
                                        IF warningsOccurred THEN ' warnings' ELSE 'out errors')
  ENDIF
EXCEPT
  IF exception="CMD0" THEN WriteF('\n***EC NOT FOUND\n\n')
ENDPROC
  /* compile */

PROC main() HANDLE
  DEF programTitleMessage
  '$VER: EPP 1.4d (3.19.94)'
  programTitleMessage:='\n  EPP V1.4d - E Preprocessor.'+
                       '\n  Copyright ©1993-1994 Barry Wills.'+
                       '  All rights reserved.\n'
  getArgs()
  IF argWBtoFront THEN WbenchToFront()
  IF argProgressIsVerbose THEN WriteF('\s', programTitleMessage)
  /*-- Resolve names for E source files and temp files. --*/
  procsFileName:='T:procsfile.e'
  defsMapFileName:='T:epp.map'          /* defs map file for error reporting */
  procsMapFileName:='T:eppprocs.map'    /* procs map file for error reporting */
  buildEProgramName(argMainModuleName)  /* main input file  */
  IF argOutFileName=NIL                 /* main output file */
    argOutFileName:='temp_main.e'
  ELSE
    buildEProgramName(argOutFileName)
  ENDIF
  /*-- Open output files. --*/
  defsFileHandle:=openFile(argOutFileName, NEWFILE)
  procsFileHandle:=openFile(procsFileName, NEWFILE)
  defsMapFileHandle:=openFile(defsMapFileName, NEWFILE)
  procsMapFileHandle:=openFile(procsMapFileName, NEWFILE)
  workStr:=String(LARGEST_TOKEN_SUPPORTED)
  /*-- Recursively get modules. --*/
  getModule(argMainModuleName)
  /*-- Append temp files containing procs info to the end of defs files. --*/
  IF userBreak=FALSE
    appendProcsToDefs()                   /* source file */
    writeMapIndex(procsFileHandle, 0, 0)  /* map file    */
    writeMapBody()
    joinMapFileHalves()
  ENDIF
  defsFileHandle:=closeFile(defsFileHandle)
  procsFileHandle:=closeFile(procsFileHandle)
  defsMapFileHandle:=closeFile(defsMapFileHandle)
  procsMapFileHandle:=closeFile(procsMapFileHandle)
  DeleteFile(procsFileName)
  DeleteFile(procsMapFileName)
  /*-- Execute command and compile? --*/
  IF userBreak
    WriteF('\n\n *** User break.\n\n')
  ELSE
    IF argExecute THEN Execute(argExecute, NIL, stdout)
    IF argCompile THEN compile()
    IF argProgressIsVerbose THEN WriteF('\s', '\n »»» Done.\n\n')
  ENDIF
  IF argKeepMapFile=FALSE THEN DeleteFile(defsMapFileName)
  CleanUp(0)
EXCEPT
  SELECT exception
    CASE ER_MEM;   WriteF('\nINSUFFICIENT MEMORY\n\n')
    CASE ER_USAGE;
      WriteF('\s', programTitleMessage)
      WriteF('\n  Usage:  EPP [switches] infile[.e] [outfile[.e]] [-xCOMMAND]' +
             '\n\tswitches:' +
             '\n\t-v\t\tverbose' +
             '\n\t-c\t\tinsert EPP comments in final output source' +
             '\n\t-t\t\tTurbo mode' +
             '\n\t-w\t\tWorkbench to front' +
             '\n\t-s\t\tsave final output source' +
             '\n\t-m\t\tsave map file' +
             '\n\t-n\t\tno compilation' +
             '\n\t-e[lanrwsbmX]\tEC options (see E Compiler.doc)' +
             '\n\t-xCOMMAND\tintermediate command (must be last)\n\n')
  ENDSELECT
  closeFile(defsFileHandle)
  closeFile(procsFileHandle)
  closeFile(defsMapFileHandle)
  closeFile(procsMapFileHandle)
  CleanUp(20)
ENDPROC
  /* main */
