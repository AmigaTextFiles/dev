	
	
	
	include	'exec/io.i'
	include	'exec/memory.i'
	include	'exec/nodes.i'
	include	'exec/ports.i'
	include	'libs/exec.i'





	XDEF	beginIO_ioreq

beginIO_ioreq:
	move.l	4(a7),d0
	beq.s	.quit
	movea.l	d0,a1
	movea.l	IO_DEVICE(a1),a6
	jsr	DEV_BEGINIO(a6)
.quit:
	rts





	XDEF	createExtIO_port_iosize

createExtIO_port_iosize:
	move.l	4(a7),d2
	move.l	8(a7),d0
create:
	beq.s	.quit
	movea.l	d0,a2
	movea.l	4.w,a6
	move.l	d2,d0
	move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
	jsr	AllocMem(a6)
	tst.l	d0
	beq.s	.quit
	movea.l	d0,a0
	move.b	#NT_REPLYMSG,LN_TYPE(a0)
	move.l	a2,MN_REPLYPORT(a0)
	move.w	d2,MN_LENGTH(a0)
.quit:
	rts




	XDEF	createStdIO_port

createStdIO_port:
	moveq	#IOSTD_SIZE,d2
	move.l	4(a7),d0
	bra.s	create




	XDEF	deleteExtIO_ioreq
	
deleteExtIO_ioreq:
	move.l	4(a7),d0
	beq.s	.quit
	movea.l	d0,a1
	moveq	#-1,d0
	move.l	d0,LN_SUCC(a1)
	move.l	d0,MN_REPLYPORT(a1)
	move.l	d0,IO_DEVICE(a1)
	movea.l	4.w,a6
	moveq	#0,d0
	move.w	MN_LENGTH(a1),d0
	jsr	FreeMem(a6)
	moveq	#0,d0	
.quit:
	rts




	XDEF	deleteStdIO_ioreq

deleteStdIO_ioreq	EQU	deleteExtIO_ioreq



