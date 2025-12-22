
; Listing18r.s = 3d.s

*********************************************************************
*																	*
*	This 3D graphics driver has entirely been written by			*
*			Petri Nordlund 1989.									*
*																	*
*********************************************************************

;niinpä niin, tässä se on tämän levyn namupala
;tämä ruutiini ei ole mikään täydellinen selvitys 3D-grafiikasta
;siihen on kuitenkin panostettu yli puolen vuoden työ, eikä se
;silti ole mikään ihmeellinen. Muista 3D-grafiikkarutkuista tämän
;erottaa siitä, että tämä piirtää TÄYTETTYÄ grafiikkaa.
;onhan itselläni tietenkin parempikin 3D-rutiini, mutta se ei
;valitettavasti sisälly levyn hintaan, hyvä kun tämäkin

START:
	MOVEM.L	D0-D7/A0-A6,-(SP)
	MOVEA.L	4.W,A6
	JSR	-$84(A6)
	MOVE.W	#$20,$DFF096	;DISABLE SPRITES
	bsr	OpenLibraries
	bsr	OpenScreen
	bsr	MakeCopperLists

	clr.w	STATE
	move.l	GFXBASE,a6
	move.l	$32(a6),OldCop		;asetetaan copper-lista

MAINLOOP:

;seuraavaksi vaihdetaan näyttöä. Kun toinen näyttö on piirretty,
;näytetään se ja aletaan piirtämään toista

	move.l	GFXBASE,a6
	tst.w	STATE
	beq.s	State1
	clr.w	STATE
	move.l	Copper2,$32(a6)
	bra.s	StateChanged
State1:	move.w	#1,STATE
	move.l	Copper,$32(a6)
StateChanged:
	bsr	SHOWVIEW
	bsr	Rotate		;suorittaa liikutukset

	btst.b	#6,$bfe001
	bne.s	MAINLOOP

WaitBlitEnd:
	btst	#14,$dff002
	btst	#14,$dff002
	bne.s	WaitBlitEnd

	move.l	GFXBASE,a6
	move.l	OldCop,$32(a6)
	bsr	CloseScreen
	bsr	FreeCopperLists
	MOVE.W	#$8020,$DFF096	;ENABLE SPRITES
	MOVEA.L	4.W,A6
	JSR	-$8A(A6)
	MOVEM.L	(SP)+,D0-D7/A0-A6
	rts

;-------------------------------------------------------------

SHOWVIEW:
	lea	SinCos,a3		;sin ja cos -taulukot a3:een ja a4:ään
	lea	2884(a3),a4
	move.w	#128,d2
	move.w	d2,d4
	movem.w	OXA,d5-d7
	lea	W,a2
	bsr	Matriisi		;matriisi jolla esine pyörii origonsa ympäri
	movem.w	MXA,d5-d7
	move.w	#179,d4
	lea	Q,a2
	bsr	Matriisi		;pyöritetään kuvaa

	sub.l	a4,a4
	lea	Pisteet,a0
LaskePisteet:
	lea	W,a2
	lea	Q,a3
	movem.w	(a0)+,d2-d4
	move.l	a0,-(a7)

	movem.w	OX,d5-d7
	sub.w	MX,d5
	sub.w	MY,d6
	sub.w	MZ,d7
	ext.l	d5
	ext.l	d6
	ext.l	d7

;kerrotaan piste matriisilla W

;HUOM! ohjelma laskee luvuilla jotka on kerrottu 128:lla. Tällöin
;saadaan riittävä tarkkuus laskuihin. Yksi luku vie tilaa 32-bittiä
;ylempi osa on desimaalia- alempi kokonaisosaa varten

	move.w	d2,d0
	muls.w	(a2)+,d0
	move.w	d3,d1
	muls.w	(a2)+,d1
	add.l	d1,d0
	move.w	d4,d1
	muls.w	(a2)+,d1
	add.l	d1,d0
	divs.w	#128,d0
	add.l	d0,d5

	move.w	d2,d0
	muls.w	(a2)+,d0
	move.w	d3,d1
	muls.w	(a2)+,d1
	add.l	d1,d0
	move.w	d4,d1
	muls.w	(a2)+,d1
	add.l	d1,d0
	divs.w	#128,d0
	add.l	d0,d6

	move.w	d2,d0
	muls.w	(a2)+,d0
	move.w	d3,d1
	muls.w	(a2)+,d1
	add.l	d1,d0
	move.w	d4,d1
	muls.w	(a2)+,d1
	add.l	d1,d0
	divs.w	#128,d0
	add.l	d0,d7

	bsr	SQRoot			;neliöjuuri???

	bsr	CountAPUXYZ		;kerrotaan piste matriisilla Q
	move.l	d0,d2
	add.l	d1,d2
	bsr	CountAPUXYZ
	move.l	d0,d3
	add.l	d1,d3
	bsr	CountAPUXYZ
	move.l	d0,d4
	add.l	d1,d4

;tästä eteenpäin alkaa rutiini joka laskee perspektiivin

	bne.s	ApuzNotZero
	moveq	#1,d4
ApuzNotZero:
	move.w	d4,d0
	muls.w	#128,d0
	swap	d4
	ext.l	d4
	add.l	d0,d4
	divs.w	#128,d4
	bne.s	ApuzNotZeroII
	moveq	#1,d4
ApuzNotZeroII:
	move.w	d2,d0
	move.l	d2,d1
	swap	d1
	muls.w	#192,d0
	muls.w	#3,d1
	divs.w	#2,d1
	ext.l	d1
	add.l	d1,d0

	divs.w	d4,d0
	add.w	#160,d0
	lea	X,a0
	move.w	d0,0(a0,a4.w)		;talletetaan pisteen X-koord.
	move.w	d0,d6

	move.w	d3,d0
	move.l	d3,d1
	swap	d1
	muls.w	#200,d0
	muls.w	#200,d1
	divs.w	#128,d1
	ext.l	d1
	add.l	d1,d0

	divs.w	d4,d0
	moveq	#100,d1
	sub.w	d0,d1
	lea	Y,a0
	move.w	d1,0(a0,a4.w)		;talletetaan pisteen Y-koord.
	move.w	d1,d7

	addq.l	#2,a4
	move.l	(a7)+,a0
	cmp.w	#9999,(a0)
	bne	LaskePisteet

;seuraava rutiini laskee polygonin etäisyyden katsojasta

	lea	Kuviot,a1
	lea	ET,a2
CountDist:
	move.w	6(a1),d0
	subq.w	#1,d0
	clr.l	d1
	move.w	d1,d2
CountDistLoop:
	move.w	8(a1,d2.w),d3
	lsl.w	#1,d3
	move.w	0(a2,d3.w),d3
	ext.l	d3
	add.l	d3,d1
	addq.l	#2,d2
	dbf	d0,CountDistLoop

	move.w	6(a1),d0
	divu.w	d0,d1
	move.w	d1,4(a1)
	mulu.w	#2,d0
	add.l	d0,a1
	addq.l	#8,a1
	cmp.w	#9999,(a1)
	bne.s	CountDist

	bsr	PoistaVastakkaiset	;poistetaan ne pinnat
					;jotka eivät kuvassa ehkä näy
	bsr	ClearScreen

PiirraKuvio:		;tämä rutku hakee aina kauimmaisen polygonin
			;ja piirtää sen
	clr.l	d4
	move.l	d4,d5
	lea	Kuviot,a4
Etsi:	cmp.w	#9999,(a4)
	beq.s	Piirra
	cmp.w	4(a4),d4
	bge.s	EtsiSeuraava
	move.l	a4,d5
	move.w	4(a4),d4
EtsiSeuraava:
	move.w	6(a4),d0
	mulu.w	#2,d0
	add.l	d0,a4
	addq.l	#8,a4
	bra.s	Etsi

PiirrosValmis:
	rts
Piirra:	tst.w	d4
	beq.s	PiirrosValmis

AntaaPalaa:		;itse piirto
	move.l	d5,a4
	clr.w	4(a4)
	lea	X,a3
	lea	Y,a5
	move.w	2(a4),Vari

	move.w	8(a4),d5
	lsl.w	#1,d5

	move.l	NowAPoints,a0
	move.w	0(a3,d5.w),(a0)+
	move.w	0(a5,d5.w),(a0)
	addq.l	#4,NowAPoints
	addq.w	#1,AreaCount
	move.l	NowAFlags,a0
	clr.b	(a0)
	addq.l	#1,NowAFlags

	moveq	#2,d6
	move.w	6(a4),d7
	add.l	#10,a4
TasopintaPiste:
	move.w	(a4)+,d5
	lsl.w	#1,d5

	move.l	NowAPoints,a0
	move.l	NowAFlags,a1
	move.w	0(a3,d5.w),d0
	move.w	0(a5,d5.w),d1
	cmp.w	-2(a0),d1
	beq.s	YtSamat
	move.b	#3,(a1)
	bra.s	YtAreaflags
YtSamat:
	move.b	#2,(a1)
YtAreaflags:
	movem.w	d0/d1,(a0)
	addq.l	#4,NowAPoints
	addq.w	#1,AreaCount
	addq.l	#1,NowAFlags

	cmp.w	d7,d6
	blt	ContinueDraw
	bsr	Areafill		;täytetään

;kun polygon on piirretty, se on kopioitava kaikkiin kuvan
;bittitasoihin

	move.l	BlitSTART,d7
	sub.l	TmpBmap,d7
	move.l	ThisRP,a2
	move.w	Vari,d2

	move.w	BlitMOD,d4
	swap	d4
	move.w	BlitMOD,d4
	lea	$dff000,a0
	move.l	#$ffffffff,$44(a0)
	move.l	BlitSTART,d5
	move.l	(a2),d6
	btst	#0,d2
	beq.s	CopyNotFirst
	bsr.s	WaitBlitCopy
	bra.s	FirstOK
CopyNotFirst:
	bsr.s	WaitBlitCopy2
FirstOK:
	move.l	4(a2),d6
	btst	#1,d2
	beq.s	CopyNotSecond
	bsr.s	WaitBlitCopy
	bra.s	SecondOK
CopyNotSecond:
	bsr.s	WaitBlitCopy2
SecondOK:
	move.l	8(a2),d6
	btst	#2,d2
	beq.s	CopyNotThird
	bsr.s	WaitBlitCopy
	bra	PiirraKuvio
CopyNotThird:
	bsr.s	WaitBlitCopy2
	bra	PiirraKuvio

ContinueDraw:
	addq.w	#1,d6
	bra	TasopintaPiste

WaitBlitCopy:
	btst	#14,2(a0)
	bne.s	WaitBlitCopy
	add.l	d7,d6
	move.l	d6,d0
	movem.l	d0/d5/d6,$4c(a0)

	move.l	d4,$64(a0)
	move.w	d4,$62(a0)
	move.l	#%00001101111111000000000000000010,$40(a0)
	move.w	BlitSIZE,$58(a0)
	rts

WaitBlitCopy2:
	btst	#14,2(a0)
	bne.s	WaitBlitCopy2
	add.l	d7,d6
	move.l	d6,d0
	movem.l	d0/d5/d6,$4c(a0)

	move.l	d4,$64(a0)
	move.w	d4,$62(a0)
	move.l	#%00001101000011000000000000000010,$40(a0)
	move.w	BlitSIZE,$58(a0)
	rts

PoistaVastakkaiset:
	clr.l	d7
	lea	Kuviot,a4
Poista:	cmp.w	#9999,0(a4,d7.l)
	beq	Poistettu
	cmp.w	#1,0(a4,d7.l)
	beq.s	PoistaNext
	move.w	6(a4,d7.l),d0
	mulu.w	#2,d0
	add.l	d0,d7
	addq.l	#8,d7
	bra.s	Poista
PoistaNext:
	move.l	d7,d6
	move.w	6(a4,d7.l),d0
	mulu.w	#2,d0
	add.l	d0,d6
	add.l	#12,d6
	move.w	0(a4,d6.l),d0
	cmp.w	4(a4,d7.l),d0
	bgt.s	DoPoisto
	beq.s	PoistoDone
	clr.w	4(a4,d7.l)
PoistoDone:
	move.w	6(a4,d7.l),d0
	mulu.w	#2,d0
	move.l	d0,d7
	add.l	d6,d7
	addq.l	#4,d7
	bra.s	Poista
DoPoisto:
	clr.w	0(a4,d6.l)
	bra.s	PoistoDone
Poistettu:
	rts

SQRoot:				;tämä on nimeltään neliöjuuri
				;vaikkei se otakaan luvusta neliöjuurta
				;mutta ennen otti, ja siitä nimi
	move.w	d5,d0
	bpl.s	SQRd5ok
	neg.w	d0
SQRd5ok:
	ext.l	d0
	mulu.w	d0,d0
	move.w	d6,d1
	bpl.s	SQRd6ok
	neg.w	d1
SQRd6ok:
	ext.l	d1
	mulu.w	d1,d1
	add.l	d1,d0
	move.w	d7,d1
	bpl.s	SQRd7ok
	neg.w	d1
SQRd7ok:
	ext.l	d1
	mulu.w	d1,d1
	add.l	d1,d0
	lsr.l	#4,d0
	lea	ET,a0
	move.w	d0,0(a0,a4.w)
	rts

CountAPUXYZ:
	move.w	d5,d0
	move.l	d5,d1
	swap	d1
	muls.w	(a3),d0
	muls.w	(a3)+,d1
	move.l	d0,a5
	move.l	d1,a6

	move.w	d6,d0
	move.l	d6,d1
	swap	d1
	muls.w	(a3),d0
	muls.w	(a3)+,d1
	add.l	d0,a5
	add.l	d1,a6
	
	move.w	d7,d0
	move.l	d7,d1
	swap	d1
	muls.w	(a3),d0
	muls.w	(a3)+,d1
	add.l	a5,d0
	add.l	a6,d1

	divs.w	#128,d0
	divs.w	#128,d1
	swap	d1
	and.l	#$ffff0000,d1
	rts

Matriisi:
	lsl.w	#2,d5
	lsl.w	#2,d6
	lsl.w	#2,d7
	add.w	#1432,d5
	add.w	#1432,d6
	add.w	#1432,d7

	move.w	2(a4,d6.w),d0
	neg.w	d0
	move.w	d0,d1
	muls.w	2(a4,d7.w),d0
	divs.w	d2,d0
	move.w	d0,a0

	muls.w	6(a3,d7.w),d1
	divs.w	d2,d1
	move.w	d1,d3
	
	muls.w	2(a4,d5.w),d0
	move.w	6(a3,d5.w),d1
	muls.w	6(a3,d7.w),d1
	add.l	d0,d1
	divs.w	d2,d1
	move.w	d1,(a2)+
	
	move.w	2(a4,d7.w),d0
	muls.w	6(a3,d6.w),d0
	divs.w	d2,d0
	move.w	d0,(a2)+

	move.w	6(a3,d7.w),d0
	neg.w	d0
	muls.w	2(a4,d5.w),d0
	move.w	a0,d1
	muls.w	6(a3,d5.w),d1
	add.l	d0,d1
	divs.w	d2,d1
	move.w	d1,(a2)+

	move.w	2(a4,d7.w),d0
	neg.w	d0
	muls.w	6(a3,d5.w),d0
	move.w	d3,d1
	muls.w	2(a4,d5.w),d1
	add.l	d0,d1
	divs.w	d2,d1
	move.w	d1,(a2)+

	move.w	6(a3,d6.w),d1
	muls.w	6(a3,d7.w),d1
	divs.w	d2,d1
	move.w	d1,(a2)+
	
	move.w	2(a4,d7.w),d0
	muls.w	2(a4,d5.w),d0
	move.w	6(a3,d5.w),d1
	muls.w	d3,d1
	add.l	d0,d1
	divs.w	d2,d1
	move.w	d1,(a2)+

	move.w	6(a3,d6.w),d0
	muls.w	2(a4,d5.w),d0
	divs.w	d4,d0
	move.w	d0,(a2)+

	move.w	2(a4,d6.w),d0
	muls.w	d2,d0
	divs.w	d4,d0
	move.w	d0,(a2)+

	move.w	6(a3,d6.w),d0
	muls.w	6(a3,d5.w),d0
	divs.w	d4,d0
	move.w	d0,(a2)+
	rts

Rotate:	addq.w	#2,OXA
	cmp.w	#359,OXA
	blt.s	OKX
	clr.w	OXA
OKX:	rts
	addq.w	#2,OYA
	cmp.w	#359,OYA
	blt.s	OKY
	clr.w	OYA
OKY:	addq.w	#2,OZA
	cmp.w	#359,OZA
	blt.s	OKZ
	clr.w	OZA
OKZ:	rts

ClearScreen:
	cmp.b	#210,$dff006
	blt.s	ClearScreen
	cmp.b	#255,$dff006
	bgt.s	ClearScreen
	tst.w	STATE
	bne.s	ClearScr2
	lea	Bmaps1,a2
	bra.s	ClearScrSelected
ClearScr2:
	lea	Bmaps2,a2
ClearScrSelected:
	move.l	a2,ThisRP
	btst	#14,$dff002
	bne.s	ClearScrSelected
	move.l	(a2),$dff054
	move.l	#$01000000,$dff040
	clr.w	$dff066
	move.w	#200*64*3+320/16,$dff058
	rts

OpenScreen:
	move.l	$4,a6
	move.l	#8000,d0
	move.l	#2+65536,d1
	jsr	-198(a6)
	move.l	d0,TmpBmap

	move.l	#8000*3,d0
	move.l	#2+65536,d1
	jsr	-198(a6)
	lea	Bmaps1,a0
	move.l	d0,(a0)+
	add.l	#8000,d0
	move.l	d0,(a0)+
	add.l	#8000,d0
	move.l	d0,(a0)+

	move.l	#8000*3,d0
	move.l	#2+65536,d1
	jsr	-198(a6)
	lea	Bmaps2,a0
	move.l	d0,(a0)+
	add.l	#8000,d0
	move.l	d0,(a0)+
	add.l	#8000,d0
	move.l	d0,(a0)+
	rts

CloseScreen:
	move.l	$4,a6
	move.l	Bmaps1,a1
	move.l	#8000*3,d0
	jsr	-210(a6)

	move.l	Bmaps2,a1
	move.l	#8000*3,d0
	jsr	-210(a6)

	move.l	TmpBmap,a1
	move.l	#8000,d0
	jsr	-210(a6)
	rts

OpenLibraries:
	move.l	$4,a6
	lea	IntLibName,a1
	jsr	-408(a6)
	move.l	d0,INTBASE
	lea	GfxLibName,a1
	jsr	-408(a6)
	move.l	d0,GFXBASE
	rts

FreeCopperLists:
	move.l	$4,a6
	move.l	Copper,a1
	move.l	#2000,d0
	jsr	-210(a6)
	rts

MakeCopperLists:
	move.l	$4,a6
	move.l	#2000,d0
	move.l	#2+65536,d1
	jsr	-198(a6)
	move.l	d0,Copper
	add.l	#1000,d0
	move.l	d0,Copper2
	lea	MyCopperList,a0
	lea	Bmaps1,a2
	move.l	(a2)+,d0
	move.l	(a2)+,d1
	move.l	(a2),d2
	move.w	d0,6(a0)
	swap.w	d0
	move.w	d0,2(a0)
	move.w	d1,14(a0)
	swap.w	d1
	move.w	d1,10(a0)
	move.w	d2,22(a0)
	swap.w	d2
	move.w	d2,18(a0)
	move.l	Copper,a1
CopyCopLoop:
	move.l	(a0),(a1)+
	cmp.l	#$fffffffe,(a0)+
	bne	CopyCopLoop

	lea	MyCopperList2,a0
	lea	Bmaps2,a2
	move.l	(a2)+,d0
	move.l	(a2)+,d1
	move.l	(a2),d2
	move.w	d0,6(a0)
	swap.w	d0
	move.w	d0,2(a0)
	move.w	d1,14(a0)
	swap.w	d1
	move.w	d1,10(a0)
	move.w	d2,22(a0)
	swap.w	d2
	move.w	d2,18(a0)
	move.l	Copper2,a1
CopyCopLoop2:
	move.l	(a0),(a1)+
	cmp.l	#$fffffffe,(a0)+
	bne	CopyCopLoop2
	rts

MyCopperList:
	dc.w	$00e0,$0000
	dc.w	$00e2,$0000
	dc.w	$00e4,$0000
	dc.w	$00e6,$0000
	dc.w	$00e8,$0000
	dc.w	$00ea,$0000
	dc.w	$0108,$0000
	dc.w	$010a,$0000
	dc.w	$0100,%0011000000000000
	dc.w	$0102,$0000
	dc.w	$0104,$0000
	dc.w	$008e,$2c81
	dc.w	$0090,$f4c1
	dc.w	$0092,$0038
	dc.w	$0094,$00d0
	dc.w	$0180,$0000
	dc.w	$0182,$0ada
	dc.w	$0184,$0595
	dc.w	$0186,$08ae
	dc.w	$0188,$068c
	dc.w	$018a,$079d
	dc.w	$018c,$057b
	dc.w	$018e,$0444
	dc.w	$ffff,$fffe

MyCopperList2:
	dc.w	$00e0,$0000
	dc.w	$00e2,$0000
	dc.w	$00e4,$0000
	dc.w	$00e6,$0000
	dc.w	$00e8,$0000
	dc.w	$00ea,$0000
	dc.w	$0108,$0000
	dc.w	$010a,$0000
	dc.w	$0100,%0011000000000000
	dc.w	$0102,$0000
	dc.w	$0104,$0000
	dc.w	$008e,$2c81
	dc.w	$0090,$f4c1
	dc.w	$0092,$0038
	dc.w	$0094,$00d0
	dc.w	$0180,$0000
	dc.w	$0182,$0ada
	dc.w	$0184,$0595
	dc.w	$0186,$08ae
	dc.w	$0188,$068c
	dc.w	$018a,$079d
	dc.w	$018c,$057b
	dc.w	$018e,$0444
	dc.w	$ffff,$fffe

Copper:	dc.l	0
Copper2:	dc.l	0
X:	ds.w	200
Y:	ds.w	200
ET:	ds.w	200
Q:	ds.w	9
W:	ds.w	9
MX:	dc.w	0
MY:	dc.w	0
MZ:	dc.w	-250
MXA:	dc.w	0
MYA:	dc.w	0 
MZA:	dc.w	0
OX:	dc.w	0
OY:	dc.w	0
OZ:	dc.w	0
OXA:	dc.w	140
OYA:	dc.w	140
OZA:	dc.w	10
INTBASE:	dc.l	0
GFXBASE:	dc.l	0
TmpBmap:	dc.l	0
STATE:	dc.w	0
OldCop:	dc.l	0
ThisRP:	dc.l	0
Bmaps1:	ds.l	5
Bmaps2:	ds.l	5
LinePoints:	ds.b	1400
AreaPoints:	ds.l	100
AreaFlags:	ds.w	100
NowAPoints:	dc.l	AreaPoints
NowAFlags:	dc.l	AreaFlags
AreaCount:	dc.w	0
Pino:	ds.b	100
AXS:	dc.w	0
AYS:	dc.w	0
Vari:	dc.w	0
BlitMOD:	dc.w	0
BlitSIZE:	dc.w	0
BlitSTART:	dc.l	0
CP_X:	dc.w	0
CP_Y:	dc.w	0
RPFlags1:	dc.b	0
RPFlags2:	dc.b	0
RPLinPatC:	dc.w	0

Pisteet:
	dc.w	30,10,50		;piste nro. 0
	dc.w	20,20,40		;piste nro. 1
	dc.w	-20,20,40		;piste...
	dc.w	-30,10,50
	dc.w	-20,0,40
	dc.w	20,0,40

	dc.w	30,10,-50
	dc.w	20,20,-40
	dc.w	-20,20,-40
	dc.w	-30,10,-50
	dc.w	-20,0,-40
	dc.w	20,0,-40

	dc.w	20,0,-10
	dc.w	-20,0,-10
	dc.w	-17,-15,-33
	dc.w	17,-15,-33

	dc.w	9999

Kuviot:
;kuviot on määritelty muodossa:

;	1.	mikäli tämä luku on 1, seuraava polygon on tämän vastakohta
;	2.	väri
;	3.	etäisyys (ohjelma laskee)
;	4.	montako pistettä
;	5-	pisteet

	dc.w	0,1,0,4,0,6,11,5
	dc.w	0,2,0,4,0,6,7,1
	dc.w	0,1,0,4,3,4,10,9
	dc.w	0,2,0,4,3,2,8,9

	dc.w	0,2,0,4,3,4,5,0
	dc.w	0,1,0,4,3,2,1,0
	dc.w	0,2,0,4,10,11,6,9
	dc.w	0,1,0,4,9,6,7,8

	dc.w	1,3,0,4,1,2,8,7
	dc.w	0,3,0,4,13,12,5,4

	dc.w	0,4,0,3,12,15,11
	dc.w	0,4,0,3,13,14,10

	dc.w	0,5,0,4,12,13,14,15
	dc.w	0,6,0,4,14,15,11,10

	dc.w	9999

IntLibName:	dc.b	'intuition.library',0
GfxLibName:	dc.b	'graphics.library',0,0
SinCos:		;in longword

 dc.l $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$7E,$7E,$7D
 dc.l $7D,$7D,$7C,$7C,$7B,$7A,$7A,$79,$78,$78,$77,$76
 dc.l $75,$74,$73,$72,$71,$70,$6F,$6E,$6D,$6C,$6A,$69
 dc.l $68,$67,$65,$64,$62,$61,$60,$5E,$5D,$5B,$59,$58
 dc.l $56,$54,$53,$51,$4F,$4E,$4C,$4A,$48,$46,$44,$42
 dc.l $41,$3F,$3D,$3B,$39,$37,$35,$33,$31,$2E,$2C,$2A
 dc.l $28,$26,$24,$22,$1F,$1D,$1B,$19,$17,$14,$12,$10
 dc.l $E,$C,$9,$7,$5,$3,0,-1,-3,-5,-7,-$A,-$C,-$E,-$10,-$13,-$15,-$17,-$19
 dc.l -$1B,-$1E,-$20,-$22,-$24,-$26,-$28,-$2B,-$2D,-$2F,-$31,-$33
 dc.l -$35,-$37,-$39,-$3B,-$3D,-$3F,-$41,-$43,-$45,-$47,-$48,-$4A
 dc.l -$4C,-$4E,-$50,-$51,-$53,-$55,-$56,-$58,-$5A,-$5B,-$5D,-$5E
 dc.l -$60,-$61,-$63,-$64,-$65,-$67,-$68,-$69,-$6B,-$6C,-$6D,-$6E
 dc.l -$6F,-$70,-$71,-$72,-$73,-$74,-$75,-$76,-$77,-$78,-$78,-$79
 dc.l -$7A,-$7A,-$7B,-$7C,-$7C,-$7D,-$7D,-$7E,-$7E,-$7E,-$7F,-$7F
 dc.l -$7F,-$7F,-$7F,-$7F,-$7F,-$80,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F
 dc.l -$7F,-$7E,-$7E,-$7E,-$7D,-$7D,-$7C,-$7C,-$7B,-$7A,-$7A,-$79
 dc.l -$78,-$78,-$77,-$76,-$75,-$74,-$73,-$72,-$71,-$70,-$6F,-$6E
 dc.l -$6D,-$6C,-$6B,-$69,-$68,-$67,-$65,-$64,-$63,-$61,-$60,-$5E
 dc.l -$5D,-$5B,-$5A,-$58,-$56,-$55,-$53,-$51,-$50,-$4E,-$4C,-$4A
 dc.l -$48,-$47,-$45,-$43,-$41,-$3F,-$3D,-$3B,-$39,-$37,-$35,-$33
 dc.l -$31,-$2F,-$2D,-$2B,-$28,-$26,-$24,-$22,-$20,-$1E,-$1B,-$19
 dc.l -$17,-$15,-$13,-$10,-$E,-$C,-$A,-7,-5,-3,-1,0,1,3,5,7,$A,$C
 dc.l $E,$10,$13,$15,$17,$19,$1B,$1E,$20,$22,$24,$26
 dc.l $28,$2B,$2D,$2F,$31,$33,$35,$37,$39,$3B,$3D,$3F
 dc.l $41,$43,$45,$47,$48,$4A,$4C,$4E,$50,$51,$53,$55
 dc.l $56,$58,$5A,$5B,$5D,$5E,$60,$61,$63,$64,$65,$67
 dc.l $68,$69,$6B,$6C,$6D,$6E,$6F,$70,$71,$72,$73,$74
 dc.l $75,$76,$77,$78,$78,$79,$7A,$7A,$7B,$7C,$7C,$7D
 dc.l $7D,$7E,$7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$80
 dc.l $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$7E,$7E,$7D,$7D
 dc.l $7C,$7C,$7B,$7A,$7A,$79,$78,$78,$77,$76,$75,$74
 dc.l $73,$72,$71,$70,$6F,$6E,$6D,$6C,$6B,$69,$68,$67
 dc.l $65,$64,$63,$61,$60,$5E,$5D,$5B,$5A,$58,$56,$55
 dc.l $53,$51,$50,$4E,$4C,$4A,$48,$47,$45,$43,$41,$3F
 dc.l $3D,$3B,$39,$37,$35,$33,$31,$2F,$2D,$2B,$28,$26
 dc.l $24,$22,$20,$1E,$1B,$19,$17,$15,$13,$10,$E,$C
 dc.l $A,$7,$5,$3,$1,0,-1,-3,-5,-7,-$A,-$C,-$E,-$10,-$13,-$15,-$17,-$19
 dc.l -$1B,-$1E,-$20,-$22,-$24,-$26,-$28,-$2B,-$2D,-$2F,-$31,-$33
 dc.l -$35,-$37,-$39,-$3B,-$3D,-$3F,-$41,-$43,-$45,-$47,-$48,-$4A
 dc.l -$4C,-$4E,-$50,-$51,-$53,-$55,-$56,-$58,-$5A,-$5B,-$5D,-$5E
 dc.l -$60,-$61,-$63,-$64,-$65,-$67,-$68,-$69,-$6B,-$6C,-$6D,-$6E
 dc.l -$6F,-$70,-$71,-$72,-$73,-$74,-$75,-$76,-$77,-$78,-$78,-$79
 dc.l -$7A,-$7A,-$7B,-$7C,-$7C,-$7D,-$7D,-$7E,-$7E,-$7E,-$7F,-$7F
 dc.l -$7F,-$7F,-$7F,-$7F,-$7F,-$80,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F
 dc.l -$7F,-$7E,-$7E,-$7E,-$7D,-$7D,-$7C,-$7C,-$7B,-$7A,-$7A,-$79
 dc.l -$78,-$78,-$77,-$76,-$75,-$74,-$73,-$72,-$71,-$70,-$6F,-$6E
 dc.l -$6D,-$6C,-$6B,-$69,-$68,-$67,-$65,-$64,-$63,-$61,-$60,-$5E
 dc.l -$5D,-$5B,-$5A,-$58,-$56,-$55,-$53,-$51,-$50,-$4E,-$4C,-$4A
 dc.l -$48,-$47,-$45,-$43,-$41,-$3F,-$3D,-$3B,-$39,-$37,-$35,-$33
 dc.l -$31,-$2F,-$2D,-$2B,-$28,-$26,-$24,-$22,-$20,-$1E,-$1B,-$19
 dc.l -$17,-$15,-$13,-$10,-$E,-$C,-$A,-7,-5,-3,-1
 dc.l 0,1,3,5,7,9,$C,$E,$10,$12,$14,$17,$19,$1B,$1D
 dc.l $1F,$22,$24,$26,$28,$2A,$2C,$2E,$31,$33,$35,$37
 dc.l $39,$3B,$3D,$3F,$41,$42,$44,$46,$48,$4A,$4C,$4E
 dc.l $4F,$51,$53,$54,$56,$58,$59,$5B,$5D,$5E,$60,$61
 dc.l $62,$64,$65,$67,$68,$69,$6A,$6C,$6D,$6E,$6F,$70
 dc.l $71,$72,$73,$74,$75,$76,$77,$78,$78,$79,$7A,$7A
 dc.l $7B,$7C,$7C,$7D,$7D,$7D,$7E,$7E,$7E,$7F,$7F,$7F
 dc.l $7F,$7F,$7F,$7F,$7F,0,1,2,4,7,$9,$B,$D,$F,$12,$14,$16
 dc.l $18,$1B,$1D,$1F,$21,$23,$25,$28,$2A,$2C,$2E,$30
 dc.l $32,$34,$36,$38,$3A,$3C,$3E,$40,$42,$44,$46,$48
 dc.l $4A,$4B,$4D,$4F,$51,$52,$54,$56,$57,$59,$5B,$5C
 dc.l $5E,$5F,$61,$62,$64,$65,$66,$68,$69,$6A,$6B,$6D
 dc.l $6E,$6F,$70,$71,$72,$73,$74,$75,$76,$77,$77,$78
 dc.l $79,$7A,$7A,$7B,$7B,$7C,$7C,$7D,$7D,$7E,$7E,$7E
 dc.l $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 dc.l $7F,$7F,$7E,$7E,$7E,$7D,$7D,$7C,$7C,$7B,$7B,$7A
 dc.l $79,$79,$78,$77,$76,$76,$75,$74,$73,$72,$71,$70
 dc.l $6F,$6D,$6C,$6B,$6A,$69,$67,$66,$65,$63,$62,$60
 dc.l $5F,$5D,$5C,$5A,$59,$57,$55,$54,$52,$50,$4F,$4D
 dc.l $4B,$49,$47,$45,$44,$42,$40,$3E,$3C,$3A,$38,$36
 dc.l $34,$32,$30,$2D,$2B,$29,$27,$25,$23,$21,$1E,$1C
 dc.l $1A,$18,$16,$13,$11,$F,$D,$B,$8,$6,$4,$2,0,-2,-4,-6,-8,-$B,-$D
 dc.l -$F,-$11,-$14,-$16,-$18,-$1A,-$1C,-$1F,-$21,-$23,-$25,-$27
 dc.l -$29,-$2B,-$2E,-$30,-$32,-$34,-$36,-$38,-$3A,-$3C,-$3E,-$40
 dc.l -$42,-$44,-$46,-$47,-$49,-$4B,-$4D,-$4F,-$50,-$52,-$54,-$56
 dc.l -$57,-$59,-$5A,-$5C,-$5D,-$5F,-$60,-$62,-$63,-$65,-$66,-$67
 dc.l -$69,-$6A,-$6B,-$6C,-$6E,-$6F,-$70,-$71,-$72,-$73,-$74,-$75
 dc.l -$76,-$76,-$77,-$78,-$79,-$79,-$7A,-$7B,-$7B,-$7C,-$7C,-$7D
 dc.l -$7D,-$7E,-$7E,-$7E,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F
 dc.l -$7F,-$7F,-$7F,-$7F,-$7F,-$7F,-$7E,-$7E,-$7E,-$7D,-$7D,-$7C
 dc.l -$7C,-$7B,-$7B,-$7A,-$7A,-$79,-$78,-$77,-$77,-$76,-$75,-$74
 dc.l -$73,-$72,-$71,-$70,-$6F,-$6E,-$6C,-$6B,-$6A,-$69,-$68,-$66
 dc.l -$65,-$63,-$62,-$61,-$5F,-$5E,-$5C,-$5A,-$59,-$57,-$56,-$54
 dc.l -$52,-$51,-$4F,-$4D,-$4B,-$49,-$48,-$46,-$44,-$42,-$40,-$3E
 dc.l -$3C,-$3A,-$38,-$36,-$34,-$32,-$30,-$2E,-$2C,-$2A,-$27,-$25
 dc.l -$23,-$21,-$1F,-$1D,-$1A,-$18,-$16,-$14,-$12,-$F,-$D,-$B
 dc.l -9,-6,-4,-2,0,2,4,6,8,$B,$D,$F,$11,$14,$16,$18,$1A
 dc.l $1C,$1F,$21,$23,$25,$27,$29,$2B,$2E,$30,$32,$34
 dc.l $36,$38,$3A,$3C,$3E,$40,$42,$44,$46,$47,$49,$4B
 dc.l $4D,$4F,$50,$52,$54,$56,$57,$59,$5A,$5C,$5D,$5F
 dc.l $60,$62,$63,$65,$66,$67,$69,$6A,$6B,$6C,$6E,$6F
 dc.l $70,$71,$72,$73,$74,$75,$76,$76,$77,$78,$79,$79
 dc.l $7A,$7B,$7B,$7C,$7C,$7D,$7D,$7E,$7E,$7E,$7F,$7F
 dc.l $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 dc.l $7E,$7E,$7E,$7D,$7D,$7C,$7C,$7B,$7B,$7A,$7A,$79
 dc.l $78,$77,$77,$76,$75,$74,$73,$72,$71,$70,$6F,$6E
 dc.l $6C,$6B,$6A,$69,$68,$66,$65,$63,$62,$61,$5F,$5E
 dc.l $5C,$5A,$59,$57,$56,$54,$52,$51,$4F,$4D,$4B,$49
 dc.l $48,$46,$44,$42,$40,$3E,$3C,$3A,$38,$36,$34,$32
 dc.l $30,$2E,$2C,$2A,$27,$25,$23,$21,$1F,$1D,$1A,$18
 dc.l $16,$14,$12,$F,$D,$B,9,6,4,2,0,-2,-4,-6,-8,-$B,-$D
 dc.l -$F,-$11,-$14,-$16,-$18,-$1A,-$1C,-$1F,-$21,-$23,-$25,-$27
 dc.l -$29,-$2B,-$2E,-$30,-$32,-$34,-$36,-$38,-$3A,-$3C,-$3E,-$40
 dc.l -$42,-$44,-$46,-$47,-$49,-$4B,-$4D,-$4F,-$50,-$52,-$54,-$56
 dc.l -$57,-$59,-$5A,-$5C,-$5D,-$5F,-$60,-$62,-$63,-$65,-$66,-$67
 dc.l -$69,-$6A,-$6B,-$6C,-$6E,-$6F,-$70,-$71,-$72,-$73,-$74,-$75
 dc.l -$76,-$76,-$77,-$78,-$79,-$79,-$7A,-$7B,-$7B,-$7C,-$7C,-$7D
 dc.l -$7D,-$7E,-$7E,-$7E,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F,-$7F
 dc.l -$7F,-$7F,-$7F,-$7F,-$7F,-$7F,-$7E,-$7E,-$7E,-$7D,-$7D,-$7C
 dc.l -$7C,-$7B,-$7B,-$7A,-$7A,-$79,-$78,-$77,-$77,-$76,-$75,-$74
 dc.l -$73,-$72,-$71,-$70,-$6F,-$6E,-$6C,-$6B,-$6A,-$69,-$68,-$66
 dc.l -$65,-$63,-$62,-$61,-$5F,-$5E,-$5C,-$5A,-$59,-$57,-$56,-$54
 dc.l -$52,-$51,-$4F,-$4D,-$4B,-$49,-$48,-$46,-$44,-$42
 dc.l -$40,-$3E,-$3C,-$3A,-$38,-$36,-$34,-$32,-$30,-$2E,-$2C,-$2A,-$27,-$25
 dc.l -$23,-$21,-$1F,-$1D,-$1A,-$18,-$16,-$14,-$12,-$F,-$D,-$B,-9,-6,-4,-2,-1,0
 dc.l $00240000,$FC1C7878,$64632E6C,$20243030,$30303030,$37462C24

;tämä areafill-rutiini on riisuttu malli amigan romissa olevasta
;areafill-rutiinista.

Areafill:
	movem.l	d2-d7/a2-a5,-(a7)
	lea	$dff000,a6
	move.l	NowAPoints,a0
	move.l	AreaPoints,d7
	cmp.l	-4(a0),d7
	beq.s	lbC000952
	move.l	NowAFlags,a1
	cmp.w	-2(a0),d7
	bne	AreaLastEiSama
	move.b	#2,(a1)
	bra.s	AreaSetJee
AreaLastEiSama:
	move.b	#3,(a1)
AreaSetJee:
	move.l	d7,(a0)
	addq.l	#4,NowAPoints
	addq.l	#1,NowAFlags
	addq.w	#1,AreaCount

lbC000952
	lea	AreaPoints,a0
	movem.w	(a0)+,d0/d2
	move.w	d0,d1
	move.w	d2,d3
	move.w	AreaCount,d7
	subq.w	#2,d7
lbC000964
	movem.w	(a0)+,d5/d6
	cmp.w	d5,d0
	ble.s	lbC00096E
	move.w	d5,d0
	bra.s	lbC000974
lbC00096E
	cmp.w	d5,d1
	bge.s	lbC000974
	move.w	d5,d1
lbC000974
	cmp.w	d6,d2
	ble.s	lbC00097E
	move.w	d6,d2
	bra.s	lbC000984
lbC00097E
	cmp.w	d6,d3
	bge.s	lbC000984
	move.w	d6,d3
lbC000984
	dbra	d7,lbC000964

	movem.w	d1/d3,AXS
	and.w	#$fff0,d0
	and.w	#$fff0,d1
	sub.w	d0,d1
	lsr.w	#3,d1
	addq.w	#2,d1
	ext.l	d1
	move.l	d1,d4
	lsr.w	#1,d1
	move.w	d3,d0
	sub.w	d2,d0
	addq.w	#1,d0
	ext.l	d0
	move.l	d0,d2
	lsl.w	#6,d0
	or.w	d0,d1
	move.w	#40,d0
	sub.w	d4,d0
	move.w	AYS,d3
	mulu.w	#40,d3
	move.l	d3,a1
	move.w	AXS,d3
	lsr.w	#4,d3
	mulu	#2,d3
	add.l	d3,a1
	add.l	TmpBmap,a1

WaitBlitReady:
	btst	#14,2(a6)
	bne.s	WaitBlitReady

	move.l	a1,$54(a6)
	move.l	#$01000002,$40(a6)
	move.w	d0,$66(a6)
	move.w	d1,$58(a6)

	movem.w	d0/d1,BlitMOD
	move.l	a1,BlitSTART

	move.w	#2,RPFlags1
	lea	AreaPoints,a4
	lea	AreaFlags,a5
	move.l	a4,NowAPoints
	move.l	a5,NowAFlags
	clr.b	d4
	moveq	#1,d5
	move.w	AreaCount,d2
	lea	LinePoints,a1

WaitBlitBMod:
	btst	#6,2(a6)
	bne.s	WaitBlitBMod
	move.w	#40,$60(a6)
	moveq	#-1,d4
	move.l	d4,$44(a6)
	move.l	#$ffff8000,$72(a6)

lbC000A1C
	bset	#0,RPFlags2
	movem.w	(a4)+,d0/d1
	btst	#0,(a5)+
	beq.s	lbC000A86
	tst.b	d4
	bne.s	lbC000A58
	cmp.w	CP_Y,d1
	ble.s	lbC000A54
	bclr	#0,RPFlags2
	bra.s	lbC000A7A
lbC000A54
	moveq	#1,d4
	bra.s	lbC000A7A
lbC000A58
	tst.b	d4
	ble.s	lbC000A6E
	cmp.w	CP_Y,d1
	bge.s	lbC000A6A
	bclr	#0,RPFlags2
	bra.s	lbC000A7A
lbC000A6A
	clr.b	d4
	bra.s	lbC000A7A
lbC000A6E
	cmp.w	CP_Y,d1
	bge.s	lbC000A78
	moveq	#1,d4
	bra.s	lbC000A7A
lbC000A78
	clr.b	d4
lbC000A7A
	bsr	LineDrawEntry
	tst.b	d5
	bge.s	lbC000AB8
	move.b	d4,d5
	bra.s	lbC000AB8
lbC000A86
	btst	#1,-1(a5)
	bne.s	lbC000AB4
;	cmp.b	d4,d5
;	bne.s	lbC000AB0
;	tst.b	d4
;	blt.s	lbC000AB0
;	bsr	WritePixel
lbC000AB0
	moveq	#-1,d4
	move.b	d4,d5
lbC000AB4
	movem.w	d0/d1,CP_X
	ori.w	#1,RPFlags1
	move.b	#$1f,RPLinPatC
lbC000AB8
	subq.w	#1,d2
	bne	lbC000A1C
	move.w	#-1,(a1)+

lbC000ABE
	btst.b	#6,2(a6)
	bne.s	lbC000ABE

	cmp.b	d4,d5
	bne.s	lbC000AE0
	tst.b	d4
	blt.s	lbC000AE0

	movem.w	CP_X,d0/d1
	move.l	TmpBmap,a0
	mulu.w	#40,d1
	add.l	d1,a0
	move.l	d0,d1
	lsr.w	#3,d0
	ext.l	d0
	add.l	d0,a0
	lsl.w	#3,d0
	sub.l	d0,d1
	moveq	#7,d0
	sub.w	d1,d0
	bchg.b	d0,(a0)

lbC000AE0
	move.w	BlitMOD,$64(a6)
	move.w	BlitMOD,$66(a6)
	move.l	BlitSTART,$50(a6)
	move.l	BlitSTART,$54(a6)
	move.l	#%00001001111100000000000000001010,$40(a6)
	move.w	BlitSIZE,$58(a6)

	lea	LinePoints,a1
	moveq	#-1,d4
	move.l	d4,$44(a6)
	move.w	#$ffff,$72(a6)
AfterLineLoop:
	btst	#6,2(a6)
	bne.s	AfterLineLoop
	cmp.w	#-1,(a1)
	beq.s	AfterLinesDone
	move.w	#$8000,$74(a6)
	move.w	#40,$60(a6)
	move.w	(a1)+,d4
	or.w	#%101111111010,d4
	move.w	d4,$40(a6)
	move.w	(a1)+,$62(a6)
	move.w	(a1)+,$52(a6)
	move.w	(a1)+,$64(a6)
	move.w	(a1)+,d4
	bclr	#1,d4
	move.w	d4,$42(a6)
	move.l	(a1),$48(a6)
	move.l	(a1)+,$54(a6)
	move.w	(a1)+,$58(a6)
	bra.s	AfterLineLoop

AfterLinesDone:
	clr.w	AreaCount
	movem.l	(a7)+,d2-d7/a2-a5
	rts

LineDrawEntry:
	movem.l	d2-d4/d7/a3,-(a7)
	movem.w	CP_X,d2/d3
	movem.w	d0/d1,CP_X
WaitLineBlitter:
	btst	#6,2(a6)
	bne.s	WaitLineBlitter
	moveq	#15,d4
	and.w	d2,d4
	lsl.w	#8,d4
	lsl.w	#4,d4
	move.w	d4,(a1)+
	or.w	#%101101101010,d4
	move.w	d4,$40(a6)

	sub.w	d2,d0
	blt.s	lbC0000CE
	beq	DrawLineNoAfterLine
	sub.w	d3,d1
	blt.s	lbC0000BE
	cmp.w	d0,d1
	bgt.s	lbC0000B8
	beq.s	apulbC1
	moveq	#$13,d7
	bra.s	lbC0000F0
apulbC1:
	subq.l	#2,a1
	bra	xbC0000B8
lbC0000B8
	moveq	#1,d7
	exg	d1,d0
	bra.s	lbC0000F0
lbC0000BE
	neg.w	d1
	cmp.w	d0,d1
	bgt.s	lbC0000C8
	beq.s	apulbC2
	moveq	#$1b,d7
	bra.s	lbC0000F0
apulbC2:
	subq.l	#2,a1
	bra	xbC0000C8
lbC0000C8
	moveq	#7,d7
	exg	d1,d0
	bra.s	lbC0000F0
lbC0000CE
	neg.w	d0
	sub.w	d3,d1
	blt.s	lbC0000E2
	cmp.w	d0,d1
	bgt.s	lbC0000DC
	beq.s	apulbC3
	moveq	#$17,d7
	bra.s	lbC0000F0
apulbC3:
	subq.l	#2,a1
	bra	xbC0000DC
lbC0000DC
	moveq	#$b,d7
	exg	d1,d0
	bra.s	lbC0000F0
lbC0000E2
	neg.w	d1
	cmp.w	d0,d1
	bgt.s	lbC0000EC
	beq.s	apulbC4
	moveq	#$1f,d7
	bra.s	lbC0000F0
apulbC4:
	subq.l	#2,a1
	bra	xbC0000EC
lbC0000EC
	moveq	#15,d7
	exg	d1,d0

lbC0000F0
	add.w	d1,d1
	move.w	d1,(a1)+
	move.w	d1,$0062(a6)	;4y
	sub.w	d0,d1
	bge.s	lbC000102
	or.w	#$40,d7
lbC000102
	move.w	d1,(a1)+
	move.w	d1,$0052(a6)	;2y-x
	sub.w	d0,d1
	move.w	d1,(a1)+
	move.w	d7,(a1)+
	move.w	d1,$0064(a6)	;4y-4x	
	move.w	d7,$0042(a6)	;con1

	move.w	d2,d4

	mulu.w	#40,d3
	asr.w	#3,d2		;x/8
	ext.l	d2
	add.l	d2,d3		;koko
	add.l	TmpBmap,d3
	move.l	d3,(a1)+
	move.l	d3,$0048(a6)
	move.l	d3,$0054(a6)

	asl.w	#6,d0
	add.w	#66,d0

	bclr	#0,RPFlags2
	bne.s	lbChangePoint
	and.w	#15,d4
	moveq	#15,d1
	sub.w	d4,d1
	move.l	d3,a3
	bchg	d1,(a3)
lbChangePoint:

	move.w	d0,(a1)+
	move.w	d0,$0058(a6)

	movem.l	(a7)+,d2-d4/d7/a3
	rts

DrawLineNoAfterLine:
	subq.l	#2,a1
	sub.w	d3,d1
	blt.s	xbC0000BE
	cmp.w	d0,d1
	bge.s	xbC0000B8
	moveq	#$13,d7
	bra.s	xbC0000F0
xbC0000B8
	moveq	#1,d7
	exg	d1,d0
	bra.s	xbC0000F0
xbC0000BE
	neg.w	d1
	cmp.w	d0,d1
	bge.s	xbC0000C8
	moveq	#$1b,d7
	bra.s	xbC0000F0
xbC0000C8
	moveq	#7,d7
	exg	d1,d0
	bra.s	xbC0000F0
xbC0000CE
	neg.w	d0
	sub.w	d3,d1
	blt.s	xbC0000E2
	cmp.w	d0,d1
	bge.s	xbC0000DC
	moveq	#$17,d7
	bra.s	xbC0000F0
xbC0000DC
	moveq	#$b,d7
	exg	d1,d0
	bra.s	xbC0000F0
xbC0000E2
	neg.w	d1
	cmp.w	d0,d1
	bge.s	xbC0000EC
	moveq	#$1f,d7
	bra.s	xbC0000F0
xbC0000EC
	moveq	#15,d7
	exg	d1,d0

xbC0000F0
	add.w	d1,d1
	move.w	d1,$0062(a6)	;4y
	sub.w	d0,d1
	bge.s	xbC000102
	or.w	#$40,d7
xbC000102
	move.w	d1,$0052(a6)	;2y-x
	sub.w	d0,d1
	move.w	d1,$0064(a6)	;4y-4x	
	move.w	d7,$0042(a6)	;con1

	move.w	d2,d4

	mulu.w	#40,d3
	asr.w	#3,d2		;x/8
	ext.l	d2
	add.l	d2,d3		;koko
	add.l	TmpBmap,d3
	move.l	d3,$0048(a6)
	move.l	d3,$0054(a6)

	asl.w	#6,d0
	add.w	#66,d0

	bclr	#0,RPFlags2
	bne.s	xbChangePoint
	and.w	#15,d4
	moveq	#15,d1
	sub.w	d4,d1
	move.l	d3,a3
	bchg	d1,(a3)
xbChangePoint:

	move.w	d0,$0058(a6)

	movem.l	(a7)+,d2-d4/d7/a3
	rts

