MODULE 'tools/easygui', 'tools/exceptions',
       'plugins/button'

DEF b2=NIL:PTR TO button

PROC main() HANDLE
  DEF b1=NIL:PTR TO button, b3=NIL:PTR TO button,
      bp=NIL:PTR TO button
  NEW bp.togglebutton('Paused')
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      [TEXT,'Button test...',NIL,TRUE,5],
      [COLS,
        [PLUGIN,{buttonaction1},NEW b1.togglebutton('New')],
        [PLUGIN,{buttonaction1},NEW b2.pushbutton('Open')],
        [PLUGIN,{buttonaction2},NEW b3.button('Save')],
        [PLUGIN,{buttonaction3},bp]
      ],
      [SBUTTON,{toggle_enabled},'Toggle Enabled',bp]
    ])
EXCEPT DO
  END b1,b2,b3,bp
  report_exception()
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
