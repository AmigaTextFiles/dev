' ---------------------------------------------------------------------------------------

REM ** $VER: CopyFDAtribs.bas 1.0 (01.09.2009) by AmiSpaTra

REM ** AllocDOSObject& (v36), FreeDosObject (v36), Examine&,
REM ** SetFileDate& (v36), SetComment&, SetProtection&, SetOwner& (v39)
' LIBRARY OPEN "dos.library"

' REM $include dos.bh
' REM $include exec.bc

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION CopyFDAtribs&(BYVAL source$,BYVAL destination$,BYVAL att&)
  LOCAL lck&, dobj&, fh&, tmp1&, tmp2&

	' ------------------------------------------
	'  Mi hipótesis de partida: todo correcto
	'    My initial hypothesis: all are ok
	' ------------------------------------------
	CopyFDAtribs& = 0&

	lck&  = 0&
	dobj& = 0&
	fh&   = 0&
	tmp1& = 0&
	tmp2& = 0&

	'-------------------------------------------
	'      Bloquea el fichero o directorio
	'         Lock the file or drawer
	' ------------------------------------------
	lck& = Lock&(SADD(source$+CHR$(0)),ACCESS_READ&)

	IF lck& THEN

		'---------------------------------------
		'   Reservo la memoria adecuada para
		'  los atributos que quiero averiguar.
		'  -----------------------------------
		'    I allocate memory for to save
		'   the atribs what I want to know.
		' --------------------------------------
		dobj& = AllocDOSObject&(DOS_FIB&,0&)

		IF dobj& THEN

			' ----------------------------------
			'       Copio los atributos
			'        I copy the atribs.
			' ----------------------------------
			fh& = Examine&(lck&,dobj&)

			' ----------------------------------
			'         Libero el bloqueo
			'        I release the lock
			' ----------------------------------
			UnLock& lck&

			IF fh& THEN

				IF att& OR &B0010& THEN

					' --------------------------
					'         Protección
					'         Protection
					' --------------------------
					tmp1& = SetProtection&(SADD(destination$+CHR$(0)),PEEKL(dobj&+fib_Protection%))

					IF tmp1& = 0& THEN
						tmp2& = &B0000000000000010&
					END IF

				END IF

				IF att& OR &B0100& THEN

					' --------------------------
					'    Comentario / Comment
					' --------------------------
					tmp1& = SetComment&(SADD(destination$+CHR$(0)),dobj&+fib_Comment%)

					IF tmp1& = 0& THEN
						tmp2& = tmp2& OR &B0000000000000100&
					END IF

				END IF

				IF att& OR &B1000&  THEN

					IF PEEKW(LIBRARY("dos.library")+lib_Version%) >= 39& THEN

						' --------------------------
						'     Propietario-grupo
						'      Owner(UID|GID)
						' --------------------------
						tmp1& = SetOwner&(SADD(destination$+CHR$(0)),CLNG((PEEKW(dobj&+fib_OwnerUID%)*2^16)+PEEKW(dobj&+fib_OwnerGID%)))

						IF tmp1& = 0& THEN
							tmp2& = tmp2& OR &B0000000000001000&
						END IF

					ELSE

						tmp2& = tmp2& OR &B0000000000001000&

					END IF
					
				END IF

				IF att& OR &B0001& THEN

					IF PEEKW(LIBRARY("dos.library")+lib_Version%) >= 36& THEN

						' --------------------------
						'        Hora y fecha
						'        Time and date
						' --------------------------
						tmp1& = SetFileDate&(SADD(destination$+CHR$(0)),dobj&+fib_Date%)

						IF tmp1& = 0& THEN
							tmp2& = tmp2& OR &B0000000000000001&
						END IF

					ELSE

						tmp2& = tmp2& OR &B0000000000000001&

					END IF

				END IF

				' ------------------------------
				'  Si se han producido errores
				'      se informa de ello.
				'      -------------------
				'      If there are errors, 
				'  the routine inform about it.
				'-------------------------------
				IF tmp2& THEN CopyFDAtribs& = tmp2&

			ELSE

				CopyFDAtribs& = &B0000010000000000&

			END IF

			FreeDosObject& DOS_FIB&,dobj&

		ELSE

			CopyFDAtribs& = &B0000001000000000&

		END IF

	ELSE

		CopyFDAtribs& = &B0000000100000000&

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
