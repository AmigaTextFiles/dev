/* blockinput.e (de la page 207 du livre sur les bibliothèques, modifié pour le
 * E par Trey Van Riper [jvanriper@uncavx.unca.edu])
 */

/* blockinput.e -- programme pour demonstrer comment bloquer les entrées d'une
 * fenêtre en utilisant les requêtes, et comment affichier un busy pointer.
 */

OPT OSVERSION=37

MODULE 'exec/types','intuition/intuition','exec/ports','exec/memory',
       'utility/tagitem'

/*
 * Autant que je sache, le E ne vous llaisse pas mettre des données directement
 * dans la mémoire Chip, donc vous devez les CopyMem de la mémoire Fast.  Donc....
 */

DEF chippointer

/*
 * beginWait()
 *
 * Efface la requête avec InitRequester. Ca met la requête  avec une margeur=0
 * hauteur = 0, gauche = 0, haut = 0; en fait, tout est à zéro.
 * Cette requête va simplement bloquer les entrées à la fenêtre tant que EndResques
 * n'ets pas appelé.
 *
 * Le pointeur est mis sur un busy pointer de 4 couleurs, avec de bons offsets.
 */

PROC beginWait(win, waitRequest)

 InitRequester(waitRequest)
 IF Request(waitRequest, win)
  SetPointer(win,chippointer, 16, 16, -6, 0)
  SetWindowTitles(win,'Busy - Input Blocked', Not(0))
  RETURN TRUE
 ELSE
  RETURN FALSE
 ENDIF

ENDPROC

/*
 * endWait()
 *
 * Routine pour remettre à zéro le pointeur au défaut système, et enlève la
 * requête installée avec beginWait().
 */

PROC endWait(win, waitRequest)

 ClearPointer(win)
 EndRequest(waitRequest, win)
 SetWindowTitles(win,'Not Busy', Not(0))


ENDPROC

/*
 * processIDCMP()
 *
 * Attend que l'utilisateur ferme la fenêtre.
 */

PROC processIDCMP (wintmp)

 DEF done, msg:PTR TO intuimessage, class, myreq:requester, tick_count,
     temp:PTR TO mp,win:PTR TO window

 done:=FALSE
 win:=wintmp
 IF beginWait(win, myreq)
  /*
   * Insérer du code ici pour qu'une fenêtre agissent sur la requête.
   */

  /* On compte à rebours les INTUITICKS, qui viennet environ toutes les
   * 1/10 de secondes.  On garde le busy pointeur pour environ 3 secondes.
   */
   tick_count := 30
 ENDIF
 temp := win.userport
 WHILE Not(done)
  Wait(Shl(1,temp.sigbit))
  WHILE NIL <> (msg := GetMsg(win.userport))
   class := msg.class
   ReplyMsg(msg)
   SELECT class
    CASE IDCMP_CLOSEWINDOW
     done := TRUE
    CASE IDCMP_INTUITICKS
     IF tick_count>0
      DEC tick_count
      IF tick_count = 0 THEN endWait(win,myreq)
     ENDIF
   ENDSELECT
  ENDWHILE
 ENDWHILE
ENDPROC

PROC main()
 DEF win:PTR TO window,waitpointer

waitpointer:=[$0000, $0000,

              $0400, $07C0,
              $0000, $07C0,
              $0100, $0380,
              $0000, $07E0,
              $07C0, $1FF8,
              $1FF0, $3FEC,
              $3FF8, $7FDE,
              $3FF8, $7FBE,
              $7FFC, $FF7F,
              $7EFC, $FFFF,
              $7FFC, $FFFF,
              $3FF8, $7FFE,
              $3FF8, $7FFE,
              $1FF0, $3FFC,
              $07C0, $1FF8,
              $0000, $07E0,

              $0000, $0000]:INT

IF chippointer:=AllocVec(72,MEMF_CHIP)
 CopyMemQuick(waitpointer,chippointer,72)
ENDIF

 IF win:=OpenWindowTagList(NIL,
                   [WA_IDCMP,IDCMP_CLOSEWINDOW OR IDCMP_INTUITICKS,
                   WA_ACTIVATE, TRUE,
                   WA_WIDTH, 320,
                   WA_HEIGHT, 100,
                   WA_CLOSEGADGET, TRUE,
                   WA_DRAGBAR, TRUE,
                   WA_DEPTHGADGET, TRUE,
                   WA_SIZEGADGET, TRUE,
                   WA_MAXWIDTH, Not(0),
                   WA_MAXHEIGHT, Not(0)])
 processIDCMP(win)
 CloseWindow(win)
 ENDIF

IF chippointer THEN FreeVec(chippointer)

ENDPROC
