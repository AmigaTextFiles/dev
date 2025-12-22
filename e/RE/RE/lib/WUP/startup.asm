*phxass NOEXE opt nrqbtlps re:lib/warpup.asm
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

	lea	(PPCName,pc),a1
	moveq	#0,d0
	jsr	(-552,a6)		; OpenLibrary()
	move.l	d0,_PowerPCBase
	beq.s	.CLOSEGFX

.ALLOCPPCMEM
	move.l	#$2000,d0	; allocate 8192 bytes for RE stack
	add.l   #56,d0
	move.l	#$10005,d1	; MEMF_PUBLIC | MEMF_FAST | MEMF_CLEAR
	movea.l	$4.w,a6
	jsr     -684(a6)	; AllocVec()
	move.l  d0,d1
	beq     .CLOSEALL
	add.l   #39,d0
	and.l   #$ffffffe0,d0
	move.l  d0,a0
	move.l  d1,-4(a0)
	move.l	d0,__stack

	lea	(ppcstruct,pc),a0	; load ppc structure
	xref	_LinkerDB
	lea	_LinkerDB,a4	; get local data
	move.l	_PowerPCBase,a1	; get powerpc.library pointer
	move.l	a4,$44(a0)	; store a4/r2
	add.l	#$1800,d0	; calc upper bound of stack (aproximated)
	move.l	d0,20(a0)	; store d0

	movea.l	_PowerPCBase,a6
	jsr	(-30,a6)
	lea	(ppcstruct,pc),a0
	move.l	(20,a0),d7

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
	movea.l	4.w,a6
.FREEPPCMEM
	move.l	__stack,a1
	move.l  a1,d0
	beq.b   .lb_2
	move.l  -4(a1),a1
	jsr     -690(a6)	; FreeVec()
.lb_2:

	movea.l	_PowerPCBase,a1
	jsr	(-414,a6)		; CloseLibrary()
.CLOSEGFX	movea.l	_GfxBase,a1
	jsr	(-414,a6)		; CloseLibrary()
.CLOSEINT	movea.l	_IntuitionBase,a1
	jsr	(-414,a6)		; CloseLibrary()
.CLOSEDOS	movea.l	_DOSBase,a1
	jsr	(-414,a6)		; CloseLibrary()
	move.l	_wbmessage,d3
	beq.b	.FINISH
	jsr	(-132,a6)		; Forbid()
	movea.l	d3,a1
	jsr	(-$17A,a6)		; ReplyMsg()
.FINISH	move.l	d7,d0
	rts
****************************************
DOSName	dc.b	'dos.library',0
IntName	dc.b	'intuition.library',0
GfxName	dc.b	'graphics.library',0
PPCName	dc.b	'powerpc.library',0
	cnop	0,4
__stack	dc.l	0
****************************************
ppcstruct	dc.l	_main
	dc.l	0,0,0,0
	dc.l	0,0,0,0,0,0,0,0	; d0-d7
	dc.l	0,0,0,0,0,0,0	; a0-a6
	dc.d	0,0,0,0,0,0,0,0	; fp0-fp7
****************************************
	xref	_main
	xref	_DOSBase
	xref	_IntuitionBase
	xref	_GfxBase
	xref	_ExecBase
	xref	_PowerPCBase
	xref	_arg
	xref	_stdout
	xref	_stdin
	xref	_conout
	xref	_wbmessage
****************************************
	section	".tocd",data
	dcb.b	32,0	; space for caches
*_PowerPCBase	dc.l	0
*_ExecBase		dc.l	0
*_DOSBase		dc.l	0
*_IntuitionBase	dc.l	0
*_GfxBase		dc.l	0
*_arg		dc.l	0
*_conout		dc.l	0
*_stdout		dc.l	0
*_stdin		dc.l	0
*_wbmessage	dc.l	0
