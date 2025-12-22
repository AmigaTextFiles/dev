
; soc22a.s
; 8x8 zu 16x16 Bit / 1 Bitplane/ 90° Pixelrotation, Test mit Debugger

anfang:
	lea font8,a0			; lädt die Anfangsadresse von font8 in a0	z.B. a0=0002128E
	lea font16,a1			; lädt die Anfangsadresse von font8 in a0
	;move.l font16,a1		; lädt den Wert der im Speicher an der Adresse "font16" ist in das Register a1	
	;move.w #256-1,d0		; alle 256 Zeichen im Font ; auskommentiert da hier nur ein Zeichen betrachtet
_fontLoop:
	moveq #7,d1				; Bits abfragen mit Bit 7 anfangen (von a11 nach a18) 							
_fontLineLoop:				; Anfangswerte auf 0
	clr.w d5				; Displacement nächstes Byte, solange ein Zeichen bearbeitet wird
	clr.w d3				; die 16Bits werden später nach Font16 kopiert
	clr.w d4				; das wievielte Bit abgefragt wird btst
_fontColumnLoop:
	move.b (a0,d5.w),d2		; 1.Byte nach d2		$C0 nach d2
	btst d1,d2				; d.h. Bit 7 wird überprüft, hier gesetzt
	beq _fontPixelEmpty		; falls das Bit nicht 1 und somit leer ist, überspringe diese Zeilen
	bset d4,d3				; d.h. 1.Bit setzen	; %00000001	; bei 2. Durchlauf:	%000001xx
	addq.b #1,d4
	bset d4,d3				; d.h. 2.Bit setzen	; %00000011	; bei 2. Durchlauf:	%000011xx
	addq.b #1,d4
	bra _fontPixelNext		; nächste Zeile überspringen
_fontPixelEmpty:
	addq.b #2,d4			; falls kein Pixel 
_fontPixelNext:
	addq.b #1,d5			; das nächste Pixel an Stelle (Zeile 2, Spalte 1)
	btst #4,d4				
	beq _fontColumnLoop		
	move.w d3,(a1)+			; (%00000011 ; %00000011)
	move.w d3,(a1)+			; bzw. nach 2 Durchläufen	%00001111	%00001111
	dbf d1,_fontLineLoop	; wenn alle Bits in der Zeile untersucht wurden --> nächstes Zeichen d1=7
	lea 8(a0),a0			; nächstes Byte; nächstes Zeichen
	;dbf d0,_fontLoop		; auskommentiert da nur 1 8x8 Zeichen betrachtet wird

	rts

font8:
	dc.b	%11000000			; $C0
	dc.b	%11000000			; $C0
	dc.b	%00100000			; $20
	dc.b	%00010000			; $10
	dc.b	%00001000			; $08
	dc.b	%00000100			; $04	
	dc.b	%00000010			; $02	
	dc.b	%00000001			; $01
						
	EVEN

font16:		blk.b	32,0		; Speicherbereich von 32Bytes d.h. 2x16 Bytes

	end

;----------------------------------------------------------------------
; Programmerklärung

1. btst, Anweisung testet ob das angegebene Bit ZERO ist

btst #7,d2		%1000.000	; Bit 7 = $80
wenn getestetes Bit gesetzt ist, ist Z-Flag=0 und die Anweisungen nach beq werden abgearbeitet
btst #6,d2		%1000.000	; Bit 7 = $80
wenn getestetes Bit nicht gesetzt ist, ist Z-Flag=1 und es wird vom beq zum Label gesprungen

2. font8 als Matrix 8x8,
d.h. A= { (a11, a12, ..., a18), 
	      (a21, a22, ..., a28), 
		    ... 
		  (a81, a22, ..., a88)} angenommen

d.h. 
mit Register a0 wird immer auf den Beginn des Zeichens (font8) gezeigt --> Element a11
mit Register d5 wird auf eines der 8 Bytes des Zeichens  (font8) gezeigt --> Element a11, a21, a31, ..., a81
mit Register d1 wird immer auf eines der 8Bit von einem Byte gezeigt --> z.B. Element a11, a12, a13,..., a18

im Register d3 werden die 16 Bit (1 Word) zusammengebaut, die anschliessend nach font16 kopiert werden
 
3. Reihenfolge
 Es wird auf den Beginn des Zeichen mit a0 gezeigt.
 Es wird zuerst das höchstwertige Bit (Bit7) im ersten Byte betrachtet
 --> Falls 1 --> dann Bit0 und Bit1 in d3 setzen und d4 jeweils 2x um 1 erhöhen 
 --> Falls 0 --> dann nichts machen und d4 um 2 erhöhen

Dann das Register d5 um 1 erhöhen, wir zeigen nun auf das 2.Byte des Zeichens

 (wir zählen binär) d.h. nach 16mal erhöhen wird 2^4 auf 1 gesetzt
 d.h. 0000 --> 0 ; 1111 --> 15 ; 1.0000
 wir prüfen auf Stelle 4 in d4

 Ist das Bit4 in d4 1-gesetzt, ist das Ergebnis in d3 fertig gebaut und
 wir können es in den Speicher kopieren und wir kopieren es 2mal da wir aus 8 Bit 16 Bit machen

 anschließend wird d1 um 1 dekrementiert, wir schauen also auf Bit 6 im nächsten Durchlauf
 Die Register d3, d4, d5 werden auf 0 gesetzt und der Ablauf erfolgt erneut.

 Wenn am Ende alle Bits betrachtet wurden wird a0 um 8 erhöht und es wird auf das nächste 
 Zeichen geschaut.



