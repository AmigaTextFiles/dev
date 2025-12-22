
; Listing18e2.s = moving-sine.s

; coded by atlaw - fixed by Randy/COMAX in 1993
; - sine - copiato col blitter!!!

radsize:equ 40
scsize: equ radsize*263

		SECTION	SINMOV,CODE

multioff: 
	MOVEM.L	D0-D7/A0-A6,-(SP)
	move.l	$4.w,a6
        jsr	-132(a6)

	move.l	#$dff000,a6
systemout:
	move.l	#COPPER,$80(a6)		;COP1LC
	MOVE.w	#0,$88(a6)			;COPJMP1
	move.w	#0,$1fc(a6)
	lea	OLDONES(pc),a0
	move.w	$1C(a6),(a0)+		;INTENAR
	move.w	2(a6),(a0)+			;DMACONR

	MOVE.L	#SCREEN,d0
	LEA	BPL1,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.w	#$7fff,$96(a6)		;DMACON
	move.w	#$83c0,$96(a6)		;DMACON
	move.w	#$7fff,$9A(a6)		;INTENA
	clr.w	d3					;init
	move.w	#64,d4				;init

CHECK: 	
	cmpi.b	#$ff,$dff006
	bne.s	check
CHECK2: 	
	cmpi.b	#$ff,$dff006
	beq.s	check2

	bsr.w	sclr				; azzera schermo
	bsr.w	a					; plotta
	btst 	#$6,$bfe001
      	bne.S	CHECK
RETURN: 
	lea	OLDONES(pc),a0
	move.w	(a0)+,d0
	bset.L	#15,d0
	move.w	#$7fff,$9A(a6)		;INTENA
	move.w	d0,$9a(a6)			;INTENA
	move.w	(a0)+,d0
	bset.L	#15,d0
	move.w	#$7fff,$96(a6)		;DMACON
	move.w	d0,$96(a6)			;DMACON
	move.l	$4.W,a6
	lea	GFXNAME(pc),a1
	jsr	-$198(a6)
	move.l	d0,a0
	move.l	38(a0),$dff080		;COP1LCH
	MOVE.w	D0,$dff088			;COPJMP1
	jsr	-138(a6)
	MOVEM.L	(SP)+,D0-D7/A0-A6
	MOVEQ	#0,d0
        rts

OLDONES:
OLDINT:	dc.w	0
OLDDMA:	dc.w	0
GFXNAME:dc.b	"graphics.library",00

	EVEN

OLDSP:
	DC.L	0

SCLR:
	MOVEM.L	D0-D7/A0-A6,-(SP)
	MOVE.L	SP,OLDSP
	LEA	dend,SP
	MOVEM.L	(ZEROS),D0-D7/A0-A6
	dcb.l	140,$48E7FFFE		;60 BYTES CLEARED WITH 1 INSTRUCTION:
	MOVEA.L	OLDSP,SP			;MOVEM.L D0-D7/A0-A6,-(SP)
	MOVEM.L	(SP)+,D0-D7/A0-A6
	RTS

ZEROS:
	dcb.L	15,0


A:
	lea	sinelist(pc),a0
	moveq	#15,d7
	move.l	#$80008000,d1
aloop1:
	lea	screen+1200,a1
	clr.w	d0
	move.b	(a0,d3.w),d0
	mulu	#50,d0
	lsr.l	#8,d0
	mulu	#radsize,d0
	add.l	d0,a1
	clr.w	d0
	move.b	(a0,d4.w),d0
	mulu	#304,d0
	lsr.l	#8,d0
	ror.l	#4,d0
	add.w	d0,d0
	add.w	d0,a1
	swap	d0
	ori.w	#$0dfc,d0

	btst.B	#6,2(a6)
bwait:
	btst.B	#6,2(a6)
	bne.S	bwait

	move.l	#DATA,$50(a6)		;BLTAPTH
	move.l	a1,$4C(a6)			;BLTBPTH
	move.l	a1,$54(a6)			;BLTDPTH
	move.w	#$0000,$64(a6)		;BLTAMOD
	move.w	#radsize*9-4,$62(a6)	;BLTBMOD
	move.w	#radsize*9-4,$66(a6)	;BLTDMOD
	move.w	d0,$40(a6)			;BLTCON0
	move.w	#$0000,$42(a6)		;BLTCON1
	move.l	d1,$44(a6)			;BLTAFWM
	move.w	#$0402,$58(a6)		;BLTSIZE
	addq.b	#3,d3
	addq.b	#3,d4
	ror.l	#1,d1
	dbra	d7,aloop1
	sub.b	#16*3+3,d3
	sub.b	#16*3+2,d4
	rts


sinelist:;256 positioner (7 bitar),sin x*127:x=x+1.40625
 dc.b	127,130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176
 dc.b	178,181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219
 dc.b	221,223,225,227,229,231,233,234,236,238,239,240,242,243,244,245,247
 dc.b	248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254
 dc.b	253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239
 dc.b	238,236,234,233,231,229,227,225,223,221,219,217,215,212,210,208,205
 dc.b	203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,158
 dc.b	155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105
 dc.b	102,099,096,093,090,087,084,081,078,076,073,070,067,064,062,059,056
 dc.b	054,051,049,046,044,042,039,037,035,033,031,029,027,025,023,021,020
 dc.b	018,016,015,014,012,011,010,009,007,006,005,005,004,003,002,002,001
 dc.b	001,001,000,000,000,000,000,000,000,001,001,001,002,002,003,004,005
 dc.b	005,006,007,009,010,011,012,014,015,016,018,020,021,023,025,027,029
 dc.b	031,033,035,037,039,042,044,046,049,051,054,056,059,062,064,067,070
 dc.b	073,076,078,081,084,087,090,093,096,099,102,105,108,111,115,118,121
 dc.b	124,127

	SECTION	COPPER,DATA_C

COPPER:	
SpritePtrs:
	dc.w	$0120,$0000,$0122,$0000,$0124,$0000,$0126,$0000,$0128,$0000
	dc.w	$012a,$0000,$012c,$0000,$012e,$0000,$0130,$0000,$0132,$0000
	dc.w	$0134,$0000,$0136,$0000,$0138,$0000,$013a,$0000,$013c,$0000
	dc.w	$013e,$0000
	dc.w	$008e,$2c81,$0090,$2cc1
	dc.w	$0092,$0038,$0094,$00d0
	dc.w	$0102,$0000
	dc.w	$0104,$0000
	dc.w	$0108,$0000
	dc.w	$010a,$0000
	dc.w	$0100,$1200
col:
	dc.w	$0180,$0001,$0182,$08fc,$0184,$0ee0,$0186,$0e80
	dc.w	$0188,$0e00,$018a,$0668,$018c,$088a,$018e,$0aac
	dc.w	$0190,$0cce,$0192,$0464,$0194,$0242,$0196,$0c6e
	dc.w	$0198,$0eee,$019a,$0eee,$019c,$0eee,$019e,$0eee
bpl1:
	dc.w	$00e0,$000,$00e2,$0000
	dc.w	$ffff,$fffe  
	dc.w	$ffff,$fffe  


DATA:
	dc.w	%0111111111111110,0
	dc.w	%1111111111111111,0
	dc.w	%1111111111111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111111111111111,0
	dc.w	%1111111111111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0
	dc.w	%1111110000111111,0

	SECTION	SCREEN,BSS_C

	ds.b	10000
SCREEN:

	DS.B	9500
DEND:
	ds.b	1300

	END
