
; soc07_angep.s = sprite16.s

; Programmiert von Yragael für Stash of Code (http://www.stashofcode.fr) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Anzeige und Bewegung eines 16-Farben-Sprites, das aus den Sprites 0 und 1 besteht,
; auf einer Bitplane (beachten Sie, dass BPL2MOD nicht verwendet wird, da nur eine
; Bitplane verwendet wird, die zwangsläufig ungerade ist, da es sich um Bitplane 1 handelt).

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=1
COPSIZE=9*4+DISPLAY_DEPTH*2*4+18*4+8*2*4+4
	; 9*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		für Adressen der Bitebenen
	; 18*4					Palette (Farben 0-1 für Bitplane, 16-31 für Sprite)
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
SPRITE_X=DISPLAY_X+14		; SPRITE_X-1 wird kodiert, da die Anzeige von Bitplanes durch
							; die Hardware um ein Pixel gegenüber der Anzeige von Sprites
							; verzögert wird (nicht dokumentiert).
SPRITE_Y=DISPLAY_Y+14
SPRITE_DX=16				; kann nicht verändert werden
SPRITE_DY=16
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
	
	move.w #COLOR00,(a0)+				; Palette
	move.w #$0000,(a0)+
	move.w #COLOR01,(a0)+
	move.w #$0777,(a0)+

	lea spritePalette,a1
	move.w #COLOR16,d0
	moveq #16-1,d1
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

	move.l #sprite1,d0
	move.w #SPR1PTL,(a0)+
	move.w d0,(a0)+
	move.w #SPR1PTH,(a0)+
	swap d0
	move.w d0,(a0)+
	
	move.l #spriteVoid,d0				; Sprites (alle Sprites werden angezeigt, daher unbenutzte Sprites mit Daten Null anzeigen)
	move.w #SPR1PTL,d1
	REPT 12
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

	; Ein Schachbrettmuster zeichnen

	movea.l bitplane,a0
	move.l #$FFFF0000,d3				; Muster
	move.w #(DISPLAY_DY>>4)-1,d0		; 256/2^4=16 oder 256/16=16  d.h. 16 x 16 Zeilen
_drawCheckerY:
	move.w #16-1,d1						; jeweils über 16 Zeilen
_drawChecker16:
	moveq #(DISPLAY_DX>>5)-1,d2			; 320/2^5=10 oder 320/32=10 x 16Bit-Muster wiederholen
_drawCheckerX:
	move.l d3,(a0)+
	dbf d2,_drawCheckerX
	dbf d1,_drawChecker16
	swap d3								; $FFFF0000 --> $0000FFFF (Muster vertauschen)
	dbf d0,_drawCheckerY

	; Hauptschleife

	move.w #SPRITE_X,d0
	move.w #SPRITE_Y,d1

_loop:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist
	; (bei der richtigen Zeile und der nächsten warten, da die Ausführung
	; der Schleife weniger als eine Zeile in Anspruch nimmt)

	movem.w d0,-(sp)
	move.w #DISPLAY_Y+DISPLAY_DY,d0		; ($2c+256)		; auf die Zeile warten
	bsr _waitRaster
	move.w #DISPLAY_Y+DISPLAY_DY+1,d0	; ($2c+256+1)	; und auf die nächste Zeile warten
	bsr _waitRaster
	movem.w (sp)+,d0

	; Die Position von Sprites aktualisieren

	lea sprite0,a0
	lea sprite1,a1

	move.w d1,d2						; Kopie Sprite_y
	lsl.w #8,d2							; ins hohe Byte verschieben = SV7-SV0
	move.w d0,d3						; Kopie Sprite_x
	subq.w #1,d3						; SPRITE_X-1
	lsr.w #1,d3							; nach rechts verschieben = SH8-SH1 
	move.b d3,d2						; d2 zusammenbauen
	move.w d2,(a0)+						; ((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1)
	move.w d2,(a1)+						; ((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1)
										; = dc.w VSTART,HSTART

	move.w d1,d2						; Kopie Sprite_y
	addi.w #SPRITE_DY,d2				; SPRITE_Y+SPRITE_DY
	move.w d2,d4						; Kopie SPRITE_Y+SPRITE_DY
	lsl.w #8,d2							; ins hohe Byte verschieben = EV7-EV0
	move.w d1,d3						; Kopie Sprite_x
	lsr.w #6,d3							; ins Byte SPTCTL verschieben	
	and.b #$04,d3						; nur Bit SV8 
	move.b d3,d2						; Ergebnis ins Ziel SPTCTL
	lsr.w #7,d4							; SPRITE_Y+SPRITE_DY ins Byte SPTCTL verschieben
	and.b #$02,d4						; nur Bit EV8
	or.b d4,d2							; zusammen mit SV8 in einem Byte
	move.w d0,d3						; Kopie Sprite_x
	subq.w #1,d3						; SPRITE_X-1
	and.b #$01,d3						; nur Bit SH0 
	or.b d3,d2							; d2 zusammenbauen
	move.w d2,(a0)						; (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)
	or.w #$0080,d2						; Attached-Bit
	move.w d2,(a1)						; (((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1)!$0080
										; = dc.w VEND,SPTCTL
		
	; Verschieben von Sprites

	addq.w #1,d0						; Sprite_x + 1
	cmpi.w #DISPLAY_X+DISPLAY_DX,d0		; hat Sprite Bildschirmrand rechts verlassen?
	ble _spriteNoOverflowX				; wenn ja, Position auf Anfang setzen
	move.w #DISPLAY_X-SPRITE_DX+1,d0	; Spriteposition x auf Anfang setzen ($81-16+1)
_spriteNoOverflowX:
	addq.w #1,d1						; Sprite_y + 1
	cmpi.w #DISPLAY_Y+DISPLAY_DY,d1		; hat Sprite Bildschirmrand unten verlassen?
	ble _spriteNoOverflowY				; wenn ja, Position auf Anfang setzen
	move.w #DISPLAY_Y-SPRITE_DY+1,d1	; Spriteposition y auf Anfang setzen ($2c-16+1) 
_spriteNoOverflowY:

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
sprite0:
					DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)

					REPT 4
					DC.W $0F0F, $00FF
					ENDR
					REPT 4
					DC.W $0F0F, $00FF
					ENDR
					REPT 4
					DC.W $0F0F, $00FF
					ENDR
					REPT 4
					DC.W $0F0F, $00FF
					ENDR
					DC.W 0, 0
sprite1:
					DC.W (VSTART<<8)!(HSTART)
					DC.W (VEND<<8)!(SPTCTL)					
					REPT 4
					DC.W $0000, $0000
					ENDR
					REPT 4
					DC.W $FFFF, $0000
					ENDR
					REPT 4
					DC.W $0000, $FFFF
					ENDR
					REPT 4
					DC.W $FFFF, $FFFF
					ENDR
					DC.W 0, 0
spriteVoid:
					DC.W 0, 0
spritePalette:
					DC.W $0000, $0F00, $0F50, $0FA0, $0FF0, $0080, $07C0, $00F0
					DC.W $000F, $007F, $00FF, $080F, $0F0F, $0F8F, $0000, $0FFF
