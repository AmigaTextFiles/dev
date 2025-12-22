// cube example CGFX+P96

MODULE	'intuition/intuition',
			'intuition/screens',
			'utility/tagitem',
			'graphics/modeid',
			'graphics/view',
			'exec/memory'

MODULE	'warp3d',
			'warp3d/warp3d'
MODULE	'cybergraphx/cybergraphics',
			'cybergraphics'

PROC Go()
	// build all needed vertexes
	DEF	v[8]:W3D_Vertex,n
	DEF	p=[	// cube vertex and colour definition
		-1,-1,-1,	0,0,0,
		+1,-1,-1,	0,0,1,
		+1,-1,+1,	0,1,0,
		-1,-1,+1,	0,1,1,
		-1,+1,-1,	1,0,0,
		+1,+1,-1,	1,0,1,
		+1,+1,+1,	1,1,1,
		-1,+1,+1,	1,1,0]:vertex
	DEF	sqr=[	// squares definition of points ids
		0,3,7,4,		// left
		1,2,6,5,		// right
		0,1,5,4,		// back
		2,3,7,6,		// front
		0,1,2,3,		// bottom
		4,5,6,7]:W	// top

	// setup all the vertex colours
	FOR n:=0 TO 7
		v[n].w:=0.0
		v[n].u:=0.0
		v[n].v:=0.0
		v[n].tex3d:=0
		v[n].color.a:=1.0
		v[n].color.r:=p[n].r
		v[n].color.g:=p[n].g
		v[n].color.b:=p[n].b
		v[n].spec.r:=1.0
		v[n].spec.g:=1.0
		v[n].spec.b:=1.0
		v[n].l:=0
	ENDFOR

	// setup the trifan for the above vertexes
	DEF	trifan:W3D_TrianglesV
	trifan.vertexcount:=4
	trifan.v:=[NIL,NIL,NIL,NIL,NIL]:UL	// prepare the field
	trifan.tex:=NIL
	trifan.st_pattern:=NIL

	DEF	msg:PTR TO IntuiMessage,class,next=TRUE
	DEF	angles=[0,0,0,0,0,0]:vertex,ver:PTR TO PTR TO W3D_Vertex
	WHILE next
		IF msg:=GetMsg(window.UserPort)
			SELECT class:=msg.Class
			CASE IDCMP_MOUSEMOVE
				angles.x:=msg.MouseY/100
				angles.y:=msg.MouseX/100
			DEFAULT
				next:=FALSE
			ENDSELECT
			ReplyMsg(msg)
		ENDIF

		FOR n:=0 TO 7 Compute3DPoint(v[n],p[n],angles)

		// lock hardware to allow to use it
		IF W3D_SUCCESS=W3D_LockHardware(context)
			W3D_ClearDrawRegion(context,0)
			W3D_ClearZBuffer(context,NIL)
			FOR n:=0 TO 5
/*
				pay attention. this is buggy stuff in PowerD!!!!!

				trifan.v[0]:=v[sqr[n*4+0]]
				trifan.v[1]:=v[sqr[n*4+1]]
				trifan.v[2]:=v[sqr[n*4+2]]
				trifan.v[3]:=v[sqr[n*4+3]]
*/
				ver:=trifan.v
				ver[0]:=v[sqr[n*4+0]]
				ver[1]:=v[sqr[n*4+1]]
				ver[2]:=v[sqr[n*4+2]]
				ver[3]:=v[sqr[n*4+3]]
				W3D_DrawTriFanV(context,trifan)
			ENDFOR
			W3D_UnLockHardware(context)
		ELSE Raise("LHW")

		// swap the buffers
		SwitchBuffers()
	ENDWHILE
ENDPROC

PROC Compute3DPoint(pixel:PTR TO W3D_Vertex,vertex:PTR TO vertex,angles:PTR TO vertex)
	DEFD	x,y,z,xx,yy,zz,x1,y1,z1,lminuszz
	x:=vertex.x
	y:=vertex.y
	z:=vertex.z

	x1:=x*Cos(angles.z)+y*Sin(angles.z)
	y1:=y*Cos(angles.z)-x*Sin(angles.z)
	xx:=x1*Cos(angles.y)+z*Sin(angles.y)
	z1:=z*Cos(angles.y)-x1*Sin(angles.y)
	zz:=z1*Cos(angles.x)+y1*Sin(angles.x)
	yy:=y1*Cos(angles.x)-z1*Sin(angles.x)

	lminuszz:=5-zz
	IF lminuszz>0.0
		x:=xx*5/lminuszz
		y:=-yy*5/lminuszz
	ELSE RETURN
	x*=height/4
	y*=height/4
	x+=width/2
	y+=height/2
	pixel.x:=x
	pixel.y:=y
	pixel.z:=(zz+2)/4
ENDPROC

PROC SwitchBuffers()
	IFN bufnum
		bm:=buf2.BitMap
		W3D_SetDrawRegion(context,bm,0,scissor)
		buf1.DBufInfo.SafeMessage.ReplyPort:=NIL
		WHILEN ChangeScreenBuffer(screen,buf1);	ENDWHILE
		WaitTOF()
		bufnum:=1
	ELSE
		bm:=buf1.BitMap
		W3D_SetDrawRegion(context,bm,0,scissor)
		buf2.DBufInfo.SafeMessage.ReplyPort:=NIL
		WHILEN ChangeScreenBuffer(screen,buf2);	ENDWHILE
		WaitTOF()
		bufnum:=0
	ENDIF
ENDPROC

OBJECT vertex
	x/y/z:F,
	r/g/b:F

DEF	Warp3DBase,CyberGfxBase

DEF	screen:PTR TO Screen,window:PTR TO Window,context:PTR TO W3D_Context,scissor:PTR TO W3D_Scissor,
		width,height,buf1:PTR TO ScreenBuffer,buf2:PTR TO ScreenBuffer,bm:PTR TO BitMap,bufnum

PROC main()
	OpenAll()
	Go()
EXCEPTDO
	CloseAll()
	DEF	err,err2=NIL
	SELECT exception
	CASE "CGX";	err:='unable to open cybergraphics.library'
	CASE "W3D";	err:='unable to open warp3d.library'
	CASE "DRV";	err:='unsuitable 3d driver'
	CASE "N15";	err:='15 bit buffer unsupported'
	CASE "MID";	err:='invalid screen mode'
	CASE "SCR";	err:='unable to open screen'
	CASE "SCB";	err:='unable to get screen buffer'
	CASE "CGB";	err:='no cybergraphics bitmap: screen buffer '
		err2:=["0"+exceptioninfo,0]:CHAR
	CASE "WIN";	err:='unable to open window'
	CASE "CTX";	err:='unable to build context: '
		SELECT exceptioninfo
		CASE W3D_ILLEGALINPUT;	err2:='illegal input'
		CASE W3D_NOMEMORY;		err2:='no memory'
		CASE W3D_NODRIVER;		err2:='no driver'
		CASE W3D_UNSUPPORTEDFMT;err2:='unsupported format'
		CASE W3D_ILLEGALBITMAP;	err2:='illegal bitmap'
		ENDSELECT
	CASE "LHW";	err:='can''t lock hardware'
	CASE "MEM";	err:='not enough memory'
	CASE "ZBU";	err:='unable to build z-buffer: '
		SELECT exceptioninfo
		CASE W3D_NOGFXMEM;	err2:='no video memory'
		CASE W3D_NOZBUFFER;	err2:='z-bufering not supported'
		ENDSELECT
	DEFAULT;		err:='   ';	StrCopy(err,[exception<<8]:L,3)
	ENDSELECT
	IF exception THEN PrintF('\s\s\n',err,err2)
ENDPROC

PROC OpenAll()
	IFN CyberGfxBase:=OpenLibrary('cybergraphics.library',0) THEN Raise("CGX")
	IFN Warp3DBase:=OpenLibrary('Warp3D.library',0) THEN Raise("W3D")

	DEF	flags=W3D_CheckDriver()
	IFN flags&W3D_DRIVER_3DHW||flags&W3D_DRIVER_CPU THEN Raise("DRV")

	DEF	format=W3D_GetDestFmt()
	IFN format&W3D_FMT_R5G5B5 THEN Raise("N15")

	DEF	modeid
	IF (modeid:=CModeRequestTags(NIL,
		CYBRMREQ_MinDepth,15,
		CYBRMREQ_MaxDepth,15,
		TAG_END))=INVALID_ID THEN Raise("MID")

	IF IsCyberModeID(modeid)
		width:=GetCyberIDAttr(CYBRIDATTR_Width,modeid)
		height:=GetCyberIDAttr(CYBRIDATTR_Height,modeid)
	ELSE Raise("MID")

	IFN screen:=OpenScreenTags(NIL,
		SA_Width,width,
		SA_Height,height,
		SA_DisplayID,modeid,
		SA_ShowTitle,FALSE,
		SA_Draggable,FALSE,
		TAG_END) THEN Raise("SCR")

	// prepare double buffering
	IFN buf1:=AllocScreenBuffer(screen,NIL,SB_SCREEN_BITMAP) THEN Raise("SCB")
	IFN GetCyberMapAttr(buf1.BitMap,CYBRMATTR_IsCyberGfx) THEN Raise("CGB",1)
	IFN buf2:=AllocScreenBuffer(screen,NIL,0) THEN Raise("SCB")
	IFN GetCyberMapAttr(buf2.BitMap,CYBRMATTR_IsCyberGfx) THEN Raise("CGB",2)
	buf1.DBufInfo.SafeMessage.ReplyPort:=NIL
	WHILEN ChangeScreenBuffer(screen,buf1);	ENDWHILE
	WaitTOF()
	bm:=buf1.BitMap
	bufnum:=0

	IFN window:=OpenWindowTags(NIL,
		WA_CustomScreen,screen,
		WA_Width,screen.Width,
		WA_Height,screen.Height,
		WA_Left,0,
		WA_Top,0,
		WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_VANILLAKEY|IDCMP_MOUSEMOVE,
		WA_Flags,WFLG_RMBTRAP|WFLG_BORDERLESS|WFLG_ACTIVATE|WFLG_REPORTMOUSE,
		TAG_END) THEN Raise("WIN")

	DEF	cerr
	IFN context:=W3D_CreateContextTags(&cerr,
		W3D_CC_MODEID,modeid,
		W3D_CC_DRIVERTYPE,W3D_DRIVER_BEST,
		W3D_CC_BITMAP,bm,
		W3D_CC_YOFFSET,0,
		TAG_END) THEN Raise("CTX",cerr)
	IFN W3D_SUCCESS=(cerr:=W3D_AllocZBuffer(context)) THEN Raise("ZBU",cerr)
	W3D_SetState(context,W3D_GOURAUD,W3D_ENABLE)
	W3D_SetState(context,W3D_ZBUFFER,W3D_ENABLE)
	W3D_SetZCompareMode(context,W3D_Z_GREATER)

	scissor:=[0,0,width,height]:W3D_Scissor
	SwitchBuffers()
ENDPROC

PROC CloseAll()
	W3D_FreeZBuffer(context)
	IF context THEN W3D_DestroyContext(context)
	IF window THEN CloseWindow(window)
	IF buf2 THEN FreeScreenBuffer(screen,buf2)
	IF buf1 THEN FreeScreenBuffer(screen,buf1)
	IF screen THEN CloseScreen(screen)
	IF Warp3DBase THEN CloseLibrary(Warp3DBase)
	IF CyberGfxBase THEN CloseLibrary(CyberGfxBase)
ENDPROC
