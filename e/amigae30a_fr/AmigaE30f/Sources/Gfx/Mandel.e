-> mini fractal

CONST CALCW=200,HEIGHT=100, DEPTH=25

PROC main()
  DEF w,xmax,ymax,x,y,xr,width=3.5,height=2.8,left,top
  IF w:=OpenW(20,11,240,130,$200,$E,'MiniFrac!',NIL,1,NIL)
    top:=!0.0-3.2; left:=!0.0-2.0; xmax:=CALCW!; ymax:=HEIGHT-1!
    FOR x:=0 TO CALCW-1
      xr:=x!/xmax*width+left
      FOR y:=0 TO HEIGHT-1 DO Plot(x+20,y+20,calc(xr,y!/ymax*height+top))
    ENDFOR
    WaitIMessage(w)
    CloseW(w)
  ENDIF
ENDPROC

PROC calc(x,y)
  DEF xtemp,it=0,xc,yc
  xc:=x; yc:=y
  WHILE (it++<DEPTH) AND (!x*x+y*y<16.0)
    xtemp:=x; x:=!x*x-(!y*y)+xc; y:=!xtemp+xtemp*y+yc
  ENDWHILE
ENDPROC it
