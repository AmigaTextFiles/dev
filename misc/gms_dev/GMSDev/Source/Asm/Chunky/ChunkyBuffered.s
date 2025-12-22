;-------T-------T------------------------T----------------------------------;
;This demo is like the other pixel list demos but uses a CHUNKY8 screen type.
;Then screen size has been kept very small as the C2P routine is too slow,
;but this will be improved in the next version.  The good thing is that
;because the routine is transparent, using a graphics card would mean that
;this demo would run at the maximum possible speed.
;
;Press LMB to exit.

	INCDIR	"INCLUDES:"
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
	tst.l	.Exit

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
	move.l	Screen(pc),a1
	move.l	GS_Bitmap(a1),a0
	CALL	Clear

	lea	MList(pc),a2	;a2 = Pointer to pixel list.
	move.l	a2,a3	;Drop the pixels here.
	moveq	#31-1,d7
.drop	addq.w	#1,2(a3)	;a3 = YCoord+1
	subq.l	#1,4(a3)	;a3 = (Colour)-1
	bge.s	.colok
	clr.l	4(a3)
.colok	addq.w	#8,a3
	dbra	d7,.drop

	move.l	DPKBase(pc),a6
	lea	MouseX(pc),a5
	move.l	JoyData(pc),a0
	CALL	Query

	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	bne	.done

	move.w	JD_XChange(a0),d0
	move.w	JD_YChange(a0),d1

	move.l	Screen(pc),a0	;a0 = Screen.
	add.w	(a5),d0	;d0 = (MouseX)+ChangeX
	add.w	2(a5),d1	;d1 = (MouseY)+ChangeY

.ChkRX	cmp.w	GS_Width(a0),d0
	blt.s	.ChkLX
	moveq	#$00,d0
	bra.s	.Calculate

.ChkLX	tst.w	d0
	bgt.s	.ChkTY
	move.w	GS_Width(a0),d0
	bra.s	.Calculate

.ChkTY	tst.w	d1
	bgt.s	.ChkBY
	move.w	GS_Height(a0),d1
	bra.s	.Calculate

.ChkBY	cmp.w	GS_Height(a0),d1
	blt.s	.Calculate
	moveq	#$00,d1

.Calculate
	move.w	d0,(a5)
	move.w	d1,2(a5)

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
		dc.l  GSA_Width,256
		dc.l  GSA_Height,128
		dc.l  GSA_Attrib,SCR_CENTRE|SCR_DBLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Palette,.palette
		dc.l    BMA_Type,CHUNKY8
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,32
		dc.l  $000000,$101010,$171717,$202020,$272727,$303030
		dc.l  $373737,$404040,$474747,$505050,$575757,$606060
		dc.l  $676767,$707070,$777777,$808080,$878787,$909090
		dc.l  $979797,$a0a0a0,$a7a7a7,$b0b0b0,$b7b7b7,$c0c0c0
		dc.l  $c7c7c7,$d0d0d0,$d7d7d7,$e0e0e0,$e0e0e0,$f0f0f0
		dc.l  $f7f7f7,$ffffff

PixelList:	dc.w   32,PXL_SIZEOF	;Amount of entries, EntrySize.
		dc.l   MList	;Pointer to pixel list array.
MList:		PIXEL  16,12,00	;First pixel to draw (at back)
		PIXEL  16,12,00	;X/Y/Colour
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
		PIXEL  16,12,00	;..
MouseX:		PIXEL  16,12,31	;Last pixel to draw (in front)

;===========================================================================;

ProgName:	dc.b  "Chunky Buffered",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "February 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Chunky double buffering.",0
		even

