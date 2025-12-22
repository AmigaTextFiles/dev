' *********************************************************************
'                       `Audio.bas' example based
'              over the C example wroter by Oliver Gantert
'
'              Ejemplo `Audio.bas' basado en la versión en C
'                      escrita por Olivert Gantert
'
'                  C to HBASIC conversion 1.0b (10.4.03)
'                by Dámaso D. Estévez <amidde@arrakis.es>
'               AmiSpaTra - http://www.arrakis.es/~amidde/
' *********************************************************************

REM $NOWINDOW

REM $include lucyplay.bh

' =====================================================================
'                    Global vars / Variables globales
' =====================================================================

lpb&    = NULL&           ' LucyPlayBase (pointer/puntero)

'     LucyPlaySample struct pointer
' Puntero a la estructura LucyPlaySample
' --------------------------------------
smp&    = NULL&

' =====================================================================
'                    The main code / El código principal
' =====================================================================

LIBRARY OPEN "lucyplay.library",1&

tmp$ = LTRIM$(RTRIM$(COMMAND$))

'  If the user don't include an argument
'    the program quit without messages
'                 ----
'  Si el usuario no incluye un argumento
' el programa termina de forma silenciosa
' ---------------------------------------

PRINT "-----------------------------------------"
PRINT "`Audio.bas' example / Ejemplo `Audio.bas'"
PRINT "-----------------------------------------"
PRINT

IF tmp$ <> "" THEN

	ok& = lucAudioInit&()

	IF ok& THEN

		smp& = lucAudioLoad&(SADD(tmp$+CHR$(0)))

		IF smp& <> NULL& THEN

			PRINT "[ENGLISH] Playing full sound..."
			PRINT "[ESPAÑOL] Reproduciendo sonido completo..."

			'       The v2 only supports PC's RIFF WAV format!
			' ¡La versión 2 sólo soporta el formato RIFF WAV de PC!
			' -----------------------------------------------------
			lucAudioPlay(smp&)
			lucAudioWait

			lucAudioFree(smp&)

		ELSE

			PRINT "[ENGLISH] Error with argument/sample WAV file!!"
			PRINT "[ESPAÑOL] ¡¡Error con el fichero WAV/argumento!!"

		END IF

		lucAudioKill

	END IF

ELSE

	PRINT "[ENGLISH] No argument (sample file)!!"
	PRINT "[ESPAÑOL] ¡¡Falta el argumento (fichero de muestra de sonido)!!"

END IF


LIBRARY CLOSE

END
