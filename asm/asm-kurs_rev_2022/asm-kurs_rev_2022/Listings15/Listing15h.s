
; Listing15h.s		- Beispiel für die BPLCON4-Effekte in der Palette

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

		    ;5432109876543210
DMASET	EQU	%1000001110000000	; copper, bitplane DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das AGA-Bild

	MOVE.L	#PICTURE,d0
	LEA	BPLPOINTERS,A1
	MOVEQ	#8-1,D7				; Anzahl bitplanes
POINTB:
	move.w	d0,6(a1)		
	swap	d0			
	move.w	d0,2(a1)		
	swap	d0			
	addi.l	#10240,d0			; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTB			; D7-mal wiederholen (D7= Anzahl bitplanes)

	bsr.s	MettiColori

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normale
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

LOOP:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2			; warte auf Zeile $110
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $110
	BNE.S	Waity1

Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $110
	BEQ.S	Aspetta

	bsr.s	CambiaCon4

	BTST	#6,$BFE001
	BNE.S	LOOP
	RTS

CambiaCon4:
	addq.b	#1,ContaSpetta
	cmp.b	#20,ContaSpetta		; Letzte 20 Frames?
	bne.s	NonAncora	
	clr.b	ContaSpetta			; "Timer" zurücksetzen
	addq.b	#1,MioCon4			; High-Byte von bplcon4 ändern
NonAncora:
	rts

ContaSpetta:
	dc.w	0

MettiColori:
	LEA	PICTURE+(10240*8),A0	; Adresse der Farbpalette am
								; Ende des Bildes -> in A0
	LEA	COLP0+2,A1				; Adresse des ersten Registers
								; auf hohes nibble eingestellt
	LEA	COLP0B+2,A2				; Adresse des ersten Registers
								; auf niedriges nibble eingestellt
	MOVEQ	#8-1,d7				; 8 Banken mit jeweils 32 Registern
ConvertiPaletteBank:
	moveq	#0,d0
	moveq	#0,d2
	moveq	#0,d3
	moveq	#32-1,d6			; 32 Farbregister pro Bank

DaLongARegistri:				; Schleife, die die Farben $00RrGgBb.l in die 2 
								; Wörter $0RGB, $0rgb geeignet für copperregister umwandelt.

; Konvertieren niedriger Nibbles von $00RrGgBb (long) in die Farbe AGA $0rgb (word)

	MOVE.B	1(A0),(a2)			; Hohes Byte der Farbe $00Rr0000 kopiert
								; in das Cop-Register für niedriges nibble
	ANDI.B	#%00001111,(a2)		; auswählen nur niedriges nibble ($0r)
	move.b	2(a0),d2			; Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	lsl.b	#4,d2				; verschiebt das niedrige Halbbyte um 4 Bit nach links
								; des GRÜNEN, "umwandeln" in ein hohes nibble
								; des niedrigen Bytes von D2 ($g0)
	move.b	3(a0),d3			; Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%00001111,d3		; auswählen nur niedriges nibble ($0b)
	or.b	d2,d3				; "MISCHEN" der niedrigen nibble von grün und blau...
	move.b	d3,1(a2)			; Bilden des nachfolgenden Low-Bytes $gb zum Setzen
								; im Farbregister nach dem Byte $0r für
								; Bilden Sie das Wort $0rgb der niedrigen nibble

; Konvertieren hohe Nibbles von $00RrGgBb (long) in die Farbe AGA $0RGB (word)

	MOVE.B	1(A0),d0			; Hohes Byte der Farbe $00Rr0000 in d0
	ANDI.B	#%11110000,d0		; auswählen nur hohes nibble ($R0)
	lsr.b	#4,d0				; verschiebt das nibble um 4 Bit nach rechts, also
								; dadurch wird es zum Low-Byte-Nibble ($0R).
	move.b	d0,(a1)				; Kopieren Sie das High-Byte $0R in das Farbregister
	move.b	2(a0),d2			; das Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d2		; auswählen nur hohes nibble ($G0)
	move.b	3(a0),d3			; das Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d3		; auswählen nur hohes nibble ($B0)
	lsr.b	#4,d3				; verschiebt es um 4 Bit nach rechts
								; dadurch wird es zum Low-Byte-Nibble d3 ($0B)
	or.b	d2,d3				; Mischen der hohen nibble von Grün und Blau ($G0 + $0B)
	move.b	d3,1(a1)			; Bilden des letzten Low-Bytes $GB zum Setzen
								; im Farbregister nach dem Byte $0R für
								; Bilden Sie das Wort $0RGB der hohen nibble

	addq.w	#4,a0				; zur nächsten Farbe .l der Palette springen
								; am unteren Rand des Bildes angebracht
	addq.w	#4,a1				; zum nächsten Farbregister springen
								; für hohes nibble in Copperlist
	addq.w	#4,a2				; zum nächsten Farbregister springen
								; für niedriges nibble in Copperlist

	dbra	d6,DaLongARegistri

	add.w	#(128+8),a1			; Farbregister überspringen + dc.w $106,xxx
								; des hohen nibble
	add.w	#(128+8),a2			; Farbregister überspringen + dc.w $106,xxx
								; des niedrigen nibble

	dbra	d7,ConvertiPaletteBank	; Konvertiert eine Bank mit 32 Farben von
	rts							; Schleife. 8 Schleifen für 256 Farben.


;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8					; ausgerichtet auf 64 bit

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
	dc.w	$10c				; BplCon4
MioCon4:
	dc.w	0

				; 5432109876543210
	dc.w	$100,%0000001000010001	; 8 bitplane LOWRES 320x256. Zum
					; Setzen von 8 planes, Bit 4 setzen
					; Bit 12,13,14 zurücksetzen. Bit 0 ist gesetzt,
					; da es viele AGA-Funktionen ermöglicht
					; die wir später sehen werden.

	dc.w	$1fc,0				; Burst mode gelöscht (im Augenblick!)

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste 	bitplane
	dc.w	$e4,0,$e6,0			; zweite	   "
	dc.w	$e8,0,$ea,0			; dritte	   "
	dc.w	$ec,0,$ee,0			; vierte	   "
	dc.w	$f0,0,$f2,0			; fünfte	   "
	dc.w	$f4,0,$f6,0			; sechste	   "
	dc.w	$f8,0,$fA,0			; siebte	   "
	dc.w	$fC,0,$fE,0			; achte		   "

; In diesem Fall wird die Palette durch eine Routine aktualisiert, daher
; reicht es aus, die Registerwerte gelöscht zu lassen

	DC.W	$106,$c00	; AUSWAHL PALETTE 0 (0-31), NIBBLE HOCH
COLP0:
	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$e00	; AUSWAHL PALETTE 0 (0-31), NIBBLE NIEDRIG
COLP0B:
	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$2C00	; AUSWAHL PALETTE 1 (32-63), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$2E00	; AUSWAHL PALETTE 1 (32-63), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$4C00	; AUSWAHL PALETTE 2 (64-95), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$4E00	; AUSWAHL PALETTE 2 (64-95), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$6C00	; AUSWAHL PALETTE 3 (96-127), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$6E00	; AUSWAHL PALETTE 3 (96-127), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$8C00	; AUSWAHL PALETTE 4 (128-159), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$8E00	; AUSWAHL PALETTE 4 (128-159), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$AC00	; AUSWAHL PALETTE 5 (160-191), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$AE00	; AUSWAHL PALETTE 5 (160-191), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$CC00	; AUSWAHL PALETTE 6 (192-223), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$CE00	; AUSWAHL PALETTE 6 (192-223), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$EC00	; AUSWAHL PALETTE 7 (224-255), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$EE00	; AUSWAHL PALETTE 7 (224-255), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	dc.w	$FFFF,$FFFE	; Ende copperlist

;******************************************************************************

; Bild RAW mit 8 bitplanes, das sind 256 Farben

	CNOP	0,8	; auf 64 Bit ausrichten

PICTURE:
	INCBIN	"/Sources/MURALE320x256x256c.RAW"
	
	end

Dieses Beispiel ist sicherlich nicht "schön", aber es gibt eine Vorstellung
von den Registern, was sicherlich in bestimmten Routinen nützlich ist, um
die Palette zu ändern .... 
Sie könnten zum Beispiel ein $10c in jede Zeile setzen, um die Palette
auf viele verschiedene Arten zu ändern ... wer weiß ....