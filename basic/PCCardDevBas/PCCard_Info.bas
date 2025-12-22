' *********************************************************************
'                 PCCard_Info - All rights reserved
'        by Dámaso D. Estévez {correoamidde-aminet000,yahoo,es}
'         AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
'
'               WARNING! Hisoft Basic 2 named incorrectly
'        the "Card" resource as "CardRes" (some conflict? r8-?).
'    Delete the "cardres.bh" and "cardres.bc" files from "BH/" drawer
'    and the "cardres.bmap" from the "BMAP/" drawer and replace them
'           with my versions (updated for AmigaOS 4.x, even
'          when the "Card" resource seems don't exists X-D).
'
'          ¡ATENCIÓN! Hisoft Basic 2 nombra incorrectamente
'      el recurso "Card" como "CardRes" (¿algún conflicto? r8-?).
'          Borre los ficheros "cardres.bh" y "cardres.bc" del
'        directorio "BH/" y "card.bmap" del directorio "BMAP/"
'         y sustitúyalos por mis versiones (actualizados para
'        AmigaOS 4.x, aunque no incluya el recurso "Card" X-D).
' *********************************************************************

'                  String version / Cadena de versión
' ---------------------------------------------------------------------
ver$ = "$VER: PCCard_Info 1.0 (26.06.2011) by Dámaso Domínguez -AmiSpaTra- "

'      Compiler's metacommands / Metacomandos para el compilador
' --------------------------------------------------------------------
REM $NOWINDOW
REM $NOBREAK

'               Include files / Ficheros de inclusión
' -------------------------------------------------------------------
REM $include exec.bh
REM $include dos.bh
REM $include utility.bh
REM $include card.bh
REM $include pccard.bh

' =====================================================================
'                     Main code... as subroutine
'                Código principal... como subrutina :)
' =====================================================================

SUB Main
	SHARED ver$, r&
	LOCAL  h&, s&,  s1&, t&,  t1&, tuple1$, tuple2$, tuple3$

	' ver$    - String version
	'           Cadena de versión
	' r&      - AmigaDOS return code
	'           Código de retorno del AmigaDOS
	' h&      - Pointer to block's memory (CardHandle struct)
	'           Puntero a bloque de memoria (estructura CardHandle)
	' s&      - OwnCard's return code
	'           Código de retorno de la función OwnCard
	' s1&     - Multiple uses
	'           Usos múltiples
	' t&      - Pointer to taglist
	'           Puntero a lista de etiquetas
	' t1&     -	Attrib/property searched
	'			   Atributo-propiedad buscada
	' tupleX$ - String for to allocate a tuple (fast, but dangerous)
	'           Cadena para alojar un tuplo (rápido, pero peligroso)
	' ----------------------------------------------------------------

	' Bold ON / Negrilla activada
	' ---------------------------
	PRINT CHR$(27);"[1m";

	PRINT MID$(ver$,7,(LEN(ver$)-7));

	' Bold OFF / Negrilla desactivada
	' -------------------------------
	PRINT CHR$(27);"[0m"

	' Simulating a struct CardHandle / Simulación de una estructura CardHandle
	' ------------------------------------------------------------------------
	h& = AllocMem&(CardHandle_sizeof%, MEMF_ANY& OR MEMF_CLEAR&)

	IF h& THEN

		'      I must to init theses fields? No, because I used MEMF_CLEAR attrib ;)
		' ¿Campos a inicializar obligatorios? No, porque he usado el atributo MEMF_CLEAR ;)
		' ---------------------------------------------------------------------------------
		POKEB h&+cah_CardNode%+ln_Pri%,  0%
		POKEB h&+cah_CardNode%+ln_Type%, 0%
		POKEL h&+cah_CardNode%+ln_Name%, NULL&
		POKEL h&+cah_CardRemoved%,       NULL&
		POKEL h&+cah_CardStatus%,        NULL&

		'      The PCCard slot need a card inserted when you run the program
		'         Don't touch it when the program is running... or RESET!
		'                                  ---
		'        El  conector PCCard ha de tener ya una tarjeta enchufada
		' ¡No la toque mientras ejecute el programa... o se reiniciará el sistema!
		' ------------------------------------------------------------------------
		POKEB h&+cah_CardFlags%,         CARDB_IFAVAILABLE&  OR CARDB_RESETREMOVE&

		'  Warning! The Autodoc don't show this value as option!
		'        (however, the program seems works!)
		'                       ---
		'    ¡Atención! ¡La autodocumentación no refleja que
		'               se pueda inicializar así!
		' (pero no parece dar problemas: el programa funciona O:)
		' -------------------------------------------------------
		POKEL h&+cah_CardInserted%,      NULL&

		' Owning the card :D / Apropiándome de la tarjeta :D
		' --------------------------------------------------
		s& = OwnCard&(h&)

		IF s& = 0& THEN

			s1& = BeginCardAccess&(h&)

			IF s1& THEN

				' Obtaining the tuple for parsing / Obteniendo el tuplo a procesar
				' ----------------------------------------------------------------

				'                          Buffer for tuple
				' Memoria tampón para el tuplo (término no reconocido por la DRAE ;D)
				' -------------------------------------------------------------------
				tuple1$=STRING$(PCCARD_MAXTUPLESIZE&+8&, CHR$(0))

				' I reuse s1& / Reutilizo s1&
				' ---------------------------
				s1& = CopyTuple(h&, SADD(tuple1$), PCCARD_TPL_MANFID&, &HFF)

				IF s1& THEN

					'   Ask the first tuple: manufacturer
					'   Pido el primer tuplo: fabricante
					' --------------------------------------
					t& = PCCard_GetTupleInfo&(SADD(tuple1$))

					'      If all are ok, I search the attribs for to show the info
					' Si todo es correcto, busco los atributos para mostrar la información
					' --------------------------------------------------------------------
					IF t& THEN

						t1& = FindTagItem&(PCCARD_Maker&,t&)

						PRINT "Manufacturer ID / Id. del fabricante : ";

						IF t1& THEN

							'    Showing the ID as a formatted hexadecimal value
							' Mostrando el identificador como un valor hexa con formato
							' ---------------------------------------------------------
							PRINT "0x";
							PRINT RIGHT$("00000000"+HEX$(PEEKL(t1&+4&)),8)

						ELSE

							PRINT "Not specified / No especificado"

						END IF

						t1& = FindTagItem&(PCCARD_Product&,t&)

						PRINT "Product code    / Código del producto: ";

						IF t1& THEN

							PRINT "0x";
							PRINT RIGHT$("00000000"+HEX$(PEEKL(t1&+4&)),8)

						ELSE

							PRINT "Not specified / No especificado"

						END IF

						PCCard_FreeTupleInfo t&

					END IF

					tuple1$ = ""

				END IF

				' --------------------------------------------------------------

				'       Buffer for tuple
				' Memoria tampón para el tuplo
				' ----------------------------
				tuple2$=STRING$(PCCARD_MAXTUPLESIZE&+8&,CHR$(0))

				s1& = CopyTuple(h&, SADD(tuple2$), PCCARD_TPL_FUNCID&, &HFF)

				IF s1& THEN

					' Card function / Función de la tarjeta
					' -------------------------------------
					t& = PCCard_GetTupleInfo&(SADD(tuple2$))

					IF t& THEN

						t1& = FindTagItem&(PCCARD_Type&,t&)

						PRINT "Card's type     / Tipo de tarjeta    : ";

						IF t1& THEN

							' Reusing s1& / Reutilizando s1&
							' ------------------------------
							s1& = PEEKL(t1&+4&)

							'   Info obtained from: / Información obtenida de:
							' from http://www.ul.ie/~rinne/et4508/ET4508_L13.pdf
							' ---------------------------------------------------
							SELECT CASE s1&

								CASE 0
									PRINT "Multifunction / Multifunción"

								CASE 1
									PRINT "Memory / Memoria"

								CASE 2
									PRINT "Serial port / Puerto serial"

								CASE 3
									PRINT "Parallel port / Puerto paralelo"

								CASE 4
									PRINT "Fixed disk / Disco fijo"

								CASE 5
									PRINT "Video adapter / Adaptador de video"

								CASE 6
									PRINT "Network adapter / Adaptador de red"

								CASE 7
									PRINT "AIMS"

								CASE 8
									PRINT "SCSI / Interfaz SCSI"

								CASE 9
									PRINT "Security / Seguridad"

								CASE &HA TO &HFD
									PRINT "ID reserved / Identificador reservado"

								CASE &HFE
									PRINT "Vendor specific / Específico del fabricante"

								CASE &HFF
									PRINT "DO NOT USE! (the ID?) / ¡NO LO UTILICE! (¿el identificador?)"

							END SELECT

						ELSE

							PRINT "Not specified / No especificada"

						END IF

						PCCard_FreeTupleInfo t&

					END IF

					tuple2$ = ""

				END IF

				' --------------------------------------------------------------

				tuple3$=STRING$(PCCARD_MAXTUPLESIZE&+8&,CHR$(0))

				s1& = CopyTuple(h&, SADD(tuple3$), PCCARD_TPL_VERS1&, &HFF)

				IF s1& THEN

					' Version / Versión
					' -----------------
					t& = PCCard_GetTupleInfo&(SADD(tuple3$))

					IF t& THEN

						t1& = FindTagItem&(PCCARD_MajorVersion&,t&)

						PRINT "Version         / Versión            : ";

						IF t1& THEN

							PRINT LTRIM$(RTRIM$(STR$(PEEKL(t1&+4&))));

							t1& = FindTagItem&(PCCARD_MinorVersion&,t&)

							IF t1& THEN

								PRINT ".";LTRIM$(RTRIM$(STR$(PEEKL(t1&+4&))))

							ELSE

								PRINT

							END IF

						ELSE

							PRINT "Not specified / No especificada"

						END IF

						PCCard_FreeTupleInfo t&

					END IF

					tuple3$ = ""

				END IF


				' I reuse s1& / Reutilizo s1&
				' ---------------------------
				s1& = EndCardAccess(h&)

			ELSE

				r& = RETURN_FAIL&
				PRINT "The access to card was failed! / ¡El acceso a la tarjeta ha fallado!"

			END IF

			'  Warning! Use the CARDF version for flag, not CARDB version!
			'¡Atención! ¡Utilice la versión CARF, no la CARDB del atributo!
			' -------------------------------------------------------------
			ReleaseCard h&, CARDF_REMOVEHANDLE&

		ELSE

			r& = RETURN_FAIL&
			PRINT "No card in the PCCard slot or the card is in use!"
			PRINT "¡No hay tarjeta en el conector PCCard o está en uso!"

		END IF

		FreeMem h&, CardHandle_sizeof%

	ELSE

		r& = RETURN_FAIL&
		PRINT "No free memory! / ¡Memoria libre insuficiente!"

	END IF

	IF r& THEN

		' Fatal error / Error fatal
		' -------------------------
		BEEP

	END IF

END SUB

' =====================================================================
'                      Main code / Código principal
' =====================================================================

LIBRARY OPEN "exec.library"
LIBRARY OPEN "dos.library"
LIBRARY OPEN "utility.library"

'      DOS return value: original hypothesis, all OK
' Valor del retorno del DOS: hipótesis original, todo correcto
'--------------------------------------------------------------
r&          = RETURN_OK&

'     Library base
' Base de la biblioteca
' ---------------------
PCCardBase& = NULL&

'   Lib/Resource to open (name and minimum version)
' Biblioteca/recurso a abrir (nombre y versión mínima)
' ----------------------------------------------------
ln$ = "pccard.library"
lv& = 1&
cn$ = "card.resource"

' Opening the library / Abriendo la biblioteca
' --------------------------------------------
PCCardBase& = OpenLibrary&(SADD(ln$+CHR$(0)), lv&)

IF PCCardBase& THEN

	'  I inform to Hisoft Basic what the library is open
	' Informo a Hisoft Basic que la biblioteca está abierta
	' -----------------------------------------------------
	LIBRARY VARPTR "pccard.library", PCCardBase&

	CardResBase& = OpenResource&(SADD(cn$+CHR$(0)))

	IF CardResBase& THEN

		' I inform to Hisoft Basic what the resource is open
		' Informo a Hisoft Basic que el recurso está abierto
		' ---------------------------------------------------
		LIBRARY VARPTR "card.resource", CardResBase&

		' Main program / Programa principal
		' ---------------------------------
		Main

		' I inform to Hisoft Basic what the resource was closed
		'  Informo a Hisoft Basic que el recurso está cerrado
		' -----------------------------------------------------
		LIBRARY VARPTR "card.resource", NULL&

		' The CloseResource don't exits! / ¡No existe la función/subrutina CloseResourse!
		' -------------------------------------------------------------------------------
		
		CardResBase& = NULL&

	ELSE

		'   Fatal error: the PCCard Lib's example, CAN'T OPEN the PCCard library X-D
		' Error fatal: el ejemplo de uso de la biblioteca PCCard, no puede abrirla X-D
		' ----------------------------------------------------------------------------
		r& = RETURN_FAIL&
		PRINT "I can't open the '";cn$;"'!"
		PRINT "¡Imposible abrir el recurso '";cn$;"'!"
		BEEP

	END IF

	'  I inform to Hisoft Basic what the library was closed
	' Informo a Hisoft Basic que la biblioteca está cerrada
	' -----------------------------------------------------
	LIBRARY VARPTR "pccard.library", NULL&
	PCCardBase& = NULL&

ELSE

	'   Fatal error: the PCCard Lib's example, CAN'T OPEN the PCCard library X-D
	' Error fatal: el ejemplo de uso de la biblioteca PCCard, no puede abrirla X-D
	' ----------------------------------------------------------------------------
	r& = RETURN_FAIL&
	PRINT "I can't open the '";ln$;"' v";lv&;"!"
	PRINT "¡ Imposible abrir la biblioteca '";ln$;"' versión";lv&;"!"
	BEEP

END IF

LIBRARY CLOSE

STOP r&

END
