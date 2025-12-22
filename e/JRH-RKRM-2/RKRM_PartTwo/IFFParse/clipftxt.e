-> clipftxt.e - Writes ASCII text to clipboard unit as FTXT
->              (All clipboard data must be IFF)
->
-> Usage: clipftxt unitnumber
->
-> To convert to an example of reading only, comment out #define WRITEREAD

->>> Header (globals)
OPT PREPROCESS

MODULE 'iffparse',
       'libraries/iffparse',
       'other/split'

ENUM ERR_NONE, ERR_ARGS, ERR_CLIP, ERR_IFF, ERR_LIB, ERR_OIFF, ERR_STOP,
     ERR_USE, ERR_WRIT

RAISE ERR_CLIP IF OpenClipboard()=NIL,
      ERR_IFF  IF AllocIFF()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_OIFF IF OpenIFF()<>0,
      ERR_STOP IF StopChunk()<>FALSE

-> Causes example to write FTXT first, then read it back.
-> Comment out to create a reader only
#define WRITEREAD

-> E-Note: using argSplit() so one arg count is one less than C's argv
CONST MINARGS=1, RBUFSZ=512, ID_FTXT="FTXT", ID_CHRS="CHRS"

DEF usage, errormsgs:PTR TO LONG, mytext
->>>

->>> PROC main()
PROC main() HANDLE
  DEF iff=NIL:PTR TO iffhandle, cn:PTR TO contextnode, error=0, unitnumber=0,
      rlen, textlen, readbuf[RBUFSZ]:ARRAY, arglist:PTR TO LONG, going=TRUE
  -> E-Note: set-up globals
  usage:='Usage: clipftxt unitnumber (use zero for primary unit)\n'
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
  mytext:='This FTXT written to clipboard by clipftxt example.\n'
  textlen:=STRLEN
  IF NIL=(arglist:=argSplit()) THEN Raise(ERR_ARGS)
  -> If not enough args or "?", print usage
  IF ListLen(arglist)<>MINARGS THEN Raise(ERR_USE)
  IF arglist[][]="?" THEN Raise(ERR_USE)
  unitnumber:=Val(arglist[])

  iffparsebase:=OpenLibrary('iffparse.library', 0)

  -> Allocate IFF_File OBJECT
  iff:=AllocIFF()

  -> Set up IFF_File for Clipboard I/O.
  iff.stream:=OpenClipboard(unitnumber)
  InitIFFasClip(iff)
  WriteF('Opened clipboard unit \d\n', unitnumber)

  InitIFFasClip(iff)

#ifdef WRITEREAD

  -> Start the IFF transaction.
  OpenIFF(iff, IFFF_WRITE)
                
  -> Write our text to the clipboard as CHRS chunk in FORM FTXT
  ->
  -> First, write the FORM ID (FTXT)
  IF FALSE=(error:=PushChunk(iff, ID_FTXT, ID_FORM, IFFSIZE_UNKNOWN))
    -> Now the CHRS chunk ID followed by the chunk data.  We'll just write one
    -> CHRS chunk.  You could write more chunks.
    IF FALSE=(error:=PushChunk(iff, 0, ID_CHRS, IFFSIZE_UNKNOWN))
      -> Now the actual data (the text)
      IF WriteChunkBytes(iff, mytext, textlen)<>textlen
        WriteF('Error writing CHRS data.\n')
        error:=IFFERR_WRITE
      ENDIF
    ENDIF
    IF FALSE=error THEN error:=PopChunk(iff)
  ENDIF
  IF FALSE=error THEN error:=PopChunk(iff)

  IF error THEN Raise(ERR_WRIT)

  WriteF('Wrote text to clipboard as FTXT\n')
  
  -> Now let's close it, then read it back.  First close the write handle, then
  -> close the clipboard.
  CloseIFF(iff)
  IF iff.stream THEN CloseClipboard(iff.stream)
  iff.stream:=NIL  -> E-Note: reinitialise it to NIL to help error trapping

  iff.stream:=OpenClipboard(unitnumber)
  WriteF('Reopened clipboard unit \d\n', unitnumber)

#endif -> WRITEREAD

  OpenIFF(iff, IFFF_READ)
                
  -> Tell iffparse we want to stop on FTXT CHRS chunks
  StopChunk(iff, ID_FTXT, ID_CHRS)
                
  -> Find all of the FTXT CHRS chunks
  -> E-Note: the going flag makes this easier to understand
  WHILE going
    error:=ParseIFF(iff, IFFPARSE_SCAN)
    IF error=IFFERR_EOC  -> Enter next context
    ELSEIF error
      going:=FALSE
    ELSE
      -> We only asked to stop at FTXT CHRS chunks.  If no error we've hit a
      -> stop chunk.  Read the CHRS chunk data
      cn:=CurrentChunk(iff)

      IF cn
        IF (cn.type=ID_FTXT) AND (cn.id=ID_CHRS)
          WriteF('CHRS chunk contains:\n')
          WHILE (rlen:=ReadChunkBytes(iff, readbuf, RBUFSZ)) > 0
            -> E-Note: stdout is safe since WriteF() has been used above
            Write(stdout, readbuf, rlen)
          ENDWHILE
          IF rlen<0 THEN error:=rlen
        ENDIF
      ENDIF
    ENDIF
  ENDWHILE

  IF error AND (error<>IFFERR_EOF)
    WriteF('IFF read failed, error \d: \s\n', error, errormsgs[-error-1])
  ENDIF
EXCEPT DO
  IF iff
    -> Terminate the IFF transaction with the stream.  Free all associated
    -> structures.
    CloseIFF(iff)
    -> Close the clipboard stream
    IF iff.stream THEN CloseClipboard(iff.stream)
    -> Free the IFF_File structure itself.
    FreeIFF(iff)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
  SELECT exception
  CASE ERR_CLIP;  WriteF('Error: could not open clipboard\n')
  CASE ERR_IFF;   WriteF('Error: could not allocate IFF handle\n')
  CASE ERR_LIB;   WriteF('Error: could not open iffparse.library\n')
  CASE ERR_OIFF;  WriteF('Error: could not open IFF handle\n')
  CASE ERR_USE;   WriteF(usage)
  CASE ERR_WRIT;  WriteF('IFF write failed, error \d: \s\n', error, errormsgs[-error-1])
  ENDSELECT
ENDPROC
->>>

->>> Version string
-> 2.0 Version string for c:Version to find
vers:
  CHAR 0, '$VER: clipftxt 37.2', 0
->>>
