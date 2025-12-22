OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_busy'

DEF     b1:PTR TO busy,
        b2:PTR TO busy,
        b3:PTR TO busy,
        b4:PTR TO busy,
        busyon=FALSE

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-BusyPlugin',     
        NG_GUI,
        [ROWS,
        [BEVELR,
        [EQROWS,
                [TEXT,'Busy-BAR Test','NewGUI',FALSE,1],
        [EQCOLS,
                [BUSY,{dummy},NEW b1.busy(7,10,2,BUSY_BOTH,4)],
                [BUSY,{dummy},NEW b2.busy(3,10,2,BUSY_BOTH,4)]],
        [EQCOLS,
                [BUSY,{dummy},NEW b3.busy(5,10,2,BUSY_STARTLEFT,8)],
                [BUSY,{dummy},NEW b4.busy(6,10,2,BUSY_STARTRIGHT,8)]]
        ]],
        [BEVELR,
        [EQCOLS,
                [SBUTTON,{dummy},'Dummy'],
        [SPACEH],
                [SBUTTON,{getbusy},'Busy ON/OFF']
        ]]]
        ,NIL,NIL])
EXCEPT DO
 END b1
 END b2
 END b3
 END b4
  IF exception
   WriteF('Exception=\d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC dummy()
 WriteF('Dummy!\n')
ENDPROC

PROC getbusy()
 IF busyon=FALSE
  b1.active(TRUE)
  b2.active(TRUE)
  b3.active(FALSE)
  b4.active(FALSE)
   busyon:=TRUE
 ELSE
  b1.active(FALSE)
  b2.active(FALSE)
  b3.active(TRUE)
  b4.active(TRUE)
   busyon:=FALSE
 ENDIF
ENDPROC
