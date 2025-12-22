/* Ca ressemble à du raytracing.
   Ne fait pas grand chose fantastique. variez les
   positions des objets ball en dessous pour voir les effets */

OBJECT ball
  next,type,x,y,z,r,col
ENDOBJECT

CONST S=100,T_BALL=1,SP=1,MI=$7FFFFFF0

DEF first:PTR TO ball,scr=NIL,last,next

PROC main()
  scr:=OpenS(320,256,4,0,'Trace...')
  IF scr
    last:=[NIL,T_BALL,6500,5500,5000,500,3]:ball
    next:=[last,T_BALL,5000,5500,6000,1500,4]:ball
    first:=[next,T_BALL,4000,5500,5000,1000,1]:ball
    traceall()
    WHILE Mouse()<>1 DO NOP
    leave(NIL)
  ELSE
    leave('Ne peut pas ouvrir l\aécran!')
  ENDIF
ENDPROC

PROC traceall()
  DEF x,y
  FOR x:=1000 TO 9000
    FOR y:=1000 TO 9000
      Plot(x/S+20*SP,y/S+20*SP,tracepixel(5000,5000,1000,x,y,9000))
      y:=y+S
      IF Mouse()=1 THEN RETURN
    ENDFOR
    x:=x+S
  ENDFOR
ENDPROC

PROC tracepixel(x,y,z,x2,y2,z2)               /* trace beam, retourne rgb */
  DEF fx,fy,f,bx,by,dx,dy,obj:PTR TO ball,o,fbest=MI
  obj:=first; o:=first
  REPEAT
    f:=(obj.z-z*256)/(z2-z)
    fx:=x2-x*f/256              /* prend le facteur */
    fy:=y2-y*f/256
    bx:=obj.x-fx                /* nouvelle position de la balle */
    by:=obj.y-fy
    dx:=bx-x                /* distance balle <--> ligne */
    dy:=by-y
    IF (f<fbest) AND (sqrt(dx*dx+(dy*dy))<obj.r)
      fbest:=f
      o:=obj
    ENDIF
    obj:=obj.next
  UNTIL obj=NIL
  obj:=o
ENDPROC IF fbest<>MI THEN obj.col ELSE 2

PROC leave(erstr)
  IF scr THEN CloseS(scr)
  IF erstr THEN WriteF('\s\n',erstr)
  CleanUp(0)
ENDPROC

PROC sqrt(x) IS !Fsqrt(x!)!
