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

	output	MapDesignerV2.0:Modules/BlocksModule.o

;   This file contains the following routines...

	xdef	EraseBlock,UseOldBlock,GetMBlock,GetTilesBlock
	xdef	SortCorners,GrabBlock,BuildBlock,ScrollUp
	xdef	ScrollDown,ScrollLeft,ScrollRight,FilledBox

;   This file makes the following external references...

	xref	_MapInfoBase,_IntuitionBase,_InputPort,InputClass,InputCode
	xref	CurrInput,BlankPointer,EditHeight
	xref	BlockCleanup,DisplayStatus,DisplayTileStatus,DialogueBox
	xref	ExtractData,HandleMove,HandleMiniMap,MoveMap
	xref	ShowTiles,HideTiles,GetTile,BlankDial,PromptDial
	xref	ClearPort,BusyPointer,PrintInteger,ClearText,SetPens
	xref	CheckInput,DrawCursor,TScrollUp,TScrollDown,TScrollLeft
	xref	TScrollRight,_GfxBase,DivideRaster,DrawMapSection,BlockStr
	xref	BlitCTile

	xref	ReadOpenFail,WriteOpenFail,ReadDataFail,WriteDataFail
	xref	NoMemFail,NotMapFail,NoTilesFail,NotIFFFail,NotILBMFail
	xref	BadIFFFail,OpenWBFail,CloseWBFail,IconFail,TileScreenFail
	xref	FileReqFail,EditScreenFail,PaletteReqFail,AboutText

	section	Program,code
EraseBlock:
	jsr	BlockCleanup		; Just a stub for V2.0.
	rts

UseOldBlock:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_BLOCK,d2			; Is there a block?
	beq.s	.Exit				; No, then we can't use it!
	ori.w	#MIFF_MODE,minfo_Flags(a2)	; Else, switch on block mode.
	jsr	DisplayStatus			; Update status area.
.Exit:
	rts

GetMBlock:
	link	a5,#-16			; Allocate local vars.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; There must be a map to do this.
	beq	.NoMapExit		; So, exit if there isn't one.
	move.l	minfo_StatusWindow(a2),a0
	move.l	#(MOUSEMOVE!GADGETUP!RAWKEY),d0
	move.l	_InputPort,wd_UserPort(a0)	; Install port.
	CALLINT		ModifyIDCMP		; Enable inputs.
	move.l	minfo_MapWindow(a2),a0
	move.l	#(MOUSEMOVE!RAWKEY!MOUSEBUTTONS),d0
	move.l	_InputPort,wd_UserPort(a0)	; Install port.
	CALLINT		ModifyIDCMP		; Enable inputs.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearPointer		; Clear BUSY! pointer.
	move.l	minfo_MapWindow(a2),a0
	lea	BlankPointer,a1		; NULL sprite struct.
	moveq	#1,d0
	moveq	#16,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Set mouse pointer to a clear image.
	jsr	BlockCleanup			; Erase old block.
	ori.w	#MIFF_BSELECT,minfo_Flags(a2)	; Set "Selecting Block" flag.
	bsr	SetPens			; Setup status RPort.
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)		; Save this.
	move.w	#60,d0
	move.w	#32,d1
	CALLGRAF	Move		; Move gfx cursor.
	move.l	(sp),a1			; Recall Rastport ptr.
	lea	BlockStr,a0
	moveq	#5,d0
	CALLGRAF	Text		; Write mode text.
	move.l	(sp),a1			; Recall Rastport ptr.
	move.w	#60,d0			; Size co-ords...
	move.w	#53,d1
	CALLGRAF	Move		; Move gfx cursor.
	lea	GrabStr,a0
	move.l	(sp),a1			; Recall Rastport ptr.
	moveq	#5,d0
	CALLGRAF	Text		; Write "Grab" text.
	move.l	(sp),a1
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	(sp)+,a1
	move.w	#14,d0			; Setup Top-Left co-ords...
	move.w	#23,d1
	move.w	#45,d2			; Setup Bottom-Right co-ords...
	move.w	#54,d3
	CALLGRAF	RectFill	; Clear CTile Image.
	bsr	MapElasticBox		; Get block size & co-ords
	tst.l	d0
	beq.s	.Exit			; Don't get block if user aborted!
	bsr	SortCorners		; Else, make sure of corners.
	move.w	-12(a5),d0
	move.w	-4(a5),d2
	sub.w	d2,d0
	addq.w	#1,d0			; Calculate Block width.
	move.w	d0,minfo_BX(a2)
	move.w	-16(a5),d1
	move.w	-8(a5),d2
	sub.w	d2,d1
	addq.w	#1,d1			; Calculate Block height.
	move.w	d1,minfo_BY(a2)
	mulu.w	d1,d0
	lsl.l	#1,d0			; Calculate block size.
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate block array.
	move.l	d0,minfo_Block(a2)
	beq.s	.Failure		; Exit if allocation failed.
	bsr	GrabBlock		; Fill the block array.
	ori.w	#(MIFF_BLOCK!MIFF_MODE),minfo_Flags(a2)
	bra.s	.Exit
.Failure:
	bsr	NoMemFail		; Display failure message.
.Exit:
	andi.w	#~MIFF_BSELECT,minfo_Flags(a2)	; Clr "Selecting Block" flag.
	CALLEXEC	Forbid		; Aaarrgh!!
	bsr	ClearPort		; Reply to all messages at our port.
	move.l	minfo_StatusWindow(a2),a0
	moveq	#0,d0
	move.l	d0,wd_UserPort(a0)	; Don't let intuition touch our port.
	CALLINT		ModifyIDCMP	; Turn off inputs for status window.
	move.l	minfo_MapWindow(a2),a0
	moveq	#0,d0
	move.l	d0,wd_UserPort(a0)	; Don't let intuition touch our port.
	CALLINT		ModifyIDCMP	; Turn off inputs for map window.
	CALLEXEC	Permit		; Ah!
	move.l	minfo_StatusWindow(a2),a0
	lea	BusyPointer,a1
	moveq	#22,d0
	moveq	#1,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Reinstate BUSY! mouse ptr.
	move.l	minfo_MapWindow(a2),a0
	lea	BusyPointer,a1
	moveq	#22,d0
	moveq	#1,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Reinstate BUSY! mouse ptr.
.NoMapExit:
	unlk	a5			; Free local variables.
	jsr	DisplayStatus		; Print info about block.
	rts

MapElasticBox:			  ; Added V2.1 Enhancement.  22/12/92
	movem.l	d2-7/a2-6,-(sp)		; Save registers.
	moveq	#0,d7			; Hit flag.
	move.l	_MapInfoBase,a4		; Get data structure.
	ori.w	#MIFF_NOCURS,minfo_Flags(a4)	; Don't want normal cursor.
.Loop:
	move.l	_InputPort,a0
	CALLEXEC	WaitPort	; Now wait on user.
.WhileMessages:
	move.l	_InputPort,a0
	CALLEXEC	GetMsg		; Get next msg from port.
	tst.l	d0
	beq.s	.Loop			; Wait again if no more messages.
	move.l	d0,a0
	jsr	ExtractData		; Get data and reply to message.
	move.l	InputClass,d0		; Get class of input.
	cmpi.l	#MOUSEMOVE,d0		; Was it a mouse movement?
	bne.s	.TryKeys		; No, check the keyboard.
	bsr	MapBoxMove		; Else, handle the users input.
	bra.s	.WhileMessages		; And loop for next message...
.TryKeys:
	cmpi.l	#RAWKEY,d0		; Was it a keyboard stroke?
	bne.s	.TryGadget		; No, check the gadget.
	bsr.s	MapBoxKeys		; Else, handle the users input.
	tst.l	d0			; If user didn't abort,
	bne.s	.WhileMessages		; loop for next message...
	bra.s	.Return			; Else, tell client we're quitting.
.TryGadget:
	cmpi.l	#GADGETUP,d0		; Was it a gadget message?
	bne.s	.TryMouse		; No, check the mouse buttons.
	bsr	HandleMiniMap		; Else, handle the users input.
	bra.s	.WhileMessages		; And loop for next message...
.TryMouse:
	cmpi.l	#MOUSEBUTTONS,d0	; Was it a mouse button?
	bne.s	.WhileMessages		; No, then we're not interested!
	move.w	InputCode,d0		; Else, get more info.
	cmpi.w	#SELECTDOWN,d0		; Was it the left button pressed?
	bne.s	.WhileMessages		; No, then again, we don't worry.
	bsr.s	MapBoxCorner		; Else, set which ever corner!
	tst.l	d0
	bne.s	.WhileMessages		; Loop if we're not done...
	moveq	#1,d0			; Else, tell client to grab block.
.Return:
	andi.w	#~MIFF_NOCURS,minfo_Flags(a4)	; Restore normal cursor.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

MapBoxKeys:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.w	InputCode,d0		; Get RAWKEY code.
	cmpi.w	#$45,d0			; Escape?
	bne.s	.Left			; No, then check left.
	moveq	#0,d0
	bra.s	.Return			; Else, return NULL.
.Left:
	cmpi.w	#$4f,d0			; Left?
	bne.s	.Right			; No, then check right.
	bsr	ScrollLeft		; Else, move map.
	bra.s	.KeysDone
.Right:
	cmpi.w	#$4e,d0			; Right?
	bne.s	.Up			; No, then check up.
	bsr	ScrollRight		; Else, move map.
	bra.s	.KeysDone
.Up:
	cmpi.w	#$4c,d0			; Up?
	bne.s	.Down			; No, then check down.
	bsr	ScrollUp		; Else, move map.
	bra.s	.KeysDone
.Down:
	cmpi.w	#$4d,d0			; Down?
	bne.s	.KeysDone		; No, then check exit.
	bsr	ScrollDown		; Else, move map.
.KeysDone:
	moveq	#1,d0			; Set continue return.
.Return:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

MapBoxCorner:
	tst.l	d7		; How's the hit flag?
	bne.s	.LastSet	; Branch if we've got top-left.
	move.w	minfo_CXP(a4),-4(a5)	; Store X co-ord.
	move.w	minfo_CYP(a4),-8(a5)	; And the Y co-ord.
	moveq	#1,d7		; Setup hit flag for next time.
	moveq	#1,d0		; And tell main to continue.
	bra.s	.Return
.LastSet:
	move.w	minfo_CXP(a4),-12(a5)	; Store X co-ord.
	move.w	minfo_CYP(a4),-16(a5)	; And the Y co-ord.
	moveq	#0,d0		; And tell main we're done
.Return:
	rts

MapBoxMove:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	jsr	CheckInput		; Activate correct window.
	jsr	SetPens			; Setup status rport.
	move.l	_MapInfoBase,a4		; Get pointer to data.
	lea	CurrInput,a0		; Pointer to input message.
	moveq	#0,d2
	move.w	im_MouseX(a0),d2	; Get x co-ord of mouse.
	divu.w	minfo_TX(a4),d2		; Get curs co-ord for screen.
	add.w	minfo_MXP(a4),d2	; Now make it relative to map.
	cmp.w	minfo_MX(a4),d2		; Is Co-ord off map?
	blt.s	.XCoOK			; No, then branch.
	move.w	minfo_MX(a4),d2		; Else, set to max allowable...
	subq.w	#1,d2
.XCoOK:
	move.w	d2,minfo_CXP(a4)	; = CXP.
	moveq	#0,d3
	move.w	im_MouseY(a0),d3	; Get y co-ord of mouse.
	divu.w	minfo_TY(a4),d3		; Get curs co-ord for screen.
	add.w	minfo_MYP(a4),d3	; Now make it relative to map.
	cmp.w	minfo_MY(a4),d3		; Is Co-ord off map?
	blt.s	.YCoOK			; No, then branch.
	move.w	minfo_MY(a4),d3		; Else, set to max allowable...
	subq.w	#1,d3
.YCoOK:
	move.w	d3,minfo_CYP(a4)	; = CYP.
	tst.l	d7			; Check hit flag.
	bne.s	.LastSet		; We only want to move BR corner.

	sub.w	minfo_MYP(a4),d3	; Get screen relative co-ord.
	mulu.w	minfo_TY(a4),d3		; Calculate on-screen co-ord of CYP.
	sub.w	minfo_MXP(a4),d2	; Get screen relative co-ord.
	mulu.w	minfo_TX(a4),d2		; Calculate on-screen co-ord of CXP.
	move.w	minfo_TX(a4),d4		; Get width of 1 tile.
	move.w	minfo_TY(a4),d5		; And height of 1 tile.
	bra.s	.GotDims
.LastSet:
	move.w	d3,d5			; Need data in different registers...
	move.w	d2,d4
	move.w	-4(a5),d2		; Calculate x start...
	sub.w	minfo_MXP(a4),d2
	bpl.s	.GotXTemp
	moveq	#0,d2
.GotXTemp:
	mulu.w	minfo_TX(a4),d2
	move.w	-8(a5),d3		; Calculate y start...
	sub.w	minfo_MYP(a4),d3
	bpl.s	.GotYTemp
	moveq	#0,d3
.GotYTemp:
	mulu.w	minfo_TY(a4),d3
	sub.w	minfo_MYP(a4),d5	; Get screen relative co-ord.
	addq.w	#1,d5
	mulu.w	minfo_TY(a4),d5
	sub.w	d3,d5
	sub.w	minfo_MXP(a4),d4	; Get screen relative co-ord.
	addq.w	#1,d4
	mulu.w	minfo_TX(a4),d4
	sub.w	d2,d4
.GotDims:
	tst.w	d4
	bgt.s	.WOK
	add.w	minfo_TX(a4),d2
	sub.w	minfo_TX(a4),d4
	sub.w	minfo_TX(a4),d4
.WOK:
	tst.w	d5
	bgt.s	.HOK
	add.w	minfo_TY(a4),d3
	sub.w	minfo_TY(a4),d5
	sub.w	minfo_TY(a4),d5
.HOK:
	move.w	minfo_Flags(a4),d6	; Get flags.
	cmp.w	minfo_OSX(a4),d2	; Are x co-ords the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSY(a4),d3	; Are y co-ords the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSW(a4),d4	; Are widths the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSH(a4),d5	; Are heights the same.
	beq.s	.IsDrawn		; Yes, see if we need draw anything.
.CursMoved:
	btst	#MIFB_CDRAWN,d6		; Is there a cursor on the display?
	beq.s	.NoCursor		; No, then we won't remove it.
	jsr	DrawCursor		; Else, remove cursor.
	andi.w	#(~MIFF_CDRAWN),minfo_Flags(a4)	; And clear flag.
.NoCursor:
	moveq	#0,d0
	CALLINT		LockIBase	; Lock-out intuition.
	move.l	ib_ActiveWindow(a6),a2	; Get Active window.
	move.l	d0,a0
	CALLINT		UnlockIBase	; Unlock intuition base.
	cmpa.l	minfo_MapWindow(a4),a2	; Is mouse in Map Window?
	bne.s	.WrongScreen		; No, then branch.
	move.w	d2,minfo_OSX(a4)	; OSX = NSX.
	move.w	d3,minfo_OSY(a4)	; OSY = NSY.
	move.w	d4,minfo_OSW(a4)	; OSW = NSW.
	move.w	d5,minfo_OSH(a4)	; OSH = NSH.
.IsDrawn:
	move.w	minfo_Flags(a4),d6	; Get updated copy of flags.
	btst	#MIFB_CDRAWN,d6		; Is cursor drawn?
	bne.s	.Exit			; Yes, then don't redraw same cursor.
	moveq	#0,d0
	CALLINT		LockIBase	; Lock-out intuition.
	move.l	ib_ActiveWindow(a6),a2	; Get Active window.
	move.l	d0,a0
	CALLINT		UnlockIBase	; Unlock intuition base.
	cmpa.l	minfo_MapWindow(a4),a2	; Is mouse in Map Window?
	bne.s	.WrongScreen		; No, then branch.
	jsr	DrawCursor		; Else, draw cursor.
	ori.w	#MIFF_CDRAWN,minfo_Flags(a4)	; And set flag.
.JustCoords:
	move.w	minfo_CXP(a4),d0	; Get cursor x value.
	move.w	#300,d1			; Set desination co-ords...
	move.w	#53,d2
	jsr	PrintInteger		; Print the value.
	move.w	minfo_CYP(a4),d0	; Get cursor y value.
	move.w	#372,d1			; Set desination co-ords...
	move.w	#53,d2
	jsr	PrintInteger		; Print the value.
	bra.s	.Exit
.WrongScreen:
	move.w	#300,d0			; Setup co-ords...
	move.w	#53,d1
	jsr	ClearText		; Clear CXP field.
	move.w	#372,d0			; Setup co-ords...
	move.w	#53,d1
	jsr	ClearText		; Clear CYP field.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall old registers.
	rts

SortCorners:		; This uses a5 stack frame from caller.
	movem.l	d0-3,-(sp)	; Save regs.
	move.w	-4(a5),d0
	move.w	-8(a5),d1
	move.w	-12(a5),d2
	move.w	-16(a5),d3	; Get all co-ords.
	cmp.w	d0,d2
	bgt.s	.XOK		; Branch if they're ok.
	exg.l	d0,d2		; Else swap 'em!
.XOK:
	cmp.w	d1,d3
	bgt.s	.YOK		; Branch if they're ok.
	exg.l	d1,d3		; Else swap 'em!
.YOK:
	move.w	d0,-4(a5)	; Put co-ord back in correct order...
	move.w	d1,-8(a5)
	move.w	d2,-12(a5)
	move.w	d3,-16(a5)
	movem.l	(sp)+,d0-3	; Recall regs.
	rts	

GrabBlock:				; Uses a5 stack frame from above.
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_Map(a2),a0	; Map base.
	move.w	-8(a5),d0
	mulu.w	minfo_MX(a2),d0
	move.w	-4(a5),d1
	swap	d1			; Clear hi WORD...
	clr.w	d1
	swap	d1
	add.l	d1,d0
	lsl.l	#1,d0
	adda.l	d0,a0			; Add offset to Map base.
	move.w	minfo_MX(a2),d3		; Calculate modulo...
	sub.w	minfo_BX(a2),d3
	mulu.w	#2,d3			; Doubles value + clears hi word.
	move.l	minfo_Block(a2),a1	; Get Block base.
	move.w	minfo_BY(a2),d1
	subq.w	#1,d1			; Setup Y loop.
.YLoop:
	move.w	minfo_BX(a2),d0
	subq	#1,d0			; Setup X loop.
.XLoop:
	move.w	(a0)+,(a1)+		; Copy WORD from map to block.
	dbra	d0,.XLoop		; Loop for BX...
	adda.l	d3,a0			; Add modulo to map ptr.
	dbra	d1,.YLoop		; Loop for BY...
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

ScrollUp:
	move.l	_MapInfoBase,a0
	move.w	minfo_Flags(a0),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit			; No, then we can't scroll it!
	tst.w	minfo_MYP(a0)
	beq.s	.Exit			; Exit if we're right up.
	subq.w	#1,minfo_MYP(a0)	; Else, scroll the map.
	bsr	MoveMap
.Exit:
	rts

ScrollLeft:
	move.l	_MapInfoBase,a0
	move.w	minfo_Flags(a0),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit			; No, then we can't scroll it!
	tst.w	minfo_MXP(a0)
	beq.s	.Exit			; Exit if we're fully left.
	subq.w	#1,minfo_MXP(a0)	; Else, scroll the map.
	bsr	MoveMap
.Exit:
	rts

ScrollDown:
	move.l	_MapInfoBase,a0
	move.w	minfo_Flags(a0),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit			; No, then we can't scroll it!
	move.l	EditHeight,d0
	divu.w	minfo_TY(a0),d0
	move.w	minfo_MY(a0),d1
	sub.w	d0,d1
	cmp.w	minfo_MYP(a0),d1	; Are we fully down?
	ble.s	.Exit			; Yes, then don't scroll.
	addq.w	#1,minfo_MYP(a0)	; Else, scroll the map.
	bsr	MoveMap
.Exit:
	rts

ScrollRight:
	move.l	_MapInfoBase,a0
	move.w	minfo_Flags(a0),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit			; No, then we can't scroll it!
	moveq	#0,d0
	move.w	minfo_MRasX(a0),d0
	divu.w	minfo_TX(a0),d0
	move.w	minfo_MX(a0),d1
	sub.w	d0,d1
	cmp.w	minfo_MXP(a0),d1	; Are we fully right?
	ble.s	.Exit			; Yes, then don't scroll.
	addq.w	#1,minfo_MXP(a0)	; Else, scroll the map.
	bsr	MoveMap
.Exit:
	rts

GetTilesBlock:
	link	a5,#-16			; Allocate some local vars.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d7
	btst	#MIFB_MAP,d7		; There must be a map to do this.
	beq	.Exit			; So, exit if there isn't one.
	bsr	BlockCleanup		; Erase old block.
	btst	#MIFB_CDRAWN,d7		;  We must make sure we remove the
	beq.s	.NoMapCursor		; maps cursor before we start.
	jsr	DrawCursor
	andi.w	#(~MIFF_CDRAWN),minfo_Flags(a2)	; Clear flag.
.NoMapCursor:
	bsr	ShowTiles		; Put up tiles screen.
	tst.l	d0
	beq	.Exit			; Exit fail if no tiles screen.
	move.l	minfo_TilesScreen(a2),a0
	CALLINT		ScreenToFront	; Reveal screen.
	move.l	minfo_TilesWindow(a2),a0
	CALLINT		ActivateWindow	; Make sure window is active!
	move.l	minfo_TilesWindow(a2),a0
	lea	BlankPointer,a1	; Mouse pointer image.
	moveq	#1,d0
	moveq	#16,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Install blank pointer.
	bsr	TileElasticBox
	move.l	d0,d7
	move.l	minfo_TilesWindow(a2),a0
	CALLINT		ClearPointer	; Get rid of blank pointer.
	move.l	minfo_TilesScreen(a2),a0
	CALLINT		ScreenToBack	; Hide screen.
	bsr	HideTiles		; Ged rid of tiles screen.
	tst.l	d7
	beq.s	.Exit			; Exit if user aborted during define.
	bsr	SortCorners		; Get co-ords correct.
	move.w	-12(a5),d0
	move.w	-4(a5),d2
	sub.w	d2,d0
	addq.w	#1,d0			; Calculate Block width.
	move.w	d0,minfo_BX(a2)
	move.w	-16(a5),d1
	move.w	-8(a5),d2
	sub.w	d2,d1
	addq.w	#1,d1			; Calculate Block height.
	move.w	d1,minfo_BY(a2)
	mulu.w	d1,d0
	lsl.l	#1,d0			; Calculate block size.
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate block array.
	move.l	d0,minfo_Block(a2)
	beq.s	.Failure		; Exit if allocation failed.
	moveq	#0,d0			; Calculate 1st tile...
	move.w	minfo_TRasX(a2),d0
	divu.w	minfo_TX(a2),d0
	mulu.w	-8(a5),d0
	add.w	-4(a5),d0
	bsr	BuildBlock		; Fill the block array.
	ori.w	#(MIFF_BLOCK!MIFF_MODE),minfo_Flags(a2)
	bra.s	.Exit
.Failure:
	bsr	NoMemFail		; Display failure message.
.Exit:
	unlk	a5			; Free local variables.
	bsr	DisplayStatus		; Update display.
	rts

TileElasticBox:			  ; Added V2.1 Enhancement.  22/12/92
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	moveq	#0,d7
	move.l	_MapInfoBase,a4
	move.l	#TBLKIDCMP,d0
	move.l	minfo_TilesWindow(a4),a0
	CALLINT		ModifyIDCMP	; Setup IDCMP for tiles.
.Loop:
	move.l	minfo_TilesWindow(a4),a3
	move.l	wd_UserPort(a3),a0
	CALLEXEC	WaitPort	; Wait for users input.
.WhileMessages:
	move.l	wd_UserPort(a3),a0
	CALLEXEC	GetMsg		; Get message from port.
	tst.l	d0
	beq.s	.Loop			; Loop if there was no message...
	move.l	d0,a0
	bsr	ExtractData		; Make copy of input.
	move.l	InputClass,d0		; Get class of input.
	cmpi.l	#MOUSEMOVE,d0		; Was it a mouse movement?
	bne.s	.TryKeys		; No, check the keyboard.
	bsr	TileBoxMove		; Else, handle the users input.
	bra.s	.WhileMessages		; And loop for next message...
.TryKeys:
	cmpi.l	#RAWKEY,d0		; Was it a keyboard stroke?
	bne.s	.TryMouse		; No, check the mouse buttons.
	bsr.s	TileBoxKeys		; Else, handle the users input.
	tst.l	d0			; If user didn't abort,
	bne.s	.WhileMessages		; loop for next message...
	moveq	#0,d7
	bra.s	.Return			; Else, tell client we're quitting.
.TryMouse:
	cmpi.l	#MOUSEBUTTONS,d0	; Was it a mouse button?
	bne.s	.WhileMessages		; No, then we're not interested!
	move.w	InputCode,d0		; Else, get more info.
	cmpi.w	#SELECTDOWN,d0		; Was it the left button pressed?
	bne.s	.WhileMessages		; No, then again, we don't worry.
	bsr.s	TileBoxCorner		; Else, set which ever corner!
	tst.l	d0
	bne.s	.WhileMessages		; Loop if we're not done...
	moveq	#1,d7			; Else, tell client to grab block.
.Return:
	moveq	#0,d0
	move.l	minfo_TilesWindow(a4),a0	; Get ptr to tiles window.
	CALLINT		ModifyIDCMP	; Disable input port.
	move.w	minfo_Flags(a4),d6
	btst	#MIFB_CDRAWN,d6		;  We must make sure we remove the
	beq.s	.NoCursor		; cursor before we exit.
	jsr	DrawTleCursor
	andi.w	#(~MIFF_CDRAWN),minfo_Flags(a4)	; Clear flag.
	move.l	d7,d0
.NoCursor:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

TileBoxKeys:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.w	InputCode,d0		; Get RAWKEY code.
	cmpi.w	#$45,d0			; Escape?
	bne.s	.Left			; No, then check left.
	moveq	#0,d0
	bra.s	.Return			; Else, return NULL.
.Left:
	cmpi.w	#$4f,d0			; Left?
	bne.s	.Right			; No, then check right.
	bsr	TScrollLeft		; Else, move Tiles.
	bra.s	.KeysDone
.Right:
	cmpi.w	#$4e,d0			; Right?
	bne.s	.Up			; No, then check up.
	bsr	TScrollRight		; Else, move Tiles.
	bra.s	.KeysDone
.Up:
	cmpi.w	#$4c,d0			; Up?
	bne.s	.Down			; No, then check down.
	bsr	TScrollUp		; Else, move Tiles.
	bra.s	.KeysDone
.Down:
	cmpi.w	#$4d,d0			; Down?
	bne.s	.KeysDone		; No, then check exit.
	bsr	TScrollDown		; Else, move Tiles.
.KeysDone:
	moveq	#1,d0			; Set continue return.
.Return:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

TileBoxCorner:
	tst.l	d7		; How's the hit flag?
	bne.s	.LastSet	; Branch if we've got top-left.
	move.w	minfo_CXP(a4),-4(a5)	; Store X co-ord.
	move.w	minfo_CYP(a4),-8(a5)	; And the Y co-ord.
	moveq	#1,d7		; Setup hit flag for next time.
	moveq	#1,d0		; And tell main to continue.
	bra.s	.Return
.LastSet:
	move.w	minfo_CXP(a4),-12(a5)	; Store X co-ord.
	move.w	minfo_CYP(a4),-16(a5)	; And the Y co-ord.
	moveq	#0,d0		; And tell main we're done
.Return:
	rts

TileBoxMove:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a4		; Get pointer to data.
	move.l	minfo_TilesWindow(a4),a1   ; Get ptr to layer structure...
	move.l	wd_RPort(a1),a1
	move.l	rp_Layer(a1),a1
	lea	CurrInput,a0		; Pointer to input message.
	moveq	#0,d0
	move.w	im_MouseX(a0),d0	; Get x co-ord of mouse.
	add.w	lr_Scroll_X(a1),d0	; Add layer offset.
	divu.w	minfo_TX(a4),d0		; Get curs co-ord for screen.
	move.l	d0,-(sp)		; Save this for later.
	move.w	d0,minfo_CXP(a4)	; = CXP.
	moveq	#0,d0
	move.w	im_MouseY(a0),d0	; Get y co-ord of mouse.
	add.w	lr_Scroll_Y(a1),d0	; Add layer offset.
	divu.w	minfo_TY(a4),d0		; Get curs co-ord for screen.
	move.l	d0,-(sp)		; Save this for later.
	move.w	d0,minfo_CYP(a4)	; = CYP.
	tst.l	d7			; Check hit flag.
	bne.s	.LastSet		; We only want to move BR corner.
	move.l	(sp)+,d3		; Recall  ( MouseY / TY )
	mulu.w	minfo_TY(a4),d3		; Calculate on-screen co-ord of CYP.
	move.l	(sp)+,d2		; Recall  ( MouseX / TX )
	mulu.w	minfo_TX(a4),d2		; Calculate on-screen co-ord of CXP.
	move.w	minfo_TX(a4),d4		; Get width of 1 tile.
	move.w	minfo_TY(a4),d5		; And height of 1 tile.
	bra.s	.GotDims
.LastSet:
	move.w	-4(a5),d2		; Calculate x start...
	mulu.w	minfo_TX(a4),d2
	move.w	-8(a5),d3		; Calculate y start...
	mulu.w	minfo_TY(a4),d3
	move.l	(sp)+,d5		; Get (MouseY / TY)
	addq.w	#1,d5
	mulu.w	minfo_TY(a4),d5
	sub.w	d3,d5
	move.l	(sp)+,d4		; Get (MouseX / TX)
	addq.w	#1,d4
	mulu.w	minfo_TX(a4),d4
	sub.w	d2,d4
.GotDims:
	tst.w	d4
	bgt.s	.WOK
	add.w	minfo_TX(a4),d2
	sub.w	minfo_TX(a4),d4
	sub.w	minfo_TX(a4),d4
.WOK:
	tst.w	d5
	bgt.s	.HOK
	add.w	minfo_TY(a4),d3
	sub.w	minfo_TY(a4),d5
	sub.w	minfo_TY(a4),d5
.HOK:
	move.w	minfo_Flags(a4),d6	; Get flags.
	cmp.w	minfo_OSX(a4),d2	; Are x co-ords the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSY(a4),d3	; Are y co-ords the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSW(a4),d4	; Are widths the same.
	bne.s	.CursMoved		; No, then we need to update display.
	cmp.w	minfo_OSH(a4),d5	; Are heights the same.
	beq.s	.IsDrawn		; Yes, see if we need draw anything.
.CursMoved:
	btst	#MIFB_CDRAWN,d6		; Is there a cursor on the display?
	beq.s	.NoCursor		; No, then we won't remove it.
	jsr	DrawTleCursor		; Else, remove cursor.
	andi.w	#(~MIFF_CDRAWN),minfo_Flags(a4)	; And clear flag.
.NoCursor:
	move.w	d2,minfo_OSX(a4)	; OSX = NSX.
	move.w	d3,minfo_OSY(a4)	; OSY = NSY.
	move.w	d4,minfo_OSW(a4)	; OSW = NSW.
	move.w	d5,minfo_OSH(a4)	; OSH = NSH.
.IsDrawn:
	move.w	minfo_Flags(a4),d6	; Get updated copy of flags.
	btst	#MIFB_CDRAWN,d6		; Is cursor drawn?
	bne.s	.Exit			; Yes, then don't redraw same cursor.
	jsr	DrawTleCursor		; Else, draw cursor.
	ori.w	#MIFF_CDRAWN,minfo_Flags(a4)	; And set flag.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall old registers.
	rts

BuildBlock:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	moveq	#0,d3			; Calculate modulo...
	move.w	minfo_TRasX(a2),d3
	divu.w	minfo_TX(a2),d3
	sub.w	minfo_BX(a2),d3
	move.w	minfo_BY(a2),d2		; d2 = Y loop control.
	subq.w	#1,d2			; Adjustment for dbra.
	move.l	minfo_Block(a2),a0	; Get block base.
.YLoop:
	move.w	minfo_BX(a2),d1		; d1 = X loop control.
	subq.w	#1,d1			; Adjustment for dbra.
.XLoop:
	move.w	d0,(a0)+		; Write in tile number.
	addq.w	#1,d0			; Advance tile number.
	dbra	d1,.XLoop		; Loop for BX...
	add.w	d3,d0			; Add modulo onto tile number.
	dbra	d2,.YLoop		; Loop for BY...
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

DrawTleCursor:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.l	minfo_TilesWindow(a2),a1
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

FilledBox:
	link	a5,#-16			; Allocate local vars.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; There must be a map to do this.
	beq	.NoMapExit		; So, exit if there isn't one.
	move.l	minfo_StatusWindow(a2),a0
	move.l	#(MOUSEMOVE!GADGETUP!RAWKEY),d0
	move.l	_InputPort,wd_UserPort(a0)	; Install port.
	CALLINT		ModifyIDCMP		; Enable inputs.
	move.l	minfo_MapWindow(a2),a0
	move.l	#(MOUSEMOVE!RAWKEY!MOUSEBUTTONS),d0
	move.l	_InputPort,wd_UserPort(a0)	; Install port.
	CALLINT		ModifyIDCMP		; Enable inputs.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearPointer		; Clear BUSY! pointer.
	move.l	minfo_MapWindow(a2),a0
	lea	BlankPointer,a1		; NULL sprite struct.
	moveq	#1,d0
	moveq	#16,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Set mouse pointer to a clear image.
	bsr	BlitCTile		; Display current tile image.
	ori.w	#MIFF_BSELECT,minfo_Flags(a2)	; Set "Selecting Block" flag.
	bsr	SetPens			; Setup status RPort.
	move.l	minfo_StatusWindow(a2),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,-(sp)		; Save this.
	move.w	#60,d0
	move.w	#32,d1
	CALLGRAF	Move		; Move gfx cursor.
	move.l	(sp),a1			; Recall Rastport ptr.
	lea	BlockStr,a0
	moveq	#5,d0
	CALLGRAF	Text		; Write mode text.
	move.l	(sp),a1			; Recall Rastport ptr.
	move.w	#60,d0			; Size co-ords...
	move.w	#53,d1
	CALLGRAF	Move		; Move gfx cursor.
	lea	FillStr,a0
	move.l	(sp)+,a1		; Recall Rastport ptr.
	moveq	#5,d0
	CALLGRAF	Text		; Write "Fill" text.
	bsr	MapElasticBox		; Get block size & co-ords
	tst.l	d0
	beq.s	.Exit			; Don't get block if user aborted!
	bsr	SortCorners		; Else, make sure of corners.
	move.l	minfo_Map(a2),a0	; Get map base.
	move.w	-8(a5),d0		; Calculate starting offset...
	mulu.w	minfo_MX(a2),d0
	move.w	-4(a5),d1
	ext.l	d1
	add.l	d1,d0
	lsl.l	#1,d0
	adda.l	d0,a0			; Add offset to map base.
	move.w	-12(a5),d0		; Calculate Box width...
	sub.w	-4(a5),d0
	move.w	-16(a5),d1		; Calculate Block height...
	sub.w	-8(a5),d1
	move.w	minfo_CTile(a2),d2	; Get fill value.
	move.w	minfo_MX(a2),d3		; Calculate modulo...
	sub.w	d0,d3
	subq.w	#1,d3			; Width is -1 for dbra, so we -1 mod.
	mulu.w	#2,d3
.RowLoop:
	move.w	d0,d4			; Get copy of width.
.ColLoop:
	move.w	d2,(a0)+		; Write next map position.
	dbra	d4,.ColLoop		; Loop for box width...
	adda.l	d3,a0			; Add modulo.
	dbra	d1,.RowLoop		; Loop for height...
	ori.w	#MIFF_CHANGED,minfo_Flags(a2)	; Set changed bit.
	jsr	DrawMapSection		; Display change.
.Exit:
	andi.w	#~MIFF_BSELECT,minfo_Flags(a2)	; Clr "Selecting Block" flag.
	CALLEXEC	Forbid		; Aaarrgh!!
	bsr	ClearPort		; Reply to all messages at our port.
	move.l	minfo_StatusWindow(a2),a0
	moveq	#0,d0
	move.l	d0,wd_UserPort(a0)	; Don't let intuition touch our port.
	CALLINT		ModifyIDCMP	; Turn off inputs for status window.
	move.l	minfo_MapWindow(a2),a0
	moveq	#0,d0
	move.l	d0,wd_UserPort(a0)	; Don't let intuition touch our port.
	CALLINT		ModifyIDCMP	; Turn off inputs for map window.
	CALLEXEC	Permit		; Ah!
	move.l	minfo_StatusWindow(a2),a0
	lea	BusyPointer,a1
	moveq	#22,d0
	moveq	#1,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Reinstate BUSY! mouse ptr.
	move.l	minfo_MapWindow(a2),a0
	lea	BusyPointer,a1
	moveq	#22,d0
	moveq	#1,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Reinstate BUSY! mouse ptr.
.NoMapExit:
	unlk	a5			; Free local variables.
	jsr	DisplayStatus		; Print info about block.
	rts

	section	ProgStuff,data
;  These are the strings used to display block grab, and filled box modes...

GrabStr:
	dc.b	"GRAB "		; Displayed when grabbing map block.
	even
FillStr:
	dc.b	"FILL "		; Displayed when in block fill mode.
	even

	end
