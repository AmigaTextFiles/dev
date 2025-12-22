
; Listing15c5.s		24-Bit-Fade in Echtzeit, nicht vorberechnet

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper, bitplane DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

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
	addi.l	#10240,d0			; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTB			; D7-mal wiederholen (D7= Anzahl bitplanes)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

LOOP:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$08000,d2			; warte auf Zeile $80
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $80
	BNE.S	Waity1

	bsr.s	MainFadeInOut		; Routine, die von schwarz zu Vollfarbe übergeht
								; und umgekehrt.

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$08000,d2			; warte auf Zeile $80
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $80
	BEQ.S	Aspetta

	BTST	#6,$BFE001			; Maus gedrückt?
	BNE.S	LOOP
	RTS
	
*****************************************************************************
* Diese Routine erhöht oder verringert den MULTIPLIER für das Ein- und		*
* Ausblenden. Das FlagFadeInOut wird verwendet, um zu überprüfen,			*
* ob die Überblendung ein- oder ausgeht.									*
*****************************************************************************

MainFadeInOut:
	BSR.w	CalcolaMettiCol ; Berechnen der 256 Farben in diesem Schritt des Fade
	; konvertiert sie in Abhängigkeit des MULTIPLIER und konvertiert sie
	; in die Wörter für die AGA copperliste und kopiert sie
	; in der copperliste selbst.

	BTST.b	#1,FlagFadeInOut	; Fade In oder fade Out?
	BNE.S	FadeOut
FadeIn:
	ADDQ.W	#1,MULTIPLIER		; Nächste Phase der Überblendung (heller)
	CMP.W	#255,MULTIPLIER		; sind wir zu maximaler Helligkeit 
								; des Verblassens angekommen? (Volle und helle Farben)
	BNE.s	NonFinito			; Wenn noch nicht, -> unvollendet, -> NonFinito
	BCHG.B	#1,FlagFadeInOut	; Andernfalls ändern Sie die Richtung der Überblendung
FadeOut:
	SUBQ.W	#1,MULTIPLIER		; Nächste Phase der Überblendung (dunkler)
	BNE.W	NonFinito			; multiplier=null? Wenn noch nicht -> Nonfinito
	BCHG.B	#1,FlagFadeInOut	; Andernfalls ändern Sie die Richtung der Überblendung
NonFinito:
	RTS

FlagFadeInOut:					; Wird verwendet, um zu entscheiden, ob FadeIn oder FadeOut
	dc.w	0

MULTIPLIER:
	dc.w	0

Temporaneo:
	dc.l	0

******************************************************************************
* Diese Routine konvertiert Farben in 24-Bit, was wie ein Langwort $00RrGgBb *
* aussieht, (wobei R = ROT hohes nibble, r = ROT niedriges nibble,			 *
* G = hohes nibble von GRÜN usw.) im Format der copperliste aga, d.h.		 *
* in zwei Worten: $0RGB mit hohen nibbles und $0rgb mit niedrigen nibbles.   *
******************************************************************************

CalcolaMettiCol:
	LEA	Temporaneo(PC),A0 		; Long temporär für Farbe bei 24
								; Bit im Format $00RrGgBb
	LEA	COLP0+2,A1				; Adresse des ersten Registers
								; auf hohes nibble eingestellt
	LEA	COLP0B+2,A2				; Adresse des ersten Registers
								; auf niedriges nibble eingestellt
	LEA	PalettePic(PC),A3		; 24bit colors tab address

	MOVEQ	#8-1,d7				; 8 Banken mit jeweils 32 Registern
ConvertiPaletteBank:
	moveq	#0,d0
	moveq	#0,d2
	moveq	#0,d3
	moveq	#32-1,d6			; 32 Farbregister pro Bank

DaLongARegistri:				; Schleife, die die Farben $00RrGgBb.l in die 2 
								; Wörter $0RGB, $0rgb geeignet für 
								; copperregister umwandelt.

;	BLAU BERECHNEN

	MOVE.L	(A3),D4				; READ COLOR FROM TAB
	ANDI.L	#%000011111111,D4	; SELECT BLUE
	MULU.W	MULTIPLIER(PC),D4	; MULTIPLIER
	ASR.w	#8,D4				; -> 8 BITS
	ANDI.L	#%000011111111,D4	; SELECT BLUE VAL
	MOVE.L	D4,D5				; SAVE BLUE TO D5

;	GRÜN BERECHNEN

	MOVE.L	(A3),D4				; READ COLOR FROM TAB
	ANDI.L	#%1111111100000000,D4	; SELECT GREEN
	LSR.L	#8,D4				; -> 8 bits (so from 0 to 7)
	MULU.W	MULTIPLIER(PC),D4	; MULTIPLIER
	ASR.w	#8,D4				; -> 8 BITS
	ANDI.L	#%0000000011111111,D4	; SELECT GREEN
	LSL.L	#8,D4				; <- 8 bits (so from 8 to 15)
	OR.L	D4,D5				; SAVE GREEN TO D5

;	ROT BERECHNEN

	MOVE.L	(A3)+,D4			; READ COLOR FROM TAB AND GO TO NEXT
	ANDI.L	#%111111110000000000000000,D4	; SELECT RED
	LSR.L	#8,D4				; -> 8 bits (so from 8 to 15)
	LSR.L	#8,D4				; -> 8 bits (so from 0 to 7)
	MULU.W	MULTIPLIER(PC),D4	; MULTIPLIER
	ASR.w	#8,D4				; -> 8 BITS
	ANDI.L	#%0000000011111111,D4	; SELECT RED
	LSL.L	#8,D4				; <- 8 bits (so from 8 to 15)
	LSL.L	#8,D4				; <- 8 bits (so from 0 to 7)
	OR.L	D4,D5				; SAVE RED TO D5
	MOVE.L	D5,(A0)				; SAVE 24 BIT VALUE IN temporaneo

; Konvertieren niedriger Nibbles von $00RrGgBb (long) in die Farbe AGA $0rgb (Word)

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
	lsr.b	#4,d0				; verschiebt das nibble um 4 Bit nach rechts, also
								; dadurch wird es zum Low-Byte-Nibble ($0R).
	move.b	d0,(a1)				; das High-Byte $0R in das Farbregister kopieren
	move.b	2(a0),d2			; das Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d2		; auswählen nur hohes nibble ($G0)
	move.b	3(a0),d3			; das Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d3		; auswählen nur hohes nibble ($B0)
	lsr.b	#4,d3				; verschiebt es um 4 Bit nach rechts
								; dadurch wird es zum Low-Byte-Nibble d3 ($0B)
	or.b	d2,d3				; Mischen der hohen nibble von Grün und Blau ($G0+$0B)
	move.b	d3,1(a1)			; Bilden des letzten Low-Bytes $GB zum Setzen						// move.b	d3,1+2(a1)
								; im Farbregister nach dem Byte $0R für
								; das Wort $0RGB der hohen nibble

	addq.w	#4,a1				; zum nächsten Farbregister springen
								; für hohes nibble in Copperlist
	addq.w	#4,a2				; zum nächsten Farbregister springen
								; für niedriges nibble in Copperlist

	dbra	d6,DaLongARegistri

	add.w	#(128+8),a1			; Farbregister überspringen + dc.w $106,xxx
								; des hohen nibble
	add.w	#(128+8),a2			; Farbregister überspringen + dc.w $106,xxx
								; des niedrigen nibble

	dbra	d7,ConvertiPaletteBank	; Konvertiert eine Bank mit 32 Farben von
	rts							; Schleife. 8 Schleifen für 256 Farben.

; Tabelle mit der 24-Bit-Palette im Format $00RRGGBB. Wir hätten genauso gut 
; die am unteren Rand des PIC angebrachte verwenden können, 
; aber um hier zu variieren, ist sie in dc.l!
; Sie können sie von PicCon speichern, wenn sie nicht "Copperlist" auswählen.


PalettePic:
	dc.l	$021104,$150f04,$001115,$191609,$092206,$182707
	dc.l	$052420,$2f1506,$17291c,$1f3108,$341613,$35230b
	dc.l	$1c331c,$2c3409,$00203d,$35241f,$323420,$21470a
	dc.l	$103937,$4a2007,$47201b,$243a32,$002a4a,$35440d
	dc.l	$492822,$443c0a,$21550a,$54280b,$483421,$3a3931
	dc.l	$07364f,$233e45,$1d4d3c,$32590c,$01335d,$27503d
	dc.l	$484f11,$5a3e0e,$354e3c,$5c3921,$593431,$70230e
	dc.l	$4c5b12,$064066,$5b442c,$5d4d11,$465a30,$104367
	dc.l	$732e11,$316143,$5b4838,$324662,$506714,$763b0f
	dc.l	$704023,$655711,$4d5d44,$733f31,$19536e,$8a2012
	dc.l	$2b6261,$6c552e,$784f19,$0d4c7d,$79492e,$8f2713
	dc.l	$716217,$6c612b,$455e61,$8f370f,$1b5081,$705845
	dc.l	$716e16,$943c17,$516463,$8b4e1f,$1e5f83,$8f510f
	dc.l	$746d2d,$89512e,$588a24,$776a45,$8c631d,$8e5e2f
	dc.l	$72635d,$8c5644,$b02015,$1d6791,$aa3c15,$af2d14
	dc.l	$8d7419,$2b6d90,$a1552d,$788a2a,$a25f13,$936d31
	dc.l	$ac4e13,$6e7071,$3a7192,$bd2a16,$878b1e,$a1672e
	dc.l	$926f47,$a46e13,$5d8e67,$8d7054,$a06546,$2f739f
	dc.l	$a37331,$c92b16,$b66110,$8e8b3b,$818d55,$c74013
	dc.l	$3d79a4,$8c7173,$b36e2b,$ba6c11,$ad7244,$a77253
	dc.l	$a58b27,$8f8c60,$a58444,$4489a4,$a59720,$a77661
	dc.l	$cd6214,$ba763e,$a78f41,$db4114,$a48b55,$4589b0
	dc.l	$b87754,$608fa2,$c97728,$8ba268,$d46d10,$c58428
	dc.l	$b8894a,$c88614,$a48c6e,$d86b22,$a59e59,$898f97
	dc.l	$5a94b3,$e46217,$c59427,$c98940,$b99259,$df6a39
	dc.l	$c39443,$c2a025,$a79a74,$da734c,$5595c1,$8c9f95
	dc.l	$c79156,$b99271,$ef6327,$ea7515,$de8b1a,$a89988
	dc.l	$eb7623,$df8d29,$c7a93e,$dd903f,$669ac7,$c5a55b
	dc.l	$c79770,$5da6c8,$f08a18,$d6995f,$ea971a,$dda043
	dc.l	$f3872b,$e1a42d,$caa472,$a8a2a3,$71a7cb,$ef9341
	dc.l	$80a6c6,$caae6f,$f2982a,$c7a287,$f69a1c,$e99959
	dc.l	$d7a86a,$f2a13e,$ccb678,$c6a499,$efb127,$e8b247
	dc.l	$89b2c9,$e5a868,$c8af94,$e2b363,$bcc28f,$f7af2d
	dc.l	$deb577,$8bb1d6,$d1b295,$beb5aa,$f7b34b,$dbb191
	dc.l	$f5b462,$8cb3e3,$f1b375,$d2ba9f,$fdc42f,$dfc189
	dc.l	$fac34a,$87c0e3,$c3c4ae,$a6bbd4,$e2ba94,$fbd232
	dc.l	$f3c967,$98bee4,$f0bf85,$d6c6a4,$fbd24a,$d3baba
	dc.l	$c1bfcd,$e8ce8d,$fdd457,$a3c3e9,$dbd0a8,$d3cbbd
	dc.l	$f0c4a0,$fcdb66,$adcde0,$f7cf8a,$b3c5e9,$dfcebc
	dc.l	$c4d2d8,$feea66,$f3e489,$b5ceeb,$d2ced4,$f5d0a8
	dc.l	$fee885,$f3dfa7,$d8dfca,$c5d2ec,$f5d2bc,$d1d2e7
	dc.l	$ede1c2,$d9d4e7,$fde7aa,$f2d2d5,$f9e2c0,$d2dfef
	dc.l	$e9dedf,$f9f3c4,$f8efda,$f9f5ee

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

	CNOP	0,8					; auf 64 Bit ausrichten

PICTURE:
	INCBIN	"/Sources/MURALE320x256x256c.RAW"

	end

Wir haben das COLORTABBY eliminiert, und dies kann als "FADE IN REALTIME" bezeichnet
werden, da es Frame für Frame berechnet wird. Es ist viel langsamer als das 
vorberechnete, benötigt aber kein 256k Puffer. Es kann verwendet werden, wenn
es notwendig ist, eine statische Figur auszublenden oder in jedem Fall, wenn es
keine sehr zeitaufwändigen Routinen gibt. Beachten Sie, dass die Palette von
einer Tabelle stammt, anstatt vom Ende des Bildes.