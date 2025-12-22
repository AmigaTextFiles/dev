
' ---------------------------------------------------------------------------------------

REM ** $VER: CCase.bas 1.0 (01.09.2009) by AmiSpaTra

REM ** ConvToUpper& (v38), ConvToLower& (v38)
' LIBRARY OPEN "locale.library", 38

' REM $include locale.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION CCase$(BYVAL st$, BYVAL mode&)
  LOCAL i%, nst$, lcl&, tmp&

	nst$ = ""

	lcl& = OpenLocale&(0&)

	IF lcl& THEN

		' He añadido este control adicional para que sólo funcione con
		'      el AmigaOS clásico que utiliza el ISO-LATIN-1.
		'   Con el AmigaOS4+ se soportan otros juegos de caracteres
		'  incluyendo los multiocteto y tal como funciona la rutina
		'   no soporta éstos... quizás, si consigo más documentación,
		'       mejore la rutina eliminando esta limitación :).
		' ------------------------------------------------------------
		'   I've added this aditional control because this routine
		'   only works with the Amiga Classic (ISO-LATIN-1 charset).
		' With AmigaOS4+ the system supports other charsets included
		'    the multibyte charsets and this routine don't support
		'      theses... yet.  Perhaps if I obtain more info
		'     I enhace the routine removing this limitation :).
		' ------------------------------------------------------------
		IF PEEKL(lcl&+loc_CodeSet%) = 0& THEN

			For i% = 0% TO LEN(st$) - 1%

				tmp& = CLNG(PEEKB(SADD(st$)+i%))

				IF mode& THEN

					nst$ = nst$ + CHR$(CINT(ConvToUpper&(lcl&,tmp&)))

				ELSE

					nst$ = nst$ + CHR$(CINT(ConvToLower&(lcl&,tmp&)))

				END IF

			NEXT i%

		END IF

		CloseLocale&(lcl&)

	ELSE

		ERROR 51

	END IF

	' ---------------------------------------------------------
	'     Invoca al recolector de basura del Basic por si
	'    se he generado mucha basura al manejar las cadenas.
	' ---------------------------------------------------------
	'     Invokes the Basic's garbage collector (if there
	' are several strings' operations theses generates garbage)
	' ---------------------------------------------------------
	tmp& = FRE("")

	CCase$ = nst$

END FUNCTION

' ---------------------------------------------------------------------------------------
