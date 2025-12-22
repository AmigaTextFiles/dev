;-------T-------T------------------------T----------------------------------;
;This demo will load in a picture of any size/type and if it is larger than
;the screen width, it scrolls left and right.  This is easily possible due
;to the fact that GMS likes to fill in fields that have been set at zero
;on initialisation, which is great for loading/displaying things like
;pictures.
;
;The benefits of this will become more apparent when you want to do things
;like changing your graphics format from ECS to AGA and vice versa.  The
;benefits for the user are enormous (full graphical editing capabilities,
;if you program correctly).  And you don't even need to change a line of
;code!

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

SPEED	=	2

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	PictureFile(pc),a0
	moveq	#ID_PICTURE,d0
	CALL	Load
	move.l	d0,Picture
	beq.s	.Exit

	moveq	#ID_SCREEN,d0
	CALL	Get
	move.l	d0,Screen
	beq.s	.Exit

	move.l	Picture(pc),a0	;a0 = Source structure.
	move.l	Screen(pc),a1	;a1 = Destination structure.
	move.l	#SCR_HSCROLL,GS_Attrib(a1)
	CALL	CopyStructure	;>> = Copy Picture to Screen.

	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a1
	clr.l	BMP_Palette(a1)
	or.l	#BMF_BLANKPALETTE,BMP_Flags(a1)
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Picture(pc),a0
	move.l	PIC_Bitmap(a0),a0
	move.l	Screen(pc),a1
	move.l	GS_Bitmap(a1),a1
	CALL	Copy

	moveq	#ID_JOYDATA,d0	;Get joydata structure for reading
	CALL	Get	;port 0.
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0	;Initialise the joydata structure.
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Screen(pc),a0
	CALL	Display

	bsr.s	Main	;Go and do the main routine.

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	move.l	Picture(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:	move.l	SCRBase(pc),a6
	move.l	Picture(pc),a2
	moveq	#0,d7	;d7 = Initialise fader.
	moveq	#$000000,d2
	moveq	#0,d3
	move.l	PIC_Bitmap(a2),a5
	move.l	BMP_AmtColours(a5),d4

.Fade1	move.l	Screen(pc),a0
	CALL	scrWaitVBL
	move.l	Screen(pc),a0
	move.l	Picture(pc),a5
	move.l	PIC_Bitmap(a5),a5
	moveq	#2,d1	;d1 = Speed of fade.
	move.l	BMP_Palette(a5),a1	;a1 = Palette we are fading to.
	addq.w	#8,a1
	move.w	d7,d0
	CALL	scrColourToPalette	;>> = Do the fade routine.
	move.w	d0,d7	;d7 = Fade counter.
	bne.s	.Fade1	;>> = If not finished, keep looping.

;---------------------------------------------------------------------------;
;Loop here.

	moveq	#SPEED,d2

.loop	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	CALL	scrWaitAVBL

	move.l	Screen(pc),a0	;a0 = Screen
	move.l	GS_Bitmap(a0),a2	;a1 = Screen.Bitmap
	move.w	GS_Width(a0),d0	;d0 = Screen.Width
	cmp.w	BMP_Width(a2),d0	;d0 = (Screen.Width >= Bitmap.Width)?
	bge.s	.done	;>> = Yes, do not scroll.

	tst.w	d2
	bgt.s	.Right

.Left	tst.w	GS_BmpXOffset(a0)
	ble.s	.RRight

.RLeft	moveq	#-SPEED,d2
	bra.s	.scroll

.Right	move.w	BMP_Width(a2),d0	;d0 = PicWidth.
	sub.w	#320,d0
	cmp.w	GS_BmpXOffset(a0),d0	;d0 = Is (Width-320 < BmpOffset)?
	ble.s	.RLeft

.RRight	moveq	#+SPEED,d2

.scroll	move.w	GS_BmpXOffset(a0),d0
	add.w	d2,d0
	move.w	GS_BmpYOffset(a0),d1
	CALL	scrSetBmpOffsets

.done	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	beq.s	.loop
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

Screen:		dc.l  0
Picture:	dc.l  0
JoyData:	dc.l  0

PictureFile:	FILENAME  "GMSDev:Logos/GMSLogo-FullScreen.iff"

;===========================================================================;

ProgName:	dc.b  "Load Picture",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Loads and displays any IFF picture.",0
		even
