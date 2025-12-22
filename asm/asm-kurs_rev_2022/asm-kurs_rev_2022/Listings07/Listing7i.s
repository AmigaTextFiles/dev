
; Listing7i.s	HORIZONTALER SCROLL EINES SPRITES IN 1-PIXEL-SCHRITTEN, UND
;				NICHT MEHR IN 2-PIXEL-SCHRITTEN, WIE FRÜHER. DAMIT WIRKT DER
;				SCROLL NICHT MEHR SO RUCKELIG

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Libname
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf das "leere" PIC

	MOVE.L	#BITPLANE,d0	; wohin pointen
	LEA	BPLPOINTERS,A1		; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Pointen auf den Sprite

	MOVE.L	#MEINSPRITE,d0	; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106

mouse:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	bne.s	mouse

	bsr.s	BewegeSpriteX	; Bewege den Sprite 0 horizontal (FLÜßIG)
	bsr.w	BewegeSpriteY	; Bewege den Sprite 0 vertikal

Warte:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse


	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)			; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0


; Diese Routine bewegt den Sprite horizontal, indem sie auf das Byte HSTART
; und das Bit 0 im vierten Kontrollbyte zugreift, also dem niederwertigen Bit
; von HSTART. Somit erfolgt ein horizontaler Scroll in Schritten zu einem Pixel
; anstatt 2, seine Bewegung ist schöner und das Ruckeln aus den vorigen
; Beispielen verschwindet.
; Die Routine, die die Koordinaten in HSTART+Bit verwandelt kann in
; allen Listings verwendet werden, die Sprites bewegen, es ist auch der
; Videooffset miteinbezogen (+$40*2, mit einem add.w #128,d0), damit können
; der Routine schon die realen Werte für einen Lowres-Screen übergeben werden.
; Mit einem 0 wird sich der Sprite ganz links positionieren, mit 160 in der
; Mitte und mit 320 ganz rechts.


BewegeSpriteX:
	ADDQ.L	#2,TABXPOINT		; Pointe auf das nächste Word
	MOVE.L	TABXPOINT(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABX-2,A0		; sind wir beim letzten Word der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann weiter
	MOVE.L	#TABX-2,TABXPOINT	; beginne beim ersten Word-2
NOBSTARTX:
	moveq	#0,d0				; löschen d0
	MOVE.w	(A0),d0				; setzen den Wert der Tabelle in d0
	add.w	#128,D0				; 128 - um den Sprite zu zentrieren.
	btst	#0,D0				; niederw. Bit der X-Koordinate auf 0?
	beq.s	NiederBitNull
	bset	#0,MEINSPRITE+3		; setzen das niederw. Bit von HSTART
	bra.s	PlaceCoords

NiederBitNull:
	bclr	#0,MEINSPRITE+3		; löschen das niederw. Bit von HSTART
PlaceCoords:
	lsr.w	#1,D0				; SHIFTEN, verschieben den Wert von HSTART um
								; 1 Bit nach Rechts, um es in den Wert zu
								; "verwandeln", der dann in HSTART kommt, also
								; ohne dem niederwertigen Bit.
	move.b	D0,HSTART			; geben den Wert XX ins Byte HSTART
	rts

TABXPOINT:
	dc.l	TABX-2			; Bemerke: die Werte in der Tabelle sind hier Word


; Tabelle mit vorausberechneten X-Koordinaten. Diese Tabelle enthält die REALEN
; Werte der Koordinaten auf dem Bildschirm, nicht die "halbierten" Werte für
; den ruckeligen Scroll zu 2 Pixel auf einmal, wie wir ihn bis jetzt gesehen
; haben.
; Da Werte über 256 möglich sind, wird die Größe eines Byte überschritten,
; deswegen ist die Tabelle aus Word zusammengesetzt, denn sie können diese
; Werte beinhalten.
; Die Routine "BewegeSpriteX" kümmert sich darum, die Word aus der
; Tabelle zu holen und sie in NIEDERWERTIGES BIT und HOCHWERTIGES BYTE
; zu unterteilen. Das niederwertige Bit dient zum flüssigen Scroll, da es die
; 2 Pixel ersetzt und Scrolls zu 1 Pixel ermöglicht.
; Zu Beachten ist, daß die X-Position des Sprites zwischen 0 und 320 liegen
; muß, wenn wir ihn ins Videofenster bekommen wollen, mit einem Offset von
; 128 ($40*2). Dieser wird von der Routine dazugefügt.
; Wir müssen uns auch erinnern, daß ein Sprite 16 Pixel breit ist, und sich
; seine X-Koordinate auf die linke Ecke bezieht. Wenn wir also Koordianten
; eingeben, die größer sind als 320-16, oder 304, dann wird der Sprite
; teilweise außerhalb des Bildschirmes liegen.
; In der Tabelle sind in der Tat nur Werte zwischen 0 und 304 enthalten.


; So erhält man die Tabelle:

;							  ___304
; DEST> tabx			     /   \ 152 (304/2)
; BEG> 0				\___/	  0
; END> 360
; AMOUNT> 150
; AMPLITUDE> 304/2		; Amplitude sowohl über als auch unter NULL, also
						; müssen wir die Hälfte über NULL und die Hälfte darunter
						; haben, anders ausgedrückt die AMPLITUDE durch 2 teilen.
; YOFFSET> 304/2		; dann alles hinaufschieben, um 152 in 0 zu verwandeln
; SIZE (B/W/L)> w
; MULTIPLIER> 1

TABX:
	incbin	"/Sources/xcoordinatok.tab"	; 150 .W Werte
ENDETABX:

; Diese Routine bewegt den Sprite nach oben und unten, indem sie auf die Byte
; VSTART und VSTOP zugreift, also auf die Y-Position des Sprite.  Es werden
; schon vorausberechnete Werte eingegeben (aus Tabelle TABY)

BewegeSpriteY:
	ADDQ.L	#1,TABYPOINT		; Point auf das nächste Byte
	MOVE.L	TABYPOINT(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Longword der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann weiter
	MOVE.L	#TABY-1,TABYPOINT	; Starte wieder beim ersten Byte (-1)
NOBSTARTY:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0				; kopiere das Byte aus der Tabelle in d0
	MOVE.b	d0,VSTART			; kopiere das Byte in VSTART VSTART
	ADD.B	#13,D0				; Zähle die Länge des Sprite dazu,
								; um die Endposition zu errechnen (VSTOP)
	move.b	d0,VSTOP			; Setze den richtigen Wert in VSTOP
	rts

TABYPOINT:
	dc.l	TABY-1			; BEMERKE: Die Werte in der Tabelle sind hier
							; Bytes, wir arbeiten also mit einem ADDQ.L #1,
							; TABYPOINT, und nicht #2 wie bei den Words
							; oder #4 bei den Longwords.


; Tabelle mit vorausberechneten Y-Koordinaten.
; Zu Bemerken, daß die Y-Position des Sprites zwischen $2c und $f2 liegen muß,
; wenn wir ihn in das Videofenster bekommen wollen. In der Tabelle sind alles
; Werte enthalten, die innerhalb dieses Limits liegen.

TABY:
	dc.b	$8E,$91,$94,$97,$9A,$9D,$A0,$A3,$A6,$A9,$AC,$AF ; Wellen,
	dc.b	$B2,$B4,$B7,$BA,$BD,$BF,$C2,$C5,$C7,$CA,$CC,$CE ; 200 Werte
	dc.b	$D1,$D3,$D5,$D7,$D9,$DB,$DD,$DF,$E0,$E2,$E3,$E5
	dc.b	$E6,$E7,$E9,$EA,$EB,$EC,$EC,$ED,$EE,$EE,$EF,$EF
	dc.b	$EF,$EF,$F0,$EF,$EF,$EF,$EF,$EE,$EE,$ED,$EC,$EC
	dc.b	$EB,$EA,$E9,$E7,$E6,$E5,$E3,$E2,$E0,$DF,$DD,$DB
	dc.b	$D9,$D7,$D5,$D3,$D1,$CE,$CC,$CA,$C7,$C5,$C2,$BF
	dc.b	$BD,$BA,$B7,$B4,$B2,$AF,$AC,$A9,$A6,$A3,$A0,$9D
	dc.b	$9A,$97,$94,$91,$8E,$8B,$88,$85,$82,$7F,$7C,$79
	dc.b	$76,$73,$70,$6D,$6A,$68,$65,$62,$5F,$5D,$5A,$57
	dc.b	$55,$52,$50,$4E,$4B,$49,$47,$45,$43,$41,$3F,$3D
	dc.b	$3C,$3A,$39,$37,$36,$35,$33,$32,$31,$30,$30,$2F
	dc.b	$2E,$2E,$2D,$2D,$2D,$2D,$2C,$2D,$2D,$2D,$2D,$2E
	dc.b	$2E,$2F,$30,$30,$31,$32,$33,$35,$36,$37,$39,$3A
	dc.b	$3C,$3D,$3F,$41,$43,$45,$47,$49,$4B,$4E,$50,$52
	dc.b	$55,$57,$5A,$5D,$5F,$62,$65,$68,$6A,$6D,$70,$73
	dc.b	$76,$79,$7C,$7F,$82,$85,$88,$8b
ENDETABY:


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$38			; DdfStart
	dc.w	$94,$d0			; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

	dc.w	$180,$000		; Color0	; Hintergrund Schwarz
	dc.w	$182,$123		; Color1	; Farbe 1 des Bitplane, die
							; in diesem Fall leer ist,
							; und deswegen nicht erscheint

	dc.w	$1A2,$F00		; Color17, oder COLOR1 des Sprite0 - ROT
	dc.w	$1A4,$0F0		; Color18, oder COLOR2 des Sprite0 - GRÜN
	dc.w	$1A6,$FF0		; Color19, oder COLOR3 des Sprite0 - GELB

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier ist der Sprite: NATÜRLICH muß er in CHIP RAM sein! ********

MEINSPRITE:		; Länge 13 Zeilen
VSTART:
	dc.b $50	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP:
	dc.b $5d	; $50+13=$5d	- Vertikale Endposition des Sprite
	dc.b $00
 dc.w	%0000000000000000,%0000110000110000 ; Binäres Format für ev. Änderungen
 dc.w	%0000000000000000,%0000011001100000
 dc.w	%0000000000000000,%0000001001000000
 dc.w	%0000000110000000,%0011000110001100 ; BINÄR 00=COLOR 0 (DURCHSICHTIG)
 dc.w	%0000011111100000,%0110011111100110 ; BINÄR 10=COLOR 1 (ROT)
 dc.w	%0000011111100000,%1100100110010011 ; BINÄR 01=COLOR 2 (GRÜN)
 dc.w	%0000110110110000,%1111100110011111 ; BINÄR 11=COLOR 3 (GELB)
 dc.w	%0000011111100000,%0000011111100000
 dc.w	%0000011111100000,%0001111001111000
 dc.w	%0000001111000000,%0011101111011100
 dc.w	%0000000110000000,%0011000110001100
 dc.w	%0000000000000000,%1111000000001111
 dc.w	%0000000000000000,%1111000000001111
 dc.w	0,0		; 2 word auf NULL definieren das Ende des Sprite.


	SECTION LEERESPLANE,BSS_C ; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end
