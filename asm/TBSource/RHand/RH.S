*************************************************
*						*
*		 (C)opyright 1991		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	14/12/1991			*
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
	INCLUDE	"devices/keyboard.i"
;	INCLUDE	"devices/inputevent.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	RHand,CODE

		openlib	Dos,ShutDown

;Get a signal bit

		move.l	#-1,d0
		lib	Exec,AllocSignal
		move.l	d0,SigBit2
		bmi	ShutDown

;Open keyboard.device

		lea.l	KeyboardName,a0
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

;Install handler

		lea.l	Interrupt,a5
		move.b	#NT_INTERRUPT,LN_TYPE(a5)
		move.b	#32,LN_PRI(a5)
		lea.l	HandlerCode,a2
		move.l	a2,IS_CODE(a5)
		move.l	#$00,IS_DATA(a5)
		lea.l	IORequest,a1
		move.w	#KBD_ADDRESETHANDLER,IO_COMMAND(a1)
		move.l	a5,IO_DATA(a1)
		lib	Exec,DoIO
		tst.l	d0
		bne	ShutDown

MainLoop:	;move.l	#$00,d0
		move.l	SigBit2,d0
		bset.l	#SIGBREAKB_CTRL_C,d0
		lib	Exec,Wait

		cmp.l	SigBit2,d0
		beq	ML1
		bra	ShutDown

; Add stuff to be done here!

ML1:		bsr	DoEffect

;		move.l	#1*50,d1
;		lib	Dos,Delay

		lea.l	IORequest,a1
		move.w	#KBD_RESETHANDLERDONE,IO_COMMAND(a1)
		lib	Exec,DoIO
		tst.l	d0
		beq	ShutDown
		bra	MainLoop

ShutDown:	lea.l	IORequest,a1
		move.w	#KBD_REMRESETHANDLER,IO_COMMAND(a1)
		move.l	a5,IO_DATA(a1)
		lib	Exec,DoIO
		tst.l	d0
		beq	ShutDown9000

		print	<"ERROR: Can't remove handler!",13,10>
		print	<"Press CTRL-C to abort, CTRL-D to try again.",13,10>

		move.l	#$00,d0
		bset	#SIGBREAKB_CTRL_C,d0
		bset	#SIGBREAKB_CTRL_D,d0
		lib	Exec,Wait
		btst	#SIGBREAKB_CTRL_D,d0		;Continue from
		beq	ShutDown			;CTRL-D

		print	<"Skipping...",13,10>

ShutDown9000:	move.l	IDev,d0
		bne	ShutDown8000
		lea.l	IORequest,a1
		lib	Exec,CloseDevice

ShutDown8000:	move.l	SigBit1,d0
		bmi	ShutDown7900
		lib	Exec,FreeSignal

ShutDown7900:	move.l	SigBit2,d0
		bmi	ShutDown7000
		lib	Exec,FreeSignal

ShutDown7000:	closlib	Dos
		clr.l	d0
		rts

DoEffect:	lea.l	CmdName1,a0
		move.l	a0,d1
		clr.l	d2
		clr.l	d3
		lib	Dos,Execute
		rts

;Handler code starts here

HandlerCode:	push	d0-d7/a0-a6

		move.l	OurTask,a1
		move.l	SigBit2,d0
		lib	Exec,Signal

Handler_OUT:	pull	d0-d7/a0-a6
		rts

;Structures

		libnames

;Other stuff, part I

SigBit1:	dc.l	0
SigBit2:	dc.l	0
OurTask:	dc.l	0

;Devices

IDev:		dc.l	0

;Strings, part I

KeyboardName:	dc.b	"keyboard.device",0
;CmdName1:	dc.b	"SPlay SAMPLES:Arnold/IllBeBack",0
CmdName1:	dc.b	"SPlay SAMPLES2:HATE.SND",0
		ds.l	0

;Other stuff, part II

IORequest:	dcb.b	IO_SIZE,0
MsgPort:	dcb.b	MP_SIZE,0
Interrupt:	dcb.b	IS_SIZE,0
		end
