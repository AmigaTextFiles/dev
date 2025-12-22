OPT     OSVERSION=37

MODULE  'newgui/newgui'
MODULE  'newgui/animcontrol'

DEF a=NIL:PTR TO animcontrol

PROC main() HANDLE
  newguiA([
        NG_WINDOWTITLE, 'NewGUI-AnimControl-Plugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
        NG_GUI,
                [ROWS,
                        [TEXT,'AnimControl test...',NIL,TRUE,1],
                        [ANIMCTRL,{animcontrolaction},NEW a.animcontrol(10,20)],
                [EQCOLS,
                        [BUTTON,{reset},'Reset',a],
                        [BUTTON,{toggle_enabled},'Toggle Enabled',a]
                ]]])
EXCEPT DO
  END a
 CleanUp(exception)
ENDPROC

PROC animcontrolaction(i,a:PTR TO animcontrol)
  PrintF('Action: mode=\d frame=\d\n', a.mode, a.frame)
ENDPROC

PROC reset(a:PTR TO animcontrol,i)
  a.setframe(10)
  a.setplay(FALSE)
ENDPROC

PROC toggle_enabled(a:PTR TO animcontrol,i)
  a.setdisabled(a.disabled=FALSE)
ENDPROC
