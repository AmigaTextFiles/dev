// LineIntersection.d - example of how to get intersection of two lines
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
			WA_Title,'Line intersection',
			TAG_END)

		drag:=[			// draggable points    A+
			-90,-90,		// position of point A   \  +D
			+90,+90,		// position of point B    \/____this is the point we want to find
			+90,-90,		// position of point C    /\
			-90,+90		// position of point D  C+  +B
			]:xy

		draw	// watch the definition below

//		EasyRequestArgs(0,[SIZEOF_EasyStruct,0,0,'Drag those points and enjoy :)','Yea']:EasyStruct,0,NIL)

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
		x,y:=LineIntersection(
			drag[0].x,drag[0].y,
			drag[1].x,drag[1].y,
			drag[2].x,drag[2].y,
			drag[3].x,drag[3].y)
		DrawCross(w.RPort,x,y)
	ENDSUB

ENDPROC

OBJECT xy
	x/y:L

PROC LineIntersection(xA:F,yA:F,xB:F,yB:F,xC:F,yC:F,xD:F,yD:F)(F,F)
	DEFF	x,y,a1,a2,c1,c2,t
	a1:=xB-xA
	a2:=yB-yA
	c1:=xD-xC
	c2:=yD-yC
	IF (c1*a2-c2*a1)
		t:=(c1*(yC-yA)+c2*(xA-xC))/(c1*a2-c2*a1)
		x:=xA+a1*t
		y:=yA+a2*t
	ENDIF
ENDPROC x,y

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

PROC DrawCross(rp,x,y)
	x+=160
	y+=160
	SetAPen(rp,2)
	Move(rp,x-3,y-3)
	Draw(rp,x+3,y+3)
	Move(rp,x-3,y+3)
	Draw(rp,x+3,y-3)
	DrawEllipse(rp,x,y,4,4)
ENDPROC

PROC Drag(x,y,drag:PTR TO xy,count)(L)
	DEF	id
	FOR id:=0 TO count-1
		IF x>=drag[id].x-2 AND x<=drag[id].x+2 AND y>=drag[id].y-2 AND y<=drag[id].y+2 THEN RETURN id
	ENDFOR
ENDPROC -1

// MarK 20/10/2000
