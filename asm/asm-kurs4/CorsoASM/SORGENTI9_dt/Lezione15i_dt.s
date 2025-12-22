
; Lezione15i.s	- Wir visualisieren das erste Bild in 640x480 32kHz VGA ohne lace.
;		  Wenn Sie keinen geeigneten Monitor haben, sehen Sie nur Rauschen.

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern copperlist etc.
*****************************************************************************

		    ;5432109876543210
DMASET	EQU	%1000001110000000	; copper, bitplane DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das AGA-Bild

	MOVE.L	#PICTURE,d0
	LEA	BPLPOINTERS,A1
	MOVEQ	#8-1,D7			; Anzahl bitplanes -1
POINTB:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addi.l	#80*100,d0		; Länge bitplane
	addq.w	#8,a1
	dbra	d7,POINTB		; D7-mal wiederholen (D7= Anzahl bitplanes)

	move.l	#$2c07fffe,d1	; erste Zeile YY wait: $2c
	moveq	#$00,d5			; Color start
	move.w	#99-1,d7		; Anzahl Zeilen: 99
	bsr.w	FaiAGACopB		; einen BLAUEN Farbton machen

	bsr.s	MettiColori

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

			 ;5432109876543210
	MOVE.W	#%0001101110001000,$1DC(A5) ; BEACON0 - Liste der gesetzten Bits:

			; 3 - BLANKEN - COMPOSITE BLANK OUT TO CSY PIN
			; 7 - VARBEAMEN - VARIABLE BEAM COUNTER COMP. ENABLED
			;     Aktivieren variable Elektronenstrahl-Komparatoren
			;	  als horizontalen Hauptzähler arbeiten,
			;	  und deaktivieren des Hardwarestopp des Displays in
			;     horizontal und vertikal.
			; 8 - VARHSYEN - VARIABLE HORIZONTAL SYNC ENABLED
			;     Aktiviert Register HSSTRT/HSSTOP (var. HSY)
			; 9 - VARVSYEN - VARIABLE VERTICAL SYNC ENABLED
			;     Aktiviert Register VSSTRT/VSSTOP (var. VSY)
			; 11- LOLDIS - DISABLE LONGLINE/SHORTLINE TOGGLE
			;     Deaktivieren des Umschaltens zwischen langen und kurzen Zeilen
			; 12- VARVBEN - VARIABLE VERTICAL BLANK ENABLED
			;     Aktiviert Register VBSTRT/VBSTOP, und deaktivieren
			;     "Hardware Ende" des Videofensters.

	MOVE.W	#113,$1C0(a5)	; HTOTAL - HIGHEST NUMBER COUNT, HORIZ LINE
				; Maximaler Farbtakt pro horizontale Zeile:
				; Der VGA hat 114 Farbtakte pro Scanlinie!
				; Der Wert liegt zwischen 0 und 255: 113 ist in Ordnung!
	
	MOVE.W	#%1000,$1C4(a5)	; HBSTRT - HORIZONTAL LINE POS FOR HBLANK START
				; Die Bits 0-7 enthalten die Startpositionen
				; und horizontal blanking stop in
				; Inkrementen von 280 ns. Die Bits 8-10 sind für
				; eine 35ns (1/4 Pixel) Positionierung.
				; In diesem Fall haben wir 2240ns eingestellt.

	MOVE.W	#14,$1DE(a5)	; HORIZONTAL SYNC START - Anzahl der Farben
							; Takte für Sync-Start.

	MOVE.W	#28,$1C2(a5)	; HORIZONTAL LINE POSITION FOR HSYNC STOP
							; Anzahl der Farbtakte für Sync-stop.

	MOVE.W	#30,$1C6(a5)	; HORIZONTAL LINE POSITION FOR HBLANK STOP
							; horizontale Zeile für Stop Horiz BLANK

	MOVE.W	#70,$1E2(a5)	; HCENTER - POS. HORIZ. von VSYNCH in interlace
							; im Fall von variablen Starhlzähler.

	MOVE.W	#524,$1C8(a5)	; VTOTAL - HIGHEST NUMBERED VERTICAL LINE
				; Maximale Anzahl Zeilen vertikal, d.h.
				; die Zeile in der der Zähler zurückgesetzt werden soll
				; vertikale Position.
				; Wir wissen das der VGA Mode 525 Zeilen hat.
LOOP:
	BTST	#6,$BFE001
	BNE.S	LOOP
	RTS

******************************************************************************

MettiColori:
	LEA	LogoPal(PC),A0			; Adresse der Farbpalette 
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

DaLongARegistri:	; Schleife, die die Farben $00RrGgBb.l in die 2 
			; Wörter $0RGB, $0rgb geeignet für copperregister umwandelt.

; Konvertieren niedriger Nibbles von $00RrGgBb (long) in die Farbe AGA $0rgb (word)

	MOVE.B	1(A0),(a2)		; Hohes Byte der Farbe $00Rr0000 kopiert
							; in das Cop-Register für niedriges nibble
	ANDI.B	#%00001111,(a2) ; auswählen nur niedriges nibble ($0r)
	move.b	2(a0),d2		; Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	lsl.b	#4,d2			; verschiebt das niedrige Halbbyte um 4 Bit nach links
							; des GRÜNEN, "umwandeln" in ein hohes nibble
							; des niedrigen Bytes von D2 ($g0)
	move.b	3(a0),d3		; Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%00001111,d3	; auswählen nur niedriges nibble ($0b)
	or.b	d2,d3			; "MISCHEN" der niedrigen nibble von grün und blau...
	move.b	d3,1(a2)		; Bilden des nachfolgenden Low-Bytes $gb zum Setzen
							; im Farbregister nach dem Byte $0r für
							; Bilden Sie das Wort $0rgb der niedrigen nibble

; Konvertieren hohe Nibbles von $00RrGgBb (long) in die Farbe AGA $0RGB (word)

	MOVE.B	1(A0),d0		; Hohes Byte der Farbe $00Rr0000 in d0
	ANDI.B	#%11110000,d0	; auswählen nur hohes nibble ($R0)
	lsr.b	#4,d0			; verschiebt das nibble um 4 Bit nach rechts, also
							; dadurch wird es zum Low-Byte-Nibble ($0R).
	move.b	d0,(a1)			; Kopieren Sie das High-Byte $0R in das Farbregister
	move.b	2(a0),d2		; das Byte $0000Gg00 aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d2	; auswählen nur hohes nibble ($G0)
	move.b	3(a0),d3		; das Byte $000000Bb aus der 24-Bit-Farbe nehmen
	ANDI.B	#%11110000,d3	; auswählen nur hohes nibble ($B0)
	lsr.b	#4,d3			; verschiebt es um 4 Bit nach rechts
							; dadurch wird es zum Low-Byte-Nibble d3 ($0B)
	or.b	d2,d3			; Mischen der hohen nibble von Grün und Blau ($G0 + $0B)
	move.b	d3,1(a1)		; Bilden des letzten Low-Bytes $GB zum Setzen
							; im Farbregister nach dem Byte $0R für
							; Bilden Sie das Wort $0RGB der hohen nibble

	addq.w	#4,a0		; zur nächsten Farbe .l der Palette springen
						; am unteren Rand des Bildes angebracht
	addq.w	#4,a1		; zum nächsten Farbregister springen
						; für hohes nibble in Copperlist
	addq.w	#4,a2		; zum nächsten Farbregister springen
						; für niedriges nibble in Copperlist

	dbra	d6,DaLongARegistri

	add.w	#(128+8),a1	; Farbregister überspringen + dc.w $106,xxx
						; des hohen nibble
	add.w	#(128+8),a2	; Farbregister überspringen + dc.w $106,xxx
						; des niedrigen nibble

	dbra	d7,ConvertiPaletteBank	; Konvertiert eine Bank mit 32 Farben von
	rts					; Schleife. 8 Schleifen für 256 Farben.

; Palette mit PicCon in Binärform gespeichert (Optionen: Als Binärdatei speichern, nicht als Cop)

LogoPal:
	incbin	"Pic640x100x256.pal"

;*****************************************************************************
; Routine, die BLAUE AGA-Farbtöne erzeugt:
;
; d1 = Erste zu wartende Zeile (Wait, z.B. $2c07fffe pro Zeile Y = $2c)
; d5 = Start Farbton ($00-$ff)
; d7 = Anzahl der zu erledigenden Zeilen
;*****************************************************************************

FaiAGACopB:
	lea	AgaCopEff1,a0
	move.l	#$01060c00,d4	; BplCon3 - nibble hoch
	move.l	#$01060e00,d3	; BplCon3 - nibble niedrig
	move.w	#$180,d2		; Registro Color0
FaiAGALoopB:
	move.l	d1,(a0)+		; wait YYXXFFFE
	add.l	#$01000000,d1	; eine Zeile tiefer für den nächsten
	move.l	d4,(a0)+		; BplCon3 - Auswahl nibble hoch
	move.w	d2,(a0)+		; Register Color0
	addq.b	#1,d5			; "Hellt" die $Gg-Farbe leicht auf
	move.w	d5,d6			; Kopie in d6
	and.w	#%11110000,d6	; Auswahl nur nibble hoch
	lsr.w	#4,d6			; An der richtigen Position, dh BLAU $xxB)
	move.w	d6,(a0)+		; Wert Color0 (nib hoch)
	move.l	d3,(a0)+		; BplCon3 - Auswahl nibble niedrig
	move.w	d2,(a0)+		; Register Color0
	move.w	d5,d6			; Farbe $xx in d6
	and.w	#%00001111,d6	; Auswahl nur nibble niedrig - Position $xxB
	move.w	d6,(a0)+		; Farbe in copperlist eintragen (nibble niedrig)
	dbra	d7,FaiAGALoopB
	rts

;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8			; ausgerichtet auf 64 bit

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$1c45	; diwstrt VGA
	dc.w	$90,$ffe5	; diwstop VGA
	dc.w	$92,$0018	; ddfstrt VGA
	dc.w	$94,$0068	; ddfstop VGA
	dc.w	$1e4,$100
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,-8		; modulo (-8 für burst 64 bit)
	dc.w	$10A,-8		; -8


			    ; 5432109876543210
	dc.w	$100,%0000001001010001	; 8 bitplane SHIRES 640x480 VGA.

	dc.w	$1fc,$8003	; sprite scan Verdopplung??

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste 	bitplane
	dc.w $e4,0,$e6,0	; zweite	   "
	dc.w $e8,0,$ea,0	; dritte	   "
	dc.w $ec,0,$ee,0	; vierte	   "
	dc.w $f0,0,$f2,0	; fünfte	   "
	dc.w $f4,0,$f6,0	; sechste	   "
	dc.w $f8,0,$fA,0	; siebte	   "
	dc.w $fC,0,$fE,0	; achte		   "

; In diesem Fall wird die Palette durch eine Routine aktualisiert, daher
; reicht es aus, die Registerwerte gelöscht zu lassen

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

	dc.w	$106,%0000110000100001		; 0 - external blank enable
						; 5 - BORDER BLANK
						; 10-11 AGA dual playfiled fix

AgaCopEff1:
	dcb.l	99*5		; dh: 99 Zeilen * 5 long:
				; 1 für wait,
				; 1 für bplcon3
				; 1 für color0 (nib hoch)
				; 1 für bplcon3
				; 1 für color0 (nib niedrig)
	dc.w	$9007,$fffe	; auf das Ende des logos warten
	dc.w	$100,$201	; null bitplanes

	dc.w	$FFFF,$FFFE	; Ende copperlist

;******************************************************************************

; Bild RAW mit 8 bitplanes, das sind 256 Farben

	CNOP	0,8	; auf 64 Bit ausrichten

PICTURE:
	INCBIN	"Pic640x100x256.RAW"	; (C) by Cristiano "KREEX" Evangelisti

	end

