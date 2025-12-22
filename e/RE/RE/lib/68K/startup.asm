*phxass NOEXE opt nrqbtlps re:lib/68K/startup.asm
START	movem.l	d0/a0,-(a7)	;save initial values
	movea.l	$4.w,a6
	suba.l	a1,a1
	jsr	(-294,a6)		; FindTask()
	move.l	d0,a4
	tst.l	(172,a4)		; process.cli
	beq.s	workbench
	movem.l	(a7)+,d0/a0	;restore regs
	bra.s	cli		;and run the user prog
workbench	lea	(92,a4),a0	; process.msgport
	jsr	(-384,a6)		;wait for a message (WaitPort(())
	lea	(92,a4),a0	; process.msgport
	jsr	(-372,a6)		;then get it (GetMsg())
	move.l	d0,_wbmessage		;save it for later reply
	movem.l	(a7)+,d0/a0	;restore
cli	bsr.s	_START		;call our program
	move.l	d0,-(a7)		;save it
	tst.l	_wbmessage
	beq.s	exittodos		;if I was a CLI
	jsr	(-132,a6)		; Forbid()
	move.l	_wbmessage,a1
	jsr	(-138,a6)		; Permit()
exittodos	move.l	(a7)+,d0		;exit code
	rts

_START	move.l	a0,_arg
	clr.b	(-1,a0,d0.w)
	movea.l	$4.w,a6
	move.l	a6,_ExecBase
	lea	(DOSName,pc),a1
	moveq	#37,d0
	jsr	(-552,a6)		; OpenLibrary()
	move.l	d0,_DOSBase
	beq.s	.FINISH

	movea.l	d0,a6
	jsr	(-60,a6)		; Output()
	move.l	d0,_stdout
	jsr	(-54,a6)		; Input()
	move.l	d0,_stdin

	movea.l	$4.w,a6
	lea	(IntName,pc),a1
	moveq	#37,d0
	jsr	(-552,a6)		; OpenLibrary()
	move.l	d0,_IntuitionBase
	beq.s	.CLOSEDOS

	lea	(GfxName,pc),a1
	moveq	#37,d0
	jsr	(-552,a6)		; OpenLibrary()
	move.l	d0,_GfxBase
	beq.s	.CLOSEINT


	xref	_main
	jsr	_main		; a6 is stored
	move.l	d0,d5

	tst.l	_conout
	beq.b	.CLOSEALL
	movea.l	_DOSBase,a6
	move.l	_conout,d1
	move.l	d1,d4
	moveq	#0,d2
	moveq	#0,d3
	jsr	(-$2A,a6) 	; Read()
	move.l	d4,d1
	jsr	(-$24,a6)	; Close()
.CLOSEALL
	movea.l	$4.w,a6

	movea.l	___memlist,a2
	move.l	a2,d0
	beq.b	.CLOSEGFX
.FREENODE
	movea.l	a2,a1
	move.l	(4,a2),d0
	movea.l	(a2),a2
	jsr	(-$d2,a6)	; FreeMem()
	move.l	a2,d0
	bne.b	.FREENODE

.CLOSEGFX	movea.l	_GfxBase,a1
	jsr	(-414,a6)		; CloseLibrary()
.CLOSEINT	movea.l	_IntuitionBase,a1
	jsr	(-414,a6)		; CloseLibrary()
.CLOSEDOS	movea.l	_DOSBase,a1
	jsr	(-414,a6)		; CloseLibrary()
.FINISH	move.l	d5,d0
	rts
****************************************
	xref	_ExecBase
	xref	_DOSBase
	xref	_IntuitionBase
	xref	_GfxBase
	xref	_arg
	xref	_conout
	xref	_stdout
	xref	_stdin
	xref	_wbmessage

	xdef	___memlist
	xdef	___epool
****************************************
*_ExecBase	dc.l	0
*_DOSBase	dc.l	0
*_IntuitionBase	dc.l	0
*_GfxBase	dc.l	0
*_arg		dc.l	0
*_conout		dc.l	0
*_stdout		dc.l	0
*_stdin		dc.l	0
*_wbmessage	dc.l	0
___memlist	dc.l	0
___epool	dc.l	0
****************************************
DOSName		dc.b	'dos.library',0
IntName		dc.b	'intuition.library',0
GfxName		dc.b	'graphics.library',0
