*************************************************
*						*
*		 (C)opyright 1991		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version: See info from main source code	*
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
	INCLUDE	"intuition/intuition.i"
	INCLUDE	"devices/input.i"
	INCLUDE	"devices/inputevent.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

	XREF	_DosBase
	XREF	OurTask
	XREF	DesStrGad1
	XREF	IHandler
	XREF	_stdout

	XDEF	OurIntuiMsg
	XDEF	MakeIHand
	XDEF	RemIHand
	XDEF	SigBit2

OURCODE:	EQU	$DEADBEEF

		section	IHand,CODE

;Get a signal bit

MakeIHand:	move.l	#-1,d0
		lib	Exec,AllocSignal
		move.l	d0,SigBit2
		bmi	RemIHand

;Open input.device

		lea.l	InputName,a0
		move.l	#$00,d0
		lea.l	IORequest,a1
		move.l	#$00,d1
		lib	Exec,OpenDevice
		move.l	d0,IDev
		bne	RemIHand

;Make a message port

		lea.l	MsgPort,a2
		move.b	#NT_MSGPORT,LN_TYPE(a2)
		clr.b	MP_FLAGS(a2)
		clr.l	LN_NAME(a2)
		move.l	#-1,d0
		lib	Exec,AllocSignal
		move.l	d0,SigBit1
		bmi	RemIHand
		move.b	d0,MP_SIGBIT(a2)


		move.l	OurTask,MP_SIGTASK(a2)

		lea.l	MP_MSGLIST(a2),a0
		NEWLIST	a0
		lea.l	IORequest,a1
		move.l	a2,MN_REPLYPORT(a1)

;Install handler

		lea.l	Interrupt,a5
		move.b	#NT_INTERRUPT,LN_TYPE(a5)
		move.b	#120,LN_PRI(a5)
		lea.l	HandlerCode,a2
		move.l	a2,IS_CODE(a5)
		lea.l	OurIntuiMsg,a1
		move.l	a1,IS_DATA(a5)
		lea.l	IHandName,a1
		move.l	a1,LN_NAME(a5)
		lea.l	IORequest,a1
		move.w	#IND_ADDHANDLER,IO_COMMAND(a1)
		move.l	a5,IO_DATA(a1)
		lib	Exec,DoIO
		tst.l	d0
		bne	RemIHand
		move.l	#-1,d0
		rts

RemIHand:	lea.l	Interrupt,a5
		lea.l	IORequest,a1
		move.w	#IND_REMHANDLER,IO_COMMAND(a1)
		move.l	a5,IO_DATA(a1)
		lib	Exec,DoIO
		tst.l	d0
		beq	RemIHand9000

		print	<"ERROR: Can't remove handler!",13,10>,_stdout
		print	<"Press CTRL-C to abort, CTRL-D to try again.",13,10>,_stdout

		move.l	#$00,d0
		bset	#SIGBREAKB_CTRL_C,d0
		bset	#SIGBREAKB_CTRL_D,d0
		lib	Exec,Wait
		btst	#SIGBREAKB_CTRL_D,d0		;Continue from
		beq	RemIHand			;CTRL-D

		print	<"Skipping...",13,10>,_stdout

RemIHand9000:	move.l	IDev,d0
		bne	RemIHand8000
		lea.l	IORequest,a1
		lib	Exec,CloseDevice

RemIHand8000:	move.l	SigBit1,d0
		bmi	RemIHand7900
		lib	Exec,FreeSignal

RemIHand7900:	move.l	SigBit2,d0
		bmi	RemIHand7000
		lib	Exec,FreeSignal

RemIHand7000:	clr.l	d0
		rts

;Handler code starts here

HandlerCode:	push	d0-d7/a0-a6
		tst.w	IHandler
		beq	Handler_OUT
HandlerCode1:	move.b	ie_Class(a0),d2
		cmpi.b	#IECLASS_RAWKEY,d2
		bne	HandlerCode2			;Process RAWKEY events only
		cmp.w	#IECODE_UP_PREFIX,ie_Code(a0)	;Process only key going
		bne	HandlerCode3			;down

HandlerCode2:	move.l	ie_NextEvent(a0),d0
		move.l	d0,a0
		bne	HandlerCode1
		jmp	Handler_OUT

HandlerCode3:	move.l	#IEQUALIFIER_RCOMMAND,d0
		move.l	d0,d1
		and.w	ie_Qualifier(a0),d1
		cmp.w	d0,d1
		bne	Handler_OUT

HandlerCode4:	jsr	TestGads
		tst.l	d0
		bne	Handler_OUT
		cmp.w	#$32,ie_Code(a0)		;Don't do Q or
		beq	Handler_OUT			;Z, cos' there
		cmp.w	#$10,ie_Code(a0)		;in use by system
		beq	Handler_OUT
		move.b	#IECLASS_NULL,ie_Class(a0)	;Kill this event
		move.w	ie_Code(a0),im_Code(a1)
		move.l	#OURCODE,im_Class(a1)
		move.l	OurTask,a1
		move.l	SigBit2,d0
		lib	Exec,Signal

Handler_OUT:	pull	d0-d7/a0-a6
		move.l	a0,d0
		rts

;Test if any string gadgets are active.
;d0 = 0 if one is
;d0 = -1 if none are

TestGads:	push	d1/a1
		lea.l	DesStrGad1,a1
TestGads1:	move.w	#SELECTED,d0
		move.w	d0,d1
		and.w	gg_Flags(a1),d1
		cmp.w	d0,d1
		beq	TestGads2

		move.l	(a1),a1
		cmp.l	#$00,a1
		bne	TestGads1
		pull	d1/a1
		move.l	#$-1,d0
		rts

TestGads2:	pull	d1/a1
		move.l	#$00,d0
		rts

;Structures

		libnames

;Other stuff, part I

SigBit1:	dc.l	0
SigBit2:	dc.l	0

;Devices

IDev:		dc.l	0

;Strings, part I

InputName:	dc.b	"input.device",0
IHandName:	dc.b	"Questions",0
		ds.l	0

;Other stuff, part II

IORequest:	dcb.b	IO_SIZE,0
MsgPort:	dcb.b	MP_SIZE,0
Interrupt:	dcb.b	IS_SIZE,0
OurIntuiMsg:	dcb.b	52,0
		end
