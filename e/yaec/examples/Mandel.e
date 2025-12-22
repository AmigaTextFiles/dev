-> mini fractal

-> yaec-note : typed most of the vars, got rid of some "!":s

CONST CALCW=200,HEIGHT=100, DEPTH=25

PROC main()
  DEF w,xmax:FLOAT,ymax:FLOAT,x:LONG,y:LONG,xr:FLOAT,width=3.5:FLOAT,
      height=2.8:FLOAT,left:FLOAT,top:FLOAT
  IF w:=OpenW(20,11,CALCW+40,HEIGHT+30,$200,$E,'MiniFrac!',NIL,1,NIL)
    top:=0.0-1.6; left:=0.0-2.0; xmax:=CALCW!; ymax:=HEIGHT-1!
    FOR x:=0 TO CALCW-1
      xr:=x!/xmax*width+left
      FOR y:=0 TO HEIGHT-1 DO Plot(x+20,y+20, calc(xr,y!/ymax*height+top))
    ENDFOR
    WaitIMessage(w)
    CloseW(w)
  ENDIF
ENDPROC

PROC calc(x:FLOAT,y:FLOAT)
  DEF xtemp:FLOAT,it=0:LONG,xc:FLOAT,yc:FLOAT
  xc:=x; yc:=y
  WHILE (it++<DEPTH) AND ((x*x+(y*y))<16.0)
    xtemp:=x; x:=x*x-(y*y)+xc; y:=xtemp+xtemp*y+yc
  ENDWHILE
ENDPROC it
