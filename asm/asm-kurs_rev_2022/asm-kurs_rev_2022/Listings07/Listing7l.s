
; Listing7l.s	VERITKALER SCROLL EINES SPRITE UNTER DIE ZEILE $FF

		SECTION CiriCop,CODE

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
	bsr.w	BewegeSpriteY	; Bewege Sprite 0 vertikal (über $FF)

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


; Diese Routine bewegt den Sprite nach oben und unten, indem sie auf die
; Byte VSTART und VSTOP zugreift. Weiters auch noch auf die hochwertigen
; Bit der VSTART/VSTOP-Koordinaten, um die Position des Sprites auch unterhalb
; der Zeile $Ff zu erlauben. Die Koordinaten müssen hier als BYTES vorliegen,
; also von $00 bis $FF, um innerhalb des normalen Screens zu bleiben (der
; Offset von $2c wird von der Routine dazugezählt), oder man kann auch darüber
; hinausgehen, wenn man den Sprite in Overscan-Screens bis an die Grenzen der
; Hardware gehen lassen will.


BewegeSpriteY:
	ADDQ.L	#2,TABYPOINT		; Point auf das nächste Byte
	MOVE.L	TABYPOINT(PC),A0	; Adresse aus Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABY-2,A0		; Sind wir beim letzten Longword der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann weiter
	MOVE.L	#TABY-2,TABYPOINT	; Starte wieder beim ersten Byte (-1)
NOBSTARTY:
	moveq	#0,d0				; Lösche d0
	MOVE.w	(A0),d0				; kopiere das Byte aus der Tabelle in d0
	ADD.W	#$2c,d0				; Offset des Anfangs des Bildschirms hinzufügen
	MOVE.b	d0,VSTART			; kopiere das Byte in VSTART VSTART
	btst.l	#8,D0				; Zähle die Länge des Sprite dazu,
								; um die Endposition zu errechnen (VSTOP)
	beq.s	NichtVSTARTSet
	bset.b	#2,MEINSPRITE+3		; Setzt Bit 8 von VSTART (Zahl > $FF) auf 1
	bra.s	ToVSTOP
NichtVSTARTSet:
	bclr.b	#2,MEINSPRITE+3		; Löscht Bit 8 von VSTART (Zahl < $FF)
ToVSTOP:
	ADD.w	#13,D0				; Zählt die Länge des Sprite dazu, um die
								; Endposition des Sprites zu errechnen (VSTOP)
	move.b	d0,VSTOP			; Gib den richtigen Wert (Bits 0-7) in VSTOP
	btst.l	#8,d0				; Ist die Position größer als 255? ($FF)
	beq.s	NichtVSTOPSet
	bset.b	#1,MEINSPRITE+3		; Setzt Bit 8 von VSTOP (Zahl > $FF) auf 1
	bra.w	VstopFIN
NichtVSTOPSet:
	bclr.b	#1,MEINSPRITE+3		; Löscht Bit 8 von VSTOP (Zahl < $FF)
VstopFIN:
	rts

TABYPOINT:
	dc.l	TABY-2				; BEMERKE: Die Werte in der Tabelle sind hier
								; Bytes, wir arbeiten also mit einem ADDQ.L #1,
								; TABYPOINT, und nicht #2 wie bei den Words
								; oder #4 bei den Longwords.


; Tabelle mit vorausberechneten Y-Koordinaten für den Sprite.
; Zu beachten ist, daß die Y-Koordinate des Sprites zwischen $0 und $ff liegen
; muß, wenn er ins Videofenster passen soll. Den Offset von $2c zählt die
; Routine dazu. Wenn keine Overscan-Modi verwendet werden, also nicht länger
; als 255 Zeilen, dann kann eine Tabelle mit dc.b-Werten verwendet werden
; ($00-$ff)


; Wie man sich eine Tabelle macht:

; BEG> 0
; END> 360
; AMOUNT> 200
; AMPLITUDE> $f0/2
; YOFFSET> $f0/2
; SIZE (B/W/L)> b
; MULTIPLIER> 1


TABY:
	DC.W	$7A,$7E,$81,$85,$89,$8D,$90,$94,$98,$9B,$9F,$A2,$A6,$A9,$AD
	DC.W	$B0,$B3,$B7,$BA,$BD,$C0,$C3,$C6,$C9,$CC,$CE,$D1,$D3,$D6,$D8
	DC.W	$DA,$DC,$DE,$E0,$E2,$E4,$E5,$E7,$E8,$EA,$EB,$EC,$ED,$EE,$EE
	DC.W	$EF,$EF,$F0,$F0,$F0,$F0,$F0,$F0,$EF,$EF,$EE,$EE,$ED,$EC,$EB
	DC.W	$EA,$E8,$E7,$E5,$E4,$E2,$E0,$DE,$DC,$DA,$D8,$D6,$D3,$D1,$CE
	DC.W	$CC,$C9,$C6,$C3,$C0,$BD,$BA,$B7,$B3,$B0,$AD,$A9,$A6,$A2,$9F
	DC.W	$9B,$98,$94,$90,$8D,$89,$85,$81,$7E,$7A,$76,$72,$6F,$6B,$67
	DC.W	$63,$60,$5C,$58,$55,$51,$4E,$4A,$47,$43,$40,$3D,$39,$36,$33
	DC.W	$30,$2D,$2A,$27,$24,$22,$1F,$1D,$1A,$18,$16,$14,$12,$10,$0E
	DC.W	$0C,$0B,$09,$08,$06,$05,$04,$03,$02,$02,$01,$01,$00,$00,$00
	DC.W	$00,$00,$00,$01,$01,$02,$02,$03,$04,$05,$06,$08,$09,$0B,$0C
	DC.W	$0E,$10,$12,$14,$16,$18,$1A,$1D,$1F,$22,$24,$27,$2A,$2D,$30
	DC.W	$33,$36,$39,$3D,$40,$43,$47,$4A,$4E,$51,$55,$58,$5C,$60,$63
	DC.W	$67,$6B,$6F,$72,$76
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

Dieses Beispiel ist fast identisch mit dem aus Listing7d.s. In diesem hier
kann  die  vertikale  Position  des  Sprite  aber über die Zeile $FF (255)
hinausgehen. Ich erinnere euch daran, daß das Videofenster bei  Koordinate
($40,$2c) beginnt, die 255ste Zeile also der 211 entspricht (255-$2c=211).
Wenn wir also unseren Sprite über den gesamten  Bildschirm  laufen  lassen
wollen,  müssen  wir  die  mögliche,  erreichbare  Position  auf  299=$12b
hinaufschrauben. Dieser Wert ist zu  groß,  um  in  einem  Byte  Platz  zu
finden,  es  sind  9  Bit notwendig. Um die Anfangs-Y-Position festzulegen
wird außer den 8 Bit des Bytes VSTART auch noch ein neuntes Bit verwendet,
um  genau zu sein das Bit2 des Byte VHBITS, also dem vierten Kontrollbyte.
Das gleiche gilt für die Endposition, nur wird hier das Bit 1  von  VHBITS
verwendet.  In  der Tabelle hingegen sind die Werte als Words gespeichert.
Die Routine, die die Koordinaten liest, schaut, ob der Wert größer ist als
255;  wenn  das  eintrifft,  dann  wird  das entsprechende Bit im Register
VHBITS auf 1 gesetzt, ansonsten auf 0. Zu Bemerken ist, daß die  Kontrolle
unabhängig  für  VSTART und VSTOP gemacht wird. Es kann nämlich passieren,
daß ein Sprite bei einer Position beginnt, die kleiner als  255 ist   und
mit  einer  größeren  endet.  In  diesem  Fall wird Bit 2 Von VHBITS auf 0
gesetzt, Bit 1 hingegen auf 1.


