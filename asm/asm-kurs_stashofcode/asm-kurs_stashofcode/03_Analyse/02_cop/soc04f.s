
; soc04f.s
; Ermittlung Komponentenversätze

RED_START  =359<<1		; Wert zwischen 0 und 718	(Winkelwert * 2)
RED_AMPLITUDE   =18		; OFFSET_AMPLITUDE+RED_AMPLITUDE muss <= 29 sein 

; Speicher für Komponentenversätze zuordnen

	;move.l #3*(360<<1),d0			; 3*(360*2)=2160
	;move.l #$10002,d1
	;movea.l $4,a6
	;jsr -198(a6)
	;move.l d0,rgbOffsets

start:
	moveq	#0,d1
; Komponentenversätze

	;movea.l rgbOffsets,a0			; Anfangsadresse rgbOffsets
	lea rgbOffsets,a0				; Anfangsadresse der Komponentenversätze
	lea sinus,a1					; Anfangsadresse Sinus
	;move.w #360-1,d0				; 360 Schleifenzähler
	move.w #4-1,d0					; zu Testzwecken 
_redOffsetsLoop:
	move.w (a1)+,d1					; aktueller Sinuswert nach d1
	muls #RED_AMPLITUDE,d1			; Amplitude von rot
	swap d1							; Registerwerte tauschen 
	rol.l #2,d1						; Registerinhalt um 2 Bit rotieren
	addi.w #RED_AMPLITUDE,d1		; roten Amplitudenwert addieren
	bclr #0,d1						; Kommt dazu, Dn durch 2 für das Verhältnis zu [0, AMPLITUDE] 
	move.w d1,(a0)+					; zu teilen und es dann mit 2 zu multiplizieren, damit ein WORT adressiert werden kann
	dbf d0,_redOffsetsLoop			; über alle Winkelwerte wiederholen

	movea.l rowOffsets,a6			; Adresse nach a6 von einem Speicherbereich
	move.w redSinus,d3				; rote Komponenete nach d3	
; Sinusförmige Startversätze in Farbkomponenten
	
	movea.l rgbOffsets,a1			; Anfangsadresse der Komponenetenversätze nach a1
	move.w (a1,d3.w),d6				; Offset addieren, aktueller Wert Komponenetenversatz nach d6
	add.w (a6),d6					; Wert von rowOffsets zu Komponenetenversatz addieren
	lea red,a2						; Anfangsadresse Feld rot
	lea (a2,d6.w),a2				; Ergebnis Adresse in a2 (des ermittelten Farbwertes)

	rts


;----------Daten ----------

	SECTION yragael,DATA_C
bitplane:			DC.L 0
;rgbOffsets:			DC.L 0		; Adresse des zugewiesenen Speicherbereichs über 3*(360*2)=2160 Bytes im Chip-RAM für die Komponentenversätze
rowOffsets:			DC.L 0
graphicslibrary:	DC.B "graphics.library",0
	even
copperList0:		DC.L 0
copperList1:		DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
redSinus:			DC.W RED_START
;greenSinus:			DC.W GREEN_START
;rblueSinus:			DC.W BLUE_START

rgbOffsets:		dcb.w	1000,$FFFF

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

; Komponenten (sinus)

red:
	dc.w $0800, $0900, $0B00, $0C00, $0D00, $0E00, $0F00, $0F00
	dc.w $0F00, $0F00, $0E00, $0D00, $0C00, $0B00, $0900, $0800
	dc.w $0600, $0400, $0300, $0200, $0100, $0000, $0000, $0000
	dc.w $0000, $0100, $0200, $0300, $0400, $0600, $0800, $0900
	dc.w $0B00, $0C00, $0D00, $0E00, $0F00, $0F00, $0F00, $0F00
	dc.w $0E00, $0D00, $0C00, $0B00, $0900, $0800, $0600, $0400
	dc.w $0300, $0200, $0100, $0000, $0000, $0000, $0000, $0100
	dc.w $0200, $0300, $0400, $0600, $0800, $0900, $0B00, $0C00 ; 8x8=64
	dc.w $0D00, $0E00, $0F00, $0F00, $0F00, $0F00				; 74


	end

; Ergebnis Komponentenversätze

>m 23faa
00023FAA 0012 0012 0012 0012 0012 0012 0012 0014  ................	
00023FBA 0014 0014 0014 0014 0014 0016 0016 0016  ................
00023FCA 0016 0016 0016 0016 0018 0018 0018 0018  ................
00023FDA 0018 0018 0018 001A 001A 001A 001A 001A  ................
00023FEA 001A 001A 001C 001C 001C 001C 001C 001C  ................
00023FFA 001C 001C 001E 001E 001E 001E 001E 001E  ................
0002400A 001E 001E 001E 001E 0020 0020 0020 0020  ......... . . .
0002401A 0020 0020 0020 0020 0020 0020 0020 0022  . . . . . . . ."
0002402A 0022 0022 0022 0022 0022 0022 0022 0022  ."."."."."."."."
0002403A 0022 0022 0022 0022 0022 0022 0022 0022  ."."."."."."."." ; 10
0002404A 0022 0022 0022 0022 0022 0022 0022 0022  ."."."."."."."."
0002405A 0022 0022 0024 0022 0022 0022 0022 0022  .".".$."."."."."
0002406A 0022 0022 0022 0022 0022 0022 0022 0022  ."."."."."."."."
0002407A 0022 0022 0022 0022 0022 0022 0022 0022  ."."."."."."."."
0002408A 0022 0022 0022 0022 0022 0022 0020 0020  .".".".".".". .
0002409A 0020 0020 0020 0020 0020 0020 0020 0020  . . . . . . . .
000240AA 0020 001E 001E 001E 001E 001E 001E 001E  . ..............
000240BA 001E 001E 001E 001C 001C 001C 001C 001C  ................
000240CA 001C 001C 001C 001A 001A 001A 001A 001A  ................
000240DA 001A 001A 0018 0018 0018 0018 0018 0018  ................ ; 20
>m
000240EA 0018 0016 0016 0016 0016 0016 0016 0016  ................
000240FA 0014 0014 0014 0014 0014 0014 0012 0012  ................
0002410A 0012 0012 0012 0012 0012 0010 0010 0010  ................
0002411A 0010 0010 0010 000E 000E 000E 000E 000E  ................
0002412A 000E 000C 000C 000C 000C 000C 000C 000C  ................
0002413A 000A 000A 000A 000A 000A 000A 000A 0008  ................
0002414A 0008 0008 0008 0008 0008 0008 0006 0006  ................
0002415A 0006 0006 0006 0006 0006 0006 0004 0004  ................
0002416A 0004 0004 0004 0004 0004 0004 0004 0004  ................
0002417A 0002 0002 0002 0002 0002 0002 0002 0002  ................ ; 30
0002418A 0002 0002 0002 0000 0000 0000 0000 0000  ................
0002419A 0000 0000 0000 0000 0000 0000 0000 0000  ................
000241AA 0000 0000 0000 0000 0000 0000 0000 0000  ................
000241BA 0000 0000 0000 0000 0000 0000 0000 0000  ................
000241CA 0000 0000 0000 0000 0000 0000 0000 0000  ................
000241DA 0000 0000 0000 0000 0000 0000 0000 0000  ................
000241EA 0000 0000 0000 0000 0000 0000 0000 0000  ................
000241FA 0000 0000 0002 0002 0002 0002 0002 0002  ................
0002420A 0002 0002 0002 0002 0002 0004 0004 0004  ................
0002421A 0004 0004 0004 0004 0004 0004 0004 0006  ................ ; 40
>m
0002422A 0006 0006 0006 0006 0006 0006 0006 0008  ................	
0002423A 0008 0008 0008 0008 0008 0008 000A 000A  ................
0002424A 000A 000A 000A 000A 000A 000C 000C 000C  ................
0002425A 000C 000C 000C 000C 000E 000E 000E 000E  ................
0002426A 000E 000E 0010 0010 0010 0010 0010 0010  ................ ; 45*8=360 
0002427A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................

