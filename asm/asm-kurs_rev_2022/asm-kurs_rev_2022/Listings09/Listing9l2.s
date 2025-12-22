
; Listing9l2.s		Kopie eines Rechtecks zwischen 2 sich überlappenden Bereichen
			; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0	
								; HIER IST DER ERSTE UNTERSCHIED
								; ZU DEN NORMALEN BILDERN !!!!!!
	ADD.L	#40,d0				; + Länge einer Linie !!!!!
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
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1				; wenn nicht, gehe zurück zu mouse1:

	bsr.s	copia				; Kopierroutine ausführen

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; wenn nicht, gehe zurück zu mouse2:

	rts


; ************************     KOPIER ROUTINE    ****************************
; Ein Rechteck mit der Breite = 160 und der Höhe = 20 wird kopiert
; von den Koordinaten X1 = 64, Y1 = 50 (Quelle)
; zu den Koordinaten X2 = 64, Y2 = 55 (Ziel)
; Beachten Sie, dass die Quelle und das Ziel sich überschneiden, und das Ziel
; sich weiter unten befindet, d.h. an einer höheren Adresse.
;****************************************************************************

;	     _______________
;	    /      _       ¬\
;	   /      / ¡__      \
;	  /      / O|o \      \
;	 /       \__l__/       \
;	/         (___)         \
;	\       (°              /
;	 \_____________________/
;	         T    T
;	        _l____|_
;	       | _    _ |
;	       |_|    |_|
;	       (_)--^-(_)
;	         T  T T  xCz
;	........ l__|_|__
;	         (____)__)

copia:

; wir laden die Quell- und Zieladressen in 2 Register

	move.l	#bitplane+((20*3*50)+64/16)*2,d0	; Adresse Quelle
	move.l	#bitplane+((20*3*55)+64/16)*2,d2	; Adresse Ziel

	btst	#6,2(a5)			; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM es passiert alles

								; Lade die Zeiger
	move.l	d0,$50(a5)			; bltapt
	move.l	d2,$54(a5)			; bltdpt

	move.l #$00140014,$64(a5)	; bltamod und bltdmod 

	move.w	#(3*20*64)+160/16,$58(a5)	; bltsize
								; Höhe 20 Zeilen und 3 Ebenen
								; 160 Pixel breit (= 10 Wörter)
						
	btst	#6,$02(a5)			; dmaconr - warte auf das Ende des Blitters
waitblit2:
	btst	#6,$02(a5)
	bne.s	waitblit2
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

								; HIER IST DER ZWEITE UNTERSCHIED
								; ZU DEN NORMALEN BILDERN!!!!!!
	dc.w	$108,80				; WERT MODULO = 2*20*(3-1)= 80
	dc.w	$10a,80				; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$0180,$000			; color0
	dc.w	$0182,$475			; color1
	dc.w	$0184,$fff			; color2
	dc.w	$0186,$ccc			; color3
	dc.w	$0188,$999			; color4
	dc.w	$018a,$232			; color5
	dc.w	$018c,$777			; color6
	dc.w	$018e,$444			; color7

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

BITPLANE:
	incbin	"/Sources/amiga.rawblit"	
								; Hier laden wir die Figur ein
								; RAWBLIT-Format (oder interleaved),
								; mit KEFCON konvertiert.
	end

;****************************************************************************

In diesem Beispiel kopieren wir ein Rechteck zwischen zwei sich überlappenden
Zonen. Dieses Mal ist die Adresse des Ziels größer als die der Quelle (auf dem
Bildschirm befindet sich das Ziel weiter unten).
Wie Sie sehen können, ist das Ergebnis nicht das, was wir wollten.



