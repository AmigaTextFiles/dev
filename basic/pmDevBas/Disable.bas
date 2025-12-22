' *********************************************************************
'      Disable © 1996-97 by Henrik Isaksson -- All Rights Reserved
'                           V. 2.0 (05.09.98)
'
'                C to HBASIC conversion 1.0a+ (06.05.03)
'               by Dámaso D. Estévez {amidde,arrakis,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'    Opens a popup menu with a checkmark menu item and a submenu...
'                 the first item controls the second.
'
'   Abre un menu emergente con un ítem tipo "marca de verificación"
'                  y un ítem que abre un submenú...
'    controlando el primero el estado/funcionamiento del segundo.
'
'         See the BigMenu.bas code / Vea el código de BigMenu.bas
' *********************************************************************

REM $NOWINDOW

REM $include pm.bh
REM $include exec.bh
REM $include intuition.bh
REM $include utility.bc

pmb&  = NULL&   ' PopUpMenuBase
ib&   = NULL&   ' IntuitionBase
gb&   = NULL&   ' GfxBase
w&    = NULL&   ' Window
im&   = NULL&   ' IntuiMessage
p&    = NULL&   ' PopupMenu
r&    = TRUE&   ' Status flag (loop) / Bandera de estado (bucle)
ok&   = FALSE&  ' Status flag / Bandera de estado
tmp&  = NULL&   ' Misc. var / Variable de varios usos

'       Remember to increase the size array if you need
'        use more tags (tags&()) or menu items (ii&()).
'    Recuerde incrementar el tamaño de la matriz si necesita
' usar más etiquetas (tags&()) o crear más ítems de menú (ii&()).
' ---------------------------------------------------------------
DIM tags&(16)   ' Taglist / Lista de atributos
DIM ii&(8)      ' Menu pointers array / Matriz de punteros del menú

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

ib& = PEEKL(pmb& + pmb_IntuitionBase%)
IF ib& <> NULL& THEN
	LIBRARY VARPTR "intuition.library", ib&
	gb& = PEEKL(pmb& + pmb_GfxBase%)
	IF gb& <> NULL& THEN
		LIBRARY VARPTR "graphics.library", gb&
		ok& = TRUE&
	END IF
END IF

IF ok& = TRUE& THEN

	' ------ Menu header (PMMenu macro) ----
	' --- Cabera del menú (macro PMMenu) ---
	' --------------------------------------

	'   First menu item (not visible)
	' Primer ítem del menú (no visible)
	' ---------------------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_Hidden&, TRUE&, _
		TAG_DONE&

	ii&(0) = PM_MakeItemA&(VARPTR(tags&(0)))

	'    Second menu item (title)
	' Segundo ítem del menú (título)
	' ------------------------------
	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("Plain Simple Menu!"+CHR$(0)), _
		PM_NoSelect&, TRUE&, _
		PM_ShinePen&, TRUE&, _
		PM_Shadowed&, TRUE&, _
		PM_Center&,   TRUE&, _
		TAG_DONE&

	ii&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	'     Third menu item (separator bar)
	' Tercer ítem del menú (barra separadora)
	' ---------------------------------------
	TAGLIST VARPTR(tags&(0)),_
		PM_WideTitleBar&, TRUE&,_
		TAG_DONE&

	ii&(2) = PM_MakeItemA&(VARPTR(tags&(0)))


	' ----- The other menu entries -----
	' ------- Restantes entradas -------
	' ----------------------------------

	'   Fourth menu item
	' Cuarto ítem del menú
	' --------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Enable quit?"+CHR$(0)),_
		PM_ID&,      10&,_
		PM_Checkit&, TRUE&,_
		TAG_DONE&

	ii&(3) = PM_MakeItemA&(VARPTR(tags&(0)))

	'    Fifth menu item (separator menu)
	' Quinto ítem del menú (barra separadora)
	' ---------------------------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_TitleBar&, TRUE&, _
		TAG_DONE&

	ii&(4) = PM_MakeItemA&(VARPTR(tags&(0)))

	'   Last menu item (but firstly, I create your subitem ;)
	' Último ítem del menú (pero primero, se crea su subítem ;)
	' ---------------------------------------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("Quit"+CHR$(0)), _
		PM_Disabled&, TRUE&, _
		PM_UserData&, 5&, _
		PM_ID&,       15&, _
		PMEnd&

	ii&(5) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("Quit"+CHR$(0)), _
		PM_Sub&,   ii&(5), _
		TAG_DONE&

	ii&(6) = PM_MakeItemA&(VARPTR(tags&(0)))

	'  Creating the popup menu
	' Creando el menú emergente
	' -------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Item&,ii&(0), _
		PM_Item&,ii&(1), _
		PM_Item&,ii&(2), _
		PM_Item&,ii&(3), _
		PM_Item&,ii&(4), _
		PM_Item&,ii&(6), _
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
			WA_Left&,        0, _
			WA_Top&,         0, _
			WA_Title&,       SADD("Disable & Enable"+CHR$(0)), _
			WA_CloseGadget&, TRUE&,_
			TAG_DONE&

		'  Opening the window: this is only needed for to obtain
		'      some info (font, screen, window position etc).
		'                          -----
		' Abriendo la ventana: ésta sólo es necesaria para obtener
		'    cierta información (tipografía a utilizar, pantalla
		'  sobre la que abrir el menú, posición de la ventana...).
		' ---------------------------------------------------------
		w& = OpenWindowTagList&(NULL&, VARPTR(tags&(0)))

		IF w& <> NULL& THEN

			'  First, a C struct simulation (see the imsg var in original C code)
			'                          ----------
			'      Primero, reservo espacio para simular una estructura en C
			' (consulte la función de la variable imsg en el código original en C)
			' --------------------------------------------------------------------
			imsg$=STRING$(IntuiMessage_sizeof%,CHR$(0))

			WHILE r&

				'  Waiting a message (you
				' can forget the tmp& value).
				'           ----
				' Esperando un mensaje (puede
				'  olvidar el valor de tmp&).
				' ---------------------------
				tmp& = WaitPort&(PEEKL(w&+UserPort%))

				DO

					'    Get the message
					' Se obtiene el mensaje
					' ---------------------
					im& = GetMsg&(PEEKL(w&+UserPort%))
					IF im& THEN

						'  ... but we will work with a copy
						' ... pero se trabajará con una copia
						' -----------------------------------
						CopyMem im&, SADD(imsg$), IntuiMessage_sizeof%
						ReplyMsg im&

						'        Reusing the tmp& var ;)
						' Reutilización de la variable tmp& ;)
						' ------------------------------------
						tmp& = PEEKL(SADD(imsg$)+Class%)

						SELECT CASE tmp&

								CASE = IDCMP_CLOSEWINDOW&
									r& = FALSE&
									EXIT DO

								CASE = IDCMP_MOUSEBUTTONS&


									' The 9.03 documentation signals what the PM_Code& tag is obsoleted!
									'     Deleted the entry PM_Code& (well, changed for PM_Dummy&).
									'                               -----------
									'         ¡La documentación de la versión 9.03 indica que
									'             la etiqueta PM_Code& ha quedado obsoleta!
									'    Suprimida la entrada PM_Code& (bueno, cambiada por PM_Dummy&)
									' ------------------------------------------------------------------
									TAGLIST VARPTR(tags&(0)), _
										PM_Menu&,  p&, _
										PM_Dummy&, (SADD(imsg$)+IntuiMessageCode%), _
										TAG_DONE&

									'  Opening finally my popupmenu menu
									' Abriendo finalmente mi menú emergente
									' -------------------------------------
									r& = PM_OpenPopupMenuA&(w&, VARPTR(tags&(0))) - 5&

									IF PM_ItemChecked(p&,10&) THEN

										' Enabling the Quit submenu
										' Activando el submenú Quit
										' -------------------------
										TAGLIST VARPTR(tags&(0)), _
											PM_Disabled&, FALSE&, _
											TAG_DONE&

										dummy& = PM_SetItemAttrsA&(PM_FindItem&(p&,15&), VARPTR(tags&(0)))

									ELSE


										'  Disabling the Quit submenu
										' Desactivando el submenú Quit
										' ----------------------------
										TAGLIST VARPTR(tags&(0)), _
											PM_Disabled&, TRUE&, _
											TAG_DONE&

										dummy& = PM_SetItemAttrsA&(PM_FindItem&(p&,15&), VARPTR(tags&(0)))

									END IF

									EXIT DO

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

'     Enabling Basic events :)
' Reactivando eventos del Basic :)
' --------------------------------
REM $event ON

IF gb&  <> NULL& THEN LIBRARY VARPTR "graphics.library",  NULL&
IF ib&  <> NULL& THEN LIBRARY VARPTR "intuition.library", NULL&

LIBRARY CLOSE

END
