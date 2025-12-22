


_LVOFreeMem		equ	-$D2
_LVOAllocMem		equ	-$C6


	incbin	start-30KB.bin

	;move.l	4.w,a6
	;jsr	-132(a6)		;Forbid
	;bsr.b	Filler
	;jsr	-138(a6)		;Permit
	;moveq	#0,d0
	;rts

Filler:
	moveq	#0,d0

;convert first digit if any

	rol.l	#4,d0
	lea.l	Table(pc),a1

.x	move.b	(a0)+,d1
	cmp.b	#"$",d1
	beq.b	.x
	cmp.b	#" ",d1
	beq.b	.x
	bset	#5,d1			;-->lowercase
	
	moveq	#16-1,d7
.scan:	cmp.b	(a1)+,d1
	bne.b	.not
	moveq	#16-1,d2
	sub.b	d7,d2
	add.b	d2,d0
	bra.b	next
.not:	dbra	d7,.scan
	bra.b	go



;convert second digit if any

next:	rol.l	#4,d0
	lea.l	Table(pc),a1

.y	move.b	(a0)+,d1
	cmp.b	#"$",d1
	beq.b	.y
	cmp.b	#" ",d1
	beq.b	.y
	bset	#5,d1			;-->lowercase
	
	moveq	#16-1,d7
.scan:	cmp.b	(a1)+,d1
	bne.b	.not
	moveq	#16-1,d2
	sub.b	d7,d2
	add.b	d2,d0
	bra.b	go
.not:	dbra	d7,.scan


go:
	move.l	a7,a5

	move.l	d0,d4
	move.l	4.W,a6

	move.l	d0,a1
	move.l	#$800000,d3
.AllocLoop:
	move.l	d3,d0
	moveq	#0,d1
	jsr	_LVOAllocMem(a6)
	
	tst.l	d0
	beq.b	.NoMem
	
	move.l	d0,-(sp)
	move.l	d0,a2
	move.l	d3,d0
	move.l	d3,-(sp)

	subq.l	#2,d0
.fill:
	move.b	d4,(a2)+
	subq.l	#1,d0
	bne.s	.fill
	
	bra.b	.AllocLoop

.NoMem:
	ror.l	#1,d3
	cmp.l	#512,d3
	bge.b	.AllocLoop

.FreePointer:
	cmpa.l	a7,a5
	bne.b	.FreeMem
	
	moveq	#0,d0
	rts

.FreeMem:
	move.l	(sp)+,d0
	move.l	(sp)+,a1
	jsr	_LVOFreeMem(a6)
	bra.b	.FreePointer

Table:	dc.b	"0123456789abcdef"

