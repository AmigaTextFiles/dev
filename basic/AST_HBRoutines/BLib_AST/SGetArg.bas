
' ---------------------------------------------------------------------------------------

REM ** $VER: SGetArg.bas 1.6 (01.09.2009) by AmiSpaTra

REM $NOBREAK

REM *************************************************************************

FUNCTION SGetArg$(BYVAL p%,BYVAL template$)
  LOCAL cad$, num%, quotes%, char%, cadtmp$, a%

	SGetArg$ = ""

	'              Anti bad coders check. Remember! p% must be >=1 !!
	'   Protección contra malos programadores. Recuerde ¡¡ p% ha de ser >=1 !!
	' ------------------------------------------------------------------------
	'IF p% <=0 THEN p%=1
	'       ó/or
	IF p% <=0 THEN ERROR 5

	cad$ = COMMAND$

	WHILE cad$ <> ""

		'           Removing not necesary spaces (start/end)
		'   Suprimir espacios innecesarios (inicio/final de la cadena)
		' --------------------------------------------------------------
		cad$=LTRIM$(RTRIM$(cad$))

		num%    = 1
		cadtmp$ = ""
		quotes% = 0

		FOR a%=1 TO LEN(cad$)

			char%=ASC(MID$(cad$,a%,1))

				SELECT CASE char%

					'        Modifying quotes status
					'   Modificando estado de las comillas
					' --------------------------------------
					CASE 34
					quotes% = NOT quotes%

					'    Spaces/ Espacios
					' ----------------------
					CASE 32
					IF quotes% = 0 THEN
						'     The space is an arguments separator
						'   El espacio es un separador de argumentos
						' -------------------------------------------
						IF num%=p% THEN
							'           Parse arg asked... end
							'   Procesado argumento pedido... terminar
							' ------------------------------------------
							EXIT FOR
						ELSE
							'   Parse the next character (and argument)
							'  Procesar siguiente carácter (y argumento)
							' -------------------------------------------
							num%=num%+1%
							EXIT SELECT
						END IF
					ELSE
						'           To preserve space for the argument asked (quoted)
						'    Preservar espacios del argumento pedido si están entre comillas
						' ---------------------------------------------------------------------
						IF num%=p% THEN cadtmp$=cadtmp$+CHR$(char%)
					END IF

					'     Preserve others characters (only for the argument asked)
					'   Preservar el resto de los caracteres para el argumento pedido
					' -----------------------------------------------------------------
					CASE ELSE
					IF num%=p% THEN cadtmp$=cadtmp$+CHR$(char%)

				END SELECT

		NEXT a%

		cad$ = cadtmp$

		'                 Template info
		'   Información sobre la sintaxis del comando
		' ---------------------------------------------

		IF cad$ = "?" THEN

			'   Activar trampa para evitar "Input Past End"
			' No es una solución elegante... pero funciona ;)
			'                  --------
			'        Trap to avoid the "Input Past End"
			'        Not very elegant but this works ;)
			' -----------------------------------------------
				BREAK STOP

			ActivarTrampa:
				ON ERROR GOTO Trampa
				PRINT template$;
				INPUT ": ",cad$
			DesactivarTrampa:
				ON ERROR GOTO 0

				BREAK ON

		ELSE


			'       Llamando al recolector de basura
			'            (rutina que hace uso
			'          intensivo de las cadenas).
			' ---------------------------------------------
			'        Calling the garbage collector
			'     (routine with intensive string use).
			' ---------------------------------------------
			dummy& = FRE("")

			'            Exit point if cad$<>""
			'   Punto de salida de la función si cad$<>""
			' ---------------------------------------------
			SGetArg$ = cad$
			EXIT WHILE

		END IF

	WEND

	'            Exit point if cad$=""
	'   Punto de salida de la función si cad$=""
	' --------------------------------------------
	EXIT FUNCTION


' ------------------------
' Mi "tramposa" trampa X-D
'    My tricky trap X-D
' ------------------------
Trampa:

	'   Error "Input Past End" (cuando el usuario combina RUN y el argumento ?)
	' "Input Past End error" (if the user uses RUN and ? argument simulteanously)
	' ---------------------------------------------------------------------------
	IF ERR = 62 THEN
		' Como si no hubiese argumento
		'   As the argument is null
		' ----------------------------
		cad$ = ""
		RESUME DesactivarTrampa
	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
