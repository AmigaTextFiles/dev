ùúùúÿ÷PWÿ÷PWÿ÷PWÿ÷PWÿ÷PWÿ÷PWÿ÷PWÿ÷PWÿ÷PW;open library...
;coded by R.The.Cz./RDST/SCT
;a matura juû za dni pare..
;i wieûa moûe teû, a Ania ma zîy humor..

	SECTION	OPEN,CODE

	movem.l	d0/a0,-(sp)

	lea	DosName(pc),a1
	bsr	OpenLibrary
	move.l	d0,a5

	jsr	-60(a5)		;OutPut
	move.l	d0,OutputHandle	;handle

	movem.l	(sp)+,d0/a0

	tst.l	d0
	beq.w	END
	bra.s	NiePlus
Plus:	addq.l	#1,a0
	subq.l	#1,d0
	beq.w	END
NiePlus:
	cmp.b	#$a,(a0)
	beq.w	END
	cmp.b	#' ',(a0)
	beq.s	Plus
	lea	FullName,a1
	moveq	#0,d1
CopyName:
	subq.l	#1,d0
	beq.s	OpenLib
	addq.b	#1,d1
	move.b	(a0)+,(a1)+
	cmp.b	#' ',(a0)
	beq.s	OpenLib
	cmp.b	#$a,(a0)
	beq.s	OpenLib
	cmp.b	#'.',(a0)
	bne.s	CopyName
OpenLib:
	move.b	d1,TextLenght
	moveq	#LibE-Lib-1,d1
	add.b	d1,TextLenght
	lea	Lib(pc),a2
.loop	move.b	(a2)+,(a1)+
	dbf	d1,.loop

	move.l	a1,TextEnd

	movem.l	d0/a0,-(sp)

	moveq	#0,d3
	move.b	TextLenght,d3	;dîugoôê textu
	move.l	#FullName,d2
	bsr.s	Write

	lea	FullName,a1
	bsr.s	OpenLibrary

	moveq	#8,d3	;Opened, failed txt
	tst.l	d0
	bne.s	OK
	move.l	#Failed,d2
	bsr.s	Write
	bra.s	Cont
OK
	move.l	#Opened,d2
	bsr.s	Write

Cont:	movem.l	(sp)+,d0/a0

	tst.l	d0
	bne.w	NiePlus

END:	moveq	#0,d0
	rts
OpenLibrary:
	moveq	#0,d0
	move.l	4.w,a6
	jmp	-552(a6)	;Open Library

Write:	moveq	#0,d0
	move.l	OutputHandle,d1
	jmp	-48(a5)		;write


Opened:	dc.b	'	Opened',$a
Failed:	dc.b	'	Failed',$a
DosName:	dc.b	'dos'
Lib:	dc.b	'.library',0
LibE:
 dc.b	' $VER:  Open Library v1.3 coded by R.The.Cz./RDST/SCT Gdynia 1994 ',0

	SECTION	DATA,BSS
TextEnd:	ds.l	1
OutputHandle:	ds.l	1
FullName:	ds.b	50
TextLenght:	ds.b 1

