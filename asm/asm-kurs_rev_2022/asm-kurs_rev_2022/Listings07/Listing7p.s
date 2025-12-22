
; Listing7p.s - Beispiel einer Anwendung der Universalroutine:
;				4 SPRITE ZU 4 FARBEN SIND NEBENEINANDER UND ERZEUGEN EIN
;				64 PIXEL BREITES BILD.
;				ES WERDEN ZWEI TABELLEN MIT VORAUSBERECHNETEN WERTEN VERWENDET

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

	
	MOVE.L	#MEINSPRITE1,d0	 ; Adresse des Sprite in d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#MEINSPRITE2,d0	 ; Adresse des Sprite in d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)


	MOVE.L	#MEINSPRITE3,d0	 ; Adresse des Sprite in d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; nostra COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!


Mouse1:
	cmpi.b	#$ff,$dff006	; Zeile	255?
	bne.s	Mouse1

	bsr.w	BewegeSprite	; bewegt alle Sprites
	
Warte:
	cmpi.b	#$ff,$dff006	; Zeile $ff?
	beq.s	Warte

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse1


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


; Diese Routine liest aus der Tabelle die Koordinaten des Sprite 0, bewegt
; ihn mit der Universalroutine, die wir in Listing7m.s gesehen haben, und
; dann bewegt sie auch die anderen Sprites. Diese anderen werden die gleichen
; vertikalen Koordinaten haben nur um jeweils 16 Pixel horizontal
; verschoben:
; Die horizontale Position des Sprite 1 ist 16 Pixel weiter rechts als Sprite0
; Die horizontale Position des Sprite 2 ist 16 Pixel weiter rechts als Sprite1
; Die horizontale Position des Sprite 3 ist 16 Pixel weiter rechts als Sprite2

Bewegesprite:
	ADDQ.L	#1,TABYPOINT		; Point auf das nächste Byte
	MOVE.L	TABYPOINT(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Longword der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann weiter
	MOVE.L	#TABY-1,TABYPOINT	; Starte wieder beim ersten Byte (-1)
NOBSTARTY:
	moveq	#0,d4				; Lösche d0 
	MOVE.b	(A0),d4

	ADDQ.L	#1,TABXPOINT		; Pointe auf das nächste Word
	MOVE.L	TABXPOINT(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABX-1,A0		; sind wir beim letzten Word der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann weiter
	MOVE.L	#TABX-1,TABXPOINT	; beginne beim ersten Word-2
NOBSTARTX:
	moveq	#0,d3				; löscht d1
	MOVE.b	(A0),d3				; setzen den Wert der Tabelle in d1

	moveq	#15,d2				; Höhe des Sprite in d2


	
	lea	MEINSPRITE,A1		; Adresse Sprite 0
	move.w	d4,d0			; geben die Koordinaten in die Register
	move.w	d3,d1
	bsr.w	UniMoveSprite	; führt die Universalroutine aus, die den Sprite
							; positioniert

	lea	MEINSPRITE1,A1		; Adresse Sprite 1
	add.w	#16,d3			; sprite 1 16 Pixel weiter rechts vom Sprite 0
	move.w	d4,d0			; geben die Koordinaten in die Register
	move.w	d3,d1
	bsr.w	UniMoveSprite	; führt die Universalroutine aus, die den Sprite
							; positioniert

	lea	MEINSPRITE2,A1		; Adresse Sprite 2
	add.w	#16,d3			; sprite 2 16 Pixel weiter rechts vom Sprite 1
	move.w	d4,d0			; geben die Koordinaten in die Register
	move.w	d3,d1
	bsr.w	UniMoveSprite	; führt die Universalroutine aus, die den Sprite
							; positioniert

	lea	MEINSPRITE3,A1		; Adresse Sprite 3
	add.w	#16,d3			; sprite 3 16 Pixel weiter rechts vom Sprite 2
	move.w	d4,d0			; geben die Koordinaten in die Register
	move.w	d3,d1
	bsr.w	UniMoveSprite	; führt die Universalroutine aus, die den Sprite
							; positioniert
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


TABY:
	incbin	"/Sources/ycoordinatok.tab"	; 200 .B Werte
ENDETABY:

; Tabelle mit X-Koordinaten für den linken Sprite. Diese Tabelle enthält
; reale Werte, ohne den Offsets, die werden von der UniversalRoutine
; automatisch dazugezählt.
; Da die vier Sprites zusammen ein Bild ergeben, das 64 Pixel breit ist,
; kann der linke Sprite seine Position nur bis maximal 319-64=255 ausdehnen.
; Das hat zur Folge, daß wir auch für diese Tabelle Bytes statt Words
; verwenden können.
; Die Tabelle wird immer so gemacht:
;
; IS
; beg>0
; end>360
; amount>300
; amp>255/2
; y_offset>255/2
; multiplier>1

TABX:
	DC.B	$80,$83,$86,$88,$8B,$8E,$90,$93,$95,$98,$9B,$9D,$A0,$A2,$A5,$A8
	DC.B	$AA,$AD,$AF,$B1,$B4,$B6,$B9,$BB,$BD,$C0,$C2,$C4,$C6,$C9,$CB,$CD
	DC.B	$CF,$D1,$D3,$D5,$D7,$D9,$DB,$DC,$DE,$E0,$E2,$E3,$E5,$E7,$E8,$EA
	DC.B	$EB,$EC,$EE,$EF,$F0,$F1,$F2,$F4,$F5,$F6,$F6,$F7,$F8,$F9,$FA,$FA
	DC.B	$FB,$FB,$FC,$FC,$FD,$FD,$FD,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FD
	DC.B	$FD,$FD,$FC,$FC,$FB,$FB,$FA,$FA,$F9,$F8,$F7,$F6,$F6,$F5,$F4,$F2
	DC.B	$F1,$F0,$EF,$EE,$EC,$EB,$EA,$E8,$E7,$E5,$E3,$E2,$E0,$DE,$DC,$DB
	DC.B	$D9,$D7,$D5,$D3,$D1,$CF,$CD,$CB,$C9,$C6,$C4,$C2,$C0,$BD,$BB,$B9
	DC.B	$B6,$B4,$B1,$AF,$AD,$AA,$A8,$A5,$A2,$A0,$9D,$9B,$98,$95,$93,$90
	DC.B	$8E,$8B,$88,$86,$83,$80,$7E,$7B,$78,$76,$73,$70,$6E,$6B,$69,$66
	DC.B	$63,$61,$5E,$5C,$59,$56,$54,$51,$4F,$4D,$4A,$48,$45,$43,$41,$3E
	DC.B	$3C,$3A,$38,$35,$33,$31,$2F,$2D,$2B,$29,$27,$25,$23,$22,$20,$1E
	DC.B	$1C,$1B,$19,$17,$16,$14,$13,$12,$10,$0F,$0E,$0D,$0C,$0A,$09,$08
	DC.B	$08,$07,$06,$05,$04,$04,$03,$03,$02,$02,$01,$01,$01,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$01,$01,$01,$02,$02,$03,$03,$04,$04,$05,$06
	DC.B	$07,$08,$08,$09,$0A,$0C,$0D,$0E,$0F,$10,$12,$13,$14,$16,$17,$19
	DC.B	$1B,$1C,$1E,$20,$22,$23,$25,$27,$29,$2B,$2D,$2F,$31,$33,$35,$38
	DC.B	$3A,$3C,$3E,$41,$43,$45,$48,$4A,$4D,$4F,$51,$54,$56,$59,$5C,$5E
	DC.B	$61,$63,$66,$69,$6B,$6E,$70,$73,$76,$78,$7B,$7E
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
	dc.w	$e0,0,$e2,0		; erste	Bitplane

	dc.w	$180,$000		; Color0	; Hintergrund Schwarz
	dc.w	$182,$123		; Color1	; Farbe 1 des Bitplane, die
							; in diesem Fall leer ist,
							; und deswegen nicht erscheint

	dc.w	$1A2,$800		; Color17, oder COLOR1 des Sprite0 - ROT
	dc.w	$1A4,$d00		; Color18, oder COLOR2 des Sprite0 - GRÜN
	dc.w	$1A6,$CC0		; Color19, oder COLOR3 des Sprite0 - GELB

; die Farben der Sprite 2 und 3 sind die gleichen, wie bei Sprite 0 und 1

	dc.w	$1AA,$800		; Color21
	dc.w	$1AC,$d00		; Color22
	dc.w	$1AE,$cc0		; Color23

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier sind die Sprites: NATÜRLICH in CHIP RAM! **********

MEINSPRITE:					; Länge 15 Zeilen
	incbin	"/Sources/Largesprite0.raw"

MEINSPRITE1:				; Länge 15 Zeilen
	incbin	"/Sources/Largesprite1.raw"

MEINSPRITE2:				; Länge 15 Zeilen
	incbin	"/Sources/Largesprite2.raw"

MEINSPRITE3:				; Länge 15 Zeilen
	incbin	"/Sources/Largesprite3.raw"

	SECTION LEERESPLANE,BSS_C	; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

In  diesem  Listing  verwenden  wir  4 Sprites zu 4 Farben, um ein Bild zu
schaffen,  das  64  Pixel  breit  ist.  Die  Sprites  sind  horizontal
nebeneinander  angereiht. Sie haben alle die gleiche Vertikalposition, nur
horizontal sind sie alle um 16 Pixel vom Vorgänger verschoben.  Wir  lesen
aus  der  Tabelle  die  Koordinaten des ersten Sprite, während die anderen
diese übernehmen außer die der X-Koordinate, da wird immer 16 dazugezählt.
Bemerkt ihr die Bequemlichkeit der Universalroutine:  um  die  Sprites  zu
bewegen  verwenden  wir  immer  die  gleiche  Routine,  nur  daß wir in a1
jedesmal eine andere Adresse geben und in d0 und  d1  andere  Koordinaten.
Die  Höhe  ist immer die gleiche, deswegen wird d2 nicht modifiziert. Wenn
das aber der Fall wäre,  dann  würde  es  auch  kein  Problem  darstellen,
einfach den Wert in d2 anpassen und alles läuft.

