
; soc09.s = triplePlayfields.s

; Programmiert von Yragael für Stash of Code (http://www.stashofcode.fr) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Dual-Playfield-Anzeige (zwei Playfields mit je zwei Farben) mit einem
; zusätzlichen Playfield aus drei Sprites in 16 Farben, die horizontal
; wiederverwendet werden.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320		; Dazu müssen 16 Pixel hinzugefügt werden, um das Hardware-Scrolling zu ermöglichen
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=4
COPSIZE=10*4+DISPLAY_DEPTH*2*4+32*4+8*2*4+DISPLAY_DY*(4+(DISPLAY_DX>>4)*2*4)+4
	; 10*4									Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4						für Adressen der Bitebenen
	; 32*4									Palette (nicht auf 1<<DISPLAY_DEPTH Farben beschränkt,
											; da Sprites die Palette stärker nutzen)
	; 8*2*4									Sprites
	; DISPLAY_DY*(4+(DISPLAY_DX>>4)*2*4)	Sprite-Karte
	; 4										$FFFFFFFE
SPRITE_X=DISPLAY_X-1
SPRITE_Y=DISPLAY_Y
SPRITE_DX=16								; kann nicht verändert werden
SPRITE_DY=32

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

	; Speicher in Chip zuweisen, der für Bitplanes auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX+16)>>3,d0
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

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0600,(a0)+			; DPF=1, COLOR=1
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$001B,(a0)+								; PF2PRI=0, PF2P2-0=%011, PF1P2-0=%011 
													; (PF2P2 und PF1P2 müssen auf dem A500 auf 0 stehen, da sonst
													; die Playfields nicht mehr sichtbar sind. Dies ist ein nicht
													; dokumentiertes "Feature" der Hardware.
													; Siehe http://eab.abime.net/showthread.php?t=19676)
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-16-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-16-17+((((DISPLAY_DX+16)>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+
	move.l #$01FC0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l bitplanes,d1
	moveq #DISPLAY_DEPTH-1,d2
_copperListBitplanes:
	move.w d0,(a0)+
	addq.w #$0002,d0
	swap d1
	move.w d1,(a0)+
	move.w d0,(a0)+
	addq.w #$0002,d0
	swap d1
	move.w d1,(a0)+
	addi.l #DISPLAY_DY*((DISPLAY_DX+16)>>3),d1
	dbf d2,_copperListBitplanes

	; Palette (aufgrund von Sprites auf 32 Farben gezwungen, unabhängig von der Anzahl der Bitplanes)

	lea palette,a1
	move.w #COLOR00,d0
	move.w #32-1,d1
_copperListColors:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_copperListColors

	; Sprites (alle Sprites werden angezeigt, daher ungenutzte Sprites mit Nulldaten anzeigen)

	move.l #spriteA0,d0
	move.w #SPR0PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR0PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteA1,d0
	move.w #SPR1PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR1PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteB0,d0
	move.w #SPR2PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR2PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteB1,d0
	move.w #SPR3PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR3PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteC0,d0
	move.w #SPR4PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR4PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteC1,d0
	move.w #SPR5PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR5PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteVoid,d0
	move.w #SPR6PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR6PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.l #spriteVoid,d0
	move.w #SPR7PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR7PTH,(a0)+
	swap d0
	move.w d0,(a0)+

	move.w #(DISPLAY_Y<<8)!$38!$0001,d0		; $38 empirisch ermittelt, aber eigentlich ist es der Wert von DDFSTRT
											; in lowres (4.5 Videotaktzyklen vor DIWSTRT => $81/2-8.5 da Auflösung 
											; von DIWSTRT Pixel ist, aber von DDFSTRT 4 Pixel ist)
	move.w #DISPLAY_DY-1,d1
_copperListSpriteY:
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+
	move.w #((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1),d2
	move.w #SPR0POS,d3
	move.w #(DISPLAY_DX>>4)-1,d4
_copperListSpriteX:
	move.w d3,(a0)+
	move.w d2,(a0)+
	addq.w #8,d3
	move.w d3,(a0)+
	move.w d2,(a0)+
	addq.w #8,d3
	cmpi.w #SPR6POS,d3						; Da Sprite 7 nicht verwendbar ist, werden nur die Spritespaare 0&1, 2&3 und 3&4 verwendet.
	bne _copperListSpriteNoReset
	move.w #SPR0POS,d3
_copperListSpriteNoReset:
	addi.w #16>>1,d2
	dbf d4,_copperListSpriteX
	addi.w #$0100,d0
	dbf d1,_copperListSpriteY

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83E0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1, SPREN=1

;********** Hauptprogramm **********

; NB: Achtung! Der DMA des Blitters wurde nicht aktiviert...

; Ein Schachbrettmuster zeichnen
; ToDo in den letzten 16 Pixeln wird momentan nichts gezeichnet....
	movea.l bitplanes,a0
	lea DISPLAY_DY*((DISPLAY_DX+16)>>3)(a0),a1
	lea DISPLAY_DY*((DISPLAY_DX+16)>>3)(a1),a2
	lea DISPLAY_DY*((DISPLAY_DX+16)>>3)(a2),a3
	move.l #$FFFF0000,d3
	moveq #0,d4
	moveq #-1,d5
	move.w #(DISPLAY_DY>>4)-1,d0
_drawCheckerY:
	move.w #16-1,d1
_drawChecker16:
	moveq #(DISPLAY_DX>>5)-1,d2
_drawCheckerX:
	move.l d3,(a0)+
	move.l d3,(a1)+
	move.l d4,(a2)+
	move.l d4,(a3)+
	dbf d2,_drawCheckerX
	swap d3
	move.w d3,(a0)+
	move.w d3,(a1)+
	swap d3
	swap d4
	move.w d4,(a2)+
	move.w d4,(a3)+
	swap d4
	dbf d1,_drawChecker16
	swap d3
	exg d4,d5
	dbf d0,_drawCheckerY

	; Hauptschleife

	moveq #15,d0	; PF1
	moveq #-1,d1
	moveq #0,d2		; PF2
	moveq #1,d3
_loop:

	; Scrollen durch die playfields

	move.w d2,d4
	lsl.b #4,d4
	or.b d0,d4
	movea.l copperlist,a0
	move.w d4,3*4+2(a0)

	add.b d1,d0
	bge _scrollPF1Positive
	neg.b d1
	add.b d1,d0
	bra _scrollPF1Done
_scrollPF1Positive:
	cmpi.b #15,d0
	ble _scrollPF1Done
	neg.b d1
	add.b d1,d0
_scrollPF1Done:

	add.b d3,d2
	bge _scrollPF2Positive
	neg.b d3
	add.b d3,d2
	bra _scrollPF2Done
_scrollPF2Positive:
	cmpi.b #15,d2
	ble _scrollPF2Done
	neg.b d3
	add.b d3,d2
_scrollPF2Done:

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

	movea.l bitplanes,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX+16)>>3,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l copperlist,a1
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
spriteA0:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)
					; Zahl 1
					DC.W $7FFC, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $F8FE, $0000
					DC.W $F9FE, $0000
					DC.W $FBFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFBE, $0000
					DC.W $FF3E, $0000
					DC.W $FE3E, $0000
					DC.W $FFFE, $0000
					DC.W $0000, $0000
					; Kleine Quadtrate
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W 0, 0
spriteA1:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)!$0080
					;  Hintergrund transparent
					REPT 16
					DC.W $0000, $0000
					ENDR
					; Kleine Quadrate
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W 0, 0
spriteB0:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)
					; Zahl 2
					DC.W $0FE0, $0000
					DC.W $1FE0, $0000
					DC.W $1FE0, $0000
					DC.W $1FE0, $0000
					DC.W $1FE0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $07E0, $0000
					DC.W $1FF8, $0000
					DC.W $0000, $0000
					; Kleine Quadrate
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W 0, 0
spriteB1:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)!$0080
					; Hintergrund transparent
					REPT 16
					DC.W $0000, $0000
					ENDR
					; Kleine Quadrate
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W 0, 0
spriteC0:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)
					; Figur 3
					DC.W $7FFC, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $F0FE, $0000
					DC.W $F0FE, $0000
					DC.W $00FE, $0000
					DC.W $FFFE, $0000
					DC.W $F800, $0000
					DC.W $F80E, $0000
					DC.W $F80E, $0000
					DC.W $FFFE, $0000
					DC.W $0000, $0000
					; Kleine Quadrate
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W $F0F0, $FF00
					DC.W 0, 0
spriteC1:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)!$0080
					; Hintergrund transparent
					REPT 16
					DC.W $0000, $0000
					ENDR
					; Kleine Quadrate
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W 0, 0
; Das letzte Paar Sprites wird nicht verwendet (Sprites 6 und 7).
spriteD0:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)
					;Chiffre 4
					DC.W $7FFC, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $FFFE, $0000
					DC.W $F0FE, $0000
					DC.W $00FE, $0000
					DC.W $00FE, $0000
					DC.W $1FF0, $0000
					DC.W $00FE, $0000
					DC.W $E0FE, $0000
					DC.W $E0FE, $0000
					DC.W $FFFE, $0000
					DC.W $0000, $0000
					; Kleine Quadrate
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $FFFF, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $0000, $FFFF
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $FFFF, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W $0000, $0000
					DC.W 0, 0
spriteD1:			DC.W ((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1)
					DC.W (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!(SPRITE_X&$1)!$0080
					; Hintergrund transparent
					REPT 16
					DC.W $0000, $0000
					ENDR
					; Kleine Quadrate
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W $0F0F, $00FF
					DC.W 0, 0
spriteVoid:
					DC.W $0000, $0000
palette:
					DC.W $0000	; COLOR00	; Playfield 1 (bitplanes 1, 3 und 5)
					DC.W $0700	; COLOR01
					DC.W $0070	; COLOR02
					DC.W $0007	; COLOR03
					DC.W $0000	; COLOR04
					DC.W $0000	; COLOR05
					DC.W $0000	; COLOR06
					DC.W $0000	; COLOR07
					DC.W $0000	; COLOR08	; Playfield 2 (bitplanes 2, 4 und 6)
					DC.W $0F00	; COLOR09
					DC.W $00F0	; COLOR10
					DC.W $000F	; COLOR11
					DC.W $0000	; COLOR12
					DC.W $0000	; COLOR13
					DC.W $0000	; COLOR14
					DC.W $0000	; COLOR15
					DC.W $0000	; COLOR16	; Sprites
					DC.W $0FFF	; COLOR17
					DC.W $0F50	; COLOR18
					DC.W $0FA0	; COLOR19
					DC.W $0FF0	; COLOR20
					DC.W $0080	; COLOR21
					DC.W $07C0	; COLOR22
					DC.W $00F0	; COLOR23
					DC.W $000F	; COLOR24
					DC.W $007F	; COLOR25
					DC.W $00FF	; COLOR26
					DC.W $080F	; COLOR27
					DC.W $0F0F	; COLOR28
					DC.W $0F8F	; COLOR29
					DC.W $0000	; COLOR30
					DC.W $0F00	; COLOR31