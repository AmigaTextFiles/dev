
; Lezione10a2.s	BLITTATA, in dem wir eine Zeichnung kopieren, indem wir eine Bitebene invertieren
		; Rechte Taste um den Blitt zu starten, links um zu beenden.

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
	MOVEQ	#2-1,D1			; Anzahl der bitplanes
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

	lea	FiguraPlane1,a0		; kopiere die erste bitplane
	lea	BITPLANE1,a1
	bsr.s	copia

	lea	FiguraPlane2,a0		; kopiere die zweite bitplane
	lea	BITPLANE2,a1
	bsr.s	copia

mouse1:
	btst	#2,$dff016	; rechte Maustaste gedrückt?
	bne.s	mouse1

; Kopieren Sie das Bild, indem Sie die erste Bitebene invertieren

	lea	FiguraPlane1,a0
	lea	BITPLANE1+14,a1
	bsr.s	CopiaInversa	; Kopiere die erste Bitplane, indem du sie umkehrst

	lea	FiguraPlane2,a0
	lea	BITPLANE2+14,a1
	bsr.s	copia			; Kopiere die zweite Bitplane, normal

mouse2:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse2			; Wenn nicht, gehe zurück zu mouse2:
	rts

;****************************************************************************
; Diese Routine kopiert die Figur auf dem Bildschirm.
; Es braucht als Parameter
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
	move.w	#(64*25)+3,$58(a5)	; BLTSIZE (Blitter starten !)
							; Breite 3 word
	rts						; Höhe 25 Zeilen

;****************************************************************************
; Diese Routine kopiert die Figur auf dem Bildschirm, indem sie sie invertiert
; Das heißt, aus 1 wird 0 und aus 0 wird 1.
;
; A0 - Quelladresse
; A1 - Zieladresse
;****************************************************************************

;	               _   _
;	            __/ \_/ \
;	           /  \_ oo_/
;	          /        \/_
;	     ____/_ ___ ____o
;	 ___/      \\  \\ UU

CopiaInversa:
	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; Maske
	move.l	#$090f0000,$40(a5)	; BLTCON0 und BLTCON1
					; kopieren Sie, indem Sie die Bits umkehren
					; D=NOT A
	move.w	#0,$64(a5)		; BLTAMOD (=0)
	move.w	#34,$66(a5)		; BLTDMOD (40-6=34)
	move.l	a0,$50(a5)		; BLTAPT  Zeiger Quelle
	move.l	a1,$54(a5)		; BLTDPT  Zeiger Ziel
	move.w	#(64*25)+3,$58(a5)	; BLTSIZE (Blitter starten !)
							; Breite 3 word
	rts						; Höhe 25 Zeilen

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

	dc.w	$100,$2200	; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000

	dc.w	$0180,$000	; color0
	dc.w	$0182,$aaa	; color1
	dc.w	$0184,$55f	; color2
	dc.w	$0186,$f80	; color3

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

FiguraPlane1:
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$c000,$0000,$0003,$c000
	dc.w	$0000,$0003,$c000,$0000,$0003,$c000,$0000,$0003,$c000,$0000
	dc.w	$0003,$c000,$0000,$0003,$c000,$0000,$0003,$c000,$0000,$0003
	dc.w	$c25c,$3bbb,$bb83,$c354,$22aa,$a283,$c2d4,$22bb,$b303,$c254
	dc.w	$22a2,$2283,$c25c,$3ba2,$3a83,$c000,$0000,$0003,$c000,$0000
	dc.w	$0003,$c000,$0000,$0003,$c000,$0000,$0003,$c000,$0000,$0003
	dc.w	$c000,$0000,$0003,$c000,$0000,$0003,$c000,$0000,$0003,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff

FiguraPlane2:
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
	dc.w	$ffff,$ffff,$ffff,$ffff,$ffff

;****************************************************************************

	SECTION	bitplane,BSS_C
BITPLANE1:
	ds.b	40*256
BITPLANE2:
	ds.b	40*256

	end

;****************************************************************************

In diesem Beispiel sehen wir eine Anwendung der logischen NOT-Operation.
Wir haben eine Zeichnung auf dem Bildschirm, die eine Schaltfläche (Button)
darstellen könnte. Nehmen wir nun an, dass wir denselben Button zeichnen,
aber die Farben invertieren wollen, um den Druck (Klick) zu simulieren.
Eine Methode besteht darin, die Farben in der Copperliste auszutauschen.
Auf diese Weise tauschen sie jedoch die Farben über den Bildschirm aus und 
dann wenn wir 2 Knöpfe gleichzeitig haben wollen, eine mit der normalen 
Farbe und die andere mit der invertierten Farbe, dann ist diese Technik 
nicht gut.
Wir müssen nur die Bitebene ändern, die das Bild bildet. Der Button wird
mit den Farben 2 und 3 gezeichnet. Um die Farben zu wechseln, müssen wir
die Farbe 2 in 3 und umgekehrt verwandeln.
Ein Pixel mit Farbe 2 tritt auf, wenn Ebene 1 auf 0 und Ebene 2 auf 1 
gesetzt ist und die Farbe 3 tritt auf, wenn die Ebene 1 auf 1 und die 
Ebene 2 auf 1 gesetzt ist. Da bei beiden Farben die Ebene 2 auf 1 gesetzt
ist, müssen wir nur die Ebene 1 ändern. Wenn wir in der Ebene 1 sind, 
invertieren wir alle Bits (d.h. wir drehen alle 0 in 1 und alle 1 in 0).
Dann werden wir die Farben 2 und 3 austauschen.
Die Umkehrung der Bits ist die logische NICHT - Operation, die wir mit dem
Blitter durch einen geeigneten Minterm erreichen. Wenn wir Kanal A zum 
Lesen verwenden, müssen wir den Ausgang D immer dann auf 1 setzen, wenn
der Eingang 0 ist und umgekehrt. Dies wird erreicht, indem alle Minterme, 
die den Kombinationen mit A = 0 entsprechen, auf 1 gesetzt werden. Das 
wird (wie Sie aus der Tabelle in der Lektion sehen können) mit LF = $0F 
erreicht.