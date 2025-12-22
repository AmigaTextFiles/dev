;-------T-------T------------------------T----------------------------------;
;This just shows how to double buffer the screen.  You can also try out
;triple buffering just by changing the DBLBUFFER flag to TPLBUFFER in the
;GameScreen.

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Start",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	ScreenTags(pc),a0	;Init screen.
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Screen(pc),a1
	lea	PictureTags(pc),a0	;Load background picture.
	move.l	GS_MemPtr1(a1),PicData
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	move.l	Picture(pc),a1
	move.l	PIC_Bitmap(a1),a2
	move.l	GS_Bitmap(a0),a3
	move.l	BMP_Palette(a2),BMP_Palette(a3)
	CALL	scrUpdatePalette

	move.l	DPKBase(pc),a6
	moveq	#ID_JOYDATA,d0	;Get joydata structure.
	CALL	Get
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0	;Initialise the joydata structure.
	sub.l	a1,a1
	CALL	Init
	tst.l	.Exit

	move.l	Screen(pc),a0
	CALL	Display

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

Main:	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL

	move.l	Screen(pc),a0
	CALL	scrSwapBuffers

	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	beq.s	Main
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	dc.l  0
ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,320
		dc.l  GSA_Height,256
		dc.l  GSA_Attrib,SCR_DBLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_AmtColours,32
		dc.l    TAGEND,0
		dc.l  TAGEND

PictureTags:	dc.l  TAGS_PICTURE
Picture:	dc.l  0
		dc.l    PCA_BitmapTags,0
		dc.l    BMA_Data
PicData:	dc.l    0
		dc.l    BMA_Width,320
		dc.l    BMA_Height,256
		dc.l    BMA_AmtColours,32
		dc.l    TAGEND,0
		dc.l  PCA_Source,.file
		dc.l  TAGEND

.file		FILENAME "GMS:demos/data/PIC.Green"

;===========================================================================;

ProgName:	dc.b  "Double Buffer",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Double buffer demonstration.",0
		even

