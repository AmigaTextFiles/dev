-> visiblewindow.e
-> Open a window on the visible part of a screen, with the window as large as
-> the visible part of the screen.  It is assumed that the visible part of the
-> screen is OSCAN_TEXT, which how the user has set their preferences.

MODULE 'intuition/intuition', -> Intuition data structures and tags
       'intuition/screens',   -> Screen data structures and tags
       'graphics/gfx',        -> Graphics structures
       'graphics/modeid'      -> Release 2 Amiga display mode ID's

ENUM ERR_NONE, ERR_WIN, ERR_PUB

RAISE ERR_WIN IF OpenWindowTagList()=NIL,
      ERR_PUB IF LockPubScreen()=NIL

-> Minimum window width and height:  These values should really be calculated
-> dynamically given the size of the font and the window borders.  Here, to
-> keep the example simple they are hard-coded values.
CONST MIN_WINDOW_WIDTH=100, MIN_WINDOW_HEIGHT=50

-> E-Note: minimum and maximum are built-in

PROC main()
  -> These calls are only valid if we have version 37 or greater
  -> E-Note: E automatically opens the Intuition and Graphics libraries
  IF KickVersion(37)
    fullScreen()
  ELSE -> E-Note: we can print a minimal error
    WriteF('Error: Needs Kickstart V37+\n')
  ENDIF
ENDPROC

-> Open a window on the default public screen, then leave it open until the
-> user selects the close gadget. The window is full-sized, positioned in the
-> currently visible OSCAN_TEXT area.
PROC fullScreen() HANDLE
  DEF test_window=NIL:PTR TO window, pub_screen=NIL:PTR TO screen,
      rect:rectangle, screen_modeID,
      -> Set some reasonable defaults for left, top, width and height
      -> We'll pick up the real values with the call to QueryOverscan()
      left=0, top=0, width=640, height=200

  -> Get a lock on the default public screen
  -> E-Note: automatically error-checked (automatic exception)
  pub_screen:=LockPubScreen(NIL)

  -> This technique returns the text overscan rectangle of the screen that we
  -> are opening on.  If you really need the actual value set into the display
  -> clip of the screen, use the VideoControl() command of the graphics library
  -> to return a copy of the ViewPortExtra structure.  See the Graphics library
  -> chapter and Autodocs for more details.
  ->
  -> GetVPModeID() is a graphics call...
  IF (screen_modeID:=GetVPModeID(pub_screen.viewport))<>INVALID_ID
    IF QueryOverscan(screen_modeID, rect, OSCAN_TEXT)
      -> Make sure window coordinates are positive or zero
      left := Max(0, -pub_screen.leftedge)
      top  := Max(0, -pub_screen.topedge)

      -> Get width and height from size of display clip
      width:=rect.maxx-rect.minx+1
      height:=rect.maxy-rect.miny+1

      -> Adjust height for pulled-down screen (only show visible part)
      IF pub_screen.topedge > 0
        height:=height-pub_screen.topedge
      ENDIF

      -> Ensure that window fits on screen
      height:=Min(height,pub_screen.height)
      width:=Min(width,pub_screen.width)

      -> Make sure window is at least minimum size
      width:=Max(width,  MIN_WINDOW_WIDTH)
      height:=Max(height, MIN_WINDOW_HEIGHT)
    ENDIF
  ENDIF

  -> Open the window on the public screen
  -> E-Note: automatically error-checked (automatic exception)
  test_window:=OpenWindowTagList(NIL,
                                [WA_LEFT, left, WA_WIDTH,  width,
                                 WA_TOP,  top,  WA_HEIGHT, height,
                                 WA_CLOSEGADGET, TRUE,
                                 WA_IDCMP,       IDCMP_CLOSEWINDOW,
                                 WA_PUBSCREEN,   pub_screen,
                                 NIL])
  -> Unlock the screen.  The window now acts as a lock on the screen, and we do
  -> not need the screen after the window has been closed.
  UnlockPubScreen(NIL, pub_screen)
  -> E-Note: set it to NIL to help deal with errors
  pub_screen:=NIL

  -> If we have a valid window open, run the rest of the program, then clean
  -> up when done.
  handle_window_events(test_window)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF test_window THEN CloseWindow(test_window)
  IF pub_screen THEN UnlockPubScreen(NIL, pub_screen)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_PUB; WriteF('Error: Could not lock public screen\n')
  CASE ERR_WIN; WriteF('Error: Failed to open window\n')
  ENDSELECT
ENDPROC

-> Wait for the user to select the close gadget.
PROC handle_window_events(win)
  -> E-Note: we can use E's special message poller
  REPEAT
  UNTIL WaitIMessage(win)=IDCMP_CLOSEWINDOW
ENDPROC
