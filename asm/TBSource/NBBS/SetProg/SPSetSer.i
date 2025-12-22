
SetSer:		lea.l	StopB1Gad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SSStopB2
		move.b	#$01,SerStopBits
		jmp	SetSer2
SSStopB2:	move.b	#$02,SerStopBits
SetSer2:	lea.l	DataB7Gad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SSDataB8
		move.b	#$07,SerDataBits
		jmp	SetSer3
SSDataB8:	move.b	#$08,SerDataBits
SetSer3:	bclr.b	#SERB_PARTY_ON,SerFlags
		bclr.b	#SERB_PARTY_ODD,SerFlags
		bclr.b	#SEXTB_MSPON,SerExtFlags+3
		bclr.b	#SEXTB_MARK,SerExtFlags+3
		lea.l	ParityNGad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		beq	SetSer4
SSParityE:	lea.l	ParityEGad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SSParityO
		bset.b	#SERB_PARTY_ON,SerFlags
		jmp	SetSer4
SSParityO:	lea.l	ParityOGad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SSParityM
		bset.b	#SERB_PARTY_ON,SerFlags
		bset.b	#SERB_PARTY_ODD,SerFlags
		jmp	SetSer4
SSParityM:	lea.l	ParityMGad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SSParityS
		bset.b	#SERB_PARTY_ON,SerFlags
		bset.b	#SEXTB_MSPON,SerExtFlags+3
		jmp	SetSer4
SSParityS:	bset.b	#SERB_PARTY_ON,SerFlags
		bset.b	#SEXTB_MSPON,SerExtFlags+3
		bset.b	#SEXTB_MARK,SerFlags+3
		jmp	SetSer4
SetSer4:	bset.b	#SERB_XDISABLED,SerFlags	
		lea.l	XONXOFFGad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SetSer5
		bclr.b	#SERB_XDISABLED,SerFlags
SetSer5:	lea.l	DuplexFGad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SSDuplexH
		move.b	#$00,SerDuplex
		jmp	SetSer6
SSDuplexH:	lea.l	DuplexHGad(pc),a0
		move.w	$c(a0),a0
		cmp.w	#$86,a0
		bne	SSDuplexE
		move.b	#$01,SerDuplex
		jmp	SetSer6
SSDuplexE:	move.b	#$02,SerDuplex
SetSer6:	move.l	SerUnitLInt(pc),SerUnit
		move.l	UserFontSizeLInt(pc),UserFontSize
		move.l	SerBRKTLInt(pc),SerBRKT
		rts
