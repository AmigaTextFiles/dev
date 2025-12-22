*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		  Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 1.00	15/08/1993			*
*	       -20.09.1993			*
* BUGS:						*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

	INCLUDE	"libraries/voice.i"

PROGVERSION:	macro
		dc.b	"1.00 (20.09.93)"
		endm

TRUE:		EQU	1
FALSE:		EQU	0


;VSFileVersion	'VS02'

GADLENG1VS02:	EQU	16
GADLENG2VS02:	EQU	64
GADLENGTHVS02:	EQU	(GADLENG1VS02+GADLENG2VS02)

;VSFileVersion	'VS03'

VocabSIZE:	EQU	60
GADLENG1:	EQU	16
GADLENG2:	EQU	256
GADLENGTH:	EQU	(GADLENG1+GADLENG2)
VSMB_Size:	EQU	VocabSIZE*304

VS02Length:	EQU	23040
VS03Length:	EQU	34560

VSHEADER_SIZE:	EQU	4

;VCLI version 7.0

VCLIVocabSIZE:	EQU	48
VCLIMB_Size:	EQU	VCLIVocabSIZE*304

NullBufSize1:	EQU	GADLENG2-GADLENG2VS02
NullBufSize2:	EQU	(VocabSIZE*304)-(VCLIVocabSIZE*304)

		section	VSConv,CODE

		openlib	Dos,NoDos

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		lib	Dos,Output
		move.l	d0,_stdout

		lib	Dos,Input
		move.l	d0,_stdin

		lea.l	FromFileText1,a0
		bsr	Printer
		move.l	SourceFile,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer

		lea.l	DestText1,a0
		bsr	Printer
		move.l	DestFile,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer

		move.l	SourceFile,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,Source
		beq	NoRDArgs

		move.l	DestFile,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,Destination
		beq	OpenDest2

OpenDest1:	lea.l	FExistsText1,a0
		bsr	Printer

		bsr	GetYesNo
		tst.l	d0
		beq	OpenDest1

		cmp.l	#1,d0			;Yes, replace
		beq	OpenDest3

		cmp.l	#2,d0
		bne	ShutDown		;Error!

		tst.l	Destination		;Don't open twice!
		bne	ShutDown		;Error!

OpenDest2:	move.l	DestFile,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,Destination
		beq	NoRDArgs

OpenDest3:	lea.l	CRLFText1,a0
		bsr	Printer

		move.l	Source,d1
		bsr	GetFileLength

		cmp.l	#VS02Length,d0
		beq	DoVS02

		cmp.l	#VS03Length,d0
		beq	DoVS03

		bra	DoVCLI

DoVS02:		lea.l	ConvText1,a0
		bsr	Printer
		lea.l	ConvText3,a0
		bsr	Printer

		move.l	#VSMB_Size,d0
		bsr	CopyMapBuffer
		cmp.l	#-1,d0
		beq	NoRDArgs

		move.l	#VocabSIZE,d6

DoVS02.1:	bsr	CopyGL02Bytes
		cmp.l	#-1,d0
		beq	NoRDArgs

		move.l	Destination,d1
		move.l	#192,d3
		bsr	WriteNulls

		sub.l	#1,d6
		bne	DoVS02.1

		bra	ShutDown

DoVS03:		lea.l	NewestText1,a0
		bsr	Printer
		bra	ShutDown

DoVCLI:		move.l	Source,d1
		bsr	GetHeader
		cmp.l	#-1,d0
		beq	NoRDArgs

		lea.l	VCLI70ID,a0
		lea.l	Buffer1,a1
		bsr	CmpStrings
		tst.l	d0
		bne	DoVCLI1.1

		lea.l	Buffer1,a0	;DEBUG
		bsr	Printer		;DEBUG

		lea.l	UnknownText1,a0
		bsr	Printer
		bra	ShutDown

DoVCLI1.1:	lea.l	ConvText2,a0
		bsr	Printer
		lea.l	ConvText4,a0
		bsr	Printer

;Seek 12 bytes from the start, to beginning of MapBuffer,
;in source (VCLI file)

		move.l	Source,d1
		move.l	#12,d2
		move.l	#-1,d3
		lib	Dos,Seek

;Copy VCLI MapBuffer to Destination (VoiceShell)

		move.l	#VCLIMB_Size,d0
		bsr	CopyMapBuffer
		cmp.l	#-1,d0
		beq	NoRDArgs


;Write (VocabSize*304) - (VCLIVocabSize*304) amount of NULL to Destination

		lea.l	NullBuffer2,a0
		move.l	Destination,d1
		move.l	a0,d2
		move.l	#NullBufSize2,d3
		lib	Dos,Write
		cmp.l	#NullBufSize2,d0
		bne	NoRDArgs

;Copy strings from Source (VCLI) to Destination (VoiceShell) with steps of
;GADLENG1. Read in 16 bytes chunks, written in GADLENG1 chunks, 
;VCLIVocabSize times. Skip GADLENG2 in between.

		lea.l	Buffer3,a0
		move.l	Source,d1
		move.l	a0,d2
		move.l	#16*48,d3
		lib	Dos,Read

;Done here (IE. NOT DONE!!!). Do rest here!
;

;Seek to first CLI Command string in Destination (VoiceShell)
;
		move.l	Destination,d1
		move.l	#(VocabSIZE*304)+GADLENG1,d2
		move.l	#-1,d3
		lib	Dos,Seek

;Copy strings from Source (VCLI) to Destination (VoiceShell) with steps of
;GADLENG2. Read in 128 bytes chunks, written in GADLENG2 chunks, 
;VCLIVocabSize times. Skip GADLENG1 in between.

		lea.l	Buffer3,a0
		move.l	Source,d1
		move.l	a0,d2
		move.l	#128*48,d3
		lib	Dos,Read

;Done here (IE. NOT DONE!!!). Do rest here!
;

		lea.l	SorryText1,a0		;DEBUG
		bsr	Printer			;DEBUG

		bra	ShutDown

GetYesNo:	move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

		move.l	_stdin,d1
		lib	Dos,Flush

		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		bne	GetYesNo2
		lea.l	ErrorText1,a0
		bsr	Printer
		bra	GetYesNo_OUT

GetYesNo2:	cmp.l	#'y',d0
		beq	GetYesNo3
		cmp.l	#'Y',d0
		beq	GetYesNo3
		cmp.l	#'n',d0
		beq	GetYesNo4
		cmp.l	#'N',d0
		beq	GetYesNo4
		cmp.l	#13,d0
		beq	GetYesNo4		;Return
		cmp.l	#10,d0
		beq	GetYesNo4		;Return
		clr.l	d0
		bra	GetYesNo_OUT
GetYesNo3:	lea.l	YesText1,a0
		bsr	Printer
		move.l	#1,d0
		bra	GetYesNo_OUT
GetYesNo4:	lea.l	NoText1,a0
		bsr	Printer
		move.l	#2,d0
;		bra	GetYesNo_OUT		;Careful!
GetYesNo_OUT:	move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		rts

;GetFileLength gets the length of a file and returns to the start of file
;
;Input	d1 = File
;
;Result	d0 = Length
;

GetFileLength:	move.l	d1,d3
		bsr	SeekStart
		move.l	d3,d1
		bsr	SeekEnd
		push	d0
		move.l	d3,d1
		bsr	SeekStart
		pull	d0
		rts


;Seek to end of file
;
;Input	d1 = File
;
;Result	d0 = Length
;

SeekEnd:	push	d2-d3
		move.l	d1,d6
		move.l	#00,d2
		move.l	#01,d3
		lib	Dos,Seek
		move.l	d6,d1
		lib	Dos,Seek
		pull	d2-d3
		rts

;Seek to start of file
;
;Input	d1 = File
;
;Result	d0 = Length
;

SeekStart:	push	d2-d3
		move.l	#0,d2
		move.l	#-1,d3
		lib	Dos,Seek
		pull	d2-d3
		rts

;GetHeader reads 12 bytes into Buffer1 and seeks to start of file
;
;Input	d1 = File

GetHeader:	move.l	d1,d4

		bsr	SeekStart

		move.l	d4,d1
		lea.l	Buffer1,a0
		move.l	a0,d2
		move.l	#12,d3
		lib	Dos,Read
		cmp.l	#12,d0
		bne	GetHeader_ERR1

		move.l	d4,d1
		bsr	SeekStart
		rts

GetHeader_ERR1:	move.l	#-1,d0
		rts

;CopyMapBuffer reads d0 bytes into MapBuffer from start of file
;
;Input	d0 = Length

CopyMapBuffer:	push	d0
		move.l	Source,d1
		bsr	SeekStart

		move.l	Destination,d1
		bsr	SeekStart

		move.l	Source,d1
		lea.l	MapBuffer,a0
		move.l	a0,d2
		pull	d3
		lib	Dos,Read
		cmp.l	d3,d0
		bne	CopyMB_ERR1

		move.l	Destination,d1
		lib	Dos,Write
		cmp.l	d3,d0
		bne	CopyMB_ERR1
		rts

CopyMB_ERR1:	move.l	#-1,d0
		rts

;CopyGL02Bytes copies GADLENG2VS02 bytes from Source to Destination
;

CopyGL02Bytes:	move.l	Source,d1		;Read GADLENGTHVS02 bytes
		lea.l	Buffer2,a0
		move.l	a0,d2
		move.l	#GADLENGTHVS02,d3
		lib	Dos,Read
		cmp.l	#GADLENGTHVS02,d0
		bne	CopyGL02_ERR1

		move.l	Destination,d1		;Write GADLENGTHVS02 bytes
		lib	Dos,Write
		cmp.l	#GADLENGTHVS02,d0
		bne	CopyGL02_ERR1
		rts

CopyGL02_ERR1:	move.l	#-1,d0
		rts

;WriteNulls writes 192 NULLs to Destination
;

WriteNulls:	move.l	Destination,d1
		lea.l	NullBuffer,a0
		move.l	a0,d2
		move.l	#NullBufSize1,d3
		lib	Dos,Write
		cmp.l	#NullBufSize1,d0
		bne	WriteNull_ERR1
		rts

WriteNull_ERR1:	move.l	#-1,d0
		rts

CloseFiles:	move.l	Source,d1
		beq	CloseFiles2
		lib	Dos,Close

CloseFiles2:	move.l	Destination,d1
		beq	CloseFiles3
		lib	Dos,Close
CloseFiles3:	rts

;Compares two strings.
;
;Input	a0 = String 1
;	a1 = String 2
;
;Result	d0 = 0 if not same
;
;BUGS
;
;String 1 has to have NULL at end!
;

CmpStrings:	bsr	GetLength
		move.l	d0,d4		;length of string1 to d4
		push	a0
		move.l	a1,a0
		bsr	GetLength
		pull	a0
		cmp.l	d4,d0		;length of string2 in d3
		bne	CmpStrings1.1
CmpStrings1:	tst.b	(a0)
		beq	CmpStrings2
		cmp.b	(a0)+,(a1)+
		beq	CmpStrings1
CmpStrings1.1:	clr.l	d0
		rts
CmpStrings2:	move.l	#-1,d0
		rts

;Get length of text in given address
;
;Input a0 = Address of null terminated text string
;
;Result d0 = Length

GetLength:	push	a0
		clr.l	d0
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d0
		tst.b	(a0)+
		bne	GetLength2
		sub.l	#1,d0		;don't include NULL
GetLength_OUT:	pull	a0
		rts

ShutDown:	move.l	RDArgs1,d1
		beq	ShutDown9000
		lib	Dos,FreeArgs

ShutDown9000:	bsr	CloseFiles

ShutDown1000:	closlib	Dos
		move.l	#RETURN_OK,d0
		rts

NoDos:		move.l	#RETURN_FAIL,d0
		rts

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

Printer:	printa	a0
		rts


;Library stuff

		libnames

;Reservations

_stdin:		dc.l	0
_stdout:		dc.l	0
RDArgs1:	dc.l	0
Source:		dc.l	0
Destination:	dc.l	0


;Options

CLArray1:
SourceFile:	dc.l	0
DestFile:	dc.l	0

;Strings, errors etc.

FExistsText1:	dc.b	13,10,"File already exists! Replace? (y/N) ",0
UnknownText1:	dc.b	"Unknown file type!",13,10,0
NewestText1:	dc.b	13,10,"This is the newest version of the datafile ",13,10
		dc.b	"for VoiceShell that this program recognizes.",13,10,13,10
		dc.b	"ERROR: Can't convert to anything!",13,10,0
ErrorText1:	dc.b	"Error!",13,10,0

;Strings, others

CLTemplate1:	dc.b	"FROM/A,TO/A",0
VSConvVersion:	dc.b	"$VER: VoiceShell Conversion Utility "
		PROGVERSION
		dc.b	" (c) Copyright Tomi Blinnikka 1993",0

FromFileText1:	dc.b	13,10,"Source file : ",0
DestText1:	dc.b	"Destination : ",0

ConvText1:	dc.b	"Converting VoiceShell: ",0
ConvText2:	dc.b	"Converting VCLI: ",0
ConvText3:	dc.b	"1.07 - 1.11 to 1.12.",13,10,0
ConvText4:	dc.b	"VCLI 7.0 to VoiceShell 1.12.",13,10,0

SorryText1:	dc.b	"Sorry, forgot to write this part of the program...",13,10,0

YesText1:	dc.b	"Yes",13,10,0
NoText1:	dc.b	"No",13,10,0
CRLFText1:	dc.b	13,10,0


;File headers

VSVersion02:	dc.b	'VS02',0		;For prefs only!
VSVersion03:	dc.b	'VS03',0		;For prefs only!
VCLI70ID:	dc.b	"VCLI7.0 DATA",0

		ds.w	0


;Other stuff, part II

		Section VS,BSS

DATA_START:

MapBuffer:	ds.b	(VocabSIZE*304)		;60 words

CmdList:	ds.b	(VocabSIZE*GADLENGTH)

DATA_END:	ds.l	1

DataSize:	EQU	(DATA_END-DATA_START)


Buffer1:	ds.b	16
Buffer2:	ds.b	GADLENG2VS02
Buffer3:	ds.b	128*48			;VCLI strings/cmds

NullBuffer:	ds.b	NullBufSize1
NullBuffer2:	ds.b	NullBufSize2


		end

;Read configuration bytes from Source (VCLI)

;	Byte 1
;
;	Sampler ID =	0 for PerfecSound3
;			1 for Sound Master
;			2 for Generic
;			3 for DSS8
;	Byte2
;
;		Sampler Gain = 0 to 16 for DSS8

		lea.l	Buffer1,a0

		move.b	a0,d0
		btst.b	d0
		beq	DoVCLI1.XX
		move.b	#TIMER_B,
		bra	DoVCLI1.XX+1
DoVCLI1.XX:	move.b	#TIMER_A,

DoVCLI1.XX+1:	add.l	#1,a0
		move.b	(a0),PrefsSampType

		add.l	#1,a0

		move.b	(a0),PrefsGain

		rts
