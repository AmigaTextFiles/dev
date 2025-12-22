' ---------------------------------------------------------------------------------------

REM ** $VER: CreateVarEnv.bas 1.1 (01.09.2009) by AmiSpaTra

' REM $include exec.bc

REM *************************************************************************

FUNCTION CreateVarEnv&(BYVAL appname$,BYVAL varname$,BYVAL v$)
  LOCAL var$

	var$ = "ENV:"+appname$+"_"+varname$

	IF NOT FEXISTS(var$) THEN

		OPEN var$ FOR OUTPUT AS #1
			PRINT #1, v$
		CLOSE #1

		CreateVarEnv& = TRUE&

	ELSE

		CreateVarEnv& = FALSE&

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
