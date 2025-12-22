
;---;  string.r  ;-------------------------------------------------------------
*
*	****	string support routines    ****
*
*	Author		Daniel Weber
*	Version		1.10
*	Last Revision	23.02.95
*	Identifier	str_defined
*       Prefix		str_	(String)
*				 ¯¯¯
*	Functions	StrCmp, StrCmpSpc, ARexxStrCmp, GetStrLen, StrLen,
*			StrCopy, StrNCopy, StrNCmp, SStrCopy, SStrNCopy
*
;------------------------------------------------------------------------------

;------------------
	ifnd	str_defined
str_defined	SET	1

;------------------
str_oldbase	equ __BASE
	base	str_base
str_base:

;------------------
	opt	sto,o+,ow-,q+,qw-		;all optimisations on

;------------------


;------------------------------------------------------------------------------
*
* StrCmp	Compare Zero Ending Strings (case independant)
*
* INPUT:	A0	first string
*		A1	second string
*
* RESULT:	D0.l	0: equal	-: position of first difference  (CCR)
*
;------------------------------------------------------------------------------
	IFD	xxx_StrCmp
xxx_str_tablist	SET	1

StrCmp:
	movem.l	d1-d2/a0-a1/a5,-(a7)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	lea	str_base(pc),a5
.loop:	addq.l	#1,d0
	move.b	(a0)+,d1
	beq.s	.ok
	move.b	(a1)+,d2
	beq.s	.false
	move.b	str_tablist(a5,d1.w),d1		;make it case independant
	cmp.b	str_tablist(a5,d2.w),d1
	beq.s	.loop
.false:	tst.l	d0
	movem.l	(a7)+,d1-d2/a0-a1/a5
	rts

.ok:	tst.b	(a1)
	bne.s	.false
.right:	moveq	#0,d0				;set return value
	bra.s	.false

	ENDC

;------------------------------------------------------------------------------
*
* StrNCmp	Compare Zero Ending Strings (case independant), with length N
*
* INPUT:	D0	max. length for strings
*			A0	first string
*			A1	second string
*
* RESULT:	D0	0: equal	-: position of first difference  (CCR)
*
;------------------------------------------------------------------------------
	IFD	xxx_StrNCmp
xxx_str_tablist	SET	1

StrNCmp:
	movem.l	d1-d3/a0-a1/a5,-(a7)
	moveq	#0,d3
	moveq	#0,d1
	moveq	#0,d2
	exg	d3,d0
	lea	str_base(pc),a5
.loop:	addq.l	#1,d0
	subq.l	#1,d3
	bmi.s	.right
	move.b	(a0)+,d1
	beq.s	.ok
	move.b	(a1)+,d2
	beq.s	.false
	move.b	str_tablist(a5,d1.w),d1		;make it case independant
	cmp.b	str_tablist(a5,d2.w),d1
	beq.s	.loop
.false:	tst.l	d0
	movem.l	(a7)+,d1-d3/a0-a1/a5
	rts

.ok:	tst.b	(a1)
	bne.s	.false
.right:	moveq	#0,d0				;set return value
	bra.s	.false

	ENDC

;------------------------------------------------------------------------------
*
* StrCmpSpc	Compare Space Ending Strings (case independant)
*
* INPUT:	A0	first string
*		A1	second string
*
* RESULT:	D0	0: equal	-: position of first difference
*
;------------------------------------------------------------------------------
	IFD	xxx_StrCmpSpc
xxx_str_tablist	SET	1

StrCmpSpc:
	movem.l	d1-d2/a0-a1/a5,-(a7)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	lea	str_base(pc),a5
.loop:	addq.l	#1,d0
	move.b	(a0)+,d1
	move.b	(a1)+,d2
	move.b	str_tablist(a5,d1.w),d1		;make it case independant
	cmp.b	str_tablist(a5,d2.w),d1
	bne.s	.false
	cmp.b	#" ",d1
	bne.s	.loop
.right:	moveq	#0,d0				;set return value
.false:	movem.l	(a7)+,d1-d2/a0-a1/a5
	rts

	ENDC

;------------------------------------------------------------------------------
*
* ARexxStrCmp	Compare ARexx String (case independant)
*
* INPUT:	A0	source string    (zero ending)
*		A1	Argument string  (space or zero ending)
*
* RESULT:	D0	0: equal	-: position of first difference
*
;------------------------------------------------------------------------------
	IFD	xxx_ARexxStrCmp
xxx_str_tablist	SET	1

ARexxStrCmp:
	movem.l	d1-d3/a0-a1/a5,-(a7)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#" ",d3
	lea	str_base(pc),a5
.loop:	addq.l	#1,d0
	move.b	(a0)+,d1
	move.b	(a1)+,d2
	cmp.b	d3,d2
	beq.s	.ok
	move.b	str_tablist(a5,d1.w),d1		;make it case independant
	cmp.b	str_tablist(a5,d2.w),d1
	bne.s	.false
	tst.b	d1				;EOsource string?
	bne.s	.loop
.right:	moveq	#0,d0				;set return value
.false:	movem.l	(a7)+,d1-d3/a0-a1/a5
	rts

.ok:	tst.b	d1				;also EOsource???
	beq.s	.right
	bra.s	.false				;no! -> error

	ENDC


;------------------------------------------------------------------------------
*
* GetStrLen	Get length of a given zero ended string
* StrLen	varargs stub for GetStrLen
*
* INPUT:	A0	string
*
* RESULT:	D0	string length (excluding the zero byte)
*
;------------------------------------------------------------------------------
	IFD	xxx_StrLen
	NEED_	GetStrLen
StrLen:
	ENDC


	IFD	xxx_GetStrLen
GetStrLen:
	move.l	a0,-(a7)
	moveq	#-1,d0
\loop:	addq.l	#1,d0
	tst.b	(a0)+
	bne.s	\loop
2$:	move.l	(a7)+,a0
	rts

	ENDC


;------------------------------------------------------------------------------
*
* StrCopy	Copy zero-terminated string
*
* INPUT:	A0	source string
*		A1	target buffer
*
* RESULT:	registers A0-A1 affected!
*
;------------------------------------------------------------------------------
	IFD	xxx_StrCopy
StrCopy:
0$:	move.b	(a0)+,(a1)+
	bne.s	0$
	rts

	ENDC



;------------------------------------------------------------------------------
*
* StrNCopy	Copy zero-terminated string with a max. length of N
*
* INPUT:	D0	max number or bytes (word).
*		A0	source string
*		A1	target buffer
*
* RESULT:	registers D0/A0-A1 affected!
*
;------------------------------------------------------------------------------
	IFD	xxx_StrNCopy
StrNCopy:
	bra.s	1$
0$:	move.b	(a0)+,(a1)+
1$:	dbeq	d0,0$
	rts
	ENDC


;------------------------------------------------------------------------------
*
* SStrCopy	Copy zero-terminated string SAVELY
*
* INPUT:	A0	source string
*		A1	target buffer
*
* RESULT:	none
*
;------------------------------------------------------------------------------
	IFD	xxx_SStrCopy
SStrCopy:
	movem.l	a0/a1,-(a7)
0$:	move.b	(a0)+,(a1)+
	bne.s	0$
	movem.l	(a7)+,a0/a1
	rts

	ENDC



;------------------------------------------------------------------------------
*
* SStrNCopy	Copy zero-terminated string with a max. length of N SAVELY
*
* INPUT:	D0	max number or bytes (word).
*		A0	source string
*		A1	target buffer
*
* RESULT:	none
*
;------------------------------------------------------------------------------
	IFD	xxx_SStrNCopy
SStrNCopy:
	movem.l	a0/a1,-(a7)
	bra.s	1$
0$:	move.b	(a0)+,(a1)+
1$:	dbeq	d0,0$
	movem.l	(a7)+,a0/a1
	rts

	ENDC


;------------------------------------------------------------------------------
*
* Data area (easier access using a base register)
*
;------------------------------------------------------------------------------
	IFD	xxx_str_tablist

str_tablist:
	dc.b	0,1,2,3,4,5,6,7,8,9,$a,$b,$c,$d,$e,$f
	dc.b	$10,$11,$12,$13,$14,$15,$16,$17
	dc.b	$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
	dc.b	" !",$22,"#$%&'()*+,-./"
	dc.b	"0123456789:;<=>?"
	dc.b	"@ABCDEFGHIJKLMNO"
	dc.b	"PQRSTUVWXYZ[\]^_"
	dc.b	"`ABCDEFGHIJKLMNO"
	dc.b	"PQRSTUVWXYZ{|}~",$7F
	dc.b	$80,$81,$82,$83,$84,$85,$86,$87
	dc.b	$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
	dc.b	$90,$91,$92,$93,$94,$95,$96,$97
	dc.b	$98,$99,$9a,$9b,$9c,$9d,$9e,$9f
	dc.b	$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
	dc.b	$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af
	dc.b	$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7
	dc.b	$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
	dc.b	$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
	dc.b	$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
	dc.b	$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
	dc.b	$d8,$d9,$da,$db,$dc,$dd,$de,$df
	dc.b	$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7
	dc.b	$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
	dc.b	$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7
	dc.b	$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff

	ENDC
;--------------------------------------------------------------------
	base	str_oldbase

;------------------
	opt	rcl

;------------------
	endif

 end

