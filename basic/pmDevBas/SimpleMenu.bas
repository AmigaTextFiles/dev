' *********************************************************************
'     SimpleMenu © 1996-99 by Henrik Isaksson -- All Rights Reserved
'                           V. 3.0 (23.8.99)
'
'                C to HBASIC conversion 1.0+ (06.05.03)
'               by Dámaso D. Estévez {amidde,arrakis,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'             Opens a popup menu... only the Quit item works.
'
'    Abre un menú emergente... sólo el ítem Quit (Salir) funciona.
'
'       See the Disable.bas code / Vea el código de Disable.bas
' *********************************************************************

REM $NOWINDOW

REM $include pm.bh
REM $include exec.bh
REM $include intuition.bh
REM $include utility.bc

pmb&  = NULL&   ' PopUpMenuBase
ib&   = NULL&   ' IntuitionBase
w&    = NULL&   ' Window
im&   = NULL&   ' IntuiMessage
p&    = NULL&   ' PopupMenu
r&    = TRUE&   ' Status flag (loop) / Bandera de estado (bucle)
ok&   = FALSE&  ' Status flag / Bandera de estado

'       Remember to increase the size array if you need
'        use more tags (tags&()) or menu items (i&()).
'    Recuerde incrementar el tamaño de la matriz si necesita
' usar más etiquetas (tags&()) o crear más ítems de menú (i&()).
' ---------------------------------------------------------------
DIM tags&(20)   ' Taglist / Lista de atributos
DIM i&(6)       ' Items pointers array / Matriz de punteros de los ítems del menú

' =====================================================================
'                          The code / El código
' =====================================================================

'            "Opening" all libraries needed
' Abriendo y preparando todas las bibliotecas necesarias
' ------------------------------------------------------

LIBRARY OPEN "exec.library"
LIBRARY OPEN "popupmenu.library",POPUPMENU_VERSION&

pmb&=LIBRARY("popupmenu.library")

'     Disabling Basic events :)
' Desactivando eventos del Basic :)
' ---------------------------------
REM $event OFF

'     You don't need checking what pmb& <> NULL&...
' with LIBRARY OPEN the program will fails without risk
'            if it can't open the library ;)
'                        ------
'    No necesita comprobar que pmb& no sea nulo...
'   con el comando LIBRARY OPEN el programa fallará
'    sin riesgos si no puede abrir la biblioteca ;)
' ------------------------------------------------------
ib& = PEEKL(pmb& + pmb_IntuitionBase%)
IF ib& <> NULL& THEN
	LIBRARY VARPTR "intuition.library", ib&
	ok& = TRUE&
END IF

IF ok& = TRUE& THEN

	' ----- Menu header (PMMenu macro) ----
	' -- Cabecera del menú (macro PMMenu)--
	' -------------------------------------

	'   First menu item (not visible)
	' Primer ítem del menú (no visible)
	' ---------------------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_Hidden&, TRUE&, _
		TAG_DONE&

	i&(0) = PM_MakeItemA&(VARPTR(tags&(0)))

	'    Second menu item (title)
	' Segundo ítem del menú (título)
	' ------------------------------
	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,SADD("SimpleMenu"+CHR$(0)), _
		PM_NoSelect&, TRUE&, _
		PM_ShinePen&, TRUE&, _
		PM_Shadowed&, TRUE&, _
		PM_Center&,   TRUE&, _
		TAG_DONE&

	i&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	'     Third menu item (separator bar)
	' Tercer ítem del menú (barra separadora)
	' ---------------------------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_WideTitleBar&, TRUE&, _
		TAG_DONE&

	i&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	' ----- The other menu entries -----
	' ------- Restantes entradas -------
	' ----------------------------------

	'   Fourth menu item
	' Cuarto ítem del menú
	' --------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("Item1"+CHR$(0)), _
		TAG_DONE&

	i&(3) = PM_MakeItemA&(VARPTR(tags&(0)))

	'    Fifth menu item
	' Quinto ítem del menú
	' --------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("Item2"+CHR$(0)), _
		TAG_DONE&

	i&(4) = PM_MakeItemA&(VARPTR(tags&(0)))

	'    Sixth menu item (separator bar)
	' Sexto ítem del menú (barra separadora)
	' --------------------------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_TitleBar&, TRUE&, _
		TAG_DONE&

	i&(5) = PM_MakeItemA&(VARPTR(tags&(0)))

	'  Seventh menu item
	' Séptimo ítem del menú
	' ---------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("Quit"+CHR$(0)), _
		PM_UserData&, 5&, _
		TAG_DONE&

	i&(6) = PM_MakeItemA&(VARPTR(tags&(0)))

	'  Creating the popup menu
	' Creando el menú emergente
	' -------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Item&,i&(0), _
		PM_Item&,i&(1), _
		PM_Item&,i&(2), _
		PM_Item&,i&(3), _
		PM_Item&,i&(4), _
		PM_Item&,i&(5), _
		PM_Item&,i&(6), _
		TAG_DONE&

	p& = PM_MakeMenuA&(VARPTR(tags&(0)))

	IF p& <> NULL& THEN

		'   Window properties
		' Atributos de la ventana
		' -----------------------
		TAGLIST VARPTR(tags&(0)),_
			WA_IDCMP&,       IDCMP_CLOSEWINDOW& OR IDCMP_MOUSEBUTTONS&, _
			WA_RMBTrap&,     TRUE&, _
			WA_DragBar&,     TRUE&, _
			WA_Width&,       150, _
			WA_Height&,      100, _
			WA_Left&,        150, _
			WA_Top&,         0, _
			WA_Title&,       SADD("SimpleMenu"+CHR$(0)), _
			WA_CloseGadget&, TRUE&,_
			TAG_DONE&

		'  Opening the window: this is only needed for to obtain
		'      some info (font, screen, window position etc).
		' Abriendo la ventana: ésta sólo es necesaria para obtener
		'    cierta información (tipografía a utilizar, pantalla
		'  sobre la que abrir el menú, posición de la ventana...).
		' ---------------------------------------------------------
		w& = OpenWindowTagList&(NULL&, VARPTR(tags&(0)))

		IF w& <> NULL& THEN

			'    A C struct simulation (see the imsg var in the original C code).
			'                             -----------
			'    Reservo espacio para simular una estructura en C que voy a usar
			' (consulte la función de la variable imsg en el código original en C).
			' ---------------------------------------------------------------------
			imsg$=STRING$(IntuiMessage_sizeof%,CHR$(0))

			WHILE r&

				'  Waiting a message
				' Esperando un mensaje
				' --------------------
				tmp& = WaitPort&(PEEKL(w&+UserPort%))

				DO

					'    Get the message
					' Se obtiene el mensaje
					' ---------------------
					im& = GetMsg&(PEEKL(w&+UserPort%))
					IF im& THEN

						'   ... but we will work with a copy
						' ... pero se trabajará con una copia
						' -----------------------------------
						CopyMem im&, SADD(imsg$), IntuiMessage_sizeof%
						ReplyMsg im&

						tmp& = PEEKL(SADD(imsg$)+Class%)

						SELECT CASE tmp&

								CASE = IDCMP_CLOSEWINDOW&
									r& = FALSE&
									EXIT DO

								CASE = IDCMP_MOUSEBUTTONS&

									TAGLIST VARPTR(tags&(0)), _
										PM_Menu&, p&, _
										TAG_DONE&

									'  Opening finally my popupmenu menu
									' Abriendo finalmente mi menú emergente
									' -------------------------------------
									r& = PM_OpenPopupMenuA&(w&, VARPTR(tags&(0)))


									IF r& = 5& THEN
										r& = FALSE&
									ELSE
										r& = TRUE&
									END IF

									EXIT DO

									'  If the user selects Quit, the function returns
									'       the UserData value defined (5&)...
									'    in other case, this returns 0& (=FALSE&).
									'  Mr Isaksson signals about other way of handling
									'      the input via the PM_MenuHandler tag.
									'                    ------
									'      Si el usuario elige la opción "Quit",
									' la función devolverá el valor UserData definido
									'   (5&)... en otro caso, devuelve 0& (=FALSE&).
									'   El Sr. Isaksson menciona como otra forma de
									'    manejar las entradas del usuario a través
									'          de la etiqueta PM_MenuHandler.

						END SELECT

					ELSE

						EXIT LOOP

					END IF

				LOOP

			WEND

			CloseWindow& w&

		ELSE

			PRINT "Window error!"

		END IF

		PM_FreePopupMenu& p&

	ELSE

		PRINT "Menu error!"

	END IF

ELSE

	PRINT "One or more libraries have failed!"

END IF

IF ib&  <> NULL& THEN LIBRARY VARPTR "intuition.library", NULL&

'    Reenabling Basic events :)
' Reactivando eventos del Basic :)
' --------------------------------
REM $event ON

LIBRARY CLOSE "popupmenu.library"
LIBRARY CLOSE "exec.library"

END
