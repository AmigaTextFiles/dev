OPT     OSVERSION=37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'gadgets/tabs'
MODULE  'newgui/pl_tabs'

DEF     t=NIL:PTR TO tabs

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-Button-Plugin',     
        NG_GUI,
                [ROWS,
                [BEVELR,
                [ROWS,
                        [TEXT,'Tabs test...',NIL,TRUE,5],
                        [TABS,{tabsaction},NEW t.tabs(['Display', -1,-1,-1,-1, NIL,
                                'Edit',    -1,-1,-1,-1, NIL,
                                'File',    -1,-1,-1,-1, NIL,
                                NIL]:tablabel,
                                0,FALSE)]]],
                [BAR],
                [EQCOLS,
                        [BUTTON,{reset},'Reset'],
                        [BUTTON,{toggle_enabled},'Toggle Enabled']
                ]],NIL,NIL])
EXCEPT DO
  END t
ENDPROC

PROC tabsaction()
  WriteF('tabs value = \d\n',t.current)
ENDPROC

PROC reset()
  t.setcurrent(0)
ENDPROC

PROC toggle_enabled()
  t.disable(t.dis=FALSE)
ENDPROC

