*>b:S16MakePermanent

	*«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*
	*   Copyright © 1997 by Kenneth "Kenny" Nilsen.  E-Mail: kenny@bgnett.no		      *
	*   Source viewed in 800x600 with mallx.font (11) in CED				      *
	*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
	*
	*   Name
	*	S16MakePermanent
	*
	*   Function
	*	Permanent edits in Studio 16 files if any
	*
	*   Inputs
	*	<file>
	*
	*   Notes
	*	
	*   Bugs
	*	
	*   Created	: 12.11.97
	*   Changes	: 12.11.97, 13.11.97, 26.11.97, 27.11.97
	*««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*


;StartSkip	SET	1
;DODUMP		SET	1


		Incdir	inc:

		include	lvo/exec_lib.i
		include	lvo/dos_lib.i

		include	digital.macs
		include	digital.i
		include	libraries/studio16file.i

		include	dos/dos.i
		include	exec/types.i

		include	startup.asm

		Incdir	""

		dc.b	"$VER: S16MakePermanent 1.1 (27.11.97)",10
		dc.b	"Copyright © 1997 Digital Surface. All rights reserved. ",0
		even
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Dump	macro
	move.l	#5,Warn
	move.l	#\1,d1
	bra	Print
	endm

Buffer	=	1024*400+S16S_SIZEOF
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Init		DefLib	dos,37
		DefEnd

Start	LibBase	dos

	NextArg
	beq	About
	move.l	d0,a0
	cmp.b	#'?',(a0)
	beq	About

	lea	IFile(pc),a1
.copy	move.b	(a0)+,(a1)+
	bne.b	.copy

; alloc memory

	LibBase	exec
	move.l	#Buffer,d0
	move.l	#$10001,d1
	Call	AllocMem
	move.l	d0,Mem
	beq	ErrorMem

	add.l	#Buffer-S16S_sizeof,d0
	move.l	d0,Header

*------------------------------------------------------------------------------------------------------------*
; open file and check it

	LibBase	dos

	move.l	#IFile,d1
	move.l	#MODE_OLDFILE,d2
	Call	Open
	move.l	d0,IHan
	beq	ErrorOpenI

	move.l	d0,d1
	move.l	Mem(pc),d2
	move.l	#S16S_SIZEOF,d3
	Call	Read
	cmp.l	#S16S_SIZEOF,d0
	bne	ErrorRead

; check header

	move.l	Mem(pc),a0
	cmp.l	#'KWK3',(a0)
	bne	ErrorType

; equal size ?

	move.l	S16S_REALSIZE(a0),d0
	move.l	S16S_EDITSIZE(a0),d1
	cmp.l	d0,d1
	bne	.notEQ

; count SampleClips

	lea	S16S_EDITLIST(a0),a1	;Show main clip as well
	moveq	#0,d0			;SampleClip counter
	moveq	#MAXSAMPLECLIPS-1,d1	;list tracker counter
.countS	move.l	(a1)+,d2		;_START
	move.l	(a1)+,d3		;_END
	beq	.smpEnd
	addq.l	#1,d0			;we had one, add one to counter
	dbra	d1,.countS

.smpEnd	cmp.l	#1,d0
	beq	ErrorEdit

; create temp file name

.notEQ	lea	IFile(pc),a0
	lea	OFile(pc),a1
.copyF	move.b	(a0)+,(a1)+
	bne.b	.copyF
	lea	-1(a1),a1
	lea	Ext(pc),a0
.copyX	move.b	(a0)+,(a1)+
	bne.b	.copyX

; try open temp file

	move.l	#OFile,d1
	move.l	#MODE_NEWFILE,d2
	Call	Open
	move.l	d0,OHan
	beq	ErrorOpenO

; copy header info

	move.l	Mem(pc),a0
	move.l	Header(pc),a1
	move.l	#S16S_res/2,d0
.copyH1	move.w	(a0)+,(a1)+
	subq.l	#1,d0
	bne.b	.copyH1

; copy region list

	move.l	Mem(pc),a0
	move.l	Header(pc),a1
	lea	S16S_REGIONLIST(a0),a0
	lea	S16S_REGIONLIST(a1),a1
	move.l	#MAXREGIONS*S16R_SIZEOF/4,d0
.copyR	move.l	(a0)+,(a1)+
	subq.l	#1,d0
	bne.b	.copyR

	move.l	Mem(pc),a0
	move.l	Header(pc),a1

	move.l	S16S_EDITSIZE(a0),d0
	move.l	d0,EditSize
	move.l	d0,S16S_REALSIZE(a1)
	move.l	d0,S16S_EDITSIZE(a1)
	subq.l	#1,d0
	move.l	d0,S16S_END(a1)
	move.l	#S16FILTERINIT,S16S_FILTER(a1)

	move.l	OHan(pc),d1
	move.l	Header(pc),d2
	move.l	#S16S_SIZEOF,d3
	Call	Write
	cmp.l	#-1,d0
	beq	ErrorWrite
*------------------------------------------------------------------------------------------------------------*
; Start MAIN converting

Main	move.l	#StartTxt,d1
	Call	PutStr

	move.l	Mem(pc),a5
	lea	S16S_EDITLIST(a5),a5

.loop	move.l	(a5)+,d6		;start
	move.l	(a5)+,d7		;end
	beq	.done
	addq.l	#1,d7			;add 1

	move.l	d6,Buff
	move.l	d7,Buff+4

	LibBase	exec
	lea	String(pc),a0
	lea	Buff(pc),a1
	lea	Proc(pc),a2
	lea	Buff+8(pc),a3
	Call	RawDoFmt

	LibBase	dos
	move.l	a3,d1
	Call	PutStr

	sub.l	d6,d7			;difference=size of buffer
	move.l	d7,Buff
	add.l	d7,Total		;update total counter
	asl.l	#1,d7			;*2 for bytesize - D7=size of part
	asl.l	#1,d6			;startpos.

	LibBase	exec
	lea	String2(pc),a0
	lea	Buff(pc),a1
	lea	Proc(pc),a2
	lea	Buff+4(pc),a3
	Call	RawDoFmt

	LibBase	dos
	move.l	a3,d1
	Call	PutStr

;seek to START

	add.l	#S16S_SIZEOF,d6

	move.l	IHan(pc),d1
	move.l	d6,d2
	move.l	#OFFSET_BEGINNING,d3
	Call	Seek
	cmp.l	#-1,d0
	beq	ErrorSeek

; read part, buffered

	moveq	#-1,d5
.copy	tst.b	d5
	beq	.loop

	move.l	IHan(pc),d1
	move.l	Mem(pc),d2
	add.l	#S16S_SIZEOF,d2
	move.l	d7,d3
	cmp.l	#Buffer-S16S_SIZEOF,d3
	ble	.sizeOk
	move.l	#Buffer-S16S_SIZEOF,d3
.sizeOk	move.l	d3,d4
	Call	Read

	move.l	d0,d3
	beq	.done
	cmp.l	d4,d3
	beq	.readOk
	cmp.l	#-1,d3
	beq	ErrorRead

	moveq	#0,d5

.readOk	move.l	OHan(pc),d1
	move.l	Mem(pc),d2
	add.l	#S16S_SIZEOF,d2
	Call	Write

	cmp.l	d3,d0
	bne	ErrorWrite
	cmp.l	#-1,d0
	beq	ErrorWrite
	sub.l	d3,d7
	bne	.copy
	bra	.loop

.done	LibBase	exec

	move.l	#EditOk,EditStatus
	move.l	Total(pc),d0
	move.l	EditSize(pc),d1
	cmp.l	d0,d1
	beq	.EdOk
	move.l	#EditErr,EditStatus

.EdOk	lea	String3(pc),a0
	lea	EditSize(pc),a1
	lea	Proc(pc),a2
	lea	Buff(pc),a3
	Call	RawDoFmt

	LibBase	dos
	move.l	a3,d1
	Call	PutStr

	move.l	IHan(pc),d1
	Call	Close
	clr.l	IHan
	move.l	OHan(pc),d1
	Call	Close
	clr.l	OHan

	move.l	#Ifile,d1
	Call	DeleteFile
	tst.l	d0
	beq	ErrorDel

	move.l	#OFile,d1
	move.l	#IFile,d2
	Call	Rename
	tst.l	d0
	beq	ErrorRename

*------------------------------------------------------------------------------------------------------------*
Close	LibBase	exec
	move.l	Mem(pc),d0
	beq	.noMem
	move.l	d0,a1
	move.l	#Buffer,d0
	Call	FreeMem

.noMem	LibBase	dos
	move.l	IHan(pc),d1
	beq	.noI
	Call	Close

.noI	move.l	OHan(pc),d1
	beq	.noO
	Call	Close

.noO	move.l	Warn(pc),d0
	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Proc	move.b	d0,(a3)+
	rts

ErrorMem	Dump	ErrMem
ErrorOpenI	Dump	ErrOpenI
ErrorOpenO	Dump	ErrOpenO
ErrorRead	Dump	ErrRead
ErrorWrite	Dump	ErrWrite
ErrorType	Dump	ErrType
ErrorEdit	Dump	ErrEdit
ErrorSeek	Dump	ErrSeek
ErrorDel	Dump	ErrDel
ErrorRename	Dump	ErrRename

About		move.l	#AboutTxt,d1

Print		LibBase	dos
		Call	PutStr
		bra	Close
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Warn		dc.l	0
IHan		dc.l	0
OHan		dc.l	0
Mem		dc.l	0
Header		dc.l	0
EditSize	dc.l	0
Total		dc.l	0
EditStatus	dc.l	0

Buff		dcb.b	70,0
IFile		dcb.b	300,0
OFile		dcb.b	300,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
ErrMem		dc.b	"Out of memory! Need 400kb..",10,0
ErrOpenI	dc.b	"Couldn't open input file!",10,0
ErrOpenO	dc.b	"Couldn't open temp file for write!",10,0
ErrRead		dc.b	"Error reading file!",10,0
ErrWrite	dc.b	"Error writing file!",10,0
ErrType		dc.b	"This is not a Studio 16 3.0 file!",10,0
ErrEdit		dc.b	"File is already made permanent!",10,0
ErrSeek		dc.b	"Error Seek()'ing file while permanenting!",10,0
ErrDel		dc.b	"Couldn't remove temp file!",10,0
ErrRename	dc.b	"Couldn't rename temp file to original!",10,0

StartTxt	dc.b	10,"EDIT TABLE:",10
		dc.b	"-------------------------------------------------------",10,0
String		dc.b	"Start: %10.ld  Stop: %10.ld",0
String2		dc.b	"  Size: %10.ld",10,0
String3		dc.b	10,"Original edit size: %ld  New size: %ld (%s)",10,10,0

Ext		dc.b	".edit",0
EditOk		dc.b	"OK",0
EditErr		dc.b	"ERROR",0

AboutTxt	dc.b	10,27,"[1mS16MakePermanent",27,"[0m 1.1 by Kenneth 'Kenny' Nilsen (kenny@bgnett.no)",10,10
		dc.b	"    USAGE: S16MakePermanent <Studio 16 file>",10,10,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
