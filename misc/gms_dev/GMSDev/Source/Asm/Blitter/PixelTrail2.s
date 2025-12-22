;-------T-------T------------------------T----------------------------------;
;This demo demonstrates the usefulness of LISTs, by drawing a trail of
;pixels attached to the mouse.
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

Main:	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	lea	Mouse(pc),a2
	move.w	JD_XChange(a0),d0
	add.w	d0,(a2)
	move.w	JD_YChange(a0),d0
	add.w	d0,2(a2)

	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	bne.s	.done

.ChkLX	tst.w	(a2)
	bge.s	.ChkRX
	clr.w	(a2)
.ChkRX	cmp.w	#319,(a2)
	ble.s	.ChkTY
	move.w	#319,(a2)
.ChkTY	tst.w	2(a2)
	bge.s	.ChkBY
	clr.w	2(a2)
.ChkBY	cmp.w	#255,2(a2)
	ble.s	.Draw
	move.w	#255,2(a2)

.Draw	lea	MList(pc),a3	;Shift the list up a place.
	moveq	#32-1,d7
.tloop	move.l	PXL_SIZEOF(a3),PXL_XCoord(a3)
	addq.w	#PXL_SIZEOF,a3
	dbra	d7,.tloop

	move.l	BLTBase(pc),a6
	move.l	Screen(pc),a0	;a0 = Screen
	move.l	GS_Bitmap(a0),a0	;a0 = Bitmap
	lea	PixelList(pc),a1	;a1 = Pixel list.
	CALL	bltDrawPixelList

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	CALL	scrSwapBuffers
	bra	Main

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
		dc.l  $000000,$101010,$202020,$303030,$404040,$505050,$606060,$707070
		dc.l  $808080,$909090,$a0a0a0,$b0b0b0,$c0c0c0,$d0d0d0,$e0e0e0,$f0f0f0
		dc.l  $000000,$101010,$202020,$303030,$404040,$505050,$606060,$707070
		dc.l  $808080,$909090,$a0a0a0,$b0b0b0,$c0c0c0,$d0d0d0,$e0e0e0,$ffffff

;---------------------------------------------------------------------------;

PixelList:	dc.w  33,PXL_SIZEOF	;Amount of entries.
		dc.l  MList	;Pointer to pixel list array.
MList:		PIXEL 160,128,00	;First pixel to draw (at back)
		PIXEL 160,128,00	;X/Y/Colour
		PIXEL 160,128,01	;..
		PIXEL 160,128,02	;..
		PIXEL 160,128,03	;..
		PIXEL 160,128,04	;..
		PIXEL 160,128,05	;..
		PIXEL 160,128,06	;..
		PIXEL 160,128,07	;..
		PIXEL 160,128,08	;..
		PIXEL 160,128,09	;..
		PIXEL 160,128,10	;..
		PIXEL 160,128,11	;..
		PIXEL 160,128,12	;..
		PIXEL 160,128,13	;..
		PIXEL 160,128,14	;..
		PIXEL 160,128,15	;..
		PIXEL 160,128,16	;..
		PIXEL 160,128,17	;..
		PIXEL 160,128,18	;..
		PIXEL 160,128,19	;..
		PIXEL 160,128,20	;..
		PIXEL 160,128,21	;..
		PIXEL 160,128,22	;..
		PIXEL 160,128,23	;..
		PIXEL 160,128,24	;..
		PIXEL 160,128,25	;..
		PIXEL 160,128,26	;..
		PIXEL 160,128,27	;..
		PIXEL 160,128,28	;..
		PIXEL 160,128,29	;..
		PIXEL 160,128,30	;..
Mouse:		PIXEL 160,128,31	;Last pixel to draw (in front)

;===========================================================================;

ProgName:	dc.b  "Pixel Trail II",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "February 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Pixel trail demonstration.",0
		even

