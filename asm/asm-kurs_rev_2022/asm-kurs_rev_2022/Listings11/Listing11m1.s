
; Listing11m1.s - Verwendung des Level 2 Interrupts ($68) zum Lesen des
;				  Tastencodes der gedrückten Taste auf der Tastatur.
;		  DRÜCKEN SIE DIE LEERTASTE, UM RAUSZUGEHEN (ZUM VERLASSEN)

	Section	InterruptKey,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern Interrupt, DMA und so weiter.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche
; geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:
	move.l	BaseVBR(PC),a0	    ; In a0 ist der Wert des VBR

	MOVE.L	#MioInt68KeyB,$68(A0)	; Tastaturroutine Int. Level 2
	move.l	#MioInt6c,$6c(a0)	; Ich lege meine Routinen Int. Level 3

			; 76543210
	move.b	#%01111111,$bfed01	; CIAAICR - Deaktiviere alle CIA-IRQs
	move.b	#%10001000,$bfed01	; CIAAICR - Aktiviere nur den SP CIA IRQ

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_init				; Musik Routine initialisieren
	movem.l	(SP)+,d0-d7/a0-a6

			; 5432109876543210
	move.w	#%1100000000101000,$9a(a5)   ; INTENA - nur VERTB aktivieren 
										 ; von Level 3 und Level 2

AttendiSpazio:
	move.b	ActualKey(PC),d0	; Holen Sie sich den Code der letzten gedrückten Taste.
	move.b	d0,Color0+1			; Legen Sie den code des aktuellen Zeichens als
								; color0 ... richtig zum Testen ..
	cmp.b	#$40,d0				; LEERTASTE GEDRÜCKT? (nur mit der Maus!)
	bne.s	AttendiSpazio

	bsr.w	mt_end				; Ende der Wiederholung!
	move.b	#%10011111,$bfed01	; CIAAICR - wiederherstellen CIA IRQ
	rts							; exit

; Variable, in der das aktuelle Zeichen gespeichert wird

ActualKey:
	dc.b	0

	even

*****************************************************************************
*	INTERRUPTROUTINE $68 (Level 2) - Tastatur-Verwaltung
*****************************************************************************

;03	PORTS	2 ($68)	Input/Output Port und Timer, verbunden mit INT2-Leitung

MioInt68KeyB:					; $68
	movem.l d0/a0,-(sp)			; speichern der Register auf dem Stack
	lea	$dff000,a0				; Register custom base für offset

	MOVE.B	$BFED01,D0			; Ciaa icr - in d0 (Lesen der ICR, die wir verursachen
								; auch seine Nullsetzung, so ist das int
								; "gelöscht" wie in intreq).
	BTST.l	#7,D0				; bit IR, (interrupt cia autorisiert), zurückgesetzt?
	BEQ.s	NonKey				; wenn ja, beenden
	BTST.l	#3,D0				; bit SP, (interrupt der Tastatur), zurückgesetzt?
	BEQ.s	NonKey				; wenn ja, beenden

	MOVE.W	$1C(A0),D0			; INTENAR in d0
	BTST.l	#14,D0				; Bit Master der Aktivierung zurückgesetzt?
	BEQ.s	NonKey				; wenn ja, interrupt ist nicht aktiv!
	AND.W	$1E(A0),D0			; INREQR - in d0 bleiben nur die Bits gesetzt
								; welche sowohl in INTENA als auch in INTREQ gesetzt sind
								; um sicher zu sein, dass wenn der Interrupt
								; auftritt, auch aktiviert ist.
	btst.l	#3,d0				; INTREQR - PORTS?
	beq.w	NonKey				; Wenn nicht, dann beenden!

; Wenn wir nach den Kontrollen hier sind, heißt das, dass wir das Zeichen übernehmen müssen!

	moveq	#0,d0
	move.b	$bfec01,d0			; CIAA sdr (serial data register - verbunden
								; mit der Tastatur - enthält das vom Tastaturchip
								; gesendete Byte) WIR LESEN DAS ZEICHEN!

; wir haben den char in d0, wir "arbeiten" daran...

	NOT.B	D0					; Wir passen den Wert durch Invertieren der Bits an
	ROR.B	#1,D0				; und Zurückkehren der Sequenz zu 76543210.
	move.b	d0,ActualKey		; speichern des Zeichens

; Jetzt müssen wir der Tastatur mitteilen, dass wir die Daten aufgenommen haben!

	bset.b	#6,$bfee01			; CIAA cra - sp ($bfec01) Ausgang, 
								; senken der KDAT-Zeile, um zu bestätigen
								; das wir den Charakter erhalten haben.

	st.b	$bfec01				; $FF in $bfec01 - Ich habe die Daten erhalten!

; Hier müssen wir eine Routine einstellen, die 90 Mikrosekunden wartet, weil die
; KDAT-Leitung genügend Zeit haben muss, um von allen Arten von Tastaturen 
; "verstanden" zu werden. Sie können beispielsweise auf 3 oder 4 Rasterzeilen warten.

	moveq	#4-1,d0				; Anzahl der zu wartenden Zeilen = 4 (in der Praxis 3 weitere)
								; der Bruchteil, in dem wir uns gerade befinden
waitlines:
	move.b	6(a0),d1			; $dff006 - aktuelle vertikale Zeile in d1
stepline:
	cmp.b	6(a0),d1			; sind wir immer noch auf der gleichen Zeile?
	beq.s	stepline			; wenn ja, warte
	dbra	d0,waitlines		; "erwartete" Zeile, warte d0-1 Zeilen

; Nachdem wir gewartet haben, können wir $bfec01 im Eingabemodus melden ...

	bclr.b	#6,$bfee01			; CIAA cra - sp (bfec01) erneut eingeben.

NonKey:		; 3210
	move.w	#%1000,$9c(a0)		; INTREQ Anfrage entfernen, int ausgeführt!
	movem.l (sp)+,d0/a0			; wiederherstellen der Register vom Stack
	rte

*****************************************************************************
*	INTERRUPTROUTINE $6c (Level 3) - benutzte VERTB und COPER			    *
*****************************************************************************

;06	BLIT	3 ($6c)	Wenn der Blitter einen Blitt beendet hat, wird es auf 1 gesetzt
;05	VERTB	3 ($6c)	Wird jedes Mal generiert, wenn der Elektronenstrahl die
			; Zeile 00 erreicht, d.h. bei jedem Beginn des vertikalen Austastens.
;04	COPER	3 ($6c)	Sie können es mit copper einstellen, um es zu einem bestimmten 
			; Zeitpunkt (Videozeile) zu erzeugen
			; Fordern Sie ihn einfach nach einer gewissen Wartezeit an.

MioInt6c:
	btst.b	#5,$dff01f			; INTREQR - ist Bit 5, VERTB zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:
NointCOPER:
NoBLIT:		 ;6543210
	move.w	#%1110000,$dff09c	; INTREQ - Löschen Flag BLIT,VERTB und COPER
	rte							; Ende vom Interrupt COPER/BLIT/VERTB

*****************************************************************************
;	Wiederholungsroutine protracker/soundtracker/noisetracker
;
	include	"/Sources/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$100,$200			; BPLCON0 - keine bitplanes
	dc.w	$180
Color0:
	dc.w	$000				; color0 - es wird in Abhängigkeit der Taste geändert
	dc.w	$FFFF,$FFFE			; Ende copperlist

*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"/Sources/mod.fairlight"

	end

Wenn das Byte des Tastaturcodes in color0 eingegeben wird, können sie die Tatsache
erkennen, das wenn eine Taste gedrückt ist, ist Bit 7 zurückgesetzt, während wenn die
Taste losgelassen wird das Bit gesetzt ist. D.h. wenn sie eine Taste drücken ist die
Farbe dunkler, als wenn sie losgelassen wird, weil das hohe Bit von Grün gelöscht wird.
