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
    [SA_WIDTH,80,SA_HEIGHT,64,SA_DEPTH,6,SA_DISPLAYID,$800,
     NIL,NIL]))=NIL THEN Raise(ER_NOSCRN)
  IF (wnd:=OpenWindowTagList(NIL,
    [WA_LEFT,0,
     WA_TOP,0,
     WA_WIDTH,80,
     WA_HEIGHT,64,
     WA_IDCMP,IDCMP_MOUSEBUTTONS,
     WA_FLAGS,WFLG_SIMPLE_REFRESH OR WFLG_NOCAREREFRESH OR
              WFLG_ACTIVATE OR WFLG_BORDERLESS,
     WA_CUSTOMSCREEN,scr,
     NIL]))=NIL THEN Raise(ER_NOWINDOW)
ENDPROC

PROC draw()
  DEF r,loop1,loop2,loop3
  r:=wnd.rport
  FOR loop1:=0 TO 3
    FOR loop2:=0 TO 3
      SetAPen(r,loop1*4+loop2+16)
      Move(r,loop2*18,loop1*16)
      Draw(r,loop2*18,loop1*16+15)
      FOR loop3:=0 TO 15
        SetAPen(r,loop3+32)
        Move(r,loop2*18+1,loop1*16+loop3)
        Draw(r,loop2*18+1,loop1*16+loop3)
        SetAPen(r,loop3+48)
        Move(r,loop2*18+2+loop3,loop1*16)
        Draw(r,loop2*18+2+loop3,loop1*16+15)
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

/*        mfG,
            TOB


The person you rejected yesterday could make you happy, if you say yes.
*/

