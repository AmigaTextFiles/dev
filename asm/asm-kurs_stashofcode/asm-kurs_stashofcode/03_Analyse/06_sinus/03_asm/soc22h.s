
; soc22h.s
; 1. d6 - Offset ermitteln vom Anfang der Zeile um das Wort in der Bitplane zu finden
;         wo die erste Spalte gezeichnet werden soll
; 2. d7 - das Bit in diesem Word in dieser Spalte

; Program

DISPLAY_DX=320						; Breite Bildschirm
SCROLL_DX=DISPLAY_DX				; Scrollbereich geht über den gesamten Bildschirm
;SCROLL_X=(DISPLAY_DX-SCROLL_DX)>>1	; (320-320)/2 = 0

;SCROLL_X=0			; das Drucken der Scrolltextes in die Bitplane beginnt ganz links
;SCROLL_X=160		; das Drucken der Scrolltextes in die Bitplane beginnt in der Mitte
SCROLL_X=19			; zum Test

BLITTER=0							; 0=draw with CPU 1=draw with Blitter

; Get the offset of the word of the bitplane where the first column must be drawn

	moveq #SCROLL_X,d6				; 0
	;move #SCROLL_X,d6				; für SCROLL_X >= 128
	lsr.w #3,d6						; Offset of the byte in the column of the bitplane				/ 8
	bclr #0,d6						; Offset of the word (same thing as lsr.w #4 then lsl.w #1)		/ gerade Adresse	

; Get the bit in this word matching this column

	IFNE BLITTER
	
; Blitter : it requires the number of the pixel in the word of the screen
	moveq #SCROLL_X,d7
	;move #SCROLL_X,d7				; für SCROLL_X >= 128
	and.w #$000F,d7

	ELSE
	
; CPU :  it requires the number of the bit matching the pixel in the word of the screen
	moveq #SCROLL_X,d4
	;move #SCROLL_X,d4				; für SCROLL_X >= 128
	and.w #$000F,d4
	moveq #15,d7
	sub.b d4,d7

	ENDC
	
	rts

	end


Programmbeschreibung:

Hier geht es darum den horizontalen Versatz in der Zeile zu ermitteln, wenn der 
Start des Scrolltextes auf dem Bildschirm an irgendeiner Position erfolgt.
In d6 steht der Byte-Offset, aber immer auf gerade Adressen und in d7
das Bit in diesem ermittelten Word. Einmal für die Variante CPU und für die 
Variante Blitter.

z.B.
>?90>>3
$0000000B = %00000000`00000000`00000000`00001011 = 11 = 11
>?11&$FE
$0000000A = %00000000`00000000`00000000`00001010 = 10 = 10
>?10*8
$00000050 = %00000000`00000000`00000000`01010000 = 80 = 80
>?12*8
$00000060 = %00000000`00000000`00000000`01100000 = 96 = 96
>

>?90
$0000005A = %00000000`00000000`00000000`01011010 = 90 = 90
>?90&$F
$0000000A = %00000000`00000000`00000000`00001010 = 10 = 10
>?$F-$A
$00000005 = %00000000`00000000`00000000`00000101 = 5 = 5
>

oder d7=15, wenn auf Wordanfang ausgerichtet
>?80&$F
$00000000 = %00000000`00000000`00000000`00000000 = 0 = 0
>?$F-$0
$0000000F = %00000000`00000000`00000000`00001111 = 15 = 15
>
