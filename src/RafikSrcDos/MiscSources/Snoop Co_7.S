;TOSPJPKPJPKPPPLCDFHPPPLCDFHPPPLCDFHPPPLCDFHPPPLCDFHPPPLCDFHPPPLCDFHPPPLCDFHAGCLOLEO

;Snoop Coô
;by Rafik
;ostatnie poprawki 96.04.13 g21:11

_OpenLib=	-408

VERSION:	MACRO
	dc.b	'0.40'
	ENDM

EXEC:	MACRO
	move.l	4.w,a6
	ENDM
CALL:	MACRO
	jsr	_\1(a6)
	ENDM
CALLB:	MACRO
	MOVEL	\2
	CALL	\1
	ENDM
JUMP:	MACRO
	jmp	_\1(a6)
	ENDM
MOVEL:	MACRO
	movea.l	\1Base(pc),a6
	ENDM
TSTL:	MACRO
	tst.l	\1Base
	ENDM
CLEARD:	MACRO
	moveq	#0,\1
	ENDM
CLEARA:	MACRO
	sub.l	\1,\1
	ENDM

SAVE=1

		IFNE	SAVE
;		AUTO	wo\

StartUp:
		movem.l	d0/a0,-(sp)

		lea	DosName,a1
		CLEARD	D0
		EXEC
		CALL	OpenLibrary
		move.l	d0,DosBase

		CLEARA	a1
		CALL	FindTask

		CLEARA	a1
		move.l	d0,a2
		tst.l	pr_CLI(a2)
		bne.s	MakeMultitasking

		lea	pr_MSGPORT(a2),a0
		CALL	WaitPort
		lea	pr_MSGPORT(a2),a0
		CALL	GetMsg
		move.l	d0,a1

		move.l	sm_NUMARGS(a1),d0
		move.l	sm_ARGLIST(a1),a0

		moveq	#-1,d1
		addq.l	#8,SP	;.w ?

		movem.l	a1/a6,-(sp)
		jsr	StartSource
		movem.l	(sp)+,a1/a6

		move.l	a1,d1
		beq.s	StartUpQuit
		move.l	d0,d2
		CALL	ReplyMsg
		move.l	d2,d0
StartUpQuit:
		rts
MakeMultitasking:
		lea	ProcName(pc),A1
		move.l	a1,d1
		CLEARD	d2
		lea	StartUp(pc),a5
		move.l	-4(a5),d3
		move.l	d2,-4(a5)
		move.l	#3500,d4
		move.l	DosBase,a6
		CALL	CreateProc
		movem.l	(sp)+,d0/a0

		CLEARD	D1
		CLEARD	D0
		rts

MesLenght:	dc.l	0
MesAdr:		dc.l	0

		dc.b	'$VER: '
ProcName:	dc.b	'Snoop Cos v'
		VERSION
		dc.b	0
;tu wrzuciê twój program...

		ENDIF

			AUTO	?EndSource-StartSource\

*******************************************************************************

			SECTION	"Snoop Coô",CODE

*******************************************************************************
StartSource:

	bsr	OpenWindow
	move.l	d0,handle
	beq.s	error

	bsr	Init

	move.l	#text,d2
	moveq	#textend-text,d3
	bsr	write_text
	
.readd
	move.l	handle(pc),d1
	moveq	#-1,d2
	CALL	WaitForChar
	tst.l	d0
	beq.s	.readd

	move.l	handle(pc),d1
	move.l	#Buffor,d2
	moveq	#10,d3		;lenght
	jsr	_Read(a6)
	tst.l	d0
	bne.s	.read
.wait
	moveq	#2,d1
	CALL	Delay
	bra.s	.readd

.read
	move.w	#$fff,$dff180
	cmp.b	#'e',Buffor
	bne.s	.wait
;test:	btst #2,$dff016		;Wait until right mousebutton
;	bne test		;  is pressed
	
End
	bsr	Remove

;close_window:
	move.l	handle(pc),d1
	MOVEL	Dos
	CALL	Close
error:
	moveq	#0,d0
	rts

write_text:
	MOVEL	Dos
	move.l	handle(pc),d1
	CALL	Write
	rts

*******************************************************************************
					Init:
*******************************************************************************
	lea	IntuiName(pc),a1
	moveq	#0,d0
	move.l	4.w,a6
	CALL	OpenLib
	move.l	d0,IntuiBase

	move.l	4.w,a6
	move.l	_DoIO+2(a6),OldMy
	move.l	#My,_DoIO+2(a6)

	rts

;	lea	Table(pc),a0
;Table:
;	dc.b	5	;text lenght
;'Lock	'		;first text
;1			;input text in d1
;0,0			;end 0,0 if 0 w d0
			;then fail


*******************************************************************************
				Remove:
*******************************************************************************
		move.l	4.w,a6
		move.l	OldMy(pc),-456+2(a6)
		rts

EndText:movem.l	d0-a6,-(sp)
	tst.l	d0
	beq.s	.2
	move.l	#OKTxt,d2
	bra.s	.1
.2	move.l	#FailTxt,d2
.1	moveq	#7,d3
	bsr	write_text

	movem.l	(sp)+,d0-a6
	rts

FileOpened
	tst.b	StupidDos
	beq.s	.1
	move.w	OldOpenFile(pc),d0
	and.l	#$ff,d0
	ext.w	d0
	ext.l	d0
	move.l	#EndText,-(sp)
	move.l	RealOpen(pc),-(sp)
	bra.s	.2

.1	move.l	OldOpenFile(pc),-(sp)
.2
	movem.l	d0-a6,-(sp)
	move.l	#OpenTxt,d2
	moveq	#5,d3
	bsr	write_text
	movem.l	(sp)+,d0-a6

	movem.l	d0-a6,-(sp)
	move.l	d1,d2
	move.l	d2,a0
	bsr.w	Count

	bsr	write_text
	movem.l	(sp)+,d0-a6
	rts

*******************************************************************************
*Wrzutka nowego doio!!!!!
*******************************************************************************
My:
	movem.l	d0-a6,-(sp)

	move.l	a1,d0
	lea	NowyText+1,a0
	bsr	PrzeliczHex
;	bra.s	WriteHex

	sub.l	a1,a1
	EXEC
	CALL	FindTask
	move.l	d0,a1
	move.l	10(a1),d2
	move.l	d2,a1
	moveq	#0,d3
.add
	addq.l	#1,d3	;dîugoôê tekstu
	tst.b	(a1)+
	bne.s	.add
	bsr	write_text	;nazwa taska

WriteHex:
	move.l	#Text,d2
	moveq	#4+10,d3
	bsr	write_text


	moveq	#4,d1
.1
	move.w	#-1,d7
.loop
	move.w	#$fff,$dff180
	move.w	#$f0f,$dff180
	move.w	#$f4f,$dff180
	dbf	d7,.loop
	dbf	d1,.1

	movem.l	(sp)+,d0-a6
	move.l	OldMy(pc),-(sp)
	rts

Text:		dc.b	'    '
NowyText:	dc.b	'$12345678',$a

*******************************************
Przelicz_Dzies:
;wescie:
;	a0 gdze wrzucac liczbe w asci
;	d0 liczba
;used registers d0-d2 a0-a1
;by R.The.K./RDST

;	lea	dzes,a1

L_00	moveq	#0,d2
	move.l	(a1)+,d1
	beq.s	nomore_tears
.1
	cmp.l	d1,d0
	blt.s	l_02		;Gdy mniejszy
	sub.l	d1,d0
	addq.b	#1,d2
	bra.s	.1
l_02
	add.b	#'0',d2
	move.b	d2,(a0)+	;Wrzutka liczby
	bra.s	L_00
nomore_tears
	move.b	#0,(a0)+
	rts

dzes	;tabela dziesiatek (wykopanie divsa
Lduzo
	dc.l	10000000000
	dc.l	1000000000
	dc.l	100000000
	dc.l	10000000
	dc.l	1000000
	dc.l	100000
L99999:	dc.l	10000
L9999:	dc.l	1000
L999:	dc.l	100
L99:	dc.l	10,1,0,0


PrzeliczHex:
	moveq	#8-1,d4
.przelicz
	rol.l	#4,d0
	move.l	d0,d1
	and.l	#$f,d1
	move.b	.table(pc,d1.w),(a0)+
	dbf	d4,.przelicz
	rts

.table:
	dc.b	'0123456789abcdef'


Locked:
	tst.b	StupidDos2
	beq.s	.1
	move.w	OldLock(pc),d0
	and.l	#$ff,d0
	ext.w	d0
	ext.l	d0
	move.l	#EndText,-(sp)
	move.l	RealLock(pc),-(sp)
	bra.s	.2

.1	move.l	OldLock(pc),-(sp)
.2	movem.l	d0-a6,-(sp)
	move.l	#LockTxt,d2
	moveq	#5,d3
	bsr	write_text
	movem.l	(sp)+,d0-a6

	movem.l	d0-a6,-(sp)
	move.l	d1,d2
	move.l	d2,a0
	bsr.s	Count

	bsr	write_text
	movem.l	(sp)+,d0-a6
	rts

WindowOpened:
	move.l	OldOpenWindow(pc),-(sp)
	movem.l	d0-a6,-(sp)
	move.l	26(a0),d2	;title
	beq.s	NoName
	bra.s	tak

ScreenOpened:
	move.l	OldOpenScreen(pc),-(sp)
	movem.l	d0-a6,-(sp)

	move.l	20(a0),d2	;title
	beq.s	NoName
tak
	move.l	d2,a0
	bsr.s	Count

	bsr	write_text

	move.l	#Enter,d2
	moveq	#1,d3
	bsr	write_text

NoName
	movem.l	(sp)+,d0-a6
	rts
Count:
	moveq	#0,d3
.count
	addq.l	#1,d3
	tst.b	(a0)+
	bne.s	.count
	rts



OpenWindow:
	move.l	#WindowDef,d1
	move.l	#1005,d2

	MOVEL	Dos
	JUMP	Open

*******************************************************************************
DosBase:	dc.l	0
IntuiBase:	dc.l	0
handle:		dc.l	0
OldMy:		dc.l	0

WindowDef:	dc.b 'con:0/0/640/100/Snoop Cos v'
		VERSION
		dc.b	0

DosName: 	dc.b "dos.library",0
IntuiName:	dc.b	'intuition.library',0
OldOpenScreen:	dc.l	0
OldOpenWindow:	dc.l	0
OldOpenFile:	dc.l	0
		dc.w	0
RealOpen:	dc.l	0
OldLock:	dc.l	0
		dc.w	0
RealLock:	dc.l	0

text:	dc.b	'Snoop Cos Ready to work...'
Enter:	dc.b	$a
textend:
LockTxt:	dc.b	'Lock	'
OpenTxt:	dc.b	'Open	'
OKTxt:		dc.b	'		 OK ',$a
FailTxt:	dc.b	'		Fail',$a
StupidDos:	ds.b	1
StupidDos2:	ds.b	1
Buffor:		ds.b	100


EndSource:


			;PROCESS
pr_MSGPORT		EQU		$5C
sm_ARGLIST		EQU		$24
sm_NUMARGS		EQU		$1C
pr_CLI			equ		172

			;DOS
_Open	EQU	-30
_Close	EQU	-36
_Read	EQU	-42
_Write	EQU	-48
_Seek	EQU	-66
_Lock	EQU	-84
_UnLock	EQU	-90
_Examine	EQU	-102
_ExNext	EQU	-108
_CurrentDir	EQU	-126
_CreateProc	EQU	-138
_LoadSeg	EQU	-150
_UnLoadSeg	EQU	-156
_Delay	EQU	-198
_WaitForChar	equ	-204
MODE_OLDFILE	EQU	1005
OFFSET_END	equ	1
OFFSET_BEGINNING	equ	-1

		;EXEC

_SetFunction	equ	-420
_AllocMem	EQU	-198
_FreeMem	EQU	-210
_AvailMem	EQU	-216
_FindTask	EQU	-294
_GetMsg	EQU	-372
_ReplyMsg	EQU	-378
_WaitPort	EQU	-384
_OldOpenLibrary	EQU	-408
_CloseLibrary	EQU	-414
_OpenLibrary	EQU	-552

	;INTUI
_OpenScreen	equ	-198
_OpenWindow	equ	-204


_DoIO	EQU	-456
