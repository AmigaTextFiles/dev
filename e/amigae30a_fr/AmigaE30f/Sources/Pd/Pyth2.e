/*
**      C'est la version E de 'l'arbre de Pythagore'.
**      Ecrit par Raymond Hoving, Waardgracht 30, 2312 RP Leiden,
**      Pays-Bas.
**      E-mail address: hoving@stpc.wi.leidenuniv.nl
**      Nécessite Kickstart V3.0+ et le reqtools.library V38+
**      Date de création : Sun Jul 17 17:30:07 1994, Version: 2.0
*/

OPT     REG=5,OSVERSION=39      /* Kickstart 3.0+ only. */

MODULE  'intuition/intuition', 'intuition/screens', 'utility/tagitem',
        'reqtools', 'exec/ports', 'exec/libraries',
        'libraries/reqtools', 'graphics/modeid', 'graphics/text'

DEF     pythscreen=NIL : PTR TO screen,
        pythwindow=NIL : PTR TO window,
        pythidcmp=NIL : PTR TO mp,
        screenmodereq=NIL : PTR TO rtscreenmoderequester,
        scrwidth, scrheight, fontheight,
        winxsize, winysize, xbase, ybase, mbase,
        depth=1, mdepth=10,
        time0, time1

CONST   BORDERSIZE = 4

ENUM    MSG_READY, MSG_ABORT, ERROR_REQTLIB, ERROR_SCREEN,
        ERROR_WINDOW, ERROR_OOM

PROC    pythcleanup(errornumber)

        /* Cette procédure va désallouer tous les objets qui ont bien été
        ** alloués. Quand une erreur arrive, il sera dit à l'utilisateur.
        */

        IF pythwindow<>NIL THEN CloseWindow(pythwindow)
        IF pythscreen<>NIL THEN CloseScreen(pythscreen)
        IF screenmodereq<>NIL THEN RtFreeRequest(screenmodereq)
        IF reqtoolsbase<>NIL THEN CloseLibrary(reqtoolsbase)
        SELECT  errornumber
                CASE ERROR_OOM
                        WriteF('ERREUR: Plus de mémoire.\n')
                CASE ERROR_REQTLIB
                        WriteF('ERREUR: Ne peut pas ouvrir la reqtools.library.\n')
                CASE ERROR_SCREEN
                        WriteF('ERREUR: Ne peut pas ouvrir un nouvel écran.\n')
                CASE ERROR_WINDOW
                        WriteF('ERREUR: Ne peu pas ouvrir une nouvelle fenêtre.\n')
                CASE MSG_ABORT
                        WriteF('Ecriture annulée.\n')
                CASE MSG_READY
                        WriteF('J'ai juste tracé \d petite maison\s!\n',
                                Shl(1,mdepth)-1,
                                IF mdepth=1 THEN '' ELSE 's')
        ENDSELECT
        CleanUp(errornumber)    /* Appelle le nettoyeur standard E. */
ENDPROC

PROC    pythtree(a1,a2,b1,b2)

        /* cette procédure (récursivement appellée) tracera l'actuel arbre
        */

        DEF c1,c2,d1,d2,e1,e2,ci1,ci2,di1,di2
        IF GetMsg(pythidcmp)<>NIL THEN pythcleanup(MSG_ABORT)
        IF depth<=mdepth                /* Vérifie si on n'est pas trop profond. */
          INC depth                     /* Cette profondeur est encore permise. */
          SetAPen(stdrast,depth)        /* La couleur du tracé dépend de la profondeur. */
          c1 := !a1-a2+b2 ; ci1 := !c1!
          c2 := !a1+a2-b1 ; ci2 := !c2!
          d1 := !b1+b2-a2 ; di1 := !d1!
          d2 := !a1-b1+b2 ; di2 := !d2! /* Calculte toutes les */
          e1 := !0.5 * (!c1-c2+d1+d2)   /* coordonnées necéssaires. */
          e2 := !0.5 * (!c1+c2-d1+d2)
          /*
          **         e      Notez l'utilisation de ! entre les () dans les calculs de e1 et
          **        /\      e2. On utilisie quelques LONG en plus pour minimiser les convertions
          **       /  \
          **     c+----+d   Les coordonées de c,d et e sont calculés à partir des coordonnées
          **      |    |    de a et b. L'algèbre linéaire, quel joie !
          **      |    |
          **     a+----+b
          */
          Move(stdrast,ci1,ci2)
          Draw(stdrast,!a1!,!a2!)
          Draw(stdrast,!b1!,!b2!)
          Draw(stdrast,di1,di2)
          Draw(stdrast,ci1,ci2)
          Draw(stdrast,!e1!,!e2!)
          Draw(stdrast,di1,di2)         /* Trace la petite maison. */
          IF Rnd(2) = 0                 /* Fait la croissance un   */
            pythtree(c1,c2,e1,e2)       /* peu plus interessant.   */
            pythtree(e1,e2,d1,d2)
          ELSE
            pythtree(e1,e2,d1,d2)
            pythtree(c1,c2,e1,e2)
          ENDIF
          DEC depth                     /* Prêt avec cette branche. */
        ENDIF
ENDPROC

PROC    main()

        DEF a1,a2,b1,b2

        /* Ouvre la reqtools.library et alloue la mémoire pour le strucuure des requesters.
        */

        IF (reqtoolsbase := OpenLibrary('reqtools.library',38)) = NIL THEN
          pythcleanup(ERROR_REQTLIB)

        IF (screenmodereq := RtAllocRequestA(RT_SCREENMODEREQ,NIL)) = NIL THEN
          pythcleanup(ERROR_OOM)

        /* Laisse l'utilisateur décider quel mode écran il veut. Notez que
        ** l'arbre est le mieux sur un écran qui a approximativement le même
        ** nombre de pixels dans les 2 directions, comme 640x512.
        */

        IF RtScreenModeRequestA(screenmodereq,'Arbre de Pythagore', [
          RTSC_FLAGS,SCREQF_OVERSCANGAD OR SCREQF_AUTOSCROLLGAD OR SCREQF_SIZEGADS,
          RTSC_MINWIDTH,100,
          RTSC_MINHEIGHT,100,
          TAG_DONE]) = FALSE THEN pythcleanup(MSG_ABORT)

        /* Puis demande la profondeur maximum de récursion.
        */

        IF (RtGetLongA({mdepth},'Arbre de Pythagore',NIL, [
          RTGL_MIN,1,
          RTGL_MAX,14,
          RTGL_TEXTFMT,'Entrez la profondeur maximum de l\aarbre :',
          RT_WINDOW,pythwindow,
          TAG_DONE])) = FALSE THEN pythcleanup(MSG_ABORT)

        /* Prend les données importantes de la structure d'écran.
        */

        scrwidth := screenmodereq.displaywidth
        scrheight := screenmodereq.displayheight

        /* Ouvre l'écran que l'utilisteur voulait.
        */

        IF (pythscreen := OpenScreenTagList(NIL, [
          SA_DEPTH,4,
          SA_TYPE,CUSTOMSCREEN,
          SA_DISPLAYID,screenmodereq.displayid,
          SA_WIDTH,scrwidth,
          SA_HEIGHT,scrheight,
          SA_TITLE,'Screen of Pythagoras',
          TAG_DONE])) = NIL THEN pythcleanup(ERROR_SCREEN)

        /* Maintenant ouvre un écran de remplissage sur l'écran qui vient d'être ouvert.
        */

        IF (pythwindow:=OpenWindowTagList(NIL, [
          WA_WIDTH,scrwidth,
          WA_HEIGHT,scrheight,
          WA_IDCMP,IDCMP_CLOSEWINDOW,
          WA_FLAGS,WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
          WA_TITLE,'Arbre de Pythagore par Raymond Hoving',
          WA_CUSTOMSCREEN,pythscreen,
          TAG_DONE])) = NIL THEN pythcleanup(ERROR_WINDOW)

        /* Prend quelques données utiles de la structure fenêtre.
        */

        stdrast := pythwindow.rport
        pythidcmp := pythwindow.userport
        fontheight := pythwindow.ifont::textfont.ysize

        /* Fixe la palette pour cet écran (marron à vert).
        */

        LoadRGB4(ViewPortAddress(pythwindow), [
          $000,$89a,$640,$752,$762,$771,$781,$680,$580,$080,
          $090,$0a0,$0b0,$0c0,$0d0,$0e0] : INT, 16)


        /* Contruit un seuil 'au hasard' à partir de l'heure
        */

        CurrentTime({time0},{time1})
        Rnd(-Abs(Eor(time0,time1)))

        /* Calcule la taille possible de l'arbre sur cet écran.
        */

        winxsize := scrwidth - (2 * BORDERSIZE)
        winysize := scrheight - (6 * BORDERSIZE + fontheight)
        xbase := winxsize! / 12.2       /* Diviseur touvé par trial et erreur. */
        ybase := winysize! / 8.0        /* Celui-ci est bon.                   */
        IF !xbase < ybase THEN mbase := xbase ELSE mbase := ybase
        a1 := scrwidth! / 2.0 - mbase
        b1 := scrwidth! / 2.0 + mbase
        a2 := scrheight - (4 * BORDERSIZE)!
        b2 := a2

        /* Met le busy pointer et comence à tracer.
        */

        SetWindowPointerA(pythwindow,[WA_BUSYPOINTER,TRUE,TAG_DONE])
        pythtree(a1,a2,b1,b2)
        SetWindowPointerA(pythwindow,TAG_DONE)

        /* Prêt ! Attend que l'utilisateur ferme l'écran.
        */

        WaitPort(pythidcmp)
        pythcleanup(MSG_READY)
ENDPROC
