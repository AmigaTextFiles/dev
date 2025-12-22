
; Listing9h2r.s		BLITT, in dem wir ein Rechteck (in einem RAWBLIT-Bild)
		; mit Masken kopieren. 
		; Drücken der rechten Taste führt den "kompletten" Blitt aus.
		; Durch Drücken der linken Taste wird der Blitt mit ausgewählten  
		; Maskenbits ausgeführt und schließlich rechte Taste für Ende.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"			; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl Bitplanes (hier sind es 3)
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
	bne.s	mouse1				; Wenn nicht, gehe zurück zu mouse1:

; Erster Blitt, mit den Masken, die alle Daten passieren lässt

	lea	bitplane+((20*3*170)+80/16)*2,a0	; Adresse Ziel
	move.w	#$ffff,d0			; alles
	move.w	#$ffff,d1			; alles
	bsr.s	copia

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; Wenn nicht, gehe zurück zu mouse2:

; Zweiter Blitt, dank der Masken wird nur der Buchstabe "I" kopiert

	lea	bitplane+((20*3*170)+160/16)*2,a0	; Adresse Ziel
	move.w	#%0000000000001111,d0	; nur die 4 Bits ganz rechts übergeben
	move.w	#%1111000000000000,d1	; nur die 4 Bits ganz links übergeben
	bsr.s	copia

mouse3:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse3				; Wenn nicht, gehe zurück zu mouse3:

	rts

;****************************************************************************
; Diese Routine kopiert die Figur auf dem Bildschirm.
;
; A0 - Zieladresse
; D0.w - erste Wortmaske
; D1.w - letzte Wortmaske
;****************************************************************************

;	  ___________   
;	 (_____ _____)  
;	 /(_o(___)O_)\  
;	/ ___________ \
;	\ \____l____/ /|
;	|\_`---'---'_/ |
;	| `---------'  |
;	|  T  xCz   T  |
;	l__|        l__|
;	(__)---^----(__)
;	  T    T     |  
;	 _l____l_____|_ 
;	(______X_______)

copia:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D

								; lädt die Parameter in die Register
	move.w	d0,$44(a5)			; BLTAFWM Maske auf der linken Seite
	move.w	d1,$46(a5)			; BLTALWM Maske auf der rechten Seite

; Lade die Zeiger

	move.l	#bitplane+((20*3*78)+128/16)*2,$50(a5) ; bltapt: Quelle
	move.l	a0,$54(a5)			; bltdpt: Ziel

	move.l #$00240024,$64(a5)	; bltamod und bltdmod 

	move.w	#(3*60*64)+2,$58(a5)		; bltsize
								; Höhe 60 Zeilen und 3 Ebenen
								; Breite 2 Wörter
						
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
								; ZU DEN NORMALEN BILDERN !!!!!!
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

Dieses Beispiel ist die Rawblit-Version von Listing9h2.s.
Vergleichen Sie die Unterschiede in den Formeln zur Berechnung der zu 
schreibenden Werte in die Blitter-Register.
