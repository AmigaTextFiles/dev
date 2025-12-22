/*

Old program that builds a frame for own programs that use more than one
window.

Created back in 1993 where 2.1b was the available version of EC :)

The REPEAT...UNTIL loop in the *huge* main proc shows the usage of portList
and port procs.

es, the program looks ugly. I just browsed through my sources looking for
a program that works with multiple windows and that was easy to modify...

*/

/*
 * Windowgrundgerüst.e
 *
 * Ein kleines Proggy, das ein Haupt- und Nebenfenster öffnet und in das
 * Hauptfenster ein Menü hängt. Samt Abfrage der Inputevents. Flagge für
 * gedrückte linke Maustaste. IntuiMessage wird kopiert in
 * ·meineintmessage· und dann sofort zurückgegeben. Bei Betätigung des
 * Close-Gadgets werden im Hafen liegende Nachrichten abgeholt, jedoch
 * nicht bearbeitet.
 *
 * V1.3 von Gregor Goldbach. 'Placed in the Public Domain.'
 * compilierbar mit v2.1b/v3.0a/v3.0b
 */


MODULE 'intuition/intuition','intuition/screens','gadtools',
        'libraries/gadtools', 'graphics/text','exec/ports','graphics/scale',
        'graphics/rastport','graphics/gfx','exec/memory', 'exec/nodes',
        'exec/lists',

        'oomodules/library/exec/port/portList',
        'oomodules/library/exec/port'


ENUM FEHLER_NOGADTOOLS,FEHLER_NOVISUAL,FEHLER_NOMENUS, FEHLER_GADGET, FEHLER_CONTEXT

DEF hauptwin:PTR TO window, /* Hauptfenster */
    nebenwin:PTR TO window, /* Nebenfenster */
    uport:PTR TO mp,        /* UserPort: für Signal */
    pscreen:PTR TO screen,  /* für LockPubScreen() */
    lmbdown=FALSE,          /* Flagge: gesetzt, wenn linke Maustaste gedrückt */
    intmsg:PTR TO intuimessage, /* von GetMsg() */
    meineintmessage:PTR TO intuimessage, /* Kopie der intmsg */
    zahl1,zahl2,
    zkette_x[80]:STRING, adresse_x,

    vinfo=NIL,              /* VisualInfo, muß 0 sein */
    menu=NIL,               /* für LayoutMenus(), muß 0 sein */

    listv:PTR TO LONG,
    gadgetliste=NIL,
    g:PTR TO gadget

PROC main() HANDLE

DEF meineklasse,meincode,x,y,x2,y2,laufvar,

  ports:PTR TO portList,
  port:PTR TO port,
  portKey

  NEW ports.new()

  IF(meineintmessage := AllocMem(SIZEOF intuimessage, MEMF_CLEAR OR MEMF_PUBLIC))=NIL
    WriteF('Kein Speicher (\d Bytes) für Kopie der intuimessage!\n', SIZEOF intuimessage)
    CleanUp(20)
  ENDIF

  gadtoolsbase := OpenLibrary('gadtools.library', 37)
  IF gadtoolsbase=NIL THEN Raise(FEHLER_NOGADTOOLS+4)

  pscreen := LockPubScreen(NIL)
  IF(vinfo := GetVisualInfoA(pscreen, NIL)) = NIL THEN Raise(FEHLER_NOVISUAL)
  IF(g:=CreateContext( {gadgetliste} ))=NIL THEN Raise(FEHLER_CONTEXT)

  listv:=[0,0,0,0]; listv[0]:=listv+4; listv[2]:=listv /* listenheader?*/
  AddTail(listv,[0,0,0,0,'eins']:ln)
  AddTail(listv,[0,0,0,0,'zwei']:ln)
  AddTail(listv,[0,0,0,0,'drei']:ln)
  AddTail(listv,[0,0,0,0,'vier']:ln)
  AddTail(listv,[0,0,0,0,'fünf']:ln)

  IF (g:=CreateGadgetA(LISTVIEW_KIND,g,
    [8,4,155,40,NIL,NIL,2,0,vinfo,0]:newgadget,
    [GTLV_LABELS,listv,
     GTLV_SHOWSELECTED,0,
     0,0]))=NIL THEN Raise(FEHLER_GADGET)

  hauptwin := OpenWindowTagList(NIL,
  [WA_TITLE,'Hauptfenster',
   WA_IDCMP,IDCMP_RAWKEY OR IDCMP_CLOSEWINDOW OR IDCMP_MOUSEMOVE OR IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEBUTTONS OR IDCMP_MENUPICK OR IDCMP_REFRESHWINDOW,
   WA_FLAGS,WFLG_ACTIVATE+WFLG_CLOSEGADGET,
   WA_GADGETS, gadgetliste,
   WA_INNERHEIGHT,120, WA_DEPTHGADGET, TRUE,
   WA_DRAGBAR, TRUE,
   WA_REPORTMOUSE,TRUE,WA_GIMMEZEROZERO,TRUE,NIL])

  Gt_RefreshWindow(hauptwin,NIL)

  SetAPen(hauptwin.rport,1)
  SetBPen(hauptwin.rport,0)
  SetDrMd(hauptwin.rport,RP_JAM2)

  nebenwin := OpenWindowTagList(NIL,
  [WA_TITLE,'Nebenfenster',WA_IDCMP,IDCMP_RAWKEY+IDCMP_CLOSEWINDOW+IDCMP_MOUSEMOVE+IDCMP_GADGETUP+IDCMP_MOUSEBUTTONS+IDCMP_MENUPICK OR IDCMP_REFRESHWINDOW,
   WA_FLAGS,WFLG_ACTIVATE+WFLG_CLOSEGADGET,
    WA_TOP,120,
   WA_INNERHEIGHT,60,WA_DEPTHGADGET,TRUE,
   WA_DRAGBAR, TRUE,
   WA_REPORTMOUSE,TRUE,WA_GIMMEZEROZERO,TRUE,NIL])


 /*
  * Add port to the list and use window pointers as keys. We get the
  * according key when a message arrives at that port.
  */

  ports.add(hauptwin.userport, hauptwin)
  ports.add(nebenwin.userport, nebenwin)



  REPEAT

   /*
    * Get message, port key and port from the list.
    */

    intmsg, portKey, port := ports.waitAndGet("gadt")


   /*
    * Check portKey for matching window pointer
    */

    IF(portKey = hauptwin)
      REPEAT

        kopiere_intmessage(intmsg,meineintmessage)

        port.replyMsg("gadt")

        meineklasse := meineintmessage.class
        meincode := meineintmessage.code

        SELECT meineklasse
          CASE IDCMP_CLOSEWINDOW
           /*
            * Nach Betätigung des Close-Gadgets werden alle eingelaufenen
            * Nachrichten entfernt.
            */
            WHILE(intmsg := port.getMsg("gadt")) DO port.replyMsg("gadt")

          CASE IDCMP_MENUPICK
            handle_menus(meincode)
          CASE IDCMP_MOUSEBUTTONS
            IF meincode = 104
              lmbdown:=TRUE
              tete(hauptwin,'Hi! and Welcome', 12,10,40,10)
              tete(hauptwin,'The Amiga E Encyclopedia', 12,20,40,10)

            ELSEIF meincode = 232
              lmbdown:=FALSE
            ENDIF
          CASE IDCMP_GADGETUP
            StringF(zkette_x, 'Eintrag Nummer \d.', meincode)
            Move(hauptwin.rport, 100, 100)
            Text(hauptwin.rport, zkette_x, StrLen(zkette_x))

          CASE IDCMP_REFRESHWINDOW
            Gt_BeginRefresh(hauptwin)
            Gt_EndRefresh(hauptwin, TRUE)

        ENDSELECT
      UNTIL (intmsg := port.getMsg("gadt")=NIL)

    ELSEIF(portKey = nebenwin)

     /*
      * Here we have the more 'traditional' way of message processing.
      */

      WHILE(intmsg := Gt_GetIMsg(nebenwin.userport))
        kopiere_intmessage(intmsg,meineintmessage)
        Gt_ReplyIMsg(intmsg)

        meineklasse := meineintmessage.class
        meincode := meineintmessage.code

        SELECT meineklasse
          CASE IDCMP_CLOSEWINDOW
           /*
            * Nach Betätigung des Close-Gadgets werden alle eingelaufenen
            * Nachrichten entfernt.
            */
            WHILE(intmsg := GetMsg(hauptwin.userport)) DO ReplyMsg(intmsg)

          CASE IDCMP_MOUSEBUTTONS
            IF meincode = 104
              lmbdown:=TRUE

            ELSEIF meincode = 232
              lmbdown:=FALSE
            ENDIF

          CASE IDCMP_REFRESHWINDOW
            Gt_BeginRefresh(hauptwin)
            Gt_EndRefresh(hauptwin, TRUE)

        ENDSELECT
      ENDWHILE
    ENDIF

  UNTIL ((meineklasse=IDCMP_CLOSEWINDOW) AND (portKey AND hauptwin))

  ClearMenuStrip(hauptwin)
  FreeMenus(menu)
  CloseWindow(hauptwin)
  IF nebenwin THEN CloseWindow(nebenwin)
  IF gadgetliste THEN FreeGadgets(gadgetliste)
  FreeVisualInfo(vinfo)
  UnlockPubScreen(NIL,pscreen)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  FreeMem(meineintmessage, SIZEOF intuimessage)
  WriteF('Einen schönen Tag noch!\n')
  CleanUp(0)
EXCEPT
  IF hauptwin THEN ClearMenuStrip(hauptwin)
  IF menu THEN FreeMenus(menu)
  IF vinfo THEN FreeVisualInfo(vinfo)
  IF(hauptwin) THEN CloseWindow(hauptwin)
  IF nebenwin THEN CloseWindow(nebenwin)
  IF gadgetliste THEN FreeGadgets(gadgetliste)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  WriteF('Fehler Nummer \d\n',exception)
  CleanUp(20)

ENDPROC


PROC handle_menus(code)
DEF titel,item,subitem,gadnummer,zkette[50]:STRING,fenster:PTR TO window,
    laufvar

  titel := (code AND %11111) /* Bits 0-4 */
  item := ((code/32) AND %111111) /* Bits 5-11 */
  subitem := ((code/2048) AND %11111) /* Bits 11-15 */

  IF (code < 65535)
    SELECT titel
      CASE 1
        SELECT item
          CASE 0
            NOP
          CASE 1
            NOP
          CASE 2
            NOP
          CASE 3
            NOP
        ENDSELECT
    ENDSELECT
  ENDIF
ENDPROC


PROC kopiere_intmessage(i1,i2)
/* kopiert die inhalte von i1 nach i2 */
DEF int1:PTR TO intuimessage,int2:PTR TO intuimessage

  int1 := i1
  int2 := i2

/*
  int2.execmessage := int1.execmessage
*/
  int2.class := int1.class
  int2.code := int1.code
  int2.class := int1.class
  int2.qualifier := int1.qualifier
  int2.iaddress := int1.iaddress
  int2.mousex := int1.mousex
  int2.mousey := int1.mousey
  int2.seconds := int1.seconds
  int2.micros := int1.micros
  int2.idcmpwindow := int1.idcmpwindow
  int2.speciallink := int1.speciallink

ENDPROC

PROC tete(win:PTR TO window, zkette, x_start,y_start, x_end,y_end)
DEF zaehler

  FOR zaehler := x_start TO x_end
    Move(win.rport,zaehler,y_start)
    SetAPen(win.rport,1)
    Text(win.rport,zkette, StrLen(zkette))
    WaitTOF()
    SetAPen(win.rport,0)
    Text(win.rport,zkette, StrLen(zkette))
  ENDFOR

ENDPROC

