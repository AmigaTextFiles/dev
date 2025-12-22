OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'newgui/gauge'

DEF     g1:PTR TO gauge,
        g2:PTR TO gauge,
        slider=NIL

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-GaugePlugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  0,                                      /* Zeichenstift für den Pattern         */
        NG_PATTERNEXP,  1,                                      /* Exponent für den Pattern             */
        NG_PATTERN1,    [$AAAA,$5555]:INT,                      /* Muster (Pattern) für FILLPATTERN1    */
        NG_P1BACKPEN,   0,                                      /* Hintergrundstift für das Patternfilling (Muster)             */
        NG_P1FRONTPEN,  0,                                      /* Zeichenstift für das Muster (Patternfilling)                 */
        NG_GUI,
        [ROWS,
        [COLS,
        [BEVELR,
        [FILLPATTERN1,
        [EQROWS,
                [GAUGE,{dummy},NEW g1.gauge(7,1,1,GAUGE_VERT,50,FALSE)]
        ]]],
        [ROWS,
        [BEVELR,
        [FILLPATTERN1,
        [EQROWS,
                [TEXT,'Gauge Test','NewGUI',FALSE,1],
                [GAUGE,{dummy},NEW g2.gauge(3,2,1,GAUGE_HOR,50,TRUE)]
        ]]],
        [BEVELR,
        [FILLPATTERN1,
        [EQCOLS,
                slider:=[SLIDE,{setgauge},NIL,FALSE,0,100,50,3,NIL]
        ]]]]],
        [BEVELR,
        [FILLPATTERN1,
        [EQCOLS,
                [SBUTTON,{reset},'Reset']
        ]]]]
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
