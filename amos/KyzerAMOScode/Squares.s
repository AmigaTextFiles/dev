; The Munching Squares!
CLR	; comment out this to CLEAR the squares

 IFD CLR
; MUNCHING SQUARES
;
; A0=BPLPTR
	moveq.w	#0,d1
tloop	moveq.w	#0,d0
xloop	move.w	d0,d2
	eor.w	d1,d2

	mulu	#40,d2
	clr.l	d7
	move.w	d0,d7
	asr.w	#3,d7
	add.w	d7,d2
	asl.w	#3,d7
	sub.w	d0,d7
	subq.w	#1,d7
	move.l	a0,a1
	adda.l	d2,a1
	bset	d7,(a1)

	addq.b	#1,d0
	bne.s	xloop

wvbl	tst.b	$dff005
	bne.s	wvbl
wvbl2	tst.b	$dff005
	beq.s	wvbl2
 
	addq.b	#1,d1
	bne.s	tloop
	rts
 ELSEIF
; FADE OUT MUNCHING SQUARES
;
; STILL A0=BPLPTR!!
	moveq.w	#0,d1
tloop	moveq.w	#0,d0
xloop	move.w	d0,d2
	eor.w	d1,d2

	mulu	#40,d2
	clr.l	d7
	move.w	d0,d7
	asr.w	#3,d7
	add.w	d7,d2
	asl.w	#3,d7
	sub.w	d0,d7
	subq.w	#1,d7
	move.l	a0,a1
	adda.l	d2,a1
	bclr	d7,(a1)

	addq.b	#1,d0
	bne.s	xloop
	addq.b	#1,d1
	bne.s	tloop
	rts
 ENDC
