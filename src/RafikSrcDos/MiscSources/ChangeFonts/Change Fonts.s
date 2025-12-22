ùúùúÿ<¤Ÿÿ<¤Ÿÿ<¤Ÿÿ<¤Ÿÿ<¤Ÿÿ<¤Ÿÿ<¤Ÿÿ<¤Ÿÿ<¤Ÿ;Change Fonts...
;its change system topaz 80 to pearl pl
;Coded by R.The.K./RDST

	incdir	"TRASH'EM_ALL:include/"
	include	'Dos/dos_lib.i'
	include	'Exec/exec_lib.i'


CALL:	MACRO
	jsr	_LVO\1(a6)
	ENDM

Start
	move.l	a7,Stock

;InitFonts:

	move.l	4.w,a6
	move.l	#2616,d0
	moveq	#1,d1
	CALL	AllocMem
	move.l	d0,a4	;gdzie kopnâê fonty
	beq.s	Error

	lea	Gfxname(pc),a1
	moveq	#0,d0
	CALL	OpenLibrary		; Otworz Gfx

	move.l	d0,a1

	move.l	a1,-(sp)

	move.l	a1,a6
	lea	TxtAttr(pc),a0		; Adres struktury fontow
	jsr	-72(a6)			; Otworz fonty
	beq.s	NoFonts

	move.l	d0,a1
	lea	-50+$c0(a4),a4	;lepiej ale nie do koïca
	move.l	a4,34(a1)	;maîa zmiana adresu...
	lea	50-$c0(a4),a4
				;pieprzyê dos !!
;	move.l	34(a1),a4		; Adres fontow
;	move.w	38(a1),FontMod		; Modulo fontow
	jsr	-78(a6)			; Zamknij fonty


	move.l	(sp)+,a1
	move.l	4.w,a6
	CALL	CloseLibrary		; Zamknij Gfx

	lea	Pearl(pc),a0
	move.l	#2616-1,d0
.loop	move.b	(a0)+,(a4)+
	dbf	d0,.loop

	bsr.s	DosLibrary
	moveq	#0,d0
;	move.l	OutputHandle(pc),d1
	move.l	#Installed,d2
	moveq	#EIns-Installed,d3	;dîugoôê textu
	jsr	_LVOWrite(a5)		;write

	move.l	a5,a1
	CALL	CloseLibrary

Error
	move.l	Stock(pc),a7
	moveq	#0,d0
	rts		;END

DosLibrary:
;write text

	lea	DosName(pc),a1
	moveq	#0,d0
	CALL	OpenLibrary
	move.l	d0,a5
	beq.s	Error

	jsr	_LVOOutPut(a5)
	move.l	d0,d1

	rts


NoFonts:
	move.l	(sp)+,a1
	move.l	4.w,a6
	CALL	CloseLibrary		; Zamknij Gfx

	move.l	#2616,d0	;Size
	move.l	a4,a1		;Where
	CALL	FreeMem

	bsr.s	DosLibrary

	moveq	#0,d0
;	move.l	OutputHandle(pc),d1
	move.l	#EIns,d2
	moveq	#ErI-EIns,d3	;dîugoôê textu
	jsr	_LVOWrite(a5)		;write

	move.l	a5,a1
	CALL	CloseLibrary

	moveq	#0,d0
	rts

Installed:
	dc.b	'Pearl Pl Fonts Installed',$a
	dc.b	'    R.The.K/RDST 1993',$a
EIns:
	dc.b	'Error Instaling Pearl Pl fonts',$a
	dc.b	"    Can't open topaz.font",$a
ErI:

Gfxname:	dc.b 'graphics.library',0,0

TxtAttr:	DC.L	FNTNAME
		DC.W	8	;size ?? 0
		DC.B	0
		DC.B	0
		dc.w	8	;size ?? nic
FntName:	DC.B	'topaz.font',0,0

DosName:
	dc.b 'dos.library',0

Stock:
	dc.l	0

Pearl:
	incdir	"df0:"

	incbin	'8.pearl'



