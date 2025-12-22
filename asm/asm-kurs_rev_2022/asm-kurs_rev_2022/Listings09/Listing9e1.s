
; Listing9e1.s		* SHIFTING * mit dem Blitter.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


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

	moveq	#0,d4				; horizontale Koordinate startet mit 0
Loop:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2			; Warte auf Zeile $108
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $108
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $108
	Beq.S	Waity2

;	  ...........
;	.· ...  ...  :
;	|.· _ ·· _ ·.|
;	l_ ¯_¯  ¯_¯  |
;	 | (°),.(°)  T
;	 | _________ |
;	 |  \_l_l_/  |
;	 l___`---'___|xCz
;	    `------'

	move.w	d4,d5				; aktuelle horizontale Koordinate in d5

	and.w	#$000f,d5			; wir wählen die ersten 4 Bits aus, weil sie
								; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d5				; die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d5				; des Wortes ... (8 + 4 = 12-Bit-Verschiebung!)
	or.w	#$09f0,d5			; ... nur um in das BLTCON0-Register zu kommen
								; Hier setzen wir $f0 in den Minterm für die Kopie von
								; Quelle A nach Ziel D und aktivieren
								; natürlich die A + D Kanäle mit $0900 (Bit 8
								; für D und Bit 11 für A). Das ist $09f0 + Verschiebung.

	addq.w	#1,d4				; Addiere 1 zur horizontalen Koordinate
								; gehe beim nächsten Mal 1 Pixel nach rechts

	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.w	#$ffff,$44(a5)		; BLTAFWM wir erklären es später
	move.w	#$ffff,$46(a5)		; BLTALWM wir erklären es später
	move.w	d5,$40(a5)			; BLTCON0 (A+D) - im Register
								; setzen wir die Shiftbits! (Bits 12,13
								; 14 und 15, d.h. High Nibble!)
	move.w	#$0000,$42(a5)		; BLTCON1 wir erklären es später
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#38,$66(a5)			; BLTDMOD (40-2=38)
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	#bitplane,$54(a5)	; BLTDPT  (Bildschirm)
	move.w	#(64*6)+1,$58(a5)	; BLTSIZE (Blitter starten !)					
								; Die Figur ist 1 Wort breit und 6 Zeilen hoch
							
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	loop

	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

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

	dc.w	$100,$1200

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$eee			; color1

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Hier ist der Fisch ... 16 Pixel breit (1 Word) und 6 Zeilen hoch.

Figura:
	dc.w	%1000001111100000
	dc.w	%1100111111111000
	dc.w	%1111111111101100
	dc.w	%1111111111111110
	dc.w	%1100111111111000
	dc.w	%1000001111100000

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C	

BITPLANE:
	ds.b	40*256			; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel können Sie sehen, wie die Verschiebung funktioniert. Wir 
haben eine 1 Word breite und 6 Zeilen hohe Figur. Diese Figur wird immer an 
der gleichen Zieladresse geshiftet, d.h. die gleiche Adresse wird immer in 
BLTDPT ($dff054) gesetzt. Jedes Mal wird jedoch der Verschiebungswert im 
BLTCON0 um 1 erhöht. Auf diese Weise bewegt sich die Figur jeweils um 
1 Pixel nach rechts.
Beachten Sie auch das in der Lektion beschriebene Phänomen: die Bits, die aus
dem Wort verschoben werden sind im nächsten Wort dann links. In unserem Fall
ist das nicht gut, weil die Nase des Fisches nach rechts herauskommt und dann
nach links, hinter den Schwanz fällt.
Im nächsten Beispiel werden wir sehen, wie wir das Problem lösen können.
