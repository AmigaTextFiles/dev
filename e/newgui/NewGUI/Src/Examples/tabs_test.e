OPT     OSVERSION=37

MODULE  'newgui/newgui'
MODULE  'gadgets/tabs'
MODULE  'newgui/tabs'

DEF     t=NIL:PTR TO tabs

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-Button-Plugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
        NG_PATTERNEXP,  1,                                      /* Exponent für den Pattern             */
        NG_PATTERN1,    [$AAAA,$5555]:INT,                      /* Muster (Pattern) für FILLPATTERN1    */
        NG_P1BACKPEN,   0,                                      /* Hintergrundstift für das Patternfilling (Muster)             */
        NG_P1FRONTPEN,  0,                                      /* Zeichenstift für das Muster (Patternfilling)                 */
        NG_GUI,
                [ROWS,
                [BEVELR,
                [FILLPATTERN1,
                [ROWS,
                        [TEXT,'Tabs test...',NIL,TRUE,5],
                        [TABS,{tabsaction},NEW t.tabs(['Display', -1,-1,-1,-1, NIL,
                                'Edit',    -1,-1,-1,-1, NIL,
                                'File',    -1,-1,-1,-1, NIL,
                                NIL]:tablabel,
                                0,FALSE)]]]],
                [BAR],
                [EQCOLS,
                        [BUTTON,{reset},'Reset'],
                        [BUTTON,{toggle_enabled},'Toggle Enabled']
                ]],NIL,NIL])
EXCEPT DO
  END t
ENDPROC

PROC tabsaction()
  WriteF('tabs value = \d\n',t.current)
ENDPROC

PROC reset()
  t.setcurrent(0)
ENDPROC

PROC toggle_enabled()
  t.setdisabled(t.disabled=FALSE)
ENDPROC

