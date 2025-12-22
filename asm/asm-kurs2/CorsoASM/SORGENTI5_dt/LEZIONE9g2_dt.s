
; Lezione9g2.s	BLITTATA, in dem wir ein Rechteck von einem Punkt zur einem 
		; anderen Punkt desselben Bildschirms im INTERLEAVED-Format kopieren
		; Linke Taste, um den Blitt auszuführen, rechts um zu beenden.
	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:
	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Bitplanepointer
	MOVEQ	#3-1,D1			; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0			; HIER IST DER ERSTE UNTERSCHIED ZU
						; DEN NORMALEN BILDERN !!!!!!
	ADD.L	#40,d0		; + LÄNGE einer ZEILE !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse1:
	btst	#2,$dff016	; rechte Maustaste gedrückt?
	bne.s	mouse1		; Wenn nicht, warte

	bsr.s	copia		; Führen Sie die Kopierroutine aus

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

	rts


; ************************ KOPIERROUTINE ****************************

; Ein Rechteck mit der Breite = 160 und der Höhe = 20 wird kopiert
; aus den Koordinaten X1 = 64, Y1 = 50 (Quelle)
; zu den Koordinaten X2 = 80, Y2 = 190 (Ziel)

;	           _
;	          /¬\
;	         /   \
;	    __  /__ __\  __
;	 .--\/-/ `°u°' \-\/--.
;	 |    /  T¯¯¬   \    |
;	 |   /   `       \   |
;	 |  /_____________\  |
;	 |    _         _    |
;	 |    |         |    |
;	 l____|         l____|
;	 (____)----^----(____)
;	    T      T      T   xCz
;	 ___l______|______|___
;	`----------^----------'

copia:

; Laden Sie die Quell- und Zieladressen in 2 Register
; ANMERKUNG DER UNTERSCHIED IM HINBLICK AUF DEN NORMALEN FALL: 
; BEI DER BERECHNUNG DES OFFSETS
; DIE Y-ZEILE WIRD MULTIPLIZIERT MIT DER ANZAHL DER PLANES (d.h. 3)
; Die Formel lautet 
; OFFSET = (Y * (Anzahl der Wörter pro Zeile) * (Anzahl der Ebenen)) * 2

	move.l	#bitplane+((20*3*50)+64/16)*2,d0	; Adresse Quelle
							; Bemerke den * 3-Faktor!
	move.l	#bitplane+((20*3*190)+80/16)*2,d2	; Adresse Ziel
							; Bemerke den * 3-Faktor!

	btst	#6,2(a5)	; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie A nach D
	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir erklären es später

; Lade die Zeiger
	move.l	d0,$50(a5)	; bltapt
	move.l	d2,$54(a5)	; bltdpt

; Diese 2 Anweisungen legen die Quell- und Zielmodulo fest
; ES GIBT KEINE UNTERSCHIEDE ZUM NORMALEN FALL:
; der Wert berechnet sich nach der Formel (H-L) * 2 (H ist die Breite der
; Bitebene in Worten und L ist die Breite des Bildes, immer in Worten)
; das haben wir in der Lektion gesehen, (20-160/16) * 2 = 20

	move.w	#(20-160/16)*2,$64(a5)	; bltamod
	move.w	#(20-160/16)*2,$66(a5)	; bltdmod

; Beachten Sie auch, weil die 2 Register aufeinander folgende Adressen haben, 
; können wir eine einzige Anweisung anstelle von 2 verwenden 
; (denken Sie daran, 20 = $14):
; move.l #$00140014,$64(a5); Bltamod und Bltdmod

; ANMERKUNG: DER UNTERSCHIED IM HINBLICK AUF DEN NORMALEN FALL: 
; LIEGT IN DER DIMENSION DER BLITTATA 
; ES IST DIE HÖHE DES BILDES - DIE ZAHL VERVIELFACHT SICH
; MIT DER ANZAHL DER BITPLANES

	move.w	#(3*20*64)+160/16,$58(a5)	; bltsize						
			; Höhe 20 Zeilen und 3 Ebenen
			; 160 Pixel breit (= 10 Wörter)
						
	btst	#6,$02(a5)	; warte auf das Ende des Blitters
waitblit2:
	btst	#6,$02(a5)
	bne.s	waitblit2
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
					
				; HIER GIBT ES EINEN RESPEKTIVEN UNTERSCHIED
				; ZU DEN NORMALEN BILDERN !!!!!!
	dc.w	$108,80		; Wert MODULO = 2*20*(3-1)= 80
	dc.w	$10a,80		; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200	; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000

	dc.w	$0180,$000	; color0
	dc.w	$0182,$475	; color1
	dc.w	$0184,$fff	; color2
	dc.w	$0186,$ccc	; color3
	dc.w	$0188,$999	; color4
	dc.w	$018a,$232	; color5
	dc.w	$018c,$777	; color6
	dc.w	$018e,$444	; color7

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

BITPLANE:
	incbin	"assembler2:sorgenti6/amiga.rawblit"		
			
		; Hier laden wir die Figur ein
		; RAWBLIT-Format (oder interleaved),
		; mit KEFCON konvertiert.
	end

;****************************************************************************

In diesem Beispiel zeigen wir ein Bild im Interleaved-Format an und 
kopieren ein Bild von einem Punkt zum Anderen auf dem Bildschirm. 
Dies ist das gleiche Programm wie Beispiel lesson9f1.s, aber im 
interleaved Format. Wir empfehlen Ihnen, dieses Beispiel zu untersuchen, 
indem Sie es mit lesson9f1.s vergleichen.
Wie wir in der Lektion gesehen haben, erlaubt uns das Interleaved-Format
die Kopie mit nur einer Blittata zu machen. Deshalb arbeitet die Routine 
"Kopieren" (das ist die Routine, die die Kopie macht) im Gegensatz zur
gleichnamigen Routine in Lektion9f1.s ohne Schleifen.
Einige Werte, die in die Blitter-Register geladen werden, sind unterschiedlich:

1) In der Adressberechnung, um den Offset zwischen dem ersten Wort der 
   Zeile Y und dem Anfang der Bitebene zu erhalten, müssen wir Y mit der Zahl
   der Anzahl der Bitplanes multiplizieren. (sowie für die Größe der Zeile.)   
   Bezüglich X, gibt es jedoch keine Unterschiede.

2) Die Höhe des Blittings ist gleich der Höhe des Bildes multipliziert mit
   der Anzahl der Bitebenen. Für die Breite gibt es jedoch keine
   Unterschiede.

Auch in Bezug auf die anderen Register, auch für das Modulo, gibt es 
keine Unterschiede.

