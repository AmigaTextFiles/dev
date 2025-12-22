/*
    PROGRAM  : Gauge_Test - trying out a *real good* gauge module...
    LANGUAGE : E
    AUTHOR   : Daniel `ThunderPig` Rädel/NEUDELSoft (-DR-/NS)
    DATE     : 040596
    xxx-WARE : This source is `Public Domain` :)
*/

OPT OSVERSION=37 -> sorry - everything else is obsolete...

MODULE  'tools/easygui','gadtools','libraries/gadtools','tools/exceptions',
        'intuition/intuition','utility','plugins/gauge'

    DEF gauge:PTR TO gauge_bar, gui=0:PTR TO guihandle,
        gauge2:PTR TO gauge_bar, gauge3:PTR TO gauge_bar,
        gauge4:PTR TO gauge_bar, gauge5:PTR TO gauge_bar,
        gauge6:PTR TO gauge_bar

PROC main() HANDLE

    IF (gadtoolsbase:=OpenLibrary('gadtools.library',0))

        -> This lib is needed by the module (GetTagData()...)
        IF (utilitybase:=OpenLibrary('utility.library',0))

    -> Opening an `easygui`-window with lots of the new plugins
            gui:=guiinit('Testing the *real* gauge plugin module...', [ROWS, [COLS,

            [PLUGIN,0, NEW gauge.init_gauge([GA_IsVertical, TRUE,
              GA_Percentage, TRUE, GA_BackgroundPen, 3,
              GA_IsVolumeSlider, TRUE, 0])],

            [PLUGIN, 0, NEW gauge3.init_gauge([GA_Current,100,
              GA_TextLen,9,GA_TextPtr,'Click Me!', GA_BorderRecessed, TRUE,
              GA_Bar3D, TRUE, GA_GaugeUsable, TRUE,
              GA_ActionProc,{testproc}, GA_GaugeID,16,0])] ,

            [PLUGIN, 0, NEW gauge4.init_gauge([GA_TextPtr,'and me!',
              GA_TextLen, 7,GA_IsRound, TRUE,GA_GaugeUsable, TRUE,
              GA_GaugeID,42, GA_ActionProc,{testproc},
              GA_Current,100,0])] ,

            [PLUGIN, 0, NEW gauge5.init_gauge([GA_BorderRecessed, TRUE,
              GA_IsRound, TRUE,GA_FixedWidth, 120,
              GA_RoundPointerPen, 3,0])] ,

            [PLUGIN, 0, NEW gauge6.init_gauge([GA_BarRecessed, TRUE,
            GA_IsVertical, TRUE, GA_Bar3D, TRUE,
            GA_BackgroundPen, 2, GA_BarPen, 1, 0])] ],

            [PLUGIN, 0, NEW gauge2.init_gauge([GA_IsVolumeSlider, TRUE,
            GA_TextLen, 9, GA_TextPtr, 'Slide me!', GA_ActionProc, {slider},
            GA_GaugeUsable, TRUE,0])] ])

            IF gui
                -> a simple loop will do in a demo
                WHILE (guimessage(gui)=-1)
                    WaitTOF()
                ENDWHILE
            ENDIF
        ENDIF
    ENDIF
EXCEPT DO
    IF gui THEN cleangui(gui)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF utilitybase THEN CloseLibrary(utilitybase)

    -> This is important! There are some structures (24 Bytes :) that are
    -> to be released!
    END gauge
    END gauge2; END gauge3; END gauge4; END gauge5; END gauge6

    report_exception()
ENDPROC

-> This proc will be called every time you change something at the
-> `Slide me!` titled volume slider
PROC slider(id, cur)
    gauge.setgauge(gui.wnd,cur)
    gauge2.setgauge(gui.wnd,cur)
    gauge5.setgauge(gui.wnd,cur)
    gauge6.setgauge(gui.wnd,cur)
ENDPROC

-> and this proc links gauge3 and gauge4 together
PROC testproc(id, cur)
    IF id=42 THEN gauge3.setgauge(gui.wnd, cur) ELSE gauge4.setgauge(gui.wnd, cur)
ENDPROC


