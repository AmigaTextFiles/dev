*>b:S16IsStudio

	*«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*
	*   Copyright © 1997 by Kenneth "Kenny" Nilsen.  E-Mail: kenny@bgnett.no		      *
	*   Source viewed in 800x600 with mallx.font (11) in CED				      *
	*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
	*
	*   Name
	*	S16IsStudio
	*
	*   Function
	*	Check if a valid studio 16 file
	*
	*   Inputs
	*	<file>
	*
	*   Notes
	*	
	*   Bugs
	*	
	*   Created	: 11.11.97
	*   Changes	: 11.11.97, 26.11.97
	*««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*


;StartSkip	SET	1
;DODUMP		SET	1


		Incdir	""

		include	lvo:exec_lib.i
		include	lvo:dos_lib.i

		Incdir	inc:

		include	digital.macs
		include	digital.i
		include	dos/dos.i
		include	libraries/studio16file.i

		include	startup.asm

		Incdir	""

		dc.b	"$VER: S16IsStudio 1.1 (26.11.97)",10
		dc.b	"Copyright © 1997 Digital Surface. All rights reserved. ",0
		even
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Init		DefLib	dos,37
		DefEnd

Start	LibBase	dos

	NextArg
	beq	About
	move.l	d0,a0
	cmp.b	#'?',(a0)
	beq	About

	lea	FileN(pc),a1
.copy	move.b	(a0)+,(a1)+
	bne.b	.copy

;copy filepart to own buffer

	lea	FileN+300(pc),a0
	move.l	#300,d0
.findDr	move.b	(a0),d1
	cmp.b	#'/',d1
	beq	.ok
	cmp.b	#':',d1
	beq	.ok
	lea	-1(a0),a0
	subq	#1,d0
	bne	.findDr
	lea	-1(a0),a0

.ok	lea	1(a0),a0
	lea	Buffer(pc),a1
.copyN	move.b	(a0)+,(a1)+
	bne.b	.copyN

	move.l	#FileN,d1
	move.l	#MODE_OLDFILE,d2
	Call	Open
	move.l	d0,Handler
	beq	ErrorOpen

	move.l	d0,d1
	move.l	#Buff,d2
	moveq	#4,d3
	Call	Read
	cmp.l	#4,d0
	bne	ErrorRead

	move.l	Buff(pc),d0
	cmp.l	#'KWK3',d0
	bne	Errortype

*------------------------------------------------------------------------------------------------------------*
Close	move.l	Handler(pc),d1
	beq	.noHan
	Call	Close

.noHan	move.l	Warn(pc),d0
	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Proc	move.b	d0,(a3)+
	rts

ErrorType	LibBase	exec
		lea	TypeTxt(pc),a0
		lea	Table(pc),a1
		lea	Proc(pc),a2
		lea	FileN(pc),a3
		Call	rawDoFmt
		LibBase	dos
		move.l	#5,Warn
		move.l	#FileN,d1
		bra	Print

ErrorOpen	LibBase	exec
		lea	ErrOpen(pc),a0
		lea	Table(pc),a1
		lea	Proc(pc),a2
		lea	FileN(pc),a3
		Call	rawDoFmt
		LibBase	dos
		move.l	#FileN,d1
		move.l	#5,Warn
		bra	Print

ErrorRead	move.l	#ErrRead,d1
		move.l	#5,Warn
		bra	Print

ErrorSeek	move.l	#ErrSeek,d1
		move.l	#5,Warn
		bra	Print

About		move.l	#AboutTxt,d1

Print		Call	PutStr
		bra	Close
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
FileN		dcb.b	300,0
Buffer		dcb.b	30,0
Handler		dc.l	0
Buff		dc.l	0
Table		dc.l	Buffer
Warn		dc.l	0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
ErrOpen		dc.b	"Couldn't open file '%s'!",10,0
ErrRead		dc.b	"Error reading file!",10,0
ErrSeek		dc.b	"Error seeking file!",10,0
ErrType		dc.b	"Not a Studio 16 (3.0) file!",10,0

TypeTxt		dc.b	"File '%s' is not a Studio 16 file (3.0)!",10,0

AboutTxt	dc.b	10,"[1mS16IsStudio[0m 1.1 by Kenneth 'Kenny' Nilsen (kenny@bgnett.no)",10,10
		dc.b	"    USAGE: S16IsStudio <file>",10,10,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
