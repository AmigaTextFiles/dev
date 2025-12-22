;-------T-------T------------------------T----------------------------------;
;This demo demonstrates the usefulness of LISTs, by drawing a trail of
;pixels attached to the mouse.  In the case of pixels there are special
;routines for drawing with lists, so the drawing is very fast.
;
;Press LMB to exit.

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
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:	lea	MList(pc),a2	;a2 = Pointer to pixel list.
.loop	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a1
	move.l	GS_Bitmap(a1),a0
	move.l	GS_MemPtr2(a1),BMP_Data(a0)
	CALL	Clear

	move.l	Screen(pc),a0
	move.l	a2,a3	;Drop the pixels here.
	moveq	#31-1,d7
.drop	addq.w	#1,2(a3)	;a3 = YCoord+1
	subq.l	#1,4(a3)	;a3 = (Colour)-1
	bge.s	.colok
	clr.l	4(a3)
.colok	addq.w	#8,a3
	dbra	d7,.drop

	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query

	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	bne	.done

	lea	MouseX(pc),a5
	move.w	JD_YChange(a0),d0
	add.w	d0,2(a5)	;d1 = (MouseY)+ChangeY

	move.w	JD_XChange(a0),d0
	add.w	(a5),d0

	move.l	Screen(pc),a0
.ChkRX	cmp.w	GS_Width(a0),d0
	blt.s	.ChkLX
	clr.w	(a5)
	bra.s	.Calculate
.ChkLX	tst.w	d0
	bgt.s	.okX
	move.w	GS_Width(a0),(a5)
	bra.s	.Calculate
.okX	move.w	d0,(a5)

.Calculate
	move.l	(a5),-(sp)
	moveq	#2,d1
	CALL	FastRandom
	subq.w	#1,d0
	add.w	d0,(a5)

	moveq	#2,d1
	CALL	FastRandom
	subq.w	#1,d0
	add.w	d0,2(a5)

	move.l	a2,a3
	moveq	#31-1,d7
.tloop	move.l	8(a3),(a3)
	move.l	12(a3),4(a3)
	addq.w	#8,a3
	dbra	d7,.tloop

	move.l	BLTBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	lea	PixelList(pc),a1	;a1 = Pixel list.
	CALL	bltDrawPixelList	;>> = Draw pixels with clipping.

	move.l	(sp)+,(a5)

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	CALL	scrSwapBuffers
	bra	.loop

.done	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	dc.l  0

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Attrib,SCR_DBLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Palette,.palette
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,32
		dc.l  $000000,$101010,$171717,$202020,$272727,$303030,$373737,$404040
		dc.l  $474747,$505050,$575757,$606060,$676767,$707070,$777777,$808080
		dc.l  $878787,$909090,$979797,$a0a0a0,$a7a7a7,$b0b0b0,$b7b7b7,$c0c0c0
		dc.l  $c7c7c7,$d0d0d0,$d7d7d7,$e0e0e0,$e0e0e0,$f0f0f0,$f7f7f7,$ffffff

PixelList:	dc.w   32,PXL_SIZEOF	;Amount of entries, EntrySize.
		dc.l   MList	;Pointer to pixel list array.
MList:		PIXEL  160,128,00	;First pixel to draw (at back)
		PIXEL  160,128,00	;X/Y/Colour
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
		PIXEL  160,128,00	;..
MouseX:		PIXEL  160,128,31	;Last pixel to draw (in front)

;===========================================================================;

ProgName:	dc.b  "Pixel Trail I",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Pixel trail demonstration.",0
		even

