-> easyintuition37.e -- Simple Intuition program for V37 (Release 2) and later
-> versions of the operating system

-> Use lowest non-obsolete version that supplies the functions needed
OPT OSVERSION=37

-> E-Note: you need to be more specific about modules than C does about includes
MODULE 'intuition/intuition',  -> Intuition and window data structures and tags
       'intuition/screens',    -> Screen data structures and tags
       'graphics/modeid',      -> Release 2 Amiga display mode ID's
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
RAISE ERR_SCRN IF OpenScreenTagList()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

PROC main() HANDLE
  -> Declare variables here
  -> E-Note: the signals stuff is handled directly by WaitIMessage
  DEF screen1=NIL:PTR TO screen, window1=NIL:PTR TO window

  -> E-Note: E automatically opens the Intuition library

  -> Open the screen
  -> E-Note: automatically error-checked (automatic exception)
  -> E-Note: pens is just a INT-typed list
  screen1:=OpenScreenTagList(NIL,
                             [SA_PENS, [-1]:INT,
                              SA_DISPLAYID, HIRES_KEY,
                              SA_DEPTH, 2,
                              SA_TITLE, 'Our Screen',
                              NIL])

  -> ... and open the window
  -> E-Note: automatically error-checked (automatic exception)
  window1:=OpenWindowTagList(NIL,
                             -> Specify window dimensions and limits
                            [WA_LEFT,      WIN_LEFTEDGE,
                             WA_TOP,       WIN_TOPEDGE,
                             WA_WIDTH,     WIN_WIDTH,
                             WA_HEIGHT,    WIN_HEIGHT,
                             WA_MINWIDTH,  WIN_MINWIDTH,
                             WA_MINHEIGHT, WIN_MINHEIGHT,
                             WA_MAXWIDTH,  -1,
                             WA_MAXHEIGHT, -1,
                             -> Specify the system gadgets we want
                             WA_CLOSEGADGET, TRUE,
                             WA_SIZEGADGET,  TRUE,
                             WA_DEPTHGADGET, TRUE,
                             WA_DRAGBAR,     TRUE,
                             -> Specify other attributes
                             WA_ACTIVATE,      TRUE,
                             WA_NOCAREREFRESH, TRUE,

                             -> Specify the events we want to know about
                             WA_IDCMP, IDCMP_CLOSEWINDOW,

                             -> Attach the window to the open screen ...
                             WA_CUSTOMSCREEN, screen1,
                             WA_TITLE,      'EasyWindow',
                             WA_SCREENTITLE,'Our Screen - EasyWindow is Active',
                             NIL])

  -> Here's the main input event loop
  -> E-Note: the signals and stuff is handled by WaitIMessage
  REPEAT
  UNTIL handleIDCMP(window1)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF window1 THEN CloseWindow(window1)
  IF screen1 THEN CloseScreen(screen1)
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

