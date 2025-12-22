;
; ### Blank v0.00b ###
;
; -   Created 880802 by JM
; - Recreated 910603 by TB
;
; Bugs: None born.
;
;
; Edited:
;
; - 880802 by JM -> v1.0	- kommentit
; - 880803 by JM -> v1.5	- lisatty CTRL+C
; - 910603 by TB -> v0.00a	- added checks for windows opening etc.
; - 910604 by TB -> v0.00b	- added checks for 2.0
; - 910723 by TB -> v0.00c	- changed write function for 2.0
;

		include	"jmplibs.i"		omia makroja
		include	"hards.i"		hardisrekistereja
		include "XREF:exec.xref"	maarittelee Execin rutiinit
		include "XREF:dos.xref"		maarittelee Dossin rutiinit
		include	"XREF:intuition.xref"
		include	"XREF:gfx.xref"

_LVOOpenScrTList:	equ 	-$264
_LVOOpenWinTList: 	equ	-$25e

keyboard	equ	$bfec01		nappaimiston rekisteri
mouse0		equ	$dff00a		hiiren 0 rekisteri
mouse1		equ	$dff00c		hiiren 1 rekisteri
diskctrl	equ	$bfd100		levyaseman ohjausrekisteri

nappis		equ	0		offset-arvot omaan taulukkoon
hiiri0		equ	2
hiiri1		equ	4
levyas		equ	6
laskuri		equ	8
raja		equ	12
dmasailo	equ	16

SAMMUTUS	equ	%0000000110100000 pysayttaa Copperin, Spritet ja nayton

INTB_VERTB	equ	5		keskeytystyyppi Vertical Blanking

CTRL_C		equ	12		bitti, joka ilmaisee CTRL+C:n painamisen

Start		push	d2-d7/a2-a6
		move.l	a0,a2
		openlib	Dos,cleanup
		lib	Dos,Output
		move.l	d0,_stdout
		cmp.b	#"?",(a2)
		beq	CommandLineHelp

		move.l	a2,a0
		bsr	ota_luku
		mulu.w	#50,d0
		bvs	viive_asetettu
		beq	viive_asetettu
		move.l	d0,IData+raja

viive_asetettu	openlib	Intuition,cleanup
		openlib	Gfx,cleanup

		print	<"Blank version 0.01b",13,10>,_stdout

;test for 2.0

		move.l	_IntuitionBase(pc),a6
		move.w	$14(a6),d0
		cmp.w	#36,d0
		bcc	StartPatch20
		move.w	#0,Kick
		jmp	Patch1

StartPatch20:	print	<"Using KickStart 2.0 - Patching new Open(Window/Screen)TagList and Write vectors",13,10>,_stdout
		move.w	#1,Kick
		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenScrTList,a0
		lea.l	OpScrTL(pc),a2
		move.l	a2,d0
		lib	Exec,SetFunction
		move.l	d0,OldOpScrTL

		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenWinTList,a0
		lea.l	OpWinTL(pc),a2
		move.l	a2,d0
		lib	Exec,SetFunction
		move.l	d0,OldOpWinTL

		move.l	_DosBase(pc),a1
		move.l	#_LVOWrite,a0
		lea.l	NewWrite(pc),a2
		move.l	a2,d0
		lib	Exec,SetFunction
		move.l	d0,OldWrite

Patch1:		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenScreen,a0
		lea.l	OpScr(pc),a2
		move.l	a2,d0
		lib	Exec,SetFunction
		move.l	d0,OldOpScr

		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenWindow,a0
		lea.l	OpWin(pc),a2
		move.l	a2,d0
		lib	Exec,SetFunction
		move.l	d0,OldOpWin

		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOPrintIText,a0
		lea.l	PrIT(pc),a2
		move.l	a2,d0
		lib	Exec,SetFunction
		move.l	d0,OldPrIT

;		move.l	_IntuitionBase(pc),a1
;		move.l	#_LVODisplayBeep,a0
;		lea.l	DisB(pc),a2
;		move.l	a2,d0
;		lib	Exec,SetFunction
;		move.l	d0,OldDisB

		move.l	_GfxBase(pc),a1
		move.l	#_LVOText,a0
		lea.l	NewText(pc),a2
		move.l	a2,d0
		lib	Exec,SetFunction
		move.l	d0,OldText

		moveq.l	#INTB_VERTB,d0
		lea	keskstruc(pc),a1
		lib	Exec,AddIntServer

		moveq.l	#0,d0
		bset.l	#CTRL_C,d0
		lib	Exec,Wait

cleanup		print	<"***Break, Blank terminating",13,10>,_stdout
		moveq.l	#INTB_VERTB,d0
		lea	keskstruc(pc),a1
		lib	Exec,RemIntServer

		cmp.w	#1,Kick
		bne	cleanup1
		move.l	OldOpScrTL(pc),a0
		move.l	a0,d0
		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenScrTList,a0
		lib	Exec,SetFunction

		move.l	OldOpWinTL(pc),a0
		move.l	a0,d0
		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenWinTList,a0
		lib	Exec,SetFunction

		move.l	OldWrite(pc),a0
		move.l	a0,d0
		move.l	_DosBase(pc),a1
		move.l	#_LVOWrite,a0
		lib	Exec,SetFunction

cleanup1	move.l	OldOpScr(pc),a0
		move.l	a0,d0
		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenScreen,a0
		lib	Exec,SetFunction

		move.l	OldOpWin(pc),a0
		move.l	a0,d0
		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOOpenWindow,a0
		lib	Exec,SetFunction

		move.l	OldPrIT(pc),a0
		move.l	a0,d0
		move.l	_IntuitionBase(pc),a1
		move.l	#_LVOPrintIText,a0
		lib	Exec,SetFunction

;		move.l	OldDisB(pc),a0
;		move.l	a0,d0
;		move.l	_IntuitionBase(pc),a1
;		move.l	#_LVODisplayBeep,a0
;		lib	Exec,SetFunction

		move.l	OldText(pc),a0
		move.l	a0,d0
		move.l	_GfxBase(pc),a1
		move.l	#_LVOText,a0
		lib	Exec,SetFunction

		closlib	Intuition
		closlib	Gfx
cleanup_out	closlib	Dos
		pull	d2-d7/a2-a6
		rts

ota_luku	moveq.l	#0,d0
		moveq.l	#0,d1
ota_seuraava	move.b	(a0)+,d1
		cmp.b	#'0',d1
		bcs	otettu
		cmp.b	#'9',d1
		bhi	otettu
		sub.b	#'0',d1
		mulu.w	#10,d0
		add.l	d1,d0
		bra	ota_seuraava
otettu		rts

introutine	push	d4-d7
		lea	$dff000,a0
		move.b	keyboard,d4
		move.w	mouse0,d5
		move.w	mouse1,d6
		move.b	diskctrl,d7

		cmp.w	#$ff,Change
		beq	touhuaa

		cmp.w	hiiri0(a1),d5
		bne	touhuaa

		cmp.b	levyas(a1),d7
		bne	touhuaa

		cmp.b	nappis(a1),d4
		bne	touhuaa

		cmp.w	hiiri1(a1),d6
		bne	touhuaa

ei_puuhaa	move.l	laskuri(a1),d0
		bmi	nukkuu_jo

		addq.l	#1,d0
		cmp.l	raja(a1),d0
		bcs	ei_nukkumaan

nukkumaan	bset.l	#31,d0
		move.l	d0,laskuri(a1)
		move.w	DMACONR(a0),dmasailo(a1)
		move.w	#SAMMUTUS,DMACON(a0)
		clr.w	COLOR0(a0)

nukkuu_jo	pull	d4-d7
		moveq.l	#0,d0
		rts

ei_nukkumaan	move.l	d0,laskuri(a1)
		pull	d4-d7
		moveq.l	#0,d0
		rts

touhuaa		move.b	d4,nappis(a1)
		move.w	d5,hiiri0(a1)
		move.w	d6,hiiri1(a1)
		move.b	d7,levyas(a1)
		move.w	#$00,Change
		tst.l	laskuri(a1)
		bpl	ei_herata

heratys		move.w	dmasailo(a1),d0
		bset.l	#15,d0
		move.w	d0,DMACON(a0)

ei_herata	clr.l	laskuri(a1)
		pull	d4-d7
		moveq.l	#1,d0
		rts

; Here starts the library changes

OpWin:		move.w	#$ff,Change
		move.l	OldOpWin(pc),a1
		jmp	(a1)

OpScr:		move.w	#$ff,Change
		move.l	OldOpScr(pc),a1
		jmp	(a1)

OpScrTL:	move.w	#$ff,Change
		push	a2
		move.l	OldOpScrTL(pc),a2
		jsr	(a2)
		pull	a2
		rts

OpWinTL:	move.w	#$ff,Change
		push	a2
		move.l	OldOpWinTL(pc),a2
		jsr	(a2)
		pull	a2
		rts

PrIT:		move.w	#$ff,Change
		push	a2
		move.l	OldPrIT(pc),a2
		jsr	(a2)
		pull	a2
		rts

;DisB:		move.w	#$ff,Change
;		move.l	OldDisB(pc),a1
;		jmp	(a1)

NewText:	move.w	#$ff,Change
		push	a2
		move.l	OldText(pc),a2
		jsr	(a2)
		pull	a2
		rts

NewWrite:	move.w	#$ff,Change
		move.l	OldWrite(pc),a1
		jmp	(a1)

		ds.l	0
OldOpWin:	dc.l	0
OldOpScr:	dc.l	0
OldPrIT:	dc.l	0
OldOpScrTL:	dc.l	0
OldOpWinTL:	dc.l	0
;OldDisB:	dc.l	0
OldText:	dc.l	0
OldWrite:	dc.l	0
Change:		dc.w	0
Kick:		dc.w	0
_stdout:	dc.l	0

		ds.l	0
keskstruc	dc.l	0		;ln_Succ
		dc.l	0		;ln_Pred
		dc.b	2		;ln_Type = NT_INTERRUPT
		dc.b	-1		;ln_Pri
		dc.l	intname		;ln_Name
		dc.l	IData		;data
		dc.l	introutine	;server

IData		dc.w	0		vanha nappiksen arvo
		dc.w	0		vanha hiiren 0 arvo
		dc.w	0		vanha hiiren 1 arvo
		dc.w	0		vanha levyaseman arvo
		dc.l	0		odotettu aika
		dc.l	3000		maksimi odotusaika
		dc.w	0		dma-sailo
		dc.w	0		varalla

intname		dc.b	'Blank_Interrupt',0	keskeytyksen nimi

		libnames			kirjastojen osoittimet, nimet

		INCLUDE	"LWF:Blank/BlCommandLineHelp.i"

		end

