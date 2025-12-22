
/*

    $VER: location_plugin 1.0 (18.2.98)

    Author:         Ali Graham
                    <agraham@hal9000.net.au>

    Desc.:          Record the location of an EasyGUI window.

*/


OPT MODULE, OSVERSION=37

MODULE 'tools/EasyGUI',
       'intuition/intuition'

EXPORT OBJECT location_plugin OF plugin

    lx, ly, lw, lh

ENDOBJECT

PROC min_size(ta,fh) OF location_plugin IS 0,0

PROC will_resize() OF location_plugin IS FALSE

PROC render(ta,x,y,xs,ys,win:PTR TO window) OF location_plugin

    self.get_values(win)

ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF location_plugin

    IF (imsg.class=IDCMP_CHANGEWINDOW) OR (imsg.class=IDCMP_NEWSIZE)

        self.get_values(win)

        RETURN TRUE

    ENDIF

ENDPROC FALSE

PROC message_action(class, qual, code, win:PTR TO window) OF location_plugin IS TRUE

PROC get_values(win:PTR TO window) OF location_plugin

    IF win

        self.lx:=win.leftedge
        self.ly:=win.topedge

        self.lw:=win.width
        self.lh:=win.height

    ENDIF

ENDPROC

