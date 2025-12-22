
;---;  extmsg.r  ;-------------------------------------------------------------
*
*	****	EXTERNAL MSG ROUTINES    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	19.07.92
*	Identifier	exm_defined
*       Prefix		exm_	(external messages)
*				 ¯¯       ¯
*	Functions	XAllocMSG, XFreeMSG, XSendMSG, XOpenPort, XClosePort
*
*	NOTE:	This include file provides the message routines for stuff
*		like snooping of a library vector which sends a message
*		to the control task. The other task calls XAllocMSG() with
*		a number of additional bytes to alloc for data, fills in the
*		data and calls XSendMSG to send it to a port. Voila.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	exm_defined
exm_defined	=1

;------------------
exm_oldbase	equ __base
	base	exm_base
exm_base:

;------------------

;------------------------------------------------------------------------------
*
* XAllocMSG	Allocates a message struct with extension.
*
* INPUT		d0	Number of bytes to be allocated additionally
*
* RESULT	d0	Address of message or 0 if no memory available
*		CCR	On d0
*
;------------------------------------------------------------------------------

;------------------
XAllocMSG:

;------------------
; Allocate the messy.
;
\alloc:
	movem.l	d1-a6,-(sp)
	add.w	#20,d0
	move.w	d0,d7
	move.l	#$10001,d1
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	tst.l	d0
	beq.s	\done			;No go!
	move.l	d0,a0
	move.w	#$500,8(a0)
	move.w	d7,18(a0)
\done:
	tst.l	d0
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* XFreeMSG	Frees a message previously allocated with XAllocMSG.
*
* INPUT		d0	Message
*
;------------------------------------------------------------------------------

;------------------
XFreeMSG:

;------------------
; Free the messy.
;
\free:
	movem.l	d0-a6,-(sp)
	move.l	d0,a1
	moveq	#0,d0
	move.w	18(a1),d0
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()
	movem.l	(sp)+,d0-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* XSendMSG	Send a message to a port.
*
* INPUT		a0	Port
*		a1	Message	
*
;------------------------------------------------------------------------------

;------------------
XSendMSG:

;------------------
; Send.
;
\free:
	movem.l	d0-a6,-(sp)
	move.l	4.w,a6
	jsr	-366(a6)		;PutMsg()
	movem.l	(sp)+,d0-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
	include	ports.r
XOpenPort	=	MakePort
XClosePort	=	UnMakePort

;------------------

;--------------------------------------------------------------------

;------------------
	base	exm_oldbase

;------------------
	endif

 end

