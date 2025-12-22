;=======T=======T========================T==========================================;
;                                   SOUND MODULE
;===================================================================================;

	xref	_LIBFreeSoundMem
	xref	_LIBAllocSoundMem
	xref	_DPKBase
	xref	_SndAlloc
	xref	_Octaves
	xref	_Volumes

	xdef	_LIBAllocAudio
	xdef	_LIBFreeAudio
	xdef	_LIBSetVolume
	xdef	_LIBStopAudio
	xdef	_LIBCheckSound
	xdef	_SND_Deactivate
	xdef	_SND_Activate

	INCDIR	"INCLUDES:"
	INCLUDE	"exec/exec_lib.i"
	INCLUDE	"hardware/custom.i"
	INCLUDE	"dpkernel/dpkernel.i"
	INCLUDE	"system/tracking.i"
	INCLUDE	"sound/sound.i"

	SECTION "ModCode",CODE

;===================================================================================;
;                         ALLOCATE AUDIO CHANNELS
;===================================================================================;
;Function: LONG AllocAudio(void)
;Short:    Attempts to allocate all the audio channels.

_LIBAllocAudio:
	MOVEM.L	D1-D7/A0-A6,-(SP)	;SP = Save all registers.
	move.l	_DPKBase,a6	;a6 = DPKBase.

	tst.w	_SndAlloc	;ma =  Check if already allocated.
	bne.s	.done	;>> = Yes, so just exit.

	move.l	$4.w,a6	;a6 = ExecBase.
	CALL	Forbid	;>> = Forbid the system.
	moveq	#-1,d0	;d0 = -1
	CALL	AllocSignal	;>> = Get a signal?
	tst.b	d0	;d0 = Did we get it?
	bmi.s	.Error	;>> = Error.
	move.b	d0,SigBitNum	;ma = Store bit number.

	;Prepare IORequest

	lea	AllocPort(pc),a1	;a1 = Port.
	move.b	d0,15(a1)	;a1 = Set mp_SigBit
	move.l	a1,-(SP)	;
	suba.l	a1,a1	;
	CALL	FindTask	;>> = Find our task.
	move.l	(SP)+,a1
	move.l	d0,16(a1)	;a1 = Set mp_SigTask
	lea	ReqList(pc),a0
	move.l	a0,(a0)	;a0 = NEWLIST begins...
	addq.l	#4,(a0)	;a0 = +4
	clr.l	4(a0)	;a0 = Clear
	move.l	a0,8(a0)	;a0 = NEWLIST ends...

	;Open the audio.device (attempt all channels).

	moveq	#2,d2	;d2 = 2.
	lea	AllocReq(pc),a1	;a1 = Ptr to AllocReq.
	lea	AUD_Name(pc),a0	;a0 = Ptr to AudioDeviceName
	moveq	#0,d0	;d0 = 00.
	moveq	#0,d1	;d1 = 00.
	move.l	($4).w,a6	;a6 = ExecBase.
	CALL	OpenDevice	;>> = Open Audio device.
	tst.b	d0	;d0 = Check for error.
	bne.s	.Error	;>> = Error, audio in use.
	st	AudioDevOpen	;MA = Yes, we managed to open it.
	move.l	($4).w,a6	;a6 = ExecBase.
	CALL	Permit	;>> = Permit the system.

	or.b	#2,($bfe001).L	;ma = Turn Sound filter OFF.
	move.w	#1,_SndAlloc	;ma = Note allocation.

.done	MOVEM.L	(SP)+,D1-D7/A0-A6	;SP = Return all registers.
	moveq	#ERR_OK,d0	;d0 = No errors.
	rts

.Error	MOVEM.L	(SP)+,D1-D7/A0-A6	;SP = Return all registers.
	moveq	#ERR_INUSE,d0	;d0 = Error, audio in use.
	rts

;===================================================================================;
;                           FREE AUDIO CHANNELS
;===================================================================================;
;Function: void FreeAudio(void)
;Short:    Free the audio channels so the system can use them again.

_LIBFreeAudio:
	MOVEM.L	A0-A6/D0-D7,-(SP)
	move.l	_DPKBase,a6	;a6 = DPKBase.
	tst.w	_SndAlloc	;ma = Check if we actually own it.
	beq.s	.done	;>> = Nope, exit.
	bsr	_LIBStopAudio
	move.l	($4).w,a6	,a6 = ExecBase.
	tst.b	AudioDevOpen	;MA = Is it actually open?
	beq.s	.rem1	;>> = No!
	move.w	#$000f,$dff096	;MA = Stop audio DMA
	lea	AllocReq(pc),a1	;a1 = 
	CALL	CloseDevice	;>> = Close audio.device

	clr.b	AudioDevOpen	;MA = No longer open.
.rem1	moveq	#0,d0	;d0 = 00.
	move.b	SigBitNum(pc),d0	;d0 = Signal.
	bmi.s	.rem2	;>> = No signal.
	CALL	FreeSignal	;>> = Free it.
	st	SigBitNum	;MA = We don't have it anymore.
.rem2	and.b	#253,($bfe001).l	;MA = Turn Sound filter back ON.
	clr.w	_SndAlloc
.done	MOVEM.L	(SP)+,A0-A6/D0-D7	;SP = Return all registers.
	rts

;===================================================================================;
;                   PLAY SOUND ACCORDING TO PRIORITIES
;===================================================================================;
;Function: LONG Activate(*Sound [a0])
;Short:    Play a sound through a channel if it passes the priority test.

_SND_Activate:
	MOVE.L	A6,-(SP)	;SP = Save registers.
	lea	$dff000,a6	;a6 = $dff000.
	move.l	SND_Attrib(a0),d0	;d0 = Sound attributes.
	and.l	#SDF_STOPLAST,d0	;d0 = Should the last play be stopped?
	beq.s	.FindChannel	;>> = Nope, leave it.

	;Deactivate the last channel if the sound is still playing.
	;This means disabling the channel that the sound last went
	;through.

	move.w	SNDP_LastChannel(a0),d0	;d0 = Channel number to play in.
	beq.s	.FindChannel
	add.w	d0,d0	;d0 = ChanNum*2.
	move.w	d0,d1	;d1 = (ChanNum)*2
	add.w	d1,d1	;d1 = (ChanNum)*4
	lea	ChannelSounds(pc),a1	;a1 = &ChannelSounds array.
	cmp.l	(a1,d1.w),a0	;a1 = Is our sound "still playing"?
	bne.s	.FindChannel	;>> = We can play through any channel.
	move.w	.Jump(pc,d0.w),d0	;d0 = Jump offset.
	jmp	.Jump(pc,d0.w)	;>> = Play through previous channel.

.Jump	dc.w	PSPri1-.Jump	;0 (This channel is actually illegal).
	dc.w	PSPri1-.Jump	;1
	dc.w	PSPri2-.Jump	;2
	dc.w	PSPri3-.Jump	;3
	dc.w	PSPri4-.Jump	;4

.FindChannel
	clr.w	SNDP_LastChannel(a0)	;a0 = Clear last channel.
	lea	ChannelPri(pc),a1	;a1 = Pointer to current priorites.
	move.w	INTREQR(a6),d0	;d0 = INTREQR.

	;Test for channel preference.

	move.l	SND_Attrib(a0),d1	;d1 = Sound attributes.
	btst	#SDB_RIGHT,d1	;d1 = Prefer right?
	bne.s	.rightfirst	;>> = Yes.
	btst	#SDB_LEFT,d1	;d1 = Prefer left?
	bne.s	.leftfirst	;>> = Yes.
.anyfirst
	btst	#7,d0	;d0 = Test left.
	bne.s	Pspi1	;>> = Left available.
	btst	#8,d0	;d0 = Test right.
	bne	Pspi2	;>> = Right available.
	btst	#9,d0	;d0 = Test right.
	bne	Pspi3	;>> = Right available.
	btst	#10,d0	;d0 = Test left.
	bne	Pspi4	;>> = Left available.
	bra.s	.priorities

;-----------------------------------------------------------------------------------;
;Right is preferred.

.rightfirst
	btst	#8,d0	;d0 = Test right.
	bne	Pspi2	;>> = Right available.
	btst	#9,d0	;d0 = Test right.
	bne	Pspi3	;>> = Right available.
	btst	#SDB_FORCE,d1	;d1 = Force on right?
	bne.s	.rightpriforce	;>> = Yes, so skip left channels.
	btst	#7,d0	;d0 = Test left.
	bne.s	Pspi1	;>> = Left available.
	btst	#10,d0	;d0 = Test left.
	bne	Pspi4	;>> = Left available.
	bra.s	.priorities

.rightpriforce
	btst	#SDB_EMPTY,d1	;d1 = Only play if channels are empty?
	bne.s	.done	;>> = Since there are none empty, exit.
	move.w	SND_Priority(a0),d0	;d0 = Sample Priority.
	cmp.w	2(a1),d0	;
	bgt	Pspi2	;>> = Chan2, Only play if greater (right)
	cmp.w	4(a1),d0	;
	bge	Pspi3	;>> = Chan3, Only play if greater/equal (right)
	bra.s	.done

;-----------------------------------------------------------------------------------;
;Left is preferred.

.leftfirst
	btst	#7,d0	;d0 = Test left.
	bne.s	Pspi1	;>> = Left available.
	btst	#10,d0	;d0 = Test left.
	bne	Pspi4	;>> = Left available.
	btst	#SDB_FORCE,d1	;d1 = Force on left?
	bne.s	.leftpriforce	;>> = Yes, so skip right channels.
	btst	#8,d0	;d0 = Test right.
	bne	Pspi2	;>> = Right available.
	btst	#9,d0	;d0 = Test right.
	bne	Pspi3	;>> = Right available.
	bra.s	.priorities

.leftpriforce
	btst	#SDB_EMPTY,d1	;d1 = Only play if channels are empty?
	bne.s	.done	;>> = Since there are none empty, exit.
	move.w	SND_Priority(a0),d0	;d0 = Sample Priority.
	cmp.w	(a1),d0	;a1 = < SamplePri?
	bgt.s	Pspi1	;>> = Chan1, Only play if greater (left)
	cmp.w	6(a1),d0	;
	bge	Pspi4	;>> = Chan4, Only play if greater/equal (left)
	bra.s	.done	;

;-----------------------------------------------------------------------------------;
;If no channels are available, compare the priorities.
;
;Requires: d1 = Sound attributes.

.priorities
	btst	#SDB_EMPTY,d1	;d1 = Only play if channels are empty?
	bne.s	.done	;>> = Since there are none empty, exit.

	move.w	SND_Priority(a0),d0	;d0 = Sample Priority.
	cmp.w	(a1),d0	;a1 = < SamplePri?
	bgt.s	Pspi1	;>> = Chan1, Only play if greater (left)
	cmp.w	2(a1),d0	;
	bgt	Pspi2	;>> = Chan2, Only play if greater (right)
	cmp.w	6(a1),d0	;
	bge	Pspi4	;>> = Chan4, Only play if greater/equal (left)
	cmp.w	4(a1),d0	;
	bge	Pspi3	;>> = Chan3, Only play if greater/equal (right)
.done	MOVE.L	(SP)+,A6	;a6 = Return registers.
	moveq	#ERR_FAILED,d0	;d0 = Error, failed.
	rts		;Exit.

;-----------------------------------------------------------------------------------;
;                                     CHANNEL 1
;-----------------------------------------------------------------------------------;

PSPri1:	lea	ChannelPri(pc),a1	;a1 = Pointer to current priorites.
	lea	$dff000,a6
	btst	#7,INTREQR+1(a6)	;a6 = Test channel - is it in use?  If
	bne.s	Pspi1	;     not, ignore channel priority.
	move.w	(a1),d1	;d1 = Current sound priority.
	cmp.w	SND_Priority(a0),d1
	bgt	PS1done

Pspi1:	move.w	#1,SNDP_LastChannel(a0)	;a0 = Set last channel.
	move.w	SND_Priority(a0),(a1)	;a1 = Store new priority.
	move.w	#$0001,DMACON(a6)	;a6 = Turn off channel ($0001)
	move.w	#$8000+1<<7,INTREQ(a6)	;a6 = Request reset of audio interrupt.
	moveq	#80-1,d1	;d1 = vsync counters to wait.
.wait0	move.b	$7(a6),d0	;d0 = Waits about 3.4 scan lines.
.wait1	cmp.b	$7(a6),d0
	beq.s	.wait1
	dbra	d1,.wait0

	move.l	SND_Data(a0),AUD0LC(a6)
	move.l	SND_Length(a0),d0
	lsr.l	#1,d0
	move.w	d0,AUD0LEN(a6)

	lea	_Octaves,a1
	move.w	SND_Octave(a0),d0
	move.w	(a1,d0.w),AUD0PER(a6)

	lea	_Volumes,a1
	move.w	SND_Volume(a0),d0
	add.w	d0,d0	;d0 = (Volume)*2 [word]
	move.w	(a1,d0.w),AUD0VOL(a6)
	move.w	(a1,d0.w),Chan1Vol

	;Check volume modulation.  Channel 1 is
	;modulated with channel 2.

.chkvol	move.w	#(1<<0),ADKCON(a6)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_MODVOL,d1
	beq.s	.chkper
	move.w	#(1<<15)!(1<<0),ADKCON(a6)

	;Check period modulation.  Channel 1 is
	;modulated with channel 2.

.chkper	move.w	#(1<<4),ADKCON(a6)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_MODPER,d1
	beq.s	.chanon
	move.w	#(1<<15)!(1<<4),ADKCON(a6)

	;Turn the channel on so that the sound
	;plays.

.chanon	move.w	#$8001,DMACON(a6)	;Turn channel on. ($8001)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_REPEAT,d1
	bne.s	PS1done
	moveq	#40-1,d1	;d1 = vsync counters to wait - 1
.wait2	move.b	$7(a6),d0	;Waits only about 1.7 scan lines.
.wait3	cmp.b	$7(a6),d0
	beq.s	.wait3
	dbra	d1,.wait2
	move.w	#1<<7,INTREQ(a6)	;Turn off audio interrupt check.
	move.l	#ChipZero,AUD0LC(a6)	;Once audio has recognised us we
	move.w	#2,AUD0LEN(a6)	;point the data to zeros.
PS1done:
	MOVE.L	(SP)+,A6
	move.l	a0,CS1	;ma = Note successful sound.

	;If we need to modulate the sound, we need
	;to play the Paired sound through channel 2.

	move.l	SND_Attrib(a0),d1
	and.l	#SDF_MODVOL|SDF_MODPER,d1
	beq.s	.done
	move.l	SND_Pair(a0),a0
	bsr	Pspi2

.done	moveq	#ERR_OK,d0
	rts

;-----------------------------------------------------------------------------------;
;                                     CHANNEL 2
;-----------------------------------------------------------------------------------;

PSPri2:	lea	ChannelPri(pc),a1	;a1 = Pointer to current priorites.
	lea	$dff000,a6
	btst	#0,INTREQR(a6)	;Test channel - is it in use?  If
	bne.s	Pspi2	;  not, ignore channel priority.
	move.w	2(a1),d1	;d1 = Current sound priority.
	cmp.w	SND_Priority(a0),d1
	bgt.s	PS1done

Pspi2:	move.w	#2,SNDP_LastChannel(a0)	;a0 = Set last channel.
	move.w	SND_Priority(a0),2(a1)	;Store new priority.
	move.w	#$0002,DMACON(a6)	;Turn off channel.
	move.w	#$8000+1<<8,INTREQ(a6)	;Request reset of audio interrupt.
	moveq	#80-1,d1	;d1 = vsync counters to wait.
.wait0	move.b	$7(a6),d0	;Waits about 3.4 scan lines.
.wait1	cmp.b	$7(a6),d0
	beq.s	.wait1
	dbra	d1,.wait0
	move.l	SND_Data(a0),AUD1LC(a6)
	move.l	SND_Length(a0),d0
	lsr.l	#1,d0
	move.w	d0,AUD1LEN(a6)
	move.w	SND_Octave(a0),d0
	lea	_Octaves,a1
	move.w	(a1,d0.w),AUD1PER(a6)

	lea	_Volumes,a1
	move.w	SND_Volume(a0),d0
	add.w	d0,d0	;d0 = (Volume)*2 [word]
	move.w	(a1,d0.w),AUD1VOL(a6)
	move.w	(a1,d0.w),Chan2Vol

.chkvol	move.w	#(1<<1),ADKCON(a6)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_MODVOL,d1
	beq.s	.chkper
	move.w	#(1<<15)!(1<<1),ADKCON(a6)

.chkper	move.w	#(1<<5),ADKCON(a6)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_MODPER,d1
	beq.s	.chanon
	move.w	#(1<<15)!(1<<5),ADKCON(a6)

.chanon	move.w	#$8002,DMACON(a6)	;Turn channel on. ($8001)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_REPEAT,d1
	bne.s	PS2done
	moveq	#40-1,d1	;d1 = vsync counters to wait - 1
.wait2	move.b	$7(a6),d0	;Waits only about 1.7 scan lines.
.wait3	cmp.b	$7(a6),d0
	beq.s	.wait3
	dbra	d1,.wait2
	move.w	#1<<8,INTREQ(a6)	;Turn off audio interrupt check.
	move.l	#ChipZero,AUD1LC(a6)	;Once audio has recognised us we
	move.w	#2,AUD1LEN(a6)	;point the data to zeros.

PS2done	MOVE.L	(SP)+,A6
	move.l	a0,CS2	;ma = Note successful sound play.

	;If we need to modulate the sound, we have
	;to play the Paired sound through the next channel.

	move.l	SND_Attrib(a0),d1
	and.l	#SDF_MODVOL|SDF_MODPER,d1
	beq.s	.done
	move.l	SND_Pair(a0),a0
	bsr	Pspi3

.done	moveq	#ERR_OK,d0
	rts

;-----------------------------------------------------------------------------------;
;                                     CHANNEL 3
;-----------------------------------------------------------------------------------;

PSPri3:	lea	ChannelPri(pc),a1	;a1 = Pointer to current priorites.
	lea	$dff000,a6
	btst	#1,INTREQR(a6)	;Test channel - is it in use?  If
	bne.s	Pspi3	;  not, ignore channel priority.
	move.w	4(a1),d1	;d1 = Current sound priority.
	cmp.w	SND_Priority(a0),d1
	bgt.s	PS2done

Pspi3:	move.w	#3,SNDP_LastChannel(a0)	;a0 = Set last channel.
	move.w	SND_Priority(a0),4(a1)	;Store new priority.
	move.w	#$0004,DMACON(a6)	;Turn off channel ($0001)
	move.w	#$8000+1<<9,INTREQ(a6)	;Request reset of audio interrupt.
	moveq	#80-1,d1	;d1 = vsync counters to wait.
.wait0	move.b	$7(a6),d0	;Waits about 3.4 scan lines.
.wait1	cmp.b	$7(a6),d0
	beq.s	.wait1
	dbra	d1,.wait0
	move.l	SND_Data(a0),AUD2LC(a6)
	move.l	SND_Length(a0),d0
	lsr.l	#1,d0
	move.w	d0,AUD2LEN(a6)
	move.w	SND_Octave(a0),d0
	lea	_Octaves,a1
	move.w	(a1,d0.w),AUD2PER(a6)

	lea	_Volumes,a1
	move.w	SND_Volume(a0),d0
	add.w	d0,d0	;d0 = (Volume)*2 [word]
	move.w	(a1,d0.w),AUD2VOL(a6)
	move.w	(a1,d0.w),Chan3Vol

.chkvol	move.w	#(1<<2),ADKCON(a6)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_MODVOL,d1
	beq.s	.chkper
	move.w	#(1<<15)!(1<<2),ADKCON(a6)

.chkper	move.w	#(1<<6),ADKCON(a6)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_MODPER,d1
	beq.s	.chanon
	move.w	#(1<<15)!(1<<6),ADKCON(a6)

.chanon	move.w	#$8004,DMACON(a6)	;Turn channel on. ($8001)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_REPEAT,d1
	bne.s	PS3done
	moveq	#40-1,d1	;d1 = vsync counters to wait - 1
.wait2	move.b	$7(a6),d0	;Waits only about 1.7 scan lines.
.wait3	cmp.b	$7(a6),d0
	beq.s	.wait3
	dbra	d1,.wait2
	move.w	#1<<9,INTREQ(a6)	;Turn off audio interrupt check.
	move.l	#ChipZero,AUD2LC(a6)	;Once audio has recognised us we
	move.w	#2,AUD2LEN(a6)	;point the data to zeros.
PS3done	MOVE.L	(SP)+,A6
	move.l	a0,CS3	;ma = Note successful sound play.

	;If we need to modulate the sound, we have
	;to play the Paired sound through the next channel.

	move.l	SND_Attrib(a0),d1
	and.l	#SDF_MODVOL|SDF_MODPER,d1
	beq.s	.done
	move.l	SND_Pair(a0),a0
	bsr	Pspi4

.done	moveq	#ERR_OK,d0
	rts

;-----------------------------------------------------------------------------------;
;                                     CHANNEL 4
;-----------------------------------------------------------------------------------;
;Note: Channel 4 cannot modulate anything.

PSPri4:	lea	ChannelPri(pc),a1	;a1 = Pointer to current priorites.
	lea	$dff000,a6
	btst	#2,INTREQR(a6)	;Test channel - is it in use?  If
	bne.s	Pspi4	;  not, ignore channel priority.
	move.w	6(a1),d1	;d1 = Current sound priority.
	cmp.w	SND_Priority(a0),d1
	bgt.s	PS3done

Pspi4:	move.w	#4,SNDP_LastChannel(a0)	;a0 = Set last channel.
	move.w	SND_Priority(a0),6(a1)	;Store new priority.
	move.w	#$0008,DMACON(a6)	;Turn off channel ($0001)
	move.w	#$8000+1<<10,INTREQ(a6)	;Request reset of audio interrupt.
	moveq	#80-1,d1	;d1 = vsync counters to wait.
.wait0	move.b	$7(a6),d0	;Waits about 3.4 scan lines.
.wait1	cmp.b	$7(a6),d0
	beq.s	.wait1
	dbra	d1,.wait0
	move.l	SND_Data(a0),AUD3LC(a6)
	move.l	SND_Length(a0),d0
	lsr.l	#1,d0
	move.w	d0,AUD3LEN(a6)
	move.w	SND_Octave(a0),d0	;d0 = Octave number.
	lea	_Octaves,a1
	move.w	(a1,d0.w),AUD3PER(a6)

	lea	_Volumes,a1
	move.w	SND_Volume(a0),d0	;d0 = Volume
	add.w	d0,d0	;d0 = (Volume)*2 [word]
	move.w	(a1,d0.w),AUD3VOL(a6)
	move.w	(a1,d0.w),Chan4Vol

	move.w	#$8008,DMACON(a6)	;Turn channel on. ($8001)
	move.l	SND_Attrib(a0),d1
	btst	#SDB_REPEAT,d1
	bne.s	PS4done
	moveq	#40-1,d1	;d1 = vsync counters to wait - 1
.wait2	move.b	$7(a6),d0	;Waits only about 1.7 scan lines.
.wait3	cmp.b	$7(a6),d0
	beq.s	.wait3
	dbra	d1,.wait2
	move.w	#1<<10,INTREQ(a6)	;Turn off audio interrupt check.
	move.l	#ChipZero,AUD3LC(a6)	;Once audio has recognised us we
	move.w	#2,AUD3LEN(a6)	;point the data to zeros.

PS4done	MOVE.L	(SP)+,A6
	move.l	a0,CS4	;ma = Note successful sound play.
	moveq	#ERR_OK,d0
	rts

;===================================================================================;
;                               STOP SOUND
;===================================================================================;
;Function: void Deactivate(*Sound [a0])
;Short:    Stops a Sound from playing any further.  All we are really doing is
;	   changing the volume to zero though :-)

_SND_Deactivate:
	move.w	SNDP_LastChannel(a0),d0	;d0 = Last channel.
	add.w	d0,d0	;d0 = *2
	add.w	d0,d0	;d0 = *4
	lea	ChannelSounds(pc),a1	;a1 = &ChannelSounds array.
	cmp.l	(a1,d0.w),a0	;a0 = Our sound still in play?
	bne.s	.notplaying	;>> = Someone else is in the channel.
	move.l	VolTable(pc,d0.w),a1	;d0 = Volume hardware address.
	move.w	#0,(a1)	;a1 = Set the audio volume to 0.
.notplaying
	rts

VolTable:
	dc.l	$dff000+AUD0VOL	;0 [Not relevant]
	dc.l	$dff000+AUD0VOL	;1
	dc.l	$dff000+AUD1VOL	;2
	dc.l	$dff000+AUD2VOL	;3
	dc.l	$dff000+AUD3VOL	;4

;===================================================================================;
;                            STOP ALL CHANNELS
;===================================================================================;
;Function: void StopAudio(void)
;Short:    Stops all the channels so that sound no longer eminates from the
;          speakers.  NB: This function needs to support stopping of music objects.

_LIBStopAudio:
	lea	$dff000,a1
	lea	ChipZero,a0
	move.l	a0,AUD0LC(a1)
	move.l	a0,AUD1LC(a1)
	move.l	a0,AUD2LC(a1)
	move.l	a0,AUD3LC(a1)
	move.w	#2,AUD0LEN(a1)
	move.w	#2,AUD1LEN(a1)
	move.w	#2,AUD2LEN(a1)
	move.w	#2,AUD3LEN(a1)
	move.w	#0,AUD0VOL(a1)
	move.w	#0,AUD1VOL(a1)
	move.w	#0,AUD2VOL(a1)
	move.w	#0,AUD3VOL(a1)
	rts

;===================================================================================;
;                        CHECK IF SOUND IS CURRENTLY PLAYING
;===================================================================================;
;Function: LONG CheckSound(*Sound [a0])
;Result:   Returns NULL (FALSE) if not playing.
;Short:    This routine will check to see if someone else is playing in the given
;          Sound's channel.  If there is, we have obviously been pushed out of play.

_LIBCheckSound:
	move.w	SNDP_LastChannel(a0),d0	;d0 = Last channel.
	beq.s	.noplay	;>> = No last channel.
	move.w	d0,d1	;d1 = Channel.
	add.w	d0,d0	;d0 = *2
	add.w	d0,d0	;d0 = *4
	lea	ChannelSounds(pc),a1	;a1 = &ChannelSounds array.
	cmp.l	(a1,d0.w),a0	;a0 = Our sound still in play?
	bne.s	.noplay	;>> = Someone else is in the channel.

	;Now check the channel hardware.

	add.w	#6,d1	;d1 = (ChanNum)+6
	move.w	$dff000+INTREQR,d0	;d0 = INTREQR
	btst	d1,d0	;d0 = Check channel bit.
	bne.s	.noplay	;>> = Not playing.
	moveq	#$01,d0	;d0 = Sound is playing, return 1.
	rts

.noplay	moveq	#$00,d0	;d0 = Not playing.
	rts

;===================================================================================;
;                        CHANGE VOLUME OF CHANNEL
;===================================================================================;
;Function: LONG SetVolume(*Sound [a0], WORD Volume [d0])
;Short:    Sets a new volume for a sound.
;Result:   Returns the old volume.

_LIBSetVolume:
	move.w	SND_Volume(a0),-(SP)	;SP = Save the current volume to the stack.
	cmp.w	#101,d0	;d0 = Check the range.
	bcc.s	.exit	;>> = Out of range, exit.
	move.w	d0,SND_Volume(a0)	;a0 = Set volume change.
	move.w	SNDP_LastChannel(a0),d1	;d1 = Channel we are playing through.
	add.w	d1,d1	;d1 = ChanNum*2 [word]
	add.w	d1,d1	;d1 = ChanNum*2 [word]
	move.l	.VolTab(pc,d1.w),a1	;a1 = $Volume
	lea	_Volumes,a0	;a0 = $VolumeTable
	add.w	d0,d0	;d0 = (Volume)*2 [word]
	move.w	(a0,d0.w),(a1)	;a1 = Convert volume and insert.
.exit	move.w	(SP)+,d0	;d0 = Return the old volume.
	rts

.VolTab	dc.l	$dff000+AUD0VOL	;Actually illegal.
	dc.l	$dff000+AUD0VOL
	dc.l	$dff000+AUD1VOL
	dc.l	$dff000+AUD2VOL
	dc.l	$dff000+AUD3VOL

;===================================================================================;
;                                  DATA
;===================================================================================;

ChannelPri:	dc.w  0,0,0,0	;0,1,2,3

;-----------------------------------------------------------------------------------;
;This array points to each Sound that last played through the available channels.

ChannelSounds:	dc.l  0	;Null.
CS1:		dc.l  0
CS2:		dc.l  0
CS3:		dc.l  0
CS4:		dc.l  0

Chan1Vol:	dc.w  0
Chan2Vol:	dc.w  0
Chan3Vol:	dc.w  0
Chan4Vol:	dc.w  0

;-----------------------------------------------------------------------------------;

AUD_Name:	dc.b  "audio.device",0
		even

AudioDevOpen:	dc.b  0
SigBitNum:	dc.b  -1

AllocPort:	dc.l  0,0	;succ, pred
		dc.b  4,0	;NT_MSGPORT
		dc.l  0	;name
		dc.b  0,0	;flags = PA_SIGNAL
		dc.l  0	;task
ReqList:	dc.l  0,0,0	;list head, tail and tailpred
		dc.b  5,0
		even

AllocReq:	dc.l  0,0
		dc.b  0,127	;NT_UNKNOWN, use maximum priority (127)
		dc.l  0,AllocPort	;name, replyport
		dc.w  68	;length
		dc.l  0	;io_Device
		dc.l  0	;io_Unit
		dc.w  0	;io_Command
		dc.b  0,0	;io_Flags, io_Error
		dc.w  0	;ioa_AllocKey
		dc.l  sttempo	;ioa_Data
		dc.l  1	;ioa_Length
		dc.w  0,0,0	;ioa_Period, Volume, Cycles
		dc.w  0,0,0,0,0,0,0,0,0,0	;ioa_WriteMsg

;These values are the SoundTracker tempos (approx).

sttempo:	dc.w  $0f00

;===================================================================================;
;                                CHIP DATA
;===================================================================================;

	SECTION	EmptyData,DATA_C

ChipZero:
	dc.l	0,0

;-----------------------------------------------------------------------------------;
EndCode

