 



;TIMERDEVICE	SET	1







	XDEF    ptPlay_module

ptPlay_module
	movea.l 4(a7),a0
	bsr.w   MT_Init
	bsr.w   SetTimerInt
	tst.l   d0
	beq.s   .error
	lea     Variables(pc),a0
	st      MT_Enable(a0)
	sf	MT_Ended(a0)
.error
	rts




	XDEF    ptStop

ptStop
	bsr.w   ResetTimerInt
	bsr.w   MT_End
	lea	Variables+MT_Ended(pc),a0
	st	(a0)
	rts
	


	XDEF    ptGetSongLen

ptGetSongLen
	movea.l Variables+MT_SongDataPtr(pc),a0
	moveq   #0,d0
	move.b  950(a0),d0
	rts



	XDEF    ptGetSongPos

ptGetSongPos
	moveq   #0,d0
	move.b  Variables+MT_SongPos(pc),d0
	rts



	XDEF    ptSetSongPos_value

ptSetSongPos_value
	move.l  Variables+MT_SongDataPtr(pc),a0
	moveq   #0,d0
	move.b  950(a0),d0
	subq.b  #1,d0
	move.l  4(a7),d1
	cmp.l   d1,d0
	bhs.s   .okval
	moveq   #-1,d0
	rts
.okval
	lea     Variables+MT_SongPos(pc),a0
	move.b  (a0),d0
	move.b  d1,(a0)
	rts




	XDEF    ptPause

ptPause
	moveq	#0,d0
	lea	Variables+MT_Enable(pc),a0
	tst.b	(a0)
	bne.s	setpause
	moveq	#-1,d0
setpause
	move.b	d0,(a0)
	lea     $dff000,a0
	clr.w   $a8(a0)
	clr.w   $b8(a0)
	clr.w   $c8(a0)
	clr.w   $d8(a0)
	move.w  #$f,$096(a0)
	rts

	


	XDEF    ptIsEnabled

ptIsEnabled
	moveq   #0,d0
	move.b  Variables+MT_Enable(pc),d0
	beq.s   .no
	moveq   #-1,d0
.no
	rts



	XDEF    ptSetVolume_value

ptSetVolume_value
	move.l  4(a7),d0
	cmp.l   #64,d0
	bls.s   ok_vol
	moveq   #64,d0
ok_vol
	lea     Variables+MT_Volume(pc),a0
	move.w  d0,(a0)
	lea     $dff0a8,a1
	lea     MT_Chan1Temp(pc),a0
	bsr.s   calcvol
	lea     MT_Chan2Temp(pc),a0
	lea     $10(a1),a1
	bsr.s   calcvol
	lea     MT_Chan3Temp(pc),a0
	lea     $10(a1),a1
	bsr.s   calcvol
	lea     MT_Chan4Temp(pc),a0
	lea     $10(a1),a1

calcvol
	moveq   #0,d1
	move.b  N_Volume(a0),d1
	mulu.w  d0,d1
	lsr.w   #6,d1
	move.w  d1,(a1)
	rts



	XDEF    ptGetVolume_channel
	
ptGetVolume_channel
	moveq   #0,d0
	move.l  4(a7),d1
	bne.s   .skip
	move.w  Variables+MT_Volume(pc),d0
	rts
.skip:
	moveq   #4,d0
	cmp.l   d0,d1
	bls.s   .okidoki
	moveq   #-1,d0
	rts
.okidoki:
	subq.l  #1,d1
	mulu.w  #N_SIZEOF,d1
	lea     MT_Chan1Temp(pc),a0
	move.b  N_Volume(a0,d1.w),d0
	rts




	XDEF    ptSetPattPos_value

ptSetPattPos_value
	move.l  4(a7),d0
	moveq   #64,d1
	cmp.l   d1,d0
	bls.s   .ok
	move.l  d1,d0
.ok
	lsl.l   #4,d0
	lea     Variables+MT_PatternPos(pc),a0
	move.w  d0,(a0)
	rts



	XDEF    ptGetPattPos

ptGetPattPos
	moveq   #0,d0
	move.w  Variables+MT_PatternPos(pc),d0
	lsr.l   #4,d0
	rts




	XDEF    ptGetSampleInfo_module_buf4name_samplenum
	
ptGetSampleInfo_module_buf4name_samplenum
	moveq   #-1,d0
	move.l  4(a7),d2
	beq.s   .quit
	moveq   #31,d1
	cmp.l   d1,d2
	bhi.s   .quit
	movea.l 12(a7),a0  ; module
	subq.l  #1,d2
	beq.s   .copy
	mulu.w  #30,d2
.copy
	lea     20(a0,d2.w),a0
	moveq   #0,d0
	move.w  22(a0),d0
	add.l   d0,d0
	moveq   #21,d1
	movea.l 8(a7),a1
.loop
	move.b  (a0)+,d2
	beq.s   .ok
	cmp.b   #32,d2
	bhs.s   .ok
	moveq   #32,d2
.ok
	move.b  d2,(a1)+
	dbeq    d1,.loop
	clr.b   (a1)
.quit:
	rts
	



	XDEF    ptGetNote_channel

ptGetNote_channel:
	move.l  4(a7),d0
	beq.s   .quit
	moveq   #4,d1
	cmp.l   d1,d0
	bhi.s   .quit
	subq.w  #1,d0
	mulu	#N_SIZEOF,d0
	lea     MT_Chan1Temp(pc),a0
	move.w  N_Note(a0,d0.w),d0
	rts
.quit:
	moveq   #0,d0
	rts




	XDEF    ptGetCmd_channel

ptGetCmd_channel:
	move.l  4(a7),d0
	beq.s   .quit
	moveq   #4,d1
	cmp.l   d1,d0
	bhi.s   .quit
	subq.w  #1,d0
	mulu	#N_SIZEOF,d0
	lea     MT_Chan1Temp(pc),a0
	move.w  N_Cmd(a0,d0.w),d0
	rts
.quit:
	moveq   #0,d0
	rts

	


	XDEF	ptLoopPlay_val
	
ptLoopPlay_val:
	move.l	4(a7),d1
	beq.s	.Set
	moveq	#-1,d1
.Set
	bsr.s	ptIsLooped
	lea	Variables+MT_Loop(pc),a0
	move.b	d1,(a0)
	rts
	




	XDEF	ptIsLooped

ptIsLooped:
	move.b	Variables+MT_Loop(pc),d0
	ext.w	d0
	ext.l	d0
	rts




	XDEF	ptIsEnded

ptIsEnded:
	move.b	Variables+MT_Ended(pc),d0
	ext.w	d0
	ext.l	d0
	rts






; ---------------------------------------------------------------------
; ---------------------------------------------------------------------
; ---------------------------------------------------------------------


	IFD	TIMERDEVICE



OpenDevice	=	-444
CloseDevice	=	-450
GetMsg		=	-372
CheckIO		=	-468
AbortIO		=	-480
WaitIO		=	-474
BeginIO		=	-30





SetTimerInt
	movem.l	a3/a6,-(a7)
	lea	DevOpen(pc),a3
	clr.l	(a3)
	lea	Port(pc),a0
	lea	20(a0),a0
	move.l	a0,8(a0)
	addq.w	#4,a0
	clr.l	(a0)
	move.l	a0,-(a0)
	move.l	4.w,a6
	lea	TimerName(pc),a0
	moveq	#0,d0
	lea	IOTimer(pc),a1
	moveq	#0,d1
	jsr	OpenDevice(a6)
	tst.l	d0
	seq	d0
	ext.w	d0
	ext.l	d0
	move.l	d0,(a3)
	beq.s	.quit
	move.l	#2500000/125,d1
	lea	Variables+MT_Interval(pc),a0
	move.l	d1,(a0)
	bsr.w	SendTime
	move.l	(a3),d0
.quit
	movem.l	(a7)+,a3/a6
	rts

DevOpen
	dc.l	0
TimerName
	dc.b	'timer.device',0
	even


ResetTimerInt
	lea	DevOpen(pc),a0
	tst.l	(a0)
	beq.s	.quit
	clr.l	(a0)
	movem.l	a2/a6,-(a7)
	lea	Variables+MT_Interval(pc),a0
	clr.l	(a0)
	lea	IOTimer(pc),a2
	move.l	4.w,a6
	movea.l	a2,a1
	jsr	CheckIO(a6)
	tst.l	d0
	bne.s	.close
	move.l	a2,a1
	jsr	AbortIO(a6)
	move.l	a2,a1
	jsr	WaitIO(a6)
.close
	movea.l	a2,a1
	jsr	CloseDevice(a6)
	movem.l	(a7)+,a2/a6
.quit
	rts
	
	

;---- Tempo ----

SetTempo
	movem.l	d1/d2/a0/a1/a6,-(a7)
	move.l	#1250000,d1
	divu.w	d0,d1
	moveq	#0,d2
	swap	d1
	move.w	d1,d2
	clr.w	d1
	add.l	d2,d2
	swap	d1
	add.l	d1,d1
	sub.l	d0,d2
	bmi.s	.skip
	addq.l	#1,d1
.skip
	move.l	d1,MT_Interval(a5)
	bsr.s	SendTime
	movem.l	(a7)+,d1/d2/a0/a1/a6
	rts


SendTime
	lea	IOTimer(pc),a1
	move.w	#9,28(a1)	; command
	clr.l	32(a1)		; secs
	move.l	d1,36(a1)	; micro
	movea.l	20(a1),a6	; device
	jmp	BeginIO(a6)

	

IOTimer
	dc.l	0,0
	dc.b	7,10	; type,pri
	dc.l	0,Port	; name,replyport	
	dc.w	40	; len
	dc.l	0,0	; device,unit
	dc.w	9	; command
	dc.b	0,0	; flags,error
	dc.l	0,0	; secs,micro

Port
	dc.l	0,0
	dc.b	4,10	; type,pri
	dc.l	0
	dc.b	1,12	; flags,sigbit
	dc.l	MusicIntServer
	ds.b	14	; msglist



MusicIntServer
	dc.l 0,0
	dc.b 0,32 ; type, priority
	dc.l 0
	dc.l 0,IntCode



IntCode
	move.l	a6,-(a7)
	lea	Port(pc),a0
	move.l	4.w,a6
	jsr	GetMsg(a6)
	tst.l	d0
	beq.s	.quit
        move.l	Variables+MT_Interval(pc),d1
	beq.s	.quit
	bsr.w	SendTime
	bsr.w	MT_Music
.quit
	move.l	(a7)+,a6
	rts



	ELSE
	


; -------------------------------------------------------------
; -------------------------------------------------------------
; -------------------------------------------------------------





OpenResource            =       -498
AddICRVector            =       -6
RemICRVector            =       -12


ciatalo         =       $400
ciatahi         =       $500
ciatblo         =       $600
ciatbhi         =       $700
ciacra          =       $e00
ciacrb          =       $f00



SetTimerInt
SetCIAInt
	movem.l d6/d7/a5/a6,-(a7)
	moveq   #0,d7
	moveq   #2,d6
	moveq   #'b',d1
	lea     $bfd000,a5
SetCIALoop
	lea     CIAAname(pc),a1
	move.b  d1,3(a1)
	move.l  4.w,a6
	jsr     OpenResource(a6)
	lea     CIAAbase(pc),a0
	move.l  d0,(a0)
	beq.b   CIAError
	
	lea     CIAAaddr(pc),a0
	move.l  a5,(a0)
	movea.l CIAAbase(pc),a6
	
TryTimerB
	lea     MusicIntServer(pc),a1
	moveq   #1,d0           ; Bit 1: Timer B
	lea     TimerFlag(pc),a0
	move.l  d0,(a0)
	jsr     AddICRVector(a6)
	tst.l   d0
	bne.s   TryTimerA
	moveq   #ciacrb>>8,d7
	bra.s   EnableCIA
CIA_Return
	move.l  d7,d0
	movem.l (a7)+,d6/d7/a5/a6
	rts

TryTimerA
	lea     MusicIntServer(pc),a1
	moveq   #0,d0           ; Bit 0: Timer A
	lea     TimerFlag(pc),a0
	move.l  d0,(a0)
	jsr     AddICRVector(a6)
	tst.l   d0
	bne.s   CIAError
	moveq   #ciacra>>8,d7
EnableCIA
	moveq   #125,d0
	bsr.s   SetTempo
	lsl.w   #8,d7
	move.b  #%10001,0(a5,d7.w)
	moveq   #-1,d7
	bra.b   CIA_Return

CIAError
	subq.w  #1,d6
	beq.b   CIA_Return
	moveq   #'a',d1
	lea     $bfe001,a5
	bra.b   SetCIALoop

ResetTimerInt
ResetCIAInt
	movem.l a5/a6,-(a7)
	move.l  CIAAbase(pc),d0
	beq.b   QuitReset
	movea.l d0,a6
	movea.l CIAAaddr(pc),a5
	lea     ciacra(a5),a0
	move.l  TimerFlag(pc),d0
	beq.s   ResTimerA
	lea     ciacrb(a5),a0
ResTimerA
	bclr    #0,(a0)
	lea     MusicIntServer(pc),a1
	jsr     RemICRVector(a6)
QuitReset
	movem.l (a7)+,a5/a6
	rts

;---- Tempo ----

SetTempo
	movem.l d0/d4/a4,-(a7)
	move.l  #1789773,d4     ; NTSC
	movea.l 4.w,a4
	cmpi.b  #60,350(a4)     ; VBlank Frequency
	beq.s   WasNTSC
	move.l  #1773447,d4     ; PAL
WasNTSC
	lea	Tempo(pc),a4
	move.l	d0,(a4)
	divu.w  d0,d4
	movea.l CIAAaddr(pc),a4
	move.l  TimerFlag(pc),d0
	beq.s   SetTimeA
	move.b  d4,ciatblo(a4)
	lsr.w   #8,d4
	move.b  d4,ciatbhi(a4)
	bra.b   QuitTempo
SetTimeA
	move.b  d4,ciatalo(a4)
	lsr.w   #8,d4
	move.b  d4,ciatahi(a4)
QuitTempo
	movem.l (a7)+,d0/d4/a4
	rts

CIAAaddr        dc.l 0
CIAAname        dc.b "ciaa.resource",0
CIAAbase        dc.l 0
TimerFlag       dc.l 0
Tempo		dc.l 0

MusicIntServer
	dc.l 0,0
	dc.b 2,20 ; type, priority
	dc.l MusIntName
	dc.l 0,CIAIntServ

MusIntName:
	dc.b "PtReplay Interrupt",0
	even


CIAIntServ
	movem.l	d0-d7/a0-a6,-(a7)
	move.l	Tempo(pc),d0
	bsr.w	SetTempo
	bsr.w	MT_Music
	movem.l	(a7)+,d0-d7/a0-a6
	rts

	ENDC
	
	
	



* ProTracker2.2a replay routine by Crayon/Noxious. Improved and modified
* by Teeme of Fist! Unlimited in 1992. Share and enjoy! :)
* Rewritten for Devpac (slightly..) by CJ. Devpac does not like bsr.L
* cmpi is compare immediate, it requires immediate data! And some
* labels had upper/lower case wrong...
*
* Now improved to make it work better if CIA timed - thanks Marco!

* Call Mt_data with A0 pointing to your module data...

* Update to 2.5 (26.07.98) by Grio :
* - timer int added
* - master volume
* - sample with zero address not played
* - and couple changes and bugfixes


N_Note = 0  ; W
N_Cmd = 2  ; W
N_Cmdlo = 3  ; B
N_Start = 4  ; L
N_Length = 8  ; W
N_LoopStart = 10 ; L
N_Replen = 14 ; W
N_Period = 16 ; W
N_FineTune = 18 ; B
N_Volume = 19 ; B
N_DMABit = 20 ; W
N_TonePortDirec = 22 ; B
N_TonePortSpeed = 23 ; B
N_WantedPeriod = 24 ; W
N_VibratoCmd = 26 ; B
N_VibratoPos = 27 ; B
N_TremoloCmd = 28 ; B
N_TremoloPos = 29 ; B
N_WaveControl = 30 ; B
N_GlissFunk = 31 ; B
N_SampleOffset = 32 ; B
N_PattPos = 33 ; B
N_LoopCount = 34 ; B
N_FunkOffset = 35 ; B
N_WaveStart = 36 ; L
N_RealLength = 40 ; W
N_SIZEOF = 44


MT_SongDataPtr = 0
MT_Speed = 4
MT_Counter = 5
MT_SongPos = 6
MT_PBreakPos = 7
MT_PosJumpFlag = 8
MT_PBreakFlag = 9
MT_LowMask = 10
MT_PattDelTime = 11
MT_PattDelTime2 = 12
MT_PatternPos = 14
MT_DMACONTemp = 16
MT_Volume = 18
MT_Enable = 20
MT_Interval = 22
MT_Loop	= 26
MT_Ended = 27








MT_Init:
	movem.l d2/a2/a3/a5,-(a7)
	lea     Variables(pc),a5
	move.l  a0,MT_SongDataPtr(a5)
	lea     952(a0),a1
	moveq   #127,d0
	moveq   #0,d1
MTLoop:
	move.l  d1,d2
	subq.w  #1,d0
MTLoop2:
	move.b  (a1)+,d1
	cmp.b   d2,d1
	bgt.s   MTLoop
	dbf     d0,MTLoop2
	addq.w  #1,d2

	lea     MT_SampleStarts(pc),a1
	asl.l   #8,d2
	asl.l   #2,d2
	addi.l  #1084,d2
	add.l   a0,d2
	move.l  d2,a2
	moveq   #30,d0
	lea     MT_ZeroTab(pc),a3
	move.l	a3,(a3)
MTLoop3:
	move.l  a2,(a1)+
	moveq   #0,d1
	move.w  42(a0),d1   ; sample length
	beq.s   MT_NoSample
;	cmpi.w  #50,d1
;	bls.b   MT_ToSmall
;	clr.l   (a2)
	move.l  a2,(a3)
MT_ToSmall:
	add.l   d1,d1
	adda.l  d1,a2
MT_NoSample:
	lea     30(a0),a0
	dbf     d0,MTLoop3

	lea     MT_Chan1Temp(pc),a0
	moveq   #N_SIZEOF-1,d0
MT_ClearChanTemp:
	clr.l   (a0)+
	dbf     d0,MT_ClearChanTemp
	lea     MT_Chan1Temp(pc),a0
	moveq   #1,d0
	moveq   #3,d1
	moveq   #1,d2
MT_SetDMABit:
	move.l  (a3),N_Start(a0)
	move.l  (a3),N_LoopStart(a0)
	move.l	(a3),N_WaveStart(a0)
	move.w  d2,N_Length(a0)
	move.w  d2,N_Replen(a0) 
	move.w  d0,N_DMABit(a0)
	lea     N_SIZEOF(a0),a0
	lsl.l   #1,d0
	dbf     d1,MT_SetDMABit

	ori.b   #2,$bfe001
	move.b  #6,MT_Speed(a5)
	sf      MT_Counter(a5)
	sf      MT_SongPos(a5)
	clr.w   MT_PatternPos(a5)
	sf      MT_PBreakPos(a5)
	sf      MT_PosJumpFlag(a5)
	sf      MT_PBreakFlag(a5)
	sf      MT_LowMask(a5)
	sf      MT_PattDelTime(a5)
	clr.w   MT_PattDelTime2(a5)
	clr.w   MT_DMACONTemp(a5)
	movem.l (a7)+,d2/a2/a3/a5
	
MT_End: 
	move.l  a4,-(a7)
	lea     Variables(pc),a4
	sf      MT_Enable(a4)
	lea     MT_Chan1Temp+N_Volume(pc),a4
	sf      (a4)
	sf      N_SIZEOF(a4)
	sf      N_SIZEOF*2(a4)
	sf      N_SIZEOF*3(a4)
	lea     $dff000,a4
	clr.w   $a8(a4)
	clr.w   $b8(a4)
	clr.w   $c8(a4)
	clr.w   $d8(a4)
	move.w  #$f,$096(a4)
	movea.l (a7)+,a4
	rts


MT_LoopEnd
;	tst.b	MT_Loop(a5)
;	bne.s	.skip
;	st	MT_Ended(a5)
;	bra.s	MT_End
;.skip
	rts
	


MT_ZeroTab:
	dc.l    0



MT_Music:
	lea     Variables(pc),a5
	tst.b   MT_Enable(a5)
	beq.w   MT_Exit
	lea     $dff000,a6
	addq.b  #1,MT_Counter(a5)
	move.b  MT_Counter(a5),d0
	cmp.b   MT_Speed(a5),d0
	blo.s   MT_NoNewNote
	clr.b   MT_Counter(a5)
	tst.b   MT_PattDelTime2(a5)
	beq.s   MT_GetNewNote
	bsr.s   MT_NoNewAllChannels
	bra.w   MT_Dskip

MT_NoNewNote:
	bsr.s   MT_NoNewAllChannels
	bra.w   MT_NoNewPosYet
MT_NoNewAllChannels:
	move.w  #$a0,d5
	lea     MT_Chan1Temp(pc),a4
	bsr.w   MT_CheckEfx
	move.w  #$b0,d5
	lea     MT_Chan2Temp(pc),a4
	bsr.w   MT_CheckEfx
	move.w  #$c0,d5
	lea     MT_Chan3Temp(pc),a4
	bsr.w   MT_CheckEfx
	move.w  #$d0,d5
	lea     MT_Chan4Temp(pc),a4
	bra.w   MT_CheckEfx
MT_GetNewNote:
	move.l  MT_SongDataPtr(a5),a0
	lea     12(a0),a3
	lea     952(a0),a2      ;pattpo
	lea     1084(a0),a0     ;patterndata
	moveq   #0,d0
	moveq   #0,d1
	move.b  MT_SongPos(a5),d0
	move.b  (a2,d0.w),d1
	asl.l   #8,d1
	asl.l   #2,d1
	add.w   MT_PatternPos(a5),d1
	clr.w   MT_DMACONTemp(a5)

	move.w  #$a0,d5
	lea     MT_Chan1Temp(pc),a4
	bsr.s   MT_PlayVoice
	move.w  #$b0,d5
	lea     MT_Chan2Temp(pc),a4
	bsr.s   MT_PlayVoice
	move.w  #$c0,d5
	lea     MT_Chan3Temp(pc),a4
	bsr.s   MT_PlayVoice
	move.w  #$d0,d5
	lea     MT_Chan4Temp(pc),a4
	bsr.s   MT_PlayVoice
	bra.w   MT_SetDMA

MT_PlayVoice:
	tst.l   (a4)
	bne.s   MT_PlvSkip
	bsr.w   MT_PerNop
MT_PlvSkip:     
	move.l  (a0,d1.l),(a4)
	addq.l  #4,d1
	moveq   #$f,d0
	lsl.b   #4,d0
	move.l  d0,d2
	and.b   N_Cmd(a4),d2
	lsr.b   #4,d2
	and.b   (a4),d0
	or.b    d0,d2
	beq.w   MT_SetRegs
	moveq   #0,d3
	lea     MT_SampleStarts(pc),a1
	move.l  d2,d4
	subq.l  #1,d2
	asl.l   #2,d2
	mulu    #30,d4


	moveq   #1,d0                   ; -
	move.w  6(a3,d4.l),N_Replen(a4) ; Save replen
	bne.s   MT_OK_Replen
	move.w  d0,N_Replen(a4)
MT_OK_Replen:

	move.l  (a1,d2.l),N_Start(a4)

	move.w  (a3,d4.l),N_Length(a4)
	
	bne.s   MT_NoZeroLen                ; -
MT_ZeroLen:                                 ; -
	move.l  MT_ZeroTab(pc),N_Start(a4)  ; -
	move.w  d0,N_Length(a4)
	
MT_NoZeroLen:
	move.b  2(a3,d4.l),N_FineTune(a4)
	move.b  3(a3,d4.l),N_Volume(a4)
	move.l  N_Start(a4),d2  ; Get start
	move.w	N_Length(a4),N_RealLength(a4)
	move.w  4(a3,d4.l),d3   ; Get repeat
	move.w  d3,d0
	beq.s	MT_NoLoop
	add.w   d3,d3
	add.w   N_Replen(a4),d0 ; Add replen
	move.w  d0,N_Length(a4)
	add.l   d3,d2           ; Add repeat
MT_NoLoop:
	move.l  d2,N_LoopStart(a4)
	move.l  d2,N_WaveStart(a4)


	pea     MT_SetRegs(pc)
	moveq   #$0f,d0
	and.b   N_Cmd(a4),d0
	cmpi.b  #$c,d0
	beq.w   MT_VolumeChange
	bra.w   MT_MasterVol

MT_SetRegs:
	move.w  N_Note(a4),d0
	andi.w  #$0fff,d0
	beq.w   MT_CheckMoreEfx ; If no note
	move.w  N_Cmd(a4),d0
	andi.w  #$0ff0,d0
	cmpi.w  #$0e50,d0
	beq.s   MT_DoSetFineTune
	moveq   #$0f,d0
	and.b   N_Cmd(a4),d0
	cmpi.b  #3,d0   ; TonePortamento
	beq.s   MT_ChkTonePorta
	cmpi.b  #5,d0
	beq.s   MT_ChkTonePorta
	cmpi.b  #9,d0   ; Sample Offset
	bne.s   MT_SetPeriod
	bsr.w   MT_CheckMoreEfx
	bra.s   MT_SetPeriod

MT_DoSetFineTune:
	bsr.w   MT_SetFineTune
	bra.s   MT_SetPeriod

MT_ChkTonePorta:
	bsr.w   MT_SetTonePorta
	bra.w   MT_CheckMoreEfx

MT_SetPeriod:
	movem.l d0-d1/a0-a1,-(a7)
	move.w  N_Note(a4),d1
	andi.w  #$0fff,d1
	lea     MT_PeriodTable(pc),a1
	moveq   #0,d0
	moveq   #36,d7
MT_FtuLoop:
	cmp.w   (a1,d0.w),d1
	bhs.s   MT_FtuFound
	addq.w  #2,d0
	dbf     d7,MT_FtuLoop
MT_FtuFound:
	moveq   #0,d1
	move.b  N_FineTune(a4),d1
	mulu    #72,d1
	add.w   d1,a1
	move.w  (a1,d0.w),N_Period(a4)
	movem.l (a7)+,d0-d1/a0-a1

	move.w  N_Cmd(a4),d0
	andi.w  #$0ff0,d0
	cmpi.w  #$0ed0,d0 ; Notedelay
	beq.w   MT_CheckMoreEfx

	move.w  N_DMABit(a4),$096(a6)
	btst    #2,N_WaveControl(a4)
	bne.s   MT_Vibnoc
	clr.b   N_VibratoPos(a4)
MT_Vibnoc:
	btst    #6,N_WaveControl(a4)
	bne.s   MT_Trenoc
	clr.b   N_TremoloPos(a4)
MT_Trenoc:
	move.l  N_Start(a4),(a6,d5.w)   ; Set start
	move.w  N_Length(a4),4(a6,d5.w) ; Set length
	move.w  N_Period(a4),6(a6,d5.w) ; Set period
	move.w  N_DMABit(a4),d0
	or.w    d0,MT_DMACONTemp(a5)
	bra.w   MT_CheckMoreEfx
MT_SetDMA:      
	bsr.w   MT_DMAWaitLoop
	move.w  MT_DMACONTemp(a5),d0
	ori.w   #$8000,d0
	move.w  d0,$096(a6)
	bsr.w   MT_DMAWaitLoop
;	move.w  MT_DMACONTemp(a5),d0
;	lsr.w	#1,d0
;	bcc.s	.skip1
	move.l  MT_Chan1Temp+N_LoopStart(pc),$a0(a6)
	move.w  MT_Chan1Temp+N_Replen(pc),$a4(a6)
;.skip1
;	lsr.w	#1,d0
;	bcc.s	.skip2
	move.l  MT_Chan2Temp+N_LoopStart(pc),$b0(a6)
	move.w  MT_Chan2Temp+N_Replen(pc),$b4(a6)
;.skip2
;	lsr.w	#1,d0
;	bcc.s	.skip3
	move.l  MT_Chan3Temp+N_LoopStart(pc),$c0(a6)
	move.w  MT_Chan3Temp+N_Replen(pc),$c4(a6)
;.skip3
;	lsr.w	#1,d0
;	bcc.s	MT_Dskip
	move.l  MT_Chan4Temp+N_LoopStart(pc),$d0(a6)
	move.w  MT_Chan4Temp+N_Replen(pc),$d4(a6)
MT_Dskip:
	addi.w  #16,MT_PatternPos(a5)
	move.b  MT_PattDelTime(a5),d0
	beq.s   MT_Dskc
	move.b  d0,MT_PattDelTime2(a5)
	clr.b   MT_PattDelTime(a5)
MT_Dskc:
	tst.b   MT_PattDelTime2(a5)
	beq.s   MT_Dska
	subq.b  #1,MT_PattDelTime2(a5)
	beq.s   MT_Dska
	sub.w   #16,MT_PatternPos(a5)
MT_Dska:
	tst.b   MT_PBreakFlag(a5)
	beq.s   MT_Nnpysk
	clr.b   MT_PBreakFlag(a5)
	moveq   #0,d0
	move.b  MT_PBreakPos(a5),d0
	clr.b   MT_PBreakPos(a5)
	lsl.w   #4,d0
	move.w  d0,MT_PatternPos(a5)
MT_Nnpysk:
	cmpi.w  #1024,MT_PatternPos(a5)
	blo.s   MT_NoNewPosYet
MT_NextPosition:        
	moveq   #0,d0
	move.b  MT_PBreakPos(a5),d0
	lsl.w   #4,d0
	move.w  d0,MT_PatternPos(a5)
	clr.b   MT_PBreakPos(a5)
	clr.b   MT_PosJumpFlag(a5)
	move.b  MT_SongPos(a5),d1
	addq.b  #1,d1
	andi.b  #$7F,d1
	move.b  d1,MT_SongPos(a5)
	move.l  MT_SongDataPtr(a5),a0
	cmp.b   950(a0),d1
	blo.s   MT_NoNewPosYet
	clr.b   MT_SongPos(a5)
	
	move.b  #6,MT_Speed(a5)         ; -
	moveq   #125,d0                 ; -
	bsr.w   SetTempo                ; -

	bsr.w	MT_LoopEnd
	tst.b	MT_Ended(a5)
	bne.s	MT_Exit
	
MT_NoNewPosYet: 
	tst.b   MT_PosJumpFlag(a5)
	bne.s   MT_NextPosition
MT_Exit
	rts

MT_CheckEfx:
	bsr.w   MT_UpdateFunk
	move.w  N_Cmd(a4),d0
	andi.w  #$0fff,d0
	beq.s   MT_PerNop
	move.b  N_Cmd(a4),d0
	andi.b  #$0f,d0
	beq.s   MT_Arpeggio
	cmpi.b  #1,d0
	beq.w   MT_PortaUp
	cmpi.b  #2,d0
	beq.w   MT_PortaDown
	cmpi.b  #3,d0
	beq.w   MT_TonePortamento
	cmpi.b  #4,d0
	beq.w   MT_Vibrato
	cmpi.b  #5,d0
	beq.w   MT_TonePlusVolSlide
	cmpi.b  #6,d0
	beq.w   MT_VibratoPlusVolSlide
	cmpi.b  #$E,d0
	beq.w   MT_E_Commands
SetBack:
	move.w  N_Period(a4),6(a6,d5.w)
	cmpi.b  #7,d0
	beq.w   MT_Tremolo
	cmpi.b  #$a,d0
	beq.w   MT_VolumeSlide
MT_Return:
	rts

MT_PerNop:
	move.w  N_Period(a4),6(a6,d5.w)
	rts

MT_Arpeggio:
	moveq   #0,d0
	move.b  MT_Counter(a5),d0
	divs    #3,d0
	swap    d0
	tst.w   d0
	beq.s   MT_Arpeggio2
	cmpi.w  #2,d0
	beq.s   MT_Arpeggio1
	moveq   #0,d0
	move.b  N_Cmdlo(a4),d0
	lsr.b   #4,d0
	bra.s   MT_Arpeggio4

MT_Arpeggio1:
	moveq   #$f,d0
	and.b   N_Cmdlo(a4),d0
	bra.s   MT_Arpeggio4

MT_Arpeggio2:
	move.w  N_Period(a4),d2
MT_Arpeggio3:
	move.w  d2,6(a6,d5.w)
	rts

MT_Arpeggio4:
	add.w   d0,d0
	moveq   #0,d1
	move.b  N_FineTune(a4),d1
	mulu    #72,d1
	lea     MT_PeriodTable(pc),a0
	add.w   d1,a0
	moveq   #0,d1
	move.w  N_Period(a4),d1
	moveq   #36,d7
MT_ArpLoop:
	move.w  (a0,d0.w),d2
	cmp.w   (a0),d1
	bhs.s   MT_Arpeggio3
	addq.w  #2,a0
	dbf     d7,MT_ArpLoop
	rts

MT_FinePortaUp:
	tst.b   MT_Counter(a5)
	bne.s   MT_Return
	move.b  #$0f,MT_LowMask(a5)
MT_PortaUp:
	moveq   #0,d0
	move.b  N_Cmdlo(a4),d0
	and.b   MT_LowMask(a5),d0
	st      MT_LowMask(a5)
	sub.w   d0,N_Period(a4)
	move.w  N_Period(a4),d0
	andi.w  #$0fff,d0
	cmpi.w  #113,d0
	bpl.s   MT_PortaUskip
	andi.w  #$f000,N_Period(a4)
	ori.w   #113,N_Period(a4)
MT_PortaUskip:
	move.w  N_Period(a4),d0
	andi.w  #$0fff,d0
	move.w  d0,6(a6,d5.w)
	rts
 
MT_FinePortaDown:
	tst.b   MT_Counter(a5)
	bne.w   MT_Return
	move.b  #$0f,MT_LowMask(a5)
MT_PortaDown:
	moveq   #0,d0
	move.b  N_Cmdlo(a4),d0
	and.b   MT_LowMask(a5),d0
	st      MT_LowMask(a5)
	add.w   d0,N_Period(a4)
	move.w  N_Period(a4),d0
	andi.w  #$0fff,d0
	cmpi.w  #856,d0
	bmi.s   MT_PortaDskip
	andi.w  #$f000,N_Period(a4)
	ori.w   #856,N_Period(a4)
MT_PortaDskip:
	move.w  N_Period(a4),d0
	andi.w  #$0fff,d0
	move.w  d0,6(a6,d5.w)
	rts

MT_SetTonePorta:
	move.l  a0,-(a7)
	move.w  N_Note(a4),d2
	andi.w  #$0fff,d2
	moveq   #0,d0
	move.b  N_FineTune(a4),d0
	mulu    #72,d0  ; was 74
	lea     MT_PeriodTable(pc),a0
	add.w   d0,a0
	moveq   #0,d0
MT_StpLoop:
	cmp.w   (a0,d0.w),d2
	bhs.s   MT_StpFound
	addq.w  #2,d0
	cmpi.w  #74,d0
	blo.s   MT_StpLoop
	moveq   #70,d0
MT_StpFound:
	move.b  N_FineTune(a4),d2
	andi.b  #8,d2
	beq.s   MT_StpGoss
	tst.w   d0
	beq.s   MT_StpGoss
	subq.w  #2,d0
MT_StpGoss:
	move.w  (a0,d0.w),d2
	move.l  (a7)+,a0
	move.w  d2,N_WantedPeriod(a4)
	move.w  N_Period(a4),d0
	clr.b   N_TonePortDirec(a4)
	cmp.w   d0,d2
	beq.s   MT_ClearTonePorta
	bge.w   MT_Return
	move.b  #1,N_TonePortDirec(a4)
	rts

MT_ClearTonePorta:
	clr.w   N_WantedPeriod(a4)
	rts

MT_TonePortamento:
	move.b  N_Cmdlo(a4),d0
	beq.s   MT_TonePortNoChange
	move.b  d0,N_TonePortSpeed(a4)
	clr.b   N_Cmdlo(a4)
MT_TonePortNoChange:
	tst.w   N_WantedPeriod(a4)
	beq.w   MT_Return
	moveq   #0,d0
	move.b  N_TonePortSpeed(a4),d0
	tst.b   N_TonePortDirec(a4)
	bne.s   MT_TonePortaUp
MT_TonePortaDown:
	add.w   d0,N_Period(a4)
	move.w  N_WantedPeriod(a4),d0
	cmp.w   N_Period(a4),d0
	bgt.s   MT_TonePortaSetPer
	move.w  N_WantedPeriod(a4),N_Period(a4)
	clr.w   N_WantedPeriod(a4)
	bra.s   MT_TonePortaSetPer

MT_TonePortaUp:
	sub.w   d0,N_Period(a4)
	move.w  N_WantedPeriod(a4),d0
	cmp.w   N_Period(a4),d0         ; was cmpi!!!!
	blt.s   MT_TonePortaSetPer
	move.w  N_WantedPeriod(a4),N_Period(a4)
	clr.w   N_WantedPeriod(a4)

MT_TonePortaSetPer:
	move.w  N_Period(a4),d2
	moveq   #0,d0
	move.b  N_GlissFunk(a4),d0
	andi.b  #$0f,d0
	beq.s   MT_GlissSkip
	move.b  N_FineTune(a4),d0
	mulu    #72,d0
	lea     MT_PeriodTable(pc),a0
	add.w   d0,a0
	moveq   #0,d0
MT_GlissLoop:
	cmp.w   (a0,d0.w),d2
	bhs.s   MT_GlissFound
	addq.w  #2,d0
	cmpi.w  #72,d0
	blo.s   MT_GlissLoop
	moveq   #70,d0
MT_GlissFound:
	move.w  (a0,d0.w),d2
MT_GlissSkip:
	move.w  d2,6(a6,d5.w) ; Set period
	rts

MT_Vibrato:
	move.b  N_Cmdlo(a4),d0
	beq.s   MT_Vibrato2
	move.b  N_VibratoCmd(a4),d2
	andi.b  #$0f,d0
	beq.s   MT_VibSkip
	andi.b  #$f0,d2
	or.b    d0,d2
MT_VibSkip:
	move.b  N_Cmdlo(a4),d0
	andi.b  #$f0,d0
	beq.s   MT_VibSkip2
	andi.b  #$0f,d2
	or.b    d0,d2
MT_VibSkip2:
	move.b  d2,N_VibratoCmd(a4)
MT_Vibrato2:
	move.b  N_VibratoPos(a4),d0
	lea     MT_VibratoTable(pc),a0
	lsr.w   #2,d0
	andi.w  #$001f,d0
	moveq   #$3,d2
	and.b   N_WaveControl(a4),d2
	beq.s   MT_Vib_Sine
	lsl.b   #3,d0
	cmpi.b  #1,d2
	beq.s   MT_Vib_RampDown
	st      d2
	bra.s   MT_Vib_Set
MT_Vib_RampDown:
	tst.b   N_VibratoPos(a4)
	bpl.s   MT_Vib_RampDown2
	st      d2
	sub.b   d0,d2
	bra.s   MT_Vib_Set
MT_Vib_RampDown2:
	move.b  d0,d2
	bra.s   MT_Vib_Set
MT_Vib_Sine:
	move.b  (a0,d0.w),d2
MT_Vib_Set:
	move.b  N_VibratoCmd(a4),d0
	andi.w  #15,d0
	mulu    d0,d2
	lsr.w   #7,d2
	move.w  N_Period(a4),d0
	tst.b   N_VibratoPos(a4)
	bmi.s   MT_VibratoNeg
	add.w   d2,d0
	bra.s   MT_Vibrato3
MT_VibratoNeg:
	sub.w   d2,d0
MT_Vibrato3:
	move.w  d0,6(a6,d5.w)
	move.b  N_VibratoCmd(a4),d0
	lsr.w   #2,d0
	andi.w  #$3C,d0
	add.b   d0,N_VibratoPos(a4)
	rts

MT_TonePlusVolSlide:
	bsr.w   MT_TonePortNoChange
	bra.w   MT_VolumeSlide

MT_VibratoPlusVolSlide:
	bsr.s   MT_Vibrato2
	bra.w   MT_VolumeSlide

MT_Tremolo:
	move.b  N_Cmdlo(a4),d0
	beq.s   MT_Tremolo2
	move.b  N_TremoloCmd(a4),d2
	andi.b  #$0f,d0
	beq.s   MT_TreSkip
	andi.b  #$f0,d2
	or.b    d0,d2
MT_TreSkip:
	move.b  N_Cmdlo(a4),d0
	and.b   #$f0,d0
	beq.s   MT_TreSkip2
	andi.b  #$0f,d2
	or.b    d0,d2
MT_TreSkip2:
	move.b  d2,N_TremoloCmd(a4)
MT_Tremolo2:
	move.b  N_TremoloPos(a4),d0
	lea     MT_VibratoTable(pc),a0
	lsr.w   #2,d0
	andi.w  #$1f,d0
	moveq   #0,d2
	move.b  N_WaveControl(a4),d2
	lsr.b   #4,d2
	andi.b  #3,d2
	beq.s   MT_Tre_Sine
	lsl.b   #3,d0
	cmpi.b  #1,d2
	beq.s   MT_Tre_RampDown
	st      d2
	bra.s   MT_Tre_Set
MT_Tre_RampDown:
	tst.b   N_VibratoPos(a4)
	bpl.s   MT_Tre_RampDown2
	st      d2
	sub.b   d0,d2
	bra.s   MT_Tre_Set
MT_Tre_RampDown2:
	move.b  d0,d2
	bra.s   MT_Tre_Set
MT_Tre_Sine:
	move.b  (a0,d0.w),d2
MT_Tre_Set:
	moveq	#$0f,d0
	and.b   N_TremoloCmd(a4),d0
	mulu    d0,d2
	lsr.w   #7,d2
	moveq   #0,d0
	move.b  N_Volume(a4),d0
	tst.b   N_TremoloPos(a4)
	bmi.s   MT_TremoloNeg
	add.w   d2,d0
	bra.s   MT_Tremolo3
MT_TremoloNeg:
	sub.w   d2,d0
MT_Tremolo3:
	bpl.s   MT_TremoloSkip
	moveq   #0,d0
MT_TremoloSkip:
	cmpi.w  #$40,d0
	bls.s   MT_TremoloOk
	moveq   #$40,d0
MT_TremoloOk:

	bsr.w     MT_MasterVolSkip

	move.b  N_TremoloCmd(a4),d0
	lsr.w   #2,d0
	andi.w  #$3c,d0
	add.b   d0,N_TremoloPos(a4)
	rts


MT_SampleOffset:
	moveq   #0,d0
	move.b  N_Cmdlo(a4),d0
	beq.s   MT_SoNoNew
	move.b  d0,N_SampleOffset(a4)
MT_SoNoNew:
	move.b  N_SampleOffset(a4),d0
	lsl.w   #7,d0
	cmp.w   N_Length(a4),d0
	bge.s   MT_SofSkip
	sub.w   d0,N_Length(a4)
	add.w   d0,d0
	add.l   d0,N_Start(a4)
	rts
MT_SofSkip:
	move.w  #1,N_Length(a4)
	rts

MT_VolumeSlide:
	moveq   #0,d0
	move.b  N_Cmdlo(a4),d0
	lsr.b   #4,d0
	tst.b   d0
	beq.s   MT_VolSlideDown
MT_VolSlideUp:
	add.b   d0,N_Volume(a4)
	cmpi.b  #$40,N_Volume(a4)
	bmi.s   MT_VsuSkip
	move.b  #$40,N_Volume(a4)
MT_VsuSkip:
	bra.w     MT_MasterVol
	

MT_VolSlideDown:
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
MT_VolSlideDown2:
	sub.b   d0,N_Volume(a4)
	bpl.s   MT_VsdSkip
	clr.b   N_Volume(a4)
MT_VsdSkip:
	bra.w     MT_MasterVol


MT_PositionJump:
	move.b  N_Cmdlo(a4),d0
	subq.b  #1,d0
	cmp.b	MT_SongPos(a5),d0
	bgt.s	MT_PJ1
	movem.l	d0/a0,-(a7)
	move.l	MT_SongDataPtr(a5),a0
	move.b	950(a0),d0
	sub.b	MT_SongPos(a5),d0
	cmpi.b	#1,d0
	bgt.s	MT_PJ0
	bsr.w	MT_LoopEnd
MT_PJ0:
	movem.l	(a7)+,d0/a0
MT_PJ1:	
	move.b	d0,MT_SongPos(a5)
MT_PJ2:
	st      MT_PosJumpFlag(a5)
	clr.b   MT_PBreakPos(a5)
	rts

MT_VolumeChange:
	moveq   #0,d0
	move.b  N_Cmdlo(a4),d0
	cmpi.b  #$40,d0
	bls.s   MT_VolumeOk
	moveq   #$40,d0
MT_VolumeOk:
	move.b  d0,N_Volume(a4)
	bra.w     MT_MasterVolSkip
	

MT_PatternBreak:
	moveq   #0,d0
	move.b  N_Cmdlo(a4),d0
	move.l  d0,d2
	lsr.b   #4,d0
	mulu    #10,d0
	andi.b  #$0f,d2
	add.b   d2,d0
	cmpi.b  #63,d0
	bhi.s   MT_PJ2
	move.b  d0,MT_PBreakPos(a5)
	st      MT_PosJumpFlag(a5)
	rts

MT_SetSpeed:
	moveq   #0,d0
	move.b  3(a4),d0
	beq.w   MT_LoopEnd  ; was MT_Return
	cmpi.b  #32,d0
	bhs.w   SetTempo
	sf      MT_Counter(a5)
	move.b  d0,MT_Speed(a5)
	rts

MT_CheckMoreEfx:
	bsr.w   MT_UpdateFunk
	moveq   #$0f,d0
	and.b   2(a4),d0
	cmpi.b  #$9,d0
	beq.w   MT_SampleOffset
	cmpi.b  #$b,d0
	beq.w   MT_PositionJump
	cmpi.b  #$d,d0
	beq.s   MT_PatternBreak
	cmpi.b  #$e,d0
	beq.s   MT_E_Commands
	cmpi.b  #$f,d0
	beq.s   MT_SetSpeed
	cmpi.b  #$c,d0
	beq.w   MT_VolumeChange
	bra.w   MT_PerNop

MT_E_Commands:
	move.b  N_Cmdlo(a4),d0
	andi.b  #$f0,d0
	lsr.b   #4,d0
	beq.s   MT_FilterOnOff
	cmpi.b  #1,d0
	beq.w   MT_FinePortaUp
	cmpi.b  #2,d0
	beq.w   MT_FinePortaDown
	cmpi.b  #3,d0
	beq.s   MT_SetGlissControl
	cmpi.b  #4,d0
	beq.b   MT_SetVibratoControl
	cmpi.b  #5,d0
	beq.w   MT_SetFineTune
	cmpi.b  #6,d0
	beq.w   MT_JumpLoop
	cmpi.b  #7,d0
	beq.w   MT_SetTremoloControl
	cmpi.b  #9,d0
	beq.w   MT_RetrigNote
	cmpi.b  #$a,d0
	beq.w   MT_VolumeFineUp
	cmpi.b  #$b,d0
	beq.w   MT_VolumeFineDown
	cmpi.b  #$c,d0
	beq.w   MT_NoteCut
	cmpi.b  #$d,d0
	beq.w   MT_NoteDelay
	cmpi.b  #$e,d0
	beq.w   MT_PatternDelay
	cmpi.b  #$f,d0
	beq.w   MT_FunkIt
	rts

MT_FilterOnOff:
	moveq   #1,d0
	and.b   N_Cmdlo(a4),d0
	add.b   d0,d0
	andi.b  #$fd,$bfe001
	or.b    d0,$bfe001
	rts

MT_SetGlissControl:
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	andi.b  #$f0,N_GlissFunk(a4)
	or.b    d0,N_GlissFunk(a4)
	rts

MT_SetVibratoControl:
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	andi.b  #$f0,N_WaveControl(a4)
	or.b    d0,N_WaveControl(a4)
	rts

MT_SetFineTune:
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	move.b  d0,N_FineTune(a4)
	rts

MT_JumpLoop:
	tst.b   MT_Counter(a5)
	bne.w   MT_Return
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	beq.s   MT_SetLoop
	tst.b   N_LoopCount(a4)
	beq.s   MT_JumpCnt
	subq.b  #1,N_LoopCount(a4)
	beq.w   MT_Return
MT_JmpLoop:
	move.b  N_PattPos(a4),MT_PBreakPos(a5)
	st      MT_PBreakFlag(a5)
	rts

MT_JumpCnt:
	move.b  d0,N_LoopCount(a4)
	bra.s   MT_JmpLoop

MT_SetLoop:
	move.w  MT_PatternPos(a5),d0
	lsr.w   #4,d0
	move.b  d0,N_PattPos(a4)
	rts

MT_SetTremoloControl:
	move.b  N_Cmdlo(a4),d0
;       andi.b  #$0f,d0
	lsl.b   #4,d0
	andi.b  #$0f,N_WaveControl(a4)
	or.b    d0,N_WaveControl(a4)
	rts

MT_RetrigNote:
	move.l  d1,-(a7)
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	beq.s   MT_RtnEnd
	moveq   #0,d1
	move.b  MT_Counter(a5),d1
	bne.s   MT_RtnSkp
	move.w  N_Note(a4),d1
	andi.w  #$0fff,d1
	bne.s   MT_RtnEnd
	moveq   #0,d1
	move.b  MT_Counter(a5),d1
MT_RtnSkp:
	divu    d0,d1
	swap    d1
	tst.w   d1
	bne.s   MT_RtnEnd
MT_DoRetrig:
	move.w  N_DMABit(a4),$096(a6)   ; Channel DMA off
	move.l  N_Start(a4),(a6,d5.w)   ; Set sampledata pointer
	move.w  N_Length(a4),4(a6,d5.w) ; Set length
	bsr.w   MT_DMAWaitLoop
	move.w  N_DMABit(a4),d0
	ori.w   #$8000,d0
;       bset    #15,d0
	move.w  d0,$096(a6)
	bsr.w   MT_DMAWaitLoop
	move.l  N_LoopStart(a4),(a6,d5.w)
	move.w  N_Replen(a4),4(a6,d5.w)
MT_RtnEnd:
	move.l  (a7)+,d1
	rts

MT_VolumeFineUp:
	tst.b   MT_Counter(a5)
	bne.w   MT_Return
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	bra.w   MT_VolSlideUp

MT_VolumeFineDown:
	tst.b   MT_Counter(a5)
	bne.w   MT_Return
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	bra.w   MT_VolSlideDown2

MT_NoteCut:
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	cmp.b   MT_Counter(a5),d0
	bne.w   MT_Return
	clr.b   N_Volume(a4)
	bra.w   MT_MasterVol


MT_NoteDelay:
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	cmp.b   MT_Counter(a5),d0   ; was cmpi!!!
	bne.w   MT_Return
	move.w  N_Note(a4),d0
	beq.w   MT_Return
	move.l  d1,-(a7)
	bra.w   MT_DoRetrig

MT_PatternDelay:
	tst.b   MT_Counter(a5)
	bne.w   MT_Return
	moveq   #$0f,d0
	and.b   N_Cmdlo(a4),d0
	tst.b   MT_PattDelTime2(a5)
	bne.w   MT_Return
	addq.b  #1,d0
	move.b  d0,MT_PattDelTime(a5)
	rts

MT_FunkIt:
	tst.b   MT_Counter(a5)
	bne.w   MT_Return
	move.b  N_Cmdlo(a4),d0
;       andi.b  #$0f,d0
	lsl.b   #4,d0
	andi.b  #$0f,N_GlissFunk(a4)
	or.b    d0,N_GlissFunk(a4)
	tst.b   d0
	beq.w   MT_Return
MT_UpdateFunk:
	movem.l a0/d1,-(a7)
	moveq   #0,d0
	move.b  N_GlissFunk(a4),d0
	lsr.b   #4,d0
	beq.s   MT_FunkEnd
	lea     MT_FunkTable(pc),a0
	move.b  (a0,d0.w),d0
	add.b   d0,N_FunkOffset(a4)
	btst    #7,N_FunkOffset(a4)
	beq.s   MT_FunkEnd
	clr.b   N_FunkOffset(a4)

	move.l  N_LoopStart(a4),d0
	moveq   #0,d1
	move.w  N_Replen(a4),d1
	add.l   d1,d0
	add.l   d1,d0
	move.l  N_WaveStart(a4),a0
	addq.w  #1,a0
	cmp.l   d0,a0
	blo.s   MT_FunkOk
	move.l  N_LoopStart(a4),a0
MT_FunkOk:
	move.l  a0,N_WaveStart(a4)
	moveq   #-1,d0
	sub.b   (a0),d0
	move.b  d0,(a0)
MT_FunkEnd:
	movem.l (a7)+,a0/d1
	rts

MT_DMAWaitLoop:
	move.w  d1,-(sp)
	moveq   #9,d0           ; wait 10 lines ( 9+1 )
.loop   move.b  6(a6),d1        ; read current raster position
.wait   cmp.b   6(a6),d1
	beq.s   .wait           ; wait until it changes
	dbf     d0,.loop        ; do it again
	move.w  (sp)+,d1
	rts

MT_MasterVol:
	moveq   #0,d0
	move.b  N_Volume(a4),d0
MT_MasterVolSkip:
	mulu.w  MT_Volume(a5),d0
	lsr.w   #6,d0
MT_MasterVolZero:
	move.w  d0,8(a6,d5.w)
	rts




MT_FunkTable:
	dc.b 0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

MT_VibratoTable:
	dc.b 000,024,049,074,097,120,141,161
	dc.b 180,197,212,224,235,244,250,253
	dc.b 255,253,250,244,235,224,212,197
	dc.b 180,161,141,120,097,074,049,024

MT_PeriodTable:
; Tuning 0, Normal
	dc.w    856,808,762,720,678,640,604,570,538,508,480,453
	dc.w    428,404,381,360,339,320,302,285,269,254,240,226
	dc.w    214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w    850,802,757,715,674,637,601,567,535,505,477,450
	dc.w    425,401,379,357,337,318,300,284,268,253,239,225
	dc.w    213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w    844,796,752,709,670,632,597,563,532,502,474,447
	dc.w    422,398,376,355,335,316,298,282,266,251,237,224
	dc.w    211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w    838,791,746,704,665,628,592,559,528,498,470,444
	dc.w    419,395,373,352,332,314,296,280,264,249,235,222
	dc.w    209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w    832,785,741,699,660,623,588,555,524,495,467,441
	dc.w    416,392,370,350,330,312,294,278,262,247,233,220
	dc.w    208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w    826,779,736,694,655,619,584,551,520,491,463,437
	dc.w    413,390,368,347,328,309,292,276,260,245,232,219
	dc.w    206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w    820,774,730,689,651,614,580,547,516,487,460,434
	dc.w    410,387,365,345,325,307,290,274,258,244,230,217
	dc.w    205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
	dc.w    814,768,725,684,646,610,575,543,513,484,457,431
	dc.w    407,384,363,342,323,305,288,272,256,242,228,216
	dc.w    204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w    907,856,808,762,720,678,640,604,570,538,508,480
	dc.w    453,428,404,381,360,339,320,302,285,269,254,240
	dc.w    226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w    900,850,802,757,715,675,636,601,567,535,505,477
	dc.w    450,425,401,379,357,337,318,300,284,268,253,238
	dc.w    225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w    894,844,796,752,709,670,632,597,563,532,502,474
	dc.w    447,422,398,376,355,335,316,298,282,266,251,237
	dc.w    223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w    887,838,791,746,704,665,628,592,559,528,498,470
	dc.w    444,419,395,373,352,332,314,296,280,264,249,235
	dc.w    222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w    881,832,785,741,699,660,623,588,555,524,494,467
	dc.w    441,416,392,370,350,330,312,294,278,262,247,233
	dc.w    220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w    875,826,779,736,694,655,619,584,551,520,491,463
	dc.w    437,413,390,368,347,328,309,292,276,260,245,232
	dc.w    219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w    868,820,774,730,689,651,614,580,547,516,487,460
	dc.w    434,410,387,365,345,325,307,290,274,258,244,230
	dc.w    217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w    862,814,768,725,684,646,610,575,543,513,484,457
	dc.w    431,407,384,363,342,323,305,288,272,256,242,228
	dc.w    216,203,192,181,171,161,152,144,136,128,121,114


MT_Chan1Temp:
	ds.b    N_SIZEOF
MT_Chan2Temp:
	ds.b    N_SIZEOF
MT_Chan3Temp:
	ds.b    N_SIZEOF
MT_Chan4Temp:
	ds.b    N_SIZEOF
MT_SampleStarts:
	ds.l    31
	
Variables:

*MT_SongDataPtr:
	dc.l 0
*MT_Speed:
	dc.b 6
*MT_Counter:
	dc.b 0
*MT_SongPos:
	dc.b 0
*MT_PBreakPos:
	dc.b 0
*MT_PosJumpFlag:
	dc.b 0
*MT_PBreakFlag:
	dc.b 0
*MT_LowMask:
	dc.b 0
*MT_PattDelTime:
	dc.b 0
*MT_PattDelTime2:
	dc.b 0,0
*MT_PatternPos:
	dc.w 0
*MT_DMACONTemp:
	dc.w 0
*MT_Volume:
	dc.w 64
*MT_Enable:
	dc.b 0,0
*MT_Interval:
	dc.l	20000
*MT_Loop:
	dc.b	-1
*MT_Ended:
	dc.b	0




