*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 1.00	08/08/1993			*
*						*
* BUGS:	Doesn't handle international character	*
*	Upper/LowerCase translation.		*
*						*
* Version 1.01	11/08/1993			*
*						*
* BUGS:	Doesn't handle international character	*
*	Upper/LowerCase translation.		*
*						*
* Added a few things to make it safer to use.	*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"devices/input.i"
	INCLUDE	"devices/inputevent.i"
	INCLUDE	"rexx/errors.i"
	INCLUDE	"rexx/storage.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

	XREF	_InvertString
	XREF	_FreeIEvents

	XDEF	_DOSBase
	XDEF	_SysBase
	XDEF	_CxBase

PROGVERSION:	macro
		dc.b	"1.01 (11.08.93)"
		endm

		section	RI,CODE

		push	d2-d7/a2-a6

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask

		openlib	Dos,NoDos
		openlib	Commodities,NoCommodities

		move.l	$4,_SysBase
		move.l	_DosBase,_DOSBase
		move.l	_CommoditiesBase,_CxBase

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

;Check to see if a port with our name already exists

		lib	Exec,Forbid
		move.l	PortPointer,a1
		flib	Exec,FindPort
		push	d0
		flib	Exec,Permit

		pull	d0
		tst.l	d0
		bne	NoMsgPort2

;Create AREXX message port

		lib	Exec,CreateMsgPort
		move.l	d0,ARexxPort
		beq	NoMsgPort

		move.l	ARexxPort,a1
		move.l	PortPointer,a0
		move.l	a0,LN_NAME(a1)
		lib	Exec,AddPort

CheckMessages:	clr.l	d1			;Set signals for
		clr.l	d0
		move.l	ARexxPort,a0		;ARexx
		move.b	MP_SIGBIT(a0),d1
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break

		move.l	ARexxPort,a0		;If ARexx
		move.b	MP_SIGBIT(a0),d1
		btst	d1,d0
		beq	CheckMessages

		bsr	DoARexx			;Go do ARexx magic
		tst.l	d0
		bne	ShutDown
		bra	CheckMessages

;ARexx interface

DoARexx:	move.l	ARexxPort,a0
		lib	Exec,GetMsg

		tst.l	d0
		beq	DoARexx_OUT

		move.l	d0,a5
		cmp.l	#RXCOMM,ACTION(a5)
		bne	DoARexxReply

		lea.l	RexxQuit,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxQuit

		move.l	ARG0(a5),a0
		lea.l	StringBuffer,a1
		bsr	CopyStrs

		bsr	SendEvents
		clr.l	d2
		tst.l	IEvents
		bne	DoARexxOK

DoARexxFail:	move.l	#RC_FATAL,RESULT1(a5)
		bra	DoARexxReply

DoARexxOK:	move.l	#RC_OK,RESULT1(a5)
DoARexxReply:	move.l	a5,a1
		lib	Exec,ReplyMsg
DoARexx_OUT:	move.l	d2,d0
		clr.l	IEvents
		rts

DoRexxQuit:	move.l	#-1,d2
		bra	DoARexxOK

;SendEvents converts ARexx string to lower case and converts it into input
;events and merges these events into the input chain.
;
;Inputs	StringBuffer = String to send

SendEvents:	lea.l	StringBuffer,a0
		bsr	MakeLowerCase

;Convert string into Input Events

		move.l	#0,-(sp)
		pea	StringBuffer
		jsr	_InvertString
		add.l	#8,sp
		move.l	d0,IEvents
		beq	SendEvents2

;Send Input Events

		move.l	IEvents,a0
		lib	Commodities,AddIEvents

;Free Input Events

		move.l	IEvents,-(sp)
		jsr	_FreeIEvents
		add.l	#4,sp
SendEvents2:	rts

;Compares two strings.
;
;INPUT
;
;A0 String 1
;A1 String 2
;
;OUTPUT
;
;D0 = 0 if not same
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

;Inputs	a0 = Pointer to NULL terminated string to convert

MakeLowerCase:	tst.b	(a0)
		beq	MakeLowerCase3
		cmp.b	#'A',(a0)
		bcs	MakeLowerCase2
		cmp.b	#'Z',(a0)
		bhi	MakeLowerCase2
		add.b	#32,(a0)

MakeLowerCase2:	add.l	#1,a0
		bra	MakeLowerCase

MakeLowerCase3: rts

;Copies bytes from a0 to a1 until NULL is reached or maximum amount of 
;255 bytes is copied. Destination will include NULL
;
;Inputs	a0 = Source
;	a1 = Destination

CopyStrs:	move.l	#255,d0

CopyStrs1:	tst.b	(a0)
		beq	CopyStrs_OUT
		move.b	(a0)+,(a1)+
		sub.l	#1,d0
		beq	CopyStrs_OUT
		bra	CopyStrs1
CopyStrs_OUT:	clr.b	(a1)
		rts

ShutDown:	move.l	RDArgs1,d1
		beq	ShutDown4000
		lib	Dos,FreeArgs

ShutDown4000:

ShutDown3000:	move.l	ARexxPort,a1			;Remove possible
		cmp.l	#$00,a1				;ports from lists
		beq	ShutDown1000			;and then delete
		lib	Exec,RemPort			;the ports

		move.l	ARexxPort,a0
		lib	Exec,DeleteMsgPort

ShutDown1000:	closlib	Commodities
		closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;Error etc. messages

NoDos:		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoCommodities:	lea.l	NoCommoText1,a0
		bsr	Printer
		bra	ShutDown

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

NoMsgPort:	lea.l	NoMsgPortText1,a0
		bsr	Printer
		bra	ShutDown

NoMsgPort2:	lea.l	NoMsgPortText2,a0
		bsr	Printer
		bra	ShutDown

Break:		lea.l	BreakText1,a0
		bsr	Printer
		bra	ShutDown

Printer:	printa	a0,_stdout
		rts


;Structures

OurTask:	dc.l	0
RDArgs1:	dc.l	0
ARexxPort:	dc.l	0
_stdout:	dc.l	0
_SysBase:	dc.l	0
_DOSBase:	dc.l	0
_CxBase:	dc.l	0

;Library stuff

		libnames

;Options

CLArray1:
PortPointer:	dc.l	ARexxPortName

;Other stuff, part I

IEvents:	dc.l	0

;Strings, error

BreakText1:	dc.b	"***Break: RexxInput",13,10,0
NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",13,10,0
NoMsgPortText2: dc.b	"ERROR: An ARexx port with the specified name already exists!",13,10,0
NoCommoText1:	dc.b	"ERROR: Couldn't open commodities.library",13,10,0


;Strings, names

CLTemplate1:	dc.b	"PORT",0
RIVersion:	dc.b	"$VER: RexxInput "
		PROGVERSION
		dc.b	" (c) Copyright Tomi Blinnikka 1993",0

;ARexx strings

ARexxPortName:	dc.b	"REXXINPUT",0

;Misc

RexxQuit:	dc.b	"QUIT",0

;Buffers

StringBuffer:	dcb.b	256,0


		END
