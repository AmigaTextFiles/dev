
DecrunchFile	Move.l	_XfdBase(a5),a6
		Call	XFDAllocBufferInfo
		Move.l	d0,MyXFDBufferInfo(a5)
		Beq.b	.NoBufferInfo

		Move.l	d0,a0

		Moveq	#1<<XFDFB_RECOGEXTERN,d0
		Move.w	d0,xfdbi_Flags(a0)

		Move.l	LoadAddr(a5),Xfdbi_SourceBuffer(a0)
		Move.l	LoadFileSize(a5),Xfdbi_SourceBufLen(a0)
		Call	XFDRecogBuffer
		Tst.l	d0
		Beq.b	.NotRecognised

.MultiPacked
		Move.l	MyXFDBufferInfo(a5),a2
		Move.w	xfdbi_PackerFlags(a2),d7

;.FileIsData
		Clr.l	Xfdbi_TargetBufMemType(a2)
		Move.l	_XfdBase(a5),a6
		Move.l	a2,a0
		Call	XFDDecrunchBuffer
		Tst.l	d0
		Beq.b	.DecrunchError

		Bsr	FreeFileMemory
		Move.l	Xfdbi_TargetBuffer(a2),LoadAddr(a5)
		Move.l	Xfdbi_TargetBufLen(a2),LoadBufferSize(a5)
		Move.l	Xfdbi_TargetBufSaveLen(a2),LoadFileSize(a5)

;--- Test if a crunched file has been crunched again.
;--- I.e., a Powerpacked file packed with TitanCrunch

		Move.l	LoadAddr(a5),Xfdbi_SourceBuffer(a2)
		Move.l	LoadFileSize(a5),Xfdbi_SourceBufLen(a2)
		Move.l	a2,a0
		Move.l	_XfdBase(a5),a6
		Call	XFDRecogBuffer
		Tst.l	d0
		Bne.b	.MultiPacked

.CantDecrypt
.DontDepack	Move.l	_XfdBase(a5),a6

.NotRecognised	Move.l	MyXFDBufferInfo(a5),a1
		Jump	XFDFreeBufferInfo

.NoBufferInfo	Rts


.DecrunchError	Ext.l	d0
		Call	XfdGetErrorText
		Move.l	d0,PrintFVarStack(a5)
		;Printf	DecrunchErrorTxt
		Bra.b	.DontDepack
