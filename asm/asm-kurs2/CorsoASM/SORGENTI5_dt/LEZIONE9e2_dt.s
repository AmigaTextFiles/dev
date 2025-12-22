
; Lezione9e2.s		SHIFTING mit 2-Word-Weiten-Objekt (eine Null)

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:
;	Wir zeigen auf das "leere" PIC"

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	moveq	#0,d4			; horizontale Koordinate bei 0
Loop:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2	; Warte auf Zeile = $108
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Linie zu warten $108
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $108
	Beq.S	Waity2
;	            .
;	           .¦.¦:.:¦:.:¦
;	          .;/'____  `;l
;	          ;/ /   ¬\  __\
;	          / /    ° \/o¬\\
;	         /  \______/\__//
;	        / ____       \  \
;	        \ \   \    ,  )  \
;	        /\ \   \_________/
;	       /    \   l_l_|/ /
;	      /    \ \      / /
;	   __/    _/\ \/\__/ /
;	  / ¬`----'¯¯\______/
;	 /  __      __ \
;	/   /        T  \

	move.w	d4,d5	; aktuelle horizontale Koordinate in d5

	and.w	#$000f,d5	; Sie wählen die ersten 4 Bits aus,
						; in den Shifter von Kanal A eingefügt
	lsl.w	#8,d5		; die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d5		; des Wortes ... (8 + 4 = 12-Bit-Verschiebung!)
	or.w	#$09f0,d5	; ... nur um das BLTCON0-Register zu betreten
			; Hier setzen wir $f0 in den Minterm für die Kopie von
			; Quelle A nach Ziel D und aktivieren
			; offensichtlich die A + D Kanäle mit $0900 (Bit 8
			; für D und 11 für A). Das ist $09f0 + Verschiebung.

	addq.w	#1,d4		; Addiere 1 zur horizontalen Koordinate
			; gehe beim nächsten Mal 1 Pixel nach rechts

	move.w	#$ffff,$44(a5)		; BLTAFWM wir erklären es später
	move.w	#$ffff,$46(a5)		; BLTALWM wir erklären es später
	move.w	d5,$40(a5)			; BLTCON0 (A+D) - im Register
								; Wir belegen die Shiftbits! (Bits 12,13
								; 14 und 15, d.h. High Nibble!)
	move.w	#$0000,$42(a5)		; BLTCON1 wir erklären es später
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#36,$66(a5)			; BLTDMOD (40-4=36)
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	#bitplane,$54(a5)	; BLTDPT  (Bildschirmzeilen)
	move.w	#(64*6)+2,$58(a5)	; BLTSIZE (Blitter starten !)
					; wir blitten 2 Wörter, dem zweiten Wort ist 
					; die Verschiebung nicht zu erlauben					 
	btst	#6,$bfe001			; linke Mausetaste gedrückt?
	bne.s	loop

	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	rts

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

	dc.w	$100,$1200

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$eee	; color1

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

; Hier ist der Fisch ... diesmal haben wir ein zweites Wort für jede Zeile auf Null gesetzt
; Maße: 32 * 6

Figura:
	dc.w	%1000001111100000,%000000000000000
	dc.w	%1100111111111000,%000000000000000
	dc.w	%1111111111101100,%000000000000000
	dc.w	%1111111111111110,%000000000000000
	dc.w	%1100111111111000,%000000000000000
	dc.w	%1000001111100000,%000000000000000

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C	

BITPLANE:
	ds.b	40*256		; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel bewegen wir eine Figur jeweils um einen Pixel nach rechts
mit der Verschiebung, mit einem Nullwort rechts von jeder Zeile. Es
verbessert den Effekt im Vergleich zu Lesson9e1.s.

Da wir die Zieladresse nicht erhöhen, bewegt sich die Figur nur mit dem 
Blitter-Shifter. Auf diese Weise ist es möglich, bis zu 15 Pixel zu bewegen. 
Die 15 ist der maximal erlaubte Verschiebungswert.
Nach Erreichen von 15 kehrt der Verschiebungswert zum Wert 0 zurück.
(Wir erhalten das, indem die 4 Bits als die Position der Figur genommen werden.)
Die Figur kehrt in die Ausgangsposition zurück, um sich wieder zu bewegen.
Um einen "ernsten" Bildlauf zu machen, werden alle 15 Scrollpixel damit gewonnen
und anschließend sollte das Bild einen Shift von 16 Pixeln auslösen
indem man 2 zum Ziel und mit dem Shiften bei Null wieder beginnt.
Dies ist so ähnlich wie wir es mit dem Scroll mit bplcon1 ($dff102) und den
bplpointers in der Copperliste gesehen haben.
