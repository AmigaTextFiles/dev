
; soc03.s = copperline.s	

; Programmiert von Yragael für Stash of Code
; (http://www.stashofcode.fr) im Jahr 2017.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Eine Copperlinie (vor der $FF-Zeile!)

;---------- Direktiven ----------

	SECTION yragael,CODE_C

;---------- Konstanten ----------

; Register

INTENA=$09A
INTENAR=$01C
INTREQ=$09C
INTREQR=$01E
DMACON=$096
DMACONR=$002
COLOR00=$180
COP1LCH=$080
COP1LCL=$082
COPJMP1=$088
VPOSR=$004

; Programm

COPSIZE=1000		; Willkürlich sagen wir uns, dass alles reichen wird
LINE=100			; <= 255

;---------- Initialisierung ----------

; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $dff000,a5

; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

; Hardware-Interrupts und DMAs ausschalten

	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

;---------- Copperlist ----------

	movea.l copperlist,a0

; auf den sichtbaren Start warten ($3E) der Zeile (<= 255). 

	move.w #(LINE<<8)!$3E!$0001,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+

; Reihe von 40 Modifikationen der Hintergrundfarbe

	lea _gradientStart,a1			; Anfangsadresse Tabelle Gradientenstart	
	moveq #40-1,d0					; 40 Farbwerte - Schleifenzähler	
_copperListColors:
	move.w #COLOR00,(a0)+			; Farbregister in Copperlist speichern	
	move.w (a1)+,(a0)+				; Farbwert in Copperlist speichern	
	cmpi.l #_gradientEnd,a1			; Ende Anzahl Farbwerte erreicht?	
	bne _copperListColorsNoLoop		; wenn nicht, weitermachen	
	lea _gradientStart,a1			; ansonsten Gradientenstart wieder auf Anfang	
_copperListColorsNoLoop:
	dbf d0,_copperListColors		; wiederholen bis Schleife zu Ende	

; Hintergrundfarbe in Schwarz ändern

	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+

; Ende

	move.l #$FFFFFFFE,(a0)

;---------- Hauptprogramm ----------

; DMAs wieder herstellen 

	move.w #$8280,DMACON(a5)		; DMAEN=1, COPEN=1

; Copperliste aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

; Hauptschleife

	lea _gradientStart,a0			; Anfangsadresse Tabelle Gradientenstart
_loop:

; auf vertikal blank warten

_waitVERTB0:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #$0000,d0					; Zeile 0?
	blt _waitVERTB0
_waitVERTB1:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #$0001,d0					; Zeile 1?
	bne _waitVERTB1

; 40 MOVE bearbeiten 

	movea.l a0,a1					; Kopie Anfangsadresse Tabelle Gradientenstart in a1
	movea.l copperlist,a2			; Adresse copperliste in a2
	lea 4+2(a2),a2					; Versatz um auf erste Farbe in copperliste zu zeigen
	moveq #40-1,d0					; 40 Farbwerte - Schleifenzähler
_setColors:
	move.w (a1)+,(a2)				; aktuellen Farbwert in copperliste kopieren
	lea 4(a2),a2					; 4 Bytes in copperliste überspringen für nächsten Farbwert
	cmpi.l #_gradientEnd,a1			; Ende Anzahl Farbwerte erreicht?
	bne _setColorsNoLoop			; wenn nicht, weitermachen
	lea _gradientStart,a1			; ansonsten Gradientenstart wieder auf Anfang
_setColorsNoLoop:
	dbf d0,_setColors				; wiederholen bis Schleife zu Ende

	; Farben tauschen

	lea 2(a0),a0					; Gradientenstart + 2 Bytes
	cmpi.l #_gradientEnd,a0			; am Ende der Tabelle?
	bne _cycleColorsNoLoop			; wenn nicht, weitermachen	
	lea _gradientStart,a0			; ansonsten mit erster Farbe wieder beginnen
_cycleColorsNoLoop:

	btst #6,$BFE001					; linke Maustaste gedrückt?
	bne _loop						; wenn nicht, zurück zu loop		

;---------- Ende ----------

; Hardware-Interrupts und DMAs ausschalten

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

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

; Speicher wieder freigeben

	movea.l copperlist,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Daten ----------

olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
copperlist:			DC.L 0
graphicslibrary:	DC.B "graphics.library",0
	even
_gradientStart:
				DC.W $0074, $0163, $0252, $0341, $0430, $0521, $0612, $0703
				DC.W $0814, $0925, $0A36, $0B47, $0C58, $0D69, $0E7A, $0F8B
				DC.W $0E9C, $0DAD, $0CBE, $0BCF, $0ADE, $09ED, $08FC, $07EB
				DC.W $06DA, $05C9, $04B8, $03A7, $0296, $0185
_gradientEnd:

end

