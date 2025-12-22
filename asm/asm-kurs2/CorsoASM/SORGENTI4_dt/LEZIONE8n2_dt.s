
; Lezione8n2.s - Optimierte Druckroutine für Punkte (Plots). Es wird
		; die Geschwindigkeit dieser Routine im Vergleich zur nicht 
		; optimierten verglichen. Drücken Sie die RECHTE Maustaste um
		; die optimierte Routine zu testen, ansonsten arbeitet die
		; normale.

	Section	dotta,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; damit mache ich Einsparungen und schreib es 
							; nicht jedes mal neu!			
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper und bitplane DMA aktivieren
;			 -----a-bcdefghij

LargSchermo	equ	40	; Bildschirmbreite in Bytes

START:
;	ZEIGER AUF BITPLANE

	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

; WIR PRÄPARIEREN EINE TABELLe MIT DEN VIELFACHEN VON 40 ODER DER BREITE DES
; Bildschirms, um eine Multiplikation für jeden Plot zu vermeiden.

	lea	MulTab,a0		; Adressraum mit 256 Wörtern zum Schreiben
						; Vielfache von 40 ...
	moveq	#0,d0		; Fangen wir an 0...
	move.w	#256-1,d7	; Anzahl der benötigten Vielfachen von 40
PreCalcLoop
	move.w	d0,(a0)+	; Speichere das aktuelle Vielfache
	add.w	#LargSchermo,d0	; Wir addieren Bildschirmgröße, nächstes Vielfaches
	dbra	d7,PreCalcLoop	; Wir erstellen alle MulTab

; Zeiger auf cop...

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

	lea	bitplane,a0	; Bitplane-Adresse, in der gedruckt werden soll a0
	lea	MulTab,a1	; Tabellenadresse mit Vielfachen von
					; Breite. vorberechneter Bildschirm in a1

mouse:
	bsr.s	Coordinate	; Koordinatenschleifen für den gesamten Bildschirm
	move.w	MioX(PC),d0	; Koordinate X
	move.w	MioY(PC),d1	; Koordinate Y

	btst	#2,$16(a5)	; rechte Maustaste gedrückt?
	beq.s	Ottimizzata
	btst.b	#1,FaiSfai	; Zurücksetzen oder einstellen?
	bne.s	Sfai
	bsr.s	PlotPIX		; Drucken Sie den Punkt auf die Koordinate. X=d0, Y=d1
	bra.s	OkPlottato
Sfai:
	bsr.s	ErasePIX	; Setzen Sie den Punkt auf die Koordinate zurück. X=d0, Y=d1
	bra.s	OkPlottato

Ottimizzata:
	btst.b	#1,FaiSfai	; Zurücksetzen oder einstellen?
	bne.s	SfaiP
	bsr.w	PlotPIXP	; Drucken Sie den Punkt auf die Koordinate. X=d0, Y=d1
	bra.s	OkPlottato
SfaiP:
	bsr.w	ErasePIXP	; Setzen Sie den Punkt auf die Koordinate zurück. X=d0, Y=d1
OkPlottato:
	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts					; exit



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
	addq.w	#1,MioX		; nächstes Pixel in der Zeile
	cmp.w	#320,MioX	; letztes Pixel dieser Zeile?
	beq.s	FinitoLinea	; wenn ja, fangen wir unten an!
	rts					; Ansonsten machen wir diesen Punkt!

FinitoLinea:
	clr.w	MioX		; Beginnen wir am Anfang der Zeile
	addq.w	#1,MioY		; in der Zeile darunter...
	cmp.w	#256,MioY	; Haben wir den Bildschirm fertiggestellt? Letzte Zeile?
	beq.s	Cambiariparti
	rts

CambiaRiparti:
	bchg.b	#1,FaiSfai	; Ändern Sie den Schreib- / Löschstatus
	clr.w	MioX		; und von der Koordinate X = 0 beginnen
	clr.w	MioY		; Y=0
	rts

*****************************************************************************
;		Routine zum Plotten eines Punktes (dots) normal
*****************************************************************************

;	Eingehende Parameter von PlotPIX:
;
;	a0 = Ziel-Bitplane-Adresse
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)


PlotPIX:
	move.w	d0,d2		; Kopieren Sie die Koordinate X in d2
	lsr.w	#3,d0		; In der Zwischenzeit finden Sie den horizontalen Versatz,
						; Teilen Sie die X-Koordinate durch 8.
	mulu.w	#largschermo,d1
	add.w	d1,d0		; Offset vertikal bis horizontal

	and.w	#%111,d2	; Wählen Sie nur die ersten 3 Bits von X aus (Rest)
	not.w	d2

	bset.b	d2,(a0,d0.w)	; Setzen Sie das Bit d2 des bytefernen Bytes d0
							; vom Anfang des Bildschirms.
	rts

; Routine, die ein Pixel löscht. Ersetzen Sie einfach BSET durch BCLR.

ErasePIX:
	move.w	d0,d2		; Kopieren Sie die Koordinate X in d2
	lsr.w	#3,d0		; In der Zwischenzeit finden Sie den horizontalen Versatz,
						; Teilen Sie die X-Koordinate durch 8.
	mulu.w	#largschermo,d1
	add.w	d1,d0		; Offset vertikal bis horizontal

	and.w	#%111,d2	; Wählen Sie nur die ersten 3 Bits von X aus (Rest)
	not.w	d2

	bclr.b	d2,(a0,d0.w)	; Setzen Sie das Bit d2 der bytefernen d0-Bytes 
							; vom Anfang des Bildschirms zurück.
	rts

*****************************************************************************
;		Routine zum Plotten eines Punktes (dots) optimiert
*****************************************************************************

;	Eingehende Parameter von PlotPIXP:
;
;	a0 =  Ziel-Bitplane-Adresse
;	a1 = Adresse der Tabelle mit Vielfachen von 40 vorberechnet
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

PlotPIXP:
	move.w	d0,d2		; Kopieren Sie die Koordinate X in d2
	lsr.w	#3,d0		; In der Zwischenzeit finden Sie den horizontalen Versatz,
						; Teilen Sie die X-Koordinate durch 8.
	add.w	d1,d1		; Wir multiplizieren das Y mit 2 und finden den Versatz
	add.w	(a1,d1.w),d0	; vertikaler Versatz + horizontaler Versatz
	and.w	#%111,d2	; Wählen Sie nur die ersten 3 Bits von X aus
	not.w	d2			; negieren
	bset	d2,(a0,d0.w)	; Setzen Sie das Bit d2 des bytefernen Bytes d0
							; vom Anfang des Bildschirms.
	rts

; Routine, die ein Pixel löscht. Ersetzen Sie einfach BCLR durch BSET.

ErasePIXP:
	move.w	d0,d2		; Kopieren Sie die Koordinate X in d2
	lsr.w	#3,d0		; In der Zwischenzeit finden Sie den horizontalen Versatz,
						; Teilen Sie die X-Koordinate durch 8.
	add.w	d1,d1		; Wir multiplizieren das Y mit 2 und finden den Versatz
	add.w	(a1,d1.w),d0	; vertikaler Versatz + horizontaler Versatz
	and.w	#%111,d2	; Wählen Sie nur die ersten 3 Bits von X aus
	not.w	d2			; negieren
	bclr	d2,(a0,d0.w)	; Bit d2 des Bytes zurücksetzen, das d0 Bytes entfernt ist
							; vom Anfang des Bildschirms.
	rts

*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,$24	; BplCon2 - Alle Sprites über der Bitplane
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
		    ; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste bitplane

	dc.w	$0180,$000	; color0 - HINTERGRUND
	dc.w	$0182,$1af	; color1 - SCHRIFT

	dc.w	$FFFF,$FFFE	; Ende copperlist


*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256	; un bitplane lowres 320x256

; Tabelle, die die vorberechneten Vielfachen der Bildschirmbreite enthält
; zur Beseitigung der Multiplikation in der PlotPIX-Routine und zur Erhöhung
; ihrer Geschwindigkeit.

	SECTION	Precalc,bss

MulTab:
	ds.w	256

	end

Dieses Listing soll ein Test sein, um zu überprüfen, ob die Routine wirklich
ohne Multiplikation schneller ist. Zu diesem Zweck ist alles ausgelegt
Bildschirm und mit "ErasePIX" neu abgestimmt, die nichts als die Routine sind
normal mit BCLR anstelle von BSET. Normalerweise wird die Routine nicht optimiert 
ausgeführt. Wenn Sie die rechte Taste gedrückt halten, wird die optimierte ausgeführt.
Abhängig vom Computer und dem Vorhandensein von FAST RAM wird der Fixierer 
anders sein. Zum Beispiel, wenn die Tabelle auf CHIP RAM anstatt auf FAST RAM geht
ist das Gewinn geringer. Zum Beispiel auf dem 68040 sind Multiplikationen 
viel schneller als bei früheren Prozessoren, bis zu dem Punkt, wenn ja
dieses Listing ohne FastRAM durchführt und ist bei deaktivierten Caches langsamer
die Routine ohne Multiplikation, da sie in CHIP-RAM auf die Tabelle zugreifen muss. 
Wer jedoch einen A4000 hat, hat auch einen schnellen Widder, seien Sie versichert, 
auch auf 68030 oder weniger, um eine Multiplikation zu entfernen, ist immer 
eine gute Aktion.
