
; soc04g.s
; Ermittlung Zeilenversätze

DISPLAY_DX=320
DISPLAY_DY=256

OFFSET_AMPLITUDE=10
OFFSET_ROW_SPEED=2

; Speicher für Zeilenversätze zuordnen
	
	;move.l #DISPLAY_DY<<1,d0		; 256*2 = 512
	;move.l #$10002,d1
	;movea.l $4,a6
	;jsr -198(a6)
	;move.l d0,rowOffsets			; Adresse speichern

start:
; Zeilenversätze

	;movea.l rowOffsets,a0			; Anfangsadresse rowOffsets
	lea rowOffsets,a0
	lea sinus,a1					; Anfangsadresse Sinus
	move.w #(360-1)<<1,d1			; 359*2=718
	move.w #DISPLAY_DY-1,d0			; 256 Zeilen Schleifenzähler
_rowOffsetsLoop:
	move.w (a1,d1.w),d2				; aktuellen Sinuswert nach d2
	muls #OFFSET_AMPLITUDE,d2		; d2=A*sin(x) 
	swap d2							; Registerwerte tauschen 
	rol.l #2,d2						; Registerinhalt um 2 Bit rotieren
	addi.w #OFFSET_AMPLITUDE,d2		; und 10 addieren
	bclr #0,d2						; Kommt dazu, Dn durch 2 für das Verhältnis zu [0, AMPLITUDE] 
	move.w d2,(a0)+					; zu teilen und es dann mit 2 zu multiplizieren, damit ein WORT adressiert werden kann 	
	subi.w #OFFSET_ROW_SPEED<<1,d1	; 2*2=4 subtrahieren
	bge _rowOffsetsLoopNoSinusUnderflow			; wenn >=0 dann überspringen
	addi.w #360<<1,d1				; ansonsten +720 auf Anfangswert zurücksetzen
_rowOffsetsLoopNoSinusUnderflow:
	dbf d0,_rowOffsetsLoop			; 


	rts

;----------Daten ----------

	SECTION yragael,DATA_C
bitplane:			DC.L 0
rgbOffsets:			DC.L 0		; Adresse des zugewiesenen Speicherbereichs über 3*(360*2)=2160 Bytes im Chip-RAM für die Komponentenversätze
;rowOffsets:			DC.L 0		; Adresse des zugewiesenen Speicherbereichs über 256*2 = 512 Bytes im Chip-RAM für die Zeilenversätze
graphicslibrary:	DC.B "graphics.library",0
	even
copperList0:		DC.L 0
copperList1:		DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
;redSinus:			DC.W RED_START
;greenSinus:			DC.W GREEN_START
;blueSinus:			DC.W BLUE_START

rowOffsets:		dcb.w	1000,$FFFF

sinus:
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

	end

; Ergebnis:

>m 23fa8
00023FA8 0008 0008 0008 0008 0008 0008 0006 0006  ................
00023FB8 0006 0006 0006 0006 0004 0004 0004 0004  ................
00023FC8 0004 0004 0002 0002 0002 0002 0002 0002  ................
00023FD8 0002 0002 0002 0000 0000 0000 0000 0000  ................
00023FE8 0000 0000 0000 0000 0000 0000 0000 0000  ................
00023FF8 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024008 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024018 0000 0000 0000 0000 0000 0000 0000 0002  ................
00024028 0002 0002 0002 0002 0002 0002 0002 0002  ................
00024038 0004 0004 0004 0004 0004 0004 0006 0006  ................
00024048 0006 0006 0006 0006 0008 0008 0008 0008  ................
00024058 0008 0008 000A 000A 000A 000A 000A 000A  ................
00024068 000C 000C 000C 000C 000C 000C 000E 000E  ................
00024078 000E 000E 000E 000E 0010 0010 0010 0010  ................
00024088 0010 0010 0010 0010 0010 0012 0012 0012  ................
00024098 0012 0012 0012 0012 0012 0012 0012 0012  ................
000240A8 0012 0012 0012 0012 0012 0012 0012 0012  ................
000240B8 0012 0012 0012 0012 0012 0012 0012 0012  ................
000240C8 0012 0012 0012 0012 0012 0012 0012 0012  ................
000240D8 0012 0010 0010 0010 0010 0010 0010 0010  ................
>m
000240E8 0010 0010 000E 000E 000E 000E 000E 000E  ................
000240F8 000C 000C 000C 000C 000C 000C 000A 000A  ................
00024108 000A 000A 000A 000A 0008 0008 0008 0008  ................
00024118 0008 0008 0006 0006 0006 0006 0006 0006  ................
00024128 0004 0004 0004 0004 0004 0004 0002 0002  ................
00024138 0002 0002 0002 0002 0002 0002 0002 0000  ................
00024148 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024158 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024168 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024178 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024188 0000 0000 0000 0002 0002 0002 0002 0002  ................
00024198 0002 0002 0002 0002 0004 0004 0004 0004  ................
000241A8 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................