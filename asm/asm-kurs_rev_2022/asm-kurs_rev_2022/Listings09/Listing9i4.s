
; Listing9i4.s		BOB mit "falschem" Hintergrund
; Linke Taste zum Verlassen.

	SECTION	bau,code

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


; konstante Kanten.
Lowest_Floor	equ	200			; untere Kante
Right_Side	equ	287				; rechter Rand	


START:
	MOVE.L	#BITPLANE1,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Bitplane-Länge (256 Zeilen hoch hier)
	addq.w	#8,a1
	dbra	d1,POINTBP

;	Wir zielen auf die vierte Bitebene (den Hintergrund)

	LEA	BPLPOINTERS,A0			; Bitplanepointer
	move.l	#SfondoFinto,d0		; Adresse Hintergrund
	move.w	d0,30(a0)			; Der Hintergrund ist Bitplane 4
	swap	d0	
	move.w	d0,26(a0)			; in das hohe Wort schreiben

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	bsr.s	MuoviOggetto		; bewegt den Bob
	bsr.w	DisegnaOggetto		; zeichne den Bob


	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.w	CancellaOggetto		; entferne den Bob von der alten Position
							
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; Wenn nicht, gehe zurück zu mouse:

	rts


;****************************************************************************
; Diese Routine bewegt den Bob, indem überprüft wird, dass er die Kanten 
; nicht überschreitet
;****************************************************************************

MuoviOggetto:
	move.w	ogg_x(pc),d0		; Position X
	move.w	ogg_y(pc),d1		; Position Y
	move.w	vel_x(pc),d2		; dx (Geschwindigkeit X)
	move.w	vel_y(pc),d3		; dy (Geschwindigkeit Y)
	add.w	d2,d0				; x = x + dx
	add.w	d3,d1				; y = y + dy
	addq.w	#1,d3				; fügt die Schwerkraft hinzu
								; (erhöht die Geschwindigkeit)
	cmp.w	#Lowest_Floor,d1	; Überprüfe die Unterkante
	blt.s	UO_NoBounce1

	subq.w	#1,d3				; Entferne die Geschwindigkeitserhöhung
	neg.w	d3					; Ändere das Geschwindigkeitszeichen dy
								; Bewegungsrichtung umkehren
	move.w	#Lowest_Floor,d1	; vom Rand weggehen
UO_NoBounce1:

	cmp.w	#Right_Side,d0		; Überprüfe die rechte Kante
	blt.s	UO_NoBounce2		; wenn es die rechte Kante überschreitet..
	sub.w	#Right_Side,d0		; Abstand vom Rand
	neg.w	d0					; kehre den Abstand um
	add.w	#Right_Side,d0		; Randkoordinate hinzufügen
	neg.w	d2					; Bewegungsrichtung umkehren
UO_NoBounce2:
	btst	#15,d0				; linke Kante prüfen (X = 0)
	beq.s	UO_NoBounce3		; wenn das X negativ ist...
	neg.w	d0					; .. macht den Abpraller
	neg.w	d2					; Bewegungsrichtung umkehren
UO_NoBounce3:
	move.w	d0,ogg_x			; Position und Geschwindigkeit aktualisieren
	move.w	d1,ogg_y
	move.w	d2,vel_x
	move.w	d3,vel_y

	rts


;****************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG 
; angegebenen Koordinaten. Der BOB und der Bildschirm sind im normalen Format 
; und daher werden die zu diesem Format gehörenden Formeln bei der Berechnung 
; der Werte, die in die Blitter-Register geschrieben werden benutzt. Auch die
; Technik, das letzte Wort des BOBs zu maskieren, ist in der Lektion zu sehen.
;****************************************************************************

;	     ,-^---^-.
;	   _/  -- --  \_
;	   l_ /¯¯T¯¯\ _|
;	  (¯T \_°|°_/ T¯)
;	   ¯T _ ¯u¯ _ T¯
;	   _| l_____| |_
;	  |¬|   ¯¬¯   |¬|
;	xCz l_________| l

DisegnaOggetto:
	lea	BITPLANE1,a0			; Ziel in a0
	move.w	ogg_y(pc),d0		; Koordinate Y
	mulu.w	#40,d0				; Adresse berechnen: Jede Zeile besteht aus 40 Bytes
	add.l	d0,a0				; zur Anfangsadresse hinzufügen

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
	
	move.l	a0,IndirizzoOgg		; speichert die Adresse des Ziels
								; für die Lösch-Routine						

	lea	Ball_Bob,a1				; Zeiger auf die Figur
	moveq	#3-1,d7				; bitplane counter

DrawLoop:
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	WBlit2

	move.w	d0,$40(a5)			; BLTCON0 - Shift-Wert schreiben
	move.w	#$0000,$42(a5)		; BLTCON1 - aufsteigender Modus
	move.l	#$ffff0000,$44(a5)	; BLTAFWM und BLTLWM
	move.w	#$FFFE,$64(a5)		; BLTAMOD
	move.w	#40-6,$66(a5)		; BLTDMOD
	move.l	a1,$50(a5)			; BLTAPT - Zeiger Figur
	move.l	a0,$54(a5)			; BLTDPT - Zeiger bitplanes

	move.w	#(31*64)+3,$58(a5)	; BLTSIZE - Höhe 31 Zeilen
								; Breite 3 Wörter (48 Pixel).

	add.l	#4*31,a1			; Bild - Adresse nächste Bitebene
	add.l	#40*256,a0			; Ziel - Adresse nächste Bitebene

	dbra	d7,DrawLoop
	rts


;****************************************************************************
; Diese Routine löscht das BOB durch den Blitter. Die Löschung
; wird auf dem Rechteck gemacht, das den Bob einschließt
;****************************************************************************

CancellaOggetto:
	moveq	#3-1,d7				; 3 bitplanes
	move.l	IndirizzoOgg(PC),a0	; Zieladresse erneut lesen

canc_loop:
	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$01000000,$40(a5)	; BLTCON0 und BLTCON1: Löschung
	move	#$0022,$66(a5)		; BLTDMOD=40-6=34=$22
	move.l	a0,$54(a5)			; BLTDPT
	move.w	#(64*31)+3,$58(a5)	; BLTSIZE (Starte Blitter !)
								; Lösche das umschließende Rechteck des Bobs
							
	add.l	#40*256,a0			; nächste Adresse Zielebene
	dbra	d7,canc_loop
	rts


; Objektdaten

IndirizzoOgg:
	dc.l	0					; Diese Variable enthält die Adresse des
								; Ziels

ogg_x:	dc.w	32				; Position X
ogg_y:	dc.w	50				; Position Y
vel_x:	dc.w	-3				; Geschwindigkeit X
vel_y:	dc.w	1				; Geschwindigkeit Y

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

 	dc.w	$182,$0A0			; color von 1 bis 7
 	dc.w	$184,$040
 	dc.w	$186,$050
 	dc.w	$188,$061
 	dc.w	$18A,$081
 	dc.w	$18C,$020
 	dc.w	$18E,$6F8

	dc.w	$192,$0A0			; color von 9 bis 15
	dc.w	$194,$040			; es sind die gleichen Werte
	dc.w	$196,$050			; wie in den Registern 1 bis 7
	dc.w	$198,$061
	dc.w	$19a,$081
	dc.w	$19c,$020
	dc.w	$19e,$6F8

	dc.w	$190,$345			; color 8 - Pixel 1 des Hintergrunds

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

	dc.w	$8007,$fffe			; Warte Zeile $80
	dc.w	$100,$4200			; bplcon0 - 4 bitplanes lowres
								; aktiviere die bitplane 4 (Hintergrund)

; In diesem Bereich wird der Teil des Hintergrunds angezeigt

	dc.w	$e007,$fffe			; Warte Zeile  $e0
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

In diesem Beispiel sehen wir einen Bob, der sich auf einem Hintergrund bewegt. 
Den Effekt haben wir aber mit einem Trick erhalten, der die Leistung stark
einschränkt. Der Trick ist Folgender: Wir verwenden 4 Bitebenen, die ersten 3
zum Zeichnen des Bobs und die vierte für den Hintergrund. Der Hintergrund und
der Bob haben daher getrennte Ebenen. Damit der Bob über dem Hintergrund
angezeigt wird, wird die Bitebene erstellt. Der Hintergrund wirkt sich nicht
auf die Farben des Bobs aus. Betrachten Sie zum Beispiel das Pixel des Bobs,
das gebildet wird, indem Ebene 1 = 0, Ebene 2 = 1, Ebene 3 = 1 genommen wird.
Diese Bits der sich bewegenden Pixel werden mit der Ebene 4 überlagert.
Entspricht es einem auf 0 gesetzten Bit, bildet sich für die 4 Ebenen die
Ebene 1 = 0, Ebene 2 = 1, Ebene 3 = 1, Ebene 4 = 0, die Farbe 6.
Wenn stattdessen ein auf 1 gesetztes Bit gefunden wird, bildet sich für die 
Ebene 1 = 0, Ebene 2 = 1, Ebene 3 = 1, Ebene 4 = 1, die Farbe 14. So ändern 
sich die Farben des Bobs in Abhängigkeit der Hintergrundbereichskreuzung. Wir
möchten stattdessen, dass der Bob immer auf dem gleichen Hintergrund erscheint.
Wir können diesen Effekt auf sehr einfache Weise simulieren, indem wir die
Farben in den Registern gleich machen, die sich nur in den Hintergrundbits
unterscheiden.
Zurück zum Beispiel, wenn sie den gleichen RGB-Wert in das COLOR06-Register und
in COLOR14 eingeben. Damit ist der Wert des Bits der Ebene 4 egal und unser
Pixel erscheint immer in der gleichen Farbe. Dasselbe machen wir für alle
anderen Register (dh wir platzieren COLOR01 = COLOR09, COLOR02 = COLOR10,
COLOR03 = COLOR11 usw.) So können wir das Problem lösen.
Der "transparente" Teil des Bobs ist derjenige, der die 3 Ebenen bei 0 hat.
Dies zeigt Farbe 0 oder Farbe 8 an, abhängig vom Wert des Bits in der Ebene 4.
Indem Sie diese beiden Farben unterschiedlich halten, können Sie den
Hintergrund anzeigen: Die Bits bei 0 des Hintergrunds werden in Farbe 0
angezeigt, während die bei 1 in der Farbe 8 angezeigt werden.
Um besser zu verstehen, was passiert, versuchen Sie ein wenig die COLOR01-07
Register auf andere Werte als COLOR09-15 zu setzen: Sie werden den Trick sofort
feststellen. Diese Technik hat den Nachteil, dass einige Farben "verschwendet"
werden. In der Tat sind wir gezwungen, gleiche RGB-Werte in einige Register zu
schreiben und verringern damit die Anzahl der anzeigbaren Farben. In diesem
Beispiel verwenden wir 4 Bitplanes, aber wir können nur 8 Farben für den Bob
und 2 für den Hintergrund verwenden. Wir verschwenden daher 6 Farben. Wenn wir
3 Bitplanes für den Bob und 2 für den Hintergrund verwendet haben, könnten wir
8 + 4 = 12 Farben anzeigen, gegenüber den 32, die normalerweise durch
5 Bitplanes möglich sind. Wie Sie sehen, ist diese Technik daher nicht ideal.
Aber keine Sorge, früher oder später können wir einen richtigen Bob machen!
Beachten Sie in der Zwischenzeit ein paar Dinge in diesem Listing:
1) Wir verwenden den (bereits gesehen) Trick von BLTLWM bei 0, um die
   Wortspalte rechts vom Bob zu speichern;
2) Wir verwenden einen NICHT interleaved Bildschirm, um die
   Hintergrundplane von der Bob Plane zu trennen.
3) In den vorherigen Beispielen berechnen wir die Zieladresse des Bobs, sowohl
   in der Zeichenroutine wie auch in der Löschroutine. Eigentlich zwischen
der Zeichnung und dem anschließenden Löschung ändert der Bob seine Position
nicht. (Erst nach dem Löschen tut er es.) So ist die Berechnung immer gleich
und wird nur einmal gemacht. In diesem Beispiel machen wir genau das:
Die Berechnung erfolgt in der DisjectObject-Routine und wird in der Variablen 
AddressOgg gespeichert. Die Löschroutine liest einfach das Ergebnis aus der
Variablen erneut und verwendet sie.