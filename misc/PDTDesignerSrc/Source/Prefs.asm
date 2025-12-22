	opt	c+,d+,l+,o+,i+
	incdir	sys:include/
	include	graphics/graphics_lib.i
	include	intuition/intuition_lib.i
	include	intuition/intuition.i
	include	workbench/workbench.i
	include	workbench/icon_lib.i

	include	MapDesignerV2.0:Source/MapDesignerV2.i	; Custom include!

	output	MapDesignerV2.0:Modules/PrefsModule.o

;   This file contains the following routines...

	xdef	StartPaint,EndPaint,ChangePaint,ChangeIncTiles
	xdef	ChangeIcon,SaveIcon,ToggleWBench,ChangePalette

;   This file makes the following external references...

	xref	_MapInfoBase,_IntuitionBase,PlaceTile,Prefs.1,Prefs.2,Prefs.3
	xref	DisplayTileStatus,ASCIITemp,_IconBase,DesignerMenus,Prefs.4
	xref	DialogueBox,_PaletteRequester,_GfxBase,StatusFont

	xref	ReadOpenFail,WriteOpenFail,ReadDataFail,WriteDataFail
	xref	NoMemFail,NotMapFail,NoTilesFail,NotIFFFail,NotILBMFail
	xref	BadIFFFail,OpenWBFail,CloseWBFail,IconFail,TileScreenFail
	xref	FileReqFail,EditScreenFail,PaletteReqFail,AboutText

	section	Program,code

StartPaint:
	move.l	_MapInfoBase,a0
	ori.w	#MIFF_BDOWN,minfo_Flags(a0)	; Set button down flag.
	bsr	PlaceTile			; Start painting!
	bsr	DisplayTileStatus	
	rts

EndPaint:
	move.l	_MapInfoBase,a0
	andi.w	#(~MIFF_BDOWN),minfo_Flags(a0)	; Clear button down flag.
	bsr	DisplayTileStatus	
	rts

ChangePaint:
	movem.l	d0-7/a0-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_MAP,d2		; There needs to be a map.
	beq.s	.Exit			; So exit if there isn't one!
	bset	#MIFB_CHANGED,d2	; Because state is saved.
	bchg	#MIFB_PAINT,d2		; Swap mode.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearMenuStrip	; Remove menus from window.
	lea	Prefs.1,a1		; Get Paint menu item.
	btst	#MIFB_PAINT,d2		; Is paint mode on?
	beq.s	.ClearCheck		; No, then remove check mark.
	ori.w	#CHECKED,mi_Flags(a1)	; Else, attatch check mark.
	bra.s	.Done
.ClearCheck:
	andi.w	#(~CHECKED),mi_Flags(a1)	; Clear check mark.
.Done:
	move.w	d2,minfo_Flags(a2)	; Install new flag settings.
	move.l	minfo_StatusWindow(a2),a0
	lea	DesignerMenus,a1
	CALLINT		SetMenuStrip	; Attatch adjusted menus to window.	
.Exit:
	bsr	DisplayTileStatus
	movem.l	(sp)+,d0-7/a0-6		; Recall regs.
	rts

ChangeIncTiles:
	movem.l	d0-7/a0-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_MAP,d2		; There needs to be a map.
	beq.s	.Exit			; So exit if there isn't one!
	bset	#MIFB_CHANGED,d2	; Because state is saved.
	bchg	#MIFB_INCTILES,d2	; Swap mode.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearMenuStrip	; Remove menus from window.
	lea	Prefs.2,a1		; Get Inc Tiles menu item.
	btst	#MIFB_INCTILES,d2	; Is mode on?
	beq.s	.ClearCheck		; No, then remove check mark.
	ori.w	#CHECKED,mi_Flags(a1)	; Else, attatch check mark.
	bra.s	.Done
.ClearCheck:
	andi.w	#(~CHECKED),mi_Flags(a1)	; Clear check mark.
.Done:
	move.w	d2,minfo_Flags(a2)	; Install new flag settings.
	move.l	minfo_StatusWindow(a2),a0
	lea	DesignerMenus,a1
	CALLINT		SetMenuStrip	; Attatch adjusted menus to window.	
.Exit:
	movem.l	(sp)+,d0-7/a0-6		; Recall regs.
	rts

ChangeIcon:
	movem.l	d0-7/a0-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2
	btst	#MIFB_MAP,d2		; There needs to be a map.
	beq.s	.Exit			; So exit if there isn't one!
	bset	#MIFB_CHANGED,d2	; Because state is saved.
	bchg	#MIFB_ICON,d2		; Swap mode.
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearMenuStrip	; Remove menus from window.
	lea	Prefs.3,a1		; Get Icon menu item.
	btst	#MIFB_ICON,d2		; Is mode on?
	beq.s	.ClearCheck		; No, then remove check mark.
	ori.w	#CHECKED,mi_Flags(a1)	; Else, attatch check mark.
	bra.s	.Done
.ClearCheck:
	andi.w	#(~CHECKED),mi_Flags(a1)	; Clear check mark.
.Done:
	move.w	d2,minfo_Flags(a2)	; Install new flag settings.
	move.l	minfo_StatusWindow(a2),a0
	lea	DesignerMenus,a1
	CALLINT		SetMenuStrip	; Attatch adjusted menus to window.	
.Exit:
	movem.l	(sp)+,d0-7/a0-6		; Recall regs.
	rts

;   The following checks the status of the ICON flag and then creates an icon
; for the filename supplied if one is required, else, we just exit.

SaveIcon:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d2	; Get flags.
	btst	#MIFB_ICON,d2		; Do we need to create an icon?
	beq.s	.GotIcon		; No, then exit!
	lea	ASCIITemp,a1
.CopyLoop:
	move.b	(a0)+,(a1)+		; Copy filespec...
	bne.s	.CopyLoop
	lea	ASCIITemp,a0
	lea	V2MapIcon,a1
	CALLICON	PutDiskObject	; Write out the disk object.
	tst.l	d0
	bne.s	.GotIcon
	bsr	IconFail		; Display error.
.GotIcon:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

ToggleWBench:
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ClearMenuStrip	; Remove menus from window.
	lea	Prefs.4,a3		; Get Create WBench menu item.
	move.w	mi_Flags(a3),d0		; Get flags.
	andi.w	#CHECKED,d0		; Is WBench assumed open?
	bne.s	.NoWBench		; No, then attempt to open it.
	CALLINT		CloseWorkBench	; Else, close Workbench screen
	tst.l	d0
	beq.s	.Fail			; Operation failed, swap flags.
	andi.w	#(~CHECKED),mi_Flags(a3)   ; Else, set WBench as closed.
	bra.s	.Exit
.NoWBench:
	CALLINT		OpenWorkBench	; Open Workbench screen
	tst.l	d0
	beq.s	.Fail2			; Operation failed, leave flags.
	ori.w	#CHECKED,mi_Flags(a3)	; Else, set WBench as open.
	bra.s	.Exit
.Fail2:
	bsr	OpenWBFail		; Display failure messages...
	bra.s	.Swap
.Fail:
	bsr	CloseWBFail
.Swap:
	eori.w	#CHECKED,mi_Flags(a3)	; Toggle state of flag.
.Exit:
	move.l	minfo_StatusWindow(a2),a0
	lea	DesignerMenus,a1
	CALLINT		SetMenuStrip	; Attatch adjusted menus to window.
	rts

ChangePalette:
	move.l	_MapInfoBase,a0
	move.w	minfo_Flags(a0),d0
	btst	#MIFB_MAP,d0		; There needs to be a map.
	beq	.Exit			; So exit if there isn't one.
	lea	PaletteScreen,a0
	CALLINT		OpenScreen	; Open screen for requester.
	tst.l	d0			; Exit if open failed.
	beq	.ReqFail
	move.l	d0,a2
	move.l	_MapInfoBase,a3
	move.l	minfo_MapScreen(a3),a0
	CALLINT		ScreenToFront	; Reset display.
	move.l	a2,a0
	move.l	minfo_MapScreen(a3),a1	; Else, get viewport to change...
	lea	sc_ViewPort(a1),a1
	jsr	_PaletteRequester	; And then open the requester.
	move.l	d0,d2
	move.l	a2,a0
	CALLINT		CloseScreen	; Close the palette screen.
	move.l	minfo_StatusWindow(a3),a0
	CALLINT		ActivateWindow	; Activate main display.
	tst.l	d2
	bmi.s	.ReqFail		; Exit if requester failed.
	bne.s	.Exit			; Exit if user canceled.
	ori.w	#MIFF_CHANGED,minfo_Flags(a3)	; Else, set changed bit.
	move.w	minfo_Depth(a3),d1
	moveq	#1,d7
	lsl.w	d1,d7			; Calculate number of colours...
	cmpi.w	#32,d7			; 32 is max.
	ble.s	.ColsOK			; So branch if value is Okay.
	move.w	#32,d7			; Else, install max value.
.ColsOK:
	subq.w	#1,d7			; dbra adjustment.
	ext.l	d7
	move.l	minfo_MapScreen(a3),a4
	lea	sc_ViewPort(a4),a4
	move.l	vp_ColorMap(a4),a4	; Get source color map.
	move.l	minfo_TilesPort(a3),a5
	move.l	vp_ColorMap(a5),a5	; Get destination color map.
.SetColsLoop:
	move.l	a4,a0
	move.l	d7,d0
	CALLGRAF	GetRGB4		; Get next color entry.
	move.l	a5,a0
	andi.w	#$fff,d0
	move.w	d0,d1			; Extract red bits...
	lsr.w	#8,d1
	move.w	d0,d2			; Extract blue bits...
	lsr.w	#4,d2
	andi.w	#$f,d2
	move.w	d0,d3
	andi.w	#$f,d3
	move.l	d7,d0			; Get entry number.
	CALLGRAF	SetRGB4CM	; Set colour value for color map.
	dbra	d7,.SetColsLoop
	bra.s	.Exit
.ReqFail:
	bsr	PaletteReqFail		; Display failure message.
.Exit:
	rts


	section	ProgStuff,data
;   This is the new screen that is opened for the palette requester...

PaletteScreen:
	dc.w	0,0,320,67,5
	dc.b	1,0
	dc.w	0,CUSTOMSCREEN
	dc.l	StatusFont,0,0,0

;   This is the data for the `V2 MAP' icon...

V2MapIcon:
	dc.w	WB_DISKMAGIC,WB_DISKVERSION
	  dc.l	0
	  dc.w	0,0,80,24,(GADGIMAGE!GADGHCOMP),(GADGIMMEDIATE!RELVERIFY)
	  dc.w	BOOLGADGET
	  dc.l	MapIconImage,0,0,0,0
	  dc.w	0
	  dc.l	0
	dc.b	WBPROJECT
	dc.l	ToolString,0
	dc.l	NO_ICON_POSITION,NO_ICON_POSITION
	dc.l	0,0,0

MapIconImage:
	dc.w	0,0,80,23,2
	dc.l	IconImageData
	dc.b	3,0
	dc.l	0
ToolString:
	dc.b	"DesignerV2:TheDesigner",0
	even

	section	ChipStuff,data_c

;   This file contains the 2 bitplanes used when creating an icon for a map
; file...

IconImageData:
	incbin	MapDesignerV2.0:GfxData/IconGfx.raw
	even
	end
