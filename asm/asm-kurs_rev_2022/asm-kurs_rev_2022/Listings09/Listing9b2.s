
; Listing9b2.s		 Schleife einer gezeichneten Linie

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

; In A0 wird die Adresse des Ziels gespeichert, die sich mit der Zeit ändert
; Die Anfangsadresse wird berechnet, um die Figur bei 
; Zeile Y = 3 beginnend mit dem Pixel mit X = 0 anzuzeigen

	lea	bitplane+(3*20+0/16)*2,a0	; Zieladresse
	move.w	#200-1,d7			; Anzahl Schleifendurchläufe = 200

BlitLoop:
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

	btst.b	#6,2(a5)			; dmaconr
WBlit:
	btst.b	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit

;	          (####)
;	        (#######)
;	      (#########)
;	     (#########)
;	    (#########)
;	   (#########)
;	  (#########)
;	   (o)(o)(##)
;	 ,_c     (##)
;	/____,   (##)
;	  \     (#)
;	   |    |
;	   oooooo
;	  /      \

	move.w	#$ffff,$44(a5)		; BLTAFWM wir werden es später erklären
	move.w	#$ffff,$46(a5)		; BLTALWM wir werden es später erklären
	move.w	#$05CC,$40(a5)		; BLTCON0 (eine Kopie von B nach D erstellen)
	move.w	#$0000,$42(a5)		; BLTCON1 wir werden es später erklären
	move.w	#$0000,$62(a5)		; BLTBMOD wir werden es später erklären
	move.w	#$0000,$66(a5)		; BLTDMOD wir werden es später erklären
	move.l	#figura,$4c(a5)		; BLTBPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (variables Ziel a0)
	move.w	#64*1+10,$58(a5)	; BLTSIZE (Blitter starten!)
								; jetzt statt 8 Wörter, wie im
								; vorherigen Beispiel, Block von 10 Wörtern

	add.w	#40,a0				; Lass uns zum nächsten Blitt gehen
								; Zeile in der nächsten Schleife.
	dbra	d7,blitloop

mouse:
	btst	#6,$bfe001			; linke Mausetaste gedrückt?
	bne.s	mouse

	btst.b	#6,2(a5)			; dmaconr
WBlit2:
	btst.b	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	rts

;*****************************************************************************

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
	dc.w	$0182,$eee			; color1

	dc.w	$FFFF,$FFFE			; Ende copperlist

*****************************************************************************

	SECTION	Figura_da_blittare,DATA_C

Figura:
	dc.w	$8888,$aaaa,$cccc,$f0f0
	dc.w	$ffff,$6666,$eeee,$5555
	dc.w	$2222,$dddd

*****************************************************************************

	SECTION	PLANEVUOTO,BSS_C	

BITPLANE:
	ds.b	40*256				; bitplane lowres

	end

*****************************************************************************

Dieses Beispiel ist eine Variation des Beispiels Listing9b1.s.
Beachten Sie, wie die Daten kopiert werden, indem wir die Zieladresse in die
verschiedenen Bereichen des Bildschirms ändern. Jeder Blitt wird eine Zeile
weiter gemacht (auf dem Bildschirm niedriger) als der vorherige. Dies wird
erreicht, indem die Zieladresse immer um 40 (= Anzahl Bytes für jede Zeile)
erhöht wird.

Beachten Sie eine sehr wichtige Sache: Immer, bevor ein Blitt gestartet wird,
das der vorherige Blitter-Block mit der Waitblit-Schleife beendet ist.

In diesem Beispiel haben wir den Kanal B als Quellkanal verwendet.
Folglich verwenden wir die BLTBPT- und BLTBMOD-Register anstelle von BLTAPT 
und BLTAMOD. Außerdem ist der in BLTCON0 geschriebene Wert anders, weil wir 
den Kanal B anstelle von Kanal A aktivieren (daher Bit 11 ist 0 und Bit 10
ist 1) und das wir die MINTERMS auf den Wert $CC setzen müssen, der genau
eine Kopie von Kanal B zu Kanal D definiert.