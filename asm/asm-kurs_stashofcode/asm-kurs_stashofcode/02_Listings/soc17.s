
; soc17.s = zoom0.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Beispiel für das Verbergen von Linien durch Änderung von DIWSTRT, DIWSTOP, BPLxPTH/L und BPLxMOD.
; Sie verkleinern einfach das Bild (PICTURE_DX x PICTURE_DY Pixel), indem Sie die ersten ZOOM_N Zeilen,
; die mittleren ZOOM_N Zeilen und die letzten ZOOM_N Zeilen ausblenden und das Ergebnis auf dem
; Bildschirm vertikal zentrieren. Das Bild wird normal angezeigt und gezoomt, wenn die linke
; Maustaste gedrückt und wieder losgelassen wird. Dazu werden die Werte, die mit MOVE in die
; Copperlist geschrieben werden, verändert.

;********** Konstanten **********

; Programm

DISPLAY_DEPTH=5
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
PICTURE_DX=DISPLAY_DX		; Konstante, die zur Verdeutlichung eingeführt wurde, indem zwischen dem,
							; was den Bildschirm (DISPLAY_*) betrifft, und dem, was das Bild (PICTURE_*)
							; betrifft, unterschieden wird.
PICTURE_DY=DISPLAY_DY		; dito
ZOOM_N=16
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+2*(1+1+1)*4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; 2*(1+1+1)*4			2 Mal die Sequenz: WAIT, MOVE auf BPL1MOD und MOVE auf BPL2MOD
	; 4						$FFFFFFFE
DEBUG=0

;********** Macros **********

; Warten Sie auf den Blitter. Wenn der zweite Operand eine Adresse ist, testet BTST nur
; die Bits 7-0 des gezeigten Bytes, aber da der erste Operand als Modulo-8-Bitnummer
; behandelt wird, bedeutet BTST #14,DMACONR(a5), dass das Bit 14%8=6 des höchstwertigen
; Bytes von DMACONR getestet wird, was gut zu BBUSY passt...

WAIT_BLITTER:	MACRO
_WAIT_BLITTER0\@
	btst #14,DMACONR(a5)
	bne _WAIT_BLITTER0\@
_WAIT_BLITTER1\@
	btst #14,DMACONR(a5)
	bne _WAIT_BLITTER1\@
	ENDM

;********** Initialisierung **********

	SECTION code,CODE

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList

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

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+	; Dies entspricht ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC,
																		; wenn DISPLAY_DX ein Vielfaches von 16 ist.
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+
	move.w #FMODE,(a0)+
	move.w #0,(a0)+

	; Adressen der Bitebenen

	move.l #picture,d0
	move.w #BPL1PTH,d1
	moveq #DISPLAY_DEPTH-1,d2
_bitplanes:
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	addi.l #PICTURE_DY*(PICTURE_DX>>3),d0
	dbf d2,_bitplanes

	; Palette

	lea picture,a1
	addi.l #DISPLAY_DEPTH*PICTURE_DY*(PICTURE_DX>>3),a1
	moveq #1,d0
	lsl.b #DISPLAY_DEPTH,d0
	subq.b #1,d0
	move.w #COLOR00,d1
_colors:
	move.w d1,(a0)+
	addq.w #2,d1
	move.w (a1)+,(a0)+
	dbf d0,_colors

	; Verdeckung der ZOOM_N Mittellinien (derzeit neutralisiert)

	move.w #((DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N-1)<<8)!$0001,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

	; Nach dieser Zeile und vor dem Ende der nächsten muss BPLxMOD auf seinen Anfangswert zurückgesetzt werden

	move.w #((DISPLAY_Y+((3*ZOOM_N)>>1)+((PICTURE_DY-ZOOM_N)>>1)-ZOOM_N)<<8)!$0001,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Auf einen Mausklick warten

_waitLButtonPushed:
	btst #6,$BFE001
	bne _waitLButtonPushed
_waitLButtonReleased
	btst #6,$BFE001
	beq _waitLButtonReleased

	; Ändern der Startadresse der Bitplanes, um die ersten ZOOM_N-Zeilen zu verbergen.

	movea.l copperList,a0
	lea 10*4(a0),a0
	move.l #picture+ZOOM_N*(PICTURE_DX>>3),d0
	moveq #DISPLAY_DEPTH-1,d1
_updateBitplanes:
	swap d0
	move.w d0,2(a0)
	lea 4(a0),a0
	swap d0
	move.w d0,2(a0)
	lea 4(a0),a0
	addi.l #PICTURE_DY*(PICTURE_DX>>3),d0
	dbf d1,_updateBitplanes

	; Ändern der Werte, die BPLxMOD in der Mitte des Bildschirms zugewiesen
	; wurden, um die ZOOM_N Mittellinien zu verbergen.

	movea.l copperList,a0
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+4(a0),a0
	move.w #ZOOM_N*(PICTURE_DX>>3),2(a0)
	move.w #ZOOM_N*(PICTURE_DX>>3),4+2(a0)

	; Ändern von DIWSTRT und DIWSTOP, um das Bild zu zentrieren und die letzten ZOOM_N-Zeilen auszublenden.

	movea.l copperList,a0
	move.w #((DISPLAY_Y+((3*ZOOM_N)>>1))<<8)!DISPLAY_X,2(a0)
	move.w #((DISPLAY_Y+DISPLAY_DY-((3*ZOOM_N)>>1)-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),4+2(a0)

	; Hauptschleife

_loop:
	btst #6,$BFE001
	bne _loop

;********** Ende **********

	; Hardware-Interrupts und DMAs ausschalten

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
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

	; Speicher freigeben

	movea.l copperList,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"
	INCLUDE "common/wait.s"

;---------- Interrrupt-Handler ----------

_rte:
	rte

;********** Daten **********

	SECTION data,DATA_C

graphicslibrary:	DC.B "graphics.library",0
					EVEN
vectors:			BLK.L 6
copperList:			DC.L 0
bitplanes:			DC.L 0
olddmacon:				DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
picture:			INCBIN "dragonSun320x256x5.raw"
					