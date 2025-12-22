*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		  Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 1.00	31/05/1993			*
*						*
* BUGS:						*
*						*
*************************************************
	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"


BUFSIZE:	EQU	#2000

		section	AGS,CODE

		openlib	Dos,NoDos

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		lib	Dos,Output
		move.l	d0,_stdout

		move.l	FromFile,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,InputFile
		beq	File_ERR1

		move.l	ToFile,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,OutputFile
		beq	File_ERR1

		move.l	InputFile,d1
		lea.l	Buffer1,a0
		move.l	a0,d2
		move.l	#BUFSIZE,d3
		lib	Dos,Read
		move.l	d0,d3		;Get amount read
		bsr	Strip


		bra	ShutDown

;Input d3 = amount to do

Strip:		lea.l	Buffer1,a0
		move.l	a0,a1
		add.l	d3,a1

		cmp.b	#'@',(a0)
		bne	Strip3

		add.l	#1,a0		;skip '@'

		cmp.b	#'{',(a0)
		bne	Strip2
		move.w	#1,Status

		add.l	#1,a0		;skip '{'
		bra	Strip3

Strip2:		sub.l	#1,a0		;go back one step (print '@')

Strip3:		cmp.b	#'}',(a0)
		bne	Strip4

		tst.w	Status
		beq	Strip4

		clr.w	Status
		add.l	#1,a0		;skip '}'

Strip4:		tst.w	Status
		beq	Strip8

		cmp.b	#'{',(a0)
		bne	Strip6

		add.l	#1,a0		;Skip '{'
		move.w	#2,Status

Strip6:		cmp.b	#'}',(a0)
		bne	Strip7

Strip7:

Strip8:

		cmp.l	a0,a1
;		beq	Strip_OUT

Strip_OUT:	rts


File_ERR1:	bsr	PrintDosFault
		bra	ShutDown


ShutDown:	move.l	RDArgs1,d1
		beq	ShutDown9000
		lib	Dos,FreeArgs

ShutDown9000:	move.l	InputFile,d1
		beq	ShutDown8900
		lib	Dos,Close
ShutDown8900:	move.l	OutputFile,d1
		beq	ShutDown8800
		lib	Dos,Close
ShutDown8800:


ShutDown1000:	closlib	Dos
		move.l	#RETURN_OK,d0
		rts

NoDos:		move.l	#RETURN_FAIL,d0
		rts

NoRDArgs:	bsr	PrintDosFault
		bra	ShutDown

PrintDosFault:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		rts

Printer:	printa	a0,_stdout
		rts

;Library stuff

		libnames

;Reservations

RDArgs1:	dc.l	0

;Options

CLArray1:
FromFile:	dc.l	0
ToFile:		dc.l	0

;Files

InputFile:	dc.l	0
OutputFile:	dc.l	0
_stdout:	dc.l	0

;Other stuff

Status:		dc.w	0		;0=normal text, 1=in {}

;Strings, part I

CLTemplate1:	dc.b	"FROM/A,TO/A",0
VersionString:	dc.b	"$VER: AGStrip 1.00 (31.05.93) (C)opyright Tomi Blinnikka 1993",0


;Strings, part II

		ds.l	0


;Other stuff, part II


Buffer1:	dcb.b	#BUFSIZE,0


		end
