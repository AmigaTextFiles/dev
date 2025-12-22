;*-----------------------------------------------------------------------*
;* ReadFile 1.1		© Dave Jones 1993				 *
;* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~				 *
;* Returns	:- d0 = File Length (0=ok -2 if no mem, -1 if empty file)*
;*		   a0 = Ptr to file buffer				 *
;*-----------------------------------------------------------------------*

ReadFile	Move.l	_Dosbase(a5),a6
		Lea	PathnameBuffer(PC),a0
		Move.l	a0,d1
		Move.l	#1005,d2
		Call	Open
		Tst.b	d0
		Beq.b	.Error
		Move.l	d0,d7

		Move.l	d7,d1
		Moveq.l	#0,d2
		Moveq.l	#1,d3		; Seek to end of file.
		Call	Seek

		Move.l	d7,d1
		Moveq.l	#0,d2
		Moveq.l	#-1,d3
		Call	Seek		; Seek to start. (Returns old pos)
		Move.l	d0,LoadFileSize(a5)
		Move.l	d0,LoadBufferSize(a5)
		Beq.b	.EmptyFile


		Moveq.l	#1,d1			; Memf_public
		Move.l	4.w,a6
		Call	AllocMem
		Tst.l	d0
		Beq.b	.Nomemory
		Move.l	d0,LoadAddr(a5)

		Move.l	d7,d1
		Move.l	LoadAddr(a5),d2
		Move.l	LoadFileSize(a5),d3
		Move.l	_Dosbase(a5),a6
		Call	Read

		Move.l	d7,d1
		Call	Close			; Close input file.
		Moveq.l	#0,d0
		Rts


.NoMemory	Move.l	d7,d1
		Call	Close
		;Print	NoMemToLoadFileTxt
		Moveq.l	#-2,d0
		Rts

.EmptyFile	Move.l	d7,d1
		Call	Close
		;Print	EmptyFileTxt
.Error		Moveq.l	#-1,d0
		Rts
