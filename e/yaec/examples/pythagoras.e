->- Tree of Pythagoras
->- based on an old E example by Raymond Hoving

-> pythagoras.e - rewritten from SHEEP to e+ by (LS)

PROC pythtree(ax:FLOAT, ay:FLOAT, bx:FLOAT, by:FLOAT, depth:LONG)
  DEF cx:FLOAT, cy:FLOAT, dx:FLOAT, dy:FLOAT, ex:FLOAT, ey:FLOAT, c:LONG

  cx := ax-ay+by
  cy := ax+ay-bx
  dx := bx+by-ay
  dy := ax-bx+by
  ex := 0.5*(cx-cy+dx+dy)
  ey := 0.5*(cx+cy-dx+dy)
  c := -1-depth*$100020
  Line(cx!,cy!,ax!,ay!,c)
  Line(ax!,ay!,bx!,by!,c)
  Line(bx!,by!,dx!,dy!,c)
  Line(dx!,dy!,cx!,cy!,c)
  Line(cx!,cy!,ex!,ey!,c)
  Line(ex!,ey!,dx!,dy!,c)
  
  IF depth < 12
    pythtree(cx,cy,ex,ey,depth+1)
    pythtree(ex,ey,dx,dy,depth+1)
  ENDIF
ENDPROC

CONST WIDTH=640, HEIGHT=480

PROC main()
   DEF w
   IF w := OpenW(20,11,WIDTH+40, HEIGHT+30,$200,$E,'Pythagoras Tree!',NIL,1,NIL)
      pythtree((WIDTH/2)-(WIDTH/12)!,HEIGHT-20!,
               (WIDTH/2)+(WIDTH/12)!, HEIGHT-20!, 0)
      WaitLeftMouse(w)
      CloseW(w)
   ENDIF
ENDPROC