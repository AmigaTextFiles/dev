
; Listing8n3.s - Optimierte Punktdruckroutine.
		; Eine Tabelle wird verwendet, um einen Punkt zu "verschieben". 
		; Rechte Taste um die "Spur zu verlassen" auf den Punkt bringen.

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
;		   	 -----a-bcdefghij

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
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.w	LeggiTabelle		; Liest die X- und Y-Positionen aus den Tabellen

	move.w	MioX(PC),d0			; Koordinate X
	move.w	MioY(PC),d1			; Koordinate Y

	bsr.w	PlotPIXP			; den Punkt auf die Koordinate X=d0, Y=d1 drucken

	btst	#2,$16(a5)			; rechte Maustaste gedrückt?
	beq.s	NonCancellare

	move.w	MioXold(PC),d0		; alte X-Koordinate, die gelöscht werden soll
	move.w	MioYold(PC),d1		; alte Y-Koordinate

	bsr.w	ErasePIXP			; den Punkt auf die Koordinate X=d0, Y=d1 zurücksetzen

NonCancellare:
	move.w	MioX(PC),MioXold	; die Koordinaten des Punktes vorbereiten, den wir löschen wollen
	move.w	MioY(PC),MioYold	; danach

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse
	rts							; exit



MioX:
	dc.w	0
MioY:
	dc.w	0
MioXold:
	dc.w	0
MioYold:
	dc.w	0


*****************************************************************************
;		Routine zum Plotten eines Punktes - optimiert
*****************************************************************************

;	Eingehende Parameter von PlotPIXP:
;
;	a0 = Ziel-Bitplane-Adresse
;	a1 = Adresse der Tabelle mit den vorberechneten Vielfachen von 40
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

;	    .....
;	  __\ oO/__
;	 / _ \./ _ \
;	/\/|  "  |\/\
;	\ \|_____|/ /
;	 \ \_(_)_| /
;	  \\\     \
;	 /   \/    \
;	 \____\____/
;	(_____\_____)eD
;

PlotPIXP:
	move.w	d0,d2				; Koordinate X in d2 kopieren
	lsr.w	#3,d0				; den horizontalen Versatz finden, in dem wir
								; die X-Koordinate durch 8 teilen
	add.w	d1,d1				; wir multiplizieren das Y mit 2 und finden den Versatz
	add.w	(a1,d1.w),d0		; vertikaler Versatz + horizontaler Versatz
	and.w	#%111,d2			; nur die ersten 3 Bits von X auswählen (Rest)
	not.w	d2					; negieren
	bset.b	d2,(a0,d0.w)		; Bit d2 des Bytes setzen, das d0 Bytes 
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
	bclr	d2,(a0,d0.w)		; Bit d2 des Bytes setzen, das d0 Bytes 
								; vom Anfang des Bildschirms entfernt ist
	rts

*****************************************************************************

LeggiTabelle:
	move.l	a0,-(SP)			; a0 im Stack speichern
	ADDQ.L	#1,TABYPOINT		; auf das nächste Byte zeigen
	MOVE.L	TABYPOINT(PC),A0	; Adresse, die im long TABXPOINT enthalten ist
								; nach a0 kopieren
	CMP.L	#FINETABY-1,A0		; Sind wir am letzten Byte der TAB?
	BNE.S	NOBSTARTY			; noch nicht? dann geht es weiter
	MOVE.L	#TABY-1,TABYPOINT	; wir beginnen wieder mit dem ersten Byte
NOBSTARTY:
	moveq	#0,d0				; d0 zurücksetzen
	MOVE.b	(A0),d0				; das Byte aus der Tabelle kopieren, dh die
								; Y-Koordinate in d0, damit Sie es tun können
								; finde zur universellen Routine

	ADDQ.L	#2,TABXPOINT		; auf das nächste Wort zeigen
	MOVE.L	TABXPOINT(PC),A0	; Adresse, die im long TABXPOINT enthalten ist
								; nach a0 kopieren
	CMP.L	#FINETABX-2,A0		; Sind wir beim letzten Wort der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann geht es weiter
	MOVE.L	#TABX-2,TABXPOINT	; wir beginnen wieder mit dem ersten Wort-2
NOBSTARTX:
	moveq	#0,d1				; d1 zurücksetzen
	MOVE.w	(A0),d1				; wir setzen den Wert der Tabelle, das heißt
								; die X-Koordinate in d1
	move.w	d0,MioY				; die Koordinaten speichern
	move.w	d1,MioX
	move.l	(sp)+,a0			; a0 vom Stack wiederherstellen
	rts


TABYPOINT:
	dc.l	TABY-1				; HINWEIS: Die Werte in der Tabelle sind Bytes
TABXPOINT:
	dc.l	TABX-2				; HINWEIS: Die hier angegebenen Tabellenwerte sind Wörter

; Tabelle mit Koordinaten Y

TABY:
	incbin	"ycoordinatok.tab"	; 200 Werte .B
FINETABY:

; Tabelle mit Koordinaten X

TABX:
	incbin	"xcoordinatok.tab"	; 150 Werte .W
FINETABX:

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

	dc.w	$0180,$000			; color0 - Hintergrund
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

In diesem Beispiel haben wir einfach die Routine hinzugefügt, die aus den 2
Tabellen die X- und Y-Koordinaten, wie für Sprites liest. Wie Sie sehen können,
ist es auch für Routinen zum Drucken von Punkten nützlich. Durch die Erstellung
komplexerer Tabellen und Routinen können Sie verschiedene Wellen erhalten.

