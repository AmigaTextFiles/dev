
' ---------------------------------------------------------------------------------------

REM ** ReplaceChars.bas 1.0 (01.09.2009) by AmiSpaTra

FUNCTION ReplaceChars$(BYVAL cadena$,BYVAL caracteres$,BYVAL cadsust$)
  LOCAL cad_tmp$, char_tmp$, a%, b%, dummy&

	cad_tmp$ = ""

	FOR a% = 1 TO LEN(cadena$)

		char_tmp$ = MID$(cadena$,a%,1)

		FOR b% = 1 TO LEN(caracteres$)

			IF char_tmp$ = MID$(caracteres$,b%,1) THEN

				char_tmp$ = cadsust$
				EXIT FOR

			END IF

		NEXT b%
		
		cad_tmp$ = cad_tmp$ + char_tmp$

	NEXT a%

	'   Llamando al recolector de basura
	'        (rutina que hace uso
	'      intensivo de las cadenas).
	' ------------------------------------
	'    Calling the garbage collector
	' (routine with intensive string use).
	' ------------------------------------
	dummy& = FRE("")

	ReplaceChars$ = cad_tmp$

END FUNCTION

' ---------------------------------------------------------------------------------------
