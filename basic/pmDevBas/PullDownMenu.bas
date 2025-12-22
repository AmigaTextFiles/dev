' *********************************************************************
'   PullDownMenu © 1996-97 by Henrik Isaksson -- All Rights Reserved
'                           V. 2.2 (20.07.00)
'
'                C to HBASIC conversion 1.1+ (06.05.03)
'               by Dámaso D. Estévez {amidde,arrakis,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'   This example create a Workbench menu simulation and uses a hook
' Este ejemplo crea una simulación del menú del WB y utiliza un resorte
' *********************************************************************

REM $NOWINDOW

REM $include pm.bh
REM $include exec.bh
REM $include intuition.bh
REM $include utility.bc

pmb&  = NULL&    ' PopUpMenuBase
ib&   = NULL&    ' IntuitionBase
ub&   = NULL&    ' UtilityBase
gb&   = NULL&    ' GfxBase
w&    = NULL&    ' Window

im&   = NULL&    ' IntuiMessage
p&    = NULL&    ' PopupMenu
r&    = TRUE&    ' Status flag (loop) / Bandera de estado (bucle)
ok&   = FALSE&   ' Status flag / Bandera de estado

DIM mtags&(40)   ' Window Taglist / Lista de atributos para la ventana

'     Hook struct simulation
' Simulación de la estructura Hook
' --------------------------------
DIM MenuHandler%(Hook_sizeof%\2)

'      Settings for to use hooks
' Preferencias para el uso de resortes
' ------------------------------------
REM $NOAUTODIM
REM $NOARRAY
REM $NOBREAK
REM $NOOVERFLOW
REM $NOEVENT
REM $NOSTACK

' =====================================================================

FUNCTION MenuHandlerFunc&(BYVAL hook&,BYVAL object&,BYVAL msg&)
SHARED r&
STATIC i&

	MenuHandlerFunc& = FALSE&

	PRINT "---"
	PRINT "Title:   "+CHR$(34)+PEEK$(PEEKL(object&+pm_Title%))+CHR$(34)
	PRINT "UserData:";PEEKL(object&+pm_UserData%)
	PRINT "ID:      ";PEEKL(object&+pm_ID%)

	'   Mr Issakson says what this is the way
	' of finding is the item is checked or not.
	'       BEWARE! I've modified slighty
	' the HBasic names for theses (PM_->PMF_)...
	' C language:
	'  #define PM_CHECKIT             0x40000000
	'  #define PM_CHECKED             0x80000000
	' HBasic language:
	'  CONST PMF_CHECKIT&          = &h40000000&
	'  CONST PMF_CHECKED&          = &h80000000&
	'
	' El Sr. Issakson señala que esta es la forma
	'    de comprobar si un ítem está activado
	'        (marca de verificación) o no.
	'    ¡ATENCIÓN! He modificado ligeramente
	'        el nombre de estas constantes
	'          en HBasic (PM_->PMF_)...
	' Lenguaje C:
	'  #define PM_CHECKIT             0x40000000
	'  #define PM_CHECKED             0x80000000
	' Lenguaje HBasic:
	'  CONST PMF_CHECKIT&          = &h40000000&
	'  CONST PMF_CHECKED&          = &h80000000&
	' --------------------------------------------
	IF(PEEKL(object&+pm_Flags%) AND PMF_CHECKIT&) THEN
		print "Checked?  ";
		IF (PEEKL(object&+pm_Flags%) AND PMF_CHECKED&) THEN
			 PRINT "Yes"
		ELSE
			 PRINT "No"
		END IF
		PRINT
	END IF

	IF(PEEKL(object&+pm_UserData%)=5&) THEN

		'       Mr Issakson uses other solution more elegant
		' in your C code, I know... I tried convert it to HBasic,
		'      but my code always finnished with a guru 8'(...
		' and I decided use the HBasic shared var for simulate it.
		'                         --------
		'   El Sr. Issakson utiliza otra solución más elegante
		'  en su código en C, lo sé... he intentado reproducirla
		'     pero mi código siempre acababa en un gurú 8'(..
		'   así que decidí utilizar las variables compartidas
		'          del HBasic para simular su función.
		' --------------------------------------------------------
		r&=FALSE&

	END IF

	MenuHandlerFunc& = TRUE&

END FUNCTION

'               --------------------------------------------

FUNCTION MakeTestMenu&()
LOCAL i&,pi&,mpi&,tags&

' Taglist / Lista de atributos
' ----------------------------
DIM tags&(24)

' Items or menu pointer arrays / Matrices de punteros a ítems o menús
' -------------------------------------------------------------------
DIM mpi&(10)    ' Main
DIM  pi&(15)    ' Aux.

	' Workbench item menu / Ítem del menú Workbench
	' =============================================

	' PMCheckItem

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Backdrop?"+CHR$(0)), _
		PM_ID&,      1&, _
		PM_Checkit&, TRUE&, _
		PM_CommKey&, SADD("B"+CHR$(0)), _
		TAG_DONE&

	pi&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	' PMItem

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Execute command..."+CHR$(0)), _
		PM_CommKey&, SADD("E"+CHR$(0)), _
		TAG_DONE&

	pi&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Redraw All"+CHR$(0)), _
		TAG_DONE&

	pi&(3) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Update All"+CHR$(0)), _
		TAG_DONE&

	pi&(4) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Last Message"+CHR$(0)), _
		TAG_DONE&

	pi&(5) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("About..."+CHR$(0)), _
		PM_CommKey&, SADD("?"+CHR$(0)), _
		TAG_DONE&

	pi&(6) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Quit"+CHR$(0)), _
		PM_UserData&, 5&, _
		PM_CommKey&,  SADD("Q"+CHR$(0)), _
		TAG_DONE&

	pi&(7) = PM_MakeItemA&(VARPTR(tags&(0)))

	' Grouping items / Agrupando ítems en un submenú
	' ----------------------------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Dummy&, 0&, _
		TAG_DONE&

	FOR i& = 1 TO 7
		TAGLIST VARPTR(tags&((i&-1)*2)), _
			PM_Item&, pi&(i&), _
			TAG_DONE&
	NEXT i&

	mpi&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	' Creating the Workbench item and link with their submenu
	'      Creando ítem Workbench y enlace con su submenú
	' -------------------------------------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("Workbench"+CHR$(0)), _
		PM_Sub&,      mpi&(0), _
		PM_UserData&, 5986&, _
		PM_NoSelect&, FALSE&, _
		TAG_DONE&

	mpi&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	' =============================================================

	' Window item menu / Ítem del menú Window
	' =======================================

	' PMItem

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("New Drawer"+CHR$(0)), _
		PM_CommKey&,  SADD("N"+CHR$(0)), _
		PM_Disabled&, TRUE&, _
		TAG_DONE&

	pi&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("Open Parent"+CHR$(0)), _
		PM_Disabled&, TRUE&, _
		TAG_DONE&

	pi&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Close"+CHR$(0)), _
		PM_CommKey&, SADD("K"+CHR$(0)), _
		PM_Disabled&, TRUE&, _
		TAG_DONE&

	pi&(3) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Update"+CHR$(0)), _
		PM_Disabled&, TRUE&,_
		TAG_DONE&

	pi&(4) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Select Contents"+CHR$(0)), _
		PM_CommKey&, SADD("A"+CHR$(0)), _
		TAG_DONE&

	pi&(5) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Clean Up"+CHR$(0)), _
		PM_CommKey&,  SADD("."+CHR$(0)), _
		TAG_DONE&

	pi&(6) = PM_MakeItemA&(VARPTR(tags&(0)))

	' Snapshot submenu / Submenú Snapshot

		' Subitems

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&, SADD("Window"+CHR$(0)), _
			TAG_DONE&

		pi&(7) = PM_MakeItemA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&, SADD("All"+CHR$(0)), _
			TAG_DONE&

		pi&(8) = PM_MakeItemA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Dummy&, 0&, _
			PM_Item&,  pi&(7), _
			PM_Item&,  pi&(8), _
			TAG_DONE&

		pi&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("Snapshot"+CHR$(0)), _
		PM_Sub&,   pi&(0), _
		TAG_DONE&

	pi&(7) = PM_MakeItemA&(VARPTR(tags&(0)))

	' Show submenu / Submenú Show

		' Subitems

		' Excluding items
		TAGLIST VARPTR(tags&(0)), _
			3&, 0&

		pi&(0)=PM_ExLstA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&,   SADD("Only Icons"+CHR$(0)), _
			PM_ID&,      2&, _
			PM_Checkit&, TRUE&, _
			PM_Exclude&, pi&(0), _
			PM_Checked&, TRUE&, _
			TAG_DONE&

		pi&(8) = PM_MakeItemA&(VARPTR(tags&(0)))

		' Excluding items

		TAGLIST VARPTR(tags&(0)), _
			2&, 0&

		pi&(0)=PM_ExLstA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&,   SADD("All"+CHR$(0)), _
			PM_ID&,      3&, _
			PM_Checkit&, TRUE&, _
			PM_Exclude&, pi&(0), _
			TAG_DONE&

		pi&(9) = PM_MakeItemA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Dummy&,    0&, _
			PM_Item&,     pi&(8), _
			PM_Item&,     pi&(9), _
			TAG_DONE&

		pi&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("Show"+CHR$(0)), _
		PM_Sub&,      pi&(0),_
		PM_Disabled&, TRUE&, _
		TAG_DONE&

	pi&(8) = PM_MakeItemA&(VARPTR(tags&(0)))

	' View By submenu / Submenu View By

		' Subitems

		' Excluding items

		TAGLIST VARPTR(tags&(0)), _
			5&, 6&, 7&, 0&

		pi&(0)=PM_ExLstA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&,   SADD("Icon"+CHR$(0)), _
			PM_ID&,      4&, _
			PM_Checkit&, TRUE&, _
			PM_Exclude&, pi&(0), _
			PM_Checked&, TRUE&, _
			TAG_DONE&

		pi&(9) = PM_MakeItemA&(VARPTR(tags&(0)))

		' Excluding items

		TAGLIST VARPTR(tags&(0)), _
			4&, 6&, 7&, 0&

		pi&(0)=PM_ExLstA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&,   SADD("Name"+CHR$(0)), _
			PM_ID&,      5&, _
			PM_Checkit&, TRUE&, _
			PM_Exclude&, pi&(0), _
			TAG_DONE&

		pi&(10) = PM_MakeItemA&(VARPTR(tags&(0)))

		' Excluding items

		TAGLIST VARPTR(tags&(0)), _
			4&, 5&, 7&, 0&

		pi&(0)=PM_ExLstA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&,   SADD("Date"+CHR$(0)), _
			PM_ID&,      6&, _
			PM_Checkit&, TRUE&, _
			PM_Exclude&, pi&(0), _
			TAG_DONE&

		pi&(11) = PM_MakeItemA&(VARPTR(tags&(0)))

		' Excluding items

		TAGLIST VARPTR(tags&(0)), _
			4&, 5&, 6&, 0&

		pi&(0)=PM_ExLstA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Title&,   SADD("Size"+CHR$(0)), _
			PM_ID&,      7&, _
			PM_Checkit&, TRUE&, _
			PM_Exclude&, pi&(0), _
			TAG_DONE&

		pi&(12) = PM_MakeItemA&(VARPTR(tags&(0)))

		TAGLIST VARPTR(tags&(0)), _
			PM_Dummy&, 0&, _
			PM_Item&,  pi&(9), _
			PM_Item&,  pi&(10), _
			PM_Item&,  pi&(11), _
			PM_Item&,  pi&(12), _
			PM_Disabled&, TRUE&, _
			TAG_DONE&

		pi&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,  SADD("View By"+CHR$(0)), _
		PM_Sub&,    pi&(0), _
		TAG_DONE&

	pi&(9) = PM_MakeItemA&(VARPTR(tags&(0)))

	' Grouping items / Agrupando ítems en un submenú
	' ----------------------------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Dummy&, 0&, _
		TAG_DONE&

	FOR i& = 1 TO 9
		TAGLIST VARPTR(tags&((i&-1)*2)), _
			PM_Item&, pi&(i&), _
			TAG_DONE&
	NEXT i&

	mpi&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("Window"+CHR$(0)), _
		PM_Sub&,   mpi&(0), _
		TAG_DONE&

	mpi&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	' =============================================================

	' Icons item menu / Ítem del menú Icons
	' =====================================

	' PMItem

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Open"+CHR$(0)), _
		PM_CommKey&, SADD("O"+CHR$(0)), _
		TAG_DONE&

	pi&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Copy"+CHR$(0)), _
		PM_CommKey&, SADD("C"+CHR$(0)), _
		TAG_DONE&

	pi&(2) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Rename..."+CHR$(0)), _
		PM_CommKey&, SADD("R"+CHR$(0)), _
		TAG_DONE&

	pi&(3) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Information..."+CHR$(0)), _
		PM_CommKey&, SADD("I"+CHR$(0)),_
		TAG_DONE&

	pi&(4) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Snapshot..."+CHR$(0)), _
		PM_CommKey&, SADD("S"+CHR$(0)), _
		TAG_DONE&

	pi&(5) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("UnSnapshot"+CHR$(0)), _
		PM_CommKey&,  SADD("U"+CHR$(0)), _
		TAG_DONE&

	pi&(6) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Leave Out"+CHR$(0)), _
		PM_CommKey&, SADD("L"+CHR$(0)), _
		TAG_DONE&

	pi&(7) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Put Away"+CHR$(0)), _
		PM_CommKey&,  SADD("P"+CHR$(0)), _
		TAG_DONE&

	pi&(8) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_TitleBar&, TRUE&, _
		TAG_DONE&

	pi&(9) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,    SADD("Delete..."+CHR$(0)), _
		PM_Disabled&, TRUE&, _
		TAG_DONE&

	pi&(10) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Format Disk..."+CHR$(0)), _
		TAG_DONE&

	pi&(11) = PM_MakeItemA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&,   SADD("Empty Trash"+CHR$(0)), _
		PM_CommKey&, TRUE&, _
		TAG_DONE&

	pi&(12) = PM_MakeItemA&(VARPTR(tags&(0)))

	' Grouping items / Agrupando ítems en un submenú
	' ----------------------------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Dummy&, 0&, _
		TAG_DONE&

	FOR i& = 1 TO 12
		TAGLIST VARPTR(tags&((i&-1)*2)), _
			PM_Item&, pi&(i&), _
			TAG_DONE&
	NEXT i&

	mpi&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("Icons"+CHR$(0)), _
		PM_Sub&,   mpi&(0), _
		TAG_DONE&

	mpi&(3) = PM_MakeItemA&(VARPTR(tags&(0)))

	' =============================================================

	' Tools item menu / Ítem del menú Tools
	' =====================================

	' PMItem
	' ------

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("ResetWB"+CHR$(0)), _
		TAG_DONE&

	pi&(1) = PM_MakeItemA&(VARPTR(tags&(0)))

	' Grouping items / Agrupando ítems en un submenú
	' ----------------------------------------------

	TAGLIST VARPTR(tags&(0)), _
		PM_Dummy&, 0&, _
		PM_Item&,  pi&(1),_
		TAG_DONE&

	mpi&(0) = PM_MakeMenuA&(VARPTR(tags&(0)))

	TAGLIST VARPTR(tags&(0)), _
		PM_Title&, SADD("Tools"+CHR$(0)), _
		PM_Sub&,   mpi&(0), _
		TAG_DONE&

	mpi&(4) = PM_MakeItemA&(VARPTR(tags&(0)))

	' =========================
	'  Creating the popup menu
	' Creando el menú emergente
	' =========================

	FOR i& = 1 TO 4
		TAGLIST VARPTR(tags&((i&-1)*2)), _
			PM_Item&, mpi&(i&), _
			TAG_DONE&
	NEXT i&

	MakeTestMenu& = PM_MakeMenuA&(VARPTR(tags&(0)))

END FUNCTION

' =====================================================================
'                          The code / El código
' =====================================================================

'            "Opening" all libraries needed
' Abriendo y preparando todas las bibliotecas necesarias
' ------------------------------------------------------

LIBRARY OPEN "exec.library"
LIBRARY OPEN "popupmenu.library",POPUPMENU_VERSION&

pmb&=LIBRARY("popupmenu.library")

ib& = PEEKL(pmb& + pmb_IntuitionBase%)
IF ib& <> NULL& THEN
	LIBRARY VARPTR "intuition.library", ib&
	gb& = PEEKL(pmb& + pmb_GfxBase%)
	IF gb& <> NULL& THEN
		LIBRARY VARPTR "graphics.library", gb&
		ok& = TRUE&
	END IF
END IF

'  First, a C struct simulation (see the imsg var in original C code)
'                                 -------
'      Primero, reservo espacio para simular una estructura en C
' (consulte la función de la variable imsg en el código original en C)
' --------------------------------------------------------------------
imsg&=AllocMem&(IntuiMessage_sizeof%,MEMF_ANY& OR MEMF_CLEAR&)
IF imsg& = NULL& THEN
	ok&= FALSE&
END IF

IF ok& = TRUE& THEN

	' Preparing my menu / Preparando mi menú
	' --------------------------------------
	p& = MakeTestMenu&()

	IF p& <> NULL& THEN

		'   Window properties
		' Atributos de la ventana
		' -----------------------
		TAGLIST VARPTR(mtags&(0)),_
			WA_IDCMP&,       IDCMP_CLOSEWINDOW& OR IDCMP_MOUSEBUTTONS& OR IDCMP_VANILLAKEY&, _
			WA_RMBTrap&,     TRUE&, _
			WA_DragBar&,     TRUE&, _
			WA_Width&,       150, _
			WA_Height&,      100, _
			WA_Left&,        0, _
			WA_Top&,         100, _
			WA_Title&,       SADD("PullDown Menus"+CHR$(0)), _
			WA_CloseGadget&, TRUE&,_
			TAG_DONE&

		'    Opening the window: this window is only needed to find out
		'  when AND where the MENU should appear AND wich SCREEN it's on.
		'                           ---------
		' Abriendo la ventana: sólo es necesaria para saber dónde y cuándo
		'       el menú emergente debe aparecer y sobre qué pantalla.
		' ----------------------------------------------------------------
		w& = OpenWindowTagList&(NULL&, VARPTR(mtags&(0)))

		IF w& <> NULL& THEN

			' Creating a Hook struct / Creando una estructura Hook
			' ----------------------------------------------------
			INITHOOK VARPTR(MenuHandler%(0)),VARPTRS(MenuHandlerFunc&)

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
						CopyMem im&, imsg&, IntuiMessage_sizeof%
						ReplyMsg im&

						TAGLIST VARPTR(mtags&(0)),_
							PM_AutoPullDown&, TRUE&,_
							PM_MenuHandler&,  VARPTR(MenuHandler%(0)), _
							TAG_DONE&

						dummy& = PM_FilterIMsgA&(w&,p&,imsg&,VARPTR(mtags&(0)))

						IF PEEKL(imsg&+Class%) =IDCMP_CLOSEWINDOW& THEN r&=FALSE&
						
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

	PRINT "The hook struct allocation or the libraries have failed!"

END IF

IF imsg& <> NULL& THEN FreeMem imsg&,IntuiMessage_sizeof%

IF gb& <> NULL& THEN LIBRARY VARPTR "graphics.library",  NULL&
IF ib& <> NULL& THEN LIBRARY VARPTR "intuition.library", NULL&

'          Safe, even if the program fails to open the libraries
' Método seguro, incluso aunque el programa falle al abrir las bibliotecas
' ------------------------------------------------------------------------
LIBRARY CLOSE "popupmenu.library"
LIBRARY CLOSE "exec.library"

END
