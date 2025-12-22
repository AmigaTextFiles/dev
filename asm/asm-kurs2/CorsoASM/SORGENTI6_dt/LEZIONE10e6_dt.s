
; Lezione10e6.s	 Optimierte Version von lesson10c4.s (Reflektoreffekt)
		; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE1,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#5-1,D1			; Anzahl der Bitplanes (hier sind es 5)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0		; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5			; CUSTOM REGISTER in a5

; hier wird der Blitter definitiv gestoppt, weil er das Startup zur Verfügung 
; gestellt bekommen hat, so können wir die Register leicht einstellen.
; Die folgenden Register werden daher immer mit den gleichen Werten verwendet
; Wir initialisieren sie zu Beginn des Programms ein für allemal.

	move.l	#$ffffffff,$44(a5)	; BLTAFWM/BLTALWM
	move.w	#$0000,$42(a5)		; BLTCON1 Modus ascending
	move.l	#$00200000,$62(a5)	; BLTBMOD (40-8=32=$20)
								; BLTAMOD (=0)

	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse2:

Loop:
	cmp.b	#$ff,$6(a5)	; VHPOSR - Warte auf Zeile $ff
	bne.s	loop
Aspetta:
	cmp.b	#$ff,$6(a5)	; noch Zeile $ff?
	beq.s	Aspetta

	bsr.s	ClearScreen		; Bildschirm löschen
	bsr.w	SpostaMaschera	; Reflektorposition verschieben
	bsr.s	Riflettore		; Routine Reflektoreffekt

	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

	rts

;***************************************************************************
; Diese Routine löscht den Teil des Bildschirms, der von der Blittata
; betroffen ist
;***************************************************************************

ClearScreen:
	moveq	#5-1,d7			; 5 Bit-planes
	lea	BITPLANE1+100*40,a1	; zu löschende Adresse (plane1)

	move.w	#(64*39)+20,d5	; Wert zum Schreiben in BLTSIZE
			; Wir haben es in D5 zur Optimierung gebracht			

	btst	#6,2(a5) 		; dmaconr
WBlit1a:
	btst	#6,2(a5) 		; warte auf das Ende des Blitters
	bne.s	wblit1a			; vor dem Ändern der Register

	move.w	#$0100,$40(a5)	; BLTCON0 Löschung
	move.w	#$0000,$66(a5)	; BLTDMOD Diese 2 Register werden 
							; mit verschiedenen Werten in der Routine
							; Reflektor verwendet
ClearLoop:
	btst	#6,2(a5) 		; dmaconr
WBlit1b:
	btst	#6,2(a5) 		; warte auf das Ende des Blitters
	bne.s	wblit1b			; vor dem Blitten

	move.l	a1,$54(a5)
	move.w	d5,$58(a5)		; Schreibe BLTSIZE
							; der Wert wurde zuvor
							; in D5 geschrieben

	add.l	#256*40,a1		; nächste Adressebene
	dbra	d7,Clearloop
	rts

;*****************************************************************************
; Diese Routine realisiert den Reflektoreffekt. Eine UND-Operation wird 
; zwischen der Figur und einer Maske ausgeführt
;*****************************************************************************

;	   |\_._/|        |,\__/|        |\__/,|  
;	   | o o |        |  o o|        |o o  |  
;	   (  T  )        (   T )        ( T   )  
;	  .^`-^-'^.      .^`--^'^.      .^`^--'^. 
;	  `.  ;  .'      `.  ;  .'      `.  ;  .' 
;	  | | | | |      | | | | |      | | | | | 
;	 ((_((|))_))    ((_((|))_))    ((_((|))_))

Riflettore:
	moveq	#5-1,d7			; 5 bit-planes
	lea	Figura+40,a0		; Adresse Figur
	lea	BITPLANE1+100*40,a1	; Adresse Ziel

	move.w	MascheraX(PC),d0 ; Reflektorposition
	move.w	d0,d2			; Kopie
	and.w	#$000f,d0		; Sie wählen die ersten 4 Bits, weil sie
							; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0			; Die 4 Bits werden zum High-Nibble 
	lsl.w	#4,d0			; des Wortes bewegt...
	or.w	#$0dc0,d0		; ...  nur um in das BLTCON0-Register zu kommen
							; LF = $C0 (dh UND zwischen A und B)
	lsr.w	#3,d2			; (entspricht einer Division durch 8)
							; Runden auf ein Vielfaches von 8 für den Zeiger
							; auf den Bildschirm, also auf ungerade Adressen
							; (also auch für Bytes, also)
							; x zB: eine 16 als Koordinate wird zum
							; Bytes 2
	and.w	#$fffe,d2		; Ich schließe Bit 0 aus
	add.w	d2,a0			; Summe zur Adresse der Bitebene, Finden
							; der richtigen Zieladresse	
	add.w	d2,a1			; Summe zur Adresse der Bitebene, Finden
							; der richtigen Zieladresse

	move.l	#Maschera,a2	; Wert zum Schreiben in BLTAPT
							; (Maskenzeiger)
							; Wir setzen es in A2 um es zu optimieren							

	move.w	#(64*39)+4,d5	; Wert zum Schreiben in BLTSIZE
							; Wir haben es in D5 zur Optimierung gebracht							

	btst	#6,2(a5) 		; dmaconr
WBlit2a:
	btst	#6,2(a5) 		; warte auf das Ende des Blitters
	bne.s	wblit2a			; vor dem Ändern der Register

	move.w	#32,$66(a5)		; BLTDMOD (40-8=32)
	move.w	d0,$40(a5)		; BLTCON0 Diese 2 Register werden verwendet
							; mit verschiedenen Werten in der Routine
							; ClearScreen
Drawloop:
	btst	#6,2(a5) 		; dmaconr
WBlit2b:
	btst	#6,2(a5) 		; warte auf das Ende des Blitters
	bne.s	wblit2b			; vor dem blitten

	move.l	a2,$50(a5)		; BLTAPT  Zeigermaske
							; der Wert wurde zuvor
							; in A2 geschrieben
	move.l	a0,$4c(a5)		; BLTBPT  Zeiger Figur
	move.l	a1,$54(a5)		; BLTDPT  Zeiger Ziel
	move.w	d5,$58(a5)		; Schreibe BLTSIZE
							; den Wert der zuvor
							; in D5 geschrieben wurde

	add.w	#56*40,a0		; Adresse nächste plane Figur
	add.w	#256*40,a1		; Adresse nächste plane Ziel
	dbra	d7,Drawloop
	rts

;*****************************************************************************
; Diese Routine liest die horizontale Koordinate aus einer Tabelle
; und speichert Sie in der Variable MASCHERAX
;*****************************************************************************

SpostaMaschera:
	ADDQ.L	#2,TABXPOINT		; Zeigen Sie auf das nächste Wort
	MOVE.L	TABXPOINT(PC),A0	; Adresse in langen TABXPOINT enthalten
								; kopiert nach a0
	CMP.L	#FINETABX-2,A0  	; Sind wir beim letzten Wort des TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann weiter
	MOVE.L	#TABX-2,TABXPOINT 	; Beginnen Sie erneut mit dem ersten Wort-2
NOBSTARTX:
	MOVE.W	(A0),MascheraX		; Kopieren Sie den Wert in die Variable
	rts

MascheraX:
		dc.w	0		; aktuelle Positionsmaske
TABXPOINT:
		dc.l	TABX	; Zeiger auf die Tabelle

; Maske Positionstabelle

TABX:
	DC.W	$12,$16,$19,$1D,$21,$25,$28,$2C,$30,$34
	DC.W	$37,$3B,$3F,$43,$46,$4A,$4E,$51,$55,$58
	DC.W	$5C,$60,$63,$67,$6A,$6E,$71,$74,$78,$7B
	DC.W	$7F,$82,$85,$89,$8C,$8F,$92,$95,$98,$9C
	DC.W	$9F,$A2,$A5,$A8,$AA,$AD,$B0,$B3,$B6,$B8
	DC.W	$BB,$BE,$C0,$C3,$C5,$C8,$CA,$CC,$CF,$D1
	DC.W	$D3,$D5,$D8,$DA,$DC,$DE,$E0,$E1,$E3,$E5
	DC.W	$E7,$E8,$EA,$EC,$ED,$EE,$F0,$F1,$F2,$F4
	DC.W	$F5,$F6,$F7,$F8,$F9,$FA,$FB,$FB,$FC,$FD
	DC.W	$FD,$FE,$FE,$FF,$FF,$FF,$100,$100,$100,$100
	DC.W	$100,$100,$100,$100,$FF,$FF,$FF,$FE,$FE,$FD
	DC.W	$FD,$FC,$FB,$FB,$FA,$F9,$F8,$F7,$F6,$F5
	DC.W	$F4,$F2,$F1,$F0,$EE,$ED,$EC,$EA,$E8,$E7
	DC.W	$E5,$E3,$E1,$E0,$DE,$DC,$DA,$D8,$D5,$D3
	DC.W	$D1,$CF,$CC,$CA,$C8,$C5,$C3,$C0,$BE,$BB
	DC.W	$B8,$B6,$B3,$B0,$AD,$AA,$A8,$A5,$A2,$9F
	DC.W	$9C,$98,$95,$92,$8F,$8C,$89,$85,$82,$7F
	DC.W	$7B,$78,$74,$71,$6E,$6A,$67,$63,$60,$5C
	DC.W	$58,$55,$51,$4E,$4A,$46,$43,$3F,$3B,$37
	DC.W	$34,$30,$2C,$28,$25,$21,$1D,$19,$16,$12
FINETABX:

;*****************************************************************************

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

	dc.w	$100,$5200	; bplcon0

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000
	dc.w $ec,$0000,$ee,$0000
	dc.w $f0,$0000,$f2,$0000

Colours:
	dc.w	$180,0,$182,$f10,$184,$f21,$186,$f42
	dc.w	$188,$f53,$18a,$f63,$18c,$f74,$18e,$f85
	dc.w	$190,$f96,$192,$fa6,$194,$fb7,$196,$fb8
	dc.w	$198,$fc9,$19a,$f21,$19c,$f10,$19e,$f00
	dc.w	$1a0,$eff,$1a2,$eff,$1a4,$dff,$1a6,$dff
	dc.w	$1a8,$cff,$1aa,$bef,$1ac,$bef,$1ae,$adf
	dc.w	$1b0,$9df,$1b2,$9cf,$1b4,$8bf,$1b6,$7bf
	dc.w	$1b8,$7af,$1ba,$69f,$1bc,$68f,$1be,$57f

	dc.w	$FFFF,$FFFE	; Ende copperlist

;*****************************************************************************

; Hier ist das Design, 320 Pixel breit, 56 Zeilen hoch und 5 Ebenen

Figura:
	;incbin	lava320*56*5.raw

;*****************************************************************************

; Dies ist die Maske. Es ist eine Figur, die von einer einzelnen Bitebene 
; gebildet wird, 39 Zeilen hoch und 4 Wörter breit

Maschera:
	dc.l	$00007fc0,$00000000,$0003fff8,$00000000,$000ffffe,$00000000
	dc.l	$001fffff,$00000000,$007fffff,$c0000000,$00ffffff,$e0000000
	dc.l	$01ffffff,$f0000000,$03ffffff,$f8000000,$03ffffff,$f8000000
	dc.l	$07ffffff,$fc000000,$0fffffff,$fe000000,$0fffffff,$fe000000
	dc.l	$1fffffff,$ff000000,$1fffffff,$ff000000,$1fffffff,$ff000000
	dc.l	$3fffffff,$ff800000,$3fffffff,$ff800000,$3fffffff,$ff800000
	dc.l	$3fffffff,$ff800000,$3fffffff,$ff800000,$3fffffff,$ff800000
	dc.l	$3fffffff,$ff800000,$3fffffff,$ff800000,$3fffffff,$ff800000
	dc.l	$1fffffff,$ff000000,$1fffffff,$ff000000,$1fffffff,$ff000000
	dc.l	$0fffffff,$fe000000,$0fffffff,$fe000000,$07ffffff,$fc000000
	dc.l	$03ffffff,$f8000000,$03ffffff,$f8000000,$01ffffff,$f0000000
	dc.l	$00ffffff,$e0000000,$007fffff,$c0000000,$001fffff,$00000000
	dc.l	$000ffffe,$00000000,$0003fff8,$00000000,$00007fc0,$00000000
	
;*****************************************************************************

	SECTION	bitplane,BSS_C
BITPLANE1:
	ds.b	40*256
BITPLANE2:
	ds.b	40*256
BITPLANE3:
	ds.b	40*256
BITPLANE4:
	ds.b	40*256
BITPLANE5:
	ds.b	40*256

	end

;*****************************************************************************

Dieses Beispiel ist die optimierte Version von lesson10c4.s. Die Optimierungen
werden im Listing erläutert.

