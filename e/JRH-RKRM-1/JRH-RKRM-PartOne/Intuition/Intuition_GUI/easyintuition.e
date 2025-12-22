-> easyintuition.e  Simple backward-compatible V37 Intuition example
->
-> This example uses extended structures with the pre-V37 OpenScreen() and
-> OpenWindow() functions to compatibly open an Intuition display.  Enhanced
-> V37 options specified via tags are ignored on 1.3 systems.

-> E-Note: you need to be more specific about modules than C does about includes
MODULE 'intuition/intuition',  -> Intuition and window data structures and tags
       'intuition/screens',    -> Screen data structures and tags
       'graphics/view',        -> Screen resolutions
       'dos/dos'               -> Official return codes defined here

-> Position and sizes for our window
CONST WIN_LEFTEDGE=20, WIN_TOPEDGE=20,
      WIN_WIDTH=400,   WIN_MINWIDTH=80,
      WIN_HEIGHT=150,  WIN_MINHEIGHT=20

-> Exception values
-> E-Note: exceptions are a much better way of handling errors
ENUM ERR_NONE, ERR_SCRN, ERR_WIN

-> Automatically raise exceptions
-> E-Note: these take care of a lot of error cases
RAISE ERR_SCRN IF OpenS()=NIL,
      ERR_WIN  IF OpenW()=NIL

PROC main() HANDLE
  -> Declare variables here
  -> E-Note: the signals stuff is handled directly by WaitIMessage
  DEF screen1=NIL:PTR TO screen, window1=NIL:PTR TO window

  -> E-Note: E automatically opens the Intuition library

  -> Open the screen
  -> E-Note: automatically error-checked (automatic exception)
  -> E-Note: simplified using OpenS
  screen1:=OpenS(640,             -> Width (high-resolution)
                 STDSCREENHEIGHT, -> Height (non-interlace)
                 2,               -> Depth (4 colours will be available)
                 V_HIRES,         -> The high-resolution display mode
                 'Our Screen',    -> The screen title
  -> We can specify that we want the V37-compatible 3D look when running under
  -> V37 by adding an SA_PENS tag.
                [SA_PENS, [-1]:INT,  -> Tags for additional V37 features
                 -> E-Note: these tags replace the missing OpenS parameters
                 SA_DETAILPEN, 0,
                 SA_BLOCKPEN,  1,
                 NIL])

  -> E-Note: we attach the window to the open screen directly, below

  -> ... and open the window
  -> E-Note: automatically error-checked (automatic exception)
  window1:=OpenW(WIN_LEFTEDGE,
                 WIN_TOPEDGE,
                 WIN_WIDTH,
                 WIN_HEIGHT,

                 -> This field specifies the events we want to get
                 IDCMP_CLOSEWINDOW,

                 -> These flags specify system gadgets and other attributes
                 WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH OR WFLG_ACTIVATE OR
                 WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_SIZEGADGET OR
                 WFLG_NOCAREREFRESH,

                 'EasyWindow',  -> Window title
                 screen1,       -> Attach to screen1...
                 CUSTOMSCREEN,  -> ... a custom screen
                 NIL,           -> Pointer to first gadget
  -> Under V37, we'll get a special screen title when our window is active
                 -> Tags for additional V37 features
                [WA_SCREENTITLE, 'Our Screen - EasyWindow is Active',
                 -> E-Note: these tags replace the missing OpenW parameters
                 WA_MINWIDTH,    WIN_MINWIDTH,
                 WA_MINHEIGHT,   WIN_MINHEIGHT,
                 WA_MAXWIDTH,    -1,
                 WA_MAXHEIGHT,   -1,
                 NIL])

  -> Here's the main input event loop
  -> E-Note: the signals and stuff is handled by WaitIMessage
  REPEAT
  UNTIL handleIDCMP(window1)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF window1 THEN CloseW(window1)
  IF screen1 THEN CloseS(screen1)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_SCRN; WriteF('Error: Failed to open custom screen\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  ENDSELECT
-> E-Note: select return code according to exception
ENDPROC IF exception THEN RETURN_WARN ELSE RETURN_OK

PROC handleIDCMP(win:PTR TO window)
  DEF class, done=FALSE
  -> E-Note: WaitIMessage replaces a lot of C code concerned with signals
  class:=WaitIMessage(win)
  -> E-Note: other parts of the message are available via MsgXXX() functions

  -> See what events occurred
  SELECT class
  CASE IDCMP_CLOSEWINDOW
    done:=TRUE
  ENDSELECT
ENDPROC done

