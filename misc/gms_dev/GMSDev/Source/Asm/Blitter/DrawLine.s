;-------T-------T------------------------T----------------------------------;
;This demo draws a line which you can control with the mouse.

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	ScreenTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	moveq	#ID_JOYDATA,d0
	CALL	Get
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Screen(pc),a0
	CALL	Display

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:
.loop	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	CALL	Clear

	move.l	JoyData(pc),a0
	CALL	Query

	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_RMB,d0
	bne.s	.done
	lea	MouseDXY(pc),a1
	btst	#JB_LMB,d0
	beq.s	.no

	lea	MouseSXY(pc),a1
.no	move.w	JD_YChange(a0),d0
	add.w	d0,2(a1)
	move.w	JD_XChange(a0),d0
	add.w	d0,(a1)

.Draw	move.l	BLTBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	movem.w	MouseSXY(pc),d1/d2/d3/d4	;d1 = XStart, YStart, XEnd, YEnd.
	moveq	#2,d5	;d5 = Colour
	move.l	#$AAAAAAAA,d6	;d6 = Pattern/Mask.
	CALL	bltDrawLine

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	CALL	scrSwapBuffers
	bra.s	.loop

.done	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

MouseSXY:	dc.w  160,128
MouseDXY:	dc.w  40,40

JoyData:	dc.l  0

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,640
		dc.l  GSA_Height,256
		dc.l  GSA_ScrMode,SM_HIRES
		dc.l  GSA_Attrib,SCR_DBLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Palette,.palette
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,4
		dc.l  $000000,$f0f0f0,$f000f0,$f00000

;===========================================================================;

ProgName:	dc.b  "Draw Line",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "May 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Simple line demonstration.",0
		even

