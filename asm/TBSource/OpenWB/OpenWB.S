*************************************************
*						*
*	       (C)opyright  1991-92		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	28/07/1991			*
*						*
* BUGS:	Version string missing.			*
*						*
* Version 0.02	27/05/1992			*
*						*
* BUGS:	What are they?				*
*						*
*************************************************
	

	INCLUDE	"INCLUDES:JMPLibs.i"
	INCLUDE	"INCLUDES:exec/types.i"
	INCLUDE	"INCLUDES:intuition/intuition.i"
	INCLUDE	"INCLUDES:libraries/dos.i"

	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	OpenWB,CODE

		push	d2-d7/a2-a6
		move.l	a0,a4
		openlib	Dos,ShutDown_Out

		cmp.b	#'?',(a4)
		beq	CmdLineHelp
		cmp.w	#'-?',(a4)
		beq	CmdLineHelp
		cmp.b	#'h',(a4)
		beq	CmdLineHelp
		cmp.w	#'-h',(a4)
		beq	CmdLineHelp
	
		openlib	Intuition,NoIntuition
		cmp.w	#'-c',(a4)
		beq	DoClose
		cmp.w	#'-C',(a4)
		beq	DoClose
		lib	Intuition,OpenWorkBench
		bra	ShutDown
DoClose:	lib	Intuition,CloseWorkBench

ShutDown:	closlib	Intuition
		closlib	Dos
		pull	d2-d7/a2-a6
		move.l	#RETURN_OK,d0
		rts
ShutDown_Out:	move.l	#RETURN_FAIL,d0
		pull	d2-d7/a2-a6
		rts

Printer:	printa	a0
		rts

NoIntuition:	lea.l	NoIntText1,a0
		bsr	Printer
		bra	ShutDown

CmdLineHelp:	lea.l	UsageText1,a0
		bsr	Printer
		bra	ShutDown


		dc.b	"$VER: "
UsageText1:	dc.b	"OpenWB 0.02 (8.10.92). (C)opyright Tomi Blinnikka",13,10,13,10
		dc.b	"USAGE: OpenWB [-c]",13,10,13,10
		dc.b	"Where: [-c] closes the Workbench screen",13,10,13,10,0

NoIntText1:	dc.b	"ERROR: Couldn't open intuition.library!",13,10,0

;library stuff

		libnames

		END

