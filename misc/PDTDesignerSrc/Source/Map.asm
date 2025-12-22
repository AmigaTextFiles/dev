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

	output	MapDesignerV2.0:Modules/MapModule.o

;   This file rontains the following routines...

	xdef	ClearMap,SetMapSize,GetInitialSize,BuildNewMap,SetHiRes
	xdef	SetLoRes,SaveRawMap,WriteMap,DiscardMap

;   This file makes the following external references...

	xref	_MapInfoBase,_IntuitionBase,_GfxBase,_DOSBase,_InputPort
	xref	CurrInput,InputClass,ASCIITemp
	xref	CheckSaved,OpenMapScreen,DrawMapSection
	xref	DialogueBox,DisplayMapStatus,StuffChar,ExtractData
	xref	CheckPos,_FileRequester,BlankDial,PromptDial
	xref	ClearPort,BusyPointer,BlockCleanup,MapCleanup,DisplayStatus

	xref	ReadOpenFail,WriteOpenFail,ReadDataFail,WriteDataFail
	xref	NoMemFail,NotMapFail,NoTilesFail,NotIFFFail,NotILBMFail
	xref	BadIFFFail,OpenWBFail,CloseWBFail,IconFail,TileScreenFail
	xref	FileReqFail,EditScreenFail,PaletteReqFail,AboutText
	xref	MapReqFail,Map.3.2

	section	Program,code
ClearMap:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit			; No, then we can't clear it!
	bsr	CheckSaved		; Make sure it's ok to do it.
	tst.l	d0
	beq.s	.Exit			; Exit if it's not.
	move.w	minfo_MX(a2),d0
	mulu.w	minfo_MY(a2),d0		; = Number of WORDs in map array.
	move.l	minfo_Map(a2),a0	; Get base of array.
	move.w	minfo_CTile(a2),d1	; And tile to clear it to.
.ClearLoop:
	move.w	d1,(a0)+		; Clear WORD and advance pointer.
	subq.l	#1,d0			; Do it for whole array...
	bne.s	.ClearLoop
	ori.w	#MIFF_CHANGED,minfo_Flags(a2)	; Set the changed flag.
	bsr	DrawMapSection		; Update map screen.
.Exit:
	rts

DiscardMap:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit			; No, then we can't free it!
	bsr	CheckSaved		; Make sure it's ok to do it.
	tst.l	d0
	beq.s	.Exit			; Exit if it's not.
	bsr	BlockCleanup
	bsr	MapCleanup
	bsr	DisplayStatus
	ori.w	#MIFF_CHANGED,minfo_Flags(a2)	; Set map changed flag.
.Exit:
	rts

SetMapSize:
	move.l	_MapInfoBase,a4
	move.l	minfo_StatusWindow(a4),a0
	move.l	#GADGETUP,d0			; Inputs for requester.
	move.l	_InputPort,wd_UserPort(a0)	; Install port.
	CALLINT		ModifyIDCMP		; Enable inputs.
	move.l	minfo_StatusWindow(a4),a0
	CALLINT		ClearPointer		; Clear BUSY! pointer.
	move.w	minfo_Flags(a4),d7	; Get flags.
	btst	#MIFB_TILES,d7		; There must be tiles to define a map.
	beq.s	.Exit			; So exit if there are none loaded.
	btst	#MIFB_MAP,d7		; If there is already a map defined,
	bne.s	.ExtendIt		; we want to extend it.
	bsr	GetInitialSize		; Else, get dimensions from user.
	tst.l	d0			; Check return.
	beq.s	.Failed			; Display error if requester failed.
	bmi.s	.Exit			; Exit if user canceled.
	move.w	minfo_NX(a4),d0		; Calculate, ( ( NX * NY ) * 2 ).
	mulu.w	minfo_NY(a4),d0
	lsl.l	#1,d0
	ble.s	.Exit			; If map size is <=0 then we cancel.
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate map memory.
	move.l	d0,minfo_Map(a4)	; Store map pointer.
	beq.s	.Failed			; Display error if allocation failed.
	move.w	minfo_NX(a4),minfo_MX(a4)	; Else, install size...
	move.w	minfo_NY(a4),minfo_MY(a4)
	clr.w	minfo_MXP(a4)		; Set position to top-left...
	clr.w	minfo_MYP(a4)
	ori.w	#(MIFF_MAP!MIFF_CHANGED),minfo_Flags(a4)  ; Update flags.
	bsr	OpenMapScreen		; Open map display.
	bra.s	.Exit
.ExtendIt:
	bsr	CheckSaved		; Is it ok to continue?
	tst.l	d0
	beq.s	.Exit			; No, then exit.
	bsr.s	ExtendMap		; Call routine to handle extensions.
	bra.s	.Exit
.Failed:
	bsr	NoMemFail		; Display message.
.Exit:
	CALLEXEC	Forbid		; Aaarrgh!!
	bsr	ClearPort		; Reply to all messages at our port.
	move.l	minfo_StatusWindow(a4),a0
	moveq	#0,d0
	move.l	d0,wd_UserPort(a0)	; Don't let intuition touch our port.
	CALLINT		ModifyIDCMP	; Turn off inputs for status window.
	CALLEXEC	Permit		; Ah!
	move.l	minfo_StatusWindow(a4),a0
	lea	BusyPointer,a1
	moveq	#22,d0
	moveq	#1,d1
	moveq	#0,d2
	moveq	#0,d3
	CALLINT		SetPointer	; Reinstate BUSY! mouse ptr.
	bsr	DisplayStatus		; Update display.
	rts

ExtendMap:
	clr.l	AInt			; Set all 4 extend values to 0...
	move.w	#$3000,AIntBuffer
	clr.l	BInt
	move.w	#$3000,BIntBuffer
	clr.l	CInt
	move.w	#$3000,CIntBuffer
	clr.l	DInt
	move.w	#$3000,DIntBuffer
	move.l	_MapInfoBase,a4
	lea	ExtendMapRequester,a0
	move.l	minfo_StatusWindow(a4),a1
	CALLINT		Request		; Open the requester.
	tst.l	d0
	beq.s	.ReqFailed		; Exit failure if requester failed.
.InputLoop:
	move.l	_InputPort,a0
	CALLEXEC	WaitPort	; Wait for a message.
.MessageLoop:
	move.l	_InputPort,a0
	CALLEXEC	GetMsg		; Get the message
	tst.l	d0			; Was there a message?
	beq.s	.InputLoop		; No, then go back to start.
	move.l	d0,a0
	bsr	ExtractData		; Get message data & reply to it.
	move.l	InputClass,d0
	cmpi.l	#GADGETUP,d0		; Are we interested?
	bne.s	.MessageLoop		; No, Loop...
	lea	CurrInput,a0		; Get Current Input.
	move.l	im_IAddress(a0),a2	; Extract address of gadget.
	cmpa.l	#OKGadget,a2		; Was it the OK Gadget?
	bne.s	.TryCancel		; No, check next gadget.
	bsr.s	BuildNewMap		; Else, make the new map...
	bra.s	.Exit
.TryCancel:
	cmpa.l	#CancelGadget,a2	; Else, was it the Cancel Gadget?
	bne.s	.MessageLoop		; No, then don't worry.
	bra.s	.Exit			; Else, exit.
.ReqFailed:
	bsr	MapReqFail		; Display message.	
.Exit:
	rts

BuildNewMap:
	move.l	_MapInfoBase,a4
	move.l	AInt,d0
	add.l	CInt,d0
	add.w	minfo_MX(a4),d0
	move.w	d0,minfo_NX(a4)		; = ( MX + ( A + C ) )
	move.l	BInt,d0
	add.l	DInt,d0
	add.w	minfo_MY(a4),d0
	move.w	d0,minfo_NY(a4)		; = ( MY + ( B + D ) )
	move.w	minfo_MX(a4),d6		; d6 = Width.
	move.w	minfo_MY(a4),d7		; d7 = Height.
	move.w	minfo_NX(a4),d0
	muls.w	minfo_NY(a4),d0
	lsl.l	#1,d0			; Size = ( ( NX * NY ) * 2 )
	ble.s	.Exit			; Must be >0 to allocate.
	move.l	#(MEMF_PUBLIC!MEMF_CLEAR),d1
	CALLEXEC	AllocMem	; Allocate new map.
	move.l	d0,a3
	move.l	d0,d2
	beq.s	.MemFailed		; Display error if no mem.
	move.l	minfo_Map(a4),a2	; Get pointer to current map.
	move.l	AInt,d0
	bpl.s	.DestA			; Adjust dest if A is >=0.
	move.l	d0,d1
	lsl.l	#1,d1
	suba.l	d1,a2			; Else Src=(Src-(2*A))
	add.w	d0,d6			; Width=(Width+A)
	bra.s	.DoneA
.DestA:
	lsl.l	#1,d0
	adda.l	d0,a3			; Else Dst=(Dst+(2*A))
.DoneA:
	move.l	CInt,d0
	bpl.s	.DoneC			; Skip if C>=0.
	add.w	d0,d6			; Width=(Width+C)
.DoneC:
	move.w	minfo_MX(a4),d4
	sub.w	d6,d4			; SMod=(MX-Width)
	move.w	minfo_NX(a4),d5
	sub.w	d6,d5			; DMod=(NX-Width)
	move.l	BInt,d0
	bpl.s	.DestB			; Adjust dest if B is >=0.
	move.l	d0,d1
	muls.w	minfo_MX(a4),d1
	lsl.l	#1,d1
	suba.l	d1,a2			; Else Src=(Src-(B*MX))
	add.w	d0,d7			; Height=(Height+B)
	bra.s	.DoneB
.DestB:
	muls.w	minfo_NX(a4),d0
	lsl.l	#1,d0
	adda.l	d0,a3			; Else Dst=(Dst+(B*NX))
.DoneB:
	move.l	DInt,d0
	bpl.s	.DoneD			; Skip if D>=0.
	add.w	d0,d7			; Height=(Height+D)
.DoneD:
	bsr.s	MakeMap		; Copy original map into new map etc.
	bra.s	.Exit
.MemFailed:
	bsr	NoMemFail		; Display message.
.Exit:
	rts

MakeMap:

; Needs the following:
;	a2	-	Source map + starting offset.
;	a3	-	Destination map + starting offset.
;	d6	-	Width to copy.
;	d7	-	Height to copy.
;	d4	-	Source modulo.
;	d5	-	Destination modulo.
;	d2	- 	Destination map base.

	ext.l	d5	; Turn WORD modulos into LONGS...
	ext.l	d4
	lsl.l	#1,d5	; Convert number of WORDS to BYTES...
	lsl.l	#1,d4
	subq.w	#1,d6		; dbra adjustments...
	subq.w	#1,d7
.LineLoop:
	move.w	d6,d3		; Get copy of Width.
.ColLoop:
	move.w	(a2)+,(a3)+	; Copy WORD and advance pointers
	dbra	d3,.ColLoop	; Loop for width...
	adda.l	d4,a2		; Add on source modulo.
	adda.l	d5,a3		; Add on destination modulo.
	dbra	d7,.LineLoop	; Repeat until all done...
	move.l	_MapInfoBase,a4
	move.l	minfo_Map(a4),a1
	move.w	minfo_MX(a4),d0
	mulu.w	minfo_MY(a4),d0
	lsl.l	#1,d0
	CALLEXEC	FreeMem		; Free old map.
	move.l	d2,minfo_Map(a4)	; Install new map pointer.
	move.w	minfo_NX(a4),minfo_MX(a4)	; And new sizes...
	move.w	minfo_NY(a4),minfo_MY(a4)
	move.l	AInt,d0
	add.w	d0,minfo_MXP(a4)	; Adjust X position
	move.l	BInt,d0
	add.w	d0,minfo_MYP(a4)	; Adjust Y position
	bsr	CheckPos		; Now check our position in the map.
	move.l	minfo_MapWindow(a4),a1
	move.l	wd_RPort(a1),a1		; Get RastPort pointer.
	move.l	a1,-(sp)
	moveq	#0,d0
	moveq	#0,d1
	CALLGRAF	Move		; Move to top of RastPort
	move.l	(sp),a1
	moveq	#RP_JAM1,d0
	CALLGRAF	SetDrMd		; Force screen clear to pen0.
	move.l	(sp)+,a1		; Recall rastport ptr.
	CALLGRAF	ClearScreen	; Clear the map screen.
	bsr	DrawMapSection		; Update map display
	ori.w	#MIFF_CHANGED,minfo_Flags(a4)	; Set the changed flag.
	rts

GetInitialSize:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	clr.l	NXInt			; Set X value to 0...
	move.w	#$3000,NXBuffer
	clr.l	NYInt			; Set Y value to 0...
	move.w	#$3000,NYBuffer
	move.l	_MapInfoBase,a4
	lea	NewSizeRequester,a0
	move.l	minfo_StatusWindow(a4),a1
	CALLINT		Request		; Open the requester.
	tst.l	d0
	beq.s	.Fail			; Exit failure if requester failed.
.InputLoop:
	move.l	_InputPort,a0
	CALLEXEC	WaitPort	; Wait for a message.
.MessageLoop:
	move.l	_InputPort,a0
	CALLEXEC	GetMsg		; Get the message
	tst.l	d0			; Was there a message?
	beq.s	.InputLoop		; No, then go back to start.
	move.l	d0,a0
	bsr	ExtractData		; Get message data & reply to it.
	move.l	InputClass,d0
	cmpi.l	#GADGETUP,d0		; Are we interested?
	bne.s	.MessageLoop		; No, Loop...
	lea	CurrInput,a0		; Get Current Input.
	move.l	im_IAddress(a0),a2	; Extract address of gadget.
	cmpa.l	#OKGadget,a2		; Was it the OK Gadget?
	beq.s	.WeWant			; Yes, branch.
	cmpa.l	#CancelGadget,a2	; Else, was it the Cancel Gadget?
	bne.s	.MessageLoop		; No, then don't worry.
.WeWant:
	move.w	gg_GadgetID(a2),d0	; Extract return value.
	ext.l	d0			; Turn it into a LONG.
	bra.s	.Exit
.Fail:
	bsr	MapReqFail
	moveq	#-1,d0
.Exit:
	move.l	NXInt,d1		; Install new map dimensions...
	move.w	d1,minfo_NX(a4)
	move.l	NYInt,d1
	move.w	d1,minfo_NY(a4)
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts				; Return!

SetHiRes:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a map.
	beq.s	.Exit			; No, then we cant change the res.
	move.w	mi_Flags+Map.3.2,d0
	btst	#4,d0			; Is item enabled?
	beq.s	.Exit			; No, then we can't do this.
	bsr	CheckSaved		; Is it ok to continue?
	tst.l	d0
	beq.s	.Exit			; No, then exit.
	ori.w	#MIFF_CHANGED,minfo_Flags(a2)	; Set the changed flag.
	move.w	#640,minfo_MRasX(a2)	; Set map screen width.
	ori.w	#V_HIRES,minfo_Res(a2)	; Set HiRes bit.
	bsr	CheckPos		; Check our position in the map.
	bsr	OpenMapScreen		; Open & update display.
	bsr	DisplayMapStatus	; Update status.
.Exit:
	rts

SetLoRes:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a map.
	beq.s	.Exit			; No, then we cant change the res.
	bsr	CheckSaved		; Is it ok to continue?
	tst.l	d0
	beq.s	.Exit			; No, then exit.
	ori.w	#MIFF_CHANGED,minfo_Flags(a2)	; Set the changed flag.
	move.w	#320,minfo_MRasX(a2)	; Set map screen width.
	andi.w	#$7fff,minfo_Res(a2)	; Clear HiRes bit.
	bsr	OpenMapScreen		; Open & update display.
	bsr	DisplayMapStatus	; Update status.
.Exit:
	rts

SaveRawMap:
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a map.
	beq.s	.Exit			; No, then we can't save it!
	move.l	minfo_StatusScreen(a2),a0
	lea	SaveRawMapTitle,a1
	lea	RawMSpec,a2
	bsr	_FileRequester		; Get destination filespec.
	tst.l	d0
	bmi.s	.ReqFail
	beq.s	.Exit			; Exit if failed or user canceled.
	move.l	#RawMSpec,d1
	move.l	#MODE_NEWFILE,d2
	CALLDOS		Open		; Open requested file.
	move.l	d0,d4			; Test and save result.
	beq.s	.Failure		; Exit if file not opened.
	bsr.s	WriteMap		; Save out map data to file.
	exg.l	d0,d4			; Swap filehandle & return value.
	move.l	d0,d1
	CALLDOS		Close		; Close output file.
	tst.l	d4			; Was data written ok?
	bne.s	.Exit			; Yes, then exit.
	move.l	#RawMSpec,d1
	CALLDOS		DeleteFile	; Else delete bad file.
	bra.s	.Exit
.Failure:
	bsr	WriteOpenFail
	bra.s	.Exit			; Display failure message.
.ReqFail:
	bsr	FileReqFail
.Exit:
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow		; Activate status window.
	rts

WriteMap:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	d0,d1			; File to write to.
	move.l	_MapInfoBase,a2
	move.w	minfo_MX(a2),d3		; Calculate size of write...
	mulu.w	minfo_MY(a2),d3
	lsl.l	#1,d3
	move.l	minfo_Map(a2),d2	; Get source buffer.
	CALLDOS		Write		; Write out data.
	cmpi.l	#-1,d0
	beq.s	.Failed			; Branch if write failed.
	moveq	#1,d0			; Else, set return = Success!
	bra.s	.Exit
.Failed:
	bsr	WriteDataFail
	moveq	#0,d0			; Set return = fail.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

	section	ProgStuff,data

RawMSpec:
	dcb.w	75	; Filespec for RAW routines.

;   This is the requester phich gets the map dimensions from the user, it
; contains 2 Integer gadgets, 1 for the width & 1 for the height, and 2
; Boolean gadgets, for OK and Cancel.  A simple instruction / prompt is
; also rendered...

NewSizeRequester:
	dc.l	0
	dc.w	0,0,640,64
	dc.w	0,0
	dc.l	NXGadget		; Gadget list.
	dc.l	0
	dc.l	RequesterText		; Instructions text.
	dc.w	0
	dc.b	1			; We'll have a white requester!
	dc.l	0
	dcb.b	32,0
	dc.l	0,0
	dcb.b	36,0

;   This is the gadget structure for the width, it is a string / longint
; gadget...

NXGadget:
	dc.l	NYGadget
	dc.w	250,50,48,9
	dc.w	GADGHCOMP,(STRINGCENTER!LONGINT!RELVERIFY),(STRGADGET!REQGADGET)
	dc.l	XIntGadgetBox,0,XDimText,0,NXInfo
	dc.w	0
	dc.l	0

;   This is the width gadgets StringInfo structure...

NXInfo:
	dc.l	NXBuffer,UndoBuff
	dc.w	0,6,0,0,0,0,0,0
	dc.l	0
NXInt	dc.l	0,0

;   This is where the ASCII representation of the map width is stored for the
; above gadget...

NXBuffer:
	ds.b	10

;   This is the text that says what the gadget shows, (width)...

XDimText:
	dc.b	0,1,RP_JAM1
	dc.w	-90,0
	dc.l	0,XDimString,0

;   And the asscoiated string...

XDimString:
	dc.b	"Map Width:",0
	even

;   This is the structure which puts the red border around the width gadget
; and text...

XIntGadgetBox:
	dc.w	-94,-2
	dc.b	2,1,RP_JAM1
	dc.b	5
	dc.l	XIntBoxArray
	dc.l	0

;   These are the co-ords for the above borders...

XIntBoxArray:
	dc.w	0,0,145,0,145,11,0,11,0,0

;   This is the gadget structure for the height, it is a string / longint
; gadget...

NYGadget:
	dc.l	OKGadget
	dc.w	430,50,48,9
	dc.w	GADGHCOMP,(STRINGCENTER!LONGINT!RELVERIFY),(STRGADGET!REQGADGET)
	dc.l	YIntGadgetBox,0,YDimText,0,NYInfo
	dc.w	0
	dc.l	0

;   This is the height gadgets StringInfo structure...

NYInfo:
	dc.l	NYBuffer,UndoBuff
	dc.w	0,6,0,0,0,0,0,0
	dc.l	0
NYInt	dc.l	0,0

;   This is where the ASCII representation of the map height is stored for
; the above gadget...

NYBuffer:
	ds.b	10

;   This is the ASCII undo buffer for both string / longint gadgets...

UndoBuff:
	ds.b	10

;   This is the text that says what the gadget shows, (height)...

YDimText:
	dc.b	0,1,RP_JAM1
	dc.w	-98,0
	dc.l	0,YDimString,0

;   And the asscoiated string...

YDimString:
	dc.b	"Map Height:",0
	even

;   This is the structure which puts the red border around the width gadget
; and text...

YIntGadgetBox:
	dc.w	-102,-2
	dc.b	2,1,RP_JAM1
	dc.b	5
	dc.l	YIntBoxArray
	dc.l	0

;   These are the co-ords for the above borders...

YIntBoxArray:
	dc.w	0,0,153,0,153,11,0,11,0,0

;   This is the gadget structure for the Okay Boolean gadget...

OKGadget:
	dc.l	CancelGadget
	dc.w	10,50,64,9
	dc.w	GADGHCOMP,(RELVERIFY!ENDGADGET),(BOOLGADGET!REQGADGET)
	dc.l	BoolGadgetBox,0,OKGadgetText,0,0
	dc.w	1
	dc.l	0

;   The IntuiText for the Okay gadget...

OKGadgetText:
	dc.b	0,1,RP_JAM1
	dc.w	2,1
	dc.l	0,OKString,0

;   And the string...

OKString:
	dc.b	"  Okay  ",0
	even

;   This is the gadget structure for the Cancel Boolean gadget...

CancelGadget:
	dc.l	0
	dc.w	565,50,64,9
	dc.w	GADGHCOMP,(RELVERIFY!ENDGADGET),(BOOLGADGET!REQGADGET)
	dc.l	BoolGadgetBox,0,CancelGadgetText,0,0
	dc.w	-1
	dc.l	0

;   The IntuiText for the Cancel gadget...

CancelGadgetText:
	dc.b	0,1,RP_JAM1
	dc.w	2,1
	dc.l	0,CancelString,0

;   And the string...

CancelString:
	dc.b	" Cancel ",0
	even

;   These are the boxes drawn around both the OK and the Cancel gadgets...

BoolGadgetBox:
	dc.w	-1,-1
	dc.b	0,1,RP_JAM1
	dc.b	5
	dc.l	BoolBoxArray
	dc.l	BoolBox2
BoolBox2:
	dc.w	-5,-3
	dc.b	3,1,RP_JAM1
	dc.b	5
	dc.l	BoolBoxArray2
	dc.l	0

;   And the co-ord tables for both the above border structures...

BoolBoxArray:
	dc.w	0,0,66,0,66,10,0,10,0,0
BoolBoxArray2:
	dc.w	0,0,74,0,74,14,0,14,0,0

;   These are the IntuiText structures for the title, and prompt that is
; rendered into the requester...

RequesterText:			; Title.
	dc.b	0,1,RP_JAM1
	dc.w	247,5
	dc.l	0,RequesterString,RequesterText2

RequesterText2:			; Prompt line 1.
	dc.b	0,1,RP_JAM1
	dc.w	51,20
	dc.l	0,RequesterString2,RequesterText3

RequesterText3:			; Prompt line 2.
	dc.b	0,1,RP_JAM1
	dc.w	187,29
	dc.l	0,RequesterString3,0

;   And the associated strings for the above...

RequesterString:
	dc.b	"Set Map Dimensions",0
	even
RequesterString2:
	dc.b	"Enter the dimensions of the map in tiles, then click Okay to accept",0
	even
RequesterString3:
	dc.b	"or Cancel to abort the operation.",0
	even

;   This is the requester used when the map is to be extended...

ExtendMapRequester:
	dc.l	0
	dc.w	0,0,640,64
	dc.w	0,0
	dc.l	AIntGadget		; Gadget list.
	dc.l	0
	dc.l	ExtRequesterText	; Instructions text.
	dc.w	0
	dc.b	1			; We'll have another white requester!
	dc.l	0
	dcb.b	32,0
	dc.l	0,0
	dcb.b	36,0

;  These are the 4 `Extend' gadgets for the requester...

AIntGadget:
		dc.l	BIntGadget
		dc.w	268,32,48,9
		dc.w	GADGHCOMP,(STRINGCENTER!LONGINT!RELVERIFY)
		dc.w	(STRGADGET!REQGADGET)
		dc.l	AIntBox,0,AIntText,0,AIntInfo
		dc.w	0
		dc.l	0
AIntInfo:
		dc.l	AIntBuffer,UndoBuff
		dc.w	0,6,0,0,0,0,0,0
		dc.l	0
AInt		dc.l	0,0
AIntBuffer	ds.b	10
AIntText:
		dc.b	0,1,RP_JAM1
		dc.w	-58,0
		dc.l	0,AIntString,0
AIntString	dc.b	"L Ext:",0
		even
AIntBox:
		dc.w	-62,-2
		dc.b	2,1,RP_JAM1
		dc.b	5
		dc.l	AIntArray
		dc.l	0
AIntArray	dc.w	0,0,113,0,113,11,0,11,0,0

BIntGadget:
		dc.l	CIntGadget
		dc.w	334,18,48,9
		dc.w	GADGHCOMP,(STRINGCENTER!LONGINT!RELVERIFY)
		dc.w	(STRGADGET!REQGADGET)
		dc.l	BIntBox,0,BIntText,0,BIntInfo
		dc.w	0
		dc.l	0
BIntInfo:
		dc.l	BIntBuffer,UndoBuff
		dc.w	0,6,0,0,0,0,0,0
		dc.l	0
BInt		dc.l	0,0
BIntBuffer	ds.b	10
BIntText:
		dc.b	0,1,RP_JAM1
		dc.w	-58,0
		dc.l	0,BIntString,0
BIntString	dc.b	"T Ext:",0
		even
BIntBox:
		dc.w	-62,-2
		dc.b	2,1,RP_JAM1
		dc.b	5
		dc.l	BIntArray
		dc.l	0
BIntArray	dc.w	0,0,113,0,113,11,0,11,0,0

CIntGadget:
		dc.l	DIntGadget
		dc.w	387,32,48,9
		dc.w	GADGHCOMP,(STRINGCENTER!LONGINT!RELVERIFY)
		dc.w	(STRGADGET!REQGADGET)
		dc.l	CIntBox,0,CIntText,0,CIntInfo
		dc.w	0
		dc.l	0
CIntInfo:
		dc.l	CIntBuffer,UndoBuff
		dc.w	0,6,0,0,0,0,0,0
		dc.l	0
CInt		dc.l	0,0
CIntBuffer	ds.b	10
CIntText:
		dc.b	0,1,RP_JAM1
		dc.w	-58,0
		dc.l	0,CIntString,0
CIntString	dc.b	"R Ext:",0
		even
CIntBox:
		dc.w	-62,-2
		dc.b	2,1,RP_JAM1
		dc.b	5
		dc.l	CIntArray
		dc.l	0
CIntArray	dc.w	0,0,113,0,113,11,0,11,0,0

DIntGadget:
		dc.l	OKGadget
		dc.w	334,46,48,9
		dc.w	GADGHCOMP,(STRINGCENTER!LONGINT!RELVERIFY)
		dc.w	(STRGADGET!REQGADGET)
		dc.l	DIntBox,0,DIntText,0,DIntInfo
		dc.w	0
		dc.l	0
DIntInfo:
		dc.l	DIntBuffer,UndoBuff
		dc.w	0,6,0,0,0,0,0,0
		dc.l	0
DInt		dc.l	0,0
DIntBuffer	ds.b	10
DIntText:
		dc.b	0,1,RP_JAM1
		dc.w	-58,0
		dc.l	0,DIntString,0
DIntString	dc.b	"B Ext:",0
		even
DIntBox:
		dc.w	-62,-2
		dc.b	2,1,RP_JAM1
		dc.b	5
		dc.l	DIntArray
		dc.l	0
DIntArray	dc.w	0,0,113,0,113,11,0,11,0,0

ExtRequesterText:		; Extend map prompt line 1.
	dc.b	0,1,RP_JAM1
	dc.w	171,5
	dc.l	0,ExtReqString,0

;   And the associated strings for the above...

ExtReqString:
	dc.b	"Set Map Extension / Reduction Factors",0
	even

;   This is the title used in the FileRequester when saving the map as RAW
; data...

SaveRawMapTitle:
	dc.b	"          Save Raw Map           ",0
	even
	end
