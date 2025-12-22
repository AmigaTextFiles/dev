
; Listing10a1.s		BLITT, wo wir Rechtecke auf dem Bildschirm zeichnen
			; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE1,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#1-1,D1				; Anzahl der bitplanes
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

; Parameter für die Zeichenroutine

	move.w	#200,d0				; X obere linke Ecke
	move.w	#10,d1				; Y obere linke Ecke
	move.w	#48,d2				; Breite
	move.w	#20,d3				; Höhe
	bsr.s	BlitRett			; Zeichenroutine ausführen 

mouse1:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1				; wenn nicht, gehe zurück zu mouse1:

; Parameter für die Zeichenroutine

	move.w	#64,d0				; X obere linke Ecke
	move.w	#70,d1				; Y obere linke Ecke
	move.w	#32,d2				; Breite
	move.w	#40,d3				; Höhe
	bsr.s	BlitRett			; Zeichenroutine ausführen 

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; wenn nicht, gehe zurück zu mouse2:

	rts

;****************************************************************************
; Diese Routine zeichnet ein Rechteck auf dem Bildschirm.
;
; D0 - X Koordinate des oberen linken Eckpunkts
; D1 - Y-Koordinate des oberen linken Eckpunkts
; D2 - Rechteckbreite in Pixel
; D3 - Rechteckhöhe
;****************************************************************************

;	  _____     .
;	 / ___ \____.
;	¡ (___)___ ¬|
;	| | o Y___) |
;	| l___| ° | ¦
;	|   , `---' `;
;	|  C__.     _)
;	| _______   T
;	| l_l_l_|   |
;	| .¾¾¾¾¾,   |
;	| (_|_)_|   |
;	l___________|
;	   _T    T_
;	  / `-^--' \
;	_/          \_
;	|       xCz  |

BlitRett:
	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

; Berechnung der Startadresse des Blitters

	lea	bitplane1,a1			; Adresse bitplane
	mulu.w	#40,d1				; Offset Y
	add.l	d1,a1				; zur Adresse hinzufügen
	lsr.w	#3,d0				; teile das X durch 8
	and.w	#$fffe,d0			; mach es gerade
	add.w	d0,a1				; Summe zur Adresse der Bitebene, Finden
								; der richtigen Zieladresse

; Blitter Modulo Berechnung

	lsr.w	#3,d2				; dividiere die Breite durch 8
	and.w	#$fffe,d2			; Ich nulle Bit 0 (gerade)
	move.w	#40,d4				; Bildschirmbreite in Bytes
	sub.w	d2,d4				; modulo = Bildschirmbreite - Rechteckbreite

; Berechnung der Größe des Blitts

	lsl.w	#6,d3				; Höhe multipliziert mit 64
	lsr.w	#1,d2				; Breite in Pixel dividiert durch 16
								; das heisst, Breite in Worten
	or	d2,d3					; lege die Dimension zusammen

; Register laden

	move.l	#$01ff0000,$40(a5)	; BLTCON0 und BLTCON1
								; benutze Kanal D
								; LF=$FF (Operation alles)
								; Mode ascending

	move.w	d4,$66(a5)			; BLTDMOD
	move.l	a1,$54(a5)			; BLTDPT  Zeiger Ziel
	move.w	d3,$58(a5)			; BLTSIZE (Blitter starten !)

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

	dc.w	$100,$1200			; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$aaa			; color1

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

	SECTION	bitplane,BSS_C

BITPLANE1:
	ds.b	40*256

;****************************************************************************

	end

In diesem Beispiel verwenden wir den Blitter, um Rechtecke auf dem Bildschirm 
zu zeichnen. Wir verwenden eine Routine mit Parameterübergabe, die ein Rechteck
an die Koordinaten des oberen linken Eckpunkts mit den Abmessungen (Breite und
Höhe) des Rechtecks, zeichnet. Zur Vereinfachung der Routine ist die Breite und
die Position X mit einem Vielfachen von 16 angenähert.
Die Zeichnung wird mit einem Blitt gemacht, der den Ausgang immer auf 1 setzt.
Dies erhalten wir durch das Setzen von LF = $FF, wie in der Lektion erläutert.

