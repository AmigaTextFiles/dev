/*************************************************************************


:Programm.      Layout_Gadget_Image.e
:Beschreibung.  Images für Gadgets ( Demo für Module Gadgetimages)

:Autor.         Friedhelm Bunk
:EC-Version.     EC3.2e
:OS.            > 2.0 
:PRG-Version.   1.0


*************************************************************************/


OPT OSVERSION=37

MODULE 'gadtools','libraries/gadtools','gadgets/gadgetimages','intuition/intuition',
       'intuition/screens', 'intuition/gadgetclass', 'graphics/text'

ENUM NONE,NOCONTEXT,NOGADGET,NOWB,NOVISUAL,OPENGT,NOWINDOW,NOMENUS

DEF	project0wnd:PTR TO window,
	project0glist,
	infos:PTR TO gadget,
	scr:PTR TO screen,
	visual=NIL,type,
	offx,offy,tattr,zwischen,zwischen1


PROC setupscreen()
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN OPENGT
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN NOWB
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN NOVISUAL
  offy:=scr.wbortop+Int(scr.rastport+58)-10
  tattr:=['topaz.font',8,0,0]:textattr
ENDPROC

PROC closedownscreen()
  IF visual THEN FreeVisualInfo(visual)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC

PROC openproject0window()
 DEF g:PTR TO gadget
  IF (g:=CreateContext({project0glist}))=NIL THEN RETURN NOCONTEXT
makeImage(1)
zwischen:=myImage
zwischen1:=my2mage
/******
 Rückgabe sind 2 Zeiger ( my2mage , myImage ) auf Strukturen, welche im CHIP-Ram
 angelegt wurden. Sie sind mehrmals verwendbar . Vor Erneutem aufruf der Prozedure
 müssen sie zur Weiterverwendung Zwischengespeichert werden.
( Z.B. zwischen1:=my2mage  ) da bei jedem Aufruf der Prozedure NEUE Strukturen
angelegt werden.
********/
  IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+55,offy+35,20,14,'',tattr,0,0,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 g.flags:=6
 g.activation:=1
 g.gadgetrender:=my2mage
 g.selectrender:=myImage
makeImage(2)
 IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+154,offy+35,20,14,'',tattr,1,0,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 g.flags:=6
 g.activation:=1
 g.gadgetrender:=my2mage
 g.selectrender:=myImage
makeImage(3)
  IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+255,offy+35,20,14,'',tattr,2,0,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 g.flags:=6
 g.activation:=1
 g.gadgetrender:=my2mage
 g.selectrender:=myImage
makeImage(4)
  IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+348,offy+35,20,14,'',tattr,3,0,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 g.flags:=6
 g.activation:=1
 g.gadgetrender:=my2mage
 g.selectrender:=myImage
  IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+55,offy+55,20,14,'',tattr,4,0,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 g.flags:=6
 g.activation:=1
 g.gadgetrender:=zwischen1
 g.selectrender:=zwischen
IF (project0wnd:=OpenW(10,15,offx+440,offy+75,$24C077E,$100E,
   'Gadget Image Window',NIL,1,project0glist))=NIL THEN RETURN NOWINDOW
  Gt_RefreshWindow(project0wnd,NIL)
ENDPROC

PROC closeproject0window()
  IF project0wnd THEN CloseWindow(project0wnd)
  IF project0glist THEN FreeGadgets(project0glist)
ENDPROC

PROC wait4message(win:PTR TO window)
  DEF mes:PTR TO intuimessage
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(win.userport)
      type:=mes.class
      IF type=IDCMP_MENUPICK
        infos:=mes.code
      ELSEIF (type=IDCMP_GADGETDOWN) OR (type=IDCMP_GADGETUP)
        infos:=mes.iaddress
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(win)
        Gt_EndRefresh(win,TRUE)
        type:=0
      ELSEIF type<>IDCMP_CLOSEWINDOW
        type:=0
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      WaitPort(win.userport)
    ENDIF
  UNTIL type
ENDPROC type

PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er
    erlist:=['get context','create gadget','lock wb','get visual infos',
      'open "gadtools.library" v37+','open window','create menus']
    EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[er-1]])
  ENDIF
ENDPROC er


PROC main()
 IF reporterr(setupscreen())=0
    reporterr(openproject0window())
   SetTopaz(8)
 Colour(1,0)
TextF(offx+30,offy+30,'Get Drawer')
TextF(offx+133,offy+30,'Get File')
TextF(offx+245,offy+30,'Drawer')
TextF(offx+343,offy+30,'Disk')
TextF(offx+85,offy+65,'Zweiter Get Drawer')
REPEAT
    wait4message(project0wnd)
UNTIL type=IDCMP_CLOSEWINDOW
    closeproject0window()
    IF CtrlC() THEN BRA x
  ENDIF
  x: closedownscreen()
ENDPROC
VOID '$VER:Layout_Gadget_Image © F.Bunk (03.03.1996)' 
