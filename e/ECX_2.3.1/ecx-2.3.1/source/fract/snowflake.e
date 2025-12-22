/*  Kochsche Schneeflocke
 *  Norman Walter 25.12.2001
 *  Demonstriert rekursive Algorithmen
 *  und die Verwendung der Amiga Grafik-Primitiven
 */

-> Ported from C to E by LS 2004
-> Has some bug in it, maybe YOU can fix it :)

->OPT STACK = 320000

MODULE 'intuition/intuition'

DEF window:PTR TO window

PROC draw_lines(x0,y0,x1,y1)
   DEF ax,ay
   DEF bx,by
   DEF cx,cy
   DEF dx,dy
   DEF ex,ey

   ax := x0
   ay := y0

   bx := ! 2.0 * x0 + x1 / 3.0
   by := ! 2.0 * y0 + y1 / 3.0

   cx := ! x0 + x1 / 2.0 - (! Fsqrt(3.0) / 6.0 * (! y1 - y0))
   cy := ! y0 + y1 / 2.0 + (! Fsqrt(3.0) / 6.0 * (! x1 - x0))

   dx := ! x0 + (! 2.0 * x1) / 3.0
   dy := ! y0 + (! 2.0 * y1) / 3.0

   ex := x1
   ey := y1

   IF FreeStack() < 1600 THEN Raise("STCK")
   IF ! Fpow(! x0 - x1, 2.0) + Fpow(! y0 - y1, 2.0) < 4.0
      Move(window.rport, !x0!, !y0!)
      Draw(window.rport, !x1!, !y1!)
   ELSE
      draw_lines(ax,ay,bx,by)
      draw_lines(bx,by,cx,cy)
      draw_lines(cx,cy,dx,dy)
      draw_lines(dx,dy,ex,ey)
   ENDIF

ENDPROC

PROC main() HANDLE
   DEF p1x=100.0, p1y=100.0
   DEF p2x=200.0, p2y=150.0
   DEF p3x=300.0, p3y=100.0

   p2y := ! p2y * Fsqrt(3.0)

   window := OpenW(20,
                   20,
                   400,
                   300,
                   NIL,
                   $F,
                   'Snowflake',
                   NIL,1,NIL)

   IF window = NIL THEN Raise("WIN")

   SetAPen(window.rport, 1)
   RectFill(window.rport,10,10,390,290)

   SetAPen(window.rport, 2)

   draw_lines(p1x,p1y,p2x,p2y)
   draw_lines(p2x,p2y,p3x,p3y)
   draw_lines(p3x,p3y,p1x,p1y)

   WaitLeftMouse(window)

EXCEPT DO
   SELECT exception
   CASE "WIN"  ; WriteF('could not open window!\n')
   CASE "STCK" ; WriteF('out of stack!\n')
   ENDSELECT

   CloseW(window)

ENDPROC


