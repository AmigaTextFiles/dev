*************************************************
*						*
*	      (C)opyright 1991			*
*						*
*	     by  Tomi Blinnikka			*
*						*
*	Texter testing cos' I'm bored		*
*						*
* Version 0.01a	16/07/1991			*
*						*
* BUGS:	Not finished				*
*						*
* Version 0.01b	28/07/1992			*
*						*
* Added CTRL_C check and changed alot of other	*
* stuff.					*
*						*
*************************************************
	

	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:dos.xref"
	INCLUDE	"XREF:exec.xref"

		section	Texter,CODE
	
Start:		move.l	a0,FileAddress		;get filename
		clr.b	-1(a0,d0.l)		;add null to end of filename
		openlib	Dos,ShutDown
		move.l	_DosBase(pc),_DOSBase
		move.l	$4,_SysBase

		lib	Dos,Output
		move.l	d0,_stdout
		beq	ShutDown

		move.l	FileAddress(pc),a0
		tst.b	(a0)
		beq	NoFName

		move.l	FileAddress(pc),a0
		cmp.b	#'"?',(a0)
		beq	CmdLineHelp
		cmp.w	#'-?',(a0)
		beq	CmdLineHelp
		cmp.b	#'h',(a0)
		beq	CmdLineHelp
		cmp.w	#'-h',(a0)
		beq	CmdLineHelp

		move.l	FileAddress(pc),d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,TextFile
		beq	FileError

		move.l	TextFile(pc),d1		;Get length of file.
		move.l	#00,d2
		move.l	#01,d3
		lib	Dos,Seek
		move.l	TextFile(pc),d1
		lib	Dos,Seek
		tst.l	d0
		beq	ZeroLength

		move.l	d0,d6
		move.l	TextFile(pc),d1
		move.l	#00,d2
		move.l	#-1,d3
		lib	Dos,Seek

		lea.l	FileBuffer(pc),a0
		move.l	a0,a4
		move.l	#$00,d5

;Start of loop.

StartLoop:	clr.l	d1
		bset.l	#SIGBREAKB_CTRL_C,d1	;check for CTRL_C
		lib	Dos,CheckSignal
		btst.l	#SIGBREAKB_CTRL_C,d0
		bne	Break

		move.l	TextFile(pc),d1
		move.l	a4,d2
		move.l	#1,d3
		lib	Dos,Read
		tst.l	d0
		beq	FileError
		bsr	CheckInput
		cmp.w	#00,Status
		beq	ContWriting
		bra	TestEnd
ContWriting:	move.l	_stdout(pc),d1
		move.l	a4,d2
		lib	Dos,Write		; d3=1
		bsr	Delay
TestEnd:	cmp.l	d5,d6
		bne	StartLoop

ShutDown:	tst.l	TextFile
		beq	ShutDown9000
		move.l	TextFile(pc),d1
		lib	Dos,Close
		move.l	#$00,TextFile

ShutDown9000:	bsr	DoPlain

		closlib	Dos

ShutDown2000:
ShutDownOut:	move.l	#RETURN_OK,d0
		rts

CheckInput:	add.l	#01,d5
		cmp.w	#$02,Status		;Returning to noneffect.
		beq	ClearStatus
		cmp.w	#01,Status		;In effect mode?
		bne	NoEffect1
		cmp.b	#$1b,(a4)
		bne	Effect1
		move.w	#$02,Status
		rts
Effect1:	cmp.b	#'0',(a4)
		bne	Effect1.1
		move.w	#$00,Speed
		rts
Effect1.1:	cmp.b	#'1',(a4)
		bne	Effect1.2
		move.w	#$01,Speed
		rts
Effect1.2:	cmp.b	#'2',(a4)
		bne	Effect1.3
		move.w	#$02,Speed
		rts
Effect1.3:	cmp.b	#'3',(a4)
		bne	Effect1.4
		move.w	#$03,Speed
		rts
Effect1.4:	cmp.b	#'d',(a4)
		bne	Effect2
		bsr	Delay
		rts
Effect2:	cmp.b	#'b',(a4)
		bne	Effect3
		bsr	BoldOn
		rts
Effect3:	cmp.b	#'i',(a4)
		bne	Effect4
		bsr	ItalicOn
		rts
Effect4:	cmp.b	#'u',(a4)
		bne	Effect5
		bsr	UnderLineOn
		rts
Effect5:	cmp.b	#'r',(a4)
		bne	Effect6
		bsr	ReverseOn
		rts
Effect6:	cmp.b	#'p',(a4)
		bne	Effect7
		bsr	Plain
		rts
Effect7:	cmp.b	#'c',(a4)
		bne	Effect8
		bsr	CursorOff
		rts
Effect8:	cmp.b	#'C',(a4)
		bne	Effect9
		bsr	CursorOn
		rts
Effect9:	cmp.b	#'!',(a4)
		bne	Effect10
		bsr	ClearCLI
		rts
Effect10:	rts

ClearStatus:	move.w	#$00,Status
		rts

NoEffect1:	cmp.b	#$1b,(a4)
		bne	NoEffect2
		move.w	#01,Status
NoEffect2:	rts

Delay:		cmp.w	#00,Speed
		beq	Delay_OUT
		cmp.w	#01,Speed
		bne	Delay1
		move.l	#1,d1
Delay1:		cmp.w	#02,Speed
		bne	Delay2
		move.l	#3,d1
Delay2:		cmp.w	#03,Speed
		bne	Delay3
		move.l	#5,d1
Delay3:		lib	Dos,Delay
Delay_OUT:	rts

DoPlain:	lea.l	PlainText1,a0
		bsr	Printer
		lea.l	CursorOnText1,a0
		bsr	Printer
		rts

Plain:		lea.l	PlainText1,a0
		bsr	Printer
		rts
BoldOn:		lea.l	BoldOnText1,a0
		bsr	Printer
		rts
ItalicOn:	lea.l	ItalicOnText1,a0
		bsr	Printer
		rts
UnderLineOn:	lea.l	UnderLineOnText1,a0
		bsr	Printer
		rts
ReverseOn:	lea.l	ReverseOnText1,a0
		bsr	Printer
		rts
CursorOn:	lea.l	CursorOnText1,a0
		bsr	Printer
		rts
CursorOff:	lea.l	CursorOffText1,a0
		bsr	Printer
		rts
ClearCLI:	lea.l	ClearCLIText1,a0
		bsr	Printer
		rts

CmdLineHelp:	lea.l	UsageText1,a0
		bsr	Printer
		bra	ShutDown

Break:		bsr	DoPlain
		lea.l	CRLFText1,a0
		bsr	Printer
		lea.l	BreakText1,a0
		bsr	Printer
		bra	ShutDown

NoFName:	lea.l	ErrorText1,a0
		bsr	Printer
		lea.l	NoFNameText1,a0
		bsr	Printer
		bra	ShutDown

ZeroLength:	lea.l	ErrorText1,a0
		bsr	Printer
		lea.l	LengthText1,a0
		bsr	Printer
		bra	ShutDown

Printer:	;tst.w	Quiet
		;beq	Printer1
		printa	a0
Printer1:	rts


FileError:	lib	Dos,IoErr
		cmp.l	#ERROR_NO_FREE_STORE,d0
		bne	CNOC1
		lea.l	NoFreeSText1,a0
		bra	FileError_OUT
CNOC1:		cmp.l	#ERROR_TASK_TABLE_FULL,d0
		bne	CNOC2
		lea.l	TaskTFullText1,a0
		bra	FileError_OUT
CNOC2:		cmp.l	#ERROR_LINE_TOO_LONG,d0
		bne	CNOC3
		lea.l	LineLongText1,a0
		bra	FileError_OUT
CNOC3:		cmp.l	#ERROR_OBJECT_IN_USE,d0
		bne	CNOC4
		lea.l	ObjInUseText1,a0
		bra	FileError_OUT
CNOC4:		cmp.l	#ERROR_OBJECT_NOT_FOUND,d0
		bne	CNOC5
		lea.l	FileNotFText1,a0
		bsr	Printer
		printa	FileAddress(pc)
		lea.l	CRLFText1,a0
		bra	FileError_OUT
CNOC5:		cmp.l	#ERROR_DISK_NOT_VALIDATED,d0
		bne	CNOC6
		lea.l	NValidatText1,a0
		bra	FileError_OUT
CNOC6:		cmp.l	#ERROR_DEVICE_NOT_MOUNTED,d0
		bne	CNOC7
		lea.l	NMountText1,a0
		bra	FileError_OUT
CNOC7:		cmp.l	#ERROR_READ_PROTECTED,d0
		bne	CNOC8
		lea.l	ReadProText1,a0
		bra	FileError_OUT
CNOC8:		cmp.l	#ERROR_NOT_A_DOS_DISK,d0
		bne	CNOC9
		lea.l	NDosText1,a0
		bra	FileError_OUT
CNOC9:		cmp.l	#ERROR_NO_DISK,d0
		bne	CNOC10
		lea.l	NDiskText1,a0
		bra	FileError_OUT
CNOC10:		lea.l	FileErrorText1,a0
		bra	FileError_OUT
FileError_OUT:	bsr	Printer
		bra	ShutDown

;Structures

;Library stuff (well what's needed anymore)

		libnames

_DOSBase:	dc.l	0
_SysBase:	dc.l	0

;File stuff

_stdout:	dc.l	0
FileAddress:	dc.l	0
TextFile:	dc.l	0
FileBuffer:	dc.b	0,0

;Other stuff XIV

Status:		dc.w	0		;0=Not in Effect mode, 1=In effect mode
Speed:		dc.w	0		;0=Off, 1=Fast, 2=Medium, 3=Slow

		dc.b	"$VER: Texter 0.01b (27.7.92)",0

UsageText1:	dc.b	"Texter 0.01b (C)opyright 1991-92 Tomi Blinnikka",13,10,13,10
		dc.b	"USAGE: Texter [Filename]",13,10,13,10
		dc.b	"       Where: [Filename] is the file to be printed.",13,10,13,10,0

;Effects

ClearCLIText1:	dc.b	$0c,0
PlainText1:	dc.b	$9b,$30,$6d,0
BoldOnText1:	dc.b	$9b,$31,$6d,0
ItalicOnText1:	dc.b	$9b,$33,$6d,0
UnderLineOnText1: dc.b	$9b,$34,$6d,0
ReverseOnText1:	dc.b	$9b,$37,$6d,0
CursorOnText1:	dc.b	$9b,$20,$70,0
CursorOffText1:	dc.b	$9b,$30,$20,$70,0

;Error texts

NoFNameText1:	dc.b	"No filename given.",13,10,0
LengthText1:	dc.b	"File length equals zero.",13,10,0
ErrorText1:	dc.b	"ERROR: ",0
NoFreeSText1:	dc.b	"No free store",13,10,0
TaskTFullText1:	dc.b	"Task table full",13,10,0
LineLongText1:	dc.b	"Line too long",13,10,0
ObjInUseText1:	dc.b	"Object in use",13,10
FileNotFText1:	dc.b	"File not found",13,10,"Filename was: ",0
NValidatText1:	dc.b	"Disk not validated",13,10,0
NMountText1:	dc.b	"Device not mounted",13,10,0
ReadProText1:	dc.b	"File is read protected",13,10,0
NDosText1:	dc.b	"Not a dos disk",13,10,0
NDiskText1:	dc.b	"No disk in drive",13,10,0
FileErrorText1:	dc.b	"Sorry, file error",13,10,0
CRLFText1:	dc.b	13,10,0
BreakText1:	dc.b	"***Break",13,10,0
		ds.l	0

		END

Effect1:	cmp.w	#'d0',(a4)
		bne	Effect1.1
		move.w	#$00,Speed
		bsr	Delay
		rts
Effect1.1:	cmp.w	#'d0',(a4)
		bne	Effect1.2
		move.w	#$01,Speed
		bsr	Delay
		rts
Effect1.2:	cmp.w	#'d0',(a4)
		bne	Effect1.3
		move.w	#$02,Speed
		bsr	Delay
		rts
Effect1.3:	cmp.w	#'d0',(a4)
		bne	Effect2
		move.w	#$03,Speed
		bsr	Delay
		rts
