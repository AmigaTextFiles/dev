
; soc15_angep.s = unlimitedBobs.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; "Unlimited bobs" mit einem BOB von 16 x 16 Pixeln in vier Farben.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=2
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; 4						$FFFFFFFE
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder &$00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = 0
BPLCON2_val = 0
BPL1MOD_val = (DISPLAY_DEPTH-1)*(DISPLAY_DX>>3)
BPL2MOD_val = (DISPLAY_DEPTH-1)*(DISPLAY_DX>>3)
;----------------------------------------------------------
BOB_DX=16
BOB_DY=16
BOB_DEPTH=DISPLAY_DEPTH
NBFRAMES=7
RADIUS_MIN=10
RADIUS_MAX=(DISPLAY_DY-BOB_DY)>>1
RADIUS_SPEED=2
ANGLE_SPEED=2

;********** Macros **********

WAIT_BLITTER:		MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)		; Entspricht dem Testen von Bit 14 % 8 = 6 des höchstwertigen Bytes von DMACONR, also BBUSY
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM	

;********** Initialisierung **********

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist
	; für die Bilder der Animation (eines nach dem anderen, um unter der
	; maximalen Größe eines verfügbaren Blocks zu bleiben)

	movea.l $4,a6
	lea images,a0
	moveq #NBFRAMES-1,d2
_allocImages:
	move.l #$10002,d1
	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movem.l a0/d2,-(sp)
	jsr -198(a6)
	movem.l (sp)+,a0/d2
	move.l d0,(a0)+
	dbf d2,_allocImages

	; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	bsr _waitVERTB
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

	; Umleitung von Hardware-Interrupt-Vektoren (Stufe 1 bis 6 entspricht
	; den Vektoren 25 bis 30, die auf die Adressen $64 bis $78 zeigen)

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

;********** Copperlist **********

	movea.l copperList,a0

	move.w #DIWSTRT,(a0)+				; Konfiguration des Bildschirms				
	move.w #DIWSTRT_val,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #DIWSTOP_val,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #DDFSTRT_val,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #DDFSTOP_val,(a0)+

	move.w #BPLCON0,(a0)+
	move.w #BPLCON0_val,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #BPLCON1_val,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #BPLCON2_val,(a0)+	

	move.w #BPL1MOD,(a0)+
	move.w #BPL1MOD_val,(a0)+			; RAW Blitter für ungerade Bitplanes
	move.w #BPL2MOD,(a0)+
	move.w #BPL1MOD_val,(a0)+			; RAW Blitter für gerade Bitplanes

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l images,d1
	moveq #DISPLAY_DEPTH-1,d2			; Anzahl der Bitebenen, hier 2
_bitplanes:
	move.w d0,(a0)+						; Registeradresse BPL1PTH in Copperlist 
	swap d1								; Hi-Lo Anteil Adresse Wörter tauschen
	move.w d1,(a0)+						; hohes Wort der Adresse in Copperlist
	addq.w #2,d0						; Registeradresse 2 Bytes addieren 
	move.w d0,(a0)+						; Registeradresse BPL1PTL in Copperlist
	swap d1								; Hi-Lo Anteil Adresse Wörter tauschen
	move.w d1,(a0)+						; niedriges Wort der Adresse in Copperlist
	addq.w #2,d0						; Registeradresse 2 Bytes addieren, ergibt BPL2PTH
	addi.l #DISPLAY_DX>>3,d1			; Adresse nächste Bitplane (320/8=40 Bytes)	hier Unterschied zu normal !
	dbf d2,_bitplanes					; wiederholen für alle Bitebenen

	; Palette

	lea bob+BOB_DEPTH*BOB_DY*(BOB_DX>>3),a1
	move.w #COLOR00,d0
	moveq #(1<<DISPLAY_DEPTH)-1,d1
_palette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_palette

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

;********** Hauptprogramm **********

	; Erstellen Sie die Bob-Maske

	lea bob,a0								; Adresse Bob
	lea bobMask,a1							; Adresse Bob Maske
	moveq #BOB_DY-1,d0						; 16-1 Schleifenzähler Zeilen
_maskRows:
	;moveq #(BOB_DX>>4)-1,d1				; (16/16)-1 Schleifenzähler Spalten
											; in diesem Fall 16Pixel breit, also 1 Wort
_maskCols:
	movea.l a0,a2							; Kopie Adresse Bob
	moveq #0,d3								; d3 reinigen
	moveq #BOB_DEPTH-1,d2					; über alle Bitebenen, hier 2

_maskGetWord:
	or.w (a2),d3							; wo 1 sind, werden 1 gesetzt
	lea BOB_DX>>3(a2),a2					; 16/8=2 Zeiger auf nächste Bitebene setzen
	dbf d2,_maskGetWord						; wiederholen für alle Bitebenen

	movea.l a1,a2							; Kopie Adresse Bob Maske
	moveq #BOB_DEPTH-1,d2					; über alle Bitebenen, hier 2
_maskSetWord:
	move.w d3,(a2)							; Ergebnis ins Ziel Bob Maske kopieren
	lea (BOB_DX+16)>>3(a2),a2				; (16+16)/8=4 ; die Maske ist ein Wort breiter
	dbf d2,_maskSetWord						; wiederholen für alle Bitebenen
	
	lea 2(a0),a0							; Adresse Bob nächste Spalte, 
	lea 2(a1),a1							; Adresse Bob Maske nächste Spalte
	;dbf d1,_maskCols						; über alle Spalten des Bobs

	lea ((BOB_DEPTH-1)*BOB_DX)>>3(a0),a0			; ((2-1)*16)/8=2 nächste Zeile, wieder 1. Bitebene
	lea 2+(((BOB_DEPTH-1)*(BOB_DX+16))>>3)(a1),a1	; 2+(((2-1)*(16+16))/8)=6 nächste Zeile, 1. Bitebene
	dbf d0,_maskRows						; über alle 16 Zeilen des Bobs
	
	; Den Bob in die Ausgangsposition bringen

	move.w #0,bobX							; 0
	move.w #0,bobY							; 0
	move.w #RADIUS_MIN,radius				; 10
	move.w #RADIUS_SPEED,radiusSpeed		; 2
	
	; Hauptschleife

_loop:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist

	move.w #DISPLAY_Y+DISPLAY_DY,d0			; Zeile=$2c+256
	bsr _waitRaster							; auf die Rasterzeile warten

	; Bilder zirkulär austauschen (das zweite wird zum ersten, ...,
	; das erste wird zum letzten)

	lea images,a0							; a0 - Zeiger auf Anfang von Feld images
	move.l (a0),d1							; den 1. Wert der an der Adresse a0 steht nach d1 kopieren
	lea 4(a0),a1							; a1 - Zeiger auf nächste Adresse im Feld
	moveq #NBFRAMES-2,d0					; 7-2=5 Anzahl Schleifen
_swapImages:
	move.l (a1)+,(a0)+						; den zweiten auf den ersten usw.
	dbf d0,_swapImages						; wiederholen
	move.l d1,(a0)							; 1. Wert wird zum letzten

	; Das angezeigte Bild ändern

	move.l images,d0						; Zeiger auf Anfang von Feld images
	movea.l copperList,a0					; Adresse copperlist 
	lea 10*4+2(a0),a0						; zur Anfangsadresse der Copperliste hinzufügen
	moveq #DISPLAY_DEPTH-1,d1				; über alle Bitebenen
_swapBuffers:
	swap d0									; Adresse aktuelles image Hi-Lo tauschen
	move.w d0,(a0)							; hohen Teil der Adresse in Copperlist
	swap d0									; Adresse aktuelles image Hi-Lo zurücktauschen
	move.w d0,4(a0)							; niedrigen Teil der Adresse in Copperlist
	lea 8(a0),a0							; nächster Bitplanepointer in Copperlist
	addi.l #DISPLAY_DX>>3,d0				; 320/8=40 Bytes nächste Bitebene
	dbf d1,_swapBuffers						; wiederholen bis alle fertig

	; die Position beleben

	move.w angle,d0							; Winkelanfangswert
	subi.w #ANGLE_SPEED<<1,d0				; Winkelwert subtrahieren
	bge _noAngleUnderflow					; wenn nicht unter 0, ok
	addi.w #360<<1,d0						; ansonsten Startwert = $2c6 (710)
_noAngleUnderflow:
	move.w d0,angle							; Winkelwert wieder abspeichern

	move.w radius,d1						; Radius
	add.w radiusSpeed,d1					; Radiusgeschwindigkeit addieren
	bge _noRadiusUnderflow					; wenn nicht unter 0, ok
	neg.w radiusSpeed						; ansonsten Radiusgeschwindigkeit negieren, Richtungsumkehr
	add.w radiusSpeed,d1					; Radiusgeschwindigkeit addieren
	bra _noRadiusOverflow					; Radius abspeichern
_noRadiusUnderflow:
	cmpi.w #RADIUS_MAX,d1					; maximalen Radius erreicht?
	ble _noRadiusOverflow					; wenn nicht über max, ok
	neg.w radiusSpeed						; ansonsten Radiusgeschwindigkeit negieren, Richtungsumkehr
	add.w radiusSpeed,d1					; Radiusgeschwindigkeit addieren
_noRadiusOverflow:
	move.w d1,radius						; Radius abspeichern 
	
	; Berechnen Sie die nächste Position des Bobs

	lea cosinus,a0							; Beginn Tabelle der Cosinuswerte nach a0 = cos(0)
	move.w (a0,d0.w),d2						; den entsprechenden Cosinuswert zum Winkel finden = cos(x)
	muls d1,d2								; Amplitude = A*cos(x)
	swap d2									; /2^16 = (2^16=65536)
	rol.l #2,d2								; *2 ; zusammen 2^14 
	addi.w #DISPLAY_DX>>1,d2				; den mit 2^14 erweiterten Amplitudenwert zum Display (320/2) addieren
	move.w d2,bobX							; Wert in bobX speichern
	
	lea sinus,a0							; Beginn Tabelle der Sinuswerte nach a0 = sin(0)
	move.w (a0,d0.w),d2						; den entsprechenden Sinuswert zum Winkel finden = sin(x)
	muls d1,d2								; Amplitude = A*sin(x)
	swap d2									; /2^16 = (2^16=65536)
	rol.l #2,d2								; *2 ; zusammen 2^14 
	addi.w #DISPLAY_DY>>1,d2				; den mit 2^14 erweiterten Amplitudenwert zum Display (320/2) addieren
	move.w d2,bobY							; Wert in bobY speichern

	; Zeichnen Sie den Bob an der nächsten Position im folgenden Bild

	;moveq #0,d1							; wird nicht benötigt
	move.w bobX,d0							; aktuelle X-Position des Bobs
	subi.w #BOB_DX>>1,d0					; 16/2=8
	move.w d0,d1							; Kopie
	and.w #$F,d0							; niedriges Wort maskieren
	ror.w #4,d0								; 
	move.w d0,BLTCON1(a5)					; BSH3-0=Verschiebung
	or.w #$0FF2,d0							; ASH3-0=Verschiebung, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	move.w d0,BLTCON0(a5)					; fertigen Wert in BLTCON0 laden
	lsr.w #3,d1								; multiplizieren * 8
	and.b #$FE,d1							; nur gerade Bytes zulassen
	move.w bobY,d0							; aktuelle Y-Position des Bobs
	subi.w #BOB_DY>>1,d0					; 16/2=8
	mulu #DISPLAY_DEPTH*(DISPLAY_DX>>3),d0	; 2*(320/8) = 80 Bytes , d0=d0*80 Zeile in der Bitebene finden
	add.l d1,d0								; das richtige Byte in der Zeile finden
	move.l images+4,d1						; Bob im folgenden Bild schreiben
	add.l d1,d0								; ins richtige Image
	move.w #$FFFF,BLTAFWM(a5)				; alles passiert
	move.w #$0000,BLTALWM(a5)				; alles gelöscht 
	move.w #-2,BLTAMOD(a5)					; Modulo Bob
	move.w #0,BLTBMOD(a5)					; Modulo Maske
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTCMOD(a5)	; 
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTDMOD(a5)	; 
	move.l #bob,BLTAPTH(a5)					; Quelle A - Bob
	move.l #bobMask,BLTBPTH(a5)				; Quelle B - Maske
	move.l d0,BLTCPTH(a5)					; Quelle C - Hintergrund
	move.l d0,BLTDPTH(a5)					; Ziel D - 
	move.w #(BOB_DEPTH*(BOB_DY<<6))!((BOB_DX+16)>>4),BLTSIZE(a5) ; 2*64 Zeilen * 32/16=4 Wörter Breite
	WAIT_BLITTER

	; Testen eines Drucks der linken Maustaste

	btst #6,$BFE001
	bne _loop

;********** Ende **********

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und 
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	bsr _waitVERTB
	move.w #$07FF,DMACON(a5)

	; Interrupts wiederherstellen

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a1)+,(a0)+
	ENDR

	; Hardware-Interrupts und DMAs wiederherstellen

	move.w olddmacon,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

	; Copperlist wiederherstellen

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

	; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

	; Speicher freigeben

	movea.l $4,a6
	lea images,a0
	moveq #NBFRAMES-1,d1
_freeImages:
	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l (a0)+,a1
	movem.l a0/d1,-(sp)
	jsr -210(a6)
	movem.l (sp)+,a0/d1
	dbf d1,_freeImages

	movea.l copperList,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"

;---------- Interrrupt-Handler ----------

_rte:
	rte

;---------- Warten auf vertikal blank (funktioniert nur, wenn der VERTB-Interrupt aktiviert ist!) ----------

_waitVERTB:
	movem.w d0,-(sp)
_waitVERTBLoop:
	move.w INTREQR(a5),d0
	btst #5,d0
	beq _waitVERTBLoop
	movem.w (sp)+,d0
	rts

;---------- Warten auf das einzeilige Raster ----------

; Eingang(s) :
;	D0 =  Zeile, in der das Raster erwartet wird
; Ausgang(s) :
;	(keine)
; Bemerkung :
;	Vorsicht, wenn die Schleife, aus der der Aufruf stammt, weniger als eine Zeile
;   zur Ausführung benötigt, denn dann sind zwei Aufrufe erforderlich :
;
;	move.w #Y+1,d0
;	bsr _waitRaster
;	move.w #Y,d0
;	bsr _waitRaster

_waitRaster:
	movem.l d1,-(sp)
_waitRasterLoop:
	move.l VPOSR(a5),d1
	lsr.l #8,d1
	and.w #$01FF,d1
	cmp.w d0,d1
	bne _waitRasterLoop
	movem.l (sp)+,d1
	rts

;********** Daten **********

graphicsLibrary:	DC.B "graphics.library",0
					EVEN
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
vectors:			BLK.L 6
copperList:			DC.L 0
bobX:				DC.W 0
bobY:				DC.W 0
angle:				DC.W 0
radius:				DC.W 0
radiusSpeed:		DC.W 0
bobMask:
					BLK.W BOB_DEPTH*BOB_DY*((BOB_DX+16)>>4),0		; leerer Speicherbereich für die Bob Maske
bob:
					INCBIN "ballBlue16x16x2.rawb"
images:				BLK.L NBFRAMES,0								; hier stehen die 7 Zeiger auf die 7 Bildschirme mit je 2 Bitebenen

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
cosinus:
	dc.w $4000, $3FFE, $3FF6, $3FEA, $3FD8, $3FC2, $3FA6, $3F86
	dc.w $3F61, $3F36, $3F07, $3ED3, $3E9A, $3E5C, $3E19, $3DD2
	dc.w $3D85, $3D34, $3CDE, $3C83, $3C24, $3BC0, $3B57, $3AEA
	dc.w $3A78, $3A01, $3986, $3906, $3882, $37FA, $376D, $36DC
	dc.w $3646, $35AD, $350F, $346D, $33C7, $331D, $326F, $31BD
	dc.w $3107, $304D, $2F90, $2ECE, $2E0A, $2D41, $2C75, $2BA6
	dc.w $2AD3, $29FD, $2923, $2847, $2767, $2684, $259E, $24B5
	dc.w $23CA, $22DB, $21EA, $20F6, $2000, $1F07, $1E0C, $1D0E
	dc.w $1C0E, $1B0C, $1A08, $1902, $17FA, $16F0, $15E4, $14D6
	dc.w $13C7, $12B6, $11A4, $1090, $0F7C, $0E66, $0D4E, $0C36
	dc.w $0B1D, $0A03, $08E8, $07CD, $06B1, $0594, $0477, $0359
	dc.w $023C, $011E, $0000, $FEE2, $FDC4, $FCA7, $FB89, $FA6C
	dc.w $F94F, $F833, $F718, $F5FD, $F4E3, $F3CA, $F2B2, $F19A
	dc.w $F084, $EF70, $EE5C, $ED4A, $EC39, $EB2A, $EA1C, $E910
	dc.w $E806, $E6FE, $E5F8, $E4F4, $E3F2, $E2F2, $E1F4, $E0F9
	dc.w $E000, $DF0A, $DE16, $DD25, $DC36, $DB4B, $DA62, $D97C
	dc.w $D899, $D7B9, $D6DD, $D603, $D52D, $D45A, $D38B, $D2BF
	dc.w $D1F6, $D132, $D070, $CFB3, $CEF9, $CE43, $CD91, $CCE3
	dc.w $CC39, $CB93, $CAF1, $CA53, $C9BA, $C924, $C893, $C806
	dc.w $C77E, $C6FA, $C67A, $C5FF, $C588, $C516, $C4A9, $C440
	dc.w $C3DC, $C37D, $C322, $C2CC, $C27B, $C22E, $C1E7, $C1A4
	dc.w $C166, $C12D, $C0F9, $C0CA, $C09F, $C07A, $C05A, $C03E
	dc.w $C028, $C016, $C00A, $C002, $C000, $C002, $C00A, $C016
	dc.w $C028, $C03E, $C05A, $C07A, $C09F, $C0CA, $C0F9, $C12D
	dc.w $C166, $C1A4, $C1E7, $C22E, $C27B, $C2CC, $C322, $C37D
	dc.w $C3DC, $C440, $C4A9, $C516, $C588, $C5FF, $C67A, $C6FA
	dc.w $C77E, $C806, $C893, $C924, $C9BA, $CA53, $CAF1, $CB93
	dc.w $CC39, $CCE3, $CD91, $CE43, $CEF9, $CFB3, $D070, $D132
	dc.w $D1F6, $D2BF, $D38B, $D45A, $D52D, $D603, $D6DD, $D7B9
	dc.w $D899, $D97C, $DA62, $DB4B, $DC36, $DD25, $DE16, $DF0A
	dc.w $E000, $E0F9, $E1F4, $E2F2, $E3F2, $E4F4, $E5F8, $E6FE
	dc.w $E806, $E910, $EA1C, $EB2A, $EC39, $ED4A, $EE5C, $EF70
	dc.w $F084, $F19A, $F2B2, $F3CA, $F4E3, $F5FD, $F718, $F833
	dc.w $F94F, $FA6C, $FB89, $FCA7, $FDC4, $FEE2, $0000, $011E
	dc.w $023C, $0359, $0477, $0594, $06B1, $07CD, $08E8, $0A03
	dc.w $0B1D, $0C36, $0D4E, $0E66, $0F7C, $1090, $11A4, $12B6
	dc.w $13C7, $14D6, $15E4, $16F0, $17FA, $1902, $1A08, $1B0C
	dc.w $1C0E, $1D0E, $1E0C, $1F07, $2000, $20F6, $21EA, $22DB
	dc.w $23CA, $24B5, $259E, $2684, $2767, $2847, $2923, $29FD
	dc.w $2AD3, $2BA6, $2C75, $2D41, $2E0A, $2ECE, $2F90, $304D
	dc.w $3107, $31BD, $326F, $331D, $33C7, $346D, $350F, $35AD
	dc.w $3646, $36DC, $376D, $37FA, $3882, $3906, $3986, $3A01
	dc.w $3A78, $3AEA, $3B57, $3BC0, $3C24, $3C83, $3CDE, $3D34
	dc.w $3D85, $3DD2, $3E19, $3E5C, $3E9A, $3ED3, $3F07, $3F36
	dc.w $3F61, $3F86, $3FA6, $3FC2, $3FD8, $3FEA, $3FF6, $3FFE	endProgrammbeschreibung:Vor der Hauptschleife wird zuerst 7x Speicher angefordert für jeweils einenBildschirm der Größe 320x256 mit 2 Bitebenen. Dann wird die Copperliste generiert und die Bitplanepointer werden auf den Anfang des Speicherbereiches"images" gesetzt. Theoretisch folgen images2 bis images7 dem Label images imentsprechenden festen Abstand von 4 Byte, denn hier sind nur die 7 Zeigergespeichert. Dann wird die Bob-Maske des Raw-Blitter-Bobs mit der CPU generiert.In der Hauptschleife wird zuerst auf das Endes des angezeigten Bildes gewartetund dann werden die 7 Zeiger (die Ergebnisse des angefoderterten Speichers durchAlloc-Mem am Anfang) rotiert und zwar rücken die Nachfolger auf einen vorderenPlatz und der erste wird zum letzten.Als nächstes werden die Bitplanepointer in der Copperliste auf das aktuelleBild gesetzt. Dann wird der Winkelwert neu berechnet und bei Unterlauf wiederzurück auf den Startwert gesetzt.Als nächstes wird der Radius neu ermittelt und dabei eine Über- oder			Unterschreitung der Grenzwerte beachtet und die neue X-,Y-Position des Bobsberechnet.Der Bob wird nun mit dem Blitter an die neue Position kopiert und zwar ins Bild (image+4) das dem ersten Speicherbereich (images) folgt.Durch NBFRAMES=7 kann nun der Abstand und die Anzahl der Bobs pro Bild verändert werden. Bei NBFRAMES=2 werden im kleinsten Abstand immer neueBobs hinzugefügt.