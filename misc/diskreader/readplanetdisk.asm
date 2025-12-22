; Captain Planet disk image reader
; v1.0: works fine with my disk (RATT-DOS 2.0)
; by Kyzer/CSG

FILEMODE=1
	include	diskreader.asm
	BUFFER	TRACKBUFFER

	; load and decode bootblock and ratt-dos
	DOSREAD	#0

	lea	TRACKBUFFER+$80,a0
	move.w	#620/4-1,d0
.d1	sub.l	#'BooT',(a0)+
	dbra	d0,.d1
	lea	TRACKBUFFER+$400,a0
	lea	rattdos,a1
	move.w	#$1000/4-1,d0
.d2	sub.l	#'RaTt',(a0)
	move.l	(a0)+,(a1)+
	dbra	d0,.d2

	SAVEF	bootnam(pc),TRACKBUFFER+$80,#620
	SAVEF	rattnam(pc),rattdos,#$1000

	; patch ratt-dos to use our own loading routines
	lea	rattdos,a6

	; RTS patches
	lea	.rlist(pc),a0
	moveq	#13-1,d0
1$	move.w	(a0)+,d1
	move.w	#$4e75,(a6,d1.w)
	dbra	d0,1$

	; other patches
	lea	fakehw,a0
	move.l	a0,$278+2(a6)		;278	lea	fakehw,a5
	move.l	a0,$286+2(a6)		;286	lea	fakehw,a3
	lea	.track(pc),a0
	move.l	a0,$59e+2(a6)		;59e	move.l	d2,track
	lea	.loader(pc),a0
	move.l	a0,$6ba+2(a6)		;6ba	jmp	loader

	lea	.plist(pc),a0
2$	move.w	(a0)+,d0		; get patch
	move.w	(a0)+,d1		; get offset
	beq	.flush			; skip to rest of loader program
	move.w	d0,(a6,d1.w)
	bra.s	2$

.rlist	dc.w	$260,$33c,$3ec,$462,$5a4,$610,$62e,$652
	dc.w	$666,$676,$6ae,$70e,$9f4

.plist	dc.w	$0042,$460
	dc.w	$004a,$33a
	dc.w	$202c,$338
	dc.w	$23c2,$59e
	dc.w	$4cdf,$45e
	dc.w	$4ef9,$6ba
	dc.w	$6002,$290
	dc.w	$6004,$2c8
	dc.w	$6004,$2d2
	dc.w	$6004,$4c2
	dc.w	$6004,$506
	dc.w	$600c,$266
	dc.w	$600e,$4a0
	dc.w	$7000,$62c
	dc.w	$b040,$60e
	dc.w	0,0

.loader	movem.l	d0-d1/a0-a1/a5-a6,-(sp)
	move.l	.a5save(pc),a5
	moveq	#0,d0
	move.b	.track+3(pc),d0
	move.l	(a4),a0
	bsr	__rawrd
	move.l	(a4),a0
	move.w	30(sp),d0
	bsr	__sync
	movem.l	(sp)+,d0-d1/a0-a1/a5-a6
	jmp	rattdos+$73a
.track	dc.l	0
.a5save	dc.l	0


.flush	move.l	a6,-(sp)
	move.l	execbase(a5),a6
	call	CacheClearU
	move.l	(sp)+,a6

	lea	.a5save(pc),a0
	move.l	a5,(a0)

	MOVE.W	#1,D1
	JSR	4(A6)	; init drives

	lea	dirbuf,a0
	MOVE.L	A0,D0
	JSR	8(A6)	; change directory-buffer

	lea	TRACKBUFFER,a0
	MOVE.L	A0,D0
	JSR	12(A6)	; change data-buffer (mfm/decode)

	moveq	#0,d0
	jsr	$38(a6)	; read directory

	; save directory file
	SAVEF	dirname(pc),dirbuf,#1628

	; save every file in the directory
	lea	dirbuf+$BC,a0
.next	tst.b	(a0)
	beq.s	.done
	move.l	a0,-(sp)
	bsr.s	.save
	move.l	(sp)+,a0
	lea	$18(a0),a0
	bra.s	.next
.done	rts

.save	lea	filebuf,a1
	movem.l	a0-a1/a5-a6,-(sp)
	exg.l	a0,a1		; a1 = filename, a0 = buffer
	move.w	#-1,d1
	jsr	$1c(a6)
	movem.l	(sp)+,a0-a1/a5-a6
	bra	__savef	; a0 = filename, a1 = buffer, d0 = length

rattnam	dc.b	'rattdos',0
bootnam	dc.b	'bootcode',0
dirname	dc.b	'cp.dir',0
	cnop	0,4

	section	mem,bss
rattdos	ds.b	4096
dirbuf	ds.b	4096
fakehw	ds.b	$200
filebuf	ds.b	80*1024
