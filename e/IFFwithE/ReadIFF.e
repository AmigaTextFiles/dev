
/****

	ReadIFF.e
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

	Written as an exersize in using iffparse.library. It reads an
	IFF file, and writes it's structure to stdout in a simple
	format.

***/


OPT OSVERSION=37

MODULE 'iffparse','libraries/iffparse'

RAISE "^C" IF CtrlC() = TRUE

PROC readiff (name) HANDLE

	DEF iff:PTR TO iffhandle,		-> Utility struct. for iffparse
		node:PTR TO contextnode,	-> additional info about chunk
		fh,							-> File handle of an IFF file
		nest,						-> How many levels deep in the
									-> file are we?
		ret,count

-> --- INIT

	IF (iffparsebase:= OpenLibrary('iffparse.library',0))=NIL
		Raise ("iffp")
	ENDIF

	-> You *MUST* use AllocIFF() to allocate an iffhandle structure
	IF (iff:=AllocIFF())=NIL THEN Raise ("iffh")

	-> Prepare the iffhandle to use a dos filehandle
	InitIFFasDOS(iff)

	-> Open a file and fill inn the iffhandle
	IF (fh:=Open (name,OLDFILE) )=0 THEN Raise ("open")
	iff.stream:=fh

	-> Start a new IO session
	IF OpenIFF (iff,IFFF_READ) THEN Raise ("oiff")


-> --- MAIN LOOP

	nest:=0;count:=0

	WHILE (ret:=ParseIFF(iff,IFFPARSE_STEP))<>IFFERR_EOF
		CtrlC()

		INC count
		IF ret=IFFERR_EOC
			DEC nest
			Write (stdout,{spaces},nest*2)
			Flush(stdout)
			IF count>1 THEN PutStr ('\n')
			PutStr ('}')
		ELSE
			count:=0
			PutStr ('\n')
			node:= CurrentChunk(iff)
			Write (stdout,{spaces},nest*2)
			Flush(stdout)
			Vprintf ('"%s" / "%s", size = %ld {',
				[[node.id,0],[node.type,0],node.size])
			INC nest
		ENDIF
	ENDWHILE

	PutStr ('\n\n')
EXCEPT DO

->--- CLEANUP:

	-> Was iffparse.library opened?
	IF iffparsebase

		-> Was the iffhandle structure allocated?
		IF iff

			-> Did OpenIFF() fail?
			IF exception<>"oiff" THEN CloseIFF(iff)

			-> Was the file opened?
			IF fh THEN Close(fh)

			-> Free the iffhandle. *MUST* be done with FreeIFF()
			FreeIFF(iff)
		ENDIF
		CloseLibrary (iffparsebase)
	ENDIF

	-> IF an exception occured, let the next exception handler deal
	-> with it too...

	ReThrow()
ENDPROC


PROC main() HANDLE
	DEF rdargs,args

	args:=[0]
	IF rdargs:=ReadArgs ('FILENAME/A',args,NIL)
		readiff (args[0])
	ENDIF
EXCEPT
	IF exception = "^C"
		PutStr ('***BREAK\n')
	ELSE
		Vprintf ('exception = %ld ("%s")\n',[exception,[exception,0]])
	ENDIF
ENDPROC

spaces: CHAR '                                                  '
