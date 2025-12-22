MODULE 'tools/easygui', 'tools/exceptions',
       'gadgets/tabs',
       'plugins/tabs'

PROC main() HANDLE
  DEF t=NIL:PTR TO tabs
  NEW t.tabs(['Display', -1,-1,-1,-1, NIL,
              'Edit',    -1,-1,-1,-1, NIL,
              'File',    -1,-1,-1,-1, NIL,
              NIL]:tablabel,
             0,FALSE)
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      [TEXT,'Tabs test...',NIL,TRUE,5],
      [PLUGIN,{tabsaction},t],
      [EQCOLS,
        [BUTTON,{reset},'Reset',t],
        [BUTTON,{toggle_enabled},'Toggle Enabled',t]
      ]
    ])
EXCEPT DO
  END t
  report_exception()
ENDPROC

PROC tabsaction(i,t:PTR TO tabs)
  WriteF('tabs value = \d\n',t.current)
ENDPROC

PROC reset(t:PTR TO tabs,i)
  t.setcurrent(0)
ENDPROC

PROC toggle_enabled(t:PTR TO tabs,i)
  t.setdisabled(t.disabled=FALSE)
ENDPROC
