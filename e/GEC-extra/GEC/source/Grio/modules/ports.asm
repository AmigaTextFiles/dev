


	incdir	include:
	include 'exec/lists.i'
	include 'exec/ports.i'
	include 'exec/nodes.i'
	include 'exec/memory.i'
	include 'libs/exec.i'
	




	XDEF	createPort_name_pri
	
createPort_name_pri:
	movea.l	4.w,a6
	cmp.w	#36,20(a6)
	blo.s	.1
	jsr	CreateMsgPort(a6)
	move.l	d0,a2
	move.l	a2,d0
	beq.s	.2
	move.b	4+3(a7),LN_PRI(a2)
	move.l	8(a7),LN_NAME(a2)
	bne.s	add_port
.2:
	rts
.1:	moveq	#-1,d0
	jsr	AllocSignal(a6)
	moveq	#-1,d1
	cmp.l	d1,d0
	beq.s	.quit
	move.l	d0,d2
	moveq	#MP_SIZE,d0
	move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
	jsr	AllocMem(a6)
	tst.l	d0
	bne.s	ok_mem
	move.l	d2,d0
	jsr	FreeSignal(a6)
	moveq	#0,d0
.quit:
	rts
ok_mem:
	movea.l	d0,a2
	move.b  #NT_MSGPORT,LN_TYPE(a2)
	move.b  d2,MP_SIGBIT(a2)
;	move.b	#PA_SIGNAL,MP_FLAGS(a2)   ;  PA_SIGNAl=0 
	suba.l	a1,a1
	jsr	FindTask(a6)
	move.l	d0,MP_SIGTASK(a2)
	move.b	4+3(a7),LN_PRI(a2)
	move.l	8(a7),LN_NAME(a2)
	bne.s	add_port
	lea	MP_MSGLIST(a2),a0
	move.l	a0,LH_TAILPRED(a0)
	move.l	a0,d0
	addq.l	#4,d0
	move.l	d0,LH_HEAD(a0)
	bra.s	exitport
add_port:
	movea.l	a2,a1
	jsr	AddPort(a6)
exitport:
	move.l	a2,d0
quitcreate:
	rts
	
	


	XDEF	deletePort_port

deletePort_port:
	move.l	4(a7),d0
	beq.s	quitdel
	movea.l	4.w,a6
	movea.l	d0,a2
	tst.l	LN_NAME(a2)
	beq.s	noname
	movea.l	a2,a1
	jsr	RemPort(a6)
noname:
	cmp.w	#36,20(a6)
	blo.s	.1
	move.l	a2,a0
	jsr	DeleteMsgPort(a6)
	bra.s	.2
.1:	moveq	#-1,d0
	move.l	d0,MP_SIGTASK(a2)
	move.l	d0,MP_MSGLIST+LH_HEAD(a2)
	moveq	#0,d0
	move.b	MP_SIGBIT(a2),d0
	jsr	FreeSignal(a6)
	moveq	#MP_SIZE,d0
	movea.l	a2,a1
	jsr	FreeMem(a6)
.2:
	moveq	#0,d0
quitdel:
	rts


	
