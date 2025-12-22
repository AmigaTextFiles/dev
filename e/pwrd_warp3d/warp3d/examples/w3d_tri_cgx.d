// silly example CGFX+W3D

MODULE	'intuition/intuition',
			'intuition/screens',
			'utility/tagitem',
			'graphics/modeid',
			'graphics/view'

MODULE	'warp3d',
			'warp3d/warp3d'
MODULE	'cybergraphx/cybergraphics',
			'cybergraphics'

PROC Go()
	// build all needed vertexes
	DEF	v1:W3D_Vertex
	DEF	v2:W3D_Vertex
	DEF	v3:W3D_Vertex

	v1.x:=width/2;		v1.y:=160
	v1.z:=0.0;	v1.w:=0.0;	v1.u:=0.0;	v1.v:=0.0
	v1.tex3d:=0
	v1.color.a:=1.0;	v1.color.r:=1.0;	v1.color.g:=1.0;	v1.color.b:=0.0
	v1.spec.r:=1.0;	v1.spec.g:=1.0;	v1.spec.b:=1.0;	v1.l:=0

	v2.x:=3*width/4;	v2.y:=320
	v2.z:=0.0;	v2.w:=0.0;	v2.u:=0.0;	v2.v:=0.0
	v2.tex3d:=0
	v2.color.a:=1.0;	v2.color.r:=1.0;	v2.color.g:=0.0;	v2.color.b:=1.0
	v2.spec.r:=1.0;	v2.spec.g:=1.0;	v2.spec.b:=1.0;	v2.l:=0

	v3.x:=width/4;		v3.y:=320
	v3.z:=0.0;	v3.w:=0.0;	v3.u:=0.0;	v3.v:=0.0
	v3.tex3d:=0
	v3.color.a:=1.0;	v3.color.r:=1.0;	v3.color.g:=1.0;	v3.color.b:=1.0
	v3.spec.r:=0.0;	v3.spec.g:=0.0;	v3.spec.b:=0.0;	v3.l:=0

	// setup the triangle from the above vertexes
	DEF	triangle:W3D_TriangleV
	triangle.v1:=v1
	triangle.v2:=v2
	triangle.v3:=v3
	triangle.tex:=NIL
	triangle.st_pattern:=NIL

	// prepare the double buffer swap stuff
	DEF	msg:PTR TO IntuiMessage,class,next=TRUE
	WHILE next
		IF msg:=GetMsg(window.UserPort)
			SELECT class:=msg.Class
			CASE IDCMP_MOUSEMOVE
				v1.x:=msg.MouseX
				v1.y:=IF msg.MouseY>=height THEN height-1 ELSE msg.MouseY	// clip if needed
			DEFAULT
				next:=FALSE
			ENDSELECT
			ReplyMsg(msg)
		ENDIF

		// lock hardware to allow to use it
		IF W3D_SUCCESS=W3D_LockHardware(context)
			W3D_ClearDrawRegion(context,0)
			W3D_DrawTriangleV(context,triangle)
			W3D_UnLockHardware(context)
		ELSE Raise("LHW")

		// swap the buffers
		SwitchBuffers()
	ENDWHILE
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
	IF (modeid:=BestCModeIDTags(
		CYBRBIDTG_Depth,15,
		CYBRBIDTG_NominalWidth,640,
		CYBRBIDTG_NominalHeight,480,
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
	W3D_SetState(context,W3D_GOURAUD,W3D_ENABLE)

	scissor:=[0,0,width,height]:W3D_Scissor
	SwitchBuffers()
ENDPROC

PROC CloseAll()
	IF context THEN W3D_DestroyContext(context)
	IF window THEN CloseWindow(window)
	IF buf2 THEN FreeScreenBuffer(screen,buf2)
	IF buf1 THEN FreeScreenBuffer(screen,buf1)
	IF screen THEN CloseScreen(screen)
	IF Warp3DBase THEN CloseLibrary(Warp3DBase)
	IF CyberGfxBase THEN CloseLibrary(CyberGfxBase)
ENDPROC
