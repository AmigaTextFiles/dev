
; soc19.s = zoom2.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Programm zur Anpassung des horizontalen Hardware Zooms.

; Der horizontale Hardware-Zoom wird durch eine nicht dokumentierte Funktion
; ermöglicht: Da die Hardware die anzuzeigenden Daten in Blöcken von 16 Pixeln
; liest, wird durch die Verringerung des Wertes von BPLCON1 zwischen zwei
; Lesevorgängen verhindert, dass das 16.

; Die Herausforderung besteht darin, zu wissen, wann man BPLCON1 ändern muss,
; um diese Verschleierung zu bewirken: Man muss mit dem Lesen der 16 Pixel
; synchronisiert sein. Dazu identifizieren wir *empirisch* im Zoom, welche der
; 40 MOVEs pro Zeile zur Änderung von BPLCON1 verwendet werden sollen. Wenn
; die Anzahl der Bitplanes 4 überschreitet, stiehlt die Anzeige DMA-Zyklen vom
; Copper, der dann nicht mehr 40 MOVEs pro Zeile ausführen kann.

; Es ist sicherlich möglich, einen strengeren Ansatz zu verfolgen, indem man
; die Verbindung zwischen der Zeitachse für das Lesen von Pixeln (DDFSTRT) und
; der Zeitachse für die Ausführung der Copperlist, kurz der Zeitachse für die
; Anzeige von Daten und die Ausführung von MOVEs, untersucht. Die Tatsache,
; dass zwischen dem Lesen der Pixel und ihrer Anzeige eine nicht ganzzahlige
; Anzahl von Video-Zyklen (4,5 Video-Zyklen) liegt, ist jedoch ein Hinweis
; darauf, dass die Sychronisierung dieser Zeitabläufe nicht einfach sein kann...

; Für jede Zeile Y auf dem Bildschirm findet man also in der Copperlist :
;
; [0]	WAIT ($00 & $FE, Y & $7F)
; [4]	MOVE BPL1MOD
; [8]	MOVE BPL2MOD
; [12]	MOVE BPLCON1
; [16]	WAIT ($3D & $FE, Y & $7F)
; [20]	40 MOVE, davon eine Reihe in BPLCON1, die anderen entsprechen NOP (siehe ZOOM_NOP)

; Die Bitplanes, auf die der Zoom angewendet wird, sollten standardmäßig um
; 7 Pixel nach rechts verschoben werden. Dies ist die Grundsituation, wenn noch
; keine Pixelspalten verborgen sind. Warum 7 und nicht 15? Um die Zentrierung
; der Bitplanes auf dem Bildschirm zu gewährleisten, während immer mehr Spalten
; verdeckt werden. Dies wirkt sich auf die Breite des Bildes aus, das in diesen
; Bitplanes angezeigt wird. Denn damit das gezoomte Bild auf dem Inhalt einer
; nicht gezoomten Bitplane zentriert bleibt (d.h.: damit der Inhalt einer
; gezoomten Bitplane auf dem klassisch angezeigten Bildschirm zentriert bleibt), 
; muss dieses Bild auf der Abszisse 0 beginnen und auf der Abszisse
; 319 - 14 = 305 in der Bitplane enden. Anders ausgedrückt:
; Es darf sich nur über 306 Pixel erstrecken.

; Natürlich kann man auch erwägen, die Daten 16 Pixel vor der Anzeige
; auszulesen, um die verlorenen 14 Pixel zurückzugewinnen. Das Bild sollte sich
; dann von der Abszisse 16 - 7 = 9 über 320 Pixel in einer 336 Pixel breiten
; Bitplane ausbreiten, also einen 9 Pixel breiten vertikalen Streifen auf der
; linken Seite und einen 7 Pixel breiten vertikalen Streifen auf der rechten
; Seite ungenutzt lassen.

; Der Zoom wird nur auf ungerade Bitplanes angewendet, um ein Beispiel zu geben
; (es ist kein Problem, den Zoom auch auf gerade Bitplanes oder nur auf gerade
; Bitplanes anzuwenden) und um die Einschränkungen zu veranschaulichen, die er
; mit sich bringt. Es werden drei Bitplanes verwendet:

;- Bitplane 1 enthält ein Gruppenmuster aus 16 Pixeln, bei dem nur das
; 16. Pixel auf 1 steht: Dadurch werden die Pixelspalten sichtbar, die durch
; das Zoomen verborgen werden können.

;- Bitplane 3 ist gefüllt: Dadurch wird der Effekt des Zoomens auf ein Bild
; sichtbar.

;- Bitplane 2 ist gefüllt: Dadurch wird der Versatz der gezoomten Bitplanes
; gegenüber einer nicht gezoomten Bitplane sichtbar.

;********** Konstanten **********

; Programm

DISPLAY_DEPTH=3
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
ZOOM_STRIPDY=8
ZOOM_DY=16*ZOOM_STRIPDY
ZOOM_X=$3D
ZOOM_Y=DISPLAY_Y+DISPLAY_DY-ZOOM_DY
ZOOM_NOP=$01FE0000
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+ZOOM_DY*(1+1+1+40)*4+4
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
	move.w #$0007,(a0)+
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

	; Zoom (16 Streifen mit ZOOM_STRIPDY Pixeln Höhe: 1. Streifen, in dem 15 Spalten
	; verborgen sind, 2. Streifen, in dem 14 Spalten verborgen sind usw.).

	move.w #ZOOM_Y<<8,d0
	lea zoom,a1
	moveq #ZOOM_STRIPDY,d1
	clr.w d2
	move.w #ZOOM_DY-1,d3
_zoomLines:

	move.w d0,d4
	or.w #$00!$0001,d4
	move.w d4,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+

	movea.l a1,a2
	move.b (a2)+,d2
	move.w #BPLCON1,(a0)+
	move.w d2,(a0)+

	move.w d0,d4
	or.w #ZOOM_X!$0001,d4
	move.w d4,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+

	move.w d2,d4
	move.w #40-1,d5
_zoomColumns:
	tst.b (a2)+
	beq _zoomNoBPLCON1
	move.w #BPLCON1,(a0)+
	subq.b #$01,d2
	move.w d2,(a0)+
	dbf d5,_zoomColumns
	bra _zoomColumnsDone
_zoomNoBPLCON1:
	move.l #ZOOM_NOP,(a0)+
	dbf d5,_zoomColumns
_zoomColumnsDone:

	addi.w #$0100,d0
	subq.b #1,d1
	bne _zoomColumnsNoNewStrip
	lea 40+1(a1),a1
	moveq #ZOOM_STRIPDY,d1
_zoomColumnsNoNewStrip:

	dbf d3,_zoomLines

	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Zeichnen Sie in Bitplane 2 ein 320 Pixel großes Muster, um die durch den Zoom erzeugte Dezentrierung zu visualisieren.

	move.w #0,BLTDMOD(a5)
	move.w #$01AA,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	move.w #$FFFF,BLTCDAT(a5)
	movea.l bitplanes,a0
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Zeichnen Sie auf der Bitplane 3 ein Muster aus 306 Pixeln, um den Effekt des Zoomens auf ein Bild zu visualisieren.

	move.w #$01F0,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=A
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$C000,BLTALWM(a5)
	move.w #$0000,BLTCON1(a5)
	move.w #$FFFF,BLTADAT(a5)
	movea.l bitplanes,a0
	lea 2*DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Zeichnen Sie auf der Bitplane 1 ein Muster aus 306 Pixeln, um die versteckten Spalten zu finden.

	move.w #$01F0,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=A
	move.w #$0000,BLTCON1(a5)
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$C000,BLTALWM(a5)
	move.w #$0001,BLTADAT(a5)
	movea.l bitplanes,a0
	move.l a0,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Zeichnen Sie in Bitplane 3 Trennlinien, um die Streifen zu markieren.

	movea.l bitplanes,a0
	lea (3*DISPLAY_DY-ZOOM_DY)*(DISPLAY_DX>>3)(a0),a0
	move.w #16-1,d0
_drawStripBorders:
	REPT 10
	move.l #0,(a0)+
	ENDR
	lea (ZOOM_STRIPDY-1)*(DISPLAY_DX>>3)(a0),a0
	dbf d0,_drawStripBorders

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
colors:				DC.W $0000	; %000
					DC.W $0FFF	; %001
					DC.W $0F00	; %010
					DC.W $0FFF	; %011
					DC.W $0F00	; %100
					DC.W $0FFF	; %101
					DC.W $0777	; %110
					DC.W $0FFF	; %111
zoom:
					DC.B  7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0007 -> $0007 (0 gelöschte Spalten)			
					DC.B  8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0008 -> $0007 (1 gelöschte Spalten)
					DC.B  8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0008 -> $0006 (2 gelöschte Spalten)
					DC.B  9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0009 -> $0006 (3 gelöschte Spalten)
					DC.B  9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0009 -> $0005 (4 gelöschte Spalten)
					DC.B 10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000A -> $0005 (5 gelöschte Spalten)
					DC.B 10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000A -> $0004 (6 gelöschte Spalten)
					DC.B 11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000B -> $0004 (7 gelöschte Spalten)
					DC.B 11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000B -> $0003 (8 gelöschte Spalten)
					DC.B 12,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000C -> $0003 (9 gelöschte Spalten)
					DC.B 12,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000C -> $0002 (10 gelöschte Spalten)
					DC.B 13,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000D -> $0002 (11 gelöschte Spalten)
					DC.B 13,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0	; BPLCON1 : $000D -> $0001 (12 gelöschte Spalten)
					DC.B 14,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0	; BPLCON1 : $000E -> $0001 (13 gelöschte Spalten)
					DC.B 14,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0	; BPLCON1 : $000E -> $0000 (14 gelöschte Spalten)
					DC.B 15,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0	; BPLCON1 : $000F -> $0000 (15 gelöschte Spalten)

					end
