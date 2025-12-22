*-----------------------------------------------*
*	@Defrag					*
*-----------------------------------------------*

Defrag:	move.l	packet0(a4),a0
	move.l	data0(a4),CurrData(a4)
	move.l	a0,CurrPkt(a4)

	move.l	MsgPort(a4),MN_REPLYPORT-sp_Pkt(a0)
	move.l	#ACTION_SFS_DEFRAGMENT_STEP,dp_Type(a0)
	move.l	MsgPort(a4),dp_Port(a0)
	lea	dp_Arg1(a0),a2
	move.l	data0(a4),(a2)+		; arg1
	move.l	#step_bufsize,(a2)+	; arg2
	clr.l	(a2)+			; arg3
	clr.l	(a2)+			; arg4
	clr.l	(a2)+			; arg5
	clr.l	(a2)+			; arg6
	clr.l	(a2)			; arg7

	move.l	packet0(a4),d0		; packet0 -> d0, packet1 -> packet0, d0 -> packet1
	move.l	data0(a4),d1		; data0 -> d1, data1 -> data0, d1 -> data1
	move.l	packet1(a4),packet0(a4)
	move.l	data1(a4),data0(a4)
	move.l	d0,packet1(a4)
	move.l	d1,data1(a4)

	move.l	dos(a4),a6
	move.l	CurrPkt(a4),d1
	move.l	SFSport(a4),d2
	move.l	MsgPort(a4),d3
	jmp	_LVOSendPkt(a6)

*-----------------------------------------------*
*	@LueViesti				*
*-----------------------------------------------*

LueViesti:
	move.l	MsgPort(a4),a0
	jsr	_LVOGetMsg(a6)
	tst.l	d0
	beq.b	.x
	move.l	CurrData(a4),a3
	move.l	CurrPkt(a4),a0
	move.l	a3,RenderData(a4)
	clr.l	CurrPkt(a4)
	tst.l	dp_Res1(a0)
	beq	DefragmentError
	move.l	(a3),d1
	beq	.check_pause
	cmp.l	#'MOVE',d1
	beq.b	.move
	cmp.l	#'DONE',d1
	beq	DefragmentDone
.x	rts

.move	move.l	a3,a2

.loop	move.l	(a2),d0
	beq.b	.jatka
	cmp.l	#'DONE',d0
	beq	DefragmentDone
	move.l	4(a2),d0
	beq.b	.jatka
	lea	8(a2,d0.w*4),a2
;	lea	20(a2),a2
	bra.b	.loop

.jatka	tst.b	bfStopDefrag(a4)
	bne.b	.check_quit
	bsr	Defrag
	TEE_METODI	MP_Kartta-t(a5),RenderMetodit
	rts

.check_pause:
	tst.b	bfStopDefrag(a4)	; pause?
	beq	Defrag			; ei, jatka
.check_quit:
	bsr	DefragmentEnd
	tst.b	bfQuitDefrag(a4)	; quit?
	bne	FreeBitMap		; yep
	rts

DefragmentDone:
	bsr	DefragmentEnd
	bsr	UpdateVolumeDate
	bsr	RemBuffers
	bsr	EnableStartDefrag
	GETSTR	MSG_DEFRAGMENT_DONE
	move.l	d0,a2
	bra	InfoRequester

DefragmentError:
	move.l	dp_Res2(a0),PacketError(a4)
	move.l	#'DONE',(a3)
	bsr	DefragmentEnd
	bsr	EnableStartDefrag
	move.l	PacketError(a4),(a4)
	move.l	VolumeName(a4),4(a4)
	GETSTR	MSG_DEFRAGMENT_ERROR
	move.l	d0,a2
	bra	InfoRequester

*-----------------------------------------------*
*	@DefragmentEnd				*
*-----------------------------------------------*

DefragmentEnd:
	TEE_METODI	MP_Kartta-t(a5),RenderMetodit
	bsr	UpdateTimer
	move.l	exec(a4),a6
	clr.b	bfTimerActive(a4)
	move.l	timer_io(a4),a1
	jsr	_LVOAbortIO(a6)
	move.l	timer_io(a4),a1
	jsr	_LVOWaitIO(a6)
	bra	UnLockDevice

*-----------------------------------------------*
*       @InitDefrag				*
*-----------------------------------------------*

InitDefrag:
	clr.l	lastread(a4)
	clr.l	lastwritten(a4)
	clr.l	lastblocks(a4)

	move.l	ActiveEntry(a4),a3
	move.l	exec(a4),a6
	move.l	a3,DefragEntry(a4)
	move.l	ll_TotalBlocks(a3),d0
	move.l	ll_MsgPort(a3),SFSport(a4)
	move.l	d0,MUI_TotalBlocks(a4)
	lsr.l	#3,d0
	add.l	#32,d0
	move.l	d0,(a4)
	move.l	#MEMF_ANY!MEMF_CLEAR,d1
	jsr	_LVOAllocVec(a6)
	move.l	d0,DefragBitMap(a4)
	beq	NotEnoughMemory

	bsr	ReadBitMap
	beq.b	.x

	st	bfBitMapExists(a4)

	move.l	#31,d0
	add.l	d5,d0
	lsr.l	#5,d0
	move.l	d0,btotal(a4)

.x	rts

*-----------------------------------------------*
*	@ReadBitMap				*
*-----------------------------------------------*

ReadBitMap:
	move.l	#ACTION_SFS_READ_BITMAP,d2
	move.l	DefragBitMap(a4),d3
	moveq	#0,d4
	move.l	MUI_TotalBlocks(a4),d5
	bsr	L‰het‰Paketti
	beq.b	.no_bitmap
	rts
.no_bitmap:
	bsr	FreeBitMap
	GETSTR	MSG_CANT_READ_BITMAP
	move.l	d0,a2
	bra	InfoRequester

*-----------------------------------------------*
*	@FreeBitMap				*
*-----------------------------------------------*

FreeBitMap:
	clr.b	bfBitMapExists(a4)

	move.l	exec(a4),a6
	move.l	DefragBitMap(a4),a1
	clr.l	DefragBitMap(a4)
	jmp	_LVOFreeVec(a6)

*-----------------------------------------------*
*	@AbortPacket				*
*-----------------------------------------------*

AbortPacket:
	move.l	CurrPkt(a4),d2
	beq	RemBuffers
	move.l	dos(a4),a6
	move.l	SFSport_Abort(a4),d1
	clr.l	CurrPkt(a4)
	jsr	_LVOAbortPkt(a6)
	bsr	RemBuffers
	bsr	UnLockDevice
	move.l	exec(a4),a6
	move.l	MsgPort(a4),a0
	jsr	_LVOWaitPort(a6)
	move.l	MsgPort(a4),a0
	jsr	_LVOGetMsg(a6)
	tst.b	bfTimerActive(a4)
	beq.b	.x
	clr.b	bfTimerActive(a4)
	move.l	timer_io(a4),a1
	jsr	_LVOAbortIO(a6)
	move.l	timer_io(a4),a1
	jmp	_LVOWaitIO(a6)
.x	rts
