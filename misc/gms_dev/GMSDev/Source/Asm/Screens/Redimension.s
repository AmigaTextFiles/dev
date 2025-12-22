;-------T-------T------------------------T----------------------------------;
;Test routine for height and width alteration.  Move the mouse to alter the
;position of the screen's right hand corner.  Hold the LMB and move the
;mouse around to move the entire screen around your monitor.
;
;Press RMB to exit.

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	lea	PictureTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	lea	ScreenTags(pc),a0
	move.l	Picture(pc),a1
	move.l	PIC_Bitmap(a1),a2
	move.l	BMP_Data(a2),GMemPtr
	move.l	BMP_Palette(a2),GPalette
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	moveq	#ID_JOYDATA,d0	;Get joydata structure for reading
	CALL	Get	;user input.
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Screen(pc),a0
	CALL	Display
	tst.l	d0
	bne.s	.Exit

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	Picture(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query

	move.l	JoyData(pc),a1
	move.l	JD_Buttons(a1),d0
	move.w	JD_XChange(a1),d4
	move.w	JD_YChange(a1),d5

	btst	#JB_RMB,d0
	bne.s	Fade_Here

	move.l	Screen(pc),a0
	add.w	GS_Width(a0),d4
	add.w	GS_Height(a0),d5

.chkty	tst.w	d5
	bge.s	.chkby
	moveq	#$00,d5

.chkby	cmp.w	#256,d5
	ble.s	.chklx
	move.w	#256,d5

.chklx	tst.w	d4
	bge.s	.chkrx
	moveq	#$00,d4

.chkrx	cmp.w	#320,d4
	ble.s	.done
	move.w	#320,d4

.done	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	CALL	scrWaitAVBL	;Always wait for a VBL first.

	move.l	Screen(pc),a0
	move.w	d5,d1
	move.w	d4,d0
	CALL	scrSetScrDimensions	;Reposition the screen now.
	bra.s	Main

Fade_Here:
	moveq	#00,d7
	move.l	SCRBase(pc),a6

.Fade	move.l	Screen(pc),a0
	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	moveq	#4,d1	;d1 = Speed
	moveq	#$000,d2
	moveq	#00,d3	;d1 = Start at colour zero.
	moveq	#32,d4	;d2 = Amount of colours (32)
	move.l	GS_Bitmap(a0),a5
	move.l	BMP_Palette(a5),a1	;a1 = Palette to fade to.
	addq.w	#8,a1
	move.w	d7,d0
	CALL	scrPaletteToColour
	move.w	d0,d7
	bne.s	.Fade
	rts

;===========================================================================;
;                           CODE-RELATIVE DATA
;===========================================================================;

JoyData:	dc.l  0

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_MemPtr1
GMemPtr:	dc.l  0
		dc.l  GSA_Width,320
		dc.l  GSA_Height,256
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Palette
GPalette:	dc.l    0
		dc.l    TAGEND,0
		dc.l  GSA_Attrib,SCR_CENTRE
		dc.l  GSA_ScrMode,SM_LACED
		dc.l  TAGEND

PictureTags:	dc.l  TAGS_PICTURE
Picture:	dc.l  0
		dc.l    PCA_BitmapTags,0
		dc.l    BMA_Data
PicData:	dc.l    0
		dc.l    BMA_Width,320
		dc.l    BMA_Height,256
		dc.l    BMA_MemType,MEM_VIDEO
		dc.l    TAGEND,0
		dc.l  PCA_Options,IMG_RESIZE
		dc.l  PCA_Source,.file
		dc.l  TAGEND

.file		FILENAME "GMS:demos/data/PIC.Green"

;===========================================================================;

ProgName:	dc.b  "Redimension",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Screen redimensioning demo.",0
		even
