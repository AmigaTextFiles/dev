;
;Catch Font by Rafik/rdst/sct
;gdynia 96.07.08

CALLB:	MACRO
	MOVEL	\2
	CALL	\1
	ENDM

VERSION	MACRO
	dc.b	'1.0'
	ENDM
;$VER: Rafik Catch Font v1.0 96.07.08


		incdir	hd1:sources/
		include	macra.s

_OldOpenLibrary:	equ	-408
_CloseLibrary:		equ	-414

Start:
		lea	DosName,a1
		EXEC
		CALL	OldOpenLibrary
		move.l	d0,DosBase

		lea	DiskName,a1
		CALL	OldOpenLibrary
		move.l	d0,DiskBase
		beq.w	NoDisk

		lea	ReqName,a1
		CALL	OldOpenLibrary
		move.l	d0,ReqBase
		beq.s	NoReq
		
		moveq	#RT_REQINFO,d0
		sub.l	a0,a0
		CALLB	rtAllocRequestA,Req
		move.l	d0,Requester
		beq.s	NoStartMemory

		moveq	#RT_FONTREQ,d0
		sub.l	a0,a0
		CALLB	rtAllocRequestA,Req
		move.l	d0,filereq
		beq.s	NoStartMemory1


_OpenDiskFont	EQU	-30
_SetFunction	EQU	-420
_Delay	EQU	-198

		EXEC
		ml	DiskBase,a1
		ml	#_OpenDiskFont,a0
		ml	#CatchOpen,d0
		CALL	SetFunction
		ml	d0,OldOpenFont



.1
	moveq	#50,d1
	CALLB	Delay,Dos

	btst	#7,$bfe001
	bne.s	.1


CloseEnd:
	MOVEL	Req
	move.l	filereq(pc),a1
	CALL	rtFreeRequest

NoStartMemory1:
	move.l	Requester(pc),a1
	CALL	rtFreeRequest
NoStartMemory:
	EXEC
	ml	ReqBase(pc),a1
	CALL	CloseLibrary
NoReq:
	EXEC
	ml	DiskBase(pc),a1
	CALL	CloseLibrary

NoDisk:
	EXEC
	ml	DosBase(pc),a1
	CALL	CloseLibrary

	moveq	#0,d0
	rts


CatchOpen:
	ml	a0,-(sp)	textattr
	ml	#CatchCheck,-(sp)
	ml	OldOpenFont,-(sp)
	rts



CatchCheck:
	tst.l	d0
	bne.s	SaFonty

	ml	(sp)+,TxtAttr

	PUSH	d0-a6

	ml	TxtAttr(pc),a0
	ml	(a0),String
	mw	4(a0),d0
	mw	d0,String+4+2
DoReqOK:
;a1 text
;a2 response
		lea	t_BrakFontow,a1
		lea	t_OK(pc),a2
		lea	String,a4
;		lea	AboutTags(pc),a0
		sub.l	a0,a0
		ml	Requester,a3
		MOVEL	Req
		CALL	rtEZRequestA


	POP	d0-a6

	rts






		sub.l	a0,a0	;tagi
		move.l	filereq(pc),a1	;struktóra zaallok prze allocreq
		lea	LoadTitle(pc),a3 ;text u góry

	CALLB	rtFontRequestA,Req
	tst.l	d0
	beq.w	.nicnowego

	POP	d0-a6
;podmianka fontów!!!
	move.l	filereq(pc),a0	;struktóra zaallok prze allocreq
	add.l	#16,a0
	ml	OldOpenFont,-(sp)
	rts

.nicnowego
	POP	d0-a6
	rts


SaFonty:
;Fonty zostaîy otwarte!!!
	addq.l	#4,sp
	rts

TxtAttr:
	dc.l	0


				Texty:

DiskName:	dc.b	'diskfont.library',0
DosName:	dc.b	'dos.library',0
ReqName:	dc.b	'reqtools.library',0
LoadTitle:	dc.b	'Catch Font '
		VERSION
	dc.b	'by (c) by Rafik 96',0
		dc.b	0

t_BrakFontow:	dc.b	'Brak Fontów: %s',$a
		dc.b	'o rozmiarze %ld',$a
		dc.b	0
t_OK:
		dc.b	'OK',0


				Dane:
	even

DiskBase:	dc.l	0
DosBase:	dc.l	0
ReqBase:	dc.l	0
filereq:	dc.l	0	;reqtools file req structure
Requester:	dc.l	0	;request
String:		dc.l	0,0

OldOpenFont:	dc.l	0


filename:	ds.b	100


RT_FILEREQ		EQU	0
RT_REQINFO		EQU	1
RT_FONTREQ		EQU	2



			;REQTOOLS
rtfl_Next	equ	0
rtfl_StrLen	equ	4
rtfl_Name	equ	8
rtfi_Dir	equ	16
_rtAllocRequestA	EQU	-30
_rtFreeRequest	EQU	-36
_rtFreeReqBuffer	EQU	-42
_rtChangeReqAttrA	EQU	-48
_rtFileRequestA	EQU	-54
_rtFreeFileList	equ	-60
_rtEZRequestA	EQU	-66
_rtGetStringA	EQU	-72
_rtGetLongA		EQU	-78
_rtFontRequestA	EQU	-96
_rtPaletteRequestA	EQU	-102
_rtScreenToFrontSafel EQU	-138
_rtSetReqPosition	EQU	-126
_rtLockWindow	equ	-156
_rtUnloc
