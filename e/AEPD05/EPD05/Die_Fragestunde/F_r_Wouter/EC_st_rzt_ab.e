/* hallihallo. wenn dieses programm mit EC v2.1b compiliert wird,
stürzt EC mit einem DEADEND 03 ab!!! Toll,was? Jedenfalls, wenn dieser
Kommentar entfernt ist...*/
MODULE 'reqtools','intuition/intuition','intuition/screens','gadtools',
		'libraries/gadtools', 'graphics/text'

ENUM FEHLER_NOGADTOOLS, FEHLER_NOVISUAL,FEHLER_NOMENUS

DEF screentiefe, meinscr:PTR TO screen, meinwin:PTR TO window,
	screenaufloesung

PROC main() HANDLE

DEF meineintmessage:intuimessage,
	vinfo=NIL, menu=NIL,meineklasse,farbe,meincode, sig

  sig := AllocSignal(-1)
  IF sig=NIL THEN CleanUp(20)

  reqtoolsbase:=OpenLibrary('reqtools.library',37)
  IF reqtoolsbase=0
	WriteF('reqtools.library v37 benötigt!')
	CleanUp(20)
  ENDIF
  gadtoolsbase := OpenLibrary('gadtools.library', 37)
  IF gadtoolsbase=NIL THEN Raise(FEHLER_NOGADTOOLS)

  screentiefe := RtEZRequestA('Bitte Farbanzahl wählen','2|4|8|16',0,0,0)
  IF screentiefe=0 THEN screentiefe := 4

  screenaufloesung := RtEZRequestA('Bitte Auflösung wählen, niy','LoRes|MedRes',0,0,0)

  meinscr := OpenScreenTagList(NIL,
  [SA_DEPTH,screentiefe,SA_PUBNAME,'meinscr',SA_PUBSIG,sig,
   SA_PUBTASK,NIL,SA_TITLE,'meinscr',NIL])

  PubScreenStatus(meinscr,0)
  SetDefaultPubScreen('meinscr') /* === SA_TITLE === SA_PUBNAME */
  SetPubScreenModes(SHANGHAI)


  meinwin := OpenWindowTagList(NIL,
  [WA_TITLE,'TinyDraw',WA_IDCMP,IDCMP_RAWKEY+IDCMP_CLOSEWINDOW+IDCMP_MOUSEMOVE+IDCMP_GADGETUP+IDCMP_MOUSEBUTTONS+IDCMP_MENUPICK,
   WA_FLAGS,WFLG_ACTIVATE+WFLG_CLOSEGADGET,WA_CUSTOMSCREEN,meinscr,
   WA_REPORTMOUSE,TRUE,NIL])

  IF(vinfo := GetVisualInfoA(meinscr, NIL)) = NIL THEN Raise(FEHLER_NOVISUAL)

  IF (menu := CreateMenusA([NM_TITLE,0,'Project',0,0,0,0,
	NM_ITEM,	0,	'Laden',		0,	0,0,0,
	NM_ITEM, 	0,	'Speichern',	0,	0,0,0,
	NM_ITEM,	0,	NM_BARLABEL,	0,	0,0,0,
	NM_ITEM,	0,	'Ende',			'E',0,0,0,
	NM_TITLE,	0,	'Verschiedenes',0,	0,0,0,
	NM_ITEM,	0,	'Farbwahl/-änderung',		'f',0,0,0,
	0,0,0,0,0,0,0]:newmenu,NIL)) = NIL THEN Raise(FEHLER_NOMENUS)
  IF LayoutMenusA(menu,vinfo,NIL)=FALSE THEN Raise(FEHLER_NOMENUS)

  IF SetMenuStrip(meinwin,menu)=FALSE THEN Raise(FEHLER_NOMENUS)
  Gt_RefreshWindow(meinwin,NIL)

  REPEAT
	WaitPort(meinwin.userport)
	meineintmessage := GetMsg(meinwin.userport)
	meineklasse := meineintmessage.class
	meincode := meineintmessage.code

	SELECT meineklasse
	  CASE IDCMP_MOUSEMOVE
		IF meincode = 104 /* LMBdown */
		  Draw(meinwin.rport,meineintmessage.mousex,meineintmessage.mousey)
	  CASE IDCMP_MENUPICK
		handle_menus(meincode)
	  CASE IDCMP_MOUSEBUTTONS
		Move(meinwin.rport,meineintmessage.mousex,meineintmessage.mousey)
		WritePixel(meinwin.rport,meineintmessage.mousex,meineintmessage.mousey)
	ENDSELECT
  UNTIL meineklasse = IDCMP_CLOSEWINDOW


  ClearMenuStrip(meinwin)
  FreeMenus(menu)
  CloseWindow(meinwin)
  FreeVisualInfo(vinfo)
  CloseScreen(meinscr)
  CloseLibrary(reqtoolsbase)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  SetDefaultPubScreen(NIL)
  WriteF('Einen schönen Tag noch!\n')
  CleanUp(0)
EXCEPT
  CloseLibrary(reqtoolsbase)
  IF meinwin THEN ClearMenuStrip(meinwin)
  IF menu THEN FreeMenus(menu)
  IF vinfo THEN FreeVisualInfo(vinfo)
  IF(meinwin) THEN CloseWindow(meinwin)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF meinscr
    SetDefaultPubScreen(NIL)
	CloseScreen(meinscr)
  ENDIF
  WriteF('Fehler Nummer %d\n',exception)
  CleanUp(20) 

ENDPROC


PROC handle_menus(code)
DEF titel,item,subitem,gadnummer,zkette[50]:STRING,farbe

  titel := (code AND %11111) /* Bits 0-4 */
  item := ((code/32) AND %111111) /* Bits 5-11 */
  subitem := ((code/2048) AND %11111) /* Bits 11-15 */

  IF (code < 65535)
	SELECT titel
	  CASE 1
		SELECT item
		  CASE 0 /* farben */
		    farbe := RtPaletteRequestA('Bitte neue Farbe wählen:',meinscr,0)
		    IF(farbe >-1) THEN SetAPen(meinwin.rport,farbe)
		ENDSELECT
	ENDSELECT
  ENDIF
ENDPROC
