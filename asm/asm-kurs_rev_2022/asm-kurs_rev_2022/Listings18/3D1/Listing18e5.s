
; Listing18e5.s = DOTSFUN.S

start:

	movem.l	d0-d7/a0-a6,-(a7)

*	dots

*	WRITTEN 10/89 BY LEO OF CYTAX

DOTS_ANZAHL	= 188

	move.l	#Bildschirm,d0
	lea	planes,a0
	move.w	d0,6(a0)
	swap	d0
	move.w	d0,2(a0)

	bsr.w	SYSTEM_INIT
	bsr.w	INIT_COPPER
	bsr.w	INIT_DOTS

loop:
	cmp.b	#255,$dff006
	bne.s	loop

	btst	#6,$bfe001
	beq.s	taste_gedr

	bsr.w	DOTS_CLEAR
	bsr.w	DOTS_MAIN
	bsr.w	DOTSCHANGE_MAIN
	
	tst.w	FADE_UpFlag
	bne.w	FADE_NoUp			; Still left?
FADE_NOUP:
	tst.w	FADE_DownFlag
	bne.s	loop
	bsr.w	TuneDown
	bra	loop

TASTE_GEDR:
	sf	FADE_DownFlag			; Now, tune down.

Wait4:
	cmp.b	#$FF,$dff006
	bne.s	Wait4

	tst.w	FADE_DownFlag
	bne.s	FADE_NoDown			; Entirely black?
	bsr.s	TuneDown
	bra.s	Wait4
FADE_NODOWN:
	bsr.w	INIT_OLDCOPPER

	Move.l	4.w,A6
	jsr	-138(A6)				;Permit
	move.w	#$8020,$dff096
	movem.l	(a7)+,d0-d7/a0-a6

	Moveq	#0,d0
	RTS							; Back to SYSTEM
; ---------------------------------

FADE_MAIN:
	subq.w	#1,FADE_Dly
	bne.s	FADE_Return			; BACK
	move.w	#6,FADE_Dly			; DELAY FACTOR

	moveq	#$f,d5
	sub.w	FADE_Count,d5
FADE_RETURN:
	RTS
TuneDown:
	subq.w	#1,FADE_Dly
	bne.s	FADE_Return
	move.w	#3,FADE_Dly
	moveq	#1,d5

	addq.w	#1,FADE_Count
	cmpi.w	#$10,FADE_Count
	bne.s	FADE_Ret2
	clr.w	FADE_Count
	seq	FADE_UpFlag
	seq	FADE_DownFlag			; Clear up&downflags
FADE_RET2:
	RTS

***************
* FADE LABELS *
***************

FADE_Count:	dc.w	0
FADE_UpFlag:	dc.w	0
FADE_DownFlag:	dc.w	0
FADE_Dly:	dc.w	1


SYSTEM_INIT:
	Move.l	$0004,A6			; EXEC
	jsr	-132(A6)				; FORBID 
	Lea	gfxname(PC),A1
	Moveq	#0,D0
	Move.l	4.w,A6
	jsr	-552(A6)				; Open Graphics Library
	Move.l	D0,gfxbase
	move.l	d0,a0
	move.l	$26(a0),oldcopper
	move.w	#$0020,$dff096
	RTS

INIT_NEWIRQ:
	Move.l	$006c,oldirq
;	Move.l	#NewIRQ,$6c
	Move.w	#$8010,$dff09a		; Vertical Blanking
	RTS

INIT_COPPER:
	Move.l	#Newcopper_list,$dff080
	move.w	d0,$dff088
	move.w	#0,$dff1fc
	RTS

INIT_Oldcopper:
	Move.l	oldcopper(PC),$dff080
	move.w	d0,$dff088
	RTS


Gfxname: 	dc.b 'graphics.library',0
	even
gfxbase:	dc.l 0
Oldcopper:	dc.l 0
Oldirq:		dc.l 0
BITMAP:		dcb.w 4,0
Rastport:	dc.l 0
R_Bitmap:	dc.l 0
	
	dcb.l	20,0	

cugo:
	dc.w	0
cuti:
	dc.w	0

DOTS_CLEAR:
	Move.w	#$8100,$dff096
	Move.l	#$01000000,$dff040	;BLITT KONTR.REG 0
	Move.l	#-1,$dff044			;MASKE FUER 1.DATEN.W
	move.w	#0,$dff066			;BLITT MOD D
	Move.l	#Bildschirm,$dff054	;ADR.ZIELDATEN
	Move.w	#[135*64]+20,$dff058	;START BLITT/GROESSE
	Moveq	#0,d0
	Moveq	#0,d1
e:	btst	#6,$dff002
	bne.s	e
	rts

DOTS_MAIN:
	move.w	#$8100,$dff096
	lea	siny,a0
	lea	sinx,a1
	lea	bits,a5
	lea	pufx(pc),a3
	lea	pufy(pc),a4
	move.w	#dots_anzahl-1,d2
cn1:	lea	Bildschirm+200,a2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a4)+,d0
	add.w	d0,d0
	add.w	(a0,d0.w),a2	
	move.b	(a3)+,d1
	add.w	d1,d1
	add.w	(a1,d1.w),a2
	add.w	#1,a2
	add.w	(a5,d1.w),d1
	rol.w	#4,d1
	not.w	d1
	bset	d1,(a2)
	dbra	d2,cn1

	lea	pufx(pc),a0
	lea	pufy(pc),a1
	move.w	#dots_anzahl-1,d0
cv:	addq.b	#1,(a0)+
	addq.b	#2,(a1)+
	dbra	d0,cv
	rts

pufx:
	dcb.b	dots_anzahl,0
pufy:
	dcb.b	dots_anzahl,0
		even

INIT_DOTS:
	lea	pufx(pc),a0
	lea	pufy(pc),a1
	moveq	#0,d0
	moveq	#0,d1
	move.w	#dots_anzahl-1,d2
INITDOTS_LOOP:
	move.b	d0,(a0)+
	move.b	d1,(a1)+
	add.b	MOVEX,d0
	add.b	MOVEY,d1
	dbra	d2,INITDOTS_LOOP
	rts

DOTSCHANGE_MAIN:
	tst.w	zeit_merker
	beq.s	DOTS_Blendaus	
	subq.w	#1,ZEIT_MERKER
	RTS

DOTS_Blendaus:
	clr.w	fade_downflag
	tst.w	blend_merker
	bne.s	dots_blendein
	lea	dots_col,a0
	tst.w	(a0)
	beq.s	INIT_NEWDOTS
	sub.w	#$111,(a0)
	RTS


INIT_NEWDOTS:
	tst.w	blend_merker
	bne.s	dots_blendein
DCSTART:
	lea	movetab(PC),a0
	lea	movex(PC),a1
	add.w	movetab_merker(PC),a0
	move.w	(a0),(a1)
	cmp.w	#$ffff,(a1)
	bne.s	dots_weiter
	clr.w	movetab_merker
	BRA.s	DCSTART

DOTS_WEITER:
	addq.w	#2,movetab_merker
	bsr.w	INIT_DOTS
	move.w	#$ffff,blend_merker
DOTS_BLENDEIN:
	tst.w	aaa	
	beq.s	ww
	subq.w	#1,aaa
	rts

ww:
	lea	dots_col,a0
	cmp.w	#$fff,(A0)
	beq.s	dots_ende		
	add.w	#$111,(a0)
	move.w	#3,aaa
	RTS

DOTS_ENDE:
	move.w	#150,zeit_merker
	clr.w	blend_merker
RETURN:
;	addq.l	#1,cln
	clr.w	fade_upflag
	RTS

*****	DOTS_LABELS	******

BLEND_MERKER:	dc.w	0
ZEIT_MERKER:	dc.w	100	
MOVETAB_MERKER: dc.w	0
MOVEX:		dc.b	$a6
MOVEY:		dc.b	$b5
aaa:		dc.w	5


MOVETAB:
 dc.w	$fefe,$5555,$f40f,$50a,$a05,$142,$102,$a0a
 dc.w	$a6b5,$d4e3,$f201,$c4d3,$7887,$f0ff
 dc.w	$e0ef,$fc0b
 dc.w	$ffff


sinx:
	dc.w	$12,$12,$12,$13,$13,$14,$14,$15
	dc.w	$15,$16,$16,$16,$17,$17,$18,$18
	dc.w	$18,$19,$19,$1A,$1A,$1A,$1B,$1B
	dc.w	$1C,$1C,$1C,$1D,$1D,$1D,$1E,$1E
	dc.w	$1E,$1F,$1F,$1F,$1F,$20,$20,$20
	dc.w	$21,$21,$21,$21,$21,$22,$22,$22
	dc.w	$22,$22,$23,$23,$23,$23,$23,$23
	dc.w	$23,$23,$23,$23,$23,$24,$24,$24
	dc.w	$24,$24,$24,$24,$23,$23,$23,$23
	dc.w	$23,$23,$23,$23,$23,$23,$23,$22
	dc.w	$22,$22,$22,$22,$21,$21,$21,$21
	dc.w	$21,$20,$20,$20,$1F,$1F,$1F,$1F
	dc.w	$1E,$1E,$1E,$1D,$1D,$1D,$1C,$1C
	dc.w	$1C,$1B,$1B,$1A,$1A,$1A,$19,$19
	dc.w	$18,$18,$18,$17,$17,$16,$16,$16
	dc.w	$15,$15,$14,$14,$13,$13,$12,$12
	dc.w	$12,$11,$11,$10,$10,$F,$F,$E
	dc.w	$E,$E,$D,$D,$C,$C,$C,$B
	dc.w	$B,$A,$A,$9,$9,$9,$8,$8
	dc.w	$8,$7,$7,$6,$6,$6,$5,$5
	dc.w	$5,$5,$4,$4,$4,$3,$3,$3
	dc.w	$3,$2,$2,$2,$2,$1,$1,$1
	dc.w	$1,$1,$1,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,$1,$1
	dc.w	$1,$1,$1,$1,$2,$2,$2,$2
	dc.w	$3,$3,$3,$3,$4,$4,$4,$5
	dc.w	$5,$5,$5,$6,$6,$6,$7,$7
	dc.w	$8,$8,$8,$9,$9,$9,$A,$A
	dc.w	$B,$B,$B,$C,$C,$D,$D,$E
	dc.w	$E,$E,$F,$F,$10,$10,$11,$11

siny:
	dc.w	$8E8,$910,$960,$988,$9D8,$A00,$A28,$A78
	dc.w	$AA0,$AC8,$B18,$B40,$B90,$BB8,$BE0,$C30
	dc.w	$C58,$C80,$CA8,$CF8,$D20,$D48,$D70,$D98
	dc.w	$DE8,$E10,$E38,$E60,$E88,$EB0,$ED8,$F00
	dc.w	$F28,$F50,$F78,$FA0,$FC8,$FF0,$1018,$1040
	dc.w	$1040,$1068,$1090,$10B8,$10B8,$10E0,$1108,$1108
	dc.w	$1130,$1130,$1158,$1158,$1180,$1180,$1180,$11A8
	dc.w	$11A8,$11A8,$11A8,$11D0,$11D0,$11D0,$11D0,$11D0
	dc.w	$11D0,$11D0,$11D0,$11D0,$11D0,$11D0,$11A8,$11A8
	dc.w	$11A8,$11A8,$1180,$1180,$1180,$1158,$1158,$1130
	dc.w	$1130,$1108,$1108,$10E0,$10B8,$10B8,$1090,$1068
	dc.w	$1040,$1040,$1018,$FF0,$FC8,$FA0,$F78,$F50
	dc.w	$F28,$F00,$ED8,$EB0,$E88,$E60,$E38,$E10
	dc.w	$DE8,$DC0,$D70,$D48,$D20,$CF8,$CA8,$C80
	dc.w	$C58,$C30,$BE0,$BB8,$B90,$B40,$B18,$AF0
	dc.w	$AA0,$A78,$A28,$A00,$9D8,$988,$960,$910
	dc.w	$8E8,$8C0,$870,$848,$7F8,$7D0,$7A8,$758
	dc.w	$730,$708,$6B8,$690,$640,$618,$5F0,$5C8
	dc.w	$578,$550,$528,$4D8,$4B0,$488,$460,$438
	dc.w	$3E8,$3C0,$398,$370,$348,$320,$2F8,$2D0
	dc.w	$2A8,$280,$258,$230,$208,$1E0,$1B8,$190
	dc.w	$190,$168,$140,$118,$118,$F0,$C8,$C8
	dc.w	$A0,$A0,$78,$78,$50,$50,$50,$28
	dc.w	$28,$28,$28,0,0,0,0,0
	dc.w	0,0,0,0,0,0,$28,$28
	dc.w	$28,$28,$50,$50,$50,$78,$78,$A0
	dc.w	$A0,$C8,$C8,$F0,$118,$118,$140,$168
	dc.w	$190,$190,$1B8,$1E0,$208,$230,$258,$280
	dc.w	$2A8,$2D0,$2F8,$320,$348,$370,$398,$3C0
	dc.w	$3E8,$410,$460,$488,$4B0,$4D8,$528,$550
	dc.w	$578,$5A0,$5F0,$618,$640,$690,$6B8,$6E0
	dc.w	$730,$758,$7A8,$7D0,$7F8,$848,$870,$8C0

bits:
	dc.w	0,$4000,$7000,$B000,$E000,$2000,$5000,$9000
	dc.w	$C000,0,$3000,$6000,$A000,$D000,$1000,$4000
	dc.w	$7000,$A000,$E000,$1000,$4000,$7000,$A000,$D000
	dc.w	0,$3000,$6000,$9000,$B000,$E000,$1000,$3000
	dc.w	$6000,$8000,$B000,$D000,$F000,$2000,$4000,$6000
	dc.w	$8000,$A000,$C000,$D000,$F000,$1000,$2000,$4000
	dc.w	$5000,$6000,$8000,$9000,$A000,$B000,$C000,$C000
	dc.w	$D000,$E000,$E000,$F000,$F000,0,0,0
	dc.w	0,0,0,0,$F000,$F000,$E000,$E000
	dc.w	$D000,$D000,$C000,$B000,$A000,$9000,$8000,$6000
	dc.w	$5000,$4000,$2000,$1000,$F000,$D000,$C000,$A000
	dc.w	$8000,$6000,$4000,$2000,$F000,$D000,$B000,$8000
	dc.w	$6000,$3000,$1000,$E000,$B000,$9000,$6000,$3000
	dc.w	0,$D000,$A000,$7000,$4000,$1000,$E000,$A000
	dc.w	$7000,$4000,$1000,$D000,$A000,$6000,$3000,0
	dc.w	$C000,$9000,$5000,$2000,$E000,$B000,$7000,$4000
	dc.w	0,$D000,$9000,$5000,$2000,$E000,$B000,$7000
	dc.w	$4000,0,$D000,$A000,$6000,$3000,0,$C000
	dc.w	$9000,$6000,$2000,$F000,$C000,$9000,$6000,$3000
	dc.w	0,$D000,$A000,$7000,$5000,$2000,$F000,$D000
	dc.w	$A000,$8000,$5000,$3000,$1000,$F000,$C000,$A000
	dc.w	$8000,$6000,$5000,$3000,$1000,$F000,$E000,$C000
	dc.w	$B000,$A000,$8000,$7000,$6000,$5000,$4000,$4000
	dc.w	$3000,$2000,$2000,$1000,$1000,0,0,0
	dc.w	0,0,0,0,$1000,$1000,$2000,$2000
	dc.w	$3000,$3000,$4000,$5000,$6000,$7000,$8000,$A000
	dc.w	$B000,$C000,$E000,$F000,$1000,$3000,$4000,$6000
	dc.w	$8000,$A000,$C000,$E000,$1000,$3000,$5000,$8000
	dc.w	$A000,$D000,$F000,$2000,$5000,$7000,$A000,$D000
	dc.w	0,$3000,$6000,$9000,$C000,$F000,$2000,$6000
	dc.w	$9000,$C000,$F000,$3000,$6000,$A000,$D000,0
	dc.w	$4000,$7000,$B000,$E000,$2000,$5000,$9000,$C000

	section	bau,data_c

Newcopper_list:
 dc.w $0100,$0200,$0102,$0000	
 Dc.w $0092,$0038,$0094,$00d0
 Dc.w $008e,$2081,$0090,$29c1	
 Dc.w $0108,$0000,$010a,$0000	
 dc.w $0180,$0000,$3501,$fffe
 dc.w $0100,$200
 DC.W	$0180,$0012			; BACKGR. MENUTEXT
 dc.w	$6207,$fffe

 dc.w	$0182
Dots_col:					; FADE IN/OUT DOTS
 dc.w	$0fff

 dc.w	$6307,$fffe,$0100,$1200		; DOTS/TEXT PLANES
 dc.w	$00e4,$0007,$00e6,$9180+1240	; MENU PLANE

planes:
 dc.w	$00e0,$0007,$00e2,$b0c0		; DOTS PLANE

 dc.w	$0092,$0038,$0094,$00d0
 dc.w	$e007,$fffe
 dc.w	$100,$200
 dc.l	-2


Bildschirm:
	ds.b	10240 ; = $7b0c0

	end


