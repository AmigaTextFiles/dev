*************
************* This is a test program to create a Task with an easily recogizable
************* saved context.
*************

	move.l	#$0,d0
	move.l	#$11111111,d1
	move.l	#$22222222,d2
	move.l	#$33333333,d3
	move.l	#$44444444,d4
	move.l	#$55555555,d5
	move.l	#$66666666,d6
	move.l	#$77777777,d7

	move.l	#$88888888,a0
	move.l	#$99999999,a1
	move.l	#$AAAAAAAA,a2
	move.l	#$BBBBBBBB,a3
	move.l	#$CCCCCCCC,a4
	move.l	#$DDDDDDDD,a5
	move.l	#$EEEEEEEE,a6

	moveq	#-1,d0
	add.l	d0,d0			;set X,N,C (or CCR = $19

endl	or.b	#$0,d0

	or.b	#$0,d1
	or.b	#$0,d1

	trapv

	sub.l	a0,a0
	sub.l	a1,a1
	sub.l	a5,a5
	bra.w	over
	nop

over	move.b	(a0)+,d0
	move.b	(a1)+,d1
	move.b	(a5)+,d6
	move.b	(a5)+,d7

	bra.w	endl
