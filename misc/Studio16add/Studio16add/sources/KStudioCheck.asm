*>b:KStudioCheck

	*«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*
	*   Copyright © 1997 by Kenneth "Kenny" Nilsen.  E-Mail: kenny@bgnett.no		      *
	*   Source viewed in 800x600 with mallx.font (11) in CED				      *
	*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
	*
	*   Name
	*	KStudioCheck 2
	*
	*   Function
	*	Count number of AD516/AD1012 cards installed
	*
	*   Created	: 03.12.97
	*   Changes	: 
	*««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*


		Incdir	inc:

		include	lvo/exec_lib.i
		include	lvo/dos_lib.i
		include	lvo/expansion_lib.i

		include	digital.macs
		include	libraries/configvars.i

		Incdir	""

*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
LibBase	macro
	move.l	\1basX(pc),a6
	endm
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Start	move.l	$4.w,a6

; -- open libs

	lea	DosName(pc),a1
	moveq	#37,d0
	Call	OpenLibrary		;open dos.library
	move.l	d0,DosbasX
	beq	.exit

	lea	ExpName(pc),a1
	moveq	#37,d0
	Call	OpenLibrary		;open expansion.library
	move.l	d0,ExpansionbasX
	beq	.exit

; -- check hardware

	LibBase	expansion
	lea	Number516(pc),a5
	moveq	#2,d7
	bsr	CheckAD			;check AD516
	lea	2(a5),a5
	subq.l	#1,d7
	bsr	CheckAD			;check AD1012

; -- show info to user

	LibBase	dos
	Call	Output
	move.l	d0,d1
	beq	.exit			;no default IO was available
	move.l	#String,d2
	move.l	#Number516,d3
	Call	VFPrintF		;format and write to StdIO

; -- exit and cleanup

.exit	move.l	$4.w,a6

	move.l	DosbasX(pc),d0
	beq	.noDos
	move.l	d0,a1
	Call	CloseLibrary

.noDos	move.l	ExpansionbasX(pc),d0
	beq	.noExp
	move.l	d0,a1
	Call	CloseLibrary

.noExp	tst.w	Numberuse
	beq	.noUse
	move.b	#5,Warn+3
.noUse	move.l	Warn(pc),d0
	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
CheckAD	moveq	#0,d6		;lastBoard
.loop	move.l	d7,d1
	move.l	d6,a0
	move.l	#2127,d0	;Sunrize
	Call	FindConfigDev	;find a card
	move.l	d0,d6
	beq	.exit		;no card, exit

	clr.b	Warn+3		;we have a card
	add.w	#1,(a5)		;counter for this card

	move.l	d0,a0
	tst.l	cd_driver(a0)	;check if in use
	beq	.loop
	add.b	#1,NumberUse+1	;counter for active card(s)
	bra	.loop

.exit	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Warn		dc.l	5

Number516	dc.w	0
Number1012	dc.w	0
NumberUse	dc.w	0

DosbasX		dc.l	0
ExpansionbasX	dc.l	0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
String		dc.b	27,"[1m%d AD516",27,"[0m and ",27,"[1m%d AD1012",27,"[0m installed. %d in use.",10,0

		dc.b	"$VER: KStudioCheck 2.0 (03.12.97) by Kenneth 'Kenny' Nilsen",10,0

DosName		dc.b	"dos.library",0
ExpName		dc.b	"expansion.library",0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
