
; soc03b.s

COLOR00=$180

LINE=100

	lea copperlist,a0

start:
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

	lea _gradientStart,a0
_loop:

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

	;bra _loop

	rts

_gradientStart:
				DC.W $0074, $0163, $0252, $0341, $0430, $0521, $0612, $0703
				DC.W $0814, $0925, $0A36, $0B47, $0C58, $0D69, $0E7A, $0F8B
				DC.W $0E9C, $0DAD, $0CBE, $0BCF, $0ADE, $09ED, $08FC, $07EB
				DC.W $06DA, $05C9, $04B8, $03A7, $0296, $0185
_gradientEnd:

copperlist:		
	blk.w 200,$F0

	end


; Programmausschnitt ist zum Analysieren mit dem ASM-One- oder WinUAE-Debugger geeignet 

h.w copperlist

	$6F032-$6EF86=172			; 

	copsize = 4+(40*4)+4+4		; Bereich berechnet


>r
Filename:soc03b.s
>a
Pass1
Pass2
No Errors
>ad			; 	