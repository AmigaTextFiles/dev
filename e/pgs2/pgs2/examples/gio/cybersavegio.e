/*  $VER: cybergfx.gio 0.004 (16 Mar 1996)

    cybergraphics saver - © Dominique Dutoit 1996

    Saver for Photogenics
    Photogenics © Almathera 1994, All Rights Reserved

    REQUIRES: AmigaE 3.2 or higher.

    $HISTORY:

    16 Mar 1996 : 000.004 :  Correct screen movements.
    11 Feb 1996 : 000.003 :  Center image on screen.
    11 Feb 1996 : 000.002 :  Background is black.
    11 Feb 1996 : 000.001 :  First version heavely based on the Cybergraphics saver one.
*/
    LIBRARY 'CyberGFX.gio',1,1,'CyberGraphics saver' IS
            gioInfo, gioExamine, gioRead, gioWrite, gioSavePrefs, gioCleanUp,
            gioAbout, gioStartup, gioShutDown, gioLoadPrefs

    MODULE 'exec/types',
           'dos/dos',
           'cybergraphics',
           'cybergraphics/cybergraphics',
           'intuition',
           'intuition/intuition',
           'intuition/screens',
           'graphics',
           'utility/tagitem',
           'pgs',
           'gio',
           'photogenics/gio',
           'devices/inputevent'

DEF cybergfxbase
CONST C_FALSE = -1

PROC gioInfo() IS GIOF_SAVER24 OR GIOF_EXTENDED
PROC gioCleanUp(g:PTR TO giodata,z) IS EMPTY
PROC gioSavePrefs(g:PTR TO giodata,z) IS EMPTY
PROC gioLoadPrefs(g:PTR TO giodata,z) IS EMPTY
PROC gioAbout(g:PTR TO giodata,z)
    dosbase := g.dosbase
    pgsbase := g.pgsbase
    OneButtonReq('About CyberGFX.gio','CyberGFX.gio Version 0.004\n\nCopyright © 1996 Dominique Dutoit\n\nDisplay the current image on a\nCyberGraphics screen.', 'Ok')
ENDPROC
PROC gioStartup() IS EMPTY
PROC gioShutDown() IS EMPTY
PROC gioRead(g:PTR TO giodata,z) IS EMPTY
PROC gioExamine(g:PTR TO giodata,z) IS EMPTY
PROC main() IS EMPTY

PROC gioWrite(g:PTR TO giodata,z)
    DEF cmodetags[64]:ARRAY OF tagitem
    DEF scrwidth, scrheight, offx=0, offy=0, dispwidth, dispheight
    DEF centerx = 0, centery = 0
    DEF scr:PTR TO screen
    DEF width, height
    DEF modeid
    DEF wnd:PTR TO window
    DEF imsg:PTR TO intuimessage
    DEF end = FALSE, updatedis = TRUE
    DEF iclass, iqual, icode
    DEF stepx, stepy
    DEF y
    DEF peeker:PTR TO LONG
    DEF s[1024]:STRING

    g.error := NIL

    IF (g.depth = 24)
        cmodetags := [
                 CYBRMREQ_SCREEN,0,
                 CYBRMREQ_MINDEPTH,15,
                 CYBRMREQ_MAXDEPTH,32,
                 CYBRMREQ_WINTITLE,'Select CyBERgraphics screenmode',
                 CYBRMREQ_OKTEXT,'OK',
                 CYBRMREQ_CANCELTEXT,'Cancel',
                 TAG_DONE
                ]:tagitem

        cybergfxbase := g.cyberbase
        dosbase := g.dosbase
        pgsbase := g.pgsbase

        cmodetags[0].data := g.pgsScreen
        IF ( modeid := CmodeRequestTagList( NIL, cmodetags))
            IF ( modeid <> C_FALSE )
                width := g.width
                height := g.height

                IF ( scr := OpenScreenTagList( NIL, [SA_DISPLAYID, modeid,
                                                 SA_AUTOSCROLL, TRUE,
                                                 SA_OVERSCAN, TRUE,
                                                 SA_DEPTH, 8,
                                                 TAG_DONE, NIL]))

                    scrwidth := scr.width
                    scrheight := scr.height

                    IF ( wnd := OpenWindowTagList( NIL, [WA_ACTIVATE,   1,
                                                     WA_CUSTOMSCREEN,   scr,
                                                     WA_WIDTH,          scr.width,
                                                     WA_HEIGHT,         scr.height,
                                                     WA_BORDERLESS,     TRUE,
                                                     WA_BACKDROP,       TRUE,
                                                     WA_RMBTRAP,        TRUE,
                                                     WA_IDCMP,          IDCMP_RAWKEY OR IDCMP_MOUSEBUTTONS,
                                                     TAG_DONE, NIL]))

                        FillPixelArray( scr.rastport, 0, 0, scr.width, scr.height, 00000000)

                        dispwidth := scrwidth
                        IF (width < scrwidth)
                            dispwidth := width
                            centerx := Div(( scrwidth - width), 2)
                        ENDIF
                        dispheight := scrheight
                        IF (height < scrheight)
                            dispheight := height
                            centery := Div(( scrheight - height), 2)
                        ENDIF

                        WHILE ( end = FALSE )
                            IF (updatedis = TRUE)

                                FOR y := 0 TO dispheight - 1
                                     peeker := GetLine( g, y + offy)
                                     WritePixelArray( peeker, offx, 0, dispwidth*4, scr.rastport, 0 + centerx, y + centery, dispwidth, 1, RECTFMT_RGB)
                                     ReleaseLine( g, y + offy)
                                ENDFOR
                                updatedis := FALSE

                            ENDIF

                            WaitPort( wnd.userport)

                            WHILE (imsg := GetMsg( wnd.userport))

                                iclass := imsg.class
                                iqual := imsg.qualifier
                                icode := imsg.code
                          
                                SELECT iclass
                                    CASE IDCMP_MOUSEBUTTONS
                                        end := TRUE
                                    CASE IDCMP_RAWKEY
                                        IF (iqual AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT))
                                            stepx := 1
                                            stepy := 1
                                        ELSE
                                            stepx := 40 ->dispwidth
                                            stepy := 40 ->dispheight
                                        ENDIF

                                        SELECT icode
                                            CASE $0045
                                                end := TRUE
                                            CASE CURSORUP
                                                IF (offy <> 0)
                                                    offy := offy - stepy
                                                    IF (offy < 0) THEN offy := 0
                                                    updatedis := TRUE
                                                ENDIF
                                            CASE CURSORDOWN
                                                 IF ( height > dispheight)
                                                    offy := offy + stepy
                                                    IF (offy > height - dispheight)
                                                        offy := height - dispheight
                                                        IF (offy < 0) THEN offy := 0
                                                    ENDIF
                                                    updatedis := TRUE
                                                 ENDIF
                                            CASE CURSORRIGHT
                                                 IF (width > dispwidth)
                                                    offx := offx + stepx ->stepx + 1
                                                    IF (offx > width - scrwidth)
                                                        offx := width - dispwidth
                                                        IF (offx < 0) THEN offx:=0
                                                    ENDIF
                                                    updatedis:=TRUE
                                                 ENDIF
                                            CASE CURSORLEFT
                                                 IF(offx<>0)
                                                    offx := offx - stepx ->stepx - 1
                                                    IF (offx < 0) THEN offx:=0
                                                    updatedis:=TRUE
                                                 ENDIF
                                        ENDSELECT
                                ENDSELECT
                            ENDWHILE
                        ENDWHILE
                        CloseWindow(wnd)
                    ELSE
                        g.error := GIO_RAMERR
                    ENDIF
                    CloseScreen(scr)
                ELSE
                    g.error := GIO_RAMERR
                ENDIF
            ENDIF
        ENDIF
    ELSE
        g.error := GIO_WRONGTYPE
    ENDIF
ENDPROC g.error
