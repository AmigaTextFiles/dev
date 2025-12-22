*************************************************
*						*
*		 (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	29/12/1992			*
*						*
* BUGS:						*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	Parse,CODE

		openlib	Dos,NoDos

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		lea.l	FromFileText1,a0
		bsr	Printer
		move.l	FromFile,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		lea.l	OptionText1,a0
		bsr	Printer
		tst.l	Option1
		bne	Check1
		lea.l	NotText1,a0
		bsr	Printer
Check1:		lea.l	SetText1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		bra	ShutDown

ShutDown:	move.l	RDArgs1,d1
		beq	ShutDown9000
		lib	Dos,FreeArgs
ShutDown9000:

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

Printer:	printa	a0
		rts


;Library stuff

		libnames

;Reservations

RDArgs1:	dc.l	0

;Options

CLArray1:
FromFile:	dc.l	0
Option1:	dc.l	0

;Strings, part I

CLTemplate1:	dc.b	"FROM/A,O=OPTION/S",0
VersionString:	dc.b	"$VER: Parser tester 0.01 (29.12.1992) (C)opyright Tomi Blinnikka 1992",0
FromFileText1:	dc.b	"Given filename is : ",0
OptionText1:	dc.b	"Option was : ",0
NotText1:	dc.b	"NOT ",0
SetText1:	dc.b	"SET",0
CRLFText1:	dc.b	13,10,0
		ds.w	0


;Other stuff, part II



		end
