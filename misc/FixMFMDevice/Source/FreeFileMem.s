FreeFilememory	Tst.l	LoadAddr(a5)
		Beq.b	.NoFileInBuffer

		Move.l	LoadAddr(a5),a1
		Move.l	LoadBufferSize(a5),d0
		Move.l	_Execbase(a5),a6
		Clr.l	LoadAddr(a5)

		Jump	FreeMem
.NoFileInBuffer	Rts
