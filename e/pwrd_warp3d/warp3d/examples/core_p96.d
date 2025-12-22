// this file should simplify the usage of the Warp3D (related to Picasso96), follow the instructions:

// 1) You should select the depth and resolution, or the selection via requester
// 2) Setup the IDCMP flags to read needed messages from the window
// 3) Setup the messaging system in the Go() procedure to meet Your needs
// 4) Render the current frame in the Render() procedure

MODULE	'intuition/intuition',
			'intuition/screens',
			'utility/tagitem',
			'graphics/modeid',
			'graphics/view',
			'exec/memory'

MODULE	'warp3d',						// Warp3D modules
			'warp3d/warp3d'
MODULE	'libraries/picasso96',		// Picasso96 modules
			'picasso96'

PROC Render()(BOOL)
ENDPROC TRUE

PROC Go()
	DEF	msg:PTR TO IntuiMessage,class,next=TRUE,noerr
	WHILE next
		IF msg:=GetMsg(window.UserPort)
			SELECT class:=msg.Class
			CASE IDCMP_MOUSEBUTTONS
				next:=FALSE
			CASE IDCMP_RAWKEY
			DEFAULT
				next:=FALSE
			ENDSELECT
			ReplyMsg(msg)
		ENDIF

		// lock hardware to allow to use it
		IF W3D_SUCCESS=W3D_LockHardware(context)
			// crear the screen and the z-buffer
			W3D_ClearDrawRegion(context,0)
			W3D_ClearZBuffer(context,[1]:D)

			// pay attention, between functions to lock and unlock the hardware, there mustn't be any
			// output (PrintF(), EasyReq(), etc.) functions, because it leads to the system freeze !!!
			noerr:=Render()

			W3D_UnLockHardware(context)
		ELSE Raise("LHW")

		// swap the buffers
		SwitchBuffers()

		IFN noerr THEN Raise("ERR")
	ENDWHILE
EXCEPTDO
	Raise(exception,exceptioninfo)
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

DEF	Warp3DBase,P96Base

DEF	screen:PTR TO Screen,window:PTR TO Window,context:PTR TO W3D_Context,scissor:PTR TO W3D_Scissor,
		width,height,depth,buf1:PTR TO ScreenBuffer,buf2:PTR TO ScreenBuffer,bm:PTR TO BitMap,bufnum

PROC main()
	OpenAll()
	Go()
EXCEPTDO
	CloseAll()
	DEF	err,err2=NIL
	SELECT exception
	CASE "P96";	err:='unable to open picasso96api.library'
	CASE "W3D";	err:='unable to open warp3d.library'
	CASE "DRV";	err:='unsuitable 3d driver'
	CASE "MID";	err:='invalid screen mode'
	CASE "SCR";	err:='unable to open screen'
	CASE "SCB";	err:='unable to get screen buffer'
	CASE "P96B";	err:='no picasso96 bitmap: screen buffer '
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
	CASE "ERR";	err:='error while rendering frame'
	DEFAULT;		err:='   ';	StrCopy(err,[exception<<8]:L,3)
	ENDSELECT
	IF exception THEN PrintF('\s\s\n',err,err2)
ENDPROC

PROC OpenAll()
	IFN P96Base:=OpenLibrary('Picasso96API.library',0) THEN Raise("P96")
	IFN Warp3DBase:=OpenLibrary('Warp3D.library',0) THEN Raise("W3D")

	DEF	flags=W3D_CheckDriver()
	IFN flags&W3D_DRIVER_3DHW||flags&W3D_DRIVER_CPU THEN Raise("DRV")

	DEF	modeid
	IF (modeid:=p96RequestModeIDTags(
		P96MA_MinDepth,15,
		P96MA_MaxDepth,16,
		P96MA_MinWidth,320,
		P96MA_MaxWidth,1600,
		P96MA_MinHeight,200,
		P96MA_MaxHeight,1200,
		TAG_END))=INVALID_ID THEN Raise("MID")

	IF p96GetModeIDAttr(modeid,P96IDA_ISP96)
		width:=p96GetModeIDAttr(modeid,P96IDA_WIDTH)
		height:=p96GetModeIDAttr(modeid,P96IDA_HEIGHT)
		depth:=p96GetModeIDAttr(modeid,P96IDA_DEPTH)
	ELSE Raise("MID")

	PrintF('DisplayID=$\h\n',modeid)
	PrintF('    Width=\d\n',width)
	PrintF('   Height=\d\n',height)
	PrintF('    Depth=\d\n',depth)

	IFN screen:=OpenScreenTags(NIL,
		SA_Width,width,
		SA_Height,height,
		SA_DisplayID,modeid,
		SA_Depth,depth,
		SA_ShowTitle,FALSE,
		SA_Draggable,FALSE,
		TAG_END) THEN Raise("SCR")

	// prepare double buffering
	IFN buf1:=AllocScreenBuffer(screen,NIL,SB_SCREEN_BITMAP) THEN Raise("SCB")
	IFN p96GetBitMapAttr(buf1.BitMap,P96IDA_ISP96) THEN Raise("P96B",1)
	IFN buf2:=AllocScreenBuffer(screen,NIL,0) THEN Raise("SCB")
	IFN p96GetBitMapAttr(buf2.BitMap,P96IDA_ISP96) THEN Raise("P96B",2)
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
		WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_RAWKEY|IDCMP_MOUSEBUTTONS,
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

	// setup the rendering usage
	W3D_SetState(context,W3D_TEXMAPPING,W3D_ENABLE)
	W3D_SetState(context,W3D_GOURAUD,W3D_ENABLE)
	W3D_SetState(context,W3D_ZBUFFER,W3D_ENABLE)
	W3D_SetState(context,W3D_PERSPECTIVE,W3D_ENABLE)
	W3D_SetZCompareMode(context,W3D_Z_LESS)
	W3D_Hint(context,W3D_H_BILINEARFILTER,W3D_H_NICE)
	W3D_SetState(context,W3D_FOGGING,W3D_ENABLE)
	W3D_SetFogParams(context,[1.0,0.15,0,0,0,0]:W3D_Fog,W3D_FOG_LINEAR)

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
	IF P96Base THEN CloseLibrary(P96Base)
ENDPROC
