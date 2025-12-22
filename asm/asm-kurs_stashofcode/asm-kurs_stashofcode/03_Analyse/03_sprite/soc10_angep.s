
; soc10_angep.s = spriteCollision.s

; Programmiert von Yragael für Stash of Code (http://www.stashofcode.fr) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Erkennung von Kollisionen zwischen zwei Sprites sowie zwischen Sprite und Playfield.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=1
COPSIZE=9*4+DISPLAY_DEPTH*2*4+10*4+8*2*4+4
	; 9*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		für Adressen der Bitebenen
	; 10*4					Palette (Farben 0-1 für Bitplane, 16-19 für Sprites 0&1, 20-23 für Sprites 2&3)
	; 8*2*4					für Adressen der Sprites
	; 4						$FFFFFFFE
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder $00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = 0
BPLCON2_val = $0008																; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
BPL1MOD_val = 0
;----------------------------------------------------------
SPRITE_X=DISPLAY_X			; SPRITE_X-1 wird kodiert, da die Anzeige von Bitplanes durch
							; die Hardware um ein Pixel gegenüber der Anzeige von Sprites
							; verzögert wird (nicht dokumentiert).
SPRITE_Y=DISPLAY_Y+(DISPLAY_DY>>1)
SPRITE_DX=16				; kann nicht verändert werden
SPRITE_DY=16

VSTART	=	SPRITE_Y&$FF
HSTART	=	((SPRITE_X-1)&$1FF)>>1
VEND	=	(SPRITE_Y+SPRITE_DY)&$FF
SPTCTL	=	((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)

;********** Initialisierung **********

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $dff000,a5

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplane

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

	move.l #$01FC0000,(a0)+				; Kompatibilität OCS mit AGA	

	move.l bitplane,d0					; Adressen der Bitebenen
	move.w #BPL1PTL,(a0)+			
	move.w d0,(a0)+
	move.w #BPL1PTH,(a0)+
	swap d0
	move.w d0,(a0)+
	
	move.w #COLOR00,(a0)+				; Palette (playfield auf einem bitplane und nur sprites 0&1 und 2&3)
	move.w #$0000,(a0)+
	move.w #COLOR01,(a0)+
	move.w #$0777,(a0)+
	
	lea spritesPalette,a1				; Palette Sprites
	move.w #COLOR16,d0					; COLOR16=$01A0
	moveq #8-1,d1						; 16 Farben
_palette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_palette

	move.l #sprite0,d0
	move.w #SPR0PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR0PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteVoid,d0
	move.w #SPR1PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR1PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #sprite2,d0
	move.w #SPR2PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR2PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteVoid,d0				; Sprites (alle Sprites werden angezeigt, daher unbenutzte Sprites mit Daten Null anzeigen)
	move.w #SPR3PTL,d1
	REPT 10
	addq.w #2,d1
	move.w d1,(a0)+
	swap d0
	move.w d0,(a0)+
	ENDR
	
	move.l #$FFFFFFFE,(a0)				; Ende

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83A0,DMACON(a5)			; DMAEN=1, BPLEN=1, COPEN=1, SPREN=1

;********** Hauptprogramm **********

	; Seitenstreifen zeichnen

	movea.l bitplane,a0					; Anfangsadresse Bitplane
	lea 4(a0),a1						; versetzt auf der Bitplane um 4 Bytes
	lea 24(a0),a0						; versetzt auf der Bitplane um 24 Bytes
	move.w #DISPLAY_DY-1,d0				; Anzahl Schleifen, Höhe 256 Zeilen 
_drawStrips:
	move.l #$F000000F,(a0)				; Streifen
	move.l #$FFFFFFFF,(a1)				; Streifen
	lea DISPLAY_DX>>3(a0),a0			; 320/8=40 Bytes - nächste Zeile	
	lea DISPLAY_DX>>3(a1),a1			; 320/8=40 Bytes - nächste Zeile	
	dbf d0,_drawStrips					; für alle Zeilen wiederholen

	; Kollisionen zwischen Sprite 0 (bereits der Standardfall) und Sprite 2
	; (bereits der Standardfall) und Bitplane 1 (muss angegeben werden) erkennen,
	; wenn letztere ein gesetztes Bit enthält (muss angegeben werden).

	move.w #$0041,CLXCON(a5)

	; Hauptschleife

_loop:

	; CLXDAT lesen setzt ihn auf 0 zurück, also seinen Wert speichern,
	; um mehrere Kollisionen zu erkennen

	move.w CLXDAT(a5),d0
	moveq #0,d1

	; Rot zu Color0 hinzufügen, falls es zu einer Kollision zwischen den
	; Sprites 0(&1) und 2(&3) kommt

	btst #9,d0
	beq _noSprite0Sprite2Collision
	or.w #$0F00,d1						; rot
_noSprite0Sprite2Collision:
	
	; Color0 zu grün wechseln, wenn es zu einer Kollision zwischen Sprite 0(&1)
	; und dem Playfield (d.h. Bitplane 1) kommt.

	btst #1,d0
	beq _noSprite0Bitplane1Collision
	or.w #$00F0,d1						; grün
_noSprite0Bitplane1Collision:

	; Color0 zu blau wechseln, wenn es zu einer Kollision zwischen Sprite 2(&3)
	; und Playfield (d.h. Bitplane 1) kommt.

	btst #2,d0
	beq _noSprite2Bitplane1Collision
	or.w #$000F,d1						; blau
_noSprite2Bitplane1Collision:

	; Ändern von Color0, um erkannte Kollisionen wiederzugeben

	move.w d1,COLOR00(a5)

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist
	; (bei der richtigen Zeile und der nächsten warten, da die Ausführung der
	; Schleife weniger als eine Zeile in Anspruch nimmt)

	movem.w d0,-(sp)
	move.w #DISPLAY_Y+DISPLAY_DY,d0		; ($2c+256)		; auf die Zeile warten
	bsr _waitRaster
	move.w #DISPLAY_Y+DISPLAY_DY+1,d0	; ($2c+256+1)	; und auf die nächste Zeile warten
	bsr _waitRaster
	movem.w (sp)+,d0

	; Die Positionen der Sprites 0 und 2 aktualisieren

	lea sprites,a0						; Anfangsadresse Sprites
	lea spritesPositions,a1				; Anfangsadresse Spritepositionen
	move.w #SPRITE_Y,d1					; Sprite Y Position, Mitte des Bildschirms
	moveq #2-1,d2						; Anzahl Sprites, hier 2
_updateSprites:

	move.w (a1),d0						; horizontale Spriteposition 
	addi.w #DISPLAY_X,d0				; $81+horizontale Spriteposition	
	lea 4(a1),a1						; Zeiger auf nächste horizontale Spriteposition voreinstellen 

	move.w d1,d3						; Kopie Sprite_y 		
	lsl.w #8,d3							; ins hohe Byte verschieben = SV7-SV0 
	move.w d0,d4						; Kopie Sprite_x 
	subq.w #1,d4						; SPRITE_X-1 
	lsr.w #1,d4							; nach rechts verschieben = SH8-SH1  
	move.b d4,d3						; d3 zusammenbauen 
	move.w d3,(a0)+						; ((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1)
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
	move.w d3,(a0)+						; (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)
										; = dc.w VEND,SPTCTL

	lea (SPRITE_DY+1)*4(a0),a0			; Adresse nächste Spritedaten
	dbf d2,_updateSprites				; nächster Schleifendurchlauf

	; Verschieben von Sprites horizonta
	
	lea spritesPositions,a0				; Tabellenanfang Spritepositionen	
	move.w #2-1,d0						; Anzahl Sprites
_moveSprites:	
	move.w (a0),d1						; aktuelle Spriteposition nach d1
	add.w 2(a0),d1						; addieren der Geschwindigkeit zur Spriteposition
	cmpi.w #-SPRITE_DX,d1				; -16? (Spritebreite) mit Spriteposition vergleichen		; cmp.w #$fff0,d1
	bge _noUnderflowX					; wenn größer, dann keine Unterschreitung von X
	addi.w #DISPLAY_DX+SPRITE_DX,d1		; ansonsten d1 = d1 + 320+16
	bra _noOverflowX					; aktuelle Spriteposition speichern
_noUnderflowX:
	cmpi.w #DISPLAY_DX,d1				; 320? rechter Rand 
	ble _noOverflowX					; wenn kleiner, dann keine Überschreitung von X
	subi.w #DISPLAY_DX+SPRITE_DX,d1		; ansonsten d1 = d1 - 320+16
_noOverflowX:
	move.w d1,(a0)						; aktuelle Spriteposition speichern	
	lea 4(a0),a0						; nächste Spriteposition
	dbf d0,_moveSprites					; wenn noch nicht alle durchlaufen sind, wiederholen

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

	movea.l bitplane,a1
	move.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l copperlist,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routines **********

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
bitplane:			DC.L 0
sprites:
					
sprite0:			; Sprite 0
					DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)					
					REPT 8
					DC.W $00FF, $0000
					ENDR
					REPT 8
					DC.W $00FF, $FFFF
					ENDR
					DC.W 0, 0
					
sprite2:			; Sprite 2
					DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)	
					REPT 8
					DC.W $00FF, $0000
					ENDR
					REPT 8
					DC.W $00FF, $FFFF
					ENDR
					DC.W 0, 0
spriteVoid:
					DC.W 0, 0
spritesPalette:
					; Sprites 0 und 1
					DC.W $0000, $0F00, $00F0, $000F
					; Sprites 2 und 3
					DC.W $0000, $0FF0, $00FF, $0F0F
spritesPositions:	; Das erste Wort ist die horizontale Position (ausgedrückt im Koordinatensystem des Bildschirms,
					; also fügen Sie DISPLAY_X hinzu, um es zu verwenden), das zweite die horizontale Geschwindigkeit
					DC.W 0, 1
					DC.W DISPLAY_DX-16, -1
