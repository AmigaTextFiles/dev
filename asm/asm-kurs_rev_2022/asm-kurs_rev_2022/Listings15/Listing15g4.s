
; Listing15g4.s	- 	Schwanken einer HIRES-Figur mit dem AGA bplcon1.
;			Beachten Sie, dass wenn das Bild HIRES ist, die Schriftrolle kann
;			Gehen Sie von 0 auf 127, um insgesamt 32 Pixel mit niedriger Auflösung zu erhalten.
;           In der Praxis ist das höchste Bit nicht aktiviert.

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
	addi.l	#80*100,d0			; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTB			; D7-mal wiederholen (D7= Anzahl bitplanes)

	bsr.w	FaiAgaCopCon1		; copperliste erstellen mit WAIT + BPLCON2 in jeder Zeile

	bsr.s	MettiColori			; Farben des Bildes setzen

	bsr.w	FINESCROLLC2		; Diese Routine "konvertiert" die Dezimalwerte
								; in Bildlaufwerte für die BPLCON1 AGA

	lea	$dff000,a5
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

	BSR.w	WABBLE

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2			; warte auf Zeile $110
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $110
	BEQ.S	Aspetta

	BTST	#6,$BFE001
	BNE.S	LOOP
	RTS

;*****************************************************************************

MettiColori:
	LEA	LogoPal(PC),A0			; Adresse der Farbpalette 
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

; Konvertieren niedriger Nibbles von $00RgGgBb (long) in die Farbe AGA $0rgb (word)

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

; Konvertieren hohe Nibbles von $00RgGgBb (long) in die Farbe AGA $0RGB (word)

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

; Palette mit PicCon in Binärform gespeichert (Optionen: Als Binärdatei 
; speichern, nicht als Cop)

LogoPal:
	incbin	"/Sources/Pic640x100x256.pal"

;*****************************************************************************
; Routine, die die copperliste mit WAIT + BPLCON1 pro Zeile erstellt
;*****************************************************************************

FaiAgaCopCon1:
	lea	AGACON1,a0				; Adresse buffer in copperlist
	move.l	#$01020000,d0		; BplCon1
	move.l	#$2c07fffe,d1		; WAIT - Zeilenanfang Y = $2c
	move.w	#99-1,d7			; Anzahl Zeilen zu erledigen
FaiAGALoopC:
	move.l	d1,(a0)+			; Warte YYXXFFFE
	move.l	d0,(a0)+			; BplCon1
	add.l	#$01000000,d1		; eine Zeile tiefer für die nächste
	dbra	d7,FaiAGALoopC
	rts

******************************************************************************
; Routine, die von "Dezimalzahlen" in Werte für die bplcon1 AGA konvertiert.
; In der Praxis wird die 8-Bit-Zahl durch Positionieren der Bits gemäß dem
; Schema der bplcon1 aga. Diese Version hat eine einzelne Tabelle mit
; 0-255 Werten konvertiert in bplcon1 mit dem gleichen Wert für die
; 2 playfields, geeignet für den Bildlaufscroll wie in diesem Beispiel.
******************************************************************************

FINESCROLLC2:
	LEA	MOVTAB(PC),A0			; Tab Wert
	LEA	CON1VALUES(PC),A1		; Tab Ziel für $DFF002
	LEA	MOVTABEND(PC),a2		; Ende der Tabelle
CONVLOOP:
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVE.B	(A0)+,D1			; WERT "DEZIMAL" PF1 IN D1
	MOVE.W	D1,D2				; KOPIE WERT 1 IN D2
	MOVE.W	d1,d4				; KOPIE WERT 1 IN D4
;pf1
	AND.W	#%11,D1				; Auswahl bits 0-1 (SCROLL 1/4 und 1/2 pixel)
	LSL.W	#8,D1				; Verschieben an die "richtige" Stelle: Bits 8 und 9
	MOVE.W	D1,D3				; speichern in d3
;pf2
	LSL.W	#4,D1				; Verschieben an die richtige Stelle: bit 12 und 13
	OR.W	D1,D3				; speichern in d3
;pf1
	AND.W	#%111100,d2			; Auswählen der "alten" 4 Bits des Scrolls auf 1
								; Pixel, maximal 16 Pixel.
	LSR.W	#2,d2				; Verschieben an die richtige Stelle: die ersten 4 Bits!
	OR.W	d2,d3				; speichern in d3
;pf2
	LSL.W	#4,d2				; Verschieben an die richtige Stelle: 4,5,6,7 Bit
	OR.W	d2,d3				; speichern in d3
;pf1
	AND.W	#%11000000,d4		; hohe Bits auswählen: Aufnahmen von 16/32 Pixel
	LSL.W	#4,d4				; Richtiger Ort: BITS 10&11 für PF1
	OR.W	D4,d3				; speichern in d3
;pf2
	LSL.W	#4,d4				; Richtiger Ort: BITS 14&15 für PF2
	OR.W	d4,d3				; add pf2 16 pixel scroll bits to d3

	MOVE.w	D3,(A1)+			; speichern Endwert BPLCON1
	CMP.L	a0,a2				; Ende der Tabelle?
	BNE.S	CONVLOOP			; Wenn noch nicht, Konvertierung fortsetzen !
	RTS



WABBLE:
	move.l	TabPointer(PC),a0	; Zeiger aktuelle Tab in a0
	lea	CON1TABEND(PC),a2		; Ende Tab
	lea	AGACON1+6,a1			; Effekt copper in a1
	move.w	#99-1,d7			; Anzahl Zeilen, d.h. loops
scroll:
	move.w	(a0)+,(a1)			; Kopie der tab al bplcon1 in copperlist
	addq.w	#8,a1				; wait Überspringen - bis zum nächsten bplcon1
	cmp.l	a2,a0				; Ende tab?
	bne.s	okay				; Wenn noch nicht, weiter
	LEA	CON1VALUES(PC),a0		; Andernfalls von vorne beginnen
okay:
	dbra	d7,scroll			; D7 MAL

	move.l	TabPointer(PC),a0	; Zeiger aktuelle Tab in a0
	addq.w	#2,a0				; vorwärts "scrollen" 
	cmp.l	a2,a0				; Ende tab?
	bne.s	okay2				; Wenn noch nicht, weiter
	LEA	CON1VALUES(PC),a0		; Andernfalls von vorne beginnen
okay2:
	move.l	a0,TabPointer		; Zeiger aktualisieren
	RTS

TabPointer:
	dc.l	CON1VALUES


; Tabelle mit Endwerten für $dff102 (BPLCON1)

NUMVAL	EQU	256


CON1VALUES:
	DCB.W	NUMVAL,0
CON1TABEND:

	ds.b	10000

;IS
;BEG>0
;END>360
;AMOUNT>128
;AMPLITUDE>63	; Wenn das Bild in HIRES ist, geht der Scroll von 0 auf 127 !!
;YOFFSET>63

;AMOUNT>64
;AMPLITUDE>63	; Wenn das Bild in HIRES ist, geht der Scroll von 0 auf 127 !!
;YOFFSET>63

;AMOUNT>32
;AMPLITUDE>63	; Wenn das Bild in HIRES ist, geht der Scroll von 0 auf 127 !!
;YOFFSET>63

;AMOUNT>32
;AMPLITUDE>63	; Wenn das Bild in HIRES ist, geht der Scroll von 0 auf 127 !!
;YOFFSET>63


MOVTAB:
	DC.B	$41,$44,$47,$4A,$4D,$50,$53,$56,$59,$5B,$5E,$61,$63,$66,$68,$6A
	DC.B	$6D,$6F,$71,$73,$74,$76,$77,$79,$7A,$7B,$7C,$7C,$7D,$7E,$7E,$7E
	DC.B	$7E,$7E,$7E,$7D,$7C,$7C,$7B,$7A,$79,$77,$76,$74,$73,$71,$6F,$6D
	DC.B	$6A,$68,$66,$63,$61,$5E,$5B,$59,$56,$53,$50,$4D,$4A,$47,$44,$41
	DC.B	$3D,$3A,$37,$34,$31,$2E,$2B,$28,$25,$23,$20,$1D,$1B,$18,$16,$14
	DC.B	$11,$0F,$0D,$0B,$0A,$08,$07,$05,$04,$03,$02,$02,$01,$00,$00,$00
	DC.B	$00,$00,$00,$01,$02,$02,$03,$04,$05,$07,$08,$0A,$0B,$0D,$0F,$11
	DC.B	$14,$16,$18,$1B,$1D,$20,$23,$25,$28,$2B,$2E,$31,$34,$37,$3A,$3D

	DC.B	$42,$48,$4E,$54,$5A,$5F,$65,$69,$6E,$72,$75,$78,$7A,$7C,$7D,$7E
	DC.B	$7E,$7D,$7C,$7A,$78,$75,$72,$6E,$69,$65,$5F,$5A,$54,$4E,$48,$42
	DC.B	$3C,$36,$30,$2A,$24,$1F,$19,$15,$10,$0C,$09,$06,$04,$02,$01,$00
	DC.B	$00,$01,$02,$04,$06,$09,$0C,$10,$15,$19,$1F,$24,$2A,$30,$36,$3C

	DC.B	$45,$51,$5D,$67,$70,$77,$7B,$7E,$7E,$7B,$77,$70,$67,$5D,$51,$45
	DC.B	$39,$2D,$21,$17,$0E,$07,$03,$00,$00,$03,$07,$0E,$17,$21,$2D,$39

	DC.B	$45,$51,$5D,$67,$70,$77,$7B,$7E,$7E,$7B,$77,$70,$67,$5D,$51,$45
	DC.B	$39,$2D,$21,$17,$0E,$07,$03,$00,$00,$03,$07,$0E,$17,$21,$2D,$39
MOVTABEND:


;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8					; ausgerichtet auf 64 bit

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop

; Hinweis: Die ddfstart / stop HIRES wären $003c und $00d4, jedoch mit aktivem Burst
; Der gleiche Wert wie bei LOWRES ist in Ordnung, dh $0038 und $00d0.

	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,-8				; Bpl1Mod (burst 64bit, modulo=modulo-8)
	dc.w	$10a,-8				; Bpl2Mod (wie oben)

				; 5432109876543210
	dc.w	$100,%1000001000010001	; 8 bitplane HIRES 640x256. Zum
					; Setzen von 8 planes, Bit 4 setzen
					; Bit 12,13,14 zurücksetzen. Bit 0 ist gesetzt,
					; da es viele AGA-Funktionen ermöglicht
					; die wir später sehen werden.

	dc.w	$1fc,3				; Burst mode 64 bit

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

AGACON1:
	dcb.l	99*2				; d.h.: 99 Zeilen * 2 long:
								; 1 für wait,
								; 1 für bplcon1
	dc.w	$9007,$fffe			; auf das Ende des Logos warten
	dc.w	$100,$200			; null bitplanes

	dc.w	$FFFF,$FFFE			; Ende copperlist

;******************************************************************************

; Bild RAW mit 8 bitplanes, das sind 256 Farben

	CNOP	0,8	; auf 64 Bit ausrichten

PICTURE:
	INCBIN	"/Sources/Pic640x100x256.RAW"	; (C) by Cristiano "KREEX" Evangelisti

	end

Für die Bilder in Hires haben wir eine Hardware-Einschränkung beim Scroll:
Das höchste Bit ist nicht aktiviert, das des Scrolls von 32 Pixeln gleichzeitig,
geht der Wert von 0 auf 127 anstatt von 0 auf 255.

