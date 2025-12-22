MODULE 'exec/nodes', 'exec/ports',
       'intuition/intuition',
       'gadtools', 'libraries/gadtools'

ENUM ER_NONE, ER_NOGT, ER_NOSCRN, ER_NOVISUAL, ER_NOMENUS, ER_NOINITWIN

ENUM CM_NONE,
     CM_NEW, CM_QUIT,
     CM_NEXT, CM_PREV, CM_ZOOM, CM_BACK, CM_FRONT, CM_CLOSE

OBJECT wininfolist
  head:     LONG
  tail:     LONG
  tailpred: LONG
ENDOBJECT

OBJECT wininfo
  succ:     LONG
  pred:     LONG
  winptr:   LONG
ENDOBJECT

DEF winlist: PTR TO wininfolist, /* linked list of windows    */
    menuptr = NIL: PTR TO menu,  /* menus built by GadTools   */
    scr = NIL,                   /* pointer to default screen */
    visual = NIL                 /* pointer to VisualInfo     */

/* Display an error using an EasyRequest */
PROC errmsg(msgptr)
  EasyRequestArgs(0, [20, 0, 'Error', msgptr, 'OK'], 0, 0)
ENDPROC

/* Open a new window */
PROC openwin()
  DEF wi: PTR TO wininfo, w: PTR TO window,
      success = FALSE

  /* Get some memory for the node */
  wi := New(SIZEOF wininfo)

  IF wi
    IF (w := OpenWindowTagList(NIL,
      [WA_LEFT, Rnd(300), WA_TOP, Rnd(100),
       WA_WIDTH,    340, WA_HEIGHT,    156,
       WA_MINWIDTH, 160, WA_MINHEIGHT,  70,
       WA_MAXWIDTH,  -1, WA_MAXHEIGHT,  -1,
       WA_TITLE, 'A window',
       WA_FLAGS, WFLG_SIMPLE_REFRESH OR WFLG_ACTIVATE OR WFLG_DRAGBAR OR
                 WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR WFLG_SIZEGADGET,
       WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_MENUPICK,
       WA_SCREENTITLE, 'Multi-Windows Example by David Higginson',
       NIL, NIL])) = NIL 
      errmsg('Could not open window.')
      Dispose(wi)
    ELSE
      IF SetMenuStrip(w, menuptr)
        wi.winptr := w
        success := TRUE
      ELSE
        CloseWindow(w)
        Dispose(wi)
        errmsg('Could not attach menus to new window.')
      ENDIF
    ENDIF
  ELSE
    errmsg('Out of memory.')
  ENDIF

  /* Link it in */
  IF success THEN AddHead(winlist, wi)
  /* N.B. New nodes MUST be added at head of list */
ENDPROC success

PROC cm_new()
  IF openwin() = FALSE THEN errmsg('Could not open window.')
ENDPROC

PROC cm_next(wi: PTR TO wininfo)
  wi := wi.succ
  IF wi.succ = FALSE THEN wi := winlist.head
  IF wi.succ THEN ActivateWindow(wi.winptr)
ENDPROC

PROC cm_prev(wi: PTR TO wininfo)
  wi := wi.pred
  IF wi.pred = FALSE THEN wi := winlist.tailpred
  IF wi.pred THEN ActivateWindow(wi.winptr)
ENDPROC

/* Set up libraries, screens, menus */
PROC setup()
  /* Open gadtools library */
  IF (gadtoolsbase := OpenLibrary('gadtools.library', 37)) = NIL THEN
    Raise(ER_NOGT)

  /* Set up exec list to hold window information */
  winlist := [0, 0, 0]
  winlist.head := Mul(winlist + 4,1)
  winlist.tailpred := winlist

  /* Get default screen and visualinfo info */
  IF (scr := LockPubScreen(NIL)) = NIL THEN Raise(ER_NOSCRN)
  IF (visual := GetVisualInfoA(scr, NIL)) = NIL THEN Raise(ER_NOVISUAL)

  /* Create menus */
  IF (menuptr := CreateMenusA([NM_TITLE, 0, 'Project', 0, 0, 0, 0,
    NM_ITEM, 0, 'New...',           'N', 0, 0, CM_NEW,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Quit',             'Q', 0, 0, CM_QUIT,
    NM_TITLE, 0, 'Window',           0 , 0, 0, 0,
    NM_ITEM, 0, 'Next',             ',', 0, 0, CM_NEXT,
    NM_ITEM, 0, 'Previous',         '.', 0, 0, CM_PREV,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Zoom',             'Z', 0, 0, CM_ZOOM,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Bring to front',   '>', 0, 0, CM_FRONT,
    NM_ITEM, 0, 'Send to back',     '<', 0, 0, CM_BACK,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Close',            'K', 0, 0, CM_CLOSE,
    NM_END, 0, 0, 0, 0, 0, 0]:newmenu, NIL)) = NIL THEN Raise(ER_NOMENUS)

  IF LayoutMenusA(menuptr, visual, NIL) = FALSE THEN Raise(ER_NOMENUS)

  /* Open initial window */
  IF openwin() = FALSE THEN Raise(ER_NOINITWIN)
ENDPROC

/* Wait for messages */
PROC eventloop()
  DEF quit = FALSE,
      msg: PTR TO intuimessage, class,
      sig, bitmask, recalc_bitmask = TRUE,
      close_this_win,
      wi: PTR TO wininfo, tempwi: PTR TO wininfo,
      w: PTR TO window, u: PTR TO mp,
      item: PTR TO menuitem, code, id

  REPEAT
    /* Recalculate mask formed by ORing all sigbits */
    IF recalc_bitmask
      bitmask := 0
      wi := winlist.head
      WHILE wi.succ
        w := wi.winptr
        u := w.userport
        bitmask := bitmask OR Shl(1,u.sigbit)
        wi := wi.succ
      ENDWHILE
    ENDIF

    /* Wait for something to happen */
    sig := Wait(bitmask)

    /* Now test all windows' sigbits */
    wi := winlist.head
    WHILE wi.succ
      tempwi := wi.succ
      w := wi.winptr
      u := w.userport
      IF sig AND Shl(1,u.sigbit)
        /* Message(s) received from this window */

        close_this_win := FALSE

        WHILE u
          IF msg:=GetMsg(u)
            class := msg.class
            code := MENUNULL

            SELECT class

              CASE IDCMP_CLOSEWINDOW
                /* User selected close gadget */
                /* Can't close yet because msgport would disappear */
                close_this_win := TRUE

              CASE IDCMP_MENUPICK
                code := msg.code

            ENDSELECT

            ReplyMsg(msg)

            /* Process menu events after messaged replied */
            WHILE code <> MENUNULL
              item := ItemAddress(menuptr, code)
              IF item
                id := Long(item + 34)
                SELECT id
                  CASE CM_NEW;    cm_new()
                  CASE CM_QUIT;   quit := TRUE
                  CASE CM_NEXT;   cm_next(wi)
                  CASE CM_PREV;   cm_prev(wi)
                  CASE CM_ZOOM;   IF w THEN ZipWindow(w)
                  CASE CM_FRONT;  IF w THEN WindowToFront(w)
                  CASE CM_BACK;   IF w THEN WindowToBack(w)
                  CASE CM_CLOSE;  close_this_win := TRUE
                ENDSELECT
                code := item.nextselect
              ELSE
                code := MENUNULL
              ENDIF
            ENDWHILE

            IF close_this_win
              recalc_bitmask := TRUE

              ClearMenuStrip(w)
              CloseWindow(w)
              Remove(wi)
              Dispose(wi)
            
              IF winlist.tailpred = winlist THEN quit := TRUE
              u := NIL

            ENDIF
          ELSE
            u := NIL /* No more messages */
          ENDIF        
        ENDWHILE
      ENDIF
      
      wi := tempwi

    ENDWHILE

  UNTIL quit
ENDPROC

PROC shutdown()
  DEF wi: PTR TO wininfo
  WHILE wi := RemTail(winlist)
    ClearMenuStrip(wi.winptr)
    CloseWindow(wi.winptr)
    Dispose(wi)
  ENDWHILE
  FreeMenus(menuptr)
  FreeVisualInfo(visual)
  UnlockPubScreen(scr, NIL)
  CloseLibrary(gadtoolsbase)
ENDPROC
  
PROC main() HANDLE
  DEF erlist:PTR TO LONG
  setup()
  eventloop()
  Raise(ER_NONE)
EXCEPT
  shutdown()
  erlist := ['This program requires gadtools library.',
             'Could not find default public screen.',
             'Could not get visual info for screen.',
             'Could not create menus.',
             'Could not create initial window.']
  IF exception>0 THEN errmsg(erlist[exception - 1])
ENDPROC
