/* mandelbrot en 256 niveau de gris avec du code 68881 en ligne

   ATTENTION : ce programme ne tourne pas sans un FPU/AGA!

*/

MODULE '*mandelcalc881'

CONST WIDTH=320,HEIGHT=256,MODUS=$0,FAC=4

DEF top,left,bottom,right,width,height,xmax,ymax

PROC main() HANDLE
  DEF scr,view,a,b
  IF (scr:=OpenS(WIDTH,HEIGHT,8,MODUS,'Mandel256'))=NIL THEN Raise(0)
  view:=scr+44
  SetRGB32(view,0,0,0,0)
  FOR a:=1 TO 255 DO (b:=Shl(256-a,24)) BUT SetRGB32(view,a,b,b,b)
  mandel()
  WHILE Mouse()=0 DO NOP
EXCEPT DO
  CloseS(scr)
ENDPROC

PROC mandel()
  left:=-2.5; right:=1.0
  top:=-1.4; bottom:=1.4
  width:=!right-left
  height:=!bottom-top
  xmax:=WIDTH!
  ymax:=HEIGHT-1!
  recmandel(0,0,WIDTH-1,HEIGHT-1)
ENDPROC

PROC recmandel(x1,y1,x2,y2)
  DEF p1,p2,p3,p4,xm,ym,a
  IF Mouse() THEN Raise(0)
  IF FreeStack()<1000 THEN Raise(0)
  p1:=calcxy(x1,y1)
  p2:=calcxy(x2,y1)
  p3:=calcxy(x2,y2)
  p4:=calcxy(x1,y2)
  IF (p1=p2) AND (p2=p3) AND (p3=p4) AND (Sign(x1)=Sign(x2)) AND (Sign(y1)=Sign(y2))
    Box(x1,y1,x2,y2,p1)
  ELSE
    Plot(x1,y1,p1)
    Plot(x2,y1,p2)
    Plot(x2,y2,p3)
    Plot(x1,y2,p4)
    IF (x2-x1<2) OR (y2-y1<2)
      IF x2-x1>1
        FOR a:=x1+1 TO x2-1 DO plotxy(a,y1)
        IF HEIGHT-1=y2 THEN FOR a:=x1+1 TO x2-1 DO plotxy(a,y2)
      ENDIF
      IF y2-y1>1
        FOR a:=y1+1 TO y2-1 DO plotxy(x1,a)
        IF WIDTH-1=x2 THEN FOR a:=y1+1 TO y2-1 DO plotxy(x2,a)
      ENDIF
    ELSE
      xm:=x1+x2/2
      ym:=y1+y2/2
      recmandel(x1,y1,xm,ym)
      recmandel(xm,y1,x2,ym)
      recmandel(x1,ym,xm,y2)
      recmandel(xm,ym,x2,y2)
    ENDIF
  ENDIF
ENDPROC

PROC calcxy(x,y)
  DEF xr,yr
  xr:=x!/xmax*width+left
  yr:=y!/ymax*height+top
ENDPROC calc(256/FAC,xr,yr)*FAC

PROC plotxy(x,y)
  Plot(x,y,calcxy(x,y))
ENDPROC
