
;---;  conreadpkt.r  ;---------------------------------------------------------
*
*	****	CONSOLE READING BY SENDING PACKETS    ****
*
*	Author		Stefan Walter
*	Version		1.01
*	Last Revision	04.04.93
*	Identifier	crp_defined
*       Prefix		crp_	(console read with packets)
*				 ¯       ¯         ¯
*	Functions	InitConRead, ResetConRead, SendConRead, ExaminePacket
*
*	NOTE:	These routines have been collected because AmigaDOS does not
*		provide comfortable read functions which can wait on additional
*		signals.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	crp_defined
crp_defined	=1

;------------------
crp_oldbase	equ __base
	base	crp_base
crp_base:

;------------------

;------------------------------------------------------------------------------
*
* InitConRead	Initialize packet sending. Open port and get packet.
*
* INPUT		d0	CON handle.
*
* RESULT:	d0	Packet or 0.
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
InitConRead:

;------------------
; Start.
;
\start:
	movem.l	d1-a6,-(sp)
	lea	crp_base(pc),a4
	lsl.l	#2,d0
	move.l	d0,crp_handle(a4)

;------------------
; Get port.
;
\openport:
	lea	crp_port(pc),a0
	bsr	MakePort
	beq.s	\done

;------------------
; Get packet.
;
\getpacket:
	bsr	AllocPacket
	beq.s	\error
	move.l	d0,crp_packet(a4)
	clr.b	crp_sent(a4)		;no packet on the way
	clr.w	crp_offset(a4)
	bra.s	\done

;------------------
; Error => close port.
;
\error:
	lea	crp_port(pc),a0
	bsr	UnMakePort
	moveq	#0,d0

;------------------
; Done.
;
\done:
	tst.l	d0
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* SendConRead	Send the read packet if it's not on the way. A read with length
*		1 is sent, ExaminePacket will read a line using this.
*
* RESULT:	d0	-1 if okay, 0 if packet already on the way.
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
SendConRead:

;------------------
; Start.
;
\start:
	movem.l	d1-a6,-(sp)
	lea	crp_base(pc),a4
	moveq	#0,d0
	tst.b	crp_sent(a4)
	bne.s	\done

;------------------
; Fill in packet.
;
\fill:
	move.l	crp_packet(pc),a0
	pea	crp_temp(pc)
	moveq	#82,d3
	move.l	d3,8(a0)		;READ!
	move.l	(sp)+,24(a0)		;Buffer
	moveq	#1,d3
	move.l	d3,28(a0)		;Length
	move.l	crp_handle(pc),a1
	move.l	36(a1),20(a0)		;Arg1 from filehandle

;------------------
; Send packet.
;
\send:
	move.l	a0,d1
	move.l	8(a1),d2		;port of CON:
	pea	crp_port(pc)
	move.l	(sp)+,d3
	bsr	SendPacket
	st.b	crp_sent(a4)
	moveq	#-1,d0

;------------------
; Done.
;
\done:
	tst.l	d0
	movem.l	(sp)+,d1-a6
	rts
	
;------------------

;------------------------------------------------------------------------------
*
* ResetConRead	Reset packet sending. Free dos object and remove port.
*
;------------------------------------------------------------------------------

;------------------
ResetConRead:

;------------------
; Start.
;
\start:
	movem.l	d0-a6,-(sp)
       	move.l	crp_packet(pc),d0	;no packet installed?
	beq.s	\exit

	move.b	crp_sent(pc),d0		;is it on the way?
	beq.s	\nowait
	pea	crp_port(pc)
	move.l	(sp)+,d0
	bsr	WaitForPacket

\nowait:
       	move.l	crp_packet(pc),d0
	bsr	FreePacket
	lea	crp_port(pc),a0
	bsr	UnMakePort

;------------------
; exit
;
\exit:
	movem.l	(sp)+,d0-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* ExaminePacket	Wait for our packet to return and get all text until the next
*		CR to the buffer.
*
* RESULT:	a0	Text if d0>=0, zeroterminated.
*		d0	Length (a0+d0=pointer on zero), -1 if EOF
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
ExaminePacket:

;------------------
; Start.
;
\start:
	movem.l	d1-d7/a1-a6,-(sp)

;------------------
; Loop.
;
\loop:
	pea	crp_port(pc)
	move.l	(sp)+,d0
	bsr	WaitForPacket
	lea	crp_sent(pc),a1
	clr.b	(a1)

;------------------
; Get that damn Packet.
;
\packet:
	move.l	d0,a1
	move.l	24(a1),a0
	move.l	12(a1),d0
	beq.s	\close
	move.b	(a0),d1
	lea	crp_buffer(pc),a0
	moveq	#0,d0
	lea	crp_offset(pc),a2
	move.w	(a2),d0	
	cmp.b	#$a,d1
	beq.s	\cr
	cmp.w	#200,d0
	beq.s	\no
	move.b	d1,(a0,d0)
	addq.w	#1,d0
\no:
	move.w	d0,(a2)
	bsr	SendConRead
	bra.s	\loop

;------------------
; This one was CR.
;
\cr:
	clr.w	(a2)		;clear offset for next line
	clr.b	(a0,d0)
	tst.w	d0
	bra.s	\done

;------------------
; Close gadget hit...
;
\close:
	moveq	#-1,d0

;------------------
; Done.
;
\done:
	movem.l	(sp)+,d1-d7/a1-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
	include	doslib.r
	include	ports.r
	include	structs.r
	include	packets.r

;------------------
; The port.
;
crp_port	PortStruct_

;------------------
; Data.
;
crp_packet:	dc.l	0
crp_sent:	dc.b	0
crp_temp:	dc.b	0
crp_offset:	dc.w	0
crp_handle:	dc.l	0

	ifd	cio_readbuffer
crp_buffer	equ	cio_readbuffer
	else
crp_buffer:	ds.b	202,0
	endif

;------------------

;--------------------------------------------------------------------

;------------------
	base	crp_oldbase

;------------------
	endif

 end

