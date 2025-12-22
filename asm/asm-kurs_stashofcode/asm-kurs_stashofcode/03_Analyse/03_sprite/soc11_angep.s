
; soc11_angep.s = spriteAGA.s

; Programmiert von Yragael für Stash of Code (http://www.stashofcode.fr) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Demonstration des Sprites-Potenzials des AGA. Anzeige und Bewegung von vier
; 64 Pixel breiten LORES-Sprites auf einem LORES-Hintergrund in 8 Bitplanes,
; wobei die Sprites an den Rändern des Bildschirms angezeigt werden können.

; Hinweis :
;
;1/ Im Gegensatz zu dem, was ich in der berühmten Datei, die ich 1993 zusammen
;   mit Junkie / PMC geschrieben hatte und die überall nachgedruckt wurde
;   (AmigaNews #62, Grapevine #14, ...), bemerkt hatte, ist es nicht sinnvoll,
;   das zweite Steuerwort (CW2) im ersten Duplikat der Daten eines Sprites
;   anzugeben. Die Datenstruktur für ein 64 Pixel breites Sprite ist :
;
;	DC.W CW1, 0, 0, 0, CW2, 0, 0, 0, 0
;	DC.W ... 
;	DC.W 0, 0, 0, 0, 0, 0, 0, 0
;
;2/ Der Burst-Modus ist für Bitplanes (Bit 1 und 0 von FMODE) nicht aktiviert,
;   sodass deren Adresse nicht auf 64 Bit ausgerichtet werden muss.
;
;3/ AGA-Möglichkeiten, die hier nicht genutzt werden :
;
;	- ein Sprite auf ein halbes oder viertel Pixel in LORES positionieren
;	- die Zeilen eines Sprites verdoppeln, ohne zusätzliche Daten anzufordern

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=8
COPPERSIZE=9*4+3*4+DISPLAY_DEPTH*2*4+2*(256/32)*(1+32)*4+8*2*4+4
	; 9*4					Konfiguration der Anzeige (OCS)
	; 3*4					Konfiguration der Anzeige (AGA)
	; DISPLAY_DEPTH*2*4		für Adressen der Bitebenen
	; 2*(256/32)*(1+32)*4	Palette mit 256 Farben in 24-Bit (8 Paletten mit 32 Farben in 24-Bit)
	; 8*2*4					für Adressen der Sprites
	; 4						$FFFFFFFE
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
;DIWSTOP_val = ((DISPLAY_Y+DISPLAY_DY-256)<<8)+(DISPLAY_X+DISPLAY_DX-256)
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder $00F8
BPLCON0_val =  ((DISPLAY_DEPTH&$0007)<<12)!((DISPLAY_DEPTH&$0008)<<1)!$0201		; (AGA) Bit 4 : 8 bitplanes, nach DISPLAY_DEPTH
																				; (AGA) Bit 0 : Erlauben Sie Bit 15 von FMODE zu arbeiten (siehe weiter unten).
BPLCON1_val = 0
BPLCON2_val = $003F			; Das Playfield steht hinter allen Sprites-Paaren
BPL1MOD_val = 0
BPL2MOD_val = 0
;----------------------------------------------------------
SPRITE_X=DISPLAY_X			; SPRITE_X-1 wird kodiert, da die Anzeige von Bitplanes durch
							; die Hardware um ein Pixel gegenüber der Anzeige von Sprites
							; verzögert wird (nicht dokumentiert).
SPRITE_Y=DISPLAY_Y
SPRITE_DX=64				; kann nicht verändert werden
SPRITE_DY=60
SPRITE_XMIN=-10
SPRITE_XMAX=DISPLAY_DX-SPRITE_DX+10	
SPRITE_YMIN=-10
SPRITE_YMAX=DISPLAY_DY-SPRITE_DY+10  

;********** Initialisierung **********

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $dff000,a5

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPPERSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanes

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

	movea.l copperlist,a0
	
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
	move.w #BPL1MOD_val,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #BPL2MOD_val,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l bitplanes,d1
	moveq #DISPLAY_DEPTH-1,d2
_bitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d1
	dbf d2,_bitplanes

	; Palette (AGA)

	lea palette,a1				; Anfangsadresse palette
	move.w #$0000,d0			; Bit 9 auf 0: MOVEs auf COLORxx betreffen die 4 höchstwertigen Bits der Komponenten R, G und B.
	moveq #(256/32)-1,d1		; 8*32=256
_HOBitsPalettes:
	move.w #BPLCON3,(a0)+		; dc.w $106
	move.w d0,(a0)+				; dc.w $106,0
	addi.w #$2000,d0			; wählt eine der 8 Farbbänke aus
	move.w #COLOR00,d2			; $0180 - erstes Farbregister
	move.w #32-1,d3				; 32 Farben
_HOBitsPalette:
	move.w d2,(a0)+				; dc.w $0180
	addq.w #2,d2				; nächstes Farbregister $0182 usw.
	move.w (a1),(a0)+			; Farbwert aus palette in Copperliste kopieren
	lea 4(a1),a1				; nächste Adresse für nächsten Farbwert
	dbf d3,_HOBitsPalette		; für alle 32 Farbregister wiederholen
	dbf d1,_HOBitsPalettes		; für alle 8 wiederholen

	lea palette+2,a1			; Anfangsadresse palette um 2 Bytes versetzt
	move.w #$0200,d0			; Bit 9 auf 1: MOVEs auf COLORxx betreffen die 4 niederwertigen Bits der Komponenten R, G und B.
	moveq #(256/32)-1,d1		; 8*32=256
_LOBitsPalettes:
	move.w #BPLCON3,(a0)+		; dc.w $106
	move.w d0,(a0)+				; dc.w $106,2000
	addi.w #$2000,d0			; wählt eine der 8 Farbbänke aus
	move.w #COLOR00,d2			; $0180 - erstes Farbregister
	move.w #32-1,d3				; 32 Farben
_LOBitsPalette:
	move.w d2,(a0)+				; dc.w $0180
	addq.w #2,d2				; nächstes Farbregister $0182 usw.
	move.w (a1),(a0)+			; Farbwert aus palette in Copperliste kopieren
	lea 4(a1),a1				; nächste Adresse für nächsten Farbwert
	dbf d3,_LOBitsPalette		; für alle 32 Farbregister wiederholen 
	dbf d1,_LOBitsPalettes		; für alle 8 wiederholen

	; Sprites (AGA)

	move.w #BPLCON4,(a0)+	; dc.w $10c
	move.w #$0011,(a0)+		; Bits 3-0 : bits 7-4 des 8-Bit-Startindexes der Palette der ungeraden Sprites
							; Bits 7-4 : bits 7-4 des 8-Bit-Startindex der Palette der geraden Sprites
							; NB : Die Palette für ungerade Sprites wird verwendet, wenn zwei Sprites angehängt werden
	move.w #BPLCON3,(a0)+	; dc.w $106
	move.w #$0042,(a0)+		; Bits 7-6 : Auflösung der Sprites (00: ECS-konform, 01: LOWRES, 10: HIRES, 11: SHRES).
							; Bit 1: Sprites an den Rändern des Bildschirms anzeigen (auch Bit 0 von BPLCON0 muss gesetzt werden)
	move.w #FMODE,(a0)+		; dc.w $1fc
	move.w #$000C,(a0)+		; Bits 3-2 : Breite der Sprites (00: 16 Pixel, 10/01: 32 Pixel, 11: 64 Pixel).
							; Bit 15 (hier nicht verwendet): Verdoppelt die Höhe von Sprites,
							; deren Bit SH10 im ersten Kontrollwort gesetzt ist.

	; Sprites

	move.w #SPR0PTH,d0		; $120
	move.l #sprites,d1		; Anfangsadresse Sprites
	moveq #8-1,d2			; Anzahl Sprites, hier 8
_sprites:
	move.w d0,(a0)+			; dc.w $120
	addq.w #2,d0			; nächste Spritepointeradresse $122 usw.
	swap d1					; hi-lo Tausch der Spriteadresse
	move.w d1,(a0)+			; hi-Anteil in Coperliste kopieren
	move.w d0,(a0)+			; dc.w $122 in Copperliste usw.
	addq.w #2,d0			; nächste Spritepointeradresse $124 usw.
	swap d1					; hi-lo Tausch der Spriteadresse
	move.w d1,(a0)+			; lo-Anteil in Coperliste kopieren
	addi.l #(SPRITE_DY+2)*16,d1		; zur nächsten Anfangsadresse der Sprites Sprite1, 2 usw.
	dbf d2,_sprites			; für alle 8 Sprites wiederholen

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83A0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, SPREN=1

;********** Hauptprogramm **********

	; Ein Schachbrettmuster zeichnen von 16 x 16 Rechtecken mit 20 x 16 Pixeln in 256 Farben
SQUARE_DX=20								; Anzahl Pixel pro Rechteckbreite
SQUARE_PATTERN=$FFFFFFFF<<(32-SQUARE_DX)	; $FFFFFFFF<<(32-20)=$FFFFF000
SQUARE_DY=16								; Anzahl Pixel pro Rechteckhöhe

	moveq #0,d0								; d0 reinigen
	movea.l bitplanes,a0					; Anfangsadresse der Bitebenen
	move.w #(DISPLAY_DY/SQUARE_DY)-1,d1		; 256/16-1= 16 Reihen Schleifenzähler
_checkerDrawRows:							; 
	movea.l a0,a1							; Kopie Anfangsadresse der Bitebenen
	move.l #SQUARE_PATTERN,pattern			; Muster speichern
	moveq #0,d6								; d6 reinigen
	move.w #(DISPLAY_DX/SQUARE_DX)-1,d2		; 320/20-1= 16 Spalten Schleifenzähler
_checkerDrawColumns:						; 
	move.b d0,d3							; d3 mit den bisher gezeichneten Spalten laden
	addq.b #1,d0							; d0 zählt die gezeichneten Spalten 
	moveq #DISPLAY_DEPTH-1,d4				; für alle 8 Bitebenen Schleifenzähler
	movea.l a1,a2							; Kopie Adresse (Adresse auf die x.te Bitebene)
_checkerDrawSquare:
	lsr.b #1,d3								; /2 alle geraden überspringen, (d3 danach frei)
	bcc _checkerSkipSquareBitplane			; wenn >= wenn d3>=0 (wenn Carry=0) dann Füllen überspringen
	movea.l a2,a3							; Kopie Adresse (Adresse in der Bitebene)
	move.l pattern,d7						; Muster in d7
	moveq #SQUARE_DY-1,d5					; 16 Zeilen pro Reihe Schleifenzähler
_checkerFillSquareBitplane:
	or.b d7,3(a3)							; die Bitebenen mit dem Muster füllen
	ror.l #8,d7								; 
	or.b d7,2(a3)							; 
	ror.l #8,d7								; 
	or.b d7,1(a3)							; 
	ror.l #8,d7								; 
	or.b d7,(a3)							; 
	ror.l #8,d7								; 
	lea DISPLAY_DX>>3(a3),a3				; 320/8=40 Bytes nächste Zeile
	dbf d5,_checkerFillSquareBitplane		; für alle 16x Zeilen pro Reihe wiederholen
_checkerSkipSquareBitplane:
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a2),a2	; 256*(320/8) = nächste Bitebene
	dbf d4,_checkerDrawSquare				; für alle 8 Bitebenen wiederholen
	addi.w #SQUARE_DX,d6					; d6=d6+20 zählt 0,20,40,60,...
	move.w d6,d3							; Kopie d6
	lsr.w #3,d3								; /8 da Adressen in Bytes
	lea (a0,d3.w),a1						; neue Anfangsadresse in der Bitebene
	move.b d6,d3							; nur den Byteanteil in d3 sichern
	and.b #$07,d3							; und das höchste Bit löschen
	move.l #SQUARE_PATTERN,d4				; $FFFFF000 nach d4
	lsr.l d3,d4								; /8
	move.l d4,pattern						; Muster speichern
	dbf d2,_checkerDrawColumns				; für alle 16x Spalten wiederholen
	lea SQUARE_DY*(DISPLAY_DX>>3)(a0),a0	; 16*(320/8)=640 nächste Anfangsadresse 16 Zeilen tiefer
	dbf d1,_checkerDrawRows					; für alle 16 Reihen wiederholen

	; Kopiere das Muster von Sprite 0 in die Sprites 2 und 4,
	; und das Muster von Sprite 1 in die Sprites 3 und 4.

	lea sprites+16,a0					; Anfangsadresse auf Spritebilddaten (Sprite0)	
	lea (SPRITE_DY+2)*16(a0),a1			; Anfangsadresse nächstes Sprite (60+2)*16 (Sprite1)
	moveq #3-1,d0						; Anzahl Sprite-Kopien, hier 3
_copySprites:
	lea (SPRITE_DY+2)*16(a1),a2			; Anfangsadresse Sprite 2 
	lea (SPRITE_DY+2)*16(a2),a3			; Anfangsadresse Sprite 3 
	moveq #SPRITE_DY-1,d1				; Schleife über 60 Zeilen 
_copySpritesLines:
	move.l (a0)+,(a2)+					; Sprite 0 nach Sprite 2,4 und 6 kopieren
	move.l (a0)+,(a2)+					; Sprite 0 nach Sprite 2,4 und 6 kopieren
	move.l (a0)+,(a2)+					; Sprite 0 nach Sprite 2,4 und 6 kopieren
	move.l (a0)+,(a2)+					; Sprite 0 nach Sprite 2,4 und 6 kopieren
	move.l (a1)+,(a3)+					; Sprite 1 nach Sprite 3,5 und 7 kopieren
	move.l (a1)+,(a3)+					; Sprite 1 nach Sprite 3,5 und 7 kopieren
	move.l (a1)+,(a3)+					; Sprite 1 nach Sprite 3,5 und 7 kopieren
	move.l (a1)+,(a3)+					; Sprite 1 nach Sprite 3,5 und 7 kopieren
	dbf d1,_copySpritesLines			; für alle 60 Zeilen wiederholen
	lea (SPRITE_DY+4)*16(a0),a0			; Anfangsadresse auf Sprite 4 bzw. 6
	lea (SPRITE_DY+2)*16(a0),a1			; Anfangsadresse auf Sprite 5 bzw. 7
	dbf d0,_copySprites					; für alle Sprite-Kopien wiederholen

	; Hauptschleife

	move.w #SPRITE_X,d0					; Anfangsposition X
	move.w #SPRITE_Y,d1					; Anfangsposition Y

_loop:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist (bei der
	; richtigen Zeile und der nächsten warten, da die Ausführung der
	; Schleife weniger als eine Zeile in Anspruch nimmt)

	movem.w d0,-(sp)
	move.w #DISPLAY_Y+DISPLAY_DY,d0		; ($2c+256)		; auf die Zeile warten
	bsr _waitRaster
	move.w #DISPLAY_Y+DISPLAY_DY+1,d0	; ($2c+256+1)	; und auf die nächste Zeile warten
	bsr _waitRaster
	movem.w (sp)+,d0

	; Sprites Positionen aktualisieren

	lea sprites,a0						; Anfangsadresse Sprites
	lea spritesPositions,a1				; Anfangsadresse Spritepositionen
	moveq #8-1,d2						; Anzahl Sprites, hier 8
_updateSprites:

	move.w (a1)+,d0						; horizontale Spriteposition 
	addi.w #DISPLAY_X,d0				; $81+horizontale Spriteposition, Sprite X Position
	move.w (a1)+,d1						; vertikale Spriteposition 
	addi.w #DISPLAY_Y,d1				; $2c+vertikale Spriteposition, Sprite Y Position 
	lea 4(a1),a1						; Zeiger auf nächste horizontale Spriteposition voreinstellen 

	move.w d1,d3						; Kopie Sprite_y 
	lsl.w #8,d3							; ins hohe Byte verschieben = SV7-SV0
	move.w d0,d4						; Kopie Sprite_x 
	subq.w #1,d4						; SPRITE_X-1 
	lsr.w #1,d4							; nach rechts verschieben = SH8-SH1 
	move.b d4,d3						; d3 zusammenbauen 
	;or.w #$0080,d3						; Um jede Zeile des Sprites zu verdoppeln, ohne die Zeile
										; in ihren Daten zu verdoppeln, wenn Bit 15 von FMODE gesetzt ist
	move.w d3,(a0)						; ((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1)
										; = dc.w VSTART,HSTART

	move.w d1,d3						; Kopie Sprite_y 
	addi.w #SPRITE_DY,d3				; SPRITE_Y+SPRITE_DY 
	move.w d3,d5						; Kopie SPRITE_Y+SPRITE_DY 
	lsl.w #8,d3							; ins hohe Byte verschieben = EV7-EV0 
	move.w d1,d4						; Kopie Sprite_x 
	lsr.w #6,d4							; ins Byte SPTCTL verschieben
	and.b #$04,d4						; nur Bit SV8 
	move.b d4,d3						; Ergebnis ins Ziel SPTCTL
	lsr.w #7,d5							; SPRITE_Y+SPRITE_DY ins Byte SPTCTL verschieben 
	and.b #$02,d5						; nur Bit EV8 
	or.b d5,d3							; zusammen mit SV8 in einem Byte 
	move.w d0,d4						; Kopie Sprite_x 
	subq.w #1,d4						; SPRITE_X-1 
	and.b #$01,d4						; nur Bit SH0  
	or.b d4,d3							; d3 zusammenbauen
	or.w #$0080,d3						; Unnötig für ungerade Sprites, aber das Attachment-Bit
										; systematisch zu setzen, vereinfacht die Schleife...
	move.w d3,8(a0)						; (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)!$0080
										; = dc.w VEND,SPTCTL
	lea (SPRITE_DY+2)*16(a0),a0			; Adresse nächste Spritedaten
	dbf d2,_updateSprites				; nächster Schleifendurchlauf

	; Verschieben von Sprites indem sie sie von den Rändern abprallen lassen

	lea spritesPositions,a0				; Tabellenanfang Spritepositionen
	move.w #8-1,d0						; Anzahl Sprites
_moveSprites:
	move.w (a0),d1						; aktuelle Spriteposition X nach d1
	add.w 4(a0),d1						; addieren der Geschwindigkeit X zur Spriteposition
	cmpi.w #SPRITE_XMIN,d1				; X Spriteposition mit -10 vergleichen
	bge _moveSpriteNoUnderflowX			; wenn größer, dann keine Unterschreitung von X
	neg.w 4(a0)							; ansonsten horizontale Richtung umkehren
	add.w 4(a0),d1						; und horizontale Geschwindigkeit addieren
	bra _moveSpriteNoOverflowX			; Sprung zu aktuelle horizontale Spriteposition speichern
_moveSpriteNoUnderflowX:
	cmpi.w #SPRITE_XMAX,d1				; X Spriteposition mit (320-64+10=266) vergleichen
	blt _moveSpriteNoOverflowX			; wenn kleiner, dann keine Überschreitung von X
	neg.w 4(a0)							; ansonsten horizontale Richtung umkehren
	add.w 4(a0),d1						; und horizontale Geschwindigkeit addieren
_moveSpriteNoOverflowX:
	move.w d1,(a0)						; aktuelle horizontale Spriteposition speichern

	move.w 2(a0),d1						; aktuelle Spriteposition Y nach d1
	add.w 6(a0),d1						; addieren der Geschwindigkeit Y zur Spriteposition
	cmpi.w #SPRITE_YMIN,d1				; Y Spriteposition mit -10 vergleichen
	bge _moveSpriteNoUnderflowY			; wenn größer, dann keine Unterschreitung von Y
	neg.w 6(a0)							; ansonsten vertikale Richtung umkehren
	add.w 6(a0),d1						; und vertikale Geschwindigkeit addieren
	bra _moveSpriteNoOverflowY			; Sprung zu aktuelle vertikale Spriteposition speichern
_moveSpriteNoUnderflowY:
	cmpi.w #SPRITE_YMAX,d1				; Y Spriteposition mit (256-60+10=206) vergleichen
	blt _moveSpriteNoOverflowY			; wenn kleiner, dann keine Überschreitung von Y
	neg.w 6(a0)							; ansonsten vertikale Richtung umkehren
	add.w 6(a0),d1						; und vertikale Geschwindigkeit addieren
_moveSpriteNoOverflowY:
	move.w d1,2(a0)						; aktuelle vertikale Spriteposition speichern

	lea 8(a0),a0						; nächste Spriteposition
	dbf d0,_moveSprites					; wenn noch nicht alle durchlaufen sind, wiederholen

	; Testen eines Drucks der linken Maustaste

	btst #6,$BFE001
	bne _loop

;********** Ende **********

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern)
	; und schalten Sie alle Hardware-Interrupts und DMAs aus.

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

	movea.l bitplanes,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l copperlist,a1
	move.l #COPPERSIZE,d0
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

;----------  Warten auf vertikal blank (funktioniert nur, wenn der VERTB-Interrupt aktiviert ist!) ----------

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
copperlist:			DC.L 0
bitplanes:			DC.L 0
					CNOP 0,8
sprites:
sprite0:			
	; Die Adresse muss auf 64 Bit ausgerichtet sein
	DC.W 0, 0, 0, 0, 0, 0, 0, 0
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000
	DC.W $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000
	DC.W $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000
	DC.W $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0, $00F0
	DC.W $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0, $00F0
	DC.W $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0, $00F0
	DC.W $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0, $00F0
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000, $F0F0
	DC.W $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000, $F0F0
	DC.W $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000, $F0F0
	DC.W $F000, $F000, $F0F0, $00F0, $F000, $00F0, $F000, $F0F0
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W $00F0, $00F0, $F000, $F000, $0000, $F0F0, $00F0, $F000
	DC.W $00F0, $00F0, $F000, $F000, $0000, $F0F0, $00F0, $F000
	DC.W $00F0, $00F0, $F000, $F000, $0000, $F0F0, $00F0, $F000
	DC.W $00F0, $00F0, $F000, $F000, $0000, $F0F0, $00F0, $F000
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F, $0F00
	DC.W $F000, $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000
	DC.W $F000, $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000
	DC.W $F000, $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000
	DC.W $F000, $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $000F, $000F, $000F, $000F, $0F0F, $0000, $0F0F, $0000
	DC.W $00F0, $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0
	DC.W $00F0, $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0
	DC.W $00F0, $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0
	DC.W $00F0, $F000, $F000, $F000, $F0F0, $00F0, $F000, $00F0
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $0F00, $0F00, $0F00, $0F00, $0F00, $000F, $0F00, $000F
	DC.W $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0
	DC.W $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0
	DC.W $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0
	DC.W $F0F0, $00F0, $00F0, $00F0, $F000, $F0F0, $0000, $F0F0
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W $000F, $000F, $000F, $000F, $0000, $0F0F, $0000, $0F0F
	DC.W 0, 0, 0, 0, 0, 0, 0, 0
sprite1:			
	; Die Adresse muss auf 64 Bit ausgerichtet sein
	DC.W 0, 0, 0, 0, 0, 0, 0, 0
	DC.W $0000, $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F
	DC.W $0000, $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F
	DC.W $0000, $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F
	DC.W $0000, $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F
	DC.W $0000, $00F0, $F0F0, $F000, $F0F0, $F0F0, $F0F0, $F000
	DC.W $0000, $00F0, $F0F0, $F000, $F0F0, $F0F0, $F0F0, $F000
	DC.W $0000, $00F0, $F0F0, $F000, $F0F0, $F0F0, $F0F0, $F000
	DC.W $0000, $00F0, $F0F0, $F000, $F0F0, $F0F0, $F0F0, $F000
	DC.W $0000, $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F
	DC.W $0000, $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F
	DC.W $0000, $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F
	DC.W $0000, $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F
	DC.W $0000, $F0F0, $F0F0, $0000, $F0F0, $F0F0, $F0F0, $0000
	DC.W $0000, $F0F0, $F0F0, $0000, $F0F0, $F0F0, $F0F0, $0000
	DC.W $0000, $F0F0, $F0F0, $0000, $F0F0, $F0F0, $F0F0, $0000
	DC.W $0000, $F0F0, $F0F0, $0000, $F0F0, $F0F0, $F0F0, $0000
	DC.W $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F, $0F0F
	DC.W $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F, $0F0F
	DC.W $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F, $0F0F
	DC.W $000F, $0F0F, $0F00, $0000, $0000, $0000, $000F, $0F0F
	DC.W $00F0, $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000
	DC.W $00F0, $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000
	DC.W $00F0, $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000
	DC.W $00F0, $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000
	DC.W $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F, $0F0F
	DC.W $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F, $0F0F
	DC.W $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F, $0F0F
	DC.W $0F0F, $0F0F, $0000, $0000, $0000, $0000, $0F0F, $0F0F
	DC.W $F0F0, $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000
	DC.W $F0F0, $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000
	DC.W $F0F0, $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000
	DC.W $F0F0, $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000
	DC.W $0F0F, $0F00, $0000, $000F, $0000, $000F, $0F0F, $0F0F
	DC.W $0F0F, $0F00, $0000, $000F, $0000, $000F, $0F0F, $0F0F
	DC.W $0F0F, $0F00, $0000, $000F, $0000, $000F, $0F0F, $0F0F
	DC.W $0F0F, $0F00, $0000, $000F, $0000, $000F, $0F0F, $0F0F
	DC.W $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000
	DC.W $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000
	DC.W $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000
	DC.W $F0F0, $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000
	DC.W $0F0F, $0000, $0000, $0F0F, $0000, $0F0F, $0F0F, $0F0F
	DC.W $0F0F, $0000, $0000, $0F0F, $0000, $0F0F, $0F0F, $0F0F
	DC.W $0F0F, $0000, $0000, $0F0F, $0000, $0F0F, $0F0F, $0F0F
	DC.W $0F0F, $0000, $0000, $0F0F, $0000, $0F0F, $0F0F, $0F0F
	DC.W $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000, $0000
	DC.W $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000, $0000
	DC.W $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000, $0000
	DC.W $F0F0, $0000, $00F0, $F0F0, $F0F0, $0000, $0000, $0000
	DC.W $0F00, $0000, $000F, $0F0F, $000F, $0F0F, $0F0F, $0F0F
	DC.W $0F00, $0000, $000F, $0F0F, $000F, $0F0F, $0F0F, $0F0F
	DC.W $0F00, $0000, $000F, $0F0F, $000F, $0F0F, $0F0F, $0F0F
	DC.W $0F00, $0000, $000F, $0F0F, $000F, $0F0F, $0F0F, $0F0F
	DC.W $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000, $0000
	DC.W $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000, $0000
	DC.W $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000, $0000
	DC.W $F000, $0000, $F0F0, $F0F0, $F000, $0000, $0000, $0000
	DC.W $0000, $0000, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F
	DC.W $0000, $0000, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F
	DC.W $0000, $0000, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F
	DC.W $0000, $0000, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F, $0F0F
	DC.W 0, 0, 0, 0, 0, 0, 0, 0
sprite2:			; Die Adresse muss auf 64 Bit ausgerichtet sein
					BLK.B (SPRITE_DY+2)*16,0
sprite3:			; Die Adresse muss auf 64 Bit ausgerichtet sein
					BLK.B (SPRITE_DY+2)*16,0
sprite4:			; Die Adresse muss auf 64 Bit ausgerichtet sein
					BLK.B (SPRITE_DY+2)*16,0
sprite5:			; Die Adresse muss auf 64 Bit ausgerichtet sein
					BLK.B (SPRITE_DY+2)*16,0
sprite6:			; Die Adresse muss auf 64 Bit ausgerichtet sein
					BLK.B (SPRITE_DY+2)*16,0
sprite7:			; Die Adresse muss auf 64 Bit ausgerichtet sein
					BLK.B (SPRITE_DY+2)*16,0
spriteVoid:			; Die Adresse muss auf 64 Bit ausgerichtet sein
					BLK.B 16,0					
palette:
	dc.w $0000, $0000, $0FFF, $0FFF, $0EEE, $0EEE, $0DDD, $0DDD
	dc.w $0CCC, $0CCC, $0BBB, $0BBB, $0AAA, $0AAA, $0999, $0999
	dc.w $0888, $0888, $0777, $0777, $0666, $0666, $0555, $0555
	dc.w $0444, $0444, $0333, $0333, $0222, $0222, $0111, $0111
	dc.w $0300, $0300, $0500, $0700, $0700, $0A00, $0900, $0E00
	dc.w $0C00, $0700, $0E00, $0B00, $0F00, $0FFF, $0F33, $0F33
	dc.w $0F55, $0FCC, $0F88, $0F00, $0FAA, $0F33, $0FCC, $0FCC
	dc.w $0300, $03F0, $0510, $07A0, $0720, $0A50, $0920, $0EF0
	dc.w $0C30, $07C0, $0E40, $0B60, $0F50, $0F7F, $0F73, $0F03
	dc.w $0F85, $0FDC, $0FA8, $0F60, $0FBA, $0FF3, $0FDC, $0FBC	; 10
	dc.w $0310, $03F0, $0530, $0740, $0740, $0A90, $0950, $0EF0
	dc.w $0C70, $0770, $0E80, $0BD0, $0F90, $0FFF, $0FA3, $0FD3
	dc.w $0FB5, $0FEC, $0FC8, $0FC0, $0FDA, $0FA3, $0FEC, $0FBC
	dc.w $0320, $03F0, $0540, $07F0, $0770, $0A00, $0990, $0E10
	dc.w $0CB0, $0760, $0ED0, $0B70, $0FE0, $0FBF, $0FE3, $0FE3
	dc.w $0FF5, $0F1C, $0FF8, $0F40, $0FFA, $0F73, $0FFC, $0FBC
	dc.w $0230, $0830, $0450, $0470, $0670, $00A0, $0790, $0CE0
	dc.w $09C0, $0C70, $0BE0, $08B0, $0CF0, $0BFF, $0DF3, $03F3
	dc.w $0DF5, $0CFC, $0EF8, $03F0, $0EFA, $0BF3, $0FFC, $04FC
	dc.w $0130, $0830, $0250, $0870, $0370, $09A0, $0490, $0AE0	; 20
	dc.w $05C0, $0D70, $06E0, $0DB0, $07F0, $0FFF, $09F3, $02F3
	dc.w $0AF5, $08FC, $0BF8, $0BF0, $0CFA, $0EF3, $0EFC, $04FC
	dc.w $0030, $0830, $0050, $0E70, $0170, $04A0, $0190, $0AE0
	dc.w $02C0, $0170, $02E0, $07B0, $03F0, $07FF, $05F3, $05F3
	dc.w $07F5, $07FC, $09F8, $05F0, $0BFA, $02F3, $0DFC, $04FC
	dc.w $0030, $0037, $0050, $007C, $0071, $00A0, $0091, $00E5
	dc.w $00C1, $007B, $00E1, $00BF, $00F2, $0FFF, $03F4, $03FE
	dc.w $05F7, $0CF2, $08F9, $00F1, $0AFA, $03FF, $0CFD, $0CF3
	dc.w $0031, $0037, $0052, $0077, $0073, $00A7, $0094, $00E7
	dc.w $00C5, $007A, $00E6, $00BA, $00F7, $0FFB, $03F8, $03FF ; 30
	dc.w $05FA, $0CF5, $08FB, $00F9, $0AFC, $03FD, $0CFE, $0CF3
	dc.w $0032, $0036, $0054, $0071, $0075, $00AC, $0097, $00E7
	dc.w $00C9, $0075, $00EB, $00B0, $00FC, $0FF3, $03FC, $03FC
	dc.w $05FD, $0CF6, $08FD, $00FF, $0AFE, $03F8, $0CFF, $0CF2
	dc.w $0033, $0003, $0055, $0017, $0077, $002A, $0099, $004E
	dc.w $00BC, $00A7, $00DE, $00BB, $00EF, $0FFF, $03FF, $031F
	dc.w $05FF, $0C4F, $08FF, $007F, $0AFF, $039F, $0CFF, $0CCF
	dc.w $0023, $0003, $0035, $0077, $0047, $00EA, $0069, $004E
	dc.w $007C, $00E7, $009E, $005B, $00AF, $0F7F, $03BF, $034F
	dc.w $05CF, $0C3F, $08DF, $000F, $0ADF, $03DF, $0CEF, $0CCF	; 40
	dc.w $0013, $0003, $0015, $00B7, $0027, $007A, $0039, $002E
	dc.w $003C, $00F7, $004E, $00AB, $005F, $0FBF, $037F, $034F
	dc.w $058F, $0CFF, $08AF, $008F, $0ACF, $030F, $0CDF, $0CCF
	dc.w $0003, $0013, $0005, $0017, $0007, $002A, $0009, $003E
	dc.w $000C, $0037, $000E, $004B, $001F, $0F3F, $033F, $036F
	dc.w $055F, $0CFF, $088F, $002F, $0AAF, $035F, $0CCF, $0CDF
	dc.w $0003, $0E03, $0105, $0907, $0207, $030A, $0209, $0D0E
	dc.w $030C, $0807, $040E, $020B, $050F, $03FF, $063F, $0D3F
	dc.w $085F, $0ACF, $0A8F, $040F, $0BAF, $0D3F, $0DCF, $0ACF
	dc.w $0103, $0F03, $0305, $0407, $0407, $090A, $0509, $0F0E	; 50
	dc.w $070C, $0707, $080E, $0D0B, $090F, $0FFF, $0A3F, $0D3F 
	dc.w $0B5F, $0ECF, $0C8F, $0C0F, $0DAF, $0A3F, $0ECF, $0BCF
	dc.w $0203, $0E03, $0405, $0E07, $0607, $0E0A, $0809, $0E0E
	dc.w $0B0C, $0307, $0D0E, $030B, $0E0F, $07FF, $0E3F, $0B3F
	dc.w $0E5F, $0FCF, $0F8F, $020F, $0FAF, $063F, $0FCF, $0ACF
	dc.w $0302, $0308, $0504, $0704, $0706, $0A00, $0907, $0E0C
	dc.w $0C09, $070C, $0E0B, $0B08, $0F0C, $0FFB, $0F3D, $0F33
	dc.w $0F5D, $0FCC, $0F8E, $0F03, $0FAE, $0F3B, $0FCF, $0FC4
	dc.w $0301, $0309, $0502, $070A, $0703, $0A0B, $0904, $0E0C
	dc.w $0C06, $0700, $0E07, $0B01, $0F08, $0FF3, $0F39, $0F36 ; 60
	dc.w $0F5A, $0FCB, $0F8B, $0F0D, $0FAD, $0F30, $0FCE, $0FC5
	dc.w $0300, $0309, $0500, $070E, $0701, $0A04, $0901, $0E0A
	dc.w $0C02, $0701, $0E02, $0B07, $0F03, $0FF7, $0F35, $0F35
	dc.w $0F57, $0FC7, $0F89, $0F05, $0FAB, $0F33, $0FCD, $0FC5	; 64 --> 64*8=512	-> 255 00FFCCD5
spritesPositions:	; Das erste Wort ist die horizontale Position (ausgedrückt im Koordinatensystem des Bildschirms,   0(a0)	
					; also fügen Sie DISPLAY_X hinzu, um es zu verwenden), das zweite Wort ist die vertikale Position  2(a0)  
					; das dritte ist die horizontale Geschwindigkeit	4(a0)
					; das vierte ist die vertikale Geschwindigkeit		6(a0)
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 2, 1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 2, 1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, -1, -2
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, -1, -2
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 3, -1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 3, -1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 1, 3
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 1, 3
pattern:			DC.L 0


	end

Programmbeschreibung:

In diesem Beispiel werden die Möglichkeiten der AGA-Sprites demonstriert. Dabei 
wird in diesem Programm das Sprite0 definiert und anschließend in die Sprite1
bis Sprite7 kopiert. Im Datenbereich sind zu diesem Zweck folgende Platzhalter
vorgesehen: BLK.B (SPRITE_DY+2)*16,0
Das Sprite0 hat die Größe von 64x60 (Breite x Höhe) und die Anfangsadresse muss
auf 64 Bit ausgerichtet sein. (CNOP 0,8)
Die Byte-Blockgröße ergibt sich aufgrund folgender Berechnung:

Sprite_DX=64	64/16 Bit = 4 Wörter * 2 planes = 8 Wörter
Sprite_DY=60
Zusätzlich für die Steuerwörter zu Beginn und für die Nullen am Ende nochmals 2*8 Wörter
d.h. 60*8+2*8=496 Wörter oder 480+16 Wörter	--> blk.w 496,0 oder in Bytes blk.b 992,0. 
Oder anders geschrieben: BLK.W (SPRITE_DY+2)*8,0 oder eben BLK.B (SPRITE_DY+2)*16,0 

Die Spritedefinition für 64 Bit breite Sprites erfolgt nach diesem Schema:

;	DC.W CW1, 0, 0, 0, CW2, 0, 0, 0, 0
;	DC.W ... 
;	DC.W 0, 0, 0, 0, 0, 0, 0, 0

Das Programm zeigt alle 8 Sprites, die jedoch zu 4 Attached-Sprites überlagert 
werden. Das Attached-Bit wird dabei in der Hauptschleife im Teil _updateSprites
der Einfachkeit für ungerade und gerade Sprites laufend neu gesetzt.

Das Programm nutzt die Möglichkeit der 256 Farben einerseits durch die Verwendung
von 8 Bitebenen im Hintergrund und für die Sprites durch Auswahl einer Palette 
mit 16 Farben für die geraden und ungeraden Sprites aus diesen 256 Farben.

Die 256 Farben werden bei der Erstellung der Copperliste in die 256 Farbregister 
eingetragen. Dabei werden die Farbregister entsprechend der Einstellung des Bit 9
von BPLCON3 in das hohe bzw. niedrige Nibble gespeichert, wodurch sich der 24Bit
Farbwert ergibt.

Das Schema hierfür ist das Folgende:

	dc.w	$106,$000	; Auswahl nibble hoch

	dc.w	$180,$47f	; hohe nibble aller Farben
	dc.w	$182,$123
	dc.w	$184,$456

	dc.w	$106,$200	; Auswahl nibble niedrig

	dc.w	$180,$3ea	; niedrige nibble aller Farben
	dc.w	$182,$111
	dc.w	$184,$444

Paletteneinstellung Farben der Sprites:
Bei 256 Farben gibt es 16 Bänke mit jeweils 16 Farben. 16*16=256.
Die erste Farbbank geht von Color0 bis Color15, die zweite von Color16 bis Color31
und die 16. von Color240 bis Color255. Dabei kann für die ungeraden und für die
geraden Sprites eine unterschiedliche Palette gewählt werden.

Die Auswahl der Spritepalette erfolgt mit dem Register BPLCON4 ($dff10c). 

; Sprites (AGA)
	move.w #BPLCON4,(a0)+	; dc.w $10c
	move.w #$0011,(a0)+		; Bits 3-0 : bits 7-4 des 8-Bit-Startindexes der Palette der ungeraden Sprites
							; Bits 7-4 : bits 7-4 des 8-Bit-Startindex der Palette der geraden Sprites
							; NB : Die Palette für ungerade Sprites wird verwendet, wenn zwei Sprites angehängt werden
	
Dann kann außerdem die Auflösung des Sprites in Lowres, Hires und Superhires eingestellt werden
und das Sprite auch ausserhalb der DIWSTRT und DIWSTOP Grenzen angezeigt werden. Dies wird
mit dem Register BPLCON3 eingestellt.	

	move.w #BPLCON3,(a0)+	; dc.w $106
	move.w #$0042,(a0)+		; Bits 7-6 : Auflösung der Sprites (00: ECS-konform, 01: LOWRES, 10: HIRES, 11: SHRES).
							; Bit 1: Sprites an den Rändern des Bildschirms anzeigen (auch Bit 0 von BPLCON0 muss gesetzt werden)
	
Als letzter Punkt muss die Übetragungsbreite (Bandbreite) für den Sprite-Datafetch auf 64 Pixel
eingestellt werden.
	
	move.w #FMODE,(a0)+		; dc.w $1fc
	move.w #$000C,(a0)+		; Bits 3-2 : Breite der Sprites (00: 16 Pixel, 10/01: 32 Pixel, 11: 64 Pixel).
							; Bit 15 (hier nicht verwendet): Verdoppelt die Höhe von Sprites,
							; deren Bit SH10 im ersten Kontrollwort gesetzt ist.



