
; Listing15c3.s		Ein erster Test von AGA 24Bit Fade (Überblendung).
					; der Fade ist in einer Tabelle vorberechnet.

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper, bitplane DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das AGA-Bild

	MOVE.L	#PICTURE,d0
	LEA	BPLPOINTERS,A1	
	MOVEQ	#8-1,D7				; Anzahl bitplanes -1
POINTB:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addi.l	#40*256,d0			; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTB			; D7-mal wiederholen (D7= Anzahl bitplanes)

	bsr.w	FADE256PRECALC		; berechnet die Werte der gesamten Überblendung vor, 
								; insgesamt 256 Farben. in 256 Schritten von
								; schwarz bis vollfarbig, d.h. 4·256·256 Bytes
								; der Tabelle: 262144 Bytes vorberechnet !!!

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

LOOP:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2			; warte auf Zeile $110
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $110
	BNE.S	Waity1

	bsr.s	MainFadeInOut		; Routine, die von schwarz zu Vollfarbe übergeht
								; und umgekehrt.

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2			; warte auf Zeile $110
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $110
	BEQ.S	Aspetta

	BTST	#6,$BFE001			; Maus gedrückt?
	BNE.S	LOOP
	RTS


*****************************************************************************
* Diese Routine dreht den Farbzeiger vorwärts oder rückwärts vorberechnetes *
* ActualFadeTab. Wenn die Überblendung von Schwarz zur vollen Farbe wechselt*
* fügt es dem Zeiger 256 Langwörter hinzu und zeigt auf die nächsten 256    *
* Farben, dh der nächst dunkelste vorberechnete Rahmen. Im anderen Fall     *
* geht es zurück zum vorherigen Frame. Das Label FlagFadeInOut wird ver-    *
* wendet, um zu überprüfen, ob die Überblendung ein- oder ausgeschaltet ist.*
*****************************************************************************

MainFadeInOut:
	BSR.w	MettiColori			; Ordnen Sie die Farben dieses frames
								; Nehmen Sie sie und konvertieren Sie sie von der Tabelle
								; der vorberechneten Überblendung.
	BTST.b	#1,FlagFadeInOut	; Fade In oder fade Out?
	BNE.S	FadeOut
FadeIn:
	ADD.L	#256*4,ActualFadeTab	; nächstes Bild (256 color.l)
	LEA	CTABEND,A0					; Adresse Tabellenende
	CMP.L	ActualFadeTab(PC),A0	; Sind wir am Ende der Tabelle des
									; Verblassens angekommen? (Volle und helle Farben)
	BNE.s	NonFinito
	BCHG.B	#1,FlagFadeInOut		; Ändern der Richtung der Überblendung
FadeOut:
	SUB.L	#256*4,ActualFadeTab	; Vorheriger Schritt (dunkler)
	LEA	COLORTABBY,A0				; Adresse Start Tabelle
	CMP.L	ActualFadeTab(PC),A0	; Sind wir am Anfang des Tabelle des 
									; Verblassens angekommen? (schwarze Farbe)
	BNE.W	NonFinito
	BCHG.B	#1,FlagFadeInOut		; Ändern der Richtung der Überblendung
NonFinito:
	RTS

FlagFadeInOut:					; Wird verwendet, um zu entscheiden, ob FadeIn 
	dc.w	0					; oder FadeOut verwendet werden soll

ActualFadeTab:					; Zeiger auf den vorberechneten "Frame" des
	dc.l	COLORTABBY			; Überblendens in der Tabelle COLORTABBY.

******************************************************************************
* Diese Routine berechnet alle 24-Bit-Farben der Überblendung vor und macht  *
* ziemlich viel, da es 256 * 256 Langwörter schreiben muss, das				 *
* sind 262144 Bytes! Es ist nichts anderes als die Fade-Routine, die für die * 
* 12-Bit-Farben des normalen Amiga verwendet wird normalerweise,			 *
* nur es nimmt 1 Byte pro RGB-Komponente anstelle von 4 Bit.				 *
******************************************************************************

FADE256PRECALC:
	LEA	COLORTABBY,A1			; DEST CALCULATED COLORS TAB
	MOVEQ	#0,D6				; MULTIPLIER START (0-255)
FADESTEPS:
	LEA	PICTURE+(10240*8),A0	; 24bit colors tab address
	MOVE.w	#256-1,D7			; Anzahl Farben = 256

COLCALCLOOP:

;	BLAU BERECHNEN

	MOVE.L	(A0),D4				; READ COLOR FROM TAB
	ANDI.L	#%000011111111,D4	; SELECT BLUE
	MULU.W	D6,D4				; MULTIPLIER
	ASR.w	#8,D4				; -> 8 BITS
	ANDI.L	#%000011111111,D4	; SELECT BLUE VAL
	MOVE.L	D4,D5				; SAVE BLUE TO D5

;	GRÜN BERECHNEN

	MOVE.L	(A0),D4				; READ COLOR FROM TAB
	ANDI.L	#%1111111100000000,D4	; SELECT GREEN
	LSR.L	#8,D4				; -> 8 bits (so from 0 to 7)
	MULU.W	D6,D4				; MULTIPLIER
	ASR.w	#8,D4				; -> 8 BITS
	ANDI.L	#%0000000011111111,D4	; SELECT GREEN
	LSL.L	#8,D4				; <- 8 bits (so from 8 to 15)
	OR.L	D4,D5				; SAVE GREEN TO D5

;	ROT BERECHNEN

	MOVE.L	(A0)+,D4			; READ COLOR FROM TAB AND GO TO NEXT
	ANDI.L	#%111111110000000000000000,D4	; SELECT RED
	LSR.L	#8,D4				; -> 8 bits (so from 8 to 15)
	LSR.L	#8,D4				; -> 8 bits (so from 0 to 7)
	MULU.W	D6,D4				; MULTIPLIER
	ASR.w	#8,D4				; -> 8 BITS
	ANDI.L	#%0000000011111111,D4	; SELECT RED
	LSL.L	#8,D4				; <- 8 bits (so from 8 to 15)
	LSL.L	#8,D4				; <- 8 bits (so from 0 to 7)
	OR.L	D4,D5				; SAVE RED TO D5
	MOVE.L	D5,(A1)+			; SAVE 24 BIT VALUE IN TAB
	DBRA	D7,COLCALCLOOP		; 256 TIMES FOR 256 COLORS

	ADDQ.W	#1,D6				; ADD 1 TO MULTIPLIER
	CMPI.W	#255,D6				; MULTIPLIER MAX = 256
	BLE.S	FADESTEPS			; IF NOT MAX NEXT FADE STEP
	RTS


******************************************************************************
* Diese Routine konvertiert Farben in 24-Bit, was wie ein Langwort $00RrGgBb *
* aussieht, (wobei R = ROT hohes nibble, r = ROT niedriges nibble,			 *
* G = hohes nibble von GRÜN usw.) im Format der copperliste aga, ist es		 *
* in zwei Worten: $0RGB mit hohen nibbles und $0rgb mit niedrigen nibbles.   *
******************************************************************************

MettiColori:
	MOVE.L	ActualFadeTab(PC),A0	; Adresse der Farbpalette al
								; aktueller Punkt der Überblendung von TAB
	LEA	COLP0+2,A1				; Adresse des ersten Registers
								; auf hohes nibble eingestellt
	LEA	COLP0B+2,A2				; Adresse des ersten Registers
								; auf niedriges nibble eingestellt
	MOVEQ	#8-1,d7				; 8 Banken mit jeweils 32 Registern
ConvertiPaletteBank:
	moveq	#0,d0
	moveq	#0,d2
	moveq	#0,d3
	moveq	#32-1,d6			; 32 Farbregister pro Bank

DaLongARegistri:				; Schleife, die die Farben $00RrGgBb.l in die 2 
								; Wörter $0RGB, $0rgb geeignet für die
								; copperregister umwandelt.

; Konvertieren niedriger Nibbles von $00RrGgBb (long) in die Farbe AGA $0rgb (word)

	MOVE.B	1(A0),(a2)			; Hohes Byte der Farbe $00Rr0000 kopiert
								; in das Cop-Register für niedriges nibble
	ANDI.B	#%00001111,(a2)		; auswählen nur niedriges nibble ($0r)
	move.b	2(a0),d2			; Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	lsl.b	#4,d2				; verschiebt das niedrige Halbbyte um 4 Bit nach links
								; des GRÜNEN, "umwandeln" in ein hohes nibble
								; des niedrigen Bytes von d2 ($g0)
	move.b	3(a0),d3			; Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%00001111,d3		; auswählen nur niedriges nibble ($0b)
	or.b	d2,d3				; "MISCHEN" der niedrigen nibble von grün und blau...
	move.b	d3,1(a2)			; Bilden des nachfolgenden Low-Bytes $gb zum Setzen
								; im Farbregister nach dem Byte $0r für
								; das word $0rgb der niedrigen nibble

; Konvertieren hohe Nibbles von $00RrGgBb (long) in die Farbe AGA $0RGB (word)

	MOVE.B	1(A0),d0			; Hohes Byte der Farbe $00Rr0000 in d0
	ANDI.B	#%11110000,d0		; auswählen nur hohes nibble ($R0)
	lsr.b	#4,d0				; verschiebt das nibble um 4 Bit nach rechts,
								; dadurch wird es zum Low-Byte-Nibble ($0R).
	move.b	d0,(a1)				; das High-Byte $0R in das Farbregister kopieren
	move.b	2(a0),d2			; das Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d2		; auswählen nur hohes nibble ($G0)
	move.b	3(a0),d3			; das Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d3		; auswählen nur hohes nibble ($B0)
	lsr.b	#4,d3				; verschiebt es um 4 Bit nach rechts
								; dadurch wird es zum Low-Byte-Nibble d3 ($0B)
	or.b	d2,d3				; Mischen der hohen nibble von Grün und Blau ($G0 + $0B)
	move.b	d3,1(a1)			; Bilden des letzten Low-Bytes $GB zum Setzen
								; im Farbregister nach dem Byte $0R für
								; das Wort $0RGB der hohen nibble
	addq.w	#4,a0				; zur nächsten Farbe .l der Palette springen
								; am unteren Rand des Bildes angebracht
	addq.w	#4,a1				; zum nächsten Farbregister springen
								; für hohes nibble in Copperlist
	addq.w	#4,a2				; zum nächsten Farbregister springen
								; für niedriges nibble in Copperlist

	dbra	d6,DaLongARegistri

	add.w	#(128+8),a1			; Farbregister überspringen + dc.w $106,xxx
								; des hohen nibble
	add.w	#(128+8),a2			; Farbregister überspringen + dc.w $106,xxx
								; des niedrigen nibble

	dbra	d7,ConvertiPaletteBank	; Konvertiert eine Bank mit 32 Farben pro
	rts							; Schleife. 8 Schleifen für 256 Farben.


;*****************************************************************************
;*				COPPERLIST AGA												 *
;*****************************************************************************

	CNOP	0,8					; ausgerichtet auf 64 bit

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

			    ; 5432109876543210
	dc.w	$100,%0000001000010001	; 8 bitplane LOWRES 320x256. Zum
								; Setzen von 8 planes, Bit 4 setzen
								; Bit 12,13,14 zurücksetzen. Bit 0 ist gesetzt,
								; da es viele AGA-Funktionen ermöglicht
								; die wir später sehen werden.

	dc.w	$1fc,0				; Burst mode gelöscht (vorerst!)

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste 	bitplane
	dc.w	$e4,0,$e6,0			; zweite	   "
	dc.w	$e8,0,$ea,0			; dritte	   "
	dc.w	$ec,0,$ee,0			; vierte	   "
	dc.w	$f0,0,$f2,0			; fünfte	   "
	dc.w	$f4,0,$f6,0			; sechste	   "
	dc.w	$f8,0,$fA,0			; siebte	   "
	dc.w	$fC,0,$fE,0			; achte		   "

; In diesem Fall wird die Palette durch eine Routine aktualisiert, daher
; reicht es aus, die Registerwerte gelöscht zu lassen.

	DC.W	$106,$c00	; AUSWAHL PALETTE 0 (0-31), NIBBLE HOCH
COLP0:
	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$e00	; AUSWAHL PALETTE 0 (0-31), NIBBLE NIEDRIG
COLP0B:
	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$2C00	; AUSWAHL PALETTE 1 (32-63), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$2E00	; AUSWAHL PALETTE 1 (32-63), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$4C00	; AUSWAHL PALETTE 2 (64-95), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$4E00	; AUSWAHL PALETTE 2 (64-95), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$6C00	; AUSWAHL PALETTE 3 (96-127), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$6E00	; AUSWAHL PALETTE 3 (96-127), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$8C00	; AUSWAHL PALETTE 4 (128-159), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$8E00	; AUSWAHL PALETTE 4 (128-159), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$AC00	; AUSWAHL PALETTE 5 (160-191), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$AE00	; AUSWAHL PALETTE 5 (160-191), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$CC00	; AUSWAHL PALETTE 6 (192-223), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$CE00	; AUSWAHL PALETTE 6 (192-223), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$EC00	; AUSWAHL PALETTE 7 (224-255), NIBBLE HOCH

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	DC.W	$106,$EE00	; AUSWAHL PALETTE 7 (224-255), NIBBLE NIEDRIG

	DC.W	$180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
	DC.W	$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
	DC.W	$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
	DC.W	$1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

	dc.w	$FFFF,$FFFE	; Ende copperlist

;******************************************************************************

; Bild RAW mit 8 bitplanes, das sind 256 Farben

	CNOP	0,8			; auf 64 Bit ausrichten

PICTURE:
	INCBIN	"/Sources/MURALE320x256x256c.RAW"
	
*************************************************************************

	Section	BufPerPrecalc,BSS	; es ist auch groß und schnell!

; 256 COLOR.L * 256

COLORTABBY:
	DS.B	4*256*256	; 262144 bytes vorberechnen!
CTABEND:

	end

Immerhin ist es ein "Upgrade" der alten Fade-Routine! Nein?
