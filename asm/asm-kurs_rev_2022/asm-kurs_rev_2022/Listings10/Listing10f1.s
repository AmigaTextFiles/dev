
; Listing10f1.s		Viele BOBs mit "falschem" Hintergrund. Es gibt einen 
				; "Fehler" zu beheben! Linke Taste zum Beenden.

	SECTION	bau,code

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper, bitplane, blitter DMA


; konstante Kanten
Lowest_Floor	equ	200			; Unterkante
Right_Side	equ	287				; Rand rechts	


START:
	MOVE.L	#BITPLANE1,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl der Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

;	Lass uns die vierte Bitebene (als Hintergrund) setzen

	LEA	BPLPOINTERS,A0			; Zeiger COP
	move.l	#SfondoFinto,d0		; Adresse Hintergrund
	move.w	d0,30(a0)			; der Hintergrund ist die Bitebene 4
	swap	d0	
	move.w	d0,26(a0)			; schreibe hohes Wort

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.w	CancellaSchermo		; Bildschirm löschen

	lea	Oggetto_1,a4			; Adresse erstes Objekt
	moveq	#6-1,d6				; 6 Objekte

Ogg_loop:
	bsr.s	MuoviOggetto		; bewege Bob
	bsr.w	DisegnaOggetto		; zeichne Bob

	addq.l	#8,a4				; Zeige auf das nächste Objekt

	dbra	d6,Ogg_loop

;	btst	#6,2(a5)
;WBlit_coppermonitor:
;	btst	#6,2(a5)
;	bne.s	WBlit_coppermonitor

	move.w	#$aaa,$180(a5)		; copper monitor: Farbe grau

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; wenn nicht, gehe zurück zur mouse:

	rts


;****************************************************************************
; Diese Routine bewegt einen Bob, indem überprüft wird, dass die Kanten nicht 
; überschritten werden
; A4 - zeigt auf die Datenstruktur, die die Position und die Geschwindigkeit 
; vom Bob enthält
;****************************************************************************

MuoviOggetto:
	move.w	(a4),d0				; Position X
	move.w	2(a4),d1			; Position Y
	move.w	4(a4),d2			; dx (Geschwindigkeit X)
	move.w	6(a4),d3			; dy (Geschwindigkeit Y)
	add.w	d2,d0				; x = x + dx
	add.w	d3,d1				; y = y + dy

	btst	#15,d1				; Kontrolle hohe Kante (Y=0)
	beq.s	UO_NoBounce4		; wenn das Y negativ ist...
	neg.w	d1					; .. springt er zurück
	neg.w	d3					; umgekehrte Bewegungsrichtung
UO_NoBounce4:

	cmp.w	#Lowest_Floor,d1	; Kontrolle Unterkante
	blt.s	UO_NoBounce1

	neg.w	d3					; ändere das Geschwindigkeitszeichen dy
								; Umkehr der Bewegungsrichtung
	move.w	#Lowest_Floor,d1	; Beginne von der Kante
UO_NoBounce1:

	cmp.w	#Right_Side,d0		; Überprüfe die rechte Kante
	blt.s	UO_NoBounce2		; wenn es die rechte Kante überschreitet..
	sub.w	#Right_Side,d0		; Abstand vom Rand
	neg.w	d0					; Die Entfernung umkehren
	add.w	#Right_Side,d0		; Board-Koordinate hinzufügen
	neg.w	d2					; umgekehrte Bewegungsrichtung
UO_NoBounce2:
	btst	#15,d0				; Überprüfe den linken Rand (X = 0)
	beq.s	UO_NoBounce3		; wenn das X negativ ist...
	neg.w	d0					; .. springt er zurück
	neg.w	d2					; umgekehrte Bewegungsrichtung
UO_NoBounce3:
	move.w	d0,(a4)				; Aktualisiere Position und Geschwindigkeit
	move.w	d1,2(a4)
	move.w	d2,4(a4)
	move.w	d3,6(a4)

	rts


;****************************************************************************
; Diese Routine zeichnet ein BOB.
; A4 - zeigt auf die Datenstruktur, die die Position und die Geschwindigkeit
; vom Bob enthält
;****************************************************************************

;	        |\__/,|   (`\
;	      _.|o o  |_   ) )
;	  ---(((---(((---------

DisegnaOggetto:
	lea	BITPLANE1,a0			; Adresse bitplane
	move.w	2(a4),d0			; Koordinate Y
	mulu.w	#40,d0				; Adresse berechnen: Jede Zeile besteht aus
								; 40 Bytes

	add.l	d0,a0				; offset hinzufügen Y

	move.w	(a4),d0				; Koordinate X
	move.w	d0,d1				; Kopie
	and.w	#$000f,d0			; wir wählen die ersten 4 Bits, weil sie 
								; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0				; Die 4 Bits werden zum High-Nibble 
	lsl.w	#4,d0				; des Wortes bewegt...
	or.w	#$0FCA,d0			; ..rechts, um in das BLTCON0-Register zu kommen
	lsr.w	#3,d1				; (entspricht einer Division durch 8)
								; Runden auf ein Vielfaches von 8 für den Zeiger
								; auf den Bildschirm, also auch auf ungerade Adressen
								; (also zu Bytes)
								; zB: eine 16 als Koordinate wird zu Byte 2
	and.l	#$0000fffe,d1		; Ich schließe Bit 0 aus
	add.w	d1,a0				; addieren zur Adresse der Bitebene, 
								; um die richtige Zieladresse zu finden

	lea	Ball_Bob,a1				; Zeiger auf die Figur
	lea	Ball_Mask,a2			; Zeiger auf die Maske
	moveq	#3-1,d7				; bitplane Zähler

DrawLoop:
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)
	bne.s	WBlit2

	move.w	d0,$40(a5)			; BLTCON0 - schreibe Verschiebungswert
	move.w	d0,d1				; Kopie von BLTCON0,
	and.w	#$f000,d1			; Verschiebungswert auswählen..
	move.w	d1,$42(a5)			; und schreibe es in BLTCON1 (für Kanal B)

	move.l	#$ffff0000,$44(a5)	; BLTAFWM und BLTLWM

	move.w	#$FFFE,$64(a5)		; BLTAMOD
	move.w	#$FFFE,$62(a5)		; BLTBMOD

	move.w	#40-6,$66(a5)		; BLTDMOD
	move.w	#40-6,$60(a5)		; BLTCMOD

	move.l	a2,$50(a5)			; BLTAPT - Zeiger Maske
	move.l	a1,$4c(a5)			; BLTBPT - Zeiger Figur
	move.l	a0,$48(a5)			; BLTCPT - Zeiger Hintergrund
	move.l	a0,$54(a5)			; BLTDPT - Zeiger bitplanes

	move.w	#(31*64)+3,$58(a5)	; BLTSIZE - Höhe 31 Zeilen
				 				; Breite 3 word (48 pixel).

	add.l	#4*31,a1			; Adresse nächste Bitebene Bild
	add.l	#40*256,a0			; Adresse nächste Bitebene Ziel
	dbra	d7,DrawLoop
	
	rts


;****************************************************************************
; Diese Routine löscht den Bildschirm mit dem Blitter.
;****************************************************************************

CancellaSchermo:
	moveq	#3-1,d7				; 3 bitplanes
	lea	BITPLANE1,a0			; Adresse pitplane

canc_loop:
	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)			 ; warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$01000000,$40(a5)	; BLTCON0 und BLTCON1: Löschung
	move	#$0000,$66(a5)		; BLTDMOD=0
	move.l	a0,$54(a5)			; BLTDPT
	move.w	#(64*256)+20,$58(a5)	; BLTSIZE (Blitter starten !)
								; lösche den gesamten Bildschirm

	add.l	#40*256,a0			; Adresse nächste Bitebene Ziel
	dbra	d7,canc_loop
	rts


; Datenobjekte
; Dies sind die Datenstrukturen, die die Geschwindigkeit und Position der Bobs enthalten.
; Jede Datenstruktur besteht aus 4 Wörtern, die der Reihe nach enthalten:
; X-POSITION, Y-POSITION, X-GESCHWINDIGKEIT, Y-GESCHWINDIGKEIT

Oggetto_1:
	dc.w	32,53				;  x / y   - Position
	dc.w	-3,1				; dx / dy  - Geschwindigkeit

Oggetto_2:
	dc.w	132,62				;  x / y   - Position
	dc.w	2,-1				; dx / dy  - Geschwindigkeit

Oggetto_3:
	dc.w	232,42				;  x / y   - Position  
	dc.w	3,1					; dx / dy  - Geschwindigkeit

Oggetto_4:
	dc.w	2,20				;  x / y   - Position
	dc.w	-5,1				; dx / dy  - Geschwindigkeit

Oggetto_5:
	dc.w	60,80				;  x / y   - Position 
	dc.w	6,1					; dx / dy  - Geschwindigkeit

Oggetto_6:
	dc.w	50,75				;  x / y   - Position
	dc.w	-5,1				; dx / dy  - Geschwindigkeit

;****************************************************************************

	SECTION	MY_COPPER,CODE_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2

	dc.w	$108,0				; MODULO
	dc.w	$10a,0

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000
	dc.w	$ec,$0000,$ee,$0000

	dc.w	$180,$000			; color0 - Hintergrund
	dc.w	$190,$000

 	dc.w	$182,$0A0			; Farbe von 1 bis 7
 	dc.w	$184,$040
 	dc.w	$186,$050
 	dc.w	$188,$061
 	dc.w	$18A,$081
 	dc.w	$18C,$020
 	dc.w	$18E,$6F8

	dc.w	$192,$0A0			; Farbe von 9 bis 15
	dc.w	$194,$040			; es sind die gleichen Werte wie
	dc.w	$196,$050			; in den Registern 1 bis 7
	dc.w	$198,$061
	dc.w	$19a,$081
	dc.w	$19c,$020
	dc.w	$19e,$6F8

	dc.w	$190,$345			; Farbe 8 - pixel zu 1 des Hintergrunds

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

	dc.w	$8007,$fffe			; warte auf Zeile $80
	dc.w	$100,$4200			; bplcon0 - 4 bitplanes lowres
								; Bitebene 4 aktivieren (Hintergrund)

; In diesem Feld wird der Teil des Hintergrunds angezeigt

	dc.w	$e007,$fffe			; warte auf Zeile $e0
	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Figur Bob
Ball_Bob:
 DC.W $0000,$0000,$0000,$0000,$0000,$0000,$003F,$8000	; plane 1
 DC.W $00C1,$E000,$017C,$E000,$02FE,$3000,$05FF,$5400
 DC.W $07FF,$1800,$0BFE,$AC00,$03FF,$1A00,$0BFE,$AC00
 DC.W $11FF,$1A00,$197D,$2C00,$0EAA,$1A00,$1454,$DC00
 DC.W $0E81,$3800,$0154,$F400,$02EB,$F000,$015F,$D000
 DC.W $00B5,$A000,$002A,$8000,$0000,$0000,$0000,$0000
 DC.W $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
 DC.W $0000,$0000,$0000,$0000,$0000,$0000

 DC.W $000F,$E000,$007F,$FC00,$01FF,$FF00,$03FF,$FF80	; plane 2
 DC.W $07C1,$FFC0,$0F00,$FFE0,$1E00,$3FF0,$3C40,$5FF8
 DC.W $3CE0,$1FF8,$7840,$2FFC,$7800,$1FFC,$7800,$2FFC
 DC.W $F800,$1FFE,$F800,$2FFE,$FE00,$1FFE,$FC00,$DFFE
 DC.W $FE81,$3FFE,$FF54,$FFFE,$FFEB,$FFFE,$7FFF,$FFFC
 DC.W $7FFF,$FFFC,$7FFF,$FFFC,$3FFF,$FFF8,$3FFF,$FFF8
 DC.W $1FFF,$FFF0,$0FFF,$FFE0,$07FF,$FFC0,$03FF,$FF80
 DC.W $01FF,$FF00,$007F,$FC00,$000F,$E000

 DC.W $000F,$E000,$007F,$FC00,$01E0,$7F00,$0380,$0F80	; plane 3
 DC.W $073E,$0AC0,$0CFF,$0560,$198F,$C2F0,$3347,$A0B8
 DC.W $32EB,$E158,$6647,$D0AC,$660B,$E05C,$4757,$D0AC
 DC.W $C7AF,$E05E,$A7FF,$D02E,$C1FF,$E05E,$A3FF,$202E
 DC.W $D17E,$C05E,$E0AB,$002E,$D014,$005E,$6800,$00AC
 DC.W $7000,$02DC,$7400,$057C,$2800,$0AF8,$3680,$55F8
 DC.W $1D54,$AAF0,$0EAB,$55E0,$0754,$ABC0,$03EB,$FF80
 DC.W $01FE,$FF00,$007F,$FC00,$000F,$E000

; Maske Bob
Ball_MASK:
 DC.W $000F,$E000,$007F,$FC00,$01FF,$FF00,$03FF,$FF80
 DC.W $07FF,$FFC0,$0FFF,$FFE0,$1FFF,$FFF0,$3FFF,$FFF8
 DC.W $3FFF,$FFF8,$7FFF,$FFFC,$7FFF,$FFFC,$7FFF,$FFFC
 DC.W $FFFF,$FFFE,$FFFF,$FFFE,$FFFF,$FFFE,$FFFF,$FFFE
 DC.W $FFFF,$FFFE,$FFFF,$FFFE,$FFFF,$FFFE,$7FFF,$FFFC
 DC.W $7FFF,$FFFC,$7FFF,$FFFC,$3FFF,$FFF8,$3FFF,$FFF8
 DC.W $1FFF,$FFF0,$0FFF,$FFE0,$07FF,$FFC0,$03FF,$FF80
 DC.W $01FF,$FF00,$007F,$FC00,$000F,$E000


;****************************************************************************

; Hintergrund 320 * 100 1 Bitplane, raw normal.

SfondoFinto:
	incbin	"/Sources/sfondo320x100.raw"

;****************************************************************************

	SECTION	bitplane,BSS_C
BITPLANE1:
	ds.b	40*256
BITPLANE2:
	ds.b	40*256
BITPLANE3:
	ds.b	40*256

	end

;****************************************************************************

In diesem Beispiel sehen wir 6 Bobs, die sich vor einem Hintergrund bewegen.
Wir verwenden den Trick mit dem gefälschten Hintergrund. Da wir aber die
6 Bobs alle in den gleichen Ebenen bewegen, müssen wir sie noch mit der Technik
der Bitplane-Maske und des "Cookie-Cuts" blitten, sonst würden sie sich nicht
richtig überlappen. 
Die Technik des gefälschten Hintergrunds erlaubt uns jedoch das Speichern und
Wiederherstellen des Hintergrunds zu vermeiden, da der Hintergrund allein durch
Nullen gebildet wird. Um die an den alten Positionen gezeichneten Bobs zu
löschen, reicht es daher aus, die für die Bobs vorgesehenen Ebenen zu löschen,
bevor man beginnt sie neu zu zeichnen.
Zum Bewegen und Zeichnen von Bobs verwenden wir Routinen mit Parametern, die in
der Lage sind, soviele Bobs zu behandeln, wie wir wollen. Anstatt die Parameter
durch CPU-Register zu übergeben verwenden wir "Datenstrukturen", d.h. wir
sammeln die Geschwindigkeits- und Positionsdaten jedes Bobs in
zusammenhängenden Adressen, immer in der gleichen Reihenfolge. Die Routinen
werden über das Register A4, die Adresse der Datenstruktur "durchlaufen". Auf
diese Weise wissen die Routinen, dass sich die Bob-Daten an der von A4 
angegebenen Adresse und in den nachfolgenden Adressen befinden. Wie Sie sehen
können, zeichnet dieses Programm die Bobs nicht richtig. ine Erläuterung des
Problems und der Lösung finden Sie in der Lektion.