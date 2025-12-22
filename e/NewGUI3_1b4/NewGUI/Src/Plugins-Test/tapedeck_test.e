OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_tapedeck'

DEF     t=NIL:PTR TO tapedeck

PROC main() HANDLE
  newguiA([
        NG_WINDOWTITLE, 'NewGUI-Tapedeck-Plugin',     
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
  t.disable(t.dis=FALSE)
ENDPROC
