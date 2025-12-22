*************************************************
*						*
*		 (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	27/05/1992			*
*						*
* BUGS:	Version string was %&* 'd up		*
*						*
* Version 0.02	04/07/1992			*
*						*
* BUGS:	What ?					*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	Debug,CODE

		move.l	a0,a4
		openlib	Dos,ShutDown_Out

		lea.l	AuthorText1,a0
		bsr	Printer

		cmp.b	#"?",(a4)
		beq	CmdLineHelp
		cmp.w	#'-?',(a4)
		beq	CmdLineHelp
		cmp.w	#'-h',(a4)
		beq	CmdLineHelp

		lea.l	EnterText1,a0
		bsr	Printer

		lib	Exec,Debug

		lea.l	ReturnText1,a0
		bsr	Printer
		
ShutDown:	closlib	Dos
ShutDown_Out:	move.l	#RETURN_OK,d0
		rts

CmdLineHelp:	lea.l	UsageText1,a0
		bsr	Printer	
		bra	ShutDown

Printer:	printa	a0
		rts

;Structures and reservations

		dc.b	"$VER: "
AuthorText1:	dc.b	"Debug 0.02 (4.7.92) by Tomi Blinnikka",13,10,13,10
;		dc.b	13,10,"!!! BETA TESTER VERSION !!!",13,10,13,10,13,10
		dc.b	0

UsageText1:	dc.b	"USAGE: Debug [?]",13,10,13,10
		dc.b	"       Where: [?] gives this text.",13,10,13,10
		dc.b	"This program makes the computer enter the debug "
		dc.b	"state (ROM-wack).",13,10
		dc.b	"See docs for more information.",13,10,0

EnterText1:	dc.b	"==> Entered debug state <==",13,10
		dc.b	13,10,"Type 'resume' from terminal to return",13,10,0
ReturnText1:	dc.b	13,10,"<== Returned from debug ==>",13,10,0

		ds.l	0

;library stuff

		libnames

		END

