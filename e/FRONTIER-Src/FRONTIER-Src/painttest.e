/* 
 *  Test für die MIP-Zeichenroutinen
 * -================================-
 * 
 * 
 * 
 * 
 */

MODULE  'graphics/rastport'
MODULE  'intuition/intuition'

ENUM    ERR_NONE   =    0,
        ERR_WIN

CONST   WIN_WIDTH  =    640,
        WIN_HEIGHT =    480

CONST   WIN_IDCMP  =    IDCMP_MOUSEBUTTONS      OR
                        IDCMP_MOUSEMOVE         OR
                        IDCMP_CLOSEWINDOW       OR
                        IDCMP_VANILLAKEY

CONST   WIN_FLAGS  =    WFLG_ACTIVATE           OR
                        WFLG_DRAGBAR            OR
                        WFLG_CLOSEGADGET        OR
                        WFLG_DEPTHGADGET

ENUM    MODE_FREEHAND   = 1,    -> d
        MODE_LINE,              -> v
        MODE_BOX,               -> b
        MODE_FILLEDBOX,         -> B
        MODE_CIRCLE,            -> c
        MODE_FILLEDCIRCLE,      -> C
        MODE_ELLIPSE,           -> e
        MODE_FILLEDELLIPSE,     -> E
        MODE_POLYGON            -> p
                                -> k = Clear

DEF     win=NIL:PTR TO window,
        rport=NIL,
        mode=MODE_FREEHAND,
        button=FALSE,
        backcolor=0,            -> Shift+0-7 (MWB-Colors...) = !,",§,$,%,&,/,(
        color=1,                -> 1-8 (MWB-Colors...)
        oldx=0,                 -> "Alte" X-Coordinate (beim Mausklick)
        oldy=0,                 -> "Alte" Y-Coordinate (beim Mausklick)
        x=0,                    -> "Neue" X-Coordinate (Nach dem Mausklick)
        y=0                     -> "Neue" Y-Coordinate (nach dem Mausklick)

PROC main()     HANDLE
 openall()
  handleall()

EXCEPT DO
 closeall()
CleanUp(exception)
ENDPROC

PROC openall()
 IF (win:=OpenWindowTagList(NIL,
       [WA_LEFT,        0,
        WA_TOP,         0,
        WA_WIDTH,       WIN_WIDTH,
        WA_HEIGHT,      WIN_HEIGHT,
        WA_IDCMP,       WIN_IDCMP,
        WA_FLAGS,       WIN_FLAGS,
        NIL,            NIL]))=FALSE THEN Raise(ERR_WIN)
  rport:=win.rport
ENDPROC

PROC closeall()
  rport:=NIL
 IF (win<>NIL)  THEN CloseWindow(win)
ENDPROC

PROC handleall()
 DEF    quit=FALSE,
        class=NIL,
        code=NIL
  REPEAT
   class:=WaitIMessage(win)
    IF (class=IDCMP_CLOSEWINDOW)
     quit:=TRUE
    ELSEIF (class=IDCMP_MOUSEBUTTONS)
     code:=MsgCode()
      IF (code=SELECTDOWN)
       IF (mode<>MODE_POLYGON)
        oldx:=MouseX(win)
         oldy:=MouseY(win)
        button:=TRUE
       ENDIF
      ELSEIF (code=SELECTUP)
       x:=MouseX(win)
        y:=MouseY(win)
        domode()
       button:=FALSE
      ENDIF
    ELSEIF (class=IDCMP_VANILLAKEY)
     analysekey(MsgCode())
    ELSEIF (class=IDCMP_MOUSEMOVE)
     IF (mode=MODE_FREEHAND) AND (button=TRUE)
      oldx:=0
       oldy:=0
        x:=MouseX(win)
       y:=MouseY(win)
      domode()
     ENDIF
    ENDIF
  UNTIL (quit=TRUE) OR CtrlC()
ENDPROC

PROC analysekey(key)
 SELECT key
  CASE  "d"
   mode:=MODE_FREEHAND
  CASE  "v"
   mode:=MODE_LINE
  CASE  "b"
   mode:=MODE_BOX
  CASE  "B"
   mode:=MODE_FILLEDBOX
  CASE  "c"
   mode:=MODE_CIRCLE
  CASE  "C"
   mode:=MODE_FILLEDCIRCLE
  CASE  "e"
   mode:=MODE_ELLIPSE
  CASE  "E"
   mode:=MODE_FILLEDELLIPSE
  CASE  "p"
   mode:=MODE_POLYGON
  CASE  "1"
   color:=0
  CASE  "2"
   color:=1
  CASE  "3"
   color:=2
  CASE  "4"
   color:=3
  CASE  "5"
   color:=4
  CASE  "6"
   color:=5
  CASE  "7"
   color:=6
  CASE  "8"
   color:=7
  CASE  "!"
   backcolor:=0
  CASE  $22
   backcolor:=1
  CASE  "§"
   backcolor:=2
  CASE  "$"
   backcolor:=3
  CASE  "%"
   backcolor:=4
  CASE  "&"
   backcolor:=5
  CASE  "/"
   backcolor:=6
  CASE  "("
   backcolor:=7
  CASE  "k"
   SetAPen(rport,backcolor)
    SetBPen(rport,backcolor)
   RectFill(rport,0,0,win.width,win.height)
  RefreshWindowFrame(win)
 ENDSELECT
ENDPROC

PROC domode()
 DEF    relx=0,
        rely=0
  SetAPen(rport,color)
  SetBPen(rport,backcolor)
  SELECT mode
   CASE MODE_FREEHAND
    Move(rport,x,y)
     Draw(rport,x,y)
   CASE MODE_LINE
    Move(rport,oldx,oldy)
     Draw(rport,x,y)
   CASE MODE_BOX
    Move(rport,oldx,oldy)
     PolyDraw(rport,4,[x,oldy,  x,y,  oldx,y,  oldx,oldy]:INT)
   CASE MODE_FILLEDBOX
 
   CASE MODE_CIRCLE
    relx:=Abs(oldx-x)
     rely:=Abs(oldy-y)
    DrawEllipse(rport,oldx,oldy,IF (relx>rely) THEN relx ELSE rely,IF (relx>rely) THEN relx ELSE rely)
   CASE MODE_FILLEDCIRCLE
 
   CASE MODE_ELLIPSE
    relx:=Abs(oldx-x)
     rely:=Abs(oldy-y)
    DrawEllipse(rport,oldx,oldy,relx,rely)
   CASE MODE_FILLEDELLIPSE
 
   CASE MODE_POLYGON
    IF (oldx>0) AND (oldy>0) THEN Move(rport,oldx,oldy) ELSE Move(rport,x,y)
     Draw(rport,x,y)
    oldx:=x
   oldy:=y
  ENDSELECT
ENDPROC

