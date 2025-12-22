
; Listing7r2.s	EIN MIT DER MAUS BEWEGTER SPRITE, DER BIS ZUM RECHTEN RAND
;				KOMMT

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

	bsr.s	LiesMouse		; Da wird die Maus ausgelesen
	move.w	sprite_y(pc),d0 ; bereite die Parameter für die
	move.w	sprite_x(pc),d1 ; Universalroutine vor
	lea	MEINSPRITE,a1		; Spriteadresse
	moveq	#13,d2			; Höhe des Sprite
	bsr.w	UniMoveSprite	; Aufruf der Universalroutine

Warte:
	cmpi.b	#$ff,$dff006	; Zeile $ff?
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

; Diese Routine liest die Maus aus und erneuert die Werte in den
; Variablen Sprite_x und Sprite_y

LiesMouse:
	move.b	$dff00a,d1		; JOY0DAT Vertikale Position der Maus
	move.b	d1,d0			; kopiert in d0
	sub.b	mouse_y(PC),d0	; zähle alte Mausposition weg
	beq.s	no_vert			; wenn die Differenz = 0 ist, dann wurde
							; die Maus nicht bewegt
	ext.w	d0				; verwandle das Byte in Word
							; (siehe Ende des Listings)
	add.w	d0,sprite_y		; modifizieren Spriteposition
no_vert:
	move.b	d1,mouse_y		; speichere Mausposition für´s nächste Mal

	move.b	$dff00b,d1		; horizontale Mausposition
	move.b	d1,d0			; kopiert in d0
	sub.b	mouse_x(PC),d0	; zähle alte Mausposition weg
	beq.s	no_oriz			; wenn die Differenz = 0 ist, dann wurde
							; die Maus nicht bewegt
	ext.w	d0				; verwandle das Byte in Word
							; (siehe Ende des Listings)
	add.w	d0,sprite_x		; modifiziere Spriteposition
no_oriz
	move.b	d1,mouse_x		; speichere Mausposition für´s nächste Mal
	RTS

SPRITE_Y:	dc.w	0		; hier wird die Y - Position des Sprite gespeichert
SPRITE_X:	dc.w	0		; hier wird die X - Position des Sprite gespeichert
MOUSE_Y:	dc.b	0		; hier wird die Y - Position der Maus gesperichert
MOUSE_X:	dc.b	0		; hier wird die X - Position der Maus gespeiuchert


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
	lsr.w	#1,D1			; SHIFTEN, wir verschieben den Wert von HSTART um
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

In  diesem  Beispiel bewegen wir einen Sprite mit der Maus so, daß wir den
rechten  Rand  erreichen.  Es  gibt  auch  keine  weiteren  Probleme  mit
vertikalem Overscan.

Wenn wir den rechten Rand erreichen  wollen,  dann  müssen  wir  ein  Word
verwenden,  um  die horizontale Position des Sprites festhalten zu können.
Die Maus gibt uns aber Koordinaten  im  Byte-Format.  Wir  verwenden  also
folgende  Methode:  Wir  speichern die Koordinaten, die der Sprite hat und
die, die uns die Maus liefert, separat ab. Jedesmal,  wenn  wir  LiesMouse
ausführen,  lesen  wir  die  neuen Koordinaten und vergleichen sie mit den
alten.  Wir  berechnen  die  Differenz  aus  den  alten  und  den  neuen
Mauskoordinaten  und  zählen  sie  zur  Spriteposition dazu. Damit gibt es
keine Probleme, wenn die Mausposition 255 überschreitet und  somit  auf  0
zurückkommt,  denn  das,  was  zählt,  ist  immer  nur  die Differenz. Ich
erinnere euch auch daran, daß wenn ein Byte einen Wert  zwischen  128  und
255 einnimmt, und es als Addition oder Subtraktion verwendet wird, wird es
als negative Zahl  im  Zweierkomplement  angesehen.  Wenn  also  die  alte
Position 255 war (=$ff), dann wird das als -1 angesehen. Also 1-(-1)=2
Diese Zahl 2 wird zur X-Koordinate  des  Sprite  dazugezählt,  und  da  es
positiv  ist,  wird  es  immer eine Bewegung nach rechts ergeben. Wenn die
Differenz hingegen negativ gewesen wäre, dann würde  das  dazuzählen  eine 
Bewegung nach links nach sich ziehen.
Es gibt aber eine Kleinigkeit, auf die Acht gegeben werden muß.  Wenn  wir
die  Differenz  zwischen  den Mauskoordinaten machen, dann rechnen wir mit
Bytes. Die Differenz wird also immer ein Byte sein. Dieses Byte  summieren
wir  aber  zur  Koordinate  des  Sprite,  und  das  ist ein Word. Das gibt
Probleme.  Bevor  wir  die  Summe  machen,  müssen  wir  es  in  ein  Word
verwandeln.  Diese Aufgabe übernimmt die Anweisung EXT, sie verwandelt ein
Byte, das in einem Register steht, in ein Word. Es gibt  nun  zwei  Fälle:
Das Byte enthält eine positive Zahl, z.B. 5. EXT wird nun so vorgehen:

Inhalt vor dem EXT          Inhalt nach dem EXT
    $XX05                       $0005
(XX deutet auf irgend eine Zahl hin)


5 schribt man im Word-Format genau $0005.

Anderer Fall: der Inhalt war -5. Nun wird EXT so arbeiten:
Ich erinnere daran, daß -5 in Hexadezimal $FB ist.

Inhalt vor dem EXT          Inhalt nach dem EXT
    $XXFB                       $FFFB
(XX deutet auf irgend eine Zahl hin)

-5 wird in der Tat im Wordformat als $FFFB geschrieben.

Praktisch gesehen nimmt das EXT das Bit 7 des Registers (das Bit, das  das
Vorzeichen  angibt), und kopiert es in die Bit 8 bis 15. Auch wenn es hier
nicht verwendet wird, solltet ihr wissen, daß um ein Word in ein  Longword
zu verwandeln, immer ein EXT verwendet wird, nur im .L-Format:

    EXT.L   d0				; verwandelt ein Word in ein Longword

Die Umwandlung erfolgt genau gleich wie oben.

Was die vertikalen Positionen angeht, so  ist  es  nur  das  Gleiche.  Die
Routine ist auch die Selbe.

Um den Sprite zu bewegen, verwenden wir wie immer unsere Universalroutine.
Ihr werdet bemerken, daß die Routinen, die  die  Maus  oder  den  Joystick
verwalten,  in  jedem  eurer  Programme  verwendet werden können, die eine
solche Verwaltung  brauchen.  Die  Programmierer  von  Spielen  und  Demos
verwenden die meisten Routinen immer wieder.

