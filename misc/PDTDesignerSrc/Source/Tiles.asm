	opt	c+,d+,l+,o+,i+
	incdir	sys:include/
	include	exec/exec_lib.i
	include	exec/exec.i
	include	intuition/intuition_lib.i
	include	intuition/intuition.i
	include	libraries/dos_lib.i
	include	libraries/dos.i
	include	graphics/graphics_lib.i
	include	graphics/layers_lib.i

	include	MapDesignerV2.0:Source/MapDesignerV2.i	; Custom include!
	include	MapDesignerV2.0:Source/iff.i

	output	MapDesignerV2.0:Modules/TilesModule.o

;   This file contains the following routines...

	xdef	LoadTiles,OpenMapScreen,CheckTileRefs,CheckSaved
	xdef	InstallColours,CheckBounds,SaveIFFTiles
	xdef	SaveRawTiles,WritePlanes,WriteColours,PickTile,ShowTiles
	xdef	HideTiles,GetTile,DivideRaster,TScrollUp,TScrollDown
	xdef	TScrollLeft,TScrollRight,NextTile,PreviousTile
	xdef	Tiles16x16,Tiles16x32,Tiles32x16,Tiles32x32,NewTileSize
	xdef	CheckPos,MapNewScreen,MapNewWindow

;   It also contains the following global data...

	xdef	BlankPointer,ContinueText,CancelText

;   This file makes the following external references...

	xref	_FileRequester,_LoadILBM,_SaveILBM,FreeTiles
	xref	DisplayStatus,CloseMapScreen,DrawMapSection,BlockCleanup
	xref	MapCleanup,ExtractData,DisplayTileStatus
	xref	_MapInfoBase,_IntuitionBase,_GfxBase,_DOSBase,ASCIITemp
	xref	_InputPort,MiniMapGadget,InputClass,InputCode,CheckSizes
	xref	CurrInput,_LayersBase,DialogueBox,EditHeight,CheckRes

	xref	ReadOpenFail,WriteOpenFail,ReadDataFail,WriteDataFail
	xref	NoMemFail,NotMapFail,NoTilesFail,NotIFFFail,NotILBMFail
	xref	BadIFFFail,OpenWBFail,CloseWBFail,IconFail,TileScreenFail
	xref	FileReqFail,EditScreenFail,PaletteReqFail,AboutText
	xref	Tiles.3.1,Tiles.3.2,Tiles.3.3


;   This file contains the functions for the tiles menu, and all associated
; data and sub-routines...

	section	Program,code
LoadTiles:
	bsr	CheckSaved		; Is the map saved?
	tst.l	d0
	beq	.Exit			; Exit if user canceled.
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusScreen(a2),a0	; Screen for file requester.
	lea	LoadTilesTitle,a1	; Title string.
	lea	IFFFileSpec,a2		; Store for filespec.
	bsr	_FileRequester		; Put up requester.
	tst.l	d0
	bmi	.ReqFail
	beq	.Exit			; Exit, if we were canceled.
	lea	IFFFileSpec,a0		; Filespec.
	move.l	#0,a1			; Create brand new viewport.
	bsr	_LoadILBM		; Load in the IFF file.
	move.l	d0,-(sp)		; Was load a success?
	bmi	.LoadFail		; No, take failure path.
	bsr	FreeTiles		; Else, free any old tiles.
	move.l	_MapInfoBase,a2
	ori.w	#(MIFF_TILES!MIFF_CHANGED),minfo_Flags(a2)  ; Set tles & chgd.
	move.l	(sp)+,minfo_TilesPort(a2)	; Install tiles ViewPort.
	clr.w	minfo_CTile(a2)			; Set CTile to 0.
	move.l	minfo_TilesPort(a2),a0
	move.l	EditHeight,d0
	add.w	#64,d0
	cmp.w	vp_DHeight(a0),d0	; Make sure we'll see whole screen...
	bge.s	.HeightOkay
	move.w	d0,vp_DHeight(a0)
.HeightOkay:
	move.l	vp_RasInfo(a0),a0
	move.l	ri_BitMap(a0),a0		; Get tiles' BitMap.
	move.w	bm_Rows(a0),minfo_TRasY(a2)	; Set MapInfo tile stuff...
	move.w	bm_BytesPerRow(a0),d0
	lsl.w	#3,d0			; Convert bits to bytes.
	move.w	d0,minfo_TRasX(a2)
	move.b	bm_Depth(a0),d0
	ext.w	d0			; Turn byte into a WORD.
	move.w	d0,minfo_Depth(a2)
	moveq	#0,d0			; Remove old data.
	move.w	minfo_TRasX(a2),d0	; Calculate MTile...
	divu.w	minfo_TX(a2),d0
	moveq	#0,d1
	move.w	minfo_TRasY(a2),d1
	divu.w	minfo_TY(a2),d1
	mulu.w	d1,d0
	subq.w	#1,d0
	move.w	d0,minfo_MTile(a2)	; = ((( TRasX/Tx ) * ( TRasY/Ty ))-1)
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_MAP,d2		; Is map data present?
	beq.s	.Exit			; No, then setup new menus.
	bsr	OpenMapScreen		; Else, re-open map screen.
	tst.l	d0			; Was open a success?
	beq.s	.Exit			; No, take failure path.
	bsr	CheckTileRefs		; Check tile numbers are valid.
	bra.s	.Exit
.LoadFail:
	move.l	(sp)+,d0		; Remove value from stack.
	cmpi.l	#IFF_NO_MEMORY,d0	; Find and display error...
	bne.s	.TryFile
	bsr	NoMemFail
	bra.s	.Exit
.TryFile:
	cmpi.l	#IFF_NO_FILE,d0
	bne.s	.TryIFF
	bsr	ReadOpenFail
	bra.s	.Exit
.TryIFF:
	cmpi.l	#IFF_NOT_IFF,d0
	bne.s	.TryILBM
	bsr	NotIFFFail
	bra.s	.Exit
.TryILBM:
	cmpi.l	#IFF_NOT_ILBM,d0
	bne.s	.TryForm
	bsr	NotILBMFail
	bra.s	.Exit
.TryForm:
	cmpi.l	#IFF_BAD_FORM,d0
	bne.s	.GeneralFail
	bsr	BadIFFFail
	bra.s	.Exit
.GeneralFail:
	bsr	ReadDataFail
	bra.s	.Exit
.ReqFail:
	bsr	FileReqFail		; Display error.
.Exit:
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a3
	move.l	wd_RPort(a3),a3		; Get status RastPort.
	move.l	a3,a1
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	a3,a1
	move.w	#14,d0			; Setup Top-Left co-ords...
	move.w	#23,d1
	move.w	#45,d2			; Setup Bottom-Right co-ords...
	move.w	#54,d3
	CALLGRAF	RectFill	; Clear CTile Image.
	bsr	CheckSizes		; Make sure we only use valid sizes.
	bsr	CheckRes		; Make sure screen res is valid.
	bsr	DisplayStatus		; Update display.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow	; Activate status window.
	rts

OpenMapScreen:
	movem.l	d2-7/a2-6,-(sp)		; Save values.
	bsr	CloseMapScreen		; Close any current display.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2	; Get flags status.
	btst	#MIFB_MAP,d2		; Is map flag set?
	beq	.Failure		; No, then take failure path.
	lea	MapNewScreen,a0
	lea	MapNewWindow,a3
	move.w	minfo_MRasX(a2),ns_Width(a0)	; Set screen width.
	move.w	minfo_MRasX(a2),nw_Width(a3)	; Set window width.
	move.w	minfo_Depth(a2),ns_Depth(a0)	; Set display depth.
	move.l	minfo_TilesPort(a2),a1
	move.w	vp_Modes(a1),d0		; Get tiles modes.
	andi.w	#$0880,d0		; Mask out all unwanted bits.
	or.w	minfo_Res(a2),d0	; Install users res setting.
	move.w	d0,ns_ViewModes(a0)	; Set modes for display.
	CALLINT		OpenScreen
	move.l	d0,minfo_MapScreen(a2)	; Install ptr.
	beq	.Failure		; Branch if there was no screen.
	move.l	a3,a0			; NewWindow ptr from above.
	move.l	d0,nw_Screen(a0)	; Install destination screen.
	CALLINT		OpenWindow
	move.l	d0,minfo_MapWindow(a2)	; Install ptr.
	beq.s	.CloseFailure		; Branch on failure.
	move.l	d0,a3
	move.l	_InputPort,wd_UserPort(a3)	; Setup input port.
	move.l	a3,a0
	move.l	#MAPIDCMP,d0
	CALLINT		ModifyIDCMP	; Set what inputs we want.
	move.l	a3,a0
	lea	BlankPointer,a1		; NULL sprite struct.
	moveq	#1,d0
	moveq	#16,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Set mouse pointer to a clear image.
	move.l	minfo_MapScreen(a2),a0
	lea	sc_ViewPort(a0),a0	; a0 = Destination ViewPort.
	bsr	InstallColours		; Install correct colours.
	move.l	minfo_StatusWindow(a2),a0
	lea	MiniMapGadget,a1
	moveq	#-1,d0
	CALLINT		AddGadget	; Add gadget to status display.
	bsr	DrawMapSection		; Display map.
	move.l	minfo_MapScreen(a2),a0
	CALLINT		ScreenToFront	; Display tiles screen.
	moveq	#1,d0			; Success!!
	bra.s	.Exit
.CloseFailure:
	move.l	minfo_MapScreen(a2),a0
	CALLINT		CloseScreen	; Close the screen on failure.
.Failure:
	bsr	BlockCleanup		; Remove all block data.
	bsr	MapCleanup		; Remove all map data.
	bsr	EditScreenFail		; Display message.
	moveq	#0,d0			; Failure code.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall registers.
	rts

CheckTileRefs:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_MTile(a2),d2
	cmp.w	minfo_CTile(a2),d2	; Check CTile value.
	bge.s	.CTileOK		; Branch if it's OK.
	move.w	d2,minfo_CTile(a2)	; Else, make it OK.
.CTileOK:
	move.w	minfo_Flags(a2),d2	; Get flags status.
	btst	#MIFB_MAP,d2		; Is there a map defined.
	beq.s	.CheckBlock		; No, then check for a block.
	move.l	minfo_Map(a2),a0
	move.w	minfo_MX(a2),d0		; Calculate size...
	mulu.w	minfo_MY(a2),d0
	bsr	CheckBounds		; Check map array
.CheckBlock:
	btst	#MIFB_BLOCK,d2		; d2 = flags from above.
	beq.s	.Exit			; Exit if there is no block.
	move.l	minfo_Block(a2),a0
	move.w	minfo_BX(a2),d0		; Calculate size...
	mulu.w	minfo_BY(a2),d0
	bsr	CheckBounds		; Check block array
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall registers.
	rts

CheckSaved:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_CHANGED,d0	; Has map changed since last save?
	beq.s	.Continue		; No, tell caller to continue.
	btst	#MIFB_MAP,d0
	beq.s	.Continue		; Don't ask if there's no map.
	bsr	CheckSavedReq		; Ask user if they want to continue.
	move.l	d0,-(sp)
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit
	move.l	minfo_MapScreen(a2),a0
	CALLINT		ScreenToFront	; Put display back correctly.
	bra.s	.Exit			; Return.
.Continue:
	move.l	#1,-(sp)
.Exit:
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow	; Activate status window.
	move.l	(sp)+,d0		; Get return value.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

InstallColours:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	a0,a4			; Destination ViewPort input.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesPort(a2),a5
	move.l	vp_ColorMap(a5),a5	; a5 = Source ColorMap.
	moveq	#0,d7			; d7 = current colour index.
.InstallLoop:
	move.l	d7,d0
	move.l	a5,a0
	CALLGRAF	GetRGB4		; Get colour value.
	tst.w	d0
	bmi.s	.Exit			; Return if no more entries.
	move.w	d0,d1
	lsr.w	#8,d1
	andi.w	#$f,d1		; Extract RED value.
	move.w	d0,d2
	lsr.w	#4,d2
	andi.w	#$f,d2		; Extract BLUE value.
	move.w	d0,d3
	andi.w	#$f,d3		; Extract GREEN value.
	move.l	d7,d0
	move.l	a4,a0
	CALLGRAF	SetRGB4		; Set entry in Maps ViewPort.
	addq.w	#1,d7			; Move onto next colour.
	bra.s	.InstallLoop		; Repeat for all entries...
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

CheckBounds:
	move.l	_MapInfoBase,a2
	move.w	minfo_MTile(a2),d1	; Upper bound.
.CheckLoop:
	cmp.w	(a0)+,d1		; Check tile value.
	bge.s	.ThatsOK		; Branch if tile is valid.
	move.w	d1,-2(a0)		; Else, make tile valid.
.ThatsOK:
	subq.l	#1,d0
	bne.s	.CheckLoop		; Loop for whole array.
	rts

SaveIFFTiles:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are there tiles?
	beq.s	.Exit			; No, then we can't save them!!
	move.l	minfo_StatusScreen(a2),a0	; Screen for file requester.
	lea	SaveIFFTilesTitle,a1	; Title string.
	lea	IFFFileSpec,a2		; Store for filespec.
	bsr	_FileRequester		; Put up requester.
	tst.l	d0
	bmi.s	.ReqFail
	beq.s	.Exit			; Exit if user canceled.
	lea	IFFFileSpec,a0
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesPort(a2),a1
	bsr	_SaveILBM		; Save the tiles ViewPort as ILBM.
	tst.l	d0			; Did save fail?
	beq.s	.Exit			; No, then exit.
	cmpi.l	#IFF_NO_MEMORY,d0	; Find and display error...
	bne.s	.TryFile
	bsr	NoMemFail
	bra.s	.Exit
.TryFile:
	cmpi.l	#IFF_NO_FILE,d0
	bne.s	.GeneralFail
	bsr	WriteOpenFail
	bra.s	.Exit
.GeneralFail:
	bsr	WriteDataFail
	bra.s	.Exit
.ReqFail:
	bsr	FileReqFail		; Display error.
.Exit:
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow	; Activate status window.
	rts

SaveRawTiles:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are there tiles?
	beq.s	.Exit			; No, then we can't save them!!
	move.l	minfo_StatusScreen(a2),a0	; Screen for file requester.
	lea	SaveRawTilesTitle,a1	; Title string.
	lea	RawTSpec,a2		; Store for filespec.
	bsr	_FileRequester		; Put up requester.
	tst.l	d0
	bmi.s	.ReqFailed
	beq.s	.Exit			; Exit if user canceled.
	move.l	#RawTSpec,d1
	move.l	#MODE_NEWFILE,d2
	CALLDOS		Open		; Attempt to open new file.
	move.l	d0,d5			; Store file handle.
	beq.s	.Failure		; Exit if open failed.
	bsr.s	WritePlanes		; Write out planes & colours.
	move.l	d0,d2
	move.l	d5,d1
	CALLDOS		Close		; Close disk file
	tst.l	d2			; Did writes fail?
	bne.s	.Exit			; No, then exit.
	move.l	#RawTSpec,d1
	CALLDOS		DeleteFile	; Delete partial file.
	bra.s	.Exit
.Failure:
	bsr	WriteOpenFail		; Put up failure message.
	bra.s	.Exit
.ReqFailed:
	bsr	FileReqFail
.Exit:
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow	; Activate status window.
	rts

WritePlanes:
	movem.l	d2-7/a2-6,-(sp)		; Save registers.
	move.l	d0,d7			; Save file handle.
	moveq	#0,d6			; d6 = Plane indexer.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesPort(a2),a3
	move.l	vp_RasInfo(a3),a3
	move.l	ri_BitMap(a3),a3	; Get source BitMap.
	move.w	bm_BytesPerRow(a3),d5
	mulu.w	bm_Rows(a3),d5		; Calculate size of 1 BitPlane.
	move.b	bm_Depth(a3),d4
	ext.w	d4
	subq.w	#1,d4			; Setup dbra loop
.WriteLoop:
	move.l	d7,d1
	move.l	bm_Planes(a3,d6),d2	; Get source buffer.
	move.l	d5,d3
	CALLDOS		Write		; Write out plane
	cmpi.l	#-1,d0
	beq.s	.WriteFail		; Exit if write fails.
	addq.w	#4,d6			; Move onto next plane.
	dbra	d4,.WriteLoop		; Loop for depth...
	move.l	d7,d0
	bsr.s	WriteColours		; Write color data to file.
	tst.l	d0
	beq.s	.WriteFail		; Exit if routine failed.
	moveq	#1,d0			; Else, Success!!
	bra.s	.Exit
.WriteFail:
	bsr	WriteDataFail
	moveq	#0,d0			; Set Failure return.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

WriteColours:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d7			; Save dest. file handle.
	link	a5,#-64			; Allocate mem for color table.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesPort(a2),a3
	move.l	vp_ColorMap(a3),a3	; a3 = source color map.
	move.w	minfo_Depth(a2),d0
	moveq	#1,d3
	lsl.w	d0,d3			; Calculate number of cols.
	cmpi.w	#32,d3			; Only 32 colour regs max.
	ble.s	.ColsOK			; Branch if <=32.
	move.w	#32,d3			; Else, d6 = 32.
.ColsOK:
	moveq	#0,d5			; Colour indexer.
	move.w	d3,d6			; Loop control.
	subq.w	#1,d6			; dbra adjustment.
	lea	-64(a5),a4		; Get start of table.
	move.l	a4,d2			; Setup for Write.
.ColsLoop:
	move.l	a3,a0
	move.l	d5,d0
	CALLGRAF	GetRGB4		; Get color value.
	move.w	d0,(a4)+		; Write it into our table.
	addq.w	#1,d5
	dbra	d6,.ColsLoop		; Get all colours...
	lsl.l	#1,d3			; Turn WORDs to bytes.
	move.l	d7,d1			; FileHandle, all others set above.
	CALLDOS		Write		; Write table to file.
	cmpi.l	#-1,d0
	beq.s	.Failed			; Exit if we failed.
	moveq	#1,d0			; Else, set success return.
	bra.s	.Exit
.Failed:
	moveq	#0,d0			; Failure return.
.Exit:
	unlk	a5			; Free stack frame.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

PickTile:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are there tiles?
	beq.s	.Exit			; No, then we can't pick one!
	bsr.s	ShowTiles		; Put up tile selection screen.
	tst.l	d0			; Was that a success?
	beq.s	.Exit			; No, take failure path.
	bsr	DivideRaster
	move.l	minfo_TilesScreen(a2),a0
	CALLINT		ScreenToFront	; Display tiles screen.
	bsr	GetTile			; Wait for user to select a tile.
	cmp.w	minfo_MTile(a2),d0	; Is tile selected valid?
	ble.s	.TileOK			; Yes, then install it.
	move.w	minfo_MTile(a2),d0	; Set to maximaum tile number.
.TileOK:
	move.w	d0,minfo_CTile(a2)	; Install new tile number.
	andi.w	#~MIFF_MODE,minfo_Flags(a2)	; Put editor into tiles mode.
	bsr	DisplayStatus		; Update status display.
	move.l	minfo_TilesScreen(a2),a0
	CALLINT		ScreenToBack	; Hide tiles screen.
	bsr	DivideRaster
	bsr	HideTiles		; Remove tiles from display
.Exit:
	rts

ShowTiles:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesPort(a2),a3	; Where to get our info.
	lea	TilesNewScreen,a0
	move.w	vp_DWidth(a3),ns_Width(a0)	; Set screen width.
	move.w	vp_DHeight(a3),ns_Height(a0)	; Set screen height.
	move.w	vp_Modes(a3),ns_ViewModes(a0)	; Set screen modes.
	move.l	vp_RasInfo(a3),a3
	move.l	ri_BitMap(a3),a3
	move.b	bm_Depth(a3),d0
	ext.w	d0
	move.w	d0,ns_Depth(a0)			; Set screen depth.
	lea	TilesNewWindow,a4
	move.w	ns_Width(a0),nw_Width(a4)	; Set window width.
	move.w	ns_Height(a0),nw_Height(a4)	; Set window height.
	move.l	a3,nw_BitMap(a4)		; Install SUPER_BITMAP.
	CALLINT		OpenScreen
	move.l	d0,minfo_TilesScreen(a2)
	beq.s	.Failure			; Exit if open failed.
	move.l	a4,a0				; Ptr to newWindow.
	move.l	d0,nw_Screen(a0)		; Install destination screen.
	CALLINT		OpenWindow
	move.l	d0,minfo_TilesWindow(a2)
	beq.s	.CloseFailure			; Cleanup & exit on failure.
	move.l	minfo_TilesScreen(a2),a0
	lea	sc_ViewPort(a0),a0	; a0 = Destination ViewPort.
	bsr	InstallColours		; Install correct colours.
	moveq	#1,d0			; Success!
	bra.s	.Exit
.CloseFailure:
	move.l	minfo_TilesScreen(a2),a0
	CALLINT		CloseScreen	; Close the screen.
.Failure:
	bsr	TileScreenFail
	moveq	#0,d0			; Set failed return code.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

HideTiles:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesWindow(a2),a0
	CALLINT		CloseWindow
	move.l	minfo_TilesScreen(a2),a0
	CALLINT		CloseScreen
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow	; Activate status window.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

GetTile:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesWindow(a2),a0
	CALLINT		ActivateWindow	; Make sure window is active!
	move.l	#TILESIDCMP,d0
	move.l	minfo_TilesWindow(a2),a0
	CALLINT		ModifyIDCMP	; Setup IDCMP for tiles.
.InputLoop:
	move.l	minfo_TilesWindow(a2),a3
	move.l	wd_UserPort(a3),a0
	CALLEXEC	WaitPort	; Wait for users input.
	move.l	wd_UserPort(a3),a0
	CALLEXEC	GetMsg		; Get message from port.
	tst.l	d0
	beq.s	.InputLoop		; Loop if there was no message...
	move.l	d0,a0
	bsr	ExtractData		; Make copy of input.
	cmpi.l	#RAWKEY,InputClass	; Is this a key stroke?
	bne.s	.TryMouse		; No, then see if it was the mouse.
	move.w	InputCode,d0		; Get Raw Key code.
	cmpi.w	#$4c,d0			; Was key pressed Up Arrow?
	bne.s	.TryDown		; No, try Down Arrow.
	bsr	TScrollUp		; Else, scroll raster.
	bra.s	.InputLoop		; And loop...
.TryDown:
	cmpi.w	#$4d,d0			; Was key pressed Down Arrow?
	bne.s	.TryLeft		; No, try Left Arrow.
	bsr	TScrollDown		; Else, scroll raster.
	bra.s	.InputLoop		; And loop...
.TryLeft:
	cmpi.w	#$4f,d0			; Was key pressed Left Arrow?
	bne.s	.TryRight		; No, try Right Arrow.
	bsr	TScrollLeft		; Else, scroll raster.
	bra.s	.InputLoop		; And loop...
.TryRight:
	cmpi.w	#$4e,d0			; Was key pressed Right Arrow?
	bne.s	.InputLoop		; No, then loop...
	bsr	TScrollRight		; Else, scroll raster.
	bra.s	.InputLoop		; And loop...
.TryMouse:
	cmpi.l	#MOUSEBUTTONS,InputClass	; Was it a mouse button msg?
	bne.s	.InputLoop		; No, then we're not interested.
	cmpi.w	#SELECTDOWN,InputCode	; Did the user select a tile?
	bne.s	.InputLoop		; No, then we're not interested.
	moveq	#0,d0
	move.l	a3,a0			; a3 still = window from above.
	CALLINT		ModifyIDCMP	; Disable input port.
	lea	CurrInput,a0
	move.l	minfo_TilesWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get Layer for scroll offsets...
	move.l	rp_Layer(a1),a1
	moveq	#0,d1
	move.w	minfo_TRasX(a2),d1
	divu.w	minfo_TX(a2),d1
	moveq	#0,d0
	move.w	im_MouseY(a0),d0
	add.w	lr_Scroll_Y(a1),d0	; Get y co-ord into tiles raster.
	divu.w	minfo_TY(a2),d0		; Convert y co-ord into tile number.
	mulu.w	d1,d0
	moveq	#0,d1
	move.w	im_MouseX(a0),d1
	add.w	lr_Scroll_X(a1),d1	; Get x co-ord into tiles raster.
	divu.w	minfo_TX(a2),d1		; Convert x co-ord into tile number.
	add.w	d1,d0			; d0 = Possible CTile.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

DivideRaster:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesWindow(a2),a3
	move.l	wd_RPort(a3),a3		; Get RastPort to draw into.
	move.l	a3,a1
	moveq	#RP_COMPLEMENT,d0
	CALLGRAF	SetDrMd		; Set mode for easy draw / removal.
	moveq	#0,d7			; X co-ord.
	moveq	#0,d6
	move.w	minfo_TRasX(a2),d6
	divu.w	minfo_TX(a2),d6		; a6 = number of lines to draw.
	subq.w	#1,d6			; dbra	adjustment.
.DrawLoopX:
	moveq	#0,d1
	move.w	d7,d0
	move.l	a3,a1
	CALLGRAF	Move		; Move gfx cursor.
	move.l	a3,a1
	move.w	d7,d0
	move.w	minfo_TRasY(a2),d1
	CALLGRAF	Draw		; Draw next line.
	add.w	minfo_TX(a2),d7		; Advance x co-ord.
	dbra	d6,.DrawLoopX
	moveq	#0,d7			; Y co-ord.
	moveq	#0,d6
	move.w	minfo_TRasY(a2),d6
	divu.w	minfo_TY(a2),d6		; a6 = number of lines to draw.
	subq.w	#1,d6			; dbra	adjustment.
.DrawLoopY:
	moveq	#0,d0
	move.w	d7,d1
	move.l	a3,a1
	CALLGRAF	Move		; Move gfx cursor.
	move.l	a3,a1
	move.w	d7,d1
	move.w	minfo_TRasX(a2),d0
	CALLGRAF	Draw		; Draw next line.
	add.w	minfo_TY(a2),d7		; Advance x co-ord.
	dbra	d6,.DrawLoopY
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

TScrollUp:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get Layer to scroll...
	move.l	rp_Layer(a1),a1
	move.w	lr_Scroll_Y(a1),d0
	beq.s	.NoScroll		; Don't bother if we're right up.
	move.l	#0,a0
	move.w	minfo_TY(a2),d1
	ext.l	d1
	neg.l	d1			; We want to go ^ thataway!
	moveq	#0,d0
	move.l	_LayersBase,a6
	jsr	_LVOScrollLayer(a6)	; Scroll the layer.
.NoScroll:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

TScrollLeft:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get Layer to scroll...
	move.l	rp_Layer(a1),a1
	move.w	lr_Scroll_X(a1),d0
	beq.s	.NoScroll		; Don't bother if we're fully left.
	move.l	#0,a0
	move.w	minfo_TX(a2),d0
	ext.l	d0
	neg.l	d0			; We want to go <- thataway!
	moveq	#0,d1
	move.l	_LayersBase,a6
	jsr	_LVOScrollLayer(a6)	; Scroll the layer.
.NoScroll:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

TScrollDown:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_TRasY(a2),d0
	move.l	minfo_TilesScreen(a2),a3
	lea	sc_ViewPort(a3),a3
	sub.w	vp_DHeight(a3),d0	; Calculate ( TRasY - VPort.Height ).
	move.l	minfo_TilesWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get layer to scroll...
	move.l	rp_Layer(a1),a1
	cmp.w	lr_Scroll_Y(a1),d0
	ble.s	.NoScroll		; Don't scroll if we're fully down.
	move.l	#0,a0
	moveq	#0,d0
	move.w	minfo_TY(a2),d1		; Scroll down.
	ext.l	d1
	move.l	_LayersBase,a6
	jsr	_LVOScrollLayer(a6)	; Scroll the layer.
.NoScroll:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

TScrollRight:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_TRasX(a2),d0
	move.l	minfo_TilesScreen(a2),a3
	lea	sc_ViewPort(a3),a3
	sub.w	vp_DWidth(a3),d0	; Calculate ( TRasX - VPort.Width ).
	move.l	minfo_TilesWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get layer to scroll...
	move.l	rp_Layer(a1),a1
	cmp.w	lr_Scroll_X(a1),d0
	ble.s	.NoScroll		; Don't scroll if we're fully right.
	move.l	#0,a0
	moveq	#0,d1
	move.w	minfo_TX(a2),d0		; Scroll right.
	ext.l	d0
	move.l	_LayersBase,a6
	jsr	_LVOScrollLayer(a6)	; Scroll the layer.
.NoScroll:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

NextTile:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are there tiles?
	beq.s	.NoChange		; No, then we don't change anything!
	move.w	minfo_CTile(a2),d0
	cmp.w	minfo_MTile(a2),d0	; Check Current Tile value.
	bge.s	.NoChange		; Don't change if were at Max.
	addq.w	#1,minfo_CTile(a2)	; Else, move onto next tile.
	bsr	DisplayTileStatus	; Update status display.
.NoChange:
	rts

PreviousTile:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are there tiles?
	beq.s	.NoChange		; No, then we don't change anything!
	tst.w	minfo_CTile(a2)		; Test Current Tile value.
	beq.s	.NoChange		; Don't change if were at Min.
	subq.w	#1,minfo_CTile(a2)	; Else, move onto previous tile.
	bsr	DisplayTileStatus	; Update status display.
.NoChange:
	rts

Tiles16x16:
	bsr	CheckSaved		; Is the map saved?
	tst.l	d0
	beq.s	.Exit			; Exit if user canceled.
	move.l	_MapInfoBase,a2
	move.w	#16,minfo_TX(a2)	; Setup new size...
	move.w	#16,minfo_TY(a2)
	bsr	NewTileSize		; Activate new size.
.Exit:
	rts

Tiles16x32:
	move.w	mi_Flags+Tiles.3.3,d0
	btst	#4,d0			; Is item enabled?
	beq.s	.Exit			; No, then we can't do this.
	bsr	CheckSaved		; Is the map saved?
	tst.l	d0
	beq.s	.Exit			; Exit if user canceled.
	move.l	_MapInfoBase,a2
	move.w	#16,minfo_TX(a2)	; Setup new size...
	move.w	#32,minfo_TY(a2)
	bsr.s	NewTileSize		; Activate new size.
.Exit:
	rts

Tiles32x16:
	move.w	mi_Flags+Tiles.3.2,d0
	btst	#4,d0			; Is item enabled?
	beq.s	.Exit			; No, then we can't do this.
	bsr	CheckSaved		; Is the map saved?
	tst.l	d0
	beq.s	.Exit			; Exit if user canceled.
	move.l	_MapInfoBase,a2
	move.w	#32,minfo_TX(a2)	; Setup new size...
	move.w	#16,minfo_TY(a2)
	bsr.s	NewTileSize		; Activate new size.
.Exit:
	rts

Tiles32x32:
	move.w	mi_Flags+Tiles.3.1,d0
	btst	#4,d0			; Is item enabled?
	beq.s	.Exit			; No, then we can't do this.
	bsr	CheckSaved		; Is the map saved?
	tst.l	d0
	beq.s	.Exit			; Exit if user canceled.
	move.l	_MapInfoBase,a2
	move.w	#32,minfo_TX(a2)	; Setup new size...
	move.w	#32,minfo_TY(a2)
	bsr.s	NewTileSize		; Activate new size.
.Exit:
	rts

NewTileSize:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are there tiles?
	beq	.Exit			; No, then don't activate new size!
	moveq	#0,d0
	ori.w	#MIFF_CHANGED,minfo_Flags(a2)  ; Set changed flag.
	move.w	minfo_TRasX(a2),d0	; Calculate MTile...
	divu.w	minfo_TX(a2),d0
	moveq	#0,d1
	move.w	minfo_TRasY(a2),d1
	divu.w	minfo_TY(a2),d1
	mulu.w	d1,d0
	subq.w	#1,d0
	move.w	d0,minfo_MTile(a2)	; = ((( TRasX/Tx ) * ( TRasY/Ty ))-1)
	bsr	CheckTileRefs		; Make sure all tiles are valid.
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a Map?
	beq.s	.NoMap			; No, then just update the status.
	bsr.s	CheckPos		; Else, Make sure map position is OK.
	move.l	minfo_MapWindow(a2),a1
	move.l	wd_RPort(a1),a1		; Get MapScreen rastport.
	moveq	#0,d0
	CALLGRAF	SetRast		; Clear out old display.
	bsr	DrawMapSection		; Display map.
.NoMap:
	move.l	minfo_StatusWindow(a2),a3
	move.l	wd_RPort(a3),a3		; Get status RastPort.
	move.l	a3,a1
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	a3,a1
	move.w	#14,d0			; Setup Top-Left co-ords...
	move.w	#23,d1
	move.w	#45,d2			; Setup Bottom-Right co-ords...
	move.w	#54,d3
	CALLGRAF	RectFill	; Clear CTile Image.
	bsr	DisplayStatus		; Display Status
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

CheckPos:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_MAP,d2		; Is there a map?
	beq.s	.Exit			; No, then theres no point checking.
	moveq	#0,d0			; d0 = ( MRasX / TX )...
	move.w	minfo_MRasX(a2),d0
	divu.w	minfo_TX(a2),d0
	move.w	minfo_MX(a2),d1		; d1 = MX - ( MRasX / TX )...
	sub.w	d0,d1			; = Max possible X position.
	ble.s	.ZeroX			; If max <=0 branch.
	cmp.w	minfo_MXP(a2),d1	; Else, see if current pos okay.
	bge.s	.CheckY			; If so, check Y.
	move.w	d1,minfo_MXP(a2)	; Else, set position to max.
	bra.s	.CheckY
.ZeroX:
	move.w	#0,minfo_MXP(a2)	; Set position to 0.
.CheckY:
	move.l	EditHeight,d0		; d0 = ( EditHeight / TY )...
	divu.w	minfo_TY(a2),d0
	move.w	minfo_MY(a2),d1		; d1 = MY - ( EditHeight / TY )...
	sub.w	d0,d1			; = Max possible Y position.
	ble.s	.ZeroY			; If max <=0 branch.
	cmp.w	minfo_MYP(a2),d1	; Else, see if current pos okay.
	bge.s	.Exit			; If so, Exit.
	move.w	d1,minfo_MYP(a2)	; Else, set position to max.
	bra.s	.Exit
.ZeroY:
	move.w	#0,minfo_MYP(a2)	; Set position to 0.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

CheckSavedReq:				; A kind of auto-request replacement.
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	lea	CheckSavedWindow,a0
	move.l	minfo_StatusScreen(a2),nw_Screen(a0)
	CALLINT		OpenWindow	; Attempt to open the window.
	move.l	d0,a5			; Store result.
	tst.l	d0
	beq	.RequesterFail		; Exit fail, if not open.
	move.l	wd_RPort(a5),a1
	moveq	#RP_JAM2,d0
	CALLGRAF	SetDrMd		; Setup drawing mode.
	move.l	wd_RPort(a5),a1
	moveq	#1,d0
	CALLGRAF	SetAPen		; Setup drawing pen.
	move.l	wd_RPort(a5),a1
	moveq	#4,d0
	moveq	#2,d1
	move.w	#295,d2
	move.w	#46,d3
	CALLGRAF	RectFill	; Fill in window background.
	move.l	wd_RPort(a5),a0
	lea	CheckSavedText,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLINT		PrintIText	; Display body text.
	lea	BoolGadgets,a0
	move.l	a5,a1
	move.l	#0,a2
	CALLINT		RefreshGadgets	; Re-display gadgets.
.UserWait:
	move.l	wd_UserPort(a5),a0
	CALLEXEC	WaitPort	; Wait for selection
	move.l	wd_UserPort(a5),a0
	CALLEXEC	GetMsg		; Get the input.
	tst.l	d0
	beq.s	.UserWait		; Loop if it was of no interest.
	move.l	d0,a0
	jsr	ExtractData		; Get data & reply to message.
	lea	CurrInput,a0
	cmpi.l	#GADGETUP,im_Class(a0)	; Correct class?
	bne.s	.UserWait		; No, then loop...
	move.l	im_IAddress(a0),a0
	move.w	gg_GadgetID(a0),d7	; Get gadgets id as return code.
	ext.l	d7
	move.l	a5,a0
	CALLINT		CloseWindow	; Close the requester display.
	bra.s	.Exit
.RequesterFail:
	moveq	#1,d7			; If window fails, just continue.
.Exit:
	move.l	d7,d0			; Get return value
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

	section	ProgStuff,data
IFFFileSpec:
	dcb.w	75	; Filespec buffer for IFF routines.
RawTSpec:
	dcb.w	75	; Filespec buffer for RAW routines.

CheckSavedWindow:
	dc.w	169,8,300,49
	dc.b	0,1
	dc.l	GADGETUP,(SMART_REFRESH!NOCAREREFRESH!RMBTRAP!ACTIVATE)
	dc.l	BoolGadgets,0,0,0,0
	dc.w	300,49,300,49,CUSTOMSCREEN
BoolGadgets:
	dc.l	BoolGadget2
	dc.w	10,30,76,14,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	BoolBorder1,0,ContinueText,0,0
	dc.w	1
	dc.l	0
BoolGadget2:
	dc.l	0
	dc.w	230,30,60,14,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	BoolBorder2,0,CancelText,0,0
	dc.w	0
	dc.l	0
BoolBorder1:
	dc.w	0,0
	dc.b	0,1,RP_JAM1
	dc.b	5
	dc.l	BoolArray1,0
BoolBorder2:
	dc.w	0,0
	dc.b	0,1,RP_JAM1
	dc.b	5
	dc.l	BoolArray2,0
BoolArray1:
	dc.w	0,0,75,0,75,13,0,13,0,0
BoolArray2:
	dc.w	0,0,59,0,59,13,0,13,0,0

;   These are the IntuiText structures used in creating the CheckSaved
; AutoRequest Body text...

CheckSavedText:
	dc.b	AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE	; Defaults here.
	dc.w	16,5
	dc.l	0,CheckSavedString
	dc.l	CheckSavedText2			; There are 2 lines of text.
CheckSavedText2:
	dc.b	AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE	; Defaults here.
	dc.w	44,15
	dc.l	0,CheckSavedString2
	dc.l	0

;   And their asscoiated strings...

CheckSavedString:
	dc.b	"All data may be lost or changed",0
	even
CheckSavedString2:
	dc.b	"Do you wish to continue?",0
	even

;   These are the IntuiText structures for the check saved gadget texts...

ContinueText:
	dc.b	AUTOFRONTPEN,AUTOBACKPEN
	dc.b	AUTODRAWMODE
	dc.w	AUTOLEFTEDGE,AUTOTOPEDGE
	dc.l	AUTOITEXTFONT,ContinueString
	dc.l	AUTONEXTTEXT
CancelText:
	dc.b	AUTOFRONTPEN,AUTOBACKPEN
	dc.b	AUTODRAWMODE
	dc.w	AUTOLEFTEDGE,AUTOTOPEDGE
	dc.l	AUTOITEXTFONT,CancelString
	dc.l	AUTONEXTTEXT

;   And their associated strings...

ContinueString:
	dc.b	"Continue",0
	even
CancelString:
	dc.b	"Cancel",0
	even


;   This is the newScreen for the map screen, field like width & depth are
; setup by in-line code...

MapNewScreen:
	dc.w	0,67		; Position screen under status area.
	dc.w	0,0,0
	dc.b	1,2
	dc.w	0,(CUSTOMSCREEN!SCREENBEHIND)	; ViewModes setup in-line.
	dc.l	0,0,0,0

;   Now the newWindow, the IDCMP is setup in-line to share the same msgPort
; as the status window.  Again the width etc are also setup in-line...

MapNewWindow:
	dc.w	0,0,0,0
	dc.b	-1,-1
	dc.l	0,(SIMPLE_REFRESH!BORDERLESS!REPORTMOUSE!NOCAREREFRESH!RMBTRAP)
	dc.l	0,0,0,0,0
	dc.w	0,0,0,0
	dc.w	CUSTOMSCREEN

;   Now cones the newScreen for displaying the tiles, width, height, depth &
; modes are all setup in-line...

TilesNewScreen:
	dc.w	0,0,0,0,0
	dc.b	1,2
	dc.w	0,(CUSTOMSCREEN!SCREENBEHIND)
	dc.l	0,0,0,0

;   The newWindow for displaying tiles, width ect it setup in-line, the IDCMP
; is also setup in-line.  The window is a SUPER_BITMAP window...

TilesNewWindow:
	dc.w	0,0,0,0
	dc.b	-1,-1
	dc.l	0,(SUPER_BITMAP!BORDERLESS!RMBTRAP!ACTIVATE!REPORTMOUSE)
	dc.l	0,0,0,0,0
	dc.w	0,0,0,0
	dc.w	CUSTOMSCREEN

;  The following are strings that are used as titles in the file requester...

LoadTilesTitle:
	dc.b	"       Load IFF Tiles File       ",0
	even
SaveIFFTilesTitle:
	dc.b	"     Save Tiles As IFF ILBM      ",0
	even
SaveRawTilesTitle:
	dc.b	"     Save Tiles As RAW Data      ",0
	even

	section	ChipStuff,data_c

;   This is a NULL strite structure, it is used to erase the mouse pointer
; from a window...

BlankPointer:
	dc.l	0,0,0
	end
