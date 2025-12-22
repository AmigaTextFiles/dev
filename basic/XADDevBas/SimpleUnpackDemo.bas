' *********************************************************************
'                 SimpleUnpackDemo.bas v1.0a (25.09.04)
'      © 2004 Dámaso D. Estévez {correoamidde-hbcoding,yahoo,es}
'                           All rights reserved
'
'             AmiSpaTra - http://www.arrakis.es/~amidde/
'
'           How to unpack an archive - Very simple example:
'          the program requires SimpleUnpackPack.lha included
'            (the example will extract all files archived).
'
'         Cómo desempaquetar un archivo - Ejemplo muy simple:
'     el programa requiere el fichero SimpleUnpackPack.lha incluido
'         (este ejemplo extraerá todos los ficheros archivados).
'
' *********************************************************************

REM $NOWINDOW
REM $NOLIBRARY

REM $include xadmaster.bh
REM $include exec.bc
REM $include utility.bc

'  Version string
' Cadena de versión
' -----------------
ver$ = "$VER: SimpleUnpackDemo 1.0a (25.09.04) by Dámaso D. Estévez {correoamidde-hbcoding,yahoo,es} "+CHR$(0)

'   3*2 tags (0-5)
' 3*2 etiquetas (0-5)
' -------------------
DIM tags&(5)

LIBRARY OPEN "xadmaster.library",1&

IF PEEKL(SYSTAB+8) <> 0 THEN
	wb& = TRUE&
	WINDOW 1,"XADmaster's example",(40,40)-(600,200),1+2+4+16
END IF

IF wb& = TRUE& THEN
	LOCATE 2,1,0
END IF

PRINT MID$(ver$,7,LEN(ver$)-7)
PRINT

f$ = "SimpleUnpackPack.lha"

BREAK OFF
ON BREAK GOTO Exiting

IF FEXISTS(f$) THEN

	OPEN f$ FOR INPUT AS #1
		sz& = LOF(1)
	CLOSE #1
	
	'   Allocating space for the archive (using an array)
	' Reservando memoria para el archivo (usando una matriz)
	' ------------------------------------------------------
	DIM fi&((sz&/4)-1)

	BLOAD f$,VARPTR(fi&(0))

	'     Creating the xadInfoFile struct: this is the only method valid !!!
	' Creando la estructura xadInfoFile: ¡¡¡ éste es el único método válido !!!
	' -------------------------------------------------------------------------
	masterstr& = xadAllocObjectA&(XADOBJ_ARCHIVEINFO&,NULL&)

	IF masterstr& THEN

		'      The library would read the file directly 
		' La biblioteca podría leer el fichero directamente
		' -------------------------------------------------
		'TAGLIST VARPTR(tags&(0)), _
		'	XAD_INFILENAME&, SADD("SimpleUnpackGfx.lha"+CHR$(0)), _
		'	TAG_DONE&

		' However, I've loaded it with HBasic and I will access to him from the memory
		'   Sin embargo, lo he cargado con HBasic y accederé a él desde la memoria
		' ----------------------------------------------------------------------------
		TAGLIST VARPTR(tags&(0)), _
			XAD_INMEMORY&, VARPTR(fi&(0)), _
			XAD_INSIZE&,   sz&, _
			TAG_DONE&

		r1& = xadGetInfoA&(masterstr&,VARPTR(tags&(0)))

		BREAK ON

		IF NOT r1& AND NOT (PEEKL(masterstr&+xai_Client%) AND XADAIF_FILECORRUPT&) THEN

			'    The achive example file must be a Lha file !
			' ¡ El archivo de ejemplo ha de ser un fichero Lha !
			' --------------------------------------------------
			IF PEEKL(PEEKL(masterstr&+xai_Client%)+xc_Identifier%) = 5007 THEN


				'           If you want to obtain the client name used...
				'        Si quiere obtener el nombre del cliente utilizado...
				'
				' temp$ = PEEK$(PEEKL(PEEKL(masterstr&+xai_Client%)+xc_ArchiverName%))
				' --------------------------------------------------------------------

				' If you want to check some attrib's client like i.e. if the packer works over files...
				' Si desea verificar algún atributo del cliente como p. ej. si trabaja sobre ficheros...
				'
				' IF PEEKL(PEEKL(masterstr&+xai_Client%)+xc_Flags%) AND XADCF_FILEARCHIVER& THEN
				'	[... do something / haz algo...]
				' END IF
				' --------------------------------------------------------------------------------------

				nxt& = PEEKL(masterstr&+xai_FileInfo%)

				DO

					filename$ = PEEK$(PEEKL(nxt&+xfi_FileName%)) + CHR$(0)
					fentry&   = PEEKL(nxt&+xfi_EntryNumber%)

					' Crunched size / Tamaño dentro del paquete-archivo
					' -------------------------------------------------
					tam1&     = PEEKL(nxt&+xfi_CrunchSize%)
					' Unpacked size / Tamaño extraído del paquete-archivo
					' ---------------------------------------------------
					tam2&     = PEEKL(nxt&+xfi_Size%)

					'  As you can see, at this case, habitually tam1&=tam2&
					'              because the original files use
					'             formats very compressed (GIF/PNG)
					' --------------------------------------------------------
					'    Como puede ver tam1&=tam2& en casi todos los casos,
					'        puesto que los ficheros originales están
					'        en formatos ya muy comprimidos (PNG/GIF)
					' --------------------------------------------------------
					PRINT USING "Extracting to 'RAM:'/Extrayendo a 'RAM:' (####";tam1&;
					PRINT " bytes/octetos):"
					PRINT USING" ##";fentry&;
					PRINT " - ";LEFT$(filename$,LEN(filename$)-1);
					PRINT " (";LTRIM$(STR$(tam2&));" bytes/octetos)"

					TAGLIST VARPTR(tags&(0)), _
						XAD_ENTRYNUMBER&, fentry&, _
						XAD_OUTFILENAME&, SADD("RAM:"+filename$+CHR$(0)), _
						TAG_DONE&

					' I unpack the entry # and the output file have
					'   the same filename what the file archived
					'
					'  Desempaqueto el nº de entrada especificada
					' dándole al fichero de salida el mismo nombre
					'        que tiene dentro del archivo :)
					' ---------------------------------------------
					r2& = xadFileUnArcA&(masterstr&,VARPTR(tags&(0)))

					IF r2& THEN

						PRINT "Error (xadFileUnArcA&: ";PEEK$(xadGetErrorText&(r2&));")"

					END IF

					'         I obtain the xadFileInfo struct pointer for the next file archived
					' Obtengo el puntero de la estructura xadFileInfo para el siguiente fichero archivado
					' -----------------------------------------------------------------------------------
					nxt& =  PEEKL(nxt&+xfi_Next%)

					'   If no more files in the archive...
					' Si no hay más ficheros en el archivo...
					' ---------------------------------------
					IF nxt& = NULL& THEN
						EXIT DO
					END IF

				WEND

			ELSE

				PRINT "Example modified! This should be a Lha file!!"
				PRINT "¡Ejemplo modificado! ¡¡Debería ser un fichero Lha!!"

			END IF

		ELSE

			PRINT "Error: archive corrupt or xadGetInfoA& failed: (";PEEK$(xadGetErrorText&(r1&));")"
			PRINT "Error: archivo corrupto o xadGetInfoA& ha fallado"

		END IF

	ELSE

		BEEP

	END IF

ELSE

	PRINT "Error: The ";f$;" file not exists in the current directory"
	PRINT "Error: El fichero ";f$;" no existe en el directorio actual"

END IF

Exiting:

	' BEWARE: If the file don't exist, the program won't execute the xadGetInfoA& function,
	'     but r1& will be NULL also (as when the function works ok)  and I would free
	'      incorrectly the resources !!  This the reason the double condition check.
	'
	' CUIDADO: Si el fichero no existe, el programa no ejecutará la función xadGetInfoA&,
	'    pero ¡¡ r1& también será nulo (como cuando se ejecuta con éxito) y liberaría
	'     incorrectamente los recursos !!  Por eso añado la condición FEXISTS(f$) ;)
	' ------------------------------------------------------------------------------------
	IF NOT r1& AND FEXISTS(f$) THEN
		xadFreeInfo masterstr&
	END IF

	IF masterstr& THEN
		'   Freeing the xadInfoFile struct
		' Liberando la estructura xadInfoFile
		' -----------------------------------
		xadFreeObjectA masterstr&,NULL&
	END IF

	IF wb& THEN

		LOCATE 18,1,0
		PRINT "Press any space bar for to end / Pulse la barra espaciadora para salir"

		DO
			IF INKEY$=" " THEN EXIT DO
			SLEEP
		WEND
		WINDOW CLOSE 1

	END IF

	LIBRARY CLOSE "xadmaster.library"

END
