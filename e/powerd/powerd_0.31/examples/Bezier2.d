// Bezier.d - example of how to generate bezier curves in D
// requires workbench height of atleast ~340 pixels and fpu

MODULE	'intuition/intuition',
			'utility/tagitem'

PROC main()
	DEF	w:PTR TO Window,class,change=FALSE,code,x,y
	DEF	id=-1,drag:PTR TO xy,count=5
	IF w:=OpenWindowTags(NIL,
			WA_InnerWidth,320,
			WA_InnerHeight,320,
			WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_MOUSEMOVE,
			WA_Flags,WFLG_DRAGBAR|WFLG_GIMMEZEROZERO|WFLG_RMBTRAP|WFLG_ACTIVATE|WFLG_CLOSEGADGET|WFLG_DEPTHGADGET|WFLG_REPORTMOUSE,
			WA_Title,'Bezier''s curve',
			TAG_END)

		drag:=[			// draggable points
			-100,-100,
			+100,-50,
			-100,0,
			+100,+50,
			-100,+100
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
					IF (id:=Drag(x,y,drag,count))>=0 THEN change:=TRUE
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
		DrawCV(w.RPort,drag,count)
		Bezier(w.RPort,drag,count,100)
	ENDSUB

ENDPROC

OBJECT xy
	x/y:L

// Bezier() - creates a curve from a list of 4 points

PROC Bezier(rp,p:PTR TO xy,count,steps)
	DEFF	delta,t,x,y,b
	DEF	i,n
	delta:=1.0/steps
	SetAPen(rp,2)
	Move(rp,p.x+160,p.y+160)
	FOR i:=1 TO steps
		t:=delta*i
		x:=y:=0
		FOR n:=0 TO count-1
			b:=Ber(count-1,n,t)
			x+=p[n].x*b
			y+=p[n].y*b
		ENDFOR
		Draw(rp,x+160,y+160)
	ENDFOR
ENDPROC

PROC NabI(n,i)(F) IS Fac(n)/(Fac(i)*Fac(n-i))
PROC Fac(i)(L)
	DEFL	r=1
	IF i THEN FOR i DTO 1 DO r*=i
ENDPROC r
PROC Ber(n,i,t:F)(F) IS NabI(n,i)*Pow(t,i)*Pow(1-t,n-i)

PROC DrawCV(rp,p:PTR TO xy,count)
	DEF	i
	SetAPen(rp,3)
	RectFill(rp,p.x-2+160,p.y-2+160,p.x+2+160,p.y+2+160)
	FOR i:=0 TO count-2
		SetAPen(rp,1)
		Move(rp,p[i].x+160,p[i].y+160)
		Draw(rp,p[i+1].x+160,p[i+1].y+160)
		SetAPen(rp,3)
		RectFill(rp,p[i+1].x-2+160,p[i+1].y-2+160,p[i+1].x+2+160,p[i+1].y+2+160)
	ENDFOR
ENDPROC

PROC Drag(x,y,drag:PTR TO xy,count)(L)
	DEF	id
	FOR id:=0 TO count-1
		IF x>=drag[id].x-2 AND x<=drag[id].x+2 AND y>=drag[id].y-2 AND y<=drag[id].y+2 THEN RETURN id
	ENDFOR
ENDPROC -1

// MarK 29/9/2000
