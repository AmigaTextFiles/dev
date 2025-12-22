
; soc21.s = zoom4.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Hardware-Zoom eines Bildes auf 1 Bitplane (logische Fortsetzung von zoom.s)

;********** Konstanten **********

; Programm

DISPLAY_DEPTH=4
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
ZOOM_X=$3D
ZOOM_DX=306			; Nicht verändern. Gibt nur die Breite des Bildes wieder, für das die Werte von zoomHSteps vorberechnet wurden.
ZOOM_DY=256			; Nicht verändern. Gibt nur die Breite des Bildes wieder, für das die Werte von zoomHSteps vorberechnet wurden.
ZOOM_Y=DISPLAY_Y
ZOOM_NOP=$01FE0000
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+ZOOM_DY*(5+40)*4+4+4
PICTURE_DY=256
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

	move.w #BPL1PTH,d0
	move.l bitplanesA,d1
	move.w #DISPLAY_DEPTH-1,d2
_bitplanes:
	move.w d0,(a0)+
	addq.w #2,d0
	swap d1
	move.w d1,(a0)+
	move.w d0,(a0)+
	addq.w #2,d0
	swap d1
	move.w d1,(a0)+	
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d1
	dbf d2,_bitplanes

	; Palette

	lea colors,a1
	IFNE DEBUG
	move.l #$01FE0000,(a0)+		; NOP-Äquivalent, um jede Änderung von COLOR00 zu neutralisieren,
								; ohne die Größe der Palette in der Copperlist zu ändern
	move.w #COLOR01,d1
	lea 2(a1),a1
	moveq #(1<<DISPLAY_DEPTH)-2,d0
	ELSE
	move.w #COLOR00,d1
	moveq #(1<<DISPLAY_DEPTH)-1,d0
	ENDC
_copperListColors:
	move.w d1,(a0)+
	addq.w #2,d1
	move.w (a1)+,(a0)+
	dbf d0,_copperListColors

	; Zoom

	move.w #ZOOM_Y<<8,d0
	move.w #ZOOM_DY-1,d2
_zoomLines:
	move.w d0,d1
	or.w #$00!$0001,d1
	move.w d1,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0007,(a0)+
	move.w d0,d1
	or.w #ZOOM_X!$0001,d1
	move.w d1,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+
	move.w #40-1,d3
_zoomLine:
	move.l #ZOOM_NOP,(a0)+
	dbf d3,_zoomLine
	addi.w #$0100,d0
	dbf d2,_zoomLines

	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	
	; Ende

	move.l #$FFFFFFFE,(a0)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; copperlist aktivieren

	move.l copperListA,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Kopieren des Bildes in Bitplane 1

	move.w #$05CC,BLTCON0(a5)	; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTBMOD(a5)
	move.w #0,BLTDMOD(a5)
	move.l #picture,BLTBPTH(a5)
	movea.l bitplanesA,a0
	lea ((DISPLAY_DY-PICTURE_DY)>>1)*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #(PICTURE_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Kopieren Sie die Copperlist, um eine Version zu erhalten, die ohne
	; Auswirkungen auf die Anzeige geändert werden kann. 	

	move.w #(COPSIZE>>2)-1,d0
	movea.l copperListA,a0
	movea.l copperListB,a1
_copyCopperList:
	move.l (a0)+,(a1)+
	dbf d0,_copyCopperList

;---------- Hauptschleife ----------

	lea zoomHSteps,a0
	lea zoomColumns,a1
	move.l a1,zoomColumnsB
	lea zoomVSteps,a2
	clr.b d0
	move.b d0,nbColumnsB
	clr.w d1						; D1 = Anzahl der insgesamt gelöschten Spalten/Zeilen
	clr.w d2						; D2 = Akkumulator für die Berechnung der Einhaltung des Aspekts Verhältnis

_loop:

	; Warten auf das Ende des Frames

	move.w d0,d3
	moveq #1,d0
	jsr _wait
	move.w d3,d0

	; Coppperliste zirkulär austauschen

	move.l copperListB,d3
	move.l copperListA,copperListB
	move.l d3,copperListA
	move.l copperListA,COP1LCH(a5)

	; Zoom zurücksetzen: Löschen der vorherigen MOVEs in BPLCON1

	movea.l zoomColumnsB,a6
	lea 1(a6),a6
	movea.l copperListB,a3
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+5*4(a3),a3
	move.b nbColumnsB,d3
_clearBPLCON1a:
	subq.b #1,d3
	blt _clearBPLCON1Done
	clr.w d4
	move.b (a6)+,d4
	add.w d4,d4
	add.w d4,d4					; D4 = MOVE-Offset in BPLCON1 durch NOP auf allen Zeilen zu ersetzen
	lea (a3,d4.w),a4
	move.w #ZOOM_DY-1,d4
_clearBPLCON1b:
	move.l #ZOOM_NOP,(a4)
	lea (5+40)*4(a4),a4
	dbf d4,_clearBPLCON1b
	bra _clearBPLCON1a
_clearBPLCON1Done:

	; Speichern Sie die Informationen, die benötigt werden, um (beim nächsten Frame) 
	; die MOVEs aus der Copperlist zu löschen, die nun auf dem Bildschirm zu sehen ist.

	move.l a1,zoomColumnsB
	move.b d0,nbColumnsB

	;++++++++++ Verkleinern Sie das Bild, wenn es nicht mehr möglich ist, die Zoom-Hardware weiter zu schieben ++++++++++

	cmp.b ZOOMSTEP_GROUPS_ZOOMED(a0),d0				; D0 = # der Spalten / Zeilen, die zu diesem Zeitpunkt gelöscht wurden
	bne _noShrink

	; Beenden, wenn das Zoomen nicht fortgesetzt werden kann

	tst.b ZOOMSTEP_DATASIZE(a0)
	beq _end

	; Bild löschen

	move.w #$01CC,BLTCON0(a5)			; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w #$0000,BLTBDAT(a5)
	move.w #0,BLTDMOD(a5)
	move.l bitplanesB,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Kopieren Sie die nicht gezoomten Gruppen links von der ersten gezoomten Gruppe
	; sowie die erste gezoomte Gruppe nach dem Ausblenden ihres letzten Pixels,
	; indem Sie sie nach rechts verschieben.

	move.w #$0002,BLTCON1(a5)			; DESC=1

	clr.w d0
	move.b ZOOMSTEP_GROUPS_FIRST(a0),d0
	clr.w d3
	move.b ZOOMSTEP_GROUPS_NOTZOOMED_LEFT(a0),d3
	addq.b #2,d3						; Fügen Sie die erste gezoomte Gruppe sowie eine Gruppe hinzu, in der die verschobenen Pixel bewegt werden.
	add.b d3,d0
	add.b d0,d0
	addi.w #(DISPLAY_DY-1)*(DISPLAY_DX>>3)-4,d0
	movea.l bitplanesA,a3
	lea (a3,d0.w),a3
	move.l a3,BLTAPTH(a5)
	movea.l bitplanesB,a4
	lea 2(a4,d0.w),a4					; Um eine Rechtsverschiebung durch Kopieren mit Linksverschiebung
										; im DESC-Modus zu erzeugen, muss sich das Ziel einen WORD nach der Quelle befinden
	move.l a4,BLTDPTH(a5)
	move.w #DISPLAY_DX>>4,d0
	sub.w d3,d0
	add.w d0,d0
	move.w d0,BLTAMOD(a5)
	move.w d0,BLTDMOD(a5)
	clr.w d0
	move.b ZOOMSTEP_SHIFT(a0),d0
	ror.w #4,d0
	move.w #$09F0,d4
	or.w d0,d4
	move.w d4,BLTCON0(a5)				; ASH3-0=Verschiebung, USEA=1, USEB=0, USEC=0, USED=1, D=A
	move.w #$FFFE,BLTAFWM(a5)
	move.w #$0000,BLTALWM(a5)
	or.w #DISPLAY_DY<<6,d3
	move.w d3,BLTSIZE(a5)
	WAIT_BLITTER

	; Kopieren Sie die gezoomten Gruppen, indem Sie ihr letztes Pixel ausblenden, indem
	; Sie sie immer weniger nach rechts verschieben (also den Versatz nach links in BLTCON1 erhöhen).

	move.b ZOOMSTEP_GROUPS_ZOOMED(a0),d3
	move.w #$FFFE,BLTAFWM(a5)
	move.w #(DISPLAY_DX-32)>>3,BLTAMOD(a5)
	move.w #(DISPLAY_DX-32)>>3,BLTCMOD(a5)
	move.w #(DISPLAY_DX-32)>>3,BLTDMOD(a5)
_shrinkColumns:
	subq.b #1,d3
	beq _shrinkDone
	addi.w #$1000,d0					; Wenn der Offset 15 erreicht, wird er wie gewünscht auf einen 
										; Offset von 15 zurückgeschaltet : $Fxxx + $1000 = $0000
	beq _shrinkKeepDestinationWord		; Wir müssen den heiklen Fall bewältigen, dass der Linksversatz
										; in die Sättigung geht, d. h. wenn er auf 16 gehen soll, obwohl er
										; nicht über 15 hinausgehen kann: Dann ist es eine Adressänderung
										; und ein Zurücksetzen des Offsets auf 0.
	lea 2(a4),a4
_shrinkKeepDestinationWord:
	lea 2(a3),a3
	move.w d0,d4
	or.w #$0BFA,d4
	move.w d4,BLTCON0(a5)				; ASH3-0=Verschiebung, USEA=1, USEB=0, USEC=1, USED=1, D=A+C
	move.l a3,BLTAPTH(a5)
	move.l a4,BLTCPTH(a5)
	move.l a4,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!2,BLTSIZE(a5)
	WAIT_BLITTER
	bra _shrinkColumns
_shrinkDone:

	; Kopieren Sie die nicht gezoomten Spalten, die auf die letzte
	; gezoomte Spalte folgen, indem Sie sie nach rechts verschieben.

	clr.w d3
	move.b ZOOMSTEP_GROUPS_NOTZOOMED_RIGHT(a0),d3
	beq _shrinkRDone
	addi.w #$1000,d0
; braucht es nicht wie oben eine Grenzübergangskontrolle auf der a4?
	or.w #$0BFA,d0
	move.w d0,BLTCON0(a5)		; ASH3-0=Verschiebung, USEA=1, USEB=0, USEC=1, USED=1, D=A+C
	move.w #$FFFF,BLTAFWM(a5)
	move.w d3,d0
	addq.b #1,d3				; Eine Gruppe hinzufügen, in der verschobene Pixel gejagt werden sollen
	move.w #DISPLAY_DX>>4,d4
	sub.b d3,d4
	add.w d4,d4
	move.w d4,BLTAMOD(a5)
	move.w d4,BLTCMOD(a5)
	move.w d4,BLTDMOD(a5)
	add.b d0,d0
	lea (a3,d0.w),a3
	move.l a3,BLTAPTH(a5)
	lea (a4,d0.w),a4
	move.l a4,BLTCPTH(a5)
	move.l a4,BLTDPTH(a5)
	or.w #DISPLAY_DY<<6,d3
	move.w d3,BLTSIZE(a5)
	WAIT_BLITTER
_shrinkRDone:

	; Bitplanes zirkulär vertauschen

	move.l bitplanesB,d0
	move.l bitplanesA,bitplanesB
	move.l d0,bitplanesA

	movea.l copperListB,a3
	movea.l copperListA,a4
	lea 10*4+2(a3),a3
	lea 10*4+2(a4),a4
	move.w #DISPLAY_DEPTH-1,d4
_swapBitplanes:
	swap d0
	move.w d0,(a3)
	move.w d0,(a4)
	swap d0
	move.w d0,4(a3)
	move.w d0,4(a4)
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	lea 8(a3),a3
	lea 8(a4),a4
	dbf d4,_swapBitplanes

	; Zoom zurücksetzen: sich darauf vorbereiten, nur die erste
	; Spalte einer neuen Reihe von Spalten zu löschen

	lea ZOOMSTEP_DATASIZE(a0),a0
	lea zoomColumns,a1
	clr.b d0

_noShrink:

	;++++++++++ Zoom anwenden ++++++++++

	; den Zoom animieren

	addq.b #1,d0
	lea 16(a1),a1

	; Ändern Sie den Wert der MOVE BPLCON1 Zeilenstart, um das Bild horizontal zu zentrieren.

	movea.l a1,a3
	movea.l copperListB,a4
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+3*4+2(a4),a4
	clr.w d4
	move.b (a3)+,d4			; D4 = ursprünglicher BPLCON1-Wert
	move.w #ZOOM_DY-1,d5
_setStartingBPLCON1:
	move.w d4,(a4)
	lea (5+40)*4(a4),a4
	dbf d5,_setStartingBPLCON1

	; Schreiben Sie die neuen MOVE-Werte und den neuen MOVE in BPLCON1, um die Spalte in allen Zeilen zu löschen.

	move.b d0,d5			; D5 = # der zu löschenden Spalten
	movea.l copperListB,a4
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+5*4(a4),a4
_setBPLCON1a:
	subi.w #$0001,d4
	clr.w d6
	move.b (a3)+,d6
	add.w d6,d6
	add.w d6,d6				; D6 = offset von MOVE in BPLCON1, um die Spalte zu löschen
	lea (a4,d6.w),a6
	move.w #ZOOM_DY-1,d6
_setBPLCON1b:
	move.w #BPLCON1,(a6)
	move.w d4,2(a6)
	lea (5+40)*4(a6),a6
	dbf d6,_setBPLCON1b
	subq.b #1,d5
	bne _setBPLCON1a

	; Vertikales Zoomen unter Beachtung des Seitenverhältnisses (unter der Annahme, dass ZOOM_DY <= ZOOM_DX)

	addi.w #ZOOM_DY,d2
	cmpi.w #ZOOM_DX,d2
	blt _noVerticalZoom
	subi.w #ZOOM_DX,d2

	; den Zoom animieren

	addq.w #1,d1

	; Reduzieren Sie die Anzeigefläche um die Anzahl der bisher gelöschten Zeilen
	; (entfernen Sie die gerade Hälfte dieser Zahl oben, die ungerade Hälfte unten).

	movea.l copperListB,a3
	move.w d1,d3
	lsr.w #1,d3
	move.w #DISPLAY_Y,d4
	add.w d3,d4					; Die gerade Hälfte der Zeilenanzahl entfernen : N >> 1
	lsl.w #8,d4
	or.w #DISPLAY_X,d4
	move.w d4,2(a3)
	move.w d1,d4
	sub.w d3,d4					; Die ungerade Hälfte der Zeilenanzahl entfernen : N - (N >> 1)
	move.w #DISPLAY_Y+DISPLAY_DY,d3
	sub.w d4,d3
	subi.w #256,d3
	lsl.w #8,d3
	or.w #DISPLAY_X+DISPLAY_DX-256,d3
	move.w d3,6(a3)

	; Die neue zu löschende Zeile als gelöscht markieren

	lea zoomVLines,a4
	move.w (a2)+,d3
	move.b #1,(a4,d3.w)

	; Zeilen [0, N-1]: Ändern Sie die Startadresse, um ggf. die ersten N Zeilen zu löschen.

	move.w #ZOOM_DY,d4			; D4 = Anzahl der Zeilen, die noch auf Löschung getestet werden müssen + 1
	moveq #0,d3
	tst.b (a4)+
	beq _zoomVKeepFirstLines
_zoomVHideFirstLines:
	subq.w #1,d4				; Wir testen nicht, ob == 0, da wir davon ausgehen, dass noch
								; mindestens eine Zeile angezeigt werden soll
	addi.w #DISPLAY_DX>>3,d3
	tst.b (a4)+
	bne _zoomVHideFirstLines
	add.l bitplanesA,d3
	move.w #DISPLAY_DEPTH-1,d5
	lea 10*4(a3),a6
_zoomVSetBitplanesPointers:
	swap d3
	move.w d3,2(a6)
	swap d3
	move.w d3,6(a6)
	lea 8(a6),a6
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d3
	dbf d5,_zoomVSetBitplanesPointers

_zoomVKeepFirstLines:

	; Positionieren Sie sich auf dem WAIT, der der ersten angezeigten Zeile entspricht
	; (wie bei jeder Zeile wirken sich die in dieser Zeile angegebenen Modulos auf die nächste Zeile aus).

	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4(a3),a3
	move.w d1,d5
	lsr.w #1,d5
	mulu #(5+40)*4,d5
	lea (a3,d5.w),a3

	; Weitere Zeilen: Modulos aktualisieren, um Zeilen jenseits von Zeile N 
	; (die also nicht gelöscht wird) zu entfernen.

_zoomVHideNextLines:
	subq.w #1,d4
	ble _zoomVDone				;*************** Ich habe ble und nicht bne geschrieben, weil es sein könnte,
								; dass man danach wieder eine Schleife macht, in der d4 auf 0 zurückgesetzt werden kann.
	tst.b (a4)+
	beq _zoomVKeepLine

	; Einen Block aufeinanderfolgender Zeilen löschen

	clr.w d3
_zoomVHideLines:
	addi.w #DISPLAY_DX>>3,d3
	subq.w #1,d4
	beq _zoomVHideLinesUpdateModulos
	tst.b (a4)+
	bne _zoomVHideLines
_zoomVHideLinesUpdateModulos:
	move.w d3,6(a3)
	move.w d3,10(a3)
	lea (5+40)*4(a3),a3
	bra _zoomVHideNextLines

	; Setzen Sie die Modulos der Zeile zurück, damit sie angezeigt werden kann.

_zoomVKeepLine:
	move.w #0,6(a3)
	move.w #0,10(a3)
	lea (5+40)*4(a3),a3
	bra _zoomVHideNextLines

_zoomVDone:

_noVerticalZoom:

	; Testen eines Drucks der linken Maustaste

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
				DC.W $0000	; COLOR00	; Playfield 1 (bitplanes 1, 3 und 5)
				DC.W $0FFF	; COLOR01
				DC.W $0700	; COLOR02
				DC.W $0FFF	; COLOR03
				DC.W $0777	; COLOR04
				DC.W $0FFF	; COLOR05
				DC.W $0777	; COLOR06
				DC.W $0FFF	; COLOR07
				DC.W $0000	; COLOR08	; Playfield 2 (bitplanes 2, 4 und 6)
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
zoomHSteps:		; Für ein 306 Pixel breites Bild: # der zu löschenden Spalten (also # der gezoomten Gruppen),
				; anzuwendende Linksverschiebung, Index der ersten verwendeten Gruppe, # der nicht gezoomten Gruppen
				; links von den gezoomten Gruppen, # der nicht gezoomten Gruppen rechts von den gezoomten Gruppen.
ZOOMSTEP_GROUPS_ZOOMED=0
ZOOMSTEP_SHIFT=1
ZOOMSTEP_GROUPS_FIRST=2
ZOOMSTEP_GROUPS_NOTZOOMED_LEFT=3
ZOOMSTEP_GROUPS_NOTZOOMED_RIGHT=4
ZOOMSTEP_DATASIZE=5
				DC.B 15, 8, 0, 2, 3, 15, 8, 0, 1, 3, 15, 8, 1, 1, 2, 15, 8, 1, 0, 2, 15, 8, 2, 0, 1, 14, 9, 2, 0, 1, 14, 9, 2, 0, 1, 13, 9, 3, 0, 1, 12, 10, 3, 0, 1, 11, 10, 4, 0, 1, 11, 10, 4, 0, 0, 10, 11, 4, 0, 1, 9, 11, 5, 0, 1, 9, 11, 5, 0, 1, 8, 12, 5, 0, 1, 7, 12, 6, 0, 1, 7, 12, 6, 0, 1, 7, 12, 6, 0, 1, 7, 12, 6, 0, 1, 5, 13, 7, 0, 1, 5, 13, 7, 0, 1, 5, 13, 7, 0, 1, 5, 13, 7, 0, 1, 5, 13, 7, 0, 1, 4, 14, 8, 0, 1, 4, 14, 8, 0, 1, 4, 14, 8, 0, 0, 3, 14, 8, 0, 1, 3, 14, 8, 0, 1, 3, 14, 8, 0, 1, 3, 14, 8, 0, 1, 3, 14, 8, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 1, 2, 15, 9, 0, 0, 1, 15, 9, 0, 1, 1, 15, 9, 0, 1, 1, 15, 9, 0, 1, 1, 15, 9, 0, 1, 1, 15, 9, 0, 1, 0
				EVEN
picture:		INCBIN "dragons320(306)x256x1.raw"
zoomColumnsB:	DC.L 0
nbColumnsB:		DC.B 0
				EVEN
zoomVSteps:		; Bei einem Bild mit 256 Zeilen: Indizes der zu löschenden Zeilen (0 bis 255), in der Reihenfolge
				; Diese Liste wird über das Tool zoom.html
				DC.W 127, 143, 111, 159, 95, 175, 79, 191, 63, 207, 47, 223, 31, 239, 15, 255, 126, 144, 109, 161, 92, 178, 75, 195, 58, 212, 41, 229, 24, 246, 7, 128, 146, 108, 164, 90, 182, 72, 200, 54, 218, 36, 236, 18, 254, 0, 125, 147, 106, 166, 87, 185, 68, 204, 49, 224, 29, 243, 10, 129, 149, 105, 169, 85, 189, 65, 210, 44, 231, 23, 251, 3, 124, 150, 103, 171, 82, 193, 60, 215, 38, 237, 16, 130, 152, 102, 174, 80, 198, 56, 221, 33, 245, 9, 123, 153, 100, 177, 76, 202, 51, 227, 26, 252, 1, 131, 155, 99, 181, 73, 208, 46, 234, 20, 122, 156, 97, 184, 69, 213, 40, 241, 12, 132, 158, 96, 188, 66, 219, 35, 249, 5, 121, 160, 93, 192, 61, 225, 28, 133, 163, 91, 197, 57, 232, 22, 120, 165, 88, 201, 52, 238, 14, 134, 168, 86, 206, 48, 247, 8, 119, 170, 83, 211, 42, 253, 118, 172, 78, 216, 34, 135, 176, 77, 222, 30, 117, 179, 71, 228, 21, 136, 183, 70, 235, 17, 116, 186, 64, 242, 6, 137, 190, 62, 250, 2, 115, 194, 55, 138, 199, 53, 114, 203, 45, 139, 209, 43, 113, 214, 37, 140, 220, 32, 112, 226, 25, 141, 233, 19, 110, 240, 11, 142, 248, 4, 107, 145, 104, 148, 101, 151, 98, 154, 94, 157, 89, 162, 84, 167, 81
zoomVLines:		; Flag für alle 256 Zeilen des Bildes: 0 wenn beibehalten, 1 wenn gelöscht
				BLK.B 256,0
zoomVStep:		DC.L 0