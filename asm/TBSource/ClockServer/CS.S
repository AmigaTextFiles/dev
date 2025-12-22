*************************************************
*						*
*		 (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	25/12/1992			*
*						*
* BUGS:						*
*						*
* Version 1.00	26/12/1992			*
*						*
* BUGS:	Not in the program itself...		*
*						*
* Version 1.01	26/12/1992			*
*						*
* BUGS:						*
*						*
* Version 1.02	26/12/1992			*
*						*
* Now makes a script and protects it		*
* accordingly.					*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"


nr_Name:	EQU	0
nr_FullName:	EQU	4
nr_Flags:	EQU	12
nr_Task:	EQU	16
nr_SignalNum:	EQU	20

NRF_SEND_SIGNAL	EQU	2

		section	CS,CODE

		move.l	a0,a4
		clr.b	-1(a0,d0.l)
		openlib	Dos,ShutDown_Out

		cmp.b	#'?',(a4)
		beq	CmdLineHelp
		cmp.w	#'-?',(a4)
		beq	CmdLineHelp
		cmp.w	#'-h',(a4)
		beq	CmdLineHelp
		cmp.b	#'h',(a4)
		beq	CmdLineHelp

;Set stuff for notification request

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask

		move.l	#-1,d0
		lib	Exec,AllocSignal
		move.b	d0,SigBit
		bmi	NoSigBit

StartMain:	bsr	DoNotify
		tst.l	d0
		beq	ShutDown

		clr.l	d0
		clr.l	d1
		move.b	SigBit,d1
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break

;		print	<"ClockServer: Received file notification!",13,10>	;DEBUG
;		print	<"Stopping notification.",13,10>			;DEBUG

		bsr	StopNotify

		lea.l	DateTime1,a0
		move.l	a0,d1
		lib	Dos,DateStamp

		lea.l	DateTime1,a0
		move.l	a0,d1
		lib	Dos,DateToStr
		tst.l	d0
		bne	SkipFail1
		lea.l	ConvFailText1,a0
		bsr	Printer
		bra	StartMain

SkipFail1:	lea.l	FileName1,a0
		move.l	a0,d1
		move.l	#1006,d2		;mode_newfile
		lib	Dos,Open
		move.l	d0,File1
		bne	SkipFail2
		lea.l	OpenFailText1,a0
		bsr	Printer
		bra	StartMain

SkipFail2:	bsr	FormatStr
		lea.l	OutputBuffer1,a1
		bsr	GetLength
		move.l	d0,d3
		move.l	File1,d1
		lea.l	OutputBuffer1,a0
		move.l	a0,d2
		lib	Dos,Write

		move.l	File1,d1
		lib	Dos,Close
		clr.l	File1


		lea.l	FileName1,a0
		move.l	a0,d1
		move.l	#%1000000,d2
		lib	Dos,SetProtection

		bra	StartMain

;Subroutines

FormatStr:	lea.l	OutputBuffer2,a2
		lea.l	DateStr1,a0
		lea.l	TimeStr1,a1
FormatStr1:	cmp.b	#$00,(a0)
		beq	FormatStr2
		move.b	(a0)+,(a2)+
		bra	FormatStr1
FormatStr2:	move.b	#' ',(a2)+
FormatStr2.1:	cmp.b	#$00,(a1)
		beq	FormatStr3
		move.b	(a1)+,(a2)+
		bra	FormatStr2.1
FormatStr3:	move.b	#13,(a2)+
		move.b	#10,(a2)+
		clr.b	(a2)+		;here so GetLength knows to stop
		rts

;Get length of text in given address
;
;Input a1 = Address of null terminated text string
;
;Result d0 = Length (not incl. NULL)

GetLength:	clr.l	d0
		cmp.l	#$00,a1		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d0
		tst.b	(a1)+
		bne	GetLength2
		sub.l	#1,d0
GetLength_OUT:	rts

DoNotify:	lea.l	NotifyReq1,a2
		move.l	#NRF_SEND_SIGNAL,nr_Flags(a2)
		move.l	OurTask,nr_Task(a2)		;Set task
		move.b	SigBit,nr_SignalNum(a2)		;Set signal
		lea.l	FileName1,a0
		move.l	a0,nr_Name(a2)			;Set filename
		move.l	a2,d1
		lib	Dos,StartNotify
		tst.l	d0
		beq	NotNotifying
		move.b	#1,UseNotify
		move.l	#-1,d0
		rts

StopNotify:	tst.b	UseNotify
		beq	StopNotify_OUT
		lea.l	NotifyReq1,a0
		move.l	a0,d1
		lib	Dos,EndNotify
		clr.b	UseNotify
StopNotify_OUT:	rts

ShutDown:	bsr	StopNotify

		move.l	File1,d1
		beq	ShutDown8000
		lib	Dos,Close

ShutDown8000:	clr.l	d0
		move.b	SigBit,d0
		bmi	ShutDown7000
		lib	Exec,FreeSignal

ShutDown7000:
ShutDown1000:	closlib	Dos
ShutDown_Out:	move.l	#RETURN_OK,d0
		rts

CmdLineHelp:	lea.l	UsageText1,a0
		bsr	Printer	
		bra	ShutDown

NoSigBit:	lea.l	NoSigBitText1,a0
		bsr	Printer	
		bra	ShutDown

NotNotifying:	lea.l	NoNotifyText1,a0
		bsr	Printer	
		clr.l	d0
		rts

Break:		lea.l	BreakText1,a0
		bsr	Printer
		bra	ShutDown

Printer:	printa	a0
		rts

;Structures & reservations

SigBit:		dc.b	-1
UseNotify:	dc.b	0
OurTask:	dc.l	0
File1:		dc.l	0

;Filenames and other dos related strings

FileName1:	dc.b	"T:CS_DateTime",0
CmdString1:	dc.b	"Date TO T:CS_DateTime",0

;Error strings etc...

NoSigBitText1:	dc.b	"ERROR: Couldn't allocate signal bit!",13,10,0
NoNotifyText1:	dc.b	"ERROR: Not getting notification on file!",13,10,0
ConvFailText1:	dc.b	"ERROR: Couldn't convert time/date!",13,10,0
OpenFailText1:	dc.b	"ERROR: Couldn't open file!",13,10,0
BreakText1:	dc.b	"***Break: ClockServer",13,10,0

;Information & other strings

		dc.b	"$VER: "
UsageText1:	dc.b	"ClockServer 1.02 (26.12.92). (C)opyright Tomi Blinnikka",13,10,13,10
;		dc.b	13,10,"!!! BETA TESTER VERSION !!!",13,10,13,10,13,10

		dc.b	"USAGE: ClockServer [?]",13,10,13,10
		dc.b	"       Where: [?] gives this text",13,10,13,10
		dc.b	"Use CTRL-C to stop program.",13,10,13,10
		dc.b	"Gives time/date to networked machine(s).",13,10
		dc.b	"See docs for more information.",13,10,0

		ds.l	0

;library stuff

		libnames

;Dos lib stuff

NotifyReq1:	dcb.b	48,0

;Buffers

DateTime1:	dc.l	0		;days past 1978
		dc.l	0		;mins past 00:00
		dc.l	0		;ticks past min

		dc.b	0		;format = DOS (dd-mmm-yy)
		dc.b	0		;do not substitute etc.

		dc.l	0		;no day, please
		dc.l	DateStr1	;pointer
		dc.l	TimeStr1	;pointer


DateStr1:	dcb.b	16,0
TimeStr1:	dcb.b	16,0
OutputBuffer1:	dc.b	"Date "
OutputBuffer2:	dcb.b	32,0

		END

