;-------T-------T------------------------T----------------------------------;
;Draws a pixel on a screen without destroying the background.  This
;version demonstrates an easy way of supporting all the different screen
;types (true colour, chunky, planar...) by drawing with RGB values.

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"DrawPixel",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	FILE_Background(pc),a0	;Load the picture.
	moveq	#ID_PICTURE,d0
	CALL	Load
	move.l	d0,PIC_Background
	beq.s	.Exit

	moveq	#ID_SCREEN,d0
	CALL	Get
	move.l	d0,Screen
	beq.s	.Exit

	move.l	PIC_Background(pc),a0
	move.l	Screen(pc),a1
	CALL	CopyStructure

	move.l	Screen(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	PIC_Background(pc),a0
	move.l	PIC_Bitmap(a0),a0
	move.l	Screen(pc),a1
	move.l	GS_Bitmap(a1),a1
	CALL	Copy

	moveq	#ID_JOYDATA,d0	;Get joydata structure.
	CALL	Get
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0	;Initialise the joydata structure.
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
	move.l	PIC_Background(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:	moveq	#100,d6
	moveq	#100,d7
.loop	move.l	BLTBase(pc),a6

	;Replace the background pixel.

	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	movem.w	OldPixel(pc),d1/d2
	move.l	OldColour(pc),d3
	blt.s	.read
	CALL	bltDrawRGBPixel	;>> = Draw the old background pixel.

	;Read the new background pixel.

.read	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	move.w	d6,d1	;d1 = X Coordinate.
	move.w	d7,d2	;d2 = Y Coordinate.
	CALL	bltReadRGBPixel	;>> = Read the pixel.
	movem.w	d6/d7,OldPixel	;MA = Save coords of next pixel.
	move.l	d0,OldColour	;MA = Save colour of next pixel.

	;Draw the pixel.

	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	move.w	d6,d1	;d1 = X Coordinate.
	move.w	d7,d2	;d2 = Y Coordinate.
	move.l	#$aaaaaa,d3	;d3 = Colour.
	CALL	bltDrawRGBPixel	;>> = Draw our pixel.

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL	;>> = Wait for VBL.

	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	add.w	JD_YChange(a0),d7
	add.w	JD_XChange(a0),d6
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	beq.s	.loop
	rts

OldPixel:
	dc.w	0,0
OldColour:
	dc.l	-1

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	 dc.l  0
Screen:		 dc.l  0
PIC_Background:	 dc.l  0
FILE_Background: FILENAME "GMS:demos/data/PIC.Green"

;===========================================================================;

ProgName:	dc.b  "Draw RGB Pixel",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Pixel demonstration.",0
		even

