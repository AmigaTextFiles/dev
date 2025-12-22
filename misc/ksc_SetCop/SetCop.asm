; SetCop v1.0 : installs copperlist at specified hex address
; by Kyzer/CSG
; $VER: SetCop.asm 1.0 (22.06.98)
;
	incdir	include:
	include	dos/dos.i
	include	exec/execbase.i	
	include	hardware/custom.i
	include	lvo/dos_lib.i
	include	lvo/exec_lib.i
	include	lvo/graphics_lib.i
	incdir	""

_custom=$dff000

	move.l	4.w,a6
	move.l	MaxLocMem(a6),d7	; d7 = chipmem top
	lea	dosname(pc),a1
	moveq	#36,d0
	jsr	_LVOOpenLibrary(a6)
	tst.l	d0
	beq	.nodos
	move.l	d0,a6

	lea	templat(pc),a0
	move.l	a0,d1
	lea	copaddr(pc),a2
	clr.l	(a2)
	move.l	a2,d2
	moveq	#0,d3
	jsr	_LVOReadArgs(a6)
	tst.l	d0
	beq.s	.noargs
	move.l	d0,-(sp)		; push [rdargs]

	move.l	(a2),a0
	bsr.s	hex
	tst.l	d1
	beq.s	.fail
	cmp.l	d7,d0	; cmp memtop,d0
	bcs.s	.ok	; d0 < memtop
.fail	moveq	#ERROR_BAD_NUMBER,d1
	jsr	_LVOSetIoErr(a6)
	bra.s	.badnum

.ok	move.l	a6,-(sp)		; push [dosbase]

	move.l	d0,d7
	move.l	4.w,a6
	lea	gfxname(pc),a1
	moveq	#33,d0
	jsr	_LVOOpenLibrary(a6)
	tst.l	d0
	beq.s	.nogfx
	move.l	d0,a6
	suba.l	a1,a1
	jsr	_LVOLoadView(a6)
	jsr	_LVOWaitTOF(a6)
	jsr	_LVOWaitTOF(a6)
	move.l	a6,a1
	move.l	4.w,a6
	jsr	_LVOCloseLibrary(a6)
.nogfx	lea	_custom,a6
	move.l	d7,cop1lc(a6)
	move.w	#0,copjmp1(a6)

	move.l	(sp)+,a6		; pop [dosbase]

.badnum	move.l	(sp)+,d1		; pop [rdargs]
	jsr	_LVOFreeArgs(a6)
.noargs	jsr	_LVOIoErr(a6)
	move.l	d0,d1
	moveq	#0,d2
	jsr	_LVOPrintFault(a6)
	move.l	a6,a1
	move.l	4.w,a6
	jsr	_LVOCloseLibrary(a6)
.nodos	moveq	#0,d0
	rts

hex	include	hex.asm

copaddr	dc.l	0
templat	dc.b	'COPPER/A',0
dosname	dc.b	'dos.library',0
gfxname	dc.b	'graphics.library',0
