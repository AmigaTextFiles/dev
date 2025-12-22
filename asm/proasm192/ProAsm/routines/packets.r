
;---;  packets.r  ;------------------------------------------------------------
*
*	****	DOS PACKET HANDLING    ****
*
*	Author		Stefan Walter
*	Version		1.02
*	Last Revision	04.04.93
*	Identifier	dph_defined
*	Prefix		dph_	(DOS packet handling)
*				 ¯   ¯      ¯
*	Functions	AllocPacket, SendPacket, WaitForPacket, ReplyPacket
*			FreePacket
*
;------------------------------------------------------------------------------

;------------------
	ifnd	dph_defined
dph_defined	=1

;------------------

;------------------------------------------------------------------------------
*
* AllocPacket	Allocate a packet structure and init it. Use V36 AllocDosObject
*		or make it on your own.
*
* RESULT:	d0	APTR Packet or 0 if error.
*		ccr	on d0.
*
;------------------------------------------------------------------------------

;------------------
AllocPacket:

;------------------
; Init.
;
\start:
	movem.l	d1-a6,-(sp)
	moveq	#0,d7
	bsr	OpenDosLib
	beq.s	\exit

;------------------
; Test version of dos.library.
;
\testdos:
	move.b	dlb_dosver(pc),d1
	beq.s	\kick13

;------------------
; Allocate dos object (3=packet).
;
\kick20:
	moveq	#3,d1
	jsr	-228(a6)		;AllocDosObject()
	tst.l	d0
	beq.s	\close
	move.l	d0,d7
	bra.s	\close

;------------------
; Init 1.2/1.3 packet.
;
\kick13:
	moveq	#$44,d0
	move.l	#$10001,d1
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	tst.l	d0
	beq.s	\close
	move.l	d0,a0
	lea	$14(a0),a1
	move.l	a1,$a(a0)		;link packet to msg
	move.l	a0,(a1)			;link msg to packet
	move.l	a1,d7

;------------------
; Installation done.
;
\close:
	bsr	CloseDosLib

\exit:
	move.l	d7,d0
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* FreePacket	Free a previously allocated packet.
*
* INPUT:	d0	APTR Packet.
*
;------------------------------------------------------------------------------

;------------------
FreePacket:

;------------------
; Init.
;
\start:
	movem.l	d0-a6,-(sp)
	move.l	d0,a0
	bsr	OpenDosLib
	beq.s	\exit
	move.l	(a0),d2

;------------------
; Test version of dos.library.
;
\testdos:
	move.b	dlb_dosver(pc),d1
	beq.s	\kick13

;------------------
; FreeDosObject().
;
\kick20:
	moveq	#3,d1
	move.l	a0,d2
	jsr	-234(a6)		;FreeDosObject()
	bra.s	\close

;------------------
; Free on our own.
;
\kick13:
	move.l	d2,a1
	moveq	#$44,d0
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()

;------------------
; Done.
;
\close:
	bsr	CloseDosLib

\exit:
	movem.l	(sp)+,d0-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* SendPacket	Send a packet to a port but do not wait. The type and
*		argument fields must be already set.
*
* INPUT:	d1	APTR Packet.
*		d2	Destination Port.
*		d3	ReplyPort (our own).
*
;------------------------------------------------------------------------------

;------------------
SendPacket:
	
;------------------
; Init.
;
\start:
	movem.l	d0-a6,-(sp)
	bsr	OpenDosLib
	beq.s	\exit

;------------------
; Test version of dos.library.
;
\testdos:
	move.b	dlb_dosver(pc),d0
	beq.s	\kick13

;------------------
; Use SendPkt().
;
\kick20:
	jsr	-246(a6)		;SendPkt()
	bra.s	\close

;------------------
; Send it on our own.
;
\kick13:
	move.l	d1,a0
	move.l	(a0),a1			;=>msg
	move.l	d3,14(a1)		;remember reply port
	move.l	d3,4(a0)		;again
	move.l	d2,a0			;=>port
	move.l	4.w,a6
	jsr	-$16e(a6)		;PutMsg()

;------------------
; Done.
;
\close:
	bsr	CloseDosLib

\exit:
	movem.l	(sp)+,d0-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* WaitForPacket	Wait for a packet on a port and return packet.
*
* INPUT:	d0	Port to wait on.
*
* RESULT:	d0	Packet.
*
;------------------------------------------------------------------------------

;------------------
WaitForPacket:
	
;------------------
; Do it.
;
\start:
	movem.l	d1-a6,-(sp)
	move.l	4.w,a6
	move.l	d0,a2
\wait:
	move.l	a2,a0
	jsr	-$180(a6)		;WaitPort
	move.l	a2,a0
	jsr	-$174(a6)		;GetMsg()
	tst.l	d0
	beq.s	\wait
	move.l	d0,a0
	move.l	10(a0),d0		;packet
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* ReplyPacket	Reply a previously recieved packet.
*
* INPUT:	d1	APTR Packet.
*		d2	Our port.
*
;------------------------------------------------------------------------------

;------------------
ReplyPacket:
	
;------------------
; Do it.
;
\start:
	move.l	a0,-(sp)
	move.l	d1,a0
	move.l	d2,d3
	move.l	4(a0),d2
	move.l	(sp)+,a0
	bra	SendPacket

;------------------

;--------------------------------------------------------------------

;------------------
	include	doslib.r

;--------------------------------------------------------------------

;------------------
	endif

	end

