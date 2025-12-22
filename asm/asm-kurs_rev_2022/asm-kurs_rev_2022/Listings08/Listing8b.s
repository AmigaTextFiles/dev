
; Listing8b.s - Verwenden des universellen Startup als Beispiel
			; eine Fusion von Listing7o.s der Sprites und der Druck Routine 
			; von Lektion 6.

	Section	UsoLaStartUp,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; damit mache ich Einsparungen und 
									; schreib es nicht jedes mal neu!	
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen 
; werden sollen

			;5432109876543210
DMASET	EQU	%1000001110100000	; copper- und Bitplane-DMA aktiviert
;			 -----a-bcdefghij

;	a: Blitter Nasty   (Im Moment ist es uns egal, lassen wir es auf Null)
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die Sprites)
;	c: Copper DMA	   (Auch die copperliste wird nicht auf Null zurückgesetzt)
;	d: Blitter DMA	   (Im Moment sind wir nicht interessiert)
;	e: Sprite DMA	   (Nur die 8 Sprites verschwinden)
;	f: Disk DMA		   (Im Moment sind wir nicht interessiert)
;	g-j: Audio 3-0 DMA (Wir setzen den Amiga auf Null zurück)

; MAIN PROGRAM - Denken Sie daran, dass alle DMA-Kanäle gelöscht sind

START:
;	 Zeiger auf unsere BITPLANE

	MOVE.L	#BITPLANE,d0		; Adresse der Bitplane	
	LEA	BPLPOINTERS,A1			; Bitplanepointer in der copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Wir richten alle Sprites auf das Sprite null

	MOVE.L	#SpriteNullo,d0		; Adresse von sprite in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	MOVEQ	#8-1,d1				; alle 8 sprites
NulLoop:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addq.w	#8,a1
	dbra	d1,NulLoop

;	Wir zielen auf die sprites

	MOVE.L	#MIOSPRITE,d0		; Adresse sprite 1 in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	addq.w	#8,a1				; Zeiger auf sprite 2
	MOVE.L	#MIOSPRITE2,d0		; Adresse von sprite 2 in d0
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren Sie bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130, = 304
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.s	PrintCarattere		; Drucke jeweils ein Zeichen
	bsr.w	MuoviSprite			; Bewege die Sprites 0 und 1

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130, = 304
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts							; exit
		
*****************************************************************************
;			Druckroutine
*****************************************************************************

PRINTcarattere:
	MOVE.L	PuntaTESTO(PC),A0	; Adresse des zu druckenden Textes in a0
	MOVEQ	#0,D2				; leer d2
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	CMP.B	#$ff,d2				; Ende des Textsignals? ($FF)
	beq.s	FineTesto			; Wenn ja, beenden ohne zu drucken
	TST.B	d2					; Zeilenende-Signal? ($00)
	bne.s	NonFineRiga			; Wenn nicht, nicht einpacken

	ADD.L	#40*7,PuntaBITPLANE	; wir gehen zum Ende der Zeile
	ADDQ.L	#1,PuntaTesto		; erste Zeichenzeile nach
								; (überspringe die NULL)
	move.b	(a0)+,d2			; erstes Zeichen der nächsten Zeile
								; (überspringe die NULL)

NonFineRiga:
	SUB.B	#$20,D2				; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
								; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
								; (Das $20 entspricht), IN $00, DAS
								; AUSRUFUNGSZEICHEN ($21) IN $01....
	LSL.W	#3,D2				; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
								; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2			; FINDEN SIE DAS GEWÜNSCHTE ZEICHEN IM FONT...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adresse der Zielbitebene in a3

								; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)			; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,40(A3)		; Drucke Zeile 2  " "
	MOVE.B	(A2)+,40*2(A3)		; Drucke Zeile 3  " "
	MOVE.B	(A2)+,40*3(A3)		; Drucke Zeile 4 " "
	MOVE.B	(A2)+,40*4(A3)		; Drucke Zeile 5 " "
	MOVE.B	(A2)+,40*5(A3)		; Drucke Zeile 6  " "
	MOVE.B	(A2)+,40*6(A3)		; Drucke Zeile 7  " "
	MOVE.B	(A2)+,40*7(A3)		; Drucke Zeile 8  " "

	ADDQ.L	#1,PuntaBitplane	; wir bewegen uns 8 Bits vorwärts (NÄCHSTES ZEICHEN)
	ADDQ.L	#1,PuntaTesto		; nächstes zu druckendes Zeichen

FineTesto:
	RTS


PuntaTesto:
	dc.l	TESTO

PuntaBitplane:
	dc.l	BITPLANE

;	$00 für "Zeilenende" - $FF für "Textende"

			 ; Anzahl der Zeichen pro Zeile: 40
TESTO:	     ;		  1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'                                        ',0 ; 1
	dc.b	'    Dieses Listing verwendet die DMA    ',0 ; 2		
	dc.b	'                                        ',0 ; 3
	dc.b	'    Kanaele von COPPER, BITPLANE und    ',0 ; 4		
	dc.b	'                                        ',0 ; 5
	dc.b	'    SPRITE, deaktiviere sie nacheinander',0 ; 6		
	dc.b	'                                        ',0 ; 7
	dc.b	'    und sie werden sehen erst           ',0 ; 8
	dc.b	'                                        ',0 ; 9
	dc.b	'    verschwinden die Sprites, dann der  ',0 ; 10 
	dc.b	'                                        ',0 ; 11
	dc.b	'    Text und dann auch die Coppertoene! ',$FF ; 12

	EVEN
	
*****************************************************************************
;	Sprite-Routinen
*****************************************************************************

MuoviSprite:
	ADDQ.L	#1,TABYPOINT		; auf das nächste Byte zeigen
	MOVE.L	TABYPOINT(PC),A0	; Adresse, die im long TABXPOINT enthalten ist
								; kopiert nach a0
	CMP.L	#FINETABY-1,A0		; Sind wir beim letzten Byte der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann geht es weiter
	MOVE.L	#TABY-1,TABYPOINT	; Beginnt wieder ab dem ersten Byte
NOBSTARTY:
	moveq	#0,d0				; d0 löschen
	MOVE.b	(A0),d0				; Kopiert das Byte der Tabelle, dh die
								; Y-Koordinate in d0

	ADDQ.L	#2,TABXPOINT		; auf das nächste Wort zeigen
	MOVE.L	TABXPOINT(PC),A0	; Adresse, die im long TABXPOINT enthalten ist
								; kopiert nach a0
	CMP.L	#FINETABX-2,A0		; Sind wir beim letzten Wort der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann geht es weiter
	MOVE.L	#TABX-2,TABXPOINT	; Beginnt wieder ab dem ersten Wort-2
NOBSTARTX:
	moveq	#0,d1				; d1 löschen
	MOVE.w	(A0),d1				; wir setzen den Wert der Tabelle, das heißt
								; die X-Koordinate in d1

	lea	MIOSPRITE,a1			; Adresse des sprites in A1
	moveq	#13,d2				; Höhe von sprite in d2

	bsr.w	UniMuoviSprite		; führt die universelle Routine aus, die 
								; das Sprite positioniert
; zweites sprite

	ADDQ.L	#1,TABYPOINT2		; auf das nächste Byte zeigen
	MOVE.L	TABYPOINT2(PC),A0	; Adresse, die im long TABXPOINT enthalten ist
								; kopiert nach a0
	CMP.L	#FINETABY-1,A0		; Sind wir beim letzten Byte der TAB?
	BNE.S	NOBSTARTY2			; noch nicht? dann geht es weiter
	MOVE.L	#TABY-1,TABYPOINT2  ; Beginnt wiedert ab dem ersten Byte
NOBSTARTY2:
	moveq	#0,d0				; d0 löschen
	MOVE.b	(A0),d0				; Kopiert das Byte der Tabelle, dh die
								; Y-Koordinate in d0

	ADDQ.L	#2,TABXPOINT2		; auf das nächste Wort zeigen
	MOVE.L	TABXPOINT2(PC),A0	; Adresse, die im long TABXPOINT enthalten ist
								; kopiert nach a0
	CMP.L	#FINETABX-2,A0		; Sind wir beim letzten Wort der TAB?
	BNE.S	NOBSTARTX2			; noch nicht? dann geht es weiter
	MOVE.L	#TABX-2,TABXPOINT2  ; Beginnt wieder ab dem ersten Wort-2
NOBSTARTX2:
	moveq	#0,d1				; d1 löschen
	MOVE.w	(A0),d1				; wir setzen den Wert der Tabelle, das heißt
								; die X-Koordinate in d1

	lea	MIOSPRITE2,a1			; Adresse des sprites in A1
	moveq	#8,d2				; Höhe des sprites in d2

	bsr.w	UniMuoviSprite		; führt die universelle Routine aus, die 
								; das Sprite positioniert
	rts

; Zeiger auf die Tabellen des ersten Sprites

TABYPOINT:
	dc.l	TABY-1
TABXPOINT:
	dc.l	TABX-2

; Zeiger auf die Tabellen des zweiten Sprites

TABYPOINT2:
	dc.l	TABY+40-1
TABXPOINT2:
	dc.l	TABX+96-2

; Tabelle mit vorberechneten Y-Koordinaten des Sprites.
TABY:
	incbin	"/Sources/ycoordinatok.tab"	; 200 Wert .B
FINETABY:

; Tabelle mit vorberechneten X-Koordinaten des Sprites.
TABX:
	incbin	"/Sources/xcoordinatok.tab"	; 150 Wert .W
FINETABX:

; Universelle Sprite-Positionierungsroutine

;
;	UniMuoviSprite Eingabeparameter:
;
;	a1 = Adresse des Sprites
;	d0 = vertikale Y-Position des Sprites auf dem Bildschirm (0-255)
;	d1 = horizontale X-Position des Sprites auf dem Bildschirm (0-320)
;	d2 = Höhe des Sprites
;

UniMuoviSprite:
; vertikale Positionierung
	ADD.W	#$2c,d0				; addiert den Offset vom Anfang des Bildschirms

; a1 enthält die Sprite-Adresse
	MOVE.b	d0,(a1)				; Kopiert das Byte nach VSTART
	btst.l	#8,d0
	beq.s	NonVSTARTSET
	bset.b	#2,3(a1)			; Bit 8 von VSTART setzen (Zahl > $FF)
	bra.s	ToVSTOP
NonVSTARTSET:
	bclr.b	#2,3(a1)			; Bit 8 von VSTART zurücksetzen (Zahl < $FF)
ToVSTOP:
	ADD.w	D2,D0				; addiert die Höhe des Sprites
								; Endposition ermitteln (VSTOP)
	move.b	d0,2(a1)			; kopiert den richtigen Wert nach VSTOP
	btst.l	#8,d0
	beq.s	NonVSTOPSET
	bset.b	#1,3(a1)			; Bit 8 von VSTOP setzen (Zahl > $FF)
	bra.w	VstopFIN
NonVSTOPSET:
	bclr.b	#1,3(a1)			; Bit 8 von VSTOP zurücksetzen (Zahl < $FF)
VstopFIN:

; horizontale Positionierung
	add.w	#128,D1				; 128 - um das Sprite zu zentrieren.
	btst	#0,D1				; niedriges Bit der X-Koordinate zurückgesetzt?
	beq.s	BitBassoZERO
	bset	#0,3(a1)			; Wir setzen das Low-Bit von HSTART
	bra.s	PlaceCoords

BitBassoZERO:
	bclr	#0,3(a1)			; Wir setzen das Low-Bit von HSTART zurück

PlaceCoords:
	lsr.w	#1,D1				; Wir SHIFTen, d.h. wir verschieben
								; der Wert von HSTART um 1 Bit nach rechts,
								; um den Wert in das HSTART-Byte zu setzen
								; ohne das niedrige Bit.
	move.b	D1,1(a1)			; Wir setzen den Wert XX im HSTART-Byte
	rts

*****************************************************************************

; Die FONT 8x8-Zeichen, die in CHIP von der CPU und nicht vom Blitter kopiert
; wurden, so kann es auch im schnellen RAM sein. In der Tat wäre es besser!

FONT:
	incbin	"/Sources/nice.fnt"

*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,$24			; BplCon2 - Alle Sprites über die Bitplane
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
				; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste bitplane

	dc.w	$0180,$000			; color0 - HINTERGRUND
	dc.w	$0182,$19a			; color1 - SCHRIFT
			
	dc.w	$1A2,$F00			; color17, das ist FARBE1 vom sprite0 - ROT
	dc.w	$1A4,$0F0			; color18, das ist FARBE2 des sprite0 - GRÜN
	dc.w	$1A6,$FF0			; color19, das ist FARBE3 des Sprite0 - GELB

;	Gradient copperlist

	dc.w	$5007,$fffe			; Warte Zeile $50
	dc.w	$180,$001			; color0
	dc.w	$5207,$fffe			; Warte Zeile $52
	dc.w	$180,$002			; color0
	dc.w	$5407,$fffe			; Warte Zeile $54
	dc.w	$180,$003			; color0
	dc.w	$5607,$fffe			; Warte Zeile $56
	dc.w	$180,$004			; color0
	dc.w	$5807,$fffe			; Warte Zeilea $58
	dc.w	$180,$005			; color0
	dc.w	$5a07,$fffe			; Warte Zeile $5a
	dc.w	$180,$006			; color0
	dc.w	$5c07,$fffe			; Warte Zeile $5c
	dc.w	$180,$007			; color0
	dc.w	$5e07,$fffe			; Warte Zeile $5e
	dc.w	$180,$008			; color0
	dc.w	$6007,$fffe			; Warte Zeile $60
	dc.w	$180,$009			; color0
	dc.w	$6207,$fffe			; Warte Zeile $62
	dc.w	$180,$00a			; color0
	dc.w	$FFFF,$FFFE			; Ende copperlist


; ************ Hier sind die Sprites: Natürlich müssen sie in CHIP RAM! sein ********

SpriteNullo:					; Sprite null, um auf die copperlist zu verweisen
	dc.l	0,0,0,0				; in nicht verwendeten Zeigern


MIOSPRITE:		; Länge 13 Zeilen
	dc.b $50	; vertikale Startposition des Sprites (von $2c bis $f2)
	dc.b $90	; horizontale Startposition des Sprites (von $40 bis $d8)
	dc.b $5d	; $50+13=$5d	; vertikale Endposition des Sprites
	dc.b $00
 dc.w	%0000000000000000,%0000110000110000 ; Binärformat für Änderungen
 dc.w	%0000000000000000,%0000011001100000
 dc.w	%0000000000000000,%0000001001000000
 dc.w	%0000000110000000,%0011000110001100 ; BINÄR 00=COLOR 0 (TRASPARENT)
 dc.w	%0000011111100000,%0110011111100110 ; BINÄR 10=COLOR 1 (ROT)
 dc.w	%0000011111100000,%1100100110010011 ; BINÄR 01=COLOR 2 (GRÜN)
 dc.w	%0000110110110000,%1111100110011111 ; BINäR 11=COLOR 3 (GELB)
 dc.w	%0000011111100000,%0000011111100000
 dc.w	%0000011111100000,%0001111001111000
 dc.w	%0000001111000000,%0011101111011100
 dc.w	%0000000110000000,%0011000110001100
 dc.w	%0000000000000000,%1111000000001111
 dc.w	%0000000000000000,%1111000000001111
 dc.w	0,0		; 2 word definiert das Ende des Sprites.


MIOSPRITE2:		; Länge 8 Zeilen
VSTART2:
	dc.b $60	; Pos. vertikal (von $2c bis $f2)
HSTART2:
	dc.b $60+(14*2)	; Pos. horizontal (von $40 bis $d8)
VSTOP2:
	dc.b $68	; $60+8=$68	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0011111111111100,%1100001000100011
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0111111111111110,%1000000111000001
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende sprite


*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256				; unsere bitplane lowres 320x256

	end

In diesem Listing erscheinen zwei Optimierungen von bereits bekannten Routinen.
Die eine ist die in Lektion 8 besprochene, nämlich das Warten auf die vertikale
Zeile:

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130, = 304
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1	

Ich erinnere Sie daran, dass die maximale Zeile auf die sie warten können $138
beträgt, wenn Sie auf $139 oder höher warten, stürzt die Routine ab, weil
dieser Wert nie auftritt.

Die andere Optimierung, die möglicherweise unbemerkt geblieben ist, ist ein:

	MULU.W	#8,d2

Welches umgewandelt wurde in:

	LSL.W	#3,D2				; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
								; da die Charakter ja 8 Pixel hoch sind

in der Druckroutine. Nun, eine Verschiebung um 3 Bits nach links entspricht
dem multiplizieren mit 8, genauso wie eine Verschiebung um ein Bit nach links
einer Multiplizikation mit 2 und eine Verschgiebung um 2 Bits nach links 
bedeutet, mit 4 zu multiplizieren.
Der Grund dafür ist, dass das Binärsystem die Multiplikation und Division
mit Potenzen von 2 erleichtert. Schauen wir uns ein Beispiel an:

	5 * 8 = 40

Schauen wir uns das in binärer Form an:

	%00000101 * %00001000 = %00101000

Wie Sie sehen können, ist das Ergebnis 40 dasselbe wie 5, jedoch mit den Bits
um 3 Positionen nach links verschoben. Wir werden später viele dieser Tricks
sehen, um den Code zu beschleunigen. Das Wichtigste, sich daran zu erinnern,
das die Multiplikation und Division SEHR LANGSAM sind, also schaffe sie aus dem
Weg. Es ist sehr nützlich, sie durch etwas anderes zu ersetzen.

