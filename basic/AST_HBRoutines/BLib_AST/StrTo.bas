' ---------------------------------------------------------------------------------------

REM ** $VER: Str2B.bas 1.1 (20.03.2009) by AmiSpaTra

FUNCTION Str2B$(BYVAL cad$)
  LOCAL tmp_st$

	tmp_st$ = RIGHT$(cad$,1)

	IF tmp_st$ = CHR$(0) THEN
		Str2B$ = LEFT$(cad$,LEN(cad$)-1)
	ELSE
		ERROR 5
	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------


REM ** $VER: Str2C.bas 1.0 (18.09.2009) by AmiSpaTra

FUNCTION Str2C$(BYVAL cad$)
  LOCAL tmp_st$

	tmp_st$ = RIGHT$(cad$,1)

	IF tmp_st$ <> CHR$(0) THEN
		Str2C$ = cad$ +CHR$(0)
	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
