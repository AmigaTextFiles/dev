;CardReset.source VER: 3.0 (26.07.2002)


	INCDIR	"Include:"

	INCLUDE	"exec/nodes.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"exec/interrupts.i"
	INCLUDE	"dos/dos.i"
	INCLUDE	"resources/card.i"


_LVOOpenLibrary		EQU	-552
_LVOCloseLibrary	EQU	-414
_LVOOpenResource	EQU	-498
_LVOAllocEntry		EQU	-222
_LVOFreeEntry		EQU	-228
_LVODisable		EQU	-120
_LVOEnable		EQU	-126

_LVOReadArgs		EQU	-798
_LVOFreeArgs		EQU	-858
_LVODelay		EQU	-198

_LVOOwnCard		EQU	-6
_LVOReleaseCard		EQU	-12


CardResetCode:

		movea.l	4.w,a6
		move.l	a6,d7			;d7=ExecBase

		moveq	#RETURN_ERROR,d4
		lea	.dosname(pc),a1
		moveq	#36,d0
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,d6			;d6=DosBase
		beq.w	.end

		lea	.cardname(pc),a1
		jsr	_LVOOpenResource(a6)
		move.l	d0,d5			;d5=CardBase
		beq.w	.dosclose
		moveq	#RETURN_OK,d4

		movea.l	d6,a6
		lea	.template(pc),a0
		move.l	a0,d1
		lea	.ticks(pc),a5		;a5=ReadArgs Array
		move.l	a5,d2
		moveq	#0,d3
		jsr	_LVOReadArgs(a6)

		moveq	#15,d3
		move.l	d0,d1
		beq.s	.default

		tst.l	(a5)
		beq.s	.freeargs

		movea.l	(a5),a0
		move.l	(a0),d3
		moveq	#50,d0
		cmp.l	d0,d3
		ble.s	.freeargs
		move.l	d0,d3

.freeargs	jsr	_LVOFreeArgs(a6)

.default	tst.l	d3			;d3=TICKS
		ble.w	.audio

		moveq	#RETURN_FAIL,d4
		suba.l	a3,a3
		suba.l	a4,a4
		movea.l	d7,a6
		lea	.memlist(pc),a0
		jsr	_LVOAllocEntry(a6)
		btst.l	#31,d0
		bne.w	.dosclose
		moveq	#RETURN_OK,d4

		movea.l	d0,a4			;a4=MemList
		movea.l	ML_SIZE+ME_ADDR(a4),a2
		lea	.ownname(pc),a0
		move.l	a0,LN_NAME(a2)

		movea.l	ML_SIZE+ME_SIZE+ME_ADDR(a4),a0
		lea	.intcode(pc),a1
		move.l	a1,IS_CODE(a0)
		move.l	a0,cah_CardRemoved(a2)

		movea.l	ML_SIZE+2*ME_SIZE+ME_ADDR(a4),a0
		move.l	a1,IS_CODE(a0)
		move.l	a0,cah_CardInserted(a2)

		move.b	#CARDF_IFAVAILABLE,cah_CardFlags(a2)

		movea.l	d5,a6
		movea.l	a2,a1
		jsr	_LVOOwnCard(a6)
		tst.l	d0
		bne.s	.forcetst
		movea.l	a2,a3			;a3=CardHandle
		bra.s	.reset

.forcetst	moveq	#RETURN_ERROR,d4
		tst.l	4(a5)
		beq.s	.freeentry
		moveq	#RETURN_WARN,d4

.reset		movea.l	#$DA9000,a2		;GAYLE INTREQ register
		move.b	#$FF,(a2)		;PCMCIA reset start
		movea.l	d6,a6
		move.l	d3,d1
		jsr	_LVODelay(a6)
		move.b	#$FC,(a2)		;PCMCIA reset stop

		move.l	a3,d0
		beq.s	.freeentry
		movea.l	d5,a6
		movea.l	a3,a1
		moveq	#CARDF_REMOVEHANDLE,d0
		jsr	_LVOReleaseCard(a6)

.freeentry	move.l	a4,d0
		beq.s	.audio
		movea.l	d7,a6
		movea.l	a4,a0
		jsr	_LVOFreeEntry(a6)

.audio		cmpi.l	#"BOOL",8(a5)
		beq.s	.intdis

		movea.l	d7,a6
		movea.l	#$DA8000,a0		;GAYLE STATUS register
		jsr	_LVODisable(a6)
		move.b	(a0),d0
		andi.b	#$09,d0
		tst.l	8(a5)
		beq.s	.noaudio
		bset.l	#1,d0
.noaudio	move.b	d0,(a0)
		jsr	_LVOEnable(a6)

.intdis		bclr.b	#3,$DAA000		;GAYLE INTENA register

.dosclose	movea.l	d7,a6
		movea.l	d6,a1
		jsr	_LVOCloseLibrary(a6)

.end		move.l	d4,d0
		rts

		dc.b	"$VER: CardReset 3.0 (26.07.2002) written by ArtPo",0
		even

.dosname	dc.b	"dos.library",0
		even

.template	dc.b	"TICKS/N/K,FORCE/S,AUDIO/T/K",0
		even

.ticks		dc.l	0
		dc.l	0
		dc.l	"BOOL"

.cardname	dc.b	"card.resource",0
		even

.memlist	dcb.b	LN_SIZE,0

		dc.w	3

		dc.l	MEMF_CLEAR!MEMF_PUBLIC
		dc.l	CardHandle_SIZEOF

		dc.l	MEMF_CLEAR!MEMF_PUBLIC
		dc.l	IS_SIZE

		dc.l	MEMF_CLEAR!MEMF_PUBLIC
		dc.l	IS_SIZE

.ownname	dc.b	"CardReset",0
		even

.intcode	rts
