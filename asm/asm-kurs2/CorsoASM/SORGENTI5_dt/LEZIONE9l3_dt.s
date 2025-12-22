
; Lezione9l3.s	Kopieren Sie ein Rechteck zwischen 2 überlappenden Bereichen 
			; mit dem DESCENDING Modus.
			; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#3-1,D1			; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0	
			; HIER GIBT ES EINEN RESPEKTIVEN UNTERSCHIED
			; ZU DEN NORMALEN BILDERN !!!!!!
	ADD.L	#40,d0		; + Länge einer Linie !!!!!
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
	bne.s	mouse1		; wenn nicht, nicht abbrechen

	bsr.s	copia		; Führen Sie die Kopierroutine aus

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

	rts


; ************************ KOPIER ROUTINE ****************************
; Ein Rechteck mit der Breite = 160 und der Höhe = 20 wird kopiert
; von den Koordinaten X1 = 64, Y1 = 50 (Quelle)
; zu den Koordinaten X2 = 64, Y2 = 55 (Ziel)
; Die Quelle und das Ziel überschneiden sich und das Ziel hat eine
; höhere Adresse (es liegt weiter unten auf dem Bildschirm).
; Verwenden Sie den Descending-Modus, um die Kopie korrekt zu erstellen
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

; Laden Sie die Quell- und Zieladressen in 2 Register
; ANMERKUNG DER UNTERSCHIED IM HINBLICK AUF DEN NORMALEN FALL:
; Die Adressen sind die Wörter, die sich am weitesten in der unteren rechten
; Ecke der Rechtecke befinden.
; Wenn Xa und Ya die Koordinaten der oberen linken Ecke sind, ist die Koordinate
; Yb die Zeile, zu der die untere Zeile des Rechtecks ​​gehört:
; Yb = Ya + RECHTECKHÖHE
; Daher ist bei der Berechnung der Adresse der zu Y gehörige OFFSET gegeben durch:
; OFFSET_Y = (Yb * (Anzahl Wörter pro Zeile) * (Anzahl Ebenen)) * 2.
; Der Versatz relativ zu X wird stattdessen berechnet, indem dies beobachtet wird
; Xa + RECHTECKBREITE ist die X-Koordinate des ersten Pixels des Worts
; Es befindet sich außerhalb des Rechtecks ​​unmittelbar rechts. Der OFFSET dieses Wortes
; ist daher ((Xa + RECHTECKBREITE) / 16) * 2. Aber das interessiert uns nicht
; aber dasjenige, das ihm vorausgeht, 
; oder das letzte Wort rechts vom Rechteck, dessen OFFSET ist daher: 
; OFFSET_Y = ((Xa + RECHTECKBREITE) / 16-1) * 2

	move.l	#bitplane+((20*3*(20+50))+(160+64)/16-1)*2,d0	; Adresse Quelle
	move.l	#bitplane+((20*3*(20+55))+(160+64)/16-1)*2,d2	; Adresse Ziel

	btst	#6,2(a5)		; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00002,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
								; MODE DESCENDING !!!!!

	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM es passiert alles

; Lade die Zeiger

	move.l	d0,$50(a5)		; bltapt
	move.l	d2,$54(a5)		; bltdpt

; Diese Anweisung legt die Quell- und Zielmodulo fest.
; Wie wir erklärten, gibt es keine Unterschiede im Vergleich zum anderen Fall!

	move.l #$00140014,$64(a5)	; bltamod und bltdmod 

; auch hinsichtlich der Größe gibt es keine Unterschiede

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
	dc.w	$108,80		; WERT MODULO = 2*20*(3-1)= 80
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

In diesem Beispiel kopieren wir ein Rechteck zwischen zwei überlappenden Zonen.
Die Adresse des Ziels ist größer als das der Quelle (auf dem Bildschirm ist das
Ziel niedriger) und deshalb benutzen wir den absteigenden Weg.
Der DESCENDING Modus wird aktiviert, indem Bit 1 des BLTCON1-Registers auf 1 
gesetzt wird. Der einzige Unterschied zum aufsteigenden Fall besteht in der
Berechnung der Adressen der Zeigern der DMA-Kanäle, die für die Berechnung 
angewendet werden wie in der Lektion erklärt .

