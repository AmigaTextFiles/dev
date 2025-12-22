*************************************************
*						*
*		 (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	28/05/1992			*
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

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"


LF:		EQU	10
CR:		EQU	13
CTRL_O:		EQU	$0F
CTRL_P:		EQU	$10

QUIT_KEY:	EQU	CTRL_P
STATS_KEY:	EQU	CTRL_O

FALSE:		EQU	0
TRUE:		EQU	1

BUFLEN:		EQU	1024

		section	ST,CODE

		push	d2-d7/a2-a6
		push	d0/a0

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask

		openlib	Dos,NoDos		;Keep at beginning

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout
		lib	Dos,Input
		move.l	d0,_stdin
		move.l	d0,d1
		lib	Dos,IsInteractive
		tst.l	d0
		beq	NotInteractive
		pull	d0/a0
		clr.b	-1(a0,d0.l)
		cmp.b	#'?',(a0)
		beq	Usage
		cmp.w	#'-?',(a0)
		beq	Usage
		cmp.w	#'-h',(a0)
		beq	Usage

Cont0.2:	bsr	ConvASCII
		tst.w	d0
		beq	Cont1
		move.w	d0,SerUnit
Cont1:		cmp.b	#' ',(a0)
		bne	Cont1.1
		add.l	#1,a0
Cont1.1:	tst.b	(a0)
		beq	Cont1.2
		move.l	a0,SerName
Cont1.2:

;Create read reply port for serial.device (or modem0.device etc.)

MainStart:	lib	Exec,CreateMsgPort
		move.l	d0,SRRPort
		beq	NoMsgPort

;Create read IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SRRPort,a0
		lib	Exec,CreateIORequest
		move.l	d0,IORRequest
		beq	NoIOReq

		move.l	IORRequest,a1
		move.w	#CMD_READ,IO_COMMAND(a1)
		lea.l	Buffer2,a0
		move.l	a0,IO_DATA(a1)

;Create write reply port for serial.device (or modem0.device etc.)

		lib	Exec,CreateMsgPort
		move.l	d0,SWRPort
		beq	NoMsgPort

;Create write IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SWRPort,a0
		lib	Exec,CreateIORequest
		move.l	d0,IOWRequest
		beq	NoIOReq

		move.l	IOWRequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)		;writes in one byte "chunks"
		lea.l	Buffer1,a0
		move.l	a0,IO_DATA(a1)

;open serial.device

		move.l	SerName,a0
		move.l	SerUnit,d0
		move.l	IORRequest,a1
		move.b	#SERF_SHARED,IO_SERFLAGS(a1)
		clr.l	d1				;no flags
		lib	Exec,OpenDevice
		tst.l	d0
		bne	NoSerial
		move.w	#$1,SerOpen		;just to tell if open

;Copy info from one req to the other

		move.l	IORRequest,a0
		move.l	IOWRequest,a1
		move.l	IO_DEVICE(a0),IO_DEVICE(a1)
		move.l	IO_UNIT(a0),IO_UNIT(a1)


		lea.l	StartText1,a0
		bsr	Printer

;Change mode for CLI to RAW:

		move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

		bsr	Reader

;LOOP
;waitfor char(shell,5000)
;if char 
; IF 'EXIT' then exit
; ELSE write to serial
;ENDIF
;
;checkIO(readrequest)
;if done write to shell
;read 1 char from serial (immediate return)
;
;ELSE goto LOOP

Looper:		move.l	_stdin,d1
		move.l	#5000,d2
		lib	Dos,WaitForChar
		tst.l	d0
		beq	Looper1
		move.l	_stdin,d1
		lea.l	Buffer1,a0
		move.l	a0,d2
		move.l	#1,d3
		lib	Dos,Read
		cmp.b	#QUIT_KEY,Buffer1
		beq	Menu
		bsr	Writer
Looper1:	bsr	Read
		tst.l	d0
		beq	Looper

		move.l	_stdout,d1
		lea.l	Buffer3,a0
		move.l	a0,d2
		move.l	d0,d3
		lib	Dos,Write

		bra	Looper

Menu:		lea.l	MenuText1,a0
		bsr	Printer
Menu1:		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	ShutDown
		cmp.l	#'1',d0
		beq	DoStats
		cmp.l	#'2',d0
		beq	ClearReceived
		cmp.l	#'3',d0
		beq	ClearSent
		cmp.l	#'4',d0
		beq	ClearBoth
		cmp.l	#'5',d0
		beq	DoCTRL_P
		cmp.l	#'6',d0
		beq	DoReset
		cmp.l	#'7',d0
		beq	DoHangUp
		cmp.l	#'8',d0
		beq	DoInfo
		cmp.l	#'9',d0
		beq	Quit
		cmp.l	#'0',d0
		bne	Menu2
		lea.l	ExitText1,a0
		bsr	Printer
		bra	Looper1
Menu2:		bra	Menu1

DoStats:	lea.l	StatsText2,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		bsr	GiveStats
		bra	Exit

ClearReceived:	lea.l	ClearText1,a0
		bsr	Printer
		clr.l	Received
		bra	Exit

ClearSent:	lea.l	ClearText1,a0
		bsr	Printer
		clr.l	Sent
		bra	Exit

ClearBoth:	lea.l	ClearText1,a0
		bsr	Printer
		clr.l	Received
		clr.l	Sent
		bra	Exit

DoCTRL_P:	move.b	CTRL_P,Buffer1
		bsr	Writer
		lea.l	CTRL_PText1,a0
		bsr	Printer
		add.l	#1,Sent
		bra	Exit

DoReset:	lea.l	ResetText1,a0
		bsr	Printer
		lea.l	ResetText2,a1
		bsr	GetLength
		add.l	d0,Sent
		lea.l	ResetText2,a0
		bsr	Writer2
		bra	Exit

DoHangUp:	lea.l	HangUpText1,a0
		bsr	Printer
		move.l	#55,d1
		lib	Dos,Delay
		lea.l	HangUpText2,a1
		bsr	GetLength
		add.l	d0,Sent
		lea.l	HangUpText2,a0
		bsr	Writer2
		move.l	#55,d1
		lib	Dos,Delay
		lea.l	HangUpText3,a1
		bsr	GetLength
		add.l	d0,Sent
		lea.l	HangUpText3,a0
		bsr	Writer2
		bra	Exit

DoInfo:		lea.l	InfoText1,a0
		bsr	Printer
		lea.l	AuthorText1,a0
		bsr	Printer
		bra	Exit

Quit:		lea.l	QuitText1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		bsr	GiveStats
		bra	ShutDown

Exit:		lea.l	TerminalText1,a0
		bsr	Printer
		bra	Looper1

Break:		lea.l	BreakText1,a0
		bsr	Printer
		clr.l	d0
		rts

ClearSer:	move.l	IORRequest,a1
		lib	Exec,CheckIO
		tst.l	d0
		beq	ClearSer1
		move.l	IORRequest,a1
		lib	Exec,WaitIO

ClearSer1:	move.l	IORRequest,a1
		ABORTIO
		move.l	IORRequest,a1
		lib	Exec,WaitIO
		rts

;Buffered read from a device
;
;Inputs d0 = Buffer length (maximum amount to read)
;
;Result d0 = amount read
;

Read:		push	d2-d7/a2-a6
		move.l	d0,d4

		tst.w	Requested
		beq	Read3

		move.l	SRRPort,a0
		lib	Exec,GetMsg
		tst.l	d0
		beq	Read_OUT1

		move.l	IORRequest,a1
		tst.b	IO_ERROR(a1)
		beq	Read1
		clr.w	Requested
		bra	Read_OUT1
		
Read1:		add.l	#1,Received
		move.b	Buffer2,Buffer3
		move.l	#1,BufCount
		bra	Read3

Read2:		clr.l	BufCount

Read3:		move.l	IORRequest,a1
		clr.b	IO_ERROR(a1)
		or.b	#IOF_QUICK,IO_FLAGS(a1)
		move.w	#1,Requested

ReadLoop:	cmp.l	BufCount,d4
		beq	Read_OUT2

		move.l	IORRequest,a1
		BEGINIO

		move.l	IORRequest,a1
		tst.b	IO_ERROR(a1)
		beq	ReadLoop1

		move.l	SRRPort,a0
		lib	Exec,GetMsg
		clr.w	Requested
		bra	Read_OUT2
		
ReadLoop1:	move.l	IORRequest,a1
		move.b	IO_FLAGS(a1),d0
		and.b	#IOF_QUICK,d0
		beq	Read_OUT2

		add.l	#1,Received
		lea.l	Buffer3,a0
		add.l	BufCount,a0
		move.b	Buffer2,(a0)
		add.l	#1,BufCount

		cmp.b	#LF,Buffer2
		bne	ReadLoop
		move.l	IORRequest,a1
		move.b	IO_FLAGS(a1),d0
		and.b	#~IOF_QUICK,d0
		move.b	d0,IO_FLAGS(a1)
		BEGINIO
		move.l	IORRequest,a1
		tst.b	IO_ERROR(a1)
		beq	Read_OUT2
		move.l	SRRPort,a0
		lib	Exec,GetMsg
		clr.w	Requested
		bra	Read_OUT2
Read_OUT1:	clr.l	d0
		pull	d2-d7/a2-a6
		rts
Read_OUT2:	move.l	BufCount,d0
		pull	d2-d7/a2-a6
		rts

Reader:		move.l	IORRequest,a1
		move.w	#CMD_READ,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)
		lea.l	Buffer2,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,SendIO
		rts

Writer:		add.l	#1,Sent
		move.l	IOWRequest,a1
		lib	Exec,DoIO		;May freeze, too bad
		rts
;Writes string to serial port
;
;D0 = Length
;A0 = String

Writer2:	move.l	IOWRequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	d0,IO_LENGTH(a1)
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO		;May freeze, too bad

;Reset back to default...

		move.l	IOWRequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)		;writes in one byte "chunks"
		lea.l	Buffer1,a0
		move.l	a0,IO_DATA(a1)
		rts


GiveStats:	lea.l	fstrl1,a0		;HEX->ASCII
		lea.l	Received,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	ReceivedText1,a3	;Destination
		lib	Exec,RawDoFmt

		lea.l	fstrl2,a0		;HEX->ASCII
		lea.l	Sent,a1			;Number2Print
		lea.l	PutChProc,a2
		lea.l	SentText1,a3		;Destination
		lib	Exec,RawDoFmt

		lea.l	StatsText1,a0
		bsr	Printer
		lea.l	ReceivedText1,a0
		bsr	Printer
		lea.l	SentText1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		rts

ShutDown:	tst.w	SerOpen
		beq	ShutDown9000
		bsr	ClearSer
		move.l	IORRequest,a1
		lib	Exec,CloseDevice

ShutDown9000:	move.l	IORRequest,a0
		lib	Exec,DeleteIORequest

ShutDown8000:	move.l	SRRPort,a0
		lib	Exec,DeleteMsgPort

ShutDown7000:	move.l	IOWRequest,a0
		lib	Exec,DeleteIORequest

ShutDown6000:	move.l	SWRPort,a0
		lib	Exec,DeleteMsgPort

ShutDown5000:	move.l	_stdin,d1
		beq	ShutDown4000
		move.l	#FALSE,d2
		lib	Dos,SetMode

ShutDown4000:
ShutDown1000:	closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;CheckEvent gets messages from serial.device and keyboard (CTRL_C)
;Give it the window structure in a0

CheckEvent:	clr.l	d0
		clr.l	d1
		move.l	SRRPort,a1		;serial.device
		move.l	a1,a2
		move.b	MP_SIGBIT(a1),d1
		bset.l	d1,d0
		lib	Exec,Wait

C2GetMsg2:	move.l	#-1,d0
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

NotInteractive:	add.l	#8,sp
		lea.l	NotIntText1,a0
		bsr	Printer
		bra	ShutDown

NoMsgPort:	lea.l	NoMsgPortText1,a0
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

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

;Structures

;lib stuff

		libnames

;Other stuff, part I

OurTask:	dc.l	0
SRRPort:	dc.l	0
IORRequest:	dc.l	0
SWRPort:	dc.l	0
IOWRequest:	dc.l	0
_stdout:	dc.l	0
_stdin:		dc.l	0
BufCount:	dc.l	0
Requested:	dc.w	0
Sent:		dc.l	0			;Count sent chars
Received:	dc.l	0			;Count reveived chars

;Serial device stuff

SerName:	dc.l	SerName2		;A pointer!
SerUnit:	dc.l	0
SerOpen:	dc.w	0

;Strings, error

BreakText1:	dc.b	"***Break",10,0
NotIntText1:	dc.b	"ERROR: Please don't redirect input!",10,0
NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"modem0.device",0
NoSerialText2:	dc.b	10,0

;Strings, Menus, starting, quitting & statistics

MenuText1:	dc.b	13,10,"ShellTerm menu. Please choose item:",13,10
		dc.b	13,10,"1) Statistics"
		dc.b	13,10,"2) Clear received"
		dc.b	13,10,"3) Clear sent"
		dc.b	13,10,"4) Clear both"
		dc.b	13,10,"5) Send CTRL-P (ASCII: DLE #16 $10 &020)"
		dc.b	13,10,"6) Reset modem (Using Hayes-commands)"
		dc.b	13,10,"7) Hangup line (Using Hayes-commands)"
		dc.b	13,10,"8) Program and author information"
		dc.b	13,10,"9) Quit ShellTerm"
		dc.b	13,10,"0) Exit menu",13,10
		dc.b	13,10,"Selection: ",0
InfoText1:	dc.b	"Information",13,10,0
CTRL_PText1:	dc.b	"CTRL-P sent",13,10,0
ExitText1:	dc.b	"Exit",13,10
TerminalText1:	dc.b	13,10,"Terminal mode active:",13,10,0
StartText1:	dc.b	"Welcome to ShellTerm. Use CTRL-P to get menu.",13,10,0
QuitText1:	dc.b	"Quit",13,10,0
StatsText1:	dc.b	"Statistics:",13,10,0
StatsText2:	dc.b	"Statistics",13,10,0
ReceivedText1:	dc.b	"                             ",00,00,0	;max of 4294967295
;			"   4294967295 bytes received.",CR,LF
SentText1:	dc.b	"                         ",00,00,0	;max of 4294967295
;			"   4294967295 bytes sent.",CR,LF
fstrl1:		dc.b	"   %10.ld bytes received.",13,10,0
fstrl2:		dc.b	"   %10.ld bytes sent.",0
ClearText1:	dc.b	"Cleared",13,10,0
CRLFText1:	dc.b	CR,LF,0
ResetText1:	dc.b	"Reset",13,10,0
ResetText2:	dc.b	"ATH",13,10,0
HangUpText1:	dc.b	"Hangup",13,10,0
HangUpText2:	dc.b	"+++",0
HangUpText3:	dc.b	"ATZ",13,10,0

;Strings, names

STVersion:	dc.b	"$VER: "
UsageText1:	dc.b	"ShellTerm 1.00 (4.8.92) (C)opyright Tomi Blinnikka 1992",13,10,13,10
;		dc.b	10,"           !!! BETA TESTER VERSION !!!",13,10,13,10,13,10
		dc.b	"USAGE: ShellTerm [Unit] [Device]",13,10,13,10
		dc.b	"       Where: [Unit] is the unit number",13,10
		dc.b	"              [Device] is the device name",13,10,13,10
		dc.b	"       Default [Device] is serial.device",13,10,13,10
		dc.b	"Use current shell as a terminal program.",13,10
		dc.b	"See docs for more information.",13,10,0
AuthorText1:	dc.b	13,10,"Name    : ShellTerm",13,10
		dc.b	"Version : 1.00 (4.8.92)",13,10
		dc.b	"Author  : Tomi Blinnikka",13,10,13,10
		dc.b	"(C)opyright Tomi Blinnikka 1992",13,10,0
DEVICEText1:	dc.b	"DEVICE",0
UNITText1:	dc.b	"UNIT",0
YESText1:	dc.b	"YES",0
		ds.l	0

;Buffers

Buffer1:	dcb.b	2,0		;For writes to serial (read from CLI)
Buffer2:	dcb.b	2,0		;For reads
Buffer3:	dcb.b	BUFLEN,0	;For writes to CLI

		end

