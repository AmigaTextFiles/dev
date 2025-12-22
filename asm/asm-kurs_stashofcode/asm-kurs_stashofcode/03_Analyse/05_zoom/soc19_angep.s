
; soc19_angep.s = zoom2.s

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
; die Anzahl der Bitplanes 4 überschreitet, stiehlt die Anzeige DMA-Zyklen von
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
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder $00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = $0007
BPLCON2_val = 0  ;$0008															; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
BPL1MOD_val = 0
BPL2MOD_val = 0

DEBUG=0

;********** Macros **********

; Warten Sie auf den Blitter. Wenn der zweite Operand eine Adresse ist, testet BTST nur
; die Bits 7-0 des gezeigten Bytes, aber da der erste Operand als Modulo-8-Bitnummer
; behandelt wird, bedeutet BTST #14,DMACONR(a5), dass das Bit 14%8=6 des höchstwertigen
; Bytes von DMACONR getestet wird, was gut zu BBUSY passt...

WAIT_BLITTER:	MACRO
_WAIT_BLITTER0\@
	btst #14,DMACONR(a5)	; Entspricht dem Testen von Bit 14 % 8 = 6 des höchstwertigen Bytes von DMACONR, also BBUSY
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

	move.w #DIWSTRT,(a0)+					; Konfiguration des Bildschirms				
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
	move.w #BPL2MOD,(a0)+
	move.w #BPL2MOD_val,(a0)+
	move.w #FMODE,(a0)+						; Kompatibilität OCS mit AGA
	move.w #0,(a0)+

	; Adressen der Bitebenen

	move.l bitplanes,d0						; Anfangsadresse bitplane
	move.w #BPL1PTH,d1						; 
	moveq #DISPLAY_DEPTH-1,d2				; Anzahl der Bitebenen, hier 3
_bitplanes:
	move.w d1,(a0)+							; Registeradresse Offset in Copperlist BPL1PTH
	addq.w #2,d1							; Registeradresse Offset addieren 2 Bytes
	swap d0									; Wörter tauschen
	move.w d0,(a0)+							; hohes Wort der Adresse in Copperlist
	move.w d1,(a0)+							; Registeradresse Offset in Copperlist BPL1PTL
	addq.w #2,d1							; Registeradresse Offset addieren 2 Bytes
	swap d0									; Wörter tauschen
	move.w d0,(a0)+							; niedriges Wort der Adresse in Copperlist
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d0	; Adresse nächste Bitplane  (256*(320/8)=10240 Bytes)
	dbf d2,_bitplanes						; wiederholen für alle Bitebenen

	; Palette

	lea colors,a1							; Tabelle mit 4 Farbwerten
	moveq #1,d0								; 00000001 = 1
	lsl.b #DISPLAY_DEPTH,d0					; 00000100 = 4 Anzahl Farben
	subq.b #1,d0							; 00000011 = 3 Schleifenzähler
	move.w #COLOR00,d1						; Farbregister Startwert
_colors:
	move.w d1,(a0)+							; Farbregister in Copperlist
	addq.w #2,d1							; nächster Farbregisterwert
	move.w (a1)+,(a0)+						; Farbwerte des Bildes des Bildes in Copperlist speichern
	dbf d0,_colors							; für alle Farbregister wiederholen

	; Zoom (16 Streifen mit ZOOM_STRIPDY Pixeln Höhe: 1. Streifen, in dem 15 Spalten
	; verborgen sind, 2. Streifen, in dem 14 Spalten verborgen sind usw.).

	move.w #ZOOM_Y<<8,d0					; $2c + 256-(16*8) = $AC   $40<<8 = $AC00	ZOOM_Y=DISPLAY_Y+DISPLAY_DY-ZOOM_DY = $2c+256-(16*8)
	lea zoom,a1								; Anfangsadresse Tabelle zoom-Werte
	moveq #ZOOM_STRIPDY,d1					; 8 Streifen
	clr.w d2								; d2 zurücksetzen
	move.w #ZOOM_DY-1,d3					; 16*8-1= 127 Schleifenzähler
_zoomLines:

	move.w d0,d4							; $AC00 Kopie
	or.w #$00!$0001,d4						; dc.w $AC01
	move.w d4,(a0)+							; Wait-Position in Copperlist schreiben
	move.w #$8000!($7F<<8)!$FE,(a0)+		; dc.w $FFFE	

	movea.l a1,a2							; Kopie Anfangsadresse Tabelle zoom-Werte
	move.b (a2)+,d2							; aktueller zoom-Wert in d2 (Shiftwert)
	move.w #BPLCON1,(a0)+					; dc.w $0102
	move.w d2,(a0)+							; aktueller zoom-Wert in d2 (Shiftwert) in Copperlist speichern

	move.w d0,d4							; $AC00 Kopie
	or.w #ZOOM_X!$0001,d4					; dc.w $AC3d
	move.w d4,(a0)+							; Wait-Position in Copperlist schreiben
	move.w #$8000!($7F<<8)!$FE,(a0)+		; dc.w $FFFE

	move.w d2,d4							; Kopie aktueller zoom-Wert in d2 (Shiftwert)
	move.w #40-1,d5							; Schleifenzähler 40 Anzahl Copper Moves
_zoomColumns:
	tst.b (a2)+								; aktueller zoom-Wert auf "leer" testen
	beq _zoomNoBPLCON1						; wenn 'leer" dann überspringen
	move.w #BPLCON1,(a0)+					; ansonsten, dc.w $0102 in Copperlist speichern
	subq.b #$01,d2							; aktuellen zoom-Wert verringern
	move.w d2,(a0)+							; und in Copperlist speichern
	dbf d5,_zoomColumns						; für alle Spalten wiederholen
	bra _zoomColumnsDone					; da Shiftwert, kein NOP in Copperlist speichern
_zoomNoBPLCON1:								; 
	move.l #ZOOM_NOP,(a0)+					; $01FE0000		= NULL := 0x0000 	No operation/NULL (Copper NOP instruction)
	dbf d5,_zoomColumns						; für alle 40 Copper Moves wiederholen
_zoomColumnsDone:

	addi.w #$0100,d0						; nächstes Wait eine Zeile tiefer
	subq.b #1,d1							; Wert Zoom_Stripdy um 1 verringern (Höhe der Zoomstreifen)
	bne _zoomColumnsNoNewStrip				; wenn nicht 0 dann überspringen
	lea 40+1(a1),a1							; ansonsten Zeiger auf die nächsten Zoom-Werte
	moveq #ZOOM_STRIPDY,d1					; 8 auf Anfangswert zurücksetzen
_zoomColumnsNoNewStrip:

	dbf d3,_zoomLines						; über alle Zeilen wiederholen

	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)				; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Zeichnen Sie in Bitplane 2 ein 320 Pixel großes Muster, um die durch den Zoom erzeugte Dezentrierung zu visualisieren.

	move.w #0,BLTDMOD(a5)					; BLTDMOD = 0
	move.w #$01AA,BLTCON0(a5)				; USEA=0, USEB=0, USEC=0, USED=1, D=C
	move.w #$0000,BLTCON1(a5)				; keine Sondermodi
	move.w #$FFFF,BLTCDAT(a5)				; Kanal C mit festen Wert vorladen
	movea.l bitplanes,a0					; Anfangsadresse bitplanes
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0	; 256*(320/8) = Offset für nächste Bitebene (also Bitebene 2)
	move.l a0,BLTDPTH(a5)					; Ziel - Kanal D 
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; 256 Zeilen und 320/16=20 Wörter Breite
	WAIT_BLITTER

	; Zeichnen Sie auf der Bitplane 3 ein Muster aus 306 Pixeln, um den Effekt des Zoomens auf ein Bild zu visualisieren.

	move.w #$01F0,BLTCON0(a5)				; USEA=0, USEB=0, USEC=0, USED=1, D=A
	move.w #$FFFF,BLTAFWM(a5)				; alles passiert
	move.w #$C000,BLTALWM(a5)				; %1100, nur die Bits ganz links passieren
	move.w #$0000,BLTCON1(a5)				; keine Sondermodi
	move.w #$FFFF,BLTADAT(a5)				; Kanal A mit festen Wert vorladen
	movea.l bitplanes,a0					; Anfangsadresse bitplanes
	lea 2*DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0	; 2*256*(320/8) = Offset für nächste Bitebene (also Bitebene 3)
	move.l a0,BLTDPTH(a5)					; Ziel - Kanal D 
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5) ; 256 Zeilen und 320/16=20 Wörter Breite
	WAIT_BLITTER

	; Zeichnen Sie auf der Bitplane 1 ein Muster aus 306 Pixeln, um die versteckten Spalten zu finden.

	move.w #$01F0,BLTCON0(a5)				; USEA=0, USEB=0, USEC=0, USED=1, D=A
	move.w #$0000,BLTCON1(a5)				; keine Sondermodi
	move.w #$FFFF,BLTAFWM(a5)				; alles passiert
	move.w #$C000,BLTALWM(a5)				; %1100, nur die Bits ganz links passieren
	move.w #$0001,BLTADAT(a5)				; Kanal A mit festen Wert vorladen
	movea.l bitplanes,a0					; Anfangsadresse bitplanes
	move.l a0,BLTDPTH(a5)					; Ziel - Kanal D 
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; 256 Zeilen und 320/16=20 Wörter Breite
	WAIT_BLITTER

	; Zeichnen Sie in Bitplane 3 Trennlinien, um die Streifen zu markieren.

	movea.l bitplanes,a0					; Anfangsadresse bitplanes
	lea (3*DISPLAY_DY-ZOOM_DY)*(DISPLAY_DX>>3)(a0),a0	; 3*256-(16*8))*(320/8) =  Offset in Bitebene 3, halber Bildschirm
	move.w #16-1,d0							; Schleifenzähler 16
_drawStripBorders:
	REPT 10									; 10*32Pixel = 320 Pixel - eine Zeile
	move.l #0,(a0)+							; Pixel löschen in Bitebene - Streifen
	ENDR									; 
	lea (ZOOM_STRIPDY-1)*(DISPLAY_DX>>3)(a0),a0		; (8-1) * (320/8) = Offset in Bitebene - nächste Zeile
	dbf d0,_drawStripBorders				; wiederholen für alle 16 Reihen

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

zoom:					 ;1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
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

Programmbeschreibung: zoom2.s

Das Programm startet mit der Anforderung von freiem Speicher für die
Copperliste und für einen Lowres-Screen 320x256 mit 3 Bitebenen. Die erste
Besonderheit ist, dass der Hardwarescrollwert nur für ungerade Bitebenen
auf den Wert $7 eingestellt wird. Somit erhält das Bild eine Grundverschiebung
"zur Mitte" hin.

>o1
 0003cf80: 008e 2c81            ;  DIWSTRT := 0x2c81
 0003cf84: 0090 2cc1            ;  DIWSTOP := 0x2cc1
 0003cf88: 0092 0038            ;  DDFSTRT := 0x0038
 0003cf8c: 0094 00d0            ;  DDFSTOP := 0x00d0
 0003cf90: 0100 3200            ;  BPLCON0 := 0x3200
 0003cf94: 0102 0007            ;  BPLCON1 := 0x0007		; Hardwarescroll
 0003cf98: 0104 0000            ;  BPLCON2 := 0x0000
 0003cf9c: 0108 0000            ;  BPL1MOD := 0x0000
 0003cfa0: 010a 0000            ;  BPL2MOD := 0x0000
 0003cfa4: 01fc 0000            ;  FMODE := 0x0000
 0003cfa8: 00e0 0004            ;  BPL1PTH := 0x0004
 0003cfac: 00e2 25e8            ;  BPL1PTL := 0x25e8
 0003cfb0: 00e4 0004            ;  BPL2PTH := 0x0004
 0003cfb4: 00e6 4de8            ;  BPL2PTL := 0x4de8
 0003cfb8: 00e8 0004            ;  BPL3PTH := 0x0004
 0003cfbc: 00ea 75e8            ;  BPL3PTL := 0x75e8
 0003cfc0: 0180 0000            ;  COLOR00 := 0x0000
 0003cfc4: 0182 0fff            ;  COLOR01 := 0x0fff
 0003cfc8: 0184 0f00            ;  COLOR02 := 0x0f00
 0003cfcc: 0186 0fff            ;  COLOR03 := 0x0fff
>o
 0003cfd0: 0188 0f00            ;  COLOR04 := 0x0f00
 0003cfd4: 018a 0fff            ;  COLOR05 := 0x0fff
 0003cfd8: 018c 0777            ;  COLOR06 := 0x0777
 0003cfdc: 018e 0fff            ;  COLOR07 := 0x0fff
 0003cfe0: ac01 fffe            ;  Wait for vpos >= 0xac and hpos >= 0x00
                                ;  VP ac, VE 7f; HP 00, HE fe; BFD 1
 0003cfe4: 0102 0007            ;  BPLCON1 := 0x0007
 0003cfe8: ac3d fffe            ;  Wait for vpos >= 0xac and hpos >= 0x3c
                                ;  VP ac, VE 7f; HP 3c, HE fe; BFD 1
 0003cfec: 01fe 0000            ;  NULL := 0x0000
 
Der Bildschirm wird nun durch die Copperliste zweigeteilt. Die obere Hälfte
bleibt unverändert. In der unteren Hälfte wird der horizontale Zomm ausgeführt.

Neben den Bitplanepointern und der Palette enthält die Copperliste ab der Zeile
$AC für 128 weitere Zeilen, also für jede Zeile ab der Hälfte des Bildschirms
je ein Wait auf die Zeile und horizontale Position $3D auf die dann 
40 Copper-Moves "Null" folgen. An einigen Stellen wird anstatt des leeren 
Copper-Moves ein Copper-Move eingetragen, der die Verschiebung des Bildes
ändert. Dies erfolgt nach einer Regel bzw. Algorithmus und zwar so, dass für 16
Zoomebenen im Abstand von 8 Pixelzeilen die Werte geändert werden. 16*8=128.
D.h, ab der Zeile $AC und dann im Abstand von je 8 Zeilen, 
also: $B4, $BC, $C4, $CC usw. werden für je 16 Ebenen Copperwerte in die
Copperliste eingetragen.

Die Information ob eine Änderung des BPLCON1 Wertes in der Copperliste erfolgt
wird aus einer Tabelle: zoom entnommen die 41x16 Bytes enthält. Der 1. Wert ist
der BPLCON1 Startwert der Zeile und der 41. Wert  einer Reihe ist eine Endemarke.
Mit jeder weiteren 1 in der Zeile wird der Verschiebungswert um den Wert -1 
verringert.  

 0006a538: ac01 fffe            ;  Wait for vpos >= 0xac and hpos >= 0x00
                                ;  VP ac, VE 7f; HP 00, HE fe; BFD 1
 0006a53c: 0102 0007            ;  BPLCON1 := 0x0007
 0006a540: ac3d fffe            ;  Wait for vpos >= 0xac and hpos >= 0x3c
                                ;  VP ac, VE 7f; HP 3c, HE fe; BFD 1
 0006a544: 01fe 0000            ;  NULL := 0x0000
 0006a548: 01fe 0000            ;  NULL := 0x0000
 0006a54c: 01fe 0000            ;  NULL := 0x0000
 0006a550: 01fe 0000            ;  NULL := 0x0000
 0006a554: 01fe 0000            ;  NULL := 0x0000
 0006a558: 01fe 0000            ;  NULL := 0x0000
 0006a55c: 01fe 0000            ;  NULL := 0x0000
 0006a560: 01fe 0000            ;  NULL := 0x0000
 0006a564: 01fe 0000            ;  NULL := 0x0000
 0006a568: 01fe 0000            ;  NULL := 0x0000		; 10 nop moves
 0006a56c: 01fe 0000            ;  NULL := 0x0000
 0006a570: 01fe 0000            ;  NULL := 0x0000
 0006a574: 01fe 0000            ;  NULL := 0x0000
>o
 0006a578: 01fe 0000            ;  NULL := 0x0000
 0006a57c: 01fe 0000            ;  NULL := 0x0000
 0006a580: 01fe 0000            ;  NULL := 0x0000
 0006a584: 01fe 0000            ;  NULL := 0x0000
 0006a588: 01fe 0000            ;  NULL := 0x0000
 0006a58c: 01fe 0000            ;  NULL := 0x0000
 0006a590: 01fe 0000            ;  NULL := 0x0000		; 10 nop moves
 0006a594: 01fe 0000            ;  NULL := 0x0000
 0006a598: 01fe 0000            ;  NULL := 0x0000
 0006a59c: 01fe 0000            ;  NULL := 0x0000
 0006a5a0: 01fe 0000            ;  NULL := 0x0000
 0006a5a4: 01fe 0000            ;  NULL := 0x0000
 0006a5a8: 01fe 0000            ;  NULL := 0x0000
 0006a5ac: 01fe 0000            ;  NULL := 0x0000
 0006a5b0: 01fe 0000            ;  NULL := 0x0000
 0006a5b4: 01fe 0000            ;  NULL := 0x0000
 0006a5b8: 01fe 0000            ;  NULL := 0x0000		; 10 nop moves
 0006a5bc: 01fe 0000            ;  NULL := 0x0000
 0006a5c0: 01fe 0000            ;  NULL := 0x0000
 0006a5c4: 01fe 0000            ;  NULL := 0x0000
>o
 0006a5c8: 01fe 0000            ;  NULL := 0x0000
 0006a5cc: 01fe 0000            ;  NULL := 0x0000
 0006a5d0: 01fe 0000            ;  NULL := 0x0000
 0006a5d4: 01fe 0000            ;  NULL := 0x0000
 0006a5d8: 01fe 0000            ;  NULL := 0x0000
 0006a5dc: 01fe 0000            ;  NULL := 0x0000
 0006a5e0: 01fe 0000            ;  NULL := 0x0000		; 10 nop moves
 0006a5e4: ad01 fffe            ;  Wait for vpos >= 0xad and hpos >= 0x00
                                ;  VP ad, VE 7f; HP 00, HE fe; BFD 1
 0006a5e8: 0102 0007            ;  BPLCON1 := 0x0007
 0006a5ec: ad3d fffe            ;  Wait for vpos >= 0xad and hpos >= 0x3c
                                ;  VP ad, VE 7f; HP 3c, HE fe; BFD 1
 0006a5f0: 01fe 0000            ;  NULL := 0x0000
 0006a5f4: 01fe 0000            ;  NULL := 0x0000
 0006a5f8: 01fe 0000            ;  NULL := 0x0000


 Knack- und Angelpunkt dabei ist, das immer abwechselnd links und rechts der
 Hardwarescrollwert geändert wird.

 zoom:					 ;1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
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

Im Speicher sieht dann die fertige Copperliste dann in etwa so aus:
0006BAB8 CC01 FFFE 0102 0009 CC3D FFFE 01FE 0000  .........=......
0006BAC8 01FE 0000 01FE 0000 01FE 0000 01FE 0000  ................
0006BAD8 01FE 0000 01FE 0000 01FE 0000 01FE 0000  ................
0006BAE8 01FE 0000 01FE 0000 01FE 0000 01FE 0000  ................
0006BAF8 01FE 0000 01FE 0000 01FE 0000 01FE 0000  ................
0006BB08 01FE 0000 01FE 0000 0102 0008 01FE 0000  ................
0006BB18 0102 0007 01FE 0000 0102 0006 0102 0005  ................
0006BB28 01FE 0000 01FE 0000 01FE 0000 01FE 0000  ................
0006BB38 01FE 0000 01FE 0000 01FE 0000 01FE 0000  ................
0006BB48 01FE 0000 01FE 0000 01FE 0000 01FE 0000  ................
0006BB58 01FE 0000 01FE 0000 01FE 0000 CD01 FFFE  ................
0006BB68 0102 0009 CD3D FFFE 01FE 0000 01FE 0000  .....=..........
...

Der Effekt wird durch die Copperliste erzeugt. Um die Wirkung des 
Hardwarescrolls durch die Copperliste zu sehen, werden die 3 Bitebenen vor
der Hauptschleife durch 3 Blitts mit Bilddaten geladen.
 
Blitt 1
Im ersten Blitt wird der Hintergrund des Bereiches (256 Zeilen * 20 Wörter)
komplett gefüllt um es vom schwarzen Hintergrund abzuheben. (Farbe rot)
Erreicht wird das durch das wiederholte Kopieren eines festen Wertes in BLTCDAT.

Blitt 2
Im zweiten Blitt wird der Hintergrund des Bereiches (256 Zeilen * 20 Wörter) 
mit einem von 256 Zeilen * 306 Pixel komplett gefüllt um es vom roten 
Hintergrund abzuheben. (Farbe grau) 306 Pixel sind 19 Wörter + 2 Pixel
Erreicht wird das durch das wiederholte Kopieren eines festen Wertes in BLTADAT.
Das kleinere Bild hat seine Ursache durch den Hardwarescroll...

Blitt 3
Durch den dritten Blit werden vertikale Linien gezeichnet um später den Zoom
zu veranschaulichen.

Anschließend werden durch eine Schleife noch alle 8 Zeilen, die Pixel gelöscht
um 16 Ebenen zu erhalten.

Nach dem Start des Programms ist die einzige Aufgabe des Programms auf
die Maustaste zu warten.


Frage:

Warum kann die zoom Tabelle nicht so aussehen?

zoom:					 ;1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
					DC.B  7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0007 -> $0007 (0 gelöschte Spalten)			
					DC.B  8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0008 -> $0007 (1 gelöschte Spalten)
					DC.B  8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0008 -> $0006 (2 gelöschte Spalten)
					DC.B  9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0009 -> $0006 (3 gelöschte Spalten)
					DC.B  9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $0009 -> $0005 (4 gelöschte Spalten)
					DC.B 10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000A -> $0005 (5 gelöschte Spalten)
					DC.B 10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000A -> $0004 (6 gelöschte Spalten)
					DC.B 11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000B -> $0004 (7 gelöschte Spalten)
					DC.B 11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000B -> $0003 (8 gelöschte Spalten)
					DC.B 12,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0	; BPLCON1 : $000C -> $0003 (9 gelöschte Spalten)
					DC.B 12,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0	; BPLCON1 : $000C -> $0002 (10 gelöschte Spalten)
					DC.B 13,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0	; BPLCON1 : $000D -> $0002 (11 gelöschte Spalten)
					DC.B 13,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0	; BPLCON1 : $000D -> $0001 (12 gelöschte Spalten)
					DC.B 14,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0	; BPLCON1 : $000E -> $0001 (13 gelöschte Spalten)
					DC.B 14,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0	; BPLCON1 : $000E -> $0000 (14 gelöschte Spalten)
					DC.B 15,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0	; BPLCON1 : $000F -> $0000 (15 gelöschte Spalten)

bzw. gibt es auch die Möglichkeit der Einsatzes einen Copper-Waits und Copper-Moves?

https://eab.abime.net/showthread.php?t=114023

1. always the last BPLCON1 value before BPL1-DMA-Cycle sets actual hardwarescrollvalue
2. the closest wait-position for a normal lowres-screen would be dc.w $VV3d,$fffe
3. the calculation for all possible wait-position follows this rule:

HH=BPL1+1 eg. $3B+1=$C --> copper wait $3D
or general BPL1_Start=$2b $2b+n*8+1 (+1 Copper-Wait)
eg. for the 6. 16 pixel group $2B+6*8+1 --> dc.w $3a55,$fffe

$2B - 1. dc.w $3a2d,$fffe (1. 16. pixel group) ; overscan
$33 - 2. dc.w $3a35,$fffe (2. 16. pixel group)
$3B - 3. dc.w $3a3d,$fffe ; normal diwstrt: $2c81 or ddfstrt: $38
$43 - 4. dc.w $3a45,$fffe
$4B - 5. dc.w $3a4d,$fffe
$53 - 6 dc.w $3a55,$fffe
$5B - 7. dc.w $3a5d,$fffe
...
$d3 - 22. dc.w $3ad5,$fffe (22. 16. pixel group) ; overscan

4. with a wait-position and copper move it is only possible to change the BPLCON1 value every 32 pixel
because wait+move needs 8+4 CCKs = 24 pixel
--> that means: no 16 pixel synchronisation is possible

dc.w $3a3d,$fffe ; horizontal wait
dc.w $102,$ff
dc.w $3a45,$fffe ; results in a wait for dc.w $3a4d,$fffe
dc.w $102,$00

[30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
                               BPL1 110
                                   FFFF                      W
                               0006A9DA
 FFF28E00  FFF29000  FFF29200  FFF29400  FFF29600  FFF29800  FFF29A00  FFF29C00

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]	; 8 CCK = 16 Pixel
 COP  08C            COP  102  BPL1 110  COP  08C            COP  08C
     0102                000F      FFFF      3A45                FFFE
 0006CD60            0006CD62  0006A9DC  0006CD64            0006CD64
 FFF29E00  FFF2A000  FFF2A200  FFF2A400  FFF2A600  FFF2A800  FFF2AA00  FFF2AC00

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]	; after 8 CCK = 16 pixel
                               BPL1 110
                                   FFFF                      W
                               0006A9DE
 FFF2AE00  FFF2B000  FFF2B200  FFF2B400  FFF2B600  FFF2B800  FFF2BA00  FFF2BC00

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]	; after 8 CCK = 16 pixel = sum 32 pixel
 COP  08C            COP  102  BPL1 110  COP  08C            COP  08C
     0102                0000      FFFF      5A55                FFFE
 0006CD68            0006CD6A  0006A9E0  0006CD6C            0006CD6C
 FFF2BE00  FFF2C000  FFF2C200  FFF2C400  FFF2C600  FFF2C800  FFF2CA00  FFF2CC00

5. with a copper move in a row it is possible to change BPLCON1 to every $8
that means: 16 pixel synchronisation is possible (copper-move needs 8 pixel)

dc.w $3a35,$fffe ; horizontal wait
dc.w $102,$ff
dc.w $102,$ff ; could be a dc.w $01FE,$0000 (Copper Nop)
dc.w $102,$00 ; last before BPL1 wins

[30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
 COP  08C            COP  102  BPL1 110  COP  08C            COP  102
     0102                000F      FFFF      0102                000F
 0006CD60            0006CD62  0006A9DA  0006CD64            0006CD66
 68FEC200  68FEC400  68FEC600  68FEC800  68FECA00  68FECC00  68FECE00  68FED000

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  08C            COP  102  BPL1 110  COP  08C            COP  08C
     0102                0000      FFFF      5A55                FFFE
 0006CD68            0006CD6A  0006A9DC  0006CD6C            0006CD6C
 68FED200  68FED400  68FED600  68FED800  68FEDA00  68FEDC00  68FEDE00  68FEE000


 Die Bilddaten werden in Pakteten von 16 Pixeln aus dem Speicher geholt. Datafetch
 endet mit dem Einlesen von BPL1. Danach erfolgt das Addieren eines Versatzes 
 aufgrund des BPLCON1-Wertes.