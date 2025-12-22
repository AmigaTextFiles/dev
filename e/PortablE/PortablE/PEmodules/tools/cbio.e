/* Cbio.e

Provide standard clipboard device interface routines,
such as Open, Close, Post, Read, Write, etc.

NOTES: These functions are useful for writing and reading simple FTXT. 
Writing and reading complex FTXT, ILBM, etc., requires more work.  You
should use the iffparse.library to write and read FTXT, ILBM and other IFF
file types.
*/

OPT POINTER
MODULE 'exec'
MODULE 'devices/clipboard', 'exec/io', 'exec/memory', 'exec/ports', 'amigalib/ports', 'amigalib/io'

OBJECT cbbuf
	size
	count	->Number of characters after stripping
	mem:ARRAY
ENDOBJECT

CONST ID_FORM="FORM", ID_FTXT="FTXT", ID_CHRS="CHRS"
PRIVATE
ENUM ERR_NONE=0, ERR_DERR, ERR_DEV, ERR_DLEN, ERR_DOIO, ERR_IO, ERR_PORT

RAISE ERR_DEV  IF OpenDevice() <> 0,
      ERR_DOIO IF DoIO() <> 0,
      "MEM"    IF AllocMem() = NIL

PROC ior2io(ior:PTR TO ioclipreq) IS ior !!PTR!!PTR TO io
PROC io2ior(io:PTR TO io) IS io !!PTR!!PTR TO ioclipreq
PUBLIC


/*	FUNCTION
	    Opens the clipboard.device.  A clipboard unit number must be passed in
	    as an argument.  By default, the unit number should be 0 (currently
	    valid unit numbers are 0-255).
		
	RESULTS
	    A pointer to an initialised IOClipReq structure.  A "CBOP" exception is
	    raised if the function fails
*/
PROC cbOpen(unit) RETURNS ior:PTR TO ioclipreq
	DEF mp:PTR TO mp
	
	IF (mp := createPort(NILA,0))=NIL THEN Raise(ERR_PORT)
	IF (ior := io2ior(createExtIO(mp, SIZEOF ioclipreq)))=NIL THEN Raise(ERR_IO)
	OpenDevice('clipboard.device', unit, ior2io(ior), 0)
FINALLY
	IF exception
		IF ior THEN deleteExtIO(ior2io(ior))
		IF mp  THEN deletePort(mp)
		Raise("CBOP")
	ENDIF
ENDPROC


/*	FUNCTION
	    Close the clipboard.device unit which was opened via cbOpen().
*/
PROC cbClose(ior:PTR TO ioclipreq)
	DEF mp:PTR TO mp
	
	mp := ior.message.replyport
	CloseDevice(ior2io(ior))
	deleteExtIO(ior2io(ior))
	deletePort(mp)
ENDPROC


/*	FUNCTION
	    Write a null terminated string of text to the clipboard.  The string
	    will be written in simple FTXT format.
	
	    Note that this function pads odd length strings automatically to
	    conform to the IFF standard.
	
	RESULTS
	    If the write did not succeed a "CBWR" exception is raised
*/
PROC cbWriteFTXT(ior:PTR TO ioclipreq, string:ARRAY OF CHAR)
	DEF length, slen, odd
	
	slen := StrLen(string)
	odd := Odd(slen)	->Pad byte flag
	length := IF odd THEN slen+1 ELSE slen
	
	->Initial set-up for offset, error, and clipid
	ior.offset := 0
	ior.error  := 0
	ior.clipid := 0
	
	->Create the IFF header information
	writeLong(ior, 'FORM')				->'FORM'
	length := length + 12				->+ length '[size]FTXTCHRS'
	writeLong(ior, ADDRESSOF length)	->Total length
	writeLong(ior, 'FTXT')				->'FTXT'
	writeLong(ior, 'CHRS')				->'CHRS'
	writeLong(ior, ADDRESSOF slen)		->String length
	
	->Write string
	ior.data    := string
	ior.length  := slen
	ior.command := CMD_WRITE
	DoIO(ior2io(ior))
	
	->Pad if needed
	IF odd
		ior.data   := ''
		ior.length := 1
		DoIO(ior2io(ior))
	ENDIF
	
	->Tell the clipboard we are done writing
	ior.command := CMD_UPDATE
	DoIO(ior2io(ior))
	->Check if error was set by any of the preceding IO requests
	IF ior.error THEN Raise(ERR_DERR)
FINALLY
	IF exception THEN Raise("CBWR")
ENDPROC


PRIVATE

PROC writeLong(ior:PTR TO ioclipreq, ldata)
	ior.data    := ldata !!ARRAY OF CHAR
	ior.length  := 4
	ior.command := CMD_WRITE
	DoIO(ior2io(ior))
	IF ior.actual <> 4 THEN Raise(ERR_DLEN)
ENDPROC

PUBLIC


/*	FUNCTION
	    Check to see if the clipboard contains FTXT.  If so, call cbReadCHRS()
	    one or more times until all CHRS chunks have been read.
	
	RESULTS
	    TRUE if the clipboard contains an FTXT chunk, else FALSE.
	
	NOTES
	    If this function returns TRUE, you must either call cbReadCHRS() until
	    cbReadCHRS() returns FALSE, or call cbReadDone() to tell the
	    clipboard.device that you are done reading.
*/
PROC cbQueryFTXT(ior:PTR TO ioclipreq) RETURNS doesContain:BOOL
	DEF cbuff[4]:ARRAY OF LONG
	
	doesContain := FALSE
	
	->Initial set-up for offset, error, and clipid
	ior.offset := 0
	ior.error  := 0
	ior.clipid := 0
	
	->Look for 'FORM[size]FTXT'
	ior.command := CMD_READ
	ior.data    := cbuff !!ARRAY
	ior.length  := 12
	
	DoIO(ior2io(ior))
	
	IF ior.actual <> 12    THEN Raise(ERR_DERR)	->Check to see if we have at least 12 bytes
	IF cbuff[0] <> ID_FORM THEN Raise(ERR_DERR)	->Check to see if it starts with 'FORM'
	IF cbuff[2] <> ID_FTXT THEN Raise(ERR_DERR)	->Check to see if it is 'FTXT'
	->E-Note: all checks passed...
	doesContain := TRUE
FINALLY
	IF exception
		->It's not 'FORM[size]FTXT', so tell clipboard we are done
		cbReadDone(ior)
		exception := 0
	ENDIF
ENDPROC


/*	FUNCTION
	    Reads and returns the text in the next CHRS chunk (if any) from the
	    clipboard.
	
	    Allocates memory to hold data in next CHRS chunk.
	
	RESULTS
	    Pointer to a cbbuf object, or NIL if no more CHRS chunks.  An
	    exception ("CBRD") is raised if failure (e.g., not enough memory).
	
	    ***Important***
	
	    The caller must free the returned buffer when done with the
	    data by calling cbFreeBuf().
	
	NOTES
	    This function strips null bytes, however, a full reader may wish to
	    perform more complete checking to verify that the text conforms to the
	    IFF standard (stripping data as required).
*/
PROC cbReadCHRS(ior:PTR TO ioclipreq) RETURNS buf:PTR TO cbbuf
	DEF chunk, size, gotchunk
	
	->Find next CHRS chunk
	->E-Note: loop until exception from reading or found non-empty CHRS chunk
	LOOP
		gotchunk := FALSE
		readLong(ior, ADDRESSOF chunk)
		gotchunk := TRUE
		IF chunk = ID_CHRS		->Is CHRS chunk?
			->Get size of chunk, and copy data
			readLong(ior, ADDRESSOF size)
			->E-Note: C version is wrong, should keep looping if empty CHRS chunk
			IF size THEN RETURN fillCBData(ior, size)
		ELSE
			->(not CHRS chunk) so skip to next chunk
			readLong(ior, ADDRESSOF size)
			IF Odd(size) THEN size++	->If odd size, add pad byte
			ior.offset := ior.offset + size
		ENDIF
	ENDLOOP
FINALLY
	IF exception
		cbReadDone(ior)	->Tell clipboard we are done
		->E-Note: pass on exception if there are chunks left
		IF gotchunk THEN Raise("CBRD")
		exception := 0
	ENDIF
ENDPROC


PRIVATE

PROC readLong(ior:PTR TO ioclipreq, ldata:ARRAY)
	ior.command := CMD_READ
	ior.data    := ldata
	ior.length  := 4
	DoIO(ior2io(ior))
	IF ior.actual <> 4 THEN Raise(ERR_DLEN)
	IF ior.error THEN Raise(ERR_DERR)
ENDPROC


PROC fillCBData(ior:PTR TO ioclipreq, size) RETURNS buf:PTR TO cbbuf
	DEF to:ARRAY OF BYTE, from:ARRAY OF BYTE, x, y, count, length
	
	->E-Note: clear mem to make sure buf.mem is NIL if allocation succeeds
	buf := AllocMem(SIZEOF cbbuf, MEMF_PUBLIC OR MEMF_CLEAR)
	length := size
	IF Odd(size) THEN length++	->If odd size, read 1 more
	buf.mem  := AllocMem(length+1, MEMF_PUBLIC)
	buf.size := length+1
	
	ior.command := CMD_READ
	ior.data    := buf.mem
	ior.length  := length
	
	to := buf.mem
	count := 0
	
	DoIO(ior2io(ior))
	IF ior.actual <> length THEN Raise(ERR_DLEN)
	
	->Strip null bytes
	from := buf.mem
	y := 0
	FOR x := 0 TO size-1
		IF from[x]
			to[y++] := from[x]
			count++
		ENDIF
	ENDFOR
	to[y] := 0	->terminate buffer
	buf.count := count	->Cache count of chars in buf
FINALLY
	IF exception
		IF buf
			IF buf.mem THEN FreeMem(buf.mem, buf.size)
			FreeMem(buf, SIZEOF cbbuf)
		ENDIF
		ReThrow()
	ENDIF
ENDPROC

PUBLIC


/*	FUNCTION
	    Reads past end of clipboard file until actual is equal to 0.
	    This is tells the clipboard that we are done reading.
*/
PROC cbReadDone(ior:PTR TO ioclipreq)
	DEF buffer[256]:ARRAY OF CHAR
	
	ior.command := CMD_READ
	ior.data    := buffer
	ior.length  := 254
	->Falls through immediately if actual=0
	WHILE ior.actual DO DoIO(ior2io(ior))
FINALLY
	->E-Note: ignore exceptions from DoIO()
	exception := 0
ENDPROC


/*	FUNCTION
	    Frees a buffer allocated by cbReadCHRS().
*/
PROC cbFreeBuf(buf:PTR TO cbbuf)
	FreeMem(buf.mem, buf.size)
	FreeMem(buf, SIZEOF cbbuf)
ENDPROC
