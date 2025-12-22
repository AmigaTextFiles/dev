
; Lezione10v.s	Rotierendes Polygon
	; Linke Taste zum Beenden

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
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	move.w	#$ffff,d0	; durchgehende Linie
	bsr.w	SetPattern	; definiert pattern

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2	; Warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $12c
	BNE.S	Waity1

	bsr.w	CancellaSchermo	; Reinigen Sie den Bildschirm

	bsr.w	MuoviPunti	; Ändern Sie die Koordinaten der Punkte

	bsr.w	InitLine	; line-mode

; Zeichne die Linie zwischen den Punkten 1 und 2

	move.w	Point1(pc),d0
	move.w	Point1+2(pc),d1
	move.w	Point2(pc),d2
	move.w	Point2+2(pc),d3
	lea	bitplane,a0
	bsr.w	Drawline

; Zeichne die Linie zwischen den Punkten 2 und 3

	move.w	Point2(pc),d0
	move.w	Point2+2(pc),d1
	move.w	Point3(pc),d2
	move.w	Point3+2(pc),d3
	lea	bitplane,a0
	bsr.w	Drawline

; Zeichne die Linie zwischen den Punkten 3 und 4

	move.w	Point3(pc),d0
	move.w	Point3+2(pc),d1
	move.w	Point4(pc),d2
	move.w	Point4+2(pc),d3
	lea	bitplane,a0
	bsr.w	Drawline

; Zeichne die Linie zwischen den Punkten 4 und 1

	move.w	Point4(pc),d0
	move.w	Point4+2(pc),d1
	move.w	Point1(pc),d2
	move.w	Point1+2(pc),d3
	lea	bitplane,a0
	bsr.w	Drawline

	moveq	#0,d0
	moveq	#0,d1
	lea	bitplane+178*40-2,a0
	bsr.w	Fill

	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.w	mouse
	rts

;***************************************************************************
; Diese Routine liest aus einer Tabelle die Koordinaten der verschiedenen 
; Punkte und speichert sie in den entsprechenden Variablen.
;***************************************************************************

;	          _
;	     _/\/¯/
;	     \___/
;	     /   \
;	    / o O \
;	   (_______)
;	   _| / \ |_
;	  / |(___)| \
;	 /  l_____|  \
;	Y    | U |    Y
;	|  ¦ l___| ¦ .|
;	|  ¡       ¡ :|
;	l__|-------l__|
;	  |        .|
;	  |    ¡   :|
;	  |    ¦   ·|
;	  |    ¦    |
;	.-`----·----'-.
;	¡_____| l_____¡bHe
	
MuoviPunti:
	ADDQ.L	#2,TABXPOINT		; Zeigen Sie auf das nächste Wort
	MOVE.L	TABXPOINT(PC),A0	; Adresse in langen TABXPOINT enthalten
								; kopiert nach a0
	CMP.L	#FINETABX-2,A0  	; Sind wir beim letzten Wort der TAB?
	BNE.S	NOBSTARTX			; noch nicht dann weiter
	MOVE.L	#TABX-2,TABXPOINT 	; Beginnen Sie wieder vom ersten Wort-2
NOBSTARTX:
	MOVE.W	(A0),Point1			; kopiere den Wert der Koordinate
								; von Punkt 1 in der entsprechenden Variablen

	LEA	50(A0),A0				; Koordinate des folgenden Punktes
	CMP.L	#FINETABX-2,A0	  	; Sind wir beim letzten Wort der TAB?
	BLE.S	NOBSTARTX2			; nein dann lesen
	SUB.L	#FINETABX-TABX,A0 	; ansonsten geh zurück in die
								; Tabelle
NOBSTARTX2:
	MOVE.W	(A0),Point2			; kopiere den Wert der Koordinate
								; von Punkt 2 in der entsprechenden Variablen

	LEA	50(A0),A0				; Koordinate des folgenden Punktes
	CMP.L	#FINETABX-2,A0	  	; Sind wir beim letzten Wort der TAB?
	BLE.S	NOBSTARTX3			; nein dann lesen
	SUB.L	#FINETABX-TABX,A0 	; ansonsten geh zurück in die
								; Tabelle
NOBSTARTX3:
	MOVE.W	(A0),Point3			; kopiere den Wert der Koordinate
								; von Punkt 3 in der entsprechenden Variablen

	LEA	50(A0),A0				; Koordinate des folgenden Punktes
	CMP.L	#FINETABX-2,A0	  	; Sind wir beim letzten Wort der TAB?
	BLE.S	NOBSTARTX4			; nein dann lesen
	SUB.L	#FINETABX-TABX,A0 	; ansonsten geh zurück in die
								; Tabelle
NOBSTARTX4:
	MOVE.W	(A0),Point4			; kopiere den Wert der Koordinate
								; von Punkt 4 in der entsprechenden Variablen

	ADDQ.L	#2,TABYPOINT		; Zeigen Sie auf das nächste Wort
	MOVE.L	TABYPOINT(PC),A0	; Adresse in langen TABYPOINT enthalten
								; kopiert nach a0
	CMP.L	#FINETABY-2,A0  	; Sind wir beim letzten Wort der TAB?
	BNE.S	NOBSTARTY			; noch nicht dann weiter
	MOVE.L	#TABY-2,TABYPOINT 	; Beginnen Sie wieder vom ersten Wort-2
NOBSTARTY:
	MOVE.W	(A0),Point1+2		; kopiere den Wert der Koordinate
								; von Punkt 1 in der entsprechenden Variablen

	LEA	50(A0),A0				; Koordinate des folgenden Punktes
	CMP.L	#FINETABY-2,A0	  	; Sind wir beim letzten Wort der TAB?
	BLE.S	NOBSTARTY2			; nein dann lesen
	SUB.L	#FINETABY-TABY,A0 	; ansonsten geh zurück in die
								; Tabelle
NOBSTARTY2:
	MOVE.W	(A0),Point2+2		; kopiere den Wert der Koordinate
								; von Punkt 2 in der entsprechenden Variablen

	LEA	50(A0),A0				; Koordinate des folgenden Punktes
	CMP.L	#FINETABY-2,A0	  	; Sind wir beim letzten Wort der TAB?
	BLE.S	NOBSTARTY3			; nein dann lesen
	SUB.L	#FINETABY-TABY,A0 	; ansonsten geh zurück in die
								; Tabelle
NOBSTARTY3:
	MOVE.W	(A0),Point3+2		; kopiere den Wert der Koordinate
								; von Punkt 3 in der entsprechenden Variablen

	LEA	50(A0),A0				; Koordinate des folgenden Punktes
	CMP.L	#FINETABY-2,A0	  	; Sind wir beim letzten Wort der TAB?
	BLE.S	NOBSTARTY4			; nein dann lesen
	SUB.L	#FINETABY-TABY,A0 	; ansonsten geh zurück in die
								; Tabelle
NOBSTARTY4:
	MOVE.W	(A0),Point4+2		; kopiere den Wert der Koordinate
								; von Punkt 4 in der entsprechenden Variablen
	rts

TABXPOINT:
	dc.l	TABX	; Zeiger auf Tabelle X

; Tabelle Positionen X

TABX:
	DC.W	$00D2,$00D2,$00D1,$00D1,$00D0,$00CF,$00CE,$00CD,$00CB,$00C9
	DC.W	$00C8,$00C6,$00C3,$00C1,$00BF,$00BC,$00B9,$00B7,$00B4,$00B1
	DC.W	$00AE,$00AB,$00A8,$00A5,$00A2,$009E,$009B,$0098,$0095,$0092
	DC.W	$008F,$008C,$0089,$0087,$0084,$0081,$007F,$007D,$007A,$0078
	DC.W	$0077,$0075,$0073,$0072,$0071,$0070,$006F,$006F,$006E,$006E
	DC.W	$006E,$006E,$006F,$006F,$0070,$0071,$0072,$0073,$0075,$0077
	DC.W	$0078,$007A,$007D,$007F,$0081,$0084,$0087,$0089,$008C,$008F
	DC.W	$0092,$0095,$0098,$009B,$009E,$00A2,$00A5,$00A8,$00AB,$00AE
	DC.W	$00B1,$00B4,$00B7,$00B9,$00BC,$00BF,$00C1,$00C3,$00C6,$00C8
	DC.W	$00C9,$00CB,$00CD,$00CE,$00CF,$00D0,$00D1,$00D1,$00D2,$00D2

FINETABX:

TABYPOINT:
	dc.l	TABY	; Zeiger auf Tabelle Y

TABY:
	DC.W	$0081,$0084,$0087,$008A,$008D,$0090,$0093,$0096,$0098,$009B
	DC.W	$009E,$00A0,$00A2,$00A5,$00A7,$00A8,$00AA,$00AC,$00AD,$00AE
	DC.W	$00AF,$00B0,$00B0,$00B1,$00B1,$00B1,$00B1,$00B0,$00B0,$00AF
	DC.W	$00AE,$00AD,$00AC,$00AA,$00A8,$00A7,$00A5,$00A2,$00A0,$009E
	DC.W	$009B,$0098,$0096,$0093,$0090,$008D,$008A,$0087,$0084,$0081
	DC.W	$007D,$007A,$0077,$0074,$0071,$006E,$006B,$0068,$0066,$0063
	DC.W	$0060,$005E,$005C,$0059,$0057,$0056,$0054,$0052,$0051,$0050
	DC.W	$004F,$004E,$004E,$004D,$004D,$004D,$004D,$004E,$004E,$004F
	DC.W	$0050,$0051,$0052,$0054,$0056,$0057,$0059,$005C,$005E,$0060
	DC.W	$0063,$0066,$0068,$006B,$006E,$0071,$0074,$0077,$007A,$007D
FINETABY:

; Hier werden die Koordinaten der Punkte des Polygons jedes Mal gespeichert

Point1:	dc.w	100,20
Point2:	dc.w	200,20
Point3:	dc.w	200,40
Point4:	dc.w	100,40


;****************************************************************************
; Diese Routine kopiert ein Bildschirmrechteck von einer festen Position aus
; an eine als Parameter angegebene Adresse. Das Bildschirmrechteck wird 
; komplett kopiert umschließt die 2 Zeilen.
; Das Füllen erfolgt während des Kopiervorgangs. Die Art der Füllung
; wird über Parameter festgelegt.
; Die Parameter sind:
; A0 - Rechteckadresse, die gefüllt werden soll
; D0 - wenn es 0 ist, dann mache inklusive Füllung, andernfalls exklusiv
; D1 - wenn es 0 ist, wird FILL_CARRYIN = 0, andernfalls FILL_CARRYIN = 1
;****************************************************************************

Fill:
	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5)		; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.w	#$09f0,$40(a5)	; BLTCON0 normale Kopie

	tst.w	d0				; test D0, um die Art der Füllung zu bestimmen
	bne.s	fill_esclusivo
	move.w	#$000a,d2		; Wert von BLTCON1: setze die Bits für den
							; inklusiven Füll- und Abstiegsmodus
	bra.s	test_fill_carry

fill_esclusivo:
	move.w	#$0012,d2		; Wert von BLTCON1: setze die Bits für den
							; exklusiven Füll- und Abstiegsmodus

test_fill_carry:
	tst.w	d1				; test D1, um zu sehen, ob das
							; FILL_CARRYIN-Bit gesetzt werden soll

	beq.s	fatto_bltcon1	; wenn D1 = 0 überspringe ..
	bset	#2,d2			; ansonsten setze Bit 2 von D2

fatto_bltcon1:
	move.w	d2,$42(a5)		; BLTCON1

	move.w	#0,$64(a5)		; BLTAMOD Breite 20 words (40-40=0)
	move.w	#0,$66(a5)		; BLTDMOD (40-40=0)

	move.l	a0,$50(a5)		; BLTAPT (am Quellrechteck fixiert)
							; das Quellrechteck umschließt
							; die 2 Zeilen ganz.
							; Wir zeigen auf das letzte Wort des Rechtecks
							; wegen des absteigenden Weges

	move.l	a0,$54(a5)		; BLTDPT - Rechteckadresse
	move.w	#(64*100)+20,$58(a5)	; BLTSIZE (Blitter starten!)
							; Breite 20 words
	rts						; Höhe 100 Zeilen (1 plane)


;******************************************************************************
; Diese Routine zeichnet die Linie. Sie benötigt als Parameter die Koordinaten
; der Punkte P1 und P2 und die Adresse der Bitebene, auf der gezeichnet werden soll.
; D0 - X1 (X-Koordinate von P1)
; D1 - Y1 (Y-Koordinate von P1)
; D2 - X2 (X-Koordinate von P2)
; D3 - Y2 (Y-Koordinate von P2)
; A0 - Bitplane Adresse
;******************************************************************************

; Konstanten

DL_Fill		=	1		; 0=NOFILL / 1=FILL

	IFEQ	DL_Fill
DL_MInterns	=	$CA
	ELSE
DL_MInterns	=	$4A
	ENDC


DrawLine:
	sub.w	d1,d3		; D3=Y2-Y1

	IFNE	DL_Fill
	beq.s	.end		; Für die Füllung werden keine horizontalen Linien benötigt
	ENDC

	bgt.s	.y2gy1		; springen wenn positiv ..
	exg	d0,d2			; .. Ansonsten tauschen Sie Punkte aus
	add.w	d3,d1		; setzt das kleinere Y in D1
	neg.w	d3			; D3=DY
.y2gy1:
	mulu.w	#40,d1		; Offset Y
	add.l	d1,a0
	moveq	#0,d1		; D1-Index in der Oktantentabelle
	sub.w	d0,d2		; D2=X2-X1
	bge.s	.xdpos		; springen wenn positiv ..
	addq.w	#2,d1		; .. andernfalls verschieben Sie den Index
	neg.w	d2			; und machen den Unterschied positiv
.xdpos:
	moveq	#$f,d4		; Maske für die 4 niedrigen Bits
	and.w	d0,d4		; wählen sie D4 aus
		
	IFNE	DL_Fill		; Diese Anweisungen sind zusammengestellt
						; nur wenn DL_Fill = 1
	move.b	d4,d5		; berechnet die Nummer des zu invertierenden Bits
	not.b	d5			; (das BCHG nummeriert die inversen Bits)
	ENDC

	lsr.w	#3,d0		; Offset X:
						; In Bytes ausrichten (dient für BCHG)
	add.w	d0,a0		; zur Adresse hinzufügen
						; Beachten Sie, dass auch wenn die Adresse
						; Es ist seltsam, dass es nichts macht, weil
						; der Blitter berücksichtigt nicht die
						; niedrigstwertiges Bit von BLTxPT
				
	ror.w	#4,d4		; D4 = Wert der Verschiebung A
	or.w	#$B00+DL_MInterns,d4	; füge das passende hinzu
						; Minterm (OR oder EOR)
	swap	d4			; Wert von BLTCON0 im High-Word
		
	cmp.w	d2,d3		; vergleiche DiffX und DiffY
	bge.s	.dygdx		; überspringen wenn >=0..
	addq.w	#1,d1		; andernfalls setzen Sie das Bit 0 des Indexes
	exg	d2,d3			; und tausche das Diff
.dygdx:
	add.w	d2,d2		; D2 = 2*DiffX
	move.w	d2,d0		; Kopie in D0
	sub.w	d3,d0		; D0 = 2*DiffX-DiffY
	addx.w	d1,d1		; multiplizieren Sie den Index mit 2 und
						; gleichzeitig fügt er die Flagge hinzu
						; X ist 1, wenn 2 * DiffX-DiffY <0 ist
						; (eingestellt von sub.w)
	move.b	Oktants(PC,d1.w),d4	; liest den Oktanten
	swap	d2			; BLTBMOD-Wert in High-Word
	move.w	d0,d2		; niedriges Word D2=2*DiffX-DiffY
	sub.w	d3,d2		; niedriges Word D2=2*DiffX-2*DiffY
	moveq	#6,d1		; Wert der Verschiebung und Test für
						; die Wartezeit Blitter

	lsl.w	d1,d3		; berechnet den Wert von BLTSIZE
	add.w	#$42,d3

	lea	$52(a5),a1		; A1 = BLTAPTL-Adresse
						; Er schreibt einige Register
						; nacheinander mit
						; MOVE #XX,(Ax)+

	btst	d1,2(a5)	; warte auf den Blitter
.wb:
	btst	d1,2(a5)
	bne.s	.wb

	IFNE	DL_Fill		; Diese Anweisung ist zusammengestellt
						; nur wenn DL_Fill = 1
	bchg	d5,(a0)		; Invertiert das erste Bit der Zeile
	ENDC

	move.l	d4,$40(a5)	; BLTCON0/1
	move.l	d2,$62(a5)	; BLTBMOD und BLTAMOD
	move.l	a0,$48(a5)	; BLTCPT
	move.w	d0,(a1)+	; BLTAPTL
	move.l	a0,(a1)+	; BLTDPT
	move.w	d3,(a1)		; BLTSIZE
.end:
	rts
	
; Wenn wir Zeilen für die Füllung ausführen möchten, setzt der Octant-Code 
; durch die Konstante SML das SING-Bit auf 1

	IFNE	DL_Fill
SML		= 	2
	ELSE
SML		=	0
	ENDC

; Tabelle Oktanten

Oktants:
	dc.b	SML+1,SML+1+$40
	dc.b	SML+17,SML+17+$40
	dc.b	SML+9,SML+9+$40
	dc.b	SML+21,SML+21+$40

;******************************************************************************
; Diese Routine legt die Blitter-Register fest, die sich 
; zwischen einer Zeile und einer anderen nicht ändern
;******************************************************************************

InitLine:
	btst	#6,2(a5) 	; dmaconr
WBlit_Init:
	btst	#6,2(a5)	; dmaconr - warte auf das Ende des Blitters
	bne.s	Wblit_Init

	moveq	#-1,d5
	move.l	d5,$44(a5)		; BLTAFWM/BLTALWM = $FFFF
	move.w	#$8000,$74(a5)	; BLTADAT = $8000
	move.w	#40,$60(a5)		; BLTCMOD = 40
	move.w	#40,$66(a5)		; BLTDMOD = 40
	rts

;******************************************************************************
; Diese Routine definiert das Muster, das zum Zeichnen der Linien verwendet 
; werden soll. In der Praxis setzt man einfach das BLTBDAT-Register.
; D0 - enthält das Linienmuster
;******************************************************************************

SetPattern:
	btst	#6,2(a5)	; dmaconr
WBlit_Set:
	btst	#6,2(a5) 	; dmaconr - warte auf das Ende des Blitters
	bne.s	Wblit_Set

	move.w	d0,$72(a5)	; BLTBDAT = Linienmuster
	rts

;****************************************************************************
; Diese Routine löscht den Bildschirm mit dem Blitter.
;****************************************************************************

CancellaSchermo:
	move.l	#bitplane+78*40,a0	; Adresse die gelöscht werden soll

	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)		 	; warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$01000000,$40(a5)		; BLTCON0 und BLTCON1: Löschung
	move.w	#$0000,$66(a5)			; BLTDMOD=0
	move.l	a0,$54(a5)				; BLTDPT
	move.w	#(64*100)+20,$58(a5)	; BLTSIZE (Blitter starten!)
									; lösche den gesamten Bildschirm
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

	dc.w	$100,$1200	; Bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$eee	; color1
	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

	Section	IlMioPlane,bss_C

BITPLANE:
	ds.b	40*256		; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel erstellen wir ein rotierendes Polygon.
Das Polygon besteht aus 4 Punkten, deren Position jeweils bei jedem Frame aus
einer vorberechneten Tabelle gelesen und geändert wird. Diese Technik ist sehr
aufwendig und verschwendet Speicher. Wir werden im Kurs noch sehen, wie man die 
Koordinaten-Punkte mit mathematischen Formeln berechnet.
Um das Polygon zu zeichnen, genügt es, die Seiten zu zeichnen und zu füllen. 
Bei den Zeichenoperationen ist es offensichtlich notwendig, zuerst den Bildschirm 
mit dem Blitter zu löschen. Der zu löschende Bildschirmbereich und der zu 
füllende Bereich wurden berechnet um immer das ganze Polygon zu erstellen.