' *********************************************************************
'                   PlaySidExample.bas 1.0 (2.7.00)
'            © 2000 by Dámaso D. Estévez <amidde@arrakis.es>
'                        All Rights Reserved
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'  This examples was wrote reading the reduced documentation included
'  in the developper package and with the hard "try & essay" method.
'   The program plays a SID module... you can find some in Aminet
'    (try Crazy_sue.sid or MegaDefender-Cracktro.sid included in
'  the mods/sets/MSX-SIDcollect.lha package), however, probably you
'   must modify them and generate your icon asociated with SIDConv
'     (included in the PlaySID package)... in my machine (060)
'        the library is slow and seems don't work very well
'                      (slow music, freezes...).
'
'  Este ejemplo ha sido escrito basándose en la reducida documentación
'              includa en el paquete para desarrolladores
'      y utilizando el siempre pesado método de ensayo y error :).
'    El programa reproduce un módulo SID... puede encontrar algunos
'     en Aminet (pruebe Crazy_sue.sid o MegaDefender-Cracktro.sid
'  incluidos en el paquete mods/sets/MSX-SIDcollect.lha), sin embargo,
'   probablemente deberá modificarlos y generar su icono asociado con
'     la herramienta  SIDConv (incluido en el paquete PlaySID)...
'   en mi máquina (060) la biblioteca es lenta y no parece funcionar
'              demasiado bien (música lenta, parones...).
' *********************************************************************

REM $include dos.bh
REM $include exec.bh
REM $include playsid.bh

' =====================================================================
'                    Global vars / Variables globales
' =====================================================================

db&    = NULL&   ' DosBase
psb&   = NULL&   ' PlaySidBase

long1& = NULL&
long2& = NULL&
long3& = NULL&
long4& = NULL&

pause& = TRUE&   ' Status reproduction / Estado de la reproducción

ok&    = FALSE&  ' Inicialization ok? / ¿Inicialización correcta?

' =====================================================================
'           Functions and subroutines / Funciones y subrutinas
' =====================================================================

'           -----------------------------------------------------
'                Prints song's author, copyright or name info
'           Imprime el autor, copyright o el nombre de la canción
'           -----------------------------------------------------

FUNCTION RecHeadInfo$(address&)
LOCAL t1$,t2$,a%

	t1$="":t2$=""

	FOR a%=0 TO HEADERINFO_SIZE&-1
		t2$=CHR$(PEEKB(address&+a%))
		IF t2$=CHR$(0) THEN
			EXIT FOR
		ELSE
			t1$=t1$+t2$
		END IF
	NEXT a%

	RecHeadInfo$=t1$

END FUNCTION

'            ---------------------------------------------------
'            Info about the module / Información sobre el módulo
'            ---------------------------------------------------

SUB InfoSID(header&)

	PRINT
	PRINT "  ------- Some info about the module -------"
	PRINT "  Name     : ";RecHeadInfo$(header&+SIDHeader_name%)
	PRINT "  Length   :";PEEKW(header&+SIDHeader_length%)
	PRINT "  DefSong  :";PEEKW(header&+SIDHeader_defsong%)
	PRINT "  Speed    :";PEEKL(header&+SIDHeader_speed%)
	PRINT "  Author   : ";RecHeadInfo$(header&+SIDHeader_author%)
	PRINT "  Copyright: ";RecHeadInfo$(header&+SIDHeader_copyright%)
	PRINT "  -----------------------------------------"
	PRINT

END SUB

'               ---------------------------------------------
'                   Processing the CLI argument(s) string
'                     See the dev/basic/ImageDTInfo.lha
'                    package for understand this routine.
'                               ------------
'                 Procesando la cadena de argumento(s) CLI
'               Consulte el paquete dev/basic/ImageDTInfo.lha
'                  para entender cómo funciona esta rutina
'               ---------------------------------------------

FUNCTION getarg$(cad$,p%)
LOCAL num%,quotes%,char%,cadtmp$,a%

	getarg$=""

	WHILE cad$ <> ""

		cad$=LTRIM$(RTRIM$(cad$))

		num%    = 1
		cadtmp$ = ""
		quotes% = 0

		FOR a%=1 TO LEN(cad$)

			char%=ASC(MID$(cad$,a%,1))

				SELECT CASE char%

					' ------ Modifying quotes status -------
					' - Modificando estado de las comillas -
					' --------------------------------------
					CASE 34
					quotes% = NOT quotes%

					' -- Spaces/ Espacios --
					' ----------------------
					CASE 32
					IF quotes% = 0 THEN
						' --- The space is an arguments separator ---
						' - El espacio es un separador de argumentos-
						' -------------------------------------------
						IF num%=p% THEN
							' --------- Parse arg asked... end ---------
							' - Procesado argumento pedido... terminar -
							' ------------------------------------------
							EXIT FOR
						ELSE
							'-- Parse the next character (and argument) --
							'- Procesar siguiente carácter (y argumento) -
							' --------------------------------------------
							num%=num%+1%
							EXIT SELECT
						END IF
					ELSE
						' --------- To preserve space for the argument asked (quoted) ---------
						' -- Preservar espacios del argumento pedido si están entre comillas --
						' ---------------------------------------------------------------------
						IF num%=p% THEN cadtmp$=cadtmp$+CHR$(char%)
					END IF

					' --- Preserve others characters (only for the argument asked) ----
					' - Preservar el resto de los caracteres para el argumento pedido -
					' -----------------------------------------------------------------
					CASE ELSE
					IF num%=p% THEN cadtmp$=cadtmp$+CHR$(char%)

				END SELECT

		NEXT a%

		cad$ = cadtmp$

		IF cad$ = "?" THEN

			PRINT "SIDFILE/A: ";
			INPUT "",cad$

		ELSE

			' ---------- Exit point if cad$<>"" -----------
			' - Punto de salida de la función si cad$<>"" -
			' ---------------------------------------------
			getarg$=cad$
			EXIT WHILE

		END IF

	WEND

	' ---------- Exit point if cad$="" -----------
	' - Punto de salida de la función si cad$="" -
	' --------------------------------------------
END FUNCTION

' =====================================================================
'                    The main code / El código principal
' =====================================================================

PRINT " Playsid Library Coding Example"
PRINT " ------------------------------"

'  Checking the CLI argument
' Verificando el argumento CLI
' ----------------------------

file$=getarg$(COMMAND$,1%)
IF file$="" THEN
	PRINT "   *** I need a SID file as argument!"
	ok& = FALSE&
ELSE
	ok&=TRUE&
END IF
file$=file$+CHR$(0)

' Opening libraries / Abriendo bibliotecas
' ----------------------------------------

IF ok& = TRUE& THEN
	LIBRARY OPEN "exec.library",36&

	db& =OpenLibrary&(SADD("dos.library"+CHR$(0)),36&)
	psb&=OpenLibrary&(SADD("playsid.library"+CHR$(0)),PLAYSIDVERSION&)

	IF psb& <> NULL& AND db& <> NULL& THEN
		LIBRARY VARPTR "dos.library",db&
		LIBRARY VARPTR "playsid.library",psb&
		PRINT " . Opened the PlaySid library"
		ok& = TRUE&
	END IF
END IF

' Allocating memory / Reservando memoria
' --------------------------------------

IF ok& = TRUE& THEN
	header&=AllocMem&(SIDHeader_sizeof%,MEMF_CLEAR& OR MEMF_ANY&)
	IF header& = NULL& THEN
		PRINT "   *** No free memory for SIDHeader struct!"
		ok& = FALSE&
	END IF
END IF

' If all are ok... / Si todo ha ido bien...
' -----------------------------------------

IF ok& = TRUE& THEN

	long1& = AllocEmulResource&()

	IF long1& = NULL& THEN

		PRINT " . PlaySID resources allocated"

		long2& = ReadIcon&(SADD(file$),header&)

		IF long2& = NULL&

			PRINT " . Filled the SIDHeader struct with icon file information"

			long3& = CheckModule&(header&)

			IF long3& = NULL& THEN

				PRINT " . Checked what this file is a SID module"

				OPEN LEFT$(file$,LEN(file$)-1) FOR INPUT AS #1
					fich$=INPUT$(LOF(1),#1)
				CLOSE #1

				PRINT " . Loaded the SID module into the memory"

				SetModule header&,SADD(fich$),LEN(fich$)

				InfoSID(header&)

				long4&=StartSong&(0&)

				PRINT " . Playing the SID module 10''...";

				Delay 50*10

				PauseSong

				PRINT " Paused 4''..."

				Delay 50*4

				dummy& = ContinueSong&

				PRINT "   Continued during 5''...";

				Delay 50*5

				StopSong

				' Detención de la reproducción
				PRINT " Stopped."
				
			ELSE

				PRINT "  *** This isn't a SID module!"

			END IF

		ELSE

			PRINT "   *** ReadIcon() failed!: ";long2&

		END IF

	ELSE

		PRINT "   *** Resource allocation failed!: error code #";long1&

	END IF

END IF

' Releasing resources / Liberando recursos
' ----------------------------------------

IF header& <> NULL& THEN FreeMem header&, SIDHeader_sizeof%

IF psb& <> NULL& THEN FreeEmulResource&

LIBRARY VARPTR "dos.library", NULL&

LIBRARY VARPTR "playsid.library", NULL&

LIBRARY CLOSE "exec.library"

PRINT " . Resources released"

END
