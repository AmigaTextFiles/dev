; For copying DOS command paths
; Used in ShellScr by Kyzer/CSG
;
; Based on dospath.library source by Stefan Becker
; all functions withstand being passed NIL

call	macro
	move.l	\2base(a4),a6
	movem.l	a0/a1/d1,-(sp)
	jsr	_LVO\1(a6)
	movem.l	(sp)+,d1/a0/a1
	endm
clra	macro
	suba.l	\1,\1
	endm
baddr	macro
	add.l	\1,\1
	add.l	\1,\1
	endm
mkbaddr	macro
	asr.l	#2,\1
	endm

	include	dos/dos.i
	include	dos/dosextens.i
	include	exec/memory.i
	include	exec/nodes.i
	include	exec/ports.i
	include	exec/tasks.i
	include	exec/types.i
	include	lvo/dos_lib.i
	include	lvo/exec_lib.i
	include	workbench/startup.i

	include	eglobs.i

     STRUCTURE	PathList,0
	BPTR	pl_next
	BPTR	pl_lock
	LABEL	pl_SIZEOF

;------------------------------------------------------------------------------
; PTR TO commandlineinterface=getcli(PTR TO process) - private call
; d0=0 and Z flag set if not a process or no commandlineinterface

getcli	moveq	#0,d0
	cmp.l	d0,a0
	beq.s	.fail
	cmp.b	#NT_PROCESS,LN_TYPE(a0)
	bne.s	.fail
	move.l	pr_CLI(a0),d0
	baddr	d0
	rts
.fail	moveq	#0,d0
	rts

;------------------------------------------------------------------------------
; PTR TO pathlist=getpathlist(PTR TO process)
; returns a normal pointer to the initial pathlist entry of the process

	xdef	getpathlist__i
getpathlist__i
	move.l	4(sp),a0
getpathlist
	bsr.s	getcli
	beq.s	.fail
	move.l	d0,a0
	move.l	cli_CommandDir(a0),d0
	baddr	d0
.fail	rts


;------------------------------------------------------------------------------
; BPTR TO pathlist=getpath()
; makes a clone of 'your' pathlist. NOTE: returns BPTR, not PTR

	xdef	getpath
getpath	move.l	execbase(a4),a6
	jsr	_LVOForbid(a6)
	move.l	wbmessage(a4),d0	; from eglobs.i
	beq.s	.getslf
	move.l	d0,a0
	bsr.s	getwbtask
	bra.s	.gottsk
.getslf	suba.l	a1,a1
	jsr	_LVOFindTask(a6)
.gottsk	move.l	d0,a0
	bsr.s	getpathlist
	move.l	d0,a0
	bsr.s	copypathlist
	move.l	d0,-(sp)
	move.l	execbase(a4),a6
	jsr	_LVOPermit(a6)
	move.l	(sp)+,d0
	mkbaddr	d0
	rts

;------------------------------------------------------------------------------
; PTR TO process=getwbtask(PTR TO wbstartup)
; returns a pointer to the Workbench/Launcher's process

	xdef	getwbtask__i
getwbtask__i
	move.l	4(sp),a0
getwbtask
	move.l	MN_REPLYPORT(a0),d0
	bne.s	.port
	lea	.wbname(pc),a1
	move.l	execbase(a4),a6
	jmp	_LVOFindTask(a6)
.port	move.l	d0,a0
	move.l	MP_SIGTASK(a0),d0
	rts
.wbname	dc.b	'Workbench',0
	even

;------------------------------------------------------------------------------
; PTR TO pathlist=copypathlist(PTR TO pathlist)
; clone a pathlist

FROM	equr	A0
CURRENT	equr	A1
HEAD	equr	A2
NEXT	equr	A3	;
ZERO	equr	D7	; constant 0

tsta	macro
	cmp.l	ZERO,\1
	endm

	xdef	copypathlist__i
copypathlist__i
	move.l	4(sp),FROM
copypathlist
	movem.l	d7/a2/a3,-(sp)
	clra	CURRENT
	clra	HEAD
	clra	NEXT
	moveq	#0,d7

.again
	tsta	FROM
	beq.s	.end

	tsta	NEXT
	bne.s	.gotmem

	moveq	#pl_SIZEOF,d0
	moveq	#MEMF_PUBLIC,d1
	call	AllocVec,exec
	move.l	d0,NEXT	; if (!NEXT) NEXT=AllocVec(sizeof(PathList), MEMF_PUBLIC)
	
.gotmem	tsta	NEXT	; if (!NEXT) { freepathlist(HEAD); return NULL; }
	bne.s	.got
	move.l	HEAD,a0
	bsr.s	freepathlist
	moveq	#0,d0
	rts
.got
	move.l	pl_lock(FROM),d1
	call	DupLock,dos
	move.l	d0,pl_lock(NEXT)
	beq.s	.next
	clr.l	pl_next(NEXT)

	tsta	HEAD
	bne.s	.gothd
	move.l	NEXT,HEAD	; if (!HEAD) HEAD=NEXT
.gothd

	tsta	CURRENT
	beq.s	.nonext
	move.l	NEXT,d0
	mkbaddr	d0
	move.l	d0,pl_next(CURRENT)
.nonext	move.l	NEXT,CURRENT
	clra	NEXT

.next	move.l	pl_next(FROM),FROM	; FROM=BADDR(FROM.next)
	baddr	FROM
	bra.s	.again

.end	move.l	NEXT,a1
	call	FreeVec,exec

	move.l	HEAD,d0		; return HEAD
.done	movem.l	(sp)+,d7/a2/a3
	rts

;------------------------------------------------------------------------------
; freepathlist(PTR TO pathlist)
; frees a pathlist - note it takes a normal pointer, not a BPTR

	xdef	freepathlist__i
freepathlist__i
	move.l	4(sp),a0
freepathlist
.again	move.l	a0,a1		; current(a1) = next(a0)
	moveq	#0,d0
	cmp.l	d0,a1		; end if current=0
	beq.s	.done
	move.l	pl_next(a1),a0	; next=BADDR(current.next)
	baddr	a0

	move.l	pl_lock(a1),d1
	call	UnLock,dos	; d1=current.lock
	call	FreeVec,exec	; a1=current

	bra.s	.again
.done	rts

;------------------------------------------------------------------------------
; PTR TO pathlist=setpathlist(PTR TO process,PTR TO pathlist)
; if a process, it will get it's pathlist set and return it's old process

	xdef	setpathlist__ii
setpathlist__ii
	move.l	8(sp),a0
	move.l	4(sp),a1
setpathlist
	bsr	getcli
	beq.s	.done	; return 0 if not a process in a0
	move.l	d0,a0
	move.l	cli_CommandDir(a0),d0	; hold old pathlist
	move.l	a1,d1
	beq.s	.fail			; ignore install if no newlist
	mkbaddr	d1			; MKBADDR(newlist)
	move.l	d1,cli_CommandDir(a0)	; install new list
.fail	baddr	d0			; return BADDR(oldlist)
.done	rts
