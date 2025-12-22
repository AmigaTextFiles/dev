OPT     OSVERSION=37

MODULE  'newgui/newgui'
MODULE  'newgui/button'

DEF     b2=NIL:PTR TO button,
        b1=NIL:PTR TO button, 
        b3=NIL:PTR TO button,
        bp=NIL:PTR TO button

PROC main() HANDLE
  newguiA([
        NG_WINDOWTITLE, 'NewGUI-Button-Plugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
        NG_GUI,
                [ROWS,
                        [TEXT,'Button test...',NIL,TRUE,5],
                [COLS,
                        [NEWBUTTON,{buttonaction1},NEW b1.togglebutton('New')],
                        [NEWBUTTON,{buttonaction1},NEW b2.pushbutton('Open')],
                        [NEWBUTTON,{buttonaction2},NEW b3.button('Save')],
                        [NEWBUTTON,{buttonaction3},NEW bp.togglebutton('Paused')]
                ],
                        [SBUTTON,{toggle_enabled},'Toggle Enabled',bp]
                ],NIL,NIL])
EXCEPT DO
  END b1
  END b2
  END b3
  END bp
ENDPROC

PROC buttonaction1(i,b:PTR TO button)
  WriteF('button selected=\d\n', b.selected)
ENDPROC

PROC buttonaction2(i,b:PTR TO button)
  WriteF('button selected=\d\n', b.selected)
  b2.setselected(FALSE)
ENDPROC

PROC buttonaction3(i,b:PTR TO button)
  WriteF('button selected=\d\n', b.selected)
  b.settext(IF b.selected THEN 'Play' ELSE 'Paused')
ENDPROC

PROC toggle_enabled(b:PTR TO button,i)
  b.setdisabled(b.disabled=FALSE)
ENDPROC
