-> winpubscreen.e
-> Open a window on the default public screen (usually the Workbench screen)

MODULE 'intuition/intuition'  -> Intuition data structures and tags

ENUM ERR_NONE, ERR_WIN, ERR_KICK, ERR_PUB

RAISE ERR_WIN IF OpenWindowTagList()=NIL,
      ERR_PUB IF LockPubScreen()=NIL

-> Open a simple window on the default public screen, then leave it open until
-> the user selects the close gadget.
PROC main() HANDLE
  DEF test_window=NIL, test_screen=NIL
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)
  -> Get a lock on the default public screen
  test_screen:=LockPubScreen(NIL)
  -> Open the window on the public screen
  test_window:=OpenWindowTagList(NIL,
                                [WA_LEFT,  10,  WA_TOP,    20,
                                 WA_WIDTH, 300, WA_HEIGHT, 100,
                                 WA_DRAGBAR,       TRUE,
                                 WA_CLOSEGADGET,   TRUE,
                                 WA_SMARTREFRESH,  TRUE,
                                 WA_NOCAREREFRESH, TRUE,
                                 WA_IDCMP,         IDCMP_CLOSEWINDOW,
                                 WA_TITLE,         'Window Title',
                                 WA_PUBSCREEN,     test_screen,
                                 NIL])
  -> Unlock the screen.  The window now acts as a lock on the screen, and we do
  -> not need the screen after the window has been closed.
  UnlockPubScreen(NIL, test_screen)
  -> Note: set it to NIL to help deal with errors
  test_screen:=NIL

  -> If we have a valid window open, run the rest of the program, then clean up
  -> when done.
  handle_window_events(test_window)

  -> Note: exit and clean up via handler
EXCEPT DO
  IF test_window THEN CloseWindow(test_window)
  IF test_screen THEN UnlockPubScreen(NIL, test_screen)
  -> Note: we can print a minimal error message
  SELECT exception
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  CASE ERR_PUB;  WriteF('Error: Could not lock public screen\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  ENDSELECT
ENDPROC

-> Wait for the user to select the close gadget.
PROC handle_window_events(win)
  -> Note: we can use E's special message poller
  REPEAT
  UNTIL WaitIMessage(win)=IDCMP_CLOSEWINDOW
ENDPROC
