' ---------------------------------------------------------------------------------------

REM ** $VER: CopyFile.bas 2.0 (01.09.2009) by AmiSpaTra

REM ** AllocMem&, FreeMem
' LIBRARY OPEN "exec.library"
REM ** xOpen&, xClose&, FRead& (v36), FWrite& (v36),
REM ** AllocDOSObject& (v36), FreeDosObject (v36), ExamineFH& (v36)
' LIBRARY OPEN "dos.library", 36

' REM $include exec.bh
' REM $include dos.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION CopyFile&(BYVAL sdir$,BYVAL ddir$,BYVAL fname$,BYVAL nname$)
  LOCAL h1&, h2&, dobj&, fh&, tmp1&, tmp2&, buf&, tam&

	' Mi hipótesis de partida
	'  My initial hypothesis
	' -----------------------
	CopyFile& = DOSFALSE&

	' Si no se especifica el nombre de destino, se utiliza el de origen
	'     If the destination name is empty, I use the source name
	' -----------------------------------------------------------------
	IF nname$ = "" THEN nname$ = fname$

	' Se abre fichero de origen
	'    Open the source file
	' -------------------------
	h1& = xOpen&(SADD(sdir$+fname$+CHR$(0)),MODE_OLDFILE&)

	IF h1& <> NULL& THEN

		' Quiero obtener los atributos del fichero origen.
		'   I want to obtain the original file attribs.
		' -------------------------------------------------
		dobj& = AllocDOSObject&(DOS_FIB&,NULL&)

		' Tampón dinámico
		' Dynamic buffer
		' ---------------
		IF dobj& <> NULL& THEN

			fh& = ExamineFH&(h1&,dobj&)

			IF fh& <> NULL& THEN

				' Calculando el tamaño de tampón óptimo para el copiado
				'             Calculating the size buffer
				' -----------------------------------------------------
				tam& = PEEKL(dobj&+fib_Size%)

				DO

					buf& = AllocMem&(tam&,MEMF_PUBLIC& AND MEMF_CLEAR&)

					IF buf& <> NULL& THEN

						EXIT LOOP

					ELSE

						tam& = tam& \ 2&

						' Tamaño de tampón mínimo: 4 Ko
						'   Minimum size buffer: 4 Kb
						' -----------------------------
						IF tam& < 4096& THEN

							EXIT LOOP

						END IF

					END IF

				LOOP UNTIL FALSE&

			END IF

			FreeDosObject& DOS_FIB&, dobj&

		END IF

		IF buf& <> NULL& THEN

			' Se abre el fichero de destino
			' Opening the destination file
			' -----------------------------

			h2& = xOpen&(SADD(ddir$+nname$+CHR$(0)),MODE_NEWFILE&)

			IF h2& <> NULL& THEN

				'     Se copia el contenido del origen en el destino
				' Copying the contents from the source to the destination
				' -------------------------------------------------------
				DO

					tmp1& = FRead&(h1&,buf&,1&,tam&)
					tmp2& = FWrite&(h2&,buf&,1&,tmp1&)

					'  ¿La lectura del bloque o su escritura ha fallado?
					'            (tmp1& = 0 -> fin del fichero).
					' ---------------------------------------------------
					' The reading/writing has failed? (tmp1& = 0 -> EOF).
					' ---------------------------------------------------
					IF tmp1& <= 0& OR tmp2& <> tmp1& THEN
						IF tmp1& = 0& THEN
							CopyFile& = DOSTRUE&
						END IF
						EXIT LOOP
					END IF

				LOOP UNTIL FALSE&

				' Cerrando fichero destino
				' Closing destination file
				'-------------------------
				tmp1& = xClose&(h2&)

			END IF

			FreeMem& buf&,tam&

		END IF

		tmp1& = xClose&(h1&)

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------

