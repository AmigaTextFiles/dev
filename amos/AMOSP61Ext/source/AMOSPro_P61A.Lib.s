* P61a Extension V1.2.
* Written by Chris Hodges.
* Last changes: Thu 24-Apr-97 23:06:13

	opt	c-,o+,w-

fade  = 1	;0 = Normal, NO master volume control possible
		;1 = Use master volume (P61_Master)

jump = 1	;0 = do NOT include position jump code (P61_SetPosition)
		;1 = Include

system = 1	;0 = killer
		;1 = friendly

CIA = 1		;0 = CIA disabled
		;1 = CIA enabled

exec = 1	;0 = ExecBase destroyed
		;1 = ExecBase valid

lev6 = 1	;0 = NonLev6
		;1 = Lev6 used

opt020 = 0	;0 = MC680x0 code
		;1 = MC68020+ or better

channels = 4	;amount of channels to be played

use = -1	;The Usecode


version	MACRO						;Version macro
	dc.b	"1.2 27-Aug-97"
	ENDM

debugvs	equ	0

ExtNb	equ	25-1					;Extension number 16
NumLabl	equ	17					;Number of Labels

English	equ	$FACE					;Any symbol can be used
							;but FACE is nicer :)
Deutsch	equ	$AFFE					;Same for this

Languag	equ	English					;Choose the language

	IncDir	"dh1:Assembler/includes"		;Set the includes
	Include	"Player61.i"
	Include	"AMOS/|AMOSPro_Includes.s"

	output	dh1:APSystem/AMOSPro_P61.Lib

debug	MACRO						;This is to debug
	IFEQ	debugvs-1				;if the switch is set to 1
	illegal
	ENDC
	ENDM
dload	MACRO						;Load the address
	move.l	ExtAdr+ExtNb*16(a5),\1			;of the data-space
	ENDM
L_Func	set	0
AddLabl	MACRO						;Macro for adding
	IFEQ	NARG-1					;functions
\1	equ	L_Func					;One or non argument
	ENDC
L\<L_Func>:
L_Func	set	L_Func+1
	IFEQ	debugvs-2				;If debug is 2 then
	illegal						;fill in a illegal.
	ENDC
	ENDM

LC	set	0
LS	MACRO						;Macro for the label-
LC0	set	LC					;length part.
LC	set	LC+1
	dc.w	(L\<LC>-L\<LC0>)/2
	ENDM

Start	dc.l	C_Tk-C_Off	;First, a pointer to the token list
	dc.l	C_Lib-C_Tk	;Then, a pointer to the first library function
	dc.l	C_Title-C_Lib	;Then to the title
	dc.l	C_End-C_Title	;From title to the end of the program

	dc.w	0		;A value of -1 forces the copy of the first library routine...

		rsreset					;Extension Main Datazone
O_P61Base	rs.l	1
O_MusicBank	rs.l	1
O_MusicAddress	rs.l	1
O_SamBuffer	rs.l	1
O_MusicEnabled	rs.w	1
O_MusicPaused	rs.w	1
;O_TempBuffer	rs.b	80
;O_FileInfo	rs.b	260
O_SizeOf	rs.l	0

C_Off							;Automatic labellength
							;generation.
	REPT	NumLabl
	LS
	ENDR

C_Tk	dc.w 	1,0
	dc.b 	$80,-1

; Commands & Functions
;
; P61 Play bank[,pos]					Implemented
; P61 Stop						Implemented
; P61 Pause						Implemented
; P61 Continue						Implemented
; P61 Volume vol					Implemented
; P61 Cia Speed ciabpm					Implemented
; sig=P61 Signal					Implemented
; P61 Fade speed [To vol]				Implemented
; pos=P61 Pos						Implemented
;
; Now the real tokens...

	dc.w	L_P61Play1,-1
	dc.b	"!p61 pla","y"+$80,"I0",-2
	dc.w	L_P61Play2,-1
	dc.b	$80,"I0,0",-1
	dc.w	L_P61Stop,-1
	dc.b	"p61 sto","p"+$80,"I",-1
	dc.w	L_P61Pause,-1
	dc.b	"p61 paus","e"+$80,"I",-1
	dc.w	L_P61Continue,-1
	dc.b	"p61 continu","e"+$80,"I",-1
	dc.w	L_P61Volume,-1
	dc.b	"p61 volum","e"+$80,"I0",-1
	dc.w	L_P61CiaSpeed,-1
	dc.b	"p61 cia spee","d"+$80,"I0",-1
	dc.w	-1,L_P61Signal
	dc.b	"p61 signa","l"+$80,"0",-1
	dc.w	L_P61Fade1,-1
	dc.b	"!p61 fad","e"+$80,"I0",-2
	dc.w	L_P61Fade2,-1
	dc.b	$80,"I0t0",-1
	dc.w	-1,L_P61Pos
	dc.b	"p61 po","s"+$80,"0",-1
	dc.w 	0

C_Lib	include	"InitRou.lnk"				;Initroutines

	AddLabl	L_P61Play1				;P61a Play bank
	clr.l	-(a3)
	Rbra	L_P61Play2

	AddLabl	L_P61Play2				;P61a Play bank,pos
	Rbsr	L_P61Stop
	dload	a2
	move.l	(a3)+,d6
	move.l	(a3)+,d0
	move.l	d0,O_MusicBank(a2)
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a0
	move.l	a0,O_MusicAddress(a2)
	cmp.l	#"P61A",(a0)+
	beq.b	.modok
	subq.l	#4,a0
.modok	btst	#6,3(a0)
	beq.s	.nobuf
	move.l	4(a0),d0
	move.l	#$10003,d1
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOAllocVec(a6)
	move.l	(sp)+,a6
	move.l	d0,O_SamBuffer(a2)
	bne.s	.nobuf
	moveq.l	#0,d0
	Rbra	L_Custom
.nobuf	move.l	O_P61Base(a2),a0
	moveq.l	#64,d0
	move.w	d0,P61_Master-P61_motuuli(a0)
	move.w	d0,P61_FadeTo-P61_motuuli(a0)
	clr.w	P61_Pos-P61_motuuli(a0)
	clr.w	P61_Patt-P61_motuuli(a0)
	clr.w	P61_CRow-P61_motuuli(a0)
	move.w	#125,P61_Tempo-P61_motuuli(a0)
	move.w	#-1,P61_E8-P61_motuuli(a0)
	moveq.l	#0,d0
	move.l	O_MusicAddress(a2),a0
	sub.l	a1,a1
	move.l	O_SamBuffer(a2),a2
	moveq.l	#1,d1
	Rbsr	L_P61Func
	tst.l	d0
	beq.s	.noerr
	moveq.l	#1,d0
	Rbra	L_Custom
.noerr	dload	a2
	tst.l	d6
	ble.s	.nopos
	move.l	d6,d0
	moveq.l	#3,d1
	Rbsr	L_P61Func
.nopos	move.w	#1,O_MusicEnabled(a2)
;	clr.w	O_MusicPaused(a2)
	rts

	AddLabl	L_P61Stop				;P61a Stop
	dload	a2
	tst.w	O_MusicEnabled(a2)
	beq.s	.nooff
	moveq.l	#2,d1
	Rbsr	L_P61Func
.nooff	move.l	O_SamBuffer(a2),d0
	beq.s	.skip
	move.l	d0,a1
	clr.l	O_SamBuffer(a2)
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOFreeVec(a6)
	move.l	(sp)+,a6
.skip	rts

	AddLabl	L_P61Pause				;P61a Pause
	dload	a2
	tst.l	O_MusicPaused(a2)
	bne.s	.skip
	move.l	O_P61Base(a2),a0
	clr.w	P61_Play-P61_motuuli(a0)
	move.w	#1,O_MusicPaused(a2)
	lea	$DFF000,a0
	moveq	#0,d0
	move	d0,$a8(a0)
	move	d0,$b8(a0)
	move	d0,$c8(a0)
	move	d0,$d8(a0)
	move	#$f,$96(a0)
.skip	rts

	AddLabl	L_P61Continue				;P61a Continue
	dload	a2
	move.l	O_P61Base(a2),a0
	move.w	#1,P61_Play-P61_motuuli(a0)
	clr.w	O_MusicPaused(a2)
	rts

	AddLabl	L_P61Volume				;P61a Volume vol
	dload	a2
	move.l	(a3)+,d0
	bpl.s	.nozero
	moveq.l	#0,d0
.nozero	cmp.w	#64,d0
	blt.s	.no64
	moveq.l	#64,d0
.no64	move.l	O_P61Base(a2),a0
	move.w	d0,P61_Master-P61_motuuli(a0)
	move.w	d0,P61_FadeTo-P61_motuuli(a0)
	rts

	AddLabl	L_P61CiaSpeed				;P61a Cia Speed bpm
	dload	a2
	move.l	(a3)+,d0
	cmp.w	#32,d0
	bgt.s	.no32
	moveq.l	#32,d0
.no32	cmp.w	#255,d0
	blt.s	.no255
	move.w	#255,d0
.no255	move.l	O_P61Base(a2),a0
	move.l	P61_timer-P61_motuuli(a0),d1
	divu	d0,d1
	move	d1,P61_thi2-P61_motuuli(a0)
	sub	#$1f0*2,d1
	move	d1,P61_thi-P61_motuuli(a0)
	rts

	AddLabl	L_P61Signal				;sig=P61a Signal
	moveq.l	#0,d2
	dload	a2
	move.l	O_P61Base(a2),a0
	lea	P61_E8-P61_motuuli(a0),a0
	move.w	(a0),d3
	ext.l	d3
	move.w	#-1,(a0)
	rts

	AddLabl	L_P61Fade1
	clr.l	-(a3)
	Rbra	L_P61Fade2

	AddLabl	L_P61Fade2				;P61 Fade speed To vol
	dload	a2
	move.l	O_P61Base(a2),a0
	move.l	(a3)+,d0
	move.w	d0,P61_FadeTo-P61_motuuli(a0)
	move.l	(a3)+,d0
	Rblt	L_IFonc
	move.w	d0,P61_FadeSpeed-P61_motuuli(a0)
	move.w	d0,P61_FadeCount-P61_motuuli(a0)
	rts

	AddLabl	L_P61Pos				;pos=P61 Pos
	moveq.l	#0,d2
	dload	a2
	move.l	O_P61Base(a2),a0
	move.w	P61_Pos-P61_motuuli(a0),d3
	ext.l	d3
	rts

	AddLabl	L_P61Func
	movem.l	a2-a6/d2-d7,-(sp)
	lea	$DFF000,a6
	bsr.s	.func
	movem.l	(sp)+,a2-a6/d2-d7
	rts
.func	subq.w	#1,d1
	bmi.s	.initp					;0
	subq.w	#1,d1
	bmi.s	P61_Init				;1
	subq.w	#1,d1
	bmi	P61_End					;2
	subq.w	#1,d1
	bmi	P61_SetPosition				;3
	rts
.initp	lea	P61_motuuli(pc),a0
	dload	a2
	move.l	a0,O_P61Base(a2)
	rts

	RDATA
	include	"610.2_devpac3.asm"

	include	"Error.lnk"

	AddLabl	L_TheEnd				;Last label.

	IFNE	(L_TheEnd-NumLabl)			;Checks, if labels
;	PRINTT	"Incorrect amount of Labels: "		;are missing.
;	PRINTT	"Expected:"
;	PRINTT	_NumLabl
;	PRINTT	"Real:"
;	PRINTT	_L_TheEnd
	FAIL
	ENDC

C_Title	dc.b	"AMOSPro P61 extension V "
	version
	dc.b	0,"$VER: V"
	version
	dc.b	0
	even
C_End	dc.w	0
