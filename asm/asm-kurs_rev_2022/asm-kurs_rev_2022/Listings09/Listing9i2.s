
; Listing9i2.s		BOB in Farbe
		; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Länge einer Bitplane !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	bsr.w	LeggiMouse			; Lesen der Koordinaten
	bsr.s	ControllaCoordinate	; verhindert, dass der Bob den Bildschirm verlässt
	bsr.s	DisegnaOggetto		; zeichne den Bob

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.w	CancellaOggetto		; lösche den Bob aus der alten Position						

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; Wenn nicht, gehe zurück zu mouse:
	rts

;****************************************************************************
; Diese Routine stellt sicher, dass die Koordinaten des Bobs immer 
; innerhalb des Bildschirms erhalten bleiben.
;****************************************************************************

ControllaCoordinate:
	tst.w	ogg_x				; X überprüfen
	bpl.s	NoMinX				; den linken Rand überprüfen
	clr.w	ogg_x				; Wenn X negativ ist, setze X = 0
	bra.s	controllaY			; Geh und überprüfe das Y

NoMinX:
	cmp.w	#319-32,ogg_x		; die rechte Kante überprüfen. In X_OGG
								; Die Kantenkoordinate wird links vom Bob
								; gespeichert. Wenn es 319-32 erreicht hat,
								; dann ist die rechte Kante erreicht
								; d.h. die Koordinate X=319.
	bls.s	controllaY			; Wenn alles in Ordnung ist, überprüfe das Y
	move.w	#319-32,ogg_x		; Andernfalls wird die Koordinate an der Kante fixiert.

controllaY:
	tst.w	ogg_y				; überprüfe die obere Kante
	bpl.s	NoMinY				; Wenn es positiv ist, überprüfe unten
	clr.w	ogg_y				; andernfalls setze Y = 0
	bra.s	EndControlla		; und geh raus

NoMinY:
	cmp.w	#255-11,ogg_y		; die untere Kante überprüfen. In Y_OGG
								; Die Kantenkoordinate wird oben vom Bob
								; gespeichert. Wenn es Y = 255-11 erreicht hat,
								; dann ist die untere Kante erreicht
								; die Koordinate Y = 255 
	bls.s	EndControlla		; Wenn alles in Ordnung ist, überprüfe das Y
	move.w	#255-11,ogg_y		; Andernfalls wird die Koordinate an der Kante fixiert.
EndControlla:
	rts

;****************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG 
; angegebenen Koordinaten. Der BOB und der Bildschirm sind im normalen Format 
; und daher werden die zu diesem Format gehörenden Formeln bei der Berechnung 
; der Werte, die in die Blitter-Register geschrieben werden benutzt. Auch die
; Technik, das letzte Wort des BOBs zu maskieren, ist in der Lektion zu sehen.
;****************************************************************************

;	     _
;	    /_\---.
;	  _//_\ __|
;	 C/ ( °\°/l)
;	 /   (___)|
;	(_ ° _____!
;	 `---'|,|_
;	    /¯' ` |
;	   //T· ·T|
;	   \\l ° |l
;	   (__) (_¯)
;	     |¯¬¯|¯ xCz
;	     l__Tl__
;	     (____)_)

DisegnaOggetto:
	lea	bitplane,a0				; Ziel in a0
	move.w	ogg_y(pc),d0		; Koordinate Y
	mulu.w	#40,d0				; Adresse berechnen: Jede Zeile besteht aus
								; 40 Bytes
	add.w	d0,a0				; zur Anfangsadresse hinzufügen

	move.w	ogg_x(pc),d0		; Koordinate X
	move.w	d0,d1				; Kopie
	and.w	#$000f,d0			; wir wählen die ersten 4 Bits aus, weil sie
								; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0				; die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d0				; des Wortes...
	or.w	#$09f0,d0			; ... rechts in das BLTCON0-Register einzugeben
	lsr.w	#3,d1				; (entspricht einer Division durch 8)
								; Runden auf ein Vielfaches von 8 für den Zeiger
								; auf den Bildschirm, also auch auf ungerade Adressen
								; (also zu Bytes)
								; zB: eine 16 als Koordinate wird zu Byte 2
	and.w	#$fffe,d1			; Ich schließe Bit 0 aus
	add.w	d1,a0				; addieren zur Adresse der Bitebene, 
								; um die richtige Zieladresse zu finden

	lea	figura,a1				; Quellzeiger
	moveq	#3-1,d7				; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffff0000,$44(a5)	; BLTAFWM = $ffff es passiert alles
								; BLTALWM = $0000 setzt das letzte Wort zurück


	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	#$0000,$42(a5)		; BLTCON1 (keine Spezialmodi)
	move.l	#$fffe0022,$64(a5)	; BLTAMOD=$fffe=-2 komm zurück
								; an den Anfang der Zeile.
								; BLTDMOD = 40-6 = 34 = $22 wie üblich
	move.l	a1,$50(a5)			; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirm)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (starte Blitter !)

	lea	4*11(a1),a1				; zeigt auf die nächste Quellebene
								; jedes Bild ist 2 Wörter breit und 
								; 11 Zeilen hoch

	lea	40*256(a0),a0			; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop

	rts

;*****************************************************************************
; Diese Routine löscht das BOB unter Verwendung des Blitters. Löschung durch
; das Rechteck das den 6-Zeilen-hohen und 3 Wörter breiten Bob umfasst.
;****************************************************************************

CancellaOggetto:
	lea	bitplane,a0				; Ziel in a0
	move.w	ogg_y(pc),d0		; Koordinate Y
	mulu.w	#40,d0				; Adresse berechnen: Jede Zeile besteht aus
								; 40 Bytes
	add.w	d0,a0				; zur Anfangsadresse hinzufügen

	move.w	ogg_x(pc),d1		; Koordinate X
	lsr.w	#3,d1				; (entspricht einer Division durch 8)
								; Runden auf ein Vielfaches von 8 für den Zeiger
								; auf den Bildschirm, also auch auf ungerade Adressen
								; (also zu Bytes)
								; zB: eine 16 als Koordinate wird zu Byte 2
	and.w	#$fffe,d1			; Ich schließe Bit 0 aus
	add.w	d1,a0				; addieren zur Adresse der Bitebene, 
								; um die richtige Zieladresse zu finden

	moveq	#3-1,d7				; wiederhole es für jede Ebene
PlaneLoop2:
	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$01000000,$40(a5)	; BLTCON0 und BLTCON1: Löschen
	move.w	#$0022,$66(a5)		; BLTDMOD=40-6=34=$22
	move.l	a0,$54(a5)			; BLTDPT
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (startet Blitter !)
								; Lösche das vom BOB umschließende Rechteck
			
	lea	40*256(a0),a0			; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop2

	rts				

*****************************************************************************
; Diese Routine liest die Maus und aktualisiert die Werte in den
; Variablen OGG_X und OGG_Y 
;****************************************************************************

LeggiMouse:
	move.b	$dff00a,d1			; JOY0DAT - vertikale Mausposition
	move.b	d1,d0				; Kopie in d0
	sub.b	mouse_y(PC),d0		; subtrahieren der alten Mausposition
	beq.s	no_vert				; Wenn die Differenz = 0 ist, steht die Maus still
	ext.w	d0					; wandelt das Byte in ein Wort um
	add.w	d0,ogg_y			; Objektposition ändern

no_vert:
  	move.b	d1,mouse_y			; speichern der Mausposition für das nächste Mal

	move.b	$dff00b,d1			; JOY0DAT - horizontale Mausposition
	move.b	d1,d0				; Kopie in d0
	sub.b	mouse_x(PC),d0		; subtrahieren der alten Mausposition
	beq.s	no_oriz				; Wenn die Differenz = 0 ist, steht die Maus still
	ext.w	d0					; wandelt das Byte in ein Wort um
	add.w	d0,ogg_x			; Objektposition ändern
no_oriz
  	move.b	d1,mouse_x			; speichern der Mausposition für das nächste Mal
	RTS

OGG_Y:		dc.w	0			; hier wird das Y des Objektes gespeichert
OGG_X:		dc.w	0			; hier wird das X des Objektes gespeichert
MOUSE_Y:	dc.b	0			; hier wird das Y der Maus gespeichert
MOUSE_X:	dc.b	0			; hier wird das X der Maus gespeichert

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; WERT MODULO 0
	dc.w	$10a,0				; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$0180,$000			; color0
	dc.w	$0182,$475			; color1
	dc.w	$0184,$fff			; color2
	dc.w	$0186,$ccc			; color3
	dc.w	$0188,$999			; color4
	dc.w	$018a,$232			; color5
	dc.w	$018c,$777			; color6
	dc.w	$018e,$444			; color7

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Dies sind die Daten, aus denen die Figur des Bobs besteht.
; Der Bob ist im normalen Format, 32 Pixel breit (2 Wörter)
; 11 Zeilen hoch und wird von 3 Bitplanes gebildet

Figura:	
	dc.l	$007fc000			; plane 1
	dc.l	$03fff800
	dc.l	$07fffc00
	dc.l	$0ffffe00
	dc.l	$1fe07f00
	dc.l	$1fe07f00
	dc.l	$1fe07f00
	dc.l	$0ffffe00
	dc.l	$07fffc00
	dc.l	$03fff800
	dc.l	$007fc000

	dc.l	$00000000			; plane 2
	dc.l	$007fc000
	dc.l	$03fff800
	dc.l	$07fffc00
	dc.l	$0fe07e00
	dc.l	$0fe07e00
	dc.l	$0fe07e00
	dc.l	$07fffc00
	dc.l	$03fff800
	dc.l	$007fc000
	dc.l	$00000000

	dc.l	$007fc000			; plane 3
	dc.l	$03803800
	dc.l	$04000400
	dc.l	$081f8200
	dc.l	$10204100
	dc.l	$10204100
	dc.l	$10204100
	dc.l	$081f8200
	dc.l	$04000400
	dc.l	$03803800
	dc.l	$007fc000

;****************************************************************************

BITPLANE:
	incbin	"/Sources/amiga.raw"						
								; Hier laden wir die Figur ein			
								; mit KEFCON konvertiert.
	end

;****************************************************************************


In diesem Beispiel haben wir einen Farb-BOB, der sich auf dem Bildschirm durch 
die Maus bewegt. Auf dem Bildschirm gibt es ein Hintergrundbild. 
Für das BOB benutzen wir die Technik, das letzte Wort zu maskieren. Wir haben
es bereits im Beispiel Listing9i1.s verwendet. Das Programm besteht aus
4 Routinen, die zyklisch aufgerufen werden. Die Routine "ReadMouse" ist 
identisch zu der, die wir in Lektion7 verwendet haben. Es liest die Koordinaten
des BOBs von der Maus und speichert sie in den X_OGG- und Y_OGG-Variablen. Die 
Routine "ControlloCoordinate" wird verwendet, um zu verhindern, das der BOB aus
dem Bildschirm kommt. Die "DrawObject"-Routine ist die Routine, die den BOB auf
den Bildschirm zeichnet und ähnelt den bereits vorher gesehenen. 
Zu beachten ist, dass diese Routine beim Zeichnen den Hintergrund überschreibt.
Ist das BOB einmal gezeichnet wartet das Programm auf den nächsten vertikal
blank. Die Routine nach dem vertikal blank wird als "DeleteObject"-Routine
bezeichnet. Sie löscht das BOB von der aktuellen Position. Diese Routine führt
eine Löschung mit dem Blitter aus, dem Rechteck, das den BOB enthält. Anstelle
des BOBs erscheint nun der leere Raum. Anschließend beginnt die Hauptschleife
erneut mit dem Lesen der neuen Koordinaten, Kontrolle und dem Zeichnen des BOBs
an der neuen Position.
Der große "Fehler" dieses Programms ist, dass der BOB die Teile vom Hintergrund
löscht, wenn er über ihn geht.

