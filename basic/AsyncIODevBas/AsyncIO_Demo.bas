' *********************************************************************
'                   AsyncIOdemo.bas 1.0 (11.06.2011)
'         Dámaso D. Estévez [correoamidde-aminet000,yahoo,es]
'         All Rights Reserved / Todos los derechos reservados
'
'         AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
'
'  Little demo for to see how to use the AsyncIO library: copies the
'  "S:Startup-Sequence" file in "RAM:" with the new name "Output.txt".
'                                  ---
'     Pequeña demostración del uso de la biblioteca AsyncIO: copia
' el fichero "S:Startup-Sequence" en "RAM:" con el nombre "Output.txt"
' *********************************************************************

REM ** AllocMem&, FreeMem
REM $include exec.bh

REM ** IoErr&, DOSTRUE&, DOSFALSE&
REM $include dos.bh

REM ** OpenAsync&, CloseAsync&, ReadAsync&, WriteAsync&
REM $include asyncio.bh

REM $NOWINDOW
REM $NOBREAK
REM $NOEVENT

'             Opening the libraries / Abriendo la bibliotecas
' --------------------------------------------------------------------
LIBRARY OPEN "exec.library"
LIBRARY OPEN "dos.library",36&
LIBRARY OPEN "asyncio.library"

REM ==================================================================
REM Based over my previous routine CopyFile (AST_HBRoutines package)
REM                                ---
REM   Basada en mi rutina previa CopyFile (paquete AST_HBRoutines)
REM ==================================================================

FUNCTION CopyAFile&(BYVAL sdir$,BYVAL ddir$,BYVAL fname$,BYVAL nname$)
         LOCAL h1&,   h2&, _
               tmp1&, tmp2&, _
               buf&,  tam&, _
               p%, e&

	'      Position and error type / Posición y tipo del error
	' ----------------------------------------------------------------
	p% = 0%
	e& = 0&

	'              Fix size buffer / Tamaño del tampón fijo
	' ----------------------------------------------------------------
	tam& = 16384&

	' Mi hipótesis de partida: fracaso / My initial hypothesis: failed
	' ----------------------------------------------------------------
	CopyAFile& = DOSFALSE&

	' Si no se especifica el nombre de destino, se utiliza el de origen
	'     If the destination name is empty, I use the source name
	' -----------------------------------------------------------------
	IF nname$ = "" THEN nname$ = fname$

	'       Se abre fichero de origen / Open the source file
	' -----------------------------------------------------------------
	h1& = OpenAsync&(SADD(sdir$+fname$+CHR$(0)),MODE_READ&,8192&)

	IF h1& <> NULL& THEN

		'     Reservando la memoria tampón / Allocating the buffer
		' -------------------------------------------------------------
		buf& = AllocMem&(tam&,MEMF_PUBLIC& AND MEMF_CLEAR&)

		IF buf& <> NULL& THEN

			'  Abriendo el fichero de destino / Opening the dest. file
			' ---------------------------------------------------------

			h2& = OpenAsync&(SADD(ddir$+nname$+CHR$(0)),MODE_WRITE&,8192&)

			IF h2& <> NULL& THEN

				'     Se copia el contenido del origen en el destino
				' Copying the contents from the source to the destination
				' -------------------------------------------------------
				DO

					tmp1& = ReadAsync&(h1&,buf&,tam&)

					'  ¿Hay un error de lectura? / There is a read error?
					' ---------------------------------------------------
					IF tmp1& < 0& THEN

						e& = IoErr&
						p% = 4%
						EXIT LOOP

					ELSE

						'  No, pues copia los datos / No? Copy the bytes
						' -----------------------------------------------
						IF tmp1& >0 THEN

							tmp2& = WriteAsync&(h2&,buf&,tmp1&)
						
							IF tmp2&<=0& THEN

								'    Copia fallida / Copy has failed
								' --------------------------------------
								e& = IoErr&
								p% = 5%
								EXIT LOOP
			
							END IF

						ELSE
						
							'      Fin de fichero... y de copia :)
							'         End of file and copy :)
							' ------------------------------------------
							CopyAFile& = DOSTRUE&
							EXIT LOOP

						END IF

					END IF

				LOOP UNTIL FALSE&

				' Cerrando fichero destino
				' Closing destination file
				'-------------------------
				tmp1& = CloseAsync&(h2&)

			ELSE

				e& = IoErr&
				p% = 3%
				
			END IF

			FreeMem& buf&,tam&

		END IF

		tmp1& = CloseAsync&(h1&)
		
		IF tmp1&<0 THEN
			e& = IoErr&
			p% = 2%
		END IF

	ELSE
	
		e& = IoErr&
		p% = 1%

	END IF

	'            Sección desactivada: Sólo para depuración
	'              Disabled section: Only for debugging
	' ----------------------------------------------------------------
	'PRINT "Error position / Posición del error: ";p%
	'PRINT "   E/S error   /      Error E/S    : ";e&

END FUNCTION

' ====================================================================
'                Sección principal / Main section
' ====================================================================

PRINT CHR$(10);"A simple demo / Demostración simple";
PRINT CHR$(10);"-----------------------------------";CHR$(10)

ds$ = "SYS:S/"
dn$ = "RAM:"

ns$ = "Startup-Sequence"
nn$ = "Startup-Sequence.bak.txt"

IF CopyAFile&(ds$,dn$,ns$,nn$) = DOSTRUE& THEN

	PRINT "Check what the file '";nn$;"' was created in '";dn$;"'"
	PRINT "Compruebe que el fichero '";nn$;"' ha sido creado en '";dn$;"'"

ELSE

	PRINT "The async copy process has failed!"
	PRINT "¡El fichero de copia asíncrona ha fracasado!"

END IF

PRINT

'        Closing all libraries / Cerrando todas la bibliotecas
' --------------------------------------------------------------------
LIBRARY CLOSE

DATA "$VER: AsynIO_Demo 1.0 (11.06.2011) by AmiSpaTra "

END
