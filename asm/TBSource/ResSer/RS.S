*************************************************
*						*
*		(C)opyright 1991-92		*
*						*
*		 by Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	01/07/1991			*
*	 -0.99ö					*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"exec/nodes.i"
	INCLUDE	"exec/lists.i"
	INCLUDE	"exec/ports.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"exec/devices.i"
	INCLUDE	"exec/io.i"
	INCLUDE	"exec/tasks.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"devices/serial.i"
	INCLUDE "workbench/startup.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"
	INCLUDE	"XREF:icon.xref"

	XREF	_CreatePort
	XREF	_DeletePort
	XREF	_CreateExtIO
	XREF	_DeleteExtIO

	XDEF	_DOSBase
	XDEF	_SysBase

DIntuition	set	1

RingTop:	EQU	2
OptionTop:	EQU	56

TRUE:		EQU	1

		section	RS,CODE

		push	d2-d7/a2-a6
		push	d0/a0

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask
		move.l	d0,a4
		move.l	pr_CLI(a4),d0
		bne	OpenDos

		add.l	#8,sp
		lea.l	pr_MsgPort(a4),a0
		lib	Exec,WaitPort
		lea.l	pr_MsgPort(a4),a0
		lib	Exec,GetMsg
		move.l	d0,WBMsg

OpenDos:	openlib	Dos,NoDos		;Keep at beginning

		tst.l	WBMsg
		beq	CLIStart

		lea.l	NILName,a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,NILFile
		beq	ShutDown
		move.l	NILFile,_stdout
		beq	NoNIL

		openlib	Icon,NoIcon

		move.l	WBMsg,a0
		move.l	sm_ArgList(a0),a1
		move.l	wa_Lock(a1),d1
		lib	Dos,CurrentDir
		move.l	d0,OldLock

		move.l	WBMsg,a0
		move.l	sm_ArgList(a0),a1
		move.l	wa_Name(a1),a0
		lib	Icon,GetDiskObject
		move.l	d0,DiskObject
		beq	MainStart

		move.l	DiskObject,a4
		move.l	$36(a4),a0		;do_ToolTypes
		lea.l	DEVICEText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType1
		move.l	d0,SerName

DoToolType1:	move.l	$36(a4),a0		;do_ToolTypes
		lea.l	UNITText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType2
		move.l	d0,a0
		bsr	ConvASCII
		tst.w	d0
		beq	DoToolType2
		move.w	d0,SerUnit

DoToolType2:	bra	MainStart

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout
		pull	d0/a0
		clr.b	-1(a0,d0.l)
		cmp.b	#"?",(a0)
		beq	Usage
		cmp.w	#'-?',(a0)
		beq	Usage
		cmp.w	#'-h',(a0)
		beq	Usage

Cont0.2:	bsr	ConvASCII
		tst.w	d0
		beq	Cont1
		move.w	d0,SerUnit
Cont1:		cmp.b	#32,(a0)		;Test for space
		bne	Cont1.01
		add.l	#1,a0
		bra	Cont1			;Loop until no spaces
Cont1.01:	cmp.b	#9,(a0)			;Test for TAB
		bne	Cont1.1
		add.l	#1,a0
		bra	Cont1.01		;Loop until no spaces
Cont1.1:	tst.b	(a0)
		beq	Cont1.4
		push	a0
Cont1.2:	cmp.b	#32,(a0)		;Test for spaces
		beq	Cont1.3
		cmp.b	#9,(a0)			;Test for TAB
		beq	Cont1.3
		add.l	#1,a0
		bra	Cont1.2
Cont1.3:	clr.b	(a0)
		pull	a0
		move.l	a0,SerName
Cont1.4:

MainStart:	move.l	_DosBase,_DOSBase
		move.l	$4,_SysBase

;Create reply port for serial.device (or modem0.device etc.)

		move.l	#0,-(sp)
		pea	SRPortName		;S(erial)R(eply)PortName
		jsr	_CreatePort
		add.l	#8,sp
		move.l	d0,SRPort
		beq	ShutDown

;Create IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,-(sp)
		move.l	d0,-(sp)
		jsr	_CreateExtIO
 		add.l	#8,sp
		move.l	d0,IORequest
		beq	NoIOReq

;open serial.device

		move.l	SerName,a0
		move.l	SerUnit,d0
		move.l	IORequest,a1
		move.b	#SERF_SHARED,IO_SERFLAGS(a1)
		clr.l	d1				;no flags
		lib	Exec,OpenDevice
		tst.l	d0
		bne	NoSerial
		move.w	#$1,SerOpen		;just to tell if open

		clr.l	d1			;Set signals for
		clr.l	d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		lib	Exec,Wait
		bra	ShutDown

ClearSer:	move.l	IORequest,a1
		lib	Exec,CheckIO
		tst.l	d0
		beq	ClearSer1
		move.l	IORequest,a1
		lib	Exec,WaitIO

ClearSer1:	move.l	IORequest,a1
		ABORTIO
		move.l	IORequest,a1
		lib	Exec,WaitIO
		rts

ShutDown:	tst.w	SerOpen
		beq	ShutDown9000
		move.l	IORequest,a1
		lib	Exec,CloseDevice

ShutDown9000:	move.l	IORequest,d0
		tst.l	d0
		beq	ShutDown8000
		move.l	#IOEXTSER_SIZE,-(sp)
		move.l	d0,-(sp)
		jsr	_DeleteExtIO
		add.l	#8,sp

ShutDown8000:	move.l	SRPort,d0
		tst.l	d0
		beq	ShutDown7000
		move.l	d0,-(sp)
		jsr	_DeletePort
		add.l	#4,sp

ShutDown7000:
ShutDown4000:	tst.l	NILFile
		beq	ShutDown3000
		move.l	NILFile,d1
		lib	Dos,Close

ShutDown3000:	tst.l	DiskObject
		beq	ShutDown2000
		move.l	DiskObject,a0
		lib	Icon,FreeDiskObject

ShutDown2000:	move.l	OldLock,d1
		beq	ShutDown1050
		lib	Dos,CurrentDir

ShutDown1050:	move.l	WBMsg,d2
		beq	ShutDown1000
		lib	Exec,Forbid
		move.l	d2,a1
		flib	Exec,ReplyMsg

ShutDown1000:	closlib	Icon
		closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;Get length of text in given address
;
;Input a1 = Address of null terminated text string
;
;Result d0 = Length

GetLength:	clr.l	d0
		cmp.l	#$00,a1		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d0
		tst.b	(a1)+
		bne	GetLength2
		sub.l	#1,d0		;don't include NULL
GetLength_OUT:	rts


ConvASCII:	clr.l	d0
		clr.l	d1
		cmp.b	#' ',(a0)
		bne	ConvASCII2
		add.l	#1,a0
ConvASCII2:	move.b	(a0),d1
		cmp.b	#'0',d1
		bcs	ConvASCII_OUT
		cmp.b	#'9',d1
		bhi	ConvASCII_OUT
		sub.b	#'0',d1
		mulu.w	#10,d0
		add.l	d1,d0
		add.l	#1,a0
		bra	ConvASCII2
ConvASCII_OUT:	rts

;Error etc. messages

Usage:		lea.l	UsageText1,a0
		bsr	Printer
		bra	ShutDown

NoDos:		add.l	#8,sp
		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoNIL:		lea.l	NoNILText1,a0
		bsr	Printer
		bra	ShutDown

NoIcon:		lea.l	NoIconText1,a0
		bsr	Printer
		bra	ShutDown

NoIOReq:	lea.l	NoIOReqText1,a0
		bsr	Printer
		bra	ShutDown

NoSerial:	lea.l	NoSerialText1,a0
		bsr	Printer
		move.l	SerName,a0
		bsr	Printer
		lea.l	NoSerialText2,a0
		bsr	Printer
		bra	ShutDown

Printer:	printa	a0,_stdout
		rts


;Structures

Iconify:	dc.w	0		;(1 = Yes, please)

;lib stuff

_SysBase:	dc.l	0
_DOSBase:	dc.l	0

		libnames

;Other stuff, part I

OurTask:	dc.l	0
SRPort:		dc.l	0
IORequest:	dc.l	0
NILFile:	dc.l	0
_stdout:	dc.l	0
WBMsg:		dc.l	0
DiskObject:	dc.l	0
OldLock:	dc.l	0

;Serial device stuff

SerName:	dc.l	SerName2		;A pointer!
SerUnit:	dc.l	0
SerOpen:	dc.w	0

;Strings, error

BreakText1:	dc.b	"***Break",13,10,0
NoNILText1:	dc.b	"ERROR: Couldn't open device NIL:!",13,10,0
NoIconText1:	dc.b	"ERROR: Couldn't open icon.library!",13,10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",13,10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"modem0.device",0
NoSerialText2:	dc.b	10,0

;Strings, names

RSVersion:	dc.b	"$VER: "
UsageText1:	dc.b	"Reserve Serial 321.221 (1.7.92). (C)opyright Tomi Blinnikka 1992",13,10,13,10
		dc.b	10,"           !!! BETA TESTER VERSION !!!",13,10,13,10,13,10
		dc.b	"USAGE: RS [Unit] [Device]",13,10,13,10
		dc.b	"       Where: [Unit] is the unit number",13,10
		dc.b	"              [Device] is the device name",13,10,13,10
		dc.b	"       Default [Device] is serial.device",13,10,13,10
		dc.b	"Program opens specified device.",13,10
		dc.b	"See docs for more information.",13,10,0
SRPortName:	dc.b	"ResSer port",0
NILName:	dc.b	"NIL:",0
DEVICEText1:	dc.b	"DEVICE",0
UNITText1:	dc.b	"UNIT",0
YESText1:	dc.b	"YES",0
		ds.l	0

		end

