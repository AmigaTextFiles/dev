
;This part sets all of the gadgets to correspond with the settings

SetGads:	lea.l	StopB1Gad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	StopB2Gad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	DataB7Gad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	DataB8Gad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	ParityNGad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	ParityEGad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	ParityOGad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	ParityMGad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	ParitySGad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	XONXOFFGad(pc),a0
		move.w	#$06,$c(a0)
		lea.l	DuplexFGad(pc),a0
		move.w	#$06+GADGDISABLED,$c(a0)
		lea.l	DuplexHGad(pc),a0
		move.w	#$06+GADGDISABLED,$c(a0)
		lea.l	DuplexEGad(pc),a0
		move.w	#$06+GADGDISABLED,$c(a0)
		cmp.b	#$01,SerStopBits
		bne	SGStopB2
		lea.l	StopB1Gad(pc),a0
		move.w	#$86,$c(a0)
		jmp	SetGads1
SGStopB2:	lea.l	StopB2Gad(pc),a0
		move.w	#$86,$c(a0)
SetGads1:	cmp.b	#$07,SerDataBits
		bne	SGDataB8
		lea.l	DataB7Gad(pc),a0
		move.w	#$86,$c(a0)
		jmp	SetGads2
SGDataB8:	lea.l	DataB8Gad(pc),a0
		move.w	#$86,$c(a0)
SetGads2:	btst.b	#SERB_PARTY_ON,SerFlags
		beq	SGParityE
		lea.l	ParityNGad(pc),a0
		move.w	#$86,$c(a0)
		jmp	SetGads3
SGParityE:	btst.b	#SERB_PARTY_ODD,SerFlags
		bne	SGParityM
		lea.l	ParityOGad(pc),a0
		move.w	#$86,$c(a0)
		jmp	SetGads3
SGParityM:	btst.b	#SEXTB_MARK,SerExtFlags+3
		bne	SGParityS
		lea.l	ParityMGad(pc),a0
		move.w	#$86,$c(a0)
		jmp	SetGads3
SGParityS:	lea.l	ParitySGad(pc),a0
		move.w	#$86,$c(a0)
SetGads3:	btst.b	#SERB_XDISABLED,SerFlags
		beq	SetGads4
		lea.l	XONXOFFGad(pc),a0
		move.w	#$86,$c(a0)
SetGads4:	cmp.b	#$00,SerDuplex
		bne	SGDuplexH
		lea.l	DuplexFGad(pc),a0
		move.w	#$86+GADGDISABLED,$c(a0)
		jmp	SetGads5
SGDuplexH:	cmp.b	#$01,SerDuplex
		bne	SGDuplexE
		lea.l	DuplexHGad(pc),a0
		move.w	#$86+GADGDISABLED,$c(a0)
		jmp	SetGads5
SGDuplexE:	lea.l	DuplexEGad(pc),a0
		move.w	#$86+GADGDISABLED,$c(a0)
SetGads5:	rts
