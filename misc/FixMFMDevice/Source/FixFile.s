FixFile		Move.l	LoadAddr(a5),a0
		Move.l	LoadBufferSize(a5),d0

		Lsr.l	#2,d0
		Subq.l	#1,d0		; Correct for dbra

.SeekHdr	Cmp.l	#$000003E9,(a0)+
		Beq.b	.GotHunkHeader
		Dbra	d0,.SeekHdr

.WrongFile	Moveq.l	#-1,d0
		Rts

.GotHunkHeader	Addq.l	#4,a0
		Move.l	a0,a1
		Cmp.l	#$70004e75,(a0)+
		Bne.b	.WrongFile
		Cmp.w	#$4afc,(a0)+
		Bne.b	.WrongFile

		Move.l	20(a0),a0
		Add.l	a1,a0
		Move.l	4(a0),a0
		Add.l	a1,a0
		Move.l	(a0),a0
		Add.l	a1,a0

		Cmp.l	#$48e72134,(a0)
		Bne.b	.WrongFile
		Move.b	#$31,2(a0)

		Moveq.l	#200,d0
.Seek2ndMovem	Cmp.w	#$4cdf,(a0)+
		Beq.b	.Maybe2nd
.Nope		Dbra	d0,.Seek2ndMovem
		Bra.b	.WrongFile

.Maybe2nd	Cmp.w	#$2c84,(a0)
		Bne.b	.Nope

		Move.b	#$8c,1(a0)
		Rts
