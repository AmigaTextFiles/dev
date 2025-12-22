;
;Dir a rzczej jego próba by Rafik/RDST
;Gdynia 1993


	AUTO	?es-ss\

SS
	cmp.b	#$a,(a0)	;No directories ?
	beq.s	Show_DF0

	lea	FileName,a1
	subq.w	#2,d0
nazwa
	move.b	(a0)+,(a1)+
	dbf	d0,nazwa

Show_DF0
	move.l	4.w,a6
	moveq	#0,d0
	lea	DosName(pc),a1
	jsr	-552(a6)	;Open Library
	move.l	d0,a5
	move.l	d0,a1
	jsr	-414(a6)	;Close Library

	jsr	-60(a5)		;OutPut
	move.l	d0,OutputHandle	;handle

;	bra.w	Print


;lock
	move.l	#FileName,d1
	moveq	#-2,d2
	jsr	-84(a5)	;lock
	move.l	d0,LockSave
	beq	DirError

;	move.l	d0,d1
;	move.l	#FileInfo,d2
;	jsr	-104(a5)	;info

;	lea	DyskName+20(pc),a0
;	move.l	

;Examine

	move.l	LockSave(pc),d1
	move.l	#FileInfo,d2
	jsr	-102(a5) ;examine
	tst.l	d0
	beq	DirError
	bra.s	Print
LOOP:
	btst	#6,$bfe001
	bne.s	ss2
RMB
	btst	#2,$dff016
	beq	EndIt
ss2
	moveq	#0,d0

	move.l	LockSave(pc),d1
	move.l	#FileInfo,d2
;	jsr	-108(a5)	;exnext
;	tst.l	d0
;	beq	DirError	;error lub end ?
Print:
	moveq	#30-1,d0
	lea	FileInfo+8,a0
	lea	Text,a1
lb_00
	move.b	(a0)+,(a1)+
	beq.s	fillrest
	dbf	d0,lb_00
	bra.s	lb_11
fillrest
	subq.l	#1,a1
lb_10
	move.b	#' ',(a1)+
	dbf	d0,lb_10
lb_11


	tst.l	FileInfo+4	;to dir or not to dir
	bmi.s	File
;dir
	lea	Text+30,a0
	lea	Dir_TXT(pc),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	bra.s	printname
Dir_TXT:
	dc.b '     (dir)',$a,0

File:
	move.l	FileInfo+124,d0
	lea	Text+30,a0
	move.l	#'    ',(a0)+
	bsr.s	Przelicz_Dzies

printname:

	moveq	#0,d0
	move.l	OutputHandle(pc),d1
	move.l	#Text,d2
	moveq	#41,d3		;dîugoôê textu
	jsr	-48(a5)		;write

	bra	LOOP
Przelicz_Dzies:
;wescie:
;	a0 gdze wrzucac liczbe w asci
;	d0 liczba
;used registers d0-d2 a0-a1
;

	lea	Dzes(pc),a1	;tabela dziesiatek (wykopanie divsa
	moveq	#0,d2
	move.b	d2,First
L_00
	move.l	(a1)+,d1
	beq.s	nomore_tears
l_01
	cmp.l	d1,d0
	blt.s	l_02		;Gdy mniejszy
	sub.l	d1,d0
	addq.b	#1,d2
	bra.s	L_01
l_02
	tst.b	First
	bne.s	Show
	tst.b	d2
	bne.s	show1
	move.b	#' ',d2		;bez pierwszych zer
	bra.s	Space
show1
	st	First
Show
	add.b	#'0',d2
Space
	move.b	d2,(a0)+	;Wrzutka liczby
	moveq	#0,d2
	bra.s	L_00
nomore_tears
	move.b	#$a,(a0)+
	rts

DirError:
	jsr	-132(a6)	;IO ERROR
	cmp.w	#232,d0	;Error no more entries
	beq.s	EndIt
Error:
	move.w	#$f00,$df180
EndIt:
	moveq	#0,d0
	rts


dzes	;tabela dziesiatek (wykopanie divsa
 dc.l 100000,10000,1000,100,10,1,0,0

LockSave	dc.l	0
OutputHandle:	dc.l	0
	even
First:	dc.b	0

	ds.b	50

DosName		dc.b 'dos.library',0


ES
	Section	Info,BSS
FileInfo:
	ds.l	260
FileName:
	ds.b	50
Text:
	ds.b	41
