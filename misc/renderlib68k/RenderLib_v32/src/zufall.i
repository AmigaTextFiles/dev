
	IFND	RANDOM_I
RANDOM_I	SET	1


;------------------------------------------------------------------------
;
;		GetRandom
;
;	>	d0	Untere Grenze
;		d1	Obere Grenze
;
;	<	d0	Zufallszahl


GetRandom:	movem.l	a0/d1-d5,-(a7)

		lea	randomseed(pc),a0
		addq.w	#1,d1
		
		sub.w	d0,d1
		move.w	d0,d5
		move.w	d1,d4
	;	beq.b	.ok
		ext.l	d4

		movem.l	(a0),d0/d1
		andi.b	#$0e,d0
		ori.b	#$20,d0
		move.l	d0,d2
		move.l	d1,d3
		add.l	d2,d2
		addx.l	d3,d3
		add.l	d2,d0
		addx.l	d3,d1
		swap	d3
		swap	d2
		move.w	d2,d3
		clr.w	d2
		add.l	d2,d0
		addx.l	d3,d1

		movem.l	d0/d1,(a0)
		move.l	d1,d0

		clr.w	d0
		swap	d0
		divu.w	d4,d0
		clr.w	d0
		swap	d0
		add.w	d5,d0

		ext.l	d0

		movem.l	(a7)+,a0/d1-d5
		rts


randomseed	dc.l	$342a3f64,$5b23d637

;------------------------------------------------------------------------
;
;		RandomInit
;
;		Setzt Random-Startwert
;
;	>	d0	short	Startwert


RandomInit:	movem.l	d0/d1/a0,-(a7)

		lea	randomseed(pc),a0

		move.w	d0,d1
		eor.w	#$e5d7,d1
		not.w	d0
		muls.w	d0,d1

		move.l	d1,(a0)+
		swap	d1
		eor.l	#$53a7fa5b,d1
		move.l	d1,(a0)

		movem.l	(a7)+,d0/d1/a0
		rts

;------------------------------------------------------------------------

	ENDC
