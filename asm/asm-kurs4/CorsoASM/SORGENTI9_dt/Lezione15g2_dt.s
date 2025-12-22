
; Lezione15g2.s		- AGA Scroll von bitplanes in Schritten von 1/4 Pixel,
;			  für maximal 64 Pixel.	Die 2 playfields bewegen sich
;			  unabhängig in diesem Beispiel.

; HINWEIS: Die 2 hohen Bits des Scrolls, welche das "Einrasten" von 16 oder 32 Pixel ermöglichen.
; Für maximal 64 Pixel Bildlauf funktionieren sie nur, wenn der Burst-Modus aktiviert ist
; bei 64 Pixel (durch Setzen der 2 niedrigen Bits von FMODE, dh $dff1fc).

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern copperlist etc.
*****************************************************************************

		    ;5432109876543210
DMASET	EQU	%1000001110000000	; copper, bitplane DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das AGA-Bild (planes gerade)

	MOVE.L	#PIC1,d0
	LEA	EVENBPLPT,A1		; BPL POINTERS DER GERADEN BITPLANES
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Zeiger auf das AGA-Bild (planes ungerade)

	MOVE.L	#PIC2,d0
	LEA	ODDBPLPT,A1			; BPL POINTERS DER UNGERADEN BITPLANES
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	bsr.w	MAKEMOVTAB	; Diese einfache Routine macht eine Tabelle
						; mit Werten von 0 bis 255, dann zurück zu 0

	bsr.w	FINESCROLLC	; Diese Routine "konvertiert" die Dezimalwerte
						; in Bildlaufwerte für die BPLCON1 AGA

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#AGACOPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
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

******************************************************************************
; Diese Routine macht eine Tabelle mit "Dezimal" -Werten 0-255-0 in zwei Tabellen
; getrennt, eines für playfield 1 und das andere für playfield 2.
******************************************************************************

NUMVAL = 255	; Der neue bplcon1 kann von 0 bis 255 gehen, lass es uns benutzen!

MAKEMOVTAB:
	LEA	MOVTAB(PC),A0	; Tab Werte playfield 1
	LEA	MOVTAB2(PC),A1	; Tab Werte playfield 2
	MOVEQ	#0,D0		; MINIMUM PLAYFIELD 1 : 0
	MOVE.L	#NUMVAL,d2	; MINIMUM PLAYFIELD 2 : numval
	MOVE.L	#NUMVAL,D1	; MAXIMUM : numval
AMTLOOP:
	MOVE.W	D0,(A0)+	; Wert playfield 1
	MOVE.W	D2,(A1)+	; Wert playfield 2
	ADDQ.L	#1,D0		; addiere 1 zu Wert playfield 1
	SUBQ.L	#1,D2		; subtrahiere 1 von Wert playfield 2
	CMP.L	D1,D0		; pf1=numval? (dann pf2=null)
	BNE.S	AMTLOOP		; Wenn noch nicht, weiter machen.
AMTLOOP2:
	MOVE.W	D0,(A0)+	; Wert Pf1 - (Ziffer auf 0)
	MOVE.W	D2,(A1)+	; Wert Pf2 - immer bei null lassen ... still!
	SUBQ.L	#1,D0		; Sub Wert Pf1
	BNE.S	AMTLOOP2	; d0=null? (flag Z) - wenn noch nicht loop!
	RTS

MOVTAB:
	DCB.W	NUMVAL*2,0	; *2 weil es Worte sind
MOVTABEND:

MOVTAB2:
	DCB.W	NUMVAL*2,0	; *2 weil es Worte sind
MOVTAB2END:

******************************************************************************
; Routine, die von "Dezimalzahlen" in Werte für die bplcon1 AGA konvertiert.
; In der Praxis wird die 8-Bit-Nummer durch Positionieren der Bits gemäß dem
; Schema der bplcon1 aga:
;
;	15	64 PIXEL SCROLL PF2 (AGA)
;	14 	64 PIXEL SCROLL PF2 (AGA)
;	13 	ENDE SCROLL PF2 (AGA SCROLL 35ns 1/4 of pixel)
;	12 	ENDE SCROLL PF2
;	11 	64 PIXEL SCROLL PF1 (AGA)
;	10 	64 PIXEL SCROLL PF1 (AGA)
;	09 	ENDE SCROLL PF1 (AGA SCROLL 35ns 1/4 of pixel)
;	08	ENDE SCROLL PF1
;	07	PF2H3
;	06	PF2H2
;	05	PF2H1
;	04	PF2H0
;	03	PF1H3
;	02	PF1H2
;	01	PF1H1
;	00	PF1H0

******************************************************************************

FINESCROLLC:
	LEA	MOVTAB2(PC),A0		; Tab Wert playfield 2
	LEA	MOVTAB(PC),A3		; Tab Wert playfield 1
	LEA	CON1VALUES(PC),A1	; Tab Ziel für $DFF002
	LEA	MOVTAB2END(PC),a2	; Ende der Tabelle
CONVLOOP:
	MOVEQ	#0,D1
	MOVE.W	(A0)+,D1	; WERT "DEZIMAL" PF1 IN D1
	MOVE.W	(A3)+,D5	; WERT "DEZIMAL" PF2 IN D5
	MOVE.W	D1,D2		; KOPIE WERT 1 IN D2
	MOVE.W	d1,d4		; KOPIE WERT 1 IN D4
	MOVE.W	D5,D6		; KOPIE WERT 2 IN D6
;pf1
	AND.W	#%11,D1		; Auswahl bits 0-1 (SCROLL 1/4 und 1/2 pixel)
	LSL.W	#8,D1		; Verschieben an die "richtige" Stelle: Bits 8 und 9
	MOVE.W	D1,D3		; speichern in d3
;pf2
	AND.W	#%11,D5		; Auswahl bits 0-1 (SCROLL 1/4 und 1/2 pixel)
	LSL.W	#8,D5		; Verschieben in 2 Schritten an die "richtige" Stelle:
	LSL.W	#4,D5		; insgesamt um 12 Bits verschoben: Bits 12 und 13
	OR.W	D5,D3		; speichern in d3
;pf1
	AND.W	#%111100,d2	; Auswählen der "alten" 4 Bits des Scrolls auf 1
						; Pixel, maximal 16 Pixel.
	LSR.W	#2,d2		; Verschieben an die richtige Stelle: die ersten 4 Bits!
	OR.W	d2,d3		; speichern in d3
;pf2
	MOVE.W	D6,D5
	AND.W	#%111100,d5	; Auswählen der "alten" 4 Bits des Scrolls auf 1
						; Pixel, maximal 16 Pixel.
	LSL.W	#2,d5		; Verschieben an die richtige Stelle: 4,5,6,7 Bit
	OR.W	d5,d3		; speichern in d3
;pf1
	AND.W	#%11000000,d4	; hohe Bits auswählen: Aufnahmen von 16/32 Pixel
	LSL.W	#4,d4		; Richtiger Ort: BITS 10&11 für PF1
	OR.W	D4,d3		; speichern in d3
;pf2
	AND.W	#%11000000,d6	; hohe Bits auswählen: Aufnahmen von 16/32 Pixel
	LSL.W	#8,d6		; Richtiger Ort: BITS 14&15 für PF2
	OR.W	d6,d3		; add pf2 16 pixel scroll bits to d3

	MOVE.w	D3,(A1)+	; speichern Endwert BPLCON1
	CMP.L	a0,a2		; Ende der Tabelle?
	BNE.S	CONVLOOP	; Wenn noch nicht, Konvertierung fortsetzen !
	RTS

; Tabelle mit Endwerten für $dff102 (BPLCON1)

CON1VALUES:
	DCB.W	NUMVAL*2,0
CON1TABEND:

******************************************************************************
; Routine, die die Werte aus der Tabelle CON1VALUES Tabelle in bplcon1 in copper kopiert.
; Sobald Sie die gesamte Tabelle gelesen haben, stoppt sie.
******************************************************************************

WABBLE:
	tst.w	FLAGGY				; sind wir mit der Tabelle fertig?
	beq.s	NOWA				; wenn ja, exit!
	move.l	Con1TabPointer(PC),a0	; Con1TabPointer in a0
	move.w	(a0)+,SCRLVAL		; Kopie Wert in copperlist
	cmp.l	#CON1TABEND,a0		; sind wir am Ende der Tabelle?
	bne.s	okay				; Wenn noch nicht, ok
	clr.w	FLAGGY				; Ansonsten bedeutet es, dass wir fertig sind
okay:
	lea	Con1TabPointer(PC),a0	; Con1TabPointer in a0
	addq.l	#2,(a0)				; zum nächsten Wert gehen
NOWA:
	RTS

FLAGGY:
	dc.w	-1

Con1TabPointer:
	dc.l	CON1VALUES

*************************************************************************
;			COPPERLIST AGA
*************************************************************************

	CNOP	0,8

		Section	MiaCop,data_C

AGACOPLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop

	dc.w	$102		; BplCon1
SCRLVAL:
	dc.w	0			; Wert Bplcon1 - von der Routine geändert

	dc.w	$104,0		; BplCon2
	dc.w	$108,-8		; Bpl1Mod
	dc.w	$10a,-8		; Bpl2Mod

	dc.w	$1fc,3		; Burst mode 64bit - HINWEIS: Die hohen Bits von
				; BPLCON1, die das ruckartige Scrollen von 16 oder 32 Pixel 
				; ermöglichen, funktionieren nur, wenn der
				; Burst 32 bzw. 64 Bit ist.

EVENBPLPT:
	dc.w $e0,0,$e2,0		; bitplane   0
ODDBPLPT:
	dc.w $e4,0,$e6,0		; bitplane   1

			    ; 5432109876543210
	dc.w	$100,%0010001000000001	; 2 bitplane LOWRES 320x256.

	dc.w	$106,$C00	; Nibble hoch
	dc.w	$180,$001	; COLOR 0 REGISTER
	dc.w	$182,$081	; COLOR 1 REGISTER
	dc.w	$184,$aa1	; COLOR 2 REGISTER
	dc.w	$186,$aa1	; COLOR 3 REGISTER
	dc.w	$106,$200	; Nibble niedrig
	dc.w	$180,$124	; COLOR 0 REGISTER
	dc.w	$182,$567	; COLOR 1 REGISTER
	dc.w	$184,$413	; COLOR 2 REGISTER
	dc.w	$186,$a83	; COLOR 3 REGISTER

	dc.w	$FFFF,$FFFE	; Ende Copperlist

*************************************************************************
;			   BITPLANES
*************************************************************************

	CNOP	0,8

PIC1:
	dcb.b	40*256,%00000111
PIC2:
	dcb.b	40*256,%01110000

	END

