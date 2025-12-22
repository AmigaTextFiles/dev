
' ---------------------------------------------------------------------------------------

REM ** $VER: FixPath.bas 1.1 (01.09.2009) by AmiSpaTra

FUNCTION FixPath$(BYVAL path$)
  LOCAL tmp_st$

	IF path$ <> "" THEN

		tmp_st$ = RIGHT$(path$,1)

		IF tmp_st$ <> "/" AND tmp_st$ <> ":" THEN
			path$ = path$ + "/"
		END IF

	END IF

	FixPath$ = path$

END FUNCTION


' ---------------------------------------------------------------------------------------
