
		IFEQ A-CIAchip
_cia		= $bfe001
control		= _cia+ciacra
		ELSE
_cia		= $bfd000
control		= _cia+ciacrb
		ENDC

		IFEQ A-TIMER
timerlo		= _cia+ciatalo
timerhi		= _cia+ciatahi
intbit		= CIAICRB_TA
		ELSE
timerlo		= _cia+ciatblo
timerhi		= _cia+ciatbhi
intbit		= CIAICRB_TB
		ENDC




GetCIA		lea.l	cia_name,a1
		CallExec OpenResource
		tst.l	d0
		beq	.error
		move.l	d0,resource

		move.l	resource,a6
		move.l	#intbit,d0
		lea.l	cia_int,a1		; the interrupt
		Call	AddICRVector
		tst.l	d0
		beq	.noerror		

		move.l	d0,a0
		move.l	LN_NAME(a0),d1
		CallDos	PutStr
		Print	< is already using my CIA timer!>
		bra	.error
.noerror
		move.w	#MicroTiming,d0
		move.b	d0,timerlo
		lsr.w	#8,d0
		move.b	d0,timerhi

		bclr.b	#CIACRAB_RUNMODE,control
		or.b	#CIACRAF_LOAD|CIAICRF_TA,control

		move.w	#1<<intbit,d0
		move.l	resource,a6
		Call	SetICR

		move.w	#CIAICRF_SETCLR|(1<<intbit),d0
		move.l	resource,a6
		Call	AbleICR

		; the interrupt is now up and running!

		clr.l	d0
		rts
.error		move.l	#20,d0
		rts


FreeCIA		move.l	resource,a6
		move.w	#1<<intbit,d0
		Call	AbleICR

		bclr.b	#CIACRAB_START,control

		move.l	resource,a6
		move.l	#intbit,d0
		lea.l	cia_int,a1		; the interrupt
		Call	RemICRVector
		rts

*-------------------------------------------------------*
*		       Data				*
*-------------------------------------------------------*

resource	dc.l	0

		IFEQ	A-CIAchip
cia_name	dc.b	'ciaa.resource',0
		ELSE
cia_name	dc.b	'ciab.resource',0
		ENDC

cia_int		dc.l	0,0		; LN_SUCC, LN_PRED
		dc.b	NT_INTERRUPT	; TYPE
		dc.b	127		; Priority, for sorting
		dc.l	int_name	; ID string, null terminated
		dc.l	0		; IS_DATA
		dc.l	cia_Interrupt	; IS_CODE
int_name	dc.b	"dFX cia-interrupt",0
		even
