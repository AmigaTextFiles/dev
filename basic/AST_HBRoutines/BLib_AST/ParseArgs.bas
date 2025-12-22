
' ---------------------------------------------------------------------------------------

REM ** ParseArgs.bas 1.0 (01.09.2009) by AmiSpaTra

REM ** FindTask&
' LIBRARY OPEN "exec.library"
REM ** ReadArgs& (v36), FreeArgs (v36)
' LIBRARY OPEN "dos.library", 36
REM ** GetDiskObject&, FindToolType&, FreeDiskObject
' LIBRARY OPEN "icon.library"

' REM $include exec.bh
' REM $include dos.bh
' REM $include icon.bh
' REM $include workbench.bc

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION ParseArgs&(tpt$(2),BYVAL appname$)
  LOCAL  a%, aw&, ac&, struct&, tmp$, sz%, tsk&

	' --------------------------------------------------------
	'                  Hipótesis inicial:
	'      El trabajo básico NO se ha hecho correctamente
	'       -------------------------------------------
	'       Initial hypothesis: The basic work was fails
	' --------------------------------------------------------
	ParseArgs& = NULL&

	sz% = UBOUND(tpt$,1)

	' --------------------------------------------------------
	'   Comprobando si el programa ha sido puesto en marcha
	'   desde el Workbench (ReadTooltypes) o CLI (ReadArgs).
	'   ------------------------------------------------------
	'           Checking if the program was started 
	'        from WB (ReadTooltypes) or CLI (ReadArgs).
	' --------------------------------------------------------
	
	IF PEEKL(SYSTAB+8) <> 0 THEN

		tsk& = FindTask&(NULL&)

		struct& = GetDiskObject&(SADD(PEEK$(tsk&+ln_Name%)+CHR$(0)))

		IF struct& <> NULL& THEN

			FOR a% = 0% TO sz%

				aw& = FindToolType&(PEEKL(struct&+do_Tooltypes%),SADD(tpt$(a%,0)+CHR$(0)))

				' --------------------------------------------
				'      El resultado puede ser un puntero a
				'     una cadena o un número de algún tipo:
				'    si es una cadena hay que salvaguardarla
				'  antes de liberar la estructura rda&, porque 
				'    luego el puntero no servirá para nada.
				'    --------------------------------------
				'   The result would be a pointer to a string
				'    or a numeric value: if this is a string
				'     I must to save it previous to release
				'        the rda& struct or, after this,
				'         the pointer will be invalid.
				' --------------------------------------------

				IF aw& THEN

					IF tpt$(a%,2) = CHR$(0) THEN
						tpt$(a%,3) = PEEK$(aw&)
					ELSE
						tpt$(a%,3) = STR$(aw&)
					END IF

				END IF			

			NEXT a%
		
			FreeDiskObject struct&

			' -----------------------------
			' La rutina ha hecho el trabajo
			' The routine has done the work
			' ------------------------------
			ParseArgs& = TRUE&

		END IF

	ELSE

		' ----------------------------------------------------
		'   Generando la cadena "plantilla" para ReadArgs&()
		'     Creating the template string for ReadArgs&()
		' ----------------------------------------------------
		tmp$  = ""

		FOR a% = 0% TO sz%

			tmp$ = tmp$+tpt$(a%,0)+tpt$(a%,1)

			IF a% <> sz% THEN
				tmp$ = tmp$ + ","
			END IF

		NEXT a%

		tmp$ = tmp$ + CHR$(0)

		' ----------------------------------------------------
		'           Creando matriz para argumentos
		'              Creating array for args
		' ----------------------------------------------------
		DIM ac&(sz%+1)

		' ----------------------------------------------------
		'         El último elemento (el terminador)
		'          The last element (the terminator)
		' ----------------------------------------------------
		ac&(sz%+1) = NULL&

		struct& = ReadArgs&(SADD(tmp$),VARPTR(ac&(0)),NULL&)

		IF struct& THEN

			FOR a% = 0% TO sz%

				' --------------------------------------------
				'      El resultado puede ser un puntero a
				'     una cadena o un número de algún tipo:
				'    si es una cadena hay que salvaguardarla
				'  antes de liberar la estructura rda&, porque 
				'    luego el puntero no servirá para nada.
				'    --------------------------------------
				'   The result would be a pointer to a string
				'    or a numeric value: if this is a string
				'      I must to save previous to release
				'        the rda& struct or, after this,
				'         the pointer will be invalid.
				' --------------------------------------------
				IF ac&(a%) THEN

					IF tpt$(a%,2) = CHR$(0) THEN
						tpt$(a%,3) = PEEK$(ac&(a%))
					ELSE
						tpt$(a%,3) = STR$(ac&(a%))
					END IF

				END IF

			NEXT a%

			FreeArgs struct&

			' ---------------------------------------------------
			'     Se borra la matriz (he terminado con ella).
			'    I erase the array (I've finnished with them).
			' ---------------------------------------------------
			ERASE ac&

			' -----------------------------
			' La rutina ha hecho el trabajo
			' The routine has done the work
			' ------------------------------
			ParseArgs& = TRUE&

		END IF

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
