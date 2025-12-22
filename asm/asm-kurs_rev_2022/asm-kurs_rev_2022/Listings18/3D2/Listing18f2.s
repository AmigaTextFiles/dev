
; Listing18f2.s = Nexcube3Axis.s

*************************************************************************
* Dot Cube med "glenz effekt" 3600 punkter incl. Snyd, Held mv...	*
* Den bliver pga. rastertid kun roteret om 2 af akserne!		*
* Der er et sted i sources, hvor det roter om akserne fjern ;;;;;osv	*
* Det stykke hvor den tredie akse er slået fra...     /Chivas		*
*************************************************************************
	
	section	baaa,code

Start:
		movem.l	d0-a6,-(a7)
		move.w	intenar+Custom,intBackup
		move	#$7fff,intena+Custom
		move	#$7fff,dmacon+Custom
		move.l	$6c,interbackup
		move.l	#MyInt,$6c
		move	#%1100000000100000,intena+Custom
		move	#%1000011111000000,dmacon+Custom


		bsr.w	Calc_Cube

Loop:		cmpi.b	#$ff,$dff006
		bne.b	loop

		btst	#10,$dff016
		beq.b	.pau
		cmp	#810,zoomfactor
		bgt	.donz
		add.w	#40,zoomfactor
.donz

		bsr.w	Rot3D		; rotate & draw
		move.w	#$0020,$dff180
		bsr.w	Dobbeltbuffer
.pau

		btst	#6,$bfe001
		bne.b	loop
 
		move.w	dmaBackup,d0
		or.w	#$8000,d0
		move	d0,dmacon+Custom

		move	#$7fff,intena+Custom
		move.l	interbackup,$6c
		move.w	intBackup,d0
		or.w	#$8000,d0		; bit #15
		move	d0,intena+Custom
		movem.l	(a7)+,d0-a6
		rts

***** INTERRUPT ***************************************************************
MyInt:		movem.l	d0-a6,-(a7)
		move.w	intreqr+Custom,d0
		btst	#5,d0
		beq.b	fuckcop

		lea	copper,a0
		move.l	a0,cop2lch+Custom
		tst	copjmp2+Custom

Fuckcop:	movem.l	(a7)+,d0-a6
		move.w	#%0000000000100000,intreq+Custom
		rte
intbackup	dc.l	0
dmabackup	dc.l	0
interbackup	dc.l	0


	




***** CALCULATE NEXCUBE *******************************************************
;* 10*10*  6 faces = 600 plots
Calc_cube:	
; range	-200 -> +200  (grid)
	Lea	cords,A0
	*** FACE 1 *****
	Move.w	#99,d7		; Dots Per Face-1
	Move.w	#-200,d0	; X
	Move.w	#-200,d1	; Y
	Move.w	#-200,d2	; Z
.fac1	move.w	d0,(a0)+
	Move.w	d1,(a0)+
	move.w	d2,(a0)+
	Add.w	#grid,d0
	cmp	#200,d0
	blt.b	.con1
	move.w	#-200,d0
	add.w	#grid,d1
.con1	dbf	d7,.Fac1
	*//////////////*
	*** FACE 2 *****
	Move.w	#99,d7		; Dots Per Face-1
	Move.w	#-200,d0	; X
	Move.w	#-200,d1	; Y
	Move.w	#200,d2	; Z
.fac2	move.w	d0,(a0)+
	Move.w	d1,(a0)+
	move.w	d2,(a0)+
	Add.w	#grid,d0
	cmp	#200,d0
	blt.b	.con2
	move.w	#-200,d0
	add.w	#grid,d1
.con2	dbf	d7,.Fac2
	*//////////////*

	*** FACE 3 *****
	Move.w	#99,d7		; Dots Per Face-1
	Move.w	#-200,d0	; X
	Move.w	#-200,d1	; Y
	Move.w	#-200,d2	; Z
.fac3	move.w	d0,(a0)+
	Move.w	d1,(a0)+
	move.w	d2,(a0)+
	Add.w	#grid,d1
	cmp	#200,d1
	blt.b	.con3
	move.w	#-200,d1
	add.w	#grid,d2
.con3	dbf	d7,.Fac3
	*//////////////*

	*** FACE 4 *****
	Move.w	#99,d7		; Dots Per Face-1
	Move.w	#200,d0	; X
	Move.w	#-200,d1	; Y
	Move.w	#-200,d2	; Z
.fac4	move.w	d0,(a0)+
	Move.w	d1,(a0)+
	move.w	d2,(a0)+
	Add.w	#grid,d1
	cmp	#200,d1
	blt.b	.con4
	move.w	#-200,d1
	add.w	#grid,d2
.con4	dbf	d7,.Fac4
	*//////////////*
		
	*** FACE 5 *****
	Move.w	#99,d7		; Dots Per Face-1
	Move.w	#-200,d0		; X
	Move.w	#200,d1		; Y
	Move.w	#-200,d2	; Z
.fac5	move.w	d0,(a0)+
	Move.w	d1,(a0)+
	move.w	d2,(a0)+
	Add.w	#grid,d2
	cmp	#200,d2
	blt.b	.con5
	move.w	#-200,d2
	add.w	#grid,d0
.con5	dbf	d7,.Fac5
	*//////////////*
		

	*** FACE 5 *****
	Move.w	#99,d7		; Dots Per Face-1
	Move.w	#-200,d0		; X
	Move.w	#-200,d1		; Y
	Move.w	#-200,d2	; Z
.fac6	move.w	d0,(a0)+
	Move.w	d1,(a0)+
	move.w	d2,(a0)+
	Add.w	#grid,d2
	cmp	#200,d2
	blt.b	.con6
	move.w	#-200,d2
	add.w	#grid,d0
.con6	dbf	d7,.Fac6
	*//////////////*
		

	
	Rts
GRID		equ	40
	

***** DOBBELTBUFFERING ********************************************************

DobbeltBuffer:

;show->	Show,Work2,work3,work4    WORK1=WORK!!

	Move.l	Showscr,d0
	Move.l	workscr1,Showscr
	Move.l	Workscr2,workscr1
	Move.l	Workscr3,workscr2
	move.l	d0,workscr3
	
	Move.l	Showscr,d0
	move	d0,bplptr1+6
	swap	d0
	move	d0,bplptr1+2

	Move.l	workscr2,d0
	move	d0,bplptr2+6
	swap	d0
	move	d0,bplptr2+2

	Move.l	workscr3,d0
	move	d0,bplptr3+6
	swap	d0
	move	d0,bplptr3+2
		
		rts

WorkScr1:	dc.l	screen1			; The REAL workscreen
Workscr2:	dc.l	screen2
Workscr3:	dc.l	screen3
ShowScr:	dc.l	screen4
		rts

*******************************************************************************

Rot3D:	
; Clear workscreen
		lea	Custom,a0

aas:
	btst	#6,2(a0)	; waitblit
	bne.s	aas

		move.l	workscr1(pc),a1
		move.l	a1,bltdpth(a0)
		move.w	#0,bltdmod(a0)
		move.w	#$0900,bltcon0(a0)
		move.w	#0,bltcon1(a0)
		move.w	#256<<6+20,bltsize(a0)

		bsr.b	Rotate
		bsr.w	Drawdot
		
		rts

***** ROTATE ******************************************************************
Rotate:	
;(X,Y)=(X*COS(V)-Y*SIN(V),X*SIN(V)+Y*COS(V))

		addq	#8,Angley		
		and	#512-1,Angley

		addq	#2,Anglex
		and	#512-1,Anglex

		addq	#4,AngleZ
		and	#512-1,AngleZ

		lea	cosinus(pc),a0
		lea	sinus(pc),a1
		lea	Cords(pc),a2
		lea	CordsR(pc),a3
		
Trans:		move	(a2)+,d1	;x
		move	(a2)+,d2	;y	
		move	(a2)+,d3	;z
	
		cmp	#$1111,d1	;Test if end
		beq.w	stoprot
		
;(X,Y)=(X*COS(V)-Y*SIN(V),X*SIN(V)+Y*COS(V))

		move.w	AngleZ(pc),d0
		add	d0,d0
		move.w	(a0,d0.w),d5
		muls	d1,d5
		move	(a1,d0.w),d4
		muls	d2,d4
		sub.l	d4,d5
		swap	d5
		rol.l	#6,d5

		move.w	(a1,d0.w),d6
		muls	d1,d6
		move.w	(a0,d0.w),d4
		muls	d2,d4
		add.l	d4,d6
		swap	d6
		rol.l	#6,d6
		move	d5,d1
		move	d6,d2
	
;(X,Z)=(X*COS(V)-Z*SIN(V),X*SIN(V)+Z*COS(V))

		move	AngleY(pc),d0
		add	d0,d0
		move	(a0,d0.w),d5
		muls	d1,d5
	        move	(a1,d0.w),d4
		muls	d3,d4
		sub.l	d4,d5
		swap	d5
        	rol.l	#6,d5

		move	(a1,d0.w),d6
		muls	d1,d6
		move	(a0,d0.w),d4
		muls	d3,d4
		add.l	d4,d6
		swap	d6
		rol.l	#6,d6
		move	d5,d1
		move	d6,d3

;(Y,Z)=(Y*COS(V)-Z*SIN(V),Y*SIN(V)+Z*COS(V))

		move	AngleX(pc),d0
		add	d0,d0
		move	(a0,d0.w),d5
		muls	d2,d5
		move	(a1,d0.w),d4
		muls	d3,d4
		sub.l	d4,d5
		swap	d5
		rol.l	#6,d5

		move	(a1,d0.w),d6
		muls	d2,d6
		move	(a0,d0.w),d4
		muls	d3,d4
		add.l	d4,d6
		swap	d6
		rol.l	#6,d6
		move	d5,d2
		move	d6,d3

		

		add.w	ZoomFactor,d3		;Zoom and perspektive
		muls	d3,d1
		muls	d3,d2
		divs	#2790,d1
		divs	#2790,d2


		move	d1,(a3)+

		move	d2,(a3)+

		bra.w	Trans
Stoprot:	rts
ZoomFactor	dc.w	0
***** DOTDRAW *****************************************************************
Drawdot:	lea	cordsR(pc),a0
nextdot:	
		move.l	workscr1,a1		

		Move.w	(a0)+,d0
		cmp	#$1111,d0
		beq.b	enddots

		add	abs_x,d0

		move.w 	d0,d1		
		lsr 	#3,d1		
		add 	d1,a1		
		lsl	#3,d1		
		sub 	d1,d0		
		move 	(a0)+,d1		
		add.w	abs_y,d1
		mulu 	#40,d1		
		add 	d1,a1		
		moveq 	#7,d1		
		sub 	d0,d1		 	
		bset	d1,(a1)	
		********/****		

		add.w	#160,a1	;2*pixel PR0V at skrive 40 i stedet for 160
		bset	d1,(a1)
	
		bra.b	nextdot
enddots:	rts
abs_x		dc.w	160
abs_y		dc.w	130

;------------------------------------------------------------------------------

Lowx:		dc.w	0
Lowy:		dc.w	0
Highy:		dc.w	0
Highx:		dc.w	0
***** TABELLER ****************************************************************

CoSinus:	* 512 

	dc.w	1024,1024,1024,1023,1023,1022,1021,1020
	dc.w	1019,1018,1016,1015,1013,1011,1009,1007
	dc.w	1004,1002,999,996,993,990,987,983
	dc.w	980,976,972,968,964,960,955,951
	dc.w	946,941,936,931,926,920,915,909
	dc.w	903,897,891,885,878,872,865,858
	dc.w	851,844,837,830,822,815,807,799
	dc.w	792,784,775,767,759,750,742,733
	dc.w	724,715,706,697,688,678,669,659
	dc.w	650,640,630,620,610,600,590,579
	dc.w	569,558,548,537,526,516,505,494
	dc.w	483,472,460,449,438,426,415,403
	dc.w	392,380,369,357,345,333,321,309
	dc.w	297,285,273,261,249,237,224,212
	dc.w	200,187,175,163,150,138,125,113
	dc.w	100,88,75,63,50,38,25,13
	dc.w	0,-12,-24,-37,-49,-62,-74,-87
	dc.w	-99,-112,-124,-137,-149,-162,-174,-186
	dc.w	-199,-211,-223,-236,-248,-260,-272,-284
	dc.w	-296,-308,-320,-332,-344,-356,-368,-379
	dc.w	-391,-402,-414,-425,-437,-448,-459,-471
	dc.w	-482,-493,-504,-515,-525,-536,-547,-557
	dc.w	-568,-578,-589,-599,-609,-619,-629,-639
	dc.w	-649,-658,-668,-677,-687,-696,-705,-714
	dc.w	-723,-732,-741,-749,-758,-766,-774,-783
	dc.w	-791,-798,-806,-814,-821,-829,-836,-843
	dc.w	-850,-857,-864,-871,-877,-884,-890,-896
	dc.w	-902,-908,-914,-919,-925,-930,-935,-940
	dc.w	-945,-950,-954,-959,-963,-967,-971,-975
	dc.w	-979,-982,-986,-989,-992,-995,-998,-1001
	dc.w	-1003,-1006,-1008,-1010,-1012,-1014,-1015,-1017
	dc.w	-1018,-1019,-1020,-1021,-1022,-1022,-1023,-1023
	dc.w	-1023,-1023,-1023,-1022,-1022,-1021,-1020,-1019
	dc.w	-1018,-1017,-1015,-1014,-1012,-1010,-1008,-1006
	dc.w	-1003,-1001,-998,-995,-992,-989,-986,-982
	dc.w	-979,-975,-971,-967,-963,-959,-954,-950
	dc.w	-945,-940,-935,-930,-925,-919,-914,-908
	dc.w	-902,-896,-890,-884,-877,-871,-864,-857
	dc.w	-850,-843,-836,-829,-821,-814,-806,-798
	dc.w	-791,-783,-774,-766,-758,-749,-741,-732
	dc.w	-723,-714,-705,-696,-687,-677,-668,-658
	dc.w	-649,-639,-629,-619,-609,-599,-589,-578
	dc.w	-568,-557,-547,-536,-525,-515,-504,-493
	dc.w	-482,-471,-459,-448,-437,-425,-414,-402
	dc.w	-391,-379,-368,-356,-344,-332,-320,-308
	dc.w	-296,-284,-272,-260,-248,-236,-223,-211
	dc.w	-199,-186,-174,-162,-149,-137,-124,-112
	dc.w	-99,-87,-74,-62,-49,-37,-24,-12
	dc.w	0,13,25,38,50,63,75,88
	dc.w	100,113,125,138,150,163,175,187
	dc.w	200,212,224,237,249,261,273,285
	dc.w	297,309,321,333,345,357,369,380
	dc.w	392,403,415,426,438,449,460,472
	dc.w	483,494,505,516,526,537,548,558
	dc.w	569,579,590,600,610,620,630,640
	dc.w	650,659,669,678,688,697,706,715
	dc.w	724,733,742,750,759,767,775,784
	dc.w	792,799,807,815,822,830,837,844
	dc.w	851,858,865,872,878,885,891,897
	dc.w	903,909,915,920,926,931,936,941
	dc.w	946,951,955,960,964,968,972,976
	dc.w	980,983,987,990,993,996,999,1002
	dc.w	1004,1007,1009,1011,1013,1015,1016,1018
	dc.w	1019,1020,1021,1022,1023,1023,1024,1024


Sinus:	* 512 *
	dc.w	0,13,25,38,50,63,75,88
	dc.w	100,113,125,138,150,163,175,187
	dc.w	200,212,224,237,249,261,273,285
	dc.w	297,309,321,333,345,357,369,380
	dc.w	392,403,415,426,438,449,460,472
	dc.w	483,494,505,516,526,537,548,558
	dc.w	569,579,590,600,610,620,630,640
	dc.w	650,659,669,678,688,697,706,715
	dc.w	724,733,742,750,759,767,775,784
	dc.w	792,799,807,815,822,830,837,844
	dc.w	851,858,865,872,878,885,891,897
	dc.w	903,909,915,920,926,931,936,941
	dc.w	946,951,955,960,964,968,972,976
	dc.w	980,983,987,990,993,996,999,1002
	dc.w	1004,1007,1009,1011,1013,1015,1016,1018
	dc.w	1019,1020,1021,1022,1023,1023,1024,1024
	dc.w	1024,1024,1024,1023,1023,1022,1021,1020
	dc.w	1019,1018,1016,1015,1013,1011,1009,1007
	dc.w	1004,1002,999,996,993,990,987,983
	dc.w	980,976,972,968,964,960,955,951
	dc.w	946,941,936,931,926,920,915,909
	dc.w	903,897,891,885,878,872,865,858
	dc.w	851,844,837,830,822,815,807,799
	dc.w	792,784,775,767,759,750,742,733
	dc.w	724,715,706,697,688,678,669,659
	dc.w	650,640,630,620,610,600,590,579
	dc.w	569,558,548,537,526,516,505,494
	dc.w	483,472,460,449,438,426,415,403
	dc.w	392,380,369,357,345,333,321,309
	dc.w	297,285,273,261,249,237,224,212
	dc.w	200,187,175,163,150,138,125,113
	dc.w	100,88,75,63,50,38,25,13
	dc.w	0,-12,-24,-37,-49,-62,-74,-87
	dc.w	-99,-112,-124,-137,-149,-162,-174,-186
	dc.w	-199,-211,-223,-236,-248,-260,-272,-284
	dc.w	-296,-308,-320,-332,-344,-356,-368,-379
	dc.w	-391,-402,-414,-425,-437,-448,-459,-471
	dc.w	-482,-493,-504,-515,-525,-536,-547,-557
	dc.w	-568,-578,-589,-599,-609,-619,-629,-639
	dc.w	-649,-658,-668,-677,-687,-696,-705,-714
	dc.w	-723,-732,-741,-749,-758,-766,-774,-783
	dc.w	-791,-798,-806,-814,-821,-829,-836,-843
	dc.w	-850,-857,-864,-871,-877,-884,-890,-896
	dc.w	-902,-908,-914,-919,-925,-930,-935,-940
	dc.w	-945,-950,-954,-959,-963,-967,-971,-975
	dc.w	-979,-982,-986,-989,-992,-995,-998,-1001
	dc.w	-1003,-1006,-1008,-1010,-1012,-1014,-1015,-1017
	dc.w	-1018,-1019,-1020,-1021,-1022,-1022,-1023,-1023
	dc.w	-1023,-1023,-1023,-1022,-1022,-1021,-1020,-1019
	dc.w	-1018,-1017,-1015,-1014,-1012,-1010,-1008,-1006
	dc.w	-1003,-1001,-998,-995,-992,-989,-986,-982
	dc.w	-979,-975,-971,-967,-963,-959,-954,-950
	dc.w	-945,-940,-935,-930,-925,-919,-914,-908
	dc.w	-902,-896,-890,-884,-877,-871,-864,-857
	dc.w	-850,-843,-836,-829,-821,-814,-806,-798
	dc.w	-791,-783,-774,-766,-758,-749,-741,-732
	dc.w	-723,-714,-705,-696,-687,-677,-668,-658
	dc.w	-649,-639,-629,-619,-609,-599,-589,-578
	dc.w	-568,-557,-547,-536,-525,-515,-504,-493
	dc.w	-482,-471,-459,-448,-437,-425,-414,-402
	dc.w	-391,-379,-368,-356,-344,-332,-320,-308
	dc.w	-296,-284,-272,-260,-248,-236,-223,-211
	dc.w	-199,-186,-174,-162,-149,-137,-124,-112
	dc.w	-99,-87,-74,-62,-49,-37,-24,-12

Cords:

		ds.w	600*3			; 600 plots 
;
;		dc.w	 200, 200, 200
;		dc.w	-200, 200, 200
;		dc.w	 200,-200, 200
;		dc.w	-200,-200, 200
;
;		dc.w	 200, 200,-200
;		dc.w	-200, 200,-200
;		dc.w	 200,-200,-200
;		dc.w	-200,-200,-200
	
;		dc.w	 000, 000,-000		; Center of rotation

		dc.w	$1111			; No more Plots

	
CordsR:		blk.b	[[cordsR-cords-2]*2/3]
		even
		dc.w	$1111


AngleX:	dc.w	0
AngleY:	dc.w	0
AngleZ:	dc.w	0
***** COPPER ******************************************************************
	even

		section	coppera,data_c
Copper:
	
		Dc.w	$0180,$0000

Palette:	
		dc.w	$0182,$000f		;1	!
		dc.w	$0184,$000A		;2	!
		dc.w	$0188,$0008		;3	!	

		dc.w	$0186,$0fff		;1+2
		dc.w	$018a,$0CCF		;3+1
		dc.w	$018c,$A88F		;3+2
		dc.w	$018e,$044F		;3+2+1

		
		


		dc.w	bplcon0,$3200
		dc.w	bplcon1,$0
		dc.w	bplcon2,%0000000

BplPtr1:	dc.w	$00e0,0,$00e2,0
BplPtr2:	dc.w	$00e4,0,$00e6,0
BplPtr3:	dc.w	$00e8,0,$00ea,0

		dc.w	$008e,$2c81,$0090,$24c1
		dc.w	$0092,$0038,$0094,$00d0
		dc.w	$0108,$0,$010a,$0
		dc.w	-2		; gawn




		SECTION	BUFFERS,BSS_C

screen1:	ds.b	40*256
screen2:	ds.b	40*256
screen3:	ds.b	40*266
screen4:	ds.b	40*266


BLTDDAT = $000
DMACONR = $002
VPOSR   = $004
VHPOSR  = $006
DSKDATR = $008
JOY0DAT = $00A
JOY1DAT = $00C
CLXDAT  = $00E
ADKCONR = $010
POT0DAT = $012
POT1DAT = $014
POTGOR  = $016
POTINP  = $016
SERDATR = $018
DSKBYTR = $01A
INTENAR = $01C
INTREQR = $01E
DSKPTH  = $020
DSKPTL  = $022
DSKLEN  = $024
DSKDAT  = $026
REFPTR  = $028
VPOSW   = $02A
VHPOSW  = $02C
COPCON  = $02E
SERDAT  = $030
SERPER  = $032
POTGO   = $034
JOYTEST = $036
STREQU  = $038
STRVBL  = $03A
STRHOR  = $03C
STRLONG = $03E
BLTCON0 = $040
BLTCON1 = $042
BLTAFWM = $044
BLTALWM = $046
BLTCPTH = $048
BLTCPTL = $04A
BLTBPTH = $04C
BLTBPTL = $04E
BLTAPTH = $050
BLTAPTL = $052
BLTDPTH = $054
BLTDPTL = $056
BLTSIZE = $058
BLTCMOD = $060
BLTBMOD = $062
BLTAMOD = $064
BLTDMOD = $066
BLTCDAT = $070
BLTBDAT = $072
BLTADAT = $074
DSKSYNC = $07E
COP1LCH = $080
COP1LCL = $082
COP2LCH = $084
COP2LCL = $086
COPJMP1 = $088
COPJMP2 = $08A
COPINS  = $08C
DIWSTRT = $08E
DIWSTOP = $090
DDFSTRT = $092
DDFSTOP = $094
DMACON  = $096
CLXCON  = $98
INTENA  = $09A
INTREQ  = $09C
ADKCON  = $09E


BPLCON0 = $100
BPLCON1 = $102
BPLCON2 = $104
BPL1MOD = $108
BPL2MOD = $10A
BPL1DAT = $110
BPL2DAT = $112
BPL3DAT = $114
BPL4DAT = $116
BPL5DAT = $118
BPL6DAT = $11A
SPR0PTH = $120
SPR0PTL = $122
SPR1PTH = $124
SPR1PTL = $126
SPR2PTH = $128
SPR2PTL = $12A
SPR3PTH = $12C
SPR3PTL = $12E
SPR4PTH = $130
SPR4PTL = $132
SPR5PTH = $134
SPR5PTL = $136
SPR6PTH = $138
SPR6PTL = $13A
SPR7PTH = $13C
SPR7PTL = $13E
SPR0POS = $140
SPR0CTL = $142
SPR0DATA= $144
SPR0DATB= $146
SPR1POS = $148
SPR1CTL = $14A
SPR1DATA= $14C
SPR1DATB= $14E
SPR2POS = $150
SPR2CTL = $152
SPR2DATA= $154
SPR2DATB= $156
SPR3POS = $158
SPR3CTL = $15A
SPR3DATA= $15C
SPR3DATB= $15E
SPR4POS = $160
SPR4CTL = $162
SPR4DATA= $164
SPR4DATB= $166
SPR5POS = $168
SPR5CTL = $16A
SPR5DATA= $16C
SPR5DATB= $16E
SPR6POS = $170
SPR6CTL = $172
SPR6DATA= $174
SPR6DATB= $176
SPR7POS = $178
SPR7CTL = $17A
SPR7DATA= $17C
SPR7DATB= $17E
COLOR00 = $180
COLOR01 = $182
COLOR02 = $184
COLOR03 = $186
COLOR04 = $188
COLOR05 = $18A
COLOR06 = $18C
COLOR07 = $18E
COLOR08 = $190
COLOR09 = $192
COLOR10 = $194
COLOR11 = $196
COLOR12 = $198
COLOR13 = $19A
COLOR14 = $19C
COLOR15 = $19E
COLOR16 = $1A0
COLOR17 = $1A2
COLOR18 = $1A4
COLOR19 = $1A6
COLOR20 = $1A8
COLOR21 = $1AA
COLOR22 = $1AC
COLOR23 = $1AE
COLOR24 = $1B0
COLOR25 = $1B2
COLOR26 = $1B4
COLOR27 = $1B6
COLOR28 = $1B8
COLOR29 = $1BA
COLOR30 = $1BC
COLOR31 = $1BE


Custom=$DFF000

	END 


*******************************************************************************
