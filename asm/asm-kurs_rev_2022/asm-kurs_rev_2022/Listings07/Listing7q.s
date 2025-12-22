
; Listing7p.s	EIN SPRITE WIRD MIT DEM JOYSTICK BEWEGT

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
	cmpi.b	#$ff,$dff006	; Zeile $ff?
	bne.s	mouse

	btst	#7,$bfe001		; FEUERKNOPF gedrückt?
	bne.s	NonFuoco		; Wenn nicht, überspringe die nächste Anweisung
	move.w	#$f00,$dff180	; Wenn ja, gib ein schönes ROT in COLOR0
NonFuoco:

	bsr.s	LiesJoy			; das liest den Joystick
	move.w	sprite_y(pc),d0 ; bereite die Parameter für Universalroutine
	move.w	sprite_x(pc),d1 ; vor
	lea	MEINSPRITE,a1		; Spriteadresse
	moveq	#13,d2			; Höhe des Sprite
	bsr.w	UniMoveSprite	; Aufruf der UniversalRoutine

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

; Diese Routine liest den Joystick aus und updatet die Werte in
; den Variablen Sprite_x und Sprite_y

LiesJoy:
	MOVE.w	$dff00c,D3		; JOY1DAT
	BTST.l	#1,D3			; das Bit 1 sagt uns, ob wir nach rechts gehn
	BEQ.S	NICHTRECHTS		; wenn es 0 ist, gehen wir nicht rechts
	ADDQ.w	#1,SPRITE_X		; wenn es 1 ist, bewege den Sprite um 1 Pixel
							; nach rechts
	BRA.S	CHECK_Y			; geh´zur Kontrolle für Y

NICHTRECHTS:
	BTST.l	#9,D3			; Bit 9 sagt uns, ob wir nach links gehn.
	BEQ.S	CHECK_Y			; wenn es 0 ist, gehen wir nicht nach links
	SUBQ.W	#1,SPRITE_X		; wenn es 1 ist, bewege den Sprite um 1 Pixel
CHECK_Y:
	MOVE.w	D3,D2			; kopiere den Wert des Registers
	LSR.w	#1,D2			; läßt die Bits um eins nach Rechts rutschen
	EOR.w	D2,D3			; Exklusives OR. Nun können wir testen
	BTST.l	#8,D3			; Testen, ob es nach oben geht
	BEQ.S	NICHTRAUF		; wenn nicht, kontrolliere ob nach unten
	SUBQ.W	#1,SPRITE_Y		; wenn ja, bewege den Sprite um 1 Pixel
	BRA.S	ENDJOYST

NICHTRAUF:
	BTST.l	#0,D3			; testen, ob es nach unten geht
	BEQ.S	ENDJOYST		; wenn nicht, ende
	ADDQ.W	#1,SPRITE_Y		; wenn ja, bewege den Sprite um 1 Pixel
ENDJOYST:
	RTS

SPRITE_Y:	dc.w	0		; hier wird das Y des Sprite gespeichert
SPRITE_X:	dc.w	0		; hier wird das X des Sprite gespeichert

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
	lsr.w	#1,D1			; SHIFTEN, wir verschieben den Wert von HSTART um
							; 1 Bit nach rechts, um es in den Wert zu
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
	dc.w	 $e0,0,$e2,0	; erste	Bitplane

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
	dc.b $5d	; $50+13=$5d	; Vertikale Endposition des Sprite
VHBITS:
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

In  diesem  Beispiel   bewegen  wir  den  Sprite  mit  dem  Joystick.  Das
einfachste  ist zu kontrollieren, ob der Feuerknopf gedrückt ist,  einfach
ein  BTST  #7,$bfe001, genau das Gleiche wie bei der linken Maustaste, nur
ist es dort das Bit 6. Um den Sprite am Monitor zu bewegen  verwenden  wir
unsere  Universalroutine, die wir schon fix und fertig vorliegen haben und
ersparen uns so eine Menge Arbeit.
Die Routine LiesJoy  kümmert  sich  darum,  den  Joystick  auszulesen  und
infolgedessen  die Koordinaten des Sprites zu erneuern, sie upzudaten. Sie
sind in den zwei Speicherzellen Sprite_x und Sprite_y festgehalten. Um den
Joystick  lesen  zu  können brauchen wir das Exklusive OR, das, wie wir in
der Lektion gesehen haben, eine Ex-OR-Operation zwischen den Bits aus zwei
Registern  durchführt.  Das  Lesen des Joystick erfolgt durch das Register
JOY1DAT. Um zu wissen, ob der Hebel des Joystick nach  links  oder  rechts
gedrückt  ist,  reicht  es  den Status der Bits 1 und 9 zu kennen. Für die
anderen Richtungen ist es etwas komplizierter. Denn um zu wissen,  ob  der
Hebel  nach  oben gedrückt ist, muß ein Ex-OR zwischen dem Bit 8 und 9 von
JOY1DAT gemacht werden. Da sich diese Bits aber beide im  selben  Register
befinden  kopieren wir dieses in zwei Datenregister des 68000, z.B. d2 und
d3. Dann SHIFTEN ("rutschen") wir eines der beiden Register um eine Stelle
nach  rechts.  Somit  wird  das  Bit  9  des  Registers auf die Position 8
verstellt. Da das Register,  das  wir  geshiftet  haben,  eine  Kopie  von
JOY1DAT  war,  wird nach dem SHIFT das Bit 8 des Datenregisters gleich dem
Bit 9 von JOY1DAT sein. Im noch nicht  geshiftetem  Register  wird  Bit  8
hingegen immer noch gleich dem Bit 8 von JOY1DAT sein.
Wenn wir nun ein EOR zwischen den beiden Registern machen wird in Position
8  das  EOR  zwischen  Bit  8 des Registers JOY1DAT und Bit 9 von Register
JOY1DAT sein. Genau das, was wir brauchen, um zu wissen,  ob  der  Sprite
nach oben geht. Um zu wissen, ob der Sprite nach unten geht müssen wir ein
EOR zwischen Bit 0 und 1 machen, genauso wie gerade beschrieben.

Ihr könnt versuchen, die Geschwindigkeit des Sprites  zu  verändern.  Wenn
die  Routine  LiesJoy  eine Bewegung des Hebels registriert, dann wird der
Sprite um 1 Pixel verstellt (mit ADDQ #1,xxx oder SUBQ #1,xxx).  Wenn  ihr
statt 1 größere Werte einsetzt, dann wird er sich schneller bewegen.

