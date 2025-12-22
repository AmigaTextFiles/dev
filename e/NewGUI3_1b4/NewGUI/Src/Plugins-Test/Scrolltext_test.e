OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_scrolltext'

DEF     gui=NIL:PTR TO guihandle,
        s:PTR TO scrolltext,
        sptr=NIL,
        disabled=FALSE

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-ScrolltextPlugin',     
        NG_GUI,
        [ROWS,
        [BEVELR,
        [EQROWS,
                [TEXT,'Scrolltext-Plugin','NewGUI',FALSE,1],
        [BEVELR,
        [ROWS,
                sptr:=[SCROLLTEXT,{dummy},NEW s.scrolltext([
                        1,SCRTXT_LEFT,  'Scrolltext-Plugin',
                        1,SCRTXT_LEFT,  'Left-Adjusted',
                        1,SCRTXT_CENTER,'centered Line',
                        1,SCRTXT_RIGHT, 'Right-Adjusted',
                        1,SCRTXT_LEFT,  'And now a BAR-Line...',
                        1,SCRTXT_BAR,   ' ',
                        1,SCRTXT_LEFT,  'is it ok?',
                        2,SCRTXT_LEFT,  'How \about colored Text??',
                        3,SCRTXT_LEFT,  'And now a blue line :-)',
                        1,SCRTXT_LEFT,  'This is a really long Line... don\at worry... it will be cutted off! :-)',
                        1,SCRTXT_LEFT,  ' ',
                        2,SCRTXT_LEFT,  'This was a empty Line :-)',
        NIL,NIL],2,50,1)]
        ]],
                [TEXT,'scrolling...!','with smooth',FALSE,1]
        ]],
        [BEVELR,
        [EQCOLS,
                [SBUTTON,{dummy},'Dummy'],
                [SLIDE,{changespeed},NIL,FALSE,0,10,2,3,NIL],
                [SBUTTON,{disable},'Dis-/Enable']
        ]]]
        ,NIL,NIL],{getinfo})
EXCEPT DO
 END s
  IF exception
   WriteF('Exception=\d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC getinfo(gh,s)      IS gui:=gh

PROC dummy()
 WriteF('Dummy!\n')
ENDPROC

PROC changespeed(x,y) IS s.setspeed(y)

PROC disable()
 IF disabled=FALSE
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      sptr,
        NG_DISABLE,     TRUE,
        NIL,            NIL])
  disabled:=TRUE
 ELSE
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      sptr,
        NG_ENABLE,      TRUE,
        NIL,            NIL])
  disabled:=FALSE
 ENDIF
ENDPROC
