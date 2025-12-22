// Ferguson.d - example of how to generate ferguson's kubics (curves) in D

OPT	PPC

MODULE	'intuition/intuition',
			'utility/tagitem'

/*
	rp			- window rastport
	xA,yA		- coordinates of point A
	xa,ya		- vector in point A
	xB,yB		- coordinates of point B
	xb,yb		- vector in point B
	steps		- number of intersections
*/
PROC Ferguson(rp,xA:FLOAT,yA:FLOAT,xa:FLOAT,ya:FLOAT,xB:FLOAT,yB:FLOAT,xb:FLOAT,yb:FLOAT,steps)
	DEFF	delta,t,x,y,f0,f1,f2,f3
	DEF	i
	delta:=1.0/steps
	SetAPen(rp,1)
	x:=xA*20.0
	y:=yA*-20.0
	Move(rp,x+160,y+160)
//	PrintF('$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]\n',xA,yA,x,y)

	FOR i:=0 TO steps
		t:=delta*i
		f0:=2.0*t*t*t-3.0*t*t+1.0		// Ferguson's polynoms
		f1:=-2.0*t*t*t+3.0*t*t
		f2:=t*t*t-2.0*t*t+t
		f3:=t*t*t-t*t
		x:=xA*f0+xB*f1+xa*f2+xb*f3		// parametrical representations for x and y coords
		y:=yA*f0+yB*f1+ya*f2+yb*f3
		x*=20.0
		y*=-20.0
		Draw(rp,x+160,y+160)
//		WritePixel(rp,x+160,y+160)
	ENDFOR

ENDPROC

PROC main()
	DEF w:PTR TO Window
	IF w:=OpenWindowTags(NIL,
			WA_InnerWidth,320,
			WA_InnerHeight,320,
			WA_IDCMP,IDCMP_CLOSEWINDOW,
			WA_Flags,WFLG_DRAGBAR|WFLG_GIMMEZEROZERO|WFLG_RMBTRAP|WFLG_ACTIVATE|WFLG_CLOSEGADGET|WFLG_DEPTHGADGET,
			WA_Title,'Ferguson''s Cubic',
			TAG_END)
	
		Ferguson(w.RPort,
		  -5.0,  0.0,  // position of point A
		 -10.0, 10.0,  // vector in point A
		   5.0,  0.0,  // position of point B
		 -10.0,-10.0,  // vector in point B
		  1000)			// # of intersections
	
		WaitPort(w.UserPort)
		CloseWindow(w)
	ENDIF
ENDPROC

// MarK 7/8/99
