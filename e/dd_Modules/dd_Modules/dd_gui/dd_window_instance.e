OPT MODULE

MODULE '*dd_window'
MODULE 'intuition/intuition'
MODULE 'utility/tagitem'

EXPORT OBJECT mainwindow OF dd_window
ENDOBJECT

EXPORT PROC new() OF mainwindow

  self.window:=OpenWindowTagList(NIL,[
    WA_FLAGS,
     WFLG_DEPTHGADGET OR
     WFLG_SIZEGADGET OR
     WFLG_SIZEBBOTTOM OR
     WFLG_DRAGBAR OR
     WFLG_CLOSEGADGET,
    WA_IDCMP,
     IDCMP_CLOSEWINDOW OR
     IDCMP_SIZEVERIFY OR
     IDCMP_REFRESHWINDOW,
    WA_HEIGHT,200,
    WA_WIDTH,300,
    WA_TITLE,'dd_window test',
    TAG_DONE,NIL])

  -> Call the dd_window class constructor.
  SUPER self.new()

ENDPROC

EXPORT PROC end() OF mainwindow

  -> Call the dd_window class destructor.
  SUPER self.end()

  CloseWindow(self.window)
  self.window:=0
ENDPROC


