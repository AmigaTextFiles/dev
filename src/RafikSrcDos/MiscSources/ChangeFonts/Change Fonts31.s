;TOSPJPKPJPKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGAFAGAG
;
;Change Fonts...
;its change system topaz 80 to pearl pl
;Coded by Rafik/RDST
;

	incdir	"hd1:include/lvo/"
	include	'dos_lib.i'
	include	'exec_lib.i'

_LVOOpenFonts:	equ	-72


CALL:	MACRO
	jsr	_LVO\1(a6)
	ENDM
EXEC:	MACRO
	move.l	4.w,a6
	ENDM

Start:
	lea	DiskFontName(pc),a1
	EXEC
	CALL	OldOpenLibrary
	move.l	d0,DiskFontBase
	beq.s	NoFont
	move.l	d0,a6

	lea	TxtAttr(pc),a0		; Adres struktury fontow
	CALL	OpenDiskFont
	move.l	d0,TopazBase
	beq.w	NoFonts

	lea	PearlATTR(pc),a0
_LVOOpenDiskFont:	equ	-30
	CALL	OpenDiskFont
	move.l	d0,a1
	beq.s	NoFont
	move.l	TopazBase(pc),a2

; a1 a0 bazy fontów
	lea	$22(a1),a1
	lea	$22(a2),a2
	move.l	(a1)+,(a2)+	;34Char data
	move.w	(a1)+,(a2)+	;38Modulo
	move.l	(a1)+,(a2)+	;40CharLoc
	move.l	(a1)+,(a2)+	;CharSpace
	move.l	(a1)+,(a2)+	;CharKern

NoFont:
	move.l	4.w,a6
	move.l	DiskFontBase(pc),a1
	CALL	CloseLibrary		; Zamknij Gfx

	bsr.s	DosLibrary
	moveq	#0,d0
;	move.l	OutputHandle(pc),d1
	move.l	#Installed,d2
	moveq	#EIns-Installed,d3	;dîugoôê textu
	jsr	_LVOWrite(a5)		;write

	move.l	a5,a1
	CALL	CloseLibrary

Error
	moveq	#0,d0
	rts		;END

DosLibrary:
;write text
	lea	DosName(pc),a1
	CALL	OldOpenLibrary
	move.l	d0,a5
	beq.s	Error

	jsr	_LVOOutput(a5)
	move.l	d0,d1
	rts


NoFonts:
	move.l	4.w,a6
	move.l	DiskFontBase(pc),a1
	CALL	CloseLibrary		; Zamknij Gfx

	bsr.s	DosLibrary

	moveq	#0,d0
;	move.l	OutputHandle(pc),d1
	move.l	#ErrorTXT,d2
	moveq	#ErrorTXT-EIns,d3	;dîugoôê textu
	jsr	_LVOWrite(a5)		;write

	move.l	a5,a1
	CALL	CloseLibrary

	moveq	#0,d0
	rts
TopazBase:	dc.l	0
DiskFontBase:	dc.l	0
TxtAttr:	DC.L	FntName
		DC.W	8
		DC.W	1
FntName:	DC.B	'topaz.font',0

		even
PearlATTR:	DC.L	.Name
		DC.W	8
		DC.W	1
.Name:		DC.B	'pearl.font',0

		dc.b	'$VER: '
ErrorTXT:
		dc.b	'Error Instaling '
Installed:
		dc.b	'Pearl Pl Fonts v1.1',$a
		dc.b	'  Rafik/RDST 1995',$a
EIns:
DosName:	dc.b	'dos.library',0
DiskFontName:	dc.b	'diskfont.library',0
