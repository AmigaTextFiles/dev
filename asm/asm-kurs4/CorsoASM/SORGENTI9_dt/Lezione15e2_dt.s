
; Lezione15e2.s	- Wir zeigen zwei Bilder zusammen, eines mit 256 Farben und
; das andere in HAM8. Bemerken Sie den Unterschied?

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper, bitplane DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das AGA-Bild

	MOVE.L	#PICTURE,d0
	LEA	BPLPOINTERS,A1
	MOVEQ	#8-1,D7			; Anzahl bitplanes
POINTB:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addi.l	#80*100,d0		; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTB		; D7-mal wiederholen (D7 = Anzahl bitplanes)

	MOVE.L	#PICTUREHAM,d0
	LEA	BPLPOINTERSham,A1
	MOVEQ	#8-1,D7			; Anzahl bitplanes
POINTBham:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addi.l	#80*100,d0		; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTBham	; D7-mal wiederholen (D7 = Anzahl bitplanes)


; Für das Bild 256 Farben

	LEA	LogoPal(PC),A0		; Adresse der Farbpalette 
	LEA	COLP0+2,A1			; Adresse des ersten Registers
							; auf hohes nibble eingestellt
	LEA	COLP0B+2,A2			; Adresse des ersten Registers
							; auf niedriges nibble eingestellt
	MOVEQ	#8-1,d7			; 8 Banken mit jeweils 32 Registern
	bsr.s	MettiColori


; Für das Bild HAM8

	LEA	LogoPalHAM(PC),A0	; Adresse der Farbpalette  
	LEA	COLP0ham+2,A1		; Adresse des ersten Registers
							; auf hohes nibble eingestellt
	LEA	COLP0Bham+2,A2		; Adresse des ersten Registers
							; auf niedriges nibble eingestellt
	MOVEQ	#2-1,d7			; 2 Banken mit jeweils 32 Registern
	bsr.s	MettiColori


	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

LOOP:
	BTST	#6,$BFE001
	BNE.S	LOOP
	RTS


; Diese Routine, die auch in meinem WORLD OF MANGA-Demo enthalten ist, wird 
; zum Lesen der 24-Bit-Palette benötigt. In diesem Fall wird sie durch ein INCBIN erhalten.
; Grundsätzlich konvertiert es jede Farbe in 24-Bit, die im Format von 
; ein langes $00RrGgBb kommt, wobei R = hohes nibble von ROT, r = niedriges nibble von ROT,
; G = hohes nibble von GRÜN usw., im copperlistenformat aga, das heißt
; in zwei Worten $0RGB mit hohen nibble und $0rgb mit niedrigen nibble.

MettiColori:
ConvertiPaletteBank:
	moveq	#0,d0
	moveq	#0,d2
	moveq	#0,d3
	moveq	#32-1,d6	; 32 Farbregister pro Bank

DaLongARegistri:		; Schleife, die die Farben $00RrGgBb.l in die 2 
				; Wörter $0RGB, $0rgb geeignet für copperregister umwandelt.

; Konvertieren niedriger Nibbles von $00RrGgBb (long) in die Farbe AGA $0rgb (word)

	MOVE.B	1(A0),(a2)	; Hohes Byte der Farbe $00Rr0000 kopiert
						; in das Cop-Register für niedriges nibble
	ANDI.B	#%00001111,(a2) ; auswählen nur niedriges nibble ($0r)
	move.b	2(a0),d2	; Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	lsl.b	#4,d2		; verschiebt das niedrige Halbbyte um 4 Bit nach links
						; des GRÜNEN, "umwandeln" in ein hohes nibble
						; des niedrigen Bytes von d2 ($g0)
	move.b	3(a0),d3	; Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%00001111,d3	; auswählen nur niedriges nibble ($0b)
	or.b	d2,d3		; "MISCHEN" der niedrigen nibble von grün und blau...
	move.b	d3,1(a2)	; Bilden des nachfolgenden Low-Bytes $gb zum Setzen
						; im Farbregister nach dem Byte $0r für
						; das word $0rgb der niedrigen nibble

; Konvertieren hohe Nibbles von $00RrGgBb (long) in die Farbe AGA $0RGB (word)

	MOVE.B	1(A0),d0	; Hohes Byte der Farbe $00Rr0000 in d0
	ANDI.B	#%11110000,d0	; auswählen nur hohes nibble ($R0)
	lsr.b	#4,d0		; verschiebt das nibble um 4 Bit nach rechts, also
						; dadurch wird es zum Low-Byte-Nibble ($0R).
	move.b	d0,(a1)		; das High-Byte $0R in das Farbregister kopieren
	move.b	2(a0),d2	; das Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d2	; auswählen nur hohes nibble ($G0)
	move.b	3(a0),d3	; das Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d3	; auswählen nur hohes nibble ($B0)
	lsr.b	#4,d3		; verschiebt es um 4 Bit nach rechts
						; dadurch wird es zum Low-Byte-Nibble d3 ($0B)
	or.b	d2,d3		; Mischen der hohen nibble von Grün und Blau ($G0+$0B)
	move.b	d3,1(a1)	; Bilden des letzten Low-Bytes $GB zum Setzen
						; im Farbregister nach dem Byte $0R für
						; das Wort $0RGB der hohen nibble

	addq.w	#4,a0		; zur nächsten Farbe .l der Palette springen
						; am unteren Rand des Bildes angebracht
	addq.w	#4,a1		; zum nächsten Farbregister springen
						; für hohes nibble in Copperlist
	addq.w	#4,a2		; zum nächsten Farbregister springen
						; für niedriges nibble in Copperlist

	dbra	d6,DaLongARegistri

	add.w	#(128+8),a1	; Farbregister überspringen + dc.w $106,xxx
						; des hohen nibble
	add.w	#(128+8),a2	; Farbregister überspringen + dc.w $106,xxx
						; des niedrigen nibble

	dbra	d7,ConvertiPaletteBank	; Konvertiert eine Bank mit 32 Farben von
	rts					; Schleife. 8 Schleifen für 256 Farben.

; Palette mit PicCon als Binärdatei gespeichert (Option: save as binary, nicht als cop)

LogoPal:
	incbin	"Pic640x100x256.pal"

LogoPalHAM:
	incbin	"pic640x100xham8.pal"

;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8	; auf 64 Bit ausrichten

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop

; Hinweis: Die ddfstart/stop HIRES wären $003c und $00d4, aber mit dem Burst aktiv
; der gleiche Wert wie bei LOWRES ist in Ordnung, dh $0038 und $00d0.

	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,-8		; Bpl1Mod (burst 64bit, modulo=modulo-8)
	dc.w	$10a,-8		; Bpl2Mod (wie oben)

			    ; 5432109876543210
	dc.w	$100,%1000001000010001	; 8 bitplane HIRES 640x256. Zum
					; Setzen von 8 planes, Bit 4 setzen
					; Bit 12,13,14 zurücksetzen. Bit 0 ist gesetzt,
					; da es viele AGA-Funktionen ermöglicht
					; die wir später sehen werden.

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

; In diesem Fall wird die Palette durch eine Routine aktualisiert, daher
; reicht es aus, die Registerwerte gelöscht zu lassen.

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

	dc.w	$9007,$fffe	; auf das Ende des Logos warten 
	dc.w	$100,$201	; null bitplanes

; RAW wird mit PicCon gespeichert, sodass Sie normal darauf zeigen können.

BPLPOINTERSham:
	dc.w $e0,0,$e2,0	; erstze 	bitplane
	dc.w $e4,0,$e6,0	; zweite	   "
	dc.w $e8,0,$ea,0	; dritte		   "
	dc.w $ec,0,$ee,0	; vierte	   "
	dc.w $f0,0,$f2,0	; fünfte	   "
	dc.w $f4,0,$f6,0	; sechste	   "
	dc.w $f8,0,$fA,0	; siebte	   "
	dc.w $fC,0,$fE,0	; achte	   "

; Dies ist die Reihenfolge der Bitebenen, wenn Sie die RAW mit AgaConv speichern
;
;	dc.w $e8,0,$ea,0	; dritte    bitplane
;	dc.w $ec,0,$ee,0	; vierte	   "
;	dc.w $f0,0,$f2,0	; fünfte	   "
;	dc.w $f4,0,$f6,0	; sechste	   "
;	dc.w $f8,0,$fA,0	; siebte	   "
;	dc.w $fC,0,$fE,0	; achte		   "
;	dc.w $e0,0,$e2,0	; erste 	   "
;	dc.w $e4,0,$e6,0	; zweite	   "


; In diesem Fall wird die Palette durch eine Routine aktualisiert, daher
; reicht es aus, die Registerwerte gelöscht zu lassen.

; *HINWEIS: IN HAM8 DEFINIEREN SIE NUR 64 FARBEN, NICHT ALLE 255 !!!!!

	DC.W	$106,$c00	; AUSWAHL PALETTE 0 (0-31), NIBBLE HOCH
COLP0ham:
	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$e00	; AUSWAHL PALETTE 0 (0-31), NIBBLE NIEDRIG
COLP0Bham:
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

	dc.w	$9507,$fffe

				; 5432109876543210
	dc.w	$100,%1000101000010001	; 8 bitplane HIRES 640x256 HAM8. Zum
					; Setzen von 8 planes, Bit 4 setzen
					; Bit 12,13,14 zurücksetzen. Bit 0 ist gesetzt,
					; da es viele AGA-Funktionen ermöglicht
					; die wir später sehen werden.
					; durch Setzen von Bit 11 wird HAM8 aktiv 

	dc.w	$f907,$fffe
	dc.w	$100,$200

	dc.w	$FFFF,$FFFE	; Ende copperlist

;******************************************************************************

; RAW-Bild mit 8 Bitebenen, dh 256 Farben

	CNOP	0,8	; auf 64 Bit ausrichten

PICTURE:
	INCBIN	"Pic640x100x256.RAW"	; (C) by Cristiano "KREEX" Evangelisti

; Bild RAW mit 8 bitplanes, in HAM8.

	CNOP	0,8	; auf 64 Bit ausrichten

PICTUREHAM:
	INCBIN	"pic640x100xham8.RAW"

	end

Sie sehen gleich aus! Doch oben sind es 256 Farben, unten ham8!
Vielleicht bemerken Sie in der Leistung ein paar Pixel in der 256-Farben-Version...
Der ham8 wäre jedoch besser mit einem gescannten Foto zu sehen.

