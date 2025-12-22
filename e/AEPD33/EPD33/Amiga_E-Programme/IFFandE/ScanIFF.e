/****

	ScanIFF.e
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
	IFF file, and dumps the contents of any occurences of a given
	type of chunk, given the type and id.

***/


OPT OSVERSION=37

MODULE 'iffparse','libraries/iffparse','dos/dos'

RAISE "^C" IF CtrlC() = TRUE

-> Convert type/id string to a longword

PROC gettype (str)
	DEF ret
	MOVE.L	str,A0
	MOVE.B	(A0)+,D0
	ASL.W	#8,D0
	MOVE.B	(A0)+,D0
	SWAP	D0
	MOVE.B	(A0)+,D0
	ASL.W	#8,D0
	MOVE.B	(A0),D0
	MOVE.L	D0,ret
ENDPROC ret

PROC scaniff (name,type,id) HANDLE

	DEF iff:PTR TO iffhandle,		-> Utility struct. for iffparse
		node:PTR TO contextnode,	-> additional info about chunk
		fh,							-> File handle of an IFF file
		buf[16]:ARRAY OF CHAR,		-> Buffer for ReadChunkBytes()
		len,i

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

	IF StopChunk (iff,gettype(type),gettype(id)) THEN Raise ("schn")


-> --- MAIN LOOP

-> 		While there's something left to read, parse the IFF stream.

	WHILE ParseIFF(iff,IFFPARSE_SCAN)<>IFFERR_EOF
		CtrlC()

		node:= CurrentChunk(iff)
		Vprintf ('"%s" / "%s", size = %ld {\n',
				[[node.id,0],[node.type,0],node.size])

		-> Dump the contents of the requested chunk
		WHILE (len:=ReadChunkBytes(iff,buf,16))>0
			PutStr ('  ')
			FOR i:=0 TO len-1 DO Vprintf (' $%02.lx',[buf[i]])
			PutStr ('\n')
		ENDWHILE

		PutStr ('}\n')
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

	args:=[0,0,0]
	IF rdargs:=ReadArgs ('FILENAME/A,TYPE/A,ID/A',args,NIL)
		scaniff (args[0],args[1],args[2])
	ELSE
		PrintFault (ERROR_BAD_TEMPLATE,'Dos error')
	ENDIF
EXCEPT
	IF exception = "^C"
		PutStr ('***BREAK\n')
	ELSE
		Vprintf ('exception = %ld ("%s")\n',[exception,[exception,0]])
	ENDIF
ENDPROC

