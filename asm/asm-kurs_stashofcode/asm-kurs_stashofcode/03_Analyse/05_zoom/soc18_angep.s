
; soc18_angep.s = zoom1.s

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


DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=2

ZOOM_X=$39					; angepasst			;ZOOM_X=$3D					; Original
ZOOM_DY=20
ZOOM_Y=DISPLAY_Y+ZOOM_DY	; $2c + 20 = $40
ZOOM_NOP=$01FE0000
ZOOM_MOVE=18				; angepasst			;ZOOM_MOVE=17				; Original
ZOOM_BPLCON1=$0000			; angepasst			;ZOOM_BPLCON1=$0022			; Original


COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+ZOOM_DY*(1+1+1+40)*4+4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; ZOOM_DY*(1+1+1+40)	Für jede gezoomte Zeile: WAIT, Initialisierung von BPLCON1,
							; WAIT, 40 MOVE (Änderung von BPLCON1, und der Rest der NOPs)
	; 4						Zurücksetzen von BPLCON1 für Zeilen, die auf die gezoomten folgen
	; 4						$FFFFFFFE
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder $00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = $00FF
BPLCON2_val = $0	;$0008														; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
BPL1MOD_val = 0
BPL2MOD_val = 0
;----------------------------------------------------------
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
	move.w #BPL2MOD,(a0)+
	move.w #BPL2MOD_val,(a0)+
	
	move.w #FMODE,(a0)+						; Kompatibilität OCS mit AGA
	move.w #0,(a0)+

	; Adressen der Bitebenen

	move.l bitplanes,d0						; Anfangsadresse bitplane
	move.w #BPL1PTH,d1						; 
	moveq #DISPLAY_DEPTH-1,d2				; Anzahl der Bitebenen, hier 2
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
	move.w (a1)+,(a0)+						; Farbwerte des Bildes kopieren
	dbf d0,_colors							; für alle Farbregister wiederholen

	; Zoom

	move.w #ZOOM_Y<<8,d0					; $2c + 20 = $40   $40<<8 = $4000
	move.w #ZOOM_DY-1,d1					; 20-1=19 Schleifenzähler (20 Wörter - eine Zeile)
_zoomLines:

	; Auf den Beginn der Zeile warten

	move.w d0,d2							; $4000 Kopie
	or.w #$00!$0001,d2						; dc.w $4001
	move.w d2,(a0)+							; Wert in Copperlist schreiben
	move.w #$8000!($7F<<8)!$FE,(a0)+		; dc.w $FFFE						--> dc.w $4001,$FFFE
		
	; BPLCON1 mit einer Verzögerung von 15 Pixeln initialisieren ($00FF)

	move.w #BPLCON1,(a0)+					; dc.w $0102
	move.w #$00FF,(a0)+						; dc.w $00FF						--> dc.w $0102,$00FF
	
	; Warten Sie auf die Position in der Zeile, die dem Beginn der Anzeige
	; entspricht (horizontale Position $3D in einem WAIT).

	move.w d0,d2							; 
	or.w #ZOOM_X!$0001,d2					; dc.w $403d
	move.w d2,(a0)+							; 
	move.w #$8000!($7F<<8)!$FE,(a0)+		; dc.w $FFFE						--> dc.w $403d,$FFFE	

	; MOVEs aneinanderreihen, die nichts tun, bis zu dem, der die Verzögerung an ZOOM_BPLCON1 weitergeben muss

	IFNE ZOOM_MOVE		; Denn ASM-One stürzt auf einem REPT ab, dessen Wert 0 ist...
	REPT ZOOM_MOVE							; 17 Wiederholungen																			; 17 moves
	move.l #ZOOM_NOP,(a0)+					; $01FE0000		= NULL := 0x0000 	No operation/NULL (Copper NOP instruction)
	ENDR									;									--> 17* dc.w $01FE,$0000
	ENDC

	; Ändern Sie BPLCON1, um die Verzögerung auf ZOOM_BPLCON1 umzustellen.		

	move.w #BPLCON1,(a0)+					; dc.w $0102	
	move.w #ZOOM_BPLCON1,(a0)+				; dc.w $0022						--> dc.w $0102,$0022 									; 1 move

	; Verketten von MOVEs, die nichts tun, bis zum Ende der Zeile

	IFNE 39-ZOOM_MOVE		; Denn ASM-One stürzt auf einem REPT ab, dessen Wert 0 ist...
	REPT 39-ZOOM_MOVE						; 39-17=22																					; 22 moves		= 17+1+22=40 moves
	move.l #ZOOM_NOP,(a0)+					; $01FE0000		= NULL := 0x0000	No operation/NULL (Copper NOP instruction)
	ENDR									;									--> 22* dc.w $01FE,$0000
	ENDC

	; Zur nächsten Zeile im gezoomten Zeilenband springen

	addi.w #$0100,d0						; nächstes Wait eine Zeile tiefer
	dbf d1,_zoomLines						; über alle Zeilen wiederholen

	; BPLCON1 ($00FF) für das Ende des Bildschirms zurücksetzen

	move.w #BPLCON1,(a0)+					; dc.w $0102
	move.w #$00FF,(a0)+						; dc.w $00FF						--> dc.w $0102,$00FF

	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)				; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

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
	
	move.w #$03AA,BLTCON0(a5)				; USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #$0000,BLTCON1(a5)				; keine Sondermodi
	move.w #-(DISPLAY_DX>>3),BLTCMOD(a5)	; BLTCMOD = -(320/8 = 40 Bytes) eine Zeile zurück
	move.w #0,BLTDMOD(a5)					; BLTDMOD = 0
	move.l #linePattern,BLTCPTH(a5)			; Quelle - Kanal C = linePattern
	movea.l bitplanes,a0					; Anfangsadresse bitplanes
	move.l a0,BLTDPTH(a5)					; Ziel - Kanal D 
	move.w #((3*ZOOM_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; (3*20) Zeilen 320/16=20 Wörter Breite
	WAIT_BLITTER

	; Löschen Sie die Bitplane 2 und füllen Sie sie mit 1, um den Hintergrund des
	; Bildschirms (COLOR02) vom Rand des Bildschirms (COLOR00) zu unterscheiden.

	move.w #$01AA,BLTCON0(a5)				; USEA=0, USEB=0, USEC=0, USED=1, D=C
	move.w #$0000,BLTCON1(a5)				; keine Sondermodi
	move.w #$FFFF,BLTCDAT(a5)				; Kanal C mit festen Wert vorladen
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0	; 256*(320/8) zur Adresse hinzufügen, nächste Bitebene
	move.l a0,BLTDPTH(a5)					; Ziel - Kanal D 
	move.w #((3*ZOOM_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; (3*20) Zeilen 320/16=20 Wörter Breite
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

		end

Programmbeschreibung: zoom1.s

In diesem Beispiel wird der Hardwarescroll durch 2 verschiedene Werte im
Register BPLCON1 veranschaulicht. ($00ff = 15 Pixel und $0022 = 2 Pixel in der
Mitte des Bildschirms)

Das Videofenster ist für ein Bild von 320x256 Pixel eingerichtet. Der größte
Teil des Bildschirms bleibt jedoch schwarz.

Durch zwei Blitts werden die beiden Bitebenen mit Pixelwerten gefüllt. 

Der erste Blitt füllt die Bitebene 1 mit einem sich jede Zeile wiederholenden
Muster. Das Muster ist für die gesamte Breite des Bildes also 20 Wörter und
zwar immmer 1 Pixel, 2 Pixel, 3 Pixel usw.

linePattern:		DC.W $0001, $0003, $0007, $000F, $001F, $003F, $007F, $00FF, $01FF, $03FF 
					DC.W $07FF, $0FFF, $1FFF, $3FFF, $7FFF, $0000, $0000, $0000, $0000, $0000

Bei diesem Blitt erfolgt eine Kopie von Kanal C nach Kanal D. Nach dem Kopieren 
einer Zeile wird durch den negativen Modulowert auf den Anfangswert des Musters
zurückgegangen um in der nächsten Zeile das selbe Muster erneut zu kopiern. Die
Höhe des Blitts sind 60 Zeilen.

Im zweiten Blitt wird der Hintergrund des Bereiches (60 Zeilen * 20 Wörter)
komplett gefüllt um es vom schwarzen Hintergrund abzuheben. Erreicht wird das
durch das wiederholte Kopieren eines festen Wertes in BLTCDAT=$ffff.

Jetzt ist das Bild im Speicher und wird durch die Copperliste angezeigt.

Im nächsten Schritt kommt die angepasste Copperliste ins Spiel und zwar gibt es
drei vertikale Wartepositionen. 

Ohne extra-Wait 
 0006a4d8: 008e 2c81            ;  DIWSTRT := 0x2c81				; Bild beginnt hier
 0006a4dc: 0090 2cc1            ;  DIWSTOP := 0x2cc1
 0006a4e8: 0100 2200            ;  BPLCON0 := 0x2200
 0006a4ec: 0102 00ff            ;  BPLCON1 := 0x00ff				; erster Shiftwert	15px	
 0006a4f0: 0104 0008            ;  BPLCON2 := 0x0008
 
20 Zeilen tiefer				; dc.w $4001,$FFFE
 0006a520: 4001 fffe            ;  Wait for vpos >= 0x40 and hpos >= 0x00	; 20 Zeilen tiefer
                                ;  VP 40, VE 7f; HP 00, HE fe; BFD 1
 0006a524: 0102 00ff            ;  BPLCON1 := 0x00ff						; zweiter Shiftwert	

Weitere 20 Zeilen tiefer		; dc.w $5301 fffe
0006b290: 0102 00ff             ;  BPLCON1 := 0x00ff						; 20 Zeilen tiefer  ; dritter Shiftwert
0006b294: ffff fffe             ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist

Und nun kommt die eigentliche Besonderheit ins Spiel:

>?$40-$2c
$00000014 = %00000000`00000000`00000000`00010100 = 20 = 20
>?$54-$40
$00000014 = %00000000`00000000`00000000`00010100 = 20 = 20

Von Zeile $40 bis $53 werden pro Zeile ab dem horizontalen Startwert $3d
(besser $39) 40 Copper "Nop" moves eingefügt. Hintergrund ist, das jeder 
Coppermove 8 Pixel benötigt und somit dadurch eine Synchronisation zum 
Bildschirm erreicht werden kann.

 0006a520: 4001 fffe            ;  Wait for vpos >= 0x40 and hpos >= 0x00			; 20 Zeilen tiefer
                                ;  VP 40, VE 7f; HP 00, HE fe; BFD 1
 0006a524: 0102 00ff            ;  BPLCON1 := 0x00ff								; zweiter Shiftwert	
>o
 0006a528: 403d fffe [040 00c]  ;  Wait for vpos >= 0x40 and hpos >= 0x3c			; letzter wait
                                ;  VP 40, VE 7f; HP 3c, HE fe; BFD 1
 0006a52c: 01fe 0000            ;  NULL := 0x0000
 0006a530: 01fe 0000            ;  NULL := 0x0000
 0006a534: 01fe 0000            ;  NULL := 0x0000
 0006a538: 01fe 0000            ;  NULL := 0x0000
 0006a53c: 01fe 0000            ;  NULL := 0x0000
 0006a540: 01fe 0000            ;  NULL := 0x0000
 0006a544: 01fe 0000            ;  NULL := 0x0000
 0006a548: 01fe 0000            ;  NULL := 0x0000
 0006a54c: 01fe 0000            ;  NULL := 0x0000
 0006a550: 01fe 0000            ;  NULL := 0x0000
 0006a554: 01fe 0000            ;  NULL := 0x0000
 0006a558: 01fe 0000            ;  NULL := 0x0000
 0006a55c: 01fe 0000            ;  NULL := 0x0000
 0006a560: 01fe 0000            ;  NULL := 0x0000
 0006a564: 01fe 0000            ;  NULL := 0x0000
 0006a568: 01fe 0000            ;  NULL := 0x0000
 0006a56c: 01fe 0000            ;  NULL := 0x0000				 
 0006a570: 0102 0022            ;  BPLCON1 := 0x0022				; 1. move bplcon1
 0006a574: 01fe 0000            ;  NULL := 0x0000
>o
 0006a578: 01fe 0000            ;  NULL := 0x0000
 0006a57c: 01fe 0000            ;  NULL := 0x0000
 0006a580: 01fe 0000            ;  NULL := 0x0000
 0006a584: 01fe 0000            ;  NULL := 0x0000
 0006a588: 01fe 0000            ;  NULL := 0x0000
 0006a58c: 01fe 0000            ;  NULL := 0x0000
 0006a590: 01fe 0000            ;  NULL := 0x0000
 0006a594: 01fe 0000            ;  NULL := 0x0000
 0006a598: 01fe 0000            ;  NULL := 0x0000
 0006a59c: 01fe 0000            ;  NULL := 0x0000
 0006a5a0: 01fe 0000            ;  NULL := 0x0000
 0006a5a4: 01fe 0000            ;  NULL := 0x0000
 0006a5a8: 01fe 0000            ;  NULL := 0x0000
 0006a5ac: 01fe 0000            ;  NULL := 0x0000
 0006a5b0: 01fe 0000            ;  NULL := 0x0000
 0006a5b4: 01fe 0000            ;  NULL := 0x0000
 0006a5b8: 01fe 0000            ;  NULL := 0x0000
 0006a5bc: 01fe 0000            ;  NULL := 0x0000
 0006a5c0: 01fe 0000            ;  NULL := 0x0000
 0006a5c4: 01fe 0000            ;  NULL := 0x0000
>o
 0006a5c8: 01fe 0000            ;  NULL := 0x0000				 ; 40 Moves	

																 ; am Ende 
 0003dd38: 0102 00ff            ;  BPLCON1 := 0x00ff
 0003dd3c: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist


 In etwa der Mitte des Bildes wird der horizontale Hardwarescrollwert einmalig geändert
 und erst mit der nächsten Zeile auf den Wert $00ff zurückgesetzt.

 Was ist zu sehen? Da im oberen und unteren Drittel des Bildes der Verschiebungswert max
 $00ff ist sind diese Zeilen um 15 Pixel nach rechts verschoben. Im mittleren Drittel
 wurde ein geringerer Verschiebungswert eingestellt, d.h. das Bild ist ab der horizontalen
 Mitte nicht so weit nach rechts verschoben. Das Bild ist also ab der Mitte horizontal
 nach links versetzt. Am linken Rand dieses Bereichs entsteht eine Lücke von einem Pixel.
 Dies ist dadurch begründet, dass wir nur 15Pixel und nicht 16 Pixel verschieben können
 und die nächste Änderung des BPLCON1 immer nur zu allen 16 Pixeln erfolgen kann.
