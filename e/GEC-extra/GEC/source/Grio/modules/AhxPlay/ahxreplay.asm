 


;CPU020


	IFD CPU020
extl:	MACRO
	extb.l	\1
	ENDM
	ELSE
extl:	MACRO
	ext.w	\1
	ext.l	\1
	ENDM
	ENDC




	XDEF    ahxPlay_module_song

ahxPlay_module_song:
	move.l  8(a7),a1
	lea	ahxMyModule(pc),a0
	move.l	a1,(a0)
	lea	ahxEnded(pc),a0
	sf	(a0)
	lea	ahxLoop(pc),a0
	st	(a0)
	move.l	4(a7),d1
	move.l	d1,d0
	subq.l	#1,d0
	cmp.b	ahx_SubSongNum(a1),d0
	ble.w	SetTimerInt
	moveq	#1,d1
	bra.w   SetTimerInt


	XDEF    ahxStop

ahxStop:
	bsr	ahxReplayer+ahxStopSong
	lea	ahxEnded(pc),a0
	st	(a0)
	bra	KillTimerInt
	


	XDEF    ahxGetSongLen
ahxGetSongLen:
	move.l	ahxMyModule(pc),d0
	beq.s	.quit
	move.l	d0,a0
	moveq	#0,d0
	move.b	7(a0),d0
.quit:
	rts



	XDEF    ahxGetSongPos

ahxGetSongPos:
	bsr	getAHX
	moveq	#0,d0
	move.w	$44c(a0),d0
	rts



	XDEF    ahxSetSongPos_value

ahxSetSongPos_value:
	bsr	getAHX
	move.l	ahxModule(a0),a1
	moveq	#0,d1
	move.b	ahx_SongLen(a1),d1
	move.l	4(a7),d0
	cmp.l	d1,d0
	bhi.s	.quit
	move.w	d0,$44c(a0)	
.quit:		
	rts




	XDEF    ahxPause

ahxPause:
	bsr	getAHX
	move.b	ahx_pPlaying(a0),d0
	seq	d1
	move.b	d1,ahx_pPlaying(a0)
	extl	d0
	lea	$dff000,a0
	clr.w	$a8(a0)
	clr.w	$b8(a0)
	clr.w	$c8(a0)
	clr.w	$d8(a0)
	rts

	


	XDEF    ahxIsEnabled

ahxIsEnabled:
	bsr	getAHX
	move.b	ahx_pPlaying(a0),d0
	extl	d0
	rts



	XDEF    ahxSetVolume_value

ahxSetVolume_value:
	bsr	getAHX
	move.l	4(a7),d0
	moveq	#64,d1
	cmp.l	d1,d0
	bcs.s	.ok
	move.l	d1,d0
.ok:	move.b	d0,ahx_pMainVolume(a0)

	rts



	XDEF    ahxGetVolume_channel
	
ahxGetVolume_channel:
	bsr	getAHX
	moveq	#0,d0
	move.l	4(a7),d0
	bne.s	.chan
	move.b	ahx_pMainVolume(a0),d0
	rts
.chan:
	moveq	#4,d1
	cmp.l	d1,d0
	bls.s	.ok
	moveq	#0,d0
	rts
.ok:
	move.l	d0,d1
	subq.l	#1,d1
	mulu.w	#232,d1		;	current chantemp size
	move.w	ahx_pVoice0Temp+ahx_pvtAudioVolume(a0,d1.w),d0
	rts




	XDEF    ahxSetPattPos_value

ahxSetPattPos_value:
	bsr	getAHX
	move.l	ahxModule(a0),a1
	moveq	#0,d1
	move.b	ahx_TrackLen(a1),d1
	move.l	4(a7),d0
	cmp.l	d1,d0
	bhi.s	.quit
	move.w	d0,$44a(a0)
.quit:		
	rts




	XDEF    ahxGetPattPos

ahxGetPattPos:
	bsr	getAHX
	moveq	#0,d0
	move.w	$44a(a0),d0
	rts




	XDEF    ahxGetSampleInfo_module_buf4name_samplenum
	
ahxGetSampleInfo_module_buf4name_samplenum:
	moveq   #-1,d0
	movea.l	8(a7),a1
	move.l  4(a7),d2
	beq.s   .quit
	movea.l 12(a7),a0  ; module
	moveq   #0,d1
	move.b	12(a0),d1  ; number of samples
	cmp.l   d1,d2
	bhi.s   .quit
	move.w	4(a0),d1   ; offset of modtitle
	adda.l	d1,a0
.loop:
	tst.b	(a0)+
	bne.s	.loop
	subq.l	#1,d2
	bne.s	.loop
	moveq	#33,d1
.copy:
	move.b	(a0)+,(a1)+
	dbeq	d1,.copy
	moveq	#0,d0
.quit:
	clr.b   (a1)
	rts
	



	XDEF    ahxGetNote_channel

ahxGetNote_channel:
	bsr	getAHX
	move.l	4(a7),d0
	subq.l	#1,d0
	moveq	#3,d1
	cmp.l	d1,d0
	bhi.s	.quit
	mulu.w	#232,d0			; sizeof pVoiceTemp
	moveq	#0,d1
	move.b	ahx_pVoice0Temp(a0,d0.w),d1
	move.l	$456(a0),a1
	move.w	$3ae(a0),d0
	mulu.w	d0,d1
	add.w	$44a(a0),d1		; $44a patt
	mulu.w	#3,d1
	moveq	#0,d0
	move.w	0(a1,d1.w),d0
.quit:
	rts




	XDEF    ahxGetCmd_channel

ahxGetCmd_channel:
	moveq	#0,d0
	rts




	XDEF	ahxLoopPlay_val

ahxLoopPlay_val:
	lea	ahxLoop(pc),a0
	tst.l	4(a7)
	sne	(a0)
	rts
	




	XDEF	ahxIsLooped

ahxIsLooped:
	move.b	ahxLoop(pc),d0
	extl	d0
	rts




	XDEF	ahxIsEnded

ahxIsEnded:
	move.b	ahxEnded(pc),d0
	extl	d0	
	rts




getAHX:
	move.l	ahxReplayer+ahxBSS_P(pc),d0
	bne.s	.ok
	addq.l	#4,a7
	rts
.ok:	move.l	d0,a0
	rts




	
	XDEF	ahxNumberSongs

ahxNumberSongs:
	move.l	ahxMyModule(pc),a0
	moveq	#0,d0
	move.b	ahx_SubSongNum(a0),d0
	addq.l	#1,d0
	rts




	XDEF	ahxSetSong_num

ahxSetSong_num:
	move.l	ahxMyModule(pc),a0
	moveq	#0,d0
	move.w	ahxCurrentSubSong(pc),d0
	move.l	4(a7),d1
	subq.l	#1,d1
	cmp.b	ahx_SubSongNum(a0),d1
	bgt.s	.quit
	move.l	d1,-(a7)
	bsr.w	ahxReplayer+ahxStopSong
	move.l	(a7),d0
	moveq	#0,d1
	bsr.w	ahxReplayer+ahxInitSubSong
	move.l	(a7)+,d0
	addq.l	#1,d0
	lea	ahxCurrentSubSong(pc),a0
	move.w	d0,(a0)
.quit:
	rts
	


	XDEF	ahxCurrentSong
	
ahxCurrentSong:
	moveq	#0,d0
	move.w	ahxCurrentSubSong(pc),d0
	rts




;BangAHX:
;	lea	ahxReplayer(pc),a1
;	bra	ahxBang


	XDEF	ahxNextPatt
	
ahxNextPatt:
	bra.w	ahxReplayer+ahxNextPattern


	XDEF	ahxPrevPatt
	
ahxPrevPatt:
	bra.w	ahxReplayer+ahxPrevPattern


	XDEF	ahxGetTrackLen

ahxGetTrackLen:
	move.l	ahxMyModule(pc),d0
	beq.s	.quit
	movea.l	d0,a0
	moveq	#0,d0
	move.b	ahx_TrackLen(a0),d0
.quit:
	rts




; ---------------------------------------------------------------------
; ---------------------------------------------------------------------
; ---------------------------------------------------------------------




	IncDir	"DH1:proj/AhxPlay/"
	Include	"AHX-Offsets.I"




SetTimerInt:
	movem.l	d1-d7/a2-a6,-(sp)
	lea	ahxCIAInterrupt(pc),a0
	moveq	#0,d0
	bsr	ahxReplayer+ahxInitCIA
	tst	d0
	bne.s	ahxInitFailed
	sub.l	a0,a0	;auto-allocate public (fast)
	sub.l	a1,a1	;auto-allocate chip
	moveq	#0,d0	;load waves from hd if possible
	moveq	#0,d1
	bsr	ahxReplayer+ahxInitPlayer
	tst	d0	;check d0=result normally here...
	bne.s	RemoveCIA	; d0=-1  failed
	move.l	ahxMyModule(pc),a0	;module
	bsr	ahxReplayer+ahxInitModule
	tst	d0	;check d0=result normally here...
	bne.s	KillPlayer
	move.l	(a7),d0	; in d1 was num song
	lea	ahxCurrentSubSong(pc),a0
	move.w	d0,(a0)
	subq.l	#1,d0
;	moveq	#0,d0	;Subsong #0 = Mainsong
	moveq	#0,d1	;Play immediately
	bsr	ahxReplayer+ahxInitSubSong
	moveq	#-1,d0
	bra.s	ahxExit
KillPlayer:
	bsr	ahxReplayer+ahxKillPlayer
RemoveCIA:
	bsr	ahxReplayer+ahxKillCIA
ahxInitFailed:
	moveq	#0,d0
ahxExit:
	movem.l	(sp)+,d1-d7/a2-a6
	rts


KillTimerInt:
	movem.l	d1-d7/a2-a6,-(sp)
	bra.s	KillPlayer


ahxCIAInterrupt:
	bra	ahxReplayer+ahxInterrupt
;	movem.l	d0/a0,-(a7)
;	movea.l	ahxReplayer+ahxBSS_P(pc),a0
;	move.b	ahxEnded(pc),d0
;	beq.s	.2
;	sf	ahx_pPlaying(a0)
;.2:	move.b	ahxLoop(pc),d0
;	bne.s	.1
;	move.w	$44c(a0),d0
;	cmp.w	$450(a0),d0
;	bne.s	.1
;	move.w	$44a(a0),d0
;	addq.w	#1,d0
;	cmp.w	$3ae(a0),d0
;	bne.s	.1
;	lea	ahxEnded(pc),a0
;	st	(a0)
;.1:	bsr	ahxReplayer+ahxInterrupt
;	movem.l	(a7)+,d0/a0
;	rts

ahxMyModule:	dc.l	0
ahxReplayer:
		IFD	CPU020
		IncBIN	AHX-Replayer020.BIN
		ELSE
		IncBIN	AHX-Replayer000.BIN
		ENDC
;ahxBang:	IncBIN	AHX-Bang000.BIN
ahxEnded:	dc.b	0,0
ahxLoop:	dc.b	$ff,0
ahxCurrentSubSong:
		dc.w	0





