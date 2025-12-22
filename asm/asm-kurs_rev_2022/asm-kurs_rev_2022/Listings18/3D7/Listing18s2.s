
; Listing18s2.s = MENUwithGLENZ.S

	section	bau,code_C

start
	move.l	4.w,a6
	jsr	-$78(a6)
		bsr.w	tangensberech
		bsr.w	inittransformation

		bsr.w	setup
		lea	$dff002,a6
wb		cmp.b	#$ff,$6-2(a6)
		bne.s	wb
		bsr.w	scroll
		bsr.w	moveroutine
		tst.w	status
		beq.w	wb

		bsr.w	transformation
		bsr.w	dovector

		btst	#6,$bfe001
		bne.s	wb
wblitter	btst	#14,$dff002
		bne.s	wblitter
		move.l	#-1,$dff0044
		move.l	oldirq(pc),$6c.w
		move.w	oldintena(pc),$dff09a		
		move.w	#$83e0,$dff096
wrast		cmp.b	#$0,$dff006
		bne.s	wrast
		move.w	#$0100,$dff096

		move.l	4.w,a6
		lea	gfxname(pc),a1
		jsr	-408(a6)
		move.l	d0,a1
		move.l	38(a1),$dff080
		clr.w	$dff088
		jsr	-414(a6)
		jsr	-$7e(a6)
		move.w	#$83e0,$dff096
		clr.w	$dff180
		rts

gfxname		dc.b	"graphics.library",0,0

oldintena	dc.w	0
setup		bsr.w	doupline

		lea	upcop(pc),a0
		lea	upline(pc),a1
		move.l	a1,d0
		move.w	d0,6(a0)
		swap	d0
		move.w	d0,2(a0)
		lea	upcop1(pc),a0
		move.l	a1,d0
		move.w	d0,6(a0)
		swap	d0
		move.w	d0,2(a0)

		move.w	#$7fff,d0
		lea	$dff002,a6
		move.w	$1c-2(a6),d1
		or.w	#$8000,d1
		move.w	d1,oldintena
		
		move.w	d0,$9a-2(a6)
		move.w	d0,$9c-2(a6)
		move.w	#$e000,$9a-2(a6)

		move.w	$a-2(a6),oldy
		lea	bitplanea+2+64*8,a0
		move.l	a0,d2
		lea	copbitplane1(pc),a2
		addq.l	#2,d2
		move.w	d2,6(a2)
		swap	d2
		move.w	d2,2(a2)		

		move.w	numberofentrys(pc),d0
		mulu	#10,d0
		move.w	d0,ymax
		lea	bitplane+8*44+2,a0
		move.l	a0,d2
		move.w	#$2800-1,d0
clear		clr.b	(a0)+
		dbf	d0,clear
		lea	copbitplane(pc),a2
		addq.l	#2,d2
		move.w	d2,6(a2)
		swap	d2
		move.w	d2,2(a2)		

		lea	colorste(pc),a0
		lea	colorste1(pc),a1
		lea	colors3(pc),a3
		moveq	#7-1,d1		
adr		move.l	#$201ffffe,(a0)+
adr1		move.l	#$201ffffe,(a1)+
		moveq	#0,d2
		addq.b	#1,adr+2
		addq.b	#1,adr1+2
lop1		moveq	#50-1,d0

adr2		move.l	a3,a2
		addq.l	#4,a3
lop2		move.w	#$0182,(a0)+
		move.w	(a2)+,(a0)+
		move.w	#$0182,(a1)+
		move.w	(a2),(a1)+
		dbf	d0,lop2
		dbf	d1,adr

		lea	scrollbuffer,a0
		move.l	a0,d0
		lea	scradr(pc),a1
		lea	scradr1(pc),a2
		move.w	d0,6(a1)
		move.w	d0,6(a2)
		swap	d0
		move.w	d0,2(a1)
		move.w	d0,2(a2)

		lea	coplist(pc),a0
		move.l	a0,$80-2(a6)
		clr.w	$88-2(a6)
		move.w	#0,$dff1fc
		lea	oldirq(pc),a0
		move.l	$6c.w,(a0)
		lea	newirq(pc),a0
		move.l	a0,$6c.w

		bsr.w	beams
		rts
;------------------------------------------------------------------------------
doupline	lea	upline+20(pc),a0
		lea	uptext(pc),a1
		move.w	(a1)+,d0
		add.w	d0,a0
		
textloop	move.b	(a1)+,d0
		beq.w	endtext
		cmp.b	#" ",d0
		bne.s	okspace1
		addq.w	#1,a0
		bra.s	textloop
okspace1	lea	fonttab(pc),a2
		lea	font(pc),a3
sortloop	cmp.b	(a2)+,d0
		beq.s	gotthechar
		addq.l	#1,a3
		tst.b	(a2)
		bne.s	sortloop

gotthechar	move.l	a0,a4

		moveq	#6,d0
printloop	move.b	(a3),(a4)
		lea	40(a4),a4
		lea	36(a3),a3
		dbf	d0,printloop
		addq.l	#1,a0
		bra.s	textloop

endtext		rts
;------------------------------------------------------------------------------
beams		lea	cols1+6(pc),a1
		lea	cols2+63*4+2(pc),a3
		moveq	#52,d2
loop2		move.l	a1,a0
		move.l	a3,a2
		moveq	#11,d0
		move.w	#$444,d1
loop		move.w	d1,(a0)
		move.w	d1,(a2)
		addq.l	#4,a0
		subq.l	#4,a2
		add.w	#$111,d1
noadd		dbf	d0,loop
		addq.l	#4,a1
		subq.l	#4,a3

		move.w	#4000,d7
l		dbf	d7,l
		addq.b	#2,wait+1
		addq.b	#2,wait1+1
		move.w	#3000,d7
l1		dbf	d7,l1
		subq.b	#2,wait+1
		subq.b	#2,wait1+1
		dbf	d2,loop2
		move.w	#$444,cols2+38
		move.w	#$444,cols2+38+4
		move.l	#coplist2,$80-2(a6)
		rts
;------------------------------------------------------------------------------

tangensberech	lea	infobuffer,a0
		move.l	textptr(pc),a1
		lea	sinusende(pc),a6
		move.w	ysetvalue(pc),ystart

newline		move.w	(a1)+,d0		;x2 ;60
		move.w	ystart(pc),d1
		neg.w	d1
		sub.w	#10,ystart

newchar		addq.w	#8,d0			;zeichen abst.
		move.b	(a1)+,d6
		beq.s	newline
		cmp.b	#$ff,d6
		beq.w	return2
		cmp.b	#" ",d6
		beq.s	newchar

		lea	fonttab(pc),a2
		moveq	#0,d7
tstloop		cmp.b	(a2)+,d6
		beq.s	gotchar
		addq.w	#1,d7
		tst.b	(a2)
		bne.s	tstloop
		moveq	#0,d7
gotchar


		moveq	#0,d2			;x1
		moveq	#0,d3		;y1
		move.b	$dff006,d2
		add.b	$dff006,d2
		add.b	$dff007,d2
		ext.w	d2
		move.b	$dff006,d3
		add.b	$dff007,d3
		add.b	$dff007,d3
		ext.w	d3
		neg.w	d3

		sub.w	d0,d2			;x1-x2
		add.w	d2,d2
		add.w	d2,d2
		sub.w	d1,d3			;y1-y2
		add.w	d3,d3
		add.w	d3,d3
		move.w	d2,d4
		move.w	d3,d5

		tst.w	d4
		bpl.w	okd4
		neg.w	d4
okd4		tst.w	d5
		bpl.w	okd5
		neg.w	d5

okd5		cmp.w	d4,d5
		bge.s	ybigger
		clr.w	(a0)+
		exg	d2,d3
		bra.s	ybigger1
ybigger		move.w	#1,(a0)+
ybigger1	ext.l	d2
		asl.l	#8,d2
		divs	d3,d2
		
		move.w	d3,(a0)+		;yodx
		move.w	d2,(a0)+		;xody
		move.w	d0,(a0)+
		move.w	d1,(a0)+
		move.w	d7,(a0)+		;buchstabe

		lea	sinus(pc),a3		;x sin
		lea	sinus(pc),a4		;y sin
		move.b	$dff007,d2
		ext.w	d2
		and.w	#$e,d2
		add.w	d2,a4

		move.b	$dff006,d2
		ext.w	d2
		and.w	#$e,d2
		add.w	d2,a3
		move.l	a3,(a0)+
		move.l	a4,(a0)+
		move.b	$dff007,d4
		and.w	#$6,d4
		move.b	$dff006,d5
		and.w	#$6,d5
		move.w	d4,(a0)+
		move.w	d5,(a0)+

		tst.w	d3
		bpl.s	okd3
		neg.w	d3
okd3
		lsr.w	#2,d3
loop3		add.w	d4,a3
		add.w	d5,a4
		cmp.l	a6,a3
		blt.s	oksinx2
		lea	-[sinusende-sinus](a3),a3
oksinx2		cmp.l	a6,a4
		blt.s	oksiny2
		lea	-[sinusende-sinus](a4),a4
oksiny2		subq.w	#1,d3
		bne.s	loop3

		move.w	(a3),(a0)+
		move.w	(a4),(a0)+
		addq.w	#1,counter2
		bra.w	newchar		

return2		move.w	#$8585,(a0)+
		addq.w	#1,counter2
		rts
;------------------------------------------------------------------------------
moveroutine	tst.w	status
		beq.s	okmove
		rts

okmove		tst.w	counter2
		beq.w	return3

		lea	swapadr(pc),a0
		move.l	8(a0),d0
		move.l	4(a0),8(a0)
		move.l	(a0),4(a0)
		move.l	d0,(a0)

		add.l	#4+[8*64],d0
		lea	copbitplane(pc),a2
		move.w	d0,6(a2)
		swap	d0
		move.w	d0,2(a2)		

wlit		btst	#14,(a6)
		bne.s	wlit
		move.l	#$01000000,$40-2(a6)
		move.w	#24,$66-2(A6)
		move.l	swapadr+4,d0
		add.l	#4+8*64,d0
		move.l	d0,$54-2(a6)
		move.w	#233*64+20,$58-2(a6)

		lea	infobuffer,a0
		lea	font(pc),a3
		lea	sinusende(pc),a6
nextchar	movem.w	(a0)+,d0/d1/d2/d3/d4/d5	;x g od y g/yx/xy/x1/y1
		cmp.w	#$7fff,d1
		bne.w	test3
		cmp.w	#$8585,d0
		beq.w	return

		add.l	#8+8,a0
		bra.s	nextchar

test3		move.l	(a0)+,a4
		move.l	(a0)+,a5

		move.l	swapadr+8(pc),a1

		tst.w	d1
		bne.s	test5
		move.w	#$7fff,-18(a0)
		subq.w	#1,counter2
		addq.l	#4,a0
		lea	bitplanea,a1
		bra.s	test6

test5		add.w	(a0)+,a4	;sin addx
		add.w	(a0)+,a5	;sin addy

test6		move.w	(a0)+,d6
		move.w	(a0)+,d7


		cmp.l	a6,a4
		blt.s	oksinx
		lea	-[sinusende-sinus](a4),a4
oksinx		cmp.l	a6,a5
		blt.s	oksiny
		lea	-[sinusende-sinus](a5),a5
oksiny		move.l	a4,-12-4(a0)
		move.l	a5,-8-4(a0)

		cmp.w	#$8585,d0
		beq.w	return

		tst.w	d1
		beq.s	test
		bmi.s	addxy
		subq.w	#4,-8-2-12-4(a0)
		bra.s	test
addxy		addq.w	#4,-8-2-12-4(a0)

test		muls	d1,d2
		lsr.l	#8,d2
		tst.w	d0
		beq.w	xwasbigger
		exg	d1,d2
xwasbigger	add.w	(a4),d1
		add.w	(a5),d2

		sub.w	d6,d1
		sub.w	d7,d2

		add.w	#160+8,d1
		add.w	d3,d1
		blt.w	nextchar
		cmp.w	#336+16,d1
		bgt.w	nextchar
		add.w	#128-8,d2
		add.w	d4,d2
		ble.w	nextchar
		cmp.w	#248,d2
		bgt.w	nextchar


		asl.w	#6,d2
		move.w	d1,d0
		lsr.w	#4,d0
		add.w	d0,d0
		add.w	d2,d0
		and.w	#$f,d1
		addq.w	#8,d1
		moveq	#6,d7
		lea	(a1,d0.w),a2		
		lea	(a3,d5.w),a4
charloop	moveq	#0,d0
		move.b	(a4),d0
		ror.l	d1,d0
		or.l	d0,(a2)
		lea	64(a2),a2
		lea	36(a4),a4
		dbf	d7,charloop

		bra.w	nextchar
return		lea	$dff002,a6
		rts

return3		lea	bitplanea,a0
		add.l	#8*64+12,a0
		lea	lastbuffer,a1
		move.l	a1,d2

wk		btst	#14,(a6)
		bne.s	wk
		move.l	#-1,$44-2(a6)
		move.l	#$09f00000,$40-2(a6)
		move.l	a0,$50-2(a6)
		move.l	d2,$54-2(a6)
		move.w	#28*2,$66-2(a6)
		move.w	#64-28,$64-2(a6)
		move.w	#200*64+14,$58-2(a6)
wk1		btst	#14,(a6)
		bne.s	wk1

		lea	lastbpl(pc),a0
		move.w	d2,6(a0)
		swap	d2
		move.w	d2,2(a0)


		lea	coplist3(pc),a0
		move.l	a0,$80-2(a6)
		clr.w	$88-2
		move.w	#1,status
		move.w	#$c010,$9a-2(a6)
		rts

counter2	dc.w	0
counter		dc.w	0
status		dc.w	0

newirq:
		btst	#4,$dff01f
		beq.w	noint
		movem.l	d0-d7/a0-a6,-(a7)

		lea	$dff002,a6
mousemove	move.w	$a-2(a6),d0

		move.w	ycord(pc),d1
		move.w	d0,d2
		lsr.w	#8,d0
next		sub.b	oldy(pc),d0
		bmi.s	minus1
		cmp.w	ymax,d1;(a1)
		blt.s	n2
		move.w	ymax,d1;(a1)
		bra.s	next1
n2		add.w	d0,d1;(a1)
		cmp.w	ymax,d1;(a1)
		blt.s	n4
		move.w	ymax,d1;(a1)
n4

		bra.s	next1
minus1		neg.b	d0
		cmp.w	ymin,d1;(a1)
		bgt.s	n3
		move.w	ymin,d1;(a1)
		bra.s	next1
n3		sub.w	d0,d1;(a1)
		cmp.w	ymin,d1;(a1)
		bgt.s	n5
		move.w	ymin,d1;(a1)
n5
next1		move.w	d2,oldy
		move.w	d1,ycord
		lea	copwait(pc),a1
		move.w	#158+8,d2
		sub.w	ysetvalue(pc),d2
		tst.w	d1
		beq.s	log
		sub.w	#1,d1
log		divu	#10,d1
		move.w	d1,0
		mulu	#10,d1
		add.w	d1,d2
		move.b	d2,(a1)
		add.w	#10,d2
		move.b	d2,24(a1)


		move.l	colorptr(pc),a0
		addq.l	#2,a0
		cmp.l	#colorptr,a0
		bne.s	okcolor
		lea	colors(pc),a0
okcolor		move.l	a0,colorptr
		moveq	#4,d0
		
cloop		move.w	(a0),6(a1)
		addq.l	#4,a1
		dbf	d0,cloop
testf		move.w	#$0010,$9c-2(a6)
		movem.l	(a7)+,d0-d7/a0-a6
noint:
	move.w	#$4070,$dff09c
	rte

;------------------------------------------------------------------------------
scroll		subq.w	#1,scount
		bne.w	escroll

		move.w	#8,scount
		move.l	scrollptr(pc),a0
ne		move.b	(a0)+,d0
		bne.s	oks
		move.l	#scrolltext,a0
		bra.s	ne
oks		lea	font(pc),a2
		lea	fonttab(pc),a1
new		cmp.b	(a1)+,d0
		beq.s	gothechar
		addq.l	#1,a2
		tst.b	(a1)
		bne.s	new
		moveq	#6,d0
		lea	scrollbuffer+43+46,a3
ccopyloop	clr.b	(a3)
		lea	46(a3),a3
		dbf	d0,ccopyloop
		bra.s	oksc
gothechar	moveq	#6,d0
		lea	scrollbuffer+43+46,a3
copyloop	move.b	(a2),(a3)
		lea	36(a2),a2
		lea	46(a3),a3
		dbf	d0,copyloop

oksc		move.l	a0,scrollptr

escroll		lea	$dff002,a6
		lea	scrollbuffer+46,a0
		lea	-2(a0),a1
wblit		btst	#14,(a6)
		bne.s	wblit
		move.l	a0,$50-2(a6)
		move.l	a1,$54-2(a6)
		move.l	#$f9f00000,$40-2(a6)
		clr.l	$64-2(a6)
		move.w	#7*64+23,$58-2(a6)
		rts

scount		dc.w	8
;------------------------------------------------------------------------------
colors		dc.w	$333,$444,$555,$666,$777,$888,$999
		dc.w	$aaa,$bbb,$ccc,$ddd,$eee,$fff,$eee,$ddd,$ccc,$bbb
		dc.w	$aaa,$999,$888,$777,$666,$555,$444,$333
colorptr	dc.l	colors
;------------------------------------------------------------------------------
ymin		dc.w	0
ymax		dc.w	0
ycord		dc.w	0
oldy		dc.b	0			;alte werte
		dc.b	0

;------------------------------------------------------------------------------
oldirq		dc.l	0
swapadr		dc.l	bitplane,bitplane1,bitplane2
;------------------------------------------------------------------------------
coplist		dc.l	$01000000
wait		dc.l	$350ffffe
cols1		blk.l	68,$01800000
		dc.l	$01820000
		dc.l	$ffe1fffe
wait1		dc.l	$1e0ffffe
cols2		blk.l	71,$01800000
		blk.l	12,$01820000
		dc.l	-2
		
coplist2	dc.l	$008e2981,$009029c1,$00920038,$009400d0,$01000000
		dc.l	$01020077
		dc.l	$009c8010
		dc.l	$01820fff
		dc.l	$2d0ffffe
upcop		dc.l	$00e00000,$00e20000
		dc.l	$01080000
		dc.l	$01001200
		dc.l	$00960020
		dc.l	$2e0ffffe,$01820eee
		dc.l	$2f0ffffe,$01820ddc
		dc.l	$300ffffe,$01820cca
		dc.l	$310ffffe,$01820bb9
		dc.l	$320ffffe,$01820aa8
		dc.l	$330ffffe,$01820996
		dc.l	$340ffffe,$01820884

		dc.l	$350ffffe,$01800444
		dc.l	$360ffffe,$01800000
		dc.l	$01080018,$010a0018
		dc.l	$01000000
copbitplane	dc.l	$00e00000,$00e20000
copbitplane1	dc.l	$00e40000,$00e60000
		dc.l	$01002200
		dc.l	$01820fff
		dc.l	$01840fff
		dc.l	$01860fff
		dc.l	$ffe1fffe
		dc.l	$1e0ffffe,$01800444,$01000000
		dc.l	$1f0ffffe,$01800000
		dc.l	$00920030,$009400d8,$008e2971,$009029d1
		dc.l	$01080002
scradr		dc.l	$00e00000,$00e20000
		dc.l	$01001200
colorste	blk.l	50*8,$01800000
		dc.l	-2

coplist3	dc.l	$008e2981,$009029c1,$00920038,$009400d0,$01000000
		dc.l	$2d0ffffe
		dc.l	$01820fff
upcop1		dc.l	$00e00000,$00e20000
		dc.l	$01080000
		dc.l	$01001200
		dc.l	$00960020
		dc.l	$2e0ffffe,$01820eee
		dc.l	$2f0ffffe,$01820ddc
		dc.l	$300ffffe,$01820cca
		dc.l	$310ffffe,$01820bb9
		dc.l	$320ffffe,$01820aa8
		dc.l	$330ffffe,$01820996
		dc.l	$340ffffe,$01820884

		dc.l	$350ffffe,$01800444
		dc.l	$360ffffe,$01800000
		dc.l	$01000000,$008e2981,$009029c1
		dc.l	$00960020

		dc.l	$00920030+24,$009400d0-24-8
		dc.l	$01080000+2*28,$010a0000+2*28
vecplaneadrs	dc.l	$00e00000,$00e20000
		dc.l	$00e40000,$00e60000
		dc.l	$00e80000,$00ea0000
lastbpl		dc.l	$00ec0000,$00ee0000
		dc.l	$01004200

_farbendescube	dc.w	$0182,$0006
		dc.w	$0184,$0606
		dc.w	$018A,$000F
		dc.w	$018C,$0F0F


		dc.l	$009c8010

copwait		dc.l	$000ffffe,$01900888,$01920000,$01940000,$019a0000
		dc.l	$019c0000
		dc.l	$000ffffe,$01900fff,$01920fff,$01940fff,$019a0fff
		dc.l	$019c0fff


		dc.l	$ffe1fffe
		dc.l	$1e0ffffe,$01800444,$01000000
		dc.l	$1f0ffffe,$01800000
		dc.l	$00920030,$009400d8,$008e2971,$009029d1
		dc.l	$01080002
scradr1		dc.l	$00e00000,$00e20000
		dc.l	$01001200
colorste1	blk.l	50*8,$01800000
		dc.l	-2

colors3		dc.w	$222,$333,$444,$555,$666,$777,$888,$999
		dc.w	$aaa,$bbb,$ccc,$ddd,$eee,$fff,$eee,$ddd,$ccc,$bbb
		dc.w	$aaa,$999,$888,$777,$666,$555,$444,$333

		dc.w	$222,$333,$444,$555,$666,$777,$888,$999
		dc.w	$aaa,$bbb,$ccc,$ddd,$eee,$fff,$eee,$ddd,$ccc,$bbb
		dc.w	$aaa,$999,$888,$777,$666,$555,$444,$333
		dc.w	$222,$333,$444,$555,$666,$777,$888,$999
		dc.w	$aaa,$bbb,$ccc,$ddd,$eee,$fff,$eee,$ddd,$ccc,$bbb
		dc.w	$aaa,$999,$888,$777,$666,$555,$444,$333
		dc.w	$222,$333,$444,$555,$666,$777,$888,$999
		dc.w	$aaa,$bbb,$ccc,$ddd,$eee,$fff,$eee,$ddd,$ccc,$bbb
		dc.w	$aaa,$999,$888,$777,$666,$555,$444,$333
		dc.w	$222,$333,$444,$555,$666,$777,$888,$999
		dc.w	$aaa,$bbb,$ccc,$ddd,$eee,$fff,$eee,$ddd,$ccc,$bbb
		dc.w	$aaa,$999,$888,$777,$666,$555,$444,$333
		
sinus   dc.w      0,2,3,5,6,8,9,11
        dc.w      12,13,15,16,17,18,19,20
        dc.w      21,22,23,23,24,24,25,25
        dc.w      25,25,25,25,25,24,24,23
        dc.w      23,22,21,20,19,18,17,16
        dc.w      15,13,12,11,9,8,6,5
        dc.w      3,2,0,-1,-3,-4,-6,-7
        dc.w      -9,-10,-12,-13,-14,-15,-17,-18
        dc.w      -19,-20,-21,-21,-22,-23,-23,-24
        dc.w      -24,-24,-24,-25,-24,-24,-24,-24
        dc.w      -23,-23,-22,-21,-21,-20,-19,-18
        dc.w      -17,-15,-14,-13,-12,-10,-9,-7
        dc.w      -6,-4,-3,-1
sinusende

		cnop	0,2

ystart		dc.w	0

modify
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
numberofentrys	dc.w	8
ysetvalue	dc.w	40			;von mitte addiert !!

text		dc.w	-80
		dc.b	"dirwork                ",0
		dc.w	-80
		dc.b	"asm one                ",0
		dc.w	-80
		dc.b	"dms cruncher           ",0
		dc.w	-80
		dc.b	"zoom cruncher          ",0
		dc.w	-80
		dc.b	"lha cruncher           ",0
		dc.w	-80
		dc.b	"xcopy pro 6 4          ",0
		dc.w	-80
		dc.b	"text editor            ",0
		dc.w	-80
		dc.b	"virus killer 6 0     ",$ff
		
	
		
		
	
		

uptext		dc.w	-18
		dc.b	"        subzero tools volume 1",0
		cnop	0,2

scrolltext	dc.b	"       "
		dc.b	"    hello lamers we are back      "
                dc.b    " zacke and dr.no of subzero   and we presents ya"
                dc.b    " subzero tools volume one a disk full with new"
                dc.b    " tools cool wa hehe this disk is for ulf ok here we go with the greetz "
                dc.b    "    jackomo   piwi   jugger of panic   flagg of panic    "
                dc.b    "phantom dude   the dark demon cew   daw of elicma    "
                dc.b    " "
                dc.b    ""
                dc.b    ""
                dc.b    "and the others we know "
                dc.b    " we say bye for now byyyyeeeee fuck ya later hehe"
                dc.b    " schwanzernator  "
;                dc.b    "the personal greetz   hohohoho  gonzo of awake "
;                dc.b    " naechsten samstag legen wir diese stadt in "
;                dc.b    "schutt und asche hehehe  genug alk haben wir ja "
;                dc.b    " und wenn wir mit flensburg fertig sind kommt"
;                dc.b    " glueckstadt dran und so ziehen wir dann von stadt"
;                dc.b    " zu stadt und legen alles in schutt und asche hehe "
;                dc.b    " ok the phychopatic   dr no said now bye          "
                dc.b    "                   "
		cnop	0,2
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
scrollptr	dc.l	scrolltext


textptr		dc.l	text
fonttab		dc.b	"abcdefghijklmnopqrstuvwxyz0123456789",0
		cnop	0,2
		;incdir	"sources:"
font
		dcb.b	5000,$a4
		;incbin	"fonta"
		
upline		blk.b	40*9,0

zoomcount	dc.w	-1200
		dc.w	-30000

dovector	bsr.w	swapvecadrs

;zoom		
		move.w	zoomcount+2(pc),d0
		add.w	#100,d0
		cmp.w	zoomcount,d0
		beq.s	wfill
		move.w	d0,zoomcount+2
		move.w	d0,zoom1+2
		move.w	#1024,d1
		sub.w	d0,d1
		move.w	d1,zoom2+2

wfill		btst	#14,(a6)
		bne.s	wfill

		move.l	#$09f00012,$40-2(a6)
		move.w	#4,$66-2(a6)
		move.w	#4,$64-2(a6)
		move.l	dublebuffer+4(pc),a0
		add.l	#[190+20]*28*3-4,a0
		move.l	a0,$54-2(a6)
		move.l	a0,$50-2(a6)
		move.w	#192*3*64+12,$58-2(a6)

;------------------------------------------------------------------------------
;rotation
;------------------------------------------------------------------------------
drehobj		lea	sinus2(pc),a1		;sintabelle
		lea	angles(pc),a2
		move.w	#360,d1			;max degree

		move.w	(a2),d0
		add.w	#1,d0
		cmp.w	d1,d0
		blt.s	okxangle
		sub.w	d1,d0
okxangle	move.w	d0,(a2)
		add.w	d0,d0
		move.w	(a1,d0.w),d4		;sin(a)
		add.w	#180,d0
		move.w	(a1,d0.w),d5

		move.w	2(a2),d0
		add.w	#1,d0
		cmp.w	d1,d0
		blt.s	okyangle
		sub.w	d1,d0
okyangle	move.w	d0,2(a2)
		add.w	d0,d0
		move.w	(a1,d0.w),a4		;sin(b)
		add.w	#180,d0
		move.w	(a1,d0.w),a5

		move.w	4(a2),d0
		add.w	#1,d0
		cmp.w	d1,d0
		blt.s	okzangle
		sub.w	d1,d0
okzangle	move.w	d0,4(a2)
		add.w	d0,d0
		move.w	(a1,d0.w),a2		;sin(c)
		add.w	#180,d0
		move.w	(a1,d0.w),a3

		lea	structure(pc),a0

		move.w	2(a0),d1
		lea	2(a0,d1.w),a1		;punkt buffer
		moveq	#14-1,d0		;anzahl punkte
		move.w	(a0),d1
		lea	(a0,d1.w),a0		;original punkte


drehschleife	movem.w	(a0)+,d1-d3		;(px,py,pz) (24cyl)

		;rot matrix
		;px1 = px*cos (b) + py*sin (b)
		;py1 = py*cos (b) - px*sin (b)
						;x rotation
		move.w	d5,d6			;cos(a) (4cyl)
		muls	d3,d6			;pz*cos(a) (70cyl)
		move.w	d4,d7			;sin(a) (4cyl)
		muls	d2,d7			;sin(a)*py (70cyl)
		add.l	d6,d7			;cos(a)*pz+sin(a)*py (6cyl)
		add.l	d7,d7			;(6cyl)
		swap	d7			;(4cyl)
		move.w	d3,d6			;pz (4cyl)
		move.w	d7,d3			;pz1 (4cyl)
		muls	d4,d6			;sin(a)*pz (70cyl)
		muls	d5,d2			;cos(a)*py (70cyl)
		sub.l	d6,d2			;sin(a)*pz-cos(a)*py (6cyl)
		add.l	d2,d2			;(6cyl)
		swap	d2			;(4cyl) insg.(328cyl)

						;y rotation
		move.w	d1,a6			;px (4cyl)
		move.w	a5,d7			;cos(b) (4cyl)
		muls	d7,d1			;cos(b)*px (70cyl)
		move.w	a4,d6			;sin(b) (4cyl)
		muls	d3,d6			;sin(b)*pz (70cyl)
		add.l	d6,d1			;cos(b)*px+sin(b)*pz (6cyl)
		add.l	d1,d1			;(6cyl)
		swap	d1			;px new (4cyl)		
		move.w	a6,d7			;px old (4cyl)
		move.w	a4,d6			;sin(b) (4cyl)
		muls	d6,d7			;sin(b)*px (70cyl)
		move.w	a5,d6			;cos(b) (4cyl)
		muls	d6,d3			;cos(b)*pz (70cyl)
		sub.l	d7,d3			;cos(b)*pz-sin(b)*px (6cyl)
		add.l	d3,d3			;(6cyl)
		swap	d3			;(4cyl) insg (336cyl)

						;z rotation
		move.w	d1,a6			;px (4cyl)
		move.w	a3,d7			;cos(c) (4cyl)
		muls	d7,d1			;cos(c)*px (70cyl)
		move.w	a2,d6			;sin(c) (4cyl)
		muls	d2,d6			;sin(c)*py (70cyl)
		add.l	d6,d1			;cos(c)*px+sin(c)*py (6cyl)
		add.l	d1,d1			;(6cyl)
		swap	d1			;px new (4cyl)		
		move.w	a6,d7			;px old (4cyl)
		move.w	a2,d6			;sin(c) (4cyl)
		muls	d6,d7			;sin(c)*px (70cyl)
		move.w	a3,d6			;cos(c) (4cyl)
		muls	d6,d2			;cos(c)*py (70cyl)
		sub.l	d7,d2			;cos(c)*py-sin(c)*px (6cyl)
		add.l	d2,d2			;(6cyl)
		swap	d2			;py new (4cyl) insg (336cyl)

		movem.w	d1-d3,(a1)
		addq.l	#6,a1
zoom1		add.w	#-1200,d3			;z add
		sub.w	#1024,d3			;pz-auge
		ext.l	d1
		ext.l	d2
		moveq	#10,d7
		asl.l	d7,d1
		asl.l	d7,d2
		divs	d3,d1			;px*auge/(pz-auge)
		divs	d3,d2			;py*auge/(pz-auge)
		neg.w	d1			;px = 0-px
		add.w	#111,d1
		add.w	#96+20,d2
		move.w	d1,(a1)+
		move.w	d2,(a1)+

		dbf	d0,drehschleife

		lea	emptybuffer(pc),a6
		movem.l	(a6),d0-a5
		move.l	dublebuffer+12(pc),a6
		lea	[193+20]*28*3(a6),a6
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)


		lea	structure(pc),a0
		move.w	2(a0),d0
		lea	2(a0,d0.w),a1		;punktbuffer

		move.w	4(a0),d0
		lea	4+4(a0,d0.w),a0		;adr flaechen+4


vloop		move.w	(a0),d0
		bmi.w	endeflaechen
		movem.w	(a1,d0.w),a4-a6		;px1,py1,pz1
		move.w	2(a0),d3
		movem.w	(a1,d3.w),d3-d5		;px2,py2,pz2
		sub.w	a4,d3			;px2-px1 [Vx]
		sub.w	a5,d4			;py2-py1 [Vy]
		sub.w	a6,d5			;pz2-pz1 [Vz]
		move.w	a4,a2
		move.w	4(a0),d0
		movem.w	(a1,d0.w),d0-d2		;px3,py3,pz3
		sub.w	a4,d0			;px3-px1 [Wx]
		sub.w	a5,d1			;py3-py1 [Wy]
		sub.w	a6,d2			;pz3-pz1 [Wz]
		move.w	d1,d6			;Wy
		move.w	d2,d7			;Wz
		muls	d4,d2			;Vy*Wz
		muls	d5,d1			;Vz*Wy
		sub.l	d1,d2			;Vy*Wz-Vz*Wy [Nx]
		roxr.l	#2,d2

		move.w	d0,a4			;Wx
		muls	d5,d0			;Vz*Wx
		muls	d3,d7			;Vx*Wz
		sub.l	d7,d0			;Vz*Wx-Vx*Wz [Ny]
		roxr.l	#2,d0
		
		muls	d3,d6			;Vx*Wy
		move.w	a4,d7			;Wx
		muls	d4,d7			;Vy*Wx
		sub.l	d7,d6			;Vx*Wy-Vy*Wx [Nz]
		roxr.l	#2,d6

		move.w	a2,d3			;px1 [Sx]
		move.w	a5,d4			;py1 [Sy]
		move.w	a6,d5			;pz1 [Sz]
zoom2		sub.w	#1024-[-1200],d5	;betrachter z [Sz]
		muls	d2,d3			;[Nx]*[Sx]
		muls	d0,d4			;[Ny]*[Sy]
		muls	d6,d5			;[Nz]*[Sz]
		lea	$dff002,a6
		add.l	d4,d3
		add.l	d5,d3
		bpl.w	drawback

		move.l	dublebuffer+8(pc),a3
		move.w	-4(a0),d0
		beq.s	noaddbpl
		lea	28(a3),a3	
noaddbpl	moveq	#3-1,d7			;anzahl lines

lineloop	move.w	(a0),d0
		movem.w	6(a1,d0.w),d0-d1
		move.w	2(a0),d2
		movem.w	6(a1,d2.w),d2-d3

		move.l	a3,a4
		
		cmp.w	d1,d3
		beq.w	noline
		bgt.s	nohi
		exg	d0,d2
		exg	d1,d3
nohi		move.w	d0,d4
		move.w	d1,d5
		mulu	#28*3,d5
		add.l	d5,a4

		lsr.w	#4,d4			;breite durch 16 teilen
		add.w	d4,d4			;mal 2 weil worte
		lea	(a4,d4.w),a4		;auf source addieren
		sub.w	d0,d2
		sub.w	d1,d3
		moveq	#15,d5
		and.l	d5,d0
		move.w	d0,d4
		ror.l	#4,d0
		eor.w	d5,d4
		moveq	#0,d5
		bset	d4,d5
		move.w	#4,d0
		tst.w	d2
		bpl.s	plus
		addq.w	#1,d0
		neg.w	d2
plus		cmp.w	d2,d3
		ble.s	minus
		exg	d2,d3
		subq.w	#4,d0
		add.w	d0,d0
minus		move.w	d3,d4
		sub.w	d2,d4
		add.w	d4,d4
		add.w	d4,d4
		add.w	d3,d3
		moveq	#0,d6
		move.w	d3,d6
		sub.w	d2,d6
		bpl.s	plus1
		bset	#4,d0
plus1		add.w	d3,d3
		add.w	d0,d0
		add.w	d0,d0
		addq.w	#1,d2
		asl.w	#6,d2
		addq.w	#2,d2
		swap	d3
		move.w	d4,d3
		or.l	#$0b5a0003,d0		;5a/3

wb3		btst	#14,(a6)
		bne.s	wb3
		eor.w	d5,(a4)

		move.l	d0,$40-2(a6)
		moveq	#28*3,d0
		move.w	d0,$60-2(a6)		;breite plane
		move.w	d0,$66-2(a6)		;breite plane
		move.l	a4,$48-2(a6)
		move.w	d6,$52-2(a6)
		move.l	a4,$54-2(a6)
		move.l	d3,$62-2(a6)
		move.l	#$ffff8000,$72-2(a6)	;muster der lines
		move.w	d2,$58-2(a6)
noline		addq.l	#2,a0
		dbf	d7,lineloop
		addq.l	#6,a0

		bra.w	vloop
drawback	move.w	-4(a0),d0
		beq.w	next6
		move.l	dublebuffer+8(pc),a3
		lea	28*2(a3),a3
		bra.w	noaddbpl

next6		lea	12(a0),a0
		bra.w	vloop



endeflaechen	lea	$dff002,a6
waitbl		btst	#14,(a6)
		bne.s	waitbl
		move.l	#$01000000,$40-2(a6)
		move.l	dublebuffer+12(pc),a0
		add.l	#2+20*3*28,a0
		move.l	a0,$54-2(a6)
		move.w	#4,$66-2(a6)
		move.w	#40*3*64+12,$58-2(a6)

		lea	emptybuffer(pc),a6
		movem.l	(a6),d0-a5
		move.l	dublebuffer+12(pc),a6
		lea	[77+20]*28*3(a6),a6
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)

		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)
		movem.l	d0-a5,-(a6)


		lea	$dff002,a6
		rts
;------------------------------------------------------------------------------
angles		dc.w	0,0,0
;------------------------------------------------------------------------------
swapvecadrs	lea	vecplaneadrs(pc),a0
		lea	dublebuffer(pc),a1

		move.l	(a1),d0
		move.l	4(a1),(a1)
		move.l	8(a1),4(a1)
		move.l	12(a1),8(a1)
		move.l	d0,12(a1)		
		move.l	(a1),d0
		addq.l	#2,d0
		move.w	d0,6(a0)		;l
		swap	d0
		move.w	d0,2(a0)		;h
		swap	d0
		add.l	#28,d0
		move.w	d0,6+8(a0)		;l
		swap	d0
		move.w	d0,2+8(a0)		;h
		swap	d0
		add.l	#28,d0
		move.w	d0,6+16(a0)		;l
		swap	d0
		move.w	d0,2+16(a0)		;h
		rts
;------------------------------------------------------------------------------
		
dublebuffer	dc.l	vecplane1,vecplane2,vecplane3,vecplane4	;show/draw
;------------------------------------------------------------------------------
structure	dr.w	punkte
		dr.w	punktbuffer
		dr.w	flaechen

punktbuffer	blk.w	5*15,0

punkte		blk.w	5*16,0

;------------------------------------------------------------------------------
flaechen	dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	0*10,1*10,8*10,0*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	0*10,8*10,3*10,0*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	8*10,2*10,3*10,8*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	1*10,2*10,8*10,1*10

;------------------------------------------------------------------------------
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	1*10,5*10,9*10,1*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	1*10,9*10,2*10,1*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	9*10,6*10,2*10,9*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	5*10,6*10,9*10,5*10

;------------------------------------------------------------------------------
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	5*10,4*10,10*10,5*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	5*10,10*10,6*10,5*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	10*10,7*10,6*10,10*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	4*10,7*10,10*10,4*10
;------------------------------------------------------------------------------
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	4*10,0*10,11*10,4*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	4*10,11*10,7*10,4*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	11*10,3*10,7*10,11*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	0*10,3*10,11*10,0*10
;------------------------------------------------------------------------------
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	4*10,5*10,13*10,4*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	4*10,13*10,0*10,4*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	13*10,1*10,0*10,13*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	5*10,1*10,13*10,5*10
;------------------------------------------------------------------------------
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	3*10,2*10,12*10,3*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	3*10,12*10,7*10,3*10
		dc.w	1		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	12*10,6*10,7*10,12*10
		dc.w	0		;farbe (0,1)
		dc.w	0		;i`m back ??
		dc.w	2*10,6*10,12*10,2*10
;------------------------------------------------------------------------------
		dc.w	0	
		dc.w	0
		dc.w	-1
;------------------------------------------------------------------------------
inittransformation
		lea	movestructure(pc),a4
		move.l	a4,a0

tallloop	move.w	(a0),d0
		lea	(a4,d0.w),a0

		lea	14(a0),a1	;delta buffer

		move.w	2(a0),d0
		lea	2(a0,d0.w),a2
		move.w	4(a0),d0
		lea	4(a0,d0.w),a3
		
		moveq	#14-1,d7
smalloop	movem.w	(a2)+,d0/d1/d2
		movem.w	(a3)+,d3/d4/d5
		sub.w	d0,d3		;delta x
		sub.w	d1,d4		;delta y
		sub.w	d2,d5		;delta z

		ext.l	d3
		ext.l	d4
		ext.l	d5

		moveq	#14,d6
		asl.l	d6,d3		;mal 2^14
		asl.l	d6,d4		;mal 2^14
		asl.l	d6,d5		;mal 2^14
		move.w	10(a0),d6
		divs	d6,d3		;wx=dx*2^14/q
		divs	d6,d4		;wy=dy*2^14/q
		divs	d6,d5		;wz=dz*2^14/q
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d5,(a1)+
		dbf	d7,smalloop

		tst.w	(a0)
		bne.s	tallloop
		rts
;------------------------------------------------------------------------------
transformation
		lea	structure(pc),a0
		move.w	(a0),d0
		lea	(a0,d0.w),a0		;rotations punkt buffer

		lea	movestructure(pc),a1

		move.w	(a1),d0
		lea	(a1,d0.w),a1


		move.w	12(a1),d7 		;counter
		cmp.w	10(a1),d7
		bgt.s	transform_done
		addq.w	#1,d7
		move.w	d7,12(a1)

		move.w	2(a1),d0
		lea	2(a1,d0.w),a2		;von trans		

		lea	14(a1),a3		;deltas

		moveq	#14-1,d6
		move.l	#14,a4
t_loop		movem.w	(a2)+,d0/d1/d2		;von
		
		movem.w	(a3)+,d3/d4/d5

		move.w	12(a1),d7		;adda
		muls	d7,d3
		muls	d7,d4
		muls	d7,d5
		move.l	a4,d7
		lsr.l	d7,d3		
		lsr.l	d7,d4
		lsr.l	d7,d5		
		add.w	d0,d3
		add.w	d1,d4
		add.w	d2,d5
		movem.w	d3/d4/d5,(a0)
		addq.l	#6,a0
		dbf	d6,t_loop
		rts

transform_done	move.w	8(a1),d1
		addq.w	#1,d1
		cmp.w	6(a1),d1
		bne.s	exit_transformation1
		clr.w	8(a1)
		clr.w	12(a1)
		move.w	(a1),d0
		beq.w	exit_transformation
		move.w	d0,movestructure
		rts
exit_transformation1
		move.w	d1,8(a1)
		rts
exit_transformation
		move.w	movestructure+2(pc),movestructure
		rts
;------------------------------------------------------------------------------
movestructure	dc.w	nextmove0-movestructure
		dc.w	nextmove0-movestructure

nextmove0	dc.w	nextmove1-movestructure
		dr.w	viereck
		dr.w	ball
		dc.w	60		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	20		;zaehler fuer oben
		blk.w	3*15,0		;deltas
		
nextmove1	dc.w	nextmove2-movestructure
		dr.w	ball
		dr.w	viereck
		dc.w	11		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	0		;zaehler fuer oben
		blk.w	3*15,0		;deltas

nextmove2	dc.w	nextmove3-movestructure
		dr.w	viereck
		dr.w	shuttle
		dc.w	11		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	0		;zaehler fuer oben
		blk.w	3*15,0		;deltas

nextmove3	dc.w	nextmove4-movestructure
		dr.w	shuttle
		dr.w	ball
		dc.w	11		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	0		;zaehler fuer oben
		blk.w	3*15,0		;deltas

nextmove4	dc.w	nextmove5-movestructure
		dr.w	ball
		dr.w	pyramide
		dc.w	11		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	0		;zaehler fuer oben
		blk.w	3*15,0		;deltas

nextmove5	dc.w	nextmove6-movestructure
		dr.w	pyramide
		dr.w	diamant
		dc.w	11		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	0		;zaehler fuer oben
		blk.w	3*15,0		;deltas

nextmove6	dc.w	nextmove7-movestructure
		dr.w	diamant
		dr.w	shuttle
		dc.w	11		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	0		;zaehler fuer oben
		blk.w	3*15,0		;deltas

nextmove7	dc.w	0;nextmove8-movestructure
		dr.w	shuttle
		dr.w	viereck
		dc.w	21		;1000*60ms sichtbar
		dc.w	0
		dc.w	256		;divisions quotient
		dc.w	0		;zaehler fuer oben
		blk.w	3*15,0		;deltas

;------------------------------------------------------------------------------
;coordinaten buffer fuer transformation
ball		dc.w	-120,120,-120
		dc.w	120,120,-120
		dc.w	120,-120,-120
		dc.w	-120,-120,-120
		dc.w	-120,120,120
		dc.w	120,120,120
		dc.w	120,-120,120
		dc.w	-120,-120,120
		dc.w	0,0,-120
		dc.w	120,0,0
		dc.w	0,0,120
		dc.w	-120,0,0
		dc.w	0,-120,0
		dc.w	0,120,0

viereck		dc.w	-120,120,-120
		dc.w	120,120,-120
		dc.w	120,-120,-120
		dc.w	-120,-120,-120
		dc.w	-120,120,120
		dc.w	120,120,120
		dc.w	120,-120,120
		dc.w	-120,-120,120
		dc.w	0,0,-200
		dc.w	200,0,0
		dc.w	0,0,200
		dc.w	-200,0,0
		dc.w	0,-200,0
		dc.w	0,200,0

shuttle		dc.w	-80,50,-120  ;0
		dc.w	80,50,-120   ;1
		dc.w	80,-50,-120  ;2
		dc.w	-80,-50,-120 ;3
		dc.w	-80,30,120   ;4
		dc.w	80,30,120    ;5
		dc.w	80,-30,120   ;6
		dc.w	-80,-30,120  ;7
		dc.w	0,0,-120     ;8
		dc.w	190,0,-100   ;9
		dc.w	0,0,160	     ;10
		dc.w	-190,0,-100  ;11
		dc.w	0,-60,0     ;12
		dc.w	0,60,0      ;13

diamant		dc.w	-65,35,-65 ;0
		dc.w	65,35,-65 ;1
		dc.w	120,-120,-120 ;2
		dc.w	-120,-120,-120 ;3
		dc.w	-65,35,65 ;4
		dc.w	65,35,65 ;5
		dc.w	120,-120,120 ;6
		dc.w	-120,-120,120 ;7
		dc.w	0,0,-80 ;8
		dc.w	80,0,0 ;9
		dc.w	0,0,80 ;10
		dc.w	-80,0,0 ;11
		dc.w	0,-120,0 ;12
		dc.w	0,190,0 ;13

pyramide	dc.w	-60,40,-60	;0
		dc.w	60,40,-60	;1
		dc.w	60,-40,-60	;2
		dc.w	-60,-40,-60	;3
		dc.w	-60,40,60	;4
		dc.w	60,40,60	;5
		dc.w	60,-40,60	;6
		dc.w	-60,-40,60	;7
		dc.w	0,0,-60		;8
		dc.w	60,0,0		;9
		dc.w	0,0,60		;10
		dc.w	-60,0,0		;11
		dc.w	0,-190,0	;12
		dc.w	0,190,0		;13

sinus2	dc.w	0,572,1144,1715,2286,2856,3425,3993
	dc.w	4560,5126,5690,6252,6813,7371,7927,8481
	dc.w	9032,9580,10126,10668,11207,11743,12275,12803
	dc.w	13328,13848,14364,14876,15383,15886,16383,16876
	dc.w	17364,17846,18323,18794,19260,19720,20173,20621
	dc.w	21062,21497,21925,22347,22762,23170,23571,23964
	dc.w	24351,24730,25101,25465,25821,26169,26509,26841
	dc.w	27165,27481,27788,28087,28377,28659,28932,29196
	dc.w	29451,29697,29934,30162,30381,30591,30791,30982
	dc.w	31163,31335,31498,31650,31794,31927,32051,32165
	dc.w	32269,32364,32448,32523,32588,32642,32687,32722
	dc.w	32747,32762,32767,32762,32747,32722,32687,32642
	dc.w	32587,32523,32448,32364,32269,32165,32051,31927
	dc.w	31794,31650,31498,31335,31163,30982,30791,30591
	dc.w	30381,30162,29934,29697,29451,29196,28932,28659
	dc.w	28377,28087,27788,27481,27165,26841,26509,26169
	dc.w	25821,25465,25101,24730,24351,23964,23571,23170
	dc.w	22762,22347,21925,21497,21062,20621,20173,19720
	dc.w	19260,18794,18323,17846,17364,16876,16384,15886
	dc.w	15383,14876,14364,13848,13328,12803,12275,11743
	dc.w	11207,10668,10126,9580,9032,8481,7927,7371
	dc.w	6813,6252,5690,5126,4560,3993,3425,2856
	dc.w	2286,1715,1144,572,0,-571,-1143,-1714
	dc.w	-2285,-2855,-3424,-3993,-4560,-5125,-5689,-6252
	dc.w	-6812,-7370,-7926,-8480,-9031,-9579,-10125,-10667
	dc.w	-11206,-11742,-12274,-12802,-13327,-13847,-14363,-14875
	dc.w	-15382,-15885,-16383,-16876,-17363,-17845,-18322,-18794
	dc.w	-19259,-19719,-20173,-20620,-21061,-21496,-21925,-22346
	dc.w	-22761,-23169,-23570,-23964,-24350,-24729,-25100,-25464
	dc.w	-25820,-26168,-26508,-26840,-27164,-27480,-27787,-28086
	dc.w	-28376,-28658,-28931,-29195,-29450,-29696,-29933,-30162
	dc.w	-30380,-30590,-30790,-30981,-31163,-31335,-31497,-31650
	dc.w	-31793,-31927,-32050,-32164,-32269,-32363,-32448,-32522
	dc.w	-32587,-32642,-32687,-32722,-32747,-32762,-32767,-32762
	dc.w	-32747,-32722,-32687,-32642,-32587,-32522,-32448,-32363
	dc.w	-32269,-32165,-32051,-31927,-31793,-31650,-31497,-31335
	dc.w	-31163,-30981,-30791,-30590,-30381,-30162,-29934,-29697
	dc.w	-29451,-29195,-28931,-28658,-28377,-28087,-27788,-27481
	dc.w	-27165,-26841,-26509,-26169,-25821,-25465,-25101,-24729
	dc.w	-24351,-23964,-23571,-23170,-22762,-22347,-21925,-21497
	dc.w	-21062,-20621,-20173,-19720,-19260,-18794,-18323,-17846
	dc.w	-17364,-16876,-16384,-15886,-15383,-14876,-14364,-13848
	dc.w	-13328,-12803,-12275,-11743,-11207,-10668,-10126,-9580
	dc.w	-9032,-8481,-7927,-7371,-6813,-6252,-5690,-5126
	dc.w	-4560,-3994,-3425,-2856,-2286,-1715,-1144,-572

	dc.w	0,572,1144,1715,2286,2856,3425,3993
	dc.w	4560,5126,5690,6252,6813,7371,7927,8481
	dc.w	9032,9580,10126,10668,11207,11743,12275,12803
	dc.w	13328,13848,14364,14876,15383,15886,16383,16876
	dc.w	17364,17846,18323,18794,19260,19720,20173,20621
	dc.w	21062,21497,21925,22347,22762,23170,23571,23964
	dc.w	24351,24730,25101,25465,25821,26169,26509,26841
	dc.w	27165,27481,27788,28087,28377,28659,28932,29196
	dc.w	29451,29697,29934,30162,30381,30591,30791,30982
	dc.w	31163,31335,31498,31650,31794,31927,32051,32165
	dc.w	32269,32364,32448,32523,32588,32642,32687,32722
	dc.w	32747,32762,32767,32762,32747,32722,32687,32642
	dc.w	32587,32523,32448,32364,32269,32165,32051,31927
	dc.w	31794,31650,31498,31335,31163,30982,30791,30591
	dc.w	30381,30162,29934,29697,29451,29196,28932,28659
	dc.w	28377,28087,27788,27481,27165,26841,26509,26169
	dc.w	25821,25465,25101,24730,24351,23964,23571,23170
	dc.w	22762,22347,21925,21497,21062,20621,20173,19720
	dc.w	19260,18794,18323,17846,17364,16876,16384,15886
	dc.w	15383,14876,14364,13848,13328,12803,12275,11743
	dc.w	11207,10668,10126,9580,9032,8481,7927,7371
	dc.w	6813,6252,5690,5126,4560,3993,3425,2856
	dc.w	2286,1715,1144,572,0
;------------------------------------------------------------------------------


emptybuffer	blk.l	15,0
vecplane1	blk.b	233*28*3
vecplane2	blk.b	233*28*3
vecplane3	blk.b	233*28*3
vecplane4	blk.b	233*28*3
		

bitplane	blk.b	256*64,0
bitplane1	blk.b	256*64,0
bitplane2	blk.b	256*64,0
bitplanea	blk.b	256*64,0
infobuffer	blk.l	2000,0
lastbuffer	blk.b	256*28*3,0
scrollbuffer	blk.b	46*10,0
	
