OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_gauge'

DEF     g1:PTR TO gauge,
        g2:PTR TO gauge,
        slider=NIL

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-GaugePlugin',     
        NG_GUI,
        [ROWS,
        [COLS,
        [BEVELR,
        [EQROWS,
                [GAUGE,{dummy},NEW g1.gauge(7,1,1,GAUGE_VERT,50,TRUE)]
        ]],
        [ROWS,
        [BEVELR,
        [EQROWS,
                [TEXT,'Gauge Test','NewGUI',FALSE,1],
                [GAUGE,{dummy},NEW g2.gauge(3,2,1,GAUGE_HOR,50,TRUE)]
        ]],
        [BEVELR,
        [EQCOLS,
                slider:=[SLIDE,{setgauge},NIL,FALSE,0,100,50,3,NIL]
        ]]]],
        [BEVELR,
        [EQCOLS,
                [SBUTTON,{reset},'Reset']
        ]]]
        ,NIL,NIL])
EXCEPT DO
 END g1
 END g2
  IF exception
   WriteF('Exception=\d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC dummy()
 WriteF('Dummy!\n')
ENDPROC

PROC setgauge(x,y)
 g1.set(y)
 g2.set(y)
ENDPROC

PROC reset(x,gh)
 g1.set(50)
 g2.set(50)
  ng_setattrsA([NG_GUI,gh,
        NG_CHANGEGAD,   SLIDE,
        NG_GADGET,      slider,
        NG_NEWDATA,50,
        NIL,NIL])
ENDPROC
