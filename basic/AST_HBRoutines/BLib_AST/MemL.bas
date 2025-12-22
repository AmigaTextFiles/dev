
' ---------------------------------------------------------------------------------------

REM ** $VER: MemL.bas 1.1 (01.09.2009) by AmiSpaTra

REM ** AllocMem&, FreeMem
' LIBRARY OPEN "exec.library"

' REM $include exec.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION AllocMemL&(BYVAL sz&, BYVAL flags&, BYVAL pml&)
  LOCAL ptr&

	ptr& = AllocMem&(sz&+12&,flags&)

	IF ptr& <> NULL& THEN

		' Guardando el tamaño del bloque
		' Saving the memory chunk's size
		' ------------------------------
		POKEL ptr&+8&, sz&+12&

		' Guardando el puntero al bloque siguiente (que aún no existe)
		'     Saving the pointer to next block (don't exists yet)
		' ------------------------------------------------------------
		POKEL ptr&+4&, NULL&

		'   Si hay nodo anterior...
		' If a previous node exists...
		' ----------------------------
		IF pml& <> NULL& THEN

			'  El nodo actual apunta al anterior
			' The current node points to previous
			' -----------------------------------
			POKEL ptr&, pml&

			'    El nodo previo apunta al actual
			'  The previous node points to current
			' ------------------------------------
			POKEL (pml&-8&), ptr&+12&

		ELSE

			' No hay nodo previo
			'  No previous node
			' ------------------
			POKEL ptr&, NULL&

		END IF

		AllocMemL& = ptr&+12&

	ELSE

		AllocMemL& = NULL&

	END IF


END FUNCTION

' ---------------------------------------------------------------------------------------

FUNCTION FreeMemL&(BYVAL pml&)
  LOCAL ptr&, sz&

	IF pml& <> NULL& AND PEEKL(pml&-8&) = NULL& THEN

		WHILE TRUE&

			FreeMemL& = pml&

			ptr& = PEEKL(pml&-12&)
			sz&  = PEEKL(pml&- 4&)

			FreeMem&(pml&-12&), sz&

			IF ptr& = NULL& THEN

				' Encontrado el bloque inicial de memoria de la lista
				'         Found the first memory list chunk
				' ---------------------------------------------------
				EXIT WHILE

			ELSE

				pml& = ptr&

			END IF

		WEND

	ELSE

		' Lista de memoria no inicializada, corrupta o el puntero no es del último elemento
		'   Memory List not initialized or corrupted or this isn't the last node's pointer
		' ---------------------------------------------------------------------------------
		FreeMemL& = NULL&

	END IF

END FUNCTION


' ---------------------------------------------------------------------------------------
