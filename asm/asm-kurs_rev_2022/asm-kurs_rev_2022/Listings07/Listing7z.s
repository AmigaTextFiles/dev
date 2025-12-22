
; Listing7z.s	ANIMATION (6 FOTOGRAMME) EINES ATTACHED-SPRITES

	 SECTION CipundCop,CODE
	 
Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
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


;	Wir pointen auf die Sprites 0 und 1, die ATTACHED einen einzigen Sprite
;	zu 16 Farben ergeben. Der ungerade Sprite, also Sprite 1, muß das Bit 7
;	des zweiten Word auf 1 haben.

	MOVE.L	FRAMETAB(PC),d0	 	; Adresse des Sprite in d0
	LEA	SpritePointers,a1		; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#$44,d0				; Der ungerade Sprite ist 44 Bytes später!!
	addq.w	#8,a1				; nächste SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

; P.S: Das Bit 7 braucht nicht gesetzt zu werden, es ist in diesem Fall schon
; gemacht

	move.l	#COPPERLIST,$dff080	; undere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!

mouse:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	bne.s	mouse

	bsr.s	Animation
	bsr.w	BewegeSprites		; Bewege die Sprites

Warte:
	cmpi.b	#$ff,$dff006		; Zeile	255?
	beq.s	Warte

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; Diese Routine animiert die Sprites, indem sie die Adressen der einzelnen
; Fotogramme so verstellt, daß die erste der Tabelle an die letzte Stelle
; kommt, während alle anderen um eine Stelle in Richtung des ersten rutschen.

Animation:
	addq.b	#1,ZahlAnim		; diese drei Anweisungen sorgen dafür, daß
	cmp.b	#2,ZahlAnim		; das Fotogramm nur alle zwei Mal geändert
	bne.s	NichtAendern	; wird.
	clr.b	ZahlAnim
	LEA	FRAMETAB(PC),a0		; Tabelle der Fotogramme
	MOVE.L	(a0),d0	 		; speichere die erste Adresse in d0
	MOVE.L	4(a0),(a0)		; verschiebe die nächsten 5 nach hinten
	MOVE.L	4*2(a0),4(a0)	; Diese Anweisungen "rotieren" die Adressen
	MOVE.L	4*3(a0),4*2(a0) ; in der Tabelle.
	MOVE.L	4*4(a0),4*3(a0)
	MOVE.L	4*5(a0),4*4(a0)
	MOVE.L	d0,4*5(a0)		; Gibt die Ex-erste Adresse an sechste Stelle

	MOVE.L	FRAMETAB(PC),d0 ; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Gerade Spritepointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#$44,d0			; Der ungerade Sprite ist 44 Bytes nach dem geraden
	addq.w	#8,a1			; POINTER des ungeraden Sprite
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
NichtAendern:
	rts

ZahlAnim:
	dc.w	0

; Das ist die Tabelle mir den Adressen der Fotogramme des geraden Sprite,
; von der aus auch auf die dementsprechenden ungeraden Sprites zugegriffen
; wird, die attached werden müssen. Die Adressen in der Tabelle werden von
; der Routine "Animation" rotiert, somit befindet sich in der Liste das
; erste Mal Fotogramm1 an erster Stelle, das nächste Mal Fotogramm2 usw.
; Das wiederholt sich immer und beginnt dann wieder von vorne. Somit muß
; immer nur die Adresse genommen werden, die am Anfang der Tabelle steht,
; und diese dann "Mischen", um die Fotogramme in Sequenz zu haben.

FRAMETAB:
	DC.L	Fotogramm1
	DC.L	Fotogramm2
	DC.L	Fotogramm3
	DC.L	Fotogramm4
	DC.L	Fotogramm5
	DC.L	Fotogramm6

; Diese Routine liest aus den zwei Tabellen die realen Koordinaten der
; Sprites. Da die Sprites Attached sind, haben sie die gleichen Koordianten.

BewegeSprites:
	ADDQ.L	#1,TABYPOINT		; Pointe auf das nächste Byte
	MOVE.L	TABYPOINT(PC),A0	; Adresse in Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Byte der TAB?
	BNE.S	NOBSTARTY			; noch nicht? Dann mach weiter
	MOVE.L	#TABY-1,TABYPOINT	; Starte wieder beim ersten Byte
NOBSTARTY:
	moveq	#0,d3				; Lösche d3
	MOVE.b	(A0),d3				; Kopiere das Byte aus der Tabelle, also
								; die Y-Koordinate, in d3

	ADDQ.L	#2,TABXPOINT		; Pointe auf das nächste Word
	MOVE.L	TABXPOINT(PC),A0	; Adresse von Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABX-2,A0		; sind wir beim letzten Word der TAB?
	BNE.S	NOBSTARTX			; noch nicht? Dann mach weiter
	MOVE.L	#TABX-2,TABXPOINT	; Starte wieder beim ersten Word-2
NOBSTARTX:
	moveq	#0,d4				; Löschen d4
	MOVE.w	(A0),d4				; geben der Wert der Tabelle, also die
								; X-Koordinate, in d4

	MOVE	D3,D0				; Y-Koordinate in d0
	MOVE	D4,D1				; X-Koordinate in d1
	moveq	#15,d2				; Höhe des Sprite in d2
	MOVE.L	FRAMETAB(PC),a1		; Adresse des Sprite in A1

	bsr.w	UniMoveSprite		; führt die UniversalRoutine zum positionieren
								; des geraden Sprite aus

	MOVE.W	D3,D0				; Y-Koordinate in d0
	MOVE.W	D4,D1				; X-Koordinate in d1
	moveq	#15,d2				; Höhe des Sprite in d2
	LEA	$44(a1),a1				; Adresse des ungeraden Sprite in A1
								; der ungerade Sprite ist 44 Byte nach dem
								; geraden
	bsr.w	UniMoveSprite		; Startet die Universalroutine zum position.
								; des ungeraden Sprite
	rts


TABYPOINT:
	dc.l	TABY-1				; BEMERKE: Die Werte der Tabelle sind hier Bytes,
								; wir arbeiten deshalb mit einem ADDQ.L #1,TABYPOINT
								; und nicht mit einem #2 wie es bei den Word der Fall
								; wäre, oder mit #4 bei Long
TABXPOINT:
	dc.l	TABX-2				; BEMERKE: Die Werte der Tabelle sind hier Word

; Tabelle mit vorausberechneten Y-Koordinaten

TABY:
	incbin	"ycoordinatok.tab"	; 200 .B Werte
ENDETABY:

; Tanbelle mit vorausberechneten X-Koordianten

TABX:
	incbin	"xcoordinatok.tab"	; 150 .W Werte
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
	dc.w	$100,%0001001000000000	; Bit 12 an: 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste	Bitplane

;	Palette der PIC

	dc.w	$180,$000		; COLOR0	; schwarzer Hintergrund
	dc.w	$182,$123		; COLOR1	; Farbe 1 des Bitplane, das
							; in diesem Fall leer ist,
							; deswegen erscheint sie nicht.

;	Palette der SPRITE Attacched

	dc.w	$1A2,$FFC		; COLOR17, COL 1 für Attached-Sprite
	dc.w	$1A4,$DEA		; COLOR18, COL 2 für Attached-Sprite
	dc.w	$1A6,$AC7		; COLOR19, COL 3 für Attached-Sprite
	dc.w	$1A8,$7B6		; COLOR20, COL 4 für Attached-Sprite
	dc.w	$1AA,$494		; COLOR21, COL 5 für Attached-Sprite
	dc.w	$1AC,$284		; COLOR22, COL 6 für Attached-Sprite
	dc.w	$1AE,$164		; COLOR23, COL 7 für Attached-Sprite
	dc.w	$1B0,$044		; COLOR24, COL 7 für Attached-Sprite
	dc.w	$1B2,$023		; COLOR25, COL 9 für Attached-Sprite
	dc.w	$1B4,$001		; COLOR26, COL 10 für Attached-Sprite
	dc.w	$1B6,$F80		; COLOR27, COL 11 für Attached-Sprite
	dc.w	$1B8,$C40		; COLOR28, COL 12 für Attached-Sprite
	dc.w	$1BA,$820		; COLOR29, COL 13 für Attached-Sprite
	dc.w	$1BC,$500		; COLOR30, COL 14 für Attached-Sprite
	dc.w	$1BE,$200		; COLOR31, COL 15 für Attached-Sprite

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier die Sprite: KLARERWEISE in CHIP RAM! **********


Fotogramm1:					; Länge 15 Zeilen, $44 Bytes
	dc.w $0000,$0000
	dc.w $0580,$0040,$07c0,$0430,$0d68,$0d18,$1fac,$1b9c
	dc.w $3428,$3818,$068e,$993c,$d554,$1390,$729e,$b6d8
	dc.w $5556,$9390,$96b0,$e972,$406c,$7c60,$5bc4,$5fc8
	dc.w $0970,$0908,$0bc0,$0030,$0600,$01c0
	dc.w 0,0
Fotogramm1b:				; Länge 15 Zeilen
	dc.w $0000,$0080
	dc.w $07c0,$0000,$1bf0,$0380,$32f8,$0380,$607c,$0380
	dc.w $43f8,$0384,$e3fc,$0382,$efec,$7ffe,$cfe4,$7ffe
	dc.w $efec,$7ffe,$fff0,$038e,$7fe0,$039c,$5c40,$23bc
	dc.w $0a80,$37f8,$0380,$1ff0,$0000,$07c0
	dc.w 0,0

Fotogramm2:
	dc.w $0000,$0000
	dc.w $0580,$0040,$05c0,$0430,$0ee8,$0e98,$1dac,$1b9c
	dc.w $34e8,$3ad8,$560e,$993c,$f5e8,$3318,$d252,$1690
	dc.w $3a96,$c7d0,$95b8,$ea32,$41ec,$78e0,$5e44,$5e48
	dc.w $0470,$0408,$0ec0,$0030,$0600,$01c0
	dc.w 0,0
Fotogramm2b:
	dc.w $0000,$0080
	dc.w $07c0,$0000,$1bf0,$0180,$3178,$01c0,$607c,$01c0
	dc.w $4138,$01c4,$e3fc,$7382,$cff8,$7f86,$efe0,$fffe
	dc.w $ffec,$0ffe,$ffc8,$07fe,$7ff8,$071c,$5940,$27bc
	dc.w $0a00,$3ff8,$0e00,$1ff0,$0000,$07c0
	dc.w 0,0

Fotogramm3:
	dc.w $0000,$0000
	dc.w $0580,$0040,$04c0,$0430,$0e68,$0e18,$3dfc,$1bec
	dc.w $25c8,$0bd8,$7b2e,$ba3c,$d068,$1798,$6642,$82b0
	dc.w $32d6,$c690,$9490,$eb12,$49bc,$78b0,$4d6c,$4d60
	dc.w $1870,$0808,$0ec0,$0030,$0600,$01c0
	dc.w 0,0
Fotogramm3b:
	dc.w $0000,$0080
	dc.w $07c0,$0000,$1bf0,$0000,$31f8,$0060,$601c,$20f0
	dc.w $7038,$30e4,$c5dc,$7de2,$eff8,$3fc6,$fff0,$0fce
	dc.w $fff0,$07ee,$ffe8,$07fe,$77c8,$0f7c,$5358,$3ebc
	dc.w $1400,$3ff8,$0c00,$1ff0,$0000,$07c0
	dc.w 0,0

Fotogramm4:
	dc.w $0000,$0000
	dc.w $0580,$0040,$04c0,$0430,$1678,$0608,$357c,$1764
	dc.w $0968,$0968,$122e,$91bc,$c7e8,$0398,$6242,$86b0
	dc.w $3256,$c790,$93b0,$f032,$786c,$5b60,$7354,$4748
	dc.w $1870,$0808,$0ac0,$0030,$0600,$01c0
	dc.w 0,0
Fotogramm4b:
	dc.w $0000,$0080
	dc.w $07c0,$0000,$1bf0,$0000,$39f8,$1830,$689c,$3c78
	dc.w $7698,$3ef4,$efdc,$1fe2,$fff8,$0fc6,$fff0,$07ce
	dc.w $fff0,$0fee,$efc0,$1ffe,$6798,$3cfc,$7f30,$38fc
	dc.w $1820,$37f8,$0000,$1ff0,$0000,$07c0
	dc.w 0,0

Fotogramm5:
	dc.w $0000,$0000
	dc.w $0580,$0040,$04c0,$0030,$0e68,$0218,$172c,$1714
	dc.w $3ca8,$3ca0,$0116,$9810,$cf10,$09d0,$64e2,$8290
	dc.w $30d6,$d7b0,$8a50,$c992,$782c,$5b20,$7be4,$4fe8
	dc.w $0830,$0808,$0ae0,$0010,$0600,$01c0
	dc.w 0,0
Fotogramm5b:
	dc.w $0000,$0080
	dc.w $07c0,$0000,$1ff0,$0400,$3df8,$0c00,$68fc,$0e08
	dc.w $4358,$0f3c,$e7ec,$077e,$f7e8,$07fe,$fff0,$07ee
	dc.w $eff0,$1fce,$f7f0,$3fee,$67c0,$3cfc,$7f10,$30fc
	dc.w $0870,$37f8,$0060,$1ff0,$0000,$07c0
	dc.w 0,0

Fotogramm6:
	dc.w $0000,$0000
	dc.w $0580,$0040,$07c0,$0430,$0e68,$0a18,$1b2c,$1b1c
	dc.w $3428,$3c18,$0696,$9910,$cf5c,$0d98,$7492,$92d0
	dc.w $50b6,$97d0,$ab70,$c8b2,$602c,$5e20,$5bc4,$5fc8
	dc.w $0850,$0848,$0ae0,$0010,$0600,$01c0
	dc.w 0,0
Fotogramm6b:
	dc.w $0000,$0080
	dc.w $07c0,$0000,$1bf0,$0300,$35f8,$0700,$64fc,$0700
	dc.w $43f8,$0784,$e3ec,$03be,$f3e4,$03fe,$efee,$1ffe
	dc.w $eff0,$7fee,$f7f0,$3fce,$7fe0,$21dc,$5e00,$21fc
	dc.w $08a0,$37f8,$00e0,$1ff0,$0000,$07c0
	dc.w 0,0

	SECTION LEERESPLANE,BSS_C	; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

In diesem Beispiel zeigen wir, wie man einen animierten Sprite realisiert,
indem  wir  die  in der Lektion angeführte Technik anwenden. Das Bild, das
wir animieren, besteht eigentlich aus einen Spritepaar, das Attached  ist,
wir  bewegen  also  praktisch  zwei  Sprites. Für jeden Sprite haben wir 6
Fotogramme parat.  Betrachten  wir  im  Moment  nur  einen  Sprite.  Jedes
Fotogramm  ist  in  einer  Spritestruktur  gespeichert. Jedesmal, wenn der
Sprite neugezeichnet wird, sorgt die Routine "Animation"  dafür,  daß  ein
anderes  Fotogramm  benutzt  wird,  also  eine  andere Spritestruktur. Die
Routine  verwaltet  eine  Tabelle  mit  den  Adressen  der  verschiedenen
Spritestrukturen,  und  jedesmal,  wenn sie ausgeführt wird, verstellt sie
die Adressen darin so, daß sie eine Art Rotation  ausführen,  alle  kommen
einmal an die erste Stelle der Tabelle.
In der Praxis gibt´s hier nichts  Neues  zu  sehen,  wir  haben  nur  eine
Tabelle  mit  Werten  vor  uns,  oder besser: mit Adressen. Diese Adressen
werden dann rotiert, die erste Adresse kommt an  die  letzte  Stelle,  die
zweite an die erste, die dritte an die zweite usw., genau so wie wir es in
Listing3e.s gesehen haben. Die Adresse an  der  ersten  Stelle  wird  dann
immer  in den Spritepointer geladen, und sie wird als Fotogramm verwendet.
Um zu vermeiden, diese Arbeit auch für den zweiten Sprite machen zu müssen
(dem  ungeraden,  der  ja  am geraden "hängt"), ist jedes Fotogramm dieses
"zweiten" Sprites sofort nach dem des ersten im Speicher angesiedelt. Wenn
man  nun  die Adresse des einen hat, kann man ohne Probleme auf das andere
rückschließen, es wird immer $44 Byte später sein:

  lea  $44(a0),a1

Damit  zählen  wir zur Adresse des Fotogrammes des ersten Sprite die Länge
des Fotogrammes selbst dazu, und befinden uns somit auf  der  Adresse  des
zweiten Fotogrammes (Ungerader Sprite).

AdÜ: FFFFFFFeeeeeeerrrrrtttttiiiiiggggg!!!!!!!

