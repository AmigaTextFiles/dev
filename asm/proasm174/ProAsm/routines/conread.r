
;---;  conread.r  ;------------------------------------------------------------
*
*	****	READ FROM CONSOLE AND WAIT FOR OTHER SIGNALS    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	19.06.92
*	Identifier	cor_defined
*       Prefix		cor_	(CON Read)
*				 ¯¯  ¯
*	Functions	InitConRead, ResetConRead, ReadCon, SetConRaw
*
*	Note:	Assumes that base of dos.library is in *dosbase and the flag
*		*dosversion is set if version 36+.
*
*		This routines have been collected because Amiga DOS does not
*		provide comfortable read functions which can wait on additional
*		stuff. At the end, make sure, that no read function is sent
*               when terminating!
*
;------------------------------------------------------------------------------

;------------------
	ifnd	cor_defined
cor_defined	=1

;------------------
cor_oldbase	equ __base
	base	cor_base
cor_base:

;------------------

;------------------------------------------------------------------------------
*
* INITCONREAD	Initializes packet sending. Either inits 1.2/1.3 selfmade
*		packet or allocates dosobject.
*
* RESULT:	d0	0 if failure else <>0
*
;------------------------------------------------------------------------------

;------------------
InitConRead:

;------------------
; Start.
;
\start:
	movem.l	d1-a6,-(sp)
	lea	cor_base(pc),a4

;------------------
; Allocate signal for our port.
;
\alloc:
	move.l	4.w,a6
	suba.l	a1,a1
	jsr	-294(a6)		;FindTask()
	move.l	d0,d7
	moveq	#-1,d0
	jsr	-330(a6)		;AllocSignal()
	move.l	d0,cor_signal(a4)
	bmi	\error

;------------------
; Add port.
;
\add:
	lea	cor_port(pc),a1
	move.l	4.w,a6
	jsr	-354(a6)		;AddPort()

;------------------
; Init port.
;
\initport:
	lea	cor_port(pc),a0
	move.b	cor_signal+3(pc),15(a0)
	move.l	d7,16(a0)
	clr.b	cor_sent(a4)		;no packet on the way

;------------------
; test version of dos.library
;
\testdos:
	move.l	dosbase(pc),a6
	cmp.w	#$24,20(a6)		;V36+ ?
	sge	cor_dosflag(a4)
	blt.s	\nodos20

;------------------
; allocate dos object (3=packet)
;
\isdos20:
	moveq	#3,d1
	jsr	-228(a6)		;AllocDosObject()
	tst.l	d0
	beq.s	\close
	move.l	d0,a0
	moveq	#'R',d1
	move.l	d1,8(a0)		;set type
	bra.s	\exit

;------------------
; init 1.2/1.3 message system mix
;
\nodos20:
	lea	cor_messy(pc),a0
	lea	cor_packet(pc),a1
	move.l	a1,$a(a0)		;packet
	move.l	a0,(a1)			;message
	move.l	a1,d0

;------------------
; installation done
;
\exit:
	move.l	d0,cor_pktptr(a4)
	movem.l	(sp)+,d1-a6
	rts

;------------------
; installation failure
;
\close:
	move.l	cor_signal(pc),d0
	move.l	4.w,a6
	jsr	-336(a6)		;FreeSignal()
	lea	cor_port(pc),a1
	jsr	-360(a6)

\error:
	moveq	#0,d0
	bra.s	\exit

;------------------

;------------------------------------------------------------------------------
*
* READCON	Reads from handler and waits for multiple signals
*
* INPUT:	d0	Mask with signals to wait for too
*		d1	Handler
*		d2	Buffer
*		d3	Length
*
* RESULT:	d0	Read length or 0 if EOF, -1 if error
*		d1	-1 if read valid else 0
*		d2	Mask of signals arrived too
*
;------------------------------------------------------------------------------

;------------------
ReadCon:

;------------------
; start
;
\start:
	movem.l	d3-a6,-(sp)
	lea	cor_base(pc),a4
	move.l	d0,d7
	tst.b	cor_sent(a4)
	bne.s	\getmessy		;packet allready sent

;------------------
; fill in packet
;
\fill:
	move.l	cor_pktptr(pc),a0
	lea	cor_port(pc),a2
	move.l	(a0),a1
	move.l	a2,14(a1)
	move.l	d2,24(a0)		;Buffer
	move.l	d3,28(a0)		;Length
	lsl.l	#2,d1
	move.l	d1,a2
	move.l	8(a2),4(a0)		;Console process ID
	move.l	36(a2),20(a0)		;Arg1 from filehandle
	move.l	a0,d1

;------------------
; switch to right routine
;
\switch:
	tst.b	cor_dosflag(a4)
	beq.s	\nodos20

;------------------
; 2.0 SendPkt()
;
\isdos20:
	move.l	dosbase(pc),a6
	move.l	8(a2),d2
	pea	cor_port(pc)
	move.l	(sp)+,d3
	jsr	-246(a6)		;SendPkt()
	bra.s	\getmessy

;------------------
; use 1.2/1.3 system
;
\nodos20:
	lea	cor_port(pc),a2
	move.l	4(a0),a1
	exg.l	a1,a0
	move.l	a2,4(a1)
	move.l	(a1),a1
	move.l	4.w,a6
	jsr	-$16e(a6)		;PutMsg()

;------------------
; forbid
;
\getmessy:
	st	cor_sent(a4)
	move.l	4.w,a6
	jsr	-132(a6)		;Forbid()

;------------------
; wait for all signals
;
\wait:
	lea	cor_port(pc),a0
	move.b	15(a0),d3
	moveq	#0,d0
	bset	d3,d0
	or.l	d7,d0
	jsr	-318(a6)		;Wait()
	bclr	d3,d0
	beq.s	\noread
	move.l	d0,d5

;------------------
; get our message and check if it is it.
;
\check:
	lea	cor_port(pc),a0
	jsr	-372(a6)		;GetMsg()
	tst.l	d0
	bne.s	\gotmsg
	tst.l	d5
	bne.s	\noread
	bra.s	\wait			;signal came without msg =>wait again
\gotmsg:
	move.l	cor_pktptr(pc),a1
	move.l	(a1),a0
	cmp.l	a0,d0
	bne.s	\check

;------------------
; case 1: packet came in
;
\camein:
	move.l	d5,d2
	moveq	#-1,d1
	move.l	12(a1),d0		;Res1=Length
	sf	cor_sent(a4)		;packet no longer sent
	bra.s	\exit

;------------------
; case 2: only other signals came in, no read result.
;
\noread:
	move.l	d0,d2
	moveq	#0,d1
	moveq	#0,d0

;------------------
; exit
;
\exit:
	movem.l	d0-d2,-(sp)
	jsr	-138(a6)
	movem.l	(sp)+,d0-a6
	rts
	
;------------------

;------------------------------------------------------------------------------
*
* RESETCONREAD	Resets packet sending. Frees dos object.
*
* RESULT:	All resources freed.
*
;------------------------------------------------------------------------------

;------------------
resetconread:

;------------------
; start
;
\start:
	movem.l	d0-a6,-(sp)
       	move.l	cor_pktptr(pc),d0      ;no packet installed
	beq.s	\exit
	lea	cor_dosflag(pc),a0
	tst.b	(a0)
	beq.s	\close

;------------------
; FreeDosObject()
;
\free:
	move.l	dosbase(pc),a6
	moveq	#3,d1
	move.l	cor_pktptr(pc),d2
	jsr	-234(a6)

;------------------
; free signal
;
\close:
	move.l	cor_signal(pc),d0
	move.l	4.w,a6
	jsr	-336(a6)		;FreeSignal()
	lea	cor_port(pc),a1
	jsr	-360(a6)

;------------------
; exit
;
\exit:
	movem.l	(sp)+,d0-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
cor_dosflag:	dc.b	0
cor_sent:	dc.b	0
cor_pktptr:	dc.l	0
cor_signal:	dc.l	0

;------------------
cor_port:	ds.b	14,0
		dc.b	0,0		;flag,sigbit
		dc.l	0		;sigtask
		ds.b	14,0

;------------------
		align.l
cor_messy:	dc.l	0,0
		dc.b	5,0
		dc.l	0	;>packet
		dc.l	0	;>replyport
		dc.w	20
cor_packet:	dc.l	0	;>messy
		dc.l	0	;>replyport
		dc.l	'R'	;>type
		dc.l	0,0	;Res
		dc.l	0,0,0,0	;Args

;--------------------------------------------------------------------

;------------------
	base	cor_oldbase

;------------------
	endif

 end

