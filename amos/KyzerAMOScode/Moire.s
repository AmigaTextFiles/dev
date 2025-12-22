; AMOS realtime Moire Interference Generator
;
; To use this in your AMOS programs first you must compile it
; in Devpac2 to a file, then run AMOS and type the following in Direct Mode
; pload "<file>",8
; where <file> is the filename you assembled this to.
;
; in your AMOS code, you must type these 4 lines where X is an X coordinate
; of some sort, and Y is a Y coordinate
; Dreg(2)=X 
; Dreg(3)=Y 
; Areg(0)=Logbase(0) 
; Call 8
;
; NOTE : you must set width and height (below) to the size of the screen
; you will be using in AMOS! Otherwise, the picture will be wrong and the
; Amiga will most certainly crash!

width=320	; the width  of your AMOS screen
height=200	; the height "   "    "     "
step=8		; the Moire spacing from 2 (slow) to 8 (fast)



	movem.l	d0-d7/a0-a6,-(sp)
	lea	$dff000,a5

	moveq.w	#0,d0
	moveq.w	#0,d1
top	bsr.s	line
	addq.w	#step,d0
	cmp.w	#width,d0
	blt.s	top

	moveq.w	#0,d0
	move.w	#height-1,d1
bottom	bsr.s	line
	addq.w	#step,d0
	cmp.w	#width,d0
	blt.s	bottom

	moveq.w	#0,d0
	moveq.w	#0,d1
left	bsr.s	line
	addq.w	#step,d1
	cmp.w	#height,d1
	blt.s	left

	move.w	#width-1,d0
	moveq.w	#0,d1
right	bsr.s	line
	addq.w	#step,d1
	cmp.w	#height,d1
	blt.s	right

	movem.l	(sp)+,d0-d7/a0-a6
	rts


; line code by tom. d0=x1, d1=y1, d2=x2, d3=y2, a0=plane, a5=$dff000

line	movem.l	d0-d5,-(sp)
	moveq.w	#width/8,d4
	muls	d1,d4
	moveq.w	#-16,d5
	and.w	d0,d5
	asr.w	#3,d5
	add.w	d5,d4
	add.l	a0,d4
	clr.l	d5
	sub.w	d1,d3
	roxl.b	#1,d5
	tst.w	d3
	bge.s	y2gty1
	neg.w	d3
y2gty1	sub.w	d0,d2
	roxl.b	#1,d5
	tst.w	d2
	bge.s	x2gtx1
	neg.w	d2
x2gtx1	move.w	d3,d1
	sub.w	d2,d1
	bge.s	dygtdx
	exg	d2,d3
dygtdx	roxl.b	#1,d5
	tst.w	d3
	beq.s	noline
waitblit	btst	#14,2(a5)
	bne.s	waitblit
	move.b	octants(pc,d5.w),d5
	add.w	d2,d2
	move.w	d2,$62(a5)
	sub.w	d3,d2
	bgt.s	signn1
	or.b	#$40,d5
signn1	move.w	d2,$52(a5)
	sub.w	d3,d2
	move.w	d2,$64(a5)
	move.w	#$8000,$74(a5)
	move.w	#$ffff,$72(a5)
	move.w	#$ffff,$44(a5)
	and.w	#$f,d0
	ror.w	#4,d0
	or.w	#$bca,d0
	move.w	d0,$40(a5)
	move.w	d5,$42(a5)
	move.l	d4,$54(a5)
	move.l	d4,$48(a5)
	move.w	#width/8,$66(a5)
	move.w	#width/8,$60(a5)
	lsl.w	#6,d3
	addq	#2,d3
	move.w	d3,$58(a5)
noline	movem.l	(sp)+,d0-d5
	rts
octants	dc.b 1,17,9,21,5,25,13,29 

