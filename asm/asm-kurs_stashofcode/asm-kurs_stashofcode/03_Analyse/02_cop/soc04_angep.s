
; soc04.s = rgbplasma.s

; Programmiert von Yragael für Stash of Code
; (http://www.stashofcode.fr) im Jahr 2017.

; Diese Arbeit wird unter den Bedingungen der Creative Commons
; Namensnennung-Keine kommerzielle Nutzung-Weitergabe unter
; gleichen Bedingungen 4.0 UK-Lizenz zur Verfügung gestellt.

; RGB-Plasma. Mehrere Versionen werden nacheinander angezeigt, was sich aus den unterschiedlichen Kombinationen
; der Quellen A, B und C ergibt, die der Blitter zulässt.

; Basierend auf den Erklärungen im Artikel "Le RGB Plasma" von Stéphane Rubinstein in Amiga News Tech Nr. 31 (März 1992)

; Version mit Vorberechnungen und der Verwendung von Blitter zum Ändern der Farben in der Copperliste.
; Diese Optimierung ist bei A1200 überhaupt nicht wirksam, bei A500 jedoch Tag und Nacht:
; Ohne Optimierung können höchstens 60 Zeilen im Frame angezeigt werden, während dies bei Optimierung möglich
; ist Anzeige 256 (und es ist noch Zeit: Es dauert nur 273 Rasterzeilen!)

;---------- Konstanten ----------

; Register

FMODE=$1FC
VPOSR=$004
INTENA=$09A
INTENAR=$01C
INTREQ=$09C
INTREQR=$01E
DMACON=$096
DMACONR=$002
DIWSTRT=$08E
DIWSTOP=$090
BPLCON0=$100
BPLCON1=$102
BPLCON2=$104
DDFSTRT=$092
DDFSTOP=$094
BPL1MOD=$108
BPL2MOD=$10A
BPL1PTH=$0E0
BPL1PTL=$0E2
COLOR00=$180
COLOR01=$182
COP1LCH=$080
COPJMP1=$088
BLTAFWM=$044
BLTALWM=$046
BLTAPTH=$050
BLTBPTH=$04C
BLTCPTH=$048
BLTDPTH=$054
BLTAMOD=$064
BLTBMOD=$062
BLTCMOD=$060
BLTDMOD=$066
BLTADAT=$074
BLTCON0=$040
BLTCON1=$042
BLTSIZE=$058

; Programm

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_DEPTH=1
COPSIZE=13*4+DISPLAY_DY*(4+((DISPLAY_DX>>3)+1)*4)+4
	; 13*4					Konfiguration der Anzeige
	; 256*(4+41*4)			256 Zeilen * (1 Wait + 41 Moves) 
	; 4						$FFFFFFFE
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
;DIWSTOP_val = ((DISPLAY_Y+DISPLAY_DY-256)<<8)+(DISPLAY_X+DISPLAY_DX-256)
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
;DDFSTOP_val = ((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC				; Dies entspricht ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC,; wenn DISPLAY_DX ein Vielfaches von 16 ist.
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder $00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = 0
BPLCON2_val = $0008																; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
BPL1MOD_val = 0
;----------------------------------------------------------

; Parameter Plasma

BORDER_COLOR=$0000
OFFSET_AMPLITUDE=10
OFFSET_ROW_SPEED=2

RED_START  =359<<1		; Wert zwischen 0 und 718	(Winkelwert * 2)
GREEN_START=90<<1
BLUE_START =60<<1

RED_ROW_SPEED  =1
GREEN_ROW_SPEED=3
BLUE_ROW_SPEED =12

RED_FRAME_SPEED  =3
GREEN_FRAME_SPEED=3
BLUE_FRAME_SPEED =6

RED_AMPLITUDE   =18		; OFFSET_AMPLITUDE+RED_AMPLITUDE muss <= 29 sein 
GREEN_AMPLITUDE =15		; OFFSET_AMPLITUDE+GREEN_AMPLITUDE muss <= 29 sein 
BLUE_AMPLITUDE  =19		; OFFSET_AMPLITUDE+BLUE_AMPLITUDE muss <= 29 sein 

MINTERMS_SPEED=100		; In Frames ausgedrückt (1/50 Sekunden)

;---------- Makros ----------

WAITBLIT:	MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM

;---------- Initialisierung ----------

; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $dff000,a5

; Speicher in CHIP zuordnen, der für die copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList0

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList1

; Speicher in CHIP zuordnen, der für die bitplane auf 0 gesetzt ist

	move.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplane

; Speicher für Zeilenversätze zuordnen
	
	move.l #DISPLAY_DY<<1,d0		; 256*2 = 512
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,rowOffsets			; Adresse speichern

; Speicher für Komponentenversätze zuordnen

	move.l #3*(360<<1),d0			; 3*(360*2)=2160
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,rgbOffsets

; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

; Hardware-Interrupts und DMAs ausschalten

	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

;---------- Copperlist ----------

	movea.l copperList0,a0

	move.w #DIWSTRT,(a0)+				; Bildschirmkonfiguration
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
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

	move.l #$01FC0000,(a0)+				; Kompatibilität OCS mit AGA	

	move.l bitplane,d0					; Adressen der Bitebenen
	move.w #BPL1PTL,(a0)+			
	move.w d0,(a0)+
	move.w #BPL1PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.w #COLOR00,(a0)+				; $0180		; Palette
	move.w #BORDER_COLOR,(a0)+			; $0000

; Plasma (WAIT und Wert von COLOR01 nicht angegeben)

	move.w #DISPLAY_DY-1,d0				; 256-1 Schleifenzähler
_copperListRows:
	move.l #$00000000,(a0)+				; Platzhalter für das Wait
	move.w #DISPLAY_DX>>3,d1			; 41 MOV pro Zeile nicht 40 ...
_copperListCols:
	move.w #COLOR01,(a0)+				; $0182
	move.w #$0000,(a0)+					; $0000
	dbf d1,_copperListCols				; Reihe von Moves
	dbf d0,_copperListRows				; über 256 Zeilen

	move.l #$FFFFFFFE,(a0)				; Ende

; Double buffering per Copperlist

	movea.l copperList0,a0				; Anfangsadresse copperList0
	movea.l copperList1,a1				; Anfangsadresse copperList1
	move.w #(COPSIZE>>2)-1,d0			; Anzahl Bytes in Anzahl Longwörter 	
_copperListCopy:						; Kopie der Copperlist
	move.l (a0)+,(a1)+					; Longwörter kopieren	
	dbf d0,_copperListCopy		

; DMA aktivieren

	move.w #$83C0,DMACON(a5)		; DMAEN=1, COPEN=1, BPLEN=1, COPEN=1, BLTEN=1

; Copperlist starten

	move.l copperList0,COP1LCH(a5)
	clr.w COPJMP1(a5)

;---------- Vorberechnungen ----------

; Plasmaoberfläche (einfaches Rechteck der Farbe 1)

	WAITBLIT
	move.w #$FFFF,BLTADAT(a5)		; das Muster mit dem die Bitplane gefüllt wird
	move.w #0,BLTDMOD(a5)			; BLTDMOD = 0
	move.w #$01F0,BLTCON0(a5)		; Verwenden Sie aber nicht Quelle A, 
	move.w #$0000,BLTCON1(a5)		; um BLTADAT zu versorgen D = Abc | AbC | ABc | ABC = A	
	move.l bitplane,BLTDPTH(a5)		; Ziel - Kanal D
	move.w #(DISPLAY_DX>>4)!(DISPLAY_DY<<6),BLTSIZE(a5)		; 320/2^4=20 Wörter Breite und 256 Zeilen
	
; Zeilenversätze
	
	movea.l rowOffsets,a0			; Anfangsadresse rowOffsets
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
	
; Komponentenversätze
	
	movea.l rgbOffsets,a0			; Anfangsadresse rgbOffsets
	lea sinus,a1					; Anfangsadresse Sinus
	move.w #360-1,d0				; 360 Schleifenzähler
_redOffsetsLoop:
	move.w (a1)+,d1					; aktueller Sinuswert nach d1
	muls #RED_AMPLITUDE,d1			; Amplitude von rot
	swap d1							; Registerwerte tauschen 
	rol.l #2,d1						; Registerinhalt um 2 Bit rotieren
	addi.w #RED_AMPLITUDE,d1		; roten Amplitudenwert addieren
	bclr #0,d1						; Kommt dazu, Dn durch 2 für das Verhältnis zu [0, AMPLITUDE] 
	move.w d1,(a0)+					; zu teilen und es dann mit 2 zu multiplizieren, damit ein WORT adressiert werden kann
	dbf d0,_redOffsetsLoop			; über alle Winkelwerte wiederholen

	lea sinus,a1					; Anfangsadresse Sinus
	move.w #360-1,d0				; 360 Schleifenzähler
_greenOffsetsLoop:
	move.w (a1)+,d1					; aktueller Sinuswert nach d1
	muls #GREEN_AMPLITUDE,d1		; Amplitude von grün
	swap d1							; Registerwerte tauschen 
	rol.l #2,d1						; Registerinhalt um 2 Bit rotieren
	addi.w #GREEN_AMPLITUDE,d1		; grünen Amplitudenwert addieren
	bclr #0,d1						; Kommt dazu, Dn durch 2 für das Verhältnis zu [0, AMPLITUDE]
	move.w d1,(a0)+					; zu teilen und es dann mit 2 zu multiplizieren, damit ein WORT adressiert werden kann
	dbf d0,_greenOffsetsLoop		; über alle Winkelwerte wiederholen

	lea sinus,a1					; Anfangsadresse Sinus
	move.w #360-1,d0				; 360 Schleifenzähler
_blueOffsetsLoop:
	move.w (a1)+,d1					; aktueller Sinuswert nach d1
	muls #BLUE_AMPLITUDE,d1			; Amplitude von blau
	swap d1							; Registerwerte tauschen 
	rol.l #2,d1						; Registerinhalt um 2 Bit rotieren
	addi.w #BLUE_AMPLITUDE,d1		; blauen Amplitudenwert addieren
	bclr #0,d1						; Kommt dazu, Dn durch 2 für das Verhältnis zu [0, AMPLITUDE]
	move.w d1,(a0)+					; zu teilen und es dann mit 2 zu multiplizieren, damit ein WORT adressiert werden kann
	dbf d0,_blueOffsetsLoop			; über alle Winkelwerte wiederholen

; Blitterkonfiguration

	WAITBLIT
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTAMOD(a5)
	move.w #0,BLTBMOD(a5)
	move.w #0,BLTCMOD(a5)
	move.w #2,BLTDMOD(a5)		; um $0182 in der Copperliste zu überspringen, es werden 1 Word Breite und 41 Zeilen kopiert
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$FFFF,BLTALWM(a5)

; Timer und Offset, um die Werte von BLTCON0 zu durchlaufen und die 256 Kombinationen von Intervallen zu testen

	move.w #(256-1)<<1,d7				; Offset in bltcon0		255*2=510 ($1fe)
	swap d7								; $0000.01FE --> 01FE.0000
	move.w #1,d7						; Timer		 --> 01FE.0001

;---------- Hauptprogramm ----------

; Hauptschleife

_loop:

; auf das Ende des Frames warten 

_waitEndOfFrame:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0		; $2c+256 am Ende des Bildes
	blt _waitEndOfFrame

; Veränderung Copperlist

	move.l copperList0,COP1LCH(a5)		; Copperpointer laden
	clr.w COPJMP1(a5)					; Copper Start
	move.l copperList1,a0				; Copperlisten Startadressen tauschen
	move.l copperList0,copperList1		; 
	move.l a0,copperList0				; 

; Konfigurieren der Intervalle (alle außer abc für D = A | B | C)

	WAITBLIT
	subq.w #1,d7						; 01FE.0001 - 1 = 
	bge _mintermsNoChange				; wenn d7>=0 werden die folgenden Anweisungen übersprungen
	move.w #MINTERMS_SPEED,d7			; 01FE.0064, d7=$64 (100)
	swap d7								; $0064.01FE 
	lea bltcon_0,a1						; Anfangsadresse des Feldes der verschiedenen BLTCON0-Werte
	move.w (a1,d7.w),BLTCON0(a5)		; BLTCON0 Wert laden: 0FFF
	;move.w #$09F0,BLTCON0(a5)
	subq.w #2,d7						; 
	bne _mintermsNoUnderflow			; 
	move.w #(256-1)<<1,d7				; 255*2=510
_mintermsNoUnderflow:
	swap d7								;  
_mintermsNoChange:

; Generieren der Copperlist

	lea 13*4(a0),a0						; Zeiger in der Copperlist
	movea.l rowOffsets,a6				; Adresse nach a6 von einem Speicherbereich
	move.w redSinus,d3					; rote Komponenete nach d3
	move.w greenSinus,d4				; grüne Komponenete nach d4
	move.w blueSinus,d5					; blaue Komponenete nach d5
	move.w #((DISPLAY_Y&$00FF)<<8)!((((DISPLAY_X-4)>>2)<<1)&$00FE)!$0001,d0			; dc.w $2c3F
	move.w #DISPLAY_DY-1,d1				; 256-1 Schleifenzähler
_rows:

; WAIT (Wechseln Sie die horizontale Position zwischen DISPLAY_X-4 und DISPLAY_X
; von einer Zeile zur anderen, um den Effekt von Blöcken zu verringern, die durch
; die Länge der MOVs (8 Pixel) erzeugt werden.)

	btst #0,d1							; Bit 0 
	beq _lineEven						; wenn 0, dann ist es gerade
	bset #1,d0							; Bit 1 setzen  --> dc.w $2c3F
	bra _lineOdd
_lineEven:
	bclr #1,d0							; Bit 1 löschen --> dc.w $2c3D
_lineOdd:
	move.w d0,(a0)+						; dc.w $2c3F 
	move.w #$FFFE,(a0)+					; dc.w $xxxx,$FFFE

; Sinusförmige Startversätze in Farbkomponenten
	
	movea.l rgbOffsets,a1				; Anfangsadresse der Komponenetenversätze nach a1
	move.w (a1,d3.w),d6					; Offset aktueller Sinuswert rot addieren und Wert nach d6
	add.w (a6),d6						; Wert von rowOffsets zu Offset Farbkomponentenwert addieren
	;move.w #58,d6						; zu Testzwecken
	lea red,a2							; Anfangsadresse Feld rot
	lea (a2,d6.w),a2					; Ergebnis Adresse in a2 (des ermittelten Wertes)

	lea 360<<1(a1),a1					; 360*2 als Offset rgbOffsets
	move.w (a1,d4.w),d6
	add.w (a6),d6
	lea green,a3						; Anfangsadresse Feld grün
	lea (a3,d6.w),a3					; Ergebnis Adresse in a3 (des ermittelten Wertes)

	lea 360<<1(a1),a1					; 360*2 als Offset rgbOffsets
	move.w (a1,d5.w),d6
	add.w (a6)+,d6						; Gehen Sie gleichzeitig zur nächsten Zeile
	lea blue,a4							; Anfangsadresse Feld blau
	lea (a4,d6.w),a4					; Ergebnis Adresse in a4 (des ermittelten Wertes)

; Reihe von MOVEs
	
	WAITBLIT
	move.l a2,BLTAPTH(a5)				; rote Komponente
	move.l a3,BLTBPTH(a5)				; grüne Komponente
	move.l a4,BLTCPTH(a5)				; blaue Komponente
	lea 2(a0),a0						; zum nächsten Byte 
	move.l a0,BLTDPTH(a5)				; Ziel Kanal D
	move.w #1!(((DISPLAY_DX>>3)+1)<<6),BLTSIZE(a5)		; Breite 1 Word und (320/8)+1=41 Zeilen

; Gehen Sie zur nächsten Zeile

	addi.w #$0100,d0
	lea 4*((DISPLAY_DX>>3)+1)-2(a0),a0	; 4*((320/8)+1)-2=162
	
; Erhöhen der Sinuslinien

	subi.w #RED_ROW_SPEED<<1,d3			; rote Geschwindigkeit * 2 subtrahieren
	bge _noRedRowSinusUnderflow			; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d3					; ansonsten auf Startwert setzen (720)
_noRedRowSinusUnderflow:
	subi.w #GREEN_ROW_SPEED<<1,d4		; grüne Geschwindigkeit * 2 subtrahieren
	bge _noGreenRowSinusUnderflow		; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d4					; ansonsten auf Startwert setzen (720)
_noGreenRowSinusUnderflow:
	subi.w #BLUE_ROW_SPEED<<1,d5		; blaue Geschwindigkeit * 2 subtrahieren
	bge _noBlueRowSinusUnderflow		; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d5					; ansonsten auf Startwert setzen (720)
_noBlueRowSinusUnderflow:

	dbf d1,_rows						; über alle 256 Zeilen

; Animieren des Sinus der Komponenten
	;bra bbb
	move.w redSinus,d3					; aktuellen Wert holen
	subi.w #RED_FRAME_SPEED<<1,d3		; rote Frame Geschwindigkeit * 2 subtrahieren 
	bge _noRedSinusUnderflow			; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d3					; ansonsten auf Startwert setzen (720)
_noRedSinusUnderflow:
	move.w d3,redSinus					; aktuellen Wert zurückspeichern

	move.w greenSinus,d4				; aktuellen Wert holen
	subi.w #GREEN_FRAME_SPEED<<1,d4		; grüne Frame Geschwindigkeit * 2 subtrahieren 
	bge _noGreenSinusUnderflow			; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d4					; ansonsten auf Startwert setzen (720)
_noGreenSinusUnderflow:					; 
	move.w d4,greenSinus				; aktuellen Wert zurückspeichern

	move.w blueSinus,d5					; aktuellen Wert holen
	subi.w #BLUE_FRAME_SPEED<<1,d5		; blaue Frame Geschwindigkeit * 2 subtrahieren 
	bge _noBlueSinusUnderflow			; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d5					; ansonsten auf Startwert setzen (720)
_noBlueSinusUnderflow:				
	move.w d5,blueSinus					; aktuellen Wert zurückspeichern
	
; Testen Sie den Druck der linken Maustaste

	btst #6,$bfe001
	bne _loop
	WAITBLIT

;---------- Ende ----------

; Hardware-Interrupts und DMA ausschalten

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

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

	lea graphicslibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

; Speicher wieder freigeben

	movea.l copperList0,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l copperList1,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplane,a1
	move.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l rowOffsets,a1
	move.l #DISPLAY_DY<<1,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l rgbOffsets,a1
	move.l #3*(360<<1),d0
	movea.l $4,a6
	jsr -210(a6)

; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;----------Daten ----------

	SECTION yragael,DATA_C
bitplane:			DC.L 0
rgbOffsets:			DC.L 0		; Adresse des zugewiesenen Speicherbereichs über 3*(360*2)=2160 Bytes im Chip-RAM für die Komponentenversätze
rowOffsets:			DC.L 0		; Adresse des zugewiesenen Speicherbereichs über 256*2 = 512 Bytes im Chip-RAM für die Zeilenversätze
graphicslibrary:	DC.B "graphics.library",0
	even
copperList0:		DC.L 0
copperList1:		DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
redSinus:			DC.W RED_START
greenSinus:			DC.W GREEN_START
blueSinus:			DC.W BLUE_START

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

bltcon_0:
	dc.w $0F00, $0F01, $0F02, $0F03, $0F04, $0F05, $0F06, $0F07
	dc.w $0F08, $0F09, $0F0A, $0F0B, $0F0C, $0F0D, $0F0E, $0F0F
	dc.w $0F10, $0F11, $0F12, $0F13, $0F14, $0F15, $0F16, $0F17
	dc.w $0F18, $0F19, $0F1A, $0F1B, $0F1C, $0F1D, $0F1E, $0F1F
	dc.w $0F20, $0F21, $0F22, $0F23, $0F24, $0F25, $0F26, $0F27
	dc.w $0F28, $0F29, $0F2A, $0F2B, $0F2C, $0F2D, $0F2E, $0F2F
	dc.w $0F30, $0F31, $0F32, $0F33, $0F34, $0F35, $0F36, $0F37
	dc.w $0F38, $0F39, $0F3A, $0F3B, $0F3C, $0F3D, $0F3E, $0F3F
	dc.w $0F40, $0F41, $0F42, $0F43, $0F44, $0F45, $0F46, $0F47
	dc.w $0F48, $0F49, $0F4A, $0F4B, $0F4C, $0F4D, $0F4E, $0F4F
	dc.w $0F50, $0F51, $0F52, $0F53, $0F54, $0F55, $0F56, $0F57
	dc.w $0F58, $0F59, $0F5A, $0F5B, $0F5C, $0F5D, $0F5E, $0F5F
	dc.w $0F60, $0F61, $0F62, $0F63, $0F64, $0F65, $0F66, $0F67
	dc.w $0F68, $0F69, $0F6A, $0F6B, $0F6C, $0F6D, $0F6E, $0F6F
	dc.w $0F70, $0F71, $0F72, $0F73, $0F74, $0F75, $0F76, $0F77
	dc.w $0F78, $0F79, $0F7A, $0F7B, $0F7C, $0F7D, $0F7E, $0F7F
	dc.w $0F80, $0F81, $0F82, $0F83, $0F84, $0F85, $0F86, $0F87
	dc.w $0F88, $0F89, $0F8A, $0F8B, $0F8C, $0F8D, $0F8E, $0F8F
	dc.w $0F90, $0F91, $0F92, $0F93, $0F94, $0F95, $0F96, $0F97
	dc.w $0F98, $0F99, $0F9A, $0F9B, $0F9C, $0F9D, $0F9E, $0F9F
	dc.w $0FA0, $0FA1, $0FA2, $0FA3, $0FA4, $0FA5, $0FA6, $0FA7
	dc.w $0FA8, $0FA9, $0FAA, $0FAB, $0FAC, $0FAD, $0FAE, $0FAF
	dc.w $0FB0, $0FB1, $0FB2, $0FB3, $0FB4, $0FB5, $0FB6, $0FB7
	dc.w $0FB8, $0FB9, $0FBA, $0FBB, $0FBC, $0FBD, $0FBE, $0FBF
	dc.w $0FC0, $0FC1, $0FC2, $0FC3, $0FC4, $0FC5, $0FC6, $0FC7
	dc.w $0FC8, $0FC9, $0FCA, $0FCB, $0FCC, $0FCD, $0FCE, $0FCF
	dc.w $0FD0, $0FD1, $0FD2, $0FD3, $0FD4, $0FD5, $0FD6, $0FD7
	dc.w $0FD8, $0FD9, $0FDA, $0FDB, $0FDC, $0FDD, $0FDE, $0FDF
	dc.w $0FE0, $0FE1, $0FE2, $0FE3, $0FE4, $0FE5, $0FE6, $0FE7
	dc.w $0FE8, $0FE9, $0FEA, $0FEB, $0FEC, $0FED, $0FEE, $0FEF
	dc.w $0FF0, $0FF1, $0FF2, $0FF3, $0FF4, $0FF5, $0FF6, $0FF7
	dc.w $0FF8, $0FF9, $0FFA, $0FFB, $0FFC, $0FFD, $0FFE, $0FFF


; Komponenten (sinus)

red:
	dc.w $0800, $0900, $0B00, $0C00, $0D00, $0E00, $0F00, $0F00	; 0
	dc.w $0F00, $0F00, $0E00, $0D00, $0C00, $0B00, $0900, $0800	; 16 Adressen
	dc.w $0600, $0400, $0300, $0200, $0100, $0000, $0000, $0000	; 32
	dc.w $0000, $0100, $0200, $0300, $0400, $0600, $0800, $0900 ; 48   58 ist der letzte Offset ist korrekt!
	dc.w $0B00, $0C00, $0D00, $0E00, $0F00, $0F00, $0F00, $0F00 ; 64
	dc.w $0E00, $0D00, $0C00, $0B00, $0900, $0800, $0600, $0400	; 80
	dc.w $0300, $0200, $0100, $0000, $0000, $0000, $0000, $0100	 
	dc.w $0200, $0300, $0400, $0600, $0800, $0900, $0B00, $0C00			; 8x8=64 Farbwerte
	dc.w $0D00, $0E00, $0F00, $0F00, $0F00;, $0F00						; +6= 70 Farbwerte

green:
	dc.w $0080, $0090, $00B0, $00C0, $00D0, $00E0, $00F0, $00F0
	dc.w $00F0, $00F0, $00E0, $00D0, $00C0, $00B0, $0090, $0080
	dc.w $0060, $0040, $0030, $0020, $0010, $0000, $0000, $0000
	dc.w $0000, $0010, $0020, $0030, $0040, $0060, $0080, $0090
	dc.w $00B0, $00C0, $00D0, $00E0, $00F0, $00F0, $00F0, $00F0
	dc.w $00E0, $00D0, $00C0, $00B0, $0090, $0080, $0060, $0040
	dc.w $0030, $0020, $0010, $0000, $0000, $0000, $0000, $0010
	dc.w $0020, $0030, $0040, $0060, $0080, $0090, $00B0, $00C0
	dc.w $00D0, $00E0, $00F0, $00F0, $00F0;, $00F0

blue:	
	dc.w $0008, $0009, $000B, $000C, $000D, $000E, $000F, $000F
	dc.w $000F, $000F, $000E, $000D, $000C, $000B, $0009, $0008
	dc.w $0006, $0004, $0003, $0002, $0001, $0000, $0000, $0000
	dc.w $0000, $0001, $0002, $0003, $0004, $0006, $0008, $0009
	dc.w $000B, $000C, $000D, $000E, $000F, $000F, $000F, $000F
	dc.w $000E, $000D, $000C, $000B, $0009, $0008, $0006, $0004
	dc.w $0003, $0002, $0001, $0000, $0000, $0000, $0000, $0001
	dc.w $0002, $0003, $0004, $0006, $0008, $0009, $000B, $000C
	dc.w $000D, $000E, $000F, $000F, $000F;, $000F

; Komponenten (Sägezahn)

red2:
	dc.w $0F00, $0E00, $0D00, $0C00, $0B00, $0A00, $0900, $0800
	dc.w $0700, $0600, $0500, $0400, $0300, $0200, $0100, $0000
	dc.w $0100, $0200, $0300, $0400, $0500, $0600, $0700, $0800
	dc.w $0900, $0A00, $0B00, $0C00, $0D00, $0E00, $0F00, $0E00
	dc.w $0D00, $0C00, $0B00, $0A00, $0900, $0800, $0700, $0600
	dc.w $0500, $0400, $0300, $0200, $0100, $0000, $0100, $0200
	dc.w $0300, $0400, $0500, $0600, $0700, $0800, $0900, $0A00
	dc.w $0B00, $0C00, $0D00, $0E00, $0F00, $0E00, $0D00, $0C00
	dc.w $0B00, $0A00, $0900, $0800, $0700, $0600
green2:
	dc.w $00F0, $00E0, $00D0, $00C0, $00B0, $00A0, $0090, $0080
	dc.w $0070, $0060, $0050, $0040, $0030, $0020, $0010, $0000
	dc.w $0010, $0020, $0030, $0040, $0050, $0060, $0070, $0080
	dc.w $0090, $00A0, $00B0, $00C0, $00D0, $00E0, $00F0, $00E0
	dc.w $00D0, $00C0, $00B0, $00A0, $0090, $0080, $0070, $0060
	dc.w $0050, $0040, $0030, $0020, $0010, $0000, $0010, $0020
	dc.w $0030, $0040, $0050, $0060, $0070, $0080, $0090, $00A0
	dc.w $00B0, $00C0, $00D0, $00E0, $00F0, $00E0, $00D0, $00C0
	dc.w $00B0, $00A0, $0090, $0080, $0070, $0060
blue2:
	dc.w $000F, $000E, $000D, $000C, $000B, $000A, $0009, $0008
	dc.w $0007, $0006, $0005, $0004, $0003, $0002, $0001, $0000
	dc.w $0001, $0002, $0003, $0004, $0005, $0006, $0007, $0008
	dc.w $0009, $000A, $000B, $000C, $000D, $000E, $000F, $000E
	dc.w $000D, $000C, $000B, $000A, $0009, $0008, $0007, $0006
	dc.w $0005, $0004, $0003, $0002, $0001, $0000, $0001, $0002
	dc.w $0003, $0004, $0005, $0006, $0007, $0008, $0009, $000A
	dc.w $000B, $000C, $000D, $000E, $000F, $000E, $000D, $000C
	dc.w $000B, $000A, $0009, $0008, $0007, $0006


; Komponenten (7.5+7.5*sin*cos, wo der sin-Winkel bei 50 beginnt und um 12 fortschreitet und der cos-Winkel bei
;			   0 beginnt und um 20 fortschreitet): Überhaupt nicht überzeugend!

red3:
	dc.w $0D00, $0E00, $0D00, $0B00, $0900, $0600, $0400, $0300
	dc.w $0400, $0500, $0600, $0800, $0800, $0800, $0700, $0500
	dc.w $0200, $0100, $0000, $0100, $0200, $0400, $0700, $0800
	dc.w $0900, $0800, $0700, $0600, $0400, $0400, $0500, $0600
	dc.w $0900, $0B00, $0D00, $0E00, $0E00, $0D00, $0B00, $0900
	dc.w $0800, $0800, $0800, $0A00, $0C00, $0D00, $0E00, $0D00
	dc.w $0B00, $0900, $0600, $0400, $0300, $0400, $0500, $0600
	dc.w $0800, $0800, $0800, $0700, $0500, $0200, $0100, $0000
	dc.w $0100, $0200, $0400, $0700, $0800, $0900

green3:
	dc.w $00D0, $00E0, $00D0, $00B0, $0090, $0060, $0040, $0030
	dc.w $0040, $0050, $0060, $0080, $0080, $0080, $0070, $0050
	dc.w $0020, $0010, $0000, $0010, $0020, $0040, $0070, $0080
	dc.w $0090, $0080, $0070, $0060, $0040, $0040, $0050, $0060
	dc.w $0090, $00B0, $00D0, $00E0, $00E0, $00D0, $00B0, $0090
	dc.w $0080, $0080, $0080, $00A0, $00C0, $00D0, $00E0, $00D0
	dc.w $00B0, $0090, $0060, $0040, $0030, $0040, $0050, $0060
	dc.w $0080, $0080, $0080, $0070, $0050, $0020, $0010, $0000
	dc.w $0010, $0020, $0040, $0070, $0080, $0090

blue3:
	dc.w $000D, $000E, $000D, $000B, $0009, $0006, $0004, $0003
	dc.w $0004, $0005, $0006, $0008, $0008, $0008, $0007, $0005
	dc.w $0002, $0001, $0000, $0001, $0002, $0004, $0007, $0008
	dc.w $0009, $0008, $0007, $0006, $0004, $0004, $0005, $0006
	dc.w $0009, $000B, $000D, $000E, $000E, $000D, $000B, $0009
	dc.w $0008, $0008, $0008, $000A, $000C, $000D, $000E, $000D
	dc.w $000B, $0009, $0006, $0004, $0003, $0004, $0005, $0006
	dc.w $0008, $0008, $0008, $0007, $0005, $0002, $0001, $0000
	dc.w $0001, $0002, $0004, $0007, $0008, $0009

	end

Programmbeschreibung

Kern des Plasma-Programms ist es eine Coppereigenschaft auszunutzen und zwar 
die, dass jeder Copper Move eine gewwisse Zeit (8 Pixel Lowres) braucht um
ausgeführt zu werden. Somit braucht es in einem Lowres Bildschirm mit einer
Breite von 320 Pixeln genau 40 Copper Moves. Um eine Verpixelung zu verringern,
wird zusätzlich die horizontale Warteposition jeder Zeile im Wechsel der
geraden und ungeraden Zeilen um je 4 Pixel versetzt durchgeführt. Zusätzlich
wird ein 41. Copper Move pro Zeile hinzugefügt.

Das Plasma wird in einer Bitplane der Größe 320x256 erstellt, in dem durch die
Copperliste die Vordergrundfarbe (Farbregister $182) durch diese 41 Copper
Moves in jeder Zeile für 256 Zeilen verschiedene Farbwerte eingetragen werden.

Dabei gibt es zwei identische Copperlisten (Double Puffering) die zu Beginn
jeden Frames getauscht werden. Somit wird in jedem Frame eine Copperliste
angezeigt und in die andere die neuen Farbwerte kopiert. Die Farbwerte 
werden dabei durch den Blitter in die Copperliste kopiert und zwar mit den
einzelnen Farbkomponeneten als Wörter $0RGB (rot, grün, blau). Die
Farbkomponenten werden gemäß der Minterm Einstellung von BLTCON0 verknüpft und
in das Ziel kopiert. Dabei ist die Besonderheit, dass ein 1-Word und 41 Zeilen
großer Blitt durchgeführt wird und das BLTDMOD auf 2 eingestellt ist. Warum? Um 
die $0182 in der Copperliste jeweils zu überspringen und nur die Farbwerte zu
überschreiben.

Die Farbkomponenten werden dabei durch drei Tabellen mit jeweils 70 Farbwerten
vorgehalten. In diesen Tabellen ist ein gewisser Farbverlauf voreingestellt.
Wobei der Adresszeiger immer gerade eingestellt sein muss um auf den Anfang 
der einzelnen Farbkomponente zu zeigen. (140 Bytes)

Also, nach dem Start des Programms wird eine Copperliste generiert und diese
wird dann kopiert, während in der Hauptschleife auf verschiedene Farbkomponenten
zugegriffen wird.
Die Hauptschleife beginnt auf die letzte Zeile zu warten und tauscht dann die
Copperlisten aus. Als nächstes gibt es einen Framecounter. Ist die 
voreingestellte Zeit abgelaufen, wird der Minterm von BLTCON0 von $FF nach $00
in Schritten von -1 jeweils geändert. Somit werden die Farbkomponenten jeweils
anders in Abhängigkeit der Logikfunktion miteinander verknüpft.

Ohne Dynamik, d.h. bei Zugriff ohne Offset auf die Farbwerte erhält man für alle
256 Zeilen den selben Farbverlauf. Im Gesamtbild eine Art vertikale Rasterbar.

	movea.l rgbOffsets,a1				; Anfangsadresse der Komponenetenversätze nach a1
	move.w (a1,d3.w),d6					; Offset aktueller Sinuswert rot addieren und Wert nach d6
	add.w (a6),d6						; Wert von rowOffsets zu Offset Farbkomponentenwert addieren
	lea red,a2							; Anfangsadresse Feld rot
	;lea (a2,d6.w),a2					; Ergebnis Adresse in a2 (des ermittelten Wertes)

	dito. für 
	lea green,a3						; Anfangsadresse Feld grün
	lea blue,a4							; Anfangsadresse Feld blau

Durch einen Offset kann nun ein Farbverlauf generiert werden.
	
	movea.l rgbOffsets,a1				; Anfangsadresse der Komponenetenversätze nach a1
	move.w (a1,d3.w),d6					; Offset aktueller Sinuswert rot addieren und Wert nach d6
	;add.w (a6),d6						; Wert von rowOffsets zu Offset Farbkomponentenwert addieren
	lea red,a2							; Anfangsadresse Feld rot
	lea (a2,d6.w),a2					; Ergebnis Adresse in a2 (des ermittelten Wertes)

Der Farbverlauf ist weitgehend vertikal, verläuft also durch den Sinuswert von
unten nach oben. Zusätzlich kann auch pro Zeile ein Versatz hinzugefügt werden um 
einen horizontalen und somit insgesamt einen gemischten Verlauf hinzuzufügen.

	movea.l rgbOffsets,a1				; Anfangsadresse der Komponenetenversätze nach a1
	move.w (a1,d3.w),d6					; Offset aktueller Sinuswert rot addieren und Wert nach d6
	add.w (a6),d6						; Wert von rowOffsets zu Offset Farbkomponentenwert addieren
	lea red,a2							; Anfangsadresse Feld rot
	lea (a2,d6.w),a2					; Ergebnis Adresse in a2 (des ermittelten Wertes)

d3 - redSinus, also Winkelwert liegt zwischen 0 und 718
rgbOffsets ist ein Speicherberich von 3*(360*2)=2160 Bytes im RAM für die
Komponentenversätze. Es wird ein Wort aus diesem Bereich nach d6 kopiert.

a6 - beinhaltet die Adresse des rowOffsets.
	movea.l rowOffsets,a6				; Adresse nach a6 von einem Speicherbereich
Diese gilt immer für eine Zeile und wird mit dem letzten Farbwert erhöht.
	add.w (a6)+,d6						; Gehen Sie gleichzeitig zur nächsten Zeile

Der Speicherbereich für die Reihen-Offsets ist 256*2=512.

Es wird also ein RGB-Offset Wert geholt und zu diesem ein Reihen-Offset Wert addiert.
Der Gesamt-Offsetwert legt dann den Beginn des ersten Wertes der Farbkomponenten fest.

Der maximale RGB-Komponentenversatz ist: $24
Der maximale Zeilenversatz ist: $12
Der maximale Gesamt-Offsetwert ist:  $24+$12=$36 = 54

Da die Farbtabellen 70 Werte im Wordformat haben, sind 70-41=29 Offset-Werte möglich.
(41, weil ein Blit 41 Farbwerte pro Zeile kopiert und um nicht über den Bereich der 
Farbkomponenten zu kommen.) 29 Offset-Werte im Byteformat sind 58, wobei nur die geraden
Adressen 0,2,4,...,58 genommen werden können.  
Wenn also der maximal mögliche Offset aus Kombination von rgbOffset und rowOffset 58
ist, heißt das, das maximal mit dem 58/2=29, mit dem 30. Element aus den Farbkomponenten 
der Blit von 41 Werten gestartet wird. 58=$3A. Somit könnten theoretisch 2 Farbwerte 
entfernt werden? 												

Am Ende jeder Zeile wird der Sinuswert d3 geändert gemäß dem Parameter:
	subi.w #RED_ROW_SPEED<<1,d3		und natürlich ein Unterlauf abgefangen.

Zum Ende eines Frames, also aller 256 Zeilen wird der aktuelle Sinuswert
gemäß dem Parameter: subi.w #RED_FRAME_SPEED<<1,d3 geändert:

	move.w redSinus,d3					; aktuellen Wert holen
	subi.w #RED_FRAME_SPEED<<1,d3		; rote Frame Geschwindigkeit * 2 subtrahieren 
	bge _noRedSinusUnderflow			; wenn größer, gleich 0, dann übersrpringen
	addi.w #360<<1,d3					; ansonsten auf Startwert setzen (720)
_noRedSinusUnderflow:
	move.w d3,redSinus					; aktuellen Wert zurückspeichern

Dadurch wird ein kontinuierlicher Verlauf generiert.

Bleibt zum Schluss nur noch die Frage, nach welcher Gesetzmässigkeit die Reihen- und
RGB-Offsets gebildet werden.

																								











 