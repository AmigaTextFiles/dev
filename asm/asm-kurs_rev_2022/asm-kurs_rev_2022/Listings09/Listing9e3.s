
; Listing9e3.s		Komplette horizontale Verschiebung mit Shift + Änderung des
				; Ziels (um 2 Bytes = 16 Pixel)

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

	moveq	#0,d1				; Horizontale Koordinate startet mit 0
	move.w	#(320-32)-1,d7		; Es bewegt sich um 320 Pixel Minus die Breite
								; vom BOB, um sicherzustellen das 
								; sein erstes Pixel auf der linken Seite ist
								; Wir stoppen, wenn der BOB am Ende 
								; des Bildschirms rechts ankommt.
Loop:
	cmp.b	#$ff,$6(a5)			; VHPOSR - Warte auf Zeile $ff
	bne.s	loop
Aspetta:
	cmp.b	#$ff,$6(a5)			; noch Zeile $ff?
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

	lea	bitplane,a0				; Ziel in a0
	move.w	d1,d0
	and.w	#$000f,d0			; wir wählen die ersten 4 Bits aus, weil sie 
								; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0				; die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d0				; des Wortes ... (8 + 4 = 12-Bit-Verschiebung)
	or.w	#$09f0,d0			; ... nur um in das BLTCON0-Register zu kommen				
								; Hier setzen wir $f0 in den Minterm für die Kopie von
								; Quelle A nach Ziel D und aktivieren
								; natürlich die A + D Kanäle mit $0900 (Bit 8
								; für D und Bit 11 für A). Das ist $09f0 + Verschiebung.
	move.w	d1,d2
	lsr.w	#3,d2				; (entspricht einer Division durch 8)
								; Runden auf ein Vielfaches von 8 für den Zeiger
								; auf den Bildschirm, also auch auf ungerade Adressen
								; (also zu Bytes)
								; zB: eine 16 als Koordinate wird zu Byte 2
	and.w	#$fffe,d2			; Ich schließe Bit 0 aus
								; AdÜ: oder anders geschrieben:
	;lsr.w	#4,d2				; dividiert durch 16 (Word)
	;lsl.w	#1,d2				; und multipliziert * 2 (Byte)
	add.w	d2,a0				; addieren zur Adresse der Bitebene, 
								; um die richtige Zieladresse zu finden
	addq.w	#1,d1				; addiere 1 zur horizontalen Koordinate

	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

; Jetzt, wie in der Theorie erklärt, nutzen wir die Gelegenheit, Werte 
; mit einem einzigen 'move.l' in zusammenhängende Register zu schreiben

	move.l	#$01000000,$40(a5)	; BLTCON0 + BLTCON1
	move.w	#$0000,$66(a5)		; BLTDMOD (=0)
	move.l	#bitplane,$54(a5)	; BLTDPT
	move.w	#(64*6)+20,$58(a5)	; wenn sie diese Zeile entfernen wird
								; der Bildschirm nicht sauber sein,
								; damit der Fisch keine "Spur" zieht

	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir werden es später erklären
	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	#$0000,$42(a5)		; BLTCON1 (wir werden es später erklären)
	move.l	#$00000024,$64(a5)	; BLTAMOD (=0) + BLTDMOD (=40-4=36=$24)
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirm)
	move.w	#(64*6)+2,$58(a5)	; BLTSIZE (Bitter starten !)
								; wir blitten 2 Wörter, aber da das zweite
								; Word auf Null gesetzt ist, wird hier "nichts"
								; in die Bitplane geschrieben				

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	beq.s	quit

	dbra	d7,loop

Quit:
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

	dc.w	$100,$1200			; BplCon0 - 1 bitplane LowRes

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$eee			; color1
	dc.w	$FFFF,$FFFE			; Ende copperlist

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
	ds.b	40*256				; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel verschieben wir unsere Figur um eine beliebige Anzahl von
Pixeln. Die horizontale Koordinate der Figur ist in d1 gespeichert. Diese
Koordinate wird durch 8 geteilt, um die Speicheradresse des Wortes zu berechnen
zu dem es gehört. Die 4 Bits der Koordinate, sie sind der Wert der
Verschiebung, wie in der Lektion erklärt.
