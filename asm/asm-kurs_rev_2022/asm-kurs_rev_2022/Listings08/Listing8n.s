
; Listing8n.s - Punktdruckroutine, optimiert durch Vorberechnung
			; Vielfache von 40 in einer Tabelle, Multiplikation entfernen
			; in der PlotPix-Routine, die den richtigen Wert aus der
			; Tabelle jedes Mal nimmt.

	Section	dotta,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; damit mache ich Einsparungen und  
									; schreib es nicht jedes mal neu!			
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche
; geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper und bitplane DMA aktivieren
;			 -----a-bcdefghij

LargSchermo	equ	40				; Bildschirmbreite in Bytes

START:
	MOVE.L	#BITPLANE,d0		; Adresse der Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer in der copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

; Wir bereiten eine Tabelle mit den Vielfachen von 40 oder der Breite des
; Bildschirms vor, um eine Multiplikation für jeden Plot zu vermeiden.

	lea	MulTab,a0				; Adressraum mit 256 Wörtern zum Schreiben
								; der Vielfachen von 40 ...
	moveq	#0,d0				; wir beginnen mit 0 ...
	move.w	#256-1,d7			; Anzahl der benötigten Vielfachen von 40
PreCalcLoop
	move.w	d0,(a0)+			; Speichere das aktuelle Vielfache
	add.w	#LargSchermo,d0		; Wir addieren die Bildschirmgröße, nächstes Vielfaches
	dbra	d7,PreCalcLoop		; Wir erstellen alle MulTab

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	
; Zeiger auf die Copperlist							
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	
mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	move.w	#160,d0				; Koordinate X
	move.w	#128,d1				; Koordinate Y
	lea	bitplane,a0				; Bitplane-Adresse, an der in a0 gedruckt werden soll
	lea	MulTab,a1				; Tabellenadresse mit Vielfachen der Bildschirmbreite
								; vorberechneter Bildschirm in a1

	bsr.s	PlotPIXP			; den Punkt auf die Koordinate X=d0, Y=d1 drucken

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts							; exit

*****************************************************************************
;		Routine zum Plotten eines Punktes - optimiert
*****************************************************************************

;	Eingehende Parameter von PlotPIXP:
;
;	a0 = Ziel-Bitplane-Adresse
;	a1 = Adresse der Tabelle mit Vielfachen von 40 vorberechnet
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

;	       ________________
;	 _____/                \_____  __  _
;	|   _/                  \_   ||  || |
;	|   \  ______    ______  /   ||  || |
;	|   _\ \  ___\  /___  / /_   ||  || |
;	|   /¯  \/   `  `   \/  ¯\   ||  || |
;	|   ¯\_     /|  |\     _/¯   ||  || |
;	|      \    ¯¯  ¯¯    /zO!   ||  || |
;	|       \_.--.--.--._/       ||  || |
;	`        `|  |  |  |`        ||  || |
;	__/\__    |  |  |  |         ||  || |
;	\ +O /    |  |  |  |         ||  || |
;	/ --_\    |  |  |  |         ||  || |
;	¯¯\/_ ____|  |  |  |_________||__||_|
;	          `--`--`--`

PlotPIXP:
	move.w	d0,d2				; Koordinate X in d2 kopieren
	lsr.w	#3,d0				; den horizontalen Versatz finden, in dem wir
								; die X-Koordinate durch 8 teilen

; ** BEGINN DER ÄNDERUNG: Hier sind die 2 Originalanweisungen:
;
;	mulu.w	#largschermo,d1
;	add.w	d1,d0				; den vertikalen zum horizontalen Versatz hinzufügen
;
; und die ohne MULU:

; Jetzt finden wir den vertikalen Versatz, das ist das Y, und nehmen den richtigen 
; vorberechneten Wert aus der Multab-Tabelle, deren Adresse in a1 steht

	add.w	d1,d1				; Wir multiplizieren das Y mit 2 und finden den Versatz
								; aus der Tabelle der Vielfachen, in der Tat jedes
								; Vielfache ist ein Wort, dh 2 Bytes. Nun, wenn
								; zum Beispiel die Koordinate 0 war, nehmen wir 
								; den ersten Wert der Tabelle, der Null ist.
								; Wenn es 3 ist, nehmen wir den dritten Wert
								; der Tabelle, der jedoch das sechste Byte ist,
								; da wir 2 Bytes überspringen müssen,
								; 1 Wort für jeden Wert in der Tabelle.
	add.w	(a1,d1.w),d0		; Wir addieren den richtigen vertikalen Versatz,
								; aus der Tabelle genommen, zum horizontalen Versatz

; ** ENDE DER ÄNDERUNG

	and.w	#%111,d2			; nur die ersten 3 Bits von X auswählen (Rest)
	not.w	d2					; negieren

	bset.b	d2,(a0,d0.w)		; Bit d2 des Bytes setzen, das d0 Bytes 
								; vom Anfang des Bildschirms entfernt ist
	rts

*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:

	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,$24			; BplCon2 - Alle Sprites über der Bitplane
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
				; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste bitplane

	dc.w	$0180,$000			; color0 - HINTERGRUND
	dc.w	$0182,$1af			; color1 - SCHRIFT

	dc.w	$FFFF,$FFFE			; Ende copperlist


*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256				; eine bitplane lowres 320x256

; Tabelle, die die vorberechneten Vielfachen der Bildschirmbreite enthält
; zur Beseitigung der Multiplikation in der PlotPIX-Routine und zur Erhöhung
; ihrer Geschwindigkeit.

	SECTION	Precalc,bss

MulTab:
	ds.w	256

	end

Mit diesem Listing machen wir eine kleine Einführung in die Lektion über
Optimierungen, indem wir eine "TABELLE" mit Multiplikation machen. Dieser
Vorgang ist sehr häufig im Code der schnellsten Demos oder in 3D-Spielen
zu finden.
Unsere Pixeldruckroutine funktioniert sehr gut, aber sie enthält eine
langsame Multiplikation. Wir müssen sie unbedingt entfernen. Multiplikation
nicht mit einer Potenz von 2, könnn nicht durch eine LSL ersetzt werden, wie
wir es in der Druckroutine in Listing8b.s geschickt eingesetzt haben.
Die Möglichkeiten der Codierung sind jedoch endlos. Betrachten Sie die
Situation, die wir haben:

	mulu.w	#largschermo,d1
	add.w	d1,d0		; den vertikalen zum horizontalen Versatz hinzufügen

Die Bildschirmbreite ist in diesem Fall 40. In d1 haben wir jedes Mal einen
anderen Wert, abhängig vom Y, aber wir wissen, dass es maximal von 0 bis 255
gehen kann. Es gibt also 256 mögliche Ergebnisse, je nachdem, welcher der 256 
möglichen Werte von Y oder d1 auftritt. Diese 256 Ergebnisse, wenn wir jedes
Mal eine Zahl von 0 auf 255 um eins erhöhen, wäre:

0,40,80,120,160,200	d.h.	40*0,40*1,40*2,40*3,40*4....

Stellen wir uns vor, dass wir all diese 256 möglichen Ergebnisse in einem Raum
mit Nullen "vorbereiten":

MulTab:
	ds.w	256

Um die Tabelle der Vielfachen von 40 zu erstellen, genügt eine sehr einfache 
Schleife:

	lea	MulTab,a0				; Adressraum mit 256 Wörtern zum Schreiben
								; der Vielfachen von 40 ...
	moveq	#0,d0				; wir beginnen mit 0 ...
	move.w	#256-1,d7			; Anzahl der benötigten Vielfachen von 40
PreCalcLoop
	move.w	d0,(a0)+			; Speichere das aktuelle Vielfache
	add.w	#LargSchermo,d0		; Wir addieren die Bildschirmgröße, nächstes Vielfaches
	dbra	d7,PreCalcLoop		; Wir erstellen alle MulTab

Jetzt haben wir die Tabelle mit den "Ergebnissen" fertig. Aber wie "holen" wir
aus der Tabelle jedes Mal das richtige Ergebnis? In der Eingabe haben wir die
Koordinate Y, d.h. eine Zahl von 0 bis 255. Wenn Y gleich Null ist, nehmen wir
einfach den ersten Wert aus der Tabelle. Das ist das Wort $0000. Wenn
stattdessen y = 1 wäre, müssen wir den zweiten Wert der Tabelle nehmen, der
jedoch vom Anfang 2 Byte entfernt ist, da seine Werte Worte sind. Ebenso, wenn
wir das richtiges Ergebnis für die Koordinate Y = 50 nehmen wollten, wäre das
Ergebnis das 50. Wort der Tabelle, mit einem Abstand von 100 Bytes.
Das alles ist nicht da. Ich schlag die Lösung vor. 
Zur Berechnung des Offsets, d.h. der Entfernung vom Anfang von der Tabelle
multiplizieren Sie einfach das Y mit 2! Und vervielfachen mit 2 kann man durch
add:

 	add.w	d1,d1

Wir sind immer noch ohne Multiplikation. Jetzt haben wir in d1 den Offset vom
Anfang der Tabelle. Wir müssen es "nehmen" und es zu d0 hinzufügen. Das kann
gemacht werden mit einer einzigen Operation:

	add.w	(a1,d1.w),d0		; Wir addieren den richtigen vertikalen Versatz,
								; aus der Tabelle genommen, zum horizontalen Versatz

In a1 haben wir die Adresse der MulTab-Tabelle .

Dieses "Tabellensystem" wird immer häufiger in Listings zu finden sein, die
viele Berechnungen durchführen.