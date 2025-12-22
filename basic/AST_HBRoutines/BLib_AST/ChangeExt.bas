
' ---------------------------------------------------------------------------------------

REM ** $VER: ChangeExt.bas 1.1 (06.02.2010) by AmiSpaTra

FUNCTION ChangeExt$(BYVAL flname$,BYVAL ext$)
  LOCAL tmp_p&, tmp_s$

	tmp_s$ = flname$
	tmp_p& = RINSTR(flname$,".")

	IF tmp_p& <> 0& AND LEN(flname$) > 0& THEN
		tmp_s$ = LEFT$(flname$,tmp_p&-1&)
	END IF

	IF ext$ <> "" THEN
		tmp_s$ = tmp_s$ + "." + ext$
	END IF

	ChangeExt$ = tmp_s$

END FUNCTION

' ---------------------------------------------------------------------------------------

