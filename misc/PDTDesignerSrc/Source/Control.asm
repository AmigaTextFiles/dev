	opt	c+,d+,l+,o+,i+
	incdir	sys:include/
	include	exec/exec_lib.i
	include	exec/exec.i
	include	exec/execbase.i
	include	intuition/intuition_lib.i
	include	intuition/intuition.i
	include	libraries/dos_lib.i
	include	libraries/dos.i
	include	libraries/dosextens.i
	include	graphics/graphics_lib.i
	include	graphics/rastport.i
	include	graphics/view.i
	include	hardware/custom.i
	include	hardware/dmabits.i
	include	workbench/icon.i
	include	workbench/startup.i
	include	devices/console_lib.i

	include	MapDesignerV2.0:Source/MapDesignerV2.i	; Custom include!

	output	MapDesignerV2.0:Modules/ControlModule.o

;   These are the functions in this file...

	xdef	_main,MainControl,MainInitialisation,GlobalCleanup
	xdef	FreeData,ExtractData,RoutineCaller,HandleInputs
	xdef	DisplayStatus,EditHeight,BlockStr,CheckSizes,CheckRes
	xdef	BlockCleanup,MapCleanup,TilesCleanup,HandleMove
	xdef	HandleMiniMap,CloseMapScreen,FreeTiles,CheckInput
	xdef	DisplayCursorPosition,MoveMap,CloseWindowSafely
	xdef	DisplayTileStatus,DisplayMapStatus,FreePlanes,DrawCursor
	xdef	PrintInteger,BlitCTile,StripInputs,StuffChar
	xdef	DrawMapSection,ClearPort

;   The file also contains the following `Un-Documented' routines...

	xdef	ClearText,WaitBlit,SetPens

;   This is the public section of the files data...

	xdef	_MapInfoBase,_IntuitionBase,_GfxBase,_InputPort,BusyPointer
	xdef	CurrInput,InputClass,InputCode,MiniMapGadget,MiniMapInfo
	xdef	ASCIITemp,IntegerFormat,SizeFormat,StatusFont,_LayersBase
	xdef	_IconBase,ConRequest

;   These routines are external...

	xref	ScrollLeft,ScrollRight,ScrollUp,ScrollDown,PlaceTile
	xref	BlankPointer,ArgStartLoad,_DOSBase,NextTile,PreviousTile

	xref	MapNewScreen,MapNewWindow

;   The import menu definitions...

	xref	DesignerMenus
	xref	ProjectMenu,TilesMenu,MapMenu,BlocksMenu,PrefsMenu
	xref	Project.1,Project.2,Project.3,Project.4,Project.5,Project.6
	xref	Tiles.1,Tiles.2,Tiles.2.1,Tiles.2.2,Tiles.3,Tiles.3.1
	xref	Tiles.3.2,Tiles.3.3,Tiles.3.4,Tiles.4
	xref	Map.1,Map.2,Map.3,Map.3.1,Map.3.2,Map.4,Map.5,Blocks.1
	xref	Blocks.2,Blocks.3,Blocks.4,Prefs.1,Prefs.2,Prefs.3,Prefs.4
	xref	Prefs.5,Blocks.5

;   These are tables of addresses which correspond to the code tables xref'd
; below...

	xref	ExtFuncs,AscFuncs,MenuFuncs,ButtonFuncs

;   These are the tables which contain the valid input codes for each class
; of input.  They should tie up with the function tables xref'd above...

	xref	ExtCodes,AscCodes,MenuCodes,ButtonCodes

;   This file contains the source for the module that sets up the editor
; system and then handles the calling of routines when we recieve inputs from
; the user.  The only references which are not resolved are those to the
; tables which contain the addresses to be called for each valid input code.

	section	Program,code
_main				; For startup to call.
MainControl:
	bsr	MainInitialisation	; Setup editor system.
	tst.l	d0
	beq	.Failure		; Exit if anything went wrong.
	move.l	4(sp),d0		; Get argc
	move.l	8(sp),a0		; Ger argv
	tst.l	d0
	bne.s	.GetArg			; Get name if we're CLI.
	move.l	sm_NumArgs(a0),d0	; Else get number or WB args.
	move.l	sm_ArgList(a0),a2	; And the Arg list.
	cmpi.l	#1,d0			; Is there just 1 argument?
	beq.s	.MainLoop		; Yes, then don't try to read a map.
	lea	wa_SIZEOF(a2),a2
	move.l	wa_Lock(a2),d1
	CALLDOS		CurrentDir	; Make inputs lock, CDir.
	move.l	d0,OldCDir		; Store this.
	move.w	#-1,SDFlg
	move.l	wa_Name(a2),a0		; Get ptr to argument.
	bra.s	.GotNamePtr
.GetArg:
	cmpi.l	#1,d0			; Is there just 1 argument?
	beq.s	.MainLoop		; Yes, then don't try to read a map.
	move.l	4(a0),a0
.GotNamePtr:
	move.l	_MapInfoBase,a5		; This is setup as a5 for load map.
	lea	minfo_Name(a5),a1
	moveq	#0,d0
.CopyLoop:
	move.b	(a0)+,(a1)+		; Copy character.
	beq.s	.GotName		; Exit if whole name has been copied.
	addq.w	#1,d0
	cmpi.w	#150,d0
	bge.s	.MainLoop		; Exit if name too long.
	bra.s	.CopyLoop
.GotName:
	bsr	BeginInput
	jsr	ArgStartLoad		;  Attempt to load map then drop into
					; main loop.
	bsr	EndInput
.MainLoop:
	move.l	_MapInfoBase,a0		; Get map structure.
	move.w	minfo_Flags(a0),d0	; Get flags.
	btst	#MIFB_QUIT,d0		; Has user requested to quit?
	bne.s	.Quit			; Yes, then cleanup & exit.
	bsr	HandleInputs		; Else, go and deal with user.
	bra.s	.MainLoop		; Loop...
.Quit:
	tst.w	SDFlg			; Has the initial dir been changed?
	beq.s	.NoOldDir		; No, then don't re-set it.
	move.l	OldCDir,d1		; Else, restore initial dir...
	CALLDOS		CurrentDir
.NoOldDir:
	bsr	GlobalCleanup		; Free everything!
	moveq	#RETURN_OK,d0		; DOS Success
	bra.s	.Exit			; Exit to CLI/WB.
.Failure:
	moveq	#RETURN_FAIL,d0		; Set failure return.
.Exit:
	rts				; Exit to CLI/WB.

MainInitialisation:
	lea	IntLib,a1
	moveq	#33,d0
	CALLEXEC	OpenLibrary	; Attempt to open intuition library.
	move.l	d0,_IntuitionBase
	beq	.Failed			; Exit on failure
	lea	GfxLib,a1
	moveq	#33,d0
	CALLEXEC	OpenLibrary	; Attempt to open graphics library.
	move.l	d0,_GfxBase
	beq	.Failed			; Exit on failure
	lea	LayLib,a1
	moveq	#33,d0
	CALLEXEC	OpenLibrary	; Attempt to open layers library.
	move.l	d0,_LayersBase
	beq	.Failed			; Exit on failure
	lea	IcnLib,a1
	moveq	#33,d0
	CALLEXEC	OpenLibrary	; Attempt to open icon library.
	move.l	d0,_IconBase
	beq	.Failed			; Exit on failure
	move.l	#minfo_SIZEOF,d0
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate a MapInfo structure.
	move.l	d0,_MapInfoBase
	beq	.Failed			; Exit if no memory.
	move.l	d0,a2
	move.w	#32,minfo_TX(a2)	; Setup default values...
	move.w	#32,minfo_TY(a2)
	move.w	#320,minfo_MRasX(a2)
	lea	StatusBitMap,a0		; Initialise status BitMap...
	moveq	#4,d0
	move.w	#640,d1
	move.w	#67,d2
	CALLGRAF	InitBitMap
	lea	StatusBitMap,a0		; Setup ptrs to fancy gfx...
	lea	bm_Planes(a0),a0
	move.l	#FancyGfx+((67*80)*0),(a0)+
	move.l	#FancyGfx+((67*80)*1),(a0)+
	move.l	#FancyGfx+((67*80)*2),(a0)+
	move.l	#FancyGfx+((67*80)*3),(a0)+
	lea	StatusNewScreen,a0
	CALLINT		OpenScreen	; Attempt to open status screen.
	move.l	d0,minfo_StatusScreen(a2)
	beq	.Failed			; Exit if no screen.
	move.l	d0,SWinScreen		; For window opening.
	move.l	d0,a0
	lea	sc_ViewPort(a0),a0	; Get screens ViewPort.
	lea	FancyGfx+((67*80)*4),a1		; Table of colours.
	moveq	#16,d0
	CALLGRAF	LoadRGB4	; Install Status colours.
	lea	StatusNewWindow,a0
	CALLINT		OpenWindow	; Attempt to open status window.
	move.l	d0,minfo_StatusWindow(a2)
	beq.s	.Failed			; Exit if no window.
	move.l	d0,a0
	move.l	wd_UserPort(a0),_InputPort	; Get MsgPort.
	bsr.s	InitConsole		; Added V2.12.  Init "console.device".
	tst.l	d0
	bne.s	.Failed			; Exit if no console device.
	CALLINT		CloseWorkBench	; Attempt to close WB screen.
	tst.l	d0
	bne.s	.WBShut			; Branch if OK.
	ori.w	#CHECKED,mi_Flags+Prefs.4	; Setup menu item.
	bra.s	.DoneWB
.WBShut:
	andi.w	#(~CHECKED),mi_Flags+Prefs.4	; Setup menu item.
.DoneWB:
	bsr	EnableMenus		; Setup and attatch initial menus.
	move.l	#0,a1
	CALLEXEC	FindTask	; Get a ptr to us!
	move.l	d0,a0
	move.l	pr_WindowPtr(a0),OldErrorPtr	; Store old value.
	move.l	#-1,pr_WindowPtr(a0)	; We don't want any error requesters.
	bsr.s	VersionControl		; Setup screen height.
	moveq	#1,d0			; Set success return.
	bra.s	.Exit			; Exit to main.
.Failed:
	bsr.s	GlobalCleanup		; Free anything we allocated.
	moveq	#0,d0			; Set Failure return.
.Exit:
	rts

;   Routine added to setup console device so keyboard commands can be read
; and interpreted properly for all international keyboards... V2.12

InitConsole:
	movem.l	d1-7/a0-6,-(sp)		; Save regs.
	lea	ConDev,a0		; Name of device
	lea	ConRequest,a1		; Get ptr for IORequest.
	moveq	#-1,d0			; Device number.
	moveq	#0,d1			; Flags.
	move.l	_InputPort,MN_REPLYPORT(a1)	; Setup msg port.
	move.l	d1,IO_DEVICE(a1)	; This way cleanup can tell if open.
	move.l	d1,IO_DATA(a1)		; We're not attatching to a window...
	move.l	d1,IO_LENGTH(a1)
	CALLEXEC	OpenDevice	; Attempt to open "console.device".
	tst.l	d0			; Did we succeed?
	beq.s	.ExitOkay		; Yes, exit immediately.
	moveq	#-1,d0			; Else, set failure return code.
.ExitOkay:
	movem.l	(sp)+,d1-7/a0-6		; Restore regs.
	rts

VersionControl:		; Setup for PAL or NTSC appropriately.
	move.l	4,a6
	move.l	#192,EditHeight		; Assume PAL.
	move.b	VBlankFrequency(a6),d0
	cmpi.b	#50,d0			; Were we correct?
	beq.s	.GotSize		; Yes, branch.
	move.l	#128,EditHeight		; Else, install NTSC size.
.GotSize:
	move.l	EditHeight,d0
	lea	MapNewWindow,a0
	move.w	d0,nw_Height(a0)	; Set height value for window.
	lea	MapNewScreen,a0
	move.w	d0,ns_Height(a0)	; Set height value for screen.
	rts

GlobalCleanup:
	tst.l	_MapInfoBase		; Is MapInfo allocated?
	beq.s	.NoMapInfo		; No, then branch.
	bsr	FreeData		; Cleanup sub-systems.
	bsr	CleanupConsole		; Close console device.  Added V2.12.
	move.l	_MapInfoBase,a2
	tst.l	minfo_StatusWindow(a2)	; Is Status window open?
	beq.s	.NoStatWindow		; No, Branch.
	move.l	#0,a1
	CALLEXEC	FindTask	; Get a ptr to us!
	move.l	d0,a0
	move.l	OldErrorPtr,pr_WindowPtr(a0)	; Restore old value.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearMenuStrip	; Remove menus.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		CloseWindow	; Close the window.
.NoStatWindow:
	tst.l	minfo_StatusScreen(a2)	; Is status screen open?
	beq.s	.NoStatScreen		; No, Branch.
	move.l	minfo_StatusScreen(a2),a0
	CALLINT		CloseScreen	; Close the screen.
.NoStatScreen:
	move.l	a2,a1
	move.l	#minfo_SIZEOF,d0
	CALLEXEC	FreeMem		; Free Map Info structure.
.NoMapInfo:
	tst.l	_IconBase
	beq.s	.NoIcon			; Branch if icon lib not open.
	move.l	_IconBase,a1
	CALLEXEC	CloseLibrary	; Else, close library.
.NoIcon:
	tst.l	_LayersBase
	beq.s	.NoLayers		; Branch if layers not open.
	move.l	_LayersBase,a1
	CALLEXEC	CloseLibrary	; Else, close library.
.NoLayers:
	tst.l	_GfxBase
	beq.s	.NoGfx			; Branch if gfx lib not open.
	move.l	_GfxBase,a1
	CALLEXEC	CloseLibrary	; Else, close library.
.NoGfx:
	tst.l	_IntuitionBase
	beq.s	.NoInt			; Branch if intuition lib not open.
	CALLINT		OpenWorkBench	; All progs are supposed to do this!
	move.l	_IntuitionBase,a1
	CALLEXEC	CloseLibrary	; Else, close library.
.NoInt:
	rts

;   Routine added to cleanup console device which is now used to properly
; handle international keyboard short-cuts... V2.12

CleanupConsole:
	movem.l	d0-7/a0-6,-(sp)		; Save regs.
	lea	ConRequest,a1		; Get ptr to request.
	tst.l	IO_DEVICE(a1)		; Is it open?
	beq.s	.Exit			; No, then don't bother to close it.
	CALLEXEC	CloseDevice	; Else, close device.
	clr.l	ConRequest+IO_DEVICE	; Clear field.
.Exit:
	movem.l	(sp)+,d0-7/a0-6		; Restore regs.
	rts

HandleInputs:
	move.l	_InputPort,a0
	CALLEXEC	WaitPort	; Wait for users input.
.InputLoop:
	move.l	_InputPort,a0
	CALLEXEC	GetMsg		; Get users input from port.
	tst.l	d0
	beq.s	.Exit			; Exit if there was no msg.
	move.l	d0,a0
	bsr.s	ExtractData		; Make a copy of the msg.
	bsr.s	RoutineCaller		; Call routine to handle input.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_QUIT,d0		; Is user quitting?
	beq.s	.InputLoop		; No, then loop...
.Exit:
	rts				; Return to main.

FreeData:
	bsr	BlockCleanup		; Cleanup Blocks sub-system.
	bsr	MapCleanup		; Cleanup Map sub-system.
	bsr	TilesCleanup		; Cleanup Tiles sus-system.
	rts

ExtractData:
	move.l	a0,-(sp)	; Save ptr for easy reply.
	lea	CurrInput,a1	; Static buffer to get msg.
	move.w	#12,d0		; Copy 13 LONGs of data.
.CopyLoop:
	move.l	(a0)+,(a1)+	; Copy msg...
	dbra	d0,.CopyLoop
	move.l	(sp)+,a1
	CALLEXEC	ReplyMsg	; Reply to input message.
	rts

RoutineCaller:
	moveq	#0,d2		; Function indexer.
	move.l	InputClass,d0	; Get Class of input.
	cmpi.l	#MOUSEMOVE,d0	; Did the mouse move?
	bne.s	.TryGadgets	; No, branch.
	bsr	HandleMove	; Else, handle input.
	bra	.Exit
.TryGadgets:
	cmpi.l	#GADGETUP,d0	; Did user move the mini-map?
	bne.s	.TryKeys	; No, see if it was a key press.
	bsr	HandleMiniMap	; Else, handle input.
	bra	.Exit
.TryKeys:
	cmpi.l	#RAWKEY,d0	; Did user press a key?
	bne.s	.TryMenus	; No, see if they used the menus.
	bsr.s	HandleShortcut	; Else, call short-cut handler. Added V2.12.
	tst.l	d0
	beq.s	.Exit		; Exit if it was a special case.
	bra.s	.GotTables	; Else, use look-up tables & call function.
.TryMenus:
	cmpi.l	#MENUPICK,d0	; Did user select a menu item?
	bne.s	.TryButtons	; No, see if they pressed mouse buttons.
	move.w	InputCode,d0
	lea	DesignerMenus,a0
	CALLINT		ItemAddress	; Else get the address of the item.
	lea	MenuCodes,a0		; And get ptrs to the code tables...
	lea	MenuFuncs,a1
	bra.s	.GotTables
.TryButtons:
	cmpi.l	#MOUSEBUTTONS,d0	; Did user click a mouse button?
	bne.s	.Exit			; No, then we're not interested!
	lea	ButtonCodes,a0		; Else, get tables...
	lea	ButtonFuncs,a1
	move.w	InputCode,d0		; And the code to look up.
	ext.l	d0
.GotTables:
	tst.l	d0		; Test input code.
	beq.s	.Exit		; Can't handle NULL codes.
.SearchLoop:
	tst.l	(a0)
	beq.s	.Exit		; NULL at the end of the table.
	cmp.l	(a0)+,d0	; Is this the code?
	beq.s	.GotCode	; Yes, then branch.
	addq.w	#4,d2
	bra.s	.SearchLoop	; Try next code...
.GotCode:
	move.l	(a1,d2),a0	; Get address of routine.
	cmpa.l	#ButtonFuncs,a1
	bne.s	.Normal
	jsr	(a0)		; Don't turn inputs off on a button command.
	bra.s	.Exit
.Normal:
	bsr	BeginInput	; Switch off inputs etc.
	jsr	(a0)		; Call routine.
	bsr	EndInput	; Switch inputs etc back on.
.Exit:
	rts			; Return.

;   This routine converts RAWKEYS into international keyboard info, then it
; sets up the tables for the main routine to use.  Special cases such as
; scrolling and +/- tile are handled directly as before, although the method
; for detecting these has changed.  See "CheckDirect".

HandleShortcut:
	movem.l	d1-7/a2-6,-(sp)		; Save regs.
	lea	ConInput,a0		; Setup inputs...
	lea	ASCIITemp,a1
	lea	CurrInput,a2		; Convert im_ to ie_...
	move.b	#IECLASS_RAWKEY,ie_Class(a0)
	move.w	im_Code(a2),ie_Code(a0)
	move.w	im_Qualifier(a2),ie_Qualifier(a0)
	move.l	im_IAddress(a2),ie_EventAddress(a0)
	move.l	#75,d1
	suba.l	a2,a2			; Default keymap.
	lea	ConRequest,a6
	move.l	IO_DEVICE(a6),a6	; Get a base ptr.
	jsr	_LVORawKeyConvert(a6)	; Convert RAWKEY.
	tst.l	d0
	beq.s	.Exit			; Exit if no converted codes.
	bsr.s	CheckDirect		; See if we can handle it here
	tst.l	d0
	beq.s	.Exit			; Exit if we did.
	lea	ASCIITemp,a0		; Else, get data.
	cmpi.b	#$9B,(a0)		; Is it "Special"?
	beq.s	.Extended
	moveq	#0,d0			; Get keycode as a LONG...
	move.b	(a0),d0
	lea	AscCodes,a0		; Get codes for normal keys...
	lea	AscFuncs,a1
	bra.s	.Exit			; Exit.
.Extended:
	moveq	#0,d0			; Get keycode as a LONG...
	move.b	1(a0),d0
	lea	ExtCodes,a0		; Get codes for extended keys...
	lea	ExtFuncs,a1
.Exit:
	movem.l	(sp)+,d1-7/a2-6		; Restore regs.
	rts

;   Changed in V2.12 for extended keyboard shortcuts...

CheckDirect:
	lea	ASCIITemp,a0		; Get data buffer.
	cmpi.b	#$9B,(a0)		; Is it "Special"?
	beq.s	.Extended		; Yes, deal with it seperately.
	move.b	(a0),d0			; Else, get ASCII code.
	cmpi.w	#"-",d0			; Is it "Down tile"?
	beq.s	.DoPrev			; No, check other key.
	cmpi.w	#"_",d0			; Is it "Down tile"?
	bne.s	.TryNext		; No, check next condition.
.DoPrev:
	bsr	PreviousTile		; Else, call function.
	moveq	#0,d0
	bra.s	.Exit			; Exit.
.TryNext:
	cmpi.w	#"+",d0			; Is it "Up tile"?
	beq.s	.DoNext			; No, then check other key.
	cmpi.w	#"=",d0			; Is it "Up tile"?
	bne.s	.UseTables		; No, then we must use tables.
.DoNext:
	bsr	NextTile		; Else, call function.
	moveq	#0,d0
	bra.s	.Exit			; Exit.
.Extended:
	move.b	1(a0),d0		; Else, get code.
	cmpi.w	#"D",d0			; Is it "Left"?
	bne.s	.TryRight		; No, check next condition.
	bsr	ScrollLeft		; Else, call function.
	moveq	#0,d0
	bra.s	.Exit			; Exit.
.TryRight:
	cmpi.w	#"C",d0			; Is it "Right"?
	bne.s	.TryUp			; No, check next condition.
	bsr	ScrollRight		; Else, call function.
	moveq	#0,d0
	bra.s	.Exit			; Exit.
.TryUp:
	cmpi.w	#"A",d0			; Is it "Up"?
	bne.s	.TryDown		; No, check next condition.
	bsr	ScrollUp		; Else, call function.
	moveq	#0,d0
	bra.s	.Exit			; Exit.
.TryDown:
	cmpi.w	#"B",d0			; Is it "Down"?
	bne.s	.UseTables		; No, then we must use tables.
	bsr	ScrollDown		; Else, call function.
	moveq	#0,d0
	bra.s	.Exit			; Exit.
.UseTables:
	moveq	#-1,d0
.Exit:
	rts

BlockCleanup:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2		; Get data struct.
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_BLOCK,d2		; Is there a block?
	beq.s	.Exit			; No, Just exit.
	move.l	minfo_Block(a2),a1
	move.w	minfo_BX(a2),d0		; Calculate block size...
	mulu.w	minfo_BY(a2),d0
	lsl.l	#1,d0			; Convert WORDs to BYTEs.
	CALLEXEC	FreeMem		; Free block array memory.
	andi.w	#~(MIFF_BLOCK!MIFF_MODE),minfo_Flags(a2)
	bsr	DisplayStatus		; Up-date status display.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

MapCleanup:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2		; Get data struct.
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_MAP,d2		; Is there a map?
	beq.s	.Exit			; No, Just exit.
	bsr	CloseMapScreen		; Get rid of map display.
	move.l	minfo_Map(a2),a1
	move.w	minfo_MX(a2),d0		; Calculate block size...
	mulu.w	minfo_MY(a2),d0
	lsl.l	#1,d0			; Convert WORDs to BYTEs.
	CALLEXEC	FreeMem		; Free map array memory.
	andi.w	#~MIFF_MAP,minfo_Flags(a2)	; Clear map flag.
.Exit:
	move.w	#320,minfo_MRasX(a2)	; Install defaults...
	clr.w	minfo_Res(a2)
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

TilesCleanup:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2		; Get data struct.
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_TILES,d2		; Are there tiles loaded?
	beq.s	.Exit			; No, Just exit.
	bsr	FreeTiles		; Free all tile data.
	andi.w	#~MIFF_TILES,minfo_Flags(a2)	; Clear tiles flag.
.Exit:
	move.w	#32,minfo_TX(a2)	; Install defaults...
	move.w	#32,minfo_TY(a2)
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

HandleMove:
	bsr	CheckInput		; Ensure correct window is active.
	bsr	DisplayCursorPosition	; Update cursor.
	rts

HandleMiniMap:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	lea	MiniMapInfo,a1		; Get PropInfo struct.
	move.l	EditHeight,d1
	divu.w	minfo_TY(a2),d1		; d1 = Window Height in tiles.
	move.w	minfo_MY(a2),d0
	sub.w	d1,d0			; d0 = Total height - 1 window.
	bge.s	.GotTempY		; If value >0, then branch.
	moveq	#0,d0			; Else install minimum possible.
.GotTempY:
	mulu.w	pi_VertPot(a1),d0	; Calculate MYP value from value in
	move.l	#MAXPOT,d1		; Pot variable...
	lsr.l	#1,d1
	add.l	d1,d0
	divu.w	#MAXPOT,d0
	move.w	d0,minfo_MYP(a2)	; Install value in minfo_ structure.
	moveq	#0,d1
	move.w	minfo_MRasX(a2),d1
	divu.w	minfo_TX(a2),d1		; d1 = Window Width in tiles.
	move.w	minfo_MX(a2),d0
	sub.w	d1,d0			; d0 = Total width - 1 window.
	bge.s	.GotTempX		; If value >0, then branch.
	moveq	#0,d0			; Else, install minimum possible.
.GotTempX:
	mulu.w	pi_HorizPot(a1),d0	; Calculate MXP value from value in
	move.l	#MAXPOT,d1		; Pot variable...
	lsr.l	#1,d1
	add.l	d1,d0
	divu.w	#MAXPOT,d0
	move.w	d0,minfo_MXP(a2)	; Install value in minfo_ structure.
	bsr	MoveMap			; Update display and status.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

DisplayStatus:
	bsr	DisplayTileStatus	; Display tiles info.
	bsr	DisplayMapStatus	; Display map info.
	rts

CloseMapScreen:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	tst.l	minfo_MapWindow(a2)	; Is map display window open?
	beq.s	.Exit			; No, exit.
	move.l	minfo_MapScreen(a2),a0
	CALLINT		ScreenToBack	; Hide screen.
	move.l	minfo_MapWindow(a2),a0
	CALLINT		ClearPointer	; Get rid of custom mouse ptr.
	move.l	minfo_MapWindow(a2),a0
	bsr	CloseWindowSafely	; Close map display window.
	clr.l	minfo_MapWindow(a2)
	move.l	minfo_MapScreen(a2),a0
	CALLINT		CloseScreen	; Close map display screen.
	move.l	minfo_StatusWindow(a2),a0
	lea	MiniMapGadget,a1
	CALLINT		RemoveGadget	; Remove Mini-Map mover.
	andi.w	#~MIFF_CDRAWN,minfo_Flags(a2)	; Clear cursor drawn flag.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

FreeTiles:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are there tiles loaded?
	beq.s	.Exit			; No, exit
	move.l	minfo_TilesPort(a2),a5
	move.l	vp_RasInfo(a5),a3
	move.l	ri_BitMap(a3),a4
	move.l	a4,a0
	bsr	FreePlanes		; Free tiles raster planes.
	move.l	a4,a1
	moveq	#bm_SIZEOF,d0
	CALLEXEC	FreeMem		; Free BitMap memory.
	move.l	a3,a1
	moveq	#ri_SIZEOF,d0
	CALLEXEC	FreeMem		; Free RasInfo memory.
	move.l	vp_ColorMap(a5),a0
	CALLGRAF	FreeColorMap	; Free ColorMap structure.
	move.l	a5,a1
	moveq	#vp_SIZEOF,d0
	CALLEXEC	FreeMem		; Free ViewPort memory.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

CheckInput:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	move.w	wd_MouseY(a0),d2	; Get y co-ord of mouse.
	moveq	#0,d0
	CALLINT		LockIBase	; Lock intuition.
	move.l	ib_ActiveWindow(a6),a3	; Get active window.
	move.l	d0,a0
	CALLINT		UnlockIBase	; Unlock intuition.
	cmpi.w	#67,d2			; Is mouse in Map Screen?
	blt.s	.ActiStatus		; No, then ensure status is active.
	tst.l	minfo_MapWindow(a2)
	beq.s	.ActiStatus		; Activate status if no map window.
	cmpa.l	minfo_MapWindow(a2),a3	; Is map window already active?
	beq.s	.Exit			; Yes, exit.
	move.l	minfo_MapWindow(a2),a0
	CALLINT		ActivateWindow	; Else, activate map window.
	bra.s	.Exit
.ActiStatus:
	andi.w	#~MIFF_BDOWN,minfo_Flags(a2)	; Must clear paint mode.
	cmpa.l	minfo_StatusWindow(a2),a3	; Is status already active?
	beq.s	.Exit				; Yes, exit.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow	; Else, activate status window.
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_BSELECT,d0	; Is user selecting a block?
	bne.s	.Exit			; Yes, then don't clear mode texts.
	bsr	DisplayTileStatus	; Else, update tile status.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

DisplayCursorPosition:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	bsr	SetPens			; Setup status rport.
	move.l	_MapInfoBase,a5		; Get pointer to data.
	lea	CurrInput,a0		; Pointer to input message.
	moveq	#0,d2
	move.w	im_MouseX(a0),d2	; Get x co-ord of mouse.
	divu.w	minfo_TX(a5),d2		; Get curs co-ord for screen.
	add.w	minfo_MXP(a5),d2	; Now make it relative to map.
	cmp.w	minfo_MX(a5),d2		; Is Co-ord off map?
	blt.s	.XCoOK			; No, then branch.
	move.w	minfo_MX(a5),d2		; Else, set to max allowable...
	subq.w	#1,d2
.XCoOK:
	move.w	d2,minfo_CXP(a5)	; = CXP.
	moveq	#0,d3
	move.w	im_MouseY(a0),d3	; Get y co-ord of mouse.
	divu.w	minfo_TY(a5),d3		; Get curs co-ord for screen.
	add.w	minfo_MYP(a5),d3	; Now make it relative to map.
	cmp.w	minfo_MY(a5),d3		; Is Co-ord off map?
	blt.s	.YCoOK			; No, then branch.
	move.w	minfo_MY(a5),d3		; Else, set to max allowable...
	subq.w	#1,d3
.YCoOK:
	move.w	d3,minfo_CYP(a5)	; = CYP.
	sub.w	minfo_MYP(a5),d3	; Get screen relative co-ord.
	mulu.w	minfo_TY(a5),d3		; Calculate on-screen co-ord of CYP.
	sub.w	minfo_MXP(a5),d2	; Get screen relative co-ord.
	mulu.w	minfo_TX(a5),d2		; Calculate on-screen co-ord of CXP.
	move.w	minfo_Flags(a5),d7	; Get flags.
	btst	#MIFB_MODE,d7		; Are we in block mode?
	beq.s	.TileMode		; No, then branch.
	move.w	minfo_BX(a5),d4		; Get block width.
	mulu.w	minfo_TX(a5),d4		; Calculate width in pixels.
	move.w	minfo_BY(a5),d5		; Get block height.
	mulu.w	minfo_TY(a5),d5		; Calculate height in pixels.
	bra.s	.GotDims
.TileMode:
	move.w	minfo_TX(a5),d4		; Get width of 1 tile.
	move.w	minfo_TY(a5),d5		; And height of 1 tile.
.GotDims:
	cmp.w	minfo_OSX(a5),d2	; Are x co-ords the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSY(a5),d3	; Are y co-ords the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSW(a5),d4	; Are widths the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSH(a5),d5	; Are heights the same.
	beq.s	.IsDrawn		; Yes, see if we need draw anything.
.CursMoved:
	btst	#MIFB_CDRAWN,d7		; Is there a cursor on the display?
	beq.s	.NoCursor		; No, then we won't remove it.
	bsr	DrawCursor		; Else, remove cursor.
	andi.w	#(~MIFF_CDRAWN),minfo_Flags(a5)	; And clear flag.
.NoCursor:
	moveq	#0,d0
	CALLINT		LockIBase	; Lock-out intuition.
	move.l	ib_ActiveWindow(a6),a2	; Get Active window.
	move.l	d0,a0
	CALLINT		UnlockIBase	; Unlock intuition base.
	cmpa.l	minfo_MapWindow(a5),a2	; Is mouse in Map Window?
	bne	.WrongScreen		; No, then branch.
	move.w	d2,minfo_OSX(a5)	; OSX = NSX.
	move.w	d3,minfo_OSY(a5)	; OSY = NSY.
	move.w	d4,minfo_OSW(a5)	; OSW = NSW.
	move.w	d5,minfo_OSH(a5)	; OSH = NSH.
	btst	#MIFB_PAINT,d7		; Are we in paint mode?
	beq.s	.IsDrawn		; No, then branch.
	btst	#MIFB_BDOWN,d7		; Is the left mouse button down?
	beq.s	.IsDrawn		; No, then branch.
	bsr	PlaceTile		; Else, place CTile / Block.
	bra.s	.JustCoords		; Now update status display.
.IsDrawn:
	move.w	minfo_Flags(a5),d7	; Get updated copy of flags.
	btst	#MIFB_CDRAWN,d7		; Is cursor drawn?
	bne.s	.Exit			; Yes, then don't redraw same cursor.
	moveq	#0,d0
	CALLINT		LockIBase	; Lock-out intuition.
	move.l	ib_ActiveWindow(a6),a2	; Get Active window.
	move.l	d0,a0
	CALLINT		UnlockIBase	; Unlock intuition base.
	cmpa.l	minfo_MapWindow(a5),a2	; Is mouse in Map Window?
	bne.s	.WrongScreen		; No, then branch.
	btst	#MIFB_NOCURS,d7		; Do we need to draw a cursor?
	bne.s	.JustCoords		; No, then branch.
	bsr	DrawCursor		; Else, draw cursor.
	ori.w	#MIFF_CDRAWN,minfo_Flags(a5)	; And set flag.
.JustCoords:
	move.w	minfo_CXP(a5),d0	; Get cursor x value.
	move.w	#300,d1			; Set desination co-ords...
	move.w	#53,d2
	bsr	PrintInteger		; Print the value.
	move.w	minfo_CYP(a5),d0	; Get cursor y value.
	move.w	#372,d1			; Set desination co-ords...
	move.w	#53,d2
	bsr	PrintInteger		; Print the value.
	bra.s	.Exit
.WrongScreen:
	move.w	#300,d0			; Setup co-ords...
	move.w	#53,d1
	bsr.s	ClearText		; Clear CXP field.
	move.w	#372,d0			; Setup co-ords...
	move.w	#53,d1
	bsr.s	ClearText		; Clear CYP field.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall old registers.
	rts

;   This routine is not documented, it basically makes the clearing of status
; fields much easier.  d0 - x co-ord.  d1 - y co-ord...

ClearText:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)		; Save this.
	CALLGRAF	Move		; Move gfx cursor.
					; Co-ords are inputs. (see above.)
	move.l	(sp)+,a1		; Recall Rastport ptr.
	lea	BlankStr,a0
	moveq	#5,d0
	CALLGRAF	Text		; Write blank data.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

MoveMap:
	bsr	DrawMapSection		; Update map display.
	bsr	DisplayMapStatus	; Update map status display.
	rts

DisplayTileStatus:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	bsr	SetPens			; Setup status RPort.
	move.l	_MapInfoBase,a4
	move.w	minfo_Flags(a4),d2	; Get flags.
	btst	#MIFB_TILES,d2		; Is the tiles flag set?
	beq	.ClearTileStatus	; No, then clear fields.
	btst	#MIFB_MODE,d2		; Are we in block mode?
	beq	.TilesInfo		; No, then print tiles info.
	move.l	minfo_StatusWindow(a4),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)		; Save this.
	move.w	#60,d0
	move.w	#32,d1
	CALLGRAF	Move		; Move gfx cursor.
	move.l	(sp),a1			; Recall Rastport ptr.
	lea	BlockStr,a0
	moveq	#5,d0
	CALLGRAF	Text		; Write mode text.
	lea	SizeFormat,a0		; Get format string.
	lea	StuffChar,a2		; Get character ouput routine.
	lea	ASCIITemp,a3		; Get destination for string.
	move.w	minfo_BY(a4),-(sp)	; Push width onto data stream.
	move.w	minfo_BX(a4),-(sp)	; Push height onto data stream.
	move.l	sp,a1			; Get ptr to data stream.
	CALLEXEC	RawDoFmt	; Convert data to ASCII string.
	move.l	4(sp),a1		; Recall Rastport ptr.
	move.w	#60,d0			; Size co-ords...
	move.w	#53,d1
	CALLGRAF	Move		; Move gfx cursor.
	lea	ASCIITemp,a0
	move.l	4(sp),a1		; Recall Rastport ptr.
	moveq	#5,d0
	CALLGRAF	Text		; Write size text.
	addq.l	#4,sp			; Remove data from stack.
	move.l	(sp),a1
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	(sp)+,a1
	move.w	#14,d0			; Setup Top-Left co-ords...
	move.w	#23,d1
	move.w	#45,d2			; Setup Bottom-Right co-ords...
	move.w	#54,d3
	CALLGRAF	RectFill	; Clear CTile Image.
	bra	.CheckPaint
.TilesInfo:
	bsr	BlitCTile
	move.w	minfo_CTile(a4),d0	; Get CTile value.
	move.w	#60,d1			; Setup co-ords...
	move.w	#32,d2
	bsr	PrintInteger		; Print CTile.
	lea	SizeFormat,a0		; Get format string.
	lea	StuffChar,a2		; Get character ouput routine.
	lea	ASCIITemp,a3		; Get destination for string.
	move.w	minfo_TY(a4),-(sp)	; Push width onto data stream.
	move.w	minfo_TX(a4),-(sp)	; Push height onto data stream.
	move.l	sp,a1			; Get ptr to data stream.
	CALLEXEC	RawDoFmt	; Convert data to ASCII string.
	move.l	minfo_StatusWindow(a4),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)		; Save this.
	move.w	#60,d0			; Size co-ords...
	move.w	#53,d1
	CALLGRAF	Move		; Move gfx cursor.
	lea	ASCIITemp,a0
	move.l	(sp)+,a1		; Recall Rastport ptr.
	moveq	#5,d0
	CALLGRAF	Text		; Write size text.
	addq.l	#4,sp			; Remove data from stack.
	bra.s	.CheckPaint
.ClearTileStatus:
	move.w	#60,d0			; Setup co-ords...
	move.w	#32,d1
	bsr	ClearText		; Clear CTile field.
	move.w	#60,d0			; Setup co-ords...
	move.w	#53,d1
	bsr	ClearText		; Clear Size field.
	move.l	minfo_StatusWindow(a4),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	(sp)+,a1
	move.w	#14,d0			; Setup Top-Left co-ords...
	move.w	#23,d1
	move.w	#45,d2			; Setup Bottom-Right co-ords...
	move.w	#54,d3
	CALLGRAF	RectFill	; Clear CTile Image.
	bra.s	.Exit
.CheckPaint:
	bsr	SetPens			; Setup status RPort.
	move.w	minfo_Flags(a4),d2	; Get flags.
	andi.w	#(MIFF_PAINT!MIFF_BDOWN),d2	; Conditions right?
	cmpi.w	#(MIFF_PAINT!MIFF_BDOWN),d2
	bne.s	.Exit			; No, then leave status alone.
	move.l	minfo_StatusWindow(a4),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)		; Save this.
	move.w	#60,d0			; Size co-ords...
	move.w	#53,d1
	CALLGRAF	Move		; Move gfx cursor.
	lea	PaintStr,a0
	move.l	(sp)+,a1		; Recall Rastport ptr.
	moveq	#5,d0
	CALLGRAF	Text		; Write paint mode text.	
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

DisplayMapStatus:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	bsr	SetPens			; Setup status RPort.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2	; Get flags.
	btst	#MIFB_MAP,d2		; Is map defined?
	beq	.ClearMapStat		; No, clear map status fields.
	move.w	minfo_MX(a2),d0
	move.w	#143,d1
	move.w	#32,d2
	bsr	PrintInteger		; Print map width.
	move.w	minfo_MY(a2),d0
	move.w	#215,d1
	move.w	#32,d2
	bsr	PrintInteger		; Print map height.
	move.w	minfo_Depth(a2),d0
	move.w	#143,d1
	move.w	#53,d2
	bsr	PrintInteger		; Print map width.
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get Rastport.
	move.l	a1,-(sp)		; Save ptr.
	move.w	#215,d0
	move.w	#53,d1
	CALLGRAF	Move		; Move graphics cursor.
	move.l	(sp)+,a1
	moveq	#5,d0
	move.w	minfo_Res(a2),d2	; Get screen res.
	btst	#15,d2			; Is HiRes bit set?
	beq.s	.LoRes			; No, print "LoRes" text.
	lea	HiResStr,a0
	CALLGRAF	Text		; Print "HiRes".
	bra.s	.DoneRes
.LoRes:
	lea	LoResStr,a0
	CALLGRAF	Text		; Print "LoRes".
.DoneRes:
	move.w	minfo_MXP(a2),d0
	move.w	#300,d1
	move.w	#32,d2
	bsr	PrintInteger		; Print map x position.
	move.w	minfo_MYP(a2),d0
	move.w	#372,d1
	move.w	#32,d2
	bsr	PrintInteger		; Print map y position.
	bsr	DisplayCursorPosition	; Draw cursor & co-ords.
	move.l	EditHeight,d4		; Calculate VertBody...
	divu.w	minfo_TY(a2),d4		; VertBody = 
	move.w	minfo_MY(a2),d0		; (((EditHeight/TY)*MAXBODY)/MY)...
	sub.w	d4,d0
	ble.s	.MaxVert
	mulu.w	#MAXBODY,d4
	divu.w	minfo_MY(a2),d4
	bra.s	.GotVBod
.MaxVert:
	move.w	#MAXBODY,d4		; Or = MAXBODY if map <= 1 screen.
.GotVBod:
	moveq	#0,d0
	move.w	minfo_MRasX(a2),d3	; Calculate HorizBody...
	divu.w	minfo_TX(a2),d3		; HorizBody=
	move.w	minfo_MX(a2),d0		; (((MRasX/TX)*MAXBODY)/MX)...
	sub.w	d3,d0
	ble.s	.MaxHoriz
	mulu.w	#MAXBODY,d3
	divu.w	minfo_MX(a2),d3
	bra.s	.GotHBod
.MaxHoriz:
	move.w	#MAXBODY,d3		; Or = MAXBODY if map <= 1 screen.
.GotHBod:
	moveq	#0,d1
	move.w	minfo_MRasX(a2),d1	; Calculate HorizPot...
	divu.w	minfo_TX(a2),d1		; HorizPot=
	move.w	minfo_MX(a2),d0		; ((MXP*MAXPOT)/(MX/TX))...
	sub.w	d1,d0
	ble.s	.MinHoriz
	move.w	minfo_MXP(a2),d1
	mulu.w	#MAXPOT,d1
	divu.w	d0,d1
	bra.s	.GotHPot
.MinHoriz:
	move.w	#0,d1			; Or = 0 if map <= 1 screen.
.GotHPot:
	move.l	EditHeight,d2		; Calculate VertPot...
	divu.w	minfo_TY(a2),d2		; VertPot=
	move.w	minfo_MY(a2),d0		; ((MYP*MAXPOT)/(MY/TY))...
	sub.w	d2,d0
	ble.s	.MinVert
	move.w	minfo_MYP(a2),d2
	mulu.w	#MAXPOT,d2
	divu.w	d0,d2
	bra.s	.GotVPot
.MinVert:
	move.w	#0,d2			; Or = 0 if map <= 1 screen.
.GotVPot:
	move.w	#(AUTOKNOB!FREEVERT!FREEHORIZ!PROPBORDERLESS),d0
	lea	MiniMapGadget,a0
	move.l	minfo_StatusWindow(a2),a1
	move.l	#0,a2
	CALLINT		ModifyProp
	bra.s	.Exit
.ClearMapStat:
	move.w	#143,d0			; Setup co-ords...
	move.w	#32,d1
	bsr	ClearText		; Clear MapX field.
	move.w	#215,d0			; Setup co-ords...
	move.w	#32,d1
	bsr	ClearText		; Clear MapY field.
	move.w	#143,d0			; Setup co-ords...
	move.w	#53,d1
	bsr	ClearText		; Clear Depth field.
	move.w	#215,d0			; Setup co-ords...
	move.w	#53,d1
	bsr	ClearText		; Clear Res field.
	move.w	#300,d0			; Setup co-ords...
	move.w	#32,d1
	bsr	ClearText		; Clear MapXPos field.
	move.w	#372,d0			; Setup co-ords...
	move.w	#32,d1
	bsr	ClearText		; Clear MapYPos field.
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	(sp)+,a1
	move.w	#435,d0			; Setup Top-Left co-ords...
	move.w	#18,d1
	move.w	#631,d2			; Setup Bottom-Right co-ords...
	move.w	#59,d3
	CALLGRAF	RectFill	; Clear Mini-Map area.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

CloseWindowSafely:
	move.l	a0,-(sp)	; Save users input.
	CALLEXEC	Forbid	; Forbid multitasking.
	move.l	(sp),a0
	tst.l	wd_UserPort(a0)
	beq.s	.NoPort
	bsr	StripInputs	; Remove all messages for this window.
	move.l	(sp),a0
	clr.l	wd_UserPort(a0)		; Remove ptr to User Port.
.NoPort:
	moveq	#0,d0
	CALLINT		ModifyIDCMP	; We want no more messages.
	CALLEXEC	Permit		; Enable multitasking.
	move.l	(sp)+,a0
	CALLINT		CloseWindow	; Now actually close the window.
	rts

FreePlanes:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	a0,a2
	moveq	#0,d2		; Set plane indexer to 0.
	move.b	bm_Depth(a2),d3		; Number of planes to free.
	ext.w	d3
	subq.w	#1,d3		; Adjustment for dbra.
.FreeLoop:
	tst.l	bm_Planes(a2,d2)	; Check current plane
	beq.s	.NoPlane		; Branch if this is not a plane.
	move.l	bm_Planes(a2,d2),a0	; Get raster ptr.
	move.w	bm_Rows(a2),d1		; Get rows.
	move.w	bm_BytesPerRow(a2),d0	; And width,
	lsl.w	#3,d0			; In pixels.
	CALLGRAF	FreeRaster
	clr.l	bm_Planes(a2,d2)	; Clear ptr, so we don't free again.
.NoPlane:
	addq.w	#4,d2			; Move onto next plane.
	dbra	d3,.FreeLoop		; Repeat for all planes...
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

DrawCursor:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_MapWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get ptr to windows rast port.
	move.l	a1,-(sp)		; Save for later usage.
	moveq	#RP_COMPLEMENT,d0	; XOR mode.
	CALLGRAF	SetDrMd		; Set the drawing mode.
	move.l	(sp),a1
	move.w	minfo_OSX(a2),d0
	move.w	minfo_OSY(a2),d1
	CALLGRAF	Move		; Starting position.
	move.l	(sp),a1
	move.w	minfo_OSX(a2),d0
	add.w	minfo_OSW(a2),d0
	subq.w	#1,d0
	move.w	minfo_OSY(a2),d1
	CALLGRAF	Draw		; Draw 1st line.
	move.l	(sp),a1
	move.w	minfo_OSX(a2),d0
	add.w	minfo_OSW(a2),d0
	subq.w	#1,d0
	move.w	minfo_OSY(a2),d1
	add.w	minfo_OSH(a2),d1
	subq.w	#1,d1
	CALLGRAF	Draw		; Draw 2nd line.
	move.l	(sp),a1
	move.w	minfo_OSX(a2),d0
	move.w	minfo_OSY(a2),d1
	add.w	minfo_OSH(a2),d1
	subq.w	#1,d1
	CALLGRAF	Draw		; Draw 3rd line.
	move.l	(sp)+,a1
	move.w	minfo_OSX(a2),d0
	move.w	minfo_OSY(a2),d1
	addq.w	#1,d1
	CALLGRAF	Draw		; Draw 4th line.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

PrintInteger:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	movem.l	d0-2,-(sp)	; Save inputs.
	lea	2(sp),a1	; Get data stream.
	lea	IntegerFormat,a0	; Get format string.
	lea	StuffChar,a2	; Get character output routine.
	lea	ASCIITemp,a3	; Get output string.
	CALLEXEC	RawDoFmt	; Convert value to an ASCII string.
	movem.l	(sp)+,d0-2	; Recall inputs
	move.w	d1,d0		; Put into correct registers...
	move.w	d2,d1
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get rastport pointer.
	move.l	a1,-(sp)
	CALLGRAF	Move	; Move cursor to given co-ords.
	moveq	#5,d0		; Always 5.
	move.l	(sp)+,a1
	lea	ASCIITemp,a0	; String.
	CALLGRAF	Text	; Print text onto screen.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

DrawMapSection:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a3		; For the use of!
	move.w	minfo_Flags(a3),d0
	btst	#MIFB_CDRAWN,d0		; Is the cursor drawn?
	beq.s	.NoCursor
	bsr	DrawCursor
.NoCursor:
	link	a5,#-20			; Allocate local vars.
	CALLGRAF	OwnBlitter	; Get Blitter for private use.
	CALLGRAF	WaitBlit	; Make sure it is safe.
	lea	custom,a6		; Get base of chips.
	move.l	#-1,bltafwm(a6)		; Setup source masks.
	move.w	#$09f0,bltcon0(a6)	; Just copy A to D.
	move.w	#$0000,bltcon1(a6)	; No special modes.
	move.w	minfo_TRasX(a3),d0
	sub.w	minfo_TX(a3),d0
	lsr.w	#3,d0			; Turn bits to bytes.
	move.w	d0,bltamod(a6)		; = ( ( TRasX - TX ) / 8 )
	move.w	minfo_MRasX(a3),d0
	sub.w	minfo_TX(a3),d0
	lsr.w	#3,d0			; Turn bits to bytes.
	move.w	d0,bltdmod(a6)		; = ( ( MRasX - TX ) / 8 )
	move.w	minfo_TY(a3),d4		; Calculate BLTSIZE...
	lsl.w	#6,d4
	move.w	minfo_TX(a3),d0
	lsr.w	#4,d0
	or.w	d0,d4			; = ( ( TY << 6 ) ! ( TX >> 4 ) )
	move.l	minfo_TilesPort(a3),a0
	move.l	vp_RasInfo(a0),a0
	move.l	ri_BitMap(a0),a0	; Get ptr to tiles' BitMap.
	move.l	minfo_MapWindow(a3),a1
	move.l	wd_RPort(a1),a1
	move.l	rp_BitMap(a1),a1	; Get ptr to map's BitMap.
	move.l	minfo_Map(a3),a2	; Get ptr to map data.
	move.w	minfo_MYP(a3),d0	; Calculate map offset...
	mulu.w	minfo_MX(a3),d0
	move.w	minfo_MXP(a3),d1	; This must be added as a LONG...
	ext.l	d1
	add.l	d1,d0
	lsl.l	#1,d0			; = ( ( ( MYP * MX ) + MXP ) * 2 )
	adda.l	d0,a2			; Add offset onto map base ptr.
	move.l	EditHeight,d7			; Calculate height of output...
	divu.w	minfo_TY(a3),d7		; = ( EditHeight / TY ).
	cmp.w	minfo_MY(a3),d7
	blt.s	.GotHeight		; Branch if we have the smaller one.
	move.w	minfo_MY(a3),d7		; Else, set height to MY.
.GotHeight:
	move.l	d7,-20(a5)
	moveq	#0,d7
	moveq	#0,d6			; Calculate width of output...
	move.w	minfo_MRasX(a3),d6	; Get screen width.
	divu.w	minfo_TX(a3),d6		; = ( MRasX / TX ).
	cmp.w	minfo_MX(a3),d6
	blt.s	.GotWidth		; Branch if we have the smaller one.
	move.w	minfo_MX(a3),d6		; Else, set width to MX.
.GotWidth:
	move.w	minfo_MX(a3),d0		; Calculate map modulo...
	sub.w	d6,d0			; = ( Mx - Width ).
	ext.l	d0
	lsl.l	#1,d0
	move.l	d0,-4(a5)		; Store as local variable.
	move.l	d6,-16(a5)		; Store width for later.
.RowLoop:
	moveq	#0,d6			; Swt initial position.
.LineLoop:
	moveq	#0,d3			; Set plane indexer to 0.
	move.w	minfo_TX(a3),d0		; Calculate dest. offset...
	lsr.w	#3,d0			; Divide by 8.
	mulu.w	d6,d0
	move.w	bm_BytesPerRow(a1),d1
	mulu.w	d7,d1
	mulu.w	minfo_TY(a3),d1
	add.l	d1,d0			; = ((X*(Tx/8))+(Y*(Ty*BytesPerRow)))
	move.l	d0,-12(a5)		; Store as Dest. Offset.
	move.w	(a2)+,d0		; Calculate Source offset...
	mulu.w	minfo_TX(a3),d0
	divu.w	minfo_TRasX(a3),d0
	move.l	d0,d1			; Save for later.
	mulu.w	bm_BytesPerRow(a0),d0
	mulu.w	minfo_TY(a3),d0		; ((((Tile*Tx)/TRasX)*Ty)*BPRow)+...
	clr.w	d1
	swap	d1			; Get remainder from above.
	lsr.w	#3,d1			; (((Tile*Tx) mod TRasX)/8)
	add.w	d1,d0			; Add two halves together.
	move.l	d0,-8(a5)		; Store as Source offset.
	move.b	bm_Depth(a1),d5		; Setup depth loop...
	ext.w	d5
	subq.w	#1,d5
.DepthLoop:
	move.l	bm_Planes(a0,d3),a4	; Get source plane.
	adda.l	-8(a5),a4		; Add source offset.
	move.l	a4,bltapt(a6)		; Write bitter register.
	move.l	bm_Planes(a1,d3),a4	; Get dest. plane.
	adda.l	-12(a5),a4		; Add dest. offset.
	move.l	a4,bltdpt(a6)		; Write bitter register.
	move.w	d4,bltsize(a6)		; Start blit.
	addq.w	#4,d3			; Advance index register.
	bsr.s	WaitBlit		; Un-documented routine. (Oops!)
	dbra	d5,.DepthLoop		; Planes Loop...
	addq.w	#1,d6
	cmp.l	-16(a5),d6
	blt.s	.LineLoop		; Width Loop...
	add.l	-4(a5),a2		; Add map modulo.
	addq.w	#1,d7
	cmp.l	-20(a5),d7
	blt.s	.RowLoop		; Rows Loop...
	CALLGRAF	DisownBlitter	; Free blitter.
	unlk	a5			; Free local vars.
	andi.w	#~MIFF_CDRAWN,minfo_Flags(a3)	; Clear CDrawn flag.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

WaitBlit:	; This is simple but was un-documented in the design...
	move.w	d0,-(sp)
	move.w	dmaconr(a6),d0		; a6 must be setup by client.
.Wait:
	move.w	dmaconr(a6),d0		; a6 must be setup by client.
	btst	#DMAB_BLTDONE,d0
	bne.s	.Wait
	move.w	(sp)+,d0
	rts

BlitCTile:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_CTile(a2),d1	; Calculate Source y co-ord...
	mulu.w	minfo_TX(a2),d1
	divu.w	minfo_TRasX(a2),d1
	move.l	d1,d0			; Save for calc of x co-ord.
	mulu.w	minfo_TY(a2),d1		; d1 = final src y co-ord.
	swap	d0			; d0 = final src x co-ord.
	move.w	#14,d2			; Dest x.
	move.w	#23,d3			; Dest y.
	move.w	minfo_TX(a2),d4		; Width.
	move.w	minfo_TY(a2),d5		; Height.
	move.b	#$C0,d6			; Blitter minterm.
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Dest RPort.
	move.l	minfo_TilesPort(a2),a0
	move.l	vp_RasInfo(a0),a0
	move.l	ri_BitMap(a0),a0	; Source BitMap.
	CALLGRAF	BltBitMapRastPort	; Do the operation.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

StripInputs:
	move.l	a0,-(sp)
	move.l	wd_UserPort(a0),a1	; Get msg port.
	lea	MP_MSGLIST(a1),a1	; Get message list.
	move.l	LH_HEAD(a1),a1		; Get head message in list.
.WhileLoop:
	move.l	(sp),a0
	move.l	LN_SUCC(a1),-(sp)	; Get next ptr onto stack.
	cmpa.l	im_IDCMPWindow(a1),a0	; Is this for our window?
	bne.s	.NotOurs		; No, then don't free it!
	move.l	a1,-(sp)		; Store ptr.
	CALLEXEC	Remove		; Remove from the list.
	move.l	(sp)+,a1
	CALLEXEC	ReplyMsg	; Send message back to intuition.
.NotOurs:
	move.l	(sp)+,a1		; Get next message.
	cmpa.l	#0,a1			; Is it NULL?
	bne.s	.WhileLoop		; No, then loop.
	move.l	(sp)+,a0		; Remove window ptr.
	rts

StuffChar:
	move.b	d0,(a3)+	; Nothing spectacular here!
	rts

;   Another undocumented routine, this one sets the pens and drawing mode for
; the status window ready for the print routines...

SetPens:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Dest RPort.
	move.l	a1,-(sp)		; Save for later use.
	moveq	#1,d0
	CALLGRAF	SetAPen		; Set FGnd pen.
	move.l	(sp),a1
	moveq	#0,d0
	CALLGRAF	SetBPen		; Set BkGnd Pen.
	move.l	(sp)+,a1
	move.b	#RP_JAM2,d0
	CALLGRAF	SetDrMd		; Set Mode.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

BeginInput:				; For Update V2.01.
	movem.l	d0-7/a0-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	andi.w	#~MIFF_BDOWN,minfo_Flags(a2)	; We *must* clear this flag.
	move.l	minfo_StatusWindow(a2),a0
	move.w	#NOITEM<<5,d0		; Disable all menus...
	CALLINT		OffMenu
	move.l	minfo_StatusWindow(a2),a0
	move.w	#(1!(NOITEM<<5)),d0
	CALLINT		OffMenu
	move.l	minfo_StatusWindow(a2),a0
	move.w	#(2!(NOITEM<<5)),d0
	CALLINT		OffMenu
	move.l	minfo_StatusWindow(a2),a0
	move.w	#(3!(NOITEM<<5)),d0
	CALLINT		OffMenu
	move.l	minfo_StatusWindow(a2),a0
	move.w	#(4!(NOITEM<<5)),d0
	CALLINT		OffMenu
	CALLEXEC	Forbid		; Aaarrgh!!
	bsr	ClearPort		; Reply to all messages at our port.
	move.l	minfo_StatusWindow(a2),a0
	moveq	#0,d0
	move.l	d0,wd_UserPort(a0)	; Don't let intuition touch our port.
	CALLINT		ModifyIDCMP	; Turn off inputs for status window.
	move.w	minfo_Flags(a2),d7
	btst	#MIFB_MAP,d7		; Is there a map?
	beq.s	.NoInputs		; No, then were done.
	move.l	minfo_MapWindow(a2),a0	; Else...
	moveq	#0,d0
	move.l	d0,wd_UserPort(a0)	; Don't let intuition touch our port.
	CALLINT		ModifyIDCMP	; Turn off inputs for map window.
.NoInputs:
	CALLEXEC	Permit		; Ah!
	move.l	minfo_StatusWindow(a2),a0
	lea	BusyPointer,a1
	moveq	#22,d0
	moveq	#1,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Install BUSY! mouse ptr.
	btst	#MIFB_MAP,d7		; Flags from above.
	beq.s	.Exit
	move.l	minfo_MapWindow(a2),a0
	lea	BusyPointer,a1
	moveq	#22,d0
	moveq	#1,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Install BUSY! mouse ptr.
.Exit:
	movem.l	(sp)+,d0-7/a0-6		; Recall regs.
	rts

EndInput:					; For Update V2.01.
	movem.l	d0-7/a0-6,-(sp)			; Save regs.
	bsr	EnableMenus			; Enable appropriate menus.
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	move.l	#STATUSIDCMP,d0
	move.l	_InputPort,wd_UserPort(a0)	; Install port.
	CALLINT		ModifyIDCMP		; Enable inputs.
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0			; Is there a map?
	beq.s	.NoInputs			; No, then were done.
	move.l	minfo_MapWindow(a2),a0
	move.l	#MAPIDCMP,d0
	move.l	_InputPort,wd_UserPort(a0)	; Install port.
	CALLINT		ModifyIDCMP		; Enable inputs.
	move.l	minfo_MapWindow(a2),a0
	lea	BlankPointer,a1		; NULL sprite struct.
	moveq	#1,d0
	moveq	#16,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Set mouse pointer to a clear image.
.NoInputs:
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearPointer		; Clear BUSY! pointer.
	movem.l	(sp)+,d0-7/a0-6			; Recall regs.
	rts

ClearPort:				; For Update V2.01.
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
.ClearLoop:
	move.l	_InputPort,a0
	CALLEXEC	GetMsg		; Get next message.
	tst.l	d0
	beq.s	.Done			; Exit if there were no more.
	move.l	d0,a1
	CALLEXEC	ReplyMsg	; Else, reply to message.
	bra.s	.ClearLoop		; And loop...
.Done:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

EnableMenus:				; For Update V2.01.
	move.l	d2,-(sp)		; Save reg.
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	tst.l	wd_MenuStrip(a0)	; Is there a menu attatched?
	beq.s	.MenusGone		; No, then branch.
	CALLINT		ClearMenuStrip	; Else, detatch it.
.MenusGone:
	lea	DesignerMenus,a1	; Get ptr to 1st menu in list.
.MenuLoop:
	move.l	mu_FirstItem(a1),a0	; Get ptr to 1st menu item.
.ItemLoop:
	andi.w	#(~ITEMENABLED),mi_Flags(a0)
	tst.l	mi_NextItem(a0)
	beq.s	.NoMoreItems		; Dont loop if end of list.
	move.l	mi_NextItem(a0),a0	; Else, get next item.
	bra.s	.ItemLoop		; And loop...
.NoMoreItems:
	tst.l	mu_NextMenu(a1)
	beq.s	.NoMoreMenus		; Dont loop if no more menus.
	move.l	mu_NextMenu(a1),a1	; Else, get next menu.
	bra.s	.MenuLoop		; And loop...
.NoMoreMenus:
	move.w	#MENUENABLED,d0		; Enable all menu headers...
	move.w	d0,mu_Flags+ProjectMenu
	move.w	d0,mu_Flags+TilesMenu
	move.w	d0,mu_Flags+MapMenu
	move.w	d0,mu_Flags+BlocksMenu
	move.w	d0,mu_Flags+PrefsMenu
	move.w	minfo_Flags(a2),d1
	move.w	#ITEMENABLED,d0
	or.w	d0,mi_Flags+Project.2	; Enable default stage 1...
	or.w	d0,mi_Flags+Project.5
	or.w	d0,mi_Flags+Project.6
	or.w	d0,mi_Flags+Tiles.1
	or.w	d0,mi_Flags+Prefs.4
	btst	#MIFB_TILES,d1		; Are there tiles?
	beq	.AllDone		; No, branch.
	or.w	d0,mi_Flags+Tiles.2	; Else, enable stage 2...
	or.w	d0,mi_Flags+Tiles.3
	or.w	d0,mi_Flags+Tiles.4
	or.w	d0,mi_Flags+Project.1
	or.w	d0,mi_Flags+Map.2
	btst	#MIFB_MAP,d1		; Is there a map?
	beq	.AllDone		; No, branch.
	or.w	d0,mi_Flags+Prefs.5	; Else, enable stage 3...
	or.w	d0,mi_Flags+Project.3
	or.w	d0,mi_Flags+Project.4
	or.w	d0,mi_Flags+Map.1
	or.w	d0,mi_Flags+Map.3
	or.w	d0,mi_Flags+Map.4
	or.w	d0,mi_Flags+Map.5
	or.w	d0,mi_Flags+Blocks.1
	or.w	d0,mi_Flags+Blocks.2
	or.w	d0,mi_Flags+Blocks.5
	move.w	d0,d2
	andi.w	#~CHECKED,mi_Flags+Prefs.1
	btst	#MIFB_PAINT,d1		; Are we in paint mode?
	beq.s	.NoPaint		; No, then branch.
	ori.w	#CHECKED,d2		; Else, set this flag as well!
.NoPaint:
	or.w	d2,mi_Flags+Prefs.1	; Enable Paint mode switching.
	move.w	d0,d2
	andi.w	#~CHECKED,mi_Flags+Prefs.2
	btst	#MIFB_INCTILES,d1	; Are we to include tiles with maps?
	beq.s	.NoIncTiles		; No, then branch.
	ori.w	#CHECKED,d2		; Else, set this flag as well!
.NoIncTiles:
	or.w	d2,mi_Flags+Prefs.2	; Enable include tiles switching.
	move.w	d0,d2
	andi.w	#~CHECKED,mi_Flags+Prefs.3
	btst	#MIFB_ICON,d1		; Are we to save an icon with maps?
	beq.s	.NoIcons		; No, then branch.
	ori.w	#CHECKED,d2		; Else, set this flag as well!
.NoIcons:
	or.w	d2,mi_Flags+Prefs.3	; Enable icon switching.
	btst	#MIFB_BLOCK,d1		; Is there a block?
	beq.s	.AllDone		; No, branch.
	or.w	d0,mi_Flags+Blocks.3	; Else, enable stge 4...
	or.w	d0,mi_Flags+Blocks.4
.AllDone:
	move.l	minfo_StatusWindow(a2),a0
	lea	DesignerMenus,a1
	CALLINT		SetMenuStrip	; Attatch new menus.
	move.l	(sp)+,d2		; Restore reg.
	rts

CheckRes:		; Added for V2.14 Special version.  Disables Hires if
			; there are >16 colours, else enables it.

	move.l	_MapInfoBase,a0
	lea	Map.3.2,a1		; Get Hires menu item.
	move.w	minfo_Depth(a0),d0	; Is there >4 planes?..
	cmpi.w	#4,d0
	ble.s	.Enable			; No, enable hires option.
	andi.w	#(~ITEMENABLED),mi_Flags(a1)	; Else, disable it.
	bra.s	.Exit
.Enable:
	ori.w	#ITEMENABLED,mi_Flags(a1)
.Exit:
	rts

CheckSizes:		; Added for V2.14 Special version.  Disables tile
			; sizes which are not possible.  Eg if tile page is
			; very small.

	move.l	_MapInfoBase,a0
	move.w	minfo_TRasX(a0),d0	; Get raster width.
	cmp.w	#32,d0			; Is raster small?
	bge.s	.XOkay			; No, then any size is possible.
	lea	Tiles.3.1,a1		; Else, disable large x values...
	andi.w	#(~ITEMENABLED),mi_Flags(a1)	; Disable 32x32.
	lea	Tiles.3.2,a1
	andi.w	#(~ITEMENABLED),mi_Flags(a1)	; Disable 32x16.
	move.w	#16,minfo_TX(a0)	; Force 16 width.
	bra.s	.CheckY
.XOkay:
	lea	Tiles.3.1,a1			; Enable large x values...
	ori.w	#ITEMENABLED,mi_Flags(a1)	; Enable 32x32.
	lea	Tiles.3.2,a1
	ori.w	#ITEMENABLED,mi_Flags(a1)	; Enable 32x16.
.CheckY:
	move.w	minfo_TRasY(a0),d0	; Get raster Height.
	cmp.w	#32,d0			; Is raster small?
	bge.s	.YOkay			; No, then any size is possible.
	lea	Tiles.3.1,a1		; Else, disable large y values...
	andi.w	#(~ITEMENABLED),mi_Flags(a1)	; Disable 32x32.
	lea	Tiles.3.3,a1
	andi.w	#(~ITEMENABLED),mi_Flags(a1)	; Disable 16x32.
	move.w	#16,minfo_TY(a0)	; Force 16 height.
	bra.s	.AllDone
.YOkay:
	lea	Tiles.3.3,a1			; Enable large y values...
	ori.w	#ITEMENABLED,mi_Flags(a1)	; Enable 16x32.
.AllDone:
	rts


	section	ProgStuff,data

;   First the base info for the libs and the editors main data structure...

_MapInfoBase	dc.l	0
_IntuitionBase	dc.l	0
_GfxBase	dc.l	0
_LayersBase	dc.l	0
_IconBase	dc.l	0
_InputPort	dc.l	0
OldErrorPtr	dc.l	0	; Pointer to our old WindowPtr for errors.
OldCDir		dc.l	0	; Our initial directory.
SDFlg		dc.w	0	; If we changed our initial directory with
				;  CurrentDir(); this flag =-1.
EditHeight	dc.l	0	; Used to change between PAL and NTSC.

;   This BitMap is initialised and setup to point to the "FancyGfx" fot the
; status display...

StatusBitMap	ds.b	bm_SIZEOF

;   This new screen is for the status area at the top of the screen, it also
; ensures that topaz.8 is used...

StatusNewScreen:
	dc.w	0,0,640,67,4
	dc.b	1,2
	dc.w	V_HIRES,CUSTOMSCREEN
	dc.l	StatusFont
	dc.l	0,0,0

;   This window is opened in the above screen, it is a SUPER_BITMAP window,
; which implements the StatusBitMap, & therefore the "FancyGfx"...

StatusNewWindow:
	dc.w	0,0,640,67
	dc.b	-1,-1
	dc.l	STATUSIDCMP,(SUPER_BITMAP!BORDERLESS!REPORTMOUSE!ACTIVATE)
	dc.l	0,0,0
SWinScreen:			; Address of screen to open window in.
	dc.l	0,StatusBitMap
	dc.w	0,0,0,0,CUSTOMSCREEN

;   This Text Attr is linked to the StatusNewScreen, and makes sure that we
; are always using the topaz.8 font...

StatusFont:
	dc.l	FontName
	dc.w	8
	dc.b	FS_NORMAL,(FPF_DESIGNED!FPF_ROMFONT)

;   This is an IORequest structure, this is used with the console.device,
; which is used to convert raw keys into something better...

ConRequest:
	dc.l	0,0		; NULL linkage.
	dc.b	NT_MESSAGE	; We are!
	dc.b	0		; No special priority.
	dc.l	ConReqName	; Our name.
	dc.l	0		; Reply port.
	dc.w	68		; Size of message + Request block.
	dc.l	0,0		; Device & unit.
	dc.w	0		; Command.
	dc.b	0,0		; Flags & error.
	dc.l	0,0,0,0		; Actual, length, data & offset.

;   This is an input event structure which is used to re-create the original
; event before intuition got to it.  This is used in converting RAWKEYS into
; the proper international key for shortcuts...

ConInput:
	ds.b	ie_SIZEOF

;   This is a copy of the message for the current input being handled, the
; Class and Code fields have their own labels so that it is easier to extract
; this data...

CurrInput:
	ds.l	5
InputClass:
	dc.l	0
InputCode:
	ds.l	7

;   This is the gadget structure for the Mini-Map fast mover gadget, it is a
; proportional gadget which allows the user to move around their map by
; moving the gadgets button around the container...

MiniMapGadget:
	dc.l	0
	dc.w	435,18,197,42
	dc.w	GADGHCOMP,RELVERIFY,PROPGADGET
	dc.l	MiniMapKnob,0,0,0,MiniMapInfo
	dc.w	0
	dc.l	0
MiniMapInfo:		; The associated PropInfo struct...
	dc.w	(AUTOKNOB!FREEHORIZ!FREEVERT!PROPBORDERLESS)
	dc.w	0,0
	dc.w	MAXBODY,MAXBODY
	dc.w	0,0,0,0,0,0

;   Plus the image structure for the auto-knob...

MiniMapKnob:
	ds.b	ig_SIZEOF

;   This buffer is used as a work space for text printing and also to store
; temporary filespecs...

ASCIITemp:
	ds.w	76

;   These are the format strings for converting WORD integers, and X*Y sizes
; to ASCII format...

IntegerFormat:
	dc.b	"%5d",0
	even
SizeFormat:
	dc.b	"%-2.2dx%2.2d",0
	even

;   The following is the ASCII text for things that get displayed in the
; status area...

BlockStr:
	dc.b	"BLOCK"
	even
PaintStr:
	dc.b	"PAINT"
	even
BlankStr:
	dc.b	"     "
	even
HiResStr:
	dc.b	"HiRes"
	even
LoResStr:
	dc.b	"LoRes"
	even

;   The rest of this section contains name specifications for libraries,
; fonts etc...

GfxLib	GRAFNAME
	even
IntLib	INTNAME
	even
IcnLib	ICONNAME
	even
LayLib	dc.b	"layers.library",0
	even
FontName:
	dc.b	"topaz.font",0
	even
ConDev:
	dc.b	"console.device",0
	even
ConReqName:
	dc.b	"console io request",0
	even

	section	ChipStuff,data_c

;  Include status display graphics...

FancyGfx:
	incbin	MapDesignerV2.0:GfxData/StatusGfx.raw
	even

;   This is the "BUSY!" pointer for when inputs are off...

BusyPointer:
	dc.w	0,0
	dc.w	%0001111100000000,%0001111100000000
	dc.w	%0011111111100000,%0010000000100000
	dc.w	%0011111111111000,%0010000000001000
	dc.w	%0011111111111000,%0010111100001000
	dc.w	%0111111111111000,%0100001000001000
	dc.w	%0111111111111100,%0100010000000100
	dc.w	%0111111111111110,%0100100000000010
	dc.w	%1111111111111110,%1001111001111010
	dc.w	%1111111111111110,%1000000000010010
	dc.w	%1111111111111110,%1000000000100010
	dc.w	%1111111111111110,%1000000001000010
	dc.w	%0111111111111110,%0100000011110010
	dc.w	%0001111111111100,%0001000000000100
	dc.w	%0000011111111100,%0000010000000100
	dc.w	%0000001111110000,%0000001000010000
	dc.w	%0000000111000000,%0000000101000000
	dc.w	%0000000000110000,%0000000000110000
	dc.w	%0000001111111000,%0000001000001000
	dc.w	%0000011111000000,%0000010001000000
	dc.w	%0000000000110000,%0000000000110000
	dc.w	%0000000000111000,%0000000000101000
	dc.w	%0000000000010000,%0000000000010000
	dc.w	0,0
	end
