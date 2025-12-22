-> Cbio.e
->
-> Provide standard clipboard device interface routines
->            such as Open, Close, Post, Read, Write, etc.
->
-> NOTES: These functions are useful for writing and reading simple FTXT. 
-> Writing and reading complex FTXT, ILBM, etc., requires more work.  You
-> should use the iffparse.library to write and read FTXT, ILBM and other IFF
-> file types.  When this code is used with older versions of the Amiga OS
-> (i.e., before V36) a memory loss of 536 bytes will occur due to bugs in the
-> clipboard device.

->>> Header (globals)
OPT MODULE

MODULE 'devices/clipboard',
       'exec/io',
       'exec/memory',
       'exec/ports',
       'amigalib/ports',
       'amigalib/io'

ENUM ERR_NONE, ERR_DERR, ERR_DEV, ERR_DLEN, ERR_DOIO, ERR_IO, ERR_PORT

RAISE ERR_DEV  IF OpenDevice()<>0,
      ERR_DOIO IF DoIO()<>0

-> E-Note: don't need size field since using NewM()/Dispose()
EXPORT OBJECT cbbuf
  count  -> Number of characters after stripping
  mem
ENDOBJECT

EXPORT CONST ID_FORM="FORM", ID_FTXT="FTXT", ID_CHRS="CHRS"
->>>

->>> EXPORT PROC cbOpen(unit)
->
->  FUNCTION
->      Opens the clipboard.device.  A clipboard unit number must be passed in
->      as an argument.  By default, the unit number should be 0 (currently
->      valid unit numbers are 0-255).
->
->  RESULTS
->      A pointer to an initialised IOClipReq structure.  An exception is
->      raised if the function fails ("CBOP")
EXPORT PROC cbOpen(unit) HANDLE
  DEF mp=NIL, ior=NIL
  IF NIL=(mp:=createPort(0,0)) THEN Raise(ERR_PORT)
  IF NIL=(ior:=createExtIO(mp, SIZEOF ioclipreq)) THEN Raise(ERR_IO)
  OpenDevice('clipboard.device', unit, ior, 0)
EXCEPT
  IF ior THEN deleteExtIO(ior)
  IF mp THEN deletePort(mp)
  Raise("CBOP")
ENDPROC ior
->>>

->>> EXPORT PROC cbClose(ior:PTR TO ioclipreq)
->
->  FUNCTION
->      Close the clipboard.device unit which was opened via cbOpen().
->
EXPORT PROC cbClose(ior:PTR TO ioclipreq)
  DEF mp
  mp:=ior.message.replyport
  CloseDevice(ior)
  deleteExtIO(ior)
  deletePort(mp)
ENDPROC
->>>

->>> EXPORT PROC cbWriteFTXT(ior:PTR TO ioclipreq, string)
->
->  FUNCTION
->      Write a NIL terminated string of text to the clipboard.  The string
->      will be written in simple FTXT format.
->
->      Note that this function pads odd length strings automatically to
->      conform to the IFF standard.
->
->  RESULTS
->      If the write did not succeed an exception is raised ("CBWR")
->
EXPORT PROC cbWriteFTXT(ior:PTR TO ioclipreq, string) HANDLE
  DEF length, slen, odd
  slen:=StrLen(string)
  odd:=Odd(slen)  -> Pad byte flag
  length:=IF odd THEN slen+1 ELSE slen

  -> Initial set-up for offset, error, and clipid
  ior.offset:=0
  ior.error:=0
  ior.clipid:=0

  -> Create the IFF header information
  writeLong(ior, 'FORM')    -> 'FORM'
  length:=length+12         -> + length '[size]FTXTCHRS'
  writeLong(ior, {length})  -> Total length
  writeLong(ior, 'FTXT')    -> 'FTXT'
  writeLong(ior, 'CHRS')    -> 'CHRS'
  writeLong(ior, {slen})    -> String length

  -> Write string
  ior.data:=string
  ior.length:=slen
  ior.command:=CMD_WRITE
  DoIO(ior)

  -> Pad if needed
  IF odd
    ior.data:=''
    ior.length:=1
    DoIO(ior)
  ENDIF

  -> Tell the clipboard we are done writing
  ior.command:=CMD_UPDATE
  DoIO(ior)
  -> Check if error was set by any of the preceding IO requests
  IF ior.error THEN Raise(ERR_DERR)
EXCEPT
  Raise("CBWR")
ENDPROC
->>>

->>> PROC writeLong(ior:PTR TO ioclipreq, ldata)
PROC writeLong(ior:PTR TO ioclipreq, ldata)
  ior.data:=ldata
  ior.length:=4
  ior.command:=CMD_WRITE
  DoIO(ior)
  IF ior.actual<>4 THEN Raise(ERR_DLEN)
ENDPROC
->>>

->>> EXPORT PROC cbQueryFTXT(ior:PTR TO ioclipreq)
->
->  FUNCTION
->      Check to see if the clipboard contains FTXT.  If so, call cbReadCHRS()
->      one or more times until all CHRS chunks have been read.
->
->  RESULTS
->      TRUE if the clipboard contains an FTXT chunk, else FALSE.
->
->  NOTES
->      If this function returns TRUE, you must either call cbReadCHRS() until
->      cbReadCHRS() returns FALSE, or call cbReadDone() to tell the
->      clipboard.device that you are done reading.
->
EXPORT PROC cbQueryFTXT(ior:PTR TO ioclipreq) HANDLE
  DEF cbuff[4]:ARRAY OF LONG

  -> Initial set-up for offset, error, and clipid
  ior.offset:=0
  ior.error:=0
  ior.clipid:=0

  -> Look for 'FORM[size]FTXT'
  ior.command:=CMD_READ
  ior.data:=cbuff
  ior.length:=12

  DoIO(ior)

  -> Check to see if we have at least 12 bytes
  IF ior.actual<>12 THEN Raise(ERR_DERR)
  -> Check to see if it starts with 'FORM'
  IF cbuff[]<>ID_FORM THEN Raise(ERR_DERR)
  -> Check to see if it is 'FTXT'
  IF cbuff[2]<>ID_FTXT THEN Raise(ERR_DERR)
  -> E-Note: all checks passed...
  RETURN TRUE
EXCEPT
  -> It's not 'FORM[size]FTXT', so tell clipboard we are done
  cbReadDone(ior)
ENDPROC FALSE
->>>

->>> EXPORT PROC cbReadCHRS(ior:PTR TO ioclipreq)
->
->  FUNCTION
->      Reads and returns the text in the next CHRS chunk (if any) from the
->      clipboard.
->
->      Allocates memory to hold data in next CHRS chunk.
->
->  RESULTS
->      Pointer to a cbbuf object, or NIL if no more CHRS chunks.  An
->      exception ("CBRD") is raised if failure (e.g., not enough memory).
->
->      ***Important***
->
->      The caller must free the returned buffer when done with the
->      data by calling cbFreeBuf().
->
->  NOTES
->      This function strips NIL bytes, however, a full reader may wish to
->      perform more complete checking to verify that the text conforms to the
->      IFF standard (stripping data as required).
->
EXPORT PROC cbReadCHRS(ior:PTR TO ioclipreq) HANDLE
  DEF chunk, size, gotchunk
  -> Find next CHRS chunk
  -> E-Note: loop until exception from reading or found non-empty CHRS chunk
  LOOP
    gotchunk:=FALSE
    readLong(ior, {chunk})
    gotchunk:=TRUE
    -> Is CHRS chunk?
    IF chunk=ID_CHRS
      -> Get size of chunk, and copy data
      readLong(ior, {size})
      -> E-Note: C version is wrong, should keep looping if empty CHRS chunk
      IF size THEN RETURN fillCBData(ior, size)
    ELSE
    -> If not, skip to next chunk
      readLong(ior, {size})
      IF Odd(size) THEN INC size  -> If odd size, add pad byte
      ior.offset:=ior.offset+size
    ENDIF
  ENDLOOP
EXCEPT
  cbReadDone(ior)  -> Tell clipboard we are done
  -> E-Note: pass on exception if there are chunks left
  IF gotchunk THEN Raise("CBRD")
ENDPROC NIL
->>>

->>> PROC readLong(ior:PTR TO ioclipreq, ldata)
PROC readLong(ior:PTR TO ioclipreq, ldata)
  ior.command:=CMD_READ
  ior.data:=ldata
  ior.length:=4
  DoIO(ior)
  IF ior.actual<>4 THEN Raise(ERR_DLEN)
  IF ior.error THEN Raise(ERR_DERR)
ENDPROC
->>>

->>> PROC fillCBData(ior:PTR TO ioclipreq, size)
PROC fillCBData(ior:PTR TO ioclipreq, size) HANDLE
  DEF to, from, x, count, length, buf=NIL:PTR TO cbbuf
  -> E-Note: clear mem to make sure buf.mem is NIL if NewM() succeeds
  buf:=NewM(SIZEOF cbbuf, MEMF_PUBLIC OR MEMF_CLEAR)
  length:=size
  IF Odd(size) THEN INC length  -> If odd size, read 1 more
  buf.mem:=NewM(length+1, MEMF_PUBLIC)

  ior.command:=CMD_READ
  ior.data:=buf.mem
  ior.length:=length

  to:=buf.mem
  count:=0

  DoIO(ior)
  IF ior.actual<>length THEN Raise(ERR_DLEN)

  -> Strip NIL bytes
  from:=buf.mem
  FOR x:=0 TO size-1
    IF from[]
      to[]:=from[]
      to++
      INC count
    ENDIF
    from++
  ENDFOR
  to[]:=NIL  -> NIL terminate buffer
  buf.count:=count  -> Cache count of chars in buf
EXCEPT
  IF buf
    IF buf.mem THEN Dispose(buf.mem)
    Dispose(buf)
  ENDIF
  ReThrow()
ENDPROC buf
->>>

->>> EXPORT PROC cbReadDone(ior:PTR TO ioclipreq)
->
->  FUNCTION
->      Reads past end of clipboard file until actual is equal to 0.
->      This is tells the clipboard that we are done reading.
->
EXPORT PROC cbReadDone(ior:PTR TO ioclipreq) HANDLE
  DEF buffer[256]:ARRAY
  ior.command:=CMD_READ
  ior.data:=buffer
  ior.length:=254
  -> Falls through immediately if actual=0
  WHILE ior.actual DO DoIO(ior)
EXCEPT
  -> E-Note: ignore exceptions from DoIO()
ENDPROC
->>>

->>> EXPORT PROC cbFreeBuf(buf:PTR TO cbbuf)
->
->  FUNCTION
->      Frees a buffer allocated by cbReadCHRS().
->
EXPORT PROC cbFreeBuf(buf:PTR TO cbbuf)
  Dispose(buf.mem)
  Dispose(buf)
ENDPROC
->>>

