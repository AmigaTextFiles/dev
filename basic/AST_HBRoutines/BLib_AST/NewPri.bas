
' ---------------------------------------------------------------------------------------

REM ** $VER: NewPri.bas 1.0 (01.09.2009) by AmiSpaTra

REM ** SetTaskPri&
' LIBRARY OPEN "exec.library"

' REM $include exec.bh

REM *************************************************************************

FUNCTION NewPri&(BYVAL npri&,BYVAL mode&)
  LOCAL opri&, dummy&

	opri& = SetTaskPri&(FindTask&(NULL&),npri&)

	IF mode& = FALSE& THEN

		dummy& = SetTaskPri&(FindTask&(NULL&),opri&+npri&)

	END IF

	NewPri& = opri&

END FUNCTION

' ---------------------------------------------------------------------------------------
