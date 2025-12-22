*>b:DumpCue

	*«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*
	*   Copyright © 1997 by Kenneth "Kenny" Nilsen.  E-Mail: kenny@bgnett.no		      *
	*   Source viewed in 800x600 with mallx.font (11) in CED				      *
	*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
	*
	*   Name
	*	DumpCue
	*
	*   Function
	*	DEMO - Dump cuelist files or track files
	*
	*   Inputs
	*	[Cuelist file | track file]
	*
	*   Notes
	*	This source is just meant as an example on how to read Cuelist files.
	*	It was orignally written to test if the assembler include was correct.
	*	It was written in a couple of hour and there are plenty of room for
	*	optimizing and speed (read structures into memory at once etc..)
	*	The slow speed is due to buffered IO and many subroutines.
	*	It's not very well commented either..
	*
	*	The source is public domain - Do what you want with it..
	*
	*	There is also an AREXX version in the rexx/ directory.
	*
	*   Bugs
	*	
	*   Created	: 05.12.97
	*   Changes	: 06.12.97, 08.12.97
	*««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*


;StartSkip	SET	1
;DODUMP		SET	1

		Incdir	inc:

		include	lvo/exec_lib.i
		include	lvo/dos_lib.i

		include	digital.macs
		include	digital.i
		include	libraries/studio16file.i
		include	lvo/mathieeedoubbas_lib.i
		include	lvo/mathieeesingbas_lib.i

		include	dos/dos.i
		include	exec/types.i

		include	startup.asm

		Incdir	""

		dc.b	"$VER: DumpCue 1.1 (08.12.97)",10
		dc.b	"Copyright © 1997 Digital Surface. All rights reserved. ",0
		even
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Dump	macro
Error\1	move.l	#Err\1,d1
	bra	Print
	endm

xRead	macro
	move.l	Han(pc),d1
	move.l	\1,d2
	move.l	#\2,d3
	Call	Read
	cmp.l	d0,d3
	bne	ErrorRead
	endm

yRead	macro
	move.l	Han(pc),d1
	move.l	\1,d2
	move.l	\2,d3
	Call	Read
	cmp.l	d0,d3
	bne	ErrorRead
	endm

ReadString	macro
	bsr	ReadStr
	endm

FPrint	macro
	lea	\1(pc),a0
	bsr	FPrintSub
	endm

Buffer	=	1024*10		;for misc data
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Init		DefLib	dos,37
		DefLib	mathieeedoubbas,37
		DefLib	mathieeesingbas,37
		DefEnd

Start	NextArg			;does user want help ?
	beq	About
	move.l	d0,a0
	cmp.b	#'?',(a0)
	beq	About
	move.l	a0,IFile	;store pointer to arg

	NextArg
	bne	About		;there should only be one arg

; alloc some memory

	move.l	#Buffer,d0
	move.l	#$10001,d1
	Call	AllocMem
	move.l	d0,Mem
	beq	ErrorMem

; try open this file and check identity

	LibBase	dos
	move.l	IFile(pc),d1
	move.l	#MODE_OLDFILE,d2
	Call	Open
	move.l	d0,Han
	beq	ErrorOpen

	move.l	#StartTxt,d1
	Call	PutStr

	xRead	#IFile,4

	move.l	IFile(pc),d0
	cmp.l	#ID_TRAX,d0
	beq	TRAX
	cmp.l	#ID_TLC,d0
	bne	Errortype

*------------------------------------------------------------------------------------------------------------*
TLC	;Read header of file

	xRead	Mem(pc),16
	FPrint	HeadWin		;dump window positions when saved

; read misc paths/names

	ReadString
	FPrint	TrackPath
	ReadString
	FPrint	CuelistPath
	ReadString
	FPrint	TrackName
	ReadString
	FPrint	CuelistName

; read main header

	xRead	Mem(pc),6	;skip 6 bytes for now

;1.1 - check if null, if not dump:

	move.l	Mem(pc),a0
	tst.l	(a0)
	bne	.dumpSk
	tst.w	4(a0)
	beq	.noNews

.dumpSk
	FPrint	HeaderNews

; dump fade-in/out type:

.noNews	bsr	FadeType
	FPrint	FadeinType
	bsr	FadeType
	FPrint	FadeoutType

; dump maximum time, grid spacing, cuelist start and total length

	bsr	GetFloat
	FPrint	MaxTime
	bsr	GetFloat
	FPrint	GridSpace
	bsr	GetFloat
	FPrint	StartTime

	xRead	Mem(pc),4
	bsr	CalcTime
	FPrint	TotalLength
	xRead	Mem(pc),4
	bsr	CalcTime
	FPrint	ViewSize
	xRead	Mem(pc),4
	bsr	CalcTime
	FPrint	ViewStart

	move.l	Mem(pc),a2
	xRead	a2,4		;BPM
	lea	4(a2),a2
	xRead	a2,4		;X/
	lea	4(a2),a2
	xRead	a2,4		; /Y
	FPrint	BPM

; time options

	xRead	Mem(pc),4
	move.l	Mem(pc),a0
	move.l	(a0),Temp
	move.l	(a0),d0
	beq	.hms
	cmp.w	#TLCTIME_SMPTE,d0
	beq	.smpte
	cmp.w	#TLCTIME_SMPTEPLUS,d0
	beq	.smpteplus
	cmp.w	#TLCTIME_BPM,d0
	bne	.unknown

.bpm	move.l	#TIMEBPM,(a0)
	bra	.showTime
.hms	move.l	#TIMEHMS,(a0)
	bra	.showTime
.smpte	move.l	#TIMESMPTE,(a0)
	bra	.showtime
.smpteplus
	move.l	#TIMESMPTEPLUS,(a0)
	bra	.showtime
.unknown
	move.l	Temp(pc),(a0)
	FPrint	Unknown
	bra	.skipTO

.showTime
	FPrint	TimeOpts

.skipTO	xRead	Mem(pc),122	;skip reserved data

; read Fxx flag marks

	moveq	#1,d6
	moveq	#9,d5
.loop	bsr	GetFloat
	move.l	Mem(pc),a5
	move.l	(a5),d0
	move.l	4(a5),d1
	move.l	d0,4(a5)
	move.l	d1,8(a5)
	move.l	d6,(a5)
	xRead	#Temp,4		;skip view flag

	lea	16(a5),a5
	move.l	a5,-4(a5)
	xRead	a5,80+30

	move.l	Mem(pc),a5
	cmp.l	#-1,4(a5)
	bne	.markok
	move.l	#NotInUse,12(a5)
.markok	FPrint	FMark

	addq.l	#1,d6
	dbra	d5,.loop

; read red locate flag

	bsr	GetFloat
	xRead	#Temp,4
	move.l	Mem(pc),a0
	lea	12(a0),a0
	move.l	a0,-4(a0)
	xRead	a0,80+30
	FPrint	LocateF

; read blue start flag

	bsr	GetFloat
	xRead	#Temp,4
	move.l	Mem(pc),a0
	lea	12(a0),a0
	move.l	a0,-4(a0)
	xRead	a0,80+30
	FPrint	StartF

; read yellow punch-in flag

	bsr	GetFloat
	xRead	#Temp,4
	move.l	Mem(pc),a0
	lea	12(a0),a0
	move.l	a0,-4(a0)
	xRead	a0,80+30
	FPrint	PunchinF

; read yellow punch-out flag

	bsr	GetFloat
	xRead	#Temp,4
	move.l	Mem(pc),a0
	lea	12(a0),a0
	move.l	a0,-4(a0)
	xRead	a0,80+30
	FPrint	PunchoutF

; skip reserved space and start on the chunks

	xRead	Mem(pc),100

	clr.l	TrackNo

*------------------------------------------------------------------------------------------------------------*
TRAX	LibBase	exec

	moveq	#0,d0
	moveq	#0,d1
	bset	#12,d1
	Call	SetSignal
	btst	#12,d0
	bne	CtrlC

	LibBase	dos

	move.l	Mem(pc),a5
	xRead	a5,4		;get chunk name

	cmp.l	#ID_TYPE,(a5)
	beq	CType
	cmp.l	#ID_SAMP,(a5)
	beq	CSamp
	cmp.l	#ID_EVNT,(a5)
	beq	CEvent
	cmp.l	#ID_END,(a5)
	beq	CEnd

	move.l	#UnknownChunk,d1
	Call	PutStr
	bra	Close
*------------------------------------------------------------------------------------------------------------*
CType	add.l	#1,TrackNo
	move.l	#1,EntryNo

	move.l	Mem(pc),a0
	move.l	TrackNo(pc),(a0)
	FPrint	TypeNo

	ReadString
	FPrint	TypeType

	cmp.l	#'Audi',4(a5)
	beq	.audio
	cmp.l	#'AREX',4(a5)
	beq	.rexx

	move.l	#UnknownType,d1
	Call	PutStr
	bra	Close

.audio	ReadString
	FPrint	TrackNam	;name on audio track
	bsr	GetFloat
	FPrint	TrackFreq	;frequency
	bsr	EntryPrefs	;show prefs for entries
	FPrint	EntryUnsel
	bsr	EntryPrefs	;show prefs for entries
	FPrint	EntrySel
	bsr	TrackStatus	;show track status
	FPrint	TrackStat
	xRead	Mem(pc),1	;skip entries prefs

	ReadString
	FPrint	PlayChan
	ReadString
	FPrint	RecChan

	xRead	Mem(pc),100	;skip reserved bytes
	bra	TRAX

.rexx	ReadString
	FPrint	TrackNam
	ReadString
	FPrint	PortNam
	xRead	Mem(pc),2
	bsr	TrackStatus
	FPrint	TrackStat
	xRead	Mem(pc),101	;skip pad + reserved bytes
	bra	TRAX
*------------------------------------------------------------------------------------------------------------*
CSamp	move.l	Mem(pc),a0
	move.l	TrackNo(pc),(a0)+
	move.l	EntryNo(pc),(a0)
	FPrint	SampleNo
	add.l	#1,EntryNo
	add.l	#1,EntryTotal

	bsr	SampStatus
	FPrint	SampleStatus	;status of entry
	bsr	GetFloat
	FPrint	SampleStart	;start pos
	bsr	GetFloat
	FPrint	SampleEnd	;end pos
	xRead	Mem(pc),4	;reserved
	xread	Mem(pc),4	;group
	move.l	Mem(pc),a0
	tst.l	(a0)
	beq	.noGRP
	FPrint	SampleGroup	;print group if any
.noGRP	ReadString
	FPrint	SampleName	;path/name
	xRead	Mem(pc),2
	bsr	FadeType
	FPrint	SampleFadein	;fade-in type
	bsr	FadeType
	FPrint	SampleFadeout
	bsr	GetFloat
	FPrint	SampleFadeinT	;fade-in time
	bsr	GetFloat
	FPrint	SampleFadeoutT
	xRead	Mem(pc),4	;crop-in
	FPrint	SampleCropIn
	xRead	Mem(pc),4	;crop-in
	FPrint	SampleCropOut

	xread	Mem(pc),2	;volume
	move.l	Mem(pc),a0
	move.w	(a0),d0
	ext.l	d0
	asr.l	#5,d0
	sub.l	#100,d0
	move.l	d0,(a0)
	FPrint	SampleVol

	xread	Mem(pc),4	;pan
	move.l	Mem(pc),a0
	move.w	(a0),d0
	asr.l	#5,d0

	move.l	#PanRight,(a0)
	cmp.l	#100,d0
	bgt	.right
	move.l	#PanLeft,(a0)
.right	cmp.l	#100,d0
	beq	.center
	tst.l	d0
	beq	.left
	cmp.l	#200,d0
	bne	.panok
	move.l	#PanFullRight,(a0)
	bra	.panok
.left	move.l	#PanFullLeft,(a0)
	bra	.panok
.center	move.l	#PanCenter,(a0)
.panOk	FPrint	SamplePan

	xRead	Mem(pc),50	;reserved space
	bra	TRAX
*------------------------------------------------------------------------------------------------------------*
CEnd	xRead	Mem(pc),4
	move.l	Mem(pc),a0
	cmp.l	#ID_END,(a0)
	beq	EndOfFile
	move.l	Han(pc),d1
	moveq	#-4,d2
	move.l	#OFFSET_CURRENT,d3
	Call	Seek
	bra	TRAX
*------------------------------------------------------------------------------------------------------------*
CEvent	move.l	Mem(pc),a0
	move.l	TrackNo(pc),(a0)+
	move.l	EntryNo(pc),(a0)
	FPrint	EventNo
	add.l	#1,EntryNo
	add.l	#1,EntryTotal

	xRead	Mem(pc),4
	move.l	Mem(pc),a0
	move.l	(a0),d0
	move.l	#EventUnsel,(a0)
	tst.w	d0
	beq	.noStat
	move.l	#EventSel,(a0)

.noStat	FPrint	EventStatus	;status of entry
	bsr	GetFloat
	FPrint	EventStart	;start pos
	bsr	GetFloat

	xRead	Mem(pc),4	;skip End and reserved
	xRead	Mem(pc),4	;Group

	move.l	Mem(pc),a0
	move.l	(a0),d0
	beq	.noEGRP
	FPrint	EventGroup
.noEGRP	xRead	Mem(pc),4	;skip reserved

	ReadString
	FPrint	EventName	;event name

	xRead	Mem(pc),4	;SMPTE stamp
	move.l	Mem(pc),a0
	move.l	(a0),d0
	
	move.b	d0,d1
	asr.l	#8,d0
	and.l	#$ff,d1
	move.w	d1,6(a0)

	move.b	d0,d1
	asr.l	#8,d0
	and.l	#$ff,d1
	move.w	d1,4(a0)

	move.b	d0,d1
	asr.l	#8,d0
	and.l	#$ff,d1
	move.w	d1,2(a0)

	move.b	d0,d1
	asr.l	#8,d0
	and.l	#$ff,d1
	move.w	d1,(a0)

	FPrint	EventStamp	

	moveq	#8,d5
.cmdlp	ReadString
	FPrint	EventCmd
	move.l	Mem(pc),a0
	clr.l	4(a0)
	dbra	d5,.cmdlp

	xRead	Mem(pc),50

	bra	TRAX
*------------------------------------------------------------------------------------------------------------*
EndOfFile
	move.l	Mem(pc),a0
	move.l	TrackNo(pc),(a0)+
	move.l	EntryTotal(pc),(a0)
	FPrint	Total
	bra	Close

CtrlC	LibBase	dos
	move.l	#BreakTxt,d1
	Call	PutStr
*------------------------------------------------------------------------------------------------------------*
Close	LibBase	dos
	move.l	Han(pc),d1
	beq	.noHan
	Call	Close

.noHan	LibBase	exec
	move.l	Mem(pc),d0
	beq	.noMem
	move.l	d0,a1
	move.l	#Buffer,d0
	Call	FreeMem

.noMem	Return	0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
CalcTime
	StackOn

	LibBase	mathieeesingbas

	moveq	#100,d0
	Call	IEEESPFlt	;convert freq. to float
	move.l	d0,d2
	move.l	Mem(pc),a0
	move.l	(a0),d0
	Call	IEEESPFlt	;convert samples to float
	move.l	d2,d1
	Call	IEEESPDiv	;div them to find seconds
	Call	IEEESPFix

	move.l	Mem(pc),a0
	move.l	d0,d1		;seconds
	divu	#60,d1		;minutes
	ext.l	d1
	move.l	d1,4(a0)
	mulu	#60,d1
	sub.l	d1,d0
	move.l	d0,8(a0)

	move.l	4(a0),d0
	move.l	d0,d1
	divu	#60,d1		;hours
	ext.l	d1
	move.l	d1,(a0)
	mulu	#60,d1
	sub.l	d1,d0
	move.l	d0,4(a0)

	StackOff
	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
EntryPrefs
	StackOn

	xRead	Mem(pc),1
	move.l	Mem(pc),a0
	move.b	(a0),d0

	move.l	#NoPrefs,(a0)
	move.l	#Blank,4(a0)
	move.l	#Blank,8(a0)
	move.l	#Blank,12(a0)

	btst	#TYPAPREFB_SHOWREGIONNAME,d0
	beq	.noRegName
	move.l	#SRegionName,(a0)+

.noRegName
	btst	#TYPAPREFB_SHOWSTARTTIME,d0
	beq	.noStartTime
	move.l	#SStartTime,(a0)+

.noStartTime
	btst	#TYPAPREFB_SHOWSAMPLESIZE,d0
	beq	.noSampleSize
	move.l	#SSampleSize,(a0)+

.noSampleSize
	btst	#TYPAPREFB_SHOWFADETIME,d0
	beq	.noFadeTime
	move.l	#SFadeTime,(a0)

.noFadeTime

	StackOff
	rts
*------------------------------------------------------------------------------------------------------------*
TrackStatus
	StackOn

	xRead	Mem(pc),1
	move.l	Mem(pc),a0
	move.b	(a0),d0

	move.l	#Blank,(a0)
	move.l	#Blank,4(a0)
	move.l	#Blank,8(a0)

	btst	#TYPTRACKB_SOUNDBUTTONON,d0
	beq	.noSnd
	move.l	#TSound,(a0)+

.noSnd	btst	#TYPTRACKB_SOLOBUTTONON,d0
	beq	.noSolo
	move.l	#TSolo,(a0)+

.noSolo	btst	#TYPTRACKB_TRACKSELECTED,d0
	beq	.noSel
	move.l	#TTrack,(a0)+

.noSel	StackOff
	rts
*------------------------------------------------------------------------------------------------------------*
SampStatus
	StackOn

	xRead	Mem(pc),4
	move.l	Mem(pc),a0

	move.l	(a0),d0
	move.l	#SampNoexist,(a0)

	tst.w	d0
	beq	.exit
	cmp.w	#SAMPSTAT_NOEXISTSEL,d0
	beq	.setSel
	cmp.w	#SAMPSTAT_OK,d0
	beq	.setOk
	cmp.w	#SAMPSTAT_OKSEL,d0
	beq	.setOkS

	move.l	#SampUnknown,(a0)
	bra	.exit

.setSel	move.l	#SampNoexistS,(a0)
	bra	.exit
.setOk	move.l	#SampOK,(a0)
	bra	.exit
.setOkS	move.l	#SampOKS,(a0)

.exit	StackOff
	rts
*------------------------------------------------------------------------------------------------------------*
FadeType
	StackOn
	xRead	Mem(pc),1

	move.l	Mem(pc),a0
	move.b	(a0),d0
	beq	.setLin
	cmp.b	#FADE_BUTT,d0
	beq	.setButt
	cmp.b	#FADE_LOGA,d0
	beq	.setLoga
	cmp.b	#FADE_EXPO,d0
	bne	.unknown

.setExpo
	move.l	#Exponential,(a0)
	bra	.showFade
.setLoga
	move.l	#Logaritmic,(a0)
	bra	.showFade
.setLin
	move.l	#Linear,(a0)
	bra	.showFade
.setButt
	move.l	#Butt,(a0)
	bra	.showFade
.unknown
	move.l	#Unknown,(a0)

.showFade
	StackOff
	rts
*------------------------------------------------------------------------------------------------------------*
GetFloat
	StackOn

	LibBase	dos
	move.l	Han(pc),d1
	move.l	#FloatNum,d2
	moveq	#8,d3
	Call	Read
	cmp.l	d0,d3
	bne	.error

	LibBase	mathieeedoubbas

	move.l	FloatNum(pc),d0
	move.l	FloatNum+4(pc),d1

	Call	IEEEDPFloor

	move.l	d0,d2
	move.l	d1,d3

	Call	IEEEDPFix		;convert number to integer
	move.l	d0,d5			;mantissa

	move.l	FloatNum(pc),d0		;get original number again
	move.l	FloatNum+4(pc),d1
	Call	IEEEDPSub		;subtract no dec. number from original number

	move.l	d0,d6			;=decimal only
	move.l	d1,d7

	move.l	#10000,d0
	Call	IEEEDPFlt		;convert to float = max number of decimal (4)

	move.l	d6,d2			;get decimal
	move.l	d7,d3
	Call	IEEEDPMul		;multiply

	Call	IEEEDPFix		;convert to integer

	move.l	Mem(pc),a0
	move.l	d0,4(a0)		;exponent
	move.l	d5,(a0)

.exit	StackOff
	rts

.error	move.l	#ErrRead,d1
	Call	PutStr
	bra	.exit
*------------------------------------------------------------------------------------------------------------*
ReadStr	StackOn

	LibBase	dos

	move.l	Han(pc),d1
	move.l	#Temp,d2
	moveq	#4,d3
	Call	Read
	cmp.l	d0,d3
	bne	.error

	move.l	Han(pc),d1
	move.l	Mem(pc),d2
	addq.l	#4,d2
	move.l	Temp(pc),d3
	beq	.exit
	Call	Read
	cmp.l	d0,d3
	bne	.error

	move.l	Mem(pc),a0
	move.l	a0,d0
	addq.l	#4,d0
	move.l	d0,(a0)

	move.l	Mem(pc),a0
	move.l	Temp(pc),d0
	clr.b	4(a0,d0.w)

.exit	StackOff
	rts

.error	move.l	#ErrRead,d1
	Call	PutStr
	bra	.exit
*------------------------------------------------------------------------------------------------------------*
FPrintSub
	StackOn

	LibBase	exec
	move.l	Mem(pc),a1
	lea	Proc(pc),a2
	lea	Buffer/2(a1),a3
	Call	RawDoFmt

	LibBase	dos
	move.l	Mem(pc),d1
	add.l	#Buffer/2,d1
	Call	PutStr

	StackOff
	rts

Proc	move.b	d0,(a3)+
	rts
*------------------------------------------------------------------------------------------------------------*

	Dump	Mem
	Dump	Open
	Dump	Read
	Dump	Type

About	move.l	#AboutTxt,d1

Print	LibBase	dos
	Call	PutStr
	bra	Close
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
IFile		dc.l	0
Han		dc.l	0
Mem		dc.l	0
Temp		dc.l	0
FloatNum	dc.l	0,0
TrackNo		dc.l	0
EntryNo		dc.l	0
EntryTotal	dc.l	0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
ErrMem		dc.b	"Out of memory!",10,0
ErrOpen		dc.b	"Couldn't open the file!",10,0
ErrRead		dc.b	"Error reading file!",10,0
ErrType		dc.b	"Not a 'TLC1' or 'TRAX' file!",10,0

StartTxt	dc.b	10,"[1mCUELIST AND TRACK DUMPER[0m version 1.0",10
		dc.b	"Demo tool by Kenneth 'Kenny' Nilsen.",10,10,0

HeadWin		dc.b	"Cuelist window positions - Left: %ld  Top: %ld  Height: %ld  Width: %ld",10,10,0
TrackPath	dc.b	"Track path           : %s",10,0
CuelistPath	dc.b	"Cuelist path         : %s",10,0
TrackName	dc.b	"Track name           : %s",10,0
CuelistName	dc.b	"Cuelist name         : %s",10,10,0
FadeinType	dc.b	"PREFS",10,10,"Default Fade-in type : %s",10,0
FadeoutType	dc.b	"Default Fade-out type: %s",10,0
MaxTime		dc.b	"Maximum fadetime     : %ld.%04.lu s",10,0
GridSpace	dc.b	"Grid spacing         : %ld.%04.lu s",10,0
StartTime	dc.b	"Cuelist start time   : %ld.%04.lu s",10,0
TotalLength	dc.b	"Total Cuelist length : %luh %2.lum %2.lus",10,0
ViewSize	dc.b	"View size position   : %luh %2.lum %2.lus",10,0
ViewStart	dc.b	"View start position  : %luh %2.lum %2.lus",10,0
BPM		dc.b	"Beats Per minuttes   : %lu (%lu/%lu) BPM",10,0
TimeOpts	dc.b	"Timer options        : %s",10,10,"FLAGS IN USE:",10,10,0
FMark		dc.b	"F%02.ld flag             : %ld.%04.lu s [%s].",10,0
LocateF		dc.b	"Red Locate flag      : %ld.%04.lu s [%s]",10,0
StartF		dc.b	"Blue Start flag      : %ld.%04.lu s [%s]",10,0
PunchinF	dc.b	"Yellow Punch-In flag : %ld.%04.lu s [%s]",10,0
PunchoutF	dc.b	"Yellow Punch-out flag: %ld.%04.lu s [%s]",10,10,"CHUNKS:",10,10,0

TypeNo		dc.b	12,10,"TYPE CHUNK",10,10,"Track number         : %ld",10,0
TypeType	dc.b	"TYPE type            : %s",10,0
TrackNam	dc.b	"Track name           : %s",10,0
TrackFreq	dc.b	"Track frequency      : %ld.%04.lu Hz",10,0
EntryUnSel	dc.b	"Entry pref unselected: %s%s%s%s",10,0
EntrySel	dc.b	"Entry pref selected  : %s%s%s%s",10,0
TrackStat	dc.b	"Track status         : %s%s%s",10,0
PlayChan	dc.b	"Play at channel      : %s",10,0
RecChan		dc.b	"Record at channel    : %s",10,10,0
PortNam		dc.b	"Port name            : %s",10,0

SampleNo	dc.b	12,10,"SAMP CHUNK",10,10,"Track number         : %ld",10,"Sample number        : %ld",10,0
SampleStatus	dc.b	"Sample status        : %s",10,0
SampleStart	dc.b	"Start pos. of sample : %ld.%04.lu s",10,0
SampleEnd	dc.b	"End pos. of sample   : %ld.%04.lu s",10,0
SampleGroup	dc.b	"Group ID             : %ld",10,0
SampleName	dc.b	"Sample path/name     : %s",10,0
SampleFadein	dc.b	"Fade-in type         : %s",10,0
SampleFadeout	dc.b	"Fade-out type        : %s",10,0
SampleFadeinT	dc.b	"Fade-in time         : %ld.%04.lu s",10,0
SampleFadeoutT	dc.b	"Fade-out time        : %ld.%04.lu s",10,0
SampleCropIn	dc.b	"Crop-In              : %lu samples",10,0
SampleCropOut	dc.b	"Crop-Out             : %lu samples",10,0
SampleVol	dc.b	"Volume               : %ld dB",10,0
SamplePan	dc.b	"Pan                  : %s",10,0

EventNo		dc.b	12,10,"EVNT CHUNK",10,10,"Track number         : %ld",10,"Event number         : %ld",10,0
EventStatus	dc.b	"Event status         : %s",10,0
EventStart	dc.b	"Event start position : %ld.%04.lu s",10,0
EventGroup	dc.b	"Event group          : %ld",10,0
EventName	dc.b	"Event name           : %s",10,0
EventStamp	dc.b	"SMPTE stamp          : %02.u:%02.u:%02.u:%02.u",10,0
EventCmd	dc.b	"Event command        : %s",10,0

EventUnsel	dc.b	"UNSELECTED",0
EventSel	dc.b	"SELECTED",0

Total		dc.b	12,10,"-------------------------------------------------------------",10
		dc.b	"TOTAL NUMBER OF TRACKS : %lu",10
		dc.b	"TOTAL NUMBER OF ENTRIES: %lu",10,10,0
BreakTxt	dc.b	10,"*** USER BREAK!",10,10,0

PanLeft		dc.b	"Left",0
PanFullLeft	dc.b	"Full left",0
PanRight	dc.b	"Right",0
PanFullRight	dc.b	"Full right",0
PanCenter	dc.b	"Center",0

SampNoexist	dc.b	"NOEXIST",0
SampNoexistS	dc.b	"NOEXIST+SELECTED",0
SampOK		dc.b	"OK",0
SampOKS		dc.b	"OK+SELECTED",0
SampUnknown	dc.b	"<unknown - report to author!>",0

SRegionName	dc.b	"Regionname/",0
SStartTime	dc.b	"Starttime/",0
SSampleSize	dc.b	"Samplesize/",0
SFadetime	dc.b	"Fadetime",0

TSound		dc.b	"SOUND ON/",0
TSolo		dc.b	"SOLO ON/",0
TTrack		dc.b	"TRACK ON",0

TSoundOff	dc.b	"SOUND OFF/",0
TSoloOff	dc.b	"SOLO OFF/",0
TTrackOff	dc.b	"TRACK OFF",0

TIMEBPM		dc.b	"Beats Per Minutes (BPM)",0
TIMEHMS		dc.b	"Hours Minutes Seconds",0
TIMESMPTE	dc.b	"SMPTE",0
TIMESMPTEPLUS	dc.b	"SMPTE PLUS",0

Exponential	dc.b	"Exponential",0
Logaritmic	dc.b	"Logarithmic",0
Linear		dc.b	"Linear",0
Butt		dc.b	"Butt",0
UNKNOWN		dc.b	"Timer options        : <unknown type (0x%08.lx) - report to author>",10,10,"FLAGS IN USE:",10,10,0

HeaderNews	dc.b	"<unknown content (0x%04.x 0x%04.x 0x%04.x) - please report to author!>",10,10,0

UnknownChunk	dc.b	10,"WARNING: Unknown chunk in file! Tell author - quitting...",10,10,0
UnknownType	dc.b	10,"WARNING: Unknown TYPE chunk! Tell author - quitting...",10,10,0

NotInUse	dc.b	"<not in use>",0
NoPrefs		dc.b	"<No Prefs>"
Blank		dc.b	0

AboutTxt	dc.b	10,27,"[1mDumpCue",27,"[0m 1.0 by Kenneth 'Kenny' Nilsen (kenny@bgnett.no)",10,10
		dc.b	"    USAGE: [Cuelistfile | Trackfile]",10,10
		dc.b	"Dumps the content of the file to console.",10
		dc.b	"Redirect to a file and use the 'more' command to read it.",10,10,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
