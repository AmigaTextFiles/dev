MODULE 'tools/easygui', 'tools/exceptions',
       'plugins/tapedeck'

PROC main() HANDLE
  DEF t=NIL:PTR TO tapedeck
  NEW t.tapedeck()
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      [TEXT,'Tapedeck test...',NIL,TRUE,1],
      [PLUGIN,{tapedeckaction},t],
      [EQCOLS,
        [BUTTON,{reset},'Reset',t],
        [BUTTON,{toggle_enabled},'Toggle Enabled',t]
      ]
    ])
EXCEPT DO
  END t
  report_exception()
ENDPROC

PROC tapedeckaction(i,t:PTR TO tapedeck)
  PrintF('Action: mode=\d\s\n', t.mode, IF t.paused THEN ' (paused)' ELSE '')
ENDPROC

PROC reset(t:PTR TO tapedeck,i)
  t.setmode()
  t.setpaused(FALSE)
ENDPROC

PROC toggle_enabled(t:PTR TO tapedeck,i)
  t.setdisabled(t.disabled=FALSE)
ENDPROC
