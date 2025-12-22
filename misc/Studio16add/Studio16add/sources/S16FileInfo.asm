*>b:S16FileInfo

	*«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*
	*   Copyright © 1997 by Kenneth "Kenny" Nilsen.  E-Mail: kenny@bgnett.no		      *
	*   Source viewed in 800x600 with mallx.font/thin711.font (11) in CED			      *
	*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
	*
	*   Name
	*	S16FileInfo
	*
	*   Function
	*	Show some information on Studio 16 files
	*
	*   Inputs
	*	<file> [options]
	*
	*	-l = list SampleClips list
	*	-r = list Region list
	*
	*   Notes
	*	Use PhxAss to assemble this source.
	*	This source is the public domain as long as original copyright is used.
	*
	*	The *>... in top is used for PhxAss Arexx scipt (Aminet) from CygnusED.
	*
	*   Bugs
	*	
	*   Created	: 14.11.97
	*   Changes	: 14.11.97, 17.11.97, 26.11.97
	*««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*


		Incdir	inc:

		include	lvo/exec_lib.i
		include	lvo/dos_lib.i

		include	libraries/studio16file.i
		include	dos/dos.i
		include	exec/types.i

		include	digital.macs
		include	startup.asm

		Incdir	""

		dc.b	"$VER: S16FileInfo 2.2 (26.11.97)",10
		dc.b	"Copyright © 1997 Digital Surface. All rights reserved. ",0
		even
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Dump	macro	;Open -> ErrorOpen Dump ErrOpen
Error\1	move.l	#Err\1,d1
	bra	Print
	endm

Buffer	=	S16S_SIZEOF
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Init		DefLib	dos,37		;open dos.library version 37 (NewStartup.asm)
		DefEnd			;no more libs to open

Start	NextArg				;get Arg if any
	beq	About			;none then show About
	move.l	d0,a0
	cmp.b	#'?',(a0)		;asked for about
	beq	About

	lea	IFile(pc),a1
.copyI	move.b	(a0)+,(a1)+		;copy firstarg=filename to buffer
	bne.b	.copyI

.argLoop				;get options if any
	NextArg
	beq	.argsOk			;end of args
	move.l	d0,a0
	and.b	#($ff-$20),1(a0)	;upper case option

	cmp.w	#'-L',(a0)		;is it -l or -L
	beq	.setList
	cmp.w	#'-R',(a0)		;is it -r or -R
	bne	About

.setRegion
	st	Regions			;set Show Regions true
	bra	.argLoop
.setList
	st	List			;set Show SampleClips true
	bra	.argLoop
*------------------------------------------------------------------------------------------------------------*
.argsOk

; open file and IDentify

	LibBase	dos
	move.l	#IFile,d1		;filename
	move.l	#MODE_OLDFILE,d2
	Call	Open
	move.l	d0,IHan
	beq	ErrorOpen		;error opening ?

; alloc memory for header

	LibBase	exec
	move.l	#Buffer,d0
	move.l	#$10001,d1
	Call	AllocMem		;alloc memory for header
	move.l	d0,Mem
	beq	ErrorMem

; read header into buffer

	LibBase	dos
	move.l	IHan(pc),d1
	move.l	Mem(pc),d2
	move.l	#Buffer,d3
	Call	Read			;read header into memory
	cmp.l	d3,d0
	bne	ErrorRead

; ID of file

	move.l	Mem(pc),a0
	cmp.l	#'KWK3',(a0)		;IDentify file
	bne	ErrorType

*------------------------------------------------------------------------------------------------------------*
; recalc volume

	move.w	S16S_VOLUME(a0),d0
	asr.w	#5,d0			;/32
	sub.w	#100,d0			;-100 (so we get dB)
	move.w	d0,S16S_VOLUME(a0)

; recalc pan

	move.l	S16S_PAN(a0),d0
	asr.l	#5,d0			;/32
	move.l	d0,S16S_PAN(a0)

; recalc SMPTE

	move.l	S16S_SMPTE(a0),d0	;SMPTE LONG word
	moveq	#0,d1
	move.b	d0,d1
	move.w	d1,S16S_SMPTE+6(a0)	;store FF - _SMPTEFLOAT is overwritten here
	asr.l	#8,d0
	move.b	d0,d1
	move.w	d1,S16S_SMPTE+4(a0)	;store SS - _SMPTEFLOAT is overwritten here
	asr.l	#8,d0
	move.b	d0,d1
	move.w	d1,S16S_SMPTE+2(a0)	;store MM
	asr.l	#8,d0
	move.b	d0,d1
	move.w	d1,S16S_SMPTE(a0)	;store HH

*------------------------------------------------------------------------------------------------------------*
; count SampleClips

	lea	S16S_EDITLIST(a0),a1	;Show main clip as well
	moveq	#0,d0			;SampleClip counter
	moveq	#MAXSAMPLECLIPS-1,d1	;list tracker counter
.countS	move.l	(a1)+,d2		;_START
	move.l	(a1)+,d3		;_END
	beq	.smpEnd
	addq.l	#1,d0			;we had one, add one to counter
	dbra	d1,.countS

.smpEnd	move.l	d0,S16S_FLAGS(a0)	;use the _FLAG field since we won't use it anyway
	cmp.l	#1,d0
	bne	.numSC			;no SampleClips ?
	clr.b	List			;then set user-want-list to false (no list)
.numSC
*------------------------------------------------------------------------------------------------------------*
; count Regions

	lea	S16S_REGIONLIST(a0),a1	;ptr. to regions
	moveq	#0,d0			;Regions counter
	moveq	#MAXREGIONS-1,d1	;list tracker counter
.countR	tst.b	(a1)			;Null terminated ? then we're done
	beq	.regEnd
	addq.l	#1,d0			;add one if a Region
	lea	S16R_SIZEOF(a1),a1	;next region struct
	dbra	d1,.countR

.regEnd	move.l	d0,S16S_RES(a0)		;store in this field since we won't use it anyway
	bne	.regList		;no regions ?
	clr.b	Regions			;set user-want-region-list to false
.regList

*------------------------------------------------------------------------------------------------------------*
; OK, we're ready to dump info to user

	LibBase	exec
	lea	String(pc),a0
	move.l	Mem(pc),a1
	move.l	#Ifile,(a1)		;set filename where ID is
	lea	Proc(pc),a2
	lea	Buff(pc),a3
	Call	RawDoFmt		;format what we have using header as table

	LibBase	dos
	move.l	#Buff,d1
	Call	PutStr			;show formatted buffer

*------------------------------------------------------------------------------------------------------------*
; do user want a SampleClip list ?

	tst.b	List			;show SampleClips ?
	beq	.noList

	move.l	#SampleList,d1
	Call	PutStr

	move.l	Mem(pc),a5
	lea	S16S_EDITLIST(a5),a5	;use _EDITLIST
.Sloop	move.l	(a5)+,d0		;_START
	move.l	(a5)+,d1		;_END
	beq	.noList
	addq.l	#1,d1			;add one to _END
	move.l	d0,Table		;store in table
	move.l	d1,Table+4
	sub.l	d0,d1			;range SIZE
	move.l	d1,Table+8

	LibBase	exec
	lea	SampleString(pc),a0
	lea	Table(pc),a1
	lea	Proc(pc),a2
	lea	Buff(pc),a3
	Call	RawDoFmt

	LibBase	dos
	move.l	#Buff,d1
	Call	PutStr			;show SampleClip entry

	bra	.Sloop

*------------------------------------------------------------------------------------------------------------*
; do user want a Region list ?

.noList	tst.b	Regions			;show Regions ?
	beq	.done

	move.l	#RegionList,d1
	Call	PutStr

	move.l	Mem(pc),a5
	lea	S16S_REGIONLIST(a5),a5	;ptr. to Regions
.Rloop	tst.b	(a5)
	beq	.done			;null term. ? then done

	move.l	S16R_START(a5),d0	;_START
	move.l	S16R_END(a5),d1		;_END
	addq.l	#1,d1			;add one to _END
	move.l	d0,Table
	move.l	d1,Table+4
	sub.l	d0,d1			;SIZE of range
	move.l	d1,Table+8
	move.l	a5,Table+12		;name on region (first in struct)

	LibBase	exec
	lea	RegionString(pc),a0
	lea	Table(pc),a1
	lea	Proc(pc),a2
	lea	Buff(pc),a3
	Call	RawDoFmt

	LibBase	dos
	move.l	#Buff,d1
	Call	PutStr			;show Region entry

	lea	S16R_SIZEOF(a5),a5	;next Region
	bra	.Rloop

*------------------------------------------------------------------------------------------------------------*
.done	move.l	#EndString,d1
	Call	PutStr
*------------------------------------------------------------------------------------------------------------*
Close	LibBase	exec			;clean up memory if any
	move.l	Mem(pc),d0
	beq	.noMem
	move.l	d0,a1
	move.l	#Buffer,d0
	Call	FreeMem

.noMem	LibBase	dos			;clean up handler if any
	move.l	Ihan(pc),d1
	beq	.noIn
	Call	Close

.noIn	move.l	Warn(pc),d0		;return code (0=ok, 5=some error)
	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Proc	move.b	d0,(a3)+
	rts

; show errors

	Dump	Open
	Dump	Mem
	Dump	Read
	Dump	Type

About	move.l	#AboutTxt,d1

Print	move.w	#5,Warn+2
	LibBase	dos
	Call	PutStr
	bra	Close
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Warn		dc.l	0
Mem		dc.l	0
IHan		dc.l	0

Table		dc.l	0,0,0

IFile		dcb.b	300,0
Buff		dcb.b	600,0

List		dc.b	0
Regions		dc.b	0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
ErrOpen		dc.b	"Couldn't open file!",10,0
ErrMem		dc.b	"Out of memory - need 3690 bytes!",10,0
ErrRead		dc.b	"Error reading file - file is mangled!",10,0
ErrType		dc.b	"Not a Studio 16 file (KWK3)!",10,0

String		dc.b	10
		dc.b	27,"[1mFileinfo",27,"[0m on sample '",27,"[3m%s",27,"[0m'",10,10
		dc.b	"             Samplerate: %ld",10
		dc.b	"                 Filter: %ld",10
		dc.b	"                 Volume: %d dB",10
		dc.b	"                  SMPTE: %02.d:%02.d:%02.d:%02.d",10
		dc.b	"                    PAN: %ld",10,10
		dc.b	"  Number of SampleClips: %ld",10
		dc.b	"      Number of Regions: %ld",10,10
		dc.b	"       Real Sample size: %ld samples",10
		dc.b	"       Edit Sample size: %ld samples",10,0

SampleString	dc.b	27,"[1mSTART",27,"[0m: %9.ld - ",27,"[1mEND",27,"[0m: %9.ld - ",27,"[1mSIZE",27,"[0m: %9.ld",10,0
RegionString	dc.b	27,"[1mSTART",27,"[0m: %9.ld - ",27,"[1mEND",27,"[0m: %9.ld - ",27,"[1mSIZE",27,"[0m: %9.ld ('%s')",10,0

EndString	dc.b	10,0

SampleList	dc.b	10,27,"[1mSAMPLECLIPS:",27,"[0m",10,10,0
RegionList	dc.b	10,27,"[1mREGIONS:",27,"[0m",10,10,0

AboutTxt	dc.b	10,27,"[1mS16FileInfo",27,"[0m 2.2 by Kenneth 'Kenny' Nilsen (kenny@bgnett.no)",10
		dc.b	"-----------------------------------------------------------",10,10
		dc.b	"    USAGE: S16FileInfo <file> [-l] [-r]",10,10
		dc.b	"    -l = List SampleClips list",10
		dc.b	"    -r = List Region list",10,10,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
