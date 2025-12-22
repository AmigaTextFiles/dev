
; Lezione10m1.s	Universalroutine Bob
; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#2-1,D1			; Anzahl der Bitplanes (hier sind es 2)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0	; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse:

; Parameter für Hintergrund speichern

	move.w	ogg_x(pc),d0		; Position X
	move.w	ogg_y(pc),d1		; Position Y
	move.w	#32,d2				; Dimension X
	move.w	#30,d3				; Dimension Y
	bsr.w	SalvaSfondo			; Speichere den Hintergrund

; Parameter für UniBob-Routinen

	move.l	Frametab(pc),a0		; setzt den Zeiger auf den Rahmen
								; in A0 zu zeichnen
	lea	2*4*30(a0),a1			; Zeiger auf die Maske in A1
	move.w	ogg_x(pc),d0		; Position X
	move.w	ogg_y(pc),d1		; Position Y
	move.w	#32,d2				; Dimension X
	move.w	#30,d3				; Dimension Y
	bsr.w	UniBob			    ; zeichne den Bob mit der 
								; universal Routine

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $130 (304)
	BNE.S	Waity1

; Parameter für die Routine Hintergrund wiederherstellen

	move.w	ogg_x(pc),d0		; Position X
	move.w	ogg_y(pc),d1		; Position Y
	move.w	#32,d2				; Dimension X
	move.w	#30,d3				; Dimension Y
	bsr.w	RipristinaSfondo	; stelle den Hintergrund wieder her

	bsr.s	MuoviOggetto	; Verschiebe das Objekt auf dem Bildschirm
	bsr.s	Animazione		; verschiebe die Rahmen in der Tabelle

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; Wenn nicht, gehe zurück zu mouse:
	rts


;****************************************************************************
; Diese Routine bewegt den Bob auf dem Bildschirm.
;****************************************************************************

MuoviOggetto:
	addq.w	#1,ogg_x		; Verschiebe den Bob nach rechts
	cmp.w	#320-32,ogg_x	; hat es die rechte Kante erreicht?
	bls.s	EndMuovi		; wenn kein Ende
	clr.w	ogg_x			; ansonsten von links starten
EndMuovi
	rts

;****************************************************************************
; Diese Routine erstellt die Animation und verschiebt die Rahmenadressen
; so dass jedes Mal, der erste zum letzten Platz der Tabelle geht,
; die anderen liegen alle in der Richtung des ersten
;****************************************************************************

Animazione:
	addq.b	#1,ContaAnim    ; Diese drei Anweisungen machen das die
	cmp.b	#4,ContaAnim    ; Frames immer einmal geändert werden
	bne.s	NonCambiare     ; 3x nein und 1 x ja
	clr.b	ContaAnim		; für die Geschwindigkeit der Animation
	LEA	FRAMETAB(PC),a0		; Tabelle mit den Adressen der 4 Bilder
	MOVE.L	(a0),d0		    ; Speichere die erste Adresse in d0
	MOVE.L	4(a0),(a0)		; verschiebe die anderen Adressen zurück
	MOVE.L	4*2(a0),4(a0)	; Diese Anweisungen "rotieren" die Adressen
	MOVE.L	4*3(a0),4*2(a0) ; von der Tabelle.
	MOVE.L	d0,4*3(a0)		; Stellen Sie die erste Adresse auf den achten Platz

NonCambiare:
	rts

ContaAnim:
	dc.w	0

; Dies ist die Frame-Adressentabelle. Die Adressen die in der Tabelle 
; vorhanden sind rotieren innerhalb der Animationsroutine. so dass
; der erste in der Tabelle das erste Mal Frame1 ist, durch die Rotation
; dann Frame2, dann die 3,4 und dann wieder der erste, immer zyklisch.
; Auf diese Weise nehmen Sie einfach die Adresse, die am Anfang der 
; Tabelle steht.

FRAMETAB:
	DC.L	Frame1
	DC.L	Frame2
	DC.L	Frame3
	DC.L	Frame4

; BOB-Positionsvariablen

OGG_Y:		dc.w	100	; das Y des Objekts wird hier gespeichert
OGG_X:		dc.w	50	; das X des Objekts wird hier gespeichert

;***************************************************************************
; Dies ist die universelle Routine zum Zeichnen von Bobs in Form und Größe
; willkürlich. Alle Parameter werden über Register weitergegeben.
; Die Routine funktioniert auf einem normalen Bildschirm
;
; A0 - Adresse Figur bob
; A1 - Bobmaskenadresse
; D0 - X Koordinate des oberen linken Eckpunkts
; D1 - Y-Koordinate des oberen linken Eckpunkts
; D2 - Rechteckbreite in Pixel
; D3 - Rechteckhöhe
;****************************************************************************

;	       ___  Oo          .:/
;	      (___)o_o        ,,///;,   ,;/
;	 //====--//(_)       o:::::::;;///
;	         \\ ^       >::::::::;;\\\
;	                      ''\\\\\'" ';\

UniBob:

; Berechnung der Startadresse des Blitters

	lea	bitplane,a2		; Adresse bitplane
	mulu.w	#40,d1		; Offset Y
	add.l	d1,a2		; zur Adresse hinzufügen
	move.w	d0,d6		; kopiere das X
	lsr.w	#3,d0		; teile das X durch 8
	and.w	#$fffe,d0	; mach es gleich
	add.w	d0,a2		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

	and.w	#$000f,d6	; wähle die ersten 4 Bits des X aus
	; Sie müssen in den Shifter der Kanäle A, B eingefügt werden 
	lsl.w	#8,d6		; Die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d6		; des Wortes. Dies ist der Wert von BLTCON1

	move.w	d6,d5		; kopieren, um den Wert von BLTCON0 zu berechnen
	or.w	#$0FCA,d5	; Werte, die in BLTCON0 gesetzt werden sollen

; berechnet den Versatz zwischen den Ebenen der Figur
	lsr.w	#3,d2		; dividiere die Breite um 8
	and.w	#$fffe,d2	; Ich nulle Bit 0 (ich bin gerade)
	move.w	d2,d0		; Kopier Breite geteilt durch 8
	mulu	d3,d2		; multiplizieren mit der Höhe

; Blitter Modulo Berechnung

	addq.w	#2,d0		; Blittata ist ein größeres Wort
	move.w	#40,d4		; Bildschirmbreite in Bytes
	sub.w	d0,d4		; modulo=Breite Bildschirm - Breite Rechteck

; Berechnung der gemischten Größe

	lsl.w	#6,d3		; Höhe für 64
	lsr.w	#1,d0		; Pixelbreite geteilt durch 16
						; das heißt, Breite in Worten
	or	d0,d3			; Setze die Dimensionen zusammen

; initialisiere die Register, die konstant bleiben
	btst	#6,2(a5)
WBlit_u1:
	btst	#6,2(a5)		 ; warte auf das Ende des Blitters
	bne.s	wblit_u1

	move.l	#$ffff0000,$44(a5)	; BLTAFWM = $ffff Es passiert alles
							; BLTALWM = $0000 setzt das letzte Wort zurück

	move.w	d6,$42(a5)		; BLTCON1 - Verschiebungswert
							; kein besonderer Weg

	move.w	d5,$40(a5)		; BLTCON0 - Verschiebungswert
							; cookie-cut

	move.l	#$fffefffe,$62(a5)	; BLTBMOD und BLTAMOD=$fffe=-2 Retouren
							; zurück zum Anfang der Zeile.

	move.w	d4,$60(a5)		; BLTCMOD berechneter Wert
	move.w	d4,$66(a5)		; BLTDMOD berechneter Wert

	moveq	#2-1,d7			; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)
WBlit_u2:
	btst	#6,2(a5)		 ; warte auf das Ende des Blitters
	bne.s	wblit_u2


	move.l	a1,$50(a5)		; BLTAPT  (Maske)
	move.l	a2,$54(a5)		; BLTDPT  (Bildschirmzeilen)
	move.l	a2,$48(a5)		; BLTCPT  (Bildschirmzeilen)
	move.l	a0,$4c(a5)		; BLTBPT  (Figur bob)
	move.w	d3,$58(a5)		; BLTSIZE (Blitter starten!)

	add.l	d2,a0			; zeigt auf die nächste Quellenebene

	lea	40*256(a2),a2		; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop

	rts

;****************************************************************************
; Diese Routine kopiert das Hintergrundrechteck, das mit dem BOB überschrieben 
; wird in einen Puffer. Die Routine behandelt einen Bob beliebiger Größe.
; Wenn Sie diese Routine für Bobs unterschiedlicher Größe verwenden, seien Sie 
; vorsichtig dass der Puffer die maximale Größe des Bobs halten kann!
; Die Position und Größe des Rechtecks sind Parameter
;
; D0 - X Koordinate des oberen linken Eckpunkts
; D1 - Y-Koordinate des oberen linken Eckpunkts
; D2 - Rechteckbreite in Pixel
; D3 - Rechteckhöhe
;****************************************************************************

SalvaSfondo:
; Berechnung der Startadresse des Blitters

	lea	bitplane,a1		; Adresse bitplane
	mulu.w	#40,d1		; Offset Y
	add.l	d1,a1		; zur Adresse hinzufügen
	lsr.w	#3,d0		; teile das X durch 8
	and.w	#$fffe,d0	; mach es gleich
	add.w	d0,a1		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

;berechnet den Versatz zwischen den Ebenen der Figur
	lsr.w	#3,d2		; dividiere die Breite um 8
	and.w	#$fffe,d2	; Ich nulle Bit 0 (ich bin gerade)
	addq.w	#2,d2		; Die Blittata ist 1 Wort mehr
	move.w	d2,d0		; Kopier Breite geteilt durch 8
	mulu	d3,d0		; multiplizieren mit der Höhe

; Blitter Modulo Berechnung
	move.w	#40,d4		; Bildschirmbreite in bytes
	sub.w	d2,d4		; modulo=Breite Bildschirm - Breite Rechteck

; Berechnung der gemischten Größe
	lsl.w	#6,d3		; Höhe für 64
	lsr.w	#1,d2		; Pixelbreite geteilt durch 16
						; das heißt, Breite in Worten
	or	d2,d3			; lege die Dimensionen zusammen

	lea	Buffer,a2		; Adresse Ziel
	moveq	#2-1,d7		; wiederhole es für jede Ebene
PlaneLoop2:
	btst	#6,2(a5)	; dmaconr
WBlit3:
	btst	#6,2(a5)	; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
								; BLTALWM = $ffff Es passiert alles

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.w	d4,$64(a5)		; BLTAMOD berechneter Wert
	move.w	#$0000,$66(a5)	; BLTDMOD=0 im Puffer
	move.l	a1,$50(a5)		; BLTAPT - Adresse Quelle
	move.l	a2,$54(a5)		; BLTDPT - Puffer
	move.w	d3,$58(a5)		; BLTSIZE (Blitter starten !)

	lea	40*256(a1),a1		; zeigt auf die nächste Quellenebene
	add.l	d0,a2			; zeigt auf die nächste Quellenebene

	dbra	d7,PlaneLoop2

	rts

;****************************************************************************
; Diese Routine kopiert den Inhalt des Puffers in das Bildschirmrechteck
; was es vor der BOB-Zeichnung enthielt. Auf diese Weise kommt es auch, das
; das BOB vom alten Standort gelöscht wird. Die Routine behandelt einen Bob 
; von willkürlicher Dimensionen.
; Wenn Sie diese Routine für Bobs unterschiedlicher Größe verwenden, seien Sie 
; vorsichtig dass der Puffer die maximale Größe des Bobs halten kann!
; Die Position und Größe des Rechtecks sind Parameter
;
; D0 - X Koordinate des oberen linken Eckpunkts
; D1 - Y-Koordinate des oberen linken Eckpunkts
; D2 - Rechteckbreite in Pixel
; D3 - Rechteckhöhe
;****************************************************************************

RipristinaSfondo:
; Berechnung der Startadresse des Blitters

	lea	bitplane,a1		; Adresse bitplane
	mulu.w	#40,d1		; Offset Y
	add.l	d1,a1		; zur Adresse hinzufügen
	lsr.w	#3,d0		; teile das X durch 8
	and.w	#$fffe,d0	; mach es gleich
	add.w	d0,a1		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

; berechnet den Versatz zwischen den Ebenen der Figur
	lsr.w	#3,d2		; dividiere die Breite um 8
	and.w	#$fffe,d2	; Ich nulle Bit 0 (ich bin gerade)
	addq.w	#2,d2		; Die Blittata ist 1 Wort mehr
	move.w	d2,d0		; Kopierbreite geteilt durch 8
	mulu	d3,d0		; multiplizieren mit der Höhe

; Berechnung modulo blitter
	move.w	#40,d4		; Bildschirmbreite in Bytes
	sub.w	d2,d4		; modulo=Breite Bildschirm-Breite Rechteck

; Berechnung Dimension blittata
	lsl.w	#6,d3		; Höhe für 64
	lsr.w	#1,d2		; Pixelbreite geteilt durch 16
						; das heißt, Breite in Worten
	or	d2,d3			; lege die Dimensionen zusammen

	lea	Buffer,a2		; Adresse Ziel
	moveq	#2-1,d7		; wiederhole es für jede Ebene
PlaneLoop3:
	btst	#6,2(a5) ; dmaconr
WBlit4:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit4

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
								; BLTALWM = $ffff Es passiert alles

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.w	d4,$66(a5)		; BLTDMOD berechneter Wert
	move.w	#$0000,$64(a5)	; BLTAMOD=0 im Puffer
	move.l	a2,$50(a5)		; BLTAPT - Puffer
	move.l	a1,$54(a5)		; BLTDPT - Bildschirm
	move.w	d3,$58(a5)		; BLTSIZE (Blitter starten!)

	lea	40*256(a1),a1		; zeigt auf die nächste Zielebene
	add.l	d0,a2			; zeigt auf die nächste Quellebene

	dbra	d7,PlaneLoop3

	rts


;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$2200	; bplcon0

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000

	dc.w	$180,$000	; color0
	dc.w	$182,$00b	; color1
	dc.w	$184,$cc0	; color2
	dc.w	$186,$b00	; color3

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************
; Dies sind die Frames, die die Animation ausmachen

Frame1:
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$03ffff80,$03ffff80
	dc.l	$03ffff80,$03ffff80,$03ffff80,$03ffff80,$03ffff80,$03ffff80
	dc.l	$03ffff80,$03ffff80,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00010000,$00038000,$0007c000,$000fe000,$001ff000,$003ff800
	dc.l	$007ffc00,$00fffe00,$01ffff00,$03ffff80,$03ffff80,$03ffff80
	dc.l	$03ffff80,$03ffff80,$03ffff80,$03ffff80,$03ffff80,$03ffff80
	dc.l	$03ffff80,$03ffff80,$03ffff80,$01ffff00,$00fffe00,$007ffc00
	dc.l	$003ff800,$001ff000,$000fe000,$0007c000,$00038000,$00010000
; maschera
	dc.l	$00010000,$00038000,$0007c000,$000fe000,$001ff000,$003ff800
	dc.l	$007ffc00,$00fffe00,$01ffff00,$03ffff80,$03ffff80,$03ffff80
	dc.l	$03ffff80,$03ffff80,$03ffff80,$03ffff80,$03ffff80,$03ffff80
	dc.l	$03ffff80,$03ffff80,$03ffff80,$01ffff00,$00fffe00,$007ffc00
	dc.l	$003ff800,$001ff000,$000fe000,$0007c000,$00038000,$00010000


Frame2:
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00300000
	dc.l	$00780000,$00fc0000,$01fe0000,$03ff0000,$07ff8000,$0fffc000
	dc.l	$07ffe000,$03fff000,$01fff800,$00fffc00,$007ffe00,$003fff00
	dc.l	$001fff80,$000fff00,$0007fe00,$0003fc00,$0001f800,$0000f000
	dc.l	$00006000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$001fffc0,$003fffc0
	dc.l	$007fffc0,$00ffffc0,$01ffffc0,$03ffffc0,$07ffffc0,$0fffffc0
	dc.l	$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0
	dc.l	$0fffff80,$0fffff00,$0ffffe00,$0ffffc00,$0ffff800,$0ffff000
	dc.l	$0fffe000,$00000000,$00000000,$00000000,$00000000,$00000000

	dc.l	$00000000,$00000000,$00000000,$00000000,$001fffc0,$003fffc0
	dc.l	$007fffc0,$00ffffc0,$01ffffc0,$03ffffc0,$07ffffc0,$0fffffc0
	dc.l	$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0
	dc.l	$0fffff80,$0fffff00,$0ffffe00,$0ffffc00,$0ffff800,$0ffff000
	dc.l	$0fffe000,$00000000,$00000000,$00000000,$00000000,$00000000

Frame3:
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$003ff000
	dc.l	$003ff000,$003ff000,$003ff000,$003ff000,$003ff000,$003ff000
	dc.l	$003ff000,$003ff000,$003ff000,$003ff000,$003ff000,$003ff000
	dc.l	$003ff000,$003ff000,$003ff000,$003ff000,$003ff000,$003ff000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$007ff800
	dc.l	$00fffc00,$01fffe00,$03ffff00,$07ffff80,$0fffffc0,$1fffffe0
	dc.l	$3ffffff0,$7ffffff8,$fffffffc,$7ffffff8,$3ffffff0,$1fffffe0
	dc.l	$0fffffc0,$07ffff80,$03ffff00,$01fffe00,$00fffc00,$007ff800
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000

	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$007ff800
	dc.l	$00fffc00,$01fffe00,$03ffff00,$07ffff80,$0fffffc0,$1fffffe0
	dc.l	$3ffffff0,$7ffffff8,$fffffffc,$7ffffff8,$3ffffff0,$1fffffe0
	dc.l	$0fffffc0,$07ffff80,$03ffff00,$01fffe00,$00fffc00,$007ff800
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000

Frame4:
	dc.l	$00000000,$00000000,$00000000,$00000000,$00006000,$0000f000
	dc.l	$0001f800,$0003fc00,$0007fe00,$000fff00,$001fff80,$003fff00
	dc.l	$007ffe00,$00fffc00,$01fff800,$03fff000,$07ffe000,$0fffc000
	dc.l	$07ff8000,$03ff0000,$01fe0000,$00fc0000,$00780000,$00300000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$0fffe000,$0ffff000
	dc.l	$0ffff800,$0ffffc00,$0ffffe00,$0fffff00,$0fffff80,$0fffffc0
	dc.l	$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0
	dc.l	$07ffffc0,$03ffffc0,$01ffffc0,$00ffffc0,$007fffc0,$003fffc0
	dc.l	$001fffc0,$00000000,$00000000,$00000000,$00000000,$00000000

	dc.l	$00000000,$00000000,$00000000,$00000000,$0fffe000,$0ffff000
	dc.l	$0ffff800,$0ffffc00,$0ffffe00,$0fffff00,$0fffff80,$0fffffc0
	dc.l	$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0,$0fffffc0
	dc.l	$07ffffc0,$03ffffc0,$01ffffc0,$00ffffc0,$007fffc0,$003fffc0
	dc.l	$001fffc0,$00000000,$00000000,$00000000,$00000000,$00000000

;****************************************************************************

; Dies ist der Puffer, in dem wir den Hintergrund von Zeit zu Zeit speichern.
; Er hat die gleichen Abmessungen wie eine Blittata: Höhe 30, Breite 3 Wörter
; 2 Bitebenen

Buffer:
	ds.w	30*3*2

; Die Bitebene enthält ein Bild von 1 Ebene 320 * 100
BITPLANE:

; plane 1
	ds.b	40*56				; 56 Linien
	;incbin	"sfondo320*100.raw"	; 100 Linien
	ds.b	40*100
	ds.b	40*100				; 100 Linien

	ds.b	40*256				; plane 2

;****************************************************************************

	end

In diesem Beispiel präsentieren wir eine universelle Routine zum Zeichnen von Bobs.
Die Routine behandelt Bobs unterschiedlicher Größe. Die Position, die Dimensionen
und die Adressen der Figur und der Bobmaske werden als Parameter übergeben.
Basierend auf den Parametern werden alle Werte berechnet, die in die Blitter-
Register geschrieben werden, wobei die zuvor gesehenen Formeln verwendet werden.
Folglich wurden auch die Rettungs- und Wiederherstellungsroutinen des Hintergrunds 
geändert, um veränderliche Rechtecke zu bearbeiten.
Achten Sie darauf, dass der von Ihnen verwendete Rettungspuffer der Routine 
groß genug ist, um das Rechteck aufzunehmen.
Mit diesen Routinen ist es möglich, einen animierten Bob in Kombination 
mit der Animationsroutine aus dem Beispiel lesson10l1.s (Animation
zyklisch) zu realisieren.
Beachten Sie, dass das Hintergrundbild den Bildschirm nur teilweise einnimmt
für den Rest wird es zurückgesetzt.