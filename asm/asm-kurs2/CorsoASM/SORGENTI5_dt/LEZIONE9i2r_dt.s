
; Lezione9i2r.s	Farbe BOB (interleaved)
			; Linke Taste zum Verlassen.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist Etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	;
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#3-1,D1			; Anzahl Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
				; HIER WIRD DER ERSTE UNTERSCHIED 
				; ZU DEN NORMALEN BILDERN GEMACHT !!!!!!
	ADD.L	#40,d0		; + LÄNGE EINER ZEILE !!!!!
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
	bsr.w	LeggiMouse			; Koordinaten lesen
	bsr.s	ControllaCoordinate	; verhindert, dass der Bob den Bildschirm verlässt
	bsr.s	DisegnaOggetto		; zeichne den Bob

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile = $130 oder 304
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile = $130 oder 304
	BNE.S	Waity1

	bsr.w	CancellaOggetto		; lösche den Bob aus der alten Position							

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; Wenn nicht, gehe zurück zur mouse:
	rts

;****************************************************************************
; Diese Routine stellt sicher, dass die Bob-Koordinaten 
; innerhalb des Bildschirms immer erhalten bleiben.
;****************************************************************************

ControllaCoordinate:
	tst.w	ogg_x		; Steuerung X
	bpl.s	NoMinX		; Überprüfen Sie die linke Kante
	clr.w	ogg_x		; Wenn X negativ ist, wird X = 0 gesetzt
	bra.s	controllaY	; geht das Y überprüfen

NoMinX:
	cmp.w	#319-32,ogg_x	; Überprüfen Sie die rechte Kante. In X_OGG
						; Die Kantenkoordinate wird links vom Bob
						; gespeichert. Wenn es 319-32 erreicht hat,
						; dann ist die rechte Kante erreicht
						; d.h. die Koordinate X=319.
	bls.s	controllaY	; Wenn alles in Ordnung ist, überprüfen Sie das Y
	move.w	#319-32,ogg_x	; Andernfalls wird die Koordinate an der Kante fixiert.

controllaY:
	tst.w	ogg_y		; überprüfe die obere Kante
	bpl.s	NoMinY		; Wenn es positiv ist, überprüfen Sie unten
	clr.w	ogg_y		; andernfalls setze Y = 0
	bra.s	EndControlla	; und geh raus

NoMinY:
	cmp.w	#255-11,ogg_y	; überprüfe die untere Kante. In Y_OGG
						; Die Kantenkoordinate wird oben vom Bob
						; gespeichert. Wenn es Y = 255-11 erreicht hat,
						; dann ist die untere Kante erreicht
						; die Koordinate Y = 255 
	bls.s	EndControlla	; Wenn alles in Ordnung ist, überprüfen Sie das Y
	move.w	#255-11,ogg_y	; Andernfalls wird die Koordinate an der Kante fixiert.
EndControlla:
	rts

;****************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG 
; angegebenen Koordinaten. Der BOB und der Bildschirm sind im  interleaved Format 
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
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#3*40,d0		; Adresse berechnen: Jede Zeile besteht aus
							; 3 Ebenen mit je 40 Bytes
	add.w	d0,a0			; zur Startadresse hinzufügen

	move.w	ogg_x(pc),d0	; Koordinate  X
	move.w	d0,d1			; Kopie
	and.w	#$000f,d0	; wähle die ersten 4 Bits aus, weil sie
						; in den Kanal A Shifter eingefügt werden
	lsl.w	#8,d0		; Die 4 Bits werden in das hohe Halbbyte verschoben
	lsl.w	#4,d0		; des Wortes...
	or.w	#$09f0,d0	; ... nur um in das Register BLTCON0 zu kommen
	lsr.w	#3,d1		; (entspricht einer Division durch 8)
						; Runden auf ein Vielfaches von 8 für den Zeiger
						; auf den Bildschirm, also auf ungerade Adressen
						; (also auch für Bytes, also)
						; zB: eine 16 als Koordinate wird zum
						; Bytes 2
	and.w	#$fffe,d1	; Ich schließe Bit 0 aus
	add.w	d1,a0		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)	; dmaconr - Warten Sie, bis der Blitter fertig ist
	bne.s	wblit2

	move.l	#$ffff0000,$44(a5)	; BLTAFWM = $ffff es passiert alles
					; BLTALWM = $0000 Setzen Sie das letzte Wort zurück


	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	#$0000,$42(a5)		; BLTCON1 (keine Spezialmodi)
	move.l	#$fffe0022,$64(a5)	; BLTAMOD=$fffe=-2 komm zurück
								; an den Anfang der Zeile.
								; BLTDMOD=40-6=34=$22 wie immer
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirmzeilen)
	move.w	#(64*11*3)+3,$58(a5)	; BLTSIZE (starte Blitter !)
	rts

;*****************************************************************************
; Diese Routine löscht das BOB unter Verwendung des Blitters. Löschung durch
; das Rechteck das den 6-Zeilen-hohen und 3 Wörter breit Bob umfasst.
;****************************************************************************

CancellaOggetto:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#3*40,d0		; Adresse berechnen: Jede Zeile besteht aus
							; 3 Ebenen mit je 40 Bytes
	add.w	d0,a0			; zur Startadresse hinzufügen

	move.w	ogg_x(pc),d1	; Koordinate X
	lsr.w	#3,d1			; (entspricht einer Division durch 8)
							; Rundet den Zeiger auf ein Vielfaches von 8
							; auf den Bildschirm oder zu den ungeraden Adressen
							; (also auch zu Bytes)
							; x zB: eine 16 als Koordinate wird zum
							; Byte 2
	and.w	#$fffe,d1		; Ich schließe Bit 0 aus
	add.w	d1,a0			; Summe zur Adresse der Bitebene, finden
							; der richtigen Zieladresse

	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)		 ; Warten Sie, bis der Blitter fertig ist
	bne.s	wblit3

	move.l	#$01000000,$40(a5)	; BLTCON0 und BLTCON1: Löschung
	move.w	#$0022,$66(a5)		; BLTDMOD=40-6=34=$22
	move.l	a0,$54(a5)			; BLTDPT
	move.w	#(64*11*3)+3,$58(a5)	; BLTSIZE (starte Blitter !)
					; Löschen Sie das vom BOB umschließende Rechteck
	rts				

*****************************************************************************
; Diese Routine liest die Maus und aktualisiert die Werte in den
; OGG_X- und OGG_Y-Variablen
;****************************************************************************

LeggiMouse:
	move.b	$dff00a,d1	; JOY0DAT vertikale Mausposition
	move.b	d1,d0		; Kopie in d0
	sub.b	mouse_y(PC),d0	; subtrahieren alte Mausposition
	beq.s	no_vert		; Ist die Differenz = 0, bleibt die Maus stehen
	ext.w	d0			; wandelt das Byte in ein Wort um
						; (siehe am Ende des Listings)
	add.w	d0,ogg_y	; Objektposition ändern

no_vert:
  	move.b	d1,mouse_y	; Mausposition für das nächste Mal speichern

	move.b	$dff00b,d1	; horizontale Position der Maus
	move.b	d1,d0		; Kopie in d0
	sub.b	mouse_x(PC),d0	; Alte Position abziehen
	beq.s	no_oriz		; Ist die Differenz = 0, bleibt die Maus stehen
	ext.w	d0			; wandelt das Byte in ein Wort um
						; (siehe am Ende des Listings)
	add.w	d0,ogg_x	; Pos. ändern Objekt
no_oriz
  	move.b	d1,mouse_x	; Mausposition für das nächste Mal speichern
	RTS

OGG_Y:		dc.w	0	; hier wird das Y des Objektes gespeichert
OGG_X:		dc.w	0	; hier wird das X des Objektes gespeichert
MOUSE_Y:	dc.b	0	; hier ist die Maus Y gespeichert
MOUSE_X:	dc.b	0	; hier ist die Maus X gespeichert

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2

				; HIER WIRD DER ZWEITE UNTERSCHIED
				; ZU DEN NORMALEN BILDERN GEMACHT !!!!!
	dc.w	$108,80		; WERT MODULO = 2*20*(3-1)= 80
	dc.w	$10a,80		; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200	; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000

	dc.w	$0180,$000	; color0
	dc.w	$0182,$475	; color1
	dc.w	$0184,$fff	; color2
	dc.w	$0186,$ccc	; color3
	dc.w	$0188,$999	; color4
	dc.w	$018a,$232	; color5
	dc.w	$018c,$777	; color6
	dc.w	$018e,$444	; color7

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

; Dies sind die Daten, aus denen sich die Bob-Figur zusammensetzt.
; Der Bob ist verschachtelt (interleaved), 32 Pixel breit (2 Wörter)
; 11 Zeilen hoch und wird von 3 Bitflächen gebildet

Figura:	dc.l	$007fc000,$00000000,$007fc000
	dc.l	$03fff800,$007fc000,$03803800
	dc.l	$07fffc00,$03fff800,$04000400
	dc.l	$0ffffe00,$07fffc00,$081f8200
	dc.l	$1fe07f00,$0fe07e00,$10204100
	dc.l	$1fe07f00,$0fe07e00,$10204100
	dc.l	$1fe07f00,$0fe07e00,$10204100
	dc.l	$0ffffe00,$07fffc00,$081f8200
	dc.l	$07fffc00,$03fff800,$04000400
	dc.l	$03fff800,$007fc000,$03803800
	dc.l	$007fc000,$00000000,$007fc000

;****************************************************************************

BITPLANE:
	incbin	"assembler2:sorgenti6/amiga.rawblit"
	
				; hier laden wir die Figur in
				; RAWBLIT-Format (oder Interleaved-Format)
				; konvertiert mit KEFCON.
	end

;****************************************************************************

Dieses Beispiel ist die Rawblit-Version von lecture9i2.s.
Vergleichen Sie die Unterschiede in den Formeln zur Berechnung der zu
schreibenden Werte in den Blitterregistern.

