-> mousetest.e - Read position and button events from the mouse.
-> Modified for use with the middle-Mouse-Button by TurricaN
-> From the DARK FRONTIER (Grundler Mathias)
-> Modifications are marked with a  -> (!)

OPT OSVERSION=37

MODULE 'devices/inputevent',
       'exec/ports',
       'graphics/gfxbase',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens'

ENUM ERR_NONE, ERR_DRAW, ERR_PUB, ERR_WIN

RAISE ERR_DRAW IF GetScreenDrawInfo()=NIL,
      ERR_PUB  IF LockPubScreen()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

-> E-Note: C version should use this for a string...
CONST BUFSIZE=15

-> Something to use to track the time between messages to test for
-> double-clicks.
OBJECT myTimeVal
  leftSeconds,  leftMicros
  midSeconds,   midMicros       -> (!)
  rightSeconds, rightMicros
ENDOBJECT

PROC main() HANDLE
  DEF win=NIL:PTR TO window, scr=NIL:PTR TO screen,
      dr_info=NIL:PTR TO drawinfo, width, gfx:PTR TO gfxbase

  -> Lock the default public screen in order to read its DrawInfo data
  scr:=LockPubScreen(NIL)

  dr_info:=GetScreenDrawInfo(scr)

  -> Use wider of space needed for output (18 chars and spaces) or titlebar
  -> text plus room for titlebar gads (approx 18 each)
  -> E-Note: get the right type for gfxbase
  gfx:=gfxbase
  width:=Max(gfx.defaultfont.xsize * 18,
             (18*2)+TextLength(scr.rastport, 'MouseTest', STRLEN))

  win:=OpenWindowTagList(NIL,
                        [WA_TOP,    20,
                         WA_LEFT,   100,
                         WA_INNERWIDTH,  width,
                         WA_HEIGHT, (2*gfx.defaultfont.ysize)+
                                    scr.wbortop+scr.font.ysize+1+scr.wborbottom,
                         WA_FLAGS, WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
                                     WFLG_ACTIVATE  OR WFLG_REPORTMOUSE OR
                                     WFLG_RMBTRAP   OR WFLG_DRAGBAR,
                         WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY OR
                                     IDCMP_MOUSEMOVE OR IDCMP_MOUSEBUTTONS,
                         WA_TITLE, 'MouseTest',
                         WA_PUBSCREEN, scr,
                         NIL])

  WriteF('Monitors the Mouse:\n')
  WriteF('    Move Mouse, Click and DoubleClick in Windows\n')

  SetAPen(win.rport, dr_info.pens[TEXTPEN])
  SetBPen(win.rport, dr_info.pens[BACKGROUNDPEN])
  SetDrMd(win.rport, RP_JAM2)

  process_window(win)

EXCEPT DO
  IF win THEN CloseWindow(win)
  IF dr_info THEN FreeScreenDrawInfo(scr, dr_info)
  IF scr THEN UnlockPubScreen(NIL, scr)
  SELECT exception
  CASE ERR_DRAW; WriteF('Error: Failed to get DrawInfo for screen\n')
  CASE ERR_PUB;  WriteF('Error: Failed to lock public screen\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  ENDSELECT
ENDPROC

-> process_window() - Simple message loop for processing IntuiMessages
PROC process_window(win:PTR TO window)
  -> E-Note: C version failed to use BUFSIZE!
  DEF going, msg:PTR TO intuimessage, class, tv, prt_buff[BUFSIZE]:STRING,
      xText, yText  -> Places to position text in window

  -> E-Note: going rather than done saves a lot of Not()-ing
  going:=TRUE
  tv:=[0, 0, 0, 0]:myTimeVal
  xText:=win.borderleft+(win.ifont.xsize*2)
  yText:=win.bordertop+3+win.ifont.baseline

  -> E-Note: we can't use WaitIMessage() because we want mousex, mousey
  WHILE going
    Wait(Shl(1, win.userport.sigbit))
    WHILE going AND (msg:=GetMsg(win.userport))
      class:=msg.class
      SELECT class
      CASE IDCMP_CLOSEWINDOW
        going:=FALSE

      -> NOTE NOTE NOTE:  If the mouse queue backs up a lot, Intuition will
      -> start dropping MOUSEMOVE messages off the end until the queue is
      -> serviced.  This may cause the program to lose some of the MOUSEMOVE
      -> events at the end of the stream.
      ->
      -> Look in the window structure if you need the true position of the
      -> mouse pointer at any given time.  Look in the MOUSEBUTTONS message if
      -> you need position when it clicked.  An alternate to this processing
      -> would be to set a flag that a mousemove event arrived, then print the
      -> position of the mouse outside of a "WHILE GetMsg()" loop.  This allows
      -> a single processing call for many mouse events, which speeds up
      -> processing A LOT!  Something like:
      ->
      -> WHILE GetMsg()
      ->   IF class=IDCMP_MOUSEMOVE THEN mouse_flag:= TRUE
      ->    ReplyMsg()  -> NOTE: copy out all needed fields first !
      -> ENDWHILE
      -> IF mouse_flag
      ->   process_mouse_event()
      ->   mouse_flag:=FALSE
      -> ENDIF
      ->
      -> You can also use IDCMP_INTUITICKS for slower paced messages (all
      -> messages have mouse coordinates.)
      CASE IDCMP_MOUSEMOVE
	-> Show the current position of the mouse relative to the upper left
        -> hand corner of our window
	Move(win.rport, xText, yText)
	StringF(prt_buff, 'X=\d[5] Y=\d[5]', msg.mousex, msg.mousey)
        Text(win.rport, prt_buff, BUFSIZE)
      CASE IDCMP_MOUSEBUTTONS
        doButtons(msg, tv)
      ENDSELECT
      ReplyMsg(msg)
    ENDWHILE
  ENDWHILE
ENDPROC

-> Show what mouse buttons where pushed
PROC doButtons(msg:PTR TO intuimessage, tv:PTR TO myTimeVal)
  DEF code
  IF msg.qualifier AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
    WriteF('Shift ')
  ENDIF

  code:=msg.code
  SELECT code
  CASE SELECTDOWN
    WriteF('Left Button Down at X=\d Y=\d', msg.mousex, msg.mousey)
    IF DoubleClick(tv.leftSeconds, tv.leftMicros, msg.seconds, msg.micros)
      WriteF(' DoubleClick!')
    ELSE
      tv.leftSeconds:=msg.seconds
      tv.leftMicros:=msg.micros
      tv.rightSeconds:=0
      tv.rightMicros:=0
    ENDIF
  CASE SELECTUP
    WriteF('Left Button Up   at X=\d Y=\d', msg.mousex, msg.mousey)
  CASE MENUDOWN
    WriteF('Right Button Down at X=\d Y=\d', msg.mousex, msg.mousey)
    IF DoubleClick(tv.rightSeconds, tv.rightMicros, msg.seconds, msg.micros)
      WriteF(' DoubleClick!')
    ELSE
      tv.leftSeconds:=0
      tv.leftMicros:=0
      tv.rightSeconds:=msg.seconds
      tv.rightMicros:=msg.micros
    ENDIF
  CASE MENUUP
    WriteF('Right Button Up   at X=\d Y=\d', msg.mousex, msg.mousey)
  CASE MIDDLEDOWN               -> (!)
    WriteF('Middle Button Down at X=\d Y|\d', msg.mousex, msg.mousey)   -> (!)
    IF DoubleClick(tv.midSeconds, tv.midMicros, msg.seconds, msg.micros)-> (!)
      WriteF(' DoubleClick!')   -> (!)
    ELSE                        -> (!)
      tv.midSeconds:=0          -> (!)
      tv.midMicros:=0           -> (!)
      tv.midSeconds:=msg.seconds-> (!)
      tv.midMicros:=msg.micros  -> (!)
    ENDIF                       -> (!)
  CASE MIDDLEUP                 -> (!)
    WriteF('Middle Button UP at X=\d Y|\d', msg.mousex, msg.mousey)     -> (!)
  ENDSELECT
  WriteF('\n')
ENDPROC
