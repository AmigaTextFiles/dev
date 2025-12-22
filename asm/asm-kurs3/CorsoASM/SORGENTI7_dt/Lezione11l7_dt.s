
; Lezione11l7.s		8 sprites attacched (daher 4 bis 16 Farben) verwendet,
				; 128 mal pro Zeile "wiederverwendet".

	SECTION	MegaRiuso,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110100000	; copper,bitplane,sprites
;			 -----a-bcdefghij

Waitdisk	EQU	30

NumeroLinee	=	128
LungSpr		=	NumeroLinee*8

START:

; Zeiger sprites

	MOVE.L	#SpritesBuffer,d0
	LEA	SPRITEPOINTERS,A1
	MOVEQ	#8-1,D1			; Anzahl sprites = 8
POINTB:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	add.l	#LungSpr,d0		; Spritelänge
	addq.w	#8,a1
	dbra	d1,POINTB		; wiederhole d1 mal

; Wir zeigen auf die genullten Bitplane

	MOVE.L	#PLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	bsr.s	CreaSprites	; Routine, die die 4 angehängten Sprites erstellt,
						; dh alle 8 Sprites, hergestellt aus
						; 128 Wiederholungen je 1 Zeile!

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites
	move.l	#COPPER,$80(a5)		; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2	; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $010
	BNE.S	Waity1

	btst	#2,$16(A5)	; rechte Maustaste gedrückt?
	beq.s	NonOndegg

	bsr.w	OndeggiaSpriteS	; bewegt die 8 wiederverwendeten Sprites

NonOndegg:
	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts

; ****************************************************************************
; Routine, die die 8 Sprites (d.h. 4 attached) im "SpritesBuffer" erstellt.
; Beachte, dass die attached Sprites wiederum 2 zu 2 flankiert werden,
; um 2 Balken 16*2=32 Pixel breit und 16 Farben zu erhalten.
; Zuerst müssen wir daran denken, dass jedes Sprite "wiederverwendet" werden kann,
; das heißt "unter" einem Sprite, nach dem Ende des Sprites kann man
; ein anderes Sprite setzen, solange eine vertikale Position "leere" Zeile
; am Anfang stehen bleibt. Wir setzen das hier massiv ein. Tatsächlich
; ist jede Wiederverwendung des Sprites 1 Zeile, also bekommen wir eine Zeile.
; vertikaler Streifen (16 Pixel breit) aus vielen "Spritini", eine Zeile hoch
; durch eine "leere" Zeile getrennt. Für 256 vertikalen Zeilen des
; Bildschirms machen wir 128 Verwendungen für jedes Sprite! Aber wenigstens können 
; wir sie in der Zeile "biegen" so viel wie wir wollen, da jeder Streifen eine
; eigene unabhängige HSTART (horizontale Position) hat.
;
; Wir erinnern uns an die Struktur eines Sprites:
;
;VSTART:
;	dc.b xx			; Pos. vertikal (von $2c bis $f2)
;HSTART:
;	dc.b xx+(xx)	; Pos. horizontal (von $40 bis $d8)
;VSTOP:
;	dc.b xx			; Ende vertikal.
;	dc.b $00		; byte spezial: bit 7 für ATTACCHED!!
;	dc.l	XXXXX	; bitplane Sprite (Zeichnung!) hier 1 Zeile
;	dc.w	0,0		; 2 word zurückgesetzt für ENDE SPRITE, dass wir hier setzen
;					; Niemals ... also hier wird es schon den VSTART und den 
;					; VSTOP des nächsten Sprites geben!
;
; 4 bytes -> Steuerwörter + 4 bytes -> Figur (1 Streifen)
; 4*2= 8 -> Länge eines Sprites; 8*128 = 1024, Länge 1 Sprite.
; Wir machen 128 Wiederverwendungen von jedem Sprite: 2 Zeilen pro sprite = 256 Zeilen!
;
; ****************************************************************************

; 1024 bytes (8*128) pro sprite

CreaSprites:
	lea	SpritesBuffer,A0			; Ziel
	move.l	#%10000000,D5			; bit 7 gesetzt - für attached in sprite+3
	moveq	#$2c,D0					; VSTART - anfangen von $2c
CreaLoop:
	move.b	d0,(A0)					; Setze den vstart auf die 8 Sprites
	move.b	d0,LungSpr(A0)			; 2 (Jedes Sprite ist 2400 bytes lang)
	move.b	d0,LungSpr*2(A0)		; 3
	move.b	d0,LungSpr*3(A0)		; 4
	move.b	d0,LungSpr*4(A0)		; 5
	move.b	d0,LungSpr*5(A0)		; 6
	move.b	d0,LungSpr*6(A0)		; 7
	move.b	d0,LungSpr*7(A0)		; 8

	move.l	d0,D1
	addq.w	#1,D1		; VSTART 1 Zeile darunter -> Lass es uns als VSTOP verwenden

	move.b	d1,2(A0)				; Setze den vstop auf die 8 Sprites
	move.b	d1,LungSpr+2(A0)		; 2 (Jedes Sprite ist 2400 Bytes lang.)
	move.b	d1,(LungSpr*2)+2(A0)	; 3
	move.b	d1,(LungSpr*3)+2(A0)	; 4
	move.b	d1,(LungSpr*4)+2(A0)	; 5
	move.b	d1,(LungSpr*5)+2(A0)	; 6
	move.b	d1,(LungSpr*6)+2(A0)	; 7
	move.b	d1,(LungSpr*7)+2(A0)	; 8

; Wir setzen die Bits, die an die 8 Sprites angehängt sind

	move.b	d5,3(A0)			; Setze das spezifizierte Byte. zu den 8 Sprites
	move.b	d5,LungSpr+3(A0)	; 2 (Jedes Sprite ist 2400 bytes lang)
	move.b	d5,(LungSpr*2)+3(A0)	; 3
	move.b	d5,(LungSpr*3)+3(A0)	; 4
	move.b	d5,(LungSpr*4)+3(A0)	; 5
	move.b	d5,(LungSpr*5)+3(A0)	; 6
	move.b	d5,(LungSpr*6)+3(A0)	; 7
	move.b	d5,(LungSpr*7)+3(A0)	; 8

	addq.w	#4,A0				; überspringe die 2 Steuerwörter
								; und lass uns zu den Sprite-planes gehen!

	move.l	#$55553333,(A0)				; 1 \ Verlaufslinie setzen
	move.l	#$0f0f00ff,LungSpr(A0)		; 2 / attacched 1!

	move.l	#$aaaacccc,LungSpr*2(A0)	; 3 \ attacched 2!
	move.l	#$f0f0ff00,LungSpr*3(A0)	; 4 /

	move.l	#$55553333,LungSpr*4(A0)	; 5 \ attacched 3!
	move.l	#$0f0f00ff,LungSpr*5(A0)	; 6 /

	move.l	#$aaaacccc,LungSpr*6(A0)	; 7 \ attacched 4!
	move.l	#$f0f0ff00,LungSpr*7(A0)	; 8 /

	addq.w	#4,A0			; überspringe die 2 Wörter der plane,
				; zum nächsten gehen
				; 2 Steuerwörter seit
				; Es wurden keine 2 Wörter zurückgesetzt
				; Ende Sprite.

	cmp.b	#%10000110,D5	; sind wir unter der Zeile $FF?
	beq.s	SiamoSottoFF
	addq.b	#2,D0		; vstart 2 Zeilen unten für die nächste
				; Wiederverwendung des Sprites. Vorausgesetzt, dass jeder
				; Sprite 1 Zeile hoch ist und das zwischen einem
				; verwendeten und einem anderen
				; eine leere Zeile sein muss, addiere 2.
	bne.w	CreaLoop	; sind wir angekommen bei $fe+2 = $00?
				; wenn ja, müssen wir das hohe Bit von 
				; vstart und vstop einstellen. Sonst mach weiter

	move.b	#%10000110,D5	; %10000110 -> setze die 2 hohen Bits von vstart
						; und vstop unter die Zeile $FF gehen 
	subq.b	#2,D0		; wir gehen einen Schritt zurück...

SiamoSottoFF:
	addq.b	#2,D0		; vstart 2 Zeilen unten...
	cmpi.b	#$2c,D0		; sind wir bei Position $FF+$2c?
	bne.w	CreaLoop	; wenn noch nicht, mach weiter!
	rts

; ****************************************************************************

; Parameter per "IS"

; BEG> 0
; END> 360
; AMOUNT> 250
; AMPLITUDE> $20
; YOFFSET> $20
; SIZE (B/W/L)> b
; MULTIPLIER> 1

SinTabHstarts:
 dc.B	$20,$21,$22,$23,$24,$24,$25,$26,$27,$28,$28,$29,$2A,$2B,$2B,$2C
 dc.B	$2D,$2E,$2E,$2F,$30,$30,$31,$32,$32,$33,$34,$34,$35,$36,$36,$37
 dc.B	$37,$38,$38,$39,$39,$3A,$3A,$3B,$3B,$3C,$3C,$3C,$3D,$3D,$3D,$3E
 dc.B	$3E,$3E,$3F,$3F,$3F,$3F,$3F,$40,$40,$40,$40,$40,$40,$40,$40,$40
 dc.B	$40,$40,$40,$40,$40,$40,$3F,$3F,$3F,$3F,$3F,$3E,$3E,$3E,$3D,$3D
 dc.B	$3D,$3C,$3C,$3C,$3B,$3B,$3A,$3A,$39,$39,$38,$38,$37,$37,$36,$36
 dc.B	$35,$34,$34,$33,$32,$32,$31,$30,$30,$2F,$2E,$2E,$2D,$2C,$2B,$2B
 dc.B	$2A,$29,$28,$28,$27,$26,$25,$24,$24,$23,$22,$21,$20,$20,$1F,$1E
 dc.B	$1D,$1C,$1C,$1B,$1A,$19,$18,$18,$17,$16,$15,$15,$14,$13,$12,$12
 dc.B	$11,$10,$10,$0F,$0E,$0E,$0D,$0C,$0C,$0B,$0A,$0A,$09,$09,$08,$08
 dc.B	$07,$07,$06,$06,$05,$05,$04,$04,$04,$03,$03,$03,$02,$02,$02,$01
 dc.B	$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 dc.B	$00,$00,$00,$01,$01,$01,$01,$01,$02,$02,$02,$03,$03,$03,$04,$04
 dc.B	$04,$05,$05,$06,$06,$07,$07,$08,$08,$09,$09,$0A,$0A,$0B,$0C,$0C
 dc.B	$0D,$0E,$0E,$0F,$10,$10,$11,$12,$12,$13,$14,$15,$15,$16,$17,$18
 dc.B	$18,$19,$1A,$1B,$1C,$1C,$1D,$1E,$1F,$20
FinTab:

TabLunghezz	= FinTab-SinTabHstarts

OndeggiaSpriteS:
	addq.b	#1,Barra1OffSalv
	moveq	#0,D0
	move.b	Barra1OffSalv(pc),D0
	cmp.w	#TabLunghezz,D0		; haben wir den maximalen offset?
	bne.s	NonRipartireO1
	clr.b	Barra1OffSalv		; von vorne anfangen
NonRipartireO1:
	addq.b	#2,Barra2OffSalv
	moveq	#0,D0
	move.b	Barra2OffSalv(pc),D0
	cmp.w	#TabLunghezz,D0
	bne.s	NonRipartireO2
	clr.b	Barra2OffSalv		; von vorne anfangen
NonRipartireO2:
	moveq	#0,D1
	moveq	#0,D2
	moveq	#0,D3
	moveq	#0,D4
	moveq	#0,D5
	lea	SpritesBuffer,A0		; Adresse erstes sprite
	lea	SinTabHstarts(PC),A1
	move.b	Barra1OffSalv(pc),D0
	move.b	Barra2OffSalv(pc),D2
	move.b	0(A1,D0.w),D5		; von sintab zweiter Barra1OffSalv
OndeggiaLoop:
	move.b	0(A1,D0.w),D3		; von sintab - für Balken 1
	move.b	0(A1,D2.w),D4		; von sintab - für Balken 2

; bearbeite alles

	add.b	D4,D3	; Balken 1
	sub.b	D5,D3	; 

	add.b	D5,D4	; Balken 2

	add.b	#105,D3	; mittlere Balken 1
	add.b	#75,D4	; mittlere Balken 2

; Ändern Sie den HSTART (horizontale Position) der 8 Sprites

; ** erster Balken

	move.b	D3,1(A0)			; sprite 1
	move.b	D3,LungSpr+1(A0)	; 2

; jetzt das angehängte Sprite desselben Balkens, aber nebeneinander (16 Pixel später)

	addq.w	#8,D3			; addiere 8, oder 16 pixel,
							; HSTART addiere 2 jedes Mal
	move.b	D3,(LungSpr*2)+1(A0)	; 3
	move.b	D3,(LungSpr*3)+1(A0)	; 4

; ** zweiter Balken

	move.b	D4,(LungSpr*4)+1(A0)	; 5
	move.b	D4,(LungSpr*5)+1(A0)	; 6

	addq.w	#8,D4			; addiere 8, oder 16 pixel,
							; HSTART addiere 2 jedes Mal
	move.b	D4,(LungSpr*6)+1(A0)	; 7
	move.b	D4,(LungSpr*7)+1(A0)	; 8

	addq.w	#1,D2			; nächster Versatz - Balken 2...
	cmpi.w	#TabLunghezz,D2	; sind wir am Maximum?
	bne.s	Nonrestart2
	moveq	#0,D2			; Lesen Sie den ersten Wert erneut...
Nonrestart2:
	addq.w	#1,D0			; nächster Versatz - Balken 1
	cmp.w	#TabLunghezz,D0	; sind wir am Maximum?
	bne.s	Nonrestart1
	moveq	#0,D0			; Lesen Sie den ersten Wert erneut
Nonrestart1:
	addq.w	#8,A0			; Fahren Sie mit der nächsten Wiederverwendung von Sprites fort

	cmpa.l	#SpritesBuffer+LungSpr,a0 ; sind wir am Ende?
	bne.s	OndeggiaLoop
	rts

Barra1OffSalv:
	dc.w	0
Barra2OffSalv:
	dc.w	0


; ****************************************************************************
;				COPPERLIST
; ****************************************************************************

	section	baucoppe,data_c

COPPER:
	dc.w	$8e,$2c81	; diwstart
	dc.w	$90,$2cc1	; diwstop
	dc.w	$92,$38		; ddfstart
	dc.w	$94,$d0		; ddfstop

SPRITEPOINTERS:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0,$12a,0,$12c,0,$12e,0
	dc.w	$130,0,$132,0,$134,0,$136,0,$138,0,$13a,0,$13c,0,$13e,0

	dc.w	$108,0	; bpl1mod
	dc.w	$10a,0	; bpl2mod
	dc.w	$102,0	; bplcon1
	dc.w	$104,0	; bplcon2

BPLPOINTERS:
	dc.w	$e0,0,$e2,0	; plane 1

	dc.w	$100,$1200	; bplcon0 - 1 plane lowres

	dc.w	$180,0		; color0 - schwarz
	dc.w	$182,$fff	; color1 - weiß

; Sprite-Farben (attacched) - von Farbe17 bis Farbe31

	dc.w	$1a2,$010,$1a4,$020,$1a6,$030
	dc.w	$1a8,$140,$1aa,$250,$1ac,$360,$1ae,$470
	dc.w	$1b0,$580,$1b2,$690,$1b4,$7a0,$1b6,$8b0
	dc.w	$1b8,$9c0,$1ba,$ad0,$1bc,$be0,$1be,$cf0

	dc.w	$ffff,$fffe	; Ende copperlist

; ****************************************************************************

	section	grafica,bss_C

SpritesBuffer:
	DS.B	LungSpr*8	; 1024 bytes jedes Mega-Sprite

; ****************************************************************************

plane:
	ds.b	40*256	; 1 plane lowres "schwarz" wie Hintergrund.

	END

