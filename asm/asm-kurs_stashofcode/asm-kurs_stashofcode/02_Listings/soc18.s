
; soc18.s = zoom1.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Hervorhebung der Möglichkeit, horizontal hardwaremäßig zu zoomen.

; ZOOM_Y+ZOOM_DY muss aus einem Grund kleiner oder gleich $7F sein, der im Artikel
; "WAIT, SKIP und COMPJMP1: Eine fortgeschrittene Verwendung von Copper (2/2)"
; erläutert wird, der veröffentlicht wird, sobald das zweite für Scoopex erstellte
; Cracktro von Galahad verteilt wird...

;********** Konstanten **********

; Programm

DISPLAY_DEPTH=2
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
ZOOM_X=$3D
ZOOM_DY=20
ZOOM_Y=DISPLAY_Y+ZOOM_DY
ZOOM_NOP=$01FE0000
ZOOM_MOVE=17
ZOOM_BPLCON1=$0022
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+ZOOM_DY*(1+1+1+40)*4+4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; ZOOM_DY*(1+1+1+40)	Für jede gezoomte Zeile: WAIT, Initialisierung von BPLCON1,
							; WAIT, 40 MOVE (Änderung von BPLCON1, und der Rest der NOPs)
	; 4						Zurücksetzen von BPLCON1 für Zeilen, die auf die gezoomten folgen
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

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
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

	movea.l copperList,a0

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$00FF,(a0)+
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

	move.l bitplanes,d0
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
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	dbf d2,_bitplanes

	; Palette

	lea colors,a1
	moveq #1,d0
	lsl.b #DISPLAY_DEPTH,d0
	subq.b #1,d0
	move.w #COLOR00,d1
_colors:
	move.w d1,(a0)+
	addq.w #2,d1
	move.w (a1)+,(a0)+
	dbf d0,_colors

	; Zoom

	move.w #ZOOM_Y<<8,d0
	move.w #ZOOM_DY-1,d1
_zoomLines:

	; Auf den Beginn der Zeile warten

	move.w d0,d2
	or.w #$00!$0001,d2
	move.w d2,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+

	; BPLCON1 mit einer Verzögerung von 15 Pixeln initialisieren ($00FF)

	move.w #BPLCON1,(a0)+
	move.w #$00FF,(a0)+

	; Warten Sie auf die Position in der Zeile, die dem Beginn der Anzeige
	; entspricht (horizontale Position $3D in einem WAIT).

	move.w d0,d2
	or.w #ZOOM_X!$0001,d2
	move.w d2,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+

	; MOVEs aneinanderreihen, die nichts tun, bis zu dem, der die Verzögerung an ZOOM_BPLCON1 weitergeben muss

	IFNE ZOOM_MOVE		; Denn ASM-One stürzt auf einem REPT ab, dessen Wert 0 ist...
	REPT ZOOM_MOVE
	move.l #ZOOM_NOP,(a0)+
	ENDR
	ENDC

	; Ändern Sie BPLCON1, um die Verzögerung auf ZOOM_BPLCON1 umzustellen.

	move.w #BPLCON1,(a0)+
	move.w #ZOOM_BPLCON1,(a0)+

	; Verketten von MOVEs, die nichts tun, bis zum Ende der Zeile

	IFNE 39-ZOOM_MOVE		; Denn ASM-One stürzt auf einem REPT ab, dessen Wert 0 ist...
	REPT 39-ZOOM_MOVE
	move.l #ZOOM_NOP,(a0)+
	ENDR
	ENDC

	; Zur nächsten Zeile im gezoomten Zeilenband springen

	addi.w #$0100,d0
	dbf d1,_zoomLines

	; BPLCON1 ($00FF) für das Ende des Bildschirms zurücksetzen

	move.w #BPLCON1,(a0)+
	move.w #$00FF,(a0)+

	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Zeichnen Sie in Bitplane 1 ein Muster (COLOR03), um die versteckten Spalten zu identifizieren:
	; 1. Wort: Bit 0 bis 1 => In der 1. Wortspalte kennzeichnet eine 1 Pixel breite weiße Spalte die Bits 0.
	; 2. Wort: Bit 1-0 bis 1 => In der zweiten Wortspalte identifiziert eine 2 Pixel breite weiße Spalte die Bits 0 und 1.
	; 3. Wort: Bits 2-1 bis 1 => In der dritten Wortspalte identifiziert eine weiße Spalte mit einer Breite von 3 Pixeln die Bits 0, 1 und 2.
	; usw.
	; Über das 15. Wort hinaus sind die Wörter 0

	move.w #$0000,BLTCON1(a5)
	move.w #$03AA,BLTCON0(a5)		; USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #-(DISPLAY_DX>>3),BLTCMOD(a5)
	move.w #0,BLTDMOD(a5)
	move.l #linePattern,BLTCPTH(a5)
	movea.l bitplanes,a0
	move.l a0,BLTDPTH(a5)
	move.w #((3*ZOOM_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Löschen Sie die Bitplane 2 und füllen Sie sie mit 1, um den Hintergrund des
	; Bildschirms (COLOR02) vom Rand des Bildschirms (COLOR00) zu unterscheiden.

	move.w #$01AA,BLTCON0(a5)		; USEA=0, USEB=0, USEC=0, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	move.w #$FFFF,BLTCDAT(a5)
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #((3*ZOOM_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

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

	movea.l bitplanes,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

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

	SECTION data,DATA

graphicslibrary:	DC.B "graphics.library",0
					EVEN
vectors:			BLK.L 6
copperList:			DC.L 0
bitplanes:			DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
colors:				DC.W $0000
					DC.W $00F0
					DC.W $0F00
					DC.W $0FFF
linePattern:		DC.W $0001, $0003, $0007, $000F, $001F, $003F, $007F, $00FF, $01FF, $03FF
					DC.W $07FF, $0FFF, $1FFF, $3FFF, $7FFF, $0000, $0000, $0000, $0000, $0000
