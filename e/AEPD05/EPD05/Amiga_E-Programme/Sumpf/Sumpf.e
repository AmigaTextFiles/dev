/*
**      $Filename: Pascalinische Sümpfe
**      $Version : 0.1
**      $Date    : 30.11.1993
**      $Status  : Public Domain !!! Unreleased Version !!!
**      $Author  : Daniel van Gerpen
**      $Others  : None
**
**      Programmbeispiel in E, Gebrauch von GadToolsBox
**
**
*/


ENUM NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,ER_MENUS
/* Fehler-Konstanten */


MODULE 'intuition/intuition', 'gadtools', 'libraries/gadtools',
       'intuition/gadgetclass', 'exec/nodes', 'intuition/screens'
/* Benutzte Includes */


DEF scr=NIL:PTR TO screen,  /* Zeiger auf Screen-Struktur */
    wnd=NIL:PTR TO window,  /* Zeiger auf Window-Struktur */
    visual=NIL,
    glist=NIL, g, infos,    /* Gadget-Liste und IDCMP - Infos */
    menu,                   /* Menu - Struktur */
    offy,offx,              /* Abstand von Windowursprung */
    tattr,                  /* Schriftattribute */
    type=0,                 /* IDCMP - Art */
    art,nopeln=0,manuseln=0,lopst=0,knelt=0,summe

PROC main() HANDLE          /* HANDLE für Exeption-Handler */
  openinterface()           /* Window mit  Gadgets öffnen */
  Colour(1,0)               /* Farbe 1 auf Farbe 0 */
  art:=2                    /* Am Anfang Cedi */
  TextF(123+offx,46+offy,'\s  ',
    ListItem(['Asi','Bela','Cedi','Drudi'],art))  /* Ausgabe */
  REPEAT
    wait4message()          /* Auf Mausklick warten */
    IF (type=IDCMP_GADGETDOWN) OR (type=IDCMP_GADGETUP) THEN auswertung()
    TextF(123+offx,46+offy,'\s  ',ListItem(['Asi','Bela','Cedi','Drudi'],art))
  UNTIL type=IDCMP_CLOSEWINDOW
  Raise(NONE)
EXCEPT
  closeinterface()
  IF exception>0 THEN WriteF('Could not \s !\n',
    ListItem(['','open "gadtools.library" v37','lock workbench',
              'get visual infos','create context','create gadget',
              'open window','allocate menus'],exception))
ENDPROC

PROC openinterface()
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN
    Raise(ER_OPENLIB)
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_WB)
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN Raise(ER_VISUAL)
  offy:=scr.wbortop+Int(scr.rastport+58)-9
  offx:=scr.wborleft
  tattr:=['topaz.font',8,0,0]
  IF (g:=CreateContext({glist}))=NIL THEN Raise(ER_CONTEXT)
  IF (menu:=CreateMenusA([1,0,'Project',0,0,0,0,
    2,0,'Über...',0,0,0,0,
    2,0,'Ende','q',0,0,0,
    0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)
  IF LayoutMenusA(menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)
  IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+11,offy+16,26,11,'_Nopelt',tattr,0,2,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN Raise(ER_GADGET)
  IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+11,offy+31,26,11,'Knelt',tattr,1,2,visual,0]:newgadget,
     NIL))=NIL THEN Raise(ER_GADGET)
  IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+11,offy+46,26,11,'Manuselt',tattr,2,2,visual,0]:newgadget,
     NIL))=NIL THEN Raise(ER_GADGET)
  IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+11,offy+62,26,11,'Löpst',tattr,3,2,visual,0]:newgadget,
     NIL))=NIL THEN Raise(ER_GADGET)
  IF (g:=CreateGadgetA(TEXT_KIND,g,
    [offx+117,offy+36,122,16,'Es ist ein...',tattr,4,4,visual,0]:newgadget,
    [GTTX_BORDER,1,
     NIL]))=NIL THEN Raise(ER_GADGET)
  IF (wnd:=OpenW(220,38,offx+249,offy+80,$24C077E,$102E,
    'Pascalinische Sümpfe',NIL,1,glist))=NIL THEN Raise(ER_WINDOW)
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

PROC auswertung()
     IF (infos+1=1) AND (nopeln=1) 
         nopeln:=0
      ELSEIF (infos+1=1) AND (nopeln=0)
         nopeln:=1
      ELSEIF (infos+1=2) AND (knelt=1)
         knelt:=0
      ELSEIF (infos+1=2) AND (knelt=0)
         knelt:=1
      ELSEIF (infos+1=3) AND (manuseln=1)
         manuseln:=0
      ELSEIF (infos+1=3) AND (manuseln=0)
         manuseln:=1
      ELSEIF (infos+1=4) AND (lopst=1)
         lopst:=0
      ELSEIF (infos+1=4) AND (lopst=0)
         lopst:=1
     ENDIF

     summe:=(lopst*1)+(knelt*2)+(nopeln*4)+(manuseln*8)

     SELECT summe
         CASE 0
          art:=2
         CASE 1
          art:=3
         CASE 2
          art:=3
         CASE 3
          art:=3
         CASE 4
          art:=1
         CASE 5
          art:=1
         CASE 6
          art:=2
         CASE 7
          art:=2
         CASE 8
          art:=3
         CASE 9
          art:=2
         CASE 10
          art:=0
         CASE 11
          art:=0
         CASE 12
          art:=1
         CASE 13
          art:=1
         CASE 14
          art:=0
         CASE 15
          art:=0
     ENDSELECT
ENDPROC

