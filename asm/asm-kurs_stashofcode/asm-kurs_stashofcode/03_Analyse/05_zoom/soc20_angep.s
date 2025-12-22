
; soc20_angep.s = zoom3.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Horizontaler Hardware-Zoom eines Bildes auf 1 Bitplane (logische Fortsetzung von zoom.s)

; Für jede Zeile einer vertikalen Region von ZOOM_DY Zeilen, die bei der Zeile
; ZOOM_Y beginnt, enthält die Copperlist :

; [0]	WAIT ($00 & $FE, Y & $7F)
; [4]	MOVE BPL1MOD
; [8]	MOVE BPL2MOD
; [12]	MOVE BPLCON1
; [16]	WAIT ($3D & $FE, Y & $7F)
; [20]	40 MOVE, davon eine Reihe in BPLCON1, die anderen entsprechen NOP

; Das Prinzip besteht darin, die Copperlist so wenig wie möglich zu verändern. Bei jedem Zoom-Schritt:

; - Nur die MOVE-Anweisungen in BPL1MOD und BPL2MOD der gelöschten Zeilen werden geändert,
; um diese Zeilen zu löschen: Die Werte von MOVE x,BPL1MOD und MOVE x,BPL2MOD werden geändert.

; - Nur die MOVE-Anweisungen der gelöschten Spalten werden geändert:
; Ein ZOOM_NOP wird durch ein MOVE x,BPLCON1 ersetzt.

; Jeder Zoom wird von einem Prinzip beherrscht: Wenn das Bild schrittweise verkleinert wird,
; darf ein Pixel, das entfernt wurde, später nicht wieder auftauchen. Dieses Prinzip kann
; horizontal leicht eingehalten werden, da der Hardware-Zoom auf einem Mechanismus beruht,
; der das letzte Pixel einer Gruppe von 16 Pixeln unabhängig von den anderen Pixeln auslöscht.
; Vertikal ist das Prinzip schwieriger einzuhalten, da der Hardware-Zoom auf einem Mechanismus
; beruht, der eine Zeile in Abhängigkeit von den zuvor gelöschten Zeilen löscht. Um es anders
; auszudrücken: Das Löschen von Spalten beruht auf absoluten Referenzen (wenn man N Spalten 
; löschen muss, um von einem Zoomschritt zum nächsten zu gelangen, kann man jede Spalte
; unabhängig von den anderen bezeichnen : Einmal heranzoomen und dabei N Spalten löschen,
; heißt, die zu löschenden Spalten im Ausgangsbild zu bestimmen und dann alle auf einmal in
; diesem Bild zu löschen), das Löschen von Zeilen beruht auf relativen Referenzen (wenn man
; N Zeilen löschen muss, um von einem Zoomschritt zum nächsten zu gelangen, muss man jede
; Zeile unter Berücksichtigung der anderen bestimmen: einmal heranzoomen und dabei N Zeilen
; löschen, heißt, eine zu löschende Zeile im Ausgangsbild zu bestimmen, diese zu löschen und
; dann die nächste zu löschende Zeile im resultierenden Bild zu bestimmen usw.), das Löschen
; von Zeilen beruht auf relativen Referenzen (wenn man N Zeilen löschen muss, um von einem
; Zoomschritt zum nächsten zu gelangen, muss man jede Zeile unter Berücksichtigung der anderen
; bestimmen: einmal heranzoomen und dabei N Zeilen löschen, heißt, eine zu löschende Zeile im
; Ausgangsbild zu bestimmen, diese zu löschen und dann die nächste zu löschende Zeile im
; resultierenden Bild zu bestimmen usw.). )

; Aber jede Medaille hat ihre Kehrseite, und die Erleichterung, die der horizontale
; Hardware-Zoom gegenüber dem vertikalen Hardware-Zoom bietet, hat ihren Preis. Während
; beim vertikalen Hardware-Zoom N beliebige Zeilen gelöscht werden können, kann beim
; horizontalen Hardware-Zoom nur eine Spalte alle 16 Spalten bis zu 15 Spalten gelöscht
; werden. Das Problem ist klar: Wenn die Breite des Bildes unter 16*15 sinkt, verringert
; sich die Anzahl der Spalten, die gelöscht werden können:

; 306          => 306 / 16 = 19 >= 15 => man kann bis zu 15 Spalten löschen
; 306-15 = 291 => 291 / 16 = 18 >= 15 =>  dito
; 291-15 = 276 => 276 / 16 = 17 >= 15 =>  dito
; 276-15 = 261 => 261 / 16 = 16 >= 15 =>  dito
; 261-15 = 246 => 246 / 16 = 15 >= 15 =>  dito
; 246-15 = 231 => 231 / 16 = 14 < 15 => man kann nur 14 Spalten löschen
; 231-14 = 217 => 217 / 16 = 13 < 15 => man kann nur 13 Spalten löschen
; ...

; Um ein Bild von 306 auf 15 Pixel Breite zu verkleinern (ab dieser Breite kann keine
; Spalte mehr entfernt werden), müssen 46 Schritte durchlaufen werden, wobei jeder Schritt
; darin besteht, alle möglichen Spalten durch Hardware-Zoom zu entfernen und dann das Bild
; zu aktualisieren, indem die Spalten tatsächlich entfernt werden (Software-Zoom), bevor der
; Hardware-Zoom zurückgesetzt wird und das neue Bild erneut gezoomt werden kann.
; Der Mechanismus ist in der Excel-Datei beschrieben.

; Die Copperlist muss mit einem Doppelpuffer verwaltet werden. Die Anweisungen, die sie enthält,
; werden nämlich im gesamten Frame ausgeführt, so dass das Zeitintervall, das zur Verfügung 
; steht, um sie vollständig zu ändern, ohne Flicker zu verursachen, ansonsten extrem kurz wäre:
; zwischen dem Ende der letzten Zeile des Frames, an dem der Copper warten musste, um die
; Copperlist fertig auszuführen, indem er die Werte von BPLCON1 entlang der Zeile änderte 
; (kurz, die nächste Zeile DISPLAY_Y + DISPLAY_DY), und der ersten Zeile, ab der der Copper
; beginnt, die Copperlist auszuführen, d. h. der Zeile 0.


;********** Konstanten **********

; Programm

DISPLAY_DEPTH=4
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
PICTURE_DY=256
ZOOM_Y=DISPLAY_Y
ZOOM_X=$3D
ZOOM_DY=DISPLAY_DY
ZOOM_NOP=$01FE0000
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+ZOOM_DY*(5+40)*4+4+4
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder $00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
;BPLCON1_val = $00FF
BPLCON1_val = $0000
BPLCON2_val = $0008																; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
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
	move.l d0,copperListA

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperListB

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanesA

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanesB

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

	movea.l copperListA,a0

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

	move.l bitplanesA,d0					; Anfangsadresse bitplane
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

	lea colors,a1							; Tabelle mit 32 Farbwerten
	IFNE DEBUG
	move.l #$01FE0000,(a0)+					; NOP-Äquivalent, um jede Änderung von COLOR00 zu neutralisieren,
											; ohne die Größe der Palette in der Copperlist zu ändern
	move.w #COLOR01,d1						; Farbregister Startwert
	lea 2(a1),a1							; Offset erhöhen um 2 Bytes 
	moveq #(1<<DISPLAY_DEPTH)-2,d0			; 00000001 = 1 , 00010000 = 16, 16-2=14 Startwert Schleifenzähler
	ELSE
	move.w #COLOR00,d1						; Farbregister Startwert
	moveq #(1<<DISPLAY_DEPTH)-1,d0			; 00000001 = 1 , 00010000 = 16, 16-1=15 Startwert Schleifenzähler
	ENDC
_copperListColors:
	move.w d1,(a0)+							; Farbregister in Copperlist
	addq.w #2,d1							; nächster Farbregisterwert
	move.w (a1)+,(a0)+						; Farbwerte des Bildes in Copperlist speichern
	dbf d0,_copperListColors				; für alle Farbregister wiederholen

	;Zoom

	move.w #ZOOM_Y<<8,d0					; $2c<<8 = $2c00
	move.w #ZOOM_DY-1,d2					; 256-1 Zeilen Schleifenzähler
_zoomLines:
	move.w d0,d1							; $2c00 Kopie
	or.w #$00!$0001,d1						; dc.w $2c01 
	move.w d1,(a0)+							; Wait-Position in Copperlist schreiben
	move.w #$8000!($7F<<8)!$FE,(a0)+		; dc.w $FFFE
	move.w #BPL1MOD,(a0)+					; BPL1MOD Wert in Copperlist schreiben
	move.w #0,(a0)+							;
	move.w #BPL2MOD,(a0)+					; BPL2MOD Wert in Copperlist schreiben
	move.w #0,(a0)+							;
	move.w #BPLCON1,(a0)+					; BPLCON1 Wert in Copperlist schreiben
	move.w #$0007,(a0)+						; dc.w $102,$0007
	move.w d0,d1							; $2c00 Kopie	
	or.w #ZOOM_X!$0001,d1					; dc.w $2c3d
	move.w d1,(a0)+							; Wait-Position in Copperlist schreiben
	move.w #$8000!($7F<<8)!$FE,(a0)+		; dc.w $FFFE
	move.w #40-1,d3							; 40-1 Schleifenzähler für move nop
_zoomLine:
	move.l #ZOOM_NOP,(a0)+					; $01FE0000		= NULL := 0x0000 	No operation/NULL (Copper NOP instruction)
	dbf d3,_zoomLine						; über eine Zeilen wiederholen
	addi.w #$0100,d0						; nächstes Wait eine Zeile tiefer
	dbf d2,_zoomLines						; über alle Zeilen wiederholen
	move.w #BPLCON1,(a0)+					; BPLCON1 Wert in Copperlist schreiben
	move.w #$0000,(a0)+						; dc.w $102,$0000
	
	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)				; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; copperlist aktivieren

	move.l copperListA,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Kopieren des Bildes in Bitplane 1

	move.w #$05CC,BLTCON0(a5)				; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)				; keine Sondermodi
	move.w #0,BLTBMOD(a5)					; BLTBMOD = 0 
	move.w #0,BLTDMOD(a5)					; BLTBMOD = 0 
	move.l #picture,BLTBPTH(a5)				; Quelle - Kanal B - picture
	movea.l bitplanesA,a0					; Anfangsadresse bitplanesA
	;lea ((DISPLAY_DY-PICTURE_DY)>>1)*(DISPLAY_DX>>3)(a0),a0	; Offset in bitplanesA  (256-256)/2 * (320/8)
	move.l a0,BLTDPTH(a5)					; Ziel - Kanal D - bitplanesA
	move.w #(PICTURE_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)		; 256 Zeilen und 320/16=20 Wörter Breite
	WAIT_BLITTER

	; Kopieren der Copperlist, um eine Version zu erhalten, die ohne
	; Auswirkungen auf die Anzeige geändert werden kann. 	

	move.w #(COPSIZE>>2)-1,d0				; Anzahl Bytes/4 (Longwort) Schleifenzähler
	movea.l copperListA,a0					; Zeiger CopperlistA
	movea.l copperListB,a1					; Zeiger CopperlistB
_copyCopperList:
	move.l (a0)+,(a1)+						; Kopie der Copperlist
	dbf d0,_copyCopperList					; wiederholen für alle Copperlistwörter

;---------- Hauptschleife ----------

	lea zoomSteps,a0						; Anfangsadresse Feld Zoomsteps
	lea zoomColumns,a1						; Anfangsadresse Tabelle mit den Zoomwerten
	move.l a1,zoomColumnsB					; Anfangsadresse Tabelle mit den Zoomwerten speichern
	clr.b d0								; d0.b zurücksetzen
	move.b d0,nbColumnsB					; Anzahl Spalten zurücksetzen

	; Warten auf das Ende des Frames
_loop:
	move.w d0,d1							; Kopie d0
	moveq #1,d0								; Anzahl 1 Frames warten
	jsr _wait								; und auf das Ende des Bildes warten
	move.w d1,d0							; Wert zurückschreiben nach d0

	; Coppperliste zirkulär austauschen

	move.l copperListB,d1					; copperListB Adresse zwischenspeichern
	move.l copperListA,copperListB			; Adresse copperListA wird copperListB
	move.l d1,copperListA					; Adresse copperListB wird copperListA
	move.l copperListA,COP1LCH(a5)			; Copperpointer bekommt neue Adresse 

	; Zoom zurücksetzen: Löschen der vorherigen MOVEs in BPLCON1
	
	movea.l zoomColumnsB,a4					; Anfangsadresse Tabelle mit den Zoomwerten
	lea 1(a4),a4							; nächste Byte in der Tabelle
	movea.l copperListB,a2					; Anfangsadresse CopperlistB zum Schreiben
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+5*4(a2),a2	; OFFset zu Anfangsadresse Copperlist hinzufügen
											; 10*4+4*2*4+16*4+5*4=156
	move.b nbColumnsB,d1					; aktueller Wert nach d1
_clearBPLCON1a:
	subq.b #1,d1							; aktueller Wert um 1 verringern
	blt _clearBPLCON1Done					; wenn < 0, dann fertig und raus
	clr.w d2								; d2.w zurücksetzen
	move.b (a4)+,d2							; aktueller Zoomwert nach d2
	add.w d2,d2								; Zoomwert verdoppeln
	add.w d2,d2								; D2 = MOVE-Offset in BPLCON1 durch NOP auf allen Zeilen zu ersetzen
	lea (a2,d2.w),a3						; Anfangsadresse von Zoomabschnitt in Copperlist + Offset
	move.w #ZOOM_DY-1,d2					; 256 Schleifenzähler
_clearBPLCON1b:
	move.l #ZOOM_NOP,(a3)					; $01FE0000		= NULL := 0x0000 	No operation/NULL (Copper NOP instruction)
	lea (5+40)*4(a3),a3						; neuer Offset für 
	dbf d2,_clearBPLCON1b					; für alle xxx wiederholen
	bra _clearBPLCON1a						; zurück zu _clearBPLCON1a 
_clearBPLCON1Done:

	; Speichern Sie die Informationen, die benötigt werden, um (beim nächsten Frame)
	; die MOVEs aus der Copperlist zu löschen, die nun auf dem Bildschirm zu sehen ist.

	move.l a1,zoomColumnsB					; Adresse speichern
	move.b d0,nbColumnsB

	;++++++++++ Verkleinern Sie das Bild, wenn es nicht mehr möglich ist, die Zoom-Hardware weiter zu schieben ++++++++++

	cmp.b ZOOMSTEP_GROUPS_ZOOMED(a0),d0		; D0 = # der Spalten / Zeilen, die zu diesem Zeitpunkt gelöscht wurden
	bne _noShrink

	; Beenden, wenn das Zoomen nicht fortgesetzt werden kann

	tst.b ZOOMSTEP_DATASIZE(a0)				; 
	beq _end

	; Bild löschen
	
	move.w #$01CC,BLTCON0(a5)				; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)				; keine Sondermodi
	move.w #$0000,BLTBDAT(a5)				; Kanal B mit festen Wert vorladen
	move.w #0,BLTDMOD(a5)					; BLTDMOD = 0
	move.l bitplanesB,BLTDPTH(a5)			; Ziel - Kanal D - bitplanesB
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; 256 Zeilen und 320/16=20 Wörter Breite
	WAIT_BLITTER

	; Kopieren Sie die nicht gezoomten Gruppen links von der ersten gezoomten
	; Gruppe sowie die erste gezoomte Gruppe nach dem Ausblenden ihres letzten
	; Pixels, indem Sie sie nach rechts verschieben.
	
	move.w #$0002,BLTCON1(a5)				; DESC=1, für Kopie mit Linksverschiebung

	clr.w d0								; d0.w zurücksetzen
	move.b ZOOMSTEP_GROUPS_FIRST(a0),d0				; 2(a0)			a0=Anfangsadresse Feld Zoomsteps d0=0
	clr.w d1								; d1.w zurücksetzen
	move.b ZOOMSTEP_GROUPS_NOTZOOMED_LEFT(a0),d1	; 3(a0)			a0=Anfangsadresse Feld Zoomsteps d1=2	
	addq.b #2,d1							; Fügen Sie die erste gezoomte Gruppe sowie eine Gruppe hinzu,
											; in der die verschobenen Pixel gejagt werden.			 d1=2+2=4
	add.b d1,d0								; 0+4=4
	add.b d0,d0								; 4+4=8
	addi.w #(DISPLAY_DY-1)*(DISPLAY_DX>>3)-4,d0		; (256-1)*(320/8)-4=10196 fester Offset + 8
	movea.l bitplanesA,a2					; bitplanesA
	lea (a2,d0.w),a2						; bitplanesA + Offset
	move.l a2,BLTAPTH(a5)					; Quelle - Kanal A - bitplanesA + Offset
	movea.l bitplanesB,a3					; Anfangsadresse bitplanesB
	lea 2(a3,d0.w),a3						; Um beim Kopieren mit Linksverschiebung im DESC-Modus einen
											; Rechtsversatz zu erzeugen, muss das Ziel einen WORD nach der Quelle liegen
	move.l a3,BLTDPTH(a5)					; Ziel Kanal D - bitplanesB + Offset
	move.w #DISPLAY_DX>>4,d0				; 320/16=20 Wörter 
	sub.w d1,d0								; d0=20-4=16
	add.w d0,d0								; d0 verdoppeln 16*2=32 in Bytes
	move.w d0,BLTAMOD(a5)					; BLTAMOD = 32	= $20 (variabel)
	move.w d0,BLTDMOD(a5)					; BLTDMOD = 32	= $20 (variabel)
	clr.w d0								; d0.w zurücksetzen
	move.b ZOOMSTEP_SHIFT(a0),d0			; 1(a0)					a0=Anfangsadresse Feld Zoomsteps d0=8
	ror.w #4,d0								; kommt in den A-Shifter
	move.w #$09F0,d2						; Kopie D=A und Kanäle aktivieren
	or.w d0,d2								; zusammen mit dem A-Shifter
	move.w d2,BLTCON0(a5)					; ASH3-0=Verschiebung, USEA=1, USEB=0, USEC=0, USED=1, D=A
	move.w #$FFFE,BLTAFWM(a5)				; Bit rechts wird gelöscht
	move.w #$0000,BLTALWM(a5)				; alles wird gelöscht
	or.w #DISPLAY_DY<<6,d1					; 256 Zeilen + 4 Wörter	$4004
	move.w d1,BLTSIZE(a5)					; 
	WAIT_BLITTER

	; Kopieren Sie die gezoomten Gruppen, indem Sie ihr letztes Pixel ausblenden,
	; indem Sie sie immer weniger nach rechts verschieben (also den Versatz nach 
	; links in BLTCON1 erhöhen).
	nop
	move.b ZOOMSTEP_GROUPS_ZOOMED(a0),d1	; 0(a0) -> Anfangsadresse Feld Zoomsteps, # der zu löschenden Spalten (also # der gezoomten Gruppen)
	move.w #$FFFE,BLTAFWM(a5)				; Pixel der ersten Grupe ganz rechts löschen
	move.w #(DISPLAY_DX-32)>>3,BLTAMOD(a5)	; BLTAMOD = (320-32)/8=36 Bytes
	move.w #(DISPLAY_DX-32)>>3,BLTCMOD(a5)	; BLTCMOD = (320-32)/8=36 Bytes
	move.w #(DISPLAY_DX-32)>>3,BLTDMOD(a5)	; BLTDMOD = (320-32)/8=36 Bytes
_shrinkColumns:
	subq.b #1,d1							; Zoomstepwert um 1 verringern
	beq _shrinkDone							; wenn 0, dann fertig und überspringen
	addi.w #$1000,d0						; Wenn der Offset 15 erreicht, wird er wie gewünscht auf einen
											; Offset von 15 zurückgeschaltet: $Fxxx + $1000 = $0000
	beq _shrinkKeepDestinationWord			; Wir müssen den heiklen Fall bewältigen, dass der Linksversatz
											; in die Sättigung geht, d.h. wenn er auf 16 gehen soll, obwohl er nicht
											; über 15 hinausgehen kann: Dann ist es eine Adressänderung und ein
											; Zurücksetzen des Offsets auf 0.
	lea 2(a3),a3							; nächste Wort im Ziel bitplanesB
_shrinkKeepDestinationWord:
	lea 2(a2),a2							; nächste Wort in der Quelle bitplanesA
	move.w d0,d2							; Kopie Verschiebungswert
	or.w #$0BFA,d2							; BLTCONO-Wert zusammenbauen
	move.w d2,BLTCON0(a5)					; ASH3-0=Verschiebung, USEA=1, USEB=0, USEC=1, USED=1, D=A+C
	move.l a2,BLTAPTH(a5)					; Quelle Kanal A - bitplanesA + Offset
	move.l a3,BLTCPTH(a5)					; Quelle Kanal C - bitplanesB + Offset
	move.l a3,BLTDPTH(a5)					; Ziel Kanal D - bitplanesB + Offset
	move.w #(DISPLAY_DY<<6)!2,BLTSIZE(a5)	; 256 Zeilen und 2 Wörter Breite
	WAIT_BLITTER							; 
	bra _shrinkColumns						; zurück zu (_shrinkColumns) Spalte schrumpfen
_shrinkDone:

	; Kopieren Sie die nicht gezoomten Spalten, die auf die letzte gezoomte
	; Spalte folgen, indem Sie sie nach rechts verschieben.

	clr.w d1								; d1.w zurücksetzen
	move.b ZOOMSTEP_GROUPS_NOTZOOMED_RIGHT(a0),d1	; 4(a0) -> Anfangsadresse Feld Zoomsteps
	beq _shrinkRDone						; wenn 0 dann überspringen
	addi.w #$1000,d0						; Shiftwert erhöhen
; braucht es nicht wie oben eine Grenzübertrittskontrolle auf A3?
	or.w #$0BFA,d0							; ASH3-0=Verschiebung, USEA=1, USEB=0, USEC=1, USED=1, D=A+C
	move.w d0,BLTCON0(a5)					; BLTCON0 Wert zusammenbauen
	move.w #$FFFF,BLTAFWM(a5)				; alles passiert
	move.w d1,d0							; Kopie Wert Gruppe nichtgezoomt rechts
	addq.b #1,d1							; Eine Gruppe hinzufügen, in der verschobene Pixel verschoben werden sollen
	move.w #DISPLAY_DX>>4,d2				; 256/16=20 Wörter
	sub.b d1,d2								; 20-4=16
	add.w d2,d2								; 16*2=32
	move.w d2,BLTAMOD(a5)					; BLTAMOD = 32 = $20 (variabel)
	move.w d2,BLTCMOD(a5)					; BLTCMOD = 32 = $20 (variabel)
	move.w d2,BLTDMOD(a5)					; BLTDMOD = 32 = $20 (variabel)
	add.b d0,d0								; 3+3=6 Offset	
	lea (a2,d0.w),a2						; bitplanesA + Offset
	move.l a2,BLTAPTH(a5)					; Quelle - Kanal A = bitplanesA + Offset
	lea (a3,d0.w),a3						; 
	move.l a3,BLTCPTH(a5)					; Quelle - Kanal A
	move.l a3,BLTDPTH(a5)					; Ziel - Kanal D
	or.w #DISPLAY_DY<<6,d1					; 256 Zeilen + x Wörter
	move.w d1,BLTSIZE(a5)					; 
	WAIT_BLITTER
_shrinkRDone:

	; Bitplanes zirkulär vertauschen

	move.l bitplanesB,d0					; Adresse bitplanesB speichern
	move.l bitplanesA,bitplanesB			; Adresse bitplanesA nach bitplanesB kopieren
	move.l d0,bitplanesA					; Adresse bitplanesB nach bitplanesA kopieren
	
	movea.l copperListB,a2					; Adresse copperListB 
	movea.l copperListA,a3					; Adresse copperListA 
	lea 10*4+2(a2),a2						; zur Anfangsadresse von copperListB hinzufügen 
	lea 10*4+2(a3),a3						; zur Anfangsadresse von copperListA hinzufügen
	move.w #DISPLAY_DEPTH-1,d2				; über alle Bitebenen, hier 4
_swapBitplanes:
	swap d0									; Wörter tauschen
	move.w d0,(a2)							; hohen Teil der Adresse in Copperlist
	move.w d0,(a3)							; hohen Teil der Adresse in Copperlist
	swap d0									; Wörter tauschen
	move.w d0,4(a2)							; niedrigen Teil der Adresse in Copperlist
	move.w d0,4(a3)							; niedrigen Teil der Adresse in Copperlist
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d0	; 256*(320/8) Offset - nächste Bitebene
	lea 8(a2),a2							; nächster Bitplanepointer in Copperlist
	lea 8(a3),a3							; nächster Bitplanepointer in Copperlist
	dbf d2,_swapBitplanes					; wiederholen bis alle getauscht	

	; Zoom zurücksetzen: sich darauf vorbereiten, nur die erste
	; Spalte einer neuen Reihe von Spalten zu löschen

	lea ZOOMSTEP_DATASIZE(a0),a0			; 5(a0) zeigt dadurch auf die nächste Gruppe von 5 Bytewerten in zoomSteps
	lea zoomColumns,a1						; Anfangsadresse Feld Zoomsteps
	clr.b d0								; d0.b zurücksetzen

_noShrink:

	;++++++++++ Zoom anwenden ++++++++++

	; den Zoom animieren

	addq.b #1,d0							; Anzahl erledigter Spalten (Spaltenzähler +1)
	lea 16(a1),a1							; Anfangsadresse Feld Zoomsteps + Offset

	; Ändern Sie den Wert der MOVE BPLCON1 Zeilenstart, um das Bild horizontal zu zentrieren.

	movea.l a1,a2							; Adressen Kopie
	movea.l copperListB,a3					; Anfanfgsadresse von copperListB
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+3*4+2(a3),a3	; Offset hinzufügen
	clr.w d2								; d2.w zurücksetzen
	move.b (a2)+,d2							; D2 = ursprünglicher BPLCON1-Wert
	move.w #ZOOM_DY-1,d3					; 256-1 Zeilen Schleifenzähler
_setStartingBPLCON1:
	move.w d2,(a3)							; nächster BPLCON1-Wert in CopperlistB speichern
	lea (5+40)*4(a3),a3						; 45*4=180 Bytes Offset hinzufügen
	dbf d3,_setStartingBPLCON1				; wenn noch nicht xxx, dann weitermachen BPLCON1

	; Schreiben Sie die neuen MOVE-Werte und den neuen MOVE in BPL1CON,
	; um die Spalte in allen Zeilen zu löschen.

	move.b d0,d3							; D3 = # der zu löschenden Spalten
	movea.l copperListB,a3					; Anfanfgsadresse von copperListB
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+5*4(a3),a3	; Offset hinzufügen
_setBPLCON1a:
	subi.w #$0001,d2						; BPLCON1-Wert um 1 verringern
	clr.w d4								; d4.w zurücksetzen
	move.b (a2)+,d4							; D2 = ursprünglicher BPLCON1-Wert
	add.w d4,d4								; 
	add.w d4,d4								; D4 = offset von MOVE in BPLCON1, um die Spalte zu löschen
	lea (a3,d4.w),a4						; Adresse Anfang Copperlist + ermittelter Offset in a4
	move.w #ZOOM_DY-1,d4					; 256-1 Zeilen Schleifenzähler
_setBPLCON1b:
	move.w #BPLCON1,(a4)					; BPLCON1 in Copperlist
	move.w d2,2(a4)							; BPLCON1-Wert in Copperlist speichern
	lea (5+40)*4(a4),a4						; 45*4=180 Bytes Offset hinzufügen
	dbf d4,_setBPLCON1b						; wenn noch nicht fertig, dann weitermachen nächste Zeile
	subq.b #1,d3							; zu löschende Spalte -1
	bne _setBPLCON1a						; wenn noch nicht xxx, dann weitermachen BPLCON1

	btst #6,$BFE001
	bne _loop

_end:

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

	movea.l bitplanesA,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanesB,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l copperListA,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l copperListB,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Interruptions **********

	INCLUDE "common/registers.s"
	INCLUDE "common/wait.s"

;---------- Interrrupt-Handler ----------

_rte:
	rte

;********** Daten **********

	SECTION data,DATA_C

graphicslibrary:	DC.B "graphics.library",0
	EVEN
vectors:		BLK.L 6
copperListA:	DC.L 0
copperListB:	DC.L 0
olddmacon:		DC.W 0
oldintena:		DC.W 0
oldintreq:		DC.W 0
colors:
				DC.W $0000	; COLOR00	;Playfield 1 (bitplanes 1, 3 und 5)
				DC.W $0FFF	; COLOR01
				DC.W $0700	; COLOR02
				DC.W $0FFF	; COLOR03
				DC.W $0777	; COLOR04
				DC.W $0FFF	; COLOR05
				DC.W $0777	; COLOR06
				DC.W $0FFF	; COLOR07
				DC.W $0000	; COLOR08	;Playfield 2 (bitplanes 2, 4 und 6)
				DC.W $0000	; COLOR09
				DC.W $0000	; COLOR10
				DC.W $0000	; COLOR11
				DC.W $0000	; COLOR12
				DC.W $0000	; COLOR13
				DC.W $0000	; COLOR14
				DC.W $0000	; COLOR15
				DC.W $0000	; COLOR16	; Sprites 0 und 1
				DC.W $0000	; COLOR17
				DC.W $0000	; COLOR18
				DC.W $0000	; COLOR19
				DC.W $0000	; COLOR20	; Sprites 2 und 3
				DC.W $0000	; COLOR21
				DC.W $0000	; COLOR22
				DC.W $0000	; COLOR23
				DC.W $0000	; COLOR24	; Sprites 4 und 5
				DC.W $0000	; COLOR25
				DC.W $0000	; COLOR26
				DC.W $0000	; COLOR27
				DC.W $0000	; COLOR28	; Sprites 6 und 7
				DC.W $0000	; COLOR29
				DC.W $0000	; COLOR30
				DC.W $0000	; COLOR31
bitplanesA:		DC.L 0
bitplanesB:		DC.L 0
zoomColumns:
				DC.B $07,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0				; BPLCON1 : $0077 -> $0077 (0 verdeckte Säulen)
				DC.B $08,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0				; BPLCON1 : $0088 -> $0077 (1 verdeckte Säulen)
				DC.B $08,21,23,0,0,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0088 -> $0066 (2 verdeckte Säulen)
				DC.B $09,19,21,23,0,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0099 -> $0066 (3 verdeckte Säulen)
				DC.B $09,19,21,23,24,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0099 -> $0055 (4 verdeckte Säulen)
				DC.B $0A,17,19,21,23,24,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $00AA -> $0055 (5 verdeckte Säulen)
				DC.B $0A,17,19,21,23,24,25,0,0,0,0,0,0,0,0,0		; BPLCON1 : $00AA -> $0044 (6 verdeckte Säulen)
				DC.B $0B,15,17,19,21,23,24,25,0,0,0,0,0,0,0,0		; BPLCON1 : $00BB -> $0044 (7 verdeckte Säulen)
				DC.B $0B,15,17,19,21,23,24,25,27,0,0,0,0,0,0,0		; BPLCON1 : $00BB -> $0033 (8 verdeckte Säulen)
				DC.B $0C,13,15,17,19,21,23,24,25,27,0,0,0,0,0,0		; BPLCON1 : $00CC -> $0033 (9 verdeckte Säulen)
				DC.B $0C,13,15,17,19,21,23,24,25,27,29,0,0,0,0,0	; BPLCON1 : $00CC -> $0022 (10 verdeckte Säulen)
				DC.B $0D,11,13,15,17,19,21,23,24,25,27,29,0,0,0,0	; BPLCON1 : $00DD -> $0022 (11 verdeckte Säulen)
				DC.B $0D,11,13,15,17,19,21,23,24,25,27,29,31,0,0,0	; BPLCON1 : $00DD -> $0011 (12 verdeckte Säulen)
				DC.B $0E,9,11,13,15,17,19,21,23,24,25,27,29,31,0,0	; BPLCON1 : $00EE -> $0011 (13 verdeckte Säulen)
				DC.B $0E,9,11,13,15,17,19,21,23,24,25,27,29,31,33,0	; BPLCON1 : $00EE -> $0000 (14 verdeckte Säulen)
				DC.B $0F,7,9,11,13,15,17,19,21,23,24,25,27,29,31,33	; BPLCON1 : $00FF -> $0000 (15 verdeckte Säulen)
zoomSteps:		
	; Für ein 306 Pixel breites Bild:
	; # der zu löschenden Spalten (also # der gezoomten Gruppen), anzuwendende Linksverschiebung, Index der ersten verwendeten Gruppe,
	; # der nicht gezoomten Gruppen links von den gezoomten Gruppen,
	; # der nicht gezoomten Gruppen rechts von den gezoomten Gruppen.
ZOOMSTEP_GROUPS_ZOOMED=0
ZOOMSTEP_SHIFT=1
ZOOMSTEP_GROUPS_FIRST=2
ZOOMSTEP_GROUPS_NOTZOOMED_LEFT=3
ZOOMSTEP_GROUPS_NOTZOOMED_RIGHT=4
ZOOMSTEP_DATASIZE=5
				DC.B 15, 8, 0, 2, 3
				DC.B 15, 8, 0, 1, 3
				DC.B 15, 8, 1, 1, 2
				DC.B 15, 8, 1, 0, 2
				DC.B 15, 8, 2, 0, 1
				DC.B 14, 9, 2, 0, 1
				DC.B 14, 9, 2, 0, 1
				DC.B 13, 9, 3, 0, 1 
				DC.B 12, 10, 3, 0, 1
				DC.B 11, 10, 4, 0, 1		; 10
				DC.B 11, 10, 4, 0, 0
				DC.B 10, 11, 4, 0, 1
				DC.B  9, 11, 5, 0, 1
				DC.B  9, 11, 5, 0, 1
				DC.B  8, 12, 5, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  5, 13, 7, 0, 1		; 20
				DC.B  5, 13, 7, 0, 1
				DC.B  5, 13, 7, 0, 1 
				DC.B  5, 13, 7, 0, 1
				DC.B  5, 13, 7, 0, 1
				DC.B  4, 14, 8, 0, 1
				DC.B  4, 14, 8, 0, 1 
				DC.B  4, 14, 8, 0, 0
				DC.B  3, 14, 8, 0, 1
				DC.B  3, 14, 8, 0, 1
				DC.B  3, 14, 8, 0, 1		; 30
				DC.B  3, 14, 8, 0, 1
				DC.B  3, 14, 8, 0, 1 
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1 
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1 
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1		; 40
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 0 
				DC.B  1, 15, 9, 0, 1
				DC.B  1, 15, 9, 0, 1
				DC.B  1, 15, 9, 0, 1
				DC.B  1, 15, 9, 0, 1 
				DC.B  1, 15, 9, 0, 1, 0		; 47
				EVEN
picture:		
				INCBIN "dragons320(306)x256x1.raw"
zoomColumnsB:	DC.L 0
nbColumnsB:		DC.B 0

	end

Programmbeschreibung: zoom3.s

Erstmal zu den Daten.

Es gibt eine Tabelle zoomColumns der Größe 16x 16 Bytes:
Und zwar für die Anzahl der Zoomschritte. Die Tabelle enthält Positionswerte an denen später in den Zeilen mit den
40 Copper-Moves einige Copper-Move "Nop" durch BPLCON1-Werte ersetzt werden. Die genauen Stellen werden dabei durch
zwei Copperlist-Routinen ermittelt. Der Wert ganz vorn ist der Anfangsverschiebungswert z.B. $07 zur Mitte hin.

zoomColumns:
				DC.B $07,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0				; BPLCON1 : $0077 -> $0077 (0 verdeckte Säulen)
				DC.B $08,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0				; BPLCON1 : $0088 -> $0077 (1 verdeckte Säulen)
				DC.B $08,21,23,0,0,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0088 -> $0066 (2 verdeckte Säulen)
				DC.B $09,19,21,23,0,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0099 -> $0066 (3 verdeckte Säulen)
				DC.B $09,19,21,23,24,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0099 -> $0055 (4 verdeckte Säulen)
				DC.B $0A,17,19,21,23,24,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $00AA -> $0055 (5 verdeckte Säulen)
				DC.B $0A,17,19,21,23,24,25,0,0,0,0,0,0,0,0,0		; BPLCON1 : $00AA -> $0044 (6 verdeckte Säulen)
				DC.B $0B,15,17,19,21,23,24,25,0,0,0,0,0,0,0,0		; BPLCON1 : $00BB -> $0044 (7 verdeckte Säulen)
				DC.B $0B,15,17,19,21,23,24,25,27,0,0,0,0,0,0,0		; BPLCON1 : $00BB -> $0033 (8 verdeckte Säulen)
				DC.B $0C,13,15,17,19,21,23,24,25,27,0,0,0,0,0,0		; BPLCON1 : $00CC -> $0033 (9 verdeckte Säulen)
				DC.B $0C,13,15,17,19,21,23,24,25,27,29,0,0,0,0,0	; BPLCON1 : $00CC -> $0022 (10 verdeckte Säulen)
				DC.B $0D,11,13,15,17,19,21,23,24,25,27,29,0,0,0,0	; BPLCON1 : $00DD -> $0022 (11 verdeckte Säulen)
				DC.B $0D,11,13,15,17,19,21,23,24,25,27,29,31,0,0,0	; BPLCON1 : $00DD -> $0011 (12 verdeckte Säulen)
				DC.B $0E,9,11,13,15,17,19,21,23,24,25,27,29,31,0,0	; BPLCON1 : $00EE -> $0011 (13 verdeckte Säulen)
				DC.B $0E,9,11,13,15,17,19,21,23,24,25,27,29,31,33,0	; BPLCON1 : $00EE -> $0000 (14 verdeckte Säulen)
				DC.B $0F,7,9,11,13,15,17,19,21,23,24,25,27,29,31,33	; BPLCON1 : $00FF -> $0000 (15 verdeckte Säulen)

umgerechnet in hex wäre es: (wegen Debuggen)

	DC.B $07,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0				; BPLCON1 : $0077 -> $0077 (0 verdeckte Säulen)				lea 1(a4),a4	; nächstes Byte in der Tabelle
	DC.B $08,$15,0,0,0,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0088 -> $0077 (1 verdeckte Säulen)				addq.b #1,d0 + lea 16(a1),a1
	DC.B $08,$15,$17,0,0,0,0,0,0,0,0,0,0,0,0,0			; BPLCON1 : $0088 -> $0066 (2 verdeckte Säulen)
	DC.B $09,$13,$15,$17,0,0,0,0,0,0,0,0,0,0,0,0		; BPLCON1 : $0099 -> $0066 (3 verdeckte Säulen)
	DC.B $09,$13,$15,$17,$18,0,0,0,0,0,0,0,0,0,0,0		; BPLCON1 : $0099 -> $0055 (4 verdeckte Säulen)
	...

Die zweite wichtige Sache ist die ZoomSteps-Struktur:

Diese beinhaltet 46 x 5 Bytes wie der Zoom erfolgen soll.

zoomSteps:		
	; Für ein 306 Pixel breites Bild: (# = Anzahl)
	; # der zu löschenden Spalten (also # der gezoomten Gruppen), anzuwendende Linksverschiebung,
	;   Index der ersten verwendeten Gruppe,
	; # der nicht gezoomten Gruppen links von den gezoomten Gruppen,
	; # der nicht gezoomten Gruppen rechts von den gezoomten Gruppen.
ZOOMSTEP_GROUPS_ZOOMED=0
ZOOMSTEP_SHIFT=1
ZOOMSTEP_GROUPS_FIRST=2
ZOOMSTEP_GROUPS_NOTZOOMED_LEFT=3
ZOOMSTEP_GROUPS_NOTZOOMED_RIGHT=4
ZOOMSTEP_DATASIZE=5
				DC.B 15, 8, 0, 2, 3
				DC.B 15, 8, 0, 1, 3
				DC.B 15, 8, 1, 1, 2
				DC.B 15, 8, 1, 0, 2
				DC.B 15, 8, 2, 0, 1
				DC.B 14, 9, 2, 0, 1
				DC.B 14, 9, 2, 0, 1
				DC.B 13, 9, 3, 0, 1 
				DC.B 12, 10, 3, 0, 1
				DC.B 11, 10, 4, 0, 1		; 10
				DC.B 11, 10, 4, 0, 0
				DC.B 10, 11, 4, 0, 1
				DC.B  9, 11, 5, 0, 1
				DC.B  9, 11, 5, 0, 1
				DC.B  8, 12, 5, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  7, 12, 6, 0, 1
				DC.B  5, 13, 7, 0, 1		; 20
				DC.B  5, 13, 7, 0, 1
				DC.B  5, 13, 7, 0, 1 
				DC.B  5, 13, 7, 0, 1
				DC.B  5, 13, 7, 0, 1
				DC.B  4, 14, 8, 0, 1
				DC.B  4, 14, 8, 0, 1 
				DC.B  4, 14, 8, 0, 0
				DC.B  3, 14, 8, 0, 1
				DC.B  3, 14, 8, 0, 1
				DC.B  3, 14, 8, 0, 1		; 30
				DC.B  3, 14, 8, 0, 1
				DC.B  3, 14, 8, 0, 1 
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1 
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1 
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 1		; 40
				DC.B  2, 15, 9, 0, 1
				DC.B  2, 15, 9, 0, 0 
				DC.B  1, 15, 9, 0, 1
				DC.B  1, 15, 9, 0, 1
				DC.B  1, 15, 9, 0, 1
				DC.B  1, 15, 9, 0, 1 
				DC.B  1, 15, 9, 0, 1, 0		; 47
				EVEN

Wie in der Beschreibung am Anfang gilt es folgendes zu beachten:

Und zwar kann beim horizontalen Hardware-Zoom nur eine Spalte (bis zu 15 Spalten)
alle 16 Spalten gelöscht werden. Das Problem ist klar: Wenn die Breite des Bildes 
unter 16*15 sinkt, verringert sich die Anzahl der Spalten, die gelöscht werden können:

 306          => 306 / 16 = 19 >= 15 => man kann bis zu 15 Spalten löschen
 306-15 = 291 => 291 / 16 = 18 >= 15 =>  dito
 291-15 = 276 => 276 / 16 = 17 >= 15 =>  dito
 276-15 = 261 => 261 / 16 = 16 >= 15 =>  dito
 261-15 = 246 => 246 / 16 = 15 >= 15 =>  dito
 246-15 = 231 => 231 / 16 = 14 < 15 => man kann nur 14 Spalten löschen
 231-14 = 217 => 217 / 16 = 13 < 15 => man kann nur 13 Spalten löschen
 ...

 Diese Werte ergeben somit den jeweils ersten Wert ZOOMSTEP_GROUPS_ZOOMED=0

; Um ein Bild von 306 auf 15 Pixel Breite zu verkleinern (ab dieser Breite kann keine
; Spalte mehr entfernt werden), müssen 46 Schritte durchlaufen werden, wobei jeder Schritt
; darin besteht, alle möglichen Spalten durch Hardware-Zoom zu entfernen und dann das Bild
; zu aktualisieren, indem die Spalten tatsächlich entfernt werden (Software-Zoom), bevor der
; Hardware-Zoom zurückgesetzt wird und das neue Bild erneut gezoomt werden kann.
; Der Mechanismus ist in der Excel-Datei beschrieben.

;------------------------------------------------------------------------------

Mit Beginn des Programm werden für 2x Copperlisten und für 2x Bitebenen mit je 
320x256 (Tiefe 2) Speicher angefordert.

Copperliste generieren Screeneinstellung, Bitplanepointer, Palette und Zoom.

>o1
 00021f50: 008e 2c81            ;  DIWSTRT := 0x2c81
 00021f54: 0090 2cc1            ;  DIWSTOP := 0x2cc1
 00021f58: 0092 0038            ;  DDFSTRT := 0x0038
 00021f5c: 0094 00d0            ;  DDFSTOP := 0x00d0
 00021f60: 0100 4200            ;  BPLCON0 := 0x4200
 00021f64: 0102 0000            ;  BPLCON1 := 0x0000
 00021f68: 0104 0008            ;  BPLCON2 := 0x0008
 00021f6c: 0108 0000            ;  BPL1MOD := 0x0000
 00021f70: 010a 0000            ;  BPL2MOD := 0x0000
 00021f74: 01fc 0000            ;  FMODE := 0x0000
 00021f78: 00e0 0004            ;  BPL1PTH := 0x0004
 00021f7c: 00e2 2870            ;  BPL1PTL := 0x2870
 00021f80: 00e4 0004            ;  BPL2PTH := 0x0004
 00021f84: 00e6 5070            ;  BPL2PTL := 0x5070
 00021f88: 00e8 0004            ;  BPL3PTH := 0x0004
 00021f8c: 00ea 7870            ;  BPL3PTL := 0x7870
 00021f90: 00ec 0004            ;  BPL4PTH := 0x0004
 00021f94: 00ee a070            ;  BPL4PTL := 0xa070
 00021f98: 0180 0000            ;  COLOR00 := 0x0000
 00021f9c: 0182 0fff            ;  COLOR01 := 0x0fff
>o
 00021fa0: 0184 0700            ;  COLOR02 := 0x0700
 00021fa4: 0186 0fff            ;  COLOR03 := 0x0fff
 00021fa8: 0188 0777            ;  COLOR04 := 0x0777
 00021fac: 018a 0fff            ;  COLOR05 := 0x0fff
 00021fb0: 018c 0777            ;  COLOR06 := 0x0777
 00021fb4: 018e 0fff            ;  COLOR07 := 0x0fff
 00021fb8: 0190 0000            ;  COLOR08 := 0x0000
 00021fbc: 0192 0000            ;  COLOR09 := 0x0000
 00021fc0: 0194 0000            ;  COLOR10 := 0x0000
 00021fc4: 0196 0000            ;  COLOR11 := 0x0000
 00021fc8: 0198 0000            ;  COLOR12 := 0x0000
 00021fcc: 019a 0000            ;  COLOR13 := 0x0000
 00021fd0: 019c 0000            ;  COLOR14 := 0x0000
 00021fd4: 019e 0000            ;  COLOR15 := 0x0000
 00021fd8: 2c01 fffe            ;  Wait for vpos >= 0x2c and hpos >= 0x00
                                ;  VP 2c, VE 7f; HP 00, HE fe; BFD 1
 00021fdc: 0108 0000            ;  BPL1MOD := 0x0000
 00021fe0: 010a 0000            ;  BPL2MOD := 0x0000
 00021fe4: 0102 000b            ;  BPLCON1 := 0x000b
 00021fe8: 2c3d fffe            ;  Wait for vpos >= 0x2c and hpos >= 0x3c
                                ;  VP 2c, VE 7f; HP 3c, HE fe; BFD 1
 00021fec: 01fe 0000            ;  NULL := 0x0000
>o
 00021ff0: 01fe 0000            ;  NULL := 0x0000
 00021ff4: 01fe 0000            ;  NULL := 0x0000
 00021ff8: 01fe 0000            ;  NULL := 0x0000
 00021ffc: 01fe 0000            ;  NULL := 0x0000
 00022000: 01fe 0000            ;  NULL := 0x0000
 00022004: 01fe 0000            ;  NULL := 0x0000
 00022008: 01fe 0000            ;  NULL := 0x0000
 0002200c: 01fe 0000            ;  NULL := 0x0000
 00022010: 01fe 0000            ;  NULL := 0x0000
 00022014: 01fe 0000            ;  NULL := 0x0000
 00022018: 01fe 0000            ;  NULL := 0x0000
 0002201c: 01fe 0000            ;  NULL := 0x0000
 00022020: 01fe 0000            ;  NULL := 0x0000
 00022024: 01fe 0000            ;  NULL := 0x0000
 00022028: 0102 000a            ;  BPLCON1 := 0x000a
 0002202c: 01fe 0000            ;  NULL := 0x0000
 00022030: 0102 0009            ;  BPLCON1 := 0x0009
 00022034: 01fe 0000            ;  NULL := 0x0000
 00022038: 0102 0008            ;  BPLCON1 := 0x0008
 0002203c: 01fe 0000            ;  NULL := 0x0000
>o
 00022040: 0102 0007            ;  BPLCON1 := 0x0007
 00022044: 01fe 0000            ;  NULL := 0x0000
 00022048: 0102 0006            ;  BPLCON1 := 0x0006
 0002204c: 0102 0005            ;  BPLCON1 := 0x0005
 00022050: 0102 0004            ;  BPLCON1 := 0x0004
 00022054: 01fe 0000            ;  NULL := 0x0000
 00022058: 0102 0003            ;  BPLCON1 := 0x0003
 0002205c: 01fe 0000            ;  NULL := 0x0000
 00022060: 01fe 0000            ;  NULL := 0x0000
 00022064: 01fe 0000            ;  NULL := 0x0000
 00022068: 01fe 0000            ;  NULL := 0x0000
 0002206c: 01fe 0000            ;  NULL := 0x0000
 00022070: 01fe 0000            ;  NULL := 0x0000
 00022074: 01fe 0000            ;  NULL := 0x0000
 00022078: 01fe 0000            ;  NULL := 0x0000
 0002207c: 01fe 0000            ;  NULL := 0x0000
 00022080: 01fe 0000            ;  NULL := 0x0000
 00022084: 01fe 0000            ;  NULL := 0x0000
 00022088: 01fe 0000            ;  NULL := 0x0000
 0002208c: 2d01 fffe            ;  Wait for vpos >= 0x2d and hpos >= 0x00
                                ;  VP 2d, VE 7f; HP 00, HE fe; BFD 1

Im Hauptprogramm wird das Bild in die Bitebene mit dem Blitter kopiert. D=B
und als nächstes wird die Copperliste kopiert. Hintergrund ist wieder, dass 
eine Copperliste "angezeigt" wird während die andere parallel geändert wird,
für das nächste Bild.

Dann kommt die Hauptschleife.

Vor Eintritt in die Hauptschleife werden die Zeiger a0, a1 unveränderlich gesetzt und zwar 
auf den Anfang der Struktur zoomsteps (a0) und die Tabelle zoomColumns (a1). Sie dienen
somit als Basisadressen.

In der zoomColumnss Tabelle werden nur die Werte berücksichtigt, die größer als 0 sind
und zwar gibt es eine Zählvariable d0, die nach jedem Durchlauf (nach jeder Änderung des 
Bildes) um 1 erhöht wird und anschließend wird der Zeiger auf die nächste Zeile verschoben
durch ein lea 16(a1),a1.

Der Wert in d0 beginnend bei 0 bis maximal 15 wird in nbColumnsB durch move.b d0,nbColumnsB
gespeichert. Er wird im Programm durch den Vergleich cmp.b ZOOMSTEP_GROUPS_ZOOMED(a0),d0
abgefragt.

;----------

Der grobe Ablauf des Programms ist wie folgt:

Hardwarescroll:

In der Hauptschleife wird zunächst auf das Ende des sichtbaren Screens gewartet und dann
werden die Copperlisten ausgetauscht. Aus der bis eben "angezeigten" Copperliste werden 
nun die alten BPLCON1-Werte entfernt. Dafür wurden die aktuelle Zoomspalte und die Anzahl
der Spalten im letzten Durchlauf hierfür bereits gespeichert.
Nachdem die Copperliste wieder beräumt wurde, wird abgefragt ob die Anzahl der bereits
gelöschten Spalten (d0) die Größe der für diesen Zoomstep gültigen Zoomspalten erreicht 
wurde.

Wenn nicht wird der Zeiger auf das nächste zoomstep gesetzt 5(a0) und die Anzahl der Spalten
um eins erhöht. Die Copperliste wird dann mit den neuen BPLCON1-Werten gefüllt.

Dieses Verfahren ist nur für den dynamischen Hardwarescroll durch die geänderte Copperliste.

;------------

Beim nächsten Hauptschleifendurchlauf, also bei Eintritt wird zunächst auf das Ende des 
Frames gewartet und als nächstes werden die Copperlisten ausgetauscht.
Aber dies erfolgt erst nachdem die Routine mit dem Zurücksetzen der BPLCON1 Werte durchlaufen
wurde. Die Werte werden also für den nächsten Durchlauf "vorbereitet".
Denn nach Rücksprung nach _loop wird eine Routine durchlaufen in der nur die Anzahl "nbColumnsB"
in der Tabelle zoomcolumns durchgegangen werden und danach wird die Routine verlassen.
Dabei wird der Zeiger a4 immer um 1 erhöht und zeigt somit auf den nächsten Wert.
Solange die Tabelle nicht komplett durchlaufen wurde cmp.b ZOOMSTEP_GROUPS_ZOOMED(a0),d0
wird der Abschnitt shrinks nicht durchlaufen.

;------------

Softwarezoom:

Wenn die Bedingung erfüllt ist und die Anzahl der gelöschten Spalten dieser Zoomgruppe entspricht,
können also keine weiteren Spalten in diesem Durchlauf durch den Hardwarescroll entfernt werden.
Dann muss der Softwarezoom übernehmen und nun diese gelöschten Spalten tatsächlich aus dem Bild
entfernen. Wenn das Bild anschließend verkleinert wurde übernimmt wieder der Hardwarescroll.
Der Softwarezoom beginnt damit das Bild komplett zu löschen. Als nächstes folgend drei verschiedene
Blitts, wobei der mittlere Blitt sogar noch in einer abhängigen Schleife auch mehrfach durchgeführt
wird.
Der erste Blitt kopiert nicht gezoomte Spalten in dem sie nach rechts verschoben werden.
Dann werden die gezoomten Gruppen, bei denen durch den Hardwarescroll jeweils eine Spalte entfernt 
wurde durch Blitts kopiert bei denen das letzte Pixel jeweils ausgeblendet wird.
Und der letzte Blitt kopiert die nichtgezoomten Spalten, die auf die letzte gezoomte Spalte folgen
mit einer Linksverschiebung?.

Das Bild wurde dadurch verkleinert.

Die Bitplanes werden getauscht und die neuen Bitplanepointer in die Copperliste kopiert.
Als letztes werden die Zeiger neu gesetzt und der Spaltenzähler wieder auf 0 gesetzt.

;------------

Hauptprogramm: (Blitter)

BLTSIZE 1 - Kopieren des Bildes in Bitplane 1		
			D=B Größe 320x256 Modulo=0  Bild in bitplaneA  ; Aufruf nur 1x

Hauptschleife:
-warten frame
-copperlisten tauschen
-Copperlsiste modifizieren

	cmp.b ZOOMSTEP_GROUPS_ZOOMED(a0),d0		; D0 = Anzahl der Spalten / Zeilen, die zu diesem Zeitpunkt gelöscht wurden
	bne _noShrink
BLTSIZE 2 - Bild löschen				
			D=B, Größe 320x256 Modulo=0	BLTBDAT=$0	; kann übersprungen werden 

BLTSIZE 3 - 
			D=A, Größe x * 256 Zeilen, DESC=1	

	; Kopieren Sie die nicht gezoomten Gruppen links von der ersten gezoomten
	; Gruppe sowie die erste gezoomte Gruppe nach dem Ausblenden ihres letzten
	; Pixels, indem Sie sie nach rechts verschieben.
	
_shrinkColumns:
	subq.b #1,d1					; Zoomstepwert um 1 verringern
	beq _shrinkDone	
	...
	; Kopieren Sie die gezoomten Gruppen, indem Sie ihr letztes Pixel ausblenden,
	; indem Sie sie immer weniger nach rechts verschieben (also den Versatz nach 
	; links in BLTCON1 erhöhen).
BLTSIZE 4 -	D=A+C		
	bra _shrinkColumns

_shrinkDone:

	move.b ZOOMSTEP_GROUPS_NOTZOOMED_RIGHT(a0),d1	; 4(a0) -> Anfangsadresse Feld Zoomsteps
	beq _shrinkRDone								; wenn 0 dann überspringen	...

BLTSIZE 5 -	D=A+C ; 256 Zeilen + x Wörter
	; Kopieren Sie die nicht gezoomten Spalten, die auf die letzte gezoomte
	; Spalte folgen, indem Sie sie nach rechts verschieben.
	

_shrinkRDone:

-Bitplane tauschen
-neue Bitplanepointer in Copperliste eintragen

	; Zoom zurücksetzen: sich darauf vorbereiten, nur die erste
	; Spalte einer neuen Reihe von Spalten zu löschen
	1
_noShrink:

	;++++++++++ Zoom anwenden ++++++++++	
	
Zoom animieren

Maustaste
