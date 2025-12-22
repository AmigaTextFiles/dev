
; Lezione9f3.s		In diesem Listing wird eine Figur von 16 * 15 Pixeln, 
		; mit 2 Bitplanes, 
		; füllen Sie den Bildschirm (320 * 256 Lowres 2 Bitplanes).
		; Timing mit VBlank
		; gezeichnet nur eine Kachel pro Frame.

	section	bau,code

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:
;	Lass uns die erste Bitebene setzen

	MOVE.L	#BitPlane1,d0	;
	LEA	BPLPOINTER1,A1		; Zeiger Bitplane1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Lass uns die zweite Bitebene setzen

	MOVE.L	#BitPlane2,d0	; 
	LEA	BPLPOINTER2,A1		; Zeiger Bitplane2
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	bsr.s	fillmem			; füllen Sie den "Kachel" -Bildschirm
							; mit dem Blitter.
mouse:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse		; Wenn nicht, gehe zurück zu mouse:
	rts					; Ausgang

;	  .---^---^---.
;	  |           |
;	  |           |
;	  | ¯¯¯   --- |
;	 _| ___   ___ l_
;	/__ `°(___)°' __\
;	\ \_/\_____/\_/ /
;	 \____`---'____/
;	    T`-----'T
;	    l_______| xCz

fillmem:
	lea	Bitplane1,a0	; erste bitplane
	lea	Bitplane2,a1	; zweite bitplane
	lea	gfxdata1,a3		; fig. plane 1
	lea	gfxdata2,a4		; fig. plane 2

	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir werden es später erklären
	move.w	#38,$66(a5)		; BLTDMOD (40-2=38), tatsächlich alle
					; "Kacheln" sind 16 Pixel breit,
					; das sind 2 Bytes, die wir entfernen müssen
					; auf die gesamte Breite einer Zeile,
					; das ist 40, und das Ergebnis ist 40-2 = 38!
	move.w	#$0000,$42(a5)		; BLTCON1 - wir werden es später erklären
	move.w	#$09f0,$40(a5)		; BLTCON0 (Kanal A+D)

	moveq	#16-1,d7	; 16 Kacheln um am Ende 
					; anzukommen, tatsächlich
					; die Kacheln sind 15 Pixel hoch,
					; 1 Pixel "Abstand" zwischen einem und
					; dem Anderen, unter jedem, macht eine
					; Größe von 16 Pixeln pro Kachel,
					; deshalb 256/16 = 16 Kacheln.
FaiTutteLeRighe:
	moveq	#20-1,d6	; 20 Blöcke pro Zeile, tatsächlich
					; die Kacheln sind 16 Pixel breit,
					; das sind 2 Bytes, leitet es ab
					; für eine horizontale Zeile
					; sind das 320/16 = 20
FaiUnaRigaLoop:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2	; Warte auf Zeile = $108
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile = $108
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile = $108
	Beq.S	Waity2

; Blittet die erste Bitebene einer Kachel

	move.l	a0,$54(a5)		; BLTDPT - Ziel (bitpl 1)
	move.l	a3,$50(a5)		; BLTAPT - Quelle (fig1)
	move.w	#(15*64)+1,$58(a5)	; BLTSIZE - Höhe 15 Zeilen,
					; 1 Wortbreite
					; Um die erste Bitplane zu machen

	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

; Blittet die zweite Bitebene einer Kachel

	move.l	a1,$54(a5)		; BLTDPT - Ziel (bitpl 2)
	move.l	a4,$50(a5)		; BLTAPT - Quelle (fig2)
	move.w	#(15*64)+1,$58(a5)	; BLTSIZE - Höhe 15 Zeilen,
					; 1 Wortbreite
					; Um die zweite Bitplane zu machen

	btst	#6,2(a5) ; dmaconr
WBlit3:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit3

	addq.w	#2,a0	; Überspringt 1 Wort (16 Pixel) in der Bitebene 1,
					; in "vorwärts" für die nächste Kachel
	addq.w	#2,a1	; Überspringt 1 Wort (16 Pixel) in der Bitebene 2
	dbra	d6,FaiUnaRigaLoop	; und Schleife bis alle fertig
				; Blittet alle 20 Kacheln
				; einer Zeile.
 
	lea	15*40(a0),a0	; überspringt 15 Zeilen in der Bitebene 1.
				; Wir haben a0 bereits mit addq #2,a0 (in jeder 
				; Schleife) erhöht und haben bereits eine Zeile 
				; übersprungen bevor Sie hier angekommen sind.
				; Daher werden 16 Zeilen übersprungen und haben
				; zwischen einer Kachel und der anderen einen 
				; "Streifen" Hintergrund, da die Fliesen
				; nur 15 Pixel hoch sind.
	lea	15*40(a1),a1	; Überspringt 15 Zeilen in der Bitebene 2
	dbra	d7,FaiTutteLeRighe	; mache alle 16 Zeilen

 	rts	

;******************************************************************************

		section	cop,data_C

copperlist
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w $100,$2200		; BPLCON0 - 2 bitplanes lowres

	dc.w $180,$000		; Color0
	dc.w $182,$FED		; Color1
	dc.w $184,$33a		; Color2
	dc.w $186,$888		; Color3

BPLPOINTER1:
	dc.w $e0,0,$e2,0	; erste bitplane
BPLPOINTER2:
	dc.w $e4,0,$e6,0	; zweite bitplane

	dc.l	$ffff,$fffe	; Ende copperlist

******************************************************************************

;	Abbildung, bestehend aus 2 Doppeldeckern. Breite = 1 Wort, Höhe = 15 Zeilen

gfxdata1:
	dc.w	%1111111111111100
	dc.w	%1111111111111100
	dc.w	%1100000000001100
	dc.w	%1101111111111100
	dc.w	%1101111111111100
	dc.w	%1101111111011100
	dc.w	%1101110011011100
	dc.w	%1101110111011100
	dc.w	%1101111111011100
	dc.w	%1101111111011100
	dc.w	%1101100000011100
	dc.w	%1101111111111100
	dc.w	%1111111111111100
	dc.w	%1111111111111100
	dc.w	%0000000000000000

gfxdata2:
	dc.w	%0000000000000010
	dc.w	%0111111111111110
	dc.w	%0111111111110110
	dc.w	%0111111111110110
	dc.w	%0111000000010110
	dc.w	%0111011111110110
	dc.w	%0111011101110110
	dc.w	%0111011101110110
	dc.w	%0111010001110110
	dc.w	%0111011111110110
	dc.w	%0111011111110110
	dc.w	%0111111111110110
	dc.w	%0100000000000110
	dc.w	%0111111111111110
	dc.w	%1111111111111110

;******************************************************************************

	section	gnippi,bss_C

bitplane1:
		ds.b	40*256
bitplane2:
		ds.b	40*256

	end

;******************************************************************************

Dieses Beispiel ist eine Variation des Beispiels lesson9c2.s. Diesmal haben
wir einen 2-Ebenen Bildschirm. Sogar unsere Fliesen bestehen aus 2 Ebenen.
Die Routine, die das "Tiling" des Bildschirms ausführt, hat die gleiche
Struktur wie die im Beispiel lesson9c2.s, nur dass 2 Kopien ausgeführt werden:
Die erste Bitebene der Kachel auf der ersten Bitebene des Bildschirms und
die zweite Bitebene der Kachel auf der zweiten Bitebene des Bildschirms.
Um es noch interessanter zu machen, haben wir die Routine verlangsamt durch
das Setzen einer Warteschleife mittels des vertikalen Blank.
Auf diese Weise werden die Kacheln in jeden vertikal Blank kopiert. Sie können 
die Reihenfolge, wie die Kacheln kopiert werden mit dem Auge beobachten.
