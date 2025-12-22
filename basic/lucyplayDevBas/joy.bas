' *********************************************************************
'                         `Joy.bas' example based
'               over the C example wrote by Oliver Gantert
'                 with little modifications/enhacements ;)
'
'              Ejemplo `Joy.bas' basado en la versión en C
'                      escrita por Olivert Gantert
'            (aunque incluye pequeñas modificiones/mejoras ;)
'
'                 C to HBASIC conversion 1.0a (10.2.01)
'                by Dámaso D. Estévez <amidde@arrakis.es>
'               AmiSpaTra - http://www.arrakis.es/~amidde/
' *********************************************************************

REM $include dos.bh
REM $include exec.bc       ' TRUE& (tag/etiqueta)
REM $include lucyplay.bh

' =====================================================================
'                    Global vars / Variables globales
' =====================================================================

lpb&    = NULL&            ' LucyPlayBase

'     LucyPlayJoystick struct pointer
' Puntero a la estructura LucyPlayJoystick
' ----------------------------------------
j&      = NULL&

' =====================================================================
'                    The main code / El código principal
' =====================================================================

' Delay()
LIBRARY OPEN "dos.library"
LIBRARY OPEN "lucyplay.library",1&

PRINT "-----------------------------------------------------------"
PRINT "  `Joy.bas' example (press red/(1st) fire button to end)   "
PRINT "Ejemplo `Joy.bas' (pulse el botón rojo/fuego para terminar)"
PRINT "-----------------------------------------------------------"
PRINT

j& = lucJoyInit&()

IF j& THEN

	PRINT "[ENGLISH] Check now the joy(stick|pad)!..."
	PRINT "[ESPAÑOL] ¡Pruebe ahora el dispositivo de control!..."
	PRINT

	DO WHILE TRUE&

		lucJoyRead j&

		IF PEEKB(j&+lpjoy_Up%)      THEN PRINT "up";TAB(20);"arriba"
		IF PEEKB(j&+lpjoy_Down%)    THEN PRINT "down";TAB(20);"abajo"
		IF PEEKB(j&+lpjoy_Left%)    THEN PRINT "left";TAB(20);"izquierda"
		IF PEEKB(j&+lpjoy_Right%)   THEN PRINT "right";TAB(20);"derecha"

		IF PEEKB(j&+lpjoy_Blue%)    THEN PRINT "blue/2st button";TAB(20);"botón azul/de disparo secundario"

		' ---------------------------------------------------
		'   This code section would be don't work if you use
		'       a not CD32 joypad compatible or with
		'      an auto mouse-joystick switch port! 8'(
		'                      ---
		' ¡Estas líneas de código podrían no funcionar si no
		'  dispone de un dispositivo de control compatible
		'  CD32 o si utiliza un compartidor de puerto! 8'(
		' ---------------------------------------------------
		IF PEEKB(j&+lpjoy_Green%)   THEN PRINT "green";TAB(20);"botón verde"
		IF PEEKB(j&+lpjoy_Yellow%)  THEN PRINT "yellow";TAB(20);"botón amarillo"
		IF PEEKB(j&+lpjoy_Forward%) THEN PRINT "forward";TAB(20);"botón de avance"
		IF PEEKB(j&+lpjoy_Reverse%) THEN PRINT "reverse";TAB(20);"botón de retroceso"
		IF PEEKB(j&+lpjoy_Play%)    THEN PRINT "play/stop";TAB(20);"botón de reproducción/pausa/detención"
		' --------------------------------------------------

		IF PEEKB(j&+lpjoy_Red%)     THEN
			PRINT "red";TAB(20);"botón rojo/de disparo primario"
			EXIT DO
		END IF

		'     Why this line? See the Mr Gantert's
		'   explanation included in your C example
		' -------------------------------------------
		'   ¿Porqué esta línea? Lea la explicación
		' del Sr. Gantert incluida en su ejemplo en C
		' -------------------------------------------
		Delay 1

	WEND

	lucJoyKill joy&

END IF

LIBRARY CLOSE

END
