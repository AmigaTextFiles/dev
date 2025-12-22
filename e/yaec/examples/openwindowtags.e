-> openwindowtags.e - open a window using tags

MODULE 'intuition/intuition'  -> Intuition data structures and tags

CONST MY_WIN_LEFT=20,   MY_WIN_TOP=10
CONST MY_WIN_WIDTH=300, MY_WIN_HEIGHT=110

ENUM ERR_NONE, ERR_WIN, ERR_KICK

RAISE ERR_WIN IF OpenWindowTagList()=NIL

-> Open a simple window using OpenWindowTagList()
PROC main() HANDLE
  DEF win=NIL
  -> These calls are only valid if we have Intuition version 37 or greater
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)
  win:=OpenWindowTagList(NIL,
                        [WA_LEFT,        MY_WIN_LEFT,
                         WA_TOP,         MY_WIN_TOP,
                         WA_WIDTH,       MY_WIN_WIDTH,
                         WA_HEIGHT,      MY_WIN_HEIGHT,
                         WA_CLOSEGADGET, TRUE,
                         WA_IDCMP,       IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS,
                         NIL])
  -> Window successfully opened here
  handle_window_events(win)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF win THEN CloseWindow(win)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  ENDSELECT
ENDPROC

-> Normally this routine would contain an event loop like the one given in the
-> chapter "Intuition Input and Output Methods".  Here we just wait for any
-> messages we requested to appear at the Window's port.
PROC handle_window_events(win:PTR TO window)
  DEF im:PTR TO intuimessage
  DEF class
  REPEAT
     WaitPort(win.userport)
     WHILE (im := GetMsg(win.userport))
        class := im.class
        PrintF('seconds : \d, micros : \d\n', im.seconds, im.micros)
        ReplyMsg(im)
     ENDWHILE
  UNTIL class = IDCMP_CLOSEWINDOW
ENDPROC
