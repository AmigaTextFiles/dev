
; Listing7n.s - Beispiel der Applikation der Universalroutine:
;				ein Sprite, der abprallt

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
	cmpi.b	#$aa,$dff006	; Zeile $aa?
	bne.s	mouse
	
	btst	#2,$dff016
	beq.s	Warte

	bsr.w	BewegeSprite	; bewege Sprite

Warte:
	cmpi.b	#$aa,$dff006	; Zeile $aa?
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

; Diese Routine ändert die Koordinaten des Sprite, indem sie eine kostante
; Geschwindigkeit sowohl vertikal als auch horizontal dazuzählt. Weiters,
; wenn der Sprite einen Rand berührt, wird die Richtung invertiert.
; Um diese Routine zu verstehen muß man die Anweisung "NEG" kennen:
; Sie verwandelt eine positive Zahl in eine negative und umgekehrt.

BewegeSprite:
	move.w	sprite_y(PC),d0		; lies die alte Position
	add.w	speed_y(PC),d0		; zähle Geschwindigkeit dazu
	btst	#15,d0				; Wenn Bit 15 gesetzt ist, dann ist die
								; Zahl negativ. Ist sie das geworden?
	beq.s	Nicht_angehen_oben	; wenn >0, dann ist alles gut
	neg.w	speed_y				; wenn <0, dann haben wir den oberen Rand
								; berührt also invertiere die Richtung
	bra.s	BewegeSprite		; errechne die neue Position

Nicht_angehen_oben:
	cmp.w	#243,d0				; wenn die Position 256-13=243 ist, dann
								; berührt der Sprite den unteren Rand
	blo.s	Nicht_angehen_unten
	neg.w	speed_y				; wenn der Sprite den unteren Rand berührt,
								; invertiere die Geschwindigkeit
	bra.s	BewegeSprite		; errechne die neue Position

Nicht_angehen_unten:
	move	d0,sprite_y			; erneuere die Position
Pos_x:
	move.w	sprite_x(PC),d1		; lies die alte Position
	add.w	speed_x(PC),d1		; zähle Geschwindigkeit dazu
	btst	#15,d0				; Wenn das Bit 15 gesetzt ist, dann ist die
								; Zahl negativ. Ist sie das geworden?
	beq.s	Nicht_angehen_links
	neg.w	speed_x				; wenn <0 dann berührt er den linken Rand:
								; invertiere die Richtung
	bra.s	Pos_x				; errechne die neue hor. Position

Nicht_angehen_links:
	cmp.w	#304,d1				; wenn die Position 320-16=304 ist, dann
								; berührt der Sprite den rechten Rand
	blo.s	Nicht_angehen_rechts
	neg.w	speed_x				; wenn er rechts anstoßt, invertiere die Richtung
	bra.s	Pos_x				; errechne die neue hor. Position

Nicht_angehen_rechts:
	move.w	d1,sprite_x			; erneuere die Position

	lea	MEINSPRITE,a1			; Adresse Sprite
	moveq	#13,d2				; Höhe Sprite
	bsr.s	UniMoveSprite		; Führt die UniversalRoutine aus, die
								; den Sprite positioniert
	rts

SPRITE_Y:
		dc.w	10				; Position Sprite
SPRITE_X:
		dc.w	0
SPEED_Y:
		dc.w	-4				; Geschwindigkeit Sprite
SPEED_X:
		dc.w	3

; Universelle Routine zum Positionieren der Sprites

;	Eingangsparameter von UniMoveSprite:
;
;	a1 = Adresse des Sprite
;	d0 = Vertikale Position des Sprite auf dem Screen (0-255)
;	d1 = Horizontale Position des Sprite auf dem Screen (0-320)
;	d2 = Höhe des Sprite
;
UniMoveSprite:
; Vertikale Positionierung

	ADD.W	#$2c,d0	 ; zähle den Offset vom Anfang des Screens dazu

; a1 enthält die Adresse des Sprite

	MOVE.b	d0,(a1)			; kopiert das Byte in VSTART
	btst.l	#8,d0
	beq.s	NichtVSTARTSET
	bset.b	#2,3(a1)		; Setzt das Bit 8 von VSTART (Zahl > $FF)
	bra.s	ToVSTOP
NichtVSTARTSET:
	bclr.b	#2,3(a1)		; Löscht das Bit 8 von VSTART (Zahl < $FF)
ToVSTOP:
	ADD.w	D2,D0			; Zähle die Höhe des Sprite dazu, um
							; die Endposition zu errechnen (VSTOP)
	move.b	d0,2(a1)		; Setze den richtigen Wert in VSTOP
	btst.l	#8,d0
	beq.s	NichtVSTOPSET
	bset.b	#1,3(a1)		; Setzt Bit 8 von VSTOP (Zahl > $FF)
	bra.w	VVSTOPENDE
NichtVSTOPSET:
	bclr.b	#1,3(a1)		; Löscht Bit 8 von VSTOP (Zahl < $FF)
VVSTOPENDE:

; horizontale Positionierung

	add.w	#128,D1			; 128 - um den Sprite zu zentrieren
	btst	#0,D1			; niederwert. Bit der X-Koordinate auf 0?
	beq.s	NiederBitNull
	bset	#0,3(a1)		; Setzen das niederw. Bit von HSTART
	bra.s	PlaceCoords

NiederBitNull:
	bclr	#0,3(a1)		; Löschen das niederw. Bit von HSTART
PlaceCoords:
	lsr.w	#1,D1			; SHIFTEN, verschieben den Wert von HSTART um
							; 1 Bit nach Rechts, um es in den Wert zu
							; "verwandeln", der dann in HSTART kommt, also
							; ohne dem niederwertigen Bit.
	move.b	D1,1(a1)		; geben den Wert XX ins Byte HSTART
	rts



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
	dc.w	$100,%0001001000000000	; Bit 12 an!! 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste	Bitplane

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
	dc.b $50	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
	dc.b $90	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
	dc.b $5d	; $50+13=$5d	; Vertikale Endposition des Sprite
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


	SECTION LEERESPLANE,BSS_C	; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

In diesem Beispiel zeigen wir eine  andere  Methode,  um  die  Sprites  zu
bewegen,  ohne  Tabellen.  In  diesem  Listing  bewegt  sich  ein  Sprite
geradlinig mit konstanter Geschwindigkeit, sowohl in vertikaler  als  auch
in  horizontaler Richtung. Die Geschwindigkeit ist nichts anderes als eine
Zahl, die sich in einer Speicherzelle befindet, die jedesmal zur  Position
dazugezählt  wird,  die der Sprite vorher hatte, und errechnet so die neue
Position. Wenn die Geschwindigkeit eine positive Zahl war, dann  wird  die
Position  des  Sprites  jedesmal  erhöht, und somit nach rechts verschoben
(oder nach Unten, im Falle der Y-Achse).
Wenn der Sprite einen Rand berührt, ist es notwendig,  seine  Richtung  zu
ändern. Um das zu tun reicht es aus, das Vorzeichen der Geschwindigkeit zu
invertieren,  und  sie  so  von  Positiv  in  Negativ  umzuschalten  oder
umgekehrt.  Darum  kümmert  sich  der  Befehl "NEG", der genau das tut: er
ändert das Vorzeichen einer Zahl, die sich in einem  Register  oder  einer
Speicherzelle befindet.

