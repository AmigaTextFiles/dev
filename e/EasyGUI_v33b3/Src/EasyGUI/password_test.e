MODULE 'tools/exceptions',
       'tools/easygui',
       'plugins/password'

DEF default

PROC main() HANDLE
  DEF p=NIL:PTR TO password, s[20]:STRING
  default:='My Password!'
  StrCopy(s,default)
  NEW p.password(s,'Password:',TRUE,10)
  easyguiA('GadTools in EasyGUI!',
    [ROWS,
      [TEXT,'Password test...',NIL,TRUE,1],
      [PLUGIN,{passaction},p,TRUE],
      [COLS,
        [BUTTON,{show},'Show',p],
        [BUTTON,{reset},'Reset',p],
        [BUTTON,{toggle_enabled},'Toggle Enabled',p]
      ]
    ])
EXCEPT DO
  END p
  report_exception()
ENDPROC

PROC passaction(i,p:PTR TO password)
  PrintF('Action: "\s"\n',p.estr)
ENDPROC

PROC show(p:PTR TO password,i)
  PrintF('Show: "\s"\n', p.estr)
ENDPROC

PROC reset(p:PTR TO password,i)
  p.setpass(default)
ENDPROC

PROC toggle_enabled(p:PTR TO password,i)
  p.setdisabled(p.disabled=FALSE)
ENDPROC
