
;---;  ports.r  ;--------------------------------------------------------------
*
*	****	PORTS, SIGNAL AND MESSAGES HANDLING    ****
*
*	Author		Stefan Walter
*	Version		1.05
*	Last Revision	28.12.93
*	Identifier	psm_defined
*       Prefix		psm_	(ports, signals and messages)
*				 ¯      ¯           ¯
*	Functions	MakePort, UnMakePort
*			SendReplyMSG, WaitAndGetMSG, ReplyMSG
*
*	Flags		psm_MESSAGES set 1 if MSG routines too.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	psm_defined
psm_defined	=1

;------------------

	include	"basicmac.r"

;------------------------------------------------------------------------------
*
* MakePort	Open and init a port and allocate a signal bit. If port
*		has a name, it goes to the public port list, else not.
*
* INPUT		a0	Port structure.
*
* RESULT	d0	Port structure or 0 if error.
*		ccr	on d0.
*
;------------------------------------------------------------------------------

;------------------
MakePort:

;------------------
; Allocate a signal bit and add port.
;
\alloc:
	movem.l	d1-a6,-(sp)
	move.l	a0,a4
	move.l	4.w,a6
	moveq	#-1,d0
	jsr	-330(a6)		;AllocSignal()
	move.b	d0,15(a4)		;signal bit...
	bmi.s	\error

	moveq	#0,d1
	bset	d0,d1
	moveq	#0,d0
	jsr	-306(a6)		;SetSignals()

	move.l	$114(a6),16(a4)		;set SigTask
	lea	20(a4),a0
	move.l	a0,(a0)			;init message list
	addq.l	#4,(a0)			;
	clr.l	4(a0)			;
	move.l	a0,8(a0)		;

	tst.l	10(a4)
	beq.s	\fine
	move.l	a4,a1
	jsr	-354(a6)		;AddPort()

\fine:
	move.l	a4,d0

\done:
	tst.l	d0
	movem.l	(sp)+,d1-a6
	rts

\error:
	moveq	#0,d0
	bra.s	\done

;------------------

;------------------------------------------------------------------------------
*
* UnMakePort	Remove a port from the public port list and free the signal.
*
* INPUT		a0	Port structure.
*
;------------------------------------------------------------------------------

;------------------
UnMakePort:

;------------------
; Free port.
;
\free:
	movem.l	d0-a6,-(sp)
	move.l	4.w,a6
	move.l	a0,a4
	move.l	a0,d0
	beq.s	\done
	moveq	#0,d0
	move.b	15(a4),d0
	jsr	-336(a6)		;FreeSignal()
	tst.l	10(a4)
	beq.s	\done	
	move.l	a4,a1
	jsr	-360(a6)		;RemPort()

\done:
	movem.l	(sp)+,d0-a6
	rts

;------------------
	ifd	psm_MESSAGES
	NEED_	SendReplyMSG
	NEED_	WaitAndGetMSG
	NEED_	ReplyMSG
	endif

;------------------

;------------------------------------------------------------------------------
*
* SendReplyMSG	Send a replyable message to a port.
*
* INPUT		a0	Destination port.
*		a1	Message.
*		a2	Reply port.
*
;------------------------------------------------------------------------------
	IFD	xxx_SendReplyMSG
;------------------
SendReplyMSG:

;------------------
; Send it.
;
\send:
	movem.l	d0-a6,-(sp)
	move.l	a2,14(a1)
	move.l	4.w,a6
	jsr	-366(a6)		;PutMSG()
	movem.l	(sp)+,d0-a6
	rts

	ENDC
;------------------

;------------------------------------------------------------------------------
*
* WaitAndGetMSG	Wait for messages and get the first one.
*
* INPUT		a0	Port.
*
* RESULT	a0	Message.
*
;------------------------------------------------------------------------------
	IFD	xxx_WaitAndGetMSG
;------------------
WaitAndGetMSG:

;------------------
; Wait.
;
\wait:
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a0,a5
	move.l	4.w,a6
	jsr	-384(a6)		;WaitPort()
	move.l	a5,a0
	jsr	-372(a6)
	move.l	d0,a0
	movem.l	(sp)+,d0-d7/a1-a6
	rts

	ENDC
;------------------

;------------------------------------------------------------------------------
*
* ReplyMSG	Reply a message.
*
* INPUT		a0	Message.
*
;------------------------------------------------------------------------------
	IFD	xxx_ReplyMSG
;------------------
ReplyMSG:

;------------------
; Do it.
;
\do:
	movem.l	d0-a6,-(sp)
	move.l	a0,a1
	move.l	4.w,a6
	jsr	-378(a6)		;WaitPort()
	movem.l	(sp)+,d0-a6
	rts

	ENDC
;------------------
	endif

;------------------

;--------------------------------------------------------------------

;------------------

 end

