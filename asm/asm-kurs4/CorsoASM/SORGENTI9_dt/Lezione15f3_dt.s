
; Lezione15f3.s		Sprite Größe 64 pixel. Verwenden Sie die rechte Maustaste
					;  zum Wechseln zwischen LowRes und HighRes

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

	MOVE.L	#MIOSPRITE64,d0		; Adresse des Sprites in d0
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
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2			; warte auf Zeile $120
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $120
	BNE.S	Waity1

	bsr.s	LeggiMouse			; das liest die Maus
	move.w	sprite_y(pc),d0		; Parameter für die 
	move.w	sprite_x(pc),d1		; universelle Routine vorbereiten
	lea	MIOSPRITE64,a1			; Adresse sprite
	moveq	#52,d2				; Höhe sprite
	bsr.w	UniMuoviSprite64	; ruft die universelle Routine auf

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2			; warte auf Zeile $120
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $120
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


; Universelle Positionierungsroutine für Sprites mit einer Breite von 64 Pixel.

;
;	Eingehende Parameter von UniMuoviSprite64:
;
;	a1 = Adresse des sprites
;	d0 = vertikale Y-Position des Sprites auf dem Bildschirm (0-255)
;	d1 = horizontale X-Position des Sprites auf dem Bildschirm (0-320)
;	d2 = Höhe des sprites
;

UniMuoviSprite64:
; vertikale Platzierung
	ADD.W	#$2c,d0		; Versatz des Bildschirmanfangs hinzufügen

; a1 enthält die Adresse des Sprites
	MOVE.b	d0,(a1)			; Kopie byte in VSTART
	btst.l	#8,d0
	beq.s	NonVSTARTSET
	bset.b	#2,3+4+2(a1)	; Bit 8 von VSTART setzen (Nummer > $FF)
	bra.s	ToVSTOP
NonVSTARTSET:
	bclr.b	#2,3+4+2(a1)	; Bit 8 von VSTART zurücksetzen (Nummer < $FF)
ToVSTOP:
	ADD.w	D2,D0			; die Höhe des Sprites hinzufügen
							; Bestimmen der Endposition (VSTOP)
	move.b	d0,2+4+2(a1)	; den richtigen Wert in VSTOP verschieben
	btst.l	#8,d0
	beq.s	NonVSTOPSET
	bset.b	#1,3+4+2(a1)	; Bit 8 von VSTOP setzen  (Nummer > $FF)
	bra.w	VstopFIN
NonVSTOPSET:
	bclr.b	#1,3+4+2(a1)	; Bit 8 von VSTOP zurücksetzen (Numer < $FF)
VstopFIN:

; horizontale Platzierung
	add.w	#128,D1			; 128 - um das Sprite zu zentrieren.
	btst.l	#0,D1			; niedriges Bit der X-Koordinate gelöscht?
	beq.s	BitBassoZERO
	bset.b	#0,3+4+2(a1)	; das niedrige Bit von HSTART setzen
	bra.s	PlaceCoords

BitBassoZERO:
	bclr.b	#0,3+4+2(a1)	; das niedrige Bit von HSTART löschen
PlaceCoords:
	lsr.w	#1,D1			; SHIFT, das heißt, wir verschieben den Wert von
							; HSTART um 1 Bit nach rechts, um ihn in "umzuwandeln"
							; Wert setzt in das HSTART-Byte, ohne das
							; niedrige Bit.
	move.b	D1,1(a1)		; wir setzen den Wert XX in das HSTART-Byte
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

	dc.w	$1fc,%1111	; Burst mode 64 bit, sprite Größe 64 pixel


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


	DC.W	$106,$e00	; AUSWAHL  PALETTE 0 (0-31), NIBBLE NIEDRIG
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
	dc.b	%00000000	; bit 7: sprites hires oder lowres. Wenn
		; sowohl Bit 7 als auch Bit 6 gesetzt sind ist das Sprite
		; in Superhires (1280x256), aber es kommt viel zu  "eng",
		; ich denke es ist nutzlos, nur hires!

	dc.w	$FFFF,$FFFE	; Ende copperlist


;*****************************************************************************
; Hier sind die Sprites: Offensichtlich müssen sie sich im CHIP-RAM befinden!
;*****************************************************************************

	cnop	0,8

SpriteNullo:			; Null-Sprite, um in der copperliste auf sie zu zeigen
	dc.l	0,0,0,0		; in nicht verwendeten Zeigern


	cnop	0,8

MIOSPRITE64:	; Länge 13*4 Zeilen
VSTART:
	dc.b $50	; Vertikale Sprite-Startposition ($2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Sprite-Startposition ($40 bis $d8)
	dc.w 0		; word + longword hinzugefügt, um das Doppelte zu erreichen
	dc.l 0		; longword für sprite Größe 64 pixel (2 long!)
VSTOP:
	dc.b $5d	; $50+13=$5d	; vertikale Position des Endsprites
VHBITS:
	dc.b $00	; bit
	dc.w 0		; word + longword hinzugefügt, um das Doppelte zu erreichen
	dc.l 0		; longword für sprite Größe 64 pixel (2 long!)

	dc.l	$00000000,$00000000,$00003000,$000c0000 ; gespeichert mit PicCon
	dc.l	$00000000,$00000000,$00003800,$001c0000
	dc.l	$00000000,$00000000,$00001c00,$00380000
	dc.l	$00000000,$00000000,$00000e00,$00700000
	dc.l	$00000000,$00000000,$00000700,$00e00000
	dc.l	$00000000,$00000000,$00000380,$01c00000
	dc.l	$00000000,$00000000,$000001c0,$03800000
	dc.l	$00000000,$00000000,$000000e0,$07000000
	dc.l	$00000000,$00000000,$00000070,$0e000000
	dc.l	$00000000,$00000000,$00000038,$1c000000
	dc.l	$00000000,$00000000,$00000038,$1c000000
	dc.l	$00000000,$00000000,$0000001c,$38000000
	dc.l	$0000000f,$f0000000,$000f001f,$f800f000
	dc.l	$0000003f,$fc000000,$003f003f,$fc00fc00
	dc.l	$0000007f,$fe000000,$007c007f,$fe003e00
	dc.l	$000000ff,$ff000000,$00f800ff,$ff001f00
	dc.l	$000001ff,$ff800000,$01f001ff,$ff800f80
	dc.l	$000003ff,$ffc00000,$03e003ff,$ffc007c0
	dc.l	$000007ff,$ffe00000,$07c007ff,$ffe003e0
	dc.l	$00000fff,$fff00000,$0f800fff,$fff001f0
	dc.l	$00001fff,$fff80000,$1f001c3f,$fc3800f8
	dc.l	$00003fff,$fffc0000,$3e00381f,$f81c007c
	dc.l	$00003fff,$fffc0000,$7c00300f,$f00c003e
	dc.l	$00007fff,$fffe0000,$fc00700f,$f00e003f
	dc.l	$00007f8f,$f1fe0000,$fffff00f,$f00fffff
	dc.l	$00007f0f,$f0fe0000,$fffff00f,$f00fffff
	dc.l	$00007f0f,$f0fe0000,$fffff80f,$f01fffff
	dc.l	$00007f1f,$f8fe0000,$7ffffc1f,$f83ffffe
	dc.l	$00003fff,$fffc0000,$00003fff,$fffc0000
	dc.l	$00003fff,$fffc0000,$00003fff,$fffc0000
	dc.l	$00001fff,$fff80000,$00007fff,$fffe0000
	dc.l	$00001fff,$fff80000,$0000ffff,$ffff0000
	dc.l	$00000fff,$fff00000,$0001ff80,$01ff8000
	dc.l	$00000fff,$fff00000,$0003ffc0,$03ffc000
	dc.l	$000007ff,$ffe00000,$0007ffe0,$07ffe000
	dc.l	$000003ff,$ffc00000,$0007fff0,$0fffe000
	dc.l	$000001ff,$ff800000,$000ff1ff,$ff8ff000
	dc.l	$000001ff,$ff800000,$001fe1ff,$ff87f800
	dc.l	$000000ff,$ff000000,$003fc0ff,$ff03fc00
	dc.l	$0000007f,$fe000000,$003fc07f,$fe03fc00
	dc.l	$0000003f,$fc000000,$007f803f,$fc01fe00
	dc.l	$0000001f,$f8000000,$007f801f,$f801fe00
	dc.l	$0000000f,$f0000000,$00ff000f,$f000ff00
	dc.l	$00000003,$c0000000,$00ff0003,$c000ff00
	dc.l	$00000000,$00000000,$03fe0000,$00007fc0
	dc.l	$00000000,$00000000,$0ffe0000,$00007ff0
	dc.l	$00000000,$00000000,$3ffe0000,$00007ffc
	dc.l	$00000000,$00000000,$7fff0000,$0000fffe
	dc.l	$00000000,$00000000,$ffff0000,$0000ffff
	dc.l	$00000000,$00000000,$ffff8000,$0001ffff
	dc.l	$00000000,$00000000,$ffff8000,$0001ffff
	dc.l	$00000000,$00000000,$ffff8000,$0001ffff

	dc.l	0,0,0,0		; Ende sprite (2 doppelte longword).

	cnop	0,8

	SECTION	PLANEVUOTO,BSS_C	; Die von uns verwendete Reset-Bitebene,
								; weil um die Sprites zu sehen
								; muss es aktivierte Bitebenen geben

BITPLANE:
	ds.b	40*256		; bitplane leer lowres

	end

Haben sie das schöne 63 Pixel breite Insekt gesehen? (Sie werden heute Nacht davon träumen!)
Die UniMuoviSprite  Routine wurde auf sehr einfache Weise modifiziert.
Tatsächlich wurden die 2 Bytes VSTOP und VHBITS um ein Word + eins long nach vorne verschoben.
Es war also genug zu ersetzen:

	2(a1) und 3(a1)

In:

	2+4+2(a1) und 3+4+2(a1)

Nichts einfacher!

