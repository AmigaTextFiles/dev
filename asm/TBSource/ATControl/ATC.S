*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		  Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 1.00	11/07/1993			*
*						*
* BUGS:	Didn't do anything really.		*
*						*
* Version 1.01	14/07/1993			*
*						*
* BUGS:	Didn't set speed or unit.		*
*						*
* Version 1.02	17/07/1993			*
*						*
* BUGS:						*
*						*
*************************************************


	INCLUDE "JMPLibs.i"
	INCLUDE "libraries/dos.i"
	INCLUDE	"exec/devices.i"
	INCLUDE	"devices/serial.i"
	INCLUDE	"intuition/intuition.i"

	INCLUDE "XREF:2.0.xref"
	INCLUDE "XREF:exec.xref"
	INCLUDE "XREF:dos.xref"

PROGVERSION:	macro
		dc.b	"1.02 (17.07.93)"
		endm

		section	ATControl,CODE

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
DoParsing2:

;Create reply port for serial.device (or modem0.device etc.)

		lib	Exec,CreateMsgPort
		move.l	d0,SRPort
		beq	NoMsgPort

;Create IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SRPort,a0
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

SkipSetParams:	bsr	Reader			;Set up first read

MainLoop:	bsr	WaitForChar
		tst.l	d0
		beq	ShutDown
		bsr	SendIDCMP

		move.l	IORequest,a1		;Check to see
		lib	Exec,CheckIO		;if we've already
		tst.l	d0			;finished reading
		beq	MainLoop2		;current char from serial

		bsr	Reader			;Yes, then start new read

MainLoop2:	bra	MainLoop

WaitForChar:	clr.l	d1			;Set signals for
		clr.l	d0
		move.l	SRPort,a1		;serial.device
		move.b	MP_SIGBIT(a1),d1
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break

WaitForChar1:	move.l	SRPort,a0
		lib	Exec,GetMsg

		tst.l	d0
		bne	WaitForChar1
		move.l	#-1,d0			;All OK.
		rts

SendIDCMP:	tst.b	Buffer1
		beq	SendIDCMP_OUT

		lea.l	FakeIDCMP,a2
		move.l	SRPort,MN_REPLYPORT(a2)
		move.b	#NT_MESSAGE,LN_TYPE(a2)

		move.l	#RAWKEY,im_Class(a2)
		move.b	Buffer1,im_Code+1(a2)
;		move.l	Window1,im_IDCMPWindow(a2)

		lib	Exec,Forbid
		lea.l	PortName1,a1		;Find port to send to
		lib	Exec,FindPort
		move.l	d0,a3

		tst.l	d0			;If none skip
		beq	SendIDCMP2

		move.l	a3,a0			;Port
		move.l	a2,a1			;Message
		lib	Exec,PutMsg		;Send!
SendIDCMP2:	lib	Exec,Permit

;		lea.l	Buffer1,a0		;DEBUG
;		bsr	Printer			;DEBUG

		clr.b	Buffer1

		cmp.l	#0,a3
		bne	SendIDCMP_OUT

		lea.l	NoPortText1,a0
		bsr	Printer

SendIDCMP_OUT:	rts

ClearSer:	clr.w	Buffer1
		move.l	IORequest,a1
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

Reader:		move.l	IORequest,a1
		move.w	#CMD_READ,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)
		lea.l	Buffer1,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,SendIO
		rts

Break:		lea.l	BreakText1,a0
		bsr	Printer
		clr.l	d0
		rts

ShutDown:	tst.w	SerOpen
		beq	ShutDown9000
		bsr	ClearSer
		move.l	IORequest,a1
		lib	Exec,CloseDevice

ShutDown9000:	move.l	IORequest,a0
		lib	Exec,DeleteIORequest

		move.l	SRPort,a0
		lib	Exec,DeleteMsgPort


ShutDown3000:	move.l	RDArgs1,d1
		beq	ShutDown2000
		lib	Dos,FreeArgs

ShutDown2000:

ShutDown1000:	closlib Dos

		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;Error etc. messages

NoDos:		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
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



Printer:	printa	a0,_stdout
		rts


;Reservations

		libnames

;Options

CLArray1:
SerName:	dc.l	SerName2	;A pointer!
UnitPointer:	dc.l	0
SpeedPointer:	dc.l	0

;Serial device stuff

SerUnit:	dc.l	0
Speed:		dc.l	0
SerOpen:	dc.w	0

;Other stuff, part I

OurTask:	dc.l	0
RDArgs1:	dc.l	0
_stdout:	dc.l	0
SRPort:		dc.l	0
IORequest:	dc.l	0

;Strings, error & other info

BreakText1:	dc.b	"***Break: ATControl",13,10,0
NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",13,10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",13,10,0
NoSetSerText1:	dc.b	"ERROR: Couldn't set parameters for device!",13,10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"serial.device",0
NoSerialText2:	dc.b	13,10,0
NoPortText1:	dc.b	"ERROR: Port not open!",13,10,0

;Strings, names

CLTemplate1:	dc.b	"DEV=DEVICE/K,UNIT/N/K,SPEED/N/K",0
ATVersion:	dc.b	"$VER: ATControl "
		PROGVERSION
		dc.b	" (c) Copyright Tomi Blinnikka 1993",0
PortName1:	dc.b	"InputMonitorPort.2.Zaphod",0
		ds.w	0


;Our Fake IDCMP Message


FakeIDCMP:	dcb.b	im_SIZEOF,0

;Buffers

Buffer1:	dc.b	2,0


		END
