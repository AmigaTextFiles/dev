
; Eine erweiterte Verwendung von copper: MOVE, WAIT, SKIP und JUMP,
; um einen Bereich anzuzeigen, der von einer beliebigen Anzahl von MOVEs
; (also zwischen 1 und 40) gezeichnet wird, deren Ordinate und Höhe
; beliebig sind. Wahrscheinlich das nervigste, was ich je codiert habe ...

; WARNUNG ! ASM-One 1.20 interpretiert IF X <100 als <= 100, aber es
; interpretiert IF X > 100 als > 100! Es ist jedoch zweifellos so,
; dass IF niemals bedingungslos verwendet wird (IF (cc) -Syntax, wie 
; in der Anleitung angegeben ...). Beachten Sie in diesem Zusammenhang,
; dass eine IFNE [Bedingung] validiert wird, wenn die Bedingung jemals
; wahr ist, da die Bewertung der Bedingung WAHR ergibt, was 1 wert ist,
; und nicht FALSCH, was 0 wert ist ... Nicht sehr intuitiv.

; Von Denis Duplan (denis_duplan@yahoo.fr) für Stash of Code
; (http://www.stashofcode.fr) im August 2017

; Diese Arbeit wird unter den Bedingungen der Creative Commons
; Namensnennung-Keine kommerzielle Nutzung-Weitergabe unter
; gleichen Bedingungen 4.0 UK-Lizenz zur Verfügung gestellt.

;---------- Direktiven ----------

	SECTION yragael,CODE_C

;---------- Konstanten ----------

; Register

FMODE=$1FC
INTENA=$09A
INTENAR=$01C
INTREQ=$09C
INTREQR=$01E
DMACON=$096
DMACONR=$002
COLOR00=$180
COLOR01=$182
COP1LCH=$080
COP1LCL=$082
COPJMP1=$088
COP2LCH=$084
COP2LCL=$086
COPJMP2=$08A
DIWSTRT=$08E
DIWSTOP=$090
BPLCON0=$100
BPLCON1=$102
BPLCON2=$104
DDFSTRT=$092
DDFSTOP=$094
BPL1MOD=$108
BPL2MOD=$10A
BPL1PTH=$0E0
BPL1PTL=$0E2

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=1
COPPERSIZE=2000
START=100		; Entspricht der Zeile START-DISPLAY_Y in der Bitebene
				; (START = 0 => Zeile 44, START = 127 => Zeile 83, START = 255 => Zeile 211)
END=280			; Entspricht der Zeile END-DISPLAY_Y in der Bitebene
NB_MOVES=40

;---------- Initialisierung ----------

; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5

; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPPERSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList

; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist
; (für eine bitplane 320x256)

	move.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplane

; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

; Hardware-Interrupts und DMA sichern

	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

;---------- Copperlist ----------

	movea.l copperList,a0

; Bildschirmkonfiguration

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
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+

; Kompatibilität OCS mit AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

; Adresse Bitplane

	move.w #BPL1PTL,(a0)+
	move.l bitplane,d0
	move.w d0,(a0)+
	move.w #BPL1PTH,(a0)+
	swap d0
	move.w d0,(a0)+

; Palette

	move.w #COLOR01,(a0)+
	move.w #$0FFF,(a0)+

; Hintergrundfarbe schwarz

	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+

; Test einer Schleife: Wiederholen Sie eine Reihe von NB_MOVES MOVE
; vom Anfang der Bitebene (horizontale Position $3E) zwischen den
; enthaltenen START- und END-Zeilen

; Es ist unmöglich, das copper zu bitten, nur an einer horizontalen
; Position auf den Elektronenstrahl zu warten, zumindest an allen
; möglichen vertikalen Positionen. Wenn es tatsächlich möglich ist,
; eine Maske anzugeben, die auf die vertikale Position angewendet
; werden soll, um ihren Vergleich mit den nicht maskierten Bits des
; Wertes Y über 8 Bits zu beschränken, die im höchstwertigen Byte
; des zweiten Wortes angegeben sind, ist dies unmöglich Bit 7 
; ausblenden. Von der vertikalen Position $80. (dh: 128) geht das
; Bit 7 der vertikalen Position auf 1. Dieses Bit wird mit Y verglichen,
; wo es bei 0 liegt. Die aktuelle vertikale Position ist daher größer
; Bei Y wird WAIT unabhängig vom Ergebnis des Vergleichs an der
; horizontalen Position validiert. Die MOVE-Reihe wird daher vor der
; horizontalen Position ausgeführt, an der der Elektronenstrahl erwartet
; wurde. Dies ist das Problem, das im Amiga-Hardware-Referenzhandbuch
; für den SKIP-Befehl beschrieben ist und hier für den WAIT-Befehl
; in einer Schleife auftritt, in der die Zeilennummer $80 überschreitet
; (plus ein weiteres Problem). derjenige, der $100 ausgibt).


; ALLGEMEINE ZUSAMMENFASSUNG
;
;// hp ist ein gerader Wert in [$00, $E0] in PAL
;// vp ist ein beliebiger Wert in [$00, $FF]
;// he ist ein beliebiger Wert in [$00, $7F] (sein Bit 7 wird immer auf 1 gesetzt)
;// ve ist ein gerader Wert in [$00, $FE]
;
;typedef unsigned char BYTE;
;
;function WAIT (BYTE hp, BYTE he, BYTE he, BYTE ve) {
;	ve = $80 | ve;				//Bit 7 von y und vp kann nicht maskiert werden
;	if ((y & ve) >= (vp & ve))
;		return;
;	while ((y & ve) < (vp & ve));
;	while ((x & he) < (hp & he));
;}
;
;function SKIP (BYTE hp, BYTE vp, BYTE he, BYTE ve) {
;	ve = $80 | ve;				// Bit 7 von y und vp kann nicht maskiert werden
;	if ((y & ve) >= (vp & ve)) {
;		if ((x & he) >= (hp & he))
;			return (true);
;	}
;	return (false);
;}
;
; Der Algorithmus ist wie folgt: x und y entsprechen den Koordinaten
; des Elektronenstrahls, die sich parallel zu 8 Bits entwickeln
; (daher Schleifen durch Überlauf an jedem Rahmen) wie in einem 
; anderen Thread, und SKIP () und WAIT () vergleichen x und y auf
; die Werte, die nach dem Anwenden der Masken auf x und y angegeben
; wurden, sowie auf diese Werte:
;
; Es sollte daher beachtet werden, dass SKIP (x, y, mx, my)
; gleichbedeutend mit SKIP (x, y, mx, my! $ 80) ist und dasselbe für WAIT ().
;
;if (START > 255)
;	WAIT ($E0, $FF, $FE, $7F)									// Warten Sie, bis Sie in ($E0, $FF) oder darüber hinaus sind
;if (START < 255) {
;	WAIT ($00, START, $FE, $7F)									// Warten Sie, bis Sie in ($00, START) oder darüber hinaus sind
;	while (true) {
;		if (SKIP ($00, $80, $00, $00)) {						// Testen Sie, ob wir bei (%xxxxxxxx, $80) oder darüber hinaus sind
;			WAIT ($3E, $80, $FE, $00)							// Warten Sie, bis Sie in ($3E, %1xxxxxxx) oder darüber hinaus sind
;			for (i = 0 i != NB_MOVES i ++)
;				move (value, COLOR00)
;			if (NB_MOVES <= 38)
;				WAIT ($E0, $80, $FE, $00)						// Warten Sie, bis Sie in ($E0, %1xxxxxxx) oder darüber hinaus sind
;		}
;		else {
;			WAIT ($3E, $00, $FE, $00)							// Warten Sie, bis Sie in ($3E, %0xxxxxxx) oder darüber hinaus sind
;			for (i = 0 i != NB_MOVES i ++)
;				move (value, COLOR00)
;			if (NB_MOVES <= 38)
;				WAIT ($E0, $00, $FE, $00)						// Warten Sie, bis Sie in ($E0, %0xxxxxxx) oder darüber hinaus sind
;		}
;		if ((END >= 255) && (START <= 255)) {
;			if (SKIP ($00, $FF, $00, $7F) { 					// Testen Sie, ob wir bei (%xxxxxxxx, $FF) oder darüber hinaus sind
;				WAIT ($3E, $FF, $FE, $7F)						// Warten Sie, bis Sie in ($3E, $FF) oder darüber hinaus sind
;				for (i = 0 i != NB_MOVES i ++)
;					move (value, COLOR00)
;				if (END == 255)
;					return
;				if (NB_MOVES <= 38)
;					WAIT ($E0, $FF, $FE, $7F)					// Warten Sie, bis Sie in ($E0, $FF) oder darüber hinaus sind
;				while (true) {
;					WAIT ($3E, $00, $FE, $00)					// Warten Sie, bis Sie in ($3E, %0xxxxxxx) oder darüber hinaus sind
;					for (i = 0 i != NB_MOVES i ++)
;						move (value, COLOR00)
;					if (NB_MOVES <= 38)
;						WAIT ($E0, $00, $FE, $00)				// Warten Sie, bis Sie in ($E0, %0xxxxxxx) oder darüber hinaus sind
;					if (SKIP ($00, (END + 1) & $FF, $00, $7F))	// Testen Sie, ob wir bei (%xxxxxxxx, (END + 1) & $FF) oder darüber hinaus sind
;						return
;				}
;			}
;		}
;		if (SKIP ($00, (END + 1) & $FF, $00, $7F))				// Testen Sie, ob wir bei (%xxxxxxxx, (END + 1) & $FF) oder darüber hinaus sind
;			return
;	}
;}
;else
;	WAIT ($00, $FF, $FE, $7F)									// Warten Sie, bis Sie in ($00, $FF) oder darüber hinaus sind
;if ((END >= 255) && (START >= 255)) {
;	if (SKIP ($00, $FF, $00, $7F) { 							// Testen Sie, ob wir bei (%xxxxxxxx, $FF) oder darüber hinaus sind
;		WAIT ($3E, $FF, $FE, $7F)								// Warten Sie, bis Sie in ($3E, $FF) oder darüber hinaus sind
;		for (i = 0 i != NB_MOVES i ++)
;			move (value, COLOR00)
;		if (END == 255)
;			return
;		if (NB_MOVES <= 38)
;			WAIT ($E0, $FF, $FE, $7F)							// Warten Sie, bis Sie in ($E0, $FF) oder darüber hinaus sind
;		while (true) {
;			WAIT ($3E, $00, $FE, $00)							// Warten Sie, bis Sie in ($3E, %0xxxxxxx) oder darüber hinaus sind
;			for (i = 0 i != NB_MOVES i ++)
;				move (value, COLOR00)
;			if (NB_MOVES <= 38)
;				WAIT ($E0, $00, $FE, $00)						// Warten Sie, bis Sie in ($E0, %0xxxxxxx) oder darüber hinaus sind
;			if (SKIP ($00, (END + 1) & $FF, $00, $7F))			// Testen Sie, ob wir bei sind (%xxxxxxxx, (END + 1) & $FF) oder darüber hinaus sind
;				return
;		}
;	}
;}

	IF START>255

;---------- Beginn des bedingten Teils für den Fall START > 255: Keine Kreuzung von $FF ----------

; Wenn die vertikale START-Position> 255 ist, warten Sie auf das Ende der Zeile 255 ...

	move.w #($FF<<8)!$E0!$0001,(a0)+					; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($7F<<8)!$00FE!$0000,(a0)+			; WAIT 2nd word (BFD ! mask y ! mask x ! 0)

;---------- Ende des bedingten Teils für den Fall START > 255: Keine Kreuzung von $FF ----------

	ENDC

	IF 255>START
	
;---------- Beginn des bedingten Teils für den Fall START < 255: 
;			Mögliche Überschreitung von $FF ----------

; Bereiten Sie die Adresse vor, zu der Sie springen möchten (A)

	move.l a0,d0
	addi.l #5*4,d0
	move.w #COP1LCL,(a0)+
	move.w d0,(a0)+						; MOVE (COP1LCL)
	swap d0
	move.w #COP1LCH,(a0)+
	move.w d0,(a0)+						; MOVE (COP1LCH)

; Warten Sie auf die vertikale START-Position und die horizontale
; Position $00 (um sicherzugehen, dass Sie auf die horizontale
; Position warten können, an der die MOVEs ausgeführt werden sollen).

	move.w #(START<<8)!$00!$0001,(a0)+			; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($7F<<8)!$FE!$0000,(a0)+		; WAIT 2nd word (BFD ! mask y ! mask x ! 0)

; Bereiten Sie die Adresse vor, zu der Sie springen möchten (B)

	move.l a0,d0
	IF 38>NB_MOVES							; Weil Fehler in ASM-One 1.20:
											; < als <= interpretiert wird!
	addi.l #(5+NB_MOVES+4)*4,d0
	ELSE
	addi.l #(5+NB_MOVES+3)*4,d0
	ENDC
	move.w #COP2LCL,(a0)+
	move.w d0,(a0)+							; MOVE (COP2LCL)
	swap d0
	move.w #COP2LCH,(a0)+
	move.w d0,(a0)+							; MOVE (COP2LCH)

; (A) Wenn die vertikale Position < $80 ist, springen Sie zu (B)

	move.w #($80<<8)!$00!$0001,(a0)+		; SKIP 1st word (y ! x ! 1)
	move.w #$8000!($00<<8)!$00!$0001,(a0)+	; SKIP 2nd word (BFD ! mask y ! mask x ! 1)
	move.l a0,d0
	move.w #COPJMP2,(a0)+
	move.w #$0000,(a0)+						; MOVE (COPJMP2)

; Die vertikale Position ist> = $80. Warten Sie an jeder vertikalen
; Position auf die horizontale Position $ 3E, aber> = $ 80 (dh: 1xxxxxxx)

	move.w #($80<<8)!$3E!$0001,(a0)+		; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($00<<8)!$FE!$0000,(a0)+ 	; WAIT 2nd word (BFD ! mask y ! mask x ! 0)

; MOVE ausführen

	lea colors,a1
	REPT NB_MOVES
	move.w #COLOR00,(a0)+
	move.w (a1)+,(a0)+						; #NB_MOVES MOVE (COLOR00)
	ENDR

; Warten Sie auf das Zeilenende an der horizontalen Position $E0
; an einer beliebigen vertikalen Position, aber> = 80 (dh: 1xxxxxxx),
; damit die nächste Zeile ...

	IF 38>NB_MOVES							; Weil Fehler in ASM-One 1.20: < als <= interpretiert wird!
	move.w #($80<<8)!$E0!$0001,(a0)+		; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($00<<8)!$FE!$0000,(a0)+	; WAIT 2nd word (BFD ! mask y ! mask x ! 0)
	ENDC

; Springe zu (C)

	move.l a0,d0
	IF 38>NB_MOVES							; Weil Fehler in ASM-One 1.20: < als <= interpretiert wird!
	addi.l #(4+NB_MOVES+1)*4,d0
	ELSE
	addi.l #(4+NB_MOVES)*4,d0
	ENDC
	move.w #COP2LCL,(a0)+
	move.w d0,(a0)+							; MOVE (COP2LCL)
	swap d0
	move.w #COP2LCH,(a0)+
	move.w d0,(a0)+							; MOVE (COP2LCH)
	move.w #COPJMP2,(a0)+
	move.w #$0000,(a0)+						; MOVE (COPJMP2)

; (B) Die vertikale Position ist < $80. Warten Sie auf die horizontale
; Position $ 3E an einer beliebigen vertikalen Position, jedoch < $80
; (dh: 0xxxxxxx).

	move.w #($00<<8)!$3E!$0001,(a0)+		; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($00<<8)!$FE!$0000,(a0)+	; WAIT 2nd word (BFD ! mask y ! mask x ! 0)

; MOVE ausführen

	lea colors,a1
	lea 40*2(a1),a1
	REPT NB_MOVES
	move.w #COLOR00,(a0)+
	move.w -(a1),(a0)+						; #NB_MOVES MOVE (COLOR00)
	ENDR

; Warten Sie auf das Zeilenende an der horizontalen Position $E0 an einer
; beliebigen vertikalen Position außer <$ 80 (dh: 0xxxxxxx), also auf die
; nächste Zeile

	IF 38>NB_MOVES							; Weil Fehler in ASM-One 1.20: < als <= interpretiert wird!
	move.w #($00<<8)!$E0!$0001,(a0)+		; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($00<<8)!$FE!$0000,(a0)+	; WAIT 2nd word (BFD ! mask y ! mask x ! 0)
	ENDC

;---------- Beginn des bedingten Teils für den Fall START <255: 
;			Mögliche Überschreitung von $ FF ----------

	ELSE

;---------- Beginn des bedingten Teils für den Fall START = 255:
;			Mögliche Überschreitung von $ FF ----------

; Warten Sie auf die horizontale Position $00 bis zur vertikalen Position $FF

	move.w #($FF<<8)!$00!$0001,(a0)+		; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($7F<<8)!$FE!$0000,(a0)+	; WAIT 2nd word (BFD ! mask y ! mask x ! 0)

;----------Ende des bedingten Teils für den Fall START = 255: Mögliche Überschreitung von $FF ----------

	ENDC

	IF (END>=255)&(255>=START)		; Weil Fehler in ASM-One 1.20: < als <= interpretiert wird!

;---------- Beginn des bedingten Teils für den Fall (END> = 255) & (START <= 255): Kreuzung von $FF ----------
	
; Warum (ENDE> = 255) & (255> = STARTEN)? Weil der Fall, in dem START> 255 impliziert,
; dass END> 255 und daher keine Kreuzung von $FF vorliegt: der Teil des vorhergehenden
; Codes, der für Zeilen <$80 gültig ist, dem notwendigerweise ein $FFE1FFFE vorausgeht,
; um $FF zu kreuzen (Dieses WAIT ist durch START> 255 bedingt) ermöglicht die problemlose
; Verwaltung der Situation.
; Wir kommen also hier an, wenn wir gerade $FE gezeichnet haben und nachdem wir in $E0
; gewartet haben, betrachtet das Copper daher, dass die Zeile $FF ist
; Dies ist der Grund, warum wir den bedingten Teil eingeführt haben, wenn START = 255.
; Denn sonst hätten wir schon $FF gezogen, wenn wir hier angekommen wären

; (C) Springe zu (A), wenn die vertikale Position < $FF ist

	move.w #($FF<<8)!$00!$0001,(a0)+					; SKIP 1st word (y ! x ! 1)
	move.w #$8000!($7F<<8)!$00!$0001,(a0)+				; SKIP 2nd word (BFD ! mask y ! mask x ! 1)
	move.w #COPJMP1,(a0)+
	move.w #$0000,(a0)+									; MOVE (COPJMP2)

; Die vertikale Position ist $FF. Warten Sie auf die horizontale Position $3E
; bis zur vertikalen Position $ FF

	move.w #($FF<<8)!$3E!$0001,(a0)+					; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($7F<<8)!$FE!$0000,(a0)+				; WAIT 2nd word (BFD ! mask y ! mask x ! 0)

; MOVE ausführen

	lea colors,a1
	lea 40*2(a1),a1
	REPT NB_MOVES
	move.w #COLOR00,(a0)+
	move.w -(a1),(a0)+									; #NB_MOVES MOVE (COLOR00)
	ENDR

; Wenn die letzte Zeile $FF ist, springe zu (E)

	IF END=255

;---------- Beginn des bedingten Teils für den Fall END = 255: Ende ----------
	
; Warum nicht mit Copper testen, ob $FF die letzte Linie ist, die gezogen wird?
; Weil es unmöglich ist, einen funktionierenden Test zu entwickeln. In der Tat
; waren am Ende der vorherigen MOVEs entweder die MOVEs ziemlich zahlreich und
; $E0 wurde überschritten, und Copper ist der Ansicht, dass die Linie $00 beträgt,
; oder sie reichen nicht aus, und es wird davon ausgegangen, dass die Linie immer 
; noch $FF ist. Wir können die beiden Fälle ausrichten, indem wir nach dem zweiten
; eine WAIT in $E0 hinzufügen (darüber hinaus tun wir dies später). Kurz gesagt, 
; wir befinden uns dann in einer Situation, in der der copper davon ausgeht, dass
; die Linie $00 ist, nachdem er $FF gezogen hat. Aber welcher Test, um zu wissen,
; ob $FF die letzte Zeile ist? Ein SKIP-In (END & $ FF), der das Überspannen eines
; COPJMP in (D) ermöglicht, funktioniert wie folgt:
; wenn END = 255, testen wir, ob $00> = $FF => daher fehlschlägt COPJMP: ok
; wenn END = 256, testen wir, ob $00> = $00 => erfolgreich ist. COPJMP wird vermieden: ok
; wenn END = 257, testen wir, ob $00> = $01 => daher COPJMP: nok fehlschlägt
; Wir sehen, dass es unmöglich ist, Fehler / Erfolg des SKIP und den erwarteten Sprung /
; keinen Sprung in Einklang zu bringen. Aus diesem Grund beschließen wir, einen
; bedingten Code zum Verlassen der Schleife bei END = 255 zu erstellen

	move.l a0,d0
	IF 38>NB_MOVES
	addi.l #(7+NB_MOVES+3)*4,d0
	ELSE
	addi.l #(6+NB_MOVES+2)*4,d0
	ENDC
	move.w #COP1LCL,(a0)+
	move.w d0,(a0)+										; MOVE (COP1LCL)
	swap d0
	move.w #COP1LCH,(a0)+ 
	move.w d0,(a0)+										; MOVE (COP1LCH)	
	move.w #COPJMP1,(a0)+
	move.w #$0000,(a0)+									; MOVE (COPJMP1)

;---------- Ende des bedingten Teils für den Fall END = 255: Ende ----------

	ENDC

; Warten Sie auf das Ende der Zeile $FF an der horizontalen Position $E0,
; also auf die nächste Zeile $00
; Tatsächlich ist es sogar nach 39 MOVE und deshalb habe ich die Tests
; in 38> NB_MOVES umgewandelt! SIEHE TEST.S
; Dieser Test ist für NB_MOVES> = 40 nicht erforderlich und sogar schädlich.
; Nach 40 MOVE von $3E in der $FF-Zeile befindet sich das Raster zwar nur in $DE,
; aber der Copper hat keine Zeit, diese WAIT auszuführen, bevor er $E0 überschreitet.
; Wenn das Raster jedoch $E0 überschreitet, berücksichtigt das Copper, dass
; die aktuelle Zeile die nächste Zeile geworden ist, sodass sich das Raster
; nicht mehr in der Zeile $FF befindet, sondern in der Zeile $00 (die Zeichnung
; der Zeile $FF nicht fertig, aber das Copper verlässt sich in seinem
; Vergleichsmechanismus nicht darauf; es ist, als hätte es einen eigenen aktuellen
; Zeilenzähler, der jedes Mal erhöht wird, wenn $E0 gekreuzt wird). Folglich
; interpretiert der Copper diese WAIT als WAIT in $E0 auf der $FF-Zeile, während
; die aktuelle Zeile $00 wäre, wodurch er einen ganzen Frame warten muss!
; Deshalb muss dieses WAIT konditioniert werden


	IF 38>NB_MOVES
	move.w #($FF<<8)!$E0!$0001,(a0)+					; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($7F<<8)!$FE!$0000,(a0)+				; WAIT 2nd word (BFD ! mask y ! mask x ! 0)
	ENDC

; Bereiten Sie die Adresse vor, zu der Sie springen möchten (A)

	move.l a0,d0
	addi.l #2*4,d0
	move.w #COP1LCL,(a0)+
	move.w d0,(a0)+										; MOVE (COP1LCL)
	swap d0
	move.w #COP1LCH,(a0)+
	move.w d0,(a0)+										; MOVE (COP1LCH)

; (A) Warten Sie, bis die horizontale Position $3E eine beliebige
; vertikale Position ist, aber <$ 80 (dh: 0xxxxxxx)

	move.w #($00<<8)!$3E!$0001,(a0)+					; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($00<<8)!$FE!$0000,(a0)+				; WAIT 2nd word (BFD ! mask y ! mask x ! 0)

; MOVE ausführen

	lea colors,a1
	lea 40*2(a1),a1
	REPT NB_MOVES
	move.w #COLOR00,(a0)+
	move.w -(a1),(a0)+									; #NB_MOVES MOVE (COLOR00)
	ENDR

; Warten Sie auf das Zeilenende an der horizontalen Position $E0
; an einer beliebigen vertikalen Position, aber <$ 80 (dh: 0xxxxxxx),
; also auf die nächste Zeile

	IF 38>NB_MOVES										; Denn Fehler in ASM-One 1.20: < wird als <= interpretiert!
	move.w #($00<<8)!$E0!$0001,(a0)+					; WAIT 1st word (y ! x ! 1)
	move.w #$8000!($00<<8)!$FE!$0000,(a0)+				; WAIT 2nd word (BFD ! mask y ! mask x ! 0)
	ENDC

;---------- Ende des bedingten Teils für den Fall (END> = 255) & (START <= 255): 
;			Kreuzung von $ FF ----------

	ENDC

; (D) Springe zu (A), wenn die vertikale Position <((END + 1) & $FF) ist.

	move.w #(((END+1)&$FF)<<8)!$00!$0001,(a0)+			; SKIP 1st word (y ! x ! 1)
	move.w #$8000!($7F<<8)!$00!$0001,(a0)+				; SKIP 2nd word (BFD ! mask y ! mask x ! 1)
	move.w #COPJMP1,(a0)+
	move.w #$0000,(a0)+									; MOVE (COPJMP1)

; (E) Stellen Sie die Adresse der copperliste für den nächsten
; Frame wieder her

	move.l copperList,d0
	move.w #COP1LCL,(a0)+
	move.w d0,(a0)+										; MOVE (COP1LCL)
	swap d0
	move.w #COP1LCH,(a0)+
	move.w d0,(a0)+										; MOVE (COP1LCH)

; Hintergrundfarbe schwarz

	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+

; Ende

	move.l #$FFFFFFFE,(a0)

;---------- Hauptprogramm ----------

; DMA einschalten

	move.w #$8380,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1

; Copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

; Hauptschleife

	move.l bitplane,a0
	movea.l a0,a1
	REPT 10
	move.l #$FFFFFFFF,(a1)+
	ENDR
	lea (128-DISPLAY_Y)*(DISPLAY_DX>>3)(a0),a1
	REPT 10
	move.l #$AAAAAAAA,(a1)+
	ENDR
	lea (255-DISPLAY_Y)*(DISPLAY_DX>>3)(a0),a1
	REPT 10
	move.l #$AAAAAAAA,(a1)+
	ENDR
	lea (DISPLAY_DY-1)*(DISPLAY_DX>>3)(a0),a1
	REPT 10
	move.l #$FFFFFFFF,(a1)+
	ENDR

	lea (START-DISPLAY_Y)*(DISPLAY_DX>>3)(a0),a1
	REPT 10
	move.l #$F0F0F0F0,(a1)+
	ENDR
	lea (END-DISPLAY_Y)*(DISPLAY_DX>>3)(a0),a1
	REPT 10
	move.l #$F0F0F0F0,(a1)+
	ENDR


_loop:
	btst #6,$BFE001
	bne _loop

;---------- Ende ----------

; Hardware-Interrupts und DMA ausschalten

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
	move.l 50(a1),COP2LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

; Speicher wieder freigeben

	movea.l bitplane,a1
	move.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l copperList,a1
	move.l #COPPERSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Daten ----------

graphicslibrary:	dc.b "graphics.library",0
	even
copperList:		dc.l 0
bitplane:		dc.l 0
olddmacon:		dc.w 0
oldintena:		dc.w 0
oldintreq:		dc.w 0
colors:
	DC.W $0F00,$00F0,$000F,$0FFF,$0000,$0FF0,$0F0F,$00FF
	DC.W $0C00,$00C0,$000C,$0CCC,$0000,$0CC0,$0C0C,$00CC
	DC.W $0900,$0090,$0009,$0999,$0000,$0990,$0909,$0099
	DC.W $0600,$0060,$0006,$0666,$0000,$0660,$0606,$0066
	DC.W $0300,$0030,$0003,$0333,$0000,$0330,$0303,$0033
