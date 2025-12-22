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

DEF winlist: PTR TO wininfolist, /* liste liées des fenêtres       */
    menuptr = NIL: PTR TO menu,  /* menus construit par GadTools   */
    scr = NIL,                   /* pointer sur l'écran par défaut */
    visual = NIL                 /* pointer sur VisualInfo         */

/* Affiche une erreur en utilisant EasyRequest */
PROC errmsg(msgptr)
  EasyRequestArgs(0, [20, 0, 'Erreur', msgptr, 'OK'], 0, 0)
ENDPROC

/* Ouvre une nouvelle fenêtre */
PROC openwin()
  DEF wi: PTR TO wininfo, w: PTR TO window,
      success = FALSE

  /* Prend un peu de mémoire pour les noeuds */
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
       WA_SCREENTITLE, 'Exemple de Multi-dfenêtre par David Higginson',
       NIL, NIL])) = NIL
      errmsg('Ne peut pas ouvrir de fenêtre.')
      Dispose(wi)
    ELSE
      IF SetMenuStrip(w, menuptr)
        wi.winptr := w
        success := TRUE
      ELSE
        CloseWindow(w)
        Dispose(wi)
        errmsg('Ne peut pas attacher de menus à la fenêtre.')
      ENDIF
    ENDIF
  ELSE
    errmsg('Plus de mémoire.')
  ENDIF

  /* Fait y le lien */
  IF success THEN AddHead(winlist, wi)
  /* N.B. Les nouveaux noeuds DOIVENT être attachés à la tte (head) de la liste */
ENDPROC success

PROC cm_new()
  IF openwin() = FALSE THEN errmsg('Ne peut pas ouvrir la fenêtre.')
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

/* Prépare bibliothèques, écrans, menus */
PROC setup()
  /* Ouvre la gadtools.library */
  IF (gadtoolsbase := OpenLibrary('gadtools.library', 37)) = NIL THEN
    Raise(ER_NOGT)

  /* Prépare la liste pour prendre les infos des fenêtres */
  winlist := [0, 0, 0]
  winlist.head := Mul(winlist + 4,1)
  winlist.tailpred := winlist

  /* Prend l'écran par défaut et les visualinfo */
  IF (scr := LockPubScreen(NIL)) = NIL THEN Raise(ER_NOSCRN)
  IF (visual := GetVisualInfoA(scr, NIL)) = NIL THEN Raise(ER_NOVISUAL)

  /* Crée les menus */
  IF (menuptr := CreateMenusA([NM_TITLE, 0, 'Projet', 0, 0, 0, 0,
    NM_ITEM, 0, 'Nouveau...',           'N', 0, 0, CM_NEW,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Quitter',             'Q', 0, 0, CM_QUIT,
    NM_TITLE, 0, 'Fenêtre',           0 , 0, 0, 0,
    NM_ITEM, 0, 'Suivante',             ',', 0, 0, CM_NEXT,
    NM_ITEM, 0, 'Précédente',         '.', 0, 0, CM_PREV,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Zoom',             'Z', 0, 0, CM_ZOOM,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Mettre devant',   '>', 0, 0, CM_FRONT,
    NM_ITEM, 0, 'Mettre derrière',     '<', 0, 0, CM_BACK,
    NM_ITEM, 0, NM_BARLABEL,         0 , 0, 0, 0,
    NM_ITEM, 0, 'Fermer',            'K', 0, 0, CM_CLOSE,
    NM_END, 0, 0, 0, 0, 0, 0]:newmenu, NIL)) = NIL THEN Raise(ER_NOMENUS)

  IF LayoutMenusA(menuptr, visual, NIL) = FALSE THEN Raise(ER_NOMENUS)

  /* Ouvre la fenêtre initiale */
  IF openwin() = FALSE THEN Raise(ER_NOINITWIN)
ENDPROC

/* Attend les messages */
PROC eventloop()
  DEF quit = FALSE,
      msg: PTR TO intuimessage, class,
      sig, bitmask, recalc_bitmask = TRUE,
      close_this_win,
      wi: PTR TO wininfo, tempwi: PTR TO wininfo,
      w: PTR TO window, u: PTR TO mp,
      item: PTR TO menuitem, code, id

  REPEAT
    /* Recalcule le masque formé par les tous les sigbits OR */
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

    /* Attend que quelqchose se passe */
    sig := Wait(bitmask)

    /* maintenant teste tous les sigbits des fenetres */
    wi := winlist.head
    WHILE wi.succ
      tempwi := wi.succ
      w := wi.winptr
      u := w.userport
      IF sig AND Shl(1,u.sigbit)
        /* Message(s) reçue par cette fenêtre */

        close_this_win := FALSE

        WHILE u
          IF msg:=GetMsg(u)
            class := msg.class
            code := MENUNULL

            SELECT class

              CASE IDCMP_CLOSEWINDOW
                /* l'utilisateur à choisit le gadget de fermeture */
                /* Ne peut la fezrmer maintenant car le msgport disparaitrait */
                close_this_win := TRUE

              CASE IDCMP_MENUPICK
                code := msg.code

            ENDSELECT

            ReplyMsg(msg)

            /* Procède aux évèments menu après que le messages soit rendu (replied) */
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
            u := NIL /* Plus d'autre message */
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
  erlist := ['Ce program a besoin de la gadtools.library.',
             'Ne peut pas trouver l'écran public.',
             'Ne peut pas prendre les visual info pour l'écran.',
             'Ne peut pas créer les menus.',
             'Ne peut pas créer la fenêtre initiale.']
  IF exception>0 THEN errmsg(erlist[exception - 1])
ENDPROC
