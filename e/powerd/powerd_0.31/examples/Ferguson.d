// Ferguson.d - example of how to generate ferguson's cubics (curves) in D
// requires workbench height of atleast ~340 pixels and fpu

MODULE	'intuition/intuition',
			'utility/tagitem'

PROC main()
	DEF	w:PTR TO Window,class,change=FALSE,code,x,y
	DEF	id=-1,drag:PTR TO xy
	IF w:=OpenWindowTags(NIL,
			WA_InnerWidth,320,
			WA_InnerHeight,320,
			WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_MOUSEMOVE,
			WA_Flags,WFLG_DRAGBAR|WFLG_GIMMEZEROZERO|WFLG_RMBTRAP|WFLG_ACTIVATE|WFLG_CLOSEGADGET|WFLG_DEPTHGADGET|WFLG_REPORTMOUSE,
			WA_Title,'Ferguson''s Cubic',
			TAG_END)

		drag:=[			// draggable points
			-50,0,		// position of point A
			+50,100,		// position of vector in point A
			+50,0,		// position of point B
			+150,-100	// position of vector in point B
			]:xy

		draw	// watch the definition below

		EasyRequestArgs(0,[SIZEOF_EasyStruct,0,0,'Drag those points and enjoy :)','Yea']:EasyStruct,0,NIL)

		WHILE (class,code:=WaitIMessage(w))<>IDCMP_CLOSEWINDOW
			SELECT class
			CASE IDCMP_MOUSEBUTTONS
				SELECT code
				CASE SELECTDOWN
					x:=w.GZZMouseX-160
					y:=w.GZZMouseY-160
					IF (id:=Drag(x,y,drag,4))>=0 THEN change:=TRUE
				DEFAULT
					id:=-1
				ENDSELECT
			CASE IDCMP_MOUSEMOVE
				IF id>=0
					x:=w.GZZMouseX-160
					y:=w.GZZMouseY-160
					drag[id].x:=x
					drag[id].y:=y
					change:=TRUE
				ENDIF
			ENDSELECT
		NEXTIF change=FALSE
			draw	// watch the definition below
			change:=FALSE
		ENDWHILE

		CloseWindow(w)
	ENDIF

	SUB draw		// this is new feature from v0.16 of PowerD :)
		SetRast(w.RPort,0)
		DrawLine(w.RPort,drag[0].x,drag[0].y,drag[1].x,drag[1].y)
		DrawLine(w.RPort,drag[2].x,drag[2].y,drag[3].x,drag[3].y)
		Ferguson(w.RPort,
			drag[0].x,drag[0].y,
			drag[0].x-drag[1].x,drag[0].y-drag[1].y,
			drag[2].x,drag[2].y,
			drag[2].x-drag[3].x,drag[2].y-drag[3].y,
			100)			// # of intersections
	ENDSUB

ENDPROC

OBJECT xy
	x/y:L

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
	SetAPen(rp,2)
	x:=xA
	y:=yA
	xa*=5										// this is needed only to look better
	ya*=5
	xb*=5
	yb*=5
	Move(rp,x+160,y+160)
	FOR i:=0 TO steps
		t:=delta*i
		f0:=2.0*t*t*t-3.0*t*t+1.0		// Ferguson's polynoms
		f1:=-2.0*t*t*t+3.0*t*t
		f2:=t*t*t-2.0*t*t+t
		f3:=t*t*t-t*t
		x:=xA*f0+xB*f1+xa*f2+xb*f3		// parametrical representations for x and y coords
		y:=yA*f0+yB*f1+ya*f2+yb*f3
		Draw(rp,x+160,y+160)
	ENDFOR
ENDPROC

PROC DrawLine(rp,x1,y1,x2,y2)
	x1+=160
	y1+=160
	x2+=160
	y2+=160
	SetAPen(rp,1)
	Move(rp,x1,y1)
	Draw(rp,x2,y2)
	SetAPen(rp,3)
	RectFill(rp,x1-2,y1-2,x1+2,y1+2)
	RectFill(rp,x2-2,y2-2,x2+2,y2+2)
ENDPROC

PROC Drag(x,y,drag:PTR TO xy,count)(L)
	DEF	id
	FOR id:=0 TO count-1
		IF x>=drag[id].x-2 AND x<=drag[id].x+2 AND y>=drag[id].y-2 AND y<=drag[id].y+2 THEN RETURN id
	ENDFOR
ENDPROC -1

// MarK 29/9/2000
