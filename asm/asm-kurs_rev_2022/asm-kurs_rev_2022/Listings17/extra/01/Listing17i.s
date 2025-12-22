
; Listing17i.s = pointmessage.S

* work done by shadow of ABYSS !

speed = 4

****************************************************************** trap

		move.l 	#init,$80
		trap	#0
		rts
		
***************************************************************** init

init:		lea	$dff000,a6	

		lea	$60000,a0
clrbpl:		clr.l	(a0)+
		cmp.l	#$65000,a0
		blt.s	clrbpl

		move.w	$1c(a6),d0			;intena read
		or.w	#$8000,d0
		move.w	d0,oldintena
		move.w	#$7fff,d0
		move.w	d0,$9a(a6)			;intena write
		move.w	d0,$9c(a6)			;intreq write

		bsr.w	initmultab
		bsr.w	inittext
		bsr.w	initcoordbuf

		move.l 	#cop,$80(a6)
		move.w	d0,$88(a6)
		move.w	#0,$1fc(a6)
		move.l	#0,$108(a6)
				
************************************************************** mainloop

wait:		cmp.b	#$ff,$06(a6)
		bne.s	wait
		
		btst	#06,$bfe001
		beq.w	ende		

;		move.w 	#$00f,$180(a6)

		btst	#00,timesine
		beq.s	sine
		btst	#00,funktion
		beq.s	nofunktion
		bclr	#00,funktion
		bsr.w	initfunktion
		bra.s	endwait
nofunktion:	tst.w	timeline
		beq.s	restart
		subq.w	#01,timeline
		bsr.w	doubblebuffer
		bsr.w	clrscreen
		bsr.w	drawline
		bra.s	endwait

sine:		bsr.w	doubblebuffer
		bsr.w	clrscreen
		bsr.w	drawsine

endwait:	move.w 	#$102,$180(a6)
		bra.s	wait			

restart:	tst.w	hell
		beq.s	endhell
		bsr.w	blendup
		bra.w	wait

endhell:	tst.w	dunkel
		beq.s	enddunkel
		bsr.w	blenddown
		bra.w	wait

enddunkel:	move.w 	#15,hell
		move.w 	#15,dunkel
		clr.w	anzahl2
		bset	#00,funktion
		bclr	#0,timesine
		move.w 	#150,timeline 
		bsr.w	initnew
		bsr.w	inittext
		bsr.w	initcoordbuf

		bra.w	wait		


funktion:	dc.b	1,0
timesine:	dc.w	0
timeline:	dc.w	150

****************************************************************** ende

ende:		move.w	oldintena(pc),$9a(a6)
		move.l 	4,a6
		lea	gfxname(pc),a1
		jsr	-408(a6)
		move.l 	d0,a1
		move.l 	38(a1),$dff080
		jsr	-414(a6)
		move.w	#$f,$dff096
		bclr	#1,$bfe001
		rte

oldintena:	dc.w	0

*************************************************************** drawsine

drawsine:	move.l 	destadressa+4(pc),a6
		lea	coordbuf(pc),a2
		lea	multab(pc),a3
		lea	coords(pc),a5		

		move.w 	anzahl2(pc),d2
		cmp.w	anzahl(pc),d2
		bge.s	drw2
		addq.w	#02,d2
		move.w 	d2,anzahl2
		bra.s	drawloop
drw2:		bset	#00,timesine
		
drawloop:	move.l	a6,a0
		move.l 	4(a2),a1
		addq.l	#02,a1
		cmp.l	#y1sine,a1
		blt.s	noy1sinrest
		lea	-[y1sine-y1sin](a1),a1
noy1sinrest:	move.l 	a1,4(a2)

		move.w 	(a1),d3			;y1add	

		move.l 	12(a2),a1
		addq.l	#06,a1
		cmp.l	#x2sine,a1
		blt.s	noy2sinrest
		lea	-[x2sine-x2sin](a1),a1
noy2sinrest:	move.l 	a1,d7
		move.l 	a1,12(a2)

		move.w 	(a1),d0			;y2add	
		add.w	d3,d0
		move.w 	d0,2(a5)		;y1coord	
		add.w	d0,d0
		lea	(a3,d0.w),a4
		add.w	(a4),a0

		move.l 	(a2),a1
		addq.l	#04,a1
		cmp.l	#x1sine,a1
		blt.s	nox1sinrest
		lea	-[x1sine-x1sin](a1),a1
nox1sinrest:	move.l 	a1,(a2)
		move.w 	(a1),d0		

		move.l 	d7,a1
		add.w 	(a1),d0		
		move.w 	d0,0(a5)		;x1coord

		move.l 	d0,d1
		lsr.w	#03,d1
		add.w	d1,a0			;x1+2add
		and.w	#07,d0
		not.w	d0
		
		bset	d0,(a0)
					
		lea	20(a5),a5
		lea	16(a2),a2
		dbf	d2,drawloop
		lea	$dff000,a6		
		rts

*********************************************************** initcoordbuf

initcoordbuf:	lea	coordbuf(pc),a0

		move.w	anzahl(pc),d0
icbloop:	move.l 	#x1sin,(a0)
x1again:	move.b 	$06(a6),d1
		muls	#$71,d1
		eor.w	#$ed,d1
		muls	$06(a6),d1
		and.l	#$7ff,d1
		cmp.l	#2000,d1
		bgt.s	x1again
		bclr	#00,d1
		add.l 	d1,(a0)+

		move.l 	#y1sin,(a0)
y1again:	move.b 	$06(a6),d1
		muls	#$71,d1
		eor.w	#$ed,d1
		muls	$06(a6),d1
		and.l	#$7ff,d1
		cmp.l	#2000,d1
		bgt.s	y1again
		bclr	#00,d1
		add.l	d1,(a0)+	

		move.l 	#x2sin,(a0)
x2again:	move.b 	$06(a6),d1
		muls	#$71,d1
		eor.w	#$ed,d1
		muls	$06(a6),d1
		and.l	#$1ff,d1
		cmp.l	#400,d1
		bgt.s	x2again
		bclr	#00,d1
		add.l	d1,(a0)+	

		move.l 	#x2sin,(a0)
y2again:	move.b 	$06(a6),d1
		muls	#$71,d1
		eor.w	#$ed,d1
		muls	$06(a6),d1
		and.l	#$1ff,d1
		cmp.l	#400,d1
		bgt.s	y2again
		bclr	#00,d1
		add.l	d1,(a0)+	

		dbf	d0,icbloop		
		 
		rts

************************************************************** drawline

drawline:	lea	coords(pc),a3
		move.w 	anzahl(pc),d4
		lea	multab(pc),a1
		move.l	destadressa+4(pc),a5
		moveq	#8,d7
		moveq	#3,d6
		moveq	#7,d5
		move.l	#20,a4
		moveq	#0,d0

nextpoint:	tst.w	10(a3)
		bge.w	goline
		bra.w	setpoint

goline:		subq.w	#speed,10(a3)
		
		btst	d0,18(a3)
		bne.s	ylenloop

xlenloop:	move.l 	a5,a0	
		move.w 	2(a3),d3		;yadd
		add.w	d3,d3
		add.w	(a1,d3.w),a0

		move.w 	8(a3),d1		

		mulu	16(a3),d1		;y=m*x
		lsr.w	d7,d1			;y=d1
		add.w	d1,d1

		btst	d0,14(a3)
		beq.s	yup
		sub.w	(a1,d1.w),a0

		bra.s	ydown
yup:		add.w 	(a1,d1.w),a0

ydown:		move.w 	(a3),d1		;xadd
		move.w 	d1,d2
		lsr.w	d6,d1
		add.w	d1,a0
		not.w	d2
		and.w	d5,d2
		bset	d2,(a0)		

noyadd:		btst	d0,12(a3)		;x1weiter
		beq.w	xrechts
		subq.w	#speed,(a3)
		bra.s	xlinks
xrechts:	addq.w	#speed,(a3)
xlinks:		addq.w	#speed,16(a3)

noxmove:
		add.l	a4,a3
		dbf	d4,nextpoint
		rts

;-------------------------------------------------------------- ylenloop

ylenloop:	move.l 	a5,a0	

		move.w 	2(a3),d1		;yadd
		add.w	d1,d1
		add.w 	(a1,d1.w),a0

		move.w 	16(a3),d1
		mulu	8(a3),d1
		lsr.w	d7,d1
		
		move.w 	(a3),d2

		btst	d0,12(a3)
		beq.s	xrechts2
		sub.w	d1,d2
		bra.s	xlinks2
xrechts2:	add.w	d1,d2
xlinks2:	move.w 	d2,d1
		lsr.w	d6,d1
		add.w	d1,a0
		not.w	d2
		and.w	d5,d2
		bset	d2,(a0)

		btst	d0,14(a3)		;y1weiter
		beq.s	yup3
		subq.w	#speed,2(a3)
		bra.w	ydown3
yup3:		addq.w	#speed,2(a3)
ydown3:		addq.w	#speed,16(a3)

noymove3:
		add.l	a4,a3
		dbf	d4,nextpoint
		rts

************************************************************ setpoint

setpoint:	move.l 	a5,a0

		move.w 	6(a3),d1		;y
		add.w	d1,d1
		add.w	(a1,d1.w),a0
		
		move.w 	4(a3),d2		;x
		move.w 	d2,d1
		lsr.w	d6,d1
		add.w	d1,a0
		not.w	d2
		and.w	d5,d2

		bset	d2,$2800(a0)		;setpoint
		bset	d2,40+$2800(a0)		;setpoint

		add.l	a4,a3
		dbf	d4,nextpoint
		rts

********************************************************** initfunktion

initfunktion:	lea	coords(pc),a0
		move.w 	anzahl(pc),d2

nextpointinit:	moveq 	#00,d0
		moveq 	#00,d1
		moveq	#0,d7
		bclr	d7,14(a0)
		move.w 	6(a0),d0
		sub.w	2(a0),d0		;y2-y1
		bpl.s	nonegy
		neg.w	d0
		bset	d7,14(a0)
nonegy:		bclr	d7,12(a0)
		move.w 	4(a0),d1
		sub.w	(a0),d1			;x2-x1
		bpl.s	nonegx
		neg.w	d1
		bset	d7,12(a0)
nonegx:		cmp.w	d0,d1
		bge.s	xlen
		move.w 	d0,10(a0)
		bset	d7,18(a0)
		exg	d0,d1
		bra.s	ylen
xlen:		move.w 	d1,10(a0)		
		bclr	d7,18(a0)	
ylen:		tst.w	d1			;division by zero?
		bne.s	nozero
		moveq 	#01,d1			
nozero:		lsl.w	#08,d0	
		divu	d1,d0			;m=(y2-y1)/(x2-x1)
		addq.w	#01,d0
		move.w 	d0,8(a0)

		lea	20(a0),a0
		dbf	d2,nextpointinit
		rts

*************************************************************** inittext

inittext:	move.l 	textpot(pc),a0
		lea	coords(pc),a3
		moveq 	#00,d3
		move.b 	(a0)+,d3			;x2
		move.w 	#128,d4				;y2
		moveq 	#-1,d5				;anzahl

nextchar:	lea	pfonttab(pc),a1
		lea	pfont(pc),a2
		
		move.b	(a0)+,d0
cmploop:	cmp.b	(a1)+,d0
		beq.s	gotchar
		addq.w	#01,a2
		bra.s	cmploop
		
gotchar:	moveq 	#08-1,d2			;breite

breiteloop:	moveq 	#07-1,d1			;hoehe

hoeheloop:	btst	d2,(a2)
		beq.s	nopoint

		move.w 	d3,4(a3)			;x2
		move.w 	d4,6(a3)			;y2
		add.w	#20,a3			;auf naechste structure
		addq.w	#01,d5
nopoint:	add.w	#48,a2				;naechste zeile
		addq.w	#02,d4				;y2 +
		dbf	d1,hoeheloop
		
		sub.w	#[7*48],a2			;erste zeile
		sub.w	#[7*2],d4				
		addq.w	#02,d3				;x2 +
		dbf	d2,breiteloop
		
		cmp.b	#$ff,(a0)
		bne.w	nextchar	
		
		addq.l	#01,a0
		cmp.l	#texte,a0
		blt.s	notextrest
		lea	text(pc),a0
notextrest:	move.l 	a0,textpot
		move.w 	d5,anzahl
		rts

********************************************************** doubblebuffer

doubblebuffer:	lea	destadressa(pc),a0

		move.l	(a0),d0
		move.l	4(a0),(a0)
		move.l	8(a0),4(a0)
		move.l	d0,8(a0)
		move.l	(a0),d0

		lea	bpls,a1
		move.w	d0,6(a1)
		swap	d0
		move.w	d0,2(a1)
		rts

destadressa:	dc.l	$60000
		dc.l	$70000
		dc.l	$75000

************************************************************** initmultab

initmultab:	lea	multab(pc),a0
		moveq 	#00,d1

		move.w 	#256-1,d0
multabloop:	move.w 	d1,d2
		mulu	#40,d2
		move.w 	d2,(a0)+
		addq.w	#01,d1
		dbf	d0,multabloop
		rts		

**************************************************************** blendup

blendup:	subq.w	#01,hell
		lea	copcol+10,a0		
		moveq	#06-1,d0		;anzahl cols	

colloop:	move.w 	(a0),d1
		move.w 	d1,d2
		and.w	#$0f00,d2
		cmp.w	#$0f00,d2
		beq.s	noredup	
		add.w	#$0100,d1
noredup:	move.w 	d1,d2
		and.w	#$00f0,d2
		cmp.w	#$00f0,d2
		beq.s	nogreenup	
		add.w	#$0010,d1
nogreenup:	move.w 	d1,d2
		and.w	#$000f,d2
		cmp.w	#$000f,d2
		beq.s	noblueup	
		addq.w	#$0001,d1
noblueup:	move.w 	d1,(a0)
		
		addq.w	#04,a0	
		dbf	d0,colloop
		rts

hell:		dc.w	15

************************************************************** blenddown

blenddown:	subq.w	#01,dunkel
		lea	copcol+10,a0		
		moveq	#06-1,d0		;anzahl cols	

colloop2:	sub.w	#$0111,(a0)
		addq.w	#04,a0	

		dbf	d0,colloop2
		rts

dunkel:		dc.w	15

**************************************************************** initnew

initnew:	lea	$62800,a0
c1:		clr.l	(a0)+
		cmp.l	#$65000,a0
		blt.s	c1
		lea	$72800,a0
c2:		clr.l	(a0)+
		cmp.l	#$75000,a0
		blt.s	c2
	
		lea	coords(pc),a0
		move.w 	#[400*20]-1,d0
clrcoords:	clr.w	(a0)+
		dbf	d0,clrcoords

		lea	cols(pc),a0
		lea	copcol+10,a1
		moveq 	#06-1,d0
movecols:	move.w 	(a0)+,(a1)
		addq.w	#04,a1
		dbf	d0,movecols
		rts

cols:		dc.w	$063a,$074b,$085c,$096d,$0a7e,$0b8f


****************************************************************** vars

gfxname:	dc.b	"graphics.library",0,0
anzahl:		dc.w	0	
anzahl2:	dc.w	0	

;			x1pot,y1pot,x2pot,y2pot
coordbuf:	blk.l	600*4,0

;			0   2   4   6   8   10  12  14  16  18
;			x1  y1  x2  y2  m   len xdi ydi zae mod
coords:		blk.w	400*20,0

pfonttab:	dc.b	"abcdefghijklmnopqrstuvwxyz!.?:^,0123456789()-+ "
pfonttabe:

text:		
		dc.b	0,"       shadow       ",$ff
		dc.b	0,"         of         ",$ff
		dc.b	8,"     ^ abyss ^      ",$ff
		dc.b	0,"      presents      ",$ff
		dc.b	0,"     a new part     ",$ff
		dc.b	8,"        for         ",$ff
		dc.b	8,"    wasted time     ",$ff
		dc.b	0,"--------------------",$ff
		dc.b	8,"       thanx        ",$ff
		dc.b	8,"  chris huelsbeck   ",$ff
		dc.b	8,"        for         ",$ff
		dc.b	8," the great muzak !  ",$ff
		dc.b	0,"--------------------",$ff
texte:		even
		
textpot:	dc.l	text

multab:		blk.w	256,0

************************************************************** clrscreen

clrscreen:	move.l 	destadressa+8(pc),a0

		clr.w	$66(a6)
		move.l 	a0,$54(a6)
		move.l 	#$01000000,$40(a6)
		move.w 	#[256*64]+20,$58(a6)
		
		lea	$dff000,a6
		rts

clrbuf:		blk.l	16,0

****************************************************************** sines

x1sin:  dc.w      1,1,1,1,1,1,1,1
        dc.w      1,1,1,1,1,1,2,2
        dc.w      2,2,2,2,2,2,2,2
        dc.w      3,3,3,3,3,3,3,4
        dc.w      4,4,4,4,5,5,5,5
        dc.w      5,6,6,6,6,7,7,7
        dc.w      7,8,8,8,8,9,9,9
        dc.w      10,10,10,10,11,11,11,12
        dc.w      12,12,13,13,13,14,14,15
        dc.w      15,15,16,16,17,17,17,18
        dc.w      18,19,19,19,20,20,21,21
        dc.w      22,22,23,23,24,24,25,25
        dc.w      26,26,27,27,28,28,29,29
        dc.w      30,30,31,31,32,32,33,33
        dc.w      34,35,35,36,36,37,37,38
        dc.w      39,39,40,40,41,42,42,43
        dc.w      44,44,45,45,46,47,47,48
        dc.w      49,49,50,51,51,52,53,53
        dc.w      54,55,55,56,57,58,58,59
        dc.w      60,60,61,62,63,63,64,65
        dc.w      66,66,67,68,68,69,70,71
        dc.w      72,72,73,74,75,75,76,77
        dc.w      78,78,79,80,81,82,82,83
        dc.w      84,85,86,86,87,88,89,90
        dc.w      90,91,92,93,94,95,95,96
        dc.w      97,98,99,100,100,101,102,103
        dc.w      104,105,105,106,107,108,109,110
        dc.w      111,111,112,113,114,115,116,117
        dc.w      117,118,119,120,121,122,123,123
        dc.w      124,125,126,127,128,129,130,130
        dc.w      131,132,133,134,135,136,137,137
        dc.w      138,139,140,141,142,143,143,144
        dc.w      145,146,147,148,149,150,150,151
        dc.w      152,153,154,155,156,157,157,158
        dc.w      159,160,161,162,163,163,164,165
        dc.w      166,167,168,169,169,170,171,172
        dc.w      173,174,175,175,176,177,178,179
        dc.w      180,180,181,182,183,184,185,185
        dc.w      186,187,188,189,190,190,191,192
        dc.w      193,194,194,195,196,197,198,198
        dc.w      199,200,201,202,202,203,204,205
        dc.w      205,206,207,208,208,209,210,211
        dc.w      212,212,213,214,214,215,216,217
        dc.w      217,218,219,220,220,221,222,222
        dc.w      223,224,225,225,226,227,227,228
        dc.w      229,229,230,231,231,232,233,233
        dc.w      234,235,235,236,236,237,238,238
        dc.w      239,240,240,241,241,242,243,243
        dc.w      244,244,245,245,246,247,247,248
        dc.w      248,249,249,250,250,251,251,252
        dc.w      252,253,253,254,254,255,255,256
        dc.w      256,257,257,258,258,259,259,260
        dc.w      260,261,261,261,262,262,263,263
        dc.w      263,264,264,265,265,265,266,266
        dc.w      267,267,267,268,268,268,269,269
        dc.w      269,270,270,270,270,271,271,271
        dc.w      272,272,272,272,273,273,273,273
        dc.w      274,274,274,274,275,275,275,275
        dc.w      275,276,276,276,276,276,277,277
        dc.w      277,277,277,277,277,278,278,278
        dc.w      278,278,278,278,278,278,278,279
        dc.w      279,279,279,279,279,279,279,279
        dc.w      279,279,279,279,279,279,279,279
        dc.w      279,279,279,279,279,279,279,279
        dc.w      279,279,278,278,278,278,278,278
        dc.w      278,278,278,278,277,277,277,277
        dc.w      277,277,277,276,276,276,276,276
        dc.w      275,275,275,275,275,274,274,274
        dc.w      274,273,273,273,273,272,272,272
        dc.w      272,271,271,271,270,270,270,270
        dc.w      269,269,269,268,268,268,267,267
        dc.w      267,266,266,265,265,265,264,264
        dc.w      263,263,263,262,262,261,261,261
        dc.w      260,260,259,259,258,258,257,257
        dc.w      256,256,255,255,254,254,253,253
        dc.w      252,252,251,251,250,250,249,249
        dc.w      248,248,247,247,246,245,245,244
        dc.w      244,243,243,242,241,241,240,240
        dc.w      239,238,238,237,236,236,235,235
        dc.w      234,233,233,232,231,231,230,229
        dc.w      229,228,227,227,226,225,225,224
        dc.w      223,222,222,221,220,220,219,218
        dc.w      217,217,216,215,214,214,213,212
        dc.w      212,211,210,209,208,208,207,206
        dc.w      205,205,204,203,202,202,201,200
        dc.w      199,198,198,197,196,195,194,194
        dc.w      193,192,191,190,190,189,188,187
        dc.w      186,185,185,184,183,182,181,180
        dc.w      180,179,178,177,176,175,175,174
        dc.w      173,172,171,170,169,169,168,167
        dc.w      166,165,164,163,163,162,161,160
        dc.w      159,158,157,157,156,155,154,153
        dc.w      152,151,150,150,149,148,147,146
        dc.w      145,144,143,143,142,141,140,139
        dc.w      138,137,137,136,135,134,133,132
        dc.w      131,130,130,129,128,127,126,125
        dc.w      124,123,123,122,121,120,119,118
        dc.w      117,117,116,115,114,113,112,111
        dc.w      111,110,109,108,107,106,105,105
        dc.w      104,103,102,101,100,100,99,98
        dc.w      97,96,95,95,94,93,92,91
        dc.w      90,90,89,88,87,86,86,85
        dc.w      84,83,82,82,81,80,79,78
        dc.w      78,77,76,75,75,74,73,72
        dc.w      72,71,70,69,68,68,67,66
        dc.w      66,65,64,63,63,62,61,60
        dc.w      60,59,58,58,57,56,55,55
        dc.w      54,53,53,52,51,51,50,49
        dc.w      49,48,47,47,46,45,45,44
        dc.w      44,43,42,42,41,40,40,39
        dc.w      39,38,37,37,36,36,35,35
        dc.w      34,33,33,32,32,31,31,30
        dc.w      30,29,29,28,28,27,27,26
        dc.w      26,25,25,24,24,23,23,22
        dc.w      22,21,21,20,20,19,19,19
        dc.w      18,18,17,17,17,16,16,15
        dc.w      15,15,14,14,13,13,13,12
        dc.w      12,12,11,11,11,10,10,10
        dc.w      10,9,9,9,8,8,8,8
        dc.w      7,7,7,7,6,6,6,6
        dc.w      5,5,5,5,5,4,4,4
        dc.w      4,4,3,3,3,3,3,3
        dc.w      3,2,2,2,2,2,2,2
        dc.w      2,2,2,1,1,1,1,1
        dc.w      1,1,1,1,1,1,1,1
x1sine:

y1sin:  dc.w      1,1,1,1,1,1,1,1
        dc.w      1,1,1,1,1,1,1,1
        dc.w      2,2,2,2,2,2,2,2
        dc.w      2,2,2,3,3,3,3,3
        dc.w      3,3,3,4,4,4,4,4
        dc.w      4,5,5,5,5,5,5,6
        dc.w      6,6,6,6,7,7,7,7
        dc.w      8,8,8,8,9,9,9,9
        dc.w      10,10,10,10,11,11,11,11
        dc.w      12,12,12,13,13,13,14,14
        dc.w      14,15,15,15,16,16,16,17
        dc.w      17,17,18,18,18,19,19,20
        dc.w      20,20,21,21,21,22,22,23
        dc.w      23,23,24,24,25,25,26,26
        dc.w      26,27,27,28,28,29,29,30
        dc.w      30,30,31,31,32,32,33,33
        dc.w      34,34,35,35,36,36,37,37
        dc.w      38,38,39,39,40,40,41,41
        dc.w      42,42,43,43,44,45,45,46
        dc.w      46,47,47,48,48,49,50,50
        dc.w      51,51,52,52,53,54,54,55
        dc.w      55,56,56,57,58,58,59,59
        dc.w      60,61,61,62,62,63,64,64
        dc.w      65,66,66,67,67,68,69,69
        dc.w      70,70,71,72,72,73,74,74
        dc.w      75,76,76,77,78,78,79,79
        dc.w      80,81,81,82,83,83,84,85
        dc.w      85,86,87,87,88,89,89,90
        dc.w      91,91,92,93,93,94,95,95
        dc.w      96,97,97,98,99,99,100,101
        dc.w      101,102,103,103,104,105,105,106
        dc.w      107,107,108,109,109,110,111,111
        dc.w      112,113,113,114,115,115,116,117
        dc.w      117,118,119,119,120,121,121,122
        dc.w      123,123,124,125,125,126,127,127
        dc.w      128,129,129,130,131,131,132,133
        dc.w      133,134,135,135,136,137,137,138
        dc.w      138,139,140,140,141,142,142,143
        dc.w      144,144,145,146,146,147,147,148
        dc.w      149,149,150,150,151,152,152,153
        dc.w      154,154,155,155,156,157,157,158
        dc.w      158,159,160,160,161,161,162,162
        dc.w      163,164,164,165,165,166,166,167
        dc.w      168,168,169,169,170,170,171,171
        dc.w      172,173,173,174,174,175,175,176
        dc.w      176,177,177,178,178,179,179,180
        dc.w      180,181,181,182,182,183,183,184
        dc.w      184,185,185,186,186,186,187,187
        dc.w      188,188,189,189,190,190,190,191
        dc.w      191,192,192,193,193,193,194,194
        dc.w      195,195,195,196,196,196,197,197
        dc.w      198,198,198,199,199,199,200,200
        dc.w      200,201,201,201,202,202,202,203
        dc.w      203,203,204,204,204,205,205,205
        dc.w      205,206,206,206,206,207,207,207
        dc.w      207,208,208,208,208,209,209,209
        dc.w      209,210,210,210,210,210,211,211
        dc.w      211,211,211,211,212,212,212,212
        dc.w      212,212,213,213,213,213,213,213
        dc.w      213,213,214,214,214,214,214,214
        dc.w      214,214,214,214,214,215,215,215
        dc.w      215,215,215,215,215,215,215,215
        dc.w      215,215,215,215,215,215,215,215
        dc.w      215,215,215,215,215,215,215,215
        dc.w      215,215,215,215,214,214,214,214
        dc.w      214,214,214,214,214,214,214,213
        dc.w      213,213,213,213,213,213,213,212
        dc.w      212,212,212,212,212,211,211,211
        dc.w      211,211,211,210,210,210,210,210
        dc.w      209,209,209,209,208,208,208,208
        dc.w      207,207,207,207,206,206,206,206
        dc.w      205,205,205,205,204,204,204,203
        dc.w      203,203,202,202,202,201,201,201
        dc.w      200,200,200,199,199,199,198,198
        dc.w      198,197,197,196,196,196,195,195
        dc.w      195,194,194,193,193,193,192,192
        dc.w      191,191,190,190,190,189,189,188
        dc.w      188,187,187,186,186,186,185,185
        dc.w      184,184,183,183,182,182,181,181
        dc.w      180,180,179,179,178,178,177,177
        dc.w      176,176,175,175,174,174,173,173
        dc.w      172,171,171,170,170,169,169,168
        dc.w      168,167,166,166,165,165,164,164
        dc.w      163,162,162,161,161,160,160,159
        dc.w      158,158,157,157,156,155,155,154
        dc.w      154,153,152,152,151,150,150,149
        dc.w      149,148,147,147,146,146,145,144
        dc.w      144,143,142,142,141,140,140,139
        dc.w      138,138,137,137,136,135,135,134
        dc.w      133,133,132,131,131,130,129,129
        dc.w      128,127,127,126,125,125,124,123
        dc.w      123,122,121,121,120,119,119,118
        dc.w      117,117,116,115,115,114,113,113
        dc.w      112,111,111,110,109,109,108,107
        dc.w      107,106,105,105,104,103,103,102
        dc.w      101,101,100,99,99,98,97,97
        dc.w      96,95,95,94,93,93,92,91
        dc.w      91,90,89,89,88,87,87,86
        dc.w      85,85,84,83,83,82,81,81
        dc.w      80,79,79,78,78,77,76,76
        dc.w      75,74,74,73,72,72,71,70
        dc.w      70,69,69,68,67,67,66,66
        dc.w      65,64,64,63,62,62,61,61
        dc.w      60,59,59,58,58,57,56,56
        dc.w      55,55,54,54,53,52,52,51
        dc.w      51,50,50,49,48,48,47,47
        dc.w      46,46,45,45,44,43,43,42
        dc.w      42,41,41,40,40,39,39,38
        dc.w      38,37,37,36,36,35,35,34
        dc.w      34,33,33,32,32,31,31,30
        dc.w      30,30,29,29,28,28,27,27
        dc.w      26,26,26,25,25,24,24,23
        dc.w      23,23,22,22,21,21,21,20
        dc.w      20,20,19,19,18,18,18,17
        dc.w      17,17,16,16,16,15,15,15
        dc.w      14,14,14,13,13,13,12,12
        dc.w      12,11,11,11,11,10,10,10
        dc.w      10,9,9,9,9,8,8,8
        dc.w      8,7,7,7,7,6,6,6
        dc.w      6,6,5,5,5,5,5,5
        dc.w      4,4,4,4,4,4,3,3
        dc.w      3,3,3,3,3,3,2,2
        dc.w      2,2,2,2,2,2,2,2
        dc.w      2,1,1,1,1,1,1,1
        dc.w      1,1,1,1,1,1,1,1
y1sine:

x2sin:  dc.w      0,0,0,0,0,0,0,0
        dc.w      1,1,1,1,1,2,2,2
        dc.w      2,3,3,3,4,4,5,5
        dc.w      5,6,6,7,7,8,8,9
        dc.w      9,10,10,11,11,12,13,13
        dc.w      14,14,15,16,16,17,17,18
        dc.w      19,19,20,21,21,22,23,23
        dc.w      24,24,25,26,26,27,27,28
        dc.w      29,29,30,30,31,31,32,32
        dc.w      33,33,34,34,35,35,35,36
        dc.w      36,37,37,37,38,38,38,38
        dc.w      39,39,39,39,39,40,40,40
        dc.w      40,40,40,40,40,40,40,40
        dc.w      40,40,40,40,39,39,39,39
        dc.w      39,38,38,38,38,37,37,37
        dc.w      36,36,35,35,35,34,34,33
        dc.w      33,32,32,31,31,30,30,29
        dc.w      29,28,27,27,26,26,25,24
        dc.w      24,23,23,22,21,21,20,19
        dc.w      19,18,17,17,16,16,15,14
        dc.w      14,13,13,12,11,11,10,10
        dc.w      9,9,8,8,7,7,6,6
        dc.w      5,5,5,4,4,3,3,3
        dc.w      2,2,2,2,1,1,1,1
        dc.w      1,0,0,0,0,0,0,0
x2sine:


pfont:	dc.l $FEFCFEFC,$FEFEFEC6,$FC06C6C0,$C6FEFEFE,$FEFEFEFE,$C6C6C6C6 
	dc.l $C6FE6600,$7C006C00,$7C087C7C,$0EFC7C7E,$7C7C0C30,$00000000 
	dc.l $06060006,$000000C6,$0006CCC0,$EE060606,$06060000,$C6C6C6C6 
	dc.l $C6006600,$C6306C00,$E218C6C6,$1EC0C606,$C6C61818,$00200000 
	dc.l $C6C6C0C6,$C0C0C0C6,$300618C0,$D6C6C6C6,$C6C6C006,$C6C6C66C 
	dc.l $6C0E6600,$0630D800,$E6380606,$36C0C006,$C6C6300C,$00200000 
	dc.l $FEFCC0C6,$F8F8CEDE,$3006F0C0,$C6C6C6FE,$D6F8FE06,$C6C6C610 
	dc.l $387C6600,$1C000000,$EA187C1C,$66FCFC0C,$7C7E300C,$FCF80000 
	dc.l $C6C6C0C6,$C0C0C6C6,$30C6D8C0,$C6C6C6C0,$DAC60606,$C6C6D66C 
	dc.l $18E06600,$30000030,$F218E006,$FE06C618,$C606300C,$00200000 
	dc.l $C6C6C0C6,$C0C0C6C6,$30C0CC00,$C6C6C6C0,$CCC60606,$060CEEC6 
	dc.l $18C00066,$00300030,$E218E0C6,$06C6C618,$C6C61818,$00200000 
	dc.l $C6FCFEFC,$FEC0FEC6,$FCFEC6FE,$C6C6FEC0,$FAC6FE06,$FE38C6C6 
	dc.l $18FE6666,$30300060,$7C18FEFC,$06FCFC18,$7CFC0C30,$00000000 


*************************************************************** coplist
	section	gfx,data_C
		
cop:		dc.l	$008e2981
		dc.l	$009029c1
		dc.l	$00920038
		dc.l	$009400d0
		dc.l	$00960020
		
copcol:		dc.l	$01800102
		dc.l	$01820f6f
		dc.l	$0184063a
		dc.l	$0186074b

		dc.l	$0188085c
		dc.l	$018a096d
		dc.l	$018c0a7e
		dc.l	$018e0b8f
		
		dc.l	$01020010

planes:		dc.l	$01003200
bpls:		dc.l	$00e00006
		dc.l	$00e20000
		dc.l	$00e40006
		dc.l	$00e60000+10240
		dc.l	$00e80006
		dc.l	$00ea0000+10240

		dc.l	$ffe1fffe
		dc.l	$009c8010
	
		dc.l	$fffffffe

