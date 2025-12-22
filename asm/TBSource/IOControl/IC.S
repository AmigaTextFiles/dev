*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		  Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 1.00	14/07/1993			*
*						*
* BUGS:						*
*						*
* Version 1.01	17/07/1993			*
*						*
* Renamed from CompleteControl to IOControl.	*
* CompleteControl is now the intuition part	*
* of the control system.			*
*						*
* BUGS:	Missed a NULL from fstrl1.		*
*						*
* Version 1.02	18/07/1993			*
*						*
* BUGS:						*
*						*
*************************************************


	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"exec/devices.i"
	INCLUDE	"devices/serial.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

PROGVERSION:	macro
		dc.b	"1.02 (18.07.93)"
		endm

;Port definitions

MIN_PORT:	EQU	1		;Code supports ports 1-9
MAX_PORT:	EQU	2

PORT_A:		EQU	0		;Code supports ports A, B, C
PORT_B:		EQU	1
PORT_C:		EQU	2

MIN_STATUS:	EQU	0		;Code supports values 0-255
MAX_STATUS:	EQU	255

;Rawkey codes

RAW_ENTER:	EQU	$43
RAW_RETURN:	EQU	$44
RAW_A:		EQU	$20
RAW_B:		EQU	$35
RAW_C:		EQU	$33

RAW_0:		EQU	$0a
RAW_1:		EQU	$01
RAW_2:		EQU	$02
RAW_3:		EQU	$03
RAW_4:		EQU	$04
RAW_5:		EQU	$05
RAW_6:		EQU	$06
RAW_7:		EQU	$07
RAW_8:		EQU	$08
RAW_9:		EQU	$09

;Other stuff

DELAY_AMOUNT:	EQU	6

		section	IOControl,CODE

		push	d2-d7/a2-a6

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask

		openlib	Dos,NoDos

		lib	Dos,Output
		move.l	d0,_stdout

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

DoParsing:	tst.l	UnitPointer
		beq	DoParsing1
		move.l	UnitPointer,a0
		move.l	(a0),SerUnit
DoParsing1:	tst.l	SpeedPointer
		beq	DoParsing2
		move.l	SpeedPointer,a0
		move.l	(a0),Speed
DoParsing2:	tst.l	PortNumPointer
		beq	BadNumber
		move.l	PortNumPointer,a0
		move.l	(a0),d0			;Valid range = 1-2
		cmp.l	#MIN_PORT,d0
		bcs	BadNumber
		cmp.l	#MAX_PORT,d0
		bhi	BadNumber
		move.b	d0,PortNum
DoParsing3:	tst.l	PortABC
		beq	BadTemplate
		move.l	PortABC,a0
		cmp.b	#'a',(a0)
		beq	DoParsing3.1
		cmp.b	#'A',(a0)
		bne	DoParsing3.2
DoParsing3.1:	move.b	#PORT_A,Port
		bra	DoParsing4

DoParsing3.2:	cmp.b	#'b',(a0)
		beq	DoParsing3.3
		cmp.b	#'B',(a0)
		bne	DoParsing3.4
DoParsing3.3:	move.b	#PORT_B,Port
		bra	DoParsing4

DoParsing3.4:	cmp.b	#'c',(a0)
		beq	DoParsing3.5
		cmp.b	#'C',(a0)
		bne	BadTemplate
DoParsing3.5:	move.b	#PORT_C,Port

DoParsing4:	tst.l	StatusPointer
		beq	DoParsing5
		move.l	StatusPointer,a0
		move.l	(a0),d0			;Valid range = 0-255
		cmp.l	#MIN_STATUS,d0
		bcs	BadNumber
		cmp.l	#MAX_STATUS,d0
		bhi	BadNumber
		move.w	d0,Status
DoParsing5:

;Create reply port for serial.device (or modem0.device etc.)

		lib	Exec,CreateMsgPort
		move.l	d0,SWPort
		beq	NoMsgPort

;Create IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SWPort,a0
		clr.b	LN_TYPE(a0)		;Make sure CheckIO doesn't hang
		lib	Exec,CreateIORequest
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

		tst.l	Speed
		beq	SkipSetParams
		move.l	IORequest,a1
		clr.l	IO_LENGTH(a1)
		clr.l	IO_DATA(a1)
		move.w	#SDCMD_SETPARAMS,IO_COMMAND(a1)
		move.l	Speed,IO_BAUD(a1)
		lib	Exec,DoIO
		tst.l	d0
		beq	SkipSetParams
		bsr	NoSetSer

SkipSetParams:	bsr	DoPortNum		;Write port number
		bsr	DoDelay			;Wait for AT to act
		bsr	DoPort			;Write port A, B or C
		bsr	DoStatus		;Write status number

		bra	ShutDown

DoDelay:	move.l	#DELAY_AMOUNT,d1
		lib	Dos,Delay
		rts

DoPortNum:	move.b	PortNum,Buffer1
		bsr	SendOneChar
		rts

DoPort:		cmp.b	#PORT_A,Port
		bne	DoPort2
		move.b	#RAW_A,Buffer1
		bra	DoPort_OUT
DoPort2:	cmp.b	#PORT_B,Port
		bne	DoPort3
		move.b	#RAW_B,Buffer1
		bra	DoPort_OUT
DoPort3:	cmp.b	#PORT_C,Port
		bne	DoPort_OUT
		move.b	#RAW_C,Buffer1
DoPort_OUT:	bsr	SendOneChar
		rts

DoStatus:	lea.l	fstrl1,a0		;HEX->ASCII
		lea.l	Status,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	ASCIINumber1,a3		;Destination
		lib	Exec,RawDoFmt

		lea.l	ASCIINumber1,a0
DoStatus1:	push	a0
		bsr	DoDelay
		pull	a0
		tst.b	(a0)
		beq	DoStatus_OUT
		cmp.b	#'0',(a0)
		beq	DoZero
		sub.b	#$30,(a0)
		move.b	(a0),Buffer1
		bsr	SendOneChar2
		add.l	#1,a0
		bra	DoStatus1

DoZero:		move.b	#RAW_0,Buffer1
		bsr	SendOneChar2
		add.l	#1,a0
		bra	DoStatus1

DoStatus_OUT:	move.b	#RAW_RETURN,Buffer1
		bsr	SendOneChar2
		rts


SendOneChar:	move.b	#RAW_RETURN,Buffer1+1
		clr.b	Buffer1+2
		bsr	Writer
		rts

;Saves a0

SendOneChar2:	push	a0
		clr.b	Buffer1+1
		bsr	Writer
		pull	a0
		rts

ShutDown:	tst.w	SerOpen
		beq	ShutDown9000
		bsr	ClearSer
		move.l	IORequest,a1
		lib	Exec,CloseDevice

ShutDown9000:	move.l	IORequest,a0
		lib	Exec,DeleteIORequest

		move.l	SWPort,a0
		lib	Exec,DeleteMsgPort

ShutDown3000:	move.l	RDArgs1,d1
		beq	ShutDown2000
		lib	Dos,FreeArgs

ShutDown2000:

ShutDown1000:	closlib Dos

		pull	d2-d7/a2-a6
		clr.l	d0
		rts

ClearSer:	clr.w	Buffer1
		move.l	IORequest,a1
		lib	Exec,CheckIO
		tst.l	d0
		bne	ClearSer_OUT
		move.l	IORequest,a1
		lib	Exec,WaitIO
		move.l	IORequest,a1
		ABORTIO
ClearSer_OUT:	rts

Writer:		lea.l	Buffer1,a1
		bsr	GetLength
		move.l	IORequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	d0,IO_LENGTH(a1)
		lea.l	Buffer1,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO
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

;Error etc. messages

NoDos:		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

BadNumber:	move.l	#ERROR_BAD_NUMBER,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

BadTemplate:	move.l	#ERROR_BAD_TEMPLATE,d1
		clr.l	d2
		lib	Dos,PrintFault
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

NoSetSer:	lea.l	NoSetSerText1,a0
		bsr	Printer
		rts

Printer:	printa	a0
		rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

;Library stuff

		libnames

;Reservations


;Options

CLArray1:
SerName:	dc.l	SerName2	;A pointer!
UnitPointer:	dc.l	0
SpeedPointer:	dc.l	0
PortNumPointer:	dc.l	0
PortABC:	dc.l	0
StatusPointer:	dc.l	0

;Serial device stuff

SerUnit:	dc.l	0
Speed:		dc.l	0
SerOpen:	dc.w	0

;I/O-card stuff

PortNum:	dc.b	0		;Port 1 or 2
Port:		dc.b	0		;0=A, 1=B, 2=C
Status:		dc.w	0

;Other stuff, part I

OurTask:	dc.l	0
RDArgs1:	dc.l	0
_stdout:	dc.l	0
SWPort:		dc.l	0
IORequest:	dc.l	0

;Strings, error

NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",13,10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",13,10,0
NoSetSerText1:	dc.b	"ERROR: Couldn't set parameters for device!",13,10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"serial.device",0
NoSerialText2:	dc.b	13,10,0

;Strings, names

CLTemplate1:	dc.b	"DEV=DEVICE/K,UNIT/K/N,SPEED/K/N,PN=PORTNUM/K/N/A,PORT/K/A,ST=STATUS/K/N/A",0
CCVersion:	dc.b	"$VER: IOControl "
		PROGVERSION
		dc.b	" (c) Copyright Tomi Blinnikka 1993",0
fstrl1:		dc.b	"%d",0
		ds.w	0


;Other stuff, part II

;Buffer

Buffer1:	dcb.b	4,0

ASCIINumber1:	dcb.b	12,0
		end
