OPT     OSVERSION=37
OPT     LARGE

MODULE  'gadgets/tabs'
MODULE  'newgui/newgui'
MODULE  'newgui/pl_tabs'
MODULE  'newgui/ng_showerror'

CONST   GUI_MAIN = 1

DEF     gh=NIL:PTR TO guihandle,
        t=NIL:PTR TO tabs,
        gui:PTR TO LONG

PROC main() HANDLE
 NEW t.tabs([   'One', -1,-1,-1,-1, NIL,
                'Two',    -1,-1,-1,-1, NIL,
                'Three',    -1,-1,-1,-1, NIL,
                NIL]:tablabel,
                0,FALSE)
  gui:=[
        [ROWS,
        [BEVELR,
        [ROWS,
                [TEXT,'Tabs test...',NIL,TRUE,5],
                [TABS,{tabsaction},t]]],
                [TEXT,'One','Page',FALSE,3],
        [BAR],
        [EQCOLS,
                [BUTTON,{reset},'Reset'],
                [BUTTON,{toggle_enabled},'Toggle Enabled']
        ]],
        [ROWS,
        [BEVELR,
        [ROWS,
                [TEXT,'Tabs test...',NIL,TRUE,5],
                [TABS,{tabsaction},t]]],
                [TEXT,'Two','Page',FALSE,3],
        [BAR],
        [EQCOLS,
                [BUTTON,{reset},'Reset'],
                [BUTTON,{toggle_enabled},'Toggle Enabled']
        ]],
        [ROWS,
        [BEVELR,
        [ROWS,
                [TEXT,'Tabs test...',NIL,TRUE,5],
                [TABS,{tabsaction},t]]],
                [TEXT,'Three','Page',FALSE,3],
        [BAR],
        [EQCOLS,
                [BUTTON,{reset},'Reset'],
                [BUTTON,{toggle_enabled},'Toggle Enabled']
        ]]
      ]
   newguiA([
        NG_WINDOWTITLE, 'NewGUI-Button-Plugin',     
        NG_GUIID,       GUI_MAIN,
        NG_GUI,
                gui[],
        NIL,            NIL],{getgui})
EXCEPT DO
 IF (t<>NIL) THEN END t
  IF (exception<>0) THEN ng_showerror(exception) 
 CleanUp(exception)
ENDPROC

PROC getgui(guihandle,scr)      IS gh:=guihandle

PROC reset()
  t.setcurrent(0)
ENDPROC

PROC toggle_enabled()
  t.disable(t.dis=FALSE)
ENDPROC

PROC tabsaction()
 ng_setattrsA(
       [NG_GUI,         gh,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_NEWDATA,     gui[t.current],
        NIL,            NIL])
ENDPROC
