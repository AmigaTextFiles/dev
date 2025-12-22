' ---------------------------------------------------------------------------------------

REM ** $VER: WKey.bas 1.0 (01.09.2009) by AmiSpaTra

SUB WKey(BYVAL mode&)
  LOCAL a$, dummy%

	SELECT CASE mode&

		CASE 257
			dummy% = MOUSE(0)

		CASE 258
			dummy% = STRIG(0)

		CASE 259
			dummy% = STRIG(2)

	END SELECT

	DO

        ' ¡Atención! ¡Use sólo esta subrutina con ventanas creadas por Hisoft Basic con el comando WINDOW!
        '  Warning! Use this subroutine only with windows created with the Hisoft Basic's command WINDOW!
        ' -----------------------------------------------------------------------------------------------
		a$ = INKEY$

		SLEEP

		SELECT CASE mode&

			CASE <= 255

				' Aguarda que se presiene la tecla especificada
				'             Wait for the key specified
				' ---------------------------------------------
				IF a$ = CHR$(INT(mode&)) THEN EXIT LOOP

			CASE 256

				' Cualquier tecla / A key
				' -----------------------
				IF a$ <> "" THEN EXIT LOOP

			CASE 257

				' Botón izquierdo del ratón / Left mouse button
				' ---------------------------------------------
				IF MOUSE(0) THEN EXIT LOOP

			CASE 258

				' Botón de disparo de la palanca nº 0
				'         Fire button (joy #0)
				' -----------------------------------
				IF STRIG(0) THEN EXIT LOOP

			CASE 259

				' Botón de disparo de la palanca nº 1
				'         Fire button (joy #1)
				' -----------------------------------
				IF STRIG(2) THEN EXIT LOOP

			CASE ELSE

				ERROR 5

		END SELECT

	LOOP

END SUB

' ---------------------------------------------------------------------------------------
