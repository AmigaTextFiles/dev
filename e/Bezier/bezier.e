/****** teaching/bezier *******************************************
* 
*   NAME
*       bezier -- draw moving Bézier spline.
*
*   SYNOPSIS
*       bezier
*
*   FUNCTION
*       Draws an animated Bézier spline on the screen.
*       Demonstrates with 4 rebounding points on screen, A B C and D.
*       You should see that the spline runs from A to D, heading to B
*       from point A, and ending facing away from C at point D. If that
*       didn't make sense, just run it :)
*
*       Working example to accompany tutorial in Defy 4 from Cydonia :)
*
*   RESULT
*       Demonstrates the following topics:
*       - ASL ScreenMode requester
*       - Intuition double-buffering
*       - Use of fixed-point math. (fixed.m)
*       - Basic 680x0 instructions
*       - Recursive subdivision
*
*   EXAMPLES
*       As an exercise for the reader, possible extensions include:
*       - Multiple splines - trails, joined shapes, screen blankers
*       - Automated decisions on how many subdivisions to make, and whether
*         to use points or lines.
*       - User influence on movement
*
*   NOTE
*       You should be able to see two levels of abstraction here. The main
*       loop is concerned with the screen buffering, timing and user input,
*       whereas init()/done() and draw() only know of a 'virtual' screen
*       whose boundaries are given in init, and they may only write using
*       stdrast and graphics functions.
*
*       We use 'fixed point' arithmetic - basically, add 16 bits of extra
*       significance, work with it, then take it away when finished
*       calculating.
*
*       We use a very complicated line of code in the double-buffering code:
*       IF sig THEN
*         WHILE m:=GetMsg(port) DO status[1-Long(m+SIZEOF mn)]:=OK_REDRAW
*
*       Basically, on the first run we are allowed to draw into either buffer
*       then 'swap it in'. When we swap it in, we ask the system to send us
*       a message to say it has been swapped in, therefore the other buffer
*       has been swapped out. We know that it will use the message in the
*       DBufInfo structure, and right after this is the UserData1 long.
*       So we can access the long directly after the message we get from
*       GetMsg(), 'Long(m + SIZEOF mn)', and say that the other buffer
*       '1-', is ok to redraw into: 'status[...]:=OK_REDRAW'
*
*   SEE ALSO
*       bezier.txt
*
****************************************************************************
*
*
*/

OPT PREPROCESS
OPT OSVERSION=39

MODULE 'asl', 'exec/ports', 'graphics/displayinfo', 'graphics/rastport',
       'graphics/view', 'intuition/intuition', 'intuition/screens',
       'libraries/asl', 'utility/tagitem', '*fixed'

-> the left/top/right/bottom edges of our screen
DEF lft, top, rgt, bot

->--------------------------------------------------------------------------

-> A B C and D are vectors - points on the screen with a direction.
OBJECT vector
   x,  y
   dx, dy
ENDOBJECT

DEF a:PTR TO vector,
    b:PTR TO vector,
    c:PTR TO vector,
    d:PTR TO vector

PROC rand() OF vector
  -> create new vector with random position/movement (within screen limits)

  self.x  := Rnd(rgt-lft) + lft
  self.y  := Rnd(bot-top) + top
  self.dx := (Rnd(10)-5) OR 1  -> between -5 and 5 but not 0
  self.dy := (Rnd(10)-5) OR 1
ENDPROC

PROC move() OF vector
  -> move and bounce around the limits of the screen (l/r/t/b)

  IF self.x <= lft THEN self.dx :=  (Rnd(5) OR 1)
  IF self.x >= rgt THEN self.dx := -(Rnd(5) OR 1)
  IF self.y <= top THEN self.dy :=  (Rnd(5) OR 1)
  IF self.y >= bot THEN self.dy := -(Rnd(5) OR 1)

  self.x:=Bounds(self.x+self.dx, lft, rgt)
  self.y:=Bounds(self.y+self.dy, top, bot)
ENDPROC

->--------------------------------------------------------------------------

PROC init(leftedge, topedge, width, height)
  -> This is called once at the start from the main program, with
  -> leftedge/topedge and width/height of the screen we'll be rendering on

  -> make a quite (!!) random seed
  DEF bla; CurrentTime({bla},{bla}); Rnd(-Abs(Mul({arg},bla)))

  -> we set up the edges of our 'screen' appropriately
  lft := leftedge
  rgt := leftedge + width  - 1
  top := topedge
  bot := topedge  + height - 1

  -> create and give random positions and directions to our vectors
  NEW a.rand()
  NEW b.rand()
  NEW c.rand()
  NEW d.rand()
ENDPROC

PROC done()
  END a; END b; END c; END d
ENDPROC

PROC draw()
  -> called once per frame from the main loop. We should draw whatever to
  -> stdrast.

  -> clear screen
  SetAPen(stdrast, 0)
  RectFill(stdrast, lft, top, rgt, bot)

  -> move vectors a, b, c and d.
  a.move(); b.move(); c.move(); d.move()

  -> draw b to a to d to c in white
  SetAPen(stdrast, 2)
  Move(stdrast, b.x, b.y)
  Draw(stdrast, a.x, a.y)
  Draw(stdrast, d.x, d.y)
  Draw(stdrast, c.x, c.y)

  -> draw bézier curve in black
  SetAPen(stdrast, 1)
  bezier(
   inttofixed(a.x), inttofixed(a.y),
   inttofixed(b.x), inttofixed(b.y),
   inttofixed(c.x), inttofixed(c.y),
   inttofixed(d.x), inttofixed(d.y)
  )
ENDPROC

->--------------------------------------------------------------------------

PROC bezier(p1_x,p1_y, p2_x,p2_y, p3_x,p3_y, p4_x,p4_y, level=0)
  ->  with thanks to Storm/Cydonia

  -> All  we  do  is  divide the curve into two seperate curves, and repeat
  -> this  division  until we have many curves in which case we have enough
  -> accuracy to get away with drawing these tiny curves as straight lines.

  -> P1  is  the start point of the curve (or curve segment). P4 is the end
  -> point. P2 and P3 are the control points of it. We divide the 'P' curve
  -> into  two  curves,  the  'L'  curve  (L1/L2/L3/L4)  and  the 'R' curve
  -> (R1/R2/R3/R4).  The  L curve goes from the start point to the midpoint
  -> of the P curve. The R curve goes from the midpoint to the end point of
  -> the P curve.

  -> we do this 5 times, and end up with 2^5 parts = 32 line segments

  -> note that we take in and calculate with 'fixed point' coordinates
  -> and turn them back into normal integers to draw the line segments.

  DEF l1_x,l1_y, l2_x,l2_y, l3_x,l3_y, l4_x,l4_y,
      r1_x,r1_y, r2_x,r2_y, r3_x,r3_y, r4_x,r4_y,
      h_x, h_y

  IF level>4
    Move(stdrast, fixedtoint(p1_x), fixedtoint(p1_y))
    Draw(stdrast, fixedtoint(p4_x), fixedtoint(p4_y))
    RETURN
  ENDIF

  -> register D1 = constant 1 (to speed up the LSR command)
  MOVEQ   #1,D1

  -> L1 = P1
  MOVE.L  p1_x,l1_x
  MOVE.L  p1_y,l1_y

  -> R4 = P4
  MOVE.L  p4_x,r4_x
  MOVE.L  p4_y,r4_y

  -> L2 = average(P1, P2)
  MOVE.L p1_x,D0; ADD.L p2_x,D0; LSR.L D1,D0; MOVE.L D0,l2_x
  MOVE.L p1_y,D0; ADD.L p2_y,D0; LSR.L D1,D0; MOVE.L D0,l2_y

  -> R3 = average(P3, P4)
  MOVE.L p3_x,D0; ADD.L p4_x,D0; LSR.L D1,D0; MOVE.L D0,r3_x
  MOVE.L p3_y,D0; ADD.L p4_y,D0; LSR.L D1,D0; MOVE.L D0,r3_y

  -> H = average(P2, P3)
  MOVE.L p2_x,D0; ADD.L p3_x,D0; LSR.L D1,D0; MOVE.L D0,h_x
  MOVE.L p2_y,D0; ADD.L p3_y,D0; LSR.L D1,D0; MOVE.L D0,h_y

  -> L3 = average(L2, H)
  MOVE.L l2_x,D0; ADD.L h_x,D0; LSR.L D1,D0; MOVE.L D0,l3_x
  MOVE.L l2_y,D0; ADD.L h_y,D0; LSR.L D1,D0; MOVE.L D0,l3_y

  -> R2 = average(R3, H)
  MOVE.L r3_x,D0; ADD.L h_x,D0; LSR.L D1,D0; MOVE.L D0,r2_x
  MOVE.L r3_y,D0; ADD.L h_y,D0; LSR.L D1,D0; MOVE.L D0,r2_y

  -> L4 = average(L3, R2)
  MOVE.L l3_x,D0; ADD.L r2_x,D0; LSR.L D1,D0; MOVE.L D0,l4_x
  MOVE.L l3_y,D0; ADD.L r2_y,D0; LSR.L D1,D0; MOVE.L D0,l4_y

  -> R1 = L4
  MOVE.L  l4_x,r1_x
  MOVE.L  l4_y,r1_y

  -> and subdivide again...
  bezier(l1_x,l1_y, l2_x,l2_y, l3_x,l3_y, l4_x,l4_y, level+1)
  bezier(r1_x,r1_y, r2_x,r2_y, r3_x,r3_y, r4_x,r4_y, level+1)
ENDPROC

->--------------------------------------------------------------------------

ENUM OK_NONE,OK_REDRAW,OK_SWAPIN

PROC main() HANDLE
  -> the main program - handle allocations, buffers, input, etc

  DEF s=NIL:PTR TO screen, w=NIL:PTR TO window, m:PTR TO intuimessage,

      sb:PTR TO screenbuffer, rp[2]:ARRAY OF rastport,
      status[2]:ARRAY OF LONG, sbuf[2]:ARRAY OF LONG,
      port=NIL:PTR TO mp,
      held_off=FALSE, sigs=0, buf_current=0, buf_nextdraw=1, buf_nextswap=1

  sbuf:=[NIL, NIL]
  status:=[OK_REDRAW, OK_REDRAW]
  InitRastPort(rp[0])
  InitRastPort(rp[1])

  IF (port:=CreateMsgPort())=NIL THEN Raise()

  -> open the screen
  s := OpenScreenTagList(NIL, [
    SA_DEPTH,     2,
    SA_DISPLAYID, asl_modereq(),
    SA_TITLE,     'Bézier spline demo',
    SA_PENS,      [-1]:INT,
    TAG_DONE
  ])
  IF s=NIL THEN Raise()

  sbuf[0]:=AllocScreenBuffer(s, NIL, SB_SCREEN_BITMAP)
  sbuf[1]:=AllocScreenBuffer(s, NIL, SB_COPY_BITMAP)

  IF (sbuf[0] AND sbuf[1])=NIL THEN Raise()

  sb:=sbuf[0]; sb.dbufinfo.userdata1:=0; rp[0].bitmap:=sb.bitmap
  sb:=sbuf[1]; sb.dbufinfo.userdata1:=1; rp[1].bitmap:=sb.bitmap

  -> open a window to recieve input on the screen
  w := OpenWindowTagList(NIL, [
    WA_CUSTOMSCREEN, s,
    WA_FLAGS,        WFLG_BORDERLESS OR WFLG_RMBTRAP,
    WA_IDCMP,        IDCMP_VANILLAKEY OR IDCMP_MOUSEBUTTONS,
    WA_BACKDROP,     TRUE,
    WA_BORDERLESS,   TRUE,
    WA_ACTIVATE,     TRUE,
    TAG_DONE
  ])
  IF w=NIL THEN Raise()

  init(0, s.barheight+1, s.width, s.height-s.barheight-1)

  REPEAT
    IF sigs THEN WHILE m:=GetMsg(port) DO status[1-Long(m+SIZEOF mn)]:=OK_REDRAW

    held_off:=FALSE

    IF status[buf_nextdraw]=OK_REDRAW
      stdrast:=rp[buf_nextdraw]
      draw()
      WaitBlit()
      status[buf_nextdraw]:=OK_SWAPIN
      buf_nextdraw:=1-buf_nextdraw
    ENDIF

    IF status[buf_nextswap]=OK_SWAPIN
      sb:=sbuf[buf_nextswap]
      sb.dbufinfo.safemessage.replyport:=port
      IF ChangeScreenBuffer(s, sb)
        status[buf_nextswap]:=OK_NONE
        buf_current:=buf_nextswap
        buf_nextswap:=1-buf_nextswap
      ELSE
        held_off:=TRUE
      ENDIF
    ENDIF

    IF held_off THEN WaitTOF() ELSE sigs:=Wait(Shl(1,port.sigbit))
  UNTIL CtrlC() OR (IF m:=GetMsg(w.userport) THEN ReplyMsg(m) BUT 1 ELSE 0)

  done()

EXCEPT DO
  IF w       THEN CloseWindow(w)
  IF sbuf[1] THEN FreeScreenBuffer(s, sbuf[1])
  IF sbuf[0] THEN FreeScreenBuffer(s, sbuf[0])
  IF s       THEN CloseScreen(s)
  IF port    THEN DeleteMsgPort(port)
ENDPROC

->--------------------------------------------------------------------------

PROC asl_modereq()
  -> a little moderequester
  -> will return modeid of chosen mode if user successfully
  -> chose a screenmode, otherwise will Raise()

  DEF req:PTR TO screenmoderequester, modeid, result=0

  IF aslbase := OpenLibrary('asl.library',37)
    IF req := AllocAslRequest(ASL_SCREENMODEREQUEST, NIL)
      result := AslRequest(req, NIL)
      modeid := req.displayid
      FreeAslRequest(req)
    ENDIF
    CloseLibrary(aslbase)
  ENDIF

  IF result=0 THEN Raise() -> if user actually chose 'Cancel'

ENDPROC modeid
