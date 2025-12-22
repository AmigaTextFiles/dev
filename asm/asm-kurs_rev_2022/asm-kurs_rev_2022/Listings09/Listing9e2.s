
; Listing9e2.s		SHIFTING mit 2-Word-breitem-Objekt (ein Null-Wort)

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

	move.w	#$ffff,$44(a5)		; BLTAFWM wir erklären es später
	move.w	#$ffff,$46(a5)		; BLTALWM wir erklären es später
	move.w	d5,$40(a5)			; BLTCON0 (A+D) - im Register
								; setzen wir die Shiftbits! (Bits 12,13
								; 14 und 15, d.h. High Nibble!)
	move.w	#$0000,$42(a5)		; BLTCON1 wir erklären es später
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#36,$66(a5)			; BLTDMOD (40-4=36)
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	#bitplane,$54(a5)	; BLTDPT  (Bildschirm)
	move.w	#(64*6)+2,$58(a5)	; BLTSIZE (Blitter starten !)
								; wir blitten 2 Wörter, aber da das zweite
								; Word auf Null gesetzt ist, wird hier "nichts"
								; in die Bitplane geschrieben
											 
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

; Hier ist der Fisch ... diesmal haben wir ein zweites Wort für jede Zeile auf
; Null gesetzt
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
	ds.b	40*256				; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel bewegen wir eine Figur jeweils um einen Pixel nach rechts
mit der Verschiebung, mit einem Nullwort rechts von jeder Zeile. Es verbessert
den Effekt im Vergleich zu Listing9e1.s.

Da wir die Zieladresse nicht erhöhen, bewegt sich die Figur nur mit dem 
Blitter-Shifter. Auf diese Weise ist es möglich, bis zu 15 Pixel zu bewegen. 
Die 15 ist der maximal mögliche Verschiebungswert.
Nach Erreichen von 15 kehrt der Verschiebungswert zum Wert 0 zurück. (Wir
erhalten das, indem die 4 Bits als die Position der Figur genommen werden.)
Die Figur kehrt in die Ausgangsposition zurück, um sich wieder zu bewegen.
Um einen "richtigen" Bildlauf zu bekommen, werden alle 15 Scrollpixel genutzt
und anschließend muss das Bild einen Shift von 16 Pixeln auslösen indem man
2 zum Ziel addiert und mit dem Shiften bei Null wieder beginnt.
Dies ist so ähnlich wie wir es mit dem Scroll mit BPLCON1 ($dff102) und den
bplpointers in der Copperliste gesehen haben.
