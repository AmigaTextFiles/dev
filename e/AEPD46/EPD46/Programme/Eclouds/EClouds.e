/*******************************************
 *  EClouds v1.0a, displays a 28-colors    *
 *  LoRes (129x129) Cloud-Graphic (like    *
 *  all these Plasma- and Cloud-programs)  *
 *  Thanx to Danny Amor 4 the information  *
 *                                         *
 *  OS2.0+ needed!                         *
 *  Public Domain by Hanns Holger Rutz     *
 *******************************************/

OPT OSVERSION = 36,
    DIR       = 'AmigaE:modules/'

MODULE 'dos/dos',
       'dos/dosextens',
       'dos/rdargs',
       'exec/ports',
       'graphics/displayinfo',
       'graphics/gfxbase',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'utility/tagitem'

/* Konstanten */

CONST CLOW    = 4,          /* unterste Farbe für Wolken */
      CHIGH   = 31,         /* oberste Farbe für Wolken */
      CNUM    = 28,         /* Anzahl der Wolken-Farben */
      PLEFT   = 95,         /* linke, */
      PTOP    = 36,         /* obere und */
      PRIGHT  = 223,        /* rechte, */
      PBOTTOM = 164,        /* untere Ecke der Graphik */
      PWIDTH  = 128,        /* Breite-1 und */
      PHEIGHT = 128,        /* Höhe-1 der Graphik */
/* not that nice
      SMODIFY = -$60,
      BMODIFY = -$30,
      SINIT   = $400,
      BINIT   = $200
*/
      SMODIFY = -$60,   /* wird bei Rekursion zu schwank addiert */
      BMODIFY = -$30,   /*   dies zu balance */
      SINIT   = $800,   /* Startwert für schwank */
      BINIT   = $400    /*   und balance */

/* globale Variablen */

DEF myRast    : rastport,
    myPort    : mp,
    oldRnd    : LONG,       /* alter Random-Wert */
    myArgs[4] : ARRAY OF LONG,
    smodify   : LONG,
    bmodify   : LONG,
    sinit     : LONG,
    binit     : LONG,
    myScr     : screen,
    myWin     : window

/* Hauptprogramm */

PROC main()

    DEF myGfx     : gfxbase,
        myFont    : textattr,
        myTask    : process,
        oldWin    : window,
        rdArgs    : rdargs,
        rc        : LONG

    myFont.name  := 'topaz.font'
    myFont.ysize := 8
    myFont.style := FS_NORMAL
    myFont.flags := FPF_ROMFONT+FPF_DESIGNED
    myGfx        := gfxbase;
    rc           := RETURN_FAIL
    myTask       := FindTask( NIL )
    myWin        := NIL

    sinit := SINIT; binit := BINIT; smodify := SMODIFY; bmodify := BMODIFY
    random( $ffff ) /* initialisieren */

    IF wbmessage = NIL

        IF ( rdArgs := ReadArgs( 'SINIT/K/N,BINIT/K/N,SMODIFY/K/N,BMODIFY/K/N',
            myArgs, NIL )) = FALSE

            printMsg( 'Usage:  EClouds [SInit <Val>] [BInit <Val>] [SModify] <Val> '+
                '[BModify] <Val>\n\nUsing defaults...\n', NIL )

        ELSE

            IF myArgs[0] THEN sinit   := Long( myArgs[0] )
            IF myArgs[1] THEN binit   := Long( myArgs[1] )
            IF myArgs[2] THEN smodify := Long( myArgs[2] )
            IF myArgs[3] THEN bmodify := Long( myArgs[3] )

        ENDIF

    ENDIF

    IF ( myScr := OpenScreenTagList( NIL, [SA_LEFT,
        (myGfx.normaldisplaycolumns/2-320)/2, SA_WIDTH,320, SA_HEIGHT,200, SA_DEPTH,5,
        SA_TYPE,CUSTOMSCREEN, SA_FONT, myFont, SA_TITLE,'EClouds Screen',
        SA_DISPLAYID,DEFAULT_MONITOR_ID+LORES_KEY, SA_PENS,[-1], SA_COLORS,{myColors},
        TAG_DONE] ))

        IF ( myWin := OpenWindowTagList( NIL, [WA_LEFT,0, WA_TOP,11, WA_WIDTH,320,
            WA_HEIGHT,189, WA_IDCMP,IDCMP_CLOSEWINDOW, WA_TITLE,'<< Click here to '+
            'quit', WA_CUSTOMSCREEN,myScr, WA_CLOSEGADGET,TRUE, WA_BACKDROP,TRUE,
            WA_NOCAREREFRESH,TRUE, WA_SMARTREFRESH,TRUE, WA_ACTIVATE,TRUE, WA_RMBTRAP,
            TRUE, WA_SCREENTITLE,'EClouds -- P.D. by Hanns Holger Rutz', TAG_DONE] ))

            myRast := myWin.rport; myPort := myWin.userport
            oldWin := myTask.windowptr; myTask.windowptr := myWin
            drawCloud()
            myTask.windowptr := oldWin
            CloseWindow( myWin )
            rc := RETURN_OK

        ELSE

            printMsg( 'Unable to open window!\n', NIL )

        ENDIF

        CloseScreen( myScr )

    ELSE

        printMsg( 'Unable to open screen!\n', NIL )

    ENDIF

ENDPROC( rc )

/* Message in der Shell bzw. in Requester (WB-Start) ausgeben */

PROC printMsg( text, args )

    DEF myReq : easystruct

    IF wbmessage

        myReq.structsize   := SIZEOF easystruct
        myReq.flags        := 0
        myReq.title        := 'EClouds Message'
        myReq.textformat   := text
        myReq.gadgetformat := 'Okay'

        EasyRequestArgs( myWin, myReq, NIL, args )

    ELSE

        Vprintf( text, args )

    ENDIF

ENDPROC

/* Zufallszahl erzeugen */

PROC random( max )

    DEF secs, mics : LONG

    CurrentTime( {secs}, {mics} )
    oldRnd := Eor( oldRnd, mics ) AND $7fff

ENDPROC oldRnd/($7fff/max)

/* Punkt zeichnen */

PROC pset( x, y, color )

    IF color > CHIGH THEN color := CHIGH
    IF color < CLOW  THEN color := CLOW
    SetAPen( myRast, color ); WritePixel( myRast, x, y )

ENDPROC

/* Punktfarbe lesen */

PROC pget( x, y )

    IF ( x >= PLEFT ) AND ( x <= PRIGHT ) AND ( y >= PTOP ) AND ( y <= PBOTTOM )

        RETURN ReadPixel( myRast, x, y )

    ENDIF

ENDPROC 0

/* Cloud zeichnen */

PROC drawCloud() HANDLE

    pset( PLEFT,  PTOP,    random( CNUM )+CLOW )
    pset( PRIGHT, PTOP,    random( CNUM )+CLOW )
    pset( PRIGHT, PBOTTOM, random( CNUM )+CLOW )
    pset( PLEFT,  PBOTTOM, random( CNUM )+CLOW )

    printMsg( 'SInit=%ld; BInit=%ld;\nSModify=%ld; BModify=%ld;\n',[sinit,binit,
        smodify, bmodify])

    rect( PLEFT, PTOP, PWIDTH, sinit, binit )
    WaitPort( myPort )

EXCEPT
    /* called, when CloseGadget's hit */
ENDPROC

/* 4 Eckepunkte zeichnen und diese Routine rekursiv 4x aufrufen */

PROC rect( x, y, width, schwank, balance )

    DEF s2,b2 : LONG,
        msg   : mn

    s2 := Shr( schwank, 8 ); b2 := Shr( balance, 8 )

/*  pcalc( x,       y,       width, s2, b2 )  */
    pcalc( x+width, y,       width, s2, b2 )
    pcalc( x,       y+width, width, s2, b2 )
    pcalc( x+width, y+width, width, s2, b2 )

    IF ( width := Shr( width, 1 ))

        schwank := schwank+smodify; balance := balance+bmodify

        rect( x,       y,       width, schwank, balance )
        rect( x+width, y,       width, schwank, balance )
        rect( x,       y+width, width, schwank, balance )
        rect( x+width, y+width, width, schwank, balance )

        IF (msg := GetMsg( myPort ))
            ReplyMsg( msg ); Raise( 0 )
        ENDIF

    ENDIF

ENDPROC

/* Farbe eines Punktes berechnen und ihn setzen */

PROC pcalc( x, y, width, schwank, balance )

    DEF f1,f2,f3,f4,num : LONG

    IF pget( x, y ) = 0

        num := 0
        IF ( f1 := pget( x-width, y       )) THEN INC num
        IF ( f2 := pget( x,       y-width )) THEN INC num
        IF ( f3 := pget( x+width, y       )) THEN INC num
        IF ( f4 := pget( x,       y+width )) THEN INC num
        pset( x, y, (f1+f2+f3+f4)/num+random( schwank+1 )-balance )

    ENDIF

ENDPROC

/* ARRAY OF colorspec; Farben des Screens */

myColors:

/* this one's not that nice
    INT  4,$f,$f,$f,  5,$e,$f,$f,  6,$e,$e,$f,  7,$d,$e,$f,  8,$d,$d,$f,  9,$c,$d,$f
    INT 10,$c,$c,$f, 11,$b,$c,$f, 12,$b,$b,$f, 13,$a,$b,$f, 14,$9,$a,$f, 15,$9,$9,$f
    INT 16,$8,$9,$f, 17,$8,$8,$f, 18,$7,$8,$f, 19,$7,$7,$f, 20,$6,$7,$f, 21,$6,$6,$f
    INT 22,$5,$6,$f, 23,$5,$5,$f, 24,$4,$5,$f, 25,$3,$4,$f, 26,$3,$3,$f, 27,$2,$3,$f
    INT 28,$2,$2,$f, 29,$1,$2,$f, 30,$1,$1,$f, 31,$0,$0,$f, -1
*/
    INT  4,$F,$F,$F,  5,$D,$E,$F,  6,$C,$E,$F,  7,$C,$D,$F,  8,$C,$D,$E,  9,$B,$D,$E
    INT 10,$B,$D,$E, 11,$B,$C,$E, 12,$A,$C,$E, 13,$A,$C,$E, 14,$A,$B,$E, 15,$A,$B,$D
    INT 16,$9,$B,$D, 17,$9,$B,$D, 18,$9,$A,$D, 19,$8,$A,$D, 20,$8,$A,$D, 21,$8,$A,$C
    INT 22,$8,$9,$C, 23,$7,$9,$C, 24,$7,$9,$C, 25,$7,$8,$C, 26,$6,$8,$C, 27,$6,$8,$C
    INT 28,$6,$8,$B, 29,$6,$7,$B, 30,$5,$7,$B, 31,$5,$7,$B, -1
