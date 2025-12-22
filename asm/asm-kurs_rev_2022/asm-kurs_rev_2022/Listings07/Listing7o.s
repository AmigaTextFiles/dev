
; Listing7o.s - Beispiel einer Anwendung der Universalroutine:
;				zwei Sprites werden von der selben Routine bewegt

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

	addq.l	#8,a1
	MOVE.L	#MEINSPRITE2,d0	 ; Adresse des Sprite in d0
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

; Diese Routine liest aus den zwei Tabellen die realen Koordinaten der Sprite.
; Also die X-Koordinate, die von 0 bis 320 geht, und die Y, von 0 bis 256
; (ohne Overscan). Da wir in diesem Beispiel kein Overscan verwenden ist die
; Koordinatentabelle für die Y-Positionen aus Byte erstellt. Die Tabelle für
; die X-Koordinaten hingegen besteht aus Word, da sie Werte größer als 256
; enthalten muß.
; Diese Routine positioniert den Sprite aber nicht direkt. Sie limitiert sich
; darauf, es die Universalroutine tun zu lassen, sie übermittelt ihr nur
; die Koordinaten über die Register d0 und d1.


BewegeSprite:
	ADDQ.L	#1,TABYPOINT		; Point auf das nächste Byte
	MOVE.L	TABYPOINT(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Longword der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann weiter
	MOVE.L	#TABY-1,TABYPOINT	; Starte wieder beim ersten Byte (-1)
NOBSTARTY:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0

	ADDQ.L	#2,TABXPOINT		; Pointe auf das nächste Word
	MOVE.L	TABXPOINT(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABX-2,A0		; sind wir beim letzten Word der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann weiter
	MOVE.L	#TABX-2,TABXPOINT	; beginne beim ersten Word-2
NOBSTARTX:
	moveq	#0,d1				; löscht d1
	MOVE.w	(A0),d1				; setzen den Wert der Tabelle in d1

	lea	MEINSPRITE,a1			; Adresse des Sprite in a1
	moveq	#13,d2				; Höhe des Sprite in d2

	bsr.w	UniMoveSprite		; führt die Universalroutine zum
								; Positionieren eines Sprites aus
; zweiter Sprite
	ADDQ.L	#1,TABYPOINT2		; Point auf das nächste Byte
	MOVE.L	TABYPOINT2(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Longword der TAB?
	BNE.S	NOBSTARTY2			; noch nicht? dann weiter
	MOVE.L	#TABY-1,TABYPOINT2	; Starte wieder beim ersten Byte (-1)
NOBSTARTY2:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0

	ADDQ.L	#2,TABXPOINT2		; Pointe auf das nächste Word
	MOVE.L	TABXPOINT2(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABX-2,A0		; sind wir beim letzten Word der TAB?
	BNE.S	NOBSTARTX2			; noch nicht? dann weiter
	MOVE.L	#TABX-2,TABXPOINT2	; beginne beim ersten Word-2
NOBSTARTX2:
	moveq	#0,d1				; löscht d1
	MOVE.w	(A0),d1				; setzen den Wert der Tabelle in d1

	lea	MEINSPRITE2,a1			; Adresse des Sprite in a1
	moveq	#8,d2				; Höhe des Sprite in d2

	bsr.w	UniMoveSprite		; führt die Universalroutine zum
								; Positionieren eines Sprites aus
	rts

; Pointer auf die Tabellen des ersten Sprite

TABYPOINT:
	dc.l	TABY-1
TABXPOINT:
	dc.l	TABX-2

; Pointer auf die Tabellen des zweiten Sprite

TABYPOINT2:
	dc.l	TABY+40-1
TABXPOINT2:
	dc.l	TABX+96-2

; Tabelle mit vorausberechneten Y-Koordinaten
TABY:
	incbin	"/Sources/ycoordinatok.tab"	; 200 .B Werte
ENDETABY:

; Tabelle mit vorausberechneten X-Koordinaten
TABX:
	incbin	"/Sources/xcoordinatok.tab"	; 150 .W Werte
ENDETABX:

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

	ADD.W	#$2c,d0			; zähle den Offset vom Anfang des Screens dazu

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



MEINSPRITE2:				; Länge 8 Zeilen
VSTART2:
	dc.b $60				; Vertikale Position (von $2c bis $f2)
HSTART2:
	dc.b $60+(14*2)			; Horizontale Position (von $40 bis $d8)
VSTOP2:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0011111111111100,%1100001000100011
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0111111111111110,%1000000111000001
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende sprite


	SECTION LEERESPLANE,BSS_C	; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

In  diesem  Beispiel  zeigen  wir  die  Vielfältigkeit  der  Routine
UniMoveSprite.  Wir  haben  zwei  Sprites  mit  unterschiedlicher Form und
Größe, und beide werden von der Routine auf den Bildschirm  gebracht.  Die
Routine  BewegeSprite  liest aus den Tabellen die Koordinaten der Sprites,
und dann ruft sie für jeden Sprite die Routine UniMoveSprite  auf.  Achtet
darauf,  wie  die Routine BewegeSprite jedesmal in Register a1 die Adresse
des jeweiligen Sprites gibt (die natürlich verschieden sind). Da auch  die
Höhen anders sind, wird auch in d2 jedesmal ein anderer Wert gegeben, also
der eines jeden Sprite.

