
; Lezione15g3.s	- 	Schwanken einer LORES Figur mit dem AGA bplcon1.

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
	addi.l	#40*256,d0		; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTB		; D7-mal wiederholen (D7= Anzahl bitplanes)

	bsr.w	FaiAgaCopCon1	; copperliste erstellen mit WAIT + BPLCON2 in jeder Zeile

	bsr.s	MettiColori		; Farben des Bildes setzen

	bsr.w	FINESCROLLC2	; Diese Routine "konvertiert" die Dezimalwerte
							; in Bildlaufwerte für die BPLCON1 AGA

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normale
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

LOOP:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2	; warte auf Zeile $110
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0		; warte auf Zeile $110
	BNE.S	Waity1

	BSR.w	WABBLE

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2	; warte auf Zeile $110
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0		; warte auf Zeile $110
	BEQ.S	Aspetta

	BTST	#6,$BFE001
	BNE.S	LOOP
	RTS

;*****************************************************************************

MettiColori:
	LEA	PICTURE+(10240*8),A0	; Adresse der Farbpalette am
							; Ende des Bildes -> in A0
	LEA	COLP0+2,A1			; Adresse des ersten Registers
							; auf hohes nibble eingestellt
	LEA	COLP0B+2,A2			; Adresse des ersten Registers
							; auf niedriges nibble eingestellt
	MOVEQ	#8-1,d7			; 8 Banken mit jeweils 32 Registern
ConvertiPaletteBank:
	moveq	#0,d0
	moveq	#0,d2
	moveq	#0,d3
	moveq	#32-1,d6		; 32 Farbregister pro Bank

DaLongARegistri:			; Schleife, die die Farben $00RrGgBb.l in die 2 
			; Wörter $0RGB, $0rgb geeignet für copperregister umwandelt.

; Konvertieren niedriger Nibbles von $00RrGgBb (long) in die Farbe AGA $0rgb (word)

	MOVE.B	1(A0),(a2)		; Hohes Byte der Farbe $00Rr0000 kopiert
							; in das Cop-Register für niedriges nibble
	ANDI.B	#%00001111,(a2) ; auswählen nur niedriges nibble ($0r)
	move.b	2(a0),d2		; Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	lsl.b	#4,d2			; verschiebt das niedrige Halbbyte um 4 Bit nach links
							; des GRÜNEN, "umwandeln" in ein hohes nibble
							; des niedrigen Bytes von D2 ($g0)
	move.b	3(a0),d3		; Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%00001111,d3	; auswählen nur niedriges nibble ($0b)
	or.b	d2,d3			; "MISCHEN" der niedrigen nibble von grün und blau...
	move.b	d3,1(a2)		; Bilden des nachfolgenden Low-Bytes $gb zum Setzen
							; im Farbregister nach dem Byte $0r für
							; Bilden Sie das Wort $0rgb der niedrigen nibble

; Konvertieren hohe Nibbles von $00RrGgBb (long) in die Farbe AGA $0RGB (word)

	MOVE.B	1(A0),d0		; Hohes Byte der Farbe $00Rr0000 in d0
	ANDI.B	#%11110000,d0	; auswählen nur hohes nibble ($R0)
	lsr.b	#4,d0			; verschiebt das nibble um 4 Bit nach rechts, also
							; dadurch wird es zum Low-Byte-Nibble ($0R).
	move.b	d0,(a1)			; Kopieren Sie das High-Byte $0R in das Farbregister
	move.b	2(a0),d2		; das Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d2	; auswählen nur hohes nibble ($G0)
	move.b	3(a0),d3		; das Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d3	; auswählen nur hohes nibble ($B0)
	lsr.b	#4,d3			; verschiebt es um 4 Bit nach rechts
							; dadurch wird es zum Low-Byte-Nibble d3 ($0B)
	or.b	d2,d3			; Mischen der hohen nibble von Grün und Blau ($G0 + $0B)
	move.b	d3,1(a1)		; Bilden des letzten Low-Bytes $GB zum Setzen
							; im Farbregister nach dem Byte $0R für
							; Bilden Sie das Wort $0RGB der hohen nibble

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

; Palette mit PicCon in Binärform gespeichert (Optionen: Als Binärdatei 
; speichern, nicht als Cop)

LogoPal:
	incbin	"Pic640x100x256.pal"

;*****************************************************************************
; Routine, die die copperliste mit WAIT + BPLCON1 pro Zeile erstellt
;*****************************************************************************

FaiAgaCopCon1:
	lea	AGACON1,a0			; Adresse buffer in copperlist
	move.l	#$01020000,d0	; BplCon1
	move.l	#$2c07fffe,d1	; WAIT - Zeilenanfang Y = $2c
	move.w	#200-1,d7		; Anzahl Zeilen zu erledigen
FaiAGALoopC:
	move.l	d1,(a0)+		; Warte YYXXFFFE
	move.l	d0,(a0)+		; BplCon1
	add.l	#$01000000,d1	; eine Zeile tiefer für die nächste
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
	LEA	MOVTAB(PC),A0		; Tab Wert
	LEA	CON1VALUES(PC),A1	; Tab Ziel für $DFF002
	LEA	MOVTABEND(PC),a2	; Ende der Tabelle
CONVLOOP:
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVE.B	(A0)+,D1	; WERT "DEZIMAL" PF1 IN D1
	MOVE.W	D1,D2		; KOPIE WERT 1 IN D2
	MOVE.W	d1,d4		; KOPIE WERT 1 IN D4
;pf1
	AND.W	#%11,D1		; Auswahl bits 0-1 (SCROLL 1/4 und 1/2 pixel)
	LSL.W	#8,D1		; Verschieben an die "richtige" Stelle: Bits 8 und 9
	MOVE.W	D1,D3		; speichern in d3
;pf2
	LSL.W	#4,D1		; Verschieben an die richtige Stelle: bit 12 und 13
	OR.W	D1,D3		; speichern in d3
;pf1
	AND.W	#%111100,d2	; Auswählen der "alten" 4 Bits des Scrolls auf 1
						; Pixel, maximal 16 Pixel.
	LSR.W	#2,d2		; Verschieben an die richtige Stelle: die ersten 4 Bits!
	OR.W	d2,d3		; speichern in d3
;pf2
	LSL.W	#4,d2		; Verschieben an die richtige Stelle: 4,5,6,7 Bit
	OR.W	d2,d3		; speichern in d3
;pf1
	AND.W	#%11000000,d4	; hohe Bits auswählen: Aufnahmen von 16/32 Pixel
	LSL.W	#4,d4		; Richtiger Ort: BITS 10&11 für PF1
	OR.W	D4,d3		; speichern in d3
;pf2
	LSL.W	#4,d4		; Richtiger Ort: BITS 14&15 für PF2
	OR.W	d4,d3		; add pf2 16 pixel scroll bits to d3

	MOVE.w	D3,(A1)+	; speichern Endwert BPLCON1
	CMP.L	a0,a2		; Ende der Tabelle?
	BNE.S	CONVLOOP	; Wenn noch nicht, Konvertierung fortsetzen !
	RTS



WABBLE:
	btst	#2,$dff016
	beq.s	WABBLE
	move.l	TabPointer(PC),a0	; Zeiger aktuelle Tab in a0
	lea	CON1TABEND(PC),a2		; Ende Tab
	lea	AGACON1+6,a1			; Effekt copper in a1
	move.w	#200-1,d7			; Anzahl Zeilen, d.h. loops
scroll:
	cmp.l	a2,a0				; Ende tab?
	bne.s	okay				; Wenn noch nicht, weiter
	LEA	CON1VALUES(PC),a0		; Andernfalls von vorne beginnen
okay:
	move.w	(a0)+,(a1)			; Kopie der tab al bplcon1 in copperlist
	addq.w	#8,a1				; wait Überspringen - bis zum nächsten bplcon1
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

NUMVAL	EQU	400+300+200+100

CON1VALUES:
	DCB.W	NUMVAL,0
CON1TABEND:

;IS
;BEG>0
;END>360
;AMOUNT>400
;AMPLITUDE>127	; Wenn das Bild in LORES ist, geht der Scroll von 0 auf 255 !!
;YOFFSET>127

;AMOUNT>300

;AMOUNT>200

;AMOUNT>100

; Hier sind 4 Sintabs untereinander...

MOVTAB:
	DC.B	$80,$82,$84,$86,$88,$8A,$8C,$8E,$90,$92,$94,$96,$98,$9A,$9C,$9E
	DC.B	$A0,$A1,$A3,$A5,$A7,$A9,$AB,$AD,$AF,$B1,$B2,$B4,$B6,$B8,$BA,$BB
	DC.B	$BD,$BF,$C1,$C2,$C4,$C6,$C7,$C9,$CA,$CC,$CE,$CF,$D1,$D2,$D4,$D5
	DC.B	$D7,$D8,$DA,$DB,$DC,$DE,$DF,$E0,$E1,$E3,$E4,$E5,$E6,$E7,$E9,$EA
	DC.B	$EB,$EC,$ED,$EE,$EF,$F0,$F1,$F1,$F2,$F3,$F4,$F5,$F5,$F6,$F7,$F7
	DC.B	$F8,$F9,$F9,$FA,$FA,$FB,$FB,$FC,$FC,$FC,$FD,$FD,$FD,$FD,$FE,$FE
	DC.B	$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FD,$FD,$FD,$FD,$FC,$FC
	DC.B	$FC,$FB,$FB,$FA,$FA,$F9,$F9,$F8,$F7,$F7,$F6,$F5,$F5,$F4,$F3,$F2
	DC.B	$F1,$F1,$F0,$EF,$EE,$ED,$EC,$EB,$EA,$E9,$E7,$E6,$E5,$E4,$E3,$E1
	DC.B	$E0,$DF,$DE,$DC,$DB,$DA,$D8,$D7,$D5,$D4,$D2,$D1,$CF,$CE,$CC,$CA
	DC.B	$C9,$C7,$C6,$C4,$C2,$C1,$BF,$BD,$BB,$BA,$B8,$B6,$B4,$B2,$B1,$AF
	DC.B	$AD,$AB,$A9,$A7,$A5,$A3,$A1,$A0,$9E,$9C,$9A,$98,$96,$94,$92,$90
	DC.B	$8E,$8C,$8A,$88,$86,$84,$82,$80,$7E,$7C,$7A,$78,$76,$74,$72,$70
	DC.B	$6E,$6C,$6A,$68,$66,$64,$62,$60,$5E,$5D,$5B,$59,$57,$55,$53,$51
	DC.B	$4F,$4D,$4C,$4A,$48,$46,$44,$43,$41,$3F,$3D,$3C,$3A,$38,$37,$35
	DC.B	$34,$32,$30,$2F,$2D,$2C,$2A,$29,$27,$26,$24,$23,$22,$20,$1F,$1E
	DC.B	$1D,$1B,$1A,$19,$18,$17,$15,$14,$13,$12,$11,$10,$0F,$0E,$0D,$0D
	DC.B	$0C,$0B,$0A,$09,$09,$08,$07,$07,$06,$05,$05,$04,$04,$03,$03,$02
	DC.B	$02,$02,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$01,$01,$01,$01,$02,$02,$02,$03,$03,$04,$04,$05,$05,$06
	DC.B	$07,$07,$08,$09,$09,$0A,$0B,$0C,$0D,$0D,$0E,$0F,$10,$11,$12,$13
	DC.B	$14,$15,$17,$18,$19,$1A,$1B,$1D,$1E,$1F,$20,$22,$23,$24,$26,$27
	DC.B	$29,$2A,$2C,$2D,$2F,$30,$32,$34,$35,$37,$38,$3A,$3C,$3D,$3F,$41
	DC.B	$43,$44,$46,$48,$4A,$4C,$4D,$4F,$51,$53,$55,$57,$59,$5B,$5D,$5E
	DC.B	$60,$62,$64,$66,$68,$6A,$6C,$6E,$70,$72,$74,$76,$78,$7A,$7C,$7E

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

	DC.B	$81,$85,$89,$8D,$91,$95,$99,$9D,$A1,$A4,$A8,$AC,$B0,$B3,$B7,$BA
	DC.B	$BE,$C1,$C5,$C8,$CB,$CE,$D1,$D4,$D7,$DA,$DD,$E0,$E2,$E5,$E7,$E9
	DC.B	$EB,$ED,$EF,$F1,$F3,$F4,$F6,$F7,$F8,$F9,$FA,$FB,$FC,$FD,$FD,$FE
	DC.B	$FE,$FE,$FE,$FE,$FE,$FD,$FD,$FC,$FB,$FA,$F9,$F8,$F7,$F6,$F4,$F3
	DC.B	$F1,$EF,$ED,$EB,$E9,$E7,$E5,$E2,$E0,$DD,$DA,$D7,$D4,$D1,$CE,$CB
	DC.B	$C8,$C5,$C1,$BE,$BA,$B7,$B3,$B0,$AC,$A8,$A4,$A1,$9D,$99,$95,$91
	DC.B	$8D,$89,$85,$81,$7D,$79,$75,$71,$6D,$69,$65,$61,$5D,$5A,$56,$52
	DC.B	$4E,$4B,$47,$44,$40,$3D,$39,$36,$33,$30,$2D,$2A,$27,$24,$21,$1E
	DC.B	$1C,$19,$17,$15,$13,$11,$0F,$0D,$0B,$0A,$08,$07,$06,$05,$04,$03
	DC.B	$02,$01,$01,$00,$00,$00,$00,$00,$00,$01,$01,$02,$03,$04,$05,$06
	DC.B	$07,$08,$0A,$0B,$0D,$0F,$11,$13,$15,$17,$19,$1C,$1E,$21,$24,$27
	DC.B	$2A,$2D,$30,$33,$36,$39,$3D,$40,$44,$47,$4B,$4E,$52,$56,$5A,$5D
	DC.B	$61,$65,$69,$6D,$71,$75,$79,$7D

	DC.B	$83,$8B,$93,$9B,$A2,$AA,$B1,$B9,$C0,$C6,$CD,$D3,$D9,$DE,$E3,$E8
	DC.B	$EC,$F0,$F4,$F6,$F9,$FB,$FC,$FD,$FE,$FE,$FD,$FC,$FB,$F9,$F6,$F4
	DC.B	$F0,$EC,$E8,$E3,$DE,$D9,$D3,$CD,$C6,$C0,$B9,$B1,$AA,$A2,$9B,$93
	DC.B	$8B,$83,$7B,$73,$6B,$63,$5C,$54,$4D,$45,$3E,$38,$31,$2B,$25,$20
	DC.B	$1B,$16,$12,$0E,$0A,$08,$05,$03,$02,$01,$00,$00,$01,$02,$03,$05
	DC.B	$08,$0A,$0E,$12,$16,$1B,$20,$25,$2B,$31,$38,$3E,$45,$4D,$54,$5C
	DC.B	$63,$6B,$73,$7B
MOVTABEND:

;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8	; ausgerichtet auf 64 bit

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop

; Hinweis: Die ddfstart / stop HIRES wären $003c und $00d4, jedoch mit aktivem Burst
; Der gleiche Wert wie bei LOWRES ist in Ordnung, dh $0038 und $00d0.

	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,-8		; Bpl1Mod (burst 64bit, modulo=modulo-8)
	dc.w	$10a,-8		; Bpl2Mod (wie oben)

				; 5432109876543210
	dc.w	$100,%0000001000010001	; 8 bitplane Lores 640x256. Zum
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

AGACON1:
	dcb.l	200*2		; d.h.: 200 Zeilen * 2 long:
						; 1 für wait,
						; 1 für bplcon1

	dc.w	$FFFF,$FFFE	; Ende copperlist

;******************************************************************************

; Bild RAW mit 8 bitplanes, das sind 256 Farben

	CNOP	0,8	; auf 64 Bit ausrichten

PICTURE:
	INCBIN	"MURALE320x256x256c.RAW"

	end

Die Striche, die sich von Zeit zu Zeit links erheben, sind ein Rätsel.
Da die Routine funktioniert, glaube ich, dass es ein Fehler in der
Amiga-Hardware ist!

