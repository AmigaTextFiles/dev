
; Listing7g.s	EIN ATTACHED-SPRITE ZU 16 FARBEN WIRD MITTELS ZWEI TABELLEN
;				(X- und Y- Koordinaten) AM BILDSCHIRM BEWEGT

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
	
;	Pointen auf die Sprite 0 und 1, die zusammen einen einzigen Sprite
;	zu 16 Farben ergeben. Der Sprite 1, der ungerade ist, muß Bit 7 des zweiten
;	Word auf 1 haben.

	MOVE.L	#MEINSPRITE0,d0	; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE1,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	bset	#7,MEINSPRITE1+3	; Setzt das Bit für Attached beim
							; Sprite 1. Ohne ihm sind die Sprites
							; nicht ATTACHED, sondern "normal"
	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	bne.s	mouse
	
	bsr.w	BewegeSpriteX	; Bewege Sprite 0+1 in X-Richtung
	bsr.w	BewegeSpriteY	; Bewege Sprite 0+1 in Y-Richtung

Warte:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse


	move.l	OldCop(PC),$dff080	; Pointen auf die alte SystemCOP
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

; Diese Routine bewegt den Sprite indem die auf das Byte HSTART, also
; dem Byte seiner X-Position,zugreift. Es werden die Werte einer vorausberechn.
; Tabelle (TABX) eingesetzt. Wenn wir nur auf HSTART agieren, dann bewegen wir
; den Sprite um jeweils 2 Pixel, und nicht nur einem, deswegen ist der Scroll
; etwas "ruckelig", vor allem wenn er langsamer wird.
; In den nächsten Listings werden wir dieses Manko beheben und mit einem Pixel
; scrollen.

BewegeSpriteX:
	ADDQ.L	#1,TABXPOINT		; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT(PC),A0	; Adresse, die im Long TABXPOINT enthalten ist
								; wird in a0 kopiert
	CMP.L	#ENDETABX-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann mach´ weiter
	MOVE.L	#TABX-1,TABXPOINT	; Starte wieder beim ersten Long
NOBSTARTX:
	MOVE.b	(A0),MEINSPRITE0+1	; Kopie das Byte aus der Tabelle in HSTART0
	MOVE.b	(A0),MEINSPRITE1+1	; Kopie das Byte aus der Tabelle in HSTART1
	rts

TABXPOINT:
	dc.l	TABX-1

; Tabelle mit vorberechneten X-Koordinaten.

TABX:
	incbin	"/Sources/XCOORDINAT.TAB"	; 334 Werte
ENDETABX:

; Diese Routine bewegt den Sprite nach Oben und nach Unten, indem sie auf
; die Bytes VSTART und VSTOP zugreift, also den Anfangs- und Endkoordinaten
; des Sprites. Es werden schon vordefinierte Koordinaten aus TABY eingesetzt.

BewegeSpriteY:
	ADDQ.L	#1,TABYPOINT		; Pointe auf das nächste Byte
	MOVE.L	TABYPOINT(PC),A0	; Adresse, die im Long TABXPOINT enthalten ist
								; wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann mach´ weiter
	MOVE.L	#TABY-1,TABYPOINT	; Starte wieder beim ersten Long
NOBSTARTY:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0				; kopieren das Byte aus der Tabelle in d0
	MOVE.b	d0,MEINSPRITE0		; kopieren das Byte in VSTART0
	MOVE.b	d0,MEINSPRITE1		; kopieren das Byte in VSTART1
	ADD.B	#15,D0				; Zähle die Länge eines Sprite dazu, um die
								; Endposition (VSTOP) zu ermitteln
	move.b	d0,MEINSPRITE0+2	; Setze den richtigen Wert in VSTOP0
	move.b	d0,MEINSPRITE1+2	; Setze den richtigen WErt in VSTOP1
	rts

TABYPOINT:
	dc.l	TABY-1				; Bemerke: die Werte der Tabelle sind Bytes

; Tabelle mit vorberechneten Y-Koordinaten.

TABY:
	incbin	"/Sources/YCOORDINAT.TAB"	; 200 Werte
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
	dc.w	$100,%0001001000000000	; Bit 12 an, 1 Bitplane lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

;	Palette der PIC

	dc.w	$180,$000		; Color0	; schwarzer Hintergrund
	dc.w	$182,$123		; Color1	; Color 1 des Bitplane, das
							; in diesem Fall leer ist,
							; also nicht erscheint

;	Palette der ATTACHED-SPRITE

	dc.w	$1A2,$FFC		; color17, Farbe 1 für die Attached-Sprites transp.
	dc.w	$1A4,$EEB		; color18, Farbe 2 für die Attached-Sprites
	dc.w	$1A6,$CD9		; color19, Farbe 3 für die Attached-Sprites
	dc.w	$1A8,$AC8		; color20, Farbe 4 für die Attached-Sprites
	dc.w	$1AA,$8B6		; color21, Farbe 5 für die Attached-Sprites
	dc.w	$1AC,$6A5		; color22, Farbe 6 für die Attached-Sprites
	dc.w	$1AE,$494		; color23, Farbe 7 für die Attached-Sprites
	dc.w	$1B0,$384		; color24, Farbe 7 für die Attached-Sprites
	dc.w	$1B2,$274		; color25, Farbe 9 für die Attached-Sprites
	dc.w	$1B4,$164		; color26, Farbe 10 für die Attached-Sprites
	dc.w	$1B6,$154		; color27, Farbe 11 für die Attached-Sprites
	dc.w	$1B8,$044		; color28, Farbe 12 für die Attached-Sprites
	dc.w	$1BA,$033		; color29, Farbe 13 für die Attached-Sprites
	dc.w	$1BC,$012		; color30, Farbe 14 für die Attached-Sprites
	dc.w	$1BE,$001		; color31, Farbe 15 für die Attached-Sprites

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier die Sprites: KLARERWEISE in CHIP RAM! **********

MEINSPRITE0:	; Länge 15 Zeilen
VSTART0:
	dc.b $00	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART0:
	dc.b $00	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP0:
	dc.b $00	; Vertikale Endposition des Sprite
	dc.b $00

	dc.w $0380,$0650,$04e8,$07d0,$0534,$1868,$1e5c,$1636 ; Daten des
	dc.w $377e,$5514,$43a1,$1595,$0172,$1317,$6858,$5035 ; Sprite 0
	dc.w $318c,$0c65,$7453,$27c9,$5ece,$5298,$0bfe,$2c32
	dc.w $005c,$13c4,$0be8,$0c18,$03e0,$03e0

	dc.w	0,0	; 2 auf 0 gesetzte Word markieren das Ende des Sprite


MEINSPRITE1:	; Länge 15 Zeilen
VSTART1:
	dc.b $00	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART1:
	dc.b $00	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP1:
	dc.b $00	; $50+13=$5d	; Vertikale Endposition des Sprite
	dc.b $00	; Bit 7 setzen, un die Sprites 0 und 1 zu vermählen

	dc.w $0430,$07f0,$0fc8,$0838,$0fe4,$101c,$39f2,$200e ; Daten des
	dc.w $58f2,$600e,$5873,$600f,$5cf1,$600f,$1ff3,$600f ; Sprite 1
	dc.w $4fe3,$701f,$47c7,$783f,$6286,$7d7e,$300e,$3ffe
	dc.w $1c3c,$1ffc,$0ff8,$0ff8,$03e0,$03e0

	dc.w	0,0	; 2 auf 0 gesetzte Word markieren das Ende des Sprites

	SECTION LEERESPLANE,BSS_C ; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

Außer der Neuigkeit des Attached-Bits, um einen Sprite in 16 Farben  statt
in 4 erscheinen zu lassen, gibt´s da noch einige Dinge:

1) Die Tabellen für X und Y wurden mit dem Befehl "WB"  abgespeichert  und
werden  nun mit dem Incbin geladen, eingebunden. Somit können verschiedene
Programme auf die selbe Tabelle zugreifen, Hauptsache, sie  befindet  sich
auf der Disk!
2) Es werden nicht mehr die Label VSTART0, VSTART1,  HSTART0  und  HSTART1
etc.  verwendet, um den Sprite zu bewegen. Die angesprochenen Bytes werden
nun auf folgende Weise erreicht:


	MEINSPRITE				; Für VSTART
	MEINSPRITE+1			; Für HSTART
	MEINSPRITE+2			; Für VSTOP

Damit kann ein Sprite ganz einfach so begonnen werden:

MEINSPRITE:
	DC.W	0,0
	..Daten..

Ohne die zwei Words in einzelne Bytes zerlegen zu müssen,  und  jedem  ein
Label  zuzuteilen.  Das  Verlängert  das  Listing  nur.  Auch um Bit 7 des
zweiten  Word  von  Sprite  1  zu  setzen,  um  also den AttachedModus
einzuschalten, reicht folgende Operation:

	bset	#7,MEINSPRITE1+3

Ansonsten hätten wir es "von Hand" in diesem vierten Byte setzen müssen:

MEINSPRITE1:
VSTART1:
	dc.b $00
HSTART1:
	dc.b $00
VSTOP1:
	dc.b $00
	dc.b %10000000			; oder dc.b $80 ($80=%10000000)

Wenn alle 8 Sprite verwendet werden müssen, dann  spart  man  damit  einen
Haufen  Labels  und  sonstigen Platz. Noch besser wäre es, die Adresse des
Sprites in ein Ax-Register  zu  geben  um  dann  mit  Offsets  dorthin  zu
gelangen, wohin man will:


	lea	MEINSPRITE,a0
	MOVE.B	#yy,(a0)		; Für VSTART
	MOVE.B	#xx,1(A0)		; Für HSTART
	MOVE.B	#y2,2(A0)		; Für VSTOP

Sich in Binärform einen Sprite in 16 Farben zu definieren wird so  langsam
problematisch.	Deswegen  ist  es  besser,  man  verläßt  sich  auf  ein
Malprogramm, man muß sich nur erinnern, daß ein Screen  zu  16  Farben  zu
wählen ist und die Sprites nicht breiter als 16 Pixel werden dürfen. Einmal
das Pic in 16 Farben  im  IFF-Format  abgespeichert  (oder  einen  Brush),
werden wir ihn mit dem IFF-Konverter genauso wie ein Bild konvertieren.

BEMERKUNG:  Unter  Brush versteht man ein Stück eines Bildes mit variabler
Größe.

Und so wird ein Sprite mit dem Kefcon konvertiert:

1) Ladet das IFF-File, das zu 16 Farben sein muß.
2) Ihr dürft nur den Sprite auswählen, um das zu  tun  drückt  die  rechte
Taste,  dann  positioniert  euch  in die linke, obere Ecke des zukünftigen
Sprite und drückt die linke Taste. Wenn ihr nun die Maus bewegt, erscheint
ein  Gittermuster,  das - wie es das Schicksal will - genau 16 Pixel breit
ist.  Ihr  könnt  natürlich  auch  die  Breite  und  Länge	des	Sprites
kontrollieren. Um den Sprite richtig ´reinzukriegen müßt ihr beachten, daß
ihr  den  Rand  des  Sprite  mit	dem	"Auswahlstrich"	des	Quadrates
überschreiten  müßt,  die  letzte noch beinhaltete Zeile des Quadrates ist
die, die auf der Grenze verläuft, und nicht die innerhalb des Quadrates.


	<----- 16 pixel ----->

	|========####========| /\
	||     ########	    || ||
	||   ############   || ||
	|| ################ || ||
	||##################|| ||
	###################### ||
	###################### Länge des Sprite, maximal 256 Pixel
	###################### ||
	||##################|| ||
	|| ################ || ||
	||   ############   || ||
	||     ########	    || ||
	|========####========| \/

Wenn der Sprite kleiner als 16 Pixel ist, dann müßt ihr einen freien  Rand
lassen,  auf  beiden  Rändern  oder  nur auf einem, so, daß die Breite des
Blocks immer 16 ist.

Einmal ausgewählt, muß der Sprite  als  "SPRITE16"  abgespeichert  werden,
oder  als  "SPRITE4", wenn es sich um einen "normalen" Sprite handelt. Der
Sprite wird in dc.b abgespeichert, also in Textformat, das  ihr  dann  mit
"I" im Listing einbinden könnt. Oder in einen anderen Textbuffer laden und
dann mit Amiga+b+c+i hinüberkopieren.

Und so speichert der KEFCON einen Attached-Sprite ab (16 Farben):

	dc.w $0000,$0000
	dc.w $0380,$0650,$04e8,$07d0,$0534,$1868,$1e5c,$1636
	dc.w $377e,$5514,$43a1,$1595,$0172,$1317,$6858,$5035
	dc.w $318c,$0c65,$7453,$27c9,$5ece,$5298,$0bfe,$2c32
	dc.w $005c,$13c4,$0be8,$0c18,$03e0,$03e0
	dc.w 0,0

	dc.w $0000,$0000
	dc.w $0430,$07f0,$0fc8,$0838,$0fe4,$101c,$39f2,$200e
	dc.w $58f2,$600e,$5873,$600f,$5cf1,$600f,$1ff3,$600f
	dc.w $4fe3,$701f,$47c7,$783f,$6286,$7d7e,$300e,$3ffe
	dc.w $1c3c,$1ffc,$0ff8,$0ff8,$03e0,$03e0
	dc.w 0,0

Wie ihr seht haben diese beiden Sprite die beiden Kontrollword  auf  NULL,
die  Daten  in Hexadezimal und die zwei auf 0 gesetzten Word, die das Ende
des Sprite markieren. Einfach die Label "Meinsprite0:" und  "Meinsprite1:"
am  Anfang  dieser  Sprites  geben,  und  dann  mit  Meinsprite+x  auf die
jeweiligen Bytes zugreifen, z.B. Koordinaten, Bit 7...  Das  Einzige,  das
noch  fehlt, ist ist das Setzen des Bit 7 für den Attached-Modus, entweder
mit einem BSET #7,MEINSPRITE+3 oder direkt im Sprite:

MEINSPRITE1:
	dc.w $0000,$0080		; $80, oder %10000000 -> ATTACCHED!

	dc.w $0430,$07f0,$0fc8,$0838,$0fe4,$101c,$39f2,$200e
	...

Wenn ihr nur Sprites zu 4 Farben macht, dann erübrigt sich das Problem, da
das Bit nicht gesetzt werden muß!

Was  die  Palette  der Sprites angeht, so müssen sie mit der Option COPPER
abgespeichert werden, genauso wie bei einem Bild. Das Problem  dabei  ist,
daß  alles  wie  ein  Bild  zu 16 Farben aufgefaßt wird, und nicht wie ein
Sprite:

	dc.w $0180,$0000,$0182,$0ffc,$0184,$0eeb,$0186,$0cd9
	dc.w $0188,$0ac8,$018a,$08b6,$018c,$06a5,$018e,$0494
	dc.w $0190,$0384,$0192,$0274,$0194,$0164,$0196,$0154
	dc.w $0198,$0044,$019a,$0033,$019c,$0012,$019e,$0001

Die Farben sind richtig, aber die Register beziehen sich auf die ersten 16
Farben, und nicht die letzten. Da muß man Hand  anlegen  und  sie  in  die
richtigen Register bringen:

	dc.w	$1A2,$FFC		; COLOR17, COLOR  1 für die Attached-Sprites
	dc.w	$1A4,$EEB		; COLOR18, COLOR  2 für die Attached-Sprites
	dc.w	$1A6,$CD9		; COLOR19, COLOR  3 für die Attached-Sprites
	dc.w	$1A8,$AC8		; COLOR20, COLOR  4 für die Attached-Sprites
	dc.w	$1AA,$8B6		; COLOR21, COLOR  5 für die Attached-Sprites
	dc.w	$1AC,$6A5		; COLOR22, COLOR  6 für die Attached-Sprites
	dc.w	$1AE,$494		; COLOR23, COLOR  7 für die Attached-Sprites
	dc.w	$1B0,$384		; COLOR24, COLOR  7 für die Attached-Sprites
	dc.w	$1B2,$274		; COLOR25, COLOR  9 für die Attached-Sprites
	dc.w	$1B4,$164		; COLOR26, COLOR 10 für die Attached-Sprites
	dc.w	$1B6,$154		; COLOR27, COLOR 11 für die Attached-Sprites
	dc.w	$1B8,$044		; COLOR28, COLOR 12 für die Attached-Sprites
	dc.w	$1BA,$033		; COLOR29, COLOR 13 für die Attached-Sprites
	dc.w	$1BC,$012		; COLOR30, COLOR 14 für die Attached-Sprites
	dc.w	$1BE,$001		; COLOR31, COLOR 15 für die Attached-Sprites

Man bemerke, daß in $1a2 der Wert von $182 kopiert werden muß, in $1a4 der
von $184 und so weiter.

Versucht, den Sprite zu 16 Farben aus diesem Listing mit einem  eigenem zu
ersetzen,  mit  eurer  Palette,  und  auch einen zu 4 Farben aus den alten
Listings zu konvertieren. Es zu Tun wird  euch  helfen,  alles  besser  zu
verstehen!!!


