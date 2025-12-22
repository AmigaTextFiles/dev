
; soc22j.s
; die Zeile (Adresse in bitplane) finden wo das Zeichen gedruckt werden soll (Sinus) 

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
SCROLL_DX=DISPLAY_DX							; Scrollbereich geht über den gesamten Bildschirm

SCROLL_DY=100									; Scrollbereich Höhe
SCROLL_AMPLITUDE=SCROLL_DY-16					; SCROLL_DY-16 is the amplitude for possible ordinates of the scroll: [0,SCROLL_DY-16]
												; SCROLL_DY must be even so that the scroll is centered on DISPLAY_DY (which is even)
												; So SCROLL_DY-16 is even
												; The ordinates are given by (A>>1)*sin that gives values in [-A,A] when A is even and in [-A+1,A+1] when A is odd
												; 100-16=84
SCROLL_Y=(DISPLAY_DY-SCROLL_DY)>>1				; (256-100)/2 = 156/2=78

; Various initializations
	clr.l d1									; d1 zurücksetzen
	move.w angle,d0								; $14 = 20
	move.w #SCROLL_DX-1,d1						; $13f = 319
	move.l bitplaneB,a2							; Anfangsadresse der Bitplane in die gezeichnet werden soll

; Compute the address of the word that contains the column to draw in the bitplane
	
	lea sinus,a6								; Beginn Tabelle der Sinuswerte nach a6 = sin(0)
	move.w (a6,d0.w),d1							; den entsprechenden Sinuswert zum Winkel finden = sin(x)	; $b1d = 2845
	muls #(SCROLL_AMPLITUDE>>1),d1				; Amplitude = A*sin(x)			d1= (84/2)*sin(x)  d1= $1d2c2
	swap d1										; /2^16  = d2c2.0001  (2^16=65536)
	rol.l #2,d1									; *2     = 4b08.0007	
												; an dieser Stelle haben wir den mit 2^14 erweiterten Amplitudenwert zum aktuellen Sinuswert 
												; dieser Wert kann zwischen -42 und 42 liegen und wird zur Nullinie/ Mittellinie addiert

												; die Nulllinie liegt bei Zeile 120  (der Sinus scrollt somit zwischen den Zeilen 78, 162)
												; positive Werte führen zu tieferen Zeilen, negative Werte zu höheren Zeilen auf dem Bildschirm
												; das Ergebnis ist das erste Wort der Zeile	
	add.w #SCROLL_Y+(SCROLL_AMPLITUDE>>1),d1	; #SCROLL_Y+(SCROLL_AMPLITUDE>>1) = 78+(84/2)=120    ; Mitte des Scrolltextes und d1 =[-42,42] = 4b08.007F
	move.w d1,d2								; Kopie = d2= 0000.007F für Optimierung  (in d1 ist die Zeile z.B. $7f=Zeile 127)
	lsl.w #5,d1									; d1= 4b08.0fe0
	lsl.w #3,d2									; d2=     .03f8
	add.w d2,d1									; d1=x.13d8			; d1 = (DISPLAY_DX>>3)*d1 = 40*d1 = (32*d1)+(8*d1) = (2^5*d1)+(2^3*d1)
	add.w d6,d1									; d6=0 (horizontaler Versatz auf der Zeile)
	lea (a2,d1.w),a4							; Word in bitplane (Zeile)

	rts
	
; Daten
angle:					DC.W 20					; holt Wert 2845 das 20.byte nach Start Tabelle Sinus
bitplaneA:				DC.L 0
bitplaneB:				DC.L 0
bitplaneC:				DC.L 0
sinus:					DC.W 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382, 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286

sinus_:
	dc.w $0000, $011E, $023C, $0359, $0477, $0594, $06B1, $07CD
	dc.w $08E8, $0A03, $0B1D, $0C36, $0D4E, $0E66, $0F7C, $1090
	dc.w $11A4, $12B6, $13C7, $14D6, $15E4, $16F0, $17FA, $1902
	dc.w $1A08, $1B0C, $1C0E, $1D0E, $1E0C, $1F07, $2000, $20F6
	dc.w $21EA, $22DB, $23CA, $24B5, $259E, $2684, $2767, $2847
	dc.w $2923, $29FD, $2AD3, $2BA6, $2C75, $2D41, $2E0A, $2ECE
	dc.w $2F90, $304D, $3107, $31BD, $326F, $331D, $33C7, $346D
	dc.w $350F, $35AD, $3646, $36DC, $376D, $37FA, $3882, $3906
	dc.w $3986, $3A01, $3A78, $3AEA, $3B57, $3BC0, $3C24, $3C83
	dc.w $3CDE, $3D34, $3D85, $3DD2, $3E19, $3E5C, $3E9A, $3ED3
	dc.w $3F07, $3F36, $3F61, $3F86, $3FA6, $3FC2, $3FD8, $3FEA
	dc.w $3FF6, $3FFE, $4000, $3FFE, $3FF6, $3FEA, $3FD8, $3FC2
	dc.w $3FA6, $3F86, $3F61, $3F36, $3F07, $3ED3, $3E9A, $3E5C
	dc.w $3E19, $3DD2, $3D85, $3D34, $3CDE, $3C83, $3C24, $3BC0
	dc.w $3B57, $3AEA, $3A78, $3A01, $3986, $3906, $3882, $37FA
	dc.w $376D, $36DC, $3646, $35AD, $350F, $346D, $33C7, $331D
	dc.w $326F, $31BD, $3107, $304D, $2F90, $2ECE, $2E0A, $2D41
	dc.w $2C75, $2BA6, $2AD3, $29FD, $2923, $2847, $2767, $2684
	dc.w $259E, $24B5, $23CA, $22DB, $21EA, $20F6, $2000, $1F07
	dc.w $1E0C, $1D0E, $1C0E, $1B0C, $1A08, $1902, $17FA, $16F0
	dc.w $15E4, $14D6, $13C7, $12B6, $11A4, $1090, $0F7C, $0E66
	dc.w $0D4E, $0C36, $0B1D, $0A03, $08E8, $07CD, $06B1, $0594
	dc.w $0477, $0359, $023C, $011E, $0000, $FEE2, $FDC4, $FCA7
	dc.w $FB89, $FA6C, $F94F, $F833, $F718, $F5FD, $F4E3, $F3CA
	dc.w $F2B2, $F19A, $F084, $EF70, $EE5C, $ED4A, $EC39, $EB2A
	dc.w $EA1C, $E910, $E806, $E6FE, $E5F8, $E4F4, $E3F2, $E2F2
	dc.w $E1F4, $E0F9, $E000, $DF0A, $DE16, $DD25, $DC36, $DB4B
	dc.w $DA62, $D97C, $D899, $D7B9, $D6DD, $D603, $D52D, $D45A
	dc.w $D38B, $D2BF, $D1F6, $D132, $D070, $CFB3, $CEF9, $CE43
	dc.w $CD91, $CCE3, $CC39, $CB93, $CAF1, $CA53, $C9BA, $C924
	dc.w $C893, $C806, $C77E, $C6FA, $C67A, $C5FF, $C588, $C516
	dc.w $C4A9, $C440, $C3DC, $C37D, $C322, $C2CC, $C27B, $C22E
	dc.w $C1E7, $C1A4, $C166, $C12D, $C0F9, $C0CA, $C09F, $C07A
	dc.w $C05A, $C03E, $C028, $C016, $C00A, $C002, $C000, $C002
	dc.w $C00A, $C016, $C028, $C03E, $C05A, $C07A, $C09F, $C0CA
	dc.w $C0F9, $C12D, $C166, $C1A4, $C1E7, $C22E, $C27B, $C2CC
	dc.w $C322, $C37D, $C3DC, $C440, $C4A9, $C516, $C588, $C5FF
	dc.w $C67A, $C6FA, $C77E, $C806, $C893, $C924, $C9BA, $CA53
	dc.w $CAF1, $CB93, $CC39, $CCE3, $CD91, $CE43, $CEF9, $CFB3
	dc.w $D070, $D132, $D1F6, $D2BF, $D38B, $D45A, $D52D, $D603
	dc.w $D6DD, $D7B9, $D899, $D97C, $DA62, $DB4B, $DC36, $DD25
	dc.w $DE16, $DF0A, $E000, $E0F9, $E1F4, $E2F2, $E3F2, $E4F4
	dc.w $E5F8, $E6FE, $E806, $E910, $EA1C, $EB2A, $EC39, $ED4A
	dc.w $EE5C, $EF70, $F084, $F19A, $F2B2, $F3CA, $F4E3, $F5FD
	dc.w $F718, $F833, $F94F, $FA6C, $FB89, $FCA7, $FDC4, $FEE2
	dc.w $1234, $5678, $0101, $0000, $0004, $0101, $0000, $000E
	dc.w $0101, $0000, $0014, $0000, $0000, $0000, $0000, $0000	
	end
