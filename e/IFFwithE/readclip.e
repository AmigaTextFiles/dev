
/****

	ReadClipboard.e
	© 1995 by Vidar Hokstad <vidarh@rforum.no>


	COPYRIGHT NOTICE:

	This code can be distributed freely, and parts of the code,
	or the whole code, can be used as is, or reused in any
	product - free or commercial - provided the following terms
	are met:

	- You accept that I give no guarantee, expressed or implied
		of the usefulness or functionality of this code, and that
		I accept no responsability for damage caused directly or
		indirectly by the use of this program.

	- The product in which the code is used can not be used
		for military applications.


	INFO:

	Written as an exersize in using iffparse.library. Reads the
	PRIMARY_CLIP clipboard unit, and prints it to stdout.

	Notice: Expects a FTXT clipboard, and will only utilize
	FTXT CHRS chunks (which is what a standard clipboard contains).

	The only 2.04+ specific stuff is the use of Vprintf for writing
	debug info. I don't really know if there's a version of
	iffparse.library for older os-versions though. There ought to
	be, but I dont really care :)

***/


OPT OSVERSION=37,PREPROCESS

-> #define DEBUG

MODULE 'iffparse','libraries/iffparse','devices/clipboard'

RAISE "^C" IF CtrlC() = TRUE



PROC readclip (unit) HANDLE

	DEF iff:PTR TO iffhandle,		-> Utility struct. for iffparse
		cliph=NIL,					-> The clipboard handler
		buf[200]:ARRAY OF CHAR,		-> Buffer for ReadChunkBytes()
		size						-> Number of read bytes.

#ifdef DEBUG
	DEF node:PTR TO contextnode	-> additional info about chunk
#endif


-> --- INIT

	IF (iffparsebase:= OpenLibrary('iffparse.library',0))=NIL
		Raise ("iffp")
	ENDIF

	-> You *MUST* use AllocIFF() to allocate an iffhandle structure
	IF (iff:=AllocIFF())=NIL THEN Raise ("iffh")

	-> Prepare the iffhandle to use the clipboard
	InitIFFasClip(iff)

	-> Open a clipboard stream and fill inn the iffhandle
	IF (cliph:=OpenClipboard (unit) )=0 THEN Raise ("open")
	iff.stream:=cliph

	-> Start a new IO session
	IF OpenIFF (iff,IFFF_READ) THEN Raise ("oiff")

	-> Tell iffparse.library you want to examine chunks of type FTXT
	-> and id CHRS which is pure ASCII text.

#ifndef DEBUG
	IF StopChunk (iff,"FTXT","CHRS") THEN Raise ("schn")
#endif


-> --- MAIN LOOP

-> 		While theres something left to read, parse the IFF stream.
-> 		For a clipboard, there's usually only one chunk of interest,
-> 		but this way the code will work if theres more chunks too.

->		IF "DEBUG" is defined, the IFF file is stepped through one
->		context change at a time, and additional info is dumped to
->		Output()


#ifndef DEBUG
	WHILE ParseIFF(iff,IFFPARSE_SCAN)<>IFFERR_EOF
#endif

#ifdef DEBUG
	WHILE ParseIFF(iff,IFFPARSE_RAWSTEP)<>IFFERR_EOF
#endif
		CtrlC()

#ifdef DEBUG
		node:= CurrentChunk(iff)
		Vprintf ('id = "%s", type = "%s", size = %ld\n',
			[[node.id,0],[node.type,0],node.size])
		Flush(stdout)

		-> Ensure that we only dump "CHRS" chunks
		IF node.id="CHRS"
#endif

		-> Copy the chunk to the output file
		WHILE (size:=ReadChunkBytes(iff,buf,200))>0
			Write(stdout,buf,size)
		ENDWHILE

#ifdef DEBUG
		ENDIF
#endif

	ENDWHILE

EXCEPT DO

->--- CLEANUP:

	-> Was iffparse.library opened?
	IF iffparsebase

		-> Was the iffhandle structure allocated?
		IF iff

			-> Did OpenIFF() fail?
			IF exception<>"oiff" THEN CloseIFF(iff)

			-> Was the Clipboard structure allocated?
			IF cliph THEN CloseClipboard(cliph)

			-> Free the iffhandle. *MUST* be done with FreeIFF()
			FreeIFF(iff)
		ENDIF
		CloseLibrary (iffparsebase)
	ENDIF

	-> IF an exception occured, let the next exception handler deal
	-> with it too...

	ReThrow()
ENDPROC


-> Read the PRIMARY_CLIP clipboard, and print it's contents to stdout
-> Display any exception that occurs.

PROC main() HANDLE
	readclip (PRIMARY_CLIP)
EXCEPT
	Vprintf ('exception = %ld ("%s")\n',[exception,[exception,0]])
ENDPROC
