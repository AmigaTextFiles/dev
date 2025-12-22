
; soc04b.s
; dc.w $2c3F bzw. dc.w $2c3D 
; Programm zeigt wie die horizontale Copper-Waitpostion bei jeder ungeraden Zeile
; um zwei Pixel verschoben wird

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256

start:
	lea copper,a0
	move.w #((DISPLAY_Y&$00FF)<<8)!((((DISPLAY_X-4)>>2)<<1)&$00FE)!$0001,d0			; dc.w $2c3F
	;move.w #DISPLAY_DY-1,d1				; 255-1 Schleifenzähler
	move.w #2,d1
_rows:

; WAIT (Wechseln Sie die horizontale Position zwischen DISPLAY_X-4 und DISPLAY_X
; von einer Zeile zur anderen, um den Effekt von Blöcken zu verringern, die durch
; die Länge der MOVs (8 Pixel) erzeugt werden.)

	btst #0,d1							; Bit 0 
	beq _lineEven						; wenn 0, dann ist es gerade
	bset #1,d0							; Bit 1 setzen --> dc.w $2c3F
	bra _lineOdd
_lineEven:
	bclr #1,d0							; Bit 1 löschen --> dc.w $2c3D
_lineOdd:
	move.w d0,(a0)+						; dc.w $2c3F 
	move.w #$FFFE,(a0)+					; dc.w $xxxx,$FFFE

	dbf d1,_rows

	rts
	
copper:
	dc.l $0,$0,$0						

	end

>m c25be2
00C25BE2 2C3D FFFE 2C3F FFFE 2C3D FFFE 0023 1234  ,=..,?..,=...#.4

>?$3D
0x0000003D = %00000000000000000000000000111101 = 61 = 61
>?$3F
0x0000003F = %00000000000000000000000000111111 = 63 = 63
>