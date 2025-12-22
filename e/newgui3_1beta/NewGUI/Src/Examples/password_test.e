OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_password'

DEF     default,
        p:PTR TO password,
        s[20]:STRING

PROC main() HANDLE
 default:='My Password!'
  StrCopy(s,default)
   newguiA([
        NG_WINDOWTITLE, 'NewGUI-Password-Plugin',     
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [ROWS,
                [TEXT,'Password test...',NIL,TRUE,1],
                [SPACE],
                [PASSWORD,{passaction},NEW p.password(s,'Password',TRUE,10)]]],
        [EQCOLS,
                [SBUTTON,{show},'Show'],
                [SBUTTON,{reset},'Reset'],
                [SBUTTON,{toggle_enabled},'Toggle Enabled']
        ]],NIL,NIL])

EXCEPT DO
 END p
  IF exception
   WriteF('Exception = \d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC passaction()
  PrintF('Action: "\s"\n',p.estr)
ENDPROC

PROC show()
  PrintF('Show: "\s"\n', p.estr)
ENDPROC

PROC reset()
  p.setpass(default)
ENDPROC

PROC toggle_enabled()
  p.setdisabled(p.disabled=FALSE)
ENDPROC
