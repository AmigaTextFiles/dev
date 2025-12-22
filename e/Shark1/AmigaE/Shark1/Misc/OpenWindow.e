MODULE 'intuition/intuition'

CONST MY_WIN_LEFT=20,   MY_WIN_TOP=10,
      MY_WIN_WIDTH=300, MY_WIN_HEIGHT=110

ENUM ERR_NONE, ERR_WIN, ERR_KICK

RAISE ERR_WIN IF OpenWindowTagList()=NIL

PROC main() HANDLE
  DEF win=NIL
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)
  win:=OpenWindowTagList(NIL,
                        [WA_LEFT,        MY_WIN_LEFT,
                         WA_TOP,         MY_WIN_TOP,
                         WA_WIDTH,       MY_WIN_WIDTH,
                         WA_HEIGHT,      MY_WIN_HEIGHT,
                         WA_CLOSEGADGET, TRUE,
                         WA_IDCMP,       IDCMP_CLOSEWINDOW,
                         NIL])

  handle_window_events(win)

EXCEPT DO
  IF win THEN CloseWindow(win)
  SELECT exception
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  ENDSELECT
ENDPROC

PROC handle_window_events(win)
  WaitIMessage(win)
ENDPROC
