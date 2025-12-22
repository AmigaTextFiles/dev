-> sift.e - Takes any IFF file and tells you what's in it.  Verifies syntax
->          and all that cool stuff.
->
-> Usage: sift -c                ; For clipboard scanning
->    or  sift <file>            ; For DOS file scanning
->
-> Reads the specified stream and prints an IFFCheck-like listing of the
-> contents of the IFF file, if any.  Stream is a DOS file for <file>
-> argument, or is the clipboard's primary clip for -c.  This program must be
-> run from a CLI.

->>> Header (globals)
MODULE 'iffparse',
       'devices/clipboard',
       'libraries/iffparse',
       'other/split'

ENUM ERR_NONE, ERR_ARGS, ERR_CLIP, ERR_IFF, ERR_LIB, ERR_OIFF, ERR_OPEN,
     ERR_USE

RAISE ERR_CLIP IF OpenClipboard()=NIL,
      ERR_IFF  IF AllocIFF()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_OIFF IF OpenIFF()<>0,
      ERR_OPEN IF Open()=NIL

-> E-Note: using argSplit() so one less argument than argv (no command name)
CONST MINARGS=1

DEF usage, errormsgs:PTR TO LONG
->>>

->>> PROC main()
PROC main() HANDLE
  DEF iff=NIL:PTR TO iffhandle, error, cbio, arglist:PTR TO LONG, going=TRUE
  -> E-Note: set-up globals
  usage:='Usage: sift IFFfilename (or -c for clipboard)\n'
  -> Text error messages for possible IFFERR_#? returns from various IFF
  -> routines.  To get the index into this array, take your IFFERR code,
  -> negate it, and subtract one.
  ->  idx = -error - 1;
  errormsgs:=['End of file (not an error).', 'End of context (not an error).',
              'No lexical scope.', 'Insufficient memory.',
              'Stream read error.', 'Stream write error.',
              'Stream seek error.', 'File is corrupt.', 'IFF syntax error.',
              'Not an IFF file.', 'Required call-back hook missing.',
              'Return to client.  You should never see this.']:LONG
  IF NIL=(arglist:=argSplit()) THEN Raise(ERR_ARGS)
  -> If not enough args or "?", print usage
  IF ListLen(arglist)<>MINARGS THEN Raise(ERR_USE)
  IF arglist[][]="?" THEN Raise(ERR_USE)

  -> Check to see if we are doing I/O to the Clipboard.
  cbio:=(arglist[][]="-") AND (arglist[][1]="c")

  iffparsebase:=OpenLibrary('iffparse.library', 0)

  -> Allocate IFF_File OBJECT
  iff:=AllocIFF()

  -> Internal support is provided for both AmigaDOS files, and the
  -> clipboard.device.  This bizarre 'IF' statement performs the appropriate
  -> machinations for each case.
  IF cbio
    -> Set up IFF_File for Clipboard I/O.
    iff.stream:=OpenClipboard(PRIMARY_CLIP)
    InitIFFasClip(iff)
  ELSE
    -> Set up IFF_File for AmigaDOS I/O.
    iff.stream:=Open(arglist[], OLDFILE)
    InitIFFasDOS(iff)
  ENDIF

  -> Start the IFF transaction.
  OpenIFF(iff, IFFF_READ)

  -> E-Note: the going flag makes this easier to understand
  WHILE going
    -> The interesting bit.  IFFPARSE_RAWSTEP permits us to have precision
    -> monitoring of the parsing process, which is necessary if we wish to
    -> print the structure of an IFF file.  ParseIFF() with _RAWSTEP will
    -> return the following things for the following reasons:
    ->
    -> Return code:                 Reason:
    -> 0                            Entered new context.
    -> IFFERR_EOC                   About to leave a context.
    -> IFFERR_EOF                   Encountered end-of-file.
    -> <anything else>              A parsing error.
    error:=ParseIFF(iff, IFFPARSE_RAWSTEP)

    -> Since we're only interested in when we enter a context, we 'discard'
    -> end-of-context (_EOC) events.
    IF error=IFFERR_EOC
    ELSEIF error
      -> Leave the loop if there is any other error.
      going:=FALSE
    ELSE
      -> If we get here, error was zero.  Print out the current state of
      -> affairs.
      printTopChunk(iff)
    ENDIF
  ENDWHILE

  -> If error was IFFERR_EOF, then the parser encountered the end of the file
  -> without problems.  Otherwise, we print a diagnostic.
  IF error=IFFERR_EOF
    WriteF('File scan complete.\n')
  ELSE
    WriteF('File scan aborted, error \d: \s\n', error, errormsgs[-error-1])
  ENDIF
EXCEPT DO
  IF iff
    -> Terminate the IFF transaction with the stream.
    CloseIFF(iff)
    -> Close the stream itself.
    IF iff.stream
      IF cbio THEN CloseClipboard(iff.stream) ELSE Close(iff.stream)
    ENDIF
    -> Free the IFF_File object itself.
    FreeIFF(iff)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
  SELECT exception
  CASE ERR_CLIP;  WriteF('Error: could not open clipboard\n')
  CASE ERR_IFF;   WriteF('Error: could not allocate IFF handle\n')
  CASE ERR_LIB;   WriteF('Error: could not open iffparse.library\n')
  CASE ERR_OIFF;  WriteF('Error: could not open IFF handle\n')
  CASE ERR_OPEN;  WriteF('Error: could not open file\n')
  CASE ERR_USE;   WriteF(usage)
  ENDSELECT
ENDPROC
->>>

->>> PROC printTopChunk(iff:PTR TO iffhandle)
PROC printTopChunk(iff:PTR TO iffhandle)
  DEF top:PTR TO contextnode, i, idbuf[5]:ARRAY
  -> Get a pointer to the context node describing the current context.
  IF NIL=(top:=CurrentChunk(iff)) THEN RETURN

  -> Print a series of dots equivalent to the current nesting depth of chunks
  -> processed so far.  This will cause nested chunks to be printed out
  -> indented.
  FOR i:=iff.depth TO 1 STEP -1 DO WriteF('. ')

  -> Print out the current chunk's ID and size.
  WriteF('\s \d ', IdtoStr(top.id, idbuf), top.size)

  -> Print the current chunk's type, with a newline.
  WriteF('\s\n', IdtoStr(top.type, idbuf))
ENDPROC
->>>

->>> Version string
-> 2.0 Version string for c:Version to find
vers:
  CHAR 0, '$VER: sift 37.1', 0
->>>
