
; Listing10g3.s		Vorhangeffekt
	; Rechter Knopf, um die Figur zu sehen, links zum Verlassen.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper, bitplane, blitter DMA


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl der Bitplanes (hier sind es 3)
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

mouse1:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1				; wenn nicht, gehe zurück zu mouse1

	moveq	#16-1,d6			; für jede Pixelspalte wiederholen

	move.w	#%1000000000000000,d5	; Wert der Maske am Anfang.
								; Es passiert nur das Pixel
								; auf der linken Seite des Wortes.

MostraLoop:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.s	BlitAnd				; zeichne die Figur

	asr.w	#1,d5				; Berechne die Maske für den nächsten
								; blitt. Ein Pixel mehr passieren
								; als Inhalt						

	dbra	d6,MostraLoop


mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; wenn nicht, gehe zurück zu mouse2

	moveq	#16-1,d6			; für jede Pixelspalte wiederholen
CancellaLoop:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile $130 (304)
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $130 (304)
	BNE.S	Waity2

	lsr.w	#1,d5				; Berechne die Maske für den nächsten
								; blitt. Ein Pixel weniger passieren
								; als Inhalt						

	bsr.s	BlitAnd				; zeichne die Figur

	dbra	d6,CancellaLoop

fine:
	rts


;****************************************************************************
; Diese Routine führt eine UND-Verknüpfung zwischen einer Figur, über Kanal A
; und einem konstanten Wert, der in BLTBDAT geladen ist durch. Das Ergebnis 
; wird auf dem Bildschirm gezeichnet.
; D5 - enthält den konstanten Wert (Maske), der in BLTBDAT geladen werden soll
;****************************************************************************

;	    ____
;	  .'_  _`.
;	  |/ \/ \|
;	  || oo ||
;	  ||    ||
;	 _|\_/\_/|_
;	(|-.____.-|)
;	 `._ -- _.'
;	   |_  _|
;	     `'

BlitAnd:
	lea	bitplane+100*40+4,a0	; Zeiger Ziel in a0
	lea	figura,a1				; Zeiger Quelle

	moveq	#3-1,d7				; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff es passiert alles
						
	move.w	d5,$72(a5)			; schreibt Maske in BLTBDAT
	move.l	#$09C00000,$40(a5)	; BLTCON0 Verwende die Kanäle A und D
								; D=A AND B
								; BLTCON1 (keine Spezialmodi)
	move.l	#$00000004,$64(a5)	; BLTAMOD=0
								; BLTDMOD=40-36=4 wie immer

	move.l	a1,$50(a5)			; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirm)
	move.w	#(64*45)+18,$58(a5)	; BLTSIZE (Blitter starten!)

	lea	2*18*45(a1),a1			; zeigt auf die nächste Quellenebene
								; Jede Bitplane ist 18 Wörter breit und 
								; 45 Zeilen hoch

	lea	40*256(a0),a0			; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop

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
	dc.w	$108,0				; WERT MODULO 0
	dc.w	$10a,0				; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres
		
BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$0180,$000			; color0
	dc.w	$0182,$475			; color1
	dc.w	$0184,$fff			; color2
	dc.w	$0186,$ccc			; color3
	dc.w	$0188,$999			; color4
	dc.w	$018a,$232			; color5
	dc.w	$018c,$777			; color6
	dc.w	$018e,$444			; color7

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Dies sind die Daten, aus denen die Figur des Bobs besteht.
; Der Bob ist im normalen Format, 288 Pixel breit (18 Wörter)
; 45 Zeilen hoch, 3 Bitebenen

Figura:
	incbin	"/Sources/copmon.raw"

;****************************************************************************

	section	gnippi,bss_C

BITPLANE:
		ds.b	40*256			; 3 bitplanes
		ds.b	40*256
		ds.b	40*256

	end

;****************************************************************************

In diesem Beispiel machen wir einen "Vorhang"-Effekt, dh wir zeichnen eine Figur
als wäre es ein venezianischer Vorhang, der geöffnet oder geschlossen wird.
Starte es zuerst um es zu betrachten, um zu verstehen, was es ist, dann lies die
Erklärung nochmal!
Diesen Effekt erhalten wir durch eine Technik, die der im Beispiel Listing9h3.s
verwendeten Technik ähnlich ist, um ein Bild jeweils eine Spalte zu zeichnen.
Um den Effekt zu erhalten, wird ein AND zwischen der Figur und einem Maskenwert
gemacht, der nur einige Spalten von Pixeln auswählt. Im Gegensatz zum Beispiel
Listing9h3.s, können wir BLTAFWM / BLTALWM nicht verwenden, um die Maske zu 
erhalten, weil wir die Maske auf alle Wörter in der Figur anwenden müssen, nicht
nur am Anfang und am Ende. Dazu machen wir ein AND zwischen dem Kanal A und
Kanal B, wir halten Kanal B deaktiviert und verwenden BLTBDAT als Maske. Die
Maske wird so variiert, bis das Bild fortlaufend durchgehend angezeigt wird und
dann wird es wieder geändert, um allmählich das ganze Bild zu löschen.