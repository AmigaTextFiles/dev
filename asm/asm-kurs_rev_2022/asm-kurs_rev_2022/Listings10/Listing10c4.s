
; Listing10c4.s		Reflektoreffekt
		; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE1,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#5-1,D1				; Anzahl der Bitplanes
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

mouse1:

Loop:
	cmp.b	#$ff,$6(a5)			; VHPOSR - Warte auf Zeile $ff
	bne.s	loop
Aspetta:
	cmp.b	#$ff,$6(a5)			; noch Zeile $ff?
	beq.s	Aspetta

	bsr.s	ClearScreen			; sauberer Bildschirm
	bsr.w	SpostaMaschera		; Reflektorposition verschieben
	bsr.s	Riflettore			; Routine Reflektor

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; wenn nicht, gehe zurück zu mouse1:

	rts

;***************************************************************************
; Diese Routine löscht den Teil des Bildschirms, der vom Blitt betroffen ist
;***************************************************************************

ClearScreen:
	moveq	#5-1,d7				; 5 Bitebenen
	lea	BITPLANE1+100*40,a1		; Adresse Bereich der gelöscht werden soll
								; (ab Bitebene 1)
ClearLoop:
	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$01000000,$40(a5)	; BLTCON0 + BLTCON1 Löschung
	move.w	#$0000,$66(a5)		; BLTDMOD	
	move.l	a1,$54(a5)			; BLTDPT Zeiger Ziel
	move.w	#(64*39)+20,$58(a5)	; BLTSIZE (Blitter starten !)
	add.l	#256*40,a1			; Adresse nächste Bitebene
	dbra	d7,Clearloop
	rts
	
;*****************************************************************************
; Diese Routine realisiert den Reflektoreffekt. Die Operation wird
; durch ein UND zwischen der Figur und einer Maske ausgeführt.
;*****************************************************************************

;	      ___________
;	     /           \
;	    /\            \
;	   / /\____________)____
;	   \/:/\___   ___/\     \
;	    \/ ___ \_/ ___ \     \
;	    ( /  o)   (  o\ )____/
;	     \\__/ /Y\ \__//
;	     (___/(_n_)\___)
;	   __//\ _ _ _ _ /\\__
;	  /==\\_Y Y Y Y Y_//==\
;	 /    `-| | | | |-'    \
;	/       `-^-^-^-'       \

Riflettore:
	moveq	#5-1,d7				; 5 Bitebenen
	lea	Figura+40,a0			; Adresse Figur
	lea	BITPLANE1+100*40,a1		; Adresse Ziel

	move.w	MascheraX(PC),d0	; Reflektorposition
	move.w	d0,d2				; Kopie
	and.w	#$000f,d0			; wir wählen die ersten 4 Bits, weil sie 
								; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0				; Die 4 Bits werden zum High-Nibble 
	lsl.w	#4,d0				; des Wortes bewegt ...
	or.w	#$0dc0,d0			; ... rechts in das BLTCON0-Register einzugeben
								; LF = $C0 (dh UND zwischen A und B)
	lsr.w	#3,d2				; (entspricht einer Division durch 8)
								; Runden auf ein Vielfaches von 8 für den Zeiger
								; auf den Bildschirm, also auch auf ungerade Adressen
								; (also zu Bytes)
								; zB: eine 16 als Koordinate wird zu Byte 2
	and.w	#$fffe,d2			; Ich schließe Bit 0 aus
	add.w	d2,a0				; addieren zur Adresse der Bitebene, 
								; um die richtige Zieladresse zu finden
	add.w	d2,a1				; addieren zur Adresse der Bitebene, 
								; um die richtige Zieladresse zu finden

Drawloop:
	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; Maske
	move.w	d0,$40(a5)			; BLTCON0
	move.w	#$0000,$42(a5)		; BLTCON1 Mode ascending
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#32,$62(a5)			; BLTBMOD (40-8=32)
	move.w	#32,$66(a5)			; BLTDMOD (40-8=32)

	move.l	#Maschera,$50(a5)	; BLTAPT Zeiger Maske
	move.l	a0,$4c(a5)			; BLTBPT Zeiger Figur
	move.l	a1,$54(a5)			; BLTDPT Zeiger Ziel
	move.w	#(64*39)+4,$58(a5)	; BLTSIZE (Blitter starten!)
								; Breite 4 word
								; Höhe 39 Zeilen

	add.w	#56*40,a0			; Adresse nächste Bitebene Figur
	add.w	#256*40,a1			; Adresse nächste Bitebene Ziel
	dbra	d7,Drawloop
	rts

;*****************************************************************************
; Diese Routine liest die horizontale Koordinate aus einer Tabelle
; und speichert sie in der Variable MASCHERAX
;*****************************************************************************

SpostaMaschera:
	ADDQ.L	#2,TABXPOINT		; Zeiger auf das nächste Wort
	MOVE.L	TABXPOINT(PC),A0	; Adresse die in TABXPOINT enthalten ist
								; nach a0 kopieren
	CMP.L	#FINETABX-2,A0  	; sind wir beim letzten Wort der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann weiter
	MOVE.L	#TABX-2,TABXPOINT 	; erneut mit dem ersten Wort-2 beginnen
NOBSTARTX:
	MOVE.W	(A0),MascheraX		; den Wert in die Variable kopieren 
	rts

MascheraX:
		dc.w	0				; aktuelle Maskenpositition
TABXPOINT:
		dc.l	TABX			; Zeiger auf die Tabelle
		
; Tabelle Maskenpositionen

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
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$100,$5200			; bplcon0  - 5 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000
	dc.w	$ec,$0000,$ee,$0000
	dc.w	$f0,$0000,$f2,$0000

Colours:
	dc.w	$180,$000,$182,$f10,$184,$f21,$186,$f42
	dc.w	$188,$f53,$18a,$f63,$18c,$f74,$18e,$f85
	dc.w	$190,$f96,$192,$fa6,$194,$fb7,$196,$fb8
	dc.w	$198,$fc9,$19a,$f21,$19c,$f10,$19e,$f00
	dc.w	$1a0,$eff,$1a2,$eff,$1a4,$dff,$1a6,$dff
	dc.w	$1a8,$cff,$1aa,$bef,$1ac,$bef,$1ae,$adf
	dc.w	$1b0,$9df,$1b2,$9cf,$1b4,$8bf,$1b6,$7bf
	dc.w	$1b8,$7af,$1ba,$69f,$1bc,$68f,$1be,$57f

	dc.w	$FFFF,$FFFE			; Ende copperlist

;*****************************************************************************

; Hier ist die Zeichnung, 320 Pixel breit, 56 Zeilen hoch und 5 Bitebenen

Figura:
	incbin	"/Sources/lava320x56x5.raw"

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

Beachten Sie, dass in diesem Beispiel die Grafik außerhalb des "Reflektors"  
sein muss, im Gegensatz zu Listing10c3.s. Da das verwendete System anders ist
und vor allem da es nicht genug Bitebenen gibt.
In diesem Beispiel sehen wir eine andere Technik, um den "Reflektor"-Effekt zu 
realisieren. Dieses Mal haben wir ein Bild, das aus 5 Bitebenen mit der Breite
von 320 Pixeln und 56 Zeilen besteht, gespeichert ab der Adresse "Figura". Die
Tatsache, dass das Bild 5 Bitebenen hat, verhindert die Verwendung der
vorherigen Technik, weil wir keine freie Bitebene haben, um die Maske separat 
zu zeichnen. Wir verwenden dann die folgende Technik: Wir führen eine
UND-Operation zwischen der Maske und der Figur durch, und wir schreiben das
Ergebnis in die Bitebenen des Bildschirms. Auf diese Weise werden nur die Bits
der Figur auf den Bildschirm kopiert, die einem 1-Bit in der Maske entsprechen. 
Die Maske hat die Form eines Kreises. Ein Teil einer kreisförmigen Figur wird 
kopiert. Beachten Sie, dass wir, wenn wir auf einem normalen (nicht interleaved) 
Bildschirm arbeiten, müssen wir die Bitebenen eine nach der anderen abarbeiten.
Da die Maske nur zur Auswahl verwendet wird. Die Bits in der Abbildung sind für 
jede Bitebene immer gleich. Die AND-Operation wird natürlich von dem Blitter
durchgeführt. Die Maske und die Figur werden durch die Kanäle A und B gelesen.
Die Berechnung der Werte die in die Register geschrieben werden (einschließlich
Minterms) ist ähnlich dem, wie wir es in den vorherigen Beispielen durchgeführt
haben.