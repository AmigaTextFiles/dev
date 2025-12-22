
; Listing10t2.s		Optimierte Linienverfolgungsroutinen

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

	move.w	#100,d0				; x1
	move.w	#100,d1				; y1
	move.w	#220,d2				; x2
	move.w	#120,d3				; y2
	lea	bitplane,a0
	bsr.s	Drawline

	move.w	#$f0f0,d0			; gezogene Linie
	bsr.w	SetPattern			; definiert pattern

	move.w	#300,d0				; x1
	move.w	#200,d1				; y1
	move.w	#240,d2				; x2
	move.w	#90,d3				; y2
	lea	bitplane,a0
	bsr.s	Drawline

	move.w	#$4444,d0			; gezogene Linie
	bsr.w	SetPattern			; definiert pattern

	move.w	#210,d0				; x1
	move.w	#24,d1				; y1
	move.w	#68,d2				; x2
	move.w	#50,d3				; y2
	lea	bitplane,a0
	bsr.s	Drawline

mouse:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse
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

;	      .---.        .-----------
;	     /     \  __  /    ------
;	    / /     \(oo)/    -----
;	   //////   ' \/ `   ---
;	  //// / // :    : ---
;	 // /   /  /`    '--
;	//          //..\\
;	-----------UU----UU-----
;	           '//||\\`
;	             ''``

; Konstanten

DL_Fill		=	0				; 0=NOFILL / 1=FILL

	IFEQ	DL_Fill
DL_MInterns	=	$CA
	ELSE
DL_MInterns	=	$4A
	ENDC


DrawLine:
	sub.w	d1,d3				; D3=Y2-Y1

	IFNE	DL_Fill
	beq.s	.end				; Für die Füllung werden keine horizontalen Linien benötigt
	ENDC

	bgt.s	.y2gy1				; springen wenn positiv ..
	exg	d0,d2					; .. Ansonsten tauschen Sie Punkte aus
	add.w	d3,d1				; setzt das kleinere Y in D1
	neg.w	d3					; D3=DY
.y2gy1:
	mulu.w	#40,d1				; Offset Y
	add.l	d1,a0
	moveq	#0,d1				; D1-Index in der Oktantentabelle
	sub.w	d0,d2				; D2=X2-X1
	bge.s	.xdpos				; springen wenn positiv ..
	addq.w	#2,d1				; .. andernfalls verschieben Sie den Index
	neg.w	d2					; und machen den Unterschied positiv
.xdpos:
	moveq	#$f,d4				; Maske für die 4 niedrigen Bits
	and.w	d0,d4				; wählen sie D4 aus
		
	IFNE	DL_Fill				; Diese Anweisungen sind zusammengestellt
								; nur wenn DL_Fill = 1
	move.b	d4,d5				; berechnet die Nummer des zu invertierenden Bits
	not.b	d5					; (das BCHG nummeriert die inversen Bits)
	ENDC

	lsr.w	#3,d0				; Offset X:
								; In Bytes ausrichten (dient für BCHG)
	add.w	d0,a0				; zur Adresse hinzufügen
								; Beachten Sie, dass auch wenn die Adresse
								; Es ist seltsam, dass es nichts macht, weil
								; der Blitter berücksichtigt nicht die
								; niedrigstwertiges Bit von BLTxPT

	ror.w	#4,d4				; D4 = Wert der Verschiebung A
	or.w	#$B00+DL_MInterns,d4	; füge das passende hinzu
								; Minterm (OR oder EOR)
	swap	d4					; Wert von BLTCON0 im High-Word
		
	cmp.w	d2,d3				; vergleiche DiffX und DiffY
	bge.s	.dygdx				; überspringen wenn> = 0 ..
	addq.w	#1,d1				; andernfalls setzen Sie das Bit 0 des Indexes
	exg	d2,d3					; und tausche das Diff
.dygdx:
	add.w	d2,d2				; D2 = 2*DiffX
	move.w	d2,d0				; Kopie in D0
	sub.w	d3,d0				; D0 = 2*DiffX-DiffY
	addx.w	d1,d1				; multiplizieren Sie den Index mit 2 und
								; gleichzeitig fügt er die Flagge hinzu
								; X ist 1, wenn 2 * DiffX-DiffY <0 ist
								; (eingestellt von sub.w)
	move.b	Oktants(PC,d1.w),d4	; liest den Oktanten
	swap	d2					; BLTBMOD-Wert in High-Word
	move.w	d0,d2				; niedriges Word D2=2*DiffX-DiffY
	sub.w	d3,d2				; niedriges Word D2=2*DiffX-2*DiffY
	moveq	#6,d1				; Wert der Verschiebung und Test für
								; die Wartezeit

	lsl.w	d1,d3				; berechnet den Wert von BLTSIZE
	add.w	#$42,d3

	lea	$52(a5),a1				; A1 = BLTAPTL-Adresse
								; Er schreibt einige Register
								; nacheinander mit
								; MOVE #XX,(Ax)+

	btst	d1,2(a5)			; warte auf den Blitter
.wb:
	btst	d1,2(a5)
	bne.s	.wb

	IFNE	DL_Fill				; Diese Anweisung ist zusammengestellt
								; nur wenn DL_Fill = 1
	bchg	d5,(a0)				; Invertiert das erste Bit der Zeile
	ENDC

	move.l	d4,$40(a5)			; BLTCON0/1
	move.l	d2,$62(a5)			; BLTBMOD und BLTAMOD
	move.l	a0,$48(a5)			; BLTCPT
	move.w	d0,(a1)+			; BLTAPTL
	move.l	a0,(a1)+			; BLTDPT
	move.w	d3,(a1)				; BLTSIZE
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

InitLine
	btst	#6,2(a5)			; dmaconr
WBlit_Init:
	btst	#6,2(a5) 			; dmaconr - warte auf das Ende des Blitters
	bne.s	Wblit_Init

	moveq	#-1,d5
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

In diesem Beispiel präsentieren wir eine optimierte Linienverfolgungs-Routine.
Das Hauptmerkmal dieser Routine ist, dass die Codes der Oktanten in einer
Tabelle enthalten sind. Die Routine berechnet den Index des richtigen Oktanten
in der Tabelle anhand der Punktepositionen. Darüber hinaus verwendet die
Routine viele 68000 Optimierungen. Diese Routine enthält bedingte
Assemblierungsanweisungen. Basierend auf dem Wert der Konstanten DL_Fill werden
einige Teile der Routine zusammengesetzt oder nicht. Auf diese Weise ist es
möglich, in einer einzigen Quelle den Code für die normale und die Version für
die Zeilenfüllversion zusammen zu bringen. Durch Setzen von DL_Fill = 0 wird
die Routine normal zusammengesetzt, während mit DL_Fill = 1 die Version für die
Zeilenfüllung zusammengestellt wird. Um es zu verstehen, beobachten Sie (mit
dem Befehl D von ASMONE) den Code der in den 2 Fällen produziert wird.
