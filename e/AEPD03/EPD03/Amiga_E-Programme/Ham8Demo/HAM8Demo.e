OPT OSVERSION=37

MODULE 'gadtools','libraries/gadtools','intuition/intuition','exec/nodes',
       'intuition/screens','intuition/gadgetclass','graphics/text'

ENUM ER_NONE,ER_NOSCRN,ER_NOWINDOW

DEF wnd=NIL:PTR TO window,
    scr=NIL:PTR TO screen

PROC shutdown()
  IF wnd THEN CloseWindow(wnd)
  IF scr THEN CloseScreen(scr)
ENDPROC

PROC setup()
  IF (scr:=OpenScreenTagList(NIL,
    [SA_WIDTH,528,SA_HEIGHT,512,SA_DEPTH,8,SA_DISPLAYID,$8804,
     NIL,NIL]))=NIL THEN Raise(ER_NOSCRN)
  IF (wnd:=OpenWindowTagList(NIL,
    [WA_LEFT,0,
     WA_TOP,0,
     WA_WIDTH,528,
     WA_HEIGHT,512,
     WA_IDCMP,IDCMP_MOUSEBUTTONS,
     WA_FLAGS,WFLG_SIMPLE_REFRESH OR WFLG_NOCAREREFRESH OR
              WFLG_ACTIVATE OR WFLG_BORDERLESS,
     WA_CUSTOMSCREEN,scr,
     NIL]))=NIL THEN Raise(ER_NOWINDOW)
ENDPROC

PROC draw()
  DEF r,loop1,loop2,loop3
  r:=wnd.rport
  FOR loop1:=0 TO 7
    FOR loop2:=0 TO 7
      SetAPen(r,loop1*8+loop2+64)
      Move(r,loop2*66,loop1*64)
      Draw(r,loop2*66,loop1*64+63)
      FOR loop3:=0 TO 63
        SetAPen(r,loop3+128)
        Move(r,loop2*66+1,loop1*64+loop3)
        Draw(r,loop2*66+1,loop1*64+loop3)
        SetAPen(r,loop3+192)
        Move(r,loop2*66+2+loop3,loop1*64)
        Draw(r,loop2*66+2+loop3,loop1*64+63)
      ENDFOR
    ENDFOR
  ENDFOR
ENDPROC

PROC waitmouse()
  DEF mes:PTR TO intuimessage,quit=FALSE
  REPEAT
    IF mes:=GetMsg(wnd.userport)
      IF mes.class=IDCMP_MOUSEBUTTONS THEN quit:=TRUE
      ReplyMsg(mes)
    ELSE
      WaitPort(wnd.userport)
    ENDIF
  UNTIL quit
ENDPROC

PROC main() HANDLE
  DEF erlist:PTR TO LONG
  setup()
  draw()
  waitmouse()
  Raise(ER_NONE)
EXCEPT
  shutdown()
  IF exception>0
    erlist:=['open screen','open window']
    EasyRequestArgs(0,[20,0,0,'Could not \s.','OK'],0,[erlist[exception-1]])
  ENDIF
ENDPROC
