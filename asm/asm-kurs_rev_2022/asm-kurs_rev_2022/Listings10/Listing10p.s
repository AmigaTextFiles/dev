
; Listing10p.s		Füllen eines Polygons mit Linien
			; mit einer Neigung < von 45 Grad
			; rechte Maustaste zum Starten, links zum Beenden

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	bsr.w	InitLine			; initialisiert line-mode

	move.w	#$ffff,d0			; durchgehende Linie
	bsr.w	SetPattern			; definiert pattern

	move.w	#34,d0				; x1 
	move.w	#25,d1				; y1
	move.w	#130,d2				; x2
	move.w	#80,d3				; y2
	lea	bitplane,a0
	bsr.w	Drawline

	move.w	#220,d0				; x1
	move.w	#25,d1				; y1
	move.w	#140,d2				; x2
	move.w	#80,d3				; y2
	lea	bitplane,a0
	bsr.s	Drawline

mouse1:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1

	move.w	#0,d0				; inklusiv
	move.w	#0,d1				; CARRYIN = 0
	lea	bitplane+180*40+30,a0
	bsr.s	Fill

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2

	rts

;****************************************************************************
; Diese Routine kopiert ein Bildschirmrechteck von einer festen Position
; an eine Adresse, die als Parameter angegeben ist. Das Bildschirmrechteck
; das kopiert wird umschließt die 2 Zeilen vollständig.
; Das Füllen wird auch während der Kopie durchgeführt. Die Art der Füllung
; wird über Parameter angegeben.
; Die Parameter sind:
; A0 - Zieladresse
; D0 - wenn es 0 ist, macht es inklusive Füllung, sonst füllt es exklusiv
; D1 - wenn es 0 ist, dann wird FILL_CARRYIN = 0, andernfalls FILL_CARRYIN = 1
;****************************************************************************

;	  ("`-''-/").___..--''"`-._
;	   `6_ 6  )   `-.  (     ).`-.__.`)
;	   (_Y_.)'  ._   )  `._ `. ``-..-'
;	 _..`--'_..-_/  /--'_.' ,'
;	(il),-''  (li),'  ((!.-'

Fill:
	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.w	#$09f0,$40(a5)		; BLTCON0 normale Kopie

	tst.w	d0					; test D0, um die Art der Füllung zu bestimmen
	bne.s	fill_esclusivo
	move.w	#$000a,d2			; Wert von BLTCON1: setze die Bits für den
								; inklusiven Füll- und Abstiegsmodus
	bra.s	test_fill_carry

fill_esclusivo:
	move.w	#$0012,d2			; Wert von BLTCON1: setze die Bits für den
								; exklusiven Füll- und Abstiegsmodus

test_fill_carry:
	tst.w	d1					; test D1, um zu sehen, ob das
								; FILL_CARRYIN-Bit gesetzt werden soll

	beq.s	fatto_bltcon1		; wenn D1 = 0 überspringe ..
	bset	#2,d2				; ansonsten setze Bit 2 von D2
fatto_bltcon1:
	move.w	d2,$42(a5)			; BLTCON1

	move.w	#14,$64(a5)			; BLTAMOD Breite 13 words (40-26=14)
	move.w	#14,$66(a5)			; BLTDMOD (40-26=14)

	move.l	#bitplane+80*40+28,$50(a5)
								; BLTAPT (am Quellrechteck fixiert)
								; das Quellrechteck umschließt
								; die 2 Zeilen ganz.
								; Wir zeigen auf das letzte Wort des Rechtecks
								; wegen des absteigenden Weges

	move.l	a0,$54(a5)			; BLTDPT (Ziel)
	move.w	#(64*56)+13,$58(a5)	; BLTSIZE (Blitter starten!)
								; Breite 13 words
								; Höhe 56 Zeilen (1 plane)
	rts

;******************************************************************************
; Diese Routine zeichnet die Linie. Sie benötigt als Parameter die Koordinaten
; der Punkte P1 und P2 und die Adresse der Bitebene, auf der gezeichnet werden soll.
; D0 - X1 (X-Koordinate von P1)
; D1 - Y1 (Y-Koordinate von P1)
; D2 - X2 (X-Koordinate von P2)
; D3 - Y2 (Y-Koordinate von P2)
; A0 - Bitplane Adresse
;******************************************************************************

Drawline:

* wähle Oktante

	sub.w	d0,d2				; D2=X2-X1
	bmi.s	DRAW4				; Wenn negativ, überspringen Sie andernfalls D2=DiffX
	sub.w	d1,d3				; D3=Y2-Y1
	bmi.s	DRAW2				; Wenn negativ, überspringen Sie andernfalls D3=DiffY
	cmp.w	d3,d2				; vergleicht DiffX und DiffY
	bmi.s	DRAW1				; wenn D2 < D3 überspringt ..
								; .. sonst D3 = DY und D2 = DX
	moveq	#$10,d5				; Oktantencode
	bra.s	DRAWL
DRAW1:
	exg.l	d2,d3				; es schaltet zwischen D2 und D3 um, so dass D3 = DY und D2 = DX
	moveq	#0,d5				; Oktantencode
	bra.s	DRAWL
DRAW2:
	neg.w	d3					; macht D3 positiv
	cmp.w	d3,d2				; vergleiche DiffX und DiffY
	bmi.s	DRAW3				; wenn D2 < D3 überspringt ..
								; .. sonst D3 = DY und D2 = DX
	moveq	#$18,d5				; Oktantencode
	bra.s	DRAWL
DRAW3:
	exg.l	d2,d3				; es schaltet zwischen D2 und D3 um, so dass D3 = DY und D2 = DX
	moveq	#$04,d5				; Oktantencode
	bra.s	DRAWL
DRAW4:
	neg.w	d2					; macht D2 positiv
	sub.w	d1,d3				; D3=Y2-Y1
	bmi.s	DRAW6				; wenn Negativ überspringt, sonst D3 = DiffY
	cmp.w	d3,d2				; vergleiche DiffX und DiffY
	bmi.s	DRAW5				; wenn D2 < D3 überspringt ..
								; .. sonst D3 = DY und D2 = DX
	moveq	#$14,d5				; Oktantencode
	bra.s	DRAWL
DRAW5:
	exg.l	d2,d3				; es schaltet zwischen D2 und D3 um, so dass D3 = DY und D2 = DX
	moveq	#$08,d5				; Oktantencode
	bra.s	DRAWL
DRAW6:
	neg.w	d3					; macht D3 positiv
	cmp.w	d3,d2				; vergleiche DiffX und DiffY
	bmi.s	DRAW7				; wenn D2 < D3 überspringt ..
								; .. sonst D3 = DY und D2 = DX
	moveq	#$1c,d5				; Oktantencode
	bra.s	DRAWL
DRAW7:
	exg.l	d2,d3				; es schaltet zwischen D2 und D3 um, so dass D3 = DY und D2 = DX
	moveq	#$0c,d5				; Oktantencode

; Wenn die Ausführung diesen Punkt erreicht, haben wir:
; D2 = DX
; D3 = DY
; D5 = Oktantencode

DRAWL:
	mulu.w	#40,d1				; Offset Y
	add.l	d1,a0				; Fügt der Adresse den Y-Offset hinzu

	move.w	d0,d1				; Kopiere die X-Koordinate
	and.w	#$000F,d0			; Wähle die 4 niedrigsten Bits des X ..
	ror.w	#4,d0				;.. und bewegt sie in den Bits 12 bis 15
	or.w	#$0B4A,d0			; mit einem OR bekomme ich den Wert zu schreiben
								; in BLTCON0. Mit diesem LF-Wert ($4A)
								; Zeichnen Sie Linien in EOR mit dem Hintergrund.

	lsr.w	#4,d1				; lösche die 4 unteren Bits des X
	add.w	d1,d1				; Ruft den X-Offset in Bytes ab
	add.w	d1,a0				; Fügt der Adresse den X-Offset hinzu

	move.w	d2,d1				; Kopie DX in D1
	addq.w	#1,d1				; D1=DX+1
	lsl.w	#$06,d1				; berechnet in D1 den Wert, der in BLTSIZE eingegeben werden soll
	addq.w	#$0002,d1			; addiert die Breite, gleich 2 Wörtern

	lsl.w	#$02,d3				; D3=4*DY
	add.w	d2,d2				; D2=2*DX

	btst.b	#6,2(a5)
WaitLine:
	btst	#6,2(a5)			; warte auf festen Blitter
	bne	WaitLine

	move.w	d3,$62(a5)			; BLTBMOD=4*DY
	sub.w	d2,d3				; D3=4*DY-2*DX
	move.w	d3,$52(a5)			; BLTAPTL=4*DY-2*DX

								; Bereite den Wert vor, um in BLTCON1 zu schreiben
	or.w	#$0001,d5			; Bit 0 0 (aktiver Zeilenmodus)
	tst.w	d3
	bpl.s	OK1					; wenn 4 * DY-2 * DX> 0 überspringen ..
	or.w	#$0040,d5			; Ansonsten setze das SIGN-Bit
OK1:
	move.w	d0,$40(a5)			; BLTCON0
	move.w	d5,$42(a5)			; BLTCON1
	sub.w	d2,d3				; D3=4*DY-4*DX
	move.w	d3,$64(a5)			; BLTAMOD=4*DY-4*DX
	move.l	a0,$48(a5)			; BLTCPT - Adresse Bildschirm
	move.l	a0,$54(a5)			; BLTDPT - Adresse Bildschirm
	move.w	d1,$58(a5)			; BLTSIZE
	rts
	

;******************************************************************************
; Diese Routine legt die Blitter-Register fest, die sich 
; zwischen einer Zeile und einer anderen nicht ändern
;******************************************************************************

InitLine
	btst	#6,2(a5) 			; dmaconr
WBlit_Init:
	btst	#6,2(a5) 			; dmaconr - warte auf das Ende des Blitters
	bne.s	Wblit_Init

	moveq.l	#-1,d5
	move.l	d5,$44(a5)			; BLTAFWM/BLTALWM = $FFFF
	move.w	#$8000,$74(a5)		; BLTADAT = $8000
	move.w	#40,$60(a5)			; BLTCMOD = 40
	move.w	#40,$66(a5)			; BLTDMOD = 40
	rts

;******************************************************************************
; Diese Routine definiert das Muster, das zum Zeichnen der Linien verwendet 
; werden soll. In der Praxis setzt man einfach das BLTBDAT-Register.
; D0 - enthält das Linienmuster
;******************************************************************************

SetPattern:
	btst	#6,2(a5)			; dmaconr
WBlit_Set:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	Wblit_Set

	move.w	d0,$72(a5)			; BLTBDAT = Linienmuster
	rts


;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$100,$1200			; Bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$eee			; color1
	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

	Section	IlMioPlane,bss_C

BITPLANE:
	ds.b	40*256				; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel ist die zu füllende Fläche durch Linien mit einer Neigung 
mit weniger als 45 Grad begrenzt. Wie wir in der Lektion unter diesen
Bedingungen erklärten wird die Befüllung nicht korrekt ausgeführt. Um dieses
Problem zu lösen, müssen wir eine besondere Art der Linienverfolgung anwenden,
wie wir im nächsten Beispiel sehen werden.
