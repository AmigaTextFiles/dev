
; Lezione10c3.s		Reflektoreffekt
		; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#FIGURA,d0	; Zeiger Figur
	LEA	BPLPOINTERS,A1	; Zeiger COP
	MOVEQ	#3-1,D1		; Anzahl der Bitplanes
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0	; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	move.l	#BITPLANE4,d0	; Zeigen Sie auf die Bitebene, wo sie gezeichnet wird
	move.w	d0,6(a1)		; 
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
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

	bsr.s	ClearScreen		; sauberer Bildschirm
	bsr.w	SpostaMaschera	; Reflektorposition verschieben
	bsr.s	Riflettore		; Routine Reflektor

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse2			; Wenn nicht, gehe zurück zu mouse2:

	rts

;***************************************************************************
; Diese Routine löscht den Teil des Bildschirms, der von der Blittata betroffen ist
;***************************************************************************

ClearScreen:
	lea	BITPLANE4+100*40,a1	; zu löschende Adresse (plane4)

	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$01000000,$40(a5)	; BLTCON0 + BLTCON1 Löschung
	move.w	#$0000,$66(a5)		; BLTDMOD
	move.l	a1,$54(a5)			; BLTDPT Zeiger Ziel
	move.w	#(64*39)+20,$58(a5)	; BLTSIZE (Blitter starten !)
	rts

;*****************************************************************************
; Diese Routine realisiert den Reflektoreffekt.
; die Maske wird einfach auf die Bitebene 4 gezeichnet
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
	lea	BITPLANE4+100*40,a1	 ; Adresse Ziel
	move.w	MascheraX(PC),d0 ; Reflektorposition
	move.w	d0,d2			 ; Kopie
	and.w	#$000f,d0	; Sie wählen die ersten 4 Bits, weil sie
				; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0		; Die 4 Bits werden zum High-Nibble bewegt
	lsl.w	#4,d0		; des Wortes...
	or.w	#$09F0,d0	; ...rechts in das Register BLTCON0
						; LF=$F0 (d.h. Kopie A nach D)
	lsr.w	#3,d2		; (entspricht einer Division durch 8)
				; Runden auf ein Vielfaches von 8 für den Zeiger
				; auf den Bildschirm, also auf ungerade Adressen
				; (also auch für Bytes, also)
				; x zB: eine 16 als Koordinate wird zum
				; Bytes 2
	and.w	#$fffe,d2	; Ich schließe Bit 0 aus
	add.w	d2,a1		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; Maske
	move.w	d0,$40(a5)			; BLTCON0
	move.w	#$0000,$42(a5)		; BLTCON1 Modus ascending
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#32,$66(a5)			; BLTDMOD (40-8=32)

	move.l	#Maschera,$50(a5)	; BLTAPT  Zeiger Quelle
	move.l	a1,$54(a5)			; BLTDPT  Zeiger Ziel
	move.w	#(64*39)+4,$58(a5)	; BLTSIZE (Blitter starten!)
								; Breite 4 word
								; Höhe 39 Zeilen

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
		dc.w	0		; aktuelle Maskenpositition
TABXPOINT:
		dc.l	TABX	; Zeiger auf die Tabelle

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
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$4200	; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000
	dc.w $ec,$0000,$ee,$0000

Colours:
	dc.w	$0180,$000	; Farben von 0-7 alle dunkel. Auf diese Weise
						; die Teile der Figur in Übereinstimmung mit der
						; welche die Maske nicht entworfen ist
						; dunkler gefärbt
	dc.w	$0182,$011	; color1
	dc.w	$0184,$223	; color2
	dc.w	$0186,$122	; color3
	dc.w	$0188,$112	; color4
	dc.w	$018a,$011	; color5
	dc.w	$018c,$112	; color6
	dc.w	$018e,$011	; color7

	dc.w	$0190,$000	; color 8-15 enthält die Palette
	dc.w	$0192,$475
	dc.w	$0194,$fff
	dc.w	$0196,$ccc
	dc.w	$0198,$999
	dc.w	$019a,$232
	dc.w	$019c,$777
	dc.w	$019e,$444

	dc.w	$FFFF,$FFFE	; Ende copperlist

;*****************************************************************************

; Hier ist die Zeichnung, 320 Pixel breit, 256 Zeilen hoch und von 3 Ebenen gebildet

Figura:
	incbin	"amiga.raw"

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

; Hier ist die vierte Bitebene, wo die Maske gezeichnet wird.

	SECTION	bitplane,BSS_C
BITPLANE4:
	ds.b	40*256

	end

;*****************************************************************************

In diesem Beispiel erzeugen wir einen "Reflektor"-Effekt mit Hilfe einer
Bitplane-Maske. Die Technik ist wie folgt. Wir haben ein Set-Design aus 
3 Bitebenen 320 Pixel breit und 256 Zeilen hoch. Um den Effekt zu erzielen,
benutzen wir eine "Maske" oder eine Zeichnung eines Kreises, der nur aus 
einer Bitplane besteht. Diese Maske wird gezeichnet und auf einer vierten 
Bitebene bewegt, als wäre es ein Bob. Wie es auf einer Bitebene getrennt 
von der Abbildung gezeichnet wird. Wir müssen uns nicht um den Hintergrund
kümmern. Es ist im Grunde derselbe Trick, wie der in lesson9i4.s, das 
Beispiel des Bobs mit dem Hintergrund als Fälschung. Diesmal aber, um den 
Reflektoreffekt einzustellen. Ansonsten sind die Farben in den Registern: 
die Palette der 3-farbigen Figur, das heißt, die Werte, die wir 
normalerweise in die COLOR00-COLOR07-Register schreiben würden. Sie werden 
diesmal in den Registern COLOR08-COLOR15 geschrieben. Stattdessen die 
Register COLOR00-COLOR07 werden alle etwas dunkler (oder schwarz) eingestellt. 
Auf diese Weise werden die Pixel des Bildes, über die vierte Bitebene 
eingestellt. Bei 0 erscheinen sie alle dunkler (wir könnten sie alle 
sogar schwarz machen). Auf der anderen Seite werden, wenn die Pixel des 
Bildes der vierten Bitebene auf 1 sind (dh an der Maske) erscheinen sie 
mit den richtigen Farben. Diese Technik ist sehr schnell, hat aber wie 
das Beispiel lesson9i4.s einen Nachteil: Wir verwenden 4 Bitplanes für 
ein 8-Farben-Bild. Im nächsten Beispiel werden wir sehen, wie dieses 
Problem vermieden werden kann.