
' ---------------------------------------------------------------------------------------

REM ** $VER: ChkPat.bas 1.1 (07.02.2010) by AmiSpaTra

REM ** AllocMem&, FreeMem
' LIBRARY OPEN "exec.library"
REM ** IoErr&, ParsePattern& (v36), MatchPattern& (v36),
REM ** ParsePatternNoCase& (v37), MatchPatternNoCase& (v37)
' LIBRARY OPEN "dos.library", 36

' REM $include exec.bh
' REM $include dos.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION ChkPat&(BYVAL cad$,BYVAL pat$,nocase&)
  LOCAL buf&, l&, hit&, s&, i&

	cad$ = cad$ + CHR$(0)
	pat$ = pat$ + CHR$(0)

	' Tamaño del tampón / Size buffer
	' -------------------------------
	l& = LEN(cad$) * 2 + 2

	' Creando tampón / Creating buffer
	' --------------------------------
	buf& = AllocMem&(l&, MEMF_PUBLIC& OR MEMF_ANY& OR MEMF_CLEAR&)

	IF buf& <> NULL& THEN

		'   La variable nocase& es modificada por esta rutina si la versión de
		'         la biblioteca DOS es inferior a la 37 (no se soporta
		'     la búsqueda que NO diferencie entre mayúsculas y minúsculas).
		'                               -----
		'    The nocase& var is modified by this routine if the DOS library
		' version < 37 (only from the v37 the "no case" functions are available).
		' -----------------------------------------------------------------------
		IF PEEKW(LIBRARY("exec.library")+lib_Version%) < 37 THEN
			 nocase& = FALSE&
		END IF

		IF nocase& = TRUE& THEN

			' No se diferencia entre mayúsculas y minúsculas / Case NO sensitive
			' ------------------------------------------------------------------
			s& = ParsePatternNoCase&(SADD(pat$),buf&,l&)
			i& = IoErr&

			IF s& >= 0& THEN

				hit&  = MatchPatternNoCase&(buf&,SADD(cad$))
				i& = IoErr&

				'   ¿Ha fallado por un error?
				' Has failed? This is an error?
				' -----------------------------
				IF hit& = NULL& AND i& <> NULL& THEN

					' Sí  / Yes
					' ---------
					ChkPat& = i&

				ELSE

					' No
					' --
					ChkPat& = hit&

				END IF

			ELSE

				' Error (ParsePatternNoCase)
				' --------------------------
				ChkPat& = i&

			END IF

		ELSE

			' Diferencia entre mayúsculas y minúsculas / Case sensitive
			' ---------------------------------------------------------
			s& = ParsePattern&(SADD(pat$),buf&,l&)
			i& = IoErr&

			IF s& >= 0& THEN

				hit&  = MatchPattern&(buf&,SADD(cad$))
				i& = IoErr&

				'   ¿Ha fallado por un error?
				' Has failed? This is an error?
				' -----------------------------
				IF hit& = NULL& AND i& <> NULL& THEN

					' Sí  / Yes
					' ---------
					ChkPat& = i&

				ELSE

					' No
					' --
					ChkPat& = hit&

				END IF

			ELSE
				' Error (ParsePattern)
				' --------------------
				ChkPat& = i&

			END IF

		END IF

		FreeMem buf&,l&

	ELSE

		' Memoria libre insuficiente / Out of memory
		' ------------------------------------------
		ChkPat& = 2&

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
