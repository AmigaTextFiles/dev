// draw 262144 colours, requies aga

OPT OSVERSION=37

MODULE	'intuition/intuition',
			'exec/nodes',
			'intuition/screens',
			'intuition/gadgetclass',
			'graphics/text',
			'utility/tagitem'

ENUM	ER_NONE,ER_NOSCRN,ER_NOWINDOW

DEF	wnd=NIL:PTR TO Window,
		scr=NIL:PTR TO Screen

PROC shutdown()
	IF wnd THEN CloseWindow(wnd)
	IF scr THEN CloseScreen(scr)
ENDPROC

PROC setup()
	IF (scr:=OpenScreenTagList(NIL,[
			SA_Width,528,
			SA_Height,512,
			SA_Depth,8,
			SA_DisplayID,$8804,
			TAG_END]))=NIL THEN Raise(ER_NOSCRN)
	IF (wnd:=OpenWindowTagList(NIL,[
			WA_Left,0,
			WA_Top,0,
			WA_Width,528,
			WA_Height,512,
			WA_IDCMP,IDCMP_MOUSEBUTTONS,
			WA_Flags,WFLG_SIMPLE_REFRESH|WFLG_NOCAREREFRESH|WFLG_ACTIVATE|WFLG_BORDERLESS,
			WA_CustomScreen,scr,
			TAG_END]))=NIL THEN Raise(ER_NOWINDOW)
ENDPROC

PROC draw()
	DEFL	r,loop1,loop2,loop3
	r:=wnd.RPort
	FOR loop1:=0 TO 7
		FOR loop2:=0 TO 7
			SetAPen(r,loop1*8+loop2+64)
			Move(r,loop2*66,loop1*64)
			Draw(r,loop2*66,loop1*64+63)
			FOR loop3:=0 TO 63
				SetAPen(r,loop3+128)
				WritePixel(r,loop2*66+1,loop1*64+loop3)
//				Move(r,loop2*66+1,loop1*64+loop3)
//				Draw(r,loop2*66+1,loop1*64+loop3)
				SetAPen(r,loop3+192)
				Move(r,loop2*66+2+loop3,loop1*64)
				Draw(r,loop2*66+2+loop3,loop1*64+63)
			ENDFOR
		ENDFOR
	ENDFOR
ENDPROC

PROC waitmouse()
	DEF	mes:PTR TO IntuiMessage,quit=FALSE
	REPEAT
		IF mes:=GetMsg(wnd.UserPort)
			IF mes.Class=IDCMP_MOUSEBUTTONS THEN quit:=TRUE
			ReplyMsg(mes)
		ELSE
			WaitPort(wnd.UserPort)
		ENDIF
	UNTIL quit
ENDPROC

PROC main()
	DEF	erlist:PTR TO LONG
	setup()
	draw()
	waitmouse()
EXCEPTDO
	shutdown()
	IF exception>0
		erlist:=['open screen','open window']:LONG
		EasyRequestArgs(0,[20,0,0,'Could not \s.','OK'],0,[erlist[exception-1]])
	ENDIF
ENDPROC
