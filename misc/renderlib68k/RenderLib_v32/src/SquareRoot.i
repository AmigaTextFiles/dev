
	IFND	SQUAREROOT_I
SQUAREROOT_I		SET	1	

SQRT		MACRO

		moveq	#0,d1
		moveq	#0,d3
		moveq	#15,d2

.sqrloop\@	move.l	d3,d5
		lsl.l	#2,d1
		move.l	d0,d4
		rol.l	#2,d4
		and.b	#3,d4
		or.b	d4,d1
		lsl.l	#2,d0
		lsl.l	#2,d3
		addq.l	#1,d3
		sub.l	d3,d1
		bge.s	.sqrskip\@

		add.l	d3,d1
		move.l	d5,d3
		add.l	d3,d3
		dbf	d2,.sqrloop\@
		bra.s	.sqrraus\@

.sqrskip\@	move.l	d5,d3
		add.l	d3,d3
		or.b	#1,d3
		dbf	d2,.sqrloop\@

.sqrraus\@	moveq	#0,d0
		move.w	d3,d0

		ENDM

	ENDC
