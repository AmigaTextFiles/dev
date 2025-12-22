
; Lezione15f.s		Sprite in HIRES, Breite 16 pixel. Verwenden Sie die 
			; rechte Maustaste zum Wechseln zwischen LowRes und HighRes

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110100000	; copper, bitplane, sprite DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das leere Bild

	MOVE.L	#BITPLANE,d0		
	LEA	BPLPOINTERS,A1			; Zeiger in copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	alle Sprites zeigen auf das Null-Sprite 

	MOVE.L	#SpriteNullo,d0		; Adresse des Sprites in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	MOVEQ	#8-1,d1				; alle 8 sprites
NulLoop:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addq.w	#8,a1
	dbra	d1,NulLoop

;	Zeiger auf sprite

	MOVE.L	#MIOSPRITE,d0		; Adresse des Sprites in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

	move.b	$dff00a,mouse_y
	move.b	$dff00b,mouse_x

mouse:
	MOVE.L	#$1ff00,d1		; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2		; warte auf Zeile $120
Waity1:
	MOVE.L	4(A5),D0		; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0			; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0			; warte auf Zeile $120
	BNE.S	Waity1

	bsr.s	LeggiMouse		; das liest die Maus
	move.w	sprite_y(pc),d0 ; Parameter für die	
	move.w	sprite_x(pc),d1 ; universelle Routine vorbereiten
	lea	MIOSPRITE,a1		; Adresse sprite
	moveq	#13,d2			; Höhe sprite
	bsr.w	UniMuoviSprite	; ruft die universelle Routine auf

	MOVE.L	#$1ff00,d1		; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2		; warte auf Zeile $120
Aspetta:
	MOVE.L	4(A5),D0		; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0			; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0			; warte auf Zeile $120
	BEQ.S	Aspetta

	btst.b	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	NonScambiareRes	; Wenn nicht, ändern Sie das Ergebnis des Sprites nicht

	bchg.b	#7,BplCon3		; Wenn ja, wechseln Sie von LowRes zu Hires oder umgekehrt.

NonScambiareRes:
	btst.b	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse
	rts

; Diese Routine liest die Maus und aktualisiert die Werte der Variablen
; sprite_x und sprite_y

LeggiMouse:
	move.b	$dff00a,d1		; JOY0DAT vertikale Mausposition
	move.b	d1,d0			; Kopie in d0
	sub.b	mouse_y(PC),d0	; alte Mausposition subtrahieren
	beq.s	no_vert			; Wenn die Differenz = 0 ist, wird die Maus gestoppt
	ext.w	d0				; Byte in Word umwandeln
							; (siehe am Ende des Listings)
	add.w	d0,sprite_y		; Sprite-Position bearbeiten
no_vert:
  	move.b	d1,mouse_y		; Speichern der Mausposition für das nächste Mal

	move.b	$dff00b,d1		; horizontale Mausposition
	move.b	d1,d0			; Kopie in d0
	sub.b	mouse_x(PC),d0	; alte Mausposition subtrahieren
	beq.s	no_oriz			; Wenn die Differenz = 0 ist, wird die Maus gestoppt
	ext.w	d0				; Byte in Word umwandeln
							; (siehe am Ende des Listings)
	add.w	d0,sprite_x		; Sprite-Position bearbeiten
no_oriz
  	move.b	d1,mouse_x		; Speichern der Mausposition für das nächste Mal
	RTS

sprite_y:	dc.w	0	; Hier wird das Y des Sprites gespeichert
sprite_x:	dc.w	0	; Hier wird das X des Sprites gespeichert
mouse_y:	dc.b	0	; Hier wird das Y der Maus gespeichert
mouse_x:	dc.b	0	; Hier wird das X der Maus gespeichert


; Universelle Sprite-Platzierungsroutine.

;
;	Eingehende Parameter von UniMuoviSprite:
;
;	a1 = Adresse des sprites
;	d0 = vertikale Y-Position des Sprites auf dem Bildschirm (0-255)
;	d1 = horizontale X-Position des Sprites auf dem Bildschirm (0-320)
;	d2 = Höhe des sprites
;

UniMuoviSprite:
; vertikale Platzierung
	ADD.W	#$2c,d0		; Versatz des Bildschirmanfangs hinzufügen

; a1 enthält die Adresse des Sprites
	MOVE.b	d0,(a1)		; Kopie byte in VSTART
	btst.l	#8,d0
	beq.s	NonVSTARTSET
	bset.b	#2,3(a1)	; Bit 8 von VSTART setzen (Nummer > $FF)
	bra.s	ToVSTOP
NonVSTARTSET:
	bclr.b	#2,3(a1)	; Bit 8 von VSTART zurücksetzen (Nummer <$FF)
ToVSTOP:
	ADD.w	D2,D0		; die Höhe des Sprites hinzufügen
						; Bestimmen Sie die Endposition (VSTOP)
	move.b	d0,2(a1)	; den richtigen Wert in VSTOP verschieben
	btst.l	#8,d0
	beq.s	NonVSTOPSET
	bset.b	#1,3(a1)	; Bit 8 von VSTOP setzen  (Nummer> $FF)
	bra.w	VstopFIN
NonVSTOPSET:
	bclr.b	#1,3(a1)	; Bit 8 von VSTOP zurücksetzen (Numer < $FF)
VstopFIN:

; horizontale Platzierung
	add.w	#128,D1		; 128 - um das Sprite zu zentrieren.
	btst	#0,D1		; niedriges Bit der X-Koordinate gelöscht?
	beq.s	BitBassoZERO
	bset	#0,3(a1)	; das niedrige Bit von HSTART setzen
	bra.s	PlaceCoords

BitBassoZERO:
	bclr	#0,3(a1)	; das niedrige Bit von HSTART löschen
PlaceCoords:
	lsr.w	#1,D1		; SHIFT, das heißt, wir verschieben den Wert von
						; HSTART um 1 Bit nach rechts, um ihn in "umzuwandeln"
						; Wert setzt in das HSTART-Byte, ohne das
						; niedrige Bit.
	move.b	D1,1(a1)	; wir setzen den Wert XX in das HSTART-Byte
	rts

;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8	; auf 64 Bit ausrichten

	section	coppera,data_C

COPLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop

	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,-8		; Bpl1Mod (burst 64bit, modulo=modulo-8)
	dc.w	$10a,-8		; Bpl2Mod (wie oben)

				; 5432109876543210
	dc.w	$100,%0001001000000001	; 1 bitplane LORES 320x256.

	dc.w	$1fc,3		; Burst mode 64 bit

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste 	bitplane
	dc.w $e4,0,$e6,0	; zweite	   "
	dc.w $e8,0,$ea,0	; dritte	   "
	dc.w $ec,0,$ee,0	; vierte	   "
	dc.w $f0,0,$f2,0	; fünfte	   "
	dc.w $f4,0,$f6,0	; sechste	   "
	dc.w $f8,0,$fA,0	; siebte	   "
	dc.w $fC,0,$fE,0	; achte		   "

; Beachten Sie, dass die Sprite-Farben 24 Bit sind, auch wenn es nur 3 sind.

	DC.W	$106,$c00	; AUSWAHL PALETTE 0 (0-31), NIBBLE HOCH
COLP0:
	dc.w	$180,$000	; color0	; schwarzer Hintergrund
	dc.w	$182,$123	; color1	; Farbe 1 der Bitebene, die
									; in diesem Fall leer ist,
									; so erscheint sie nicht.

	dc.w	$1A2,$F00	; color17, das ist COLOR1 von sprite0 - ROT
	dc.w	$1A4,$0F0	; color18, das ist COLOR2 von sprite0 - GRÜN
	dc.w	$1A6,$FF0	; color19, das ist COLOR3 von sprite0 - GELB


	DC.W	$106,$e00	; AUSWAHL PALETTE 0 (0-31), NIBBLE NIEDRIG
COLP0B:
	dc.w	$180,$000	; color0	; schwarzer Hintergrund
	dc.w	$182,$000	; color1	; Farbe 1 der Bitebene, die
									; in diesem Fall leer ist,
									; so erscheint sie nicht.

	dc.w	$1A2,$462	; color17, nibble niedrig
	dc.w	$1A4,$2e4	; color18, nibble niedrig
	dc.w	$1A6,$672	; color19, nibble niedrig

	dc.w	$106		; BPLCON3
	dc.b	0
BplCon3:
	       ; 76543210
	dc.b	%10000000	; bit 7: sprites hires oder lowres. Wenn
		; sowohl Bit 7 als auch Bit 6 gesetzt sind ist das Sprite
		; in Superhires (1280x256), aber es kommt viel zu  "eng",
		; ich denke es ist nutzlos, nur hires!

	dc.w	$FFFF,$FFFE	; Ende copperlist


;*****************************************************************************
; Hier sind die Sprites: Offensichtlich müssen sie sich im CHIP-RAM befinden!
;*****************************************************************************

	cnop	0,8

SpriteNullo:			; Null-Sprite, um auf die copperliste zu zeigen
	dc.l	0,0,0,0		; in nicht verwendeten Zeigern


	cnop	0,8

MIOSPRITE:		; Länge 13 Zeilen
VSTART:
	dc.b $50	; Vertikale Sprite-Startposition ($2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Sprite-Startposition ($40 bis $d8)
VSTOP:
	dc.b $5d	; $50+13=$5d	; vertikale Position des Endsprites
VHBITS:
	dc.b $00	; bit

 dc.w	%0000000000000000,%0000110000110000 ; Binärformat für Änderungen
 dc.w	%0000000000000000,%0000011001100000
 dc.w	%0000000000000000,%0000001001000000
 dc.w	%0000000110000000,%0011000110001100 ; BINÄR 00=COLOR 0 (TRANSPARENT)
 dc.w	%0000011111100000,%0110011111100110 ; BINÄR 10=COLOR 1 (ROT)
 dc.w	%0000011111100000,%1100100110010011 ; BINÄR 01=COLOR 2 (GRÜN)
 dc.w	%0000110110110000,%1111100110011111 ; BINÄR 11=COLOR 3 (GELB)
 dc.w	%0000011111100000,%0000011111100000
 dc.w	%0000011111100000,%0001111001111000
 dc.w	%0000001111000000,%0011101111011100
 dc.w	%0000000110000000,%0011000110001100
 dc.w	%0000000000000000,%1111000000001111
 dc.w	%0000000000000000,%1111000000001111
 dc.w	0,0	; 2 gelöschte Wörter definieren das Ende des Sprites.


	cnop	0,8

	SECTION	PLANEVUOTO,BSS_C	; Die von uns verwendete Reset-Bitebene,
								; weil um die Sprites zu sehen
								; muss es  aktivierte Bitebenen geben

BITPLANE:
	ds.b	40*256				; bitplane leer lowres

	end

In diesem Listing gibt es bereits zwei Dinge über AGA-Sprites: Eine Sache ist, wie
wählen Sie die Auflösung zwischen LowRes, Hires oder SuperHires. Eigentlich ist
die SuperHires-Auflösung nutzlos, da das Sprite zu klein ist.
Eine andere Sache ist, dass die Sprite-Palette 24-Bit ist, wie Bitplanes.
Sie setzen also zuerst das hohe Nibble und dann das niedrige Nibble.

