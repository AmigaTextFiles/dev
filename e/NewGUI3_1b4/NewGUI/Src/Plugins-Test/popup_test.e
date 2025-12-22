OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_popup'

DEF     p1=NIL:PTR TO popup,
        p2=NIL:PTR TO popup

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE,         'NewGui PopUp-Plugin',
        NG_GUI,
                [ROWS,
                        [TEXT,'with select.gadget','PopUp-Plugin',FALSE,1],
                        [POPUP,{pressed},NEW p1.popup(['Zeile1','Zeile2','Zeile3','Zeile4',NIL],FALSE)],
                        [POPUP,{pressed},NEW p2.popup(['Zeile1','Zeile2','Zeile3','Zeile4',NIL],FALSE)]
                ]])
EXCEPT DO
  END p2
  END p1
 CleanUp(exception)
ENDPROC

PROC pressed(x,popup:PTR TO popup)
 WriteF('Item = \d\n',popup.item)
ENDPROC
