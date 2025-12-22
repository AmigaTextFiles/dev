;Line Vector example for TSB's VectorDesigner.  Original by ALLOC
;----------------------------------------------------------------

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

	moveq	#ID_JOYDATA,d0
	CALL	Get
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0
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

Main:	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL

	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	CALL	Clear

	;move.w	#$f00,$dff180
	bsr.s	V_Lines
	;move.w	#$000,$dff180

	move.l	SCRBase(pc),a6
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
;                         DRAW THE VECTOR OBJECT
;===========================================================================;

V_Lines:
	addq.w	#2,AngleX
	addq.w	#2,AngleY
	addq.w	#2,AngleZ
	move.w	#$1ff,d7
	and.w	d7,AngleX
	and.w	d7,AngleY
	and.w	d7,AngleZ

	lea	LineObject(pc),a6
	lea	DrawTable(pc),a5
.loop	move.w	(a6)+,d0
	cmp.w	#$7fff,d0
	beq.s	.loop2
	move.w	(a6)+,d1
	move.w	(a6)+,d2
	addq.l	#2,a6
	move.w	AngleX(pc),a0
	move.w	AngleY(pc),a1
	move.w	AngleZ(pc),a2

	bsr.s	Rotate
	add.w	#400,d2
	ext.l	d0
	ext.l	d1
	ext.l	d2
	asl.l	#8,d0
	asl.l	#8,d1
	divs	d2,d0
	divs	d2,d1
	add.w	#160,d0
	add.w	#100,d1
	move.w	d0,(a5)+
	move.w	d1,(a5)+
	bra.s	.loop

.loop2	move.w	#$7fff,(a5)
	lea	DrawTable(pc),a5
	lea	LineObject+1024(pc),a4

.loop3	move.w	(a4)+,d5
	cmp.w	#$7fff,d5
	beq.s	.loop4
	move.w	(a4)+,d6
	lsl.w	#2,d5	;table offset.
	lsl.w	#2,d6	;table offset.
	move.w	(a5,d5.w),d1
	move.w	2(a5,d5.w),d2
	move.w	(a5,d6.w),d3
	move.w	2(a5,d6.w),d4

	move.l	BLTBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	move.l	#$1,d5
	move.l	#$FFFFFFFF,d6
	CALL	bltDrawLine
	bra.s	.loop3

.loop4	rts

;===========================================================================;
;                          *** 3-D Rotieren ***
;===========================================================================;
;d0,d1,d2   x,y,z
;a0,a1,a2   umx,umy,umz

Rotate:	MOVEM.L	D3-D7/A3-A6,-(SP)
	lea	CosTable(pc),a3
	lea	SinTable(pc),a4
	cmp.w	#0,a2
	beq.s	rot_1
	move.w	d0,d4
	move.w	d1,d5
	muls	(a3,a2.w),d4
	muls	(a4,a2.w),d5
	sub.l	d5,d4
	asr.l	#8,d4
	move.w	d4,d6
	move.w	d0,d4
	move.w	d1,d5
	muls	(a4,a2.w),d4
	muls	(a3,a2.w),d5
	add.l	d4,d5
	asr.l	#8,d5
	move.w	d5,d1
	move.w	d6,d0

rot_1:	cmp.w	#0,a0
	beq.s	rot_2
	move.w	d2,d4
	move.w	d1,d5
	muls	(a3,a0.w),d4
	muls	(a4,a0.w),d5
	sub.l	d5,d4
	asr.l	#8,d4
	move.w	d4,d6
	move.w	d2,d4
	move.w	d1,d5
	muls	(a4,a0.w),d4
	muls	(a3,a0.w),d5
	add.l	d4,d5
	asr.l	#8,d5
	move.w	d5,d1
	move.w	d6,d2

rot_2:	cmp.w	#0,a1
	beq.s	rot_end
	move.w	d0,d4
	move.w	d2,d5
	muls	(a3,a1.w),d4
	muls	(a4,a1.w),d5
	sub.l	d5,d4
	asr.l	#8,d4
	move.w	d4,d6
	move.w	d0,d4
	move.w	d2,d5
	muls	(a4,a1.w),d4
	muls	(a3,a1.w),d5
	add.l	d4,d5
	asr.l	#8,d5
	move.w	d5,d2
	move.w	d6,d0
rot_end	MOVEM.L	(SP)+,D3-D7/A3-A6
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	dc.l  0

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,320
		dc.l  GSA_Height,256
		dc.l  GSA_ScrMode,SM_LORES
		dc.l  GSA_Attrib,SCR_DBLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Palette,.palette
		dc.l    BMA_Type,ILBM
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,2
		dc.l  $000000,$FFFFFF

;===========================================================================;

LineObject:
	INCBIN	"GMSDev:Source/Asm/Vectors/lineship.l"

AngleX:	dc.w	0
AngleY:	dc.w	0
AngleZ:	dc.w	0

DrawTable:
	dcb.b	1000

CosTable:
	dc.w	256,256,256,255,255,254,253,252
	dc.w	251,250,248,247,245,243,241,239
	dc.w	237,234,231,229,226,223,220,216
	dc.w	213,209,206,202,198,194,190,185
	dc.w	181,177,172,167,162,157,152,147
	dc.w	142,137,132,126,121,115,109,104
	dc.w	098,092,086,080,074,068,062,056
	dc.w	050,044,038,031,025,019,013,006
	dc.w	-000,-005,-012,-018,-024,-030,-037,-043
	dc.w	-049,-055,-061,-067,-073,-079,-085,-091
	dc.w	-097,-103,-108,-114,-120,-125,-131,-136
	dc.w	-141,-146,-151,-156,-161,-166,-171,-176
	dc.w	-180,-184,-189,-193,-197,-201,-205,-208
	dc.w	-212,-215,-219,-222,-225,-228,-230,-233
	dc.w	-236,-238,-240,-242,-244,-246,-247,-249
	dc.w	-250,-251,-252,-253,-254,-254,-255,-255
	dc.w	-255,-255,-255,-254,-254,-253,-252,-251
	dc.w	-250,-249,-247,-246,-244,-242,-240,-238
	dc.w	-236,-233,-230,-228,-225,-222,-219,-215
	dc.w	-212,-208,-205,-201,-197,-193,-189,-184
	dc.w	-180,-176,-171,-166,-161,-156,-151,-146
	dc.w	-141,-136,-131,-125,-120,-114,-108,-103
	dc.w	-097,-091,-085,-079,-073,-067,-061,-055
	dc.w	-049,-043,-037,-030,-024,-018,-012,-005
	dc.w	000,006,013,019,025,031,038,044
	dc.w	050,056,062,068,074,080,086,092
	dc.w	098,104,109,115,121,126,132,137
	dc.w	142,147,152,158,162,167,172,177
	dc.w	181,185,190,194,198,202,206,209
	dc.w	213,216,220,223,226,229,231,234
	dc.w	237,239,241,243,245,247,248,250
	dc.w	251,252,253,254,255,255,256,256

SinTable:
	dc.w	-000,-005,-012,-018,-024,-030,-037,-043
	dc.w	-049,-055,-061,-067,-073,-079,-085,-091
	dc.w	-097,-103,-108,-114,-120,-125,-131,-136
	dc.w	-141,-146,-151,-156,-161,-166,-171,-176
	dc.w	-180,-184,-189,-193,-197,-201,-205,-208
	dc.w	-212,-215,-219,-222,-225,-228,-230,-233
	dc.w	-236,-238,-240,-242,-244,-246,-247,-249
	dc.w	-250,-251,-252,-253,-254,-254,-255,-255
	dc.w	-255,-255,-255,-254,-254,-253,-252,-251
	dc.w	-250,-249,-247,-246,-244,-242,-240,-238
	dc.w	-236,-233,-230,-228,-225,-222,-219,-215
	dc.w	-212,-208,-205,-201,-197,-193,-189,-184
	dc.w	-180,-176,-171,-166,-161,-156,-151,-146
	dc.w	-141,-136,-131,-125,-120,-114,-108,-103
	dc.w	-097,-091,-085,-079,-073,-067,-061,-055
	dc.w	-049,-043,-037,-030,-024,-018,-012,-005
	dc.w	000,006,013,019,025,031,038,044
	dc.w	050,056,062,068,074,080,086,092
	dc.w	098,104,109,115,121,126,132,137
	dc.w	142,147,152,158,162,167,172,177
	dc.w	181,185,190,194,198,202,206,209
	dc.w	213,216,220,223,226,229,231,234
	dc.w	237,239,241,243,245,247,248,250
	dc.w	251,252,253,254,255,255,256,256
	dc.w	256,256,256,255,255,254,253,252
	dc.w	251,250,248,247,245,243,241,239
	dc.w	237,234,231,229,226,223,220,216
	dc.w	213,209,206,202,198,194,190,185
	dc.w	181,177,172,167,162,157,152,147
	dc.w	142,137,132,126,121,115,109,104
	dc.w	098,092,086,080,074,068,062,056
	dc.w	050,044,038,031,025,019,013,006
	dc.w	000


;===========================================================================;

ProgName:	dc.b  "Vector Example",0
ProgAuthor:	dc.b  "Original by ALLOC.",0
ProgDate:	dc.b  "June 1998",0
ProgCopyright:	dc.b  "Converted from TSB's vector designer.",0
ProgShort:	dc.b  "Simple vector demonstration.",0
		even

