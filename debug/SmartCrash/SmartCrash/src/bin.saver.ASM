; FILE: Source:bin.saver.ASM          REV: 7 --- save next hunk as PROGDIR:<progname>.bin
; History
;  0      2nd Dec 1997.
;  1      Working.
;  2      Now writes PROGDIR:fade.ovl
;  3      Now gets filename dynamically, renamed to bin.saver.ASM
;

	SECTION	A,CODE

Main_saver	movem.l	d1-a6,-(sp)
	moveq	#20,d7			;RETURN_FAIL,d7

	move.l	(Main_saver-4,pc),d4
	beq	.exit
	lsl.l	#2,d4
	move.l	d4,a0
	addq.l	#4,d4
	move.l	-(a0),d3
	subq.l	#8,d3

	move.l	(4).w,a6
	lea	(378,a6),a0		;LibList,a6),a0
	lea	(.dosname,pc),a1
	jsr	(-$84,a6)		;call	Forbid
	jsr	(-$114,a6)		;call	FindName
	jsr	(-$8A,a6)		;call	Permit
	move.l	d0,a6

	lea	(.progname,pc),a0
	move.l	a0,d1
	moveq	#127,d2
	jsr	(-$240,a6)		;call	GetProgramName

	lea	(.progname,pc),a0
	move.l	a0,d1
	jsr	(-$366,a6)		;call	FilePart
	move.l	d0,a0
	lea	(.filepart,pc),a1
.copy	move.b	(a0)+,(a1)+
	bne.b	.copy
	subq.l	#1,a1
	move.b	#'.',(a1)+
	move.b	#'b',(a1)+
	move.b	#'i',(a1)+
	move.b	#'n',(a1)+
	clr.b	(a1)

	lea	(.file,pc),a0
	move.l	a0,d1
	jsr	(-$48,a6)		;call	DeleteFile
	lea	(.file,pc),a0
	move.l	a0,d1
	move.l	#$3EE,d2		;MODE_NEWFILE,d2
	jsr	(-$1E,a6)		;call	Open
	lea	(.exit,pc),a0
	move.l	d0,d6
	beq.b	.exite

	move.l	d6,d1
	move.l	d4,d2
	jsr	(-$30,a6)		;call	Write
	move.l	d0,d2
	move.l	d6,d1
	jsr	(-$24,a6)		;call	Close
	cmp.l	d2,d3
	beq.b	.exitok

	lea	(.exitdel,pc),a0

.exite	move.l	a0,-(sp)
	jsr	(-$84,a6)		;call	IoErr
	move.l	d0,d1
	lea	(.errh,pc),a0
	move.l	a0,d2
	jmp	(-$1DA,a6)		;jmp	(_LVOPrintFault,a6)

.exitok	lea	(.okmes,pc),a0
	move.l	a0,d1
	move.l	d3,-(sp)
	move.l	d3,-(sp)
	pea	(.file,pc)
	move.l	sp,d2
	jsr	(-$3BA,a6)		;call	VPrintf
	lea	(3*4,sp),sp

	moveq	#0,d7			;RETURN_OK,d7

.exit	move.l	d7,d0
	movem.l	(sp)+,d1-a6
	rts

.exitdel	lea	(.file,pc),a0
	move.l	a0,d1
	jsr	(-$48,a6)		;call	DeleteFile
	bra.b	.exit


.dosname	dc.b	'dos.library',0
.errh	dc.b	'bin.saver',0
.okmes	dc.b	'Saved first hunk to file "%s", lenght $%lx (%ld) bytes.',10,0
.file	dc.b	'PROGDIR:'
.filepart	ds.b	64

.progname	ds.b	128

	CNOP	0,4

	SECTION	B,CODE
