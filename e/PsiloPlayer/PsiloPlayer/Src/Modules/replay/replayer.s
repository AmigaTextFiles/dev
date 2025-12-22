*
* Generic code for music replayers,
*  a little based on the P61 replayer code
*
*   by Petter E. Stokke, Stardate 6600.2
*

	include	exec/funcdef.i
	include	exec/exec_lib.i
	include	exec/interrupts.i
	include	exec/memory.i

LVO	macro
	jsr	_LVO\1(a6)
	endm
LVOEXE	macro
	move.l	4.w,a6
	LVO	\1
	endm


	XDEF	dti_AudioAlloc,dti_AudioFree,dti_StartInt__i,dti_StopInt,dti_SetSpeed__i

*
* dti_AudioAlloc - allocates audio channels, returns TRUE upon success.
*

dti_AudioAlloc	movem.l	d1-a6,-(sp)
		moveq	#-1,d0
		LVOEXE	AllocSignal
		move.b	d0,sigBit
		bmi.s	dti_AudioFree
		lea	audioPort,a1
		move.l	a1,aPort
		move.b	d0,15(a1)
		move.l	a1,-(sp)
		sub.l	a1,a1
		jsr	-$126(a6)
		move.l	(sp)+,a1
		move.l	d0,16(a1)
		lea	reqList,a0
		move.l	a0,(a0)
		addq.l	#4,(a0)
		clr.l	4(a0)
		move.l	a0,8(a0)
		lea	audioData,a1
		move.l	a1,reqData
		lea	allocReq,a1
		lea	audioname,a0
		moveq	#0,d0
		moveq	#0,d1
		LVO	OpenDevice
		tst.b	d0
		bne.s	dti_AudioFree
		st	audioOpen
		moveq	#-1,d0
		movem.l	(sp)+,d1-a6
		rts

*
* dti_AudioFree - frees audio channels if allocated. Safe to call anytime.
*

dti_AudioFree	movem.l	d1-a6,-(sp)
		move.l	4.w,a6
		tst.b	audioOpen
		beq.s	.1
		lea	allocReq,a1
		jsr	-$1c2(a6)
		clr.b	audioOpen
.1		moveq	#0,d0
		move.b	sigBit,d0
		bmi.s	.end
		LVO	FreeSignal
		st	sigBit
.end		moveq	#0,d0
		movem.l	(sp)+,d1-a6
		rts

*
* dti_StartInt - launches a CIA timer interrupt with the code pointed to
*                by the parameter on the stack. Returns TRUE upon success.
*

dti_StartInt__i	move.l	4(sp),d0
		move.l	d0,intcode
		movem.l	d1-a6,-(sp)
		move.l	4.w,a6
		cmp.b	#60,$213(a6)
		beq.s	.ntsc
		move.l	#1773447,d0
		bra.s	.setcia
.ntsc		move.l	#1789773,d0
.setcia		move.l	d0,timer
		divu	#125,d0
		move.w	d0,thi
.timerset	clr.w	server
		lea	timerint,a1
		move.l	a1,timerdata
		lea	intServer,a1
		move.l	a1,timerdata+8
		moveq	#0,d3
		lea	cianame,a1
.openciares	moveq	#0,d0
		LVO	OpenResource
		move.l	d0,ciares
		beq.s	.err
		move.l	d0,a6
		lea	timerinterrupt,a1
		moveq	#0,d0
		jsr	-6(a6)
		tst.l	d0
		beq.s	.gottimer
		addq.l	#4,d3
		lea	timerinterrupt,a1
		moveq	#1,d0
		jsr	-6(a6)
		tst.l	d0
		bne.s	.err
.gottimer	lea	craddr+8,a6
		lea	ciaaddr,a0
		move.l	(a0,d3),d0
		move.l	d0,(a6)
		sub.w	#$100,d0
		move.l	d0,-(a6)
		moveq	#2,d3
		btst	#9,d0
		bne.s	.timerb
		subq.b	#1,d3
		add.w	#$100,d0
.timerb		add.w	#$900,d0
		move.l	d0,-(a6)
		move.l	d0,a0
		and.b	#%10000000,(a0)
		move.b	d3,timerOpen
		moveq	#-1,d0
		move.l	craddr+4,a1
		move.b	tlo,(a1)
		move.b	thi,$100(a1)
		or.b	#$19,(a0)
		bra.s	.end
.err		moveq	#0,d0
.end		movem.l	(sp)+,d1-a6
		rts

*
* dti_StopInt - stops the timer interrupt if it's running.
*

dti_StopInt	movem.l	d0-a6,-(sp)
		moveq	#0,d0
		move.b	timerOpen,d0
		beq.s	.end
		move.l	ciares,a6
		lea	timerinterrupt,a1
		subq.b	#1,d0
		jsr	-12(a6)
		clr.b	timerOpen
.end		movem.l	(sp)+,d0-a6
		rts

intServer	movem.l	d2-d7/a2-a6,-(sp)
		lea	softInt,a1
		LVOEXE	Cause
		move.l	craddr+4,a0
		move.b	tlo,(a0)
		move.b	thi,$100(a0)
		movem.l	(sp)+,d2-d7/a2-a6
		moveq	#1,d0
		rts

*
* dti_SetSpeed - sets the timer speed to the number of BPM
*                passed on the stack.
*

dti_SetSpeed__i	move.l	4(sp),d0
		movem.l	d1/a1,-(sp)
		move.l	timer(pc),d1
		divu	d0,d1
		move.w	d1,thi
		movem.l	(sp)+,d1/a1
		rts



intName		dc.b	"ProTracker Interrupt Server",0
audioname	dc.b	"audio.device",0
cianame		dc.b	"ciab.resource",0
	even
thi		ds.b	1
tlo		ds.b	1
audioData	dc.w	$0f00
audioPort	dc.l	0,0
		dc.b	4,0
		dc.l	0
		dc.b	0,0
		dc.l	0
reqList		dc.l	0,0,0
		dc.b	5,0
allocReq	dc.l	0,0
		dc.w	127
		dc.l	0
aPort		dc.l	0
		dc.w	68
		dc.l	0,0,0
		dc.w	0
reqData		dc.l	0,1,0,0,0,0,0,0
		dc.w	0
server		dc.w	0
miscbase	dc.l	0
ciares		dc.l	0
craddr		dc.l	0,0,0
timerinterrupt	dc.w	0,0,0,0,127
timerdata	dc.l	0,0,0
timer		dc.l	0
softInt		dc.l	0,0
		dc.b	NT_INTERRUPT,32
		dc.l	intName,0
intcode		dc.l	0
ciaaddr		dc.l	$bfd500,$bfd700
timerint	dc.b	'x',0
sigBit		dc.b	-1
audioOpen	dc.b	0
timerOpen	dc.b	0

