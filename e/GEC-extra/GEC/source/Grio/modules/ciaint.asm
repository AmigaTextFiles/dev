
OpenResource            =       -498
AddICRVector            =       -6
RemICRVector            =       -12


ciatalo         =       $400
ciatahi         =       $500
ciatblo         =       $600
ciatbhi         =       $700
ciacra          =       $e00
ciacrb          =       $f00


	XDEF	setCIAInt_code_name


setCIAInt_code_name
	move.l	8(a7),IntCode
	move.l	4(a7),IntName
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


	XDEF	remCIAInt

remCIAInt
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

	XDEF	setCIATempo_tempo

setCIATempo_tempo
	move.l	4(a7),d0
	cmp.l	#255,d0
	bls.s	SetTempo
	moveq	#0,d0
	rts
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
IntName	dc.l 0,0
	dc.l MusicInt

IntCode
	dc.l	0

MusicInt
	movem.l	d0-d7/a0-a6,-(a7)
	move.l	Tempo(pc),d0
	bsr.s	SetTempo
	move.l	IntCode(pc),d0
	beq.s	.zero
	move.l	d0,a6
	jsr	(a6)
.zero	movem.l	(a7)+,d1-d7/a0-a6
	rts
	




