
; Listing9b1.s		BLITT, in dem wir 8 Wörter in eine Null-Bit-Ebene kopieren.
; Linke Taste, um den Blitt auszuführen, rechts um zu beenden.

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

Aspettasin:
	btst	#6,$bfe001			; Warten, bis die linke Maustaste gedrückt wird
	bne.s	Aspettasin

	btst.b	#6,2(a5)			; dmaconr
WBlit:
	btst.b	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit

;	 |\/\/\/|
;	 |      |
;	 |      |
;	 | (o)(o)
;	 c      _)
;	  | ,___|
;	  |   /
;	 /____\
;	/      \		

	move.w	#$ffff,$44(a5)		; bltafwm - wir werden es später erklären
	move.w	#$ffff,$46(a5)		; bltalwm - wir werden es später erklären

	move.w	#$09f0,$40(a5)		; bltcon0 - Kanal A und D ist aktiviert, 
								; MINTERMS=$f0, das Kopieren von A nach D ist definiert
	move.w	#$0000,$42(a5)		; bltcon1 - wir werden es später erklären
	move.l	#figura_a_caso,$50(a5)	; bltapt - Adresse Quelle

; Die Zieladresse hängt von der gewünschten X- und Y-Position ab
; zeichne das erste Pixel der Figur. Die Regeln der Lektion gelten
; In diesem Fall X = 32 und Y = 4.

	move.l	#bitplane+(4*20+32/16)*2,$54(a5)	; bltdpt - Adrese Ziel
	move.w	#64*1+8,$58(a5)		; bltsize - Höhe 1 Zeile, Breite 8 Wörter

mouse:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse

	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	rts

;******************************************************************************

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

	dc.w	$100,$1200			; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$eee			; color1

	dc.w	$FFFF,$FFFE			; Ende copperlist

;*****************************************************************************

; Dies ist die "Figur", die mit einem Blitt in die BITPLANE kopiert wird:

Figura_a_caso:	
	dc.w	$1111,$1010,$2044,$235a
	dc.w	$18f0,$97ff,$ca54,$90a2

;******************************************************************************

	SECTION	PLANEVUOTO,BSS_C

BITPLANE:
	ds.b	40*256				; bitplane zurücksetzen lowres

	end

;******************************************************************************

In diesem Beispiel kopieren wir einen Speicherbereich mit dem Blitter.
Genauer gesagt lesen wir 8 Wörter (betrachten sie es als ein 8 Wörter großes 
und nur eine Zeile hohes Rechteck) beginnend mit der identifizierten Adresse
vom Label "Figura_a_caso:" und überschreiben sie beginnend mit der Adresse
identifiziert durch das Label "BITPLANE:" Das Label Bitplane ist die Adresse 
einer Speicherzone, die eine Bitebene enthält.
Eigentlich kopieren wir die Daten in die BITPLANE + Offset, was von der
Anfangsecke versetzt ist. Daher werden die Daten, die wir kopieren, auf dem
Bildschirm angezeigt.
Um einen Kopiervorgang durchzuführen, müssen 2 DMA-Kanäle verwendet werden,
eine zum Lesen und eine zum Schreiben. In diesem Fall benutzen wir den Kanal A
zum Lesen und Kanal D zum Schreiben. Daher werden nur diese 2 Kanäle
aktiviert, indem die zugehörigen Bits im BLTCON0-Register auf 1 gesetzt werden.
Um dem Blitter mitzuteilen, dass er eine Kopie von Kanal A an den Kanal D
senden soll ist es notwendig, das Byte, das die MINTERMS enthält, auf den Wert
$f0 zu setzen.
Versuchen Sie, die Position zu ändern, in der die Figur gezeichnet wird, indem 
sie die Zieladresse des Blitts variieren. Wenden Sie das in der Lektion
gelernte Wissen an.

