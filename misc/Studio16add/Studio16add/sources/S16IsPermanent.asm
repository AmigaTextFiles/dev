*>b:S16IsPermanent

	*«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*
	*   Copyright © 1997 by Kenneth "Kenny" Nilsen.  E-Mail: kenny@bgnett.no		      *
	*   Source viewed in 800x600 with mallx.font (11) in CED				      *
	*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
	*
	*   Name
	*	S16IsPermanent
	*
	*   Function
	*	Check if a Studio 16 file contains edits
	*
	*   Inputs
	*	<file>
	*
	*   Notes
	*	2.0 = total rewrite
	*
	*   Bugs
	*	
	*   Created	: 12.11.97
	*   Changes	: 12.11.97, 13.11.97, 26.11.97
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

		dc.b	"$VER: S16IsPermanent 2.0 (26.11.97)",10
		dc.b	"Copyright © 1997 Digital Surface. All rights reserved. ",0
		even
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Dump	macro
	move.l	#5,Warn
	move.l	#\1,d1
	bra	Print
	endm

Buffer	=	S16S_sizeof
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
	bne	ErrorEdit

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
	bne	ErrorEdit

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

.noI	move.l	Warn(pc),d0
	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Proc	move.b	d0,(a3)+
	rts

ErrorMem	Dump	ErrMem
ErrorOpenI	Dump	ErrOpenI
ErrorRead	Dump	ErrRead
ErrorType	Dump	ErrType
ErrorEdit	Dump	ErrEdit

About		move.l	#AboutTxt,d1
		move.l	#10,Warn

Print		LibBase	dos
		Call	PutStr
		bra	Close
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Warn		dc.l	0
IHan		dc.l	0
Mem		dc.l	0

IFile		dcb.b	300,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
ErrMem		dc.b	"Out of memory!",10,0
ErrOpenI	dc.b	"Couldn't open input file!",10,0
ErrRead		dc.b	"Error reading file!",10,0
ErrType		dc.b	"This is not a Studio 16 3.0 file!",10,0
ErrEdit		dc.b	"File contains edits!",10,0

AboutTxt	dc.b	10,27,"[1mS16IsPermanent",27,"[0m 2.0 by Kenneth 'Kenny' Nilsen (kenny@bgnett.no)",10,10
		dc.b	"    USAGE: S16IsPermanent <Studio 16 file>",10,10,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
