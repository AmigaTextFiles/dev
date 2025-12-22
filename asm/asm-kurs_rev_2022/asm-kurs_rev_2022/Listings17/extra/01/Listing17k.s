
; Listings17k.s = paraCOP.S

; work done by shadow of ABYSS !

; absoluta verso $40000....

	section	nan,code

		move.l 	#init,$80
		trap	#0
		rts

*************************************************************** init

init:		lea	$dff000,a5

		move.w	#$7fff,d0
		move.w	$1c(a5),d1
		or.w	#$8000,d1
		move.w	d1,oldintena
		move.w	d0,$9a(a5)
		move.w	d0,$9c(a5)		

		bsr.w	initpic
		bsr.w	initwaits		
		bsr.w	initmultab
		bsr.w	initfirst

		move.l 	#cop,$80(a5)
		move.w	d0,$88(a5)
		move.w	#0,$1fc(a5)
		move.l	#0,$108(a5)

************************************************************* mainloop

wait:
		cmp.b	#$ff,$06(a5)
		bne.s	wait

		btst	#06,$bfe001
		beq.s	ende

;		move.w 	#$fff,$dff180
		bsr.w	changepattern
		bsr.s	paraeffect

		btst	#00,smooth
		beq.s	nosmooth
		bsr.w	smoothit
		bra.w	endwait

nosmooth:	bsr.w	colch

endwait:	move.w 	#$00,$dff180
		bra.s	wait

************************************************************* ende

ende:		move.w 	oldintena(pc),$9a(a5)
		move.l 	4,a6
		lea	gfxname(pc),a1
		jsr	-408(a6)
		move.l 	d0,a1
		move.l 	38(a1),$dff080
		jsr	-414(a6)
		rte

oldintena:	dc.w	0	

*********************************************************** paraeffect

paraeffect:	lea	parastruct(pc),a6
		lea	copwaits+10,a0

		move.l 	psinpot(pc),a1
		move.l 	a1,a2
		add.w	(a6),a2
		cmp.l	#parasine,a2
		blt.s	nosinrestore
		sub.l	#parasine-parasin,a2
nosinrestore:	move.l 	a2,psinpot

		move.l 	psinpot2(pc),a2
		move.l 	a2,a3
		add.w	2(a6),a3
		cmp.l	#parasine,a2
		blt.s	nosinrestore2
		sub.l	#parasine-parasin,a3
nosinrestore2:	move.l 	a3,psinpot2
		
		move.w 	addy(pc),d3
		move.w 	d3,d2
		move.w 	d3,d4
		add.w	4(a6),d4	
		move.w 	d4,addy

		tst.w	4(a6)
		beq.s	noaddrest
		bgt.s	posi	
		blt.s	negi

posi:		cmp.w	#128,addy
		blt.s	noaddrest
		sub.w	#128,addy				
		bra.s	noaddrest

negi:		tst.w	addy
		bge.s	noaddrest
		add.w	#128,addy				

;----------------------------------------------------- change waits	

noaddrest:	move.w	#276-1,d0
		lea	multab(pc),a4

coploop:	move.w 	d2,d4
		add.w	d2,d2
		move.w	(a4,d2.w),d2

		move.w 	d2,d1
		move.w 	d1,(a0)
		add.w	#88,d1
		move.w 	d1,8(a0)
		add.w	#88,d1
		move.w 	d1,16(a0)

		add.w	#28,a0

		tst.w	10(a6)
		beq.s	nodiagonal
		bgt.s	adddiagonal
		blt.s	subdiagonal
				
adddiagonal:	add.w	10(a6),d4
		cmp.w	#128,d4
		blt.s	nosubdia	
		sub.w	#128,d4	
nosubdia:	move.w 	d4,d2
		bra.s	nosub		

subdiagonal:	add.w	10(a6),d4
		tst.w	d4
		bge.s	noadddia	
		add.w	#128,d4	
noadddia:	move.w 	d4,d2
		bra.s	nosub		

nodiagonal:	move.w 	d3,d2

		add.b	(a1),d2
		add.w	6(a6),a1

		add.b	(a2),d2
		add.w	8(a6),a2

		cmp.w	#128,d2
		blt.s	nosub
		sub.w	#128,d2
nosub:		dbf	d0,coploop

paraend:	rts


psinpot:	dc.l	parasin
psinpot2:	dc.l	parasin
addy:		dc.w	0

********************************************************** changepattern

changepattern:	tst.w	time
		beq.s	newpattern
		subq.w	#01,time
		rts
		
newpattern:	btst	#01,smooth
		bne.s	justdoit
		bset	#00,smooth
		rts
		
justdoit:	move.l 	parapattern(pc),a0
		move.l 	14(a0),a0
		move.l 	a0,parapattern	
		
		lea	parastruct(pc),a1

		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0),time

		rts

time:		dc.w	0

*********************************************************** col-change

colch:		btst	#00,work
		bne.s	co2
		subq.w	#01,zaehler
		beq.s	c1
		rts

c1:		move.w 	#400,zaehler
		bset	#00,work
	
co2:		subq.w	#01,z3
		beq.s	co3
		rts

co3:		move.w 	#6,z3
		move.l 	fpot(pc),a1
		lea	copcol+2,a0
		clr.l	d4
		moveq 	#08-1,d5

goo:		move.w 	(a0),d0
		move.w 	(a1)+,d2

		move.w 	d0,d1	
		move.w 	d2,d3
		and.w	#$000f,d1
		and.w	#$000f,d3
		cmp.w	d1,d3
		blt.s	c2			
		bgt.s	c3	
		bra.s	c4
c2:		subq.w	#$0001,d1
		bra.s	c4
c3:		add.w	#$0001,d1
c4:		or.w	d1,d4

		move.w 	d0,d1	
		move.w 	d2,d3
		and.w	#$00f0,d1
		and.w	#$00f0,d3
		cmp.w	d1,d3
		blt.s	c5			
		bgt.s	c6	
		bra.s	c7
c5:		sub.w	#$0010,d1
		bra.s	c7
c6:		add.w	#$0010,d1
c7:		or.w	d1,d4

		move.w 	d0,d1	
		move.w 	d2,d3
		and.w	#$0f00,d1
		and.w	#$0f00,d3
		cmp.w	d1,d3
		blt.s	c8			
		bgt.s	c9	
		bra.s	c10
c8:		sub.w	#$0100,d1
		bra.s	c10
c9:		add.w	#$0100,d1
c10:		or.w	d1,d4

		move.w 	d4,(a0)
		clr.w	d4
		addq.w	#04,a0
		dbf	d5,goo
	
		subq.w	#01,z2
		tst.w	z2
		bne.s	schluss
		move.w	#16,z2 
		bclr	#00,work
		add.l	#16,fpot
		cmp.l	#colore,fpot
		bne.s	schluss
		move.l 	#color,fpot
	
schluss:	rts

work:		dc.b	0,0
z2:		dc.w	16
z3:		dc.w	6
zaehler:	dc.w	400	
fpot:		dc.l	color

************************************************************* smoothit

smoothit:	btst	#00,first
		bne.s	smoothdown
		bset	#00,first

		lea	copcol+2,a0
		lea	colpuf(pc),a1
		move.w 	(a0),(a1)+
		move.w 	4(a0),(a1)+
		move.w 	8(a0),(a1)+
		move.w 	12(a0),(a1)+
		move.w 	16(a0),(a1)+
		move.w 	20(a0),(a1)+
		move.w 	24(a0),(a1)+
		move.w 	28(a0),(a1)+

smoothdown:	tst.b	scount
		beq.s	smoothup
		subq.b	#01,scount

		lea	copcol+2,a0
		moveq	#08-1,d0
smloop:		move.w  (a0),d1
		move.w 	d1,d2
		and.w	#$0f00,d2
		tst.w	d2
		beq.s	green
		sub.w	#$0100,(a0)
green:		move.w 	d1,d2
		and.w	#$00f0,d2
		tst.w	d2
		beq.s	blue
		sub.w	#$0010,(a0)
blue:		and.w	#$000f,d1
		tst.w	d1
		beq.s	next		
		subq.w	#$0001,(a0)

next:		addq.w	#4,a0
		dbf	d0,smloop
		rts		

smoothup:	tst.b	scount2
		beq.s	smoothend
		subq.b	#01,scount2

		lea	copcol+2,a0
		lea	colpuf(pc),a1
		
		moveq	#08-1,d0
smloop2:	move.w  (a0),d1
		move.w 	(a1)+,d2
		move.w 	d1,d3
		move.w 	d2,d4
		and.w	#$0f00,d3
		and.w	#$0f00,d4
		cmp.w	d3,d4
		beq.s	green2
		add.w	#$0100,(a0)
green2:		move.w 	d1,d3
		move.w 	d2,d4
		and.w	#$00f0,d3
		and.w	#$00f0,d4
		cmp.w	d3,d4
		beq.s	blue2
		add.w	#$0010,(a0)
blue2:		and.w	#$000f,d1
		and.w	#$000f,d2
		cmp.w	d1,d2
		beq.s	next2
		addq.w	#$0001,(a0)

next2:		addq.w	#4,a0
		dbf	d0,smloop2
		bset	#01,smooth
		rts		

smoothend:	bclr	#00,smooth
		bclr	#01,smooth
		bclr	#00,first
		move.b	#15,scount
		move.b 	#15,scount2
		rts

colpuf:		blk.w	8,0
first:		dc.b	0
smooth:		dc.b	0
scount:		dc.b	15
scount2:	dc.b	15

******************************************************** initfirststruct

initfirst:	move.l 	parapattern(pc),a0
		lea	parastruct(pc),a1

		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0)+,(a1)+
		move.w 	(a0),time

		rts

************************************************************ initwaits

initwaits:	lea	copwaits,a0
		move.l 	#$20e1fffe,d1
		
		move.w	#276-1,d0
waitloop:	move.l 	d1,(a0)+

		move.w 	#$00e0,(a0)+
		move.w 	#$0006,(a0)+
		move.w 	#$00e2,(a0)+
		move.w 	#$0000,(a0)+

		move.w 	#$00e4,(a0)+
		move.w 	#$0006,(a0)+
		move.w 	#$00e6,(a0)+
		move.w 	#$0000+88,(a0)+

		move.w 	#$00e8,(a0)+
		move.w 	#$0006,(a0)+
		move.w 	#$00ea,(a0)+
		move.w 	#$0000+[2*88],(a0)+

		add.l	#$01000000,d1	

		dbf	d0,waitloop
		rts

************************************************************ initmultab

initmultab:	lea	multab(pc),a0

		moveq	#0,d1
		move.w	#275-1,d0
initloop:	move.w	d1,(a0)+
		add.w	#[88*3],d1
		dbf	d0,initloop

		rts

************************************************************ initpic

initpic:	lea	paragfx,a0
		lea	paragfxmask,a2

wblit4x:
	btst	#14,$02(a5)
	bne.s	wblit4x

		move.l 	#$ffff0000,$44(a5)
		move.w 	#-2,$62(a5)
		move.w 	#-2,$64(a5)
		move.w 	#104-10,$60(a5)
		move.w 	#104-10,$66(a5)

;---------------------------------------------------------------

initpic4:	tst.b	sig4	
		beq.s	initpic5
		
		lea	struct4(pc),a3

		moveq	#12-1,d2
anzahloop4:
	lea	$40000,a1
	add.w	addy4(pc),a1
	move.l 	#$0fca0000,d1

	move.w 	#128-1,d0
wblit4:
	btst	#14,$02(a5)
	bne.s	wblit4

	move.l 	a2,$50(a5)		;apt
	move.l 	a0,$4c(a5)		;bpt
	move.l 	a1,$54(a5)		;dpt
	move.l 	a1,$48(a5)		;cpt
	move.l 	d1,$40(a5)		;con0+1
	move.w 	#[3*64]+5,$58(a5)	;size

	add.w	#[104*3],a1

	tst.b	(a3)+
	beq.s	noadd4
	sub.l	#$10001000,d1
	cmp.l	#$ffc9f000,d1
	bne.s	noadd4
	move.l 	#$ffcaf000,d1
	subq.w	#02,a1

noadd4:
	cmp.l	#struct4e,a3
	bne.s	nostructe4
	lea	struct4(pc),a3
nostructe4:
	dbf	d0,wblit4
		
	addq.w	#8,addy4
	dbf	d2,anzahloop4
				
;---------------------------------------------------------------

initpic5:
	tst.b	sig5	
	beq.s	initpic6
		
	lea	struct5(pc),a3

	moveq	#10-1,d2
anzahloop5:
	lea	$40000,a1
	add.w	addy5(pc),a1
	move.l 	#$0fca0000,d1

	move.w 	#128-1,d0
wblit5:	
	btst	#14,$02(a5)
	bne.s	wblit5

	move.l 	a2,$50(a5)		;apt
	move.l 	a0,$4c(a5)		;bpt
	move.l 	a1,$54(a5)		;dpt
	move.l 	a1,$48(a5)		;cpt
	move.l 	d1,$40(a5)		;con0+1
	move.w 	#[3*64]+5,$58(a5)	;size

	add.w	#[104*3],a1

	tst.b	(a3)+
	beq.s	noadd5
	sub.l	#$10001000,d1
	cmp.l	#$ffc9f000,d1
	bne.s	noadd5
	move.l 	#$ffcaf000,d1
	subq.w	#02,a1

noadd5:
	cmp.l	#struct5e,a3
	bne.s	nostructe5
	lea	struct5(pc),a3
nostructe5:
	dbf	d0,wblit5
		
	add.w	#10,addy5
	dbf	d2,anzahloop5
				
;---------------------------------------------------------------

initpic6:
	tst.b	sig6	
	beq.s	initpic7
	
	lea	struct6(pc),a3

	moveq	#08-1,d2
anzahloop6:
	lea	$40000,a1
	add.w	addy6(pc),a1
	move.l 	#$0fca0000,d1

	move.w 	#128-1,d0
wblit6:	
	btst	#14,$02(a5)
	bne.s	wblit6

	move.l 	a2,$50(a5)		;apt
	move.l 	a0,$4c(a5)		;bpt
	move.l 	a1,$54(a5)		;dpt
	move.l 	a1,$48(a5)		;cpt
	move.l 	d1,$40(a5)		;con0+1
	move.w 	#[3*64]+5,$58(a5)	;size

	add.w	#[104*3],a1

	tst.b	(a3)+
	beq.s	noadd6
	sub.l	#$10001000,d1
	cmp.l	#$ffc9f000,d1
	bne.s	noadd6
	move.l 	#$ffcaf000,d1
	subq.w	#02,a1

noadd6:	
	cmp.l	#struct6e,a3
	bne.s	nostructe6
	lea	struct6(pc),a3
nostructe6:
	dbf	d0,wblit6
		
	add.w	#12,addy6
	dbf	d2,anzahloop6
				
;---------------------------------------------------------------

initpic7:
	tst.b	sig7	
	beq.s	initpic8
		
	lea	struct7(pc),a3

	moveq	#07-1,d2
anzahloop7:
	lea	$40000,a1
	add.w	addy7(pc),a1
	move.l 	#$0fca0000,d1

	move.w 	#128-1,d0
wblit7:
	btst	#14,$02(a5)
	bne.s	wblit7

	move.l 	a2,$50(a5)		;apt
	move.l 	a0,$4c(a5)		;bpt
	move.l 	a1,$54(a5)		;dpt
	move.l 	a1,$48(a5)		;cpt
	move.l 	d1,$40(a5)		;con0+1
	move.w 	#[3*64]+5,$58(a5)	;size

	add.w	#[104*3],a1

	tst.b	(a3)+
	beq.s	noadd7
	sub.l	#$10001000,d1
	cmp.l	#$ffc9f000,d1
	bne.s	noadd7
	move.l 	#$ffcaf000,d1
	subq.w	#02,a1

noadd7:	
	cmp.l	#struct7e,a3
	bne.s	nostructe7
	lea	struct7(pc),a3
nostructe7:
	dbf	d0,wblit7
		
	add.w	#14,addy7
	dbf	d2,anzahloop7
				
;---------------------------------------------------------------

initpic8:
	tst.b	sig8	
	beq.s	copypic
		
	lea	struct8(pc),a3

	moveq	#07-1,d2
anzahloop8:
	lea	$40000,a1
	add.w	addy8(pc),a1
	move.l 	#$0fca0000,d1

	move.w 	#128-1,d0
wblit8:
	btst	#14,$02(a5)
	bne.s	wblit8

	move.l 	a2,$50(a5)		;apt
	move.l 	a0,$4c(a5)		;bpt
	move.l 	a1,$54(a5)		;dpt
	move.l 	a1,$48(a5)		;cpt
	move.l 	d1,$40(a5)		;con0+1
	move.w 	#[3*64]+5,$58(a5)	;size

	add.w	#[104*3],a1

	tst.b	(a3)+
	beq.s	noadd8
	sub.l	#$10001000,d1
	cmp.l	#$ffc9f000,d1
	bne.s	noadd8
	move.l 	#$ffcaf000,d1
	subq.w	#02,a1

noadd8:	
	cmp.l	#struct8e,a3
	bne.s	nostructe8
	lea	struct8(pc),a3
nostructe8:
	dbf	d0,wblit8
		
	add.w	#16,addy8
	dbf	d2,anzahloop8
				
copypic:
	btst	#14,$02(a5)
	bne.s	copypic
		
	move.l 	#$ffffffff,$44(a5)
	move.w 	#16,$64(a5)
	move.w 	#0,$66(a5)
	move.l 	#$40000,$50(a5)
	move.l 	#$60000,$54(a5)
	move.l 	#$09f00000,$40(a5)
	move.w 	#[128*3*64]+44,$58(a5)
		
	rts	


sig4:		dc.b	1
sig5:		dc.b	1
sig6:		dc.b	1
sig7:		dc.b	1
sig8:		dc.b	1

struct4:	dc.b	1,0
struct4e:	even
struct5:	dc.b	1,1,0,1,0,1,1,0
struct5e:	even
struct6:	dc.b	1,1,1,0
struct6e:	even
struct7:	dc.b	1,1,1,1,1,1,1,0
struct7e:	even
struct8:	dc.b	1
struct8e:	even

addy4:		dc.w	0
addy5:		dc.w	0
addy6:		dc.w	-8
addy7:		dc.w	-2
addy8:		dc.w	-8


************************************************************ parapatterns

parapattern:	dc.l	pattern1

pattern1:	dc.w	0		;sinspeed1
		dc.w	0		;sinspeed2
		dc.w	4		;speed horizontal
		dc.w	0		;sinadd1
		dc.w	0		;sinadd2
		dc.w	0		;diagonal
		dc.w	400		;subtime
		dc.l	pattern2	;nextpattern

pattern2:	dc.w	0		;sinspeed1
		dc.w	0		;sinspeed2
		dc.w	-4		;speed horizontal
		dc.w	0		;sinadd1
		dc.w	0		;sinadd2
		dc.w	0		;diagonal
		dc.w	200		;subtime
		dc.l	pattern3	;nextpattern

pattern3:	dc.w	0		;sinspeed1
		dc.w	0		;sinspeed2
		dc.w	8		;speed horizontal
		dc.w	0		;sinadd1
		dc.w	0		;sinadd2
		dc.w	-1		;diagonal
		dc.w	200		;subtime
		dc.l	pattern4	;nextpattern

pattern4:	dc.w	0		;sinspeed1
		dc.w	0		;sinspeed2
		dc.w	-8		;speed horizontal
		dc.w	0		;sinadd1
		dc.w	0		;sinadd2
		dc.w	1		;diagonal
		dc.w	200		;subtime
		dc.l	pattern5	;nextpattern

pattern5:	dc.w	12		;sinspeed1
		dc.w	5		;sinspeed2
		dc.w	0		;speed horizontal
		dc.w	1		;sinadd1
		dc.w	1		;sinadd2
		dc.w	0		;diagonal
		dc.w	600		;subtime
		dc.l	pattern6	;nextpattern

pattern6:	dc.w	4		;sinspeed1
		dc.w	2		;sinspeed2
		dc.w	4		;speed horizontal
		dc.w	1		;sinadd1
		dc.w	2		;sinadd2
		dc.w	0		;diagonal
		dc.w	600		;subtime
		dc.l	pattern7	;nextpattern

pattern7:	dc.w	6		;sinspeed1
		dc.w	8		;sinspeed2
		dc.w	-6		;speed horizontal
		dc.w	1		;sinadd1
		dc.w	1		;sinadd2
		dc.w	0		;diagonal
		dc.w	600		;subtime
		dc.l	pattern8	;nextpattern

pattern8:	dc.w	4		;sinspeed1
		dc.w	10		;sinspeed2
		dc.w	6		;speed horizontal
		dc.w	2		;sinadd1
		dc.w	3		;sinadd2
		dc.w	0		;diagonal
		dc.w	600		;subtime
		dc.l	pattern1	;nextpattern

************************************************************ parastruct

parastruct:	dc.w	0		;sinspeed1
		dc.w	0		;sinspeed2
		dc.w	0		;speed horizontal
		dc.w	0		;sinadd1
		dc.w	0		;sinadd2
		dc.w	0		;diagonal

************************************************************* variablen

multab:
		blk.w	277,0

gfxname:	dc.b	"graphics.library",0,0



color:
	dc.w	$0000,$0FDF,$0DAD,$0A7C,$074A,$0539,$0317,$0106
	dc.w	$0000,$0F0F,$0D0D,$0A0C,$070A,$0509,$0307,$0106
	dc.w	$0000,$00DF,$00AD,$007C,$004A,$0039,$0017,$0006
	dc.w	$0000,$0FD0,$0DA0,$0A70,$0740,$0530,$0310,$0100
	dc.w	$0000,$0ddF,$0bbD,$0aaC,$088A,$0668,$0446,$0334
	dc.w	$0000,$0d00,$0b00,$0a00,$0800,$0600,$0400,$0300
	dc.w	$0000,$0dd0,$0bb0,$0aa0,$0880,$0660,$0440,$0330
	dc.w	$0000,$00d0,$00b0,$00a0,$0080,$0060,$0040,$0030
	dc.w	$0000,$000e,$000c,$000b,$0009,$0007,$0005,$0004
colore:

************************************************************* parasin

parasin:	dc.b      1,1,1,1,1,1,1,1
	        dc.b      1,1,1,1,1,1,1,2
        	dc.b      2,2,2,2,2,2,2,2
        	dc.b      2,3,3,3,3,3,3,3
        	dc.b      4,4,4,4,4,4,5,5
        	dc.b      5,5,5,6,6,6,6,6
        	dc.b      7,7,7,7,8,8,8,9
        	dc.b      9,9,9,10,10,10,11,11
        	dc.b      11,11,12,12,12,13,13,13
        	dc.b      14,14,14,15,15,16,16,16
        	dc.b      17,17,17,18,18,19,19,20
        	dc.b      20,20,21,21,22,22,23,23
        	dc.b      23,24,24,25,25,26,26,27
        	dc.b      27,28,28,29,29,30,30,31
        	dc.b      31,32,32,33,33,34,34,35
        	dc.b      35,36,37,37,38,38,39,39
        	dc.b      40,40,41,42,42,43,43,44
        	dc.b      45,45,46,46,47,48,48,49
        	dc.b      50,50,51,51,52,53,53,54
        	dc.b      55,55,56,57,57,58,59,59
        	dc.b      60,61,61,62,63,63,64,65
        	dc.b      65,66,67,68,68,69,70,70
        	dc.b      71,72,72,73,74,75,75,76
        	dc.b      77,78,78,79,80,81,81,82
        	dc.b      83,83,84,85,86,86,87,88
        	dc.b      89,90,90,91,92,93,93,94
        	dc.b      95,96,96,97,98,99,100,100
        	dc.b      101,102,103,103,104,105,106,107
        	dc.b      107,108,109,110,111,111,112,113
        	dc.b      114,114,115,116,117,118,118,119
        	dc.b      120,121,122,122,123,124,125,126
        	dc.b      126,127,128,129,130,130,131,132
        	dc.b      133,134,134,135,136,137,138,138
        	dc.b      139,140,141,142,142,143,144,145
        	dc.b      145,146,147,148,149,149,150,151
        	dc.b      152,153,153,154,155,156,156,157
        	dc.b      158,159,160,160,161,162,163,163
        	dc.b      164,165,166,166,167,168,169,170
        	dc.b      170,171,172,173,173,174,175,175
        	dc.b      176,177,178,178,179,180,181,181
        	dc.b      182,183,184,184,185,186,186,187
        	dc.b      188,188,189,190,191,191,192,193
        	dc.b      193,194,195,195,196,197,197,198
        	dc.b      199,199,200,201,201,202,203,203
        	dc.b      204,205,205,206,206,207,208,208
        	dc.b      209,210,210,211,211,212,213,213
        	dc.b      214,214,215,216,216,217,217,218
        	dc.b      218,219,219,220,221,221,222,222
        	dc.b      223,223,224,224,225,225,226,226
        	dc.b      227,227,228,228,229,229,230,230
        	dc.b      231,231,232,232,233,233,233,234
        	dc.b      234,235,235,236,236,236,237,237
        	dc.b      238,238,239,239,239,240,240,240
        	dc.b      241,241,242,242,242,243,243,243
        	dc.b      244,244,244,245,245,245,245,246
        	dc.b      246,246,247,247,247,247,248,248
        	dc.b      248,249,249,249,249,250,250,250
        	dc.b      250,250,251,251,251,251,251,252
        	dc.b      252,252,252,252,252,253,253,253
        	dc.b      253,253,253,253,254,254,254,254
	        dc.b   	  254,254,254,254,254,254,255,255
	        dc.b      255,255,255,255,255,255,255,255
	        dc.b      255,255,255,255,255,255,255,255
       		dc.b      255,255,255,255,255,255,255,255
        	dc.b      255,255,255,254,254,254,254,254
        	dc.b      254,254,254,254,254,253,253,253
        	dc.b      253,253,253,253,252,252,252,252
        	dc.b      252,252,251,251,251,251,251,250
        	dc.b      250,250,250,250,249,249,249,249
        	dc.b      248,248,248,247,247,247,247,246
        	dc.b      246,246,245,245,245,245,244,244
        	dc.b      244,243,243,243,242,242,242,241
        	dc.b      241,240,240,240,239,239,239,238
        	dc.b      238,237,237,236,236,236,235,235
        	dc.b      234,234,233,233,233,232,232,231
        	dc.b      231,230,230,229,229,228,228,227
        	dc.b      227,226,226,225,225,224,224,223
        	dc.b      223,222,222,221,221,220,219,219
        	dc.b      218,218,217,217,216,216,215,214
        	dc.b      214,213,213,212,211,211,210,210
        	dc.b      209,208,208,207,206,206,205,205
        	dc.b      204,203,203,202,201,201,200,199
        	dc.b      199,198,197,197,196,195,195,194
        	dc.b      193,193,192,191,191,190,189,188
        	dc.b      188,187,186,186,185,184,184,183
        	dc.b      182,181,181,180,179,178,178,177
        	dc.b      176,175,175,174,173,173,172,171
	        dc.b      170,170,169,168,167,166,166,165
	        dc.b      164,163,163,162,161,160,160,159
        	dc.b      158,157,156,156,155,154,153,153
        	dc.b      152,151,150,149,149,148,147,146
        	dc.b      145,145,144,143,142,142,141,140
        	dc.b      139,138,138,137,136,135,134,134
        	dc.b      133,132,131,130,130,129,128,127
        	dc.b      126,126,125,124,123,122,122,121
        	dc.b      120,119,118,118,117,116,115,114
        	dc.b      114,113,112,111,110,110,109,108
        	dc.b      107,107,106,105,104,103,103,102
        	dc.b      101,100,100,99,98,97,96,96
        	dc.b      95,94,93,93,92,91,90,90
        	dc.b      89,88,87,86,86,85,84,83
        	dc.b      83,82,81,81,80,79,78,78
        	dc.b      77,76,75,75,74,73,72,72
        	dc.b      71,70,70,69,68,68,67,66
        	dc.b      65,65,64,63,63,62,61,61
        	dc.b      60,59,59,58,57,57,56,55
        	dc.b      55,54,53,53,52,51,51,50
        	dc.b      50,49,48,48,47,46,46,45
        	dc.b      45,44,43,43,42,42,41,40
        	dc.b      40,39,39,38,38,37,37,36
        	dc.b      35,35,34,34,33,33,32,32
        	dc.b      31,31,30,30,29,29,28,28
        	dc.b      27,27,26,26,25,25,24,24
        	dc.b      23,23,23,22,22,21,21,20
        	dc.b      20,20,19,19,18,18,17,17
        	dc.b      17,16,16,16,15,15,14,14
        	dc.b      14,13,13,13,12,12,12,11
        	dc.b      11,11,11,10,10,10,9,9
        	dc.b      9,9,8,8,8,7,7,7
        	dc.b      7,6,6,6,6,6,5,5
        	dc.b      5,5,5,4,4,4,4,4
        	dc.b      4,3,3,3,3,3,3,3
        	dc.b      2,2,2,2,2,2,2,2
        	dc.b      2,2,1,1,1,1,1,1
        	dc.b      1,1,1,1,1,1,1,1
parasine:	
		dc.b      1,1,1,1,1,1,1,1
	        dc.b      1,1,1,1,1,1,1,2
        	dc.b      2,2,2,2,2,2,2,2
        	dc.b      2,3,3,3,3,3,3,3
        	dc.b      4,4,4,4,4,4,5,5
        	dc.b      5,5,5,6,6,6,6,6
        	dc.b      7,7,7,7,8,8,8,9
        	dc.b      9,9,9,10,10,10,11,11
        	dc.b      11,11,12,12,12,13,13,13
        	dc.b      14,14,14,15,15,16,16,16
        	dc.b      17,17,17,18,18,19,19,20
        	dc.b      20,20,21,21,22,22,23,23
        	dc.b      23,24,24,25,25,26,26,27
        	dc.b      27,28,28,29,29,30,30,31
        	dc.b      31,32,32,33,33,34,34,35
        	dc.b      35,36,37,37,38,38,39,39
        	dc.b      40,40,41,42,42,43,43,44
        	dc.b      45,45,46,46,47,48,48,49
        	dc.b      50,50,51,51,52,53,53,54
        	dc.b      55,55,56,57,57,58,59,59
        	dc.b      60,61,61,62,63,63,64,65
        	dc.b      65,66,67,68,68,69,70,70
        	dc.b      71,72,72,73,74,75,75,76
        	dc.b      77,78,78,79,80,81,81,82
        	dc.b      83,83,84,85,86,86,87,88
        	dc.b      89,90,90,91,92,93,93,94
        	dc.b      95,96,96,97,98,99,100,100
        	dc.b      101,102,103,103,104,105,106,107
        	dc.b      107,108,109,110,111,111,112,113
        	dc.b      114,114,115,116,117,118,118,119
        	dc.b      120,121,122,122,123,124,125,126
        	dc.b      126,127,128,129,130,130,131,132
        	dc.b      133,134,134,135,136,137,138,138
        	dc.b      139,140,141,142,142,143,144,145
        	dc.b      145,146,147,148,149,149,150,151
        	dc.b      152,153,153,154,155,156,156,157
        	dc.b      158,159,160,160,161,162,163,163
        	dc.b      164,165,166,166,167,168,169,170
        	dc.b      170,171,172,173,173,174,175,175
        	dc.b      176,177,178,178,179,180,181,181
        	dc.b      182,183,184,184,185,186,186,187
        	dc.b      188,188,189,190,191,191,192,193
        	dc.b      193,194,195,195,196,197,197,198
        	dc.b      199,199,200,201,201,202,203,203
        	dc.b      204,205,205,206,206,207,208,208
        	dc.b      209,210,210,211,211,212,213,213
        	dc.b      214,214,215,216,216,217,217,218
        	dc.b      218,219,219,220,221,221,222,222
        	dc.b      223,223,224,224,225,225,226,226
        	dc.b      227,227,228,228,229,229,230,230
        	dc.b      231,231,232,232,233,233,233,234
        	dc.b      234,235,235,236,236,236,237,237
        	dc.b      238,238,239,239,239,240,240,240
        	dc.b      241,241,242,242,242,243,243,243
        	dc.b      244,244,244,245,245,245,245,246
        	dc.b      246,246,247,247,247,247,248,248
        	dc.b      248,249,249,249,249,250,250,250
        	dc.b      250,250,251,251,251,251,251,252
        	dc.b      252,252,252,252,252,253,253,253
        	dc.b      253,253,253,253,254,254,254,254
	        dc.b   	  254,254,254,254,254,254,255,255
	        dc.b      255,255,255,255,255,255,255,255
	        dc.b      255,255,255,255,255,255,255,255
       		dc.b      255,255,255,255,255,255,255,255
        	dc.b      255,255,255,254,254,254,254,254
        	dc.b      254,254,254,254,254,253,253,253
        	dc.b      253,253,253,253,252,252,252,252
        	dc.b      252,252,251,251,251,251,251,250
        	dc.b      250,250,250,250,249,249,249,249
        	dc.b      248,248,248,247,247,247,247,246
        	dc.b      246,246,245,245,245,245,244,244
        	dc.b      244,243,243,243,242,242,242,241
        	dc.b      241,240,240,240,239,239,239,238
        	dc.b      238,237,237,236,236,236,235,235
        	dc.b      234,234,233,233,233,232,232,231
        	dc.b      231,230,230,229,229,228,228,227
        	dc.b      227,226,226,225,225,224,224,223
        	dc.b      223,222,222,221,221,220,219,219
        	dc.b      218,218,217,217,216,216,215,214
        	dc.b      214,213,213,212,211,211,210,210
        	dc.b      209,208,208,207,206,206,205,205
        	dc.b      204,203,203,202,201,201,200,199
        	dc.b      199,198,197,197,196,195,195,194
        	dc.b      193,193,192,191,191,190,189,188
        	dc.b      188,187,186,186,185,184,184,183
        	dc.b      182,181,181,180,179,178,178,177
        	dc.b      176,175,175,174,173,173,172,171
	        dc.b      170,170,169,168,167,166,166,165
	        dc.b      164,163,163,162,161,160,160,159
        	dc.b      158,157,156,156,155,154,153,153
        	dc.b      152,151,150,149,149,148,147,146
        	dc.b      145,145,144,143,142,142,141,140
        	dc.b      139,138,138,137,136,135,134,134
        	dc.b      133,132,131,130,130,129,128,127
        	dc.b      126,126,125,124,123,122,122,121
        	dc.b      120,119,118,118,117,116,115,114
        	dc.b      114,113,112,111,110,110,109,108
        	dc.b      107,107,106,105,104,103,103,102
        	dc.b      101,100,100,99,98,97,96,96
        	dc.b      95,94,93,93,92,91,90,90
        	dc.b      89,88,87,86,86,85,84,83
        	dc.b      83,82,81,81,80,79,78,78
        	dc.b      77,76,75,75,74,73,72,72
        	dc.b      71,70,70,69,68,68,67,66
        	dc.b      65,65,64,63,63,62,61,61
        	dc.b      60,59,59,58,57,57,56,55
        	dc.b      55,54,53,53,52,51,51,50
        	dc.b      50,49,48,48,47,46,46,45
        	dc.b      45,44,43,43,42,42,41,40
        	dc.b      40,39,39,38,38,37,37,36
        	dc.b      35,35,34,34,33,33,32,32
        	dc.b      31,31,30,30,29,29,28,28
        	dc.b      27,27,26,26,25,25,24,24
        	dc.b      23,23,23,22,22,21,21,20
        	dc.b      20,20,19,19,18,18,17,17
        	dc.b      17,16,16,16,15,15,14,14
        	dc.b      14,13,13,13,12,12,12,11
        	dc.b      11,11,11,10,10,10,9,9
        	dc.b      9,9,8,8,8,7,7,7
        	dc.b      7,6,6,6,6,6,5,5
        	dc.b      5,5,5,4,4,4,4,4
        	dc.b      4,3,3,3,3,3,3,3
        	dc.b      2,2,2,2,2,2,2,2
        	dc.b      2,2,1,1,1,1,1,1
        	dc.b      1,1,1,1,1,1,1,1



************************************************************ coplist

	section	grafic,data_C

cop:
	dc.l	$008e2281+1
	dc.l	$009034c1+1
	dc.l	$00920038+4
	dc.l	$009400d0+4
	dc.l	$00960020
	
copcol:	
	dc.l	$01820000,$0182000e
	dc.l	$0184000c,$0186000b
	dc.l	$01880009,$018A0007
	dc.l	$018C0005,$018E0004

	dc.w	$0108,[2*88]+8
	dc.w	$010a,[2*88]+8

	dc.l	$0100b200
copwaits:
	blk.l	7*276,$01800000		; coppeffect

	dc.l	$fffffffe

	ds.b	10000

paragfx:
	dc.l	 $D1742E8B,$D1742E8B
	dc.l	 $FE802FF4,$2FF4017F
	dc.l	 $FFFFD000,$000BFFFF 

paragfxmask:
	dc.l	 $ffffffff,$ffffffff
	dc.l	 $ffffffff,$ffffffff
	dc.l	 $ffffffff,$ffffffff

	end

