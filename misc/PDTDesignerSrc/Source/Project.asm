	opt	c+,d+,l+,o+,i+
	incdir	sys:include/
	include	exec/exec_lib.i
	include	exec/exec.i
	include	intuition/intuition_lib.i
	include	intuition/intuition.i
	include	libraries/dos_lib.i
	include	libraries/dos.i
	include	graphics/graphics_lib.i

	include	MapDesignerV2.0:Source/MapDesignerV2.i	; Custom include!

	output	MapDesignerV2.0:Modules/ProjectModule.o

;   This file contains the following routines...

	xdef	About,AllocPlanes,AllocateTilesPort,LoadInit,LoadInMap
	xdef	LoadInTiles,LoadMap,NewMap,PlaceBlock,PlaceTile,Quit
	xdef	ReadColours,ReadPlanes,SaveMap,SaveMapAs,SaveTiles

;   This is *part* of LoadMap, it is called when CLI or WB arguments are
; passed to us by the startup code to attempt to load the argument as a map.

	xdef	ArgStartLoad

;   This file makes the following external references...

	xref	_MapInfoBase,_IntuitionBase,_DOSBase,_GfxBase
	xref	DrawMapSection,DisplayStatus,DialogueBox,CheckSaved,FreeData
	xref	FreePlanes,CheckTileRefs,OpenMapScreen,TilesCleanup,FreeTiles
	xref	_FileRequester,BlockCleanup,MapCleanup,SaveIcon,EditHeight
	xref	WritePlanes,WriteMap,DrawCursor,BlankDial,PromptDial
	xref	CheckPos,CheckRes,CheckSizes

	xref	ReadOpenFail,WriteOpenFail,ReadDataFail,WriteDataFail
	xref	NoMemFail,NotMapFail,NoTilesFail,NotIFFFail,NotILBMFail
	xref	BadIFFFail,OpenWBFail,CloseWBFail,IconFail,TileScreenFail
	xref	FileReqFail,EditScreenFail,PaletteReqFail,AboutText

About:
	lea	AboutText,a0		; DialogueBox string array.
	bsr	DialogueBox		; Display x boxes of text.
	rts

Quit:
	bsr	CheckSaved		; Get confirmation.
	tst.l	d0
	beq.s	.Exit			; Exit if the user canceled.
	move.l	_MapInfoBase,a0
	ori.w	#MIFF_QUIT,minfo_Flags(a0)	; Tell main to quit.
.Exit:
	rts

NewMap:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_TILES,d2		; There must be tiles to do this!
	beq.s	.Exit			; So, exit if there aren't any.
	bsr	CheckSaved		; Else, get the user to confirm.
	tst.l	d0
	beq.s	.Exit			; And exit if they canceled.
	bsr	FreeData		; Else, free *all* data.
	bsr	DisplayStatus		; Update status display.
					; Clear most flags...
	andi.w	#~(MIFF_CHANGED!MIFF_PAINT!MIFF_ICON!MIFF_INCTILES),minfo_Flags(a2)
	clr.w	minfo_Name(a2)		; Remove old filespec.
.Exit:
	rts

PlaceTile:
	movem.l	d2-7/a2-6,-(sp)
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0
	beq.s	.Exit			; Exit if there's no map.
	move.w	minfo_CXP(a2),d1
	cmp.w	minfo_MX(a2),d1
	bge.s	.Exit			; Exit if cursor is not in map.
	move.w	minfo_CYP(a2),d1
	cmp.w	minfo_MY(a2),d1
	bge.s	.Exit			; Exit if cursor is not in map.
	ori.w	#MIFF_CHANGED,minfo_Flags(a2)	; Set map changed flag.
	btst	#MIFB_MODE,d0		; Are we in tiles mode?
	bne.s	.ItsaBlock		; No, then put down a block.
	moveq	#0,d1
	move.w	minfo_CYP(a2),d0	; Calculate offset for tile...
	move.w	minfo_CXP(a2),d1
	mulu.w	minfo_MX(a2),d0
	add.l	d1,d0
	lsl.l	#1,d0
	move.l	minfo_Map(a2),a0
	adda.l	d0,a0
	move.w	minfo_CTile(a2),(a0)	; Write in the tile.
	bra.s	.Update			; Then Branch.
.ItsaBlock:
	bsr.s	PlaceBlock		; Call block placement.
.Update:
	bsr	DrawMapSection		; Update map display.
	bsr	DrawCursor		; ReDraw cursor
	ori.w	#MIFF_CDRAWN,minfo_Flags(a2)
.Exit:
	movem.l	(sp)+,d2-7/a2-6
	rts

PlaceBlock:
	move.l	_MapInfoBase,a2
	moveq	#0,d7
	move.w	minfo_BX(a2),d7
	add.w	minfo_CXP(a2),d7
	cmp.w	minfo_MX(a2),d7		; ( ( Bx + Cxp ) > Mx ) ?
	ble.s	.XFits			; Branch if it is in range.
	sub.w	minfo_MX(a2),d7		; d7 = Block modulo.
	move.w	minfo_BX(a2),d4
	sub.w	d7,d4			; d4 = Width to write.
	lsl.l	#1,d7
	bra.s	.GotX
.XFits:
	moveq	#0,d7			; No modulo.
	move.w	minfo_BX(a2),d4		; Normal width.
.GotX:
	moveq	#0,d6
	move.w	minfo_BY(a2),d6
	add.w	minfo_CYP(a2),d6
	cmp.w	minfo_MY(a2),d6		; ( ( By + Cyp ) > My ) ?
	ble.s	.YFits			; Branch if it is in range.
	sub.w	minfo_MY(a2),d6
	move.w	minfo_BY(a2),d5
	sub.w	d6,d5			; d5 = Height to write.
	bra.s	.GotY
.YFits:
	move.w	minfo_BY(a2),d5		; Normal height.
.GotY:
	subq.w	#1,d5
	move.w	minfo_MX(a2),d6
	sub.w	d4,d6			; d6 = Map modulo.
	lsl.l	#1,d6
	subq	#1,d4			; dbra adjustment.
	moveq	#0,d1
	move.w	minfo_CYP(a2),d0	; Calculate offset for 1st tile...
	move.w	minfo_CXP(a2),d1
	mulu.w	minfo_MX(a2),d0
	add.l	d1,d0
	lsl.l	#1,d0
	move.l	minfo_Map(a2),a0
	adda.l	d0,a0			; a0 = Destination
	move.l	minfo_Block(a2),a1	; a1 = Source.
.YLoop:
	move.w	d4,d3			; Get copy of width for loop.
.XLoop:
	move.w	(a1)+,(a0)+		; Copy WORD.
	dbra	d3,.XLoop		; Loop for Width...
	adda.l	d7,a1			; Add block modulo.
	adda.l	d6,a0			; Add map modulo.
	dbra	d5,.YLoop		; Loop for Height...
	rts

AllocPlanes:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	a0,a2			; Save users input.
	moveq	#0,d4			; Plane Indexer.
	move.b	bm_Depth(a2),d3
	ext.w	d3
	subq.w	#1,d3			; Setup loop.
.AllocLoop:
	move.w	bm_BytesPerRow(a2),d0
	lsl.w	#3,d0
	move.w	bm_Rows(a2),d1
	CALLGRAF	AllocRaster	; Get a BitPlane.
	move.l	d0,bm_Planes(a2,d4)	; Install & test.
	beq.s	.Failure		; Cleanup & exit on failure.
	addq.w	#4,d4			; Advance index.
	dbra	d3,.AllocLoop		; Loop for all planes...
	moveq	#1,d0			; Set return = Success.
	bra.s	.Exit
.Failure:
	move.l	a2,a0
	bsr	FreePlanes		; Free any successful planes.
	moveq	#0,d0			; Set return = Failure.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

AllocateTilesPort:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d7			; Save users input.
	moveq	#vp_SIZEOF,d0
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate memory for VPort.
	tst.l	d0
	beq	.NoViewPort		; Exit on failure.
	move.l	d0,a5			; Keep this ptr safe!
	move.l	d0,d2
	move.l	d7,d1
	moveq	#vp_SIZEOF,d3
	CALLDOS		Read		; Read in ViewPort
	cmpi.l	#-1,d0
	beq	.NoRasInfo		; Exit on read failure.
	moveq	#ri_SIZEOF,d0
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate a RasInfo structure.
	move.l	d0,vp_RasInfo(a5)	; Install ptr.
	beq	.NoRasInfo
	move.l	d0,a4
	moveq	#bm_SIZEOF,d0
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate a BitMap.
	move.l	d0,ri_BitMap(a4)	; Install ptr.
	beq.s	.NoBitMap
	move.l	d0,a0
	move.l	_MapInfoBase,a2
	move.w	minfo_Depth(a2),d0
	move.w	minfo_TRasX(a2),d1
	move.w	minfo_TRasY(a2),d2
	CALLGRAF	InitBitMap	; Initialise the BitMap.
	move.w	minfo_Depth(a2),d1
	moveq	#1,d0
	lsl.l	d1,d0			; Calculate number of cols.
	cmpi.w	#32,d0
	ble.s	.ColsOK			; Branch if its a valid number.
	moveq	#32,d0			; Else, set to max possible.
.ColsOK:
	CALLGRAF	GetColorMap	; Allocate a ColorMap.
	move.l	d0,vp_ColorMap(a5)	; Install ptr.
	beq.s	.NoColorMap		; Branch on error.
	move.l	ri_BitMap(a4),a0
	bsr	AllocPlanes		; Allocate the BitPlanes.
	tst.l	d0
	beq.s	.NoBitPlanes		; Exit on failure.
	move.l	a5,minfo_TilesPort(a2)	; Else, install ptr to tiles port.
	moveq	#1,d0			; Set return = Success!
	bra.s	.Exit
.NoBitPlanes:
	move.l	vp_ColorMap(a5),a0
	CALLGRAF	FreeColorMap	; Free color map.
.NoColorMap:
	move.l	ri_BitMap(a4),a1
	moveq	#bm_SIZEOF,d0
	CALLEXEC	FreeMem		; Free BitMap memory.
.NoBitMap:
	move.l	vp_RasInfo(a5),a1
	moveq	#ri_SIZEOF,d0
	CALLEXEC	FreeMem		; Free Rasinfo memory.
.NoRasInfo:
	move.l	a5,a1
	moveq	#vp_SIZEOF,d0
	CALLEXEC	FreeMem		; Free ViewPort memory.
.NoViewPort:
	bsr	NoMemFail		; Display error.
	moveq	#0,d0			; Set reurn = fail.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

LoadInit:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a4		; For the use of!
	move.l	d0,d7			; Save file handle.
	move.l	#minfo_SIZEOF,d0
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate a new MapInfo.
	tst.l	d0
	beq	.NoMapInfo		; Exit on failure.
	move.l	d0,a5			; Save this ptr.
	move.l	d0,d2
	move.l	d7,d1
	moveq	#minfo_FileHeader,d3
	CALLDOS		Read		; Read in file header.
	cmpi.l	#-1,d0
	beq	.FileFailure		; Exit on failure.
	cmpi.l	#"M2.0",(a5)		; Is this a map?
	bne	.TypeFailure		; No, then exit.
	move.l	minfo_StatusScreen(a4),minfo_StatusScreen(a5)
	move.l	minfo_StatusWindow(a4),minfo_StatusWindow(a5)
	move.l	minfo_TilesPort(a4),minfo_TilesPort(a5)	; Install old tiles.
	move.w	minfo_Flags(a4),d0
	andi.w	#MIFF_TILES,d0			; Keep old tiles status
	andi.w	#MIFIOMASK,minfo_Flags(a5)  	; Mask out un-needed flags.
	or.w	d0,minfo_Flags(a5)		; Combine old and new flags.
	move.w	minfo_Flags(a5),d0
	btst	#MIFB_INCTILES,d0
	bne.s	.TilesAreHere		; Branch if tiles are included.
	btst	#MIFB_TILES,d0		; Are there tiles loaded?
	beq.s	.TilesFailure		; No, then we can't load the map.
	move.w	minfo_TRasX(a4),minfo_TRasX(a5)
	move.w	minfo_TRasY(a4),minfo_TRasY(a5)
	move.w	minfo_TX(a4),minfo_TX(a5)
	move.w	minfo_TY(a4),minfo_TY(a5)
	move.w	minfo_Depth(a4),minfo_Depth(a5)
	move.w	minfo_CTile(a4),minfo_CTile(a5)
	move.w	minfo_MTile(a4),minfo_MTile(a5)
	ori.w	#MIFF_TILES,minfo_Flags(a5)	; Set tiles flag.
	bra.s	.InitDone
.TilesAreHere:
	bsr	FreeTiles		; Free old tiles.
	andi.w	#MIFIOMASK,minfo_Flags(a5)	; Clear new flag.
.InitDone:
	lea	minfo_Name(a4),a1	; Transfer filespec...
	lea	minfo_Name(a5),a0
	move.w	#74,d0
.CopyLoop:
	move.w	(a1)+,(a0)+
	dbra	d0,.CopyLoop		; Loop for all characters...
	move.l	a4,a1
	move.l	#minfo_SIZEOF,d0
	CALLEXEC	FreeMem		; Free old MapInfo.
	move.l	a5,_MapInfoBase		; Install new MapInfo.
	moveq	#1,d0			; Set return = success.
	bra.s	.Exit
.TilesFailure:
	bsr	NoTilesFail
	bra.s	.Failure
.TypeFailure:
	bsr	NotMapFail
	bra.s	.Failure
.FileFailure
	bsr	ReadDataFail
.Failure:
	move.l	a5,a1
	move.l	#minfo_SIZEOF,d0
	CALLEXEC	FreeMem		; Free half finished new MapInfo.
	bra.s	.FExit
.NoMapInfo:
	bsr	NoMemFail
.FExit:
	moveq	#0,d0			; Set return = fail.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

LoadInMap:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d7			; Save file handle.
	move.l	_MapInfoBase,a2
	move.w	minfo_MX(a2),d2
	mulu.w	minfo_MY(a2),d2
	lsl.l	#1,d2			; Size of map array.
	move.l	d2,d0
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate map array.
	move.l	d0,minfo_Map(a2)
	beq.s	.NoMapArray		; Exit on failure.
	move.l	d2,d3
	move.l	d7,d1
	move.l	d0,d2
	CALLDOS		Read		; Read data into map array.
	cmpi.l	#-1,d0
	beq.s	.FileFailure		; Exit if read failed.
	ori.w	#MIFF_MAP,minfo_Flags(a2)	; Set map flag.
	bsr	CheckTileRefs		; Check tile references.
	bsr	CheckPos		; Check our position in map.
	bsr	OpenMapScreen
	tst.l	d0			; Open map display.
	beq.s	.FExit		; Exit if something went wrong.
	moveq	#1,d0
	bra.s	.Exit
.FileFailure:
	move.l	minfo_Map(a2),a1
	move.w	minfo_MX(a2),d0		; Calculte size of map array.
	mulu.w	minfo_MY(a2),d0
	lsl.l	#1,d0
	CALLEXEC	FreeMem		; Free map memory.
	bsr	ReadDataFail
	bra.s	.FExit
.NoMapArray:
	bsr	NoMemFail
.FExit:
	moveq	#0,d0
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; recall regs.
	rts

LoadInTiles:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d7			; Save file handle.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_TILES,d0		; Are we to load tiles?
	bne.s	.GotTiles		; No, then exit.
	move.l	d7,d0
	bsr	AllocateTilesPort	; Allocate new tiles port.
	tst.l	d0
	beq.s	.Failure		; Exit if can't build ViewPort.
	ori.w	#MIFF_TILES,minfo_Flags(a2)	; Set tiles flag.
	move.l	d7,d0
	bsr	ReadPlanes		; Read in bitplanes.
	tst.l	d0
	beq.s	.NoPlanes		; Exit on failure.
	move.l	d7,d0
	bsr	ReadColours		; Read in and install cols.
	tst.l	d0
	beq.s	.NoPlanes		; Exit on failure.
.GotTiles:
	moveq	#1,d0			; Set return = success.
	bra.s	.Exit
.NoPlanes:
	bsr	TilesCleanup		; Get rid of any tiles data.
.Failure:
	moveq	#0,d0			; Set return = failure.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

LoadMap:
	move.l	_MapInfoBase,a5
	bsr	CheckSaved		; Are they sure?
	tst.l	d0
	beq	Exit			; No, then exit.
	move.l	minfo_StatusScreen(a5),a0
	lea	LoadMapTitle,a1
	lea	minfo_Name(a5),a2
	bsr	_FileRequester		; Get file name to load.
	tst.l	d0
	bmi	ReqFail
	beq	Exit			; Exit if user canceled.
	bsr	BlockCleanup		; Get rid of old data...
	bsr	MapCleanup
ArgStartLoad:				  ** Special starting place to handle
	move.l	minfo_StatusWindow(a5),a3	; arguments when loading.
	move.l	wd_RPort(a3),a3
	move.l	a3,a1
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	a3,a1
	move.w	#14,d0			; Setup Top-Left co-ords...
	move.w	#23,d1
	move.w	#45,d2			; Setup Bottom-Right co-ords...
	move.w	#54,d3
	CALLGRAF	RectFill	; Clear CTile Image.
	move.l	a5,d1
	add.l	#minfo_Name,d1		; Pointer to filespec.
	move.l	#MODE_OLDFILE,d2
	CALLDOS		Open		; Open file.
	move.l	d0,d7			; Save & test result.
	beq.s	NoFile			; Exit on failure.
	bsr	LoadInit		; Setup for load.
	tst.l	d0
	beq.s	LoadFail		; Exit on failure.
	move.l	d7,d0
	bsr	LoadInTiles		; Load / Setup tiles.
	tst.l	d0
	beq.s	LoadFail		; Exit on failure.
	move.l	d7,d0
	bsr	LoadInMap		; Load / Setup map.
	tst.l	d0
	beq.s	MapFail			; Exit on failure.
	move.l	_MapInfoBase,a5		; Get ptr to new MapInfo.
	move.l	d7,d1
	CALLDOS		Close		; Close file.
	move.l	minfo_TilesPort(a5),a0
	move.l	EditHeight,d0
	add.w	#64,d0
	cmp.w	vp_DHeight(a0),d0	; Make sure we'll see whole screen...
	bge.s	Exit
	move.w	d0,vp_DHeight(a0)
	bra.s	Exit
MapFail:
	move.w	minfo_Flags(a5),d0
	btst	#MIFB_INCTILES,d0	; Are the tiles ours?
	beq.s	LoadFail		; No, then dont free them.
	bsr	TilesCleanup		; Else, do free them!
LoadFail:
	move.l	d7,d1
	CALLDOS		Close		; Close the file.
	bra.s	Exit
NoFile:
	bsr	ReadOpenFail
	bra.s	Exit
ReqFail:
	bsr	FileReqFail
Exit:
	bsr	CheckSizes		; Allow only valid tile sizes.
	bsr	CheckRes		; Allow only valid screens.
	bsr	DisplayStatus		; Update status.
	move.l	minfo_StatusWindow(a5),a0
	CALLINT		ActivateWindow	; Activate status area.
	rts

ReadPlanes:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d7			; Save file handle.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesPort(a2),a2
	move.l	vp_RasInfo(a2),a2
	move.l	ri_BitMap(a2),a2	; Ah! At last the BitMap!!
	moveq	#0,d5			; d5 = Plane index.
	move.b	bm_Depth(a2),d4
	ext.w	d4
	subq.w	#1,d4			; d4 = Loop control.
	move.w	bm_BytesPerRow(a2),d6
	mulu.w	bm_Rows(a2),d6		; d6 = Size of 1 plane.
.ReadLoop:
	move.l	d7,d1
	move.l	d6,d3
	move.l	bm_Planes(a2,d5),d2	; Get destination plane.
	CALLDOS		Read		; Read in data.
	cmpi.l	#-1,d0
	beq.s	.Failure		; Exit on failure.
	addq.w	#4,d5			; Move on to next plane.
	dbra	d4,.ReadLoop		; Loop for all planes...
	moveq	#1,d0			; Set return = success.
	bra.s	.Exit
.Failure:
	bsr	ReadDataFail
	moveq	#0,d0
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

ReadColours:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d7			; Save file handle.
	link	a5,#-64			; Allocate stack for max cols.
	lea	-64(a5),a4		; a4 = Start of table.
	move.l	_MapInfoBase,a3
	move.w	minfo_Depth(a3),d0
	moveq	#1,d6
	lsl.w	d0,d6			; d6 = Number of cols.
	cmpi.w	#32,d6
	ble.s	.ColsOK			; Branch if its a valid number.
	moveq	#32,d6			; Else, set to max possible.
.ColsOK:
	move.l	d7,d1
	move.l	a4,d2
	move.l	d6,d3
	lsl.l	#1,d3
	CALLDOS		Read		; Read colour data into buffer.
	cmpi.l	#-1,d0
	beq.s	.Failure		; Exit on failure.
	move.l	minfo_TilesPort(a3),a2
	move.l	vp_ColorMap(a2),a2
	moveq	#0,d5			; d5 = index.
	subq.w	#1,d6			; d6 = Loop control.
.ColsLoop:
	move.w	(a4)+,d0
	move.w	d0,d1			; Get Red.
	move.w	d0,d2			; Get Green.
	move.w	d0,d3			; Get Blue.
	lsr.w	#8,d1			; Format data properly...
	lsr.w	#4,d2
	andi.w	#$f,d1			; Mask out rubbish...
	andi.w	#$f,d2
	andi.w	#$f,d3
	move.l	d5,d0			; Get index.
	move.l	a2,a0
	CALLGRAF	SetRGB4CM	; Setup ColorMap entry.
	addq.w	#1,d5
	dbra	d6,.ColsLoop		; Loop for all entries...
	moveq	#1,d0			; Set return = success.
	bra.s	.Exit
.Failure:
	bsr	ReadDataFail
	moveq	#0,d0			; Set return = Fail.
.Exit:
	unlk	a5			; Free stack mem.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

SaveTiles:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d7			; Save FileHandle.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesPort(a2),d2
	move.l	d7,d1
	moveq	#vp_SIZEOF,d3
	CALLDOS		Write		; Wrie out ViewPort structure.
	cmpi.l	#-1,d0
	beq.s	.Failure		; Exit if write failed.
	move.l	d7,d0
	bsr	WritePlanes		; Write out planes & cols.
	tst.l	d0
	beq.s	.FExit			; Exit if writes failed.
	moveq	#1,d0			; Else, set success return.
	bra.s	.Exit
.Failure:
	bsr	WriteDataFail
.FExit:
	moveq	#0,d0			; Set reurn = fail.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

SaveMapAs:
	move.l	_MapInfoBase,a5
	move.w	minfo_Flags(a5),d0
	btst	#MIFB_MAP,d0		; Need a map to be able to save one!
	beq.s	.Exit			; So, exit if there isn't one.
	move.l	minfo_StatusScreen(a5),a0
	lea	SaveMapTitle,a1
	lea	minfo_Name(a5),a2
	bsr	_FileRequester		; Get file name to save under.
	bmi.s	.ReqFail
	tst.l	d0
	beq.s	.Exit			; Exit if user canceled.
	move.l	minfo_MapScreen(a5),a0
	CALLINT		ScreenToFront		; Bring Map Screen back.
	bsr.s	SaveMap				; Do the save.
	bra.s	.Exit
.ReqFail:
	bsr	FileReqFail
.Exit:
	move.l	minfo_StatusWindow(a5),a0
	CALLINT		ActivateWindow		; Activate ststus area.
	rts

SaveMap:
	move.l	_MapInfoBase,a5
	tst.b	minfo_Name(a5)		; Is filespec valid?
	beq	.SaveAS			; No, branch.
	move.l	a5,d1
	add.l	#minfo_Name,d1
	move.l	#MODE_NEWFILE,d2
	CALLDOS		Open		; Open file to write to.
	move.l	d0,d7			; Save this.
	beq.s	.NoFile			; Branch on failure.
	move.l	#"M2.0",minfo_ID(a5)	; Install version ID.
	move.l	a5,d2
	move.l	d7,d1
	moveq	#minfo_FileHeader,d3
	CALLDOS		Write		; Write out file header.
	cmpi.l	#-1,d0
	beq.s	.BadWrite		; Branch on failure.
	move.w	minfo_Flags(a5),d0
	btst	#MIFB_INCTILES,d0	; Include Tiles?
	beq.s	.SaveMapData		; No, branch.
	move.l	d7,d0
	bsr	SaveTiles		; Else, save tiles data.
	tst.l	d0
	beq.s	.Exit			; Branch if writes failed.
.SaveMapData:
	move.l	d7,d0
	bsr	WriteMap		; Save map data out.
	tst.l	d0
	beq.s	.Exit			; Branch if writes failed.
	move.l	d7,d1
	CALLDOS		Close		; Close disk file.
	andi.w	#~MIFF_CHANGED,minfo_Flags(a5)	; Clear map changed flag.
	lea	minfo_Name(a5),a0
	jsr	SaveIcon		; Create icon if required
	bra.s	.Exit
.BadWrite:
	move.l	d7,d1
	CALLDOS		Close		; Close disk file.
	move.l	a5,d1
	add.l	#minfo_Name,d1
	CALLDOS		DeleteFile	; Delete partial file.
	bsr	WriteDataFail
	bra.s	.Exit
.NoFile:
	bsr	WriteOpenFail
	bra.s	.Exit
.SaveAS:
	bsr	SaveMapAs		; Get filespec etc, then save.
.Exit:
	rts

	section	ProgStuff,data

;   These are the load / save map file requester title strings...

LoadMapTitle:
	dc.b	"       Load V2.0 Map File        ",0
	even
SaveMapTitle:
	dc.b	"       Save V2.0 Map File        ",0
	even

	end
