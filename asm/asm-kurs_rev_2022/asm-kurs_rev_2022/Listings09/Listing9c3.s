
; Listing9c3.s		BLITT mit negativen MODULO
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
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	Aspettasin

	btst	#6,2(a5)			; dmaconr
WBlit:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit
;	      __
;	     /\ \
;	    /  \ \
;	   / /\ \ \
;	  / / /\ \ \
;	 / / /__\_\ \
;	/ / /________\
;	\/___________/		

	move.w	#$ffff,$44(a5)		; bltafwm - wir erklären es später
	move.w	#$ffff,$46(a5)		; bltalwm - wir erklären es später

	move.w	#$09f0,$40(a5)		; bltcon0 - Kanal A und D einschalten, 
								; MINTERMS=$f0, das heißt, Kopieren von A nach D

	move.w	#$0000,$42(a5)		; bltcon1 - wir erklären es später

	move.w	#2*(20-8),$66(a5)	; BLTDMOD - wie immer.

	move.w	#-16,$64(a5)		; BLTAMOD - das Bild ist 8 Wörter breit
								; (16 Bytes): um zum Anfang zurückzukehren
								; legen wir die negative Form an.

	move.l	#figura_a_caso,$50(a5)	; bltapt - Adresse Quellfigur 

; Die Zieladresse hängt von der gewünschten X- und Y-Position ab
; zeichne das erste Pixel der Figur. Die Regeln der Lektion gelten
; In diesem Fall X = 32 und Y = 4.

	move.l	#bitplane+(4*20+32/16)*2,$54(a5)	; bltdpt - Adresse Ziel
	move.w	#64*10+8,$58(a5)	; bltsize - Höhe 10 Zeilen,
								; 8 Wörter Breite.

mouse:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse

	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	rts


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

	dc.w	$100,$1200			; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$eee			; color1

	dc.w	$FFFF,$FFFE			; Ende copperlist

;*****************************************************************************

; Dies ist die "Figur", die mit einem Blitt in die BITPLANE kopiert wird

Figura_a_caso:	
	dc.w	$1111,$1010,$2044,$235a
	dc.w	$18f0,$97ff,$ca54,$90a2


	SECTION	PLANEVUOTO,BSS_C

BITPLANE:
	ds.b	40*256		; bitplane lowres

	end

;*****************************************************************************

In diesem Beispiel haben wir ein einzeiliges hohes Bild, das wir beginnend von
einer bestimmten Zeile des Bildschirms, 10 Mal kopieren. Jedes Mal gehen wir
eine Zeile tiefer. 
Natürlich könnten wir einfach eine Schleife von 10 Blitts machen, bei der wir
jedes Mal die Zieladresse ändern. Es ist jedoch möglich, es mit nur einem Blitt
zu erledigen, welches einen negativen Wert für das Quellmodulo hat. Wie Sie
wissen, wird der Wert des Modulo dem Inhalt der Adresse im Zeigerregister jedes
Mal, wenn der Blitter eine Zeile beendet hinzugefügt.
Normalerweise setzt man im Modulo einen positiven Wert, der den Blitter erlaubt
die Wörter, die nicht zum Rechteck gehören, zu "überspringen" und zur nächsten
Zeile zu gehen. Wenn das Modulo jedoch einen negativen Wert hat, wird die
Adresse die im Zeigerregister enthalten ist "zurückgegangen".
Insbesondere wenn der Blitt L Wörter breit ist, und eine Zeile mit dem im
Zeiger enthaltenen Wert kopiert wird es um 2 * L erhöht (weil der Zeiger Bytes
zählt, und 1 Wort = 2 Bytes ist).
Wenn wir den Wert -2 * L in das Modulo schreiben, gehen wir mit dem Zeiger 
genau an den Anfang der Zeile zurück. In diesem Beispiel tun wir genau das
mit der Quelle. Wir lesen jedes Mal die gleiche Zeile neu. Für das Ziel
verhalten wir uns stattdessen normal und dann werden die 10 Zeilen eine unter
der anderen geschrieben.
Wenn Sie sich erinnern, haben wir einen ähnlichen Effekt mit den Bitplane-
Modulos gemacht. Wenn Sie sie auf -40 setzen, erhalten wir eine unendliche
"Verlängerung" der ersten Zeile, aber nur auf der Ansichtsebene. In diesem 
Fall schreiben wir stattdessen die selbe Zeile mehrmals mit dem Blitter in den
Speicher.  
