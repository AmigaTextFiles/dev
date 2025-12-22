
; Lezione9i1.s	Fisch nochmal! Aber noch schlauer!

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:
;	Zeiger auf das "leere" Bild 

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

	moveq	#0,d1			; horizontale Koordinate bei 0
	move.w	#(320-32)-1,d7	; bewegt sich um die Breite von 320 Pixel 			
					; um das sicherzustellen ist das erste Pixel
					; des BOB auf der linken Seite
					; Stoppen Sie es, wenn es rechts 
					; am Ende des Bildschirms ankommt.
Loop:
	cmp.b	#$ff,$6(a5)	; VHPOSR - warte auf die Zeile $ff
	bne.s	loop
Aspetta:
	cmp.b	#$ff,$6(a5)	; noch Zeile $ff?
	beq.s	Aspetta

;	 _____________
;	 \____ _ ____/
;	(¯T¯¯(·X.)¯¯T¯)
;	 ¯T _ ¯u¯ _ T¯
;	 _| `-^---' |_
;	|¬|   ¯¯¯   |¬|
;	| l_________| |
;	|__l `-o-' |__|
;	(__)       (__)
;	  T_________T
;	   T¯  _  ¯T xCz
;	 __l___l___l__
;	(______X______)

	lea	bitplane,a0		; Ziel in a0
	move.w	d1,d0
	and.w	#$000f,d0	; Sie wählen die ersten 4 Bits, weil sie in
						; den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0		; Die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d0		; des Wortes...
	or.w	#$09f0,d0	; ... nur um in das Register BLTCON0 zu kommen
	move.w	d1,d2
	lsr.w	#3,d2		; (entspricht einer Division durch 8)
						; Runden auf ein Vielfaches von 8 für den Zeiger
						; auf den Bildschirm, also auf ungerade Adressen
						; (also auch für Bytes, also)
						; zB: eine 16 als Koordinate wird zu
						; Bytes 2
	and.w	#$fffe,d2	; Ich schließe Bit 0 aus
	add.w	d2,a0		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse
	addq.w	#1,d1		; addiere 1 zur horizontalen Koordinate

	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

; Jetzt, wie in der Theorie erklärt, nutzen wir die Gelegenheit, Werte 
; mit einem einzigen 'move.l' in zusammenhängende Register zu schreiben

	move.l	#$01000000,$40(a5)	; BLTCON0 + BLTCON1
	move.w	#$0000,$66(a5)		; BLTDMOD
	move.l	#bitplane,$54(a5)	; BLTDPT
	move.w	#(64*256)+20,$58(a5)	; versuche diese Zeile zu entfernen
							; und der Bildschirm wird nicht sauber sein,
							; damit der Fisch die "Spur" verlässt

	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffff0000,$44(a5)	; BLTAFWM = $ffff Es passiert alles
					; BLTALWM = $0000 setzt das letzte Wort zurück

	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	#$0000,$42(a5)		; BLTCON1 (kein Spezialmodi)
	move.l	#$fffe0024,$64(a5)	; BLTAMOD=$fffe=-2 komm zurück					
					; an den Anfang der Zeile.
					; BLTDMOD = 40-4 = 36 =  $24 wie üblich
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirmzeilen)
	move.w	#(64*6)+2,$58(a5)	; BLTSIZE (startet Blitter !)
					; wir blitten 2 Wörter, das zweite Word
					; wird von der Maske zurückgesetzt
					; um die Verschiebung zu ermöglichen

	btst	#6,$bfe001		; linke Maustaste gedrückt?
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

; Der kleine Fisch: diesmal merken wir uns nur die Wörter, die uns interessieren
; Das Wort null wird von der Maske erzeugt.

Figura:
	dc.w	%1000001111100000
	dc.w	%1100111111111000
	dc.w	%1111111111101100
	dc.w	%1111111111111110
	dc.w	%1100111111111000
	dc.w	%1000001111100000

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C	

BITPLANE:
	ds.b	40*256		; bitplane lowres

	end

;****************************************************************************

Dieses Beispiel ist eine Modifikation des Beispiels lesson9e3.s, 
das wir in der Lektion erklärt haben. Es ermöglicht uns, die 
Verschwendung von Speicher für eine zusätzliche Wortspalte zu vermeiden.
Tatsächlich ist unsere Figur nur ein Word breit. Nichtsdestotrotz machen
wir 2 Wörter große Blittings. Durch das Zurücksetzen des zweiten Wortes
(das letzte Wort der Zeile) mit BLTALWM auf den Wert $0000.
Dann haben wir das Problem, dass der Quellzeiger (Kanal A) ja ein Wort 
zu viel verschiebt. Legen Sie das Modulo (BLTAMOD) auf den Wert 
$fffe = -2 fest, um es zurück zur Quelle zu bekommen.

