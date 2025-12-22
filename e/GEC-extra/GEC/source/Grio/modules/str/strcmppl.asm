

	xdef	strcmppl_str1_str2


strcmppl_str1_str2:

	movem.l	4(a7),a0/a1
	lea	table(pc),a2
	moveq	#0,d0
	moveq	#0,d1
loop:
	move.b	(a1)+,d0
	beq.s	quit
	move.b	(a0)+,d1
	move.b	0(a2,d0.w),d0
	sub.b	0(a2,d1.w),d0
	beq.s	loop
	ext.w	d0
	ext.l	d0
quit:
	rts


table:
	dc.b	$00,$01,$02,$03,$04,$05,$06,$07,$08,$09
	dc.b	$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13
	dc.b	$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d
	dc.b	$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27
	dc.b	$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31
	dc.b	$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b
	dc.b	$3c,$3d,$3e,$3f,$40,$41,$45,$47,$4b,$4d
	dc.b	$51,$53,$55,$57,$59,$5b,$5d,$61,$63,$67
	dc.b	$6b,$6d,$6f,$71,$75,$77,$79,$7b,$7d,$7f
	dc.b	$81,$87,$88,$89,$8a,$8b,$8c,$42,$46,$48
	dc.b	$4c,$4e,$52,$54,$56,$58,$5a,$5c,$5e,$62
	dc.b	$64,$68,$6c,$6e,$70,$72,$76,$78,$7a,$7c
	dc.b	$7e,$80,$82,$8d,$8e,$8f,$90,$91,$92,$93
	dc.b	$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d
	dc.b	$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
	dc.b	$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1
	dc.b	$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb
	dc.b	$bc,$bd,$be,$bf,$c0,$c1,$c2,$c3,$c4,$c5
	dc.b	$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
	dc.b	$d0,$d1,$d2,$d3,$43,$d4,$d5,$d6,$d7,$d8
	dc.b	$d9,$da,$49,$4f,$db,$dc,$5f,$65,$dd,$de
	dc.b	$df,$69,$73,$e0,$e1,$e2,$e3,$e4,$83,$85
	dc.b	$e5,$e6,$e7,$e8,$e9,$ea,$44,$eb,$ec,$ed
	dc.b	$ee,$ef,$f0,$f1,$4a,$50,$f2,$f3,$60,$66
	dc.b	$f4,$f5,$f6,$6a,$74,$f7,$f8,$f9,$fa,$fb
	dc.b	$84,$86,$fc,$fd,$fe,$ff



	

	
	
		