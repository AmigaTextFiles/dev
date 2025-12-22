' *********************************************************************
'             Layout © Henrik Isaksson -- All Rights Reserved
'                           V. 1.1 (23.08.00)
'
'                C to HBASIC conversion 1.0a+ (06.05.03)
'               by Dámaso D. Estévez {amidde,arrakis,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'     This example shows how to create groups like the C version...
'        except what with this version };) the Quit item works.
'
'           Este ejemplo muestra cómo crear grupos igual que
'                  en la versión en C... salvo que con
'           esta versión };) el ítem Quit (Salir) funciona.
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
r&    = TRUE&    ' Status flag (loop) / Bandera de estado (bucle)
ok&   = FALSE&   ' Status flag / Bandera de estado

DIM wtags&(20)   ' Window Taglist / Lista de atributos para la ventana

' My function / Mi función
' ------------------------
DECLARE FUNCTION MakeTestMenu&()

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

	' Preparing my menu / Preparando mi menú
	' --------------------------------------
	p& = MakeTestMenu&()

	IF p& <> NULL& THEN

		'   Window properties
		' Atributos de la ventana
		' -----------------------
		TAGLIST VARPTR(wtags&(0)),_
			WA_IDCMP&,       IDCMP_CLOSEWINDOW& OR IDCMP_MOUSEBUTTONS& OR IDCMP_VANILLAKEY, _
			WA_RMBTrap&,     TRUE&, _
			WA_DragBar&,     TRUE&, _
			WA_Width&,       150, _
			WA_Height&,      100, _
			WA_Left&,        0, _
			WA_Top&,         100, _
			WA_Title&,       SADD("Layout"+CHR$(0)), _
			WA_CloseGadget&, TRUE&,_
			TAG_DONE&

		'    Opening the window: this window is only needed to find out
		'  when AND where the MENU should appear AND wich SCREEN it's on.
		' Abriendo la ventana: sólo es necesaria para saber dónde y cuándo
		'       el menú emergente debe aparecer y sobre qué pantalla.
		' ----------------------------------------------------------------
		w& = OpenWindowTagList&(NULL&, VARPTR(wtags&(0)))

		IF w& <> NULL& THEN

			'  First, a C struct simulation (see the imsg var in original C code)
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

								CASE = IDCMP_MOUSEBUTTONS&

									TAGLIST VARPTR(tags&(0)), _
										PM_Menu&,  p&, _
										TAG_DONE&

									'  Opening finally my popupmenu menu
									' Abriendo finalmente mi menú emergente
									' -------------------------------------
									r& = PM_OpenPopupMenuA&(w&, VARPTR(tags&(0))) - 2&

									EXIT DO

								CASE = IDCMP_CLOSEWINDOW&
									r& = FALSE&
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

' =====================================================================

FUNCTION MakeTestMenu&()
LOCAL i&,j&,pi1&,pi2&,mpi&,tags&

' Taglist / Lista de atributos
' ----------------------------
DIM tags&(28)

' Items or menu pointer arrays / Matrices de punteros a ítems o menús
' -------------------------------------------------------------------
DIM mpi&(7)     ' Main
DIM pi1&(10)    ' Aux. first  level
DIM pi2&(9)     ' Aux. second level

	' ====================================
	'     Menu header (PMMenu macro)
	'   Cabecera del menú (macro PMMenu)
	' =====================================

	'   First menu item (not visible)
	' Primer ítem del menú (no visible)
	' ---------------------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_Hidden&, TRUE&, _
		TAG_DONE&

	mpi&(0) = PM_MakeItemA&(VARPTR(tags&(0)))

	'    Second menu item (title)
	' Segundo ítem del menú (título)
	' ------------------------------
	TAGLIST VARPTR(tags&(0)),_
		PM_Title&,SADD("Group Layout"+CHR$(0)), _
		PM_NoSelect&, TRUE&, _
		PM_ShinePen&, TRUE&, _
		PM_Shadowed&, TRUE&, _
		PM_Center&,   TRUE&, _
		TAG_DONE&

	mpi&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	'     Third menu item (separator bar)
	' Tercer ítem del menú (barra separadora)
	' ---------------------------------------
	TAGLIST VARPTR(tags&(0)), _
		PM_WideTitleBar&, TRUE&, _
		TAG_DONE&

	mpi&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	' ===================================================================
	' The first horizontal group with three elements (one is other group)
	' El primer grupo horizontal con tres elementos (one is other group)
	' ===================================================================

	' -------------------------------
	' First element / Primer elemento
	'--------------------------------

	TAGLIST VARPTR (tags&(0)),_
		PM_Title&,  SADD("Left"+CHR$(0)),_
		PM_Center&, TRUE&,_
		TAG_DONE&

	pi1&(1)= PM_MakeItemA&(VARPTR(tags&(0)))

	' ------------------------------------
	'  Second element (a vertical group)
	' Segundo elemento (un grupo vertical)
	' ------------------------------------

	FOR i&=1 TO 6

		' Creating the six menu entries / Creando seis entradas de menú
		' -------------------------------------------------------------

		TAGLIST VARPTR (tags&(0)),_
			PM_Title&,  SADD("Item"+RIGHT$(STR$(i&),LEN(STR$(i&))-1)++CHR$(0)),_
			PM_Center&, TRUE&,_
			TAG_DONE&

		pi2&(i&)= PM_MakeItemA&(VARPTR(tags&(0)))

	NEXT i&

	' Now, vertical grouping... / Ahora, agrupación vertical...
	' ---------------------------------------------------------
	TAGLIST VARPTR(tags&(0)),_
		PM_Dummy&, 0&,_
		PM_Item&,  pi2&(1), _
		PM_Item&,  pi2&(2), _
		PM_Item&,  pi2&(3), _
		PM_Item&,  pi2&(4), _
		PM_Item&,  pi2&(5), _
		PM_Item&,  pi2&(6), _
		TAG_DONE&

	pi2&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_NoSelect&,   TRUE&, _
		PM_LayoutMode&, PML_Vertical&, _
		PM_Members&,    pi2&(0),_
		TAG_DONE&

	pi1&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	' -------------------------------
	' Third element / Tercer elemento
	' -------------------------------

	TAGLIST VARPTR (tags&(0)),_
		PM_Title&,   SADD("Right"+CHR$(0)),_
		PM_Center&, TRUE&,_
		TAG_DONE&

	pi1&(3)= PM_MakeItemA&(VARPTR(tags&(0)))

	'  And now, horizontal grouping...
	' Y ahora, agrupación horizontal...
	' ---------------------------------
	TAGLIST VARPTR(tags&(0)),_
		PM_Dummy&, 0&,_
		PM_Item&,  pi1&(1), _
		PM_Item&,  pi1&(2), _
		PM_Item&,  pi1&(3), _
		TAG_DONE&

	pi1&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_NoSelect&,   TRUE&, _
		PM_LayoutMode&, PML_Horizontal&, _
		PM_Members&,    pi1&(0),_
		TAG_DONE&

	mpi&(3) = PM_MakeItemA&(VARPTR(tags&(0)))

	' ================================
	' Separator bar / Barra separadora
	' ================================
	TAGLIST VARPTR(tags&(0)), _
		PM_TitleBar&, TRUE&, _
		TAG_DONE&

	mpi&(4) = PM_MakeItemA&(VARPTR(tags&(0)))

	' ====================================================
	'   The second group (vertical)... this contains
	'   five entries (horizontal groups with 10 items).
	'   El segundo grupo (vertical)... contiene cinco
	' entradas (grupos horizontales de 10 ítems cada uno).
	' ====================================================

	FOR j& = 0 TO 4						'  5 items (vertical)

		FOR i& = 0  TO 9				' 10 items (horizontal)

			TAGLIST VARPTR (tags&(0)),_
				PM_ColourBox&, i&+(j&*10),_
				TAG_DONE&

			pi2&(i&)= PM_MakeItemA&(VARPTR(tags&(0)))

		NEXT i&

	' Creating the horizontal group / Creación del grupo horizontal
	' -------------------------------------------------------------

		TAGLIST VARPTR(tags&(0)),_
			PM_Dummy&, 0&,_
			PM_Item&,  pi2&(1), _
			PM_Item&,  pi2&(2), _
			PM_Item&,  pi2&(3), _
			PM_Item&,  pi2&(4), _
			PM_Item&,  pi2&(5), _
			PM_Item&,  pi2&(6), _
			PM_Item&,  pi2&(7), _
			PM_Item&,  pi2&(8), _
			PM_Item&,  pi2&(9), _
			PM_Item&,  pi2&(0), _
			TAG_DONE&

		pi1&(6+j&) = PM_MakeMenuA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_NoSelect&,   TRUE&, _
			PM_LayoutMode&, PML_Horizontal&, _
			PM_Members&,    pi1&(6+j&),_
			TAG_DONE&

		pi1&(1+j&) = PM_MakeItemA&(VARPTR(tags&(0)))

	NEXT j&

	' Creating the vertical group / Creación del grupo vertical
	' ---------------------------------------------------------
	TAGLIST VARPTR(tags&(0)),_
		PM_Dummy&, 0&,_
		PM_Item&,  pi1&(1), _
		PM_Item&,  pi1&(2), _
		PM_Item&,  pi1&(3), _
		PM_Item&,  pi1&(4), _
		PM_Item&,  pi1&(5), _
		TAG_DONE&

	pi1&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_NoSelect&,   TRUE&, _
		PM_LayoutMode&, PML_Vertical&, _
		PM_Members&,    pi1&(0),_
		TAG_DONE&

	mpi&(5) = PM_MakeItemA&(VARPTR(tags&(0)))

	' ================================
	' Separator bar / Barra separadora
	' ================================
	TAGLIST VARPTR(tags&(0)), _
		PM_TitleBar&, TRUE&, _
		TAG_DONE&

	mpi&(6) = PM_MakeItemA&(VARPTR(tags&(0)))

	' =============================
	' Quit item / Ítem Quit (Salir)
	' =============================

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("Quit"+CHR$(0)), _
		PM_UserData&, 2&, _
		TAG_DONE&

	mpi&(7) = PM_MakeItemA&(VARPTR(tags&(0)))

	' =========================
	'  Creating the popup menu
	' Creando el menú emergente
	' =========================

	FOR i& = 0 TO 7
		TAGLIST VARPTR(tags&(i&*2)), _
			PM_Item&, mpi&(i&), _
			TAG_DONE&
	NEXT i&

	MakeTestMenu& = PM_MakeMenuA&(VARPTR(tags&(0)))

END FUNCTION
