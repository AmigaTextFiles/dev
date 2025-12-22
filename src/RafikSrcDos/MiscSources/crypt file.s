;coded by Rafik/RDST/SCT
;Gdynia 94.12.13

DEBUG=0

	IFNE	DEBUG
	AddWatch	SourceName,A
	AddWatch	DestName,A
	AddWatch	a1-2,A
	AddWatch	a2-2,A

	ENDC


VERSION:	MACRO
	dc.b	'v0.1'
		ENDM

	SECTION	COPY,CODE
START:

	IFNE	DEBUG
		bra.s	S
		dc.b	'c/copy ram:',$a
S
		move.l	#S-START,d0
		lea	START,a0
	ENDIF


	tst.l	d0
	beq.w	END

	move.l	4.w,a6

	movem.l	d0/a0,-(sp)

	lea	DosName(pc),a1
	bsr	OpenLibrary
	move.l	d0,a5

	jsr	-60(a5)		;OutPut
	move.l	d0,OutputHandle	;handle

	movem.l	(sp)+,d0/a0

	bsr.w	Find

	lea	Crypt,a1
	move.b	(a0)+,(a1)+
	move.b	(a0)+,(a1)+
	move.b	(a0)+,(a1)+
	move.b	(a0)+,(a1)+

	bsr.w	Find

	lea	SourceName,a1
	bsr	CopyN
	move.l	a1,-(sp)
	move.b	d1,TextLenght

	bsr.w	Find

	lea	DestName,a1
	bsr	CopyN
	move.b	d1,SecondTxt
	cmp.b	#'/',-1(a0)
	beq.s	.addrest
	cmp.b	#':',-1(a0)
	bne.s	.noadd
.addrest
	move.l	(sp),a2
.l
	subq.l	#1,a2
	cmp.l	#SourceName,a2
	bmi.s	.add
	cmp.b	#'/',(a2)
	beq.s	.add
	cmp.b	#':',(a2)
	bne.s	.l
.add
	addq.l	#1,a2
	subq.l	#1,a1
.c	move.b	(a2)+,(a1)+
	cmp.l	(sp),a2
	bmi.s	.c
.noadd
	addq.l	#4,sp

	movem.l	d0/a0,-(sp)

	moveq	#0,d3
	move.b	TextLenght,d3	;dîugoôê textu
	move.l	#SourceName,d2
	bsr.w	Write

	moveq	#4,d3
	move.l	#ToTxt,d2
	bsr.w	Write

	moveq	#0,d3
	move.b	SecondTxt,d3
	move.l	#DestName,d2
	bsr.w	Write

Cont:	movem.l	(sp)+,d0/a0

	move.l	#SourceName,d1
	move.l	#1005,d2	;mode old ?
	jsr	-30(a5)		;Open

	move.l	d0,FHandle
	beq.w	Error

		move.l	d0,d1
		moveq	#0,d2
		moveq	#OFFSET_END,d3
	jsr	-66(a5)		;seek
		move.l	FHandle,d1
		moveq	#0,d2
		moveq	#OFFSET_BEGINNING,d3
	jsr	-66(a5)
		move.l	d0,FileSize

		move.l	#MEMF_PUBLIC,d1
	jsr	-198(a6)
		move.l	d0,AllocAdress
		beq.w	Error

		move.l	d0,d2	;buffor
		move.l	FHandle,d1
		move.l	FileSize,d3
	jsr	-42(a5)		;read
		cmp.l	FileSize,d0
		bne.s	Error

		move.l	FHandle,d1
	jsr	-36(a5)		;close

;crypt w tym miejscu...
		lea	Crypt,a0
		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3

		move.l	AllocAdress,a0
		move.l	FileSize,d4

.loop		eor.b	d0,(a0)+
		subq.l	#1,d4
		beq.s	koniecc
		eor.b	d1,(a0)+
		subq.l	#1,d4
		beq.s	koniecc
		eor.b	d2,(a0)+
		subq.l	#1,d4
		beq.s	koniecc
		eor.b	d3,(a0)+
		subq.l	#1,d4
		beq.s	koniecc
		bra.s	.loop
koniecc:
		move.l	#DestName,d1
		move.l	#1006,d2	;mode new
	jsr	-30(a5)		;Open
		move.l	d0,FHandle
		beq.s	Error

		move.l	d0,d1
		move.l	AllocAdress,d2
		move.l	FileSize,d3
	jsr	-48(a5)		;write
		cmp.l	#-1,d0
		beq.w	Error

		move.l	#Copied,-(sp)
		bra.s	NoErr
Error:
		move.l	#Failed,-(sp)
NoErr:
		move.l	FHandle,d1
	jsr	-36(a5)		;close

		move.l	(sp)+,d2
		moveq	#8,d3	;dîugoôê textu
		bsr.w	Write

		move.l	FileSize,d0
		beq.s	.cont
		move.l	AllocAdress,a1
	jsr	-210(a6)	;freemem

.cont

;	tst.l	d0
;	bne.w	NiePlus
_LVOOpen	EQU	-30
_LVOClose	EQU	-36
_LVORead	EQU	-42
_LVOWrite	EQU	-48
_LVOSeek	EQU	-66
_LVOAllocMem	EQU	-198
MEMF_PUBLIC	=1
_LVOFreeMem	EQU	-210

END:	moveq	#0,d0
	rts
OpenLibrary:
	moveq	#0,d0
	move.l	4.w,a6
	jmp	-552(a6)	;Open Library

Write:	moveq	#0,d0
	move.l	OutputHandle,d1
	jmp	-48(a5)		;write

CopyN:
	moveq	#0,d1
CopyName:
	subq.l	#1,d0
	beq.s	Rts
	addq.b	#1,d1
	move.b	(a0)+,(a1)+
	cmp.b	#' ',(a0)
	beq.s	Rts
	cmp.b	#$a,(a0)
	bne.s	CopyName
	clr.b	(a1)+
Rts
	rts


Plus:	addq.l	#1,a0
	subq.l	#1,d0
	beq.s	Rts
Find:
	cmp.b	#$a,(a0)
	beq.s	Rts
	cmp.b	#' ',(a0)
	beq.s	Plus
	rts


Copied:	dc.b	'	Crypted',$a
Failed:	dc.b	'	Failed ',$a
ToTxt:	dc.b	'	TO	'
DosName:	dc.b	'dos'
Lib:	dc.b	'.library',0
LibE:
 dc.b	' $VER:  Crypt '
 VERSION
 dc.b	' coded by RTheK/RDST/SCT Gdynia 1994 dla Grega ',0

	SECTION	DATA,BSS
AllocAdress:	ds.l	1
FileSize:	ds.l	1
FHandle:	ds.l	1
TextEnd:	ds.l	1
OutputHandle:	ds.l	1
SourceName:	ds.b	100
DestName:	ds.b	100
TextLenght:	ds.b	1
SecondTxt:	ds.b	1
Crypt:		ds.b	8
MODE_OLDFILE	EQU	1005
OFFSET_END	equ	1
OFFSET_BEGINNING	equ	-1
