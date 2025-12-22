


	xdef    nameFromLock_lock_buf_len

nameFromLock_lock_buf_len:
	movem.l 4(a7),d0/d2/a0
	movem.l	d3-d6/a5,-(a7)
	movea.l -44(a4),a6      ; dosbase
	move.l  d0,d3
	move.l	a0,d1
	cmp.w   #36,20(a6)
	bmi.s   .oldkick
	jsr     -402(a6)        ; NameFromLock
	bra.w	.backreg
.oldkick:
	subq.l  #1,d3
	bmi.s   .quitfroml2n
	movea.l d2,a3
	move.l	d2,d6
	move.l  a7,d5
	move.l  a7,d0
	moveq   #-4,d2
	and.l   d2,d0
	movea.l d0,a7
	lea     -260(a7),a7     ; fib_SIZEOF
	move.l  a7,d2
	lea     8(a7),a5        ; fib_FileName
	clr.l   -(a7)
	jsr     -96(a6)         ; DupLock
	move.l  d0,-(a7)
	bne.s   .lockparentloop
	addq.w  #8,a7
	bra.s	.quitfroml2n
.lockparentloop:
	move.l  d0,d1
	jsr     -210(a6)        ; ParentDir
	move.l  d0,-(a7)
	bne.s   .lockparentloop
	addq.w  #4,a7
	move.l  (a7)+,d1
	movea.l d1,a2
	jsr     -102(a6)        ; Examine
	movea.l a5,a0
.copyvolume:
	move.b  (a0)+,(a3)+
	dbeq    d3,.copyvolume
	tst.w	d3
	bmi.s   .unlockparent
.skip1:	subq.w  #1,a3
	move.b  #':',(a3)+
	moveq   #'/',d4
	bra.s   .unlockparent
.locknameloop:
	movea.l d1,a2
	jsr     -102(a6)        ; Examine
	movea.l a5,a0
.copyname2buf:
	move.b  (a0)+,(a3)+
	dbeq    d3,.copyname2buf
	tst.w	d3
	bmi.s	.unlockparent	
	subq.w  #1,a3
	move.b  d4,(a3)+
.unlockparent:
	move.l  a2,d1
	jsr     -90(a6)         ; UnLock
.getlockfromstc:
	move.l  (a7)+,d1
	bne.s   .locknameloop
	cmp.b   -(a3),d4
	beq.s   .quitfroml2n
	addq.w  #1,a3
.quitfroml2n:
	moveq	#-1,d0
	tst.w	d3
	bpl.s	.okeylength
	moveq	#0,d0
	move.l	d6,a3
.okeylength:
	clr.b   (a3)
	movea.l d5,a7
.backreg:
	movem.l (a7)+,d3-d6/a5
	rts
	
