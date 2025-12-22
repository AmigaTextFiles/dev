
; soc11.s = spriteAGA.s

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

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #((DISPLAY_DEPTH&$0007)<<12)!((DISPLAY_DEPTH&$0008)<<1)!$0201,(a0)+		; (AGA) Bit 4 : 8 bitplanes, nach DISPLAY_DEPTH
																					; (AGA) Bit 0 : Erlauben Sie Bit 15 von FMODE zu arbeiten (siehe weiter unten).
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$003F,(a0)+			; Das Playfield steht hinter allen Sprites-Paaren
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

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

	lea palette,a1
	move.w #$0000,d0			; Bit 9 bis 0: MOVEs auf COLORxx betreffen die 4 höchstwertigen Bits der Komponenten R, G und B.
	moveq #(256/32)-1,d1
_HOBitsPalettes:
	move.w #BPLCON3,(a0)+
	move.w d0,(a0)+
	addi.w #$2000,d0
	move.w #COLOR00,d2
	move.w #32-1,d3
_HOBitsPalette:
	move.w d2,(a0)+
	addq.w #2,d2
	move.w (a1),(a0)+
	lea 4(a1),a1
	dbf d3,_HOBitsPalette
	dbf d1,_HOBitsPalettes

	lea palette+2,a1
	move.w #$0200,d0			; Bit 9 bis 1: MOVEs auf COLORxx betreffen die 4 niederwertigen Bits der Komponenten R, G und B.
	moveq #(256/32)-1,d1
_LOBitsPalettes:
	move.w #BPLCON3,(a0)+
	move.w d0,(a0)+
	addi.w #$2000,d0
	move.w #COLOR00,d2
	move.w #32-1,d3
_LOBitsPalette:
	move.w d2,(a0)+
	addq.w #2,d2
	move.w (a1),(a0)+
	lea 4(a1),a1
	dbf d3,_LOBitsPalette
	dbf d1,_LOBitsPalettes

	; Sprites (AGA)

	move.w #BPLCON4,(a0)+
	move.w #$0011,(a0)+		; Bits 3-0 : bits 7-4 des 8-Bit-Startindexes der Palette der ungeraden Sprites
							; Bits 7-4 : bits 7-4 des 8-Bit-Startindex der Palette der geraden Sprites
							; NB : Die Palette für ungerade Sprites wird verwendet, wenn zwei Sprites angehängt werden
	move.w #BPLCON3,(a0)+
	move.w #$0042,(a0)+		; Bits 7-6 : Auflösung der Sprites (00: ECS-konform, 01: LOWRES, 10: HIRES, 11: SHRES).
							; Bit 1: Sprites an den Rändern des Bildschirms anzeigen (auch Bit 0 von BPLCON0 muss gesetzt werden)
	move.w #FMODE,(a0)+
	move.w #$000C,(a0)+		; Bits 3-2 : Breite der Sprites (00: 16 Pixel, 10/01: 32 Pixel, 11: 64 Pixel).
							; Bit 15 (hier nicht verwendet): Verdoppelt die Höhe von Sprites,
							; deren Bit SH10 im ersten Kontrollwort gesetzt ist.

	; Sprites

	move.w #SPR0PTH,d0
	move.l #sprites,d1
	moveq #8-1,d2
_sprites:
	move.w d0,(a0)+
	addq.w #2,d0
	swap d1
	move.w d1,(a0)+
	move.w d0,(a0)+
	addq.w #2,d0
	swap d1
	move.w d1,(a0)+
	addi.l #(SPRITE_DY+2)*16,d1
	dbf d2,_sprites

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83A0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, SPREN=1

;********** Hauptprogramm **********

	; Ein Schachbrettmuster zeichnen von 16 x 16 Rechtecken mit 20 x 16 Pixeln in 256 Farben
SQUARE_DX=20
SQUARE_PATTERN=$FFFFFFFF<<(32-SQUARE_DX)
SQUARE_DY=16

	moveq #0,d0
	movea.l bitplanes,a0
	move.w #(DISPLAY_DY/SQUARE_DY)-1,d1
_checkerDrawRows:
	movea.l a0,a1
	move.l #SQUARE_PATTERN,pattern
	moveq #0,d6
	move.w #(DISPLAY_DX/SQUARE_DX)-1,d2
_checkerDrawColumns:
	move.b d0,d3
	addq.b #1,d0
	moveq #DISPLAY_DEPTH-1,d4
	movea.l a1,a2
_checkerDrawSquare:
	lsr.b #1,d3
	bcc _checkerSkipSquareBitplane
	movea.l a2,a3
	move.l pattern,d7
	moveq #SQUARE_DY-1,d5
_checkerFillSquareBitplane:
	or.b d7,3(a3)
	ror.l #8,d7
	or.b d7,2(a3)
	ror.l #8,d7
	or.b d7,1(a3)
	ror.l #8,d7
	or.b d7,(a3)
	ror.l #8,d7
	lea DISPLAY_DX>>3(a3),a3
	dbf d5,_checkerFillSquareBitplane
_checkerSkipSquareBitplane:
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a2),a2
	dbf d4,_checkerDrawSquare
	addi.w #SQUARE_DX,d6
	move.w d6,d3
	lsr.w #3,d3
	lea (a0,d3.w),a1
	move.b d6,d3
	and.b #$07,d3
	move.l #SQUARE_PATTERN,d4
	lsr.l d3,d4
	move.l d4,pattern
	dbf d2,_checkerDrawColumns
	lea SQUARE_DY*(DISPLAY_DX>>3)(a0),a0
	dbf d1,_checkerDrawRows

	; Kopiere das Muster von Sprite 0 in die Sprites 2 und 4,
	; und das Muster von Sprite 1 in die Sprites 3 und 4.

	lea sprites+16,a0
	lea (SPRITE_DY+2)*16(a0),a1
	moveq #3-1,d0
_copySprites:
	lea (SPRITE_DY+2)*16(a1),a2
	lea (SPRITE_DY+2)*16(a2),a3
	moveq #SPRITE_DY-1,d1
_copySpritesLines:
	move.l (a0)+,(a2)+
	move.l (a0)+,(a2)+
	move.l (a0)+,(a2)+
	move.l (a0)+,(a2)+
	move.l (a1)+,(a3)+
	move.l (a1)+,(a3)+
	move.l (a1)+,(a3)+
	move.l (a1)+,(a3)+
	dbf d1,_copySpritesLines
	lea (SPRITE_DY+4)*16(a0),a0
	lea (SPRITE_DY+2)*16(a0),a1
	dbf d0,_copySprites

	; Hauptschleife

	move.w #SPRITE_X,d0
	move.w #SPRITE_Y,d1

_loop:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist (bei der
	; richtigen Zeile und der nächsten warten, da die Ausführung der
	; Schleife weniger als eine Zeile in Anspruch nimmt)

	movem.w d0,-(sp)
	move.w #DISPLAY_Y+DISPLAY_DY,d0
	bsr _waitRaster
	move.w #DISPLAY_Y+DISPLAY_DY+1,d0
	bsr _waitRaster
	movem.w (sp)+,d0

	; Sprites Positionen aktualisieren

	lea sprites,a0
	lea spritesPositions,a1
	moveq #8-1,d2
_updateSprites:

	move.w (a1)+,d0
	addi.w #DISPLAY_X,d0
	move.w (a1)+,d1
	addi.w #DISPLAY_Y,d1
	lea 4(a1),a1

	move.w d1,d3
	lsl.w #8,d3
	move.w d0,d4
	subq.w #1,d4
	lsr.w #1,d4
	move.b d4,d3
	;or.w #$0080,d3		; Um jede Zeile des Sprites zu verdoppeln, ohne die Zeile
						; in ihren Daten zu verdoppeln, wenn Bit 15 von FMODE gesetzt ist
	move.w d3,(a0)		; ((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1)

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
	or.w #$0080,d3		; Unnötig für ungerade Sprites, aber das Attachment-Bit
						; systematisch zu setzen, vereinfacht die Schleife...
	move.w d3,8(a0)		; (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)!$0080

	lea (SPRITE_DY+2)*16(a0),a0
	dbf d2,_updateSprites

	; Verschieben von Sprites indem sie sie von den Rändern abprallen lassen

	lea spritesPositions,a0
	move.w #8-1,d0
_moveSprites:

	move.w (a0),d1
	add.w 4(a0),d1
	cmpi.w #SPRITE_XMIN,d1
	bge _moveSpriteNoUnderflowX
	neg.w 4(a0)
	add.w 4(a0),d1
	bra _moveSpriteNoOverflowX
_moveSpriteNoUnderflowX:
	cmpi.w #SPRITE_XMAX,d1
	blt _moveSpriteNoOverflowX
	neg.w 4(a0)
	add.w 4(a0),d1
_moveSpriteNoOverflowX:
	move.w d1,(a0)

	move.w 2(a0),d1
	add.w 6(a0),d1
	cmpi.w #SPRITE_YMIN,d1
	bge _moveSpriteNoUnderflowY
	neg.w 6(a0)
	add.w 6(a0),d1
	bra _moveSpriteNoOverflowY
_moveSpriteNoUnderflowY:
	cmpi.w #SPRITE_YMAX,d1
	blt _moveSpriteNoOverflowY
	neg.w 6(a0)
	add.w 6(a0),d1
_moveSpriteNoOverflowY:
	move.w d1,2(a0)

	lea 8(a0),a0
	dbf d0,_moveSprites

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
sprite0:			; Die Adresse muss auf 64 Bit ausgerichtet sein
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
sprite1:			; Die Adresse muss auf 64 Bit ausgerichtet sein
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
					DC.W $0000, $0000
					DC.W $0FFF, $0FFF
					DC.W $0EEE, $0EEE
					DC.W $0DDD, $0DDD
					DC.W $0CCC, $0CCC
					DC.W $0BBB, $0BBB
					DC.W $0AAA, $0AAA
					DC.W $0999, $0999
					DC.W $0888, $0888
					DC.W $0777, $0777
					DC.W $0666, $0666
					DC.W $0555, $0555
					DC.W $0444, $0444
					DC.W $0333, $0333
					DC.W $0222, $0222
					DC.W $0111, $0111
					DC.W $0300, $0300
					DC.W $0500, $0700
					DC.W $0700, $0A00
					DC.W $0900, $0E00
					DC.W $0C00, $0700
					DC.W $0E00, $0B00
					DC.W $0F00, $0FFF
					DC.W $0F33, $0F33
					DC.W $0F55, $0FCC
					DC.W $0F88, $0F00
					DC.W $0FAA, $0F33
					DC.W $0FCC, $0FCC
					DC.W $0300, $03F0
					DC.W $0510, $07A0
					DC.W $0720, $0A50
					DC.W $0920, $0EF0
					DC.W $0C30, $07C0
					DC.W $0E40, $0B60
					DC.W $0F50, $0F7F
					DC.W $0F73, $0F03
					DC.W $0F85, $0FDC
					DC.W $0FA8, $0F60
					DC.W $0FBA, $0FF3
					DC.W $0FDC, $0FBC
					DC.W $0310, $03F0
					DC.W $0530, $0740
					DC.W $0740, $0A90
					DC.W $0950, $0EF0
					DC.W $0C70, $0770
					DC.W $0E80, $0BD0
					DC.W $0F90, $0FFF
					DC.W $0FA3, $0FD3
					DC.W $0FB5, $0FEC
					DC.W $0FC8, $0FC0
					DC.W $0FDA, $0FA3
					DC.W $0FEC, $0FBC
					DC.W $0320, $03F0
					DC.W $0540, $07F0
					DC.W $0770, $0A00
					DC.W $0990, $0E10
					DC.W $0CB0, $0760
					DC.W $0ED0, $0B70
					DC.W $0FE0, $0FBF
					DC.W $0FE3, $0FE3
					DC.W $0FF5, $0F1C
					DC.W $0FF8, $0F40
					DC.W $0FFA, $0F73
					DC.W $0FFC, $0FBC
					DC.W $0230, $0830
					DC.W $0450, $0470
					DC.W $0670, $00A0
					DC.W $0790, $0CE0
					DC.W $09C0, $0C70
					DC.W $0BE0, $08B0
					DC.W $0CF0, $0BFF
					DC.W $0DF3, $03F3
					DC.W $0DF5, $0CFC
					DC.W $0EF8, $03F0
					DC.W $0EFA, $0BF3
					DC.W $0FFC, $04FC
					DC.W $0130, $0830
					DC.W $0250, $0870
					DC.W $0370, $09A0
					DC.W $0490, $0AE0
					DC.W $05C0, $0D70
					DC.W $06E0, $0DB0
					DC.W $07F0, $0FFF
					DC.W $09F3, $02F3
					DC.W $0AF5, $08FC
					DC.W $0BF8, $0BF0
					DC.W $0CFA, $0EF3
					DC.W $0EFC, $04FC
					DC.W $0030, $0830
					DC.W $0050, $0E70
					DC.W $0170, $04A0
					DC.W $0190, $0AE0
					DC.W $02C0, $0170
					DC.W $02E0, $07B0
					DC.W $03F0, $07FF
					DC.W $05F3, $05F3
					DC.W $07F5, $07FC
					DC.W $09F8, $05F0
					DC.W $0BFA, $02F3
					DC.W $0DFC, $04FC
					DC.W $0030, $0037
					DC.W $0050, $007C
					DC.W $0071, $00A0
					DC.W $0091, $00E5
					DC.W $00C1, $007B
					DC.W $00E1, $00BF
					DC.W $00F2, $0FFF
					DC.W $03F4, $03FE
					DC.W $05F7, $0CF2
					DC.W $08F9, $00F1
					DC.W $0AFA, $03FF
					DC.W $0CFD, $0CF3
					DC.W $0031, $0037
					DC.W $0052, $0077
					DC.W $0073, $00A7
					DC.W $0094, $00E7
					DC.W $00C5, $007A
					DC.W $00E6, $00BA
					DC.W $00F7, $0FFB
					DC.W $03F8, $03FF
					DC.W $05FA, $0CF5
					DC.W $08FB, $00F9
					DC.W $0AFC, $03FD
					DC.W $0CFE, $0CF3
					DC.W $0032, $0036
					DC.W $0054, $0071
					DC.W $0075, $00AC
					DC.W $0097, $00E7
					DC.W $00C9, $0075
					DC.W $00EB, $00B0
					DC.W $00FC, $0FF3
					DC.W $03FC, $03FC
					DC.W $05FD, $0CF6
					DC.W $08FD, $00FF
					DC.W $0AFE, $03F8
					DC.W $0CFF, $0CF2
					DC.W $0033, $0003
					DC.W $0055, $0017
					DC.W $0077, $002A
					DC.W $0099, $004E
					DC.W $00BC, $00A7
					DC.W $00DE, $00BB
					DC.W $00EF, $0FFF
					DC.W $03FF, $031F
					DC.W $05FF, $0C4F
					DC.W $08FF, $007F
					DC.W $0AFF, $039F
					DC.W $0CFF, $0CCF
					DC.W $0023, $0003
					DC.W $0035, $0077
					DC.W $0047, $00EA
					DC.W $0069, $004E
					DC.W $007C, $00E7
					DC.W $009E, $005B
					DC.W $00AF, $0F7F
					DC.W $03BF, $034F
					DC.W $05CF, $0C3F
					DC.W $08DF, $000F
					DC.W $0ADF, $03DF
					DC.W $0CEF, $0CCF
					DC.W $0013, $0003
					DC.W $0015, $00B7
					DC.W $0027, $007A
					DC.W $0039, $002E
					DC.W $003C, $00F7
					DC.W $004E, $00AB
					DC.W $005F, $0FBF
					DC.W $037F, $034F
					DC.W $058F, $0CFF
					DC.W $08AF, $008F
					DC.W $0ACF, $030F
					DC.W $0CDF, $0CCF
					DC.W $0003, $0013
					DC.W $0005, $0017
					DC.W $0007, $002A
					DC.W $0009, $003E
					DC.W $000C, $0037
					DC.W $000E, $004B
					DC.W $001F, $0F3F
					DC.W $033F, $036F
					DC.W $055F, $0CFF
					DC.W $088F, $002F
					DC.W $0AAF, $035F
					DC.W $0CCF, $0CDF
					DC.W $0003, $0E03
					DC.W $0105, $0907
					DC.W $0207, $030A
					DC.W $0209, $0D0E
					DC.W $030C, $0807
					DC.W $040E, $020B
					DC.W $050F, $03FF
					DC.W $063F, $0D3F
					DC.W $085F, $0ACF
					DC.W $0A8F, $040F
					DC.W $0BAF, $0D3F
					DC.W $0DCF, $0ACF
					DC.W $0103, $0F03
					DC.W $0305, $0407
					DC.W $0407, $090A
					DC.W $0509, $0F0E
					DC.W $070C, $0707
					DC.W $080E, $0D0B
					DC.W $090F, $0FFF
					DC.W $0A3F, $0D3F
					DC.W $0B5F, $0ECF
					DC.W $0C8F, $0C0F
					DC.W $0DAF, $0A3F
					DC.W $0ECF, $0BCF
					DC.W $0203, $0E03
					DC.W $0405, $0E07
					DC.W $0607, $0E0A
					DC.W $0809, $0E0E
					DC.W $0B0C, $0307
					DC.W $0D0E, $030B
					DC.W $0E0F, $07FF
					DC.W $0E3F, $0B3F
					DC.W $0E5F, $0FCF
					DC.W $0F8F, $020F
					DC.W $0FAF, $063F
					DC.W $0FCF, $0ACF
					DC.W $0302, $0308
					DC.W $0504, $0704
					DC.W $0706, $0A00
					DC.W $0907, $0E0C
					DC.W $0C09, $070C
					DC.W $0E0B, $0B08
					DC.W $0F0C, $0FFB
					DC.W $0F3D, $0F33
					DC.W $0F5D, $0FCC
					DC.W $0F8E, $0F03
					DC.W $0FAE, $0F3B
					DC.W $0FCF, $0FC4
					DC.W $0301, $0309
					DC.W $0502, $070A
					DC.W $0703, $0A0B
					DC.W $0904, $0E0C
					DC.W $0C06, $0700
					DC.W $0E07, $0B01
					DC.W $0F08, $0FF3
					DC.W $0F39, $0F36
					DC.W $0F5A, $0FCB
					DC.W $0F8B, $0F0D
					DC.W $0FAD, $0F30
					DC.W $0FCE, $0FC5
					DC.W $0300, $0309
					DC.W $0500, $070E
					DC.W $0701, $0A04
					DC.W $0901, $0E0A
					DC.W $0C02, $0701
					DC.W $0E02, $0B07
					DC.W $0F03, $0FF7
					DC.W $0F35, $0F35
					DC.W $0F57, $0FC7
					DC.W $0F89, $0F05
					DC.W $0FAB, $0F33
					DC.W $0FCD, $0FC5
spritesPositions:
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 2, 1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 2, 1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, -1, -2
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, -1, -2
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 3, -1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 3, -1
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 1, 3
					DC.W (DISPLAY_DX-SPRITE_DX)>>1, (DISPLAY_DY-SPRITE_DY)>>1, 1, 3
pattern:			DC.L 0