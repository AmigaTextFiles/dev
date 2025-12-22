*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		 by Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	10/01/1993			*
*	 -0.99ö					*
*						*
* Version 1.00	DD/MM/1993			*
*						*
* BUGS:						*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"devices/serial.i"
	INCLUDE	"devices/timer.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"


TRUE:		EQU	1
FALSE:		EQU	0

		section	NoDisCo,CODE

		push	d2-d7/a2-a6

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask

OpenDos:	openlib	Dos,NoDos		;Keep at beginning

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

		tst.l	UnitPointer
		beq	DoParsing1
		move.l	UnitPointer,a0
		move.l	(a0),SerUnit
DoParsing1:	tst.l	SpeedPointer
		beq	DoParsing2
		move.l	SpeedPointer,a0
		move.l	(a0),Speed
DoParsing2:	tst.l	TimePointer
		beq	DoParsing3
		move.l	TimePointer,a0
		move.l	(a0),Time
DoParsing3:

;Create reply port for timer.device

		lib	Exec,CreateMsgPort
		move.l	d0,TRPort
		beq	NoMsgPort

;Create IOReq for timer.device

		move.l	#IOTV_SIZE,d0
		move.l	TRPort,a0
		lib	Exec,CreateIORequest
		move.l	d0,TIORequest
		beq	NoIOReq

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

;open timer.device

		lea.l	TimerName,a0
		move.l	TIORequest,a1
		move.l	#UNIT_VBLANK,d0
		clr.l	d1				;no flags
		lib	Exec,OpenDevice
		tst.l	d0
		bne	NoTimer
		move.w	#$1,TimerOpen			;just to tell if open

;Set up first wait request

		bsr	Waiter

;open serial.device

		move.l	SerName,a0
		move.l	SerUnit,d0
		move.l	IORequest,a1
		move.b	#SERF_SHARED,IO_SERFLAGS(a1)
		clr.l	d1				;no flags
		lib	Exec,OpenDevice
		tst.l	d0
		bne	NoSerial
		move.w	#$1,SerOpen			;just to tell if open

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

SkipSetParams:

;Wait for signals from serial.device, keyboard (CTRL_C).

Main:		clr.l	d1			;Set signals for
		clr.l	d0
		move.l	TRPort,a0		;timer.device
		move.b	MP_SIGBIT(a0),d1
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		bset.l	#SIGBREAKB_CTRL_D,d0	;and CTRL_D
		bset.l	#SIGBREAKB_CTRL_E,d0	;and CTRL_E
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break
		cmp.l	#SIGBREAKF_CTRL_D,d0	;If CTRL_D
		beq	Disable			;go disable
		cmp.l	#SIGBREAKF_CTRL_E,d0	;If CTRL_E
		beq	Enable			;go enable

		move.l	TRPort,a0
		move.b	MP_SIGBIT(a0),d1
		btst	d1,d0			;test for timer.device
		beq	Main			;if was go do Space->BS
		move.l	TRPort,a0
		lib	Exec,GetMsg
		bsr	DoNoDisCo
		bsr	Waiter
		bra	Main

Break:		lea.l	BreakText1,a0
		bsr	Printer
		bra	ShutDown

Disable:	move.l	#1,Active
		lea.l	DisabledText1,a0
		bsr	Printer
		bra	Main

Enable:		clr.l	Active
		lea.l	EnabledText1,a0
		bsr	Printer
		bra	Main

ClearTimer:	move.l	TIORequest,a1
		lib	Exec,AbortIO
		tst.l	d0
		beq	ClearTimer1
		move.l	TRPort,a0
		lib	Exec,GetMsg
ClearTimer1:	move.l	TIORequest,a1
		lib	Exec,WaitIO
		rts

Waiter:		move.l	TIORequest,a1
		move.w	#TR_ADDREQUEST,IO_COMMAND(a1)
		move.l	Time,IOTV_TIME(a1)
		move.l	#2,IOTV_TIME+4(a1)	;just in case secs=0
		lib	Exec,SendIO
		rts

DoNoDisCo:	tst.l	Active
		bne	DoNoDisCo_OUT

		move.l	IORequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)
		lea.l	SpaceText1,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO

		move.l	#50,d1
		lib	Dos,Delay

		move.l	IORequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)
		lea.l	DelText1,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO
DoNoDisCo_OUT:	rts

ShutDown:	tst.w	SerOpen
		beq	ShutDown9000
		move.l	IORequest,a1
		lib	Exec,CloseDevice

ShutDown9000:	tst.w	TimerOpen
		beq	ShutDown8000
		bsr	ClearTimer
		move.l	TIORequest,a1
		lib	Exec,CloseDevice

ShutDown8000:	move.l	TIORequest,a0
		lib	Exec,DeleteIORequest

		move.l	TRPort,a0
		lib	Exec,DeleteMsgPort

		move.l	IORequest,a0
		lib	Exec,DeleteIORequest

		move.l	SRPort,a0
		lib	Exec,DeleteMsgPort

ShutDown7000:
ShutDown4000:	move.l	RDArgs1,d1
		beq	ShutDown3000
		lib	Dos,FreeArgs

ShutDown3000:
ShutDown1000:	closlib	Dos
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

NoTimer:	lea.l	NoTimerText1,a0
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

;Structures

		libnames

;Other stuff, part I

OurTask:	dc.l	0
RDArgs1:	dc.l	0
TRPort:		dc.l	0
SRPort:		dc.l	0
TIORequest:	dc.l	0
IORequest:	dc.l	0
_stdout:	dc.l	0

;Options

CLArray1:
Active:		dc.l	0		;(0 = Yes, please, 1=No)
TimePointer:	dc.l	0
SerName:	dc.l	SerName2	;A pointer!
UnitPointer:	dc.l	0
SpeedPointer:	dc.l	0

;Device stuff

SerUnit:	dc.l	0
Speed:		dc.l	0
Time:		dc.l	120
SerOpen:	dc.w	0
TimerOpen:	dc.w	0

;Strings, error

BreakText1:	dc.b	"***Break: NoDisCo",13,10,0
NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",13,10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",13,10,0
NoSetSerText1:	dc.b	"ERROR: Couldn't set parameters for device!",13,10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"serial.device",0
NoSerialText2:	dc.b	13,10,0
NoTimerText1:	dc.b	"ERROR: Couldn't open timer.device",13,10,0

;Strings, names

CLTemplate1:	dc.b	"D=DISABLE/S,TIME/N/K,DEV=DEVICE/K,UNIT/N/K,SPEED/N/K",0
RDVersion:	dc.b	"$VER: NoDisCo 1.00 (10.1.93) (C)opyright Tomi Blinnikka 1993",0
DisabledText1:	dc.b	"NoDisCo disabled.",13,10,0
EnabledText1:	dc.b	"NoDisCo enabled.",13,10,0
SpaceText1:	dc.b	" ",0			;Space
DelText1:	dc.b	8,0			;Backspace
TimerName:	dc.b	"timer.device",0
		ds.w	0

		end

