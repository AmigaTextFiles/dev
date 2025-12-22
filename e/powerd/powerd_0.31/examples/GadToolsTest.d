// simple gadtools button in window

OPT	OSVERSION=37

MODULE	'gadtools',
			'libraries/gadtools',
			'intuition/intuition',
			'intuition/screens',
			'intuition/gadgetclass',
			'graphics/text'

ENUM	NOERROR,ERROR

DEF	window:PTR TO Window,
		glist,
		screen:PTR TO Screen,
		visual=NIL,
		g:PTR TO Gadget,
		GadToolsBase

PROC OpenAll()(LONG)
	IF (GadToolsBase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN ERROR
	IF (screen:=LockPubScreen('Workbench'))=NIL THEN RETURN ERROR
	IF (visual:=GetVisualInfoA(screen))=NIL THEN RETURN ERROR
	IF (g:=CreateContext(&glist))=NIL THEN RETURN ERROR
	IF (g:=CreateGadgetA(BUTTON_KIND,g,[8,8,112,48,'Button',0,0,16,visual,0]:NewGadget,NIL))=NIL THEN RETURN ERROR
	IF (window:=OpenWindowTagList(NIL,[
			WA_Left,214,
			WA_Top,64,
			WA_InnerWidth,128,
			WA_InnerHeight,64,
			WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_GADGETUP,
			WA_Flags,$1100E|WFLG_GIMMEZEROZERO,
			WA_Title,'Window',
			WA_CustomScreen,screen,
			WA_Gadgets,glist,
			TAG_END]))=NIL THEN RETURN ERROR
	DrawBevelBox(window.RPort,4,4,120,56,GT_VisualInfo,visual,GTBB_Recessed,1,TAG_END)
	GT_RefreshWindow(window,NIL)
ENDPROC NOERROR

PROC CloseAll()
	IF window THEN CloseWindow(window) ELSE PrintF('Unable to open window!\n')
	IF glist THEN FreeGadgets(glist) ELSE PrintF('Unable to create gadgets!\n')
	IF visual THEN FreeVisualInfo(visual) ELSE PrintF('Unable to get visual info!\n')
	IF screen THEN UnlockPubScreen(NIL,screen) ELSE PrintF('Unable to lock a screen!\n')
	IF GadToolsBase THEN CloseLibrary(GadToolsBase) ELSE PrintF('Unable to open gadtools.library v37+!\n')
ENDPROC

PROC main()
	IF OpenAll() THEN Raise()
	WaitPort(window.UserPort)
	Raise()
EXCEPT
	CloseAll()
ENDPROC
