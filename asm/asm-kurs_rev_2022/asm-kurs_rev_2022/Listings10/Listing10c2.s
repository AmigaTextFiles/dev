
; Listing10c2.s		BLITT, in dem wir die Maske einer Zeichnung aufbauen
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
	MOVEQ	#3-1,D1				; Anzahl der Bitplanes
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

; kopiere das Bild normal

	lea	FiguraPlane1,a0			; Kopiere die erste Bitplane
	lea	BITPLANE1,a1
	bsr.s	copia

	lea	FiguraPlane2,a0			; Kopiere die zweite Bitplane
	lea	BITPLANE2,a1
	bsr.s	copia

	lea	FiguraPlane3,a0			; Kopiere die dritte Bitplane
	lea	BITPLANE3,a1
	bsr.s	copia

mouse1:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1				; wenn nicht, gehe zurück zu mouse1:

; ODER aller Bitebenen

	lea	FiguraPlane1,a0
	lea	FiguraPlane2,a1
	lea	FiguraPlane3,a2
	lea	BITPLANE1+14,a3
	bsr.s	BlitOR				; führt ein ODER zwischen den Ebenen der Figur durch
								; und kopiert das Ergebnis

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; wenn nicht, gehe zurück zu mouse2:
	rts

;****************************************************************************
; Diese Routine kopiert die Figur auf dem Bildschirm.
;
; A0 - Quelladresse
; A1 - Zieladresse
;****************************************************************************

Copia:
	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$ffffffff,$44(a5)	; Maske
	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 (A+D)
								; normale Kopie
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#34,$66(a5)			; BLTDMOD (40-6=34)
	move.l	a0,$50(a5)			; BLTAPT  Zeiger Quelle
	move.l	a1,$54(a5)			; BLTDPT  Zeiger Ziel
	move.w	#(64*42)+3,$58(a5)	; BLTSIZE (Blitter starten !)
								; Breite 3 word, Höhe 42 Zeilen
	rts	

;****************************************************************************
; Diese Routine führt ein ODER zwischen den 3 Kanälen A, B und C durch.
;
; A0 - Adresse Kanal A
; A1 - Adresse Kanal B
; A2 - Adresse Kanal C
; A3 - Adresse Ziel
;****************************************************************************

;	                 _____
;	                (_____)
;	                  ,,,
;	 __n____________.|o o|.____________n__
;	== _o_|         |  -  |         |_o_ ==
;	 ¯¯ . |   ____  |\ O /|  ____   |   ¯¯
;	      |__/    \ ||`*'|| /    \_#| :
;	    :         | ||   || |      `:
;	    .         |#._______|         .
;	              ! |  o  |
;	                (     )
;	                |  U  |
;	                :  !  :

BlitOR:
	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$FFFFFFFF,$44(a5)	; BLTFWM und BLTLWM
	move.l	#$0FFE0000,$40(a5)	; BLTCON0 und BLTCON1
								; Aktiviere alle Kanäle
								; führt ein OR zwischen A, B und C aus
								; D=A OR B OR C
	move.w	#0,$60(a5)			; BLTCMOD (=0)
	move.w	#0,$62(a5)			; BLTBMOD (=0)
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#34,$66(a5)			; BLTDMOD (40-6=34)
	move.l	a0,$48(a5)			; BLTCPT  Zeiger Quelle
	move.l	a1,$4c(a5)			; BLTBPT  Zeiger Quelle
	move.l	a2,$50(a5)			; BLTAPT  Zeiger Quelle
	move.l	a3,$54(a5)			; BLTDPT  Zeiger Ziel
	move.w	#(64*42)+3,$58(a5)	; BLTSIZE (Blitter starten!)
								; Breite 3 word, Höhe 42 Zeilen
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

	dc.w	$100,$3200			; bplcon0

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$180,$000			; color0
	dc.w	$182,$aaa			; color1
	dc.w	$184,$b00			; color2
	dc.w	$186,$080			; color3
	dc.w	$188,$24c
	dc.w	$18a,$eb0
	dc.w	$18c,$b52
	dc.w	$18e,$0cc

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Das ist die Figur

FiguraPlane1:
	dc.l	$ffffc000,$ffff,$c0000000,$ffffc000,$ffff,$c0000000
	dc.l	$ffffc000,$ffff,$c0000000,$ffffc000,$ffff,$c0000000
	dc.l	$ffffc000,$ffff,$c0000000,$ffffc000,$ffff,$c0000000
	dc.l	$ffffc000,$ffff,$c0000000,$ffffc000,$ffff,$c0000000
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0,0,0,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,0

FiguraPlane2:
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,$3fffff80
	dc.l	$3fff,$ff800000,$3fffff80,$3fff,$ff800000,0
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0

FiguraPlane3:
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0,0,0,0
	dc.l	0,0,0,0,0,0
	dc.l	$ffffc000,$ffff,$c0000000,$ffffc000,$ffff,$c0000000
	dc.l	$ffffc000,$ffff,$c0000000,$ffffc000,$ffff,$ffffff80
	dc.l	$ffffffff,$ff80ffff,$ffffff80,$ffffffff,$ff80ffff,$ffffff80
	dc.l	$f000ffff,$ff80f000,$ffffff80,$f000ffff,$ff80f000,$ffffff80
	dc.l	$f000ffff,$ff80f000,$ffffff80,$f000ffff,$ff80f000,$ffffff80
	dc.l	$f000ffff,$ff80f000,$ffffff80,$f000ffff,$ff80f000,$ffffff80
	dc.l	$ffffffff,$ff800000,0

;****************************************************************************

	SECTION	bitplane,BSS_C

BITPLANE1:
	ds.b	40*256
BITPLANE2:
	ds.b	40*256
BITPLANE3:
	ds.b	40*256

;****************************************************************************

	end

In diesem Beispiel erstellen wir die Maske einer Figur mit dem Blitter. Wir 
verwenden dabei eine andere Technik, als die im Listing10c1.s. Dieses Mal
führen wir tatsächlich nur einen Blitt aus, indem wir alle Kanäle benutzen. Da
unsere Figur 3 Bitebenen hat, können wir sie gleichzeitig durch die Kanäle
A, B und C über das OR lesen und durch Kanal D schreiben.
Dies ist das erste Beispiel, in welchem wir alle Blitter-Kanäle gleichzeitig
aktivieren. Beachten Sie, dass die Bits 8 bis 11 von BLTCON0 tatsächlich alle
auf 1 gesetzt sind. Der Wert von LF wird auf die übliche Weise berechnet. Die
Einstellung wird vorgenommen für alle Minterme, die den Eingangskombinationen 
A = 1 oder B = 1 oder C = 1 entsprechen. Natürlich sind dies 7 Kombinationen.
Die einzige, die nicht enthalten ist, ist diejenige mit A = 0, B = 0 und C = 0.
Beachten Sie, dass diese Technik, anders als im Listing10c1.s nur angewendet 
werden kann, wenn die Figur 3 Bitebenen hat.