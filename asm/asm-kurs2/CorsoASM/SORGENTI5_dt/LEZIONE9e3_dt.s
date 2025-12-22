
; Lezione9e3.s	Komplette horizontale Verschiebung mit Shift + Änderung von
				; Ort des Ziels (2 Bytes Aufnahme = 16 Pixel)

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

	moveq	#0,d1			; Horizontale Koordinate bei 0
	move.w	#(320-32)-1,d7	; Es bewegt sich um 320 Pixel Minus die Breite
							; vom BOB, um sicherzustellen das 
							; sein erstes Pixel auf der linken Seite ist
							; Stoppen Sie, wenn der BOB am Ende 
							; des Bildschirms rechts ankommt.
Loop:
	cmp.b	#$ff,$6(a5)	; VHPOSR - Warte auf Zeile $ff
	bne.s	loop
Aspetta:
	cmp.b	#$ff,$6(a5)	; noch Zeile $ff?
	beq.s	Aspetta

;	  \\ ,\\  /, ,,//
;	   \\\\\X///////
;	    \¬¯___  __/
;	   _;=(  ©)(®_)
;	  (, _ ¯T¯  \¬\
;	   T /\ '   ,)/
;	   |('/\_____/__
;	   l_¯         ¬\
;	    _T¯¯¯T¯¯¯¯¯¯¯
;	 /¯¯¬l___¦¯¯¬\
;	/___,  °  ,___\
;	¯/¯/¯  °__T\¬\¯
;	(  \___/ '\ \ \
;	 \_________) \ \
;	    l_____ \  \ \
;	    / ___¬T¯   \ \
;	   / _/ \ l_    ) \
;	   \ ¬\  \  \  ())))
;	  __\__\  \  )  ¯¯¯
;	 (______)  \/\ xCz
;	           / /
;	          (_/

	lea	bitplane,a0		; Ziel in a0
	move.w	d1,d0
	and.w	#$000f,d0	; Sie wählen die ersten 4 Bits aus, weil sie 
						; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0		; Die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d0		; des Wortes ... (8 + 4 = 12-Bit-Verschiebung)
	or.w	#$09f0,d0	; ...Rechts, das BLTCON0-Register einzugeben				
				; Hier setzen wir $f0 in den Minterm für die Kopie von
				; Quelle A nach Ziel D und aktivieren
				; offensichtlich die A + D Kanäle mit $0900 (Bit 8
				; für D und 11 für A). Das ist $09f0 + Verschiebung.
	move.w	d1,d2
	lsr.w	#3,d2		; (entspricht einer Division durch 8)
				; Runden auf ein Vielfaches von 8 für den Zeiger
				; auf den Bildschirm, also auf ungerade Adressen
				; (also auch für Bytes)
				; zB: eine 16 als Koordinate wird zu 2 Bytes
	and.w	#$fffe,d2	; Ich schließe Bit 0 aus
	add.w	d2,a0		; Summe an der Bitebene Adresse, 
						; um die richtige Zieladresse zu finden
	addq.w	#1,d1		; Füge 1 zur horizontalen Koordinate hinzu

	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

; Jetzt, wie in der Theorie erklärt, nutzen wir die Gelegenheit.
; Wir schreiben die Werte in zusammenliegende Register mit einem einzigen 'move.l'

	move.l	#$01000000,$40(a5)	; BLTCON0 + BLTCON1
	move.w	#$0000,$66(a5)
	move.l	#bitplane,$54(a5)
	move.w	#(64*256)+20,$58(a5)	; versuche diese Zeile zu entfernen
					; und der Bildschirm wird nicht sauber sein,
					; damit der Fisch die "Spur" verlässt

	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir werden es später erklären
	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	#$0000,$42(a5)		; BLTCON1 (wir werden es später erklären)
	move.l	#$00000024,$64(a5)	; BLTAMOD (=0) + BLTDMOD (=40-4=36=$24)
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirmzeilen)
	move.w	#(64*6)+2,$58(a5)	; BLTSIZE (Bitter starten !)
					; wir blitten 2 Wörter, dem zweiten Wort ist 
					; die Verschiebung nicht zu erlauben					

	btst	#6,$bfe001		; linke Mausetaste gedrückt?
	beq.s	quit

	dbra	d7,loop

Quit:
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

	dc.w	$100,$1200	; BplCon0 - 1 bitplane LowRes

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$eee	; color1
	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

; der kleine Fisch:

Figura:
	dc.w	%1000001111100000,0
	dc.w	%1100111111111000,0
	dc.w	%1111111111101100,0
	dc.w	%1111111111111110,0
	dc.w	%1100111111111000,0
	dc.w	%1000001111100000,0

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C	

BITPLANE:
	ds.b	40*256		; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel verschieben wir unsere Figur um eine beliebige 
Anzahl von Pixeln. Die horizontale Koordinate der Figur ist in D1 
gespeichert. Diese Koordinate wird durch 8 geteilt, um die Speicher-
adresse des Wortes zu berechnen zu dem es gehört. Die 4 Bits der 
Koordinate, sie sind der Wert der Verschiebung, wie in der Lektion erklärt.
