OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_password'
MODULE  'newgui/pl_dndexample'

DEF     default,
        p:PTR TO password,
        d:PTR TO dndplug,
        s[80]:STRING

PROC main() HANDLE
 default:='My Password!'
  AstrCopy(s,default)
   newguiA([
        NG_WINDOWTITLE, 'NewGUI-Password-Plugin',     
        NG_GUI,
                [ROWS,
                [BEVELR,
                [COLS,
                        [PLUGIN,{dropped},NEW d.dnd(DND_DRAGBOX,NIL,NIL,22,22,'Beispiel-Passoword',99,DND_ACT_PUT,NIL)]
                ]
                ],
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
 END d
 END p
  IF exception
   WriteF('Exception = \d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC dropped()
 WriteF('Drop!\n')
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
  p.disable(p.dis=FALSE)
ENDPROC
