	opt	c+,d+,l+,o+,i+
	incdir	sys:include/
	include	exec/exec_lib.i
	include	graphics/graphics_lib.i
	include	intuition/intuition_lib.i
	include	intuition/intuition.i

	include	MapDesignerV2.0:Source/MapDesignerV2.i

	output	MapDesignerV2.0:Modules/Dialogue.o

	xref	_IntuitionBase,_GfxBase,_MapInfoBase

	xdef	DialogueBox

;   This is where all possible errors are exported, also the "About" text...

	xdef	ReadOpenFail,WriteOpenFail,ReadDataFail,WriteDataFail
	xdef	NoMemFail,NotMapFail,NoTilesFail,NotIFFFail,NotILBMFail
	xdef	BadIFFFail,OpenWBFail,CloseWBFail,IconFail,TileScreenFail
	xdef	FileReqFail,EditScreenFail,PaletteReqFail,AboutText
	xdef	MapReqFail

;   This is a new file created for V2.1 update, all dialogue box messages /
; error messages are now in this file.  The DialogueBox sub-routine and its
; associated data are also here.
;
;  NOTE: Dialogue texts are now auto-centered.


	section	Program,code
MapReqFail:
	lea	MapReqText,a0
	bsr	DialogueBox
	rts
ReadOpenFail:
	lea	ReadOpenText,a0
	bsr	DialogueBox
	rts
WriteOpenFail:
	lea	WriteOpenText,a0
	bsr	DialogueBox
	rts
ReadDataFail:
	lea	ReadDataText,a0
	bsr	DialogueBox
	rts
WriteDataFail:
	lea	WriteDataText,a0
	bsr	DialogueBox
	rts
NoMemFail:
	lea	NoMemText,a0
	bsr.s	DialogueBox
	rts
NotMapFail:
	lea	NotMapText,a0
	bsr.s	DialogueBox
	rts
NoTilesFail:
	lea	NoTilesText,a0
	bsr.s	DialogueBox
	rts
NotIFFFail:
	lea	NotIFFText,a0
	bsr.s	DialogueBox
	rts
NotILBMFail:
	lea	NotILBMText,a0
	bsr.s	DialogueBox
	rts
BadIFFFail:
	lea	BadIFFText,a0
	bsr.s	DialogueBox
	rts
OpenWBFail:
	lea	OpenWBText,a0
	bsr.s	DialogueBox
	rts
CloseWBFail:
	lea	CloseWBText,a0
	bsr.s	DialogueBox
	rts
IconFail:
	lea	IconText,a0
	bsr.s	DialogueBox
	rts
TileScreenFail:
	lea	TileScreenText,a0
	bsr.s	DialogueBox
	rts
FileReqFail:
	lea	FileReqText,a0
	bsr.s	DialogueBox
	rts
PaletteReqFail:
	lea	PaletteReqText,a0
	bsr.s	DialogueBox
	rts
EditScreenFail:
	lea	EditScreenText,a0
	bsr.s	DialogueBox
	rts

	Section	DialogueText,data

;   These are the dialogue text arrays for all the failure messages, and also
; the V2.13 "About" text...

MapReqText:
	dc.l	FailStr,BlankStr,MapReqStr,BlankStr,MousePrompt,0
ReadOpenText:
	dc.l	FailStr,BlankStr,ReadOpenStr,BlankStr,MousePrompt,0
WriteOpenText:
	dc.l	FailStr,BlankStr,WriteOpenStr,BlankStr,MousePrompt,0
ReadDataText:
	dc.l	FailStr,BlankStr,ReadDataStr,BlankStr,MousePrompt,0
WriteDataText:
	dc.l	FailStr,BlankStr,WriteDataStr,BlankStr,MousePrompt,0
NoMemText:
	dc.l	FailStr,BlankStr,NoMemStr,BlankStr,MousePrompt,0
NotMapText:
	dc.l	FailStr,BlankStr,NotMapStr,BlankStr,MousePrompt,0
NoTilesText:
	dc.l	FailStr,BlankStr,NoTilesStr,BlankStr,MousePrompt,0
NotIFFText:
	dc.l	FailStr,BlankStr,NotIFFStr,BlankStr,MousePrompt,0
NotILBMText:
	dc.l	FailStr,BlankStr,NotILBMStr,BlankStr,MousePrompt,0
BadIFFText:
	dc.l	FailStr,BlankStr,BadIFFStr,BlankStr,MousePrompt,0
OpenWBText:
	dc.l	FailStr,BlankStr,OpenWBStr,BlankStr,MousePrompt,0
CloseWBText:
	dc.l	FailStr,BlankStr,CloseWBStr,BlankStr,MousePrompt,0
IconText:
	dc.l	BlankStr,IconStr,BlankStr,BlankStr,MousePrompt,0
TileScreenText:
	dc.l	FailStr,BlankStr,TileScreenStr,BlankStr,MousePrompt,0
FileReqText:
	dc.l	FailStr,BlankStr,FileReqStr,BlankStr,MousePrompt,0
EditScreenText:
	dc.l	FailStr,BlankStr,EditScreenStr,BlankStr,MousePrompt,0
PaletteReqText:
	dc.l	FailStr,BlankStr,PaletteReqStr,BlankStr,MousePrompt,0


AboutText:
	dc.l	AboutStr1,BlankStr,AboutStr2,BlankStr,MousePrompt
	dc.l	AboutStr3,BlankStr,AboutStr4,AboutStr5,BlankStr
	dc.l	AboutStr6,AboutStr7,BlankStr,AboutStr8,BlankStr
	dc.l	BlankStr,AboutStr9,AboutStr10,BlankStr,BlankStr
	dc.l	AboutStr11,BlankStr,AboutStr12,BlankStr,BlankStr
	dc.l	AboutStr13,BlankStr,BlankStr,AboutStr14,BlankStr
	dc.l	0

;   These are the strings used for the "About" message...

; Window 1...
AboutStr1:
	dc.w	57-18
	dc.b	"The Designer V2.14 - (C)1994 P.D.Turner"
	even
AboutStr2:
	dc.w	72-18
	dc.b	"Utility for creating background & level gfx for games."
	even
; Window 2...
AboutStr3:
	dc.w	34-18	
	dc.b	"Copyright Notice"
	even
AboutStr4:
	dc.w	86-18	
	dc.b	"This program is copyright.  It is not public domain or shareware and"
	even
AboutStr5:
	dc.w	78-18	
	dc.b	"may not be distributed without the permission of the author."
	even
; Window 3...
AboutStr6:
	dc.w	56-18
	dc.b	"Program design and code by Paul Turner"
	even
AboutStr7:
	dc.w	41-18 
	dc.b	"Graphics by Paul Turner"
	even
AboutStr8:
	dc.w	80-18
	dc.b	"Example material and documents by Paul Turner and Lucie Turner"
	even
; Window4...
AboutStr9:
	dc.w	85-18
	dc.b	"The source code for The Designer is now available for £10 in the UK"
	even
AboutStr10:
	dc.w	72-18
	dc.b	"(£12 if outside UK) from the address on the last page."
	even

; Window5...
AboutStr11:
	dc.w	60-18
	dc.b	"Please do not send any foreign currencies."
	even
AboutStr12:
	dc.w	72-18
	dc.b	"Make cheques, postal orders etc payable to P.D.Turner."
	even
; Window6...
AboutStr13:
	dc.w	36-18
	dc.b	"Contact address..."
	even
AboutStr14:
	dc.w	73-18
	dc.b	"21 Langton Avenue, Chelmsford, Essex, CM1 2BW, England."
	even

;   These strings are general and are used along with lots of the others...

BlankStr:
	dc.w	1	
	dc.b	" "
	even
MousePrompt:
	dc.w	41-18	
	dc.b	"Press left mouse button"
	even
FailStr:
	dc.w	41-18	
	dc.b	"Operation has failed..."
	even

;   These are the strings used for the failure messages...

MapReqStr:
	dc.w	55-18	
	dc.b	"Unable to display map size requester."
	even
ReadOpenStr:
	dc.w	50-18	
	dc.b	"Unable to open file for reading."
	even
ReadDataStr:
	dc.w	48-18	
	dc.b	"Unable to read data from file."
	even
NoMemStr:
	dc.w	60-18	
	dc.b	"Not enough memory for requested operation."
	even
NotMapStr:
	dc.w	44-18	
	dc.b	"File is not a V2 map file."
	even
NoTilesStr:
	dc.w	40-18	
	dc.b	"No tiles data present."
	even
WriteOpenStr:
	dc.w	50-18	
	dc.b	"Unable to open file for writing."
	even
WriteDataStr:
	dc.w	47-18	
	dc.b	"Unable to write data to file."
	even
NotIFFStr:
	dc.w	45-18	
	dc.b	"File is not an IFF-85 file."
	even
NotILBMStr:
	dc.w	55-18	
	dc.b	"IFF file is not an ILBM picture file."
	even
BadIFFStr:
	dc.w	56-18	
	dc.b	"IFF file is missing required chunk(s)."
	even
CloseWBStr:
	dc.w	48-18	
	dc.b	"Unable to close the Workbench."
	even
OpenWBStr:
	dc.w	47-18	
	dc.b	"Unable to open the Workbench."
	even
IconStr:
	dc.w	53-18	
	dc.b	"Unable to create icon for map file."
	even
TileScreenStr:
	dc.w	53-18	
	dc.b	"Unable to display the tiles screen."
	even
FileReqStr:
	dc.w	55-18	
	dc.b	"Unable to display the file requester."
	even
PaletteReqStr:
	dc.w	58-18	
	dc.b	"Unable to display the palette requester."
	even
EditScreenStr:
	dc.w	73-18	
	dc.b	"Unable to open edit window - All unsaved map data lost."
	even

	Section	Program,code
DialogueBox:
	movem.l	d2-7/a2-6,-(sp)		; Save regs.
	move.l	a0,a3			; Store users input in a3.
	move.l	_MapInfoBase,a2
	lea	DialogueNewWindow,a0
	move.l	minfo_StatusScreen(a2),nw_Screen(a0)	; Where to open it.
	CALLINT		OpenWindow
	tst.l	d0			; Did window open OK?
	beq	.Failure		; No, take failure path.
	move.l	d0,a5			; Store window here.
	move.l	wd_RPort(a5),a4		; Store RastPort here.
	move.l	a4,a1
	moveq	#1,d0
	CALLGRAF	SetAPen		; Set FGnd Pen.
	move.l	a4,a1
	moveq	#0,d0
	CALLGRAF	SetBPen		; Set BkGnd Pen.
	move.l	a4,a1
	moveq	#RP_JAM2,d0
	CALLGRAF	SetDrMd		; Set drawing mode.
	moveq	#0,d7			; Clear local exit flag.
.BoxLoop:
	move.l	a4,a1
	move.w	#0,d0
	move.w	#6,d1
	CALLGRAF	Move		; Set initial cursor position.
	moveq	#4,d6			; Do dbra loop for 5.
.LineLoop:
	tst.l	(a3)			; Is there another line of text?
	beq.s	.LastLine		; No, exit loop.
	move.l	(a3)+,a0		; Get string pointer.
	move.w	(a0)+,d2		; Get length of string.
	move.w	d2,d3
	lsl.w	#3,d3			; Get width of string in pixels
	move.w	#640,d0			; Get dialogue width.
	sub.w	d3,d0			; Calculate unused pixels on line.
	lsr.w	#1,d0			; Divide by 2 to get left offset.
	move.l	a4,a1
	move.w	rp_cp_y(a1),d1
	addq.w	#8,d1
	CALLGRAF	Move		; Move cursor down a line.
	move.w	d2,d0
	move.l	a4,a1
	CALLGRAF	Text		; Display text.
	dbra	d6,.LineLoop		; Loop until done...
	tst.l	(a3)			; Is there any more text?
	beq.s	.LastLine		; No, Set the finished flag.
	bra.s	.WaitForUser		; Then wait for user.
.LastLine:
	moveq	#-1,d7			; Set local exit flag.
.WaitForUser:
	move.l	wd_UserPort(a5),a0
	CALLEXEC	WaitPort	; Wait for a message.
	move.l	wd_UserPort(a5),a0
	CALLEXEC	GetMsg		; Get message.
	tst.l	d0
	beq.s	.WaitForUser		; Loop if there was no msg.
	move.l	d0,a1
	move.l	im_Class(a1),d2		; Get msg class.
	move.w	im_Code(a1),d3		; Get msg code.
	CALLEXEC	ReplyMsg	; Send msg back.
	cmpi.l	#MOUSEBUTTONS,d2	; Is it the right message?
	bne.s	.WaitForUser		; No, loop...
	cmpi.w	#SELECTDOWN,d3		; Was it the correct button?
	bne.s	.WaitForUser		; No, loop...
	tst.l	d7			; Is local flag set?
	bne.s	.EndBox			; Yes, cleanup & exit.
	move.l	a4,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLGRAF	Move		; Move cursor to top-left.
	move.l	a4,a1
	CALLGRAF	ClearScreen	; Clear the screen
	bra	.BoxLoop		; Then loop again...
.EndBox:
	move.l	a5,a0
	CALLINT		CloseWindow	; Remove the dialogue box.
	bra.s	.Exit			; Then return.
.Failure:
	move.l	#RECOVERY_ALERT,d0	; This is *not* the end of the world!
	lea	BadFailString,a0	; Get alert string.
	move.w	#58,d1			; Height of alert
	CALLINT		DisplayAlert	; Display the message.
	move.l	_MapInfoBase,a2
	move.w	minfo_Flags(a2),d0
	btst	#MIFB_MAP,d0		; Is there a map?
	beq.s	.Exit
	move.l	minfo_MapScreen(a2),a0
	CALLINT		ScreenToFront	; Put display back correctly.
.Exit:
	move.l	_MapInfoBase,a2
	move.l	minfo_StatusWindow(a2),a0
	CALLINT		ActivateWindow	; Activate status window.
	movem.l	(sp)+,d2-7/a2-6		; Recall regs:
	rts

	section	ProgStuff,data

;   This is the newWindow structure used by the DialogueBox function, it is
; fixed in size, and always opens in the Status Screen...

DialogueNewWindow:
	dc.w	0,0,640,64
	dc.b	-1,-1
	dc.l	MOUSEBUTTONS,(SIMPLE_REFRESH!BORDERLESS!ACTIVATE!RMBTRAP!NOCAREREFRESH)
	dc.l	0,0,0,0,0
	dc.w	0,0,0,0
	dc.w	CUSTOMSCREEN

;   This is the alert string used to get a message to the user, when the
; Dialogue box can't open...

BadFailString:
	dc.b	00,187,10,"The Designer  -  Failure Message",0,1
	dc.b	00,167,26,"Unable to open message display window",0,1
	dc.b	00,131,34,"Requested operation has for some reason failed",0,1
	dc.b	00,223,52,"Press left mouse button",0,0
	even
	end
