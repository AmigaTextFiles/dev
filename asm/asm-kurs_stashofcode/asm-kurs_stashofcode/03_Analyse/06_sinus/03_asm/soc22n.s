
; soc22n.s
; Sinus der nächsten Spalte berechnen
; zur nächsten Spalte in der Bitebene wechseln

BLITTER=1						; 0=draw with CPU 1=draw with Blitter

SINE_SPEED_PIXEL=1

start:
	;move.w angle,d0
	;moveq	#10,d0							; aktueller Winkel 1. Test
	moveq	#0,d0							; aktueller Winkel 2. Test

; Sine of the next column

	subq.w #(SINE_SPEED_PIXEL<<1),d0		; d0=d0-2		; 1<<1= 2
	bge _anglePixelNoLoop					; solange größer, gleich, überspringen
	add.w #(360<<1),d0						; ansonsten 720 addieren, d0=d0+720 
_anglePixelNoLoop:

	IFNE BLITTER

	;Move to the next column in the bitplane
	
	;Blitter : it requires the number of the pixel in the word
	addq.b #1,d7							; d7+1
	btst #4,d7								; 1.0000 
	beq _pixelKeepWord						; wenn ja, überspringen
	addq.w #2,d6							; ansonsten d6+2
	clr.b d7								; d7 zurücksetzen
_pixelKeepWord:

	ELSE

	;CPU : it requires the number of the pixel in the word of the screen
	subq.b #1,d7							; von 15 nach 0 gezählt
	bge _pixelKeepWord						; wenn ja, überspringen
	addq.w #2,d6							; 1 Wort weiter (Offset in der Zeile)
	moveq #15,d7							; ansonsten auf Startwert 15 zurücksetzen
_pixelKeepWord:

	ENDC


	rts

	end