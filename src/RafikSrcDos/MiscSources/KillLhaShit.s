;TOSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;
;del lha
;rtk/rdst....
;kasuje ômieci w lha takie jak reqtools, powerpacker itd itd...

VERSION:	MACRO
	dc.b	'v1.0'
		ENDM

SAVE=0
		Addwatch	a0,H
		Addwatch	a0,A
		addwatch	Name,A
;		addbpoint	potem

	IFNE	SAVE
	AUTO	wo\
	ELSE

		lea	Test,a0
		moveq	#1,d0
		bra.s	potem
Test:	dc.b	'"dh0:archive/fish/fish_852.lha"',0
		even
potem:

	ENDIF




		incdir	dh1:sources/
		include	macra.s

Start:

		tst.l	d0
		beq.w	End
		lea	Name,a1
		move.b	(a0)+,d1
		cmp.b	#'"',d1
		bne.s	.1
		st	cudzyslow
		bra.s	.copy
.1
		move.b	d1,(a1)+
.copy
		move.b	(a0)+,d1
		beq.s	.test
		cmp.b	#$a,d1
		bne.s	.1
		clr.b	(a1)+
.test
		move.b	cudzyslow(pc),d0
		beq.s	.2
		clr.b	-1(a1)	;ostatni cudzysîow
.2

		lea	DosName(pc),a1
		move.l	4.w,a6
		jsr	-408(a6)	;oldOpen Library
		move.l	d0,a6

		
		move.l	#Name,d1
		move.l	#MODE_OLDFILE,d2
		CALL	Open
		move.l	d0,FHandle
		beq.s	End

b:
MainLoop:
		bsr	Read

		moveq	#0,d5	;dîugoôê
		lea	Buffor,a0
		move.b	10(a0),d5
		lsl.w	#8,d5
		move.b	9(a0),d5	;mam nadzieje...:)
		swap	d5
		move.b	8(a0),d5	;1bajt ??xx
		lsl.w	#8,d5
		move.b	7(a0),d5	;2bajt xx?? dîugoôê prawie..

		add.l	#$10,d5		;+structurka


		lea	21(a0),a0
		moveq	#0,d7
		move.b	(a0)+,d7	;dîugoôê nazwy..
		lea	-1(a0,d7.w),a1	;koniec nazwy...
		move.l	d7,d6
.szukaj:
		cmp.b	#':',(a1)
		beq.s	.nazwa
		cmp.b	#'\',(a1)
		beq.s	.nazwa
		subq.l	#1,a1
		subq.w	#1,d6
		bne.s	.szukaj
.nazwa:		;a wîaôciwie jej koïcówka
		addq.l	#1,a1
;tera powinno nastâpiê przeszukanie nazw zgodnie z tekstem..


CloseFile:
		move.l	FHandle(pc),d1
		CALL	Close


End:		moveq	#0,d0
		rts

Read:
		move.l	FHandle(pc),d1
		move.l	#Buffor,d2
		move.l	#300,d3		;z max nazwâ
		JUMP	Read


FHandle:	dc.l	0
cudzyslow:	dc.b	0
DosName:	dc.b	'dos.library',0

Name:		ds.b	400

		even
Buffor:		ds.b	100		;buffor...

ToDelete:	dc.b	'powerpacker.library',0
		dc.b	'reqtools.library',0
		dc.b	0,0

DeleteTable:	ds.b	3000		;miejsce na kasacje plików






_Open	EQU	-30
_Close	EQU	-36
_Read	EQU	-42
_Write	EQU	-48
_Seek	EQU	-66
MODE_OLDFILE	EQU	1005
OFFSET_END	equ	1
OFFSET_BEGINNING	equ	-1


;		move.l	d0,d1
;		moveq	#0,d2
;		moveq	#OFFSET_END,d3

;		move.l	FHandle,d1
;		moveq	#0,d2
;		moveq	#OFFSET_BEGINNING,d3

