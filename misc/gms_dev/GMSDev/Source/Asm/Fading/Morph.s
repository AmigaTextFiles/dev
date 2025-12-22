;-------T-------T------------------------T----------------------------------;
;Fades in a 32 colour picture, then fades it into a second purple palette,
;and then out to black.  Press left mouse button to exit.

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	PicFile(pc),a0
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
	move.l	Screen(pc),a0
	CALL	Free
	move.l	Picture(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN CODE
;===========================================================================;

Main:	moveq	#$00,d7	;d0 = FadeState
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a5
	move.l	SCRBase(pc),a6
.f_in	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	move.l	Picture(pc),a1
	move.l	PIC_Bitmap(a1),a1
	move.l	BMP_Palette(a1),a1	;a1 = Palette to fade to.
	addq.w	#8,a1
	moveq	#5,d1	;d1 = Speed of fade.
	moveq	#$000000,d2
	moveq	#00,d3
	move.l	BMP_AmtColours(a5),d4
	move.w	d7,d0
	CALL	scrColourToPalette	;Do the fade routine.
	move.w	d0,d7	;Has the fade finished yet?
	bne.s	.f_in	;If not, keep doing it.

	move.l	DPKBase(pc),a6
	moveq	#50,d0
	CALL	WaitTime

	moveq	#$00,d7	;d0 = FadeState
	move.l	SCRBase(pc),a6
.f_mid	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	moveq	#2,d1	;d1 = Speed of fade.
	move.l	Picture(pc),a1
	move.l	PIC_Bitmap(a1),a1
	move.l	BMP_Palette(a1),a1	;a1 = Palette to fade to.
	addq.w	#8,a1
	lea	MorphPalette(pc),a2	;a2 = Destination Palette.
	move.w	d7,d0
	CALL	scrPaletteMorph	;Do the fade routine.
	move.w	d0,d7	;Has the fade finished yet?
	bne.s	.f_mid	;If not, keep doing it.

	move.l	DPKBase(pc),a6
	moveq	#50,d0
	CALL	WaitTime

	moveq	#$00,d7	;d0 = FadeState
	move.l	SCRBase(pc),a6
.f_out	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	moveq	#2,d1	;d1 = Speed of fade.
	lea	MorphPalette(pc),a1
	moveq	#$000000,d2
	move.w	d7,d0
	CALL	scrPaletteToColour	;Do the fade routine.
	move.w	d0,d7	;Has the fade finished yet?
	bne.s	.f_out	;If not, keep doing it.

	move.l	DPKBase(pc),a6
	moveq	#25,d0
	CALL	WaitTime
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

Screen:	dc.l	0
Picture	dc.l	0

MorphPalette:
	dc.l	$000000,$0A0107,$14020E,$1D0314
	dc.l	$27041B,$310522,$3B0629,$45082F
	dc.l	$4E0936,$580A3D,$620B44,$6C0C4A
	dc.l	$760D51,$800E58,$890F5F,$931066
	dc.l	$9D116C,$A71273,$B1137A,$BA1481
	dc.l	$C41687,$CE178E,$D81895,$E2199C
	dc.l	$EB1AA2,$F51BA9,$FF1CB0,$D71C9F
	dc.l	$557D55,$707082,$443300,$1E1E1E

PicFile	FILENAME "GMS:demos/data/PIC.Loading"

;===========================================================================;

ProgName:	dc.b  "Palette Morph",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Fading demonstration.",0
		even

