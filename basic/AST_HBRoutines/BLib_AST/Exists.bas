' ---------------------------------------------------------------------------------------

REM ** $VER: Exists.bas 2.0 (14.02.2010) by AmiSpaTra

REM ** Lock&, IoErr&, UnLock
' LIBRARY OPEN "dos.library"

' REM $include dos.bh
 
REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION Exists&(BYVAL oname$)
  LOCAL lck&, e&, ret&

	IF oname$ <> "" THEN

		lck& = Lock&(SADD(oname$+CHR$(0)),ACCESS_READ&)
		e&   = IoErr&

		IF lck& THEN

			UnLock lck&
			ret& = 1&
		
		ELSE

			IF e& = ERROR_OBJECT_NOT_FOUND& OR e& = ERROR_DIR_NOT_FOUND& OR e& = ERROR_DEVICE_NOT_MOUNTED& THEN
				ret& = 0&
			ELSE
				ret& = e&
			END IF
		END IF

		Exists& = ret&

	ELSE
	
		ERROR 5
		
	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
