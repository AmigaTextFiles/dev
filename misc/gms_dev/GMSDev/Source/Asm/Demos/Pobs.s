;-------T-------T------------------------T----------------------------------;
;This demo originally came from the HowToCode series.
;
;This demo took just 15 minutes in being converted to a multi-tasking demo,
;with no speed loss in run-time.

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

width	EQU	40
height	EQU	256

	SECTION	"Pobs",CODE

;==========================================================================;
;                             INITIALISE DEMO
;==========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	ScreenTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Screen(pc),a0
	CALL	Display

	moveq	#ID_JOYDATA,d0	;Get joydata structure.
	CALL	Get
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0	;Initialise the joydata structure.
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;==========================================================================;
;                                MAIN LOOP
;==========================================================================;

Main:	bsr.s	InPtabs
	bsr.w	Rmasks

.loop	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL

	move.l	Screen(pc),a0
	CALL	scrSwapBuffers

	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a1	;a1 = Screen
	move.l	GS_Bitmap(a1),a0	;a0 = Bitmap
	CALL	Clear

	bsr.w	Calc
	bsr.w	Put

	cmp.w	#293-1,number
	beq.b	.mouse
	addq.w	#1,number

.mouse	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	beq.s	.loop
	rts

;===========================================================================;
;                            SET UP POB TABLES
;===========================================================================;

InPtabs	lea	pob_xbuffer,a0	;a0 = Ptr to XBuffer.
	moveq	#$00,d0	;d0 = 00.
.xloop	move.w	d0,d1
	and.w	#$000f,d1	;d1 = $000x
	lsl.w	#6,d1	;d1 = <<6
	move.w	d1,(a0)+	;a0 = +d1
	move.w	d0,d1
	and.w	#$fff0,d1	;d2 = $xxx0
	ror.w	#3,d1	;d2 = $?xxx
	move.w	d1,(a0)+	;a0 = +d2
	addq.w	#1,d0	;d0 = ++1
	cmp.w	#width*8,d0	;d0 > Is d0 == ScreenWidth?
	bne.b	.xloop

	lea	pob_ybuffer,a0
	moveq	#$00,d0
.yloop	move.w	d0,d1
	mulu	#width,d1
	move.l	d1,(a0)+
	addq.w	#1,d0
	cmp.w	#height,d0
	bne.b	.yloop
	rts

;===========================================================================;
;
;===========================================================================;

Rmasks:	moveq	#0,d7
	lea	shape_buffer,a1
.loop1	lea	pob_shape(pc),a0
	move.w	#16,d6
.loop2	move.l	(a0)+,d0
	ror.l	d7,d0
	move.l	d0,(a1)+
	subq.w	#1,d6
	bne.b	.loop2
	addq.w	#1,d7
	cmpi.w	#16,d7
	bne.b	.loop1
	rts

;===========================================================================;
;                       ADJUST POB SCREEN POSITIONS
;===========================================================================;

Calc:	move.w	#$eeee,d0
	move.w	#720,d6
	lea	sinx_pointer1(pc),a0

	movem.l	(a0),a2/a3/a4/a5
	movem.w	sinx_add1(pc),d2/d3/d4/d5

	add.w	d2,a2
	cmp.w	(a2),d0
	bne.s	.bkip1
	sub.w	d6,a2

.bkip1	add.w	d3,a3
	cmp.w	(a3),d0
	bne.s	.bkip2
	sub.w	d6,a3

.bkip2	add.w	d4,a4
	cmp.w	(a4),d0
	bne.s	.bkip3
	sub.w	d6,a4

.bkip3	add.w	d5,a5
	cmp.w	(a5),d0
	bne.s	.bkip4
	sub.w	d6,a5

.bkip4	movem.l	a2/a3/a4/a5,(a0)
	lea	coord_stack,a0
	movem.w	sinx_dist1(pc),d3-d4/a1/a6
	move.w	d0,d5
	move.w	number(pc),d7	;d7 = Number of Pobs.
.loop	add.w	d3,a2
	add.w	d4,a3
	cmp.w	(a2),d5
	bne.s	.not_x1
	sub.w	d6,a2
.not_x1	cmp.w	(a3),d5
	bne.s	.not_x2
	suba.w	d6,a3
.not_x2	move.w	(a2),d0
	add.w	(a3),d0
	add.w	a1,a4
	add.w	a6,a5
	cmp.w	(a4),d5
	bne.b	.not_y1
	sub.w	d6,a4
.not_y1	cmp.w	(a5),d5
	bne.b	.not_y2
	sub.w	d6,a5
.not_y2	move.w	(a4),d1
	add.w	(a5),d1
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	dbf	d7,.loop
	rts

;===========================================================================;
;                          PLACE POBS ON SCREEN
;===========================================================================;

Put:	lea	pob_xbuffer,a0
	lea	pob_ybuffer,a1
	lea	shape_buffer,a4
	move.l	Screen(pc),a6
	move.l	GS_MemPtr2(a6),a6
	lea	coord_stack,a5

	move.w	number(pc),d7
.loop	movem.w	(a5)+,d0/d1	;d0 = X, d1 = Y
	add.w	d0,d0
	add.w	d0,d0	;d0 = (XCoord)*4
	add.w	d1,d1
	add.w	d1,d1	;d1 = (YCoord)*4
	move.l	(a0,d0.w),d0
	lea	width(a6,d0.w),a3
	add.l	(a1,d1.w),a3
	swap	d0
	lea	(a4,d0.w),a2
	movem.l	(a2),d0-d5	;d0..d5 = POB Gfx Data. 
	or.l	d0,(a3)
	or.l	d1,width(a3)
	or.l	d2,width*2(a3)
	or.l	d3,width*3(a3)
	or.l	d4,width*4(a3)
	or.l	d5,width*5(a3)
	dbf	d7,.loop
	rts

;===========================================================================;
;
;===========================================================================;

JoyData:	dc.l  0

sinx_pointer1:	dc.l  sin_xtab
sinx_pointer2:	dc.l  sin_xtab
siny_pointer1:	dc.l  sin_ytab
siny_pointer2:	dc.l  sin_ytab
sinx_add1:	dc.w  1*2	;change values here to obtain
sinx_add2:	dc.w  5*2	;new patterns
siny_add1:	dc.w  3*2
siny_add2:	dc.w  2*2
sinx_dist1:	dc.w  4*2
sinx_dist2:	dc.w  3*2
siny_dist1:	dc.w  1*2
siny_dist2:	dc.w  2*2
number:		dc.w  0			;number of 'pobs'

sin_xtab:
	dc.w	75,76,78,79,80,82,83,84
	dc.w	85,87,88,89,91,92,93,94
	dc.w	96,97,98,99,101,102,103,104
	dc.w	106,107,108,109,110,111,112,114
	dc.w	115,116,117,118,119,120,121,122
	dc.w	123,124,125,126,127,128,129,130
	dc.w	131,132,132,133,134,135,136,136
	dc.w	137,138,139,139,140,141,141,142
	dc.w	142,143,144,144,145,145,145,146
	dc.w	146,147,147,147,148,148,148,149
	dc.w	149,149,149,149,150,150,150,150
	dc.w	150,150,150,150,150,150,150,150
	dc.w	150,149,149,149,149,149,148,148
	dc.w	148,147,147,147,146,146,145,145
	dc.w	145,144,144,143,142,142,141,141
	dc.w	140,139,139,138,137,136,136,135
	dc.w	134,133,132,132,131,130,129,128
	dc.w	127,126,125,124,123,122,121,120
	dc.w	119,118,117,116,115,114,113,111
	dc.w	110,109,108,107,106,104,103,102
	dc.w	101,99,98,97,96,94,93,92
	dc.w	91,89,88,87,85,84,83,82
	dc.w	80,79,78,76,75,74,72,71
	dc.w	70,68,67,66,65,63,62,61
	dc.w	59,58,57,56,54,53,52,51
	dc.w	49,48,47,46,44,43,42,41
	dc.w	40,39,38,36,35,34,33,32
	dc.w	31,30,29,28,27,26,25,24
	dc.w	23,22,21,20,19,18,18,17
	dc.w	16,15,14,14,13,12,11,11
	dc.w	10,9,9,8,8,7,6,6
	dc.w	5,5,5,4,4,3,3,3
	dc.w	2,2,2,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,1,1,1
	dc.w	1,1,2,2,2,3,3,3
	dc.w	4,4,5,5,5,6,6,7
	dc.w	8,8,9,9,10,11,11,12
	dc.w	13,14,14,15,16,17,18,18
	dc.w	19,20,21,22,23,24,25,26
	dc.w	27,28,29,30,31,32,33,34
	dc.w	35,36,37,39,40,41,42,43
	dc.w	44,46,47,48,49,51,52,53
	dc.w	54,56,57,58,59,61,62,63
	dc.w	65,66,67,68,70,71,72,74
	dc.w	75
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee

sin_ytab:
	dc.w	57,59,60,61,62,63,64,65
	dc.w	66,66,67,68,69,70,71,72
	dc.w	73,74,75,76,77,78,79,80
	dc.w	81,82,83,84,84,85,86,87
	dc.w	88,89,90,90,91,92,93,94
	dc.w	94,95,96,97,97,98,99,100
	dc.w	100,101,102,102,103,103,104,105
	dc.w	105,106,106,107,107,108,108,109
	dc.w	109,110,110,110,111,111,112,112
	dc.w	112,112,113,113,113,114,114,114
	dc.w	114,114,114,115,115,115,115,115
	dc.w	115,115,115,115,115,115,115,115
	dc.w	115,115,114,114,114,114,114,114
	dc.w	113,113,113,112,112,112,112,111
	dc.w	111,110,110,110,109,109,108,108
	dc.w	107,107,106,106,105,105,104,103
	dc.w	103,102,102,101,100,100,99,98
	dc.w	97,97,96,95,94,94,93,92
	dc.w	91,90,90,89,88,87,86,85
	dc.w	84,84,83,82,81,80,79,78
	dc.w	77,76,75,74,73,72,71,70
	dc.w	69,68,67,66,66,65,64,63
	dc.w	62,61,60,59,58,56,55,54
	dc.w	53,52,51,50,49,49,48,47
	dc.w	46,45,44,43,42,41,40,39
	dc.w	38,37,36,35,34,33,32,31
	dc.w	31,30,29,28,27,26,25,25
	dc.w	24,23,22,21,21,20,19,18
	dc.w	18,17,16,15,15,14,13,13
	dc.w	12,12,11,10,10,9,9,8
	dc.w	8,7,7,6,6,5,5,5
	dc.w	4,4,3,3,3,3,2,2
	dc.w	2,1,1,1,1,1,1,0
	dc.w	0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,1,1
	dc.w	1,1,1,1,2,2,2,3
	dc.w	3,3,3,4,4,5,5,5
	dc.w	6,6,7,7,8,8,9,9
	dc.w	10,10,11,12,12,13,13,14
	dc.w	15,15,16,17,18,18,19,20
	dc.w	21,21,22,23,24,25,25,26
	dc.w	27,28,29,30,31,31,32,33
	dc.w	34,35,36,37,38,39,40,41
	dc.w	42,43,44,45,46,47,48,49
	dc.w	49,50,51,52,53,54,55,56
	dc.w	57
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee

pob_shape:
	dc.w	%0000000110000000,0
	dc.w	%0000000110000000,0
	dc.w	%0000011111100000,0
	dc.w	%0000011111100000,0
	dc.w	%0000000110000000,0
	dc.w	%0000000110000000,0

;===========================================================================;
;                                  DATA
;===========================================================================;

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_MemPtr1,ScreenMem
		dc.l  GSA_MemPtr2,ScreenMem+height*width
		dc.l  GSA_MemPtr3,ScreenMem+height*width*2
		dc.l  GSA_Width,320
		dc.l  GSA_Height,256
		dc.l  GSA_Attrib,SCR_TPLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Type,PLANAR
		dc.l    BMA_Palette,.palette
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,2
		dc.l  $00000000,$00f0f000

;===========================================================================;

	SECTION	Screens,BSS_C

ScreenMem:	ds.b  (height*width*3)+(width*50)
shape_buffer:	ds.l  256
pob_xbuffer:	ds.l  (width*8)
pob_ybuffer:	ds.l  height
coord_stack:	ds.l  1500

;===========================================================================;

ProgName:	dc.b  "Pobs",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Triple buffered bob demonstration.",0
		even

