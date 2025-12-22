
; Listing7m.s   Positionierung der Sprite mittels einer Universalroutine.
; Dieses Beispiel zeigt eine universelle Routine, die die Sprites bewegen
; kann, sie beachtet dabei alle Bits (horizontal und vertikal) des Sprites.
; Als weiteres zählt sie automatisch das Offset (128 für die X-Koordinaten,
; $2c für die Y-Koordinaten) dazu.
; Somit können die Koordinaten in der Tabelle die realen sein, also von
; 0 bis 320 für die horizontalen, und von 0 bis 256 für die vertikalen.

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


	btst	#2,$dff016
	beq.s	Warte
	bsr.w	BewegeSprite	; Bewege Sprite

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


; Um den Sprite richtig zu bewegen lesen wir zuerst die Tabelle, um zu
; wissen, welche Positionen er einnehmen muß, dann übergeben wir diese
; mitsamt der Adresse und der Höhe des Sprites an die Routine UniMoveSprite.
; Das geschieht durch die Register a1,d0,d1,d2

BewegeSprite:
	bsr.s	LiesTabellen	; Liest die X-und Y-Koordinaten aus den Tabellen,
							; gibt in das Register a1 die Adresse des
							; Sprite, in d0 die Y-Pos, in d1 die X-Pos
							; und in d2 die Höhe des Sprite.

;
;	Eingangsparameter von UniMoveSprite:
;
;	a1 = Adresse des Sprite
;	d0 = Vertikale Position des Sprite auf dem Screen (0-255)
;	d1 = Horizontale Position des Sprite auf dem Screen (0-320)
;	d2 = Höhe des Sprite

	bsr.w	UniMoveSprite	; führt die Universalroutine aus, die den
							; Sprite bewegt
	rts


; Diese Routine liest aus den zwei Tabellen die realen Koordinaten der Sprite.
; Also die X-Koordinate, die von 0 bis 320 geht, und die Y, von 0 bis 256
; (ohne Overscan). Da wir in diesem Beispiel kein Overscan verwenden ist die
; Koordinatentabelle für die Y-Positionen aus Byte erstellt. Die Tabelle für
; die X-Koordinaten hingegen besteht aus Word, da sie Werte größer als 256
; enthalten muß.
; Diese Routine positioniert den Sprite aber nicht direkt. Sie limitiert sich
; darauf, es die Universalroutine tun zu lassen, sie übermittelt ihr nur
; die Koordinaten über die Register d0 und d1.


LiesTabellen:
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
	rts


TABYPOINT:
	dc.l	TABY-1			; BEMERKE: Die Werte in der Tabelle sind hier
							; Bytes, wir arbeiten also mit einem ADDQ.L #1,
							; TABYPOINT, und nicht #2 wie bei den Words
							; oder #4 bei den Longwords.

TABXPOINT:
	dc.l	TABX-2			; Bemerke: die Werte in der Tabelle sind hier Word

 
; Tabelle mit vorausberechneten Y-Koordinaten.
; Zu Bemerken, daß die Y-Position des Sprites zwischen $2c und $f2 liegen muß,
; wenn wir ihn in das Videofenster bekommen wollen. In der Tabelle sind alles
; Werte enthalten, die innerhalb dieses Limits liegen.

; So macht man sich eine Tabelle:

; BEG> 0
; END> 360
; AMOUNT> 200
; AMPLITUDE> $f0/2
; YOFFSET> $f0/2
; SIZE (B/W/L)> b
; MULTIPLIER> 1


TABY:
	incbin	"/Sources/ycoordinatok.tab"	; 200 .B Werte
ENDETABY:


; Tabelle mit vorausberechneten X-Koordinaten.
; Diese Tabelle enthält die REALEN Koordinaten des Bildschirmes, und nicht
; die "halbierten" Werte wie für den Scroll, beidem jedesmal 2 Pixel auf einmal
; genommen wurden. In der Tabelle kommen keine Bytes vor, die größer als
; 304 (320-16, wegen des Sprites) oder kleiner als 0 sind.



TABX:
	incbin	"/Sources/xcoordinatok.tab"	; 150 .W Werte
ENDETABX:


; Universelle Sprite-Positionierungs-Routine.
; Diese Routine verändert die Position des Sprites, dessen Adresse
; sich in a1 befindet und dessen Höhe im Register d2 steht.
; Seine Koordinaten für X und Y stehen jeweils in den Registers
; d0 und d1.
; Vor dem Aufruf dieser Routine muß die Adresse des Sprites in a1
; gegeben werden, seine Höhe in d2, und die Koordinaten, auf die
; er gesetzt werden soll in d0 (X) und d1 (Y).

; Diese Prozedur wird "Parameterübergabe" genannt.
; Bemerke, diese Routine modifiziert die Register d0 und d1.


;	Eingangsparameter von UniMoveSprite:
;
;	a1 = Adresse des Sprite
;	d0 = Vertikale Position des Sprite auf dem Screen (0-255)
;	d1 = Horizontale Position des Sprite auf dem Screen (0-320)
;	d2 = Höhe des Sprite

UniMoveSprite:
; Vertikale Positionierung

	ADD.W	#$2c,d0	 		; zähle den Offset vom Anfang des Screens dazu

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
	ds.b	40*256				; Bitplane auf 0 Lowres

	end

In  diesem  Listing präsentieren wir eine Universalroutine, um die Sprites
zu verstellen, sie heißt "UniMoveSprite".  Diese  Routine  übernimmt  alle
Aspekte  der Positionierung der Sprite, es verwaltet alle Bits richtig und
zählt den Offset dazu. Somit können die Werte  direkt  als  "reale"  Werte
übergeben  werden, die Tabellen können also die Werte enthalten, auf denen
der Sprite sich am Bildschirm im Endeffekt befinden soll.
Diese Routine funktioniert mit jedem Sprite. Denn die Adresse  des  Sprite
ist nicht fix, sie wird aus dem Register a1 ausgelesen. Das bedeutet daß:

  VSTART sich an der Adresse in a1 befindet

  HSTART sich im nachfolgenden Byte befindet, also an der Adresse a1 + 1

  VSTOP sich zwei Bytes danach befindet, oder a1 + 2

  das vierte Byte drei Byte danach liegt, oder a1 + 3

UniMoveSprite greift auf diese Byte mittels indirekter Adressierung über
Register mit Offset zu:

 um auf  VSTART zuzugreifen verwendet man (a1)
 um auf  HSTART zuzugreifen verwendet man 1(a1)
 um auf  VSTOP zuzugreifen verwendet man 2(a1)
 um auf das vierte Byte verwendet man 3(a1)

Auch die Höhe des Sprites ist nicht fix, sondern im Register d2 enthalten.
Damit  kann  die  Routine  dazu verwendet werden, um Sprites verschiedener
Höhe zu bewegen. Als weiteres holt sich die Routine die Daten nicht direkt
aus der Tabelle, sondern bekommt sie über d0 und d1 mitgeteilt.

Und  wer  gibt  diese  Daten  in  die  Register?  Eine andere Routine, die
"LiesTabellen" heißt, sie holt die Koordinaten aus den Tabellen, gibt  sie
in  die Register d0 und d1 und führt dann die Routine "UniMoveSprite" aus.
Praktisch haben wir die Aufgaben auf zwei Routinen aufgeteilt, so, als  ob
es  zwei Angestellte wären. Die Routine "LiesTabellen" macht ihre Aufgabe,
dann sagt sie: "Hey, Routine UniMoveSprite, hier kriegste ´nen  Sprite  zu
bewegen,  ich schick´ dir die Adresse im Register a1. In d2 schick ich dir
die Höhe. Dann noch die Koordinaten, die bekommst du über die Register  d0
und d1. Du weißt ja, wie man damit umgeht!"
Die Routine  "UniMoveSprite"  bekommt  die  Adresse  des  Sprite  und  die
Koordinaten  und  setzt diese dann in die richtigen Bytes des Sprites. Die
"Spedition" der Koordinaten über die Register heißt "Parameterübergabe".

Die Aufteilung der Arbeiten ist eine sehr bequeme Sache.  Nehmen  wir  an,
wir  möchten  einen  Sprite  bewegen,  der  seine  Y-Koordinaten aus einer
Tabelle  bekommt,  die  X-Koordinaten  hingegen  mit   ADDQ/SUBQ   separat
berechnet werden, um praktisch einen Sprite zu schaffen, der dauernd links
und rechts geht, dabei aber auf- und abschwingt. Da die Routine die  Daten
aus  den  Registern  holt,  insteressiert  es  sie nicht, ob sie aus einer
Tabelle kommen oder berechnet  werden.  Deshalb  können  wir  die  Routine
wiederverwenden,  ohne  etwas ändern zu müssen. Und da sie die Adresse und
die Höhe des Sprites auch über Register bekommt  ist  sie  somit  auch  an
keinen bestimmten Sprite gebunden und universell einsetzbar.
Von nun an werden wir also für jedes Beispiel mit  Sprites  diese  Routine
"UniMoveSprite"  verwenden,  ohne  sie  nur  ein  einziges Mal abändern zu
müssen.

