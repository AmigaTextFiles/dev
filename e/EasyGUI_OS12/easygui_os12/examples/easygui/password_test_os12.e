OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'plugins/password_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'plugins/password'
#endif

MODULE 'tools/exceptions'

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
  WriteF('Action: "\s"\n',p.estr)
ENDPROC

PROC show(p:PTR TO password,i)
  WriteF('Show: "\s"\n', p.estr)
ENDPROC

PROC reset(p:PTR TO password,i)
  p.setpass(default)
ENDPROC

PROC toggle_enabled(p:PTR TO password,i)
  p.setdisabled(p.disabled=FALSE)
ENDPROC
