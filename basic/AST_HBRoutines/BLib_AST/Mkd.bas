
' ---------------------------------------------------------------------------------------

REM ** $VER: Mkd.bas 1.1 (01.09.2002) by AmiSpaTra

REM ** IoErr&, CreateDir&, UnLock&
' LIBRARY OPEN "dos.library"

' REM $include exec.bc
' REM $include dos.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION MKD&(BYVAL dirname$)
  LOCAL tmp_hdl&, tmp_err&

	tmp_hdl& = CreateDir&(SADD(dirname$+CHR$(0)))
	tmp_err& = IoErr&()

	IF tmp_hdl& <> NULL& THEN

		MKD& = tmp_hdl&

		' Se desbloquea el directorio creado
		'    Unlocking the dir created
		' ---------------------------------
		UnLock& tmp_hdl&

	ELSE
	
		MKD& = tmp_err&

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
