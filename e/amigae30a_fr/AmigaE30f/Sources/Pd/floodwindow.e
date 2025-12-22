/*
    floodwindow.e

    Une procédure qui remplira les bordures de chaque fenêtre dans n'importe quelle couleur
    plus un code 'wrapper' montrant comment ça marche.

    IMPORTANT :     Si vous voulez connaître la hauteur de la barre de titre _avant_
                    d'ouvrir la fenêtre, c'est à dire dans le cas de font proportionnelle, vous devez
                    utiliser
                    DEF              screen:PTR TO screen,
                                     font:PTR TO textattr
                    screenfont:=     screen.font
                    titlebarheight:= screen.wbortop+font.ysize+1

    Quand   Qui     Quoi
    ------- ------- ---------------------------------------------------------
    4/3/94  UWP!    Tout !

*/

MODULE  'intuition/screens','exec/lists','exec/nodes',
        'intuition/intuition',
        'intuition/screens','intuition/gadgetclass','graphics/text'

PROC    main()
DEF     screen:PTR TO screen, window:PTR TO window,class,
        imess:PTR TO intuimessage, quit

    screen:=(LockPubScreen(NIL))   /* pas de vérification, j'assume que vous avez le WB :) */
    window:=OpenWindowTagList(NIL,[ WA_TOP,         screen.height/2,
                                    WA_LEFT,        screen.width/2,
                                    WA_INNERWIDTH,  screen.width/4,
                                    WA_INNERHEIGHT, screen.height/2,
                                    WA_CLOSEGADGET, TRUE,
                                    WA_DRAGBAR,     TRUE,
                                    WA_DEPTHGADGET, TRUE,
                                    WA_SIZEBBOTTOM, TRUE, /* modifiez ça */
                                    WA_SIZEGADGET,  TRUE,
                                    WA_MINHEIGHT,   100,
                                    WA_MINWIDTH,    50,
                                    WA_MAXHEIGHT,   -1,
                                    WA_MAXWIDTH,    -1,
                                    WA_IDCMP,       IDCMP_CLOSEWINDOW OR
                                                    IDCMP_CHANGEWINDOW,
                                    WA_TITLE,       'Utilisez moi! Abusez de moi!',
                                    0,0]) /* NB: pas de vérification ici non plus :<*/

    floodwindow(window,3)

    quit:=FALSE
    WHILE quit=FALSE
        class:=NIL
        IF  imess:=GetMsg(window.userport)
            class:=imess.class
            IF  class=IDCMP_CHANGEWINDOW
                floodwindow(window,3)
            ENDIF
            IF  class=IDCMP_CLOSEWINDOW
                quit:=TRUE
            ENDIF
            ReplyMsg(imess)
        ELSE
            WaitPort(window.userport)
        ENDIF
    ENDWHILE

    CloseWindow(window)
    UnlockPubScreen(NIL,screen)

ENDPROC

PROC    floodwindow(window:PTR TO window,colour)

    SetAPen(window.rport,colour)
    RectFill(window.rport,  window.borderleft,
                            window.bordertop,
                            window.width-window.borderright-1,
                            window.height-window.borderbottom-1)

ENDPROC
