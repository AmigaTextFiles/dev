; FILE: Source:CauseFailPro.ASM          REV: 24 --- System failures with some register
; History
;  14     1st release. Has still some bugs, though.
;

; CauseFailPro --- Written by Harry Sintonen, Public Domain
;
; I strongly suggest that you don't try to learn proper assembler programming
; from this source. ;-D
;

Main	move.l	sp,SpSave
	movem.l	d0/a0,-(sp)

	move.l	#$d0,d0
	move.l	#$d1,d1
	move.l	#$d2,d2
	move.l	#$d3,d3
	move.l	#$d4,d4
	move.l	#$d5,d5
	move.l	#$d6,d6
	move.l	#$d7,d7

Ptr1	move.l	#$a0,a0
	move.l	#$a1,a1
	move.l	#$a2,a2
	move.l	#$a3,a3
	move.l	#$a4,a4
	move.l	#$a5,a5
	move.l	#$a6,a6

	movem.l	d0-d4,-(sp)

	pea	Ptr1(pc)
	lea	Ptr2(pc),a5
	movem.l	a0-a1/a5,-(sp)

Ptr2	divu	#0,d0
;	trap	#$B
;	trap	#$A
;	trap	#$B
;	trap	#$E
	trapt
	chk	#-1,d0
	illegal
	dc.w	$ABCD
	dc.w	$FEDC
	movec	cacr,d0
	move.l	SpSave,sp
	rts


	SECTION	turistiBuSSi,BSS

SpSave	ds.l	1
