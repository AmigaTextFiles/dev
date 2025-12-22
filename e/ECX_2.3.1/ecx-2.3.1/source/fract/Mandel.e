-> mini fractal

-> With CALCW=800, HEIGHT=600, DEPTH=255:
-> EC compiled, running under MorphOS 68k emulation : 60 seconds to render.
-> ECX compiled for 68k, running under MorphOS emulation: 39 seconds to render.
-> ECX compiled, running natively under morphos: 3 seconds ! :-D

CONST CALCW=800,HEIGHT=600, DEPTH=255

PROC main()
  DEF w,xmax,ymax,x,y,xr,width=3.5,height=2.8,left,top
  IF w:=OpenW(20,11,CALCW+30,HEIGHT+40,$200,$E,'MiniFrac!',NIL,1,NIL)
    top:=!0.0-1.6; left:=!0.0-2.0; xmax:=CALCW!; ymax:=HEIGHT-1!
    FOR x:=0 TO CALCW-1
      xr:=x!/xmax*width+left
      FOR y:=0 TO HEIGHT-1 DO Plot(x+20,y+25,calc(xr,y!/ymax*height+top))
    ENDFOR
    WaitIMessage(w)
    CloseW(w)
  ELSE
     WriteF('could not open window!\n')
  ENDIF
ENDPROC

PROC calc(x,y)
  DEF xtemp,it=0,xc,yc
  xc:=x; yc:=y
  WHILE (it++<DEPTH) AND (!x*x+(!y*y)<16.0)
    xtemp:=x; x:=!x*x-(!y*y)+xc; y:=!xtemp+xtemp*y+yc
  ENDWHILE
ENDPROC it
