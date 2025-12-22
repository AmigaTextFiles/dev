;-------T-------T------------------------T----------------------------------;
;This demo loads in a picture in chunky format and then calls RefreshScreen()
;to do the C2P conversion.

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i"

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	SECTION	"Demo",CODE

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	ScreenTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	;Load the picture.

	move.l	Screen(pc),a1
	move.l	GS_MemPtr1(a1),PicData
	lea	PictureTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	;Update palette to that of the picture.

	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	move.l	Picture(pc),a1
	move.l	GS_Bitmap(a0),a2
	move.l	PIC_Bitmap(a1),a3
	move.l	BMP_Palette(a3),BMP_Palette(a2)
	CALL	scrUpdatePalette

	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0
	CALL	Display

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
;                                MAIN LOOP
;===========================================================================;

Main:	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	CALL	scrRefreshScreen

	move.l	DPKBase(pc),a6
	move.l	#200,d0
	CALL	WaitTime
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,320
		dc.l  GSA_Height,256
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Type,CHUNKY8
		dc.l    TAGEND,0
		dc.l  TAGEND

PictureTags:	dc.l  TAGS_PICTURE
Picture:	dc.l  0
		dc.l    PCA_BitmapTags,0
		dc.l    BMA_Data
PicData:	dc.l    0
		dc.l    BMA_Width,320
		dc.l    BMA_Height,256
		dc.l    BMA_Type,CHUNKY8
		dc.l    TAGEND,0
		dc.l  PCA_Source,.file
		dc.l  TAGEND

.file		FILENAME "GMS:demos/data/PIC.Green"

;===========================================================================;

ProgName:	dc.b  "Chunky Picture",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "July 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Chunky demonstration.",0
		even

