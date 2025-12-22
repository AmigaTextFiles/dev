
; Lezione10d1.s	BOB mit Hintergrundsanierung.
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
	MOVEQ	#3-1,D1			; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0		; + Länge einer Bitplane !!!!!
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

	bsr.w	LeggiMouse			; lies Koordinaten
	bsr.s	ControllaCoordinate	; verhindert, dass der Bob den Bildschirm verlässt
	bsr.w	SalvaSfondo			; Speichere den Hintergrund
	bsr.s	DisegnaOggetto		; zeichne den Bob

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.w	RipristinaSfondo	; stelle den Hintergrund wieder her


	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; Wenn nicht, gehe zurück zu mouse:

	rts


;****************************************************************************
; Diese Routine stellt sicher, dass die Koordinaten des Bobs immer 
; innerhalb des Bildschirms erhalten bleiben.
;****************************************************************************

ControllaCoordinate:
	tst.w	ogg_x		; Steuerung X
	bpl.s	NoMinX		; Überprüfen Sie den linken Rand
	clr.w	ogg_x		; Wenn X negativ ist, setze X = 0
	bra.s	controllaY	; Geh und überprüfe das Y

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
	clr.w	ogg_y		; Andernfalls setze Y = 0
	bra.s	EndControlla	; und geh raus

NoMinY:
	cmp.w	#255-11,ogg_y	; überprüfe die untere Kante. In Y_OGG
						; wird die Kantenkoordinate Hoch vom Bob 
						; gespeichert. Wenn es Y = 255-11 erreicht hat,
						; dann ist die untere Kante 
						; die Y = 255 Koordinate erreicht
	bls.s	EndControlla	; Wenn alles in Ordnung ist, überprüfen Sie das Y
	move.w	#255-11,ogg_y	; Andernfalls wird die Koordinate an der Kante fixiert.
EndControlla:
	rts

;***************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG 
; angegebenen Koordinaten. Der BOB und der Bildschirm sind im normalen Format 
; und daher werden die zu diesem Format gehörenden Formeln bei der Berechnung 
; der Werte, die in die Blitter-Register geschrieben werden benutzt. Auch die
; Technik, das letzte Wort des BOBs zu maskieren, ist in der Lektion zu sehen.
;****************************************************************************

;	.         .     ___
;	 .°·    °/\_/\_\\|/))
;	 _______/. @¤  \/ /
;	(|O|___ /  ¯    \/
;	 |_| /  \_______/~
;	 :  /     `¡:°  \
;	 . _\   ___·. _  \
;	  * ¯\ /  /.  °  /
;	 ð/aL \\_/______/
;	        ¯¯  `----'

DisegnaOggetto:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0		; Adresse berechnen: Jede Zeile besteht aus
						; 40 bytes
	add.w	d0,a0		; zum Anfang der Adresse hinzufügen

	move.w	ogg_x(pc),d0	; Koordinate X
	move.w	d0,d1		; Kopie
	and.w	#$000f,d0	; Sie wählen die ersten 4 Bits, weil sie 
						; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0		; Die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d0		; des Wortes...
	move.w	d0,d2

	or.w	#$0FCA,d0	; ... nur um das BLTCON0-Register zu betreten
	lsr.w	#3,d1		; (entspricht einer Division durch 8)
				; Runden auf ein Vielfaches von 8 für den Zeiger
				; auf den Bildschirm, also auf ungerade Adressen
				; (also auch für Bytes, also)
				; x zB: eine 16 als Koordinate wird zum
				; Bytes 2
	and.w	#$fffe,d1	; Ich schließe Bit 0 aus
	add.w	d1,a0		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

	lea	figura,a1		; Zeiger Quelle
	moveq	#3-1,d7		; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)		 ; warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffff0000,$44(a5)	; BLTAFWM = $ffff Es passiert alles
					; BLTALWM = $0000 setzt das letzte Wort zurück


	move.w	d0,$40(a5)		; BLTCON0 (A+D)
	move.w	d2,$42(a5)		; BLTCON1 (keine Spezialmodi)
	move.l	#$0022fffe,$60(a5)
	move.l	#$fffe0022,$64(a5)	; BLTAMOD=$fffe=-2 komm 
								; zum Anfang der Zeile zurück.
								; BLTDMOD=40-6=34=$22 wie üblich
	move.l	#Maschera,$50(a5)	; BLTAPT  (an der Maske fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirm)
	move.l	a0,$48(a5)			; BLTCPT  (Bildschirm)
	move.l	a1,$4c(a5)			; BLTBPT  (Figur Bob)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Blitter starten!)

	lea	4*11(a1),a1		; zeigt auf die nächste Quellenebene
						; jedes Bitplane ist 2 Wörter breit und 
						; 11 Zeilen hoch

	lea	40*256(a0),a0		; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop

	rts

;****************************************************************************
; Diese Routine kopiert das Hintergrundrechteck, das mit dem BOB 
; überschrieben wird in einen Puffer
;****************************************************************************

SalvaSfondo:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0			; Adresse berechnen: Jede Zeile besteht aus
							; 40 Bytes
	add.w	d0,a0		; zum Anfang der Adresse hinzufügen

	move.w	ogg_x(pc),d1	;  Koordinate X
	lsr.w	#3,d1		; (entspricht einer Division durch 8)
				; Runden auf ein Vielfaches von 8 für den Zeiger
				; auf den Bildschirm, also auf ungerade Adressen
				; (also auch für Bytes, also)
				; x zB: eine 16 als Koordinate wird zum
				; Bytes 2
	and.w	#$fffe,d1	; Ich schließe Bit 0 aus
	add.w	d1,a0		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

	lea	Buffer,a1		; Adresse Ziel
	moveq	#3-1,d7		; wiederhole es für jede Ebene
PlaneLoop2:
	btst	#6,2(a5) ; dmaconr
WBlit3:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
								; BLTALWM = $ffff Es passiert alles

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.l	#$00220000,$64(a5)	; BLTAMOD=40-4=36=$24
								; BLTDMOD=0 im Puffer
	move.l	a0,$50(a5)			; BLTAPT - Adresse Quelle
	move.l	a1,$54(a5)			; BLTDPT - Puffer
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Blitter starten !)

	lea	40*256(a0),a0	; zeigt auf die nächste Quellenebene
	lea	6*11(a1),a1		; zeigt auf die nächste Zielebene
					; Jede Blittata ist 3 Wörter breit und 
					; 11 Zeilen hoch
	dbra	d7,PlaneLoop2

	rts

;****************************************************************************
; Diese Routine kopiert den Inhalt des Puffers in das Bildschirmrechteck
; was es vor der BOB-Zeichnung enthielt. Auf diese Weise kommt es auch, das
; das BOB vom alten Standort gelöscht wird.
;****************************************************************************

RipristinaSfondo:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0		; Adresse berechnen: Jede Zeile besteht aus
						; 40 Bytes
	add.w	d0,a0		; zum Anfang der Adresse hinzufügen

	move.w	ogg_x(pc),d1	; Koordinate  X
	lsr.w	#3,d1		; (entspricht einer Division durch 8)
				; Runden auf ein Vielfaches von 8 für den Zeiger
				; auf den Bildschirm, also auf ungerade Adressen
				; (also auch für Bytes, also)
				; x zB: eine 16 als Koordinate wird zum
				; Bytes 2
	and.w	#$fffe,d1	; Ich schließe Bit 0 aus
	add.w	d1,a0		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

	lea	Buffer,a1		; Adresse Quelle
	moveq	#3-1,d7		; wiederhole es für jede Ebene
PlaneLoop3:
	btst	#6,2(a5)	; dmaconr
WBlit4:
	btst	#6,2(a5)	; warte auf das Ende des Blitters
	bne.s	wblit4

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
								; BLTALWM = $ffff Es passiert alles

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.l	#$00000022,$64(a5)	; BLTAMOD=0 (Puffer)
							; BLTDMOD=40-6=34=$22
	move.l	a1,$50(a5)		; BLTAPT (Puffer)
	move.l	a0,$54(a5)		; BLTDPT (Bildschirm)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Blitter starten !)

	lea	40*256(a0),a0	; zeigt auf die nächste Zielebene
	lea	6*11(a1),a1		; zeigt auf die nächste Quellenebene
					; Jede Blittata ist 3 Wörter breit und 
					; 11 Zeilen hoch
	dbra	d7,PlaneLoop3
	rts

;****************************************************************************
; Diese Routine liest die Maus und aktualisiert die Werte in den
; OGG_X und OGG_Y Variablen
;****************************************************************************

LeggiMouse:
	move.b	$dff00a,d1	; JOY0DAT Maus vertikale Position
	move.b	d1,d0		; Kopie in d0
	sub.b	mouse_y(PC),d0	; Subtrahieren Sie die alte Mausposition
	beq.s	no_vert		; Wenn die Differenz = 0 ist, ist die Maus still
	ext.w	d0			; wandelt das Byte in ein Wort um
						; (siehe am Ende des Listings)
	add.w	d0,ogg_y	; Objektposition ändern

no_vert:
  	move.b	d1,mouse_y	; Speichern Sie die Mausposition für das nächste Mal

	move.b	$dff00b,d1	; horizontale Mausposition
	move.b	d1,d0		; Kopie in d0
	sub.b	mouse_x(PC),d0	; Subtrahieren Sie die alte Position
	beq.s	no_oriz		; Wenn die Differenz = 0 ist, ist die Maus still
	ext.w	d0			; wandelt das Byte in ein Wort um
						; (siehe am Ende des Listings)
	add.w	d0,ogg_x	; Wechselpos. Objekt
no_oriz
  	move.b	d1,mouse_x	; Speichern Sie die Mausposition für das nächste Mal
	RTS

OGG_Y:		dc.w	0	; das Y des Objekts wird hier gespeichert
OGG_X:		dc.w	0	; das X des Objekts wird hier gespeichert
MOUSE_Y:	dc.b	0	; Die Maus Y ist hier gespeichert
MOUSE_X:	dc.b	0	; Die Maus X ist hier gespeichert

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Wert MODULO = 0
	dc.w	$10a,0		; BEIDE MODULO MIT GLEICHEN WERT.

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

; Dies sind die Daten, aus denen die Figur des Bobs besteht.
; Der Bob ist im normalen Format, 32 Pixel breit (2 Wörter)
; 11 Zeilen hoch und wird von 3 Biteplanes gebildet

Figura:	dc.l	$007fc000	; plane 1
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

	dc.l	$00000000	; plane 2
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

	dc.l	$007fc000	; plane 3
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

Maschera:
	dc.l	$007fc000
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



;****************************************************************************

BITPLANE:
	incbin	"amiga.raw"		; Hier laden wir die Figur

;****************************************************************************

	SECTION	BUFFER,BSS_C

; Dies ist der Puffer, in dem wir den Hintergrund von Zeit zu Zeit speichern.
; Er hat die gleichen Abmessungen wie eine Blittata: Höhe 11, Breite 3 Wörter
; 3 Bit-Ebenen

Buffer:
	ds.w	11*3*3

	end

;****************************************************************************

In diesem Beispiel lösen wir das Hintergrundproblem der BOBs. Die Struktur des 
Programms ist dieselbe wie in lesson9i3.s. Die Unterschiede sind alle in der 
Routine "DisegnaOggetto". Die übernimmt die Zeichnungsprozedur wie in der 
Lektion erklärt. Wie Sie für die Blittata sehen können setzen wir LF = $CA 
cookie-cut) und wir benutzen alle Kanäle des Blitters (A für die Maske, 
B für den BOB und C für den Hintergrund).