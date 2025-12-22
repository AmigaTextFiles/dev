' *SOF*

' *********************************************************************
'                            SCRNTF_Test.bas
'            by/de Copyright 2015 Dámaso "AmiSpaTra" Estévez
'                          {miast, esteson, eu}
'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************
'              Based over the example "screennotifytest.c"
'               included in the ScreeNotify Lib package.

'              All rights reserved over MY derivative work:
'              This Hisoft/Maxon Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'      in this package: If you create a derivative work from mine,
'                  you MUST to include ALL legal notes.

'                        Screennotify lib test:
'            The program opens a window on Workbench screen.
'                  If the Workbench screen is closed,
'              the window is automa(t|g)ically closed...
'                 if the Workbench screen is reopened,
'                the program will reopen their window.
'                                 ----
'               Basado en el ejemplo "screennotifytest.c"
'        incluido en el paquete de la biblioteca ScreenNotify.

'       Todos los derechos reservados sobre MI trabajo derivado:
'                   Este paquete para desarrolladores
'                 que programen con Hisoft/Maxon Basic.
'          Está prohibido eliminar cualquier comentario o nota
'     de autoría/legal de este paquete: Si crea un trabajo derivado
'    del mío HA DE INCLUIR OBLIGATORIAMENTE TODAS LAS NOTAS LEGALES.

'                 Prueba de la biblioteca ScreenNotify:
'     El programa abre una ventana sobre la pantalla del Worbench.
'                Si la pantalla del Workbench se cierra,
'             la ventana automá(t|g)icamente se cerrará...
'               y si se reabre la pantalla del Workbench,
'                   el programa reabrirá su ventana.
' *********************************************************************

OPTION BASE 1

' ---------------------------------------------------------------------
'        Compiler's metacommands (see the Hisoft Basic Manual)
' Metacomandos para el compilador (consulte el manual del Hisoft Basic)
' ---------------------------------------------------------------------
REM $NOWINDOW
REM $NOLIBRARY
REM $NOBREAK

' ---------------------------------------------------------------------
'                    Include files / Ficheros de inclusión
' ---------------------------------------------------------------------

'   OS / SO
' ------------
REM $include exec.bh
REM $include dos.bh
REM $include intuition.bh

' ScreenNotify
' ------------
REM $include screennotify.bh

' ---------------------------------------------------------------------
'              C= string version / Cadena de versión de C=
' ---------------------------------------------------------------------

vstring$ = "$VER: SCRNTF_Test 1.0 (28.10.2015) by Dámaso 'AmiSpaTra' Domínguez based over 'screennotifytest.c' code by Stephan Becker "+CHR$(0)

' ---------------------------------------------------------------------
'           Some vars (pointers) / Algunas variables (punteros)
' ---------------------------------------------------------------------

port&   = NULL& ' Struct pointer/Puntero a estructura: MsgPort
handle& = NULL&
snm&    = NULL& ' Struct pointer/Puntero a estructura: ScreenNotifyMessage
win&    = NULL& ' Struct pointer/Puntero a estructura: Window

' ---------------------------------------------------------------------
'              Window's attribs / Atributos de la ventana
' ---------------------------------------------------------------------

DIM t&(13)      ' For taglist / Para la lista de etiquetas

TAGLIST VARPTR(t&(1)), _
	WA_Width&,         200&, _
	WA_Height&,        100&, _
	WA_Flags&,         (WFLG_CLOSEGADGET& OR WFLG_DRAGBAR&), _
	WA_IDCMP&,         IDCMP_CLOSEWINDOW&, _
	WA_PubScreenName&, SADD("Workbench"+CHR$(0)), _
	WA_Title&,         SADD("ScreenNotify: Test/Prueba"+CHR$(0)), _
	TAG_DONE&

' ---------------------------------------------------------------------
'               Opening libraries / Abriendo bibliotecas
' ---------------------------------------------------------------------
LIBRARY OPEN "exec.library",         36&
LIBRARY OPEN "dos.library",          36&
LIBRARY OPEN "intuition.library",    36&
LIBRARY OPEN "screennotify.library", SCREENNOTIFY_VERSION&

' =====================================================================
'                      Main code / Código principal
' =====================================================================

' Creating a message port / Creando un puerto de mensajes
' -------------------------------------------------------
port& = CreateMsgPort&

IF port& THEN

	' Adding a Workbench client / Añadiendo un cliente al Workbench
	' -------------------------------------------------------------
	handle& = AddWorkbenchClient&(port&, 0&)

	IF handle& THEN

		' Opening the window / Abriendo la ventana
		' ----------------------------------------
		win& = OpenWindowTagList&(NULL&, VARPTR(t&(1)))

		IF win& THEN

			active&   = TRUE&

			pmask&  = 1& << PEEKB(port&+mp_SigBit%)
			wmask&  = 1& << PEEKB(PEEKL(win&+UserPort%)+mp_SigBit%)

			WHILE active&

				sigs& = xWait&(pmask& OR wmask&)

				IF (sigs& AND pmask&) THEN

					DO

						snm& = GetMsg&(port&)

						IF snm& THEN

							IF PEEKL(snm&+snm_Type%) = SCREENNOTIFY_TYPE_WORKBENCH& THEN

								v& = PEEKL(snm&+snm_Value%)

								SELECT CASE v&

									' To close the WB screen, will close our window
									' Cerrar la pantalla del WB, cerrará nuestra ventana
									' --------------------------------------------------
									 CASE FALSE&
										IF win& THEN
											CloseWindow win&
											win&   = NULL&
											wmask& = NULL&
										END IF

									' To open the WB screen, will reopen our window
									' Abrir la pantalla del WB, reabrirá nuestra ventana
									' --------------------------------------------------
									CASE TRUE&
										IF NOT win& THEN
											win& = OpenWindowTagList&(NULL&, VARPTR(t&(1)))
											IF win& THEN wmask&  = 1& << PEEKB(PEEKL(win&+UserPort%)+mp_SigBit%)
										END IF

								END SELECT

							END IF

							ReplyMsg snm&

						ELSE

							EXIT LOOP

						END IF

					LOOP

				END IF

				' If the user press the close gadget... / Si el usuario presiona el botón de cierre...
				' ------------------------------------------------------------------------------------
				IF (sigs& AND wmask&) THEN

					DO

						msg& = GetMsg&(PEEKL(win&+UserPort%))

						IF msg& THEN

							IF PEEKL(msg&+Class%) = IDCMP_CLOSEWINDOW& THEN
								active& = FALSE&
							END IF

							ReplyMsg msg&

						ELSE

							EXIT LOOP

						END IF

					LOOP

				END IF

			WEND

		END IF

	END IF

END IF

' Closing the window / Cerrando la ventana
' ----------------------------------------

IF win& THEN
	CloseWindow win&
	win& = NULL&
END IF

' Removing the WB client / Borrando el cliente del WB
' ---------------------------------------------------
IF handle& THEN

	DO
		IF RemWorkbenchClient&(handle&) THEN
			handle& = NULL&
			EXIT DO
		ELSE
			Delay 10&
		END IF
	LOOP

END IF

' Deleting the message port / Borrando el puerto de mensajes
' ----------------------------------------------------------
IF port& THEN
	DeleteMsgPort port&
	port& = NULL&
END IF

END

' *EOF*
