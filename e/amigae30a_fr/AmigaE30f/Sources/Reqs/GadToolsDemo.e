/*Démo de la gadtools */

ENUM NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,ER_MENUS

MODULE 'intuition/intuition', 'gadtools', 'libraries/gadtools',
       'intuition/gadgetclass', 'exec/nodes', 'intuition/screens'

DEF scr=NIL:PTR TO screen,
    visual=NIL,
    wnd=NIL:PTR TO window,
    glist=NIL,offy,g,
    type,infos,listv:PTR TO LONG,menu

PROC main() HANDLE
  openinterface()
  REPEAT
    wait4message()
    TextF(10,150+offy,'type: \d[3], info: \h[4]',type,infos)
  UNTIL type=IDCMP_CLOSEWINDOW
  Raise(NONE)
EXCEPT
  closeinterface()
  IF exception>0 THEN WriteF('Nepeut pas \s !\n',
    ListItem(['','ouvrir la "gadtools.library" v37','locker le workbench',
              'prendre les "visual infos"','créé le "context"','créé les "gadgets"',
              'ouvrir la fenêtre','allouer les menus'],exception))
ENDPROC

PROC openinterface()
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN
    Raise(ER_OPENLIB)
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_WB)
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN Raise(ER_VISUAL)
  offy:=scr.wbortop+Int(scr.rastport+58)+1
  IF (g:=CreateContext({glist}))=NIL THEN Raise(ER_CONTEXT)
  IF (menu:=CreateMenusA([1,0,'Project',0,0,0,0,
    2,0,'Charger','l',0,0,0,
    2,0,'Sauver','s',0,0,0,
    2,0,'Bla ->',0,0,0,0,
    3,0,'aaargh','a',0,0,0,
    3,0,'hmmm','h',0,0,0,
    2,0,'Quitter','q',0,0,0,
    0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)
  IF LayoutMenusA(menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)
  IF (g:=CreateGadgetA(SCROLLER_KIND,g,
    [scr.wborleft+20,offy+9,155,22,NIL,NIL,1,0,visual,0]:newgadget,
    [GTSC_TOP,2,
     GTSC_VISIBLE,3,
     GTSC_TOTAL,10,
     GTSC_ARROWS,22,
     PGA_FREEDOM,LORIENT_HORIZ,
     GA_RELVERIFY,TRUE,
     GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
  listv:=[0,0,0,0]; listv[0]:=listv+4; listv[2]:=listv
  AddTail(listv,[0,0,0,0,'aaaargh']:ln)
  AddTail(listv,[0,0,0,0,'hmmmm']:ln)
  IF (g:=CreateGadgetA(LISTVIEW_KIND,g,
    [scr.wborleft+20,offy+40,155,100,NIL,NIL,2,0,visual,0]:newgadget,
    [GTLV_SCROLLWIDTH,20,
     GTLV_LABELS,listv,0]))=NIL THEN Raise(ER_GADGET)
  IF (wnd:=OpenW(10,15,200,offy+165,$304 OR SCROLLERIDCMP,$E,
    'Démo gadtools en E',NIL,1,glist))=NIL THEN Raise(ER_WINDOW)
  IF SetMenuStrip(wnd,menu)=FALSE THEN Raise(ER_MENUS)
  Gt_RefreshWindow(wnd,NIL)
ENDPROC

PROC closeinterface()
  IF wnd THEN ClearMenuStrip(wnd)
  IF menu THEN FreeMenus(menu)
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC

PROC wait4message()
  DEF mes:PTR TO intuimessage,g:PTR TO gadget
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(wnd.userport)
      type:=mes.class
      IF type=IDCMP_MENUPICK
        infos:=mes.code
      ELSEIF (type=IDCMP_GADGETDOWN) OR (type=IDCMP_GADGETUP)
        g:=mes.iaddress
        infos:=g.gadgetid
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(wnd)
        Gt_EndRefresh(wnd,TRUE)
        type:=0
      ELSEIF type<>IDCMP_CLOSEWINDOW
        type:=0
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      Wait(-1)
    ENDIF
  UNTIL type
ENDPROC
