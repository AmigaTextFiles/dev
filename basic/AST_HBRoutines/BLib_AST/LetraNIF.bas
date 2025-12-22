
' ---------------------------------------------------------------------------------------

REM ** $VER: LetraNIF.bas 1.0 (06.02.2009) by AmiSpaTra

FUNCTION LetraNIF$(BYVAL dni&)

	LetraNIF$ = MID$("TRWAGMYFPDXBNJZSQVHLCKE",(dni& MOD 23 + 1),1)

END FUNCTION

' ---------------------------------------------------------------------------------------
