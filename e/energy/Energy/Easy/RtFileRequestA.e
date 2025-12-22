
MODULE 	'reqtools','libraries/reqtools'

PROC main()

DEF 	filereq:PTR TO rtfilerequester,	-> punta all'OBJECT contenuto in 'libraries/reqtools'
	filename[34]:STRING		-> EString che conterra` il nome del file scelto

  IF reqtoolsbase:=OpenLibrary('reqtools.library',37)	-> apertura della libreria...

/* 	allocazione del requester specificando il tipo con RT_FILEREQ	*/

	IF (filereq := RtAllocRequestA(RT_FILEREQ, NIL))

		IF RtFileRequestA(filereq, filename, 'Scegli un file...',0)
/* filereq verra` riempito di dati, filename conterra` il nome del file	*/

			RtEZRequestA('Tu hai preso il file:\n\s\nin directory:\n\a\s\a',
					'Giusto', NIL, [filename, filereq.dir], NIL)
			StringF(filename,'\s/\s',filereq.dir,filename)
			WriteF('percorso \s\n',filename)
		ELSE
			RtEZRequestA('nessun file scelto', 'No', NIL, NIL,NIL)

		ENDIF
		RtFreeRequest(filereq)	-> libera la memoria allocata per il req
	ELSE
		RtEZRequestA('Senza memoria!', 'Peccato!', NIL, NIL, NIL)

	ENDIF

    CloseLibrary(reqtoolsbase)	-> chiusura della libreria
  ELSE
    WriteF('Non ho potuto aprire la reqtools.library!\n')
  ENDIF
ENDPROC