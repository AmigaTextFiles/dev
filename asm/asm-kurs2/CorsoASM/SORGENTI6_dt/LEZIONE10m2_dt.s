; Lezione10m2.s	Universalroutine Bob - Version interleaved
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
	ADD.L	#40,d0			; + Länge Reihe
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
	mulu.w	#2*40,d1	; Adresse berechnen: Jede Zeile besteht aus
						; 2 Ebenen von jeweils 40 Bytes
	add.l	d1,a2		; zur Adresse hinzufügen
	move.w	d0,d6		; kopiere das X
	lsr.w	#3,d0		; teile das X durch 8
	and.w	#$fffe,d0	; mach es gleich
	add.w	d0,a2		; Summe zur Adresse der Bitebene, Finden
						; die richtigen Zieladresse

	and.w	#$000f,d6	; wähle die ersten 4 Bits des X aus
	; Sie müssen in den Shifter der Kanäle A, B eingefügt werden 
	lsl.w	#8,d6		; Die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d6		; des Wortes. Dies ist der Wert von BLTCON1

	move.w	d6,d5		; kopieren, um den Wert von BLTCON0 zu berechnen
	or.w	#$0FCA,d5	; Werte, die in BLTCON0 gesetzt werden sollen

; berechnet den Versatz zwischen den Ebenen der Figur
	lsr.w	#3,d2		; dividiere die Breite um 8
	and.w	#$fffe,d2	; Ich nulle Bit 0 (ich bin gerade)
	addq.w	#2,d2		; Blittata ist ein größeres Wort
	move.w	#40,d4		; Bildschirmbreite in Bytes
	sub.w	d2,d4		; modulo=Breite Bildschirm-Breite Rechteck

; Berechnung Dimension blittata

	mulu	#2,d3		; Multiplizieren Sie die Höhe mit der Anzahl der Ebenen
						; (für verschachtelten Bildschirm)
						; In diesem Fall haben wir 2 Flugzeuge
						; Man könnte die ASL benutzen, aber im Allgemeinen
						; (zB 3 Flugzeuge) muss das MULU benutzt werden
	lsl.w	#6,d3		; Höhe für 64
	lsr.w	#1,d2		; Pixelbreite geteilt durch 16
						; das heißt, Breite in Worten
	or	d2,d3			; lege die Dimensionen zusammen

; initialisiere die Register
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

	move.l	#$fffefffe,$62(a5)	; BLTBMOD e BLTAMOD=$fffe=-2 Retouren
							; zurück zum Anfang der Zeile.

	move.w	d4,$60(a5)		; BLTCMOD berechneter Wert
	move.w	d4,$66(a5)		; BLTDMOD berechneter Wert

	move.l	a1,$50(a5)		; BLTAPT  (Maske)
	move.l	a2,$54(a5)		; BLTDPT  (Bildschirmzeilen)
	move.l	a2,$48(a5)		; BLTCPT  (Bildschirmzeilen)
	move.l	a0,$4c(a5)		; BLTBPT  (Figur bob)
	move.w	d3,$58(a5)		; BLTSIZE (Blitter starten!)

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
	mulu.w	#2*40,d1	; Adresse berechnen: Jede Zeile besteht aus
						; 2 Ebenen von jeweils 40 Bytes
	add.l	d1,a1		; zur Adresse hinzufügen
	lsr.w	#3,d0		; teile das X durch 8
	and.w	#$fffe,d0	; mach es gleich
	add.w	d0,a1		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

; Berechnung modulo blitter
	lsr.w	#3,d2		; dividiere die Breite um 8
	and.w	#$fffe,d2	; Ich nulle Bit 0 (ich bin gerade)
	addq.w	#2,d2		; Die Blittata ist 1 Wort mehr
	move.w	#40,d4		; Bildschirmbreite in bytes
	sub.w	d2,d4		; modulo=Breite Bildschirmbreite Rechteck

; Berechnung Dimensione blittata
	mulu	#2,d3		; Multiplizieren Sie die Höhe mit der Anzahl der Ebenen
						; (für verschachtelten Bildschirm)
						; In diesem Fall haben wir 2 Flugzeuge
						; Man könnte die ASL benutzen, aber im Allgemeinen
						; (zB 3 Flugzeuge) muss das MULU benutzt werden
	lsl.w	#6,d3		; Höhe für 64
	lsr.w	#1,d2		; Pixelbreite geteilt durch 16
						; das heißt, Breite in Worten
	or	d2,d3			; lege die Dimensionen zusammen

	lea	Buffer,a2		; Adresse Ziel

	btst	#6,2(a5)	; dmaconr
WBlit3:
	btst	#6,2(a5)	; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
								; BLTALWM = $ffff Es passiert alles

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.w	d4,$64(a5)		; BLTAMOD berechneter Wert
	move.w	#$0000,$66(a5)	; BLTDMOD=0 Puffer
	move.l	a1,$50(a5)		; BLTAPT - Adresse Quelle
	move.l	a2,$54(a5)		; BLTDPT - Puffer
	move.w	d3,$58(a5)		; BLTSIZE (Blitter starten !)

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
	mulu.w	#2*40,d1	; Adresse berechnen: Jede Zeile besteht aus
						; 2 Ebenen von jeweils 40 Bytes
	add.l	d1,a1		; zur Adresse hinzufügen
	lsr.w	#3,d0		; teile das X durch 8
	and.w	#$fffe,d0	; mach es gleich
	add.w	d0,a1		; Summe zur Adresse der Bitebene, Finden
						; die richtige Zieladresse

; Berechnung modulo blitter
	lsr.w	#3,d2		; dividiere die Breite um 8
	and.w	#$fffe,d2	; Ich zero Bit 0 (ich bin gerade)
	addq.w	#2,d2		; Die Blittata ist 1 Wort mehr
	move.w	#40,d4		; Bildschirmbreite in bytes
	sub.w	d2,d4		; modulo=Breite Bildschirmbreite Rechteck

; Berechnung Dimension blittata
	mulu	#2,d3		; Multiplizieren Sie die Höhe mit der Anzahl der Ebenen
						; (für verschachtelten Bildschirm)
						; In diesem Fall haben wir 2 Flugzeuge
						; Man könnte die ASL benutzen, aber im Allgemeinen
						; (zB 3 Flugzeuge) muss das MULU benutzt werden
	lsl.w	#6,d3		; Höhe für 64
	lsr.w	#1,d2		; Pixelbreite geteilt durch 16
						; das heißt, Breite in Worten
	or	d2,d3			; lege die Dimensionen zusammen

	lea	Buffer,a2		; Adresse Ziel

	btst	#6,2(a5)	; dmaconr
WBlit4:
	btst	#6,2(a5)	; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit4

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
								; BLTALWM = $ffff Es passiert alles

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.w	d4,$66(a5)		; BLTDMOD berechneter Wert
	move.w	#$0000,$64(a5)	; BLTAMOD=0 Puffer
	move.l	a2,$50(a5)		; BLTAPT - Puffer
	move.l	a1,$54(a5)		; BLTDPT - Bildschirm
	move.w	d3,$58(a5)		; BLTSIZE (Blitter starten!)

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
	dc.w	$108,40		; Bpl1Mod
	dc.w	$10a,40		; Bpl2Mod

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

	dc.l	$00000000,$00020000
	dc.l	$00000000,$00070000
	dc.l	$00000000,$000f8000
	dc.l	$00000000,$001fc000
	dc.l	$00000000,$003fe000
	dc.l	$00000000,$007ff000
	dc.l	$00000000,$00fff800
	dc.l	$00000000,$01fffc00
	dc.l	$00000000,$03fffe00
	dc.l	$00000000,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$07ffff00,$07ffff00
	dc.l	$00000000,$07ffff00
	dc.l	$00000000,$03fffe00
	dc.l	$00000000,$01fffc00
	dc.l	$00000000,$00fff800
	dc.l	$00000000,$007ff000
	dc.l	$00000000,$003fe000
	dc.l	$00000000,$001fc000
	dc.l	$00000000,$000f8000
	dc.l	$00000000,$00070000
	dc.l	$00000000,$00020000

; maschera
	dc.l	$00020000
	dc.l	$00020000
	dc.l	$00070000
	dc.l	$00070000
	dc.l	$000f8000
	dc.l	$000f8000
	dc.l	$001fc000
	dc.l	$001fc000
	dc.l	$003fe000
	dc.l	$003fe000
	dc.l	$007ff000
	dc.l	$007ff000
	dc.l	$00fff800
	dc.l	$00fff800
	dc.l	$01fffc00
	dc.l	$01fffc00
	dc.l	$03fffe00
	dc.l	$03fffe00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$07ffff00
	dc.l	$03fffe00
	dc.l	$03fffe00
	dc.l	$01fffc00
	dc.l	$01fffc00
	dc.l	$00fff800
	dc.l	$00fff800
	dc.l	$007ff000
	dc.l	$007ff000
	dc.l	$003fe000
	dc.l	$003fe000
	dc.l	$001fc000
	dc.l	$001fc000
	dc.l	$000f8000
	dc.l	$000f8000
	dc.l	$00070000
	dc.l	$00070000
	dc.l	$00020000
	dc.l	$00020000

Frame2:
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$001fffc0
	dc.l	$00300000,$003fffc0
	dc.l	$00780000,$007fffc0
	dc.l	$00fc0000,$00ffffc0
	dc.l	$01fe0000,$01ffffc0
	dc.l	$03ff0000,$03ffffc0
	dc.l	$07ff8000,$07ffffc0
	dc.l	$0fffc000,$0fffffc0
	dc.l	$07ffe000,$0fffffc0
	dc.l	$03fff000,$0fffffc0
	dc.l	$01fff800,$0fffffc0
	dc.l	$00fffc00,$0fffffc0
	dc.l	$007ffe00,$0fffffc0
	dc.l	$003fff00,$0fffffc0
	dc.l	$001fff80,$0fffff80
	dc.l	$000fff00,$0fffff00
	dc.l	$0007fe00,$0ffffe00
	dc.l	$0003fc00,$0ffffc00
	dc.l	$0001f800,$0ffff800
	dc.l	$0000f000,$0ffff000
	dc.l	$00006000,$0fffe000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$001fffc0
	dc.l	$001fffc0
	dc.l	$003fffc0
	dc.l	$003fffc0
	dc.l	$007fffc0
	dc.l	$007fffc0
	dc.l	$00ffffc0
	dc.l	$00ffffc0
	dc.l	$01ffffc0
	dc.l	$01ffffc0
	dc.l	$03ffffc0
	dc.l	$03ffffc0
	dc.l	$07ffffc0
	dc.l	$07ffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffff80
	dc.l	$0fffff80
	dc.l	$0fffff00
	dc.l	$0fffff00
	dc.l	$0ffffe00
	dc.l	$0ffffe00
	dc.l	$0ffffc00
	dc.l	$0ffffc00
	dc.l	$0ffff800
	dc.l	$0ffff800
	dc.l	$0ffff000
	dc.l	$0ffff000
	dc.l	$0fffe000
	dc.l	$0fffe000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

Frame3:

	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$003ff000,$007ff800
	dc.l	$003ff000,$00fffc00
	dc.l	$003ff000,$01fffe00
	dc.l	$003ff000,$03ffff00
	dc.l	$003ff000,$07ffff80
	dc.l	$003ff000,$0fffffc0
	dc.l	$003ff000,$1fffffe0
	dc.l	$003ff000,$3ffffff0
	dc.l	$003ff000,$7ffffff8
	dc.l	$003ff000,$fffffffc
	dc.l	$003ff000,$7ffffff8
	dc.l	$003ff000,$3ffffff0
	dc.l	$003ff000,$1fffffe0
	dc.l	$003ff000,$0fffffc0
	dc.l	$003ff000,$07ffff80
	dc.l	$003ff000,$03ffff00
	dc.l	$003ff000,$01fffe00
	dc.l	$003ff000,$00fffc00
	dc.l	$003ff000,$007ff800
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$007ff800
	dc.l	$007ff800
	dc.l	$00fffc00
	dc.l	$00fffc00
	dc.l	$01fffe00
	dc.l	$01fffe00
	dc.l	$03ffff00
	dc.l	$03ffff00
	dc.l	$07ffff80
	dc.l	$07ffff80
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$1fffffe0
	dc.l	$1fffffe0
	dc.l	$3ffffff0
	dc.l	$3ffffff0
	dc.l	$7ffffff8
	dc.l	$7ffffff8
	dc.l	$fffffffc
	dc.l	$fffffffc
	dc.l	$7ffffff8
	dc.l	$7ffffff8
	dc.l	$3ffffff0
	dc.l	$3ffffff0
	dc.l	$1fffffe0
	dc.l	$1fffffe0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$07ffff80
	dc.l	$07ffff80
	dc.l	$03ffff00
	dc.l	$03ffff00
	dc.l	$01fffe00
	dc.l	$01fffe00
	dc.l	$00fffc00
	dc.l	$00fffc00
	dc.l	$007ff800
	dc.l	$007ff800
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

Frame4:

	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00006000,$0fffe000
	dc.l	$0000f000,$0ffff000
	dc.l	$0001f800,$0ffff800
	dc.l	$0003fc00,$0ffffc00
	dc.l	$0007fe00,$0ffffe00
	dc.l	$000fff00,$0fffff00
	dc.l	$001fff80,$0fffff80
	dc.l	$003fff00,$0fffffc0
	dc.l	$007ffe00,$0fffffc0
	dc.l	$00fffc00,$0fffffc0
	dc.l	$01fff800,$0fffffc0
	dc.l	$03fff000,$0fffffc0
	dc.l	$07ffe000,$0fffffc0
	dc.l	$0fffc000,$0fffffc0
	dc.l	$07ff8000,$07ffffc0
	dc.l	$03ff0000,$03ffffc0
	dc.l	$01fe0000,$01ffffc0
	dc.l	$00fc0000,$00ffffc0
	dc.l	$00780000,$007fffc0
	dc.l	$00300000,$003fffc0
	dc.l	$00000000,$001fffc0
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000
	dc.l	$00000000,$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$0fffe000
	dc.l	$0fffe000
	dc.l	$0ffff000
	dc.l	$0ffff000
	dc.l	$0ffff800
	dc.l	$0ffff800
	dc.l	$0ffffc00
	dc.l	$0ffffc00
	dc.l	$0ffffe00
	dc.l	$0ffffe00
	dc.l	$0fffff00
	dc.l	$0fffff00
	dc.l	$0fffff80
	dc.l	$0fffff80
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$0fffffc0
	dc.l	$07ffffc0
	dc.l	$07ffffc0
	dc.l	$03ffffc0
	dc.l	$03ffffc0
	dc.l	$01ffffc0
	dc.l	$01ffffc0
	dc.l	$00ffffc0
	dc.l	$00ffffc0
	dc.l	$007fffc0
	dc.l	$007fffc0
	dc.l	$003fffc0
	dc.l	$003fffc0
	dc.l	$001fffc0
	dc.l	$001fffc0
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

;****************************************************************************

	SECTION	bitplane,BSS_C

; Dies ist der Puffer, in dem wir den Hintergrund von Zeit zu Zeit speichern.
; Er hat die gleichen Abmessungen wie eine Blittata: Höhe 30, Breite 3 Wörter
; 2 Bitebenen

Buffer:
	ds.w	30*3*2

BITPLANE:

; 2 planes 
	ds.b	40*256
	ds.b	40*256

;****************************************************************************

	end

In diesem Beispiel zeigen wir die rawblit Version der universellen Routine zum
Bobs zeichnen. Das Programm ist mit lesson10m1.s identisch mit dem Unterschied 
dass ein rawblit Bildschirm verwendet wird und als Ergebnis, wie Sie wissen, 
ändern sie sich die 'Formeln für die Berechnung von Werten, die in den Registern 
geschrieben werden müssen ein wenig.
In diesem Fall verwenden wir kein Hintergrundbild, welches die Routinen
speichern und wiederherstellen. Sie können sich ein Hintergrundbild (in Rawblit-
Version) zeichnen und es sich ohne es zu ändern in die Quelle legen!

