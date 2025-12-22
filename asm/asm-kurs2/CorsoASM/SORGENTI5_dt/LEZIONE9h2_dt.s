
; Lezione9h2.s	BLITTATE, in dem wir ein Rechteck (in einem normalen Bild)
		; mit Masken kopieren. 
		; Drücken der rechten Taste führt den "kompletten" Blitt aus.
		; Durch Drücken der linken Taste wird der Blitt mit ausgewählten  
		; Maskenbits ausgeführt und schließlich rechte Taste für Ende.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#3-1,D1			; Anzahl Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0		; + Größe einer Bitplane !!!!!
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
	btst	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	mouse1			; Wenn nicht, gehe zurück zu mouse1:

; Erste Blittata, mit den Masken, die alle Daten passieren lässt

	lea	bitplane+((20*170)+80/16)*2,a0		; Adresse Ziel
	move.w	#$ffff,d0						; alles
	move.w	#$ffff,d1						; alles
	bsr.s	copia

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

; Zweite Blittata, dank der Masken wird nur der Buchstabe "I"
; kopiert

	lea	bitplane+((20*170)+160/16)*2,a0		; Adresse Ziel
	move.w	#%0000000000001111,d0	; Übergeben Sie die 4 Bits nach rechts
	move.w	#%1111000000000000,d1	; übergeben Sie die 4 Bits nach links
	bsr.s	copia

mouse3:
	btst	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	mouse3			; Wenn nicht, gehe zurück zu mouse3:

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

	lea	bitplane+((20*78)+128/16)*2,a1	; feste Quelladresse

	moveq	#3-1,d7		; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)	; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D

					; lädt die Parameter in die Regsiter
	move.w	d0,$44(a5)		; BLTAFWM Maske auf der linken Seite
	move.w	d1,$46(a5)		; BLTALWM Maske auf der rechten Seite
	
; Lade die Zeiger

	move.l	a1,$50(a5)		; bltapt - Quelle 
	move.l	a0,$54(a5)		; bltdpt - Ziel

	move.l #$00240024,$64(a5)	; bltamod und bltdmod 

	move.w	#(60*64)+2,$58(a5)	; bltsize
					; Höhe 60 Zeilen
					; Breite 2 Wörter

	lea	40*256(a1),a1		; zeigt auf die nächste Quellenebene
	lea	40*256(a0),a0		; zeigt auf die nächste Zielebene

	dbra	d7,PlaneLoop

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

				; normale Bilder!!!!!!
	dc.w	$108,0		; Wert MODULO = 0
	dc.w	$10a,0		; BEIDE MODULO MIT GLEICHEN WERT.

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
	incbin	"assembler2:sorgenti6/amiga.raw"
	
					; Hier laden wir die Figur ein
					; RAW-Format konvertiert mit KEFCON.
	end

;****************************************************************************

In diesem Beispiel zeigen wir, wie die Masken verwendet werden.
Es ist möglich, "Teile" von Bildern durch Löschen von Teilen die Sie 
nicht möchten zu extrahieren. In diesem Fall wollen wir nur den Buchstaben 
"I" des geschriebenen Amiga. Dieser Buchstabe ist in einem 2 Wörter breiten
Rechteck enthalten. Im Rechteck befinden sich jedoch auch Teile anderer 
Buchstaben. Die erste Maske wird mit dem Wert $ffff ausgeführt, sodass alle
Pixel übergeben werden. Wie Sie sehen können, werden die Teile der anderen 
Buchstaben ebenfalls kopiert. Bei der zweiten Blittata werden stattdessen 
die Masken auf geeignete Werte gesetzt, so dass nur die Pixel passieren,
die den Buchstaben "I" bilden.
