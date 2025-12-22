MODULE 'tools/easygui', 'tools/exceptions',
       'plugins/animcontrol'

PROC main() HANDLE
  DEF a=NIL:PTR TO animcontrol
  NEW a.animcontrol(10,20)
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      [TEXT,'AnimControl test...',NIL,TRUE,1],
      [PLUGIN,{animcontrolaction},a],
      [EQCOLS,
        [BUTTON,{reset},'Reset',a],
        [BUTTON,{toggle_enabled},'Toggle Enabled',a]
      ]
    ])
EXCEPT DO
  END a
  report_exception()
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
