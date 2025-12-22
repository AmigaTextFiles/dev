
; Listing8n2.s - Optimierte Punktdruckroutine. Es wird
		; die Geschwindigkeit dieser Routine im Vergleich zur nicht 
		; optimierten verglichen. Drücken Sie die RECHTE Maustaste um
		; die optimierte Routine zu testen, ansonsten arbeitet die
		; normale Routine.

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

	lea	bitplane,a0				; Bitplane-Adresse, an der in a0 gedruckt werden soll
	lea	MulTab,a1				; Tabellenadresse mit Vielfachen der Bildschirmbreite
								; vorberechneter Bildschirm in a1

mouse:
	bsr.s	Coordinate			; Koordinatenschleifen für den gesamten Bildschirm
	move.w	MioX(PC),d0			; Koordinate X
	move.w	MioY(PC),d1			; Koordinate Y

	btst	#2,$16(a5)			; rechte Maustaste gedrückt?
	beq.s	Ottimizzata
	btst.b	#1,FaiSfai			; Zurücksetzen oder einstellen?
	bne.s	Sfai
	bsr.s	PlotPIX				; den Punkt auf die Koordinate X=d0, Y=d1 drucken
	bra.s	OkPlottato
Sfai:
	bsr.s	ErasePIX			; den Punkt von der Koordinate X=d0, Y=d1 zurücksetzen
	bra.s	OkPlottato

Ottimizzata:
	btst.b	#1,FaiSfai			; Zurücksetzen oder einstellen?
	bne.s	SfaiP
	bsr.w	PlotPIXP			; den Punkt auf die Koordinate X=d0, Y=d1 drucken
	bra.s	OkPlottato
SfaiP:
	bsr.w	ErasePIXP			; den Punkt von der Koordinate X=d0, Y=d1 zurücksetzen
OkPlottato:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse
	rts							; exit



MioX:
	dc.w	0
MioY:
	dc.w	0
FaiSfai:
	dc.w	0

;		    ___
;		   /_ -\
;		  ( ¢ ¢ )
;		   \ ° /
;		  /¯\¬/¯\
;		 /   Y   ·
;		·    `

; Routine, die kontinuierlich den gesamten Bildschirm druckt und löscht
; Punkt zu einer Zeit.

Coordinate:
	addq.w	#1,MioX				; nächstes Pixel in der Zeile
	cmp.w	#320,MioX			; letztes Pixel dieser Zeile?
	beq.s	FinitoLinea			; wenn ja, fangen wir mit dem folgenden an!
	rts							; ansonsten machen wir diesen Punkt!

FinitoLinea:
	clr.w	MioX				; beginnen wir wieder am Anfang der Zeile
	addq.w	#1,MioY				; in der Zeile darunter...
	cmp.w	#256,MioY			; haben wir den Bildschirm fertiggestellt? Letzte Zeile?
	beq.s	Cambiariparti
	rts

CambiaRiparti:
	bchg.b	#1,FaiSfai			; ändert den Schreib- / Löschstatus
	clr.w	MioX				; und von der Koordinate X = 0 beginnen
	clr.w	MioY				; Y=0
	rts

*****************************************************************************
;		Routine zum Plotten eines Punktes - normal
*****************************************************************************

;	Eingehende Parameter von PlotPIX:
;
;	a0 = Ziel-Bitplane-Adresse
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)


PlotPIX:
	move.w	d0,d2				; Koordinate X in d2 kopieren 
	lsr.w	#3,d0				; den horizontalen Versatz finden, in dem wir
								; die X-Koordinate durch 8 teilen
	mulu.w	#largschermo,d1
	add.w	d1,d0				; den vertikalen zum horizontalen Versatz hinzufügen

	and.w	#%111,d2			; nur die ersten 3 Bits von X auswählen (Rest)
	not.w	d2					; negieren

	bset.b	d2,(a0,d0.w)		; Bit d2 des Bytes setzen, das d0 Bytes 
								; vom Anfang des Bildschirms entfernt ist
	rts

; Routine, die ein Pixel löscht. Ersetzen Sie einfach BSET durch BCLR.

ErasePIX:
	move.w	d0,d2				; Koordinate X in d2 kopieren 
	lsr.w	#3,d0				; den horizontalen Versatz finden, in dem wir
								; die X-Koordinate durch 8 teilen
	mulu.w	#largschermo,d1
	add.w	d1,d0				; den vertikalen zum horizontalen Versatz hinzufügen

	and.w	#%111,d2			; nur die ersten 3 Bits von X auswählen (Rest)
	not.w	d2					; negieren

	bclr.b	d2,(a0,d0.w)		; Bit d2 des Bytes zurücksetzen, das d0 Bytes 
								; vom Anfang des Bildschirms entfernt ist
	rts

*****************************************************************************
;		Routine zum Plotten eines Punktes - optimiert
*****************************************************************************

;	Eingehende Parameter von PlotPIXP:
;
;	a0 =  Ziel-Bitplane-Adresse
;	a1 = Adresse der Tabelle mit Vielfachen von 40 vorberechnet
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

PlotPIXP:
	move.w	d0,d2				; Koordinate X in d2 kopieren
	lsr.w	#3,d0				; den horizontalen Versatz finden, in dem wir
								; die X-Koordinate durch 8 teilen
	add.w	d1,d1				; wir multiplizieren das Y mit 2 und finden den Versatz
	add.w	(a1,d1.w),d0		; vertikaler Versatz + horizontaler Versatz
	and.w	#%111,d2			; nur die ersten 3 Bits von X auswählen (Rest)
	not.w	d2					; negieren
	bset	d2,(a0,d0.w)		; Bit d2 des Bytes setzen, das d0 Bytes 
								; vom Anfang des Bildschirms entfernt ist
	rts

; Routine, die ein Pixel löscht. Ersetzen Sie einfach BSET durch BCLR.

ErasePIXP:
	move.w	d0,d2				; Koordinate X in d2 kopieren
	lsr.w	#3,d0				; den horizontalen Versatz finden, in dem wir
								; die X-Koordinate durch 8 teilen
	add.w	d1,d1				; wir multiplizieren das Y mit 2 und finden den Versatz
	add.w	(a1,d1.w),d0		; vertikaler Versatz + horizontaler Versatz
	and.w	#%111,d2			; nur die ersten 3 Bits von X auswählen (Rest)
	not.w	d2					; negieren
	bclr	d2,(a0,d0.w)		; Bit d2 des Bytes zurücksetzen, das d0 Bytes 
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

Diese Listing ist als Test gedacht, um zu sehen, ob die Routine wirklich ohne
Multiplikation schneller läuft. Zu diesem Zweck wird der gesamte Bildschirm mit
'ErasePIX' gelöscht, was nichts anderes ist als die normale Routine mit BCLR
anstelle von BSET zu verwenden. Normalerweise wird die nicht optimierte Routine
ausgeführt. Wenn Sie die rechte Taste gedrückt halten, wird die optimierte
Routine ausgeführt. Abhängig vom Computer und dem Vorhandensein von FAST RAM
wird das Ergebnis anders sein. Zum Beispiel, wenn die Tabelle im CHIP RAM
anstatt im FAST RAM gespeichert wird, wird die Geschwindigkeit geringer sein.
Auf dem 68040 sind Multiplikationen zum Beispiel viel schneller als bei
früheren Prozessoren, so dass die Ausführung dieses Listings ohne Fast RAM und
mit deaktivierten Caches langsamer ist als die Routine ohne Multiplikation, da
sie auf die Tabelle in CHIP RAM zugreifen muss.
Diejenigen, die einen A4000 haben, haben auch FAST RAM, aber keine Sorge, 
auch auf 68030 oder niedriger, ist das Entfernen einer Multiplikation immer eine 
gute Maßnahme.
