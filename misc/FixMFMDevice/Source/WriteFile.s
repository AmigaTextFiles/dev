;* Returns	:- d0 = 0=Success (-1 if failed)

WriteFile	Move.l	_DosBase(a5),a6
		Lea	PathNameBuffer(PC),a0
		Move.l	a0,d1
		Lea	OldMFMName(PC),a0
		Move.l	a0,d2
		Call	Rename			; rename the old bugged device

		Move.l	LoadAddr(a5),d2
		Move.l	LoadBufferSize(a5),d3

		PushM	d2/d3
		Move.l	#1006,d2		; Mode R/w
		Lea	PathnameBuffer(PC),a0
		Move.l	a0,d1
		Call	Open
		move.l	d0,d7
		beq.b	.FileError

		PopM	d2/d3
		Move.l	d7,d1
		Call	Write

		move.l	d7,d1			; d1=files handle
		Call	Close			; close output file.
		Moveq.l	#0,d0
		Rts

.FileError	Addq.l	#8,sp
		Moveq.l	#-1,d0

.UserCancelled	Rts
