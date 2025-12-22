*************************************************
*						*
*		 (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	04/07/1992			*
*						*
* BUGS:	None.					*
*						*
* Version 0.02	11/07/1992			*
*						*
* Added delay. Added informing TTYs. Added	*
* -q(uiet) option				*
*						*
* BUGS:	-q didn't work...			*
*						*
* Version 0.03	26/07/1992			*
*						*
* Version 0.04	28/07/1992			*
*						*
* Added CTRL_C check.				*
*						*
* Version 0.05	28/12/1992			*
*						*
* Added quick option.				*
*						*
* Version 1.00	30/12/1992			*
*						*
* CBM guidelines in parser. 			*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	Reset,CODE

		move.l	a0,a4
		clr.b	-1(a0,d0.l)
		openlib	Dos,NoDos

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		tst.l	DevPointer
		beq	Start1

		clr.l	d4

WriteLoop:	move.l	DevPointer,a0
		move.l	d4,d3
		mulu.w	#4,d3
		add.l	d3,a0

		move.l	(a0),a0

		cmp.l	#$00,a0		;if pointer is NULL
		beq	Start1		;we don't have a string

		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	Start1

		move.l	d0,d5
		lea.l	ResetText1,a0
		move.l	a0,d2
		bsr	GetLength		;loads d3 with length
		lib	Dos,Write

		move.l	d5,d1
		lib	Dos,Close

		add.l	#1,d4
		bra	WriteLoop

Start1:		tst.l	Immediate
		beq	Wait

		lea.l	ResetText2,a0
		bsr	Printer
		bra	SkipWait

Wait:		lea.l	ResetText1,a0
		bsr	Printer

		move.l	#5*50,d1
		lib	Dos,Delay

SkipWait:	clr.l	d0
		bset.l	#SIGBREAKB_CTRL_C,d1	;check for CTRL_C
		lib	Dos,CheckSignal
		btst.l	#SIGBREAKB_CTRL_C,d0
		beq	DoReset

		lea.l	BreakText1,a0
		bsr	Printer
		bra	ShutDown

DoReset:	lib	Exec,ColdReboot
		
ShutDown:	move.l	RDArgs1,d1
		beq	ShutDown1000
		lib	Dos,FreeArgs

ShutDown1000:	closlib	Dos
		move.l	#RETURN_OK,d0
		rts

NoDos:		move.l	#RETURN_FAIL,d0
		rts

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

Printer:	tst.l	Quiet
		bne	Printer1
		printa	a0
Printer1:	rts

;Get length of text in given address
;
;Input a0 = Address of null terminated text string
;
;Result d3 = Length

GetLength:	push	a0
		clr.l	d3
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d3
		tst.b	(a0)+
		bne	GetLength2
		sub.l	#1,d3		;don't include NULL
GetLength_OUT:	pull	a0
		rts

;Structures and reservations

VersionString:	dc.b	"$VER: Reset 1.00 (30.12.92) (C)opyright Tomi Blinnikka",0
CLTemplate1:	dc.b	"Q=QUIET/S,I=IMMEDIATE/S,DEVS=DEVICES/M",0

ResetText1:	dc.b	7,13,10,"WARNING! System shutdown begins in 5 seconds!",13,10
		dc.b	"Please logon again in a few minutes.",13,10,0
ResetText2:	dc.b	7,13,10,"WARNING! System shutdown!",13,10
		dc.b	"Please logon again in a few minutes.",13,10,0
BreakText1:	dc.b	"***Break: Reset",13,10,0
		ds.l	0

;library stuff

		libnames

;Options

RDArgs1:	dc.l	0

CLArray1:
Quiet:		dc.l	0		;0=Print texts, 1=Be quiet
Immediate:	dc.l	0		;0=Wait N secs, 1=Do not wait
DevPointer:	dc.l	0		;Pointer to devices string

;buffers

Buf1:		dcb.b	10,0
Buf2:		dcb.b	10,0
Buf3:		dcb.b	10,0
Buf4:		dcb.b	10,0
Buf5:		dcb.b	10,0
Buf6:		dcb.b	10,0
Buf7:		dcb.b	10,0
Buf8:		dcb.b	10,0
Buf9:		dcb.b	10,0
Buf10:		dcb.b	10,0
Buf11:		dcb.b	10,0

		END
