
; Lezione10c1.s	BLITTATA, in dem wir die Maske einer Zeichnung aufbauen
		; abwechselnd die Maustasten, um die Blittings zu sehen

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE1,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#3-1,D1			; Anzahl der Bitplanes
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0	; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

; kopiere das Bild normal

	lea	FiguraPlane1,a0		; Kopiere die erste Bitplane
	lea	BITPLANE1,a1
	bsr.s	copia

	lea	FiguraPlane2,a0		; Kopiere die zweite Bitplane
	lea	BITPLANE2,a1
	bsr.s	copia

	lea	FiguraPlane3,a0		; Kopiere die dritte Bitplane
	lea	BITPLANE3,a1
	bsr.s	copia

mouse1:
	btst	#2,$dff016	; rechte Maustaste gedrückt?
	bne.s	mouse1

; Kopie erste Bitebene 

	lea	FiguraPlane1,a0
	lea	BITPLANE1+14,a1
	bsr.s	BlitOR		; führt ein ODER zwischen der Ebene 1 der Figur
						; und dem Ziel (leer) durch

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

	lea	FiguraPlane2,a0
	lea	BITPLANE1+14,a1
	bsr.s	BlitOR		; führt ein ODER zwischen der Ebene 2 der Figur 
						; und dem Ziel (Ebene 1 der Figur) durch
mouse3:
	btst	#2,$dff016	; rechte Maustaste gedrückt?
	bne.s	mouse3

	lea	FiguraPlane3,a0
	lea	BITPLANE1+14,a1
	bsr.s	BlitOR		; führt ein ODER zwischen der Ebene 3 der Figur 
						; und dem Ziel (Ebene 1 ODER 2 der Figur) durch
mouse4:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse4
	rts

;****************************************************************************
; Diese Routine kopiert die Figur auf dem Bildschirm.
;
; A0 - Quelladresse
; A1 - Zieladresse
;****************************************************************************

Copia:
	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$ffffffff,$44(a5)	; Maske
	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 (A+D)
							; normale Kopie
	move.w	#0,$64(a5)		; BLTAMOD (=0)
	move.w	#34,$66(a5)		; BLTDMOD (40-6=34)
	move.l	a0,$50(a5)		; BLTAPT  Zeiger Quelle
	move.l	a1,$54(a5)		; BLTDPT  Zeiger Ziel
	move.w	#(64*42)+3,$58(a5)	; BLTSIZE (Blitter starten !)
					; Breite 3 word
	rts				; Höhe 42 Zeilen

;****************************************************************************
; Diese Routine führt ein ODER zwischen der Quelle und dem Ziel durch.
; Verwenden Sie die Kanäle B, C und D. Die Quelle wird über Kanal C gelesen.
; Stattdessen wird das Ziel von Kanal B gelesen und dann von D neu geschrieben.
; Folglich haben die Kanäle B und D beim Start das gleiche Modulo und die 
; gleichen Adressen.
;
; Parameter:
;
; A0 - Adresse Quelle
; A1 - Adresse Ziel
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
	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$07EE0000,$40(a5)	; BLTCON0 und BLTCON1
					; führt ein OR zwischen B und C aus
					; D=B OR C
	move.w	#0,$60(a5)		; BLTCMOD (=0)
	move.w	#34,$66(a5)		; BLTDMOD (40-6=34)
	move.w	#34,$62(a5)		; BLTBMOD (40-6=34)
	move.l	a0,$48(a5)		; BLTCPT  Zeiger Quelle
	move.l	a1,$4c(a5)		; BLTBPT  Zeiger Ziel
	move.l	a1,$54(a5)		; BLTDPT  Zeiger Ziel
	move.w	#(64*42)+3,$58(a5)	; BLTSIZE (Blitter starten !)
					; Breite 3 word
	rts				; Höhe 42 Zeilen

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$3200	; bplcon0

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000

	dc.w	$180,$000	; color0
	dc.w	$182,$aaa	; color1
	dc.w	$184,$b00	; color2
	dc.w	$186,$080	; color3
	dc.w	$188,$24c
	dc.w	$18a,$eb0
	dc.w	$18c,$b52
	dc.w	$18e,$0cc

	dc.w	$FFFF,$FFFE	; Ende copperlist

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

	end

;****************************************************************************

In diesem Beispiel erstellen wir die Maske einer Figur mit dem Blitter, das ist 
sein "Schatten". Um dies zu tun, ist es notwendig, ein ODER zwischen den Bits 
der Ebenen der Figur durchzuführen. In diesem Beispiel führen wir diese Operation 
ein Schritt nach dem anderen aus. Zuerst machen wir das ODER zwischen der ersten 
Bitebene der Figur und dem Ziel, in dem wir die Maske zeichnen werden.
Da das Ziel zu Beginn leer ist, entspricht dieser Schritt einer einfachen Kopie 
der ersten Ebene der Figur. Als zweiten Schritt führen wir das ODER zwischen der 
zweiten Ebene und dem Ziel durch. Das Ziel enthält die erste Ebene. In der Praxis 
führen wir ein OR zwischen der Ebene 1 und der Ebene 2 aus. Als dritten Schritt
führen wir das ODER zwischen der Ebene 3 und dem Ziel durch.  Das Ziel enthält 
das OR von Ebene 1 und Ebene 2. Als Ergebnis erhalten wir das OR aller 3 Ebenen. 
Wenn wir eine Figur mit mehr als 3 Ebenen hätten, hätten wir das gleiche Verfahren
auch für die anderen Bitplanes wiederholen müssen.
Der Blitt wird mit 3 Kanälen gemacht. Die Ebenen der Figur werden durch den 
Kanal C gelesen, stattdessen wird das Ziel durch den Kanal B gelesen und dann
über den Kanal D neu geschrieben. Der Wert von LF wird berechnet für
das ODER der Kanäle B und C.