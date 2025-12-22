
; soc8.s = spriteField.s

; Programmiert von Yragael für Stash of Code (http://www.stashofcode.fr) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Wiederholung der Sprites von einer Zeile zur nächsten nach dem Prinzip
; des Sternenhintergrunds (starfield).

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=1
COPSIZE=9*4+DISPLAY_DEPTH*2*4+6*4+8*2*4+4
	; 9*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		für Adressen der Bitebenen
	; 6*4					Palette (Farben 0-1 für Bitplane, 16-19 für Sprite)
	; 8*2*4					für Adressen der Sprites
	; 4						$FFFFFFFE
STARFIELD_Y=DISPLAY_Y
SPRITE_DX=16				; kann nicht verändert werden
SPRITE_DY=16
STARFIELD_NBROWS=15

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

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #0,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0008,(a0)+			; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+	; Dies entspricht ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC,
																		; wenn DISPLAY_DX ein Vielfaches von 16 ist.
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTL,(a0)+
	move.l bitplane,d0
	move.w d0,(a0)+
	move.w #BPL1PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	; Palette

	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+
	move.w #COLOR01,(a0)+
	move.w #$0777,(a0)+

	lea spritePalette,a1
	move.w #COLOR16,d0
	moveq #4-1,d1
_palette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_palette

	; Sprites (alle Sprites werden angezeigt, daher ungenutzte Sprites mit Nulldaten anzeigen)

	move.l #spriteData,d0
	move.w #SPR0PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR0PTH,(a0)+
	swap d0
	move.w d0,(a0)+
	move.l #spriteVoid,d0
	move.w #SPR0PTL,d1
	REPT 7
	addq.w #2,d1
	move.w d1,(a0)+
	swap d0
	move.w d0,(a0)+
	addq.w #2,d1
	move.w d1,(a0)+
	swap d0
	move.w d0,(a0)+
	ENDR
	
	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83A0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, SPREN=1

;********** Hauptprogramm **********

	; Ein Schachbrettmuster zeichnen

	movea.l bitplane,a0
	move.l #$FFFF0000,d3
	move.w #(DISPLAY_DY>>4)-1,d0
_drawCheckerY:
	move.w #16-1,d1
_drawChecker16:
	moveq #(DISPLAY_DX>>5)-1,d2
_drawCheckerX:
	move.l d3,(a0)+
	dbf d2,_drawCheckerX
	dbf d1,_drawChecker16
	swap d3
	dbf d0,_drawCheckerY

	; Erstellen Sie die Daten des Sprites, das in mehrere vertikal übereinander liegende Stücke
	; zerlegt wurde (und dabei eine Zeile auseinander liegen, damit der DMA Zeit hat, die
	; neuen Steuerwörter in SPR0POS und SPR0CTL am Ende jedes Stückes des Sprites zu laden).

	lea spriteData,a0
	lea spritePositions,a1
	move.w #STARFIELD_Y,d1
	move.w #STARFIELD_NBROWS-1,d2
_createSprite:

	move.w (a1),d0
	addi.w #DISPLAY_X,d0
	lea 4(a1),a1

	move.w d1,d3
	lsl.w #8,d3
	move.w d0,d4
	subq.w #1,d4
	lsr.w #1,d4
	move.b d4,d3
	move.w d3,(a0)+		; ((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1)

	move.w d1,d3
	addi.w #SPRITE_DY,d3
	move.w d3,d5
	lsl.w #8,d3
	move.w d1,d4
	lsr.w #6,d4
	and.b #$04,d4
	move.b d4,d3
	lsr.w #7,d5
	and.b #$02,d5
	or.b d5,d3
	move.w d0,d4
	subq.w #1,d4
	and.b #$01,d4
	or.b d4,d3
	move.w d3,(a0)+		; (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)

	lea spriteBitmap,a2
	REPT SPRITE_DY
	move.l (a2)+,(a0)+
	ENDR

	addi.w #SPRITE_DY+1,d1	; Man muss der DMA eine Zeile lassen

	dbf d2,_createSprite

	move.l #$00000000,(a0)+

	; Hauptschleife

_loop:

	; Die Position der Stücke des Sprites horizontal aktualisieren

	lea spriteData,a0
	lea spritePositions,a1
	move.w #STARFIELD_Y,d1
	move.w #STARFIELD_NBROWS-1,d2
_updateSprites:

	move.w (a1),d0
	addi.w #DISPLAY_X,d0
	lea 4(a1),a1

	move.w d1,d3
	lsl.w #8,d3
	move.w d0,d4
	subq.w #1,d4
	lsr.w #1,d4
	move.b d4,d3
	move.w d3,(a0)+		; ((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1)

	move.w d1,d3
	addi.w #SPRITE_DY,d3
	move.w d3,d5
	lsl.w #8,d3
	move.w d1,d4
	lsr.w #6,d4
	and.b #$04,d4
	move.b d4,d3
	lsr.w #7,d5
	and.b #$02,d5
	or.b d5,d3
	move.w d0,d4
	subq.w #1,d4
	and.b #$01,d4
	or.b d4,d3
	move.w d3,(a0)+		; (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)

	lea SPRITE_DY*4(a0),a0
	addi.w #SPRITE_DY+1,d1	; Man muss der DMA eine Zeile lassen

	dbf d2,_updateSprites

	; Verschieben Sie die Teile des Sprites horizontal

	lea spritePositions,a0
	move.w #STARFIELD_NBROWS-1,d0
_moveSprites:
	move.w (a0),d1
	add.w 2(a0),d1
	cmpi.w #-SPRITE_DX,d1
	bge _noUnderflowX
	addi.w #DISPLAY_DX+SPRITE_DX,d1
	bra _noOverflowX
_noUnderflowX:
	cmpi.w #DISPLAY_DX,d1
	ble _noOverflowX
	subi.w #DISPLAY_DX+SPRITE_DX,d1
_noOverflowX:
	move.w d1,(a0)
	lea 4(a0),a0
	dbf d0,_moveSprites

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist
	; (bei der richtigen Zeile und der nächsten warten, da die
	; Ausführung der Schleife weniger als eine Zeile in Anspruch nimmt)

	movem.w d0,-(sp)
	move.w #DISPLAY_Y+DISPLAY_DY,d0
	bsr _waitRaster
	move.w #DISPLAY_Y+DISPLAY_DY+1,d0
	bsr _waitRaster
	movem.w (sp)+,d0

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
spriteBitmap:
					REPT SPRITE_DY>>1
					DC.W $00FF, $0000
					ENDR
					REPT SPRITE_DY>>1
					DC.W $00FF, $FFFF
					ENDR
spriteVoid:
					DC.W 0, 0
spritePalette:
					DC.W $0000, $0F00, $00F0, $000F
spriteData:
					BLK.W STARFIELD_NBROWS*(1+SPRITE_DY)*2+2, 0
spritePositions:	; Sie benötigen STARFIELD_NBROWS Zeilen. Das erste Wort ist die horizontale Position
					; (ausgedrückt im Koordinatensystem des Bildschirms, also fügen Sie DISPLAY_X hinzu,
					; um es zu verwenden), das zweite die horizontale Geschwindigkeit (zufällig generiert).

					DC.W 164, 4
					DC.W 129, 2
					DC.W 68, 5
					DC.W 192, 3
					DC.W 84, 2
					DC.W 144, 5
					DC.W 127, 1
					DC.W 21, 1
					DC.W 71, 2
					DC.W 182, 2
					DC.W 20, 2
					DC.W 120, 2
					DC.W 222, 4
					DC.W 97, 5
					DC.W 5, 5
