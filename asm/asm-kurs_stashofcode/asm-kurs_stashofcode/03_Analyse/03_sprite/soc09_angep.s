
; soc09_angep.s = triplePlayfields.s

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
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-16-17)>>1)&$00FC										; oder &$00F8
DDFSTOP_val = ((DISPLAY_X-16-17+((((DISPLAY_DX+16)>>4)-1)<<4))>>1)&$00FC		; oder &$00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0600		; DPF=1, COLOR=1		; (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = 0
BPLCON2_val = $001B							; PF2PRI=0, PF2P2-0=%011, PF1P2-0=%011 
											; (PF2P2 und PF1P2 müssen auf dem A500 auf 0 stehen, da sonst
											; die Playfields nicht mehr sichtbar sind. Dies ist ein nicht
											; dokumentiertes "Feature" der Hardware.
											; Siehe http://eab.abime.net/showthread.php?t=19676)
BPL1MOD_val = 0
BPL2MOD_val = 0
;----------------------------------------------------------
SPRITE_X=DISPLAY_X-1
SPRITE_Y=DISPLAY_Y
SPRITE_DX=16								; kann nicht verändert werden
SPRITE_DY=32
;----------------------------------------------------------
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

	move.w #DIWSTRT,(a0)+				; Konfiguration des Bildschirms				
	move.w #DIWSTRT_val,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #DIWSTOP_val,(a0)+
										; BBPLCON wird durchs Hauptprogramm geändert, daher kann die
										; Reihenfolge hier nicht getauscht werden
	move.w #BPLCON0,(a0)+
	move.w #BPLCON0_val,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #BPLCON1_val,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #BPLCON2_val,(a0)+		
	
	move.w #DDFSTRT,(a0)+
	move.w #DDFSTRT_val,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #DDFSTOP_val,(a0)+

	move.w #BPL1MOD,(a0)+
	move.w #BPL1MOD_val,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #BPL2MOD_val,(a0)+

	move.l #$01FC0000,(a0)+				; Kompatibilität OCS mit AGA

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
	move.w #DISPLAY_DY-1,d1					; 256-1 Zeilen
_copperListSpriteY:
	move.w d0,(a0)+							; dc.w $2c39
	move.w #$FFFE,(a0)+						; dc.w $2c39,$FFFE (wait)
	move.w #((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1),d2		; $2C40
	move.w #SPR0POS,d3						; SPR0POS = $0140
	move.w #(DISPLAY_DX>>4)-1,d4			; (320/8)-1 = 40 Bytes Bildschrimbreite - Schleifenzähler
_copperListSpriteX:
	move.w d3,(a0)+							; SPR0POS in Copperliste kopieren
	move.w d2,(a0)+							; XY-Pos in Copperliste kopieren z.b. "2C40,2C48,2C50,2C58" usw.)
	addq.w #8,d3							; nächstes SPRxPOS-Register
	move.w d3,(a0)+							; SPR0POS in Copperliste kopieren
	move.w d2,(a0)+							; XY-Pos in Copperliste kopieren, an selbe Position (attached)
	addq.w #8,d3							; nächstes SPRxPOS-Register
	cmpi.w #SPR6POS,d3						; Da Sprite 7 nicht verwendbar ist, werden nur die Spritespaare 0&1, 2&3 und 3&4 verwendet.
	bne _copperListSpriteNoReset			; 
	move.w #SPR0POS,d3						; wieder auf SPR0POS zurücksetzen
_copperListSpriteNoReset:	
	addi.w #16>>1,d2						; +8 Bytes vorwärts 
	dbf d4,_copperListSpriteX				; über gesamte Zeile 40 Bytes
	addi.w #$0100,d0						; nächste Zeile
	dbf d1,_copperListSpriteY				; über alle Zeilen

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83E0,DMACON(a5)				; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1, SPREN=1

;********** Hauptprogramm **********

; NB: Achtung! Der DMA des Blitters wurde nicht aktiviert...

; Ein Schachbrettmuster zeichnen
; ToDo in den letzten 16 Pixeln wird momentan nichts gezeichnet....
	movea.l bitplanes,a0						; Anfangsadresse der Bitebenen
	lea DISPLAY_DY*((DISPLAY_DX+16)>>3)(a0),a1	; +256*((320+16)/8) Offset, Zeiger auf 2. Bitebene
	lea DISPLAY_DY*((DISPLAY_DX+16)>>3)(a1),a2	; +256*((320+16)/8) Offset, Zeiger auf 3. Bitebene
	lea DISPLAY_DY*((DISPLAY_DX+16)>>3)(a2),a3	; +256*((320+16)/8) Offset, Zeiger auf 4. Bitebene
	move.l #$FFFF0000,d3				; Muster d3 = $FFFF.0000 = 32 Bits
	moveq #0,d4							; Muster d4 = $0000.0000
	moveq #-1,d5						; Muster d5 = $FFFF.FFFF
	move.w #(DISPLAY_DY>>4)-1,d0		; 256/16-1 = 16 Reihen Schleifenzähler	
_drawCheckerY:
	move.w #16-1,d1						; 16-1 = 16 Zeilen Schleifenzähler
_drawChecker16:							; 
	moveq #(DISPLAY_DX>>5)-1,d2			; 320/32-1 = 10 Wörter für eine Zeile Schleifenzähler
_drawCheckerX:							; 
	move.l d3,(a0)+						; Muster in 1. Bitebene kopieren
	move.l d3,(a1)+						; Muster in 2. Bitebene kopieren
	move.l d4,(a2)+						; Muster in 3. Bitebene kopieren
	move.l d4,(a3)+						; Muster in 4. Bitebene kopieren
	dbf d2,_drawCheckerX				; für alle 10 Spalten wiederholen	
	swap d3								; Muster tauschen $FFFF0000 --> $0000FFFF 
	move.w d3,(a0)+						; Muster in 1. Bitebene kopieren
	move.w d3,(a1)+						; Muster in 2. Bitebene kopieren
	swap d3								; Muster tauschen $0000FFFF --> $FFFF0000
	swap d4								; Muster tauschen
	move.w d4,(a2)+						; Muster in 3. Bitebene kopieren
	move.w d4,(a3)+						; Muster in 4. Bitebene kopieren
	swap d4								; Muster tauschen	
	dbf d1,_drawChecker16				; für alle 16 Zeilen wiederholen	
	swap d3								; Muster tauschen $FFFF0000 --> $0000FFFF 
	exg d4,d5							; tauscht Inhalt von d4.l und d5.l
	dbf d0,_drawCheckerY				; für alle 16 Reihen wiederholen

	; Hauptschleife

	moveq #15,d0				; PF1 (Scrollwert zwischen 0 und 15 Pixel)
	moveq #-1,d1				; Geschwindigkeit PF1
	moveq #0,d2					; PF2 (Scrollwert zwischen 0 und 15 Pixel)
	moveq #1,d3					; Geschwindigkeit PF2
_loop:
	
	; Scrollen durch die playfields

	move.w d2,d4				; Kopie Scrollwert PF2
	lsl.b #4,d4					; um vier Bits verschieben um in das Register BPLCON1 zu kommen
	or.b d0,d4					; BPLCON1 Wert für PF1 und PF2 zusammenbauen
	movea.l copperlist,a0		; Anfangsadresse copperlist
	move.w d4,3*4+2(a0)			; BPLCON1 Wert in die Copperliste kopieren

	add.b d1,d0					; PF1 - Scrollwert ändern 
	bge _scrollPF1Positive		; wenn > 0, dann überspringen
	neg.b d1					; Richtungsumkehr
	add.b d1,d0					; PF1 - Scrollwert ändern
	bra _scrollPF1Done			; wenn hier, dann überspringen
_scrollPF1Positive:
	cmpi.b #15,d0				; maximaler Scrollwert erreicht?
	ble _scrollPF1Done			; wenn > 15
	neg.b d1					; Richtungsumkehr
	add.b d1,d0					; PF1 - Scrollwert ändern
_scrollPF1Done:

	add.b d3,d2					; PF2 - Scrollwert ändern
	bge _scrollPF2Positive		; wenn > 0, dann überspringen
	neg.b d3					; Richtungsumkehr
	add.b d3,d2					; PF2 - Scrollwert ändern
	bra _scrollPF2Done			; wenn hier, dann überspringen
_scrollPF2Positive:
	cmpi.b #15,d2				; maximaler Scrollwert erreicht?
	ble _scrollPF2Done			; wenn > 15
	neg.b d3					; Richtungsumkehr
	add.b d3,d2					; PF2 - Scrollwert ändern
_scrollPF2Done:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist
	; (bei der richtigen Zeile und der nächsten warten, da die
	; Ausführung der Schleife weniger als eine Zeile in Anspruch nimmt)

	movem.w d0,-(sp)
	move.w #DISPLAY_Y+DISPLAY_DY,d0		; ($2c+256)		; auf die Zeile warten
	bsr _waitRaster
	move.w #DISPLAY_Y+DISPLAY_DY+1,d0	; ($2c+256+1)	; und auf die nächste Zeile warten
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
spriteA0:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)
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
spriteA1:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)!$0080
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
spriteB0:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)
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
spriteB1:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)!$0080
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
spriteC0:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)
					; Zahl 3
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
spriteC1:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)!$0080
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
spriteD0:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)!$0080
					; Zahl 4
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
spriteD1:			DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)!$0080
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


	end


Programmbeschreibung:

Zuerst zu den Sprites. Im Datenbereich werden die Daten der 8 Sprites 
vorgehalten und zwar als SpriteA0,A1 (0,1), SpriteB0,B1 (2,3) 
SpriteC0,C1 (4,5), SpriteD0,D1 (6,7). Die Spritepaare werden durch das
attached-Bit im zweiten Steuerwort des zweiten Sprites miteinander verbunden,
sodass grundsätzlich 15 Farben plus 1 transparent dargestellt werden. Die
Sprites selbst zeigen im oberen Bereich eine Zahl und im unteren kleine
Quadrate. Das Spritepaar 6,7 kann aufgrund des Hardwarescrolls und dem damit 
verbundenen früheren DDFSTRT nicht verwendet werden.

Die Spritedaten werden über DMA gelesen und mit den Bilddaten der Bitplanes,
den Playfields entsprechend der Playfield-Sprite-Priorität angezeigt.
Kern des Tricks, ist die Spritedaten durch horizontale Neupositionierung 
mittels SPRxPOS durch die Copperliste mehrfach auf dem Bildschirm auszugeben. 

Auszug Copperliste:

 00024930: 2c39 fffe            ;  Wait for vpos >= 0x2c and hpos >= 0x38
                                ;  VP 2c, VE 7f; HP 38, HE fe; BFD 1
 00024934: 0140 2c40            ;  SPR0POS := 0x2c40		; $40 = 64 2+64=128
 00024938: 0148 2c40            ;  SPR1POS := 0x2c40
 0002493c: 0150 2c48            ;  SPR2POS := 0x2c48		; $48 = 72 2*72=144		
 00024940: 0158 2c48            ;  SPR3POS := 0x2c48		; 144-128=16, d.h. 16 Pixel weiter rechts
 00024944: 0160 2c50            ;  SPR4POS := 0x2c50
 00024948: 0168 2c50            ;  SPR5POS := 0x2c50
 0002494c: 0140 2c58            ;  SPR0POS := 0x2c58
 00024950: 0148 2c58            ;  SPR1POS := 0x2c58
 00024954: 0150 2c60            ;  SPR2POS := 0x2c60
 00024958: 0158 2c60            ;  SPR3POS := 0x2c60		; 10
 0002495c: 0160 2c68            ;  SPR4POS := 0x2c68
 00024960: 0168 2c68            ;  SPR5POS := 0x2c68
 00024964: 0140 2c70            ;  SPR0POS := 0x2c70
 00024968: 0148 2c70            ;  SPR1POS := 0x2c70
 0002496c: 0150 2c78            ;  SPR2POS := 0x2c78
 00024970: 0158 2c78            ;  SPR3POS := 0x2c78
 00024974: 0160 2c80            ;  SPR4POS := 0x2c80
 00024978: 0168 2c80            ;  SPR5POS := 0x2c80
 0002497c: 0140 2c88            ;  SPR0POS := 0x2c88
 00024980: 0148 2c88            ;  SPR1POS := 0x2c88		; 20
 00024984: 0150 2c90            ;  SPR2POS := 0x2c90
 00024988: 0158 2c90            ;  SPR3POS := 0x2c90
 0002498c: 0160 2c98            ;  SPR4POS := 0x2c98
 00024990: 0168 2c98            ;  SPR5POS := 0x2c98
 00024994: 0140 2ca0            ;  SPR0POS := 0x2ca0
 00024998: 0148 2ca0            ;  SPR1POS := 0x2ca0
 0002499c: 0150 2ca8            ;  SPR2POS := 0x2ca8
 000249a0: 0158 2ca8            ;  SPR3POS := 0x2ca8
 000249a4: 0160 2cb0            ;  SPR4POS := 0x2cb0
 000249a8: 0168 2cb0            ;  SPR5POS := 0x2cb0		; 30
 000249ac: 0140 2cb8            ;  SPR0POS := 0x2cb8
 000249b0: 0148 2cb8            ;  SPR1POS := 0x2cb8
 000249b4: 0150 2cc0            ;  SPR2POS := 0x2cc0
 000249b8: 0158 2cc0            ;  SPR3POS := 0x2cc0
 000249bc: 0160 2cc8            ;  SPR4POS := 0x2cc8
 000249c0: 0168 2cc8            ;  SPR5POS := 0x2cc8
 000249c4: 0140 2cd0            ;  SPR0POS := 0x2cd0
 000249c8: 0148 2cd0            ;  SPR1POS := 0x2cd0
 000249cc: 0150 2cd8            ;  SPR2POS := 0x2cd8
 000249d0: 0158 2cd8            ;  SPR3POS := 0x2cd8		; 40
 000249d4: 2d39 fffe            ;  Wait for vpos >= 0x2d and hpos >= 0x38
                                ;  VP 2d, VE 7f; HP 38, HE fe; BFD 1
 000249d8: 0140 2c40            ;  SPR0POS := 0x2c40
 000249dc: 0148 2c40            ;  SPR1POS := 0x2c40
 000249e0: 0150 2c48            ;  SPR2POS := 0x2c48
 000249e4: 0158 2c48            ;  SPR3POS := 0x2c48
 000249e8: 0160 2c50            ;  SPR4POS := 0x2c50
 000249ec: 0168 2c50            ;  SPR5POS := 0x2c50
 000249f0: 0140 2c58            ;  SPR0POS := 0x2c58
 000249f4: 0148 2c58            ;  SPR1POS := 0x2c58
 000249f8: 0150 2c60            ;  SPR2POS := 0x2c60
 000249fc: 0158 2c60            ;  SPR3POS := 0x2c60
 00024a00: 0160 2c68            ;  SPR4POS := 0x2c68
 00024a04: 0168 2c68            ;  SPR5POS := 0x2c68
>

Die Copperliste ist dabei so aufgebaut, dass auf den Beginn einer Zeile gewartet wird
und dann eine Folge von 40 Moves kommt. Während der 40 Moves werden die horizontalen
Sprite-Positionswerte der 6 Sprites Spr0 bis Spr5 geändert. 

z.B.
 00024934: 0140 2c40            ;  SPR0POS := 0x2c40		; $40 = 64 2+64=128
 00024938: 0148 2c40            ;  SPR1POS := 0x2c40
 0002493c: 0150 2c48            ;  SPR2POS := 0x2c48		; $48 = 72 2*72=144		
 00024940: 0158 2c48            ;  SPR3POS := 0x2c48		; 144-128=16, d.h. 16 Pixel weiter rechts
 00024944: 0160 2c50            ;  SPR4POS := 0x2c50
 00024948: 0168 2c50            ;  SPR5POS := 0x2c50
 0002494c: 0140 2c58            ;  SPR0POS := 0x2c58
 
Die vertikale Position $2c bleibt unverändert und ist nur für die erste Zeile
von Bedeutung. Ab der zweite Zeile bis zum Ende des Sprites kann dieser Wert
beliebig sein, z.B. auch 0 (SPR0POS := 0x0040). Die Hardware liest nur noch
die horizontale Positionswerte.

Die 40 erhöht sich jeweils um 8 Byte bezogen auf das nächste Spritepaar. Der  
Hintergrund ist folgender: Die Pixelbreite für ein Sprite ist mit 16 Pixel 
fest. Die $40 entsprechen der Pixelposition 128 auf dem Bildschirm.
($40=64 2*64=128) Die nächste horizontale Position ist $48=72, d.h. 2*72=144 
Daraus ergibt sich der horizontale Abstand von 16 Pixeln 144-128=16.

Würde man auf die Wiedeholung der SPRxPOS ab der zweiten Zeile verzichten,
würden nur die letzten Sprites angezeigt werden.

Nun zum Dualplayfield:
Im BPLCON0 wurde Dualplayfieldmode mit 4 Bitebenen eingestellt, d.h. jeweils
zwei Bitebenen für jedes einzelne Playfield aufgrund der DMA-Zyklen.
Ab 5 Bitebenen würden dem Copper Zyklen fehlen. Für die 4 Bitebenen wurde 
entsprechender Speicher reserviert.

BPLCON2 wurde mit $1b geladen, d.h. PF2PRI=0, PF2P2-0=%011, PF1P2-0=%011 
was bedeutet, dass die Spritepaare 0,1 2,3, 4,5 vor Playfield 1 vor
Playfield 2 liegen und nur das Spritepaar 6,7 hinter allem liegt.						
 
; PF2PRI=0, PF2P2-0=%011, PF1P2-0=%011  (%011011 = $1B)
; (PF2P2 und PF1P2 müssen auf dem A500 auf 0 stehen, da sonst
; die Playfields nicht mehr sichtbar sind. Dies ist ein nicht
; dokumentiertes "Feature" der Hardware.
; Siehe http://eab.abime.net/showthread.php?t=19676)

; Testen andere Kombinationen:
%111111 = $3F  - Playfields nicht mehr sichtbar
%101101 = $2D  - Playfields nicht mehr sichtbar
%100100 = $24  - Playfields sind sichtbar

Das zuvor angelegte Schachbrettmuster wird nun in der Hauptschleife durch
den Hardwarescroll der Playfields bewegt.
  

