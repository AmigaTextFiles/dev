*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	 02/04/1993			*
*	 -0.99ö	-				*
*						*
* BUGS:						*
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
	INCLUDE	"exec/interrupts.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"devices/input.i"
	INCLUDE	"devices/inputevent.i"

;	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	SerialKeyBoard,CODE

		oldlib	Dos,ShutDown

;Open input.device

		lea.l	InputName,a0
		move.l	#$00,d0
		lea.l	IORequest,a1
		move.l	#$00,d1
		lib	Exec,OpenDevice
		move.l	d0,IDev
		bne	ShutDown

;make a message port

		lea.l	MsgPort,a2
		move.b	#NT_MSGPORT,LN_TYPE(a2)
		clr.b	MP_FLAGS(a2)
		clr.l	LN_NAME(a2)
		move.l	#-1,d0
		lib	Exec,AllocSignal
		move.l	d0,SigBit1
		bmi	ShutDown
		move.b	d0,MP_SIGBIT(a2)

;Find this task

		move.l	#$00,a1
		lib	Exec,FindTask
		move.l	d0,MP_SIGTASK(a2)
		move.l	d0,OurTask

		lea.l	MP_MSGLIST(a2),a0
		NEWLIST	a0
		lea.l	IORequest,a1
		move.l	a2,MN_REPLYPORT(a1)

		lea.l	IORequest,a1
		move.w	#IND_WRITEEVENT,IO_COMMAND(a1)
		lea.l	Event,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO
		tst.l	d0
		bne	ShutDown

MainLoop:	clr.l	d0
		bset.l	#SIGBREAKB_CTRL_C,d0
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0
		beq	ShutDown
		bra	MainLoop

ShutDown:
ShutDown9000:	move.l	IDev,d0
		bne	ShutDown8000
		lea.l	IORequest,a1
		lib	Exec,CloseDevice

ShutDown8000:	move.l	SigBit1,d0
		bmi	ShutDown7900
		lib	Exec,FreeSignal

ShutDown7900:

ShutDown7000:	closlib	Dos
		clr.l	d0
		rts

;Structures

		libnames

;Other stuff, part I

SigBit1:	dc.l	0
OurTask:	dc.l	0

;Devices

IDev:		dc.l	0

;Strings, error

;Strings, part I

VersionString:	dc.b	"$VER: SerialKeyBoard Server 0.11 (02.04.93) (C)opyright Tomi Blinnikka 1993",0
InputName:	dc.b	"input.device",0
		ds.l	0

;Other stuff, part II

IOEvent:	dcb.b	IE_SIZE,0
IORequest:	dcb.b	IO_SIZE,0
MsgPort:	dcb.b	MP_SIZE,0
		end
