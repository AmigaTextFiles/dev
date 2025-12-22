
; Listing9i3.s		BOB mit Hintergrundwiederherstellung.
; Linke Taste zum Verlassen.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
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
	bsr.w	LeggiMouse			; Koordinaten lesen
	bsr.s	ControllaCoordinate	; verhindert, dass der Bob den Bildschirm verlässt
	bsr.w	SalvaSfondo			; speichert den Hintergrund
	bsr.s	DisegnaOggetto		; zeichnet den Bob

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.w	RipristinaSfondo	; stellt den Hintergrund wieder her

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

;***************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG 
; angegebenen Koordinaten. Der BOB und der Bildschirm sind im normalen Format  
; und daher werden die zu diesem Format gehörenden Formeln bei der Berechnung 
; der Werte, die in die Blitter-Register geschrieben werden benutzt. Auch die
; Technik, das letzte Wort des BOBs zu maskieren, ist in der Lektion zu sehen.
;****************************************************************************

;	     _, ,. ,_
;	     ////;\\\
;	    /'__  __`\
;	  _/  ______  \_
;	 (_   `°'`°'   _)
;	  /  _ (__) _  \ xCz
;	 / _ l______| _ \
;	/  (  `----'  )  \
;	\_____      _____/
;	    `--------'

DisegnaOggetto:
	lea	bitplane,a0				; Ziel in a0
	move.w	ogg_y(pc),d0		; Koordinate Y
	mulu.w	#40,d0				; Adresse berechnen: Jede Zeile besteht aus 40 Bytes
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
								; BLTDMOD = 40-6 = 34 = $22 wie immer
	move.l	a1,$50(a5)			; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirm)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Start Blitter !)

	lea	4*11(a1),a1				; zeigt auf die nächste Quellenebene
								; jede Bitplane ist 2 Wörter breit und 
								; 11 Zeilen hoch

	lea	40*256(a0),a0			; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop

	rts

;****************************************************************************
; Diese Routine kopiert das Hintergrundrechteck, das von dem 
; BOB überschrieben wird in einem Puffer
;****************************************************************************

SalvaSfondo:
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

	lea	Buffer,a1				; Zieladresse
	moveq	#3-1,d7				; wiederhole es für jede Ebene
PlaneLoop2:
	btst	#6,2(a5)			; dmaconr
WBlit3:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff lass alles passieren
								; BLTALWM = $ffff lass alles passieren


	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.l	#$00220000,$64(a5)	; BLTAMOD=40-4=36=$24
								; BLTDMOD=0 im Puffer
	move.l	a0,$50(a5)			; BLTAPT - Adresse Quelle
	move.l	a1,$54(a5)			; BLTDPT - Puffer
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (starte Blitter !)

	lea	40*256(a0),a0			; zeigt auf die nächste Quellebene
	lea	6*11(a1),a1				; zeigt auf die nächste Zielebene
								; Jeder Blitt ist 3 Wörter breit und 
								; 11 Zeilen hoch
	dbra	d7,PlaneLoop2

	rts

;****************************************************************************
; Diese Routine kopiert den Inhalt des Puffers in das Bildschirmrechteck
; welches es vor dem Zeichnen des BOB enthielt. Auf diese Weise kommt auch
; das gelöschte BOB von der alten Position.
;****************************************************************************

RipristinaSfondo:
	lea	bitplane,a0				; Ziel in a0
	move.w	ogg_y(pc),d0		; Koordinate Y
	mulu.w	#40,d0				; Adresse berechnen: Jede Zeile besteht aus 40 Bytes
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

	lea	Buffer,a1				; Zieladresse
	moveq	#3-1,d7				; wiederhole es für jede Ebene
PlaneLoop3:
	btst	#6,2(a5)			; dmaconr
WBlit4:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit4

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff lass alles passieren
								; BLTALWM = $ffff lass alles passieren


	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.l	#$00000022,$64(a5)	; BLTAMOD=0 (buffer)
								; BLTDMOD=40-6=34=$22
	move.l	a1,$50(a5)			; BLTAPT (buffer)
	move.l	a0,$54(a5)			; BLTDPT (Bildschirm)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (starte Blitter !)

	lea	40*256(a0),a0			; zeigt auf die nächste Zielebene
	lea	6*11(a1),a1				; zeigt auf die nächste Quellebene
								; Jeder Blitt ist 3 Wörter breit und 
								; 11 Zeilen hoch
	dbra	d7,PlaneLoop3
	rts

;****************************************************************************
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
	dc.w	$108,0				; WERT MODULO = 0
	dc.w	$10a,0				; BEIDE MODULO MIT ZUM GLEICHEN WERT.

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

; Dies sind die Daten, aus denen sich die Bob-Figur zusammensetzt.
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
					; hier laden wir die figur
					; konvertiert mit KEFCON.

;****************************************************************************

	SECTION	BUFFER,BSS_C

; Dies ist der Puffer, in dem wir von Zeit zu Zeit den Hintergrund speichern.
; Er hat die gleichen Abmessungen wie ein Blitt: Höhe 11 Zeilen, Breite 3 Worte
; 3 Bitplanes

Buffer:
	ds.w	11*3*3

	end

;****************************************************************************

In diesem Beispiel gehen wir das Hintergrundproblem von BOBs an.
Wir werden nicht die endgültige Lösung anbieten, die Verständnis der Blitter-
eigenschaften erfordert, die im Kurs noch nicht erklärt wurden. Aber wir werden 
einen erster Schritt machen. Die Idee ist die folgende: Bevor Sie das BOB auf
dem Bildschirm zeichnen, kopieren wir den Teil des Hintergrunds, der vom BOB
überschrieben wird in einen Puffer. Dann zeichnen wir ganz normal das BOB. Nach
dem vertikal blank müssen wir das BOB löschen, (wodurch der Bildschirm leer
bliebe). Aus diesem Grund kopieren wir den Hintergrund der zuvor an dieser
Stelle war hierhin zurück. Auf diese Weise löschen wir die alte Kopie des BOBs
und wir setzen den Hintergrund zurück, der dort vor seinem Durchgang war. Das
Problem bei dieser Technik ist, wie Sie sehen, dass Sie den Hintergrund in den
Bereichen im Rechteck, die das BOB einschließen nicht sehen. Das liegt an der
Tatsache, dass die mit der Color0 gefärbten Teile des BOBs nicht transparent
sind, wie das bei Sprites der Fall ist, sondern sie repräsentieren die 
Hintergrundfarbe. Wir werden später die Lösung für dieses Problem sehen.
