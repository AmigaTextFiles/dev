
; soc12.s = bobRAW.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Anzeige und Verschieben eines 32 x 32 Pixel großen BOB in 32 Farben auf einem
; Hintergrund aus 5 Bitplanes im RAW-Modus, mit Maskierung.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=5
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; 4						$FFFFFFFE
BOB_X=DISPLAY_DX>>1
BOB_Y=DISPLAY_DY>>1
BOB_DX=64
BOB_DY=64
BOB_DEPTH=DISPLAY_DEPTH
DEBUG=1

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
	move.l d0,copperlist

	; Speicher in Chip zuweisen auf 0 gesetzt für Hintergrund (background)

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,background

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt (für Anzeige) (front buffer)

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanesA
	move.l bitplanesA,frontBuffer

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt (für Erstellung) (back buffer)

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanesB
	move.l bitplanesB,backBuffer

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
	move.w #0,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+	; Dies entspricht ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC,
																		; wenn DISPLAY_DX ein Vielfaches von 16 ist.
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l frontBuffer,d1
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

	; Palette

	lea palette,a1
	move.w #COLOR00,d0
	moveq #(1<<DISPLAY_DEPTH)-1,d1
	IFNE DEBUG				; Füge einen unnötigen MOVE hinzu, der COLOR00 nicht beeinflusst, 
							; um die Größe der Copperliste nicht zu verändern (kann nützlich sein)
	addq.w #2,d0
	move.w d0,(a0)+
	move.w (a1)+,(a0)+
	subq.w #1,d1
	ENDIF
_palette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_palette

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

;********** Hauptprogramm **********

	; Zeichnen Sie den Hintergrund aus 16 x 16 Quadraten aufeinanderfolgender
	; Farben, die auf Farbe 0 zurückspringen.

	moveq #0,d0
	movea.l background,a0
	move.w #(DISPLAY_DY>>4)-1,d1
_checkerDrawRows:
	move.w #(DISPLAY_DX>>4)-1,d2
_checkerDrawCols:
	move.b d0,d3
	movea.l a0,a1
	move.w #DISPLAY_DEPTH-1,d4
_checkerDrawBitplanes:
	lsr.b #1,d3
	bcc _checkerSkipBitplane
	movea.l a1,a2
	move.w #16-1,d5
_checkerDrawLines:
	move.w #$FFFF,(a2)
	lea DISPLAY_DX>>3(a2),a2
	dbf d5,_checkerDrawLines
_checkerSkipBitplane:
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a1),a1
	dbf d4,_checkerDrawBitplanes
	lea 2(a0),a0
	addq.b #1,d0
	dbf d2,_checkerDrawCols
	lea 15*(DISPLAY_DX>>3)(a0),a0
	dbf d1,_checkerDrawRows
	
	; Kopieren Sie den Hintergrund in den Front- und Backpuffer.

	move.w #0,BLTBMOD(a5)
	move.w #0,BLTDMOD(a5)
	move.w #$05CC,BLTCON0(a5)	; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.l background,a0
	move.l frontBuffer,a1
	move.l backBuffer,a2
	move.w #DISPLAY_DEPTH-1,d0
_copyBackground:
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	move.l a0,BLTBPTH(a5)
	move.l a2,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a1),a1
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a2),a2
	dbf d0,_copyBackground

	; Hauptschleife

_loop:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist

	move.w #DISPLAY_Y+DISPLAY_DY,d0
	bsr _waitRaster

	; Debugging: Hintergrundfarbe am Anfang der Schleife auf rot ändern

	IFNE DEBUG
	move.w #$0F00,COLOR00(a5)
	ENDIF
	
	; Front- und Backpuffer umkehren

	move.l backBuffer,d0
	move.l frontBuffer,backBuffer
	move.l d0,frontBuffer
	movea.l copperlist,a0
	lea 10*4+2(a0),a0
	moveq #DISPLAY_DEPTH-1,d1
_swapBuffers:
	swap d0
	move.w d0,(a0)
	swap d0
	move.w d0,4(a0)
	lea 8(a0),a0
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	dbf d1,_swapBuffers

	; Löschen der Zeilen im Backpuffer, in denen sich der Bob befand (recover not sophisticated!).

	move.w #0,BLTBMOD(a5)
	move.w #0,BLTDMOD(a5)
	move.w #$05CC,BLTCON0(a5)	; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.l background,a0
	move.w bobY+2,d0
	mulu #DISPLAY_DX>>3,d0
	add.l d0,a0
	move.l backBuffer,a1
	add.l d0,a1
	move.w #DISPLAY_DEPTH-1,d0
_clearBob:
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #(BOB_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a1),a1
	dbf d0,_clearBob

	; Bewegen Sie den BOB, indem Sie ihn von den Rändern abprallen lassen.

	move.w bobX,d0
	move.w d0,bobX+2
	add.w bobSpeedX,d0
	bge _moveBobNoUnderflowX
	neg.w bobSpeedX
	add.w bobSpeedX,d0
	bra _moveBobNoOverflowX
_moveBobNoUnderflowX:
	cmpi.w #DISPLAY_DX-BOB_DX,d0
	blt _moveBobNoOverflowX
	neg.w bobSpeedX
	add.w bobSpeedX,d0
_moveBobNoOverflowX:
	move.w d0,bobX

	move.w bobY,d0
	move.w d0,bobY+2
	add.w bobSpeedY,d0
	bge _moveBobNoUnderflowY
	neg.w bobSpeedY
	add.w bobSpeedY,d0
	bra _moveBobNoOverflowY
_moveBobNoUnderflowY:
	cmpi.w #DISPLAY_DY-BOB_DY,d0
	blt _moveBobNoOverflowY
	neg.w bobSpeedY
	add.w bobSpeedY,d0
_moveBobNoOverflowY:
	move.w d0,bobY

	; BOB zeichnen

	moveq #0,d1
	move.w bobX,d0
	move.w d0,d1
	and.w #$F,d0
	ror.w #4,d0
	move.w d0,BLTCON1(a5)		; BSH3-0=Verschiebung
	or.w #$0FF2,d0
	move.w d0,BLTCON0(a5)		; ASH3-0=Verschiebung, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	lsr.w #3,d1
	and.b #$FE,d1
	move.w bobY,d0
	mulu #DISPLAY_DX>>3,d0
	add.w d1,d0

	lea bob,a0
	lea mask,a1
	movea.l backBuffer,a2
	addi.l d0,a2
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$0000,BLTALWM(a5)
	move.w #-2,BLTAMOD(a5)
	move.w #0,BLTBMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTCMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTDMOD(a5)
	move.w #BOB_DEPTH-1,d0
_drawBobBitplanes:
	move.l a0,BLTAPTH(a5)
	move.l a1,BLTBPTH(a5)
	move.l a2,BLTCPTH(a5)
	move.l a2,BLTDPTH(a5)
	move.w #(BOB_DY<<6)!((BOB_DX+16)>>4),BLTSIZE(a5)
	WAIT_BLITTER
	addi.l #BOB_DY*(BOB_DX>>3),a0
	addi.l #BOB_DY*((BOB_DX+16)>>3),a1
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),a2
	dbf d0,_drawBobBitplanes

	; Debugging: Hintergrundfarbe am Ende der Schleife auf grün ändern

	IFNE DEBUG
	move.w #$00F0,COLOR00(a5)
	ENDIF

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

	movea.l background,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanesA,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanesB,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
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

;---------- Warten auf vertikal blank (funktioniert nur, wenn der VERTB-Interrupt aktiviert ist!)  ----------

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
background:			DC.L 0
bitplanesA:			DC.L 0
bitplanesB:			DC.L 0
backBuffer:			DC.L 0
frontBuffer:		DC.L 0
palette:
					DC.W $0000
					DC.W $0FFF
					DC.W $0700
					DC.W $0900
					DC.W $0B00
					DC.W $0D00
					DC.W $0F00
					DC.W $0070
					DC.W $0090
					DC.W $00B0
					DC.W $00D0
					DC.W $00F0
					DC.W $0007
					DC.W $0009
					DC.W $000B
					DC.W $000D
					DC.W $000F
					DC.W $0770
					DC.W $0990
					DC.W $0BB0
					DC.W $0DD0
					DC.W $0FF0
					DC.W $0707
					DC.W $0909
					DC.W $0B0B
					DC.W $0D0D
					DC.W $0F0F
					DC.W $0077
					DC.W $0099
					DC.W $00BB
					DC.W $00DD
					DC.W $00FF
bobX:				DC.W BOB_X, 0
bobY:				DC.W BOB_Y, 0
bobSpeedX:			DC.W 2
bobSpeedY:			DC.W 3
bob:
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $F000, $F000, $F000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $F000, $F000, $F000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $000F, $000F, $000F, $000F
					DC.W $00F0, $00F0, $F000, $F000
					DC.W $00F0, $00F0, $F000, $F000
					DC.W $00F0, $00F0, $F000, $F000
					DC.W $00F0, $00F0, $F000, $F000

					DC.W $000F, $0F00, $000F, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0000, $F0F0, $00F0, $F000
					DC.W $0000, $F0F0, $00F0, $F000
					DC.W $0000, $F0F0, $00F0, $F000
					DC.W $0000, $F0F0, $00F0, $F000

					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $00F0
					DC.W $F0F0, $F0F0, $0000, $00F0
					DC.W $F0F0, $F0F0, $0000, $00F0
					DC.W $F0F0, $F0F0, $0000, $00F0

					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $000F
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $000F
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000

					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $00F0
					DC.W $0000, $0000, $0000, $00F0
					DC.W $0000, $0000, $0000, $00F0
					DC.W $0000, $0000, $0000, $00F0
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
mask:
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR

					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR

					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR

					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR

					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
