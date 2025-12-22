-> mini fractal example, also little timing...

OPT PREPROCESS,REG=5


/* Add comment for this line if You want NOFPU version of this example */
#define FPU

#ifdef FPU
MODULE 'bettermath/math_881_s','bettermath/math_881_test'
#endif

#ifndef FPU
MODULE 'bettermath/math_ieee_s'
#endif

MODULE 'dos/dos'

CONST TICKS_PER_MINUTE=TICKS_PER_SECOND*60
CONST CALCW=200,HEIGHT=100, DEPTH=25

PROC main()
  DEF w,xmax,ymax,x,y,xr,width=3.5,height=2.8,left,top,ds1:datestamp,ds2:datestamp,tct
#ifdef FPU
	IF ftestiffpu()
#endif

#ifdef FPU
		WriteF('This is FPU version of this program.\n')
#endif
#ifndef FPU
		WriteF('This is NOFPU version of this program.\n')
#endif

		finit()
	  IF w:=OpenW(0,11,CALCW+40,HEIGHT+30,$200,$E,'MiniFrac!',NIL,1,NIL)
			DateStamp(ds1)
	    top:=fsub(0.0,3.2)
		 	left:=fsub(0.0,2.0)
			xmax:=ftoreal(CALCW)
			ymax:=ftoreal(HEIGHT-1)

	    FOR x:=0 TO CALCW-1
			xr:=fadd(fmul(fdiv(ftoreal(x),xmax),width),left)
	      FOR y:=0 TO HEIGHT-1 DO Plot(x+20,y+20,calc(xr,fadd(fmul(fdiv(ftoreal(y),ymax),height),top)))
	    ENDFOR
			DateStamp(ds2)
			tct:=((ds2.minute-ds1.minute)*TICKS_PER_MINUTE)+ds2.tick-ds1.tick
			WaitIMessage(w)
	    CloseW(w)
			WriteF('Ticks:\d\n',tct)
		ELSE
			WriteF('Can''t open window !\n')
		ENDIF
		fend()
#ifdef FPU
	ELSE
		WriteF('Sorry, FPU is needed.\n')
  ENDIF
#endif

ENDPROC

PROC calc(x,y)
  DEF xtemp,it=0,xc,yc
  xc:=x; yc:=y

  WHILE (it++<DEPTH) AND (fcmp(fmul(fadd(fmul(x,x),y),y),16.0)=-1)
		xtemp:=x

		x:=fadd(fsub(fmul(x,x),fmul(y,y)),xc)
		y:=fadd(fmul(fadd(xtemp,xtemp),y),yc)
	
  ENDWHILE
ENDPROC it
