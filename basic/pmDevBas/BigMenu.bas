' *********************************************************************
'      BigMenu © 1996-97 by Henrik Isaksson -- All Rights Reserved
'                           V. 1.6 (05.09.98)
'
'                C to HBASIC conversion 1.2+ (06.05.03)
'               by Dámaso D. Estévez {amidde,arrakis,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'         This example shows how to create (deeeeep ;) submenus
' Este ejemplo muestra cómo crear submenús (con muuucha profundidad ;)
'
'         See the Layout.bas code / Vea el código de Layout.bas
' *********************************************************************

REM $NOWINDOW

REM $include pm.bh
REM $include exec.bh
REM $include intuition.bh
REM $include utility.bc

pmb&  = NULL&    ' PopUpMenuBase
ib&   = NULL&    ' IntuitionBase
gb&   = NULL&    ' GfxBase
w&    = NULL&    ' Window
im&   = NULL&    ' IntuiMessage
p&    = NULL&    ' PopupMenu
prev& = NULL&    ' PopupMenu
r&    = TRUE&    ' Status flag (loop) / Bandera de estado (bucle)
ok&   = FALSE&   ' Status flag / Bandera de estado
i%    = 0%       ' Counter / Contador

'       Remember to increase the size array if you need
'        use more tags (tags&()) or menu items (pi&()).
'    Recuerde incrementar el tamaño de la matriz si necesita
' usar más etiquetas (tags&()) o crear más ítems de menú (pi&()).
' ---------------------------------------------------------------
DIM tags&(28)   ' Taglist / Lista de atributos
DIM pi&(13)     ' Items pointer array / Matriz de punteros de los ítems del menú

' =====================================================================
'                          The code / El código
' ====================================================================

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

	' PMInfo macros / Macros PMInfo
	' -----------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("Congratulations!!"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(0)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("You've shown a great"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(1)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("deal of patience"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(2)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("working your way"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(3)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("through all theese"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(4)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("menus!"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(5)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("You will now be"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(6)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("rewarded with a"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(7)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("menus option that"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(8)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("lets you stop"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(9)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("browsing through"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(10)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("the menus..."+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(11)=PM_MakeItemA&(VARPTR(tags&(0)))

	' PMBar macro / Macro PMBar
	' -------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_WideTitleBar&, TRUE&,_
		TAG_DONE&

	pi&(12) = PM_MakeItemA&(VARPTR(tags&(0)))

	' PMItem macro / Macro PMItem
	' ---------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("Quit"+CHR$(0)), _
		PM_UserData&, 5&, _
		TAG_DONE&

	pi&(13) = PM_MakeItemA&(VARPTR(tags&(0)))

	'  Creating the lastest submenu (size needed: 13*2+2)
	' Creando el último submenú (tamaño necesario: 13*2+2)
	' ----------------------------------------------------
	FOR i%=0 TO 13
		TAGLIST VARPTR(tags&(i%*2)), _
			PM_Item&,pi&(i%), _
			TAG_DONE&
	NEXT i%

	prev& = PM_MakeMenuA&(VARPTR(tags&(0)))

	'         Creating the submenus from #19 to #1 and linking.
	' Creando los submenús (del nº 19 al nº 1) y enlazado entre ellos.
	' ----------------------------------------------------------------

	FOR i% = 0 TO 19 STEP 1

		'     The RIGHT$ function deletes the initial extra space
		' (plus symbol not visible for numbers)... a Basic's question.
		'                         --------
		' La función RIGHT$ suprime el espacio inicial extra (símbolo
		'  positivo no visible para los números)... cosas del Basic.
		' ------------------------------------------------------------

		bfr$="Submenu #"+RIGHT$(STR$(20%-i%),LEN(STR$(20%-i%))-1)+CHR$(0)

		' First item in a submenu / Primer ítem del submenú
		' -------------------------------------------------

		TAGLIST VARPTR(tags&(0)),_
			PM_Title&,    SADD(bfr$),_
			PM_NoSelect&, TRUE&,_
			PM_ShinePen&, TRUE&,_
			TAG_DONE&

		pi&(0)=PM_MakeItemA&(VARPTR(tags&(0)))

		' Second item in the same submenu / Segundo ítem del submenú
		' ----------------------------------------------------------

		TAGLIST VARPTR(tags&(0)),_
			PM_Title&, SADD("Next Submenu"+CHR$(0)),_
			PM_Sub&, prev&,_
			TAG_DONE&

		pi&(1)=PM_MakeItemA&(VARPTR(tags&(0)))

		' Now, creating the submenu / Ahora creando el submenú
		' ----------------------------------------------------

		TAGLIST VARPTR(tags&(0)),_
			PM_Item&,pi&(0),_
			PM_Item&,pi&(1),_
			TAG_DONE&

		prev&=PM_MakeMenuA&(VARPTR(tags&(0)))

	NEXT i%

	' ------ Menu header (PMMenu macro) ----
	' --- Cabera del menú (macro PMMenu) ---
	' --------------------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Hidden&, TRUE&, _
		TAG_DONE&

	pi&(0) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("Big Menu"+CHR$(0)), _
		PM_NoSelect&, TRUE&, _
		PM_ShinePen&, TRUE&, _
		PM_Shadowed&, TRUE&, _
		PM_Center&,   TRUE&, _
		TAG_DONE&

	pi&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_WideTitleBar&, TRUE&,_
		TAG_DONE&

	pi&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	' PMInfo macros / Macros PMInfo
	' -----------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("Welcome to the neverending"+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(3)=PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("submenu example."+CHR$(0)),_
		PM_NoSelect&, TRUE&,_
		PM_ShinePen&, TRUE&,_
		TAG_DONE&

	pi&(4)=PM_MakeItemA&(VARPTR(tags&(0)))

	' PMBar macro / Macro PMBar
	' -------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_WideTitleBar&, TRUE&,_
		TAG_DONE&

	pi&(5) = PM_MakeItemA&(VARPTR(tags&(0)))

	' PMItem macro / Macro PMItem
	' ---------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&, SADD("Submenu"+CHR$(0)), _
		PM_Sub&,   prev&, _
		TAG_DONE&

	pi&(6) = PM_MakeItemA&(VARPTR(tags&(0)))

	' PMBar macro / Macro PMBar
	' -------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_WideTitleBar&, TRUE&,_
		TAG_DONE&

	pi&(7) = PM_MakeItemA&(VARPTR(tags&(0)))

	' PMItem macro / Macro PMItem
	' ---------------------------

	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,    SADD("Quit"+CHR$(0)), _
		PM_UserData&, 5&, _
		TAG_DONE&

	pi&(8) = PM_MakeItemA&(VARPTR(tags&(0)))

	'     Creating the popup menu (size needed: 8*2+2)
	' Creando el menú emergente (tamaño necesario: 13*2+2)
	' ----------------------------------------------------
	FOR i%=0 TO 8
		TAGLIST VARPTR(tags&(i%*2)), _
			PM_Item&,pi&(i%), _	        ' +2*i% array elements / elementos en la matriz
			TAG_DONE&                   ' +2    array elements / elementos en la matriz
	NEXT i%

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
			WA_Title&,       SADD("BigMenu"+CHR$(0)), _
			WA_CloseGadget&, TRUE&,_
			TAG_DONE&

		'    Opening the window: this window is only needed to find out
		'  when AND where the MENU should appear AND wich SCREEN it's on.
		'                           ----------
		' Abriendo la ventana: sólo es necesaria para saber dónde y cuándo
		'       el menú emergente debe aparecer y sobre qué pantalla.
		' ----------------------------------------------------------------
		w& = OpenWindowTagList&(NULL&, VARPTR(tags&(0)))

		IF w& <> NULL& THEN

			'  First, a C struct simulation (see the imsg var in original C code)
			'                         ----------
			'      Primero, reservo espacio para simular una estructura en C
			' (consulte la función de la variable imsg en el código original en C)
			' --------------------------------------------------------------------
			imsg$=STRING$(IntuiMessage_sizeof%,CHR$(0))

			WHILE r&

				'  Waiting a message
				' Esperando un mensaje
				' --------------------
				dummy& = WaitPort&(PEEKL(w&+UserPort%))

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

									'  The 9.03 documentation signals what the PM_Code& tag
									'      is obsoleted!...  this is the reason because
									'        I've changed this and I use PM_Dummy& ;-)
									'
									'    ¡La documentación de la versión 9.03 indica que
									'     la etiqueta PM_Code& ha quedado obsoleta!...
									'          por eso la he cambiado PM_Dummy& ;-)
									' -----------------------------------------------------
									TAGLIST VARPTR(tags&(0)), _
										PM_Menu&,  p&, _
										PM_Dummy&, (SADD(imsg$)+IntuiMessageCode%), _
										TAG_DONE&

									'  Opening finally my popupmenu menu
									' Abriendo finalmente mi menú emergente
									' -------------------------------------
									r& = PM_OpenPopupMenuA&(w&, VARPTR(tags&(0))) - 5&

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

IF gb&  <> NULL& THEN LIBRARY VARPTR "graphics.library",  NULL&
IF ib&  <> NULL& THEN LIBRARY VARPTR "intuition.library", NULL&

'    Reenabling Basic events :)
' Reactivando eventos del Basic :)
' --------------------------------
REM $event ON

'          Safe, even if the program fails to open the libraries
' Método seguro, incluso aunque el programa falle al abrir las bibliotecas
' ------------------------------------------------------------------------
LIBRARY CLOSE "popupmenu.library"
LIBRARY CLOSE "exec.library"

END
