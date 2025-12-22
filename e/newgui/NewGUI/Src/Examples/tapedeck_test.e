OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'newgui/tapedeck'

DEF     t=NIL:PTR TO tapedeck

PROC main() HANDLE
  newguiA([
        NG_WINDOWTITLE, 'NewGUI-Tapedeck-Plugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
/*                                                              /* ARexx-Port hinzufügen!               */
        NG_REXXNAME,    'NEWGUI',                               /* Name für einen ARexx-Port            */
        NG_REXXPROC,    {rexxmsg},                              /* Prozedur die ARexx-Messages auswertet*/
*/                                                              /* Durch den Port wird das EXE nicht größer!    */
        NG_GUI,
        [ROWS,
                [TEXT,'Tapedeck test...',NIL,TRUE,1],
                [TAPEDECK,{tapedeckaction},NEW t.tapedeck()],
        [COLS,
                [BUTTON,{reset},'Reset'],
                [BUTTON,{toggle_enabled},'Toggle Enabled']
        ]
        ],NIL,NIL])
EXCEPT DO
 END t
ENDPROC

PROC tapedeckaction(i,t:PTR TO tapedeck)
  PrintF('Action: mode=\d\s\n', t.mode, IF t.paused THEN ' (paused)' ELSE '')
ENDPROC

PROC reset()
  t.setmode()
  t.setpaused(FALSE)
ENDPROC

PROC toggle_enabled()
  t.setdisabled(t.disabled=FALSE)
ENDPROC
