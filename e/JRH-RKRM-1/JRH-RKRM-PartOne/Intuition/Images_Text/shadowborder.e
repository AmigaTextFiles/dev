-> shadowborder.e - Program to show the use of an Intuition Border.

OPT OSVERSION=37  -> E-Note: silently require V37

MODULE 'graphics/rastport',
       'intuition/intuition',
       'intuition/screens'

ENUM ERR_NONE, ERR_DRAW, ERR_PUB, ERR_WIN

RAISE ERR_DRAW IF GetScreenDrawInfo()=NIL,
      ERR_PUB  IF LockPubScreen()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST MYBORDER_LEFT=0, MYBORDER_TOP=0

-> Main routine. Open required window and draw the images.  This routine opens
-> a very simple window with no IDCMP.  See the chapters on "Windows" and
-> "Input and Output Methods" for more info.  Free all resources when done.
PROC main() HANDLE
  DEF screen=NIL, win=NIL:PTR TO window, drawinfo=NIL:PTR TO drawinfo,
      shineBorder, shadowBorder, mySHADOWPEN=1, mySHINEPEN=2

  -> E-Note: C version doesn't think these should cause fatal errors...
  screen:=LockPubScreen(NIL)
  drawinfo:=GetScreenDrawInfo(screen)

  -> Get a copy of the correct pens for the screen.  This is very important in
  -> case the user or the application has the pens set in a unusual way.
  mySHADOWPEN:=drawinfo.pens[SHADOWPEN]
  mySHINEPEN:=drawinfo.pens[SHINEPEN]

  -> Open a simple window on the workbench screen for displaying a border.  An
  -> application would probably never use such a window, but it is useful for
  -> demonstrating graphics...
  -> E-Note: C version uses "screen" after unlocking it!
  win:=OpenWindowTagList(NIL, [WA_PUBSCREEN, screen, WA_RMBTRAP, TRUE, NIL])

  shineBorder:=[MYBORDER_LEFT, MYBORDER_TOP, mySHINEPEN, 0,
                RP_JAM1, 5, [0,0, 50,0, 50,30, 0,30, 0,0]:INT,
                NIL]:border
  shadowBorder:=[MYBORDER_LEFT+1, MYBORDER_TOP+1, mySHADOWPEN, 0,
                 RP_JAM1, 5, [0,0, 50,0, 50,30, 0,30, 0,0]:INT,
                 shineBorder]:border

  -> Draw the border at 10, 10
  DrawBorder(win.rport, shadowBorder, 10, 10)

  -> Draw the border again at 100, 10
  DrawBorder(win.rport, shadowBorder, 100, 10)

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