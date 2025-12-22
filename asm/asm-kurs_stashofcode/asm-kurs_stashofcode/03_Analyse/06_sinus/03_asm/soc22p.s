
; soc22p.s
; Berechnung aktueller Winkelwert

SINE_SPEED_FRAME=5

; Animate the sine of the image

	;lea winkel,a1					; test
	move.w #80,d5					; 360°/5=72
angle_loop:
	move.w angle,d0					; in angle ist der Winkelwert gespeichert von 0 bis 720 im Abstand von 10 bzw. 5°
	sub.w #(SINE_SPEED_FRAME<<1),d0	; <<1 bedeutet 5*2=10 (left shift) 00101<<1= 1010
	bge _angleFrameNoLoop			; if >=0 ist iO
	add.w #(360<<1),d0				; ansonsten Startwert = $2c6 (710)
_angleFrameNoLoop:
	move.w d0,angle					; Winkelwert wieder abspeichern
	;move.w d0,(a1)+
	dbf d5,angle_loop				; für alle Winkelwerte und noch etwas mehr
	rts


; Daten
angle:					DC.W 20		; $14

winkel:
	blk.w 80,0						; test zum Speichern der Winkelwerte

	end

Programmerklärung:

aktueller Winkelwert wird gelesen, geändert und wieder gespeichert
720 = 0, es ist der selbe Punkt auf dem Kreis (2*360)
daher wenn Winkel <0 ist wird (720) dazu addiert

sub.w #(SINE_SPEED_FRAME<<1),d0		; 0 --> $fff6	= -10
add.w #(360<<1),d0					; 2C6 = 710

im nächsten loop angle = 2bc (700), 2b2 (690), 2a8 (680)

>m c25cb4 200
00C25CB4 000A 0000 02C6 02BC 02B2 02A8 029E 0294  ................		
00C25CC4 028A 0280 0276 026C 0262 0258 024E 0244  .....v.l.b.X.N.D		; 9*8=72 Werte
00C25CD4 023A 0230 0226 021C 0212 0208 01FE 01F4  .:.0.&..........
00C25CE4 01EA 01E0 01D6 01CC 01C2 01B8 01AE 01A4  ................
00C25CF4 019A 0190 0186 017C 0172 0168 015E 0154  .......|.r.h.^.T
00C25D04 014A 0140 0136 012C 0122 0118 010E 0104  .J.@.6.,."......
00C25D14 00FA 00F0 00E6 00DC 00D2 00C8 00BE 00B4  ................
00C25D24 00AA 00A0 0096 008C 0082 0078 006E 0064  ...........x.n.d
00C25D34 005A 0050 0046 003C 0032 0028 001E 0014  .Z.P.F.<.2.(....
00C25D44 000A 0000 02C6 02BC 02B2 02A8 029E 0294  ................

>?9*8
$00000048 = %00000000`00000000`00000000`01001000 = 72 = 72
>?9*8*10
$000002D0 = %00000000`00000000`00000010`11010000 = 720 = 720
>
