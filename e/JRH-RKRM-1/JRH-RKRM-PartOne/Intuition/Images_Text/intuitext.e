-> intuitext.e - Program to show the use of an Intuition IntuiText object.

OPT OSVERSION=37  -> E-Note: silently require V37

MODULE 'exec/ports',
       'exec/nodes',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens'

ENUM ERR_NONE, ERR_DRAW, ERR_PUB, ERR_WIN

RAISE ERR_DRAW IF GetScreenDrawInfo()=NIL,
      ERR_PUB  IF LockPubScreen()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST MYTEXT_LEFT=0, MYTEXT_TOP=0

-> Main routine. Open required window and draw the images.  This routine opens
-> a very simple window with no IDCMP.  See the chapters on "Windows" and
-> "Input and Output Methods" for more info.  Free all resources when done.
PROC main() HANDLE
  DEF screen=NIL, drawinfo=NIL:PTR TO drawinfo, win=NIL:PTR TO window,
      myTEXTPEN, myBACKGROUNDPEN

  screen:=LockPubScreen(NIL)

  drawinfo:=GetScreenDrawInfo(screen)

  -> Get a copy of the correct pens for the screen.  This is very important in
  -> case the user or the application has the pens set in a unusual way.
  myTEXTPEN:=drawinfo.pens[TEXTPEN]
  myBACKGROUNDPEN:=drawinfo.pens[BACKGROUNDPEN]

  -> Open a simple window on the workbench screen for displaying a text string.
  -> An application would probably never use such a window, but it is useful
  -> for demonstrating graphics...
  win:=OpenWindowTagList(NIL, [WA_PUBSCREEN, screen, WA_RMBTRAP, TRUE, NIL])


  -> Draw the text string at 10, 10
  PrintIText(win.rport,
             [myTEXTPEN, myBACKGROUNDPEN, RP_JAM2, MYTEXT_LEFT, MYTEXT_TOP,
              [drawinfo.font.mn.ln.name, drawinfo.font.ysize,
               drawinfo.font.style, drawinfo.font.flags]:textattr,
              'Hello, World.  ;-)', NIL]:intuitext,
             10, 10)

  -> Wait a bit, then quit.
  -> In a real application, this would be an event loop, like the one described
  -> in the Intuition Input and Output Methods chapter.
  Delay(200)

EXCEPT DO
  IF win THEN CloseWindow(win)
  IF drawinfo THEN FreeScreenDrawInfo(screen, drawinfo)
  IF screen THEN UnlockPubScreen(NIL, screen)
  SELECT exception
  CASE ERR_DRAW; WriteF('Error: Failed to get DrawInfo for screen\n')
  CASE ERR_PUB;  WriteF('Error: Failed to lock public screen\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  ENDSELECT
ENDPROC
