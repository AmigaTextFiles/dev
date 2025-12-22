/* An old YAEC example converted to PortablE.
   Included with permission from Leif. */

->- Tree of Pythagoras
->- based on an old E example by Raymond Hoving

-> pythagoras.e - rewritten from SHEEP to e+ by (LS)

MODULE 'intuition', 'graphics'

PROC pythtree(ax:FLOAT, ay:FLOAT, bx:FLOAT, by:FLOAT, depth)
  DEF cx:FLOAT, cy:FLOAT, dx:FLOAT, dy:FLOAT, ex:FLOAT, ey:FLOAT, c

  cx := ax-ay+by
  cy := ax+ay-bx
  dx := bx+by-ay
  dy := ax-bx+by
  ex := cx-cy+dx+dy * 0.5
  ey := cx+cy-dx+dy * 0.5
  c := -1-(depth*$100020)
  Line(cx!!LONG, cy!!LONG, ax!!LONG, ay!!LONG, c)
  Line(ax!!LONG, ay!!LONG, bx!!LONG, by!!LONG, c)
  Line(bx!!LONG, by!!LONG, dx!!LONG, dy!!LONG, c)
  Line(dx!!LONG, dy!!LONG, cx!!LONG, cy!!LONG, c)
  Line(cx!!LONG, cy!!LONG, ex!!LONG, ey!!LONG, c)
  Line(ex!!LONG, ey!!LONG, dx!!LONG, dy!!LONG, c)
  
  IF depth < 12
    pythtree(cx,cy,ex,ey,depth+1)
    pythtree(ex,ey,dx,dy,depth+1)
  ENDIF
ENDPROC

CONST WIDTH=640, HEIGHT=480

PROC main()
   DEF w:PTR TO window
   IF w := OpenW(20,11,WIDTH+40, HEIGHT+30,$200,$E,'Pythagoras Tree!',NIL,1,NIL)
      pythtree((WIDTH/2)-(WIDTH/12), HEIGHT-20,
               (WIDTH/2)+(WIDTH/12), HEIGHT-20, 0)
      WaitLeftMouse(w)
      CloseW(w)
   ENDIF
ENDPROC
