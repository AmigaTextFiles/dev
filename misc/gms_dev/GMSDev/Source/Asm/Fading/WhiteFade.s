;-------T-------T------------------------T----------------------------------;
;Fades the screen to white, then down to a palette, and exits with a fade
;to black.  This demo can load and fade any picture that you specify at
;the end of this file.
;
;Press left mouse button to exit.

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	FilePic(pc),a0
	moveq	#ID_PICTURE,d0
	CALL	Load
	move.l	d0,Picture
	beq.s	.Exit

	moveq	#ID_SCREEN,d0
	CALL	Get
	move.l	d0,Screen
	beq.s	.Exit

	move.l	Picture(pc),a0
	move.l	Screen(pc),a1
	CALL	CopyStructure

	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a1
	move.l	#BMF_BLANKPALETTE,BMP_Flags(a1)
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Picture(pc),a0
	move.l	PIC_Bitmap(a0),a0
	move.l	Screen(pc),a1
	move.l	GS_Bitmap(a1),a1
	CALL	Copy

	move.l	Screen(pc),a0
	CALL	Show

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	Picture(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN CODE
;===========================================================================;

Main:	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a5
	moveq	#$00,d7	;d7 = FadeState (reset).
.f_in	CALL	scrWaitAVBL

	moveq	#5,d1	;d1 = Speed of fade.
	move.l	Screen(pc),a0
	moveq	#$000000,d2	;d2 = Source colour
	move.l	#$ffffff,d5	;d5 = Destination colour.
	moveq	#00,d3	;d3 = Start colour
	move.l	BMP_AmtColours(a5),d4	;d4 = Amount of colours.
	move.w	d7,d0	;d0 = FadeState
	CALL	scrColourMorph	;Do the fade routine.
	move.w	d0,d7	;Has the fade finished yet?
	bne.s	.f_in	;If not, keep doing it.

	moveq	#$00,d7
.f_mid	CALL	scrWaitAVBL
	moveq	#2,d1	;d1 = Speed of fade.
	move.l	Screen(pc),a0
	move.l	Picture(pc),a1
	move.l	PIC_Bitmap(a1),a1
	move.l	BMP_Palette(a1),a1	;a1 = Palette to fade to.
	addq.w	#8,a1
	move.l	#$ffffff,d2	;d2 = Colour we are fading from.
	move.w	d7,d0
	CALL	scrColourToPalette	;Do the fade routine.
	move.w	d0,d7	;Has the fade finished yet?
	bne.s	.f_mid	;If not, keep doing it.

	moveq	#$00,d7
.f_out	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	moveq	#2,d1	;d0 = Speed of fade.
	move.l	Picture(pc),a1
	move.l	PIC_Bitmap(a1),a1
	move.l	BMP_Palette(a1),a1	;a1 = Palette to fade to.
	addq.w	#8,a1
	moveq	#$000000,d2	;d2 = Destination colour.
	move.w	d7,d0
	CALL	scrPaletteToColour	;Do the fade routine.
	move.w	d0,d7	;Has the fade finished yet?
	bne.s	.f_out	;If not, keep doing it.

	move.l	DPKBase(pc),a6
	moveq	#20,d0
	CALL	WaitTime
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

Screen:		dc.l  0
Picture:	dc.l  0
FilePic:	FILENAME "GMS:demos/data/PIC.Loading"

;===========================================================================;

ProgName:	dc.b  "White Fade",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "March 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Fading demonstration.",0
		even

