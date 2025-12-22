
; Listings17p.s = zoomer.S

	section	bau,code

j:
	move.l	SP,STACKPOINTER
	move.l	$4,a6
	jsr	-150(a6)
	move.l	d0,sysstack

;	bsr	FixCharSet

ClearSpritePointers:
	lea	SpritePointers1,a0
	lea	SpritePointers1,a1
	moveq	#7,d0
	move.l	#Dummy,d1
ClearS:
	move.w	d1,6(a0)
	move.w	d1,6(a1)
	swap	d1
	move.w	d1,2(a0)
	move.w	d1,2(a1)
	swap	d1
	addq.w	#8,a0
	addq.w	#8,a1
	dbra	d0,ClearS


	move.l	#Screen1,d0
	move.w	d0,pl1l
	swap	d0
	move.w	d0,pl1h
	
	
	move.l #copperlist,$dff080
	move.w $dff088,d0
	move.w	#0,$dff1fc
	move.w #$8380,$dff096

	bsr.w	InitZoomer
	
	move.w #%1000010000000000,$dff096
	
koll:
	cmp.b 	#$3f,$dff006
	bne.s 	koll
	
	clr.l d0
	clr.l d1
	
	move.w 	#$0008,$dff180	;Raster Check
;-------------------------------
	cmp.w	#100,ZoomerReady
	beq.s	ZoomerFinished
	bsr	clear
Wait:	btst	#6,$dff002
	bne.s	Wait
	move.w	#$0006,$dff180
	bsr	initbob
	
	jsr	Zoomer
ZoomerFinished:
;-------------------------------
	move.w	#4,$dff180	;End of raster check!
	
	btst 	#6,$bfe001
	bne.s 	koll
	
Exit:
	move.w #$0000010000000000,$dff096
	
	;bsr 	mt_end
	move.l 	$4,a6
	move.l 	sysstack,d0
	jsr 	-156(a6)
	lea 	graph,a1
	jsr 	-408(a6)
	move.l 	d0,a6
	move.l 	38(a6),$dff080
	move.w	#$c000,$dff09a
	move.l 	STACKPOINTER,SP
	clr.l 	d0
	clr.l 	d1
	rts
	
graph:	dc.b 'graphics.library',0
	EVEN
SYSSTACK:	dc.l 0
STACKPOINTER:	dc.l 0
Dummy:		dc.l 0
	
Zoomer:
	lea	Sinus,a2
	lea	ZoomerOrder(pc),a3
	lea	XCoord(pc),a4
	lea	MemAdd(pc),a5
	lea	MuluTab(pc),a6
	clr.w	d6
ZoomLoop:
	move.w	(a3)+,d4		;Viliken bob
	add.w	d4,d4

	move.w	(a5,d4.w),d3		;Req to bob rut.

	move.w	(a4,d4.w),d0
	sub.w	CentreX,d0		;Delta X

	add.w	#200,d4
	move.w	(a4,d4.w),d1
	sub.w	CentreY,d1		;Delta Y

	add.w	#200,d4

	move.w	(a4,d4.w),d7		;What Movment step
	cmp.w	#SinusNum+2,d7
	beq.s	BobReady
	cmp.w	#SinusNum,d7		;Check for last bob (Num*2)
	bne.s	LastBob
	move.w	#$01,Special		;Sign indicates last bob
	addq.w	#$01,ZoomerReady
LastBob:				;-2 coz of inc 2 later on
	move.w	(a2,d7.w),d7		;Z
;-------Interpolate new Coords----------
	muls	d7,d0
	asr.w	#6,d0			;Transf. x
	add.w	CentreX,d0		;New x
	muls	d7,d1
	asr.w	#6,d1			;Transf. Y
	add.w	CentreY,d1		;New Y
	move.w	d7,d5			;Fix Color
	lsr.w	#2,d5
	add.w	d5,d5
	move.w	(a6,d5.w),d5		;Add to Next plane

	bsr	drawbob
	addq.w	#$02,(a4,d4.w)		;Inc Sinus
	
BobReady:
	addq.w	#$01,d6
	cmp.w	Nbobs,d6		;Hur manga bobs
	bne.s	Zoomloop

	tst.w	TimeDelay
	beq.s	MoreInc
	subq.w	#$01,TimeDelay
	rts
MoreInc:
	move.w	#4,TimeDelay		;Effect Time Beetw. Waves
	cmp.w	#100,Nbobs
	beq.s	NoMoreInc
	add.w	#1,Nbobs		;Effect Waves
NoMoreInc:
	rts

CentreX:	dc.w	160
CentreY:	dc.w	100

ZoomerReady:	dc.w	0
Special:	dc.w	0
TimeDelay:	dc.w	4
Nbobs:		dc.w	1
NumBobs:	dc.w	100

ZoomerOrder:
	DC.W	$00,$01,$02,$03,$04,$05,$06,$07,$08,$09
	DC.W	$0A,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$13
	DC.W	$27,$26,$25,$24,$23,$22,$21,$20,$1F,$1E
	DC.W	$1D,$1C,$1B,$1A,$19,$18,$17,$16,$15,$14
	DC.W	$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31
	DC.W	$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B
	DC.W	$4F,$4E,$4D,$4C,$4B,$4A,$49,$48,$47,$46
	DC.W	$45,$44,$43,$42,$41,$40,$3F,$3E,$3D,$3C
	DC.W	$50,$51,$52,$53,$54,$55,$56,$57,$58,$59
	DC.W	$5A,$5B,$5C,$5D,$5E,$5F,$60,$61,$62,$63

	DC.W	$00,$01,$02,$03,$04,$05,$06,$07,$08,$09
	DC.W	$0A,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$13
	DC.W	$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D
	DC.W	$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27
	DC.W	$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31
	DC.W	$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B
	DC.W	$3C,$3D,$3E,$3F,$40,$41,$42,$43,$44,$45
	DC.W	$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
	DC.W	$50,$51,$52,$53,$54,$55,$56,$57,$58,$59
	DC.W	$5A,$5B,$5C,$5D,$5E,$5F,$60,$61,$62,$63

	DC.W	$00,$01,$02,$03,$04,$05,$06,$07,$08,$09
	DC.W	$0A,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$13
	DC.W	$27,$3B,$4F,$63,$62,$61,$60,$5F,$5E,$5D
	DC.W	$5C,$5B,$5A,$59,$58,$57,$56,$55,$54,$53
	DC.W	$52,$51,$50,$3C,$28,$14,$15,$16,$17,$18
	DC.W	$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22
	DC.W	$23,$24,$25,$26,$3A,$4E,$4D,$4C,$4B,$4A
	DC.W	$49,$48,$47,$46,$45,$44,$43,$42,$41,$40
	DC.W	$3F,$3E,$3D,$29,$2A,$2B,$2C,$2D,$2E,$2F
	DC.W	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39

XCoord:	dc.w	0,16,32,48,64,80,96,112,128,144,160
	dc.w	176,192,208,224,240,256,272,288,304
	dc.w	0,16,32,48,64,80,96,112,128,144,160
	dc.w	176,192,208,224,240,256,272,288,304
	dc.w	0,16,32,48,64,80,96,112,128,144,160
	dc.w	176,192,208,224,240,256,272,288,304
	dc.w	0,16,32,48,64,80,96,112,128,144,160
	dc.w	176,192,208,224,240,256,272,288,304
	dc.w	0,16,32,48,64,80,96,112,128,144,160
	dc.w	176,192,208,224,240,256,272,288,304
YCoord:	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	16,16,16,16,16,16,16,16,16,16
	dc.w	16,16,16,16,16,16,16,16,16,16
	dc.w	32,32,32,32,32,32,32,32,32,32
	dc.w	32,32,32,32,32,32,32,32,32,32
	dc.w	48,48,48,48,48,48,48,48,48,48
	dc.w	48,48,48,48,48,48,48,48,48,48
	dc.w	64,64,64,64,64,64,64,64,64,64
	dc.w	64,64,64,64,64,64,64,64,64,64
ZCoord:	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	
	;-----Must be kept together--------
MuluTab:
	dc.w	$4b00,$4600,$4100,$3c00,$3700,$3200,$2d00,$2800
	dc.w	$2300,$1e00,$1900,$1400,$0f00,$0a00,$0500,$0000
	;----------------------------------
	
ASCII:
	dc.w	0,54,54,54,54,54,54,54,54,54,54
	dc.w	54,54,54,54,58,60,62,64,66,68,70,72,74,76,78,54,54,54,54,54,56
	dc.w	0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32
	dc.w	34,36,38,40,42,44,46,48,50,52,0,0,0
	
	;        12345678901234567890
Text:	DC.B	'*****0123456789*****'
	DC.B	'ABCDEFGHIJKLMNOPQRST'
	DC.B	'UVWXYZ..............'
	DC.B	'DONT CALL ME! LAJMER'
	DC.B	'---C U LATER MATE---'
	EVEN

MemAdd:	dcb.w	100,0
	
InitZoomer:
	move.w	NumBobs,d0
	subq.w	#$01,d0
	lea	Text(pc),a0
	lea	MemAdd(pc),a1
	lea	ASCII(pc),a2
InitZoom:
	moveq	#$00,d1
	move.b	(a0)+,d1
	sub.b	#$20,d1
	lsl.w	#1,d1
	move.w	(a2,d1.w),(a1)+
	dbf	d0,InitZoom
	rts
	
clear:
	lea	WhatScreen,a0
	bchg	#2,ScreenCounter+1
	move.w	ScreenCounter,d0
	move.l	(a0,d0.w),d0
	move.w	d0,pl1l
	swap	d0
	move.w	d0,pl1h
	swap	d0

	btst	#6,$dff002
Axx:
	btst	#6,$dff002
	bne.s	axx

	move.w #$09f0,$dff040		;MINTERM D=A
	clr.w  $dff042			;O=BLTCON1
	move.l #$ffffffff,$dff044	;MASK
	move.l #$00000000,$dff064	;MOD A,D
	move.l d0,$dff054		;DESTNATION
	move.l #SafeScreen,$dff050	;SOURCE
	move.w #200*64+20,$dff058	;Size

	add.l	#$28,d0
	move.w	d0,pl2l
	swap	d0
	move.w	d0,pl2h
	rts
	
	
InitBob:

	btst	#6,$dff002
Ayy:
	btst	#6,$dff002
	bne.s	ayy

	move.l	#$0024004c,$dff060	;c,b
	move.l	#$ffff0000,$dff044		;Pixel pitch
	move.l	#$004c0024,$dff064	;a,d
	rts
	
drawbob:
	; Here starts the bob routine x in d0 y in d1
	
	add.w d1,d1
	add.w d1,d1
	add.w d1,d1
	move.w d1,d7
	add.w d1,d1
	add.w d1,d1
	add.w d7,d1
	
	lea	WhatScreen,a0
	move.w	ScreenCounter,d2
	move.l	(a0,d2.w),a0	;Pos (0,0) in a1

	move.w	d0,d2		;Save xpos in d2
	lsr.w	#3,d0		;Int (xpos/8)
	and.w	#$000f,d2
	
	add.w	d1,a0		;a0+ypos*44
	add.w	d0,a0		;a0+(xpos/8)
	
	lea	chr,a1	;source   RESERVED FOR MULTIBOBUSE
	add.w	d3,a1
	add.w	d5,a1

	btst	#6,$dff002
Azz:
	btst	#6,$dff002
	bne.s	azz

	move.l  a1,$dff050		;Reserved for multibobuse
	;-----------------------------------------------------
	move.l	a1,$dff04c		;Reserved for multibobuse
	;-----------------------------------------------------
	move.l	a0,$dff048		;src c (bgn)
	move.l	a0,$dff054		;dst d (dst)
	ror.w	#4,d2
	move.w	d2,$dff042	;if objmask(a)*obj(b)=1 then poke to d=AB
	add.w	#$0fca,d2	;				  _
	move.w	d2,$dff040	;if objmask(a)=0 then bgn(c) to d=AC
	move.w	#15*64+2,$dff058

	tst.w	Special
	beq.s	NoSafeBob
	lea	SafeScreen,a0
	add.w	d1,a0		;a0+ypos*44
	add.w	d0,a0		;a0+(xpos/8)

	btst	#6,$dff002
Aee:
	btst	#6,$dff002
	bne.s	aee

	move.l  a1,$dff050		;Reserved for multibobuse
	move.l	a1,$dff04c		;Reserved for multibobuse
	move.l	a0,$dff048		;src c (bgn)
	move.l	a0,$dff054		;dst d (dst)
	move.w	#15*64+2,$dff058
	clr.w	Special
NoSafeBob:
	rts

FixCharSet:
	lea	Chr,a0
	lea	NewChr,a1
	move.w	#14,d3		;Num of New CharSets-1
NewSet:
	move.w	#39,d4
NewChar:
	move.w	#-8,d7		;Y-coord
NewY:
	move.w	#-8,d6		;X-coord
NewX:
	move.w	d6,d0		;Copy coords
	move.w	d7,d1
	muls	Dist,d0
	muls	Dist,d1
	ASR.L	#8,d0		;divs	#256,d0
	ASR.L	#8,d1		;divs	#256,d1
	addq.w	#8,d0		;Move Centre from Centrum to Upper Corner
	addq.w	#8,d1
	add.w	XAdd,d0		;Add to pos on Screen
	add.w	YAdd,d1

	move.w	d3,XSave
	move.w	d4,YSave
	bsr	Point
	move.w	XSave,d3
	move.w	YSave,d4

	addq.w	#$01,d6
	cmp.w	#$08,d6
	bne.s	NewX
	addq.w	#$01,d7
	cmp.w	#$08,d7
	bne.s	NewY

	add.w	#16,XAdd	;Inc for next Colum
	dbf	d4,NewChar
	clr.w	XAdd
	add.w	#16,YAdd	;Inc for next raw
	sub.w	#12,Dist	;Change Distance
	dbf	d3,NewSet
	rts

Point:
	move.w	d6,d4		;Save reg
	move.w	d7,d5
	addq.w	#$08,d4
	addq.w	#$08,d5
	add.w	XAdd,d4
	
	mulu	#80,d5
	move.w	d4,d2		;Save xpos in d2
	lsr.w	#3,d4		;Int (xpos/8)
	and.w	#$000f,d2
	add.w	d4,d5
	eor.w	#$000f,d2
	btst	d2,(a0,d5.w)
	bne.s	SetPoint
	
ClearPoint:
	mulu	#80,d1
	move.w	d0,d2		;Save xpos in d2
	lsr.w	#3,d0		;Int (xpos/8)
	and.w	#$000f,d2
	add.w	d0,d1
	eor.w	#$000f,d2
	bclr	d2,(a1,d1.w)
	move.w	d1,$dff180
	rts

SetPoint:
	mulu	#80,d1
	move.w	d0,d2		;Save xpos in d2
	lsr.w	#3,d0		;Int (xpos/8)
	and.w	#$000f,d2
	add.w	d0,d1
	eor.w	#$000f,d2
	bset	d2,(a1,d1.w)
	move.w	#$0f0f,$dff180
	rts

XAdd:	dc.w	0
YAdd:	dc.w	0
Dist:	dc.w	256-12
XSave:	dc.w	0
YSave:	dc.w	0

	;-----------------------------
SinusNum=128*2
Sinus:
	DC.W	0,0,0,0,0,0,0,0
	DC.W	0,0,0,0,0,0,0,1
	DC.W	1,1,1,1,1,2,2,2
	DC.W	2,2,3,3,3,4,4,4
	DC.W	4,5,5,5,6,6,6,7
	DC.W	7,7,8,8,9,9,9,$A
	DC.W	$A,$B,$B,$C,$C,$D,$D,$E
	DC.W	$E,$F,$F,$10,$10,$11,$11,$12
	DC.W	$12,$13,$13,$14,$15,$15,$16,$16
	DC.W	$17,$18,$18,$19,$19,$1A,$1B,$1B
	DC.W	$1C,$1D,$1D,$1E,$1F,$1F,$20,$21
	DC.W	$21,$22,$23,$23,$24,$25,$26,$26
	DC.W	$27,$28,$28,$29,$2A,$2B,$2B,$2C
	DC.W	$2D,$2E,$2E,$2F,$30,$31,$31,$32
	DC.W	$33,$34,$35,$35,$36,$37,$38,$38
	DC.W	$39,$3A,$3B,$3C,$3C,$3D,$3E,$3F,$3f
	;-----------------------------

WhatScreen:
	dc.l	Screen1,Screen2
ScreenCounter:
	dc.w	0

;	dcb.b	16*80,0
NewChr:	dcb.b	16*80*15,0


		section	gnau,data_C

copperlist:
SpritePointers1:
	dc.l $01200000,$01220000,$01240000,$01260000,$01280000,$012a0000
	dc.l $012c0000,$012e0000,$01300000,$01320000,$01340000,$01360000
	dc.l $01380000,$013a0000,$013c0000,$013e0000
	dc.l $01002200,$00920038,$009400d0,$008e2c81
	dc.l $0090f4c1,$01020001
	dc.l $01080000,$010a0000
ColorReg:
	dc.l $01800000,$01820888,$01840fff,$01860ccc
	
	dc.w $00e0
pl1h:	dc.w $0000,$00e2
pl1l:	dc.w $0000
	dc.w $00e4
pl2h:	dc.w $0000,$00e6
pl2l:	dc.w $0000
	
	dc.l $fffffffe



Chr:
	incbin	"ZoomChar.r"

	
	dcb.b	4000,0
Screen1:dcb.b	200*40,0
Screen2:dcb.b	200*40,0
SafeScreen:
	dcb.b	200*40,0
