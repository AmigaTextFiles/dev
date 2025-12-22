
; soc22s.s
; Umwandlung einer 4 stelligten hexadezimalen Zahl von 0 bis $270F in eine vierstellige
; BCD-Zahl von 0 bis 9999. Die Zahl ist anschließend rückwärts im Register d1 zu lesen 
; fertiger Algorithmus für Anzeigen auf dem Bildschirm

start:
	;move.w #$270F,d0		; von 0 bis 9999 (0 - $270F)
	move.w #$123,d0			; $123 Rasterzeilen	= 0291
_timeDisplayCounter:
							; =>d0.w = #of lines required by the calculations to display
	and.l #$0000FFFF,d0
	moveq #0,d1				; hier kommt das Ergebnis rein
	moveq #3-1,d2			; 3 Stellen, d.h. Anzahl Schleifen 2
_timeLoopNumber:
	divu #10,d0				; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0		; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1
	lsl.l #8,d1
	clr.w d0
	swap d0
	dbf d2,_timeLoopNumber
	divu #10,d0				; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0		; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1
; => d1 : d1 : sequence of 4 ASCII offsets in the font for the 4 characters to display,
; but in reverse order (ex: 123 => "3210")
	
	nop						; only for breakpoint
	rts
	
	end
	
;------------------------------------------------------------------------------
; Programmerklärung

D1= 11191210		; move.w #$123,d0	= 0291		-- 123 --> $3210 (D1= x1x9x2x0) 
D1= 13171210		; move.w #$111,d0	= 0273			   --> $1110 (D1= x3x7x2x0)

	move.w #$123,d0		; $123 = 291
;-1. Runde - nächstes Zeichen
	divu #10,d0			; d0=0001.001d			291/10=29,1		1d=29
	swap d0				; d0=001d.0001
	add.b #$30-$20,d0	; d0=001d.0011
	move.b d0,d1		; d1=0000.0011
	lsl.l #8,d1			; d1=0000.1100
	clr.w d0			; d0=001d.0000
	swap d0				; d0=0000.001d							1d=29
;-2. Runde - nächstes Zeichen
	divu #10,d0			; d0=0009.0002			29/10=2,9 		2=2
	swap d0				; d0=0002.0009
	add.b #$30-$20,d0	; d0=0002.0019
	move.b d0,d1		; d1=0000.1119
	lsl.l #8,d1			; d1=0011.1900
	clr.w d0			; d0=0002.0000
	swap d0				; d0=0000.0002							2=2
;-3. Runde - nächstes Zeichen
	divu #10,d0			; d0=0002.0000			2/10=0,2		0
	swap d0				; d0=0000.0002
	add.b #$30-$20,d0	; d0=0000.0012
	move.b d0,d1		; d1=0011.1912
	lsl.l #8,d1			; d1=1119.1200
	clr.w d0			; d0=0000.0000
	swap d0				; d0=0000.0000
;-3. Runde - nächstes Zeichen
	divu #10,d0			; d0=0000.0000			0
	swap d0				; d0=0000.0000
	add.b #$30-$20,d0	; d0=0000.0010
	move.b d0,d1		; d1=1119.1210		
	

>r 
soc22s.s
>a
Pass1
Pass2
No Errors
>x
	
		