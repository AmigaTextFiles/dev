' *********************************************************************
'                      SimpleDecrunchDemo.bas
'        © Dámaso D. Estévez {correoamidde-hbcoding,yahoo,es}
'                       All rights reserved
'
'             AmiSpaTra - http://www.arrakis.es/~amidde/
'
'         How to decrunch a DATA file - Very simple example:
'          the program requires CrunchedFile.crm included.
'
'     Cómo descomprimir un fichero de DATOS - Ejemplo muy simple:
'      el programa requiere el fichero CrunchedFile.crm incluido.
' *********************************************************************

REM $NOWINDOW
REM $NOLIBRARY

REM $include xfdmaster.bh
REM $include exec.bh
REM $include utility.bc

'  Version string
' Cadena de versión
' -----------------
ver$ = "$VER: SimpleDecruchDemo 1.0 (12.02.05) by Dámaso D. Estévez {correoamidde-hbcoding,yahoo,es} "+CHR$(0)

LIBRARY OPEN "exec.library",NULL&
LIBRARY OPEN "xfdmaster.library",36&

IF PEEKL(SYSTAB+8) <> 0 THEN
	wb& = TRUE&
	WINDOW 1,"XFDmaster's example",(40,40)-(600,200),1+2+4+16
END IF

IF wb& = TRUE& THEN
	LOCATE 3,1,0
	COLOR 2
ELSE
	' Salto de línea y activación de negrilla
	'          New line and bold on
	' ---------------------------------------
	PRINT CHR$(10);CHR$(27);"[1m";
END IF

PRINT MID$(ver$,7,LEN(ver$)-7);

IF wb& = TRUE& THEN
	LOCATE 8,1,0
	COLOR 1
ELSE
	' Desactivación de negrilla
	'         Bold off
	' -------------------------
	PRINT CHR$(27);"[22m";CHR$(10)
END IF

f$ = "CrunchedFile.crm"

ON BREAK GOTO Exiting

IF FEXISTS(f$) THEN

	OPEN f$ FOR INPUT AS #1

		'     What is the file size?
		' ¿Cuál es el tamaño del fichero?
		' -------------------------------
		sz& = LOF(1)

		'   Allocating space for the file (using an array)
		' Reservando memoria para el fichero (usando una matriz)
		' ------------------------------------------------------
		DIM fi&((sz&/4)-1)

		'     Loading the file in the array
		' Cargando el fichero dentro de la matriz
		' ---------------------------------------
		BLOAD f$,VARPTR(fi&(0))

	CLOSE #1

	xfdbi& = xfdAllocObject&(XFDOBJ_BUFFERINFO&)

	IF xfdbi& THEN

		'   Initializing some fields
		' Inicializando algunos campos
		' ----------------------------
		POKEL (xfdbi&+xfdbi_SourceBuffer%), VARPTR(fi&(0))
		POKEL (xfdbi&+xfdbi_SourceBufLen%), sz&
		POKEL (xfdbi&+xfdbi_Flags%       ), NULL&

		r1& = xfdRecogBuffer&(xfdbi&)

		' Si r1& = TRUE& el fichero tiene un formato de compresión reconocido
		'    If r1& = TRUE& the file is compressed with a format recognized
		' ---------------------------------------------------------------------------
		IF r1& THEN

			'       The example file must be compressed with CrunchMania
			' ¡ El fichero de ejemplo ha de estar comprimido con CrunchMania !
			' ----------------------------------------------------------------
			IF PEEKW(PEEKL(xfdbi&+xfdbi_Slave%)+xfds_SlaveID%) = &H08023 THEN


				'    If you want to obtain the client name used...
				' Si quiere obtener el nombre del cliente utilizado...
				'
				'   temp$ = PEEK$(PEEKL(xfdbi&+xfdbi_PackerName%))
				' ----------------------------------------------------

				' ¿Es necesaria clave de 16/32 bits o contraseña?
				'     No con este ejemplo... de manera que
				'   esta sección de código no está comprobada.
				
				'     A 16/32 bits or password is required?
				'   No with this example... this implies what
				'        this code section wasn't checked.
				' -----------------------------------------------
				IF (PEEKW(xfdbi&+xfdbi_PackerFlags%) AND XFDPFF_KEY16&) THEN

					INPUT "Clave de 16 bits / 16 bits key:",key16%
					POKEL (xfdbi&+xfdbi_Special%), VARPTR(key16%)
				
				END IF

				IF (PEEKW(xfdbi&+xfdbi_PackerFlags%) AND XFDPFF_KEY32&) THEN
					INPUT "Clave de 32 bits / 32 bits key:",key32&
					POKEL (xfdbi&+xfdbi_Special%), VARPTR(key32&)		
				END IF
				
				IF (PEEKW(xfdbi&+xfdbi_PackerFlags%) AND XFDPFF_PASSWORD&) THEN

					'  Si quiere conocer la long. máxima de la contraseña...
					'     If you want to know the password max. size....
					'   passwordsize& = PEEKW(xfbi&+xfdbi_MaxSpecialLen%))
					' -------------------------------------------------------			
					PRINT "Password / Contraseña:";
					INPUT " ",psw$
					psw$ = psw$ + CHR$(0)
					POKEL (xfdbi&+xfdbi_Special%), SADD(psw$)
				
				END IF

				' Define el tipo de memoria que necesito r8-?... 
				' la alternativa 5b especificada en el documento
				'   "Autodocs/xfdApplications.txt" del paquete
				'     para desarrolladores de XFD, requiere 
				'  la versión 38+ de la biblioteca y comprobar
				'   previamente el atributo XFDOFB_USERTARGET
				'  está activado en el campo xfdbi_PackerFlags.
				'
				'    I define what memory type I need r8-?...
				'  the other alternative 5b offered in the doc
				'   "Autodocs/xfdApplications.txt" included 
				'    in the XFD developper package, requires
				'       the v38 library and checking if
				'          the xfdbi_PackerFlags has
				'     the XFDOFB_USERTARGET attrib activated.
				' ----------------------------------------------
				POKEL(xfdbi&+xfdbi_TargetBufMemType%),MEMF_CLEAR& OR MEMF_ANY&

				r2& = xfdDecrunchBuffer&(xfdbi&)

					IF r2& THEN
						
						PRINT "Guardando (fichero ";f$;".orig) / Saving (";f$;".orig file)..."
						PRINT "   Original:";sz&;"octetos/bytes --> Descomprimido/Decompressed:";PEEKL(xfdbi&+xfdbi_TargetBufSaveLen%);"octetos/bytes."

						' Guardando el fichero descomprimido
						'    Saving the decompressed file
						' ----------------------------------
						BSAVE f$+".orig",PEEKL(xfdbi&+xfdbi_TargetBuffer%),PEEKL(xfdbi&+xfdbi_TargetBufSaveLen%)
					
					ELSE

						BEEP
						PRINT "Error: descompress process failed!"
						PRINT "Error: ¡proceso de descompresión fallido!"
					
					END IF

			ELSE

				BEEP
				PRINT "Example modified! This should be a CrM file!!"
				PRINT "¡Ejemplo modificado! ¡¡Debería ser un fichero con compresión CrM!!"

			END IF

		ELSE

			BEEP
			PRINT "Error: file not compressed or format unknow... xfdRecogBuffer& failed!"
			PRINT "Error: fichero no comprimido o formato desconocido... ¡xfdRecogBuffer& ha fallado!"

		END IF

	ELSE

		BEEP
		PRINT "Error: no memory for the object!"
		PRINT "Error: ¡memoria libre insuficiente para el objeto!"

	END IF

ELSE

	BEEP
	PRINT "Error: The ";f$;" file not exists in the current directory"
	PRINT "Error: El fichero ";f$;" no existe en el directorio actual"

END IF

Exiting:

	IF r2& THEN
		' Liberando la memoria reservada con xfdDecrunchBuffers&
		' Freeing the memory allocated with xfdDecrunchBuffers&
		' ------------------------------------------------------
		FreeMem PEEKL(xfdbi&+xfdbi_TargetBuffer%),PEEKL(xfdbi&+xfdbi_TargetBufLen%)
	END IF

	IF xfdbi& THEN
		'   Freeing the xfdAllocObject struct
		' Liberando la estructura xfdAllocObject
		' --------------------------------------
		xfdFreeObject xfdbi&
	END IF

	IF wb& THEN

		LOCATE 18,1,0
		PRINT "Press any space bar for to end / Pulse la barra espaciadora para salir"

		DO
			IF INKEY$=" " THEN EXIT DO
			SLEEP
		WEND
		WINDOW CLOSE 1

	ELSE

		PRINT

	END IF

	LIBRARY CLOSE "exec.library"
	LIBRARY CLOSE "xfdmaster.library"

END
